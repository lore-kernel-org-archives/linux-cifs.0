Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56582C3065B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352652AbjHQPfm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353242AbjHQPfb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:31 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668332D6D
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:29 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBUEbXV9bz9ZnmO9Vxf4Sz7qaDsxNZRQjhphLLsioVs=;
        b=oKEHUoSPRsZtH8+KQFBNNo/FlUKA3dAvXZ0OZ+U4nDGzDm9ExjLpY2Uan13/yxJhsA6z1c
        Mu7ONjz4RsVDhGWHb0uDNiUP/bb0Qp+Or5CWgRmP5rF9e/TolScFlwBOSfQBoINq+FvomX
        2v1ehzxtcEmP9c8NsSR+kUr+/N94TjI2YVTJTAXRW72Lwmgr5DQDETzCD6z7dy8olYlsrm
        TugH2E+xqyv5pvi7bUm0Hu3xqt6ChDsOQteRTi5Ql6PMphP4Ai3ytEPpxFnCio30o1Xy4X
        gR0SVxk0K3eIrCSEkJra/XAO9Zmvw0RF7GkyH071Gavu+ePOTyb3CWSq4m82Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBUEbXV9bz9ZnmO9Vxf4Sz7qaDsxNZRQjhphLLsioVs=;
        b=S8ptd85FRWAHDqkwU2j3Wu/f1jK+n0iw5MbnFnCSTfOCJgY8Lalurr4KC3cXc7kEzGS2xf
        73zEiV0UTWZaUYv/5g5PC24lSsgAu91jYLoKz1BYTZXbTUYs7cKBw50qvnd2pQN/Ka4ly5
        c2Uvn4YQpXFq18ICzRIWjB6n0AEWZK7pBvyWTW82rxehyeFDkODk5C9Z0yvBiLv66gU3Wq
        hAXcFsEBQJZmLy922VzplFVTw7ZupiRaF9dnCOJc+fU4cCnzQgEjitH4f76gJV8Asx66OF
        a4dD7rCEW7+so1GezzbqbHZLp9o2xJKZrF3YaLJrlcdyTPaJ0NrC25g32PkqgA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286528; a=rsa-sha256;
        cv=none;
        b=NhD7J672of9gJYGV/nxnQIT1xOvZhpk0lhg9jcMW6g4h7HHpB40SPpN8rTpJsNFRXxJsy9
        SSzrRodFpwZ0DcHbCg3RPk5rfQXLqqkPD5gvOvmoDpGBTJ7bD7VxzVa9OuwaTNYNZzuo0+
        Gf4NWjHoXO8XRv3Bd5LzZYB3nujbWyqYJHYLHJwAJ9bcRMdBNbIc5n/Yn4bKMwwebekaeg
        JIl2xAOtzciHsjlTcStpobwEfx9G6mipcj4K0QhswrxMM9Z+nxY9kxaEzhod1EAgvbRzNd
        wg7i3KNHwKqfnKbiKjaYJiSsP38C/ZET95IvN60cZwndFm1W6h59ZmjRa862Tw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 02/17] smb: client: ensure to try all targets when finding nested links
Date:   Thu, 17 Aug 2023 12:34:00 -0300
Message-ID: <20230817153416.28083-3-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With current implementation, when a nested DFS link is found during
mount(2), the client follows the referral and then try to connect to
all of its targets.  If all targets failed, the client bails out
rather than retrying remaining targets from previous referral.

Fix this by stacking all referrals and targets so the client can retry
remaining targets from previous referrals in case all targets of
current referral have failed.

Thanks to samba, this can be easily tested like below

* Run the following under dfs folder in samba server

  $ ln -s "msdfs:srv\\bad-share" link1
  $ ln -s "msdfs:srv\\dfs\\link1,srv\\good-share" link0

* Before patch

  $ mount.cifs //srv/dfs/link0 /mnt -o ...
  mount error(2): No such file or directory
  Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)...

* After patch

  $ mount.cifs //srv/dfs/link0 /mnt -o ...
  # ls /mnt
  bar  fileshare1  sub

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  |  16 ++-
 fs/smb/client/dfs.c       | 271 ++++++++++++++++++++------------------
 fs/smb/client/dfs.h       | 104 +++++++++++++++
 fs/smb/client/dfs_cache.c |   6 +-
 fs/smb/client/dfs_cache.h |   6 +-
 5 files changed, 265 insertions(+), 138 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 657dee4b2c8c..712557c2d526 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1721,11 +1721,23 @@ struct cifs_mount_ctx {
 	struct list_head dfs_ses_list;
 };
 
