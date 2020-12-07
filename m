Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CC6C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910DA23A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgLGXi4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:38:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgLGXi4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:38:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FrHrXIH/KXGp/YDgXxcYhmIq/OazSysRl0iK9anLJE8=;
        b=iFSWnowlIRmMsNmv4WxPEr7LUfB5FDbNcv+65gpFb6hn4emHk/hywzItfyTEAo/8eAtfPv
        SwIdgb7jje0cJsk+m8UZNu+Gtld1Hh/zrLWf1SJVEJ98oluKj1T5uoEfJ08Gu8zmbTM+H8
        jt5JnePlo/PJK2DEMT1x8LldZ3+Ahu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-PwJzWvhpMeioL8LcpG80hQ-1; Mon, 07 Dec 2020 18:37:27 -0500
X-MC-Unique: PwJzWvhpMeioL8LcpG80hQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4556D51D4;
        Mon,  7 Dec 2020 23:37:26 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2812136FA;
        Mon,  7 Dec 2020 23:37:24 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 08/21] cifs: get rid of cifs_sb->mountdata
Date:   Tue,  8 Dec 2020 09:36:33 +1000
Message-Id: <20201207233646.29823-8-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

as we now have a full smb3_fs_context as part of the cifs superblock
we no longer need a local copy of the mount options and can just
reference the copy in the smb3_fs_context.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_dfs_ref.c |  3 ++-
 fs/cifs/cifs_fs_sb.h   |  1 -
 fs/cifs/cifsfs.c       |  7 -------
 fs/cifs/connect.c      | 19 ++++++++++---------
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 81f6066d5865..6f7187b90fda 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -23,6 +23,7 @@
 #include "cifs_debug.h"
 #include "cifs_unicode.h"
 #include "dfs_cache.h"
+#include "fs_context.h"
 
 static LIST_HEAD(cifs_dfs_automount_list);
 
@@ -275,7 +276,7 @@ static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
 	/* See afs_mntpt_do_automount in fs/afs/mntpt.c for an example */
 
 	/* strip first '\' from fullpath */
-	mountdata = cifs_compose_mount_options(cifs_sb->mountdata,
+	mountdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
 					       fullpath + 1, NULL);
 	if (IS_ERR(mountdata)) {
 		kfree(devname);
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 34d0229c0519..8ee37c80880a 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -74,7 +74,6 @@ struct cifs_sb_info {
 	umode_t	mnt_file_mode;
 	umode_t	mnt_dir_mode;
 	unsigned int mnt_cifs_flags;
-	char   *mountdata; /* options received at mount time or via DFS refs */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7fe6502e1672..4f27f77d3053 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -812,12 +812,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		goto out;
 	}
 
-	cifs_sb->mountdata = kstrndup(cifs_sb->ctx->mount_options, PAGE_SIZE, GFP_KERNEL);
-	if (cifs_sb->mountdata == NULL) {
-		root = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
 	rc = cifs_setup_cifs_sb(cifs_sb->ctx, cifs_sb);
 	if (rc) {
 		root = ERR_PTR(rc);
@@ -872,7 +866,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 out:
 	if (cifs_sb) {
 		kfree(cifs_sb->prepath);
-		kfree(cifs_sb->mountdata);
 		cifs_cleanup_volume_info(cifs_sb->ctx);
 		kfree(cifs_sb);
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20acd741fda2..7fc27fb49789 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2999,7 +2999,7 @@ build_unc_path_to_root(const struct smb3_fs_context *ctx,
  * expand_dfs_referral - Perform a dfs referral query and update the cifs_sb
  *
  *
- * If a referral is found, cifs_sb->mountdata will be (re-)allocated
+ * If a referral is found, cifs_sb->ctx->mount_options will be (re-)allocated
  * to a string containing updated options for the submount.  Otherwise it
  * will be left untouched.
  *
@@ -3025,7 +3025,7 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 	rc = dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			    ref_path, &referral, NULL);
 	if (!rc) {
-		mdata = cifs_compose_mount_options(cifs_sb->mountdata,
+		mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
 						   full_path + 1, &referral);
 		free_dfs_info_param(&referral);
 
@@ -3036,8 +3036,8 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 			cifs_cleanup_volume_info_contents(ctx);
 			rc = cifs_setup_volume_info(ctx);
 		}
-		kfree(cifs_sb->mountdata);
-		cifs_sb->mountdata = mdata;
+		kfree(cifs_sb->ctx->mount_options);
+		cifs_sb->ctx->mount_options = mdata;
 	}
 	kfree(full_path);
 	return rc;
@@ -3096,7 +3096,8 @@ static int setup_dfs_tgt_conn(const char *path, const char *full_path,
 	if (rc)
 		return rc;
 
-	mdata = cifs_compose_mount_options(cifs_sb->mountdata, full_path + 1, &ref);
+	mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
+					   full_path + 1, &ref);
 	free_dfs_info_param(&ref);
 
 	if (IS_ERR(mdata)) {
@@ -3424,7 +3425,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			goto error;
 	}
 	/* Save mount options */
-	mntdata = kstrndup(cifs_sb->mountdata, strlen(cifs_sb->mountdata), GFP_KERNEL);
+	mntdata = kstrndup(cifs_sb->ctx->mount_options,
+			   strlen(cifs_sb->ctx->mount_options), GFP_KERNEL);
 	if (!mntdata) {
 		rc = -ENOMEM;
 		goto error;
@@ -3448,12 +3450,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			break;
 		}
 		/* Chase referral */
-		oldmnt = cifs_sb->mountdata;
+		oldmnt = cifs_sb->ctx->mount_options;
 		rc = expand_dfs_referral(xid, root_ses, ctx, cifs_sb, ref_path + 1);
 		if (rc)
 			break;
 		/* Connect to new DFS target only if we were redirected */
-		if (oldmnt != cifs_sb->mountdata) {
+		if (oldmnt != cifs_sb->ctx->mount_options) {
 			mount_put_conns(cifs_sb, xid, server, ses, tcon);
 			rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 		}
@@ -3759,7 +3761,6 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	kfree(cifs_sb->mountdata);
 	kfree(cifs_sb->prepath);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	dfs_cache_del_vol(cifs_sb->origin_fullpath);
-- 
2.13.6

