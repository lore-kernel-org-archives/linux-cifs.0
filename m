Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F14AC3065D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352676AbjHQPfo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353248AbjHQPfi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:38 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCC130C5
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:37 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tsioSQiZ417b8RqCL1VpmHMw8YPV2IvsZHhxTbozTFg=;
        b=JR1Bvzn0PB3VoEAGXFaF7DS+aRxAcaV7FuwWxENixqNgRD5F7mnAkhn5YTxtgJfm4bOTid
        uggFk9vo+g8cEW22A9Sl2hEJDfnfRBkCKl78CTxFJSsBw21N9t2SEzg/PGaRhej1wSFCeX
        4L+Amy0Ww9e0pOcok8PDE+SxyKbBr7DS3fYR8azMpn3GLBf6k2LS+2coO4aO7tMDNP3mdR
        P2ieVe5lgLiePf7wfEq/YoL4KdJDyNRHZVHJAmvOJBFnDzha+3HcftUIWccqUOiz16g92C
        IMazTeOEMp7tzYZdMw+mKl1iMMUvCdvr1tFr7Rg2BOu6RApq9BMJj4eCaYmUsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tsioSQiZ417b8RqCL1VpmHMw8YPV2IvsZHhxTbozTFg=;
        b=pEESAX/8xhGEnSRn1mTxfGLQ7MjOLeAPyAwf9YKjPgGct98sztegR62r8zFpX8H6PX/VB9
        HfQkH/GlnOCXxubE3+QlUDx4zvB7rB9XSV/jM1Ak+18zKhF+z74pcGjg6KeyEo9lSslqFS
        yCd3ehgmYxQjciocfTi/O10z8XB8vjw3TLDS58YqlHwK0j7OFC97yY5WJKM1KK/6ZYaqZ2
        nxYCvDOChVPWUmpckFwIce63kOJMH++N6AVQOJcsuPeR4UZhOY+2vEF1i8glnO/B9VN0vT
        KeGFLCpm+wiPGBwkwMr9U0vPEJ8sRBhwe4rp5lRtWwG26WSGYnXxLYiFiarrSQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286536; a=rsa-sha256;
        cv=none;
        b=rIH1EkQTYUVmWv3ARJcNE7sbcJ/FfmNeVqBWcmkNwskVDimTu0eEYzT2bW4SmXdlqmOSyO
        LgqMT3O7/tRiFknmgWzcgr0gYOyOLBruuFc6YvF6jNff8S1ymuSND47oRrk2yBnxvj6lu0
        Drud4Jzmdq7OLse6s2fV1zQV3QyHUDX8/l6kWhNNTxtAW2lt79QV3Lhv5LPWi3RzEWgiC+
        bIgBNEVgEbM4VS+KUq8yqvn6ELosVufe9byMhGMKG4ZIPINzPreSAzg8Kf0x81swSYlPsk
        5XAB+lGZczPNQtstflTUBKByZN0Ar3AflIMF91obz7rES/NAxe4k/b1vuCN/sw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 07/17] smb: client: get rid of dfs code dep in namespace.c
Date:   Thu, 17 Aug 2023 12:34:05 -0300
Message-ID: <20230817153416.28083-8-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make namespace.c being built without requiring
CONFIG_CIFS_DFS_UPCALL=y by moving set_dest_addr() to dfs.c and call
it at the beginning of dfs_mount_share() so it can chase the DFS link
starting from the correct server in @ctx->dstaddr.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/Makefile    |  5 ++--
 fs/smb/client/cifsfs.h    |  7 -----
 fs/smb/client/cifsproto.h |  4 ---
 fs/smb/client/dfs.c       | 16 +++++++++++
 fs/smb/client/dfs.h       | 37 --------------------------
 fs/smb/client/inode.c     |  4 ---
 fs/smb/client/namespace.c | 56 ++++++++++++++++++++++++++-------------
 7 files changed, 57 insertions(+), 72 deletions(-)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 851e6ba65e9b..0b07eb94c93b 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -11,7 +11,8 @@ cifs-y := trace.o cifsfs.o cifs_debug.o connect.o dir.o file.o \
 	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