+static inline void __free_dfs_info_param(struct dfs_info3_param *param)
+{
+	kfree(param->path_name);
+	kfree(param->node_name);
+}
+
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
+{
+	if (param)
+		__free_dfs_info_param(param);
+}
+
+static inline void zfree_dfs_info_param(struct dfs_info3_param *param)
 {
 	if (param) {
-		kfree(param->path_name);
-		kfree(param->node_name);
+		__free_dfs_info_param(param);
+		memset(param, 0, sizeof(*param));
 	}
 }
 
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index c837800c49d4..71ee74041884 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2022 Paulo Alcantara <palcantara@suse.de>
  */
 
-#include <linux/namei.h>
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "dns_resolve.h"
@@ -96,51 +95,134 @@ static int add_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
 	return 0;
 }
 
-static int get_dfs_conn(struct cifs_mount_ctx *mnt_ctx, const char *ref_path, const char *full_path,
-			const struct dfs_cache_tgt_iterator *tit)
+static inline int parse_dfs_target(struct smb3_fs_context *ctx,
+				   struct dfs_ref_walk *rw,
+				   struct dfs_info3_param *tgt)
+{
+	int rc;
+	const char *fpath = ref_walk_fpath(rw) + 1;
+
+	rc = ref_walk_get_tgt(rw, tgt);
+	if (!rc)
+		rc = dfs_parse_target_referral(fpath, tgt, ctx);
+	return rc;
+}
+
+static int set_ref_paths(struct cifs_mount_ctx *mnt_ctx,
+			 struct dfs_info3_param *tgt,
+			 struct dfs_ref_walk *rw)
+{
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	char *ref_path, *full_path;
+	int rc;
+
+	full_path = smb3_fs_context_fullpath(ctx, CIFS_DIR_SEP(cifs_sb));
+	if (IS_ERR(full_path))
+		return PTR_ERR(full_path);
+
+	if (!tgt || (tgt->server_type == DFS_TYPE_LINK &&
+		     DFS_INTERLINK(tgt->flags)))
+		ref_path = dfs_get_path(cifs_sb, ctx->UNC);
+	else
+		ref_path = dfs_get_path(cifs_sb, full_path);
+	if (IS_ERR(ref_path)) {
+		rc = PTR_ERR(ref_path);
+		kfree(full_path);
+		return rc;
+	}
+	ref_walk_path(rw) = ref_path;
+	ref_walk_fpath(rw) = full_path;
+	return 0;
+}
+
+static int __dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx,
+			       struct dfs_ref_walk *rw)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
-	struct dfs_info3_param ref = {};
+	struct dfs_info3_param tgt = {};
 	bool is_refsrv;
-	int rc, rc2;
-
-	rc = dfs_cache_get_tgt_referral(ref_path + 1, tit, &ref);
-	if (rc)
-		return rc;
-
-	rc = dfs_parse_target_referral(full_path + 1, &ref, ctx);
-	if (rc)
-		goto out;
-
-	cifs_mount_put_conns(mnt_ctx);
-	rc = get_session(mnt_ctx, ref_path);
-	if (rc)
-		goto out;
-
-	is_refsrv = !!(ref.flags & DFSREF_REFERRAL_SERVER);
-
-	rc = -EREMOTE;
-	if (ref.flags & DFSREF_STORAGE_SERVER) {
-		rc = cifs_mount_get_tcon(mnt_ctx);
-		if (rc)
-			goto out;
-
-		/* some servers may not advertise referral capability under ref.flags */
-		is_refsrv |= is_tcon_dfs(mnt_ctx->tcon);
-
-		rc = cifs_is_path_remote(mnt_ctx);
-	}
-
-	dfs_cache_noreq_update_tgthint(ref_path + 1, tit);
-
-	if (rc == -EREMOTE && is_refsrv) {
-		rc2 = add_root_smb_session(mnt_ctx);
-		if (rc2)
-			rc = rc2;
-	}
+	int rc = -ENOENT;
+
+again:
+	do {
+		if (ref_walk_empty(rw)) {
+			rc = dfs_get_referral(mnt_ctx, ref_walk_path(rw) + 1,
+					      NULL, ref_walk_tl(rw));
+			if (rc) {
+				rc = cifs_mount_get_tcon(mnt_ctx);
+				if (!rc)
+					rc = cifs_is_path_remote(mnt_ctx);
+				continue;
+			}
+			if (!ref_walk_num_tgts(rw)) {
+				rc = -ENOENT;
+				continue;
+			}
+		}
+
+		while (ref_walk_next_tgt(rw)) {
+			rc = parse_dfs_target(ctx, rw, &tgt);
+			if (rc)
+				continue;
+
+			cifs_mount_put_conns(mnt_ctx);
+			rc = get_session(mnt_ctx, ref_walk_path(rw));
+			if (rc)
+				continue;
+
+			is_refsrv = tgt.server_type == DFS_TYPE_ROOT ||
+				DFS_INTERLINK(tgt.flags);
+			ref_walk_set_tgt_hint(rw);
+
+			if (tgt.flags & DFSREF_STORAGE_SERVER) {
+				rc = cifs_mount_get_tcon(mnt_ctx);
+				if (!rc)
+					rc = cifs_is_path_remote(mnt_ctx);
+				if (!rc)
+					break;
+				if (rc != -EREMOTE)
+					continue;
+			}
+
+			if (is_refsrv) {
+				rc = add_root_smb_session(mnt_ctx);
+				if (rc)
+					goto out;
+			}
+
+			rc = ref_walk_advance(rw);
+			if (!rc) {
+				rc = set_ref_paths(mnt_ctx, &tgt, rw);
+				if (!rc) {
+					rc = -EREMOTE;
+					goto again;
+				}
+			}
+			if (rc != -ELOOP)
+				goto out;
+		}
+	} while (rc && ref_walk_descend(rw));
 
 out:
