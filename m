Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC36C3DA40
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352757AbjHQPfp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353246AbjHQPfh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:37 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B457430C6
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:35 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+qC7fw5PBrM2g10SnT+3E6TH4omTAkAHDXNRo187g8=;
        b=SLRoYipqRGV0JrcJQmBip9h6A6bdy/bX4YpiUIDStyFdwzwAqT+8pkN9o9hRMCK/Ji7nA3
        qJ3uDgtbBvnjgKWmYGO5/jkEUH/FDjg6DjtSUj73+KdLNF0RXyOiUpsq/e+fOwu0xbwnxr
        6Yh3Ss/VFssIntlP84+blNnLzdiZ42QN8KSlpGbH608fahceOySo95RAJi2/66nl+jcAzp
        XtA6HqqQLti3wM2E1H0/U8hZDmnsCFZImKS4oBdcyA+oISsvS4Gf3FidXFicffot+MB76T
        P5DpmEQQsd1Lly/Hvl61CFBgt+Ffpn+y4lJ37qoFHoZHymewhZImLiXczFwBIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+qC7fw5PBrM2g10SnT+3E6TH4omTAkAHDXNRo187g8=;
        b=WNI074jkOFzfuGRMsXaPygsMfXgGprIWSYOcO71WQIweKmRPK0rZ80CrEkszgs0V+LZNFJ
        DSXg8E82tcvJ59FrOAit9FXva6D5qVwRP3hdJelEnmWjdGDuBiCgemFsOoftBfPrJqLjUc
        +x52AIWQvlN8sX/FHRzonBxlISox/+BiB0baK6XFCYdkWttKqCnUDV1YPNtrG/yaaZSzzQ
        a96jrfDWbJeue7oa83C/QWLxrVJ72GSaUnKPwcOpLLJpMmJMKCy0RwkPaO6jJ4HACsFG7D
        YtNnR1hCuzDWMpVizotCHNS1jUQrJup7DPOYFr5BsBDnOCpmb7UgQDDC1LrmSg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286534; a=rsa-sha256;
        cv=none;
        b=Dv5O6ZdWISIbfzXre71VcISd6TwQFG70aJlpmCKbHSkPwMqXHz0jWK8mXam6mvtvcvxoYG
        HGrk3YYfbXhqgsrS0lPtdDOmIs46GnFaeQ6h3nivGEhV1ZM8uaVg7xCvIrTyP6Map8Gzfq
        bjpjYdhNhHex75EjobjWfczqlu1ty3R2k/K15W1rto2+FoIy3DBnbmT5loq33CqXJVRAWg
        vl8EzYek9yt7UiFuBDBWiSjxHrGnJaNeFr+84nCNNQq8mK8dbiq7o9Zr2THVDdeJhiqKGo
        1zjW5/cD2ZcVgOzWHWM/SlbhXjKuUH/hGpYqA2+HPP+Rf3iKLxCorObJFgzq2Q==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 06/17] smb: client: get rid of dfs naming in automount code
Date:   Thu, 17 Aug 2023 12:34:04 -0300
Message-ID: <20230817153416.28083-7-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Automount code will handle both DFS links and reparse mount points.

Also, get rid of BUG_ON() in cifs_release_automount_timer() while
we're at it.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsfs.c    |  2 +-
 fs/smb/client/cifsfs.h    |  6 +++---
 fs/smb/client/cifsproto.h |  4 ++--
 fs/smb/client/dir.c       |  4 ++--
 fs/smb/client/inode.c     |  2 +-
 fs/smb/client/namespace.c | 42 +++++++++++++++++++--------------------
 6 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a4d8b0ea1c8c..d49fd2bf71b0 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1805,7 +1805,7 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
-	cifs_dfs_release_automount_timer();
+	cifs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
 	cifs_genl_exit();
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 15c8cc4b6680..99075970716e 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -81,7 +81,7 @@ extern int cifs_fiemap(struct inode *, struct fiemap_extent_info *, u64 start,
 
 extern const struct inode_operations cifs_file_inode_ops;
 extern const struct inode_operations cifs_symlink_inode_ops;
-extern const struct inode_operations cifs_dfs_referral_inode_operations;
+extern const struct inode_operations cifs_namespace_inode_operations;
 
 
 /* Functions related to files and directories */
@@ -119,9 +119,9 @@ extern const struct dentry_operations cifs_dentry_ops;
 extern const struct dentry_operations cifs_ci_dentry_ops;
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-extern struct vfsmount *cifs_dfs_d_automount(struct path *path);
+extern struct vfsmount *cifs_d_automount(struct path *path);
 #else
-static inline struct vfsmount *cifs_dfs_d_automount(struct path *path)
+static inline struct vfsmount *cifs_d_automount(struct path *path)
 {
 	return ERR_PTR(-EREMOTE);
 }
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1d71d658e167..c7a7484efbd2 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -296,9 +296,9 @@ extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
 extern void cifs_put_tcon(struct cifs_tcon *tcon);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
-extern void cifs_dfs_release_automount_timer(void);
+extern void cifs_release_automount_timer(void);
 #else /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
-#define cifs_dfs_release_automount_timer()	do { } while (0)
+#define cifs_release_automount_timer()	do { } while (0)
 #endif /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
 
 void cifs_proc_init(void);
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 30b1e1bfd204..580a27a3a7e6 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -797,7 +797,7 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 
 const struct dentry_operations cifs_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
-	.d_automount = cifs_dfs_d_automount,
+	.d_automount = cifs_d_automount,
 /* d_delete:       cifs_d_delete,      */ /* not needed except for debugging */
 };
 
