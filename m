Received: from mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF53B44B68B
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627332; cv=none; b=shetByuMx9xT2NM2kxLVp/YMlZCAJ8pRwxdkeKoEKNoi/IuiQnCPwNoxxhdh9pxnnT7DiNUvfz6h4UGwffblUyoemYOATvX0wfy3LjUXAbhLjc+aZFU7ZT+huoJxlIWkwy7ZE7nUlHgHhmqOEAMLHM03YZFp3YubM5Bky//Uhfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627332; c=relaxed/simple;
	bh=wLD20CgWJXIysPLhdyNyOF51BfWz7KZURSsyYC0vNes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=notlwb3sT9f/rqvPgqMy8Ksrp2eO5LGGYv8gsCkDA/PVFoDjTC002HWaILKjjCYB6ryH67Uzh4Ybu9mwAT/hNpQOJ8SxETxD57+zjwVgjJuD0fj5s9j6vWlSgGmtE+BKsk2ghV6K85VvSl9mGWIa4wpfdpemE/p4eL5O+/I8OKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PTEBvx2d; arc=none smtp.client-ip=95.215.58.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PTEBvx2d"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wLD20CgWJXIysPLhdyNyOF51BfWz7KZURSsyYC0vNes=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786627328; v=1; x=1787232128;
 b=PTEBvx2dBxwbVZM5MN5PW9Y2IcgbpHCR4TeNPS0DHRDM7lu1+o2NBHrwPBpTLkMZv2Gnj3q6
 RyyPenHMtNLkEyM0njsy8TcsWkJHScom7j4XlYnmYttvGqDdGjtW9eIFmIa5v7Suf73EGSSoJaU
 ubPx2Zn4Gk80kQ+jDYTckUv0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:9d9:8475:703:1f32:b67e)
	by smtp.migadu.com with ESMTPS id 9e08407f4884b5da;
	Thu, 13 Aug 2026 13:22:08 +0000
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
Subject: [PATCH 1/2] smb/client: validate new EOF for insert range
Date: Thu, 13 Aug 2026 21:21:35 +0800
Message-ID: <20260813132136.366532-2-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813132136.366532-1-huiwen.he@linux.dev>
References: <20260813132136.366532-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_insert_range() does not check if the new file size
(i_size + len) is valid. This allows FALLOC_FL_INSERT_RANGE to bypass
RLIMIT_FSIZE, exceed s_maxbytes, or produce a size outside the loff_t
range.

Use check_add_overflow() to calculate the new EOF. Validate it with
inode_newsize_ok() before modifying the file.

Reproducer, using a file on a CIFS mount:

	bash -c '
		FILE=/mnt/cifs/repro

		trap "" SIGXFSZ
		ulimit -f 3072		# RLIMIT_FSIZE = 3 MiB

		# A regular write is stopped at 3 MiB.
		dd if=/dev/zero of="$FILE" bs=1M count=4 status=none
		stat -c "size after write: %s" "$FILE"

		# Insert 2 MiB into a 2 MiB file.
		truncate -s 2M "$FILE"
		fallocate -i -o 0 -l 2M "$FILE"
		stat -c "size after insert: %s" "$FILE"
	'

Before this change, the regular write stops at the 3 MiB limit, but
insert range grows the file to 4 MiB:

	dd: error writing '/mnt/cifs/repro': File too large
	size after write: 3145728
	size after insert: 4194304

After this change, insert range also fails at the limit and leaves the
2 MiB file unchanged:

	dd: error writing '/mnt/cifs/repro': File too large
	size after write: 3145728
	fallocate: fallocate failed: File too large
	size after insert: 2097152

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 192649fec25d..bc7dda6d825a 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3985,7 +3985,8 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	__u64 count, old_eof, new_eof;
+	u64 count;
+	loff_t old_eof, new_eof;
 
 	xid = get_xid();
 
@@ -3995,8 +3996,15 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	if (check_add_overflow(old_eof, len, &new_eof)) {
+		rc = -EFBIG;
+		goto out;
+	}
+	rc = inode_newsize_ok(inode, new_eof);
+	if (rc)
+		goto out;
+
 	count = old_eof - off;
-	new_eof = old_eof + len;
 
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
-- 
2.43.0

