Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBABC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 04:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B460761038
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 04:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhIUEmf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 00:42:35 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:38481 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhIUEmf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 00:42:35 -0400
Received: by mail-pf1-f175.google.com with SMTP id y4so16766133pfe.5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 21:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vypsXh7GqcRDYOWJpLw6MHf+/r/txHRBTkQAHR1/Y1g=;
        b=PCaycE34c4ajbmUFzWhZc3t5WQlkqR1iY7RkOiJv8QJkSquK6OOrJDyZttoIs+BYa/
         rrq64vtJx3iQDhFrnWIFstpKTTWCKR5G9OdikOMGqAJdAuppm4G2RtSL/+jWrveC7ozU
         1IVPnaePO85aJslNMUiBFBPRVqite/GCMLvOWflOeqWD0MBhNM2pK5roVa/NUu86rMCz
         WPOOL9dttU7VQKmD9CmOArxAiBVK1r1ww7tn90vZafKIOCUGYGHvgJLlZCOYQv6irrRu
         QCM3ObN5qGwUZfCHu+monzF9zSDQXWPpmYS0WgqZb+u/D6+TXokTG84XuLunu+QgWICf
         wFyw==
X-Gm-Message-State: AOAM531SGpjfDJz81bQjMRhsPD/Oz2dk/83OystkNATS7h7/0SUctEfK
        JXgZCNWPtWYcJIa9R2vxWen00uPmJoF2Jw==
X-Google-Smtp-Source: ABdhPJyATBBM+5lhsTRPw241FXB33qnd8Jx1i+V2DmSP3OFwbSbKZy7PI4as/m1u6exgamWeYNluRQ==
X-Received: by 2002:a63:551a:: with SMTP id j26mr26989018pgb.142.1632199267005;
        Mon, 20 Sep 2021 21:41:07 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id u24sm16863257pfm.81.2021.09.20.21.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 21:41:06 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH v2] ksmbd: remove follow symlinks support
Date:   Tue, 21 Sep 2021 13:40:39 +0900
Message-Id: <20210921044040.624769-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch remove symlink support that can be vulnerable and access out
of share, and we re-implement it as reparse point later.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
  - reorganize path lookup in smb2_open to call only one
    ksmbd_vfs_kern_path().

 fs/ksmbd/smb2pdu.c | 60 ++++++++++------------------------------------
 fs/ksmbd/vfs.c     | 50 ++++++++------------------------------
 2 files changed, 22 insertions(+), 88 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e08c6b26b6f0..de044802fc5b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2648,19 +2648,9 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out1;
 	}
 
-	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
-		if (test_share_config_flag(work->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
-			/*
-			 * On delete request, instead of following up, need to
-			 * look the current entity
-			 */
-			rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
-		} else {
-			rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
-		}
-
-		if (!rc) {
+	rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
+	if (!rc) {
+		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
 			/*
 			 * If file exists with under flags, return access
 			 * denied error.
@@ -2679,26 +2669,10 @@ int smb2_open(struct ksmbd_work *work)
 				path_put(&path);
 				goto err_out;
 			}
-		}
-	} else {
-		if (test_share_config_flag(work->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
-			/*
-			 * Use LOOKUP_FOLLOW to follow the path of
-			 * symlink in path buildup
-			 */
-			rc = ksmbd_vfs_kern_path(name, LOOKUP_FOLLOW, &path, 1);
-			if (rc) { /* Case for broken link ?*/
-				rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
-			}
-		} else {
-			rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS,
-						 &path, 1);
-			if (!rc && d_is_symlink(path.dentry)) {
-				rc = -EACCES;
-				path_put(&path);
-				goto err_out;
-			}
+		} else if (d_is_symlink(path.dentry)) {
+			rc = -EACCES;
+			path_put(&path);
+			goto err_out;
 		}
 	}
 
@@ -4781,12 +4755,8 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	struct path path;
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
-	int lookup_flags = LOOKUP_NO_SYMLINKS;
-
-	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
 
-	rc = ksmbd_vfs_kern_path(share->path, lookup_flags, &path, 0);
+	rc = ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0);
 	if (rc) {
 		pr_err("cannot create vfs path\n");
 		return -EIO;
@@ -5293,7 +5263,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	char *pathname = NULL;
 	struct path path;
 	bool file_present = true;
-	int rc, lookup_flags = LOOKUP_NO_SYMLINKS;
+	int rc;
 
 	ksmbd_debug(SMB, "setting FILE_RENAME_INFO\n");
 	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -5362,11 +5332,8 @@ static int smb2_rename(struct ksmbd_work *work,
 		goto out;
 	}
 
-	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
-
 	ksmbd_debug(SMB, "new name %s\n", new_name);
-	rc = ksmbd_vfs_kern_path(new_name, lookup_flags, &path, 1);
+	rc = ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1);
 	if (rc)
 		file_present = false;
 	else
