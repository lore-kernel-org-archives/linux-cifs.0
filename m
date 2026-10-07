Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36923496D3E
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378859; cv=none; b=JbeOCo8QBaHa8RTBEYaFTkxkw3t9ZeJwMz+Nlrp2vBAYPb1RdsI2IvZ9mTIP2ZnS3+22kcw2JTL64RkUmHt7kSy834yqSBewIgeBcNgjPp9IROD/BcejeMcV7lurCLnxGUXPcMXTpVl+s/emry5sLq9qSPlrjZ3NSI0IrkkhhfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378859; c=relaxed/simple;
	bh=S1nv8sZ4z/Hr9VErYp9be0DR0dBhRaf2A/rYiPuTmdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TxhmfeKgy3wcJ4V2mJY2kPzpF1+g3wCDBUzq9SmJgolFw6DEtFKh2Pz3M6sWIxN5D7RubfgZJNlgiKBSxV+WgTHJvkHFx7kHNZHex9rdYQw/dVkVgWIAPsuSuoqfLmo2f2Q5JQy/b9/mYYsfXva5dpC3soH1VIWC7CoxdQj0Pg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWQYO8K5; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWQYO8K5"
Received: by mail-pz2-f40.google.com with SMTP id d2e1a72fcca58-87887996990so191385b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 07 Oct 2026 06:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791378848; x=1791983648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ZRdtqkYDmeNoqn1xTNoRA+GBKnvF+80kTAY1mxh8NE=;
        b=aWQYO8K5JHQsyiHxXg/aogijKVYWVwVmzJX8xCF7FSsdWTh/qj90K26m/m1vVQ/KEN
         EgZEzZfcwAZ7zo93doht6S4Rd+GGxzHsk8A85FfGAYbi3QnEnVySMXCfEjW/XgCqYkj6
         5HSuZTF6ZxQ0LsEJX/7P0+4/diWOba7QevOZ0sWkBvWe7umwDesPpJMLKsh/zIZNN0gO
         coXik457SCdiAAZ6Iu+fQFKqAbMuXAgGNTaZvfjaEPox70yxjdM9YSU6Go+qfoLEECvJ
         l9vIo8Zvn1EvUpRC+X3ahNj+AmcP1PcAcZZ81mzok0o0Xjif3TPpPU7+0LMezRYNdoI5
         +/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791378848; x=1791983648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZRdtqkYDmeNoqn1xTNoRA+GBKnvF+80kTAY1mxh8NE=;
        b=ABeLJ5RgVShawOKH+HWaZvOaUBrdpVcrWCK/O5k6gFduLjDUgKvYleT4rlYaIdU24A
         HaUSdHOa89b5/K08Y6DF+FfMe7DAOhqI6iurAhuUkEO5FNiH/zfoLia7gJUmGPCyojbM
         IAd3mB7MTzuKFHEQVYgfSjEhkWsyyN2QgH8y9odeM+w/xSKieBCWwPeu5Pa63F52VEpU
         XasRkn/i6MUdykim+UUHZ17PWDg5FaX1/YkDdbA0/jA39KscdubDfCEgm9YW1wZ2F3P7
         htASqzt4OuSXHf5EO1lxpVeGYN8rck+YZUO+/Ceu6CFdKmNEg1/CgBvS2q71iuHR/frD
         +fPA==
X-Forwarded-Encrypted: i=1; AKwUvByEPPuud7P8q2X18Ed3zZgYfrNnvWWkjg7ozwyOaC/4RpeZ+MJADkXds6raR4i+3C8L3HqYVIYnAq8U@vger.kernel.org
X-Gm-Message-State: AFq9FYIaXIZ6uAj4el4WLtXfHKKJIfXCQaHYo0SdV5EvU2JZhvmrk6h8
	cY+1AZ/qLfTVwPXOLJQwgjPxPTsHxIcsRrDcXzfpBXix6N7yq+Gi2XDP
