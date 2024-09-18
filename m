Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B0139D1B
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636579; cv=pass; b=cV6senzFsOvhxBAcyDKQtBfsW4RhFnOQ0uKHGvN0Td5HtaWWMhAGzbXIEK0hSQ4MyzbbxvEOGg/Va4WfOGwpjkxXdiZeRDt+rfupytPK64Sjm7MpJ1TyuzXQAX58ZXtKAopVAQAGYDVZucAFiqS5llInCcv+zGsfZBbEBtQvTLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636579; c=relaxed/simple;
	bh=fK2tZsUjCHUzE726FLveHLSKV3QsberRB7D8sJ/+xn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3VndqfnGyHxtWuJcH+0n9WeY0Jbtyu3ILtHge4DBA3AnEJ5oYQktJphkyhEN/5Z8pCuuOhYSkKOTPWQmMWz6xqAgJVScSyp2QkSZZ+fef267j0Z3VeG6Abe0CqK3c00zH9gDFHo7hDj6rl7Ui0tezfehF/4tbB8A71o5KbFK4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=dih68IZi; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="dih68IZi"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8GAwxoM2jkzIiF+K8JYIaYW/UaUBpJmIHmBZuPGWFs=;
	b=dih68IZiuNXmn7OhdnGv3N15aq3yXaYW95WU32HnzlQ8IWEI/IzTRrrZk2nwWdhCtG4AAR
	t86eFhqLsITY0O0ZY2syJjI8K7T4V5jRyaTgNQkbn/g2pEL+ka1zREFNQN5fvWgThW4Ofe
	qrkIgOe0pLQNBHTQyfo+UPlmcCF4txA49r5wXnYlaT44TL3MSEbAhqq8w5v0I5mezfK302
	4p5kdgvrYguSEiEp/DbfIGcgr/tVwfkjoNz38XDFaAjFY50zy031RbimKOzYXCJF6kV2dW
	lFlJPxxs2bdbwR3zAX3DfLNkJuNK1I52S+uMYWM+WPLTpUbdKLow/o4m18mmcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636576; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8GAwxoM2jkzIiF+K8JYIaYW/UaUBpJmIHmBZuPGWFs=;
	b=KjeiWxPIkn1b8NgaQ9w0hc5VLV9Fx7LVk8/X3NTqZRkhaLwsemM1IFD2+0yArU28OConGk
	3wKx03jxyuLcleE67RXRXOkm5dYvyLy4HDMXbLwsksH0Sh7FssiSGwLe7xJCFju984KSVw
	wUH9/n1XRju9nKUODFXDO3XOhUnaTV2sXx0arettsGiB+BAcZp1vPds6Kdc86566iaH8wg
	wQQxNjBq98bWkPTSBypppHziWhrXMrR45bX5wEo14SrxumyPhoTa/FKoQ81S3a4ygzo562
	NhcQxT95WGS3DjCyj4XSMw2e4UZL4cGK7KDLMZo5CtcEo1jVvbrt3jHiiOzo7g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636576; a=rsa-sha256;
	cv=none;
	b=UlGKi0K9H8IrYT3EgASJ6mTsrfUH8FGXOdY/zhFiSHSZkyjF5pvYoxsgcAxTO6cdiAFcMu
	Uqi0jsc2CExgmgor3wb/paoXQ4X5pBLzgpcF2M9TP4UEMreVG6tA2FKKXwpxixFr6P1WOw
	IYbFfHAzJfZoNEecZXpMCVMLq/ZbmMpK5rPEW9BE9yU+1ZJ5OacEPPHBzfgLzj5fIUrrpd
	X7amzDKCiS3NjcHZaXTsrWJ1gABY9wRne8e6FwW9FHXkE8jzvZLZ+NYZteEztv/7K9/3Yy
	In9yQPQjVWzm+MQhEQtL4csPSLT/B1Du/WvgrzbPk8pTfBLXzUBngiTrPZW6jg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 7/9] smb: client: stop flooding dmesg with automounts
