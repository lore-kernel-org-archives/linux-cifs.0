Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7823C10A8
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787210190; cv=none; b=uuJGtG1kSV5npSqFGdN4PiSiLj3XS2GajN/UhI/qb3Neaw2Du4ybIVVdk0s/Pr9DNvFFqY9Vt7p9BDyO6eXb0mBymqMHpwBOWGX9iJkZUmJx3LlFidoZYfXL7UVP+rNZM6bnMffKou6VjDpZWlSnELiCyILkiYZOmwWWDulA+Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787210190; c=relaxed/simple;
	bh=ijsCBiN9cP1SR7ezlZJs5bteoXsloF70d4f7RircjRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aK2C4TdRtrlCMbfSvOV0MElRCLuxzOq6FG8BJvw9vXyZ86kbbqdIAHtK7HaqF6lb/zb8dSSa8ZzYSHWDD5UKOECZkE8vw+is2Adlwp/zUz/9KAX8ty/wMxECHhQuFyTRY8e324uWavF3PkIYFCSJD3rKL29+EwE1n33LufksfKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qwTM3oR7; arc=none smtp.client-ip=95.215.58.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qwTM3oR7"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ijsCBiN9cP1SR7ezlZJs5bteoXsloF70d4f7RircjRk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210187; v=1; x=1787814987;
 b=qwTM3oR7OrnKU2qbDmaw/XHZCLHAmEL2pfYf9kECxPh6ukv4tITcRNrtTMfqEGjfbvATZSr4
 NyneVPelWI5mmmXYiHmf7Cp01coN+JohmqlMOpHWz0wBscF1Y331MKKThXW8zw4+2ZEPVuwXGyp
 OezcZ/lf7TnU8dY6CD281I3A=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from harry-WUJIE-Series.. (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 79feeae3901fde85;
	Thu, 20 Aug 2026 07:16:27 +0000
X-Mizu-Trace-ID: 79feeae3901fde85
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 6/6] smb/client: fix stale page cache in insert/collapse range
Date: Thu, 20 Aug 2026 15:15:26 +0800
Message-ID: <20260820071526.826926-7-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820071526.826926-1-huiwen.he@linux.dev>
References: <20260820071526.826926-1-huiwen.he@linux.dev>
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

Fix this by writing back from the start of the page containing off and
invalidating the page cache from off to EOF with
invalidate_inode_pages2_range().

Fixes: 9c8b7a293f50 ("smb3: fix temporary data corruption in insert range")
Fixes: fa30a81f255a ("smb3: fix temporary data corruption in collapse range")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ee0f646d1aa2..890974f33a1d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4025,15 +4025,25 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
+	if (rc < 0)
+		goto out_2;
+
+	netfs_wait_for_outstanding_io(inode);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	rc = invalidate_inode_pages2_range(inode->i_mapping,
+					   off >> PAGE_SHIFT, -1);
 	if (rc < 0)
 		goto out_2;
 
-	truncate_pagecache_range(inode, off, old_eof);
 	spin_lock(&inode->i_lock);
 	netfs_write_zero_point(inode, old_eof);
 	spin_unlock(&inode->i_lock);
-	netfs_wait_for_outstanding_io(inode);
 
 	rc = __smb2_copychunk_range(xid, cfile, cfile, off + len,
 				    old_eof - off - len, off);
@@ -4107,11 +4117,20 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
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
+	rc = invalidate_inode_pages2_range(inode->i_mapping,
+					   off >> PAGE_SHIFT, -1);
+	if (rc < 0)
+		goto out_2;
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
-- 
2.43.0

