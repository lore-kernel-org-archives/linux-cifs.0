Return-Path: <SRS0=5TF8=26=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D74EC282DD
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 13:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CC92067D
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 13:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="Jo40nLd1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgAINDi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jan 2020 08:03:38 -0500
Received: from mx.cjr.nz ([51.158.111.142]:40438 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgAINDi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Jan 2020 08:03:38 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C6C2E808C0;
        Thu,  9 Jan 2020 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1578575014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RDWUDbhZjEXPeVkx4NLxXTDbMRW528lKXoMRtBdPt8o=;
        b=Jo40nLd1LnyTpeOXdSBgTprWe5gsMlR4kvL6saPVKYgoXbuH0dH01cTgUtU4RoxoLn8yOp
        t48ow+Um+lPBH82B3pYLZRL8zZE6fU4tqeXU9Tna1bwEGtC07syIpIFb48iPBZ7N/NWW6D
        U2yD9Ny8Vcwtv7NqvdO0if+OhunyED4PDkZ9e9JYTSGRquZpareNiMtwGB6CoEBFuvc/OH
        mZjWgVP2Edr90eNJmU3TrolmXUGZd6xGaDSO+c13UCZZ05zDGvf+8bXRIxSRdlmzbkJPD2
        HNnObv20B96xfMG5ARrGkpTBcD8QcQe/OqX8wrRfK3kQefCDwrGDDiR3KYMioA==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Subject: [PATCH] cifs: Fix mount options set in automount
Date:   Thu,  9 Jan 2020 10:03:19 -0300
Message-Id: <20200109130319.20660-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Starting from 4a367dc04435, we must set the mount options based on the
DFS full path rather than the resolved target, that is, cifs_mount()
will be responsible for resolving the DFS link (cached) as well as
performing failover to any other targets in the referral.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reported-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Fixes: 4a367dc04435 ("cifs: Add support for failover in cifs_mount()")
Link: https://lore.kernel.org/linux-cifs/39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com
Tested-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
---
 fs/cifs/cifs_dfs_ref.c | 97 +++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 54 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 41957b82d796..606f26d862dc 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -120,17 +120,17 @@ cifs_build_devname(char *nodename, const char *prepath)
 
 
 /**
- * cifs_compose_mount_options	-	creates mount options for refferral
+ * cifs_compose_mount_options	-	creates mount options for referral
  * @sb_mountdata:	parent/root DFS mount options (template)
  * @fullpath:		full path in UNC format
- * @ref:		server's referral
+ * @ref:		optional server's referral
  * @devname:		optional pointer for saving device name
  *
  * creates mount options for submount based on template options sb_mountdata
  * and replacing unc,ip,prefixpath options with ones we've got form ref_unc.
  *
  * Returns: pointer to new mount options or ERR_PTR.
- * Caller is responcible for freeing retunrned value if it is not error.
+ * Caller is responsible for freeing returned value if it is not error.
  */
 char *cifs_compose_mount_options(const char *sb_mountdata,
 				   const char *fullpath,
@@ -150,18 +150,27 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	if (sb_mountdata == NULL)
 		return ERR_PTR(-EINVAL);
 
-	if (strlen(fullpath) - ref->path_consumed) {
-		prepath = fullpath + ref->path_consumed;
-		/* skip initial delimiter */
-		if (*prepath == '/' || *prepath == '\\')
-			prepath++;
-	}
+	if (ref) {
+		if (strlen(fullpath) - ref->path_consumed) {
+			prepath = fullpath + ref->path_consumed;
+			/* skip initial delimiter */
+			if (*prepath == '/' || *prepath == '\\')
+				prepath++;
+		}
 
-	name = cifs_build_devname(ref->node_name, prepath);
-	if (IS_ERR(name)) {
-		rc = PTR_ERR(name);
-		name = NULL;
-		goto compose_mount_options_err;
+		name = cifs_build_devname(ref->node_name, prepath);
+		if (IS_ERR(name)) {
+			rc = PTR_ERR(name);
+			name = NULL;
+			goto compose_mount_options_err;
+		}
+	} else {
+		name = cifs_build_devname((char *)fullpath, NULL);
+		if (IS_ERR(name)) {
+			rc = PTR_ERR(name);
+			name = NULL;
+			goto compose_mount_options_err;
+		}
 	}
 
 	rc = dns_resolve_server_name_to_ip(name, &srvIP);
@@ -225,6 +234,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 
 	if (devname)
 		*devname = name;
+	else
+		kfree(name);
 
 	/*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
 	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
@@ -241,23 +252,23 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 }
 
 /**
- * cifs_dfs_do_refmount - mounts specified path using provided refferal
+ * cifs_dfs_do_mount - mounts specified path using DFS full path
+ *
+ * Always pass down @fullpath to smb3_do_mount() so we can use the root server
+ * to perform failover in case we failed to connect to the first target in the
+ * referral.
+ *
  * @cifs_sb:		parent/root superblock
  * @fullpath:		full path in UNC format
- * @ref:		server's referral
  */
-static struct vfsmount *cifs_dfs_do_refmount(struct dentry *mntpt,
-		struct cifs_sb_info *cifs_sb,
-		const char *fullpath, const struct dfs_info3_param *ref)
+static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
+					  struct cifs_sb_info *cifs_sb,
+					  const char *fullpath)
 {
 	struct vfsmount *mnt;
 	char *mountdata;
 	char *devname;
 
-	/*
-	 * Always pass down the DFS full path to smb3_do_mount() so we
-	 * can use it later for failover.
-	 */
 	devname = kstrndup(fullpath, strlen(fullpath), GFP_KERNEL);
 	if (!devname)
 		return ERR_PTR(-ENOMEM);
@@ -266,7 +277,7 @@ static struct vfsmount *cifs_dfs_do_refmount(struct dentry *mntpt,
 
 	/* strip first '\' from fullpath */
 	mountdata = cifs_compose_mount_options(cifs_sb->mountdata,
-					       fullpath + 1, ref, NULL);
+					       fullpath + 1, NULL, NULL);
 	if (IS_ERR(mountdata)) {
 		kfree(devname);
 		return (struct vfsmount *)mountdata;
@@ -278,28 +289,16 @@ static struct vfsmount *cifs_dfs_do_refmount(struct dentry *mntpt,
 	return mnt;
 }
 
-static void dump_referral(const struct dfs_info3_param *ref)
-{
-	cifs_dbg(FYI, "DFS: ref path: %s\n", ref->path_name);
-	cifs_dbg(FYI, "DFS: node path: %s\n", ref->node_name);
-	cifs_dbg(FYI, "DFS: fl: %d, srv_type: %d\n",
-		 ref->flags, ref->server_type);
-	cifs_dbg(FYI, "DFS: ref_flags: %d, path_consumed: %d\n",
-		 ref->ref_flag, ref->path_consumed);
-}
-
 /*
  * Create a vfsmount that we can automount
  */
 static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 {
-	struct dfs_info3_param referral = {0};
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	char *full_path, *root_path;
 	unsigned int xid;
-	int len;
 	int rc;
 	struct vfsmount *mnt;
 
@@ -357,7 +356,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	if (!rc) {
 		rc = dfs_cache_find(xid, ses, cifs_sb->local_nls,
 				    cifs_remap(cifs_sb), full_path + 1,
-				    &referral, NULL);
+				    NULL, NULL);
 	}
 
 	free_xid(xid);
@@ -366,26 +365,16 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 		mnt = ERR_PTR(rc);
 		goto free_root_path;
 	}
-
-	dump_referral(&referral);
-
-	len = strlen(referral.node_name);
-	if (len < 2) {
-		cifs_dbg(VFS, "%s: Net Address path too short: %s\n",
-			 __func__, referral.node_name);
-		mnt = ERR_PTR(-EINVAL);
-		goto free_dfs_ref;
-	}
 	/*
-	 * cifs_mount() will retry every available node server in case
-	 * of failures.
+	 * OK - we were able to get and cache a referral for @full_path.
+	 *
+	 * Now, pass it down to cifs_mount() and it will retry every available
+	 * node server in case of failures - no need to do it here.
 	 */
-	mnt = cifs_dfs_do_refmount(mntpt, cifs_sb, full_path, &referral);
-	cifs_dbg(FYI, "%s: cifs_dfs_do_refmount:%s , mnt:%p\n", __func__,
-		 referral.node_name, mnt);
+	mnt = cifs_dfs_do_mount(mntpt, cifs_sb, full_path);
+	cifs_dbg(FYI, "%s: cifs_dfs_do_mount:%s , mnt:%p\n", __func__,
+		 full_path + 1, mnt);
 
-free_dfs_ref:
-	free_dfs_info_param(&referral);
 free_root_path:
 	kfree(root_path);
 free_full_path:
-- 
2.24.1

