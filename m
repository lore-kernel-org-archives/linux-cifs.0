Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E154C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 06:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B6876109E
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 06:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhITG5w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 02:57:52 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44002 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhITG5v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 02:57:51 -0400
Received: by mail-pj1-f44.google.com with SMTP id k23-20020a17090a591700b001976d2db364so11920588pji.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 23:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0KLWuDWmLIJ86wuoY+otk1OE9KRmw4oj81l329YCrM=;
        b=eb2B0tSYykAvVFdhyrnF+CxZB1cc2HkzGltkQR1/3OtHN6mI9uc4FP4sG8PsC8ocsF
         e8YlqLzogcpEWpoJJlWkAX01Bd3r8NoG0E2sFivb5mUMTMPmUM4jNNTuKwxE1b7vSj8S
         iPFzq2fcPtgeU2dsbXP7VEKv/91to41jaslzJJ1S4vr8YZ446TSkbZ+spl6+hINdxfnY
         1ICcmyoTEu8o9uICLNOLZVraWG2YAnR90XbyPPITaTzBCR53eOvXx6uA6AAAcOrbOZ7T
         /rEeIefz9HumUk7ER+pna4hsPBpazjmMXiaROCyPXtYiy14esHVe5lZtjWEqp0Y7+NTb
         4+mQ==
X-Gm-Message-State: AOAM530DHZfDXy0cjtpRlK2KQFbqce/p4d5YbIcWOikKUGt9oNgP2cgQ
        2xbGcqUvVjW19El2dyeu7ohXVBFotqmcLg==
X-Google-Smtp-Source: ABdhPJy1q4I43R7Q50GiY2pPvMbxs6SR9+WhXKhRdSCw8qpgwQFszygTMN9m1Ni+VqqeCThqGx+5gw==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr35702085pjb.15.1632120984759;
        Sun, 19 Sep 2021 23:56:24 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id u12sm14008332pgi.21.2021.09.19.23.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 23:56:24 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH] ksmbd: remove follow symlinks support
Date:   Mon, 20 Sep 2021 15:56:13 +0900
Message-Id: <20210920065613.5506-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch remove symlink support that can be vulnerable, and we
re-implement it as reparse point later.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 55 ++++++++++------------------------------------
 fs/ksmbd/vfs.c     | 50 +++++++++--------------------------------
 2 files changed, 21 insertions(+), 84 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index afc508c2656d..911c5e97678d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2661,17 +2661,7 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
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
+		rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
 		if (!rc) {
 			/*
 			 * If file exists with under flags, return access
@@ -2693,24 +2683,11 @@ int smb2_open(struct ksmbd_work *work)
 			}
 		}
 	} else {
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
+		rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
+		if (!rc && d_is_symlink(path.dentry)) {
+			rc = -EACCES;
+			path_put(&path);
+			goto err_out;
 		}
 	}
 
@@ -4795,12 +4772,8 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	struct path path;
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
-	int lookup_flags = LOOKUP_NO_SYMLINKS;
 
-	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
-
-	rc = ksmbd_vfs_kern_path(share->path, lookup_flags, &path, 0);
+	rc = ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0);
 	if (rc) {
 		pr_err("cannot create vfs path\n");
 		return -EIO;
@@ -5307,7 +5280,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	char *pathname = NULL;
 	struct path path;
 	bool file_present = true;
-	int rc, lookup_flags = LOOKUP_NO_SYMLINKS;
+	int rc;
 
 	ksmbd_debug(SMB, "setting FILE_RENAME_INFO\n");
 	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -5376,11 +5349,8 @@ static int smb2_rename(struct ksmbd_work *work,
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
@@ -5430,7 +5400,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path;
 	bool file_present = true;
-	int rc, lookup_flags = LOOKUP_NO_SYMLINKS;
+	int rc;
 
 	if (buf_len < sizeof(struct smb2_file_link_info) +
 			le32_to_cpu(file_info->FileNameLength))
@@ -5457,11 +5427,8 @@ static int smb2_create_link(struct ksmbd_work *work,
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

