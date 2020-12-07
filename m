Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A324EC4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7319423998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgLGXkf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbgLGXkf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=fwQKYghYQ0RwvWZbB4I3CGcAWxKfbR1AGJSty4+jm3w=;
        b=U5BT0RjvSiGGGMcoDUT+ILjaluzPCjDARnW2lQriS9hkALNzVMncTXIJcT33LBySd5OQ+X
        CFpv0856NR0GMH+HfU+7Mp6Y8Gu5LB11GSICXP6vAy6L7yVLolWmNvMM8/WfWJGqBeoWLf
        7mdBu5pbY2ezk57GEGSbEJKBPL77Wkw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-0sZaN_AcPZ-EZwRxHPg94Q-1; Mon, 07 Dec 2020 18:39:06 -0500
X-MC-Unique: 0sZaN_AcPZ-EZwRxHPg94Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC0CF809DD4;
        Mon,  7 Dec 2020 23:39:04 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBE4D19C59;
        Mon,  7 Dec 2020 23:39:03 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 06/21] cifs: remove the devname argument to cifs_compose_mount_options
Date:   Tue,  8 Dec 2020 09:36:31 +1000
Message-Id: <20201207233646.29823-6-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

none of the callers use this argument any more.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_dfs_ref.c | 11 +++--------
 fs/cifs/cifsproto.h    |  3 +--
 fs/cifs/connect.c      | 11 +++--------
 fs/cifs/dfs_cache.c    |  6 ++----
 4 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 4b0b9cfe2ab1..81f6066d5865 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -124,7 +124,6 @@ cifs_build_devname(char *nodename, const char *prepath)
  * @sb_mountdata:	parent/root DFS mount options (template)
  * @fullpath:		full path in UNC format
  * @ref:		optional server's referral
- * @devname:		optional pointer for saving device name
  *
  * creates mount options for submount based on template options sb_mountdata
  * and replacing unc,ip,prefixpath options with ones we've got form ref_unc.
@@ -134,8 +133,7 @@ cifs_build_devname(char *nodename, const char *prepath)
  */
 char *cifs_compose_mount_options(const char *sb_mountdata,
 				   const char *fullpath,
-				   const struct dfs_info3_param *ref,
-				   char **devname)
+				   const struct dfs_info3_param *ref)
 {
 	int rc;
 	char *name;
@@ -232,10 +230,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	strcat(mountdata, "ip=");
 	strcat(mountdata, srvIP);
 
-	if (devname)
-		*devname = name;
-	else
-		kfree(name);
+	kfree(name);
 
 	/*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
 	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
@@ -281,7 +276,7 @@ static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
 
 	/* strip first '\' from fullpath */
 	mountdata = cifs_compose_mount_options(cifs_sb->mountdata,
-					       fullpath + 1, NULL, NULL);
+					       fullpath + 1, NULL);
 	if (IS_ERR(mountdata)) {
 		kfree(devname);
 		return (struct vfsmount *)mountdata;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 49a122978772..19ee76f3a96f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,8 +78,7 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 				     int add_treename);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
-		const char *fullpath, const struct dfs_info3_param *ref,
-		char **devname);
+		const char *fullpath, const struct dfs_info3_param *ref);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 081e61a212cd..dd7c2058ecf6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3019,11 +3019,8 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 	rc = dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			    ref_path, &referral, NULL);
 	if (!rc) {
-		char *fake_devname = NULL;
-
 		mdata = cifs_compose_mount_options(cifs_sb->mountdata,
-						   full_path + 1, &referral,
-						   &fake_devname);
+						   full_path + 1, &referral);
 		free_dfs_info_param(&referral);
 
 		if (IS_ERR(mdata)) {
@@ -3033,7 +3030,6 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 			cifs_cleanup_volume_info_contents(ctx);
 			rc = cifs_setup_volume_info(ctx);
 		}
-		kfree(fake_devname);
 		kfree(cifs_sb->mountdata);
 		cifs_sb->mountdata = mdata;
 	}
@@ -3085,7 +3081,7 @@ static int setup_dfs_tgt_conn(const char *path, const char *full_path,
 {
 	int rc;
 	struct dfs_info3_param ref = {0};
-	char *mdata = NULL, *fake_devname = NULL;
+	char *mdata = NULL;
 	struct smb3_fs_context fake_ctx = {NULL};
 
 	cifs_dbg(FYI, "%s: dfs path: %s\n", __func__, path);
@@ -3094,7 +3090,7 @@ static int setup_dfs_tgt_conn(const char *path, const char *full_path,
 	if (rc)
 		return rc;
 
-	mdata = cifs_compose_mount_options(cifs_sb->mountdata, full_path + 1, &ref, &fake_devname);
+	mdata = cifs_compose_mount_options(cifs_sb->mountdata, full_path + 1, &ref);
 	free_dfs_info_param(&ref);
 
 	if (IS_ERR(mdata)) {
@@ -3104,7 +3100,6 @@ static int setup_dfs_tgt_conn(const char *path, const char *full_path,
 		rc = cifs_setup_volume_info(&fake_ctx);
 	}
 	kfree(mdata);
-	kfree(fake_devname);
 
 	if (!rc) {
 		/*
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index dde859c21f1a..6bccff4596bf 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1416,7 +1416,7 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
 	int rc;
 	struct cache_entry *ce;
 	struct dfs_info3_param ref = {0};
-	char *mdata = NULL, *devname = NULL;
+	char *mdata = NULL;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct smb3_fs_context ctx = {NULL};
@@ -1443,8 +1443,7 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
 
 	up_read(&htable_rw_lock);
 
-	mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref,
-					   &devname);
+	mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref);
 	free_dfs_info_param(&ref);
 
 	if (IS_ERR(mdata)) {
@@ -1454,7 +1453,6 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
 	}
 
 	rc = cifs_setup_volume_info(&ctx);
-	kfree(devname);
 
 	if (rc) {
 		ses = ERR_PTR(rc);
-- 
2.13.6

