Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2B1D2EE
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="WWfZdwzg"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DE7358C
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 07:02:07 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699542124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0s6fEJTJqnP1fAl1i4bwbAYuzeWkgLclqXUSSly8n98=;
	b=WWfZdwzgXhDA43ocqFVEi2S4kuKNFo+VWK9JKk50LDcdTk0wemK7o7s9EGTjEbH3cV21HD
	fvqaxMtQX04I78S0zC0tP3v8AHHbcClvDYml0SgMpkt28v1TUweu5TjFj5oSPSDiy7DJRK
	zH1YQ7Hqk/yBn3XLxWeEGU14Vopnf3E2NRYfP19DdyLlU0rs2PoebD6SaX+XsZoy7/mgK5
	sLF+lufC8/Ay/R+TUSRhCnMcq616KmKc1iovp0XSeNpQgDaNo0gcjefSVqcq64h6Wlc8mM
	tog03PTYjzwCVDYiErjCSImOeayFVJlitdFnFJQaDLQsgjxdy7+FWZ6aA7G3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699542124; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0s6fEJTJqnP1fAl1i4bwbAYuzeWkgLclqXUSSly8n98=;
	b=EqCI7/7XfLGP3MaH7wDBuCybidAraWZ6j87CfdlWSTEj5bTPZO0hkUJQuilOffWosDCUxY
	o4gPvpOEnXLJQUQwityXSW2XMewYDPeX4+d5oWtkkCyemEoRXLgvNclyx3BUeLH6A30NID
	aQTIiAUV9I6Y/fsyEOi8fg2HzZGtH0sqB2XYbRdX3Z+t51zP5NKrVQjTi5/68NfZhvJvY7
	GEdEh6G6uV2gC45w2lPS18m9ZvKuUlFLLhx5r+fcI3IGNQSKkjm90FIjpDt/IZBavtP+40
	rn/9RGVFp1otAkLqsC0zS886eYy+KEQe+GPMGqi30HkTy2D1VgauR0L16LfotQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699542124; a=rsa-sha256;
	cv=none;
	b=eYoNeKv3t5jYnmSQ7pie2SAlbVRt+GYfTmIKQlcJG9SqEqBhIClLfiTz/d8+Ab4eYPOaPJ
	keH+dJbgdvNG+frtQy+6ztwq6SguwGTEsa72Gg1gYh9NyGg7I6kwi4iBVM4lHx/ILp2UT4
	8aXhYHbPRtFe0IkHGjjm+Yu+4EaxNe/NhC1aE33nepa3Nn45pu0mNqKPZ2eVgO8/BotJSE
	NKS/7Ec8H6ew3elvb8bYizoYoNw+kq1IOIXSKPvBNjPxsxJfnOjPwNYi6Pkeu1PMyC44R0
	H/weYetFxzmvVjDUHXgtlov+aa/zmr8D7a6jgdQUKNGe1uAx03qzP4lPBlYXWw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Eduard Bachmakov <e.bachmakov@gmail.com>
Subject: [PATCH] smb: client: fix mount when dns_resolver key is not available
Date: Thu,  9 Nov 2023 12:01:48 -0300
Message-ID: <20231109150148.6273-1-pc@manguebit.com>
In-Reply-To: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
References: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There was a wrong assumption that with CONFIG_CIFS_DFS_UPCALL=y there
would always be a dns_resolver key set up so we could unconditionally
upcall to resolve UNC hostname rather than using the value provided by
mount(2).

Only require it when performing automount of junctions within a DFS
share so users that don't have dns_resolver key still can mount their
regular shares with server hostname resolved by mount.cifs(8).

Fixes: 348a04a8d113 ("smb: client: get rid of dfs code dep in namespace.c")
Tested-by: Eduard Bachmakov <e.bachmakov@gmail.com>
Reported-by: Eduard Bachmakov <e.bachmakov@gmail.com>
Closes: https://lore.kernel.org/all/CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/dfs.c        | 18 +++++++++++++-----
 fs/smb/client/fs_context.h |  1 +
 fs/smb/client/namespace.c  | 17 +++++++++++++++--
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 81b84151450d..a8a1d386da65 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -263,15 +263,23 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	return rc;
 }
 
-/* Resolve UNC hostname in @ctx->source and set ip addr in @ctx->dstaddr */
+/*
+ * If @ctx->dfs_automount, then update @ctx->dstaddr earlier with the DFS root
+ * server from where we'll start following any referrals.  Otherwise rely on the
+ * value provided by mount(2) as the user might not have dns_resolver key set up
+ * and therefore failing to upcall to resolve UNC hostname under @ctx->source.
+ */
 static int update_fs_context_dstaddr(struct smb3_fs_context *ctx)
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
-	int rc;
+	int rc = 0;
 
-	rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
-	if (!rc)
-		cifs_set_port(addr, ctx->port);
+	if (!ctx->nodfs && ctx->dfs_automount) {
+		rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
+		if (!rc)
+			cifs_set_port(addr, ctx->port);
+		ctx->dfs_automount = false;
+	}
 	return rc;
 }
 
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 9d8d34af0211..cf46916286d0 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -268,6 +268,7 @@ struct smb3_fs_context {
 	bool witness:1; /* use witness protocol */
 	char *leaf_fullpath;
 	struct cifs_ses *dfs_root_ses;
+	bool dfs_automount:1; /* set for dfs automount only */
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index c8f5ed8a69f1..a6968573b775 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -117,6 +117,18 @@ cifs_build_devname(char *nodename, const char *prepath)
 	return dev;
 }
 
+static bool is_dfs_mount(struct dentry *dentry)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	bool ret;
+
+	spin_lock(&tcon->tc_lock);
+	ret = !!tcon->origin_fullpath;
+	spin_unlock(&tcon->tc_lock);
+	return ret;
+}
+
 /* Return full path out of a dentry set for automount */
 static char *automount_fullpath(struct dentry *dentry, void *page)
 {
@@ -212,8 +224,9 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 		ctx->source = NULL;
 		goto out;
 	}
-	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s\n",
-		 __func__, ctx->source, ctx->UNC, ctx->prepath);
+	ctx->dfs_automount = is_dfs_mount(mntpt);
+	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s dfs_automount=%d\n",
+		 __func__, ctx->source, ctx->UNC, ctx->prepath, ctx->dfs_automount);
 
 	mnt = fc_mount(fc);
 out:
-- 
2.42.0

