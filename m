Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DA8566C
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 03:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="s78mea7Q"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9108C25B8
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 19:43:30 -0800 (PST)
Message-ID: <d2c0c53db617b6d2f9b71e734b165b4b.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699501408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nu+Ko3sT859XBe6/nDvmHhzsODISLoa1vCW4MxKQg/U=;
	b=s78mea7Qp6PCdQGcvy6gQ6pD1fyo1jWmuvgf6OQSOIZgrFFT/G9VfQDergR+ADJ4xUrbMq
	euE4dXgF+pDFz/NAKoZ+q2hmtzum2ZfCpAnxfseuLswkyzAzX6l2PedZAKgpw6BI5KHfxB
	cMxLqQjqpcRYcNDWOSAfh/SwJvt91hrQJFdtTCNZwpl8UznCLx4QF2ML1yrgfXLRDUlAde
	M84ezoLzok4NapUWswE6rjWVQ8sLKG7fGa9vJWC0YQaFgz066BQbeVrcHx8OMTHwuCv+SY
	IJIHBQETmTCln9SdG1dwsWw9L7Ko1yyXFhr+5b3Qh7LUv2dI7Ysiky015Igdqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699501408; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nu+Ko3sT859XBe6/nDvmHhzsODISLoa1vCW4MxKQg/U=;
	b=qaVCo8bLgZ3yxc/ncfIkNg6RcMzv2DGD9LIG3BDEdfWtogiiQSDL+3g+AcMZEiwf7WLe+A
	x1+DA3Dyut05EdjuBnvJZkPN5ubyX04TLydRzPVV5+svfB+odGl6DPtbHgfZQCo8ctry8x
	eUM2SVIhu42b92+acjMLWk+jNE26Dq30HVlbF594mW3bnT0cfjYINtezzZ0vGdfSWMObLc
	D7G7MavbrIYBRDQmUNsEI0XU6QVaeXVpxoPtQ0s2V9P+s+UyjBWuZrtfE4pgdpX/5pfK9h
	GLeGpQgWw0ezopbC5fqhV0hOol3e3FqvoJm/azZ7Ox05LjVuf2x80bibyj8fdw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699501408; a=rsa-sha256;
	cv=none;
	b=sCvziCvGJZY+m3j5ljR+TWXyl0gTpac97sBQnoE0JozI+bqMR6IguKhSQN++tmPRzcIF6o
	QnsOZSWmJouRKLd6dzXEZetwHhEnANgEkRB4ebhh6ClzyjlJfR4gawAMFpbdmj3cSapK/4
	6gsx/sm9t+RFgDLHecZNvaRFyvUfA71uCj4rD3CBjNskfN7WMPfizLbdNkOR8wRWdEI3mv
	m5W3ADiMiDfDhDQz0y7kQ1XlovNRrgwDBBaG9XTjsTU+n22VLPXd7HNDkaSbvW5rk2qRu7
	FFguyF0NUbDMbLRtlP2P8mak0hsoTljyqY5xoA9+jlkrqAdXFa+dbSPKu9eoJw==
From: Paulo Alcantara <pc@manguebit.com>
To: Eduard Bachmakov <e.bachmakov@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Unexpected additional umh-based DNS lookup in 6.6.0
In-Reply-To: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
References: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
Date: Thu, 09 Nov 2023 00:43:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain

Eduard Bachmakov <e.bachmakov@gmail.com> writes:

> When attempting to mount (mount.cifs version 7.0) a share using
>
>     $ mount -t cifs -o
> vers=3.1.1,cred=/home/u/.secret.txt,uid=1000,gid=100
> //smb.server.example.com/scans /home/u/mnt
>
> it succeeds on 6.5.9:
>
>     mount("//smb.server.example.com/scans", ".", "cifs", 0,
> "ip=192.168.5.43,unc=\\\\smb.server.example.com\\scans,vers=3.1.1,uid=1000,gid=100,user=u,pass=mypassword")
> = 0
>
> but fails on 6.0.0:
>
>     mount("//smb.server.example.com/scans", ".", "cifs", 0,
> "ip=192.168.5.43,unc=\\\\smb.server.example.com\\scans,vers=3.1.1,uid=1000,gid=100,user=u,pass=mypassword")
> = -1 ENOKEY (Required key not available)
>
> (or ENOENT) though it still works with using the IP instead of the domain:
>
>     mount("//192.168.5.43/scans", ".", "cifs", 0,
> "ip=192.168.5.43,unc=\\\\192.168.5.43\\scans,vers=3.1.1,uid=1000,gid=100,user=u,pass=mypassword")
> = 0
>
> Based on my reading ever since 348a04a ("smb: client: get rid of dfs
> code dep in namespace.c") dfs_mount_share() is now calling
> dns_resolve_server_name_to_ip() early and unconditionally. This can be
> verified on a running system by enabling dns_resolver logging (echo 1
> | sudo tee /sys/module/dns_resolver/parameters/debug + watch dmesg).
> An additional DNS lookup is attempted in 6.0.0 that previously wasn't.
> My best guess is that ENOENT is "didn't work" and ENOKEY means "didn't
> work but cached".

Yes, this is a regression.  Commit assumed that there would be always a
dns_resolver key set up on kernels built with CONFIG_CIFS_DFS_UPCALL=y
so that cifs.ko could safely upcall to resolve UNC hostname regardless
whether mounting a DFS share or a regular share.

Could you please try attached patch?

Thanks.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=patch.diff

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

--=-=-=--
