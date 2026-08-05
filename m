Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9705621CA03
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785906751; cv=none; b=j1tHjQetAtfYXPtrLZ/hPvnPN2uXBjMv1ef60xkGl59IYRK5/v6QqWD7RMfRAK8EmMXeb0kINsmwQzFskeBgjRsBjwKzmcbseyG7VHynA/n0dtunEIstgpq93lOiHjF2ZxXFSKC8hSNSXn34IC+JLH+rgbvWHuXaCigRx0FHQr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785906751; c=relaxed/simple;
	bh=QqpYnoBqb6SqxeYGYUKDxgYqhoB+Ct32ZTmfrKC4pbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INYcSlUlCIoe6n5TEBcKbx+v3ipS9dQyHqMQ4T5RjSEZGGQGovTDwag/4m+B8JUbbm0n9WOLLqtmZNP3odXNHTABG0WC67TEBPxzWXx6VUFNxXIX1lUjAB8IZtjYnw9sO9IFz5Wgfp5NMurUUVGcG1BQrVOlTTOHVMg3ZI6icN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=KUZdK5cH; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="KUZdK5cH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785906744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nz6nU6eGxZL16/U51eQeyGTX0zYw3elRhjZ+3FAlKUs=;
	b=KUZdK5cH6c7iP+mwSRFHGI6hoETIK9094LbMexdma2qfUzgoShdd/gEEvixuFuSTt93AvO
	JdpDwn+Bx74SjeAhv/Giy9oTz6QZyDJixc07iz7JqeYxrM0VyPpKksjDLHyY/bsAUtECcx
	GjihzTg38ztqm3vlKjG/qvsu3FOeLDPW0UfzeDBTfFxZJ8l7D2RQquTms022wNtuNbNepd
	YeM0iPNMZVpIXEo003VoTxHwg9nkXDpyZxzE8Af4T2CTmMRZVfF95dKihAKKoQ9+0sLhPI
	ncKHdsDfEAmFVFgftSvZAX6/ohhyFaMnUVG/QXIIAqpGO62t9AT7THH38pdTYg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 resend 1/3] smb/server: rename to ksmbd_has_nonposix_open_child()
Date: Wed,  5 Aug 2026 05:11:10 +0000
Message-ID: <20260805051112.305078-2-chenxiaosong@chenxiaosong.com>
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

