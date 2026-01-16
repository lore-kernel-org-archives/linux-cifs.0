Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454A3090C6
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768583944; cv=none; b=VhYl+8ViKbz2UQ1n+IVwywQFcOcMdMPIqgJP1tc0u5zWqgCNZpHLuQnY9/hxH+z1c3G4CeT7GMlSUsCTAYfGKb0zdkYrXZ4wvcglzGQ6KJ+O0ZzN7CKae4LABApHYrWpY/GOgctFkHwiSxn2eaa5DhG7fIwnvymzVgbwUzAru88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768583944; c=relaxed/simple;
	bh=XKF3vojpIJcUSQHI1PGZd4DJqjQN6TjTHkIhDDa0/Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwjVtkvOfDZbux36iRttZ4GMP23AwgebNN+cjfSXX502tOoQfQXwsJOaOdl4+Xr+ThhkRslP5eeAhV268bpF3/gK3AxNwbnub7jaod467jszci7/mt2hfV6D9zSATddmRtfJH2R7yfdf22q68DbtNRSlGxxCk/IfIMR4iktW2ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GAXbkuYu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KED7eZYN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GAXbkuYu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KED7eZYN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GAXbkuYu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KED7eZYN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GAXbkuYu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KED7eZYN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70C7D336AC;
	Fri, 16 Jan 2026 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768583939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6H/XO45p5bvMuajrUTTvA00FgGFm9IP28CDF7vkOdFk=;
	b=GAXbkuYuoCJDzbTjqzVPtkqBQBN/yeRjg3GlpWoYC5ZEImRbJi+mZXbqdpxSxxOn5ND6xK
	lW5sk2hCVXeeXsaNKoCgTx4yej1F/ErjyvIzip0+1HV1KzmQR64UmKxa816IZCdImJmDxe
	v+TYbfopGUclty4IMZsPwBoD7Jgkokg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768583939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6H/XO45p5bvMuajrUTTvA00FgGFm9IP28CDF7vkOdFk=;
	b=KED7eZYNgx1gsXUF1JDKtu9HFnDxvP+DGiYGMSr7mmSKYGqoh1OmOrt0iaXXfrw3CDOz3y
	3Sh1dZsLTCCnjQCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GAXbkuYu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KED7eZYN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768583939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6H/XO45p5bvMuajrUTTvA00FgGFm9IP28CDF7vkOdFk=;
	b=GAXbkuYuoCJDzbTjqzVPtkqBQBN/yeRjg3GlpWoYC5ZEImRbJi+mZXbqdpxSxxOn5ND6xK
	lW5sk2hCVXeeXsaNKoCgTx4yej1F/ErjyvIzip0+1HV1KzmQR64UmKxa816IZCdImJmDxe
	v+TYbfopGUclty4IMZsPwBoD7Jgkokg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768583939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6H/XO45p5bvMuajrUTTvA00FgGFm9IP28CDF7vkOdFk=;
	b=KED7eZYNgx1gsXUF1JDKtu9HFnDxvP+DGiYGMSr7mmSKYGqoh1OmOrt0iaXXfrw3CDOz3y
	3Sh1dZsLTCCnjQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC3A43EA63;
	Fri, 16 Jan 2026 17:18:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DG6tKwJzamnjFgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 16 Jan 2026 17:18:58 +0000
Date: Fri, 16 Jan 2026 14:18:56 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: introduce multichannel async work during
 mount
