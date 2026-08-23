Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027F3278161
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787497942; cv=none; b=P7GemEojrkcAt9AYZpN1pq7c33Qk76lMc8S1v1OcB31J45aSq4B5XfUrv1RcVMr/JpLMxIcALd9ny2nNnvEibCX59i3Td8t7BpXh3LtaqkkspDsv0vO7CDAHI/582w4eQb0i3qbnfRk9X8r4MfmhAkj8oNOrC+A/b1Le9YB32G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787497942; c=relaxed/simple;
	bh=YN/lt8anyq5aWnUAva2BioqJqJ0KVyHQTBbreUAurqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQtKRR2KlLgi/NSF/ASBhrGuZ/9XxbcTKdWtpHZxlUgArrvnYHlvODjUZ4woR6D0/MSe94E9bvs5xZy3CcRCCgzADgQeJWz+p4CYotpEduX2kM5/4eAQnjyzdPnwVDTrsFc9CbrwcmPMbK02NPIrse6Q1OTpqvPRTnaXkWAaYeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AAk2uh7D; arc=none smtp.client-ip=95.215.58.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AAk2uh7D"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YN/lt8anyq5aWnUAva2BioqJqJ0KVyHQTBbreUAurqw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787497938; v=1; x=1788102738;
 b=AAk2uh7DaYhP8CgV0jznrU4O3iPIxF0TbwUAvkdi5Nh5+wmfVBpOCjEs2VWFYnCVnft/MHQn
 zKcvD1pgQT8TCXmnZS2U8ThuH7lSsguKy91NRvMLU6LTeCRupLAj2/9Di0FR1yhi/Z9VQFEZy4T
 /Y34QwQKjB60UDXl4S0pTrCU=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:269e:918b:d2e0:eaa5:de79)
	by smtp.migadu.com with ESMTPS id db47643bd7be4c51;
	Sun, 23 Aug 2026 15:12:18 +0000
X-Mizu-Trace-ID: db47643bd7be4c51
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 7/7] smb/client: invalidate fscache for fallocate range operations
Date: Sun, 23 Aug 2026 23:10:53 +0800
Message-ID: <20260823151053.935889-8-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260823151053.935889-1-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_zero_range(), smb3_punch_hole(), smb3_insert_range(), and
smb3_collapse_range() modify file contents through server-side range
operations. These operations discard the affected page cache, but leave
the FS-Cache cookie valid, so a later read may return data cached before
the range operation.

Fix this by invalidating FS-Cache after outstanding I/O has completed
and before modifying the file on the server.

Run the following as root on a CIFS mount with fsc enabled and an active
CacheFiles backend:

        bash -c '
                MNT=/mnt/cifs
                FILE="$MNT/repro"

                # Generate four 1 MiB random blocks: [A][B][C][D].
                dd if=/dev/urandom of=/tmp/src bs=1M count=4 status=none

                # Expected contents after zeroing B: [A][zero][C][D].
                cp /tmp/src /tmp/expected
                dd if=/dev/zero of=/tmp/expected bs=1M seek=1 count=1 \
                        conv=notrunc status=none
                cp /tmp/src "$FILE"

                # Populate FS-Cache, then discard the page cache.
                sync
                echo 1 > /proc/sys/vm/drop_caches
                cat "$FILE" > /dev/null
                sync
                echo 1 > /proc/sys/vm/drop_caches

                fallocate --zero-range -o 1M -l 1M "$FILE"

                if cmp -s /tmp/expected "$FILE"; then
                        echo "readback: OK"
                else
                        echo "readback: STALE DATA"
                fi
        '

Before this change, the readback differs from /tmp/expected:

        readback: STALE DATA

After this change, it matches:

        readback: OK

Fixes: 30175628bf7f ("[SMB3] Enable fallocate -z support for SMB3 mounts")
Fixes: 31742c5a3317 ("enable fallocate punch hole ("fallocate -p") for SMB3")
Fixes: 5476b5dd82c8 ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 835bc342840d..60a40d6b0da3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3549,6 +3549,9 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
 		goto zero_range_exit;
 
+	fscache_invalidate(cifs_inode_cookie(inode), NULL,
+			   i_size_read(inode), 0);
+
 	rc = smb3_zero_data(file, tcon, offset, len, xid);
 	if (rc < 0)
 		goto zero_range_exit;
@@ -3618,6 +3621,8 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	 */
 	truncate_pagecache_range(inode, offset, offset + len - 1);
 	netfs_wait_for_outstanding_io(inode);
+	fscache_invalidate(cifs_inode_cookie(inode), NULL,
+			   i_size_read(inode), 0);
 
 	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
@@ -4037,6 +4042,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	 * moving data on the server, so subsequent reads do not see stale data.
 	 */
 	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
+	fscache_invalidate(cifs_inode_cookie(inode), NULL, old_eof, 0);
 
 	spin_lock(&inode->i_lock);
 	netfs_write_zero_point(inode, old_eof);
@@ -4125,6 +4131,7 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	 * moving data on the server, so subsequent reads do not see stale data.
 	 */
 	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
+	fscache_invalidate(cifs_inode_cookie(inode), NULL, old_eof, 0);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
-- 
2.43.0