X-Gm-Gg: AYBFou1sE8BZSVdjOxYw9Oa7uBTvMZK78Igo2e6qyanqO+vtS1nZHB3OGbVuvizlwnr
	4f5GQaZZTwI1AyjcJeanaM7E12eTT+KyZPjn2Sh6GwbB8h+YvWoAOU1kxErewTXxhQ6c/JHXhnp
	mVKbcYhQcCXGUabNKjJcKQetXR26aI3ITxkJrvEAsfWmibIsYhY4eXaCpnnpCNl+LSuNsRGB99J
	bQCqUW3hoPQveM2mivhzjhYyLf0m2KfnK+EXdPJO/Mxdz7tphxyYyRAJJ9wDa+xDjjLd9aj+dVl
	hGPVOan1XbCrfQwxQ8t2Zn0AYAqLDyVo4A91vXkOSnxR6Z9+/APh0FTLNQ40fWTPgIaMv2kFXFz
	K0ZnV249RWS7A8EMR7NklNIry7hT+lN7b9C+6YVdYZuLE8mGsm2WkR3nO3hocy1PpAZKSFkbduq
	1hXRwSmu9m/PxMisP1Wuet2EGNnRADexezDBKV9IHE6o6B/N9q49wP59WmdwRwbzkflnw622wLv
	g==
X-Received: by 2002:a05:6a00:4782:b0:890:bb23:b973 with SMTP id d2e1a72fcca58-891b09892c6mr2131587b3a.2.1791378848289;
        Wed, 07 Oct 2026 06:14:08 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-892bac8e8f3sm76529b3a.15.2026.10.07.06.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 06:14:07 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix named stream write and EOF handling
Date: Wed,  7 Oct 2026 22:13:51 +0900
Message-ID: <20261007131351.2968640-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An SMB WRITE to an existing named stream can silently discard data after
its written range. ksmbd stores streams as xattr values, but the write
path passes offset + count as the length of the replacement xattr even
when the old stream is longer. Writing 26 bytes at offset 0 to a 60-byte
stream reports 26 bytes written while discarding the remaining 34 bytes.

Keep the existing xattr length when an in-place write ends before EOF.
Reject writes that cross XATTR_SIZE_MAX rather than storing only the
portion that fits while reporting the full requested count.

Commit 4ea0bb8aaedf ("ksmbd: handle set/get info file for streamed file")
intentionally skipped ordinary inode truncation for stream handles: an
EOF SetInfo on an ADS had truncated the base file. That fixed the base
file corruption but left stream EOF changes reporting success without
resizing the stream. Handle these requests by resizing only the stream
xattr; the base file size remains untouched. Zero-fill stream extensions.
This is needed alongside the write fix: a short write's accidental
truncation previously masked an ignored explicit EOF change. The stream
resize helper returns xattr errors directly rather than using the
base-file truncate path's EBADF conversion.

Fixes: f44158485826 ("cifsd: add file operations")
Fixes: 4ea0bb8aaedf ("ksmbd: handle set/get info file for streamed file")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
Tested with SMB2.1 against QEMU guests running kernels built from
ksmbd-for-next (17a2c1764a45) and cifs-next (ff47652a4b66). On both,
a 26-byte overwrite preserved the tail of a 60-byte stream, while an
explicit EOF=0 followed by the same write left 26 bytes. Shrink,
zero-filled extension, append, middle overwrite and size-limit tests
passed. Both kernels built successfully.

 fs/smb/server/smb2pdu.c |  5 ++--
 fs/smb/server/vfs.c     | 72 +++++++++++++++++++++++++++++++++++++++++++------
 fs/smb/server/vfs.h     |  1 +
 3 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 26e683aeb..12a43efdb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8578,6 +8578,8 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 	newsize = le64_to_cpu(file_eof_info->EndOfFile);
 	inode = file_inode(fp->filp);
+	if (ksmbd_stream_fd(fp))
+		return ksmbd_vfs_stream_truncate(fp, newsize);
 
 	/*
 	 * If FILE_END_OF_FILE_INFORMATION of set_info_file is called
@@ -8586,8 +8588,7 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	 * truncate of some filesystem like FAT32 fill zero data in
 	 * truncated range.
 	 */
