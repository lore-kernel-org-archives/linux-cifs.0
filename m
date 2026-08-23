Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E4368D71
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787497935; cv=none; b=eSYs5S3HgbZZSJFLkIURk4yQBXnnN77+M2b7wHN2+GFMDqSZE5i+HuQI1QVTH5fsk5abdfbwpddgJOPTKv8mmFQOu7nvRAGUFWWt3FFRCtSAY4RDe9w0D0tqMpzhSxpX+LGKelHiF9KP3XLrQVRGwviLjCRwo5C1T9NLV98x8wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787497935; c=relaxed/simple;
	bh=WXl/lcRtHyxyVh35CDK3TJrY3MtVM+GPuxn1iQmHaUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHstMuyoYfOoUFibmEHG155k3oHPqEA7ySVpDl8G3c2whrZgmecEgXJCXKpkP5Hps6hsmFICholZz4uWqpWcZUQXFCm65EuaMezlJtMyHMOU2epDPKx/7arkrA2qZr4WD2R0N010brxtH8fyUwCm3AOFjsLBTrB+tG1pP/neAVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fljhmhgw; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fljhmhgw"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WXl/lcRtHyxyVh35CDK3TJrY3MtVM+GPuxn1iQmHaUE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787497931; v=1; x=1788102731;
 b=fljhmhgw+2qu7FWdWSq22HVAiaMMDPKv7lK2S7KeAvMP22SqQQ1FnLHr5I1F2hbgV1fVNfit
 YJS22V699kT3ggtXsuokFVd65bzo9bld9EQt9EtlK6YLbcRHu+cUBlvPvE7x9zWnaFbxpk9zYrr
 KzFCW55bgKwApB8op2e1tAIg=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:269e:918b:d2e0:eaa5:de79)
	by smtp.migadu.com with ESMTPS id 796402a3c1b34fc1;
	Sun, 23 Aug 2026 15:12:11 +0000
X-Mizu-Trace-ID: 796402a3c1b34fc1
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
Subject: [PATCH v3 6/7] smb/client: fix stale page cache in insert/collapse range
Date: Sun, 23 Aug 2026 23:10:52 +0800
Message-ID: <20260823151053.935889-7-huiwen.he@linux.dev>
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

smb3_insert_range() and smb3_collapse_range() use
truncate_pagecache_range() to invalidate the affected page cache.
However, if off or old_eof is not page-aligned, the boundary pages are
only partially zeroed and remain uptodate. As a result, the client may
return stale data after a successful insert/collapse range operation.

For example, with 4K pages:

    page 0          page 1          page 2
    0------4K       4K------8K      8K------12K
       ^                                ^
    off=2K                       old_eof=10K

Page 1 is removed from the page cache, while the boundary pages are
only partially zeroed. After COPYCHUNK moves the data on the server,
these cached pages may still return stale data.

This can be reproduced on a CIFS mount:

    bash -c '
            FILE=/mnt/scratch/repro

            # Use a 6 KiB file so EOF is not page-aligned.
            dd if=/dev/urandom of=/tmp/src bs=1K count=6 status=none

            # Expected: a 4 KiB hole followed by the original data.
            rm -f /tmp/expected
            truncate -s 4K /tmp/expected
            cat /tmp/src >> /tmp/expected

            cp /tmp/src "$FILE"

            # Prime the page cache before moving data on the server.
            cat "$FILE" > /dev/null

            fallocate --insert-range -o 0 -l 4K "$FILE"

            if cmp -s /tmp/expected "$FILE"; then
                    echo "readback: OK"
            else
                    echo "readback: STALE DATA"
            fi
    '

Fix this by writing back dirty data and discarding the page cache from
the start of the page containing off to EOF before moving data on the
server.

Fixes: 9c8b7a293f50 ("smb3: fix temporary data corruption in insert range")
Fixes: fa30a81f255a ("smb3: fix temporary data corruption in collapse range")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ee0f646d1aa2..835bc342840d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4025,15 +4025,22 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
 	if (rc < 0)
 		goto out_2;
 
-	truncate_pagecache_range(inode, off, old_eof);
+	netfs_wait_for_outstanding_io(inode);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
+
 	spin_lock(&inode->i_lock);
 	netfs_write_zero_point(inode, old_eof);
 	spin_unlock(&inode->i_lock);
-	netfs_wait_for_outstanding_io(inode);
 
 	rc = __smb2_copychunk_range(xid, cfile, cfile, off + len,
 				    old_eof - off - len, off);
@@ -4107,11 +4114,17 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
 	if (rc < 0)
 		goto out_2;
-	truncate_pagecache_range(inode, off, old_eof);
 	netfs_wait_for_outstanding_io(inode);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
-- 
2.43.0

