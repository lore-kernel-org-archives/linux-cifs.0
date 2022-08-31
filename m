Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C38C0502A
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 15:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiHaPHE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 11:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiHaPHD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 11:07:03 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D3422D6
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 08:06:58 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DFFAF7FCED;
        Wed, 31 Aug 2022 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1661958416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P4K2HE05/BiTA9lwD1tG6Cmtrr10TRv1xUpxw2ZVGOQ=;
        b=w/CIkvVxBnrbOPtvIiXrZeU17aL34Y4abCB/xYRuhxysuDe5YKoqfEecWBQPBQ7tbhn2MS
        JtLF4bQ1J8K/WawFqkrS4nw76Db+BVsPcKqUkUGEQPS1VA3iffJqy4vthOA74/WHY+WMe8
        qUiszctQYbGrRQbGDQ/q5OoIo8CI+hiKKmnjtoF7Hc7KXiXqi00TGIDDelUWodPXOv2f1k
        xgIEbH68cx8Iz6NpbpQ6n0vo7Lxi6jHol/YN5uXnZpyWNyBwUozQfABw0bvItJx3wGkk3j
        m/K4p+0ldrpCUHHl8RhOgVX12Jtz5TbokvFtfmgt5EBr8RbTNUFOyEFIN1DaJQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, ronniesahlberg@gmail.com,
        jlayton@kernel.org, dhowells@redhat.com,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: use fs_context for automounts
Date:   Wed, 31 Aug 2022 12:07:15 -0300
Message-Id: <20220831150715.15627-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use filesystem context support to handle dfs links.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_dfs_ref.c | 102 +++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b0864da9ef43..575ca68e5da8 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -258,61 +258,23 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	goto compose_mount_options_out;
 }
 
-/**
- * cifs_dfs_do_mount - mounts specified path using DFS full path
- *
- * Always pass down @fullpath to smb3_do_mount() so we can use the root server
- * to perform failover in case we failed to connect to the first target in the
- * referral.
- *
- * @mntpt:		directory entry for the path we are trying to automount
- * @cifs_sb:		parent/root superblock
- * @fullpath:		full path in UNC format
- */
-static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
-					  struct cifs_sb_info *cifs_sb,
-					  const char *fullpath)
-{
-	struct vfsmount *mnt;
-	char *mountdata;
-	char *devname;
-
-	devname = kstrdup(fullpath, GFP_KERNEL);
-	if (!devname)
-		return ERR_PTR(-ENOMEM);
-
-	convert_delimiter(devname, '/');
-
-	/* TODO: change to call fs_context_for_mount(), fill in context directly, call fc_mount */
-
-	/* See afs_mntpt_do_automount in fs/afs/mntpt.c for an example */
-
-	/* strip first '\' from fullpath */
-	mountdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-					       fullpath + 1, NULL, NULL);
-	if (IS_ERR(mountdata)) {
-		kfree(devname);
-		return (struct vfsmount *)mountdata;
-	}
-
-	mnt = vfs_submount(mntpt, &cifs_fs_type, devname, mountdata);
-	kfree(mountdata);
-	kfree(devname);
-	return mnt;
-}
-
 /*
  * Create a vfsmount that we can automount
  */
-static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
+static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 {
+	int rc;
+	struct dentry *mntpt = path->dentry;
+	struct fs_context *fc;
 	struct cifs_sb_info *cifs_sb;
-	void *page;
+	void *page = NULL;
+	struct smb3_fs_context *ctx, *cur_ctx;
+	struct smb3_fs_context tmp;
 	char *full_path;
 	struct vfsmount *mnt;
 
-	cifs_dbg(FYI, "in %s\n", __func__);
-	BUG_ON(IS_ROOT(mntpt));
+	if (IS_ROOT(mntpt))
+		return ERR_PTR(-ESTALE);
 
 	/*
 	 * The MSDFS spec states that paths in DFS referral requests and
@@ -321,29 +283,49 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	 * gives us the latter, so we must adjust the result.
 	 */
 	cifs_sb = CIFS_SB(mntpt->d_sb);
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) {
-		mnt = ERR_PTR(-EREMOTE);
-		goto cdda_exit;
-	}
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+		return ERR_PTR(-EREMOTE);
+
+	cur_ctx = cifs_sb->ctx;
+
+	fc = fs_context_for_submount(path->mnt->mnt_sb->s_type, mntpt);
+	if (IS_ERR(fc))
+		return ERR_CAST(fc);
+
+	ctx = fc->fs_private;
 
 	page = alloc_dentry_path();
 	/* always use tree name prefix */
 	full_path = build_path_from_dentry_optional_prefix(mntpt, page, true);
 	if (IS_ERR(full_path)) {
 		mnt = ERR_CAST(full_path);
-		goto free_full_path;
+		goto out;
 	}
 
-	convert_delimiter(full_path, '\\');
+	convert_delimiter(full_path, '/');
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
-	mnt = cifs_dfs_do_mount(mntpt, cifs_sb, full_path);
-	cifs_dbg(FYI, "%s: cifs_dfs_do_mount:%s , mnt:%p\n", __func__, full_path + 1, mnt);
+	tmp = *cur_ctx;
+	tmp.UNC = tmp.prepath = NULL;
 
-free_full_path:
+	rc = smb3_fs_context_dup(ctx, &tmp);
+	if (rc) {
+		mnt = ERR_PTR(rc);
+		goto out;
+	}
+
+	rc = smb3_parse_devname(full_path, ctx);
+	if (!rc)
+		mnt = fc_mount(fc);
+	else
+		mnt = ERR_PTR(rc);
+
+	if (IS_ERR(mnt))
+		smb3_cleanup_fs_context(ctx);
+
+out:
+	put_fs_context(fc);
 	free_dentry_path(page);
-cdda_exit:
-	cifs_dbg(FYI, "leaving %s\n" , __func__);
 	return mnt;
 }
 
@@ -354,9 +336,9 @@ struct vfsmount *cifs_dfs_d_automount(struct path *path)
 {
 	struct vfsmount *newmnt;
 
-	cifs_dbg(FYI, "in %s\n", __func__);
+	cifs_dbg(FYI, "%s: %pd\n", __func__, path->dentry);
 
-	newmnt = cifs_dfs_do_automount(path->dentry);
+	newmnt = cifs_dfs_do_automount(path);
 	if (IS_ERR(newmnt)) {
 		cifs_dbg(FYI, "leaving %s [automount failed]\n" , __func__);
 		return newmnt;
-- 
2.37.2

