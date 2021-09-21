Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F9BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 05:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80CD560F70
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 05:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhIUFVL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 01:21:11 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33728 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhIUFVL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 01:21:11 -0400
Received: by mail-pg1-f180.google.com with SMTP id u18so19730690pgf.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 22:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgRdlYb0vLw7zuc0p+aQf+5UmN8QJk9k1rvdQ30L6GM=;
        b=i+c6iWy/0iLmSbooTs1ysUbC+0i1Z2rg1CKlNkMAVX7xkh2TFkf1Gh1AsOxubBs+p5
         5EpfihSdqeQvVh+6u8uMdPughREXkgpl4DRUIkemJdhiVrOm1zGqT5XQy26Kk2fB0bpg
         7NPaGnPujqb58QbMm16xZJVaUpH6oWTtlvNAgYcdc+aFSkDOMkV9gKhy8FJfa/cMfKJ9
         BbPBkrj3KM4J47B8Ln5rgz+WquRSX2RlRV/MEaecVIM+FnQImog84krYh1XPOmXzPweX
         nrqSJlQ699CJmSluxGadtpuLVrHmT9CKvz2d1rkUMurLpVUSSvs4i0aDof23FYkgS0iU
         luQw==
X-Gm-Message-State: AOAM533NhRdr0vDxa/o9J5Qzl5399hzxFmDV925lTHo5reBmGeKB6VHW
        LFkUtl/g1P/tge5+519vAXV1eliFhjM/cQ==
X-Google-Smtp-Source: ABdhPJxNPmgetoKo1JR27tuplgz5PZemayua7+AjNXznZGtkH/hZuEfuJpQMD3uJ32VmNlc1zboPvQ==
X-Received: by 2002:aa7:988c:0:b0:445:13a5:67bd with SMTP id r12-20020aa7988c000000b0044513a567bdmr19877751pfl.16.1632201582857;
        Mon, 20 Sep 2021 22:19:42 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id p4sm16744797pgc.15.2021.09.20.22.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 22:19:42 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH v3] ksmbd: remove follow symlinks support
Date:   Tue, 21 Sep 2021 14:19:33 +0900
Message-Id: <20210921051933.626532-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the middle of
symlink component lookup and remove follow symlinks parameter support.
We re-implement it as reparse point later.

Test result:
smbclient -Ulinkinjeon%1234 //172.30.1.42/share -c
"get hacked/passwd passwd"
NT_STATUS_OBJECT_NAME_NOT_FOUND opening remote file \hacked\passwd

Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
  - reorganize path lookup in smb2_open to call only one
    ksmbd_vfs_kern_path().
 v3:
  - combine "ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup"
    patch into this patch.

 fs/ksmbd/smb2pdu.c | 43 ++++++++++---------------------------------
 fs/ksmbd/vfs.c     | 32 +++++++++-----------------------
 2 files changed, 19 insertions(+), 56 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4399c399284b..baf7ce31d557 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2660,13 +2660,9 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out1;
 	}
 
-	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
-		/*
-		 * On delete request, instead of following up, need to
-		 * look the current entity
-		 */
-		rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
-		if (!rc) {
+	rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
+	if (!rc) {
+		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
 			/*
 			 * If file exists with under flags, return access
 			 * denied error.
@@ -2685,25 +2681,10 @@ int smb2_open(struct ksmbd_work *work)
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
-			rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
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
 
@@ -4788,12 +4769,8 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	struct path path;
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
-	int lookup_flags = 0;
-
-	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		lookup_flags = LOOKUP_FOLLOW;
 
-	rc = ksmbd_vfs_kern_path(share->path, lookup_flags, &path, 0);
+	rc = ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0);
 	if (rc) {
 		pr_err("cannot create vfs path\n");
 		return -EIO;
@@ -5370,7 +5347,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	}
 
 	ksmbd_debug(SMB, "new name %s\n", new_name);
-	rc = ksmbd_vfs_kern_path(new_name, 0, &path, 1);
+	rc = ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1);
 	if (rc)
 		file_present = false;
 	else
@@ -5448,7 +5425,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 	}
 
 	ksmbd_debug(SMB, "target name is %s\n", target_name);
-	rc = ksmbd_vfs_kern_path(link_name, 0, &path, 0);
+	rc = ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, 0);
 	if (rc)
 		file_present = false;
 	else
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index b047f2980d96..3733e4944c1d 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -166,7 +166,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 	struct dentry *dentry;
 	int err;
 
-	dentry = kern_path_create(AT_FDCWD, name, &path, 0);
+	dentry = kern_path_create(AT_FDCWD, name, &path, LOOKUP_NO_SYMLINKS);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		if (err != -ENOENT)
@@ -203,7 +203,8 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 	struct dentry *dentry;
 	int err;
 
-	dentry = kern_path_create(AT_FDCWD, name, &path, LOOKUP_DIRECTORY);
+	dentry = kern_path_create(AT_FDCWD, name, &path,
+				  LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		if (err != -EEXIST)
@@ -588,16 +589,11 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
 	struct path path;
 	struct dentry *parent;
 	int err;
-	int flags = 0;
 
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
@@ -652,16 +648,11 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 	struct path oldpath, newpath;
 	struct dentry *dentry;
 	int err;
-	int flags = 0;
 
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
@@ -669,7 +660,7 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 	}
 
 	dentry = kern_path_create(AT_FDCWD, newname, &newpath,
-				  flags | LOOKUP_REVAL);
+				  LOOKUP_NO_SYMLINKS | LOOKUP_REVAL);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		pr_err("path create err for %s, err %d\n", newname, err);
@@ -788,7 +779,6 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	struct dentry *src_dent, *trap_dent, *src_child;
 	char *dst_name;
 	int err;
-	int flags;
 
 	dst_name = extract_last_component(newname);
 	if (!dst_name)
@@ -797,12 +787,8 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	src_dent_parent = dget_parent(fp->filp->f_path.dentry);
 	src_dent = fp->filp->f_path.dentry;
 
-	flags = LOOKUP_DIRECTORY;
-	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		flags |= LOOKUP_FOLLOW;
-
-	err = kern_path(newname, flags, &dst_path);
+	err = kern_path(newname, LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY,
+			&dst_path);
 	if (err) {
 		ksmbd_debug(VFS, "Cannot get path for %s [%d]\n", newname, err);
 		goto out;
@@ -861,7 +847,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work, const char *name,
 	int err = 0;
 
 	if (name) {
-		err = kern_path(name, 0, &path);
+		err = kern_path(name, LOOKUP_NO_SYMLINKS, &path);
 		if (err) {
 			pr_err("cannot get linux path for %s, err %d\n",
 			       name, err);
-- 
2.25.1