-	  dns_resolve.o cifs_spnego_negtokeninit.asn1.o asn1.o
+	  dns_resolve.o cifs_spnego_negtokeninit.asn1.o asn1.o \
+	  namespace.o
 
 $(obj)/asn1.o: $(obj)/cifs_spnego_negtokeninit.asn1.h
 
@@ -21,7 +22,7 @@ cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
-cifs-$(CONFIG_CIFS_DFS_UPCALL) += namespace.o dfs_cache.o dfs.o
+cifs-$(CONFIG_CIFS_DFS_UPCALL) += dfs_cache.o dfs.o
 
 cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o cifs_swn.o
 
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 99075970716e..532c38fe07cd 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -118,14 +118,7 @@ extern void cifs_pages_write_redirty(struct inode *inode, loff_t start, unsigned
 extern const struct dentry_operations cifs_dentry_ops;
 extern const struct dentry_operations cifs_ci_dentry_ops;
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
 extern struct vfsmount *cifs_d_automount(struct path *path);
-#else
-static inline struct vfsmount *cifs_d_automount(struct path *path)
-{
-	return ERR_PTR(-EREMOTE);
-}
-#endif
 
 /* Functions related to symlinks */
 extern const char *cifs_get_link(struct dentry *, struct inode *,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c7a7484efbd2..694d16acdf61 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -295,11 +295,7 @@ extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
 				 int from_reconnect);
 extern void cifs_put_tcon(struct cifs_tcon *tcon);
 
-#if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_release_automount_timer(void);
-#else /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
-#define cifs_release_automount_timer()	do { } while (0)
-#endif /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
 
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 71ee74041884..81b84151450d 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -263,12 +263,28 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	return rc;
 }
 
+/* Resolve UNC hostname in @ctx->source and set ip addr in @ctx->dstaddr */
+static int update_fs_context_dstaddr(struct smb3_fs_context *ctx)
+{
+	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
+	int rc;
+
+	rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
+	if (!rc)
+		cifs_set_port(addr, ctx->port);
+	return rc;
+}
+
 int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	bool nodfs = ctx->nodfs;
 	int rc;
 
+	rc = update_fs_context_dstaddr(ctx);
+	if (rc)
+		return rc;
+
 	*isdfs = false;
 	rc = get_session(mnt_ctx, NULL);
 	if (rc)
diff --git a/fs/smb/client/dfs.h b/fs/smb/client/dfs.h
index c0a9eea6a2c5..875ab7ae57fc 100644
--- a/fs/smb/client/dfs.h
+++ b/fs/smb/client/dfs.h
@@ -138,43 +138,6 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
 			      cifs_remap(cifs_sb), path, ref, tl);
 }
 