-	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC &&
-	    ksmbd_stream_fd(fp) == false) {
+	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC) {
 		ksmbd_debug(SMB, "truncated to newsize %lld\n", newsize);
 		rc = ksmbd_vfs_truncate(work, fp, newsize);
 		if (rc) {
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index db0f2de2b..3e0609546 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -388,23 +388,21 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	const struct cred *saved_cred;
 	char *stream_buf = NULL, *wbuf;
 	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
-	size_t size;
+	size_t size, write_end;
 	ssize_t v_len;
 	int err = 0;
 
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
 		    *pos, count);
 
-	if (*pos >= XATTR_SIZE_MAX) {
+	if (*pos < 0 || *pos >= XATTR_SIZE_MAX) {
 		pr_err("stream write position %lld is out of bounds\n",	*pos);
 		return -EINVAL;
 	}
 
-	size = *pos + count;
-	if (size > XATTR_SIZE_MAX) {
-		size = XATTR_SIZE_MAX;
-		count = XATTR_SIZE_MAX - *pos;
-	}
+	if (count > XATTR_SIZE_MAX - *pos)
+		return -EFBIG;
+	write_end = *pos + count;
 
 	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(idmap,
@@ -417,6 +415,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		err = v_len;
 		goto out_revert;
 	}
+	/* Preserve the tail of an existing stream on an in-place write. */
+	size = max_t(size_t, v_len, write_end);
 
 	if (v_len < size) {
 		wbuf = kvzalloc(size, KSMBD_DEFAULT_GFP);
@@ -445,13 +445,69 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	if (err < 0)
 		goto out;
 	else
-		fp->stream.pos = size;
+		fp->stream.pos = write_end;
 	err = 0;
 out:
 	kvfree(stream_buf);
 	return err;
 }
 
+/**
+ * ksmbd_vfs_stream_truncate() - change the length of a named stream
+ * @fp:		stream file handle
+ * @newsize:	new stream length
+ *
+ * Resize the stream xattr without changing the base inode size.
+ *
+ * Return: 0 on success, otherwise a negative error code
+ */
+int ksmbd_vfs_stream_truncate(struct ksmbd_file *fp, loff_t newsize)
+{
+	const struct cred *saved_cred;
+	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
+	char *stream_buf = NULL, *new_buf = NULL;
+	ssize_t v_len;
+	int err;
+
+	if (newsize < 0)
+		return -EINVAL;
+	if (newsize > XATTR_SIZE_MAX)
+		return -EFBIG;
+
+	saved_cred = override_creds(fp->filp->f_cred);
+	v_len = ksmbd_vfs_getcasexattr(idmap, fp->filp->f_path.dentry,
+				       fp->stream.name, fp->stream.size,
+				       &stream_buf);
+	if (v_len < 0) {
+		err = v_len;
+		goto out;
+	}
+	if (v_len == newsize) {
+		err = 0;
+		goto out;
+	}
+
+	new_buf = stream_buf;
+	if (newsize > v_len) {
+		new_buf = kvzalloc(newsize, KSMBD_DEFAULT_GFP);
+		if (!new_buf) {
+			err = -ENOMEM;
+			goto out;
+		}
+		if (v_len)
+			memcpy(new_buf, stream_buf, v_len);
+	}
+
+	err = ksmbd_vfs_setxattr(idmap, &fp->filp->f_path, fp->stream.name,
+				 new_buf, newsize, 0, true);
+	if (new_buf != stream_buf)
+		kvfree(new_buf);
+out:
+	kvfree(stream_buf);
+	revert_creds(saved_cred);
+	return err;
+}
+
 /**
  * ksmbd_vfs_write() - vfs helper for smb file write
  * @work:	work
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 566c670c9..ef3ab3f18 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -83,6 +83,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 		    char *buf, size_t count, loff_t *pos, bool sync,
 		    ssize_t *written);
+int ksmbd_vfs_stream_truncate(struct ksmbd_file *fp, loff_t newsize);
 int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid, u64 p_id);
 int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path);
 int ksmbd_vfs_link(struct ksmbd_work *work,
