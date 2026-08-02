Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A4393DDB
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785690553; cv=none; b=jjrSZ9TOZCh535bE8xP7mZ8DMPyXFRARa2c+DgOLXKpy9PxJ2E937edHenmG2r1ujyQ+7BgXcuEyQbwHULpKRjerF2UOP1xiZPPgW4cLm+wROxnH2hlSM5Mlbv4K5r3zAufIEwYP8bnsItGe8NygGcP+EGGWYPanWgzHu+c7PDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785690553; c=relaxed/simple;
	bh=WgaP/LADAm301kMdc88t+zFcGfNetRPwHC+FZKmoFME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hzcci9VzToMrpKCoHyf1/jBbh/ZXL3NJKiym7+J/z7RLRkxgA71mEIUpTS57kHxPD6UUqCjuzGJbCYGbt69RcTi4JWnCGMyio6tPJPW5xuMsMNP/AGwc1zTYdfyVi+vyuQDp/WM/lyRAq99rNpvCWbix/wMj/5+HEdkqrijQ7Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=iOlFCkX7; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="iOlFCkX7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785690548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LpvJGHsA5QSBQa2nqE+biSJAyBUge6cVZGIJwJmhZ+k=;
	b=iOlFCkX7y+eJ75bdnaZKcVa/3eTe6Jqd9Q2/4GsvvqKjbp/Pxp+XRjXsdniqiJ2X9Oknim
	zksmv7wg5qKI/tTDAW/UIRqOsMXoSEDJT47KZnZjjs23FGgpfqgS/g0yokEzoDgQiY2QFp
	EtR0c6ejMd6ZbdUATm1bqAswEbJ0yS72doQ6EjpL0FRIFZpGhMhtJIJVqidzphSPBotUXV
	LJFU7+Xr0eQth2rDlF1X2UsaM8F9fLD6t7K5EcoF6ZbRY+PAclsnVA6VgAsXWXXF7rzf54
	alKaO+clD9wG9McE2mrKn0kQj9pgqpX60Q108l1F2iGTHGDa57tWFjyLKdxLcA==
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
Subject: [PATCH 1/2] smb/server: pass source ksmbd_file to rename helpers
Date: Sun,  2 Aug 2026 17:07:56 +0000
Message-ID: <20260802170757.220862-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
References: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Pass the source ksmbd_file to ksmbd_vfs_rename() and
ksmbd_has_open_files().

This is a preparatory change for the next patch. Keeping the interface
change separate makes the functional fix easier to review.

No functional change.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c   | 2 +-
 fs/smb/server/vfs.c       | 5 +++--
 fs/smb/server/vfs.h       | 4 ++--
 fs/smb/server/vfs_cache.c | 3 ++-
 fs/smb/server/vfs_cache.h | 2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2039a44d4b17..cb6c222b937b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7690,7 +7690,7 @@ static int smb2_rename(struct ksmbd_work *work,
 		goto out;
 
 	smb_break_all_levII_oplock_rename(work, fp);
-	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
+	rc = ksmbd_vfs_rename(work, fp, new_name, flags);
 out:
 	kfree(new_name);
 	return rc;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 8a80d6d8e02d..34975e18528c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -681,9 +681,10 @@ int ksmbd_vfs_check_rename_share(struct ksmbd_work *work,
 	return err;
 }
 
-int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
+int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
 			     char *newname, int flags)
 {
+	const struct path *old_path = &old_fp->filp->f_path;
 	struct dentry *old_child = old_path->dentry;
 	struct path new_path;
 	struct qstr new_last;
@@ -721,7 +722,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out_drop_write;
 
 	if (!work->tcon->posix_extensions && d_is_dir(old_child) &&
-	    ksmbd_has_open_files(old_child)) {
+	    ksmbd_has_open_files(old_fp)) {
 		err = -EACCES;
 		goto out3;
 	}
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 1818b3f1971c..f922cd15ce3e 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -88,8 +88,8 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path);
 int ksmbd_vfs_link(struct ksmbd_work *work,
 		   const char *oldname, const char *newname);
 int ksmbd_vfs_getattr(const struct path *path, struct kstat *stat);
-int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
-			     char *newname, int flags);
+int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
+		     char *newname, int flags);
 int ksmbd_vfs_check_rename_share(struct ksmbd_work *work,
 				 const struct path *old_path);
 int ksmbd_vfs_truncate(struct ksmbd_work *work,
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index a35df2ab59c9..c66584ed23ab 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1137,8 +1137,9 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
-bool ksmbd_has_open_files(struct dentry *dentry)
+bool ksmbd_has_open_files(struct ksmbd_file *old_fp)
 {
+	struct dentry *dentry = old_fp->filp->f_path.dentry;
 	struct ksmbd_file *fp;
 	unsigned int id;
 	bool ret = false;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index d80f379d4e12..127ea4987e3f 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -212,7 +212,7 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
-bool ksmbd_has_open_files(struct dentry *dentry);
+bool ksmbd_has_open_files(struct ksmbd_file *old_fp);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_launch_ksmbd_durable_scavenger(void);
-- 
2.54.0

