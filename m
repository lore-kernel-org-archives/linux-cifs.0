Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2410B54781
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901688; cv=none; b=dpCNKUxvATKYzJfD17oS7FbYmrLVbOitqlsYlctBvXWN/3ySN41KRfFGeQWAHEDn/J3wkwKKIKQtx+rnLtAblrzSHzz8iwHUv6dAMt96KnDc/tLPYtQzM2nMWQQbsJI2w5ptEzwEg9Ox1qaMn7WmOqmhNDiLh+ybLK27IGegbaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901688; c=relaxed/simple;
	bh=O2QY0yYXqqiFvGSGxE17LLRKTsTzfvvg6OzjE5B3TU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evmzzYTEpqS0LR77ZeS8bVRC5j+y6Ox6luIt7y0IHr/hXmqhPhj+mx+Y0tsmyLivvuhcOSL9GxSyXnI0ZhQaZrchZsnudmER+a8H+7cvgPnxbYX16vqDqAZ9TbO7rNo0dX1jmp4AZnf7yXszr6vwpJ33nZbNcDPbMRgb2/HwaVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bGeQ9V24; arc=none smtp.client-ip=95.215.58.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bGeQ9V24"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=O2QY0yYXqqiFvGSGxE17LLRKTsTzfvvg6OzjE5B3TU0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901684; v=1; x=1788506484;
 b=bGeQ9V24hZMKMa/JPTQI4i/4wHKkFeC7g6BWHJ2bGUQp9Z6ZsrUBP3iMPg9x0Ghob59h8zRS
 kjs/ROJrC8kTEPAJSzw5UgC1Ij2haTwdGDeoiGfxn1HByGJBKzMaaIxV+QPl0OxyfGPWjnvsyBa
 Qni0KjsoBEU7JWEqEf/sNtt0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7673b1ac1386f03d;
	Fri, 28 Aug 2026 07:21:24 +0000
X-Mizu-Trace-ID: 7673b1ac1386f03d
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
Subject: [PATCH v4 6/7] smb/client: fix stale page cache in insert/collapse range
Date: Fri, 28 Aug 2026 15:19:34 +0800
Message-ID: <20260828071935.552165-7-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828071935.552165-1-huiwen.he@linux.dev>
References: <20260828071935.552165-1-huiwen.he@linux.dev>
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
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2ops.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4676c5fe54ba..ae9c2b7a2611 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4026,15 +4026,22 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
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
@@ -4094,11 +4101,17 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
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

