Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA319EB64D9
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 00:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjF1AZP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 20:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjF1AZO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 20:25:14 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E11296B
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 17:25:10 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687911903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FLyGagQGGychTGKAdAB93meS/kugJhrMmMdQYJ3jgOs=;
        b=pIXFhRQxy2e7WeIEQBC7hL5o8PKlmX6Opsf8IwyA5LbWA1+wB7SdRZE9btoVa21puhxqBZ
        c7env4gOv8TUF5q+sDOTg2cPNWUJx23vDVMqG5u0ed079TxABPNfwJUCK7ucf3zIXMxxMp
        VZ8UzIjyokFFxqM0PIotzzfVbS5Qu69lBiIrm6IOR0mwzAndErEhdhaVdk9mir/Hqtz3Lb
        NhjMUvcnLX3p2R6Q6FnHw8DYOC2E8xqQBPdm3h3RTTtGRE8+yClsxFRnljQW1M8HTMnfry
        mb1sh2FFt6g+gLuvYX3Jg6CFYB4cvGPhFY0Ihy3oM3B0REZm6Ku2ESMZUv/SPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687911903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FLyGagQGGychTGKAdAB93meS/kugJhrMmMdQYJ3jgOs=;
        b=oEUTyP+37TAY4Ih/EQ7eykr7OuQQ+kiG28ex8VWHFB3lfqhyThKFxEdSAPOKKBgygiCBx8
        auUMod8H5syMFE6mUeJi9Zkx4HVZUMRAbgRHLYnuvPa0Yi70cVuL+idCy6TUc8VOsFCBWk
        AvpGypNbq5rRLnoNSCvXguRBdbHBG98LqPog0pKy8uEwJY26Bq4B6gCyQuoLJDkGwXv+3h
        q+YIKSrlG4QbHdkgXgv1jQQjm/M1vKnZkVeHG0D7iBK+oZ3V8HizLmpd/HxH8gNLWDU+Go
        kF7G4PmaZOQzwbX9OxSVbGaNgs7cPhPJNAtLeWHbpmemcqAkWS18ZqjjhZo4yQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1687911903; a=rsa-sha256;
        cv=none;
        b=h8XKPBfYux9MEI4XJLyzVsm9CjoJQXTu2PKnea/exFJU04nzsOBFpfCbnrJ1AhqP4NbZD8
        9WZbHbDnYqHLj2PthFxelLODWzib4tgpb7J18nTk6WxD3vm/HEUPBo9Jnj8YUD6M50T9ll
        tZqrt991GXhpv3//RzyVqfSCc12ajjVnXwCp2DjflmqvSi0KMH056JKZR7LxVUxSyQucgg
        7j+YnIfxUTboh8C3cWMNuSZoTlHMaI39ESckzSJEu0zCQxo6ie4eh5sB29C1LkVDSswFFW
        Glisa6X1JL6WH767dVlddQzjBhpoG7Atxk7A2GFUXq5LvhnAsRVmt5XOZdZkzw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/4] smb: client: fix parsing of source mount option
Date:   Tue, 27 Jun 2023 21:24:47 -0300
Message-ID: <20230628002450.18781-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Handle trailing and leading separators when parsing UNC and prefix
paths in smb3_parse_devname().  Then, store the sanitised paths in
smb3_fs_context::source.

This fixes the following cases

$ mount //srv/share// /mnt/1 -o ...
$ cat /mnt/1/d0/f0
cat: /mnt/1/d0/f0: Invalid argument

The -EINVAL was returned because the client sent SMB2_CREATE "\\d0\f0"
rather than SMB2_CREATE "\d0\f0".

$ mount //srv//share /mnt/1 -o ...
mount: Invalid argument

The -EINVAL was returned correctly although the client only realised
it after sending a couple of bad requests rather than bailing out
earlier when parsing mount options.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifs_dfs_ref.c | 28 +++++++++++------
 fs/smb/client/cifsproto.h    |  2 ++
 fs/smb/client/dfs.c          | 38 ++---------------------
 fs/smb/client/fs_context.c   | 59 ++++++++++++++++++++++++++++++------
 fs/smb/client/misc.c         | 17 +++++++----
 5 files changed, 84 insertions(+), 60 deletions(-)

diff --git a/fs/smb/client/cifs_dfs_ref.c b/fs/smb/client/cifs_dfs_ref.c
index 0329a907bdfe..b1c2499b1c3b 100644
--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -118,12 +118,12 @@ cifs_build_devname(char *nodename, const char *prepath)
 	return dev;
 }
 