@@ -872,5 +872,5 @@ const struct dentry_operations cifs_ci_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
 	.d_hash = cifs_ci_hash,
 	.d_compare = cifs_ci_compare,
-	.d_automount = cifs_dfs_d_automount,
+	.d_automount = cifs_d_automount,
 };
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0d11e63042e2..0d4a78561acc 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -60,7 +60,7 @@ static void cifs_set_ops(struct inode *inode)
 	case S_IFDIR:
 #ifdef CONFIG_CIFS_DFS_UPCALL
 		if (IS_AUTOMOUNT(inode)) {
-			inode->i_op = &cifs_dfs_referral_inode_operations;
+			inode->i_op = &cifs_namespace_inode_operations;
 		} else {
 #else /* NO DFS support, treat as a directory */
 		{
diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index b1c2499b1c3b..af64f2add873 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *   Contains the CIFS DFS referral mounting routines used for handling
- *   traversal via DFS junction point
+ *   Contains mounting routines used for handling traversal via SMB junctions.
  *
  *   Copyright (c) 2007 Igor Mammedov
  *   Copyright (C) International Business Machines  Corp., 2008
@@ -24,27 +23,28 @@
 #include "dfs.h"
 #include "fs_context.h"
 
-static LIST_HEAD(cifs_dfs_automount_list);
+static LIST_HEAD(cifs_automount_list);
 
-static void cifs_dfs_expire_automounts(struct work_struct *work);
-static DECLARE_DELAYED_WORK(cifs_dfs_automount_task,
-			    cifs_dfs_expire_automounts);
-static int cifs_dfs_mountpoint_expiry_timeout = 500 * HZ;
+static void cifs_expire_automounts(struct work_struct *work);
+static DECLARE_DELAYED_WORK(cifs_automount_task,
+			    cifs_expire_automounts);
+static int cifs_mountpoint_expiry_timeout = 500 * HZ;
 
-static void cifs_dfs_expire_automounts(struct work_struct *work)
+static void cifs_expire_automounts(struct work_struct *work)
 {
-	struct list_head *list = &cifs_dfs_automount_list;
+	struct list_head *list = &cifs_automount_list;
 
 	mark_mounts_for_expiry(list);
 	if (!list_empty(list))
-		schedule_delayed_work(&cifs_dfs_automount_task,
-				      cifs_dfs_mountpoint_expiry_timeout);
+		schedule_delayed_work(&cifs_automount_task,
+				      cifs_mountpoint_expiry_timeout);
 }
 
-void cifs_dfs_release_automount_timer(void)
+void cifs_release_automount_timer(void)
 {
-	BUG_ON(!list_empty(&cifs_dfs_automount_list));
-	cancel_delayed_work_sync(&cifs_dfs_automount_task);
+	if (WARN_ON(!list_empty(&cifs_automount_list)))
+		return;
+	cancel_delayed_work_sync(&cifs_automount_task);
 }
 
 /**
@@ -132,7 +132,7 @@ static int set_dest_addr(struct smb3_fs_context *ctx)
 /*
  * Create a vfsmount that we can automount
  */
-static struct vfsmount *cifs_dfs_do_automount(struct path *path)
+static struct vfsmount *cifs_do_automount(struct path *path)
 {
 	int rc;
 	struct dentry *mntpt = path->dentry;
@@ -214,25 +214,25 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 /*
  * Attempt to automount the referral
  */
-struct vfsmount *cifs_dfs_d_automount(struct path *path)
+struct vfsmount *cifs_d_automount(struct path *path)
 {
 	struct vfsmount *newmnt;
 
 	cifs_dbg(FYI, "%s: %pd\n", __func__, path->dentry);
 
-	newmnt = cifs_dfs_do_automount(path);
+	newmnt = cifs_do_automount(path);
 	if (IS_ERR(newmnt)) {
 		cifs_dbg(FYI, "leaving %s [automount failed]\n" , __func__);
 		return newmnt;
 	}
 
 	mntget(newmnt); /* prevent immediate expiration */
-	mnt_set_expiry(newmnt, &cifs_dfs_automount_list);
-	schedule_delayed_work(&cifs_dfs_automount_task,
-			      cifs_dfs_mountpoint_expiry_timeout);
+	mnt_set_expiry(newmnt, &cifs_automount_list);
+	schedule_delayed_work(&cifs_automount_task,
+			      cifs_mountpoint_expiry_timeout);
 	cifs_dbg(FYI, "leaving %s [ok]\n" , __func__);
 	return newmnt;
 }
 
-const struct inode_operations cifs_dfs_referral_inode_operations = {
+const struct inode_operations cifs_namespace_inode_operations = {
 };
-- 
2.41.0