-	free_dfs_info_param(&ref);
+	free_dfs_info_param(&tgt);
+	return rc;
+}
+
+static int dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx)
+{
+	struct dfs_ref_walk *rw;
+	int rc;
+
+	rw = ref_walk_alloc();
+	if (IS_ERR(rw))
+		return PTR_ERR(rw);
+
+	ref_walk_init(rw);
+	rc = set_ref_paths(mnt_ctx, NULL, rw);
+	if (!rc)
+		rc = __dfs_referral_walk(mnt_ctx, rw);
+	ref_walk_free(rw);
 	return rc;
 }
 
@@ -148,105 +230,36 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 {
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
-	char *ref_path = NULL, *full_path = NULL;
-	struct dfs_cache_tgt_iterator *tit;
 	struct cifs_tcon *tcon;
-	char *origin_fullpath = NULL;
-	char sep = CIFS_DIR_SEP(cifs_sb);
-	int num_links = 0;
+	char *origin_fullpath;
 	int rc;
 
-	ref_path = dfs_get_path(cifs_sb, ctx->UNC);
-	if (IS_ERR(ref_path))
-		return PTR_ERR(ref_path);
+	origin_fullpath = dfs_get_path(cifs_sb, ctx->source);
+	if (IS_ERR(origin_fullpath))
+		return PTR_ERR(origin_fullpath);
 
-	full_path = smb3_fs_context_fullpath(ctx, sep);
-	if (IS_ERR(full_path)) {
-		rc = PTR_ERR(full_path);
-		full_path = NULL;
+	rc = dfs_referral_walk(mnt_ctx);
+	if (rc)
 		goto out;
-	}
 
-	origin_fullpath = kstrdup(full_path, GFP_KERNEL);
-	if (!origin_fullpath) {
-		rc = -ENOMEM;
-		goto out;
+	tcon = mnt_ctx->tcon;
+	spin_lock(&tcon->tc_lock);
+	if (!tcon->origin_fullpath) {
+		tcon->origin_fullpath = origin_fullpath;
+		origin_fullpath = NULL;
 	}
-
-	do {
-		DFS_CACHE_TGT_LIST(tl);
-
-		rc = dfs_get_referral(mnt_ctx, ref_path + 1, NULL, &tl);
-		if (rc) {
-			rc = cifs_mount_get_tcon(mnt_ctx);
-			if (!rc)
-				rc = cifs_is_path_remote(mnt_ctx);
-			break;
-		}
-
-		tit = dfs_cache_get_tgt_iterator(&tl);
-		if (!tit) {
-			cifs_dbg(VFS, "%s: dfs referral (%s) with no targets\n", __func__,
-				 ref_path + 1);
-			rc = -ENOENT;
-			dfs_cache_free_tgts(&tl);
-			break;
-		}
-
-		do {
-			rc = get_dfs_conn(mnt_ctx, ref_path, full_path, tit);
-			if (!rc)
-				break;
-			if (rc == -EREMOTE) {
-				if (++num_links > MAX_NESTED_LINKS) {
-					rc = -ELOOP;
-					break;
-				}
-				kfree(ref_path);
-				kfree(full_path);
-				ref_path = full_path = NULL;
-
-				full_path = smb3_fs_context_fullpath(ctx, sep);
-				if (IS_ERR(full_path)) {
-					rc = PTR_ERR(full_path);
-					full_path = NULL;
-				} else {
-					ref_path = dfs_get_path(cifs_sb, full_path);
-					if (IS_ERR(ref_path)) {
-						rc = PTR_ERR(ref_path);
-						ref_path = NULL;
-					}
-				}
-				break;
-			}
-		} while ((tit = dfs_cache_get_next_tgt(&tl, tit)));
-		dfs_cache_free_tgts(&tl);
-	} while (rc == -EREMOTE);
-
-	if (!rc) {
-		tcon = mnt_ctx->tcon;
-
-		spin_lock(&tcon->tc_lock);
-		if (!tcon->origin_fullpath) {
-			tcon->origin_fullpath = origin_fullpath;
-			origin_fullpath = NULL;
-		}
-		spin_unlock(&tcon->tc_lock);
-
-		if (list_empty(&tcon->dfs_ses_list)) {
-			list_replace_init(&mnt_ctx->dfs_ses_list,
-					  &tcon->dfs_ses_list);
-			queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
-					   dfs_cache_get_ttl() * HZ);
-		} else {
-			dfs_put_root_smb_sessions(&mnt_ctx->dfs_ses_list);
-		}
+	spin_unlock(&tcon->tc_lock);
+
+	if (list_empty(&tcon->dfs_ses_list)) {
+		list_replace_init(&mnt_ctx->dfs_ses_list, &tcon->dfs_ses_list);
+		queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
+				   dfs_cache_get_ttl() * HZ);
+	} else {
+		dfs_put_root_smb_sessions(&mnt_ctx->dfs_ses_list);
 	}
 
 out:
 	kfree(origin_fullpath);
-	kfree(ref_path);
-	kfree(full_path);
 	return rc;
 }
 