-static int set_dest_addr(struct smb3_fs_context *ctx, const char *full_path)
+static int set_dest_addr(struct smb3_fs_context *ctx)
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
 	int rc;
 
-	rc = dns_resolve_server_name_to_ip(full_path, addr, NULL);
+	rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
 	if (!rc)
 		cifs_set_port(addr, ctx->port);
 	return rc;
@@ -171,10 +171,9 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		mnt = ERR_CAST(full_path);
 		goto out;
 	}
-	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	tmp = *cur_ctx;
-	tmp.source = full_path;
+	tmp.source = NULL;
 	tmp.leaf_fullpath = NULL;
 	tmp.UNC = tmp.prepath = NULL;
 	tmp.dfs_root_ses = NULL;
@@ -185,13 +184,22 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		goto out;
 	}
 
-	rc = set_dest_addr(ctx, full_path);
-	if (rc) {
-		mnt = ERR_PTR(rc);
-		goto out;
-	}
-
 	rc = smb3_parse_devname(full_path, ctx);
+	if (rc) {
+		mnt = ERR_PTR(rc);
+		goto out;
+	}
+
+	ctx->source = smb3_fs_context_fullpath(ctx, '/');
+	if (IS_ERR(ctx->source)) {
+		mnt = ERR_CAST(ctx->source);
+		ctx->source = NULL;
+		goto out;
+	}
+	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s dstaddr=%pISpc\n",
+		 __func__, ctx->source, ctx->UNC, ctx->prepath, &ctx->dstaddr);
+
+	rc = set_dest_addr(ctx);
 	if (!rc)
 		mnt = fc_mount(fc);
 	else
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index d127aded2f28..293c54867d94 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -85,6 +85,8 @@ extern void release_mid(struct mid_q_entry *mid);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
+extern char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx,
+				      char dirsep);
 extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 extern int smb3_parse_opt(const char *options, const char *key, char **val);
 extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 2390b2fedd6a..d741f396c527 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -54,39 +54,6 @@ int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_para
 	return rc;
 }
 
