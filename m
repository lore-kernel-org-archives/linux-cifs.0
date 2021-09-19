Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D2BC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E7F661056
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhISCO4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:14:56 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:40518 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhISCOz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 22:14:55 -0400
Received: by mail-pl1-f174.google.com with SMTP id n18so8764358plp.7
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 19:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ufpnubNsOGy3WOlXZoQ3yaxPkdTwa+8ByCfDSeTBfg=;
        b=In1Em+A7TMYDMyqakci6QujVUXXX2T5OgXEIsxZQhw90ckjYBZnkFgxQ2fQ4kiqX5M
         yZAwluB3Nlp7nUJXXY/m3KBRlr56rbsD7ertULWjL04IPYu3khRY9+NBccTawnjwVpm6
         hdJZybsqPsNf0+WqQLjgdogd9cvsmT8yEyjhFeHlHpO/RmvctVe9sBv7hwKwO83+bLvo
         iFhqiNk7+0bNhJEHbJNyj/eDNvKWPDEjql5nxAwJTHstSZPGdqq/JvL04sTnRT0NHqEY
         P/bng/hT8jBHGa1VyZefw/jYEh+GPYuQynHIG8K1CI/Lf0ezRwvR6SOZAK0VnATNGY3U
         daMA==
X-Gm-Message-State: AOAM531snven/K0x6YF+tAUPXFIHzUPVqGFQ4lWUdF77G3PwfntwFHC2
        t0WhchO/ZU+5Vli5pjwEbeNJuuZmk8SiaA==
X-Google-Smtp-Source: ABdhPJxQAVSpf3ymCqkyLo2rHmbBFPdNn1rWDuWkcx4gzy8aqo1u9Q1Mmr5nZU7zfS3plZsoS1Y4Ww==
X-Received: by 2002:a17:90a:b907:: with SMTP id p7mr21385633pjr.142.1632017610623;
        Sat, 18 Sep 2021 19:13:30 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m28sm10849537pgl.9.2021.09.18.19.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 19:13:30 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH] ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup
Date:   Sun, 19 Sep 2021 11:13:12 +0900
Message-Id: <20210919021315.642856-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the middle of
symlink component lookup.

Test result:
# smbclient -Ulinkinjeon%1234 //172.30.1.42/share -c
"get hacked/passwd passwd"
NT_STATUS_OBJECT_NAME_NOT_FOUND opening remote file \hacked\passwd

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 35 ++++++++++++++++++++++++-----------
 fs/ksmbd/vfs.c     | 34 +++++++++++++++++++++++++---------
 2 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 592d489277e8..afc508c2656d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2661,11 +2661,17 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
-		/*
-		 * On delete request, instead of following up, need to
-		 * look the current entity
-		 */
-		rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
+		if (test_share_config_flag(work->tcon->share_conf,
+					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
+			/*
+			 * On delete request, instead of following up, need to
+			 * look the current entity
+			 */
+			rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
+		} else {
+			rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
+		}
+
 		if (!rc) {
 			/*
 			 * If file exists with under flags, return access
@@ -2698,7 +2704,8 @@ int smb2_open(struct ksmbd_work *work)
 				rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
 			}
 		} else {
-			rc = ksmbd_vfs_kern_path(name, 0, &path, 1);
+			rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS,
+						 &path, 1);
 			if (!rc && d_is_symlink(path.dentry)) {
 				rc = -EACCES;
 				path_put(&path);
@@ -4788,7 +4795,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	struct path path;
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
-	int lookup_flags = 0;
+	int lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
 		lookup_flags = LOOKUP_FOLLOW;
@@ -5300,7 +5307,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	char *pathname = NULL;
 	struct path path;
 	bool file_present = true;
-	int rc;
+	int rc, lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	ksmbd_debug(SMB, "setting FILE_RENAME_INFO\n");
 	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -5369,8 +5376,11 @@ static int smb2_rename(struct ksmbd_work *work,
 		goto out;
 	}
 
+	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
+		lookup_flags = LOOKUP_FOLLOW;
+
 	ksmbd_debug(SMB, "new name %s\n", new_name);
-	rc = ksmbd_vfs_kern_path(new_name, 0, &path, 1);
+	rc = ksmbd_vfs_kern_path(new_name, lookup_flags, &path, 1);
 	if (rc)
 		file_present = false;
 	else
@@ -5420,7 +5430,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path;
 	bool file_present = true;
-	int rc;
+	int rc, lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	if (buf_len < sizeof(struct smb2_file_link_info) +
 			le32_to_cpu(file_info->FileNameLength))
@@ -5447,8 +5457,11 @@ static int smb2_create_link(struct ksmbd_work *work,
 		goto out;
 	}
 
+	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
+		lookup_flags = LOOKUP_FOLLOW;
+
 	ksmbd_debug(SMB, "target name is %s\n", target_name);
-	rc = ksmbd_vfs_kern_path(link_name, 0, &path, 0);
+	rc = ksmbd_vfs_kern_path(link_name, lookup_flags, &path, 0);
 	if (rc)
 		file_present = false;
 	else
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index b047f2980d96..53047f013371 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -164,9 +164,13 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 {
 	struct path path;
 	struct dentry *dentry;
-	int err;
+	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
+
+	if (test_share_config_flag(work->tcon->share_conf,
+				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
+		lookup_flags = LOOKUP_FOLLOW;
 
-	dentry = kern_path_create(AT_FDCWD, name, &path, 0);
+	dentry = kern_path_create(AT_FDCWD, name, &path, lookup_flags);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		if (err != -ENOENT)
@@ -201,9 +205,14 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 	struct user_namespace *user_ns;
 	struct path path;
 	struct dentry *dentry;
-	int err;
+	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
 
-	dentry = kern_path_create(AT_FDCWD, name, &path, LOOKUP_DIRECTORY);
+	if (test_share_config_flag(work->tcon->share_conf,
+				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
+		lookup_flags = LOOKUP_FOLLOW;
+
+	dentry = kern_path_create(AT_FDCWD, name, &path,
+				  lookup_flags | LOOKUP_DIRECTORY);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		if (err != -EEXIST)
@@ -588,7 +597,7 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
 	struct path path;
 	struct dentry *parent;
 	int err;
-	int flags = 0;
+	int flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
 		return -ENOMEM;
@@ -652,7 +661,7 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 	struct path oldpath, newpath;
 	struct dentry *dentry;
 	int err;
-	int flags = 0;
+	int flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
 		return -ENOMEM;
@@ -788,7 +797,7 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	struct dentry *src_dent, *trap_dent, *src_child;
 	char *dst_name;
 	int err;
-	int flags;
+	int flags = LOOKUP_NO_SYMLINKS;
 
 	dst_name = extract_last_component(newname);
 	if (!dst_name)
@@ -800,7 +809,8 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	flags = LOOKUP_DIRECTORY;
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
-		flags |= LOOKUP_FOLLOW;
+		flags = LOOKUP_FOLLOW;
+	flags |= LOOKUP_DIRECTORY;
 
 	err = kern_path(newname, flags, &dst_path);
 	if (err) {
@@ -861,7 +871,13 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work, const char *name,
 	int err = 0;
 
 	if (name) {
-		err = kern_path(name, 0, &path);
+		int flags = LOOKUP_NO_SYMLINKS;
+
+		if (test_share_config_flag(work->tcon->share_conf,
+					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
+			flags = LOOKUP_FOLLOW;
+
+		err = kern_path(name, flags, &path);
 		if (err) {
 			pr_err("cannot get linux path for %s, err %d\n",
 			       name, err);
-- 
2.25.1