diff --git a/fs/smb/client/dfs.h b/fs/smb/client/dfs.h
index 98e9d2aca6a7..c0a9eea6a2c5 100644
--- a/fs/smb/client/dfs.h
+++ b/fs/smb/client/dfs.h
@@ -9,6 +9,110 @@
 #include "cifsglob.h"
 #include "fs_context.h"
 #include "cifs_unicode.h"
+#include <linux/namei.h>
+
+#define DFS_INTERLINK(v) \
+	(((v) & DFSREF_REFERRAL_SERVER) && !((v) & DFSREF_STORAGE_SERVER))
+
+struct dfs_ref {
+	char *path;
+	char *full_path;
+	struct dfs_cache_tgt_list tl;
+	struct dfs_cache_tgt_iterator *tit;
+};
+
+struct dfs_ref_walk {
+	struct dfs_ref *ref;
+	struct dfs_ref refs[MAX_NESTED_LINKS];
+};
+
+#define ref_walk_start(w)	((w)->refs)
+#define ref_walk_end(w)	(&(w)->refs[ARRAY_SIZE((w)->refs) - 1])
+#define ref_walk_cur(w)	((w)->ref)
+#define ref_walk_descend(w)	(--ref_walk_cur(w) >= ref_walk_start(w))
+
+#define ref_walk_tit(w)	(ref_walk_cur(w)->tit)
+#define ref_walk_empty(w)	(!ref_walk_tit(w))
+#define ref_walk_path(w)	(ref_walk_cur(w)->path)
+#define ref_walk_fpath(w)	(ref_walk_cur(w)->full_path)
+#define ref_walk_tl(w)		(&ref_walk_cur(w)->tl)
+
+static inline struct dfs_ref_walk *ref_walk_alloc(void)
+{
+	struct dfs_ref_walk *rw;
+
+	rw = kmalloc(sizeof(*rw), GFP_KERNEL);
+	if (!rw)
+		return ERR_PTR(-ENOMEM);
+	return rw;
+}
+
+static inline void ref_walk_init(struct dfs_ref_walk *rw)
+{
+	memset(rw, 0, sizeof(*rw));
+	ref_walk_cur(rw) = ref_walk_start(rw);
+}
+
+static inline void __ref_walk_free(struct dfs_ref *ref)
+{
+	kfree(ref->path);
+	kfree(ref->full_path);
+	dfs_cache_free_tgts(&ref->tl);
+	memset(ref, 0, sizeof(*ref));
+}
+
+static inline void ref_walk_free(struct dfs_ref_walk *rw)
+{
+	struct dfs_ref *ref = ref_walk_start(rw);
+
+	for (; ref <= ref_walk_end(rw); ref++)
+		__ref_walk_free(ref);
+	kfree(rw);
+}
+
+static inline int ref_walk_advance(struct dfs_ref_walk *rw)
+{
+	struct dfs_ref *ref = ref_walk_cur(rw) + 1;
+
+	if (ref > ref_walk_end(rw))
+		return -ELOOP;
+	__ref_walk_free(ref);
+	ref_walk_cur(rw) = ref;
+	return 0;
+}
+
+static inline struct dfs_cache_tgt_iterator *
+ref_walk_next_tgt(struct dfs_ref_walk *rw)
+{
+	struct dfs_cache_tgt_iterator *tit;
+	struct dfs_ref *ref = ref_walk_cur(rw);
+
+	if (!ref->tit)
+		tit = dfs_cache_get_tgt_iterator(&ref->tl);
+	else
+		tit = dfs_cache_get_next_tgt(&ref->tl, ref->tit);
+	ref->tit = tit;
+	return tit;
+}
+
+static inline int ref_walk_get_tgt(struct dfs_ref_walk *rw,
+				   struct dfs_info3_param *tgt)
+{
+	zfree_dfs_info_param(tgt);
+	return dfs_cache_get_tgt_referral(ref_walk_path(rw) + 1,
+					  ref_walk_tit(rw), tgt);
+}
+
+static inline int ref_walk_num_tgts(struct dfs_ref_walk *rw)
+{
+	return dfs_cache_get_nr_tgts(ref_walk_tl(rw));
+}
+
+static inline void ref_walk_set_tgt_hint(struct dfs_ref_walk *rw)
+{
+	dfs_cache_noreq_update_tgthint(ref_walk_path(rw) + 1,
+				       ref_walk_tit(rw));
+}
 
 struct dfs_root_ses {
 	struct list_head list;
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 89b8af831a43..508d831fabe3 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -29,8 +29,6 @@
 #define CACHE_MIN_TTL		120 /* 2 minutes */
 #define CACHE_DEFAULT_TTL	300 /* 5 minutes */
 
-#define IS_DFS_INTERLINK(v) (((v) & DFSREF_REFERRAL_SERVER) && !((v) & DFSREF_STORAGE_SERVER))
-
 struct cache_dfs_tgt {
 	char *name;
 	int path_consumed;
@@ -174,7 +172,7 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
 				   ce->path, ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
 				   ce->ttl, ce->etime.tv_nsec, ce->hdr_flags, ce->ref_flags,
-				   IS_DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
+				   DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
 				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
 
 			list_for_each_entry(t, &ce->tlist, list) {
@@ -243,7 +241,7 @@ static inline void dump_ce(const struct cache_entry *ce)
 		 ce->srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ttl,
 		 ce->etime.tv_nsec,
 		 ce->hdr_flags, ce->ref_flags,
-		 IS_DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
+		 DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
 		 ce->path_consumed,
 		 cache_entry_expired(ce) ? "yes" : "no");
 	dump_tgts(ce);
diff --git a/fs/smb/client/dfs_cache.h b/fs/smb/client/dfs_cache.h
index c6abc524855f..18a08a2ca93b 100644
--- a/fs/smb/client/dfs_cache.h
+++ b/fs/smb/client/dfs_cache.h
@@ -55,8 +55,8 @@ static inline struct dfs_cache_tgt_iterator *
 dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
 		       struct dfs_cache_tgt_iterator *it)
 {
-	if (!tl || list_empty(&tl->tl_list) || !it ||
-	    list_is_last(&it->it_list, &tl->tl_list))
+	if (!tl || !tl->tl_numtgts || list_empty(&tl->tl_list) ||
+	    !it || list_is_last(&it->it_list, &tl->tl_list))
 		return NULL;
 	return list_next_entry(it, it_list);
 }
@@ -75,7 +75,7 @@ static inline void dfs_cache_free_tgts(struct dfs_cache_tgt_list *tl)
 {
 	struct dfs_cache_tgt_iterator *it, *nit;
 
-	if (!tl || list_empty(&tl->tl_list))
+	if (!tl || !tl->tl_numtgts || list_empty(&tl->tl_list))
 		return;
 	list_for_each_entry_safe(it, nit, &tl->tl_list, it_list) {
 		list_del(&it->it_list);
-- 
2.41.0