-/*
- * cifs_build_path_to_root returns full path to root when we do not have an
- * existing connection (tcon)
- */
-static char *build_unc_path_to_root(const struct smb3_fs_context *ctx,
-				    const struct cifs_sb_info *cifs_sb, bool useppath)
-{
-	char *full_path, *pos;
-	unsigned int pplen = useppath && ctx->prepath ? strlen(ctx->prepath) + 1 : 0;
-	unsigned int unc_len = strnlen(ctx->UNC, MAX_TREE_SIZE + 1);
-
-	if (unc_len > MAX_TREE_SIZE)
-		return ERR_PTR(-EINVAL);
-
-	full_path = kmalloc(unc_len + pplen + 1, GFP_KERNEL);
-	if (full_path == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	memcpy(full_path, ctx->UNC, unc_len);
-	pos = full_path + unc_len;
-
-	if (pplen) {
-		*pos = CIFS_DIR_SEP(cifs_sb);
-		memcpy(pos + 1, ctx->prepath, pplen);
-		pos += pplen;
-	}
-
-	*pos = '\0'; /* add trailing null */
-	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
-	cifs_dbg(FYI, "%s: full_path=%s\n", __func__, full_path);
-	return full_path;
-}
-
 static int get_session(struct cifs_mount_ctx *mnt_ctx, const char *full_path)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
@@ -179,6 +146,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon;
 	char *origin_fullpath = NULL;
+	char sep = CIFS_DIR_SEP(cifs_sb);
 	int num_links = 0;
 	int rc;
 
@@ -186,7 +154,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	if (IS_ERR(ref_path))
 		return PTR_ERR(ref_path);
 
-	full_path = build_unc_path_to_root(ctx, cifs_sb, true);
+	full_path = smb3_fs_context_fullpath(ctx, sep);
 	if (IS_ERR(full_path)) {
 		rc = PTR_ERR(full_path);
 		full_path = NULL;
@@ -228,7 +196,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 				kfree(full_path);
 				ref_path = full_path = NULL;
 
-				full_path = build_unc_path_to_root(ctx, cifs_sb, true);
+				full_path = smb3_fs_context_fullpath(ctx, sep);
 				if (IS_ERR(full_path)) {
 					rc = PTR_ERR(full_path);
 					full_path = NULL;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 226d71e12db0..a4b80babd03e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -442,14 +442,17 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
  * but there are some bugs that prevent rename from working if there are
  * multiple delimiters.
  *
- * Returns a sanitized duplicate of @path. @gfp indicates the GFP_* flags
- * for kstrdup.
+ * Return a sanitized duplicate of @path or NULL for empty prefix paths.
+ * Otherwise, return ERR_PTR.
+ *
+ * @gfp indicates the GFP_* flags for kstrdup.
  * The caller is responsible for freeing the original.
  */
 #define IS_DELIM(c) ((c) == '/' || (c) == '\\')
 char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
 {
 	char *cursor1 = prepath, *cursor2 = prepath;
+	char *s;
 
 	/* skip all prepended delimiters */
 	while (IS_DELIM(*cursor1))
@@ -470,8 +473,39 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
 	if (IS_DELIM(*(cursor2 - 1)))
 		cursor2--;
 
-	*(cursor2) = '\0';
-	return kstrdup(prepath, gfp);
+	*cursor2 = '\0';
+	if (!*prepath)
+		return NULL;
+	s = kstrdup(prepath, gfp);
+	if (!s)
+		return ERR_PTR(-ENOMEM);
+	return s;
+}
+
+/*
+ * Return full path based on the values of @ctx->{UNC,prepath}.
+ *
+ * It is assumed that both values were already parsed by smb3_parse_devname().
+ */
+char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep)
+{
+	size_t ulen, plen;
+	char *s;
+
+	ulen = strlen(ctx->UNC);
+	plen = ctx->prepath ? strlen(ctx->prepath) + 1 : 0;
+
+	s = kmalloc(ulen + plen + 1, GFP_KERNEL);
+	if (!s)
+		return ERR_PTR(-ENOMEM);
+	memcpy(s, ctx->UNC, ulen);
+	if (plen) {
+		s[ulen] = dirsep;
+		memcpy(s + ulen + 1, ctx->prepath, plen);
+	}
+	s[ulen + plen] = '\0';
+	convert_delimiter(s, dirsep);
+	return s;
 }
 
 /*
@@ -485,6 +519,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	char *pos;
 	const char *delims = "/\\";
 	size_t len;
+	int rc;
 
 	if (unlikely(!devname || !*devname)) {
 		cifs_dbg(VFS, "Device name not specified\n");
@@ -512,6 +547,8 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 
 	/* now go until next delimiter or end of string */
 	len = strcspn(pos, delims);
+	if (!len)
+		return -EINVAL;
 
 	/* move "pos" up to delimiter or NULL */
 	pos += len;
@@ -534,8 +571,11 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 		return 0;
 
 	ctx->prepath = cifs_sanitize_prepath(pos, GFP_KERNEL);
-	if (!ctx->prepath)
-		return -ENOMEM;
+	if (IS_ERR(ctx->prepath)) {
+		rc = PTR_ERR(ctx->prepath);
+		ctx->prepath = NULL;
+		return rc;
+	}
 
 	return 0;
 }
@@ -1150,12 +1190,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "Unknown error parsing devname\n");
 			goto cifs_parse_mount_err;
 		}
-		ctx->source = kstrdup(param->string, GFP_KERNEL);
-		if (ctx->source == NULL) {
+		ctx->source = smb3_fs_context_fullpath(ctx, '/');
+		if (IS_ERR(ctx->source)) {
+			ctx->source = NULL;
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
-		fc->source = kstrdup(param->string, GFP_KERNEL);
+		fc->source = kstrdup(ctx->source, GFP_KERNEL);
 		if (fc->source == NULL) {
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index cd914be905b2..609d0c0d9eca 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1198,16 +1198,21 @@ int match_target_ip(struct TCP_Server_Info *server,
 
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 {
+	int rc;
+
 	kfree(cifs_sb->prepath);
+	cifs_sb->prepath = NULL;
 
 	if (prefix && *prefix) {
 		cifs_sb->prepath = cifs_sanitize_prepath(prefix, GFP_ATOMIC);
-		if (!cifs_sb->prepath)
-			return -ENOMEM;
-
-		convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
-	} else
-		cifs_sb->prepath = NULL;
+		if (IS_ERR(cifs_sb->prepath)) {
+			rc = PTR_ERR(cifs_sb->prepath);
+			cifs_sb->prepath = NULL;
+			return rc;
+		}
+		if (cifs_sb->prepath)
+			convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
+	}
 
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	return 0;
-- 
2.41.0

