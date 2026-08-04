Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D3346E5D
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 12:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785846858; cv=none; b=MRwG5Td/XsIzhBwyuzkKeqXVnJ8wF/X0jLApeid3ov/Mvs8QGKNkmZShKiyWRJO02H2ttu8fOyjZtakgAmiI4YCNFvuDQLSvUAR+rs5lqfPm9f0Z05+NgUe1/XzOoeK11/xafGpTcXK4I0tU90xKjwlxaWUVLIeLexCm+2Kv84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785846858; c=relaxed/simple;
	bh=QqpYnoBqb6SqxeYGYUKDxgYqhoB+Ct32ZTmfrKC4pbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X85ilRquiEGTjXr1qjH6WSr9HOgAjdOmZ9D6tnHVx0OKTvVoVB4D9OFeKiAEYJzyjtrATKq9Ar41teK/PM8uhRSpsedk743ZeyMo9/nicZHXnqOC06taH/IjIp+tsj3OcE4SQ/xMHfqx+J1XG7mDVL6LLMNdTa6sj6fmKTf+4y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=dgrNsEO/; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="dgrNsEO/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785846853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nz6nU6eGxZL16/U51eQeyGTX0zYw3elRhjZ+3FAlKUs=;
	b=dgrNsEO/aKYzeT3RPYcN3H9kbRRLwyVlRlbTMDcs9zOncpcvpYVq0kwhj90CV3EWX4HPg+
	gTJuDtvc1/CchJmOwKWNDgFM4gqDig9Q9j9YqznEKIkXO1VY7BdnoKhORUbiJ+IenNHpUb
	jp5Lkaxz5mqZXQhJPx/B10t5K2OvC/XN6EIE8gFh2dzEfUl6n55/8sKgwJzg8QebxTcVUQ
	YxXGBtvzDfiBqJJifyq9AxtydaI697hHRKTzQclT8A0cIm4eG7MMfMQRPa8zuH6gjYIaAw
	yBAY1iL/8V6Pd6R/BYjp6gf9D0bjWGLRe4vWfP/8pKXeyLCaaRHc8gzXXmNmag==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/3] smb/server: rename to ksmbd_has_nonposix_open_child()
Date: Tue,  4 Aug 2026 12:32:59 +0000
Message-ID: <20260804123301.285434-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The original function name `ksmbd_has_open_files()` could be confused with
the function name introduced in the next patch, and it does not accurately
describe what this function does.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c       | 2 +-
 fs/smb/server/vfs_cache.c | 2 +-
 fs/smb/server/vfs_cache.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 28940c7b5f83..16ef8d051b18 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -721,7 +721,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
 	if (err)
 		goto out_drop_write;
 
-	if (d_is_dir(old_child) && ksmbd_has_open_files(old_fp)) {
+	if (d_is_dir(old_child) && ksmbd_has_nonposix_open_child(old_fp)) {
 		err = -EACCES;
 		goto out3;
 	}
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index eac9886eb6e3..028bc1b0f652 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1137,7 +1137,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
-bool ksmbd_has_open_files(struct ksmbd_file *old_fp)
+bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp)
 {
 	struct dentry *dentry = old_fp->filp->f_path.dentry;
 	struct ksmbd_file *fp;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 127ea4987e3f..9dca617bc429 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -212,7 +212,7 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
-bool ksmbd_has_open_files(struct ksmbd_file *old_fp);
+bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_launch_ksmbd_durable_scavenger(void);
-- 
2.54.0