Message-ID: <crmq6jjsp5iknahbeo2d6lf7gbmrnmqcqgnfuq4sjxulw3sdku@ik35hhy3zkst>
References: <20260116153548.223614-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260116153548.223614-1-henrique.carvalho@suse.com>
X-Spam-Score: -4.01
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[samba.org,manguebit.org,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 70C7D336AC
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 01/16, Henrique Carvalho wrote:
>Mounts can experience large delays when servers advertise interfaces
>that are unreachable from the client.
>
>Decouple channel addition from the synchronous mount path by introducing
>struct mchan_mount and running channel setup as background work. This
>prevents mount stalls caused by slow or unreachable interfaces.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/cifsglob.h |  7 ++++
> fs/smb/client/connect.c  | 75 ++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 79 insertions(+), 3 deletions(-)

Ack for the fix idea, but I have a few comments on the patch itself
(inline reply below).

>diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>index 7d815dd96ad1..ed2f0a13655a 100644
>--- a/fs/smb/client/cifsglob.h
>+++ b/fs/smb/client/cifsglob.h
>@@ -1803,6 +1803,13 @@ struct cifs_mount_ctx {
> 	struct cifs_tcon *tcon;
> };
>
>+struct mchan_mount {
>+	struct kref refcount;
>+	struct work_struct work;
>+
>+	struct cifs_ses *ses;
>+};
>+
> static inline void __free_dfs_info_param(struct dfs_info3_param *param)
> {
> 	kfree(param->path_name);
>diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>index 778664206722..56c5df9df943 100644
>--- a/fs/smb/client/connect.c
>+++ b/fs/smb/client/connect.c
>@@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *server);
> static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
> static void cifs_prune_tlinks(struct work_struct *work);
>
>+static struct mchan_mount *mchan_mount_alloc(struct smb3_fs_context *ctx);
>+static void mchan_mount_release(struct kref *refcount);
>+static void mchan_mount_work_fn(struct work_struct *work);
>+
> /*
>  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
>  * get their ip addresses changed at some point.
>@@ -3898,15 +3902,78 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
> 	return rc;
> }
>
>+static struct mchan_mount *
>+mchan_mount_alloc(struct smb3_fs_context *ctx)
>+{
>+	int rc;
>+	struct TCP_Server_Info *server;
>+	struct mchan_mount *mchan_mount;
>+
>+	mchan_mount = kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
>+	if (!mchan_mount)
>+		return ERR_PTR(-ENOMEM);
>+
>+	INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
>+	kref_init(&mchan_mount->refcount);
>+
>+	server = cifs_get_tcp_session(ctx, NULL);

server ref is not put later.

>+	if (IS_ERR(server)) {
>+		rc = PTR_ERR(server);
>+		goto error;
>+	}
>+
>+	mchan_mount->ses = cifs_get_smb_ses(server, ctx);
>+	if (IS_ERR(mchan_mount->ses)) {
>+		cifs_put_tcp_session(server, false);
>+		rc = PTR_ERR(mchan_mount->ses);
>+		goto error;
>+	}
>+
>+	return mchan_mount;
>+
>+error:
>+	kfree(mchan_mount);
>+
>+	return ERR_PTR(rc);
>+}
>+
>+static void
>+mchan_mount_release(struct kref *refcount)
>+{
>+	struct mchan_mount *mchan_mount = container_of(refcount, struct mchan_mount, refcount);
>+
>+	cifs_put_smb_ses(mchan_mount->ses);
>+	kfree(mchan_mount);
>+}
>+
>+static void
>+mchan_mount_work_fn(struct work_struct *work)
>+{
>+	struct mchan_mount *mchan_mount = container_of(work, struct mchan_mount, work);
>+
>+	smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->server, false, false);
>+	kref_put(&mchan_mount->refcount, mchan_mount_release);

If you're going to use kref_put just for the kref_init ref (1), makes
more sense to just ditch it and do regular alloc/free path.

>+}
>+
> #ifdef CONFIG_CIFS_DFS_UPCALL
> int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
> {
> 	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
>+	struct mchan_mount *mchan_mount = NULL;
> 	int rc;
>
> 	rc = dfs_mount_share(&mnt_ctx);
> 	if (rc)
> 		goto error;
>+
>+	if (ctx->multichannel) {
>+		mchan_mount = mchan_mount_alloc(ctx);
>+		if (IS_ERR(mchan_mount)) {
>+			rc = PTR_ERR(mchan_mount);
>+			goto error;
>+		}
>+	}
>+
> 	if (!ctx->dfs_conn)
> 		goto out;
>
>@@ -3925,17 +3992,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
> 	ctx->prepath = NULL;
>
> out:
>-	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
>-				  false /* from_reconnect */,
>-				  false /* disable_mchan */);
> 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> 	if (rc)
> 		goto error;
>
>+	if (ctx->multichannel)
>+		queue_work(cifsiod_wq, &mchan_mount->work);
>+
> 	free_xid(mnt_ctx.xid);
> 	return rc;
>
> error:
>+	if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
>+		kref_put(&mchan_mount->refcount, mchan_mount_release);
> 	cifs_mount_put_conns(&mnt_ctx);
> 	return rc;
> }
>-- 

In general, I'd suggest getting ses ref with cifs_smb_ses_inc_refcount()
instead (you already have the session here, cifs_get_smb_ses() does a
full search + checks + possible reconnect).

Then move cifs_put_smb_ses() to the end of mchan_mount_work_fn().


Cheers,

Enzo
