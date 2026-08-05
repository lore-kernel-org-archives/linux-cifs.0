Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C1B30648C
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 04:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785905300; cv=none; b=Q7qt4zpgSi31JDXPmOxe5Bbgxgg++adqjlSOqPpRF9wbXWmwhFX61ppNJSXqfFlWhCTxjFjYbB3Tm3LMsbX6yU+FYYi3Mjrv+4jYlIfSK23z4tTVg3QIqfQDlkt0ToVyMthqAvi/OI0DBUCHWe3IAeUbZXM32j8f4OPpOLL+/Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785905300; c=relaxed/simple;
	bh=rAYkfwPuyDHnfwVs9MUeq0Fv3vZbg0hBQkYzejuBApw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thvYSJ42lyAviRY+NQVWBotAPnwEIGYex0MPTKpA3ov9MAzX0LwPeOFkmknKNVVGvXz4XGNm8GopM7BDc7fB2ruw4GPh+kNkFjYeIu7vnnJrFHtqPzlE3nqExOCkwCvV53mDTO2ITODMuVQEB+B9siC7Ym/94TI52R/NLdg28EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=I8L74JZV; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="I8L74JZV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785905295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eto3qsQl/EOWiEO/jhRlxIsgonKhs03tgb7cLIy2dW0=;
	b=I8L74JZVo+3EVzjv8P1+zcOJm0Kows23/kq18eSLxPbieclo7w8KbgPy56iQLRqO7vjDVZ
	I88PR5bq1Kgh70twdIXEdaOO4tX1H0e5Jbzu/yQfQ0EyoGe0FMXoSZC8JKqlWcqYnFK371
	21xOuNuxBItZB8waQqlA6nVeNlV0Iy3ISU2UR0HH/+pPGxCzyM6CS2wzMJXS0Oux2N4NFH
	Qwl5JIQiJcei2x1HQjf8IPjJ7f8HhYTswa4YJYkdDFhMvUNNIzRcTHIOIYGg2F4bIyr38u
	uD2oGdn1Xa8NVVlKOe9fZ/xWjsSMS65UkITe5/14NvCrXEh36V/TuT80vXt+hw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 2/3] smb/server: deny overwriting targets with non-POSIX opens
Date: Wed,  5 Aug 2026 04:47:06 +0000
Message-ID: <20260805044706.304687-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260805043704.304533-1-chenxiaosong@chenxiaosong.com>
References: <20260805043704.304533-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount without `posix` option
     mount -t cifs //${server_ip}/export /mnt
  3. client: touch /mnt/file1 /mnt/file2
  4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
  5. client: C program: rename("/mnt/file1", "/mnt/file2");
  6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
                        stbuf.st_nlink is 1, should be 0

This patch fixes xfstests generic/035 when mounted without `posix` option.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c       | 13 +++++++++++++
 fs/smb/server/vfs_cache.c | 27 +++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 41 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 16ef8d051b18..9102ab47a3aa 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -726,6 +726,19 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
 		goto out3;
 	}
 
+	/*
+	 * See MS-FSA 2.1.5.15.12.
+	 * An overwrite rename must fail with STATUS_ACCESS_DENIED if the
+	 * existing target still has a non-POSIX open.
+	 */
+	if (!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)) &&
+	    d_inode(rd.new_dentry) &&
+	    d_inode(rd.new_dentry) != d_inode(old_child) &&
+	    ksmbd_has_other_nonposix_open(rd.new_dentry)) {
+		err = -EACCES;
+		goto out3;
+	}
+
 	err = ksmbd_vfs_check_rename_share(work, old_path);
 	if (err)
 		goto out3;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 028bc1b0f652..90348a409162 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1137,6 +1137,33 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
+bool ksmbd_has_other_nonposix_open(struct dentry *dentry)
+{
+	struct ksmbd_file *fp;
+	struct inode *inode = d_inode(dentry);
+	unsigned int id;
+	bool ret = false;
+
+	if (!inode)
+		return false;
+
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		if (READ_ONCE(fp->f_state) != FP_INITED)
+			continue;
+		if (inode != file_inode(fp->filp))
+			continue;
+		if (fp->is_posix_ctxt)
+			continue;
+
+		ret = true;
+		break;
+	}
+	read_unlock(&global_ft.lock);
+
+	return ret;
+}
+
 bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp)
 {
 	struct dentry *dentry = old_fp->filp->f_path.dentry;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 9dca617bc429..5cac022b540b 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -212,6 +212,7 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
+bool ksmbd_has_other_nonposix_open(struct dentry *dentry);
 bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
-- 
2.54.0