@@ -5416,7 +5383,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path;
 	bool file_present = true;
-	int rc, lookup_flags = LOOKUP_NO_SYMLINKS;
+	int rc;
 
 	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
 	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -5439,11 +5406,8 @@ static int smb2_create_link(struct ksmbd_work *work,
 		goto out;
 	}
 
-	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
-
 	ksmbd_debug(SMB, "target name is %s\n", target_name);
-	rc = ksmbd_vfs_kern_path(link_name, lookup_flags, &path, 0);
+	rc = ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, 0);
 	if (rc)
 		file_present = false;
 	else
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 53047f013371..3733e4944c1d 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -164,13 +164,9 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 {
 	struct path path;
 	struct dentry *dentry;
-	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
-
-	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
+	int err;
 
-	dentry = kern_path_create(AT_FDCWD, name, &path, lookup_flags);
+	dentry = kern_path_create(AT_FDCWD, name, &path, LOOKUP_NO_SYMLINKS);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		if (err != -ENOENT)
@@ -205,14 +201,10 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 	struct user_namespace *user_ns;
 	struct path path;
 	struct dentry *dentry;
-	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
-
-	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
+	int err;
 
 	dentry = kern_path_create(AT_FDCWD, name, &path,
-				  lookup_flags | LOOKUP_DIRECTORY);
+				  LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		if (err != -EEXIST)
@@ -597,16 +589,11 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
 	struct path path;
 	struct dentry *parent;
 	int err;
-	int flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
 		return -ENOMEM;
 
-	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		flags = LOOKUP_FOLLOW;
-
-	err = kern_path(name, flags, &path);
+	err = kern_path(name, LOOKUP_NO_SYMLINKS, &path);
 	if (err) {
 		ksmbd_debug(VFS, "can't get %s, err %d\n", name, err);
 		ksmbd_revert_fsids(work);
@@ -661,16 +648,11 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 	struct path oldpath, newpath;
 	struct dentry *dentry;
 	int err;
-	int flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
 		return -ENOMEM;
 
-	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		flags = LOOKUP_FOLLOW;
-
-	err = kern_path(oldname, flags, &oldpath);
+	err = kern_path(oldname, LOOKUP_NO_SYMLINKS, &oldpath);
 	if (err) {
 		pr_err("cannot get linux path for %s, err = %d\n",
 		       oldname, err);
@@ -678,7 +660,7 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 	}
 
 	dentry = kern_path_create(AT_FDCWD, newname, &newpath,
-				  flags | LOOKUP_REVAL);
+				  LOOKUP_NO_SYMLINKS | LOOKUP_REVAL);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		pr_err("path create err for %s, err %d\n", newname, err);
@@ -797,7 +779,6 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	struct dentry *src_dent, *trap_dent, *src_child;
 	char *dst_name;
 	int err;
-	int flags = LOOKUP_NO_SYMLINKS;
 
 	dst_name = extract_last_component(newname);
 	if (!dst_name)
@@ -806,13 +787,8 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	src_dent_parent = dget_parent(fp->filp->f_path.dentry);
 	src_dent = fp->filp->f_path.dentry;
 
-	flags = LOOKUP_DIRECTORY;
-	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		flags = LOOKUP_FOLLOW;
-	flags |= LOOKUP_DIRECTORY;
-
-	err = kern_path(newname, flags, &dst_path);
+	err = kern_path(newname, LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY,
+			&dst_path);
 	if (err) {
 		ksmbd_debug(VFS, "Cannot get path for %s [%d]\n", newname, err);
 		goto out;
@@ -871,13 +847,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work, const char *name,
 	int err = 0;
 
 	if (name) {
-		int flags = LOOKUP_NO_SYMLINKS;
-
-		if (test_share_config_flag(work->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-			flags = LOOKUP_FOLLOW;
-
-		err = kern_path(name, flags, &path);
+		err = kern_path(name, LOOKUP_NO_SYMLINKS, &path);
 		if (err) {
 			pr_err("cannot get linux path for %s, err %d\n",
 			       name, err);
-- 
2.25.1