-/* Return DFS full path out of a dentry set for automount */
-static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
-{
-	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	size_t len;
-	char *s;
-
-	spin_lock(&tcon->tc_lock);
-	if (unlikely(!tcon->origin_fullpath)) {
-		spin_unlock(&tcon->tc_lock);
-		return ERR_PTR(-EREMOTE);
-	}
-	spin_unlock(&tcon->tc_lock);
-
-	s = dentry_path_raw(dentry, page, PATH_MAX);
-	if (IS_ERR(s))
-		return s;
-	/* for root, we want "" */
-	if (!s[1])
-		s++;
-
-	spin_lock(&tcon->tc_lock);
-	len = strlen(tcon->origin_fullpath);
-	if (s < (char *)page + len) {
-		spin_unlock(&tcon->tc_lock);
-		return ERR_PTR(-ENAMETOOLONG);
-	}
-
-	s -= len;
-	memcpy(s, tcon->origin_fullpath, len);
-	spin_unlock(&tcon->tc_lock);
-	convert_delimiter(s, '/');
-
-	return s;
-}
-
 static inline void dfs_put_root_smb_sessions(struct list_head *head)
 {
 	struct dfs_root_ses *root, *tmp;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0d4a78561acc..da2ec48dc0f6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -58,13 +58,9 @@ static void cifs_set_ops(struct inode *inode)
 			inode->i_data.a_ops = &cifs_addr_ops;
 		break;
 	case S_IFDIR:
-#ifdef CONFIG_CIFS_DFS_UPCALL
 		if (IS_AUTOMOUNT(inode)) {
 			inode->i_op = &cifs_namespace_inode_operations;
 		} else {
-#else /* NO DFS support, treat as a directory */
-		{
-#endif
 			inode->i_op = &cifs_dir_inode_ops;
 			inode->i_fop = &cifs_dir_ops;
 		}
diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index af64f2add873..3252fe33f7a3 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -6,6 +6,7 @@
  *   Copyright (C) International Business Machines  Corp., 2008
  *   Author(s): Igor Mammedov (niallain@gmail.com)
  *		Steve French (sfrench@us.ibm.com)
+ *   Copyright (c) 2023 Paulo Alcantara <palcantara@suse.de>
  */
 
 #include <linux/dcache.h>
@@ -18,9 +19,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
-#include "dns_resolve.h"
 #include "cifs_debug.h"
-#include "dfs.h"
 #include "fs_context.h"
 
 static LIST_HEAD(cifs_automount_list);
@@ -118,15 +117,41 @@ cifs_build_devname(char *nodename, const char *prepath)
 	return dev;
 }
 
-static int set_dest_addr(struct smb3_fs_context *ctx)
+/* Return full path out of a dentry set for automount */
+static char *automount_fullpath(struct dentry *dentry, void *page)
 {
-	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
-	int rc;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	size_t len;
+	char *s;
 
-	rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
-	if (!rc)
-		cifs_set_port(addr, ctx->port);
-	return rc;
+	spin_lock(&tcon->tc_lock);
+	if (unlikely(!tcon->origin_fullpath)) {
+		spin_unlock(&tcon->tc_lock);
+		return ERR_PTR(-EREMOTE);
+	}
+	spin_unlock(&tcon->tc_lock);
+
+	s = dentry_path_raw(dentry, page, PATH_MAX);
+	if (IS_ERR(s))
+		return s;
+	/* for root, we want "" */
+	if (!s[1])
+		s++;
+
+	spin_lock(&tcon->tc_lock);
+	len = strlen(tcon->origin_fullpath);
+	if (s < (char *)page + len) {
+		spin_unlock(&tcon->tc_lock);
+		return ERR_PTR(-ENAMETOOLONG);
+	}
+
+	s -= len;
+	memcpy(s, tcon->origin_fullpath, len);
+	spin_unlock(&tcon->tc_lock);
+	convert_delimiter(s, '/');
+
+	return s;
 }
 
 /*
@@ -166,7 +191,7 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 	ctx = smb3_fc2context(fc);
 
 	page = alloc_dentry_path();
-	full_path = dfs_get_automount_devname(mntpt, page);
+	full_path = automount_fullpath(mntpt, page);
 	if (IS_ERR(full_path)) {
 		mnt = ERR_CAST(full_path);
 		goto out;
@@ -196,15 +221,10 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 		ctx->source = NULL;
 		goto out;
 	}
-	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s dstaddr=%pISpc\n",
-		 __func__, ctx->source, ctx->UNC, ctx->prepath, &ctx->dstaddr);
-
-	rc = set_dest_addr(ctx);
-	if (!rc)
-		mnt = fc_mount(fc);
-	else
-		mnt = ERR_PTR(rc);
+	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s\n",
+		 __func__, ctx->source, ctx->UNC, ctx->prepath);
 
+	mnt = fc_mount(fc);
 out:
 	put_fs_context(fc);
 	free_dentry_path(page);
-- 
2.41.0

