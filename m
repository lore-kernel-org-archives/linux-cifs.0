Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8FD3CB8FF
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785906753; cv=none; b=IsKX9nHH17DdTS3jGYnIN01qHbsabR0ClkizaQpbmiTt8i4pRfka9QGQ6e//zK46qfsoPbjRFXB27UT8RcoMvAd8YRyT+Klqr6/jUVQYljYk5H+PyVgxbwueHNJi1KtZ6U3GHAN1Go/J+4EYfGlmPrKXLDBboiQG18roCce7kgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785906753; c=relaxed/simple;
	bh=rAYkfwPuyDHnfwVs9MUeq0Fv3vZbg0hBQkYzejuBApw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8OryIFKqRW8T8HwVxmYG207HQzWQpblsO/npniEbQwA6bNvTqJ8dX+znsBhwS7T5/rNfCEHgLWOdNbrR2JGP23PAwO2qRUwpEUjP178n2mH79/r/crdTQAPjhfQNlF5I2QMR6U32iJ8lh81yRogm+/meA5vNJHf2qWcFeDLn5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=qeMdcGTg; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="qeMdcGTg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785906749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eto3qsQl/EOWiEO/jhRlxIsgonKhs03tgb7cLIy2dW0=;
	b=qeMdcGTgSmPAMTEAVUXUjfVfe0lbaa6hvJJzqBprWz4z+mEjTRxEyuLxZpyekrx8+3NN02
	uBPliS9B+H2IHJbq6WGY0lcMivLayji2FFXNGpCNcibfXfwTXfy93GzMn9Ya8QAnfF/7Q9
	kVQ6rsb0J98GCJGmnVhX+LAr7FtQVMhM8SavDzyHMwL/Rqz0YCuzzFuH+vX9hdRCoRNzpa
	HCktVmWJiBtqERnl+1lCQgQ3E0bPMZTHI2iiVUKWKPpFohzn+c0aM9t/t2ELvOu6gW2m73
	Syxdgb+hnaKgL+4cG0x/cXtq1HFGT0hTwFMoLgsGGLV0ukU9V+QsiUoZC6tWNg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 resend 2/3] smb/server: deny overwriting targets with non-POSIX opens
Date: Wed,  5 Aug 2026 05:11:11 +0000
Message-ID: <20260805051112.305078-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
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

