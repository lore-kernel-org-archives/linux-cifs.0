Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922AC3A7F4D
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901653; cv=none; b=BeGeMbHA7mWIcFt8S//TaMhlYZiMDoV7doZmvQn6k2gpSemkSaRiqbmr6WSeYHKJAxZABUaGrpkelyFThhfl6UBGrYYZ5oKO0QKrLJvl7zOAywhv9xL0isJutHCpaTah/HNWP4eKeN3AgJLt8p1Lm3CGoE5QK5IYUPouVrwscIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901653; c=relaxed/simple;
	bh=u2YLZfuZLYG/J4Gnvk7I6G91SgOnXbX5th9nLpjBQmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA4KhvA925w6qag5XUXDtJCdev+ry57CTzwOfXAZrsyuxfRrv5tRNFP2Al0YkyicW9BwjUm3p6bt58s8tu8RmAN1c0ojCsRQfj9n+/IyK4aLyTpYYMg41ZPkD3jmDCKOQ0ZOHSoGcP2iQz1jIJZnOOcvwtDjpLAgCSruFJZmetc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hi37T7Fi; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hi37T7Fi"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u2YLZfuZLYG/J4Gnvk7I6G91SgOnXbX5th9nLpjBQmI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901649; v=1; x=1788506449;
 b=hi37T7FimlHsh0zP6XwfitOoRhU6gCCt612m+HdGQBDRNd4LyV6OPw8nd1/HR8ncJVKMGMHq
 GL/pq45XyHCrVRzT8ga5XimSYmAFGzc/OvVzCmRu4D9vdlBcMNguIf1igUm7864/ChAX//taecb
 AOOYDEGEsa9LRhHK+f4EeaE4=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fbf6ae2c3556146a;
	Fri, 28 Aug 2026 07:20:49 +0000
X-Mizu-Trace-ID: fbf6ae2c3556146a
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
Subject: [PATCH v4 1/7] smb/client: validate new EOF for insert range
Date: Fri, 28 Aug 2026 15:19:29 +0800
Message-ID: <20260828071935.552165-2-huiwen.he@linux.dev>
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
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
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