Date: Wed, 18 Sep 2024 02:15:40 -0300
Message-ID: <20240918051542.64349-7-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid logging info and expected errors when automounting DFS links and
reparse mount points as a share might contain hundreds of them and the
client would end up flooding dmesg.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsfs.c     | 4 ++--
 fs/smb/client/connect.c    | 3 ++-
 fs/smb/client/dfs.c        | 3 +--
 fs/smb/client/fs_context.h | 2 +-
 fs/smb/client/namespace.c  | 5 +++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 2a2523c93944..c91cf57f337c 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -910,7 +910,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	if (cifsFYI) {
 		cifs_dbg(FYI, "%s: devname=%s flags=0x%x\n", __func__,
 			 old_ctx->source, flags);
-	} else {
+	} else if (!old_ctx->automount) {
 		cifs_info("Attempting to mount %s\n", old_ctx->source);
 	}
 
@@ -937,7 +937,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 	rc = cifs_mount(cifs_sb, cifs_sb->ctx);
 	if (rc) {
-		if (!(flags & SB_SILENT))
+		if (!(flags & SB_SILENT) && !old_ctx->automount)
 			cifs_dbg(VFS, "cifs_mount failed w/return code = %d\n",
 				 rc);
 		root = ERR_PTR(rc);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a382f532974a..e71b6933464a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3390,7 +3390,8 @@ int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx)
 	ses = cifs_get_smb_ses(server, ctx);
 	if (IS_ERR(ses)) {
 		rc = PTR_ERR(ses);
-		if (rc == -ENOKEY && ctx->sectype == Kerberos)
+		if (rc == -ENOKEY && ctx->sectype == Kerberos &&
+		    !ctx->automount)
 			cifs_dbg(VFS, "Verify user has a krb5 ticket and keyutils is installed\n");
 		ses = NULL;
 		goto out;
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 3f6077c68d68..96db96062a8a 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -263,11 +263,10 @@ static int update_fs_context_dstaddr(struct smb3_fs_context *ctx)
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
 	int rc = 0;
 
-	if (!ctx->nodfs && ctx->dfs_automount) {
+	if (!ctx->nodfs && ctx->automount && ctx->dfs_conn) {
 		rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
 		if (!rc)
 			cifs_set_port(addr, ctx->port);
-		ctx->dfs_automount = false;
 	}
 	return rc;
 }
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 69f9d938b336..5135f7b2e8d3 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -282,7 +282,7 @@ struct smb3_fs_context {
 	bool witness:1; /* use witness protocol */
 	char *leaf_fullpath;
 	struct cifs_ses *dfs_root_ses;
-	bool dfs_automount:1; /* set for dfs automount only */
+	bool automount:1; /* set for automounts */
 	enum cifs_reparse_type reparse_type;
 	bool dfs_conn:1; /* set for dfs mounts */
 };
diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index 0f788031b740..9bfc0a592d27 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -220,6 +220,7 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 	tmp.leaf_fullpath = NULL;
 	tmp.UNC = tmp.prepath = NULL;
 	tmp.dfs_root_ses = NULL;
+	tmp.automount = true;
 	fs_context_set_ids(&tmp);
 
 	rc = smb3_fs_context_dup(ctx, &tmp);
@@ -240,9 +241,9 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 		ctx->source = NULL;
 		goto out;
 	}
-	ctx->dfs_automount = ctx->dfs_conn = is_dfs_mount(mntpt);
+	ctx->dfs_conn = is_dfs_mount(mntpt);
 	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s dfs_automount=%d\n",
-		 __func__, ctx->source, ctx->UNC, ctx->prepath, ctx->dfs_automount);
+		 __func__, ctx->source, ctx->UNC, ctx->prepath, ctx->dfs_conn);
 
 	mnt = fc_mount(fc);
 out:
-- 
2.46.0

