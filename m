Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27943325739
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768586074; cv=none; b=ViafONaANRUALJDbguGhZIh0wbTd63ZOybOSDuALJldikO640oMhKKshnyVg0hBXHvYaWZAIwtgL9vWL88U7CX+C3xgOuhM5y9a8y5Hd7EJC/KgYl51WoBleMxozJk9IdH/G191vyqxAsrGI+nAjqqei0Xapbvzc04+MNgV7MTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768586074; c=relaxed/simple;
	bh=zOUgS9cIXWtt+OFT+FgmnROWq+iTmnVsZJ31/tf5xKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeBgN8JrTvor4iJbrHvnOAEIgMpG2MNkH4oSZBQjEkPJz6eCH4USc8q74OhtYrsk3gycJocvf9uHIYt2jTdbWC0R6QwK3BLtrlvlYdCCbNXxQqFIpBULSd3RD6u1nHeQiP46n3FgshJIxgYpwasy5FHb7zV9rpamWh6seUZYQlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TMCO6zr5; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TMCO6zr5"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-480142406b3so11400885e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 09:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768586071; x=1769190871; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCoN+wTEKMK6+sDOH6rgER1drfsGvKBj0S2n6sfd+Zw=;
        b=TMCO6zr5tUog7m5kcQr5WzUMi3R+yd3tFTPOdfaMrHTbnIWUfwH2xG/Bb68bKNhXMZ
         l+PJbkvcA1Q/CPCP9GwuefF9+5CrAYMi50UXi4QjjuJCVqcZMH1ygMQLAGnERc5YxEtQ
         VIa7uf797Huf4spAKfoDSzuwTAftEd3X8kQcYrG3C2xqJHTDBV3II8q5ztlEJPUYYAXq
         NnGLlLwBV6blUF43HFGy9vqYfhomB6KeEF+/niO3+xvT0erjI+s1nDXCh2KokXW/+9ds
         1J9a3Ib8to84DwtOlHU2Y9GjxUZDUf9A2yXw9uTOupVg8Q0/AgGLMn1Vei24cqNerwqn
         OG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768586071; x=1769190871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCoN+wTEKMK6+sDOH6rgER1drfsGvKBj0S2n6sfd+Zw=;
        b=uUELdtd/QXxrXyPy/o37C8ZwUgT00LCbEf7kjS6K4FPCGH+JJ+cZF+JY9l2YCzwjnM
         gXWTM5uB4N8L9eXiFCafxSm8TBiX+s5KUWnaFWkM/ebCXq+CGnzAHyanw1x/RzMEzDDR
         9eJmetMNetchNbOEb63vB7jUXpL1xhcb7V1o5QLSbEufTfLD2jysJmbqYfJxpXU638Ux
         b6BqesDpeGZAakRvK5YN7jgu4lonRnyrWjfn4WocnGmY7mu3K5+3KXXMmvfbpU5/RQ3x
         PdnJoIvFWaop0J1sULQCLc4BYR1I6FrPtv79qzoC8tY35lTSWtdOVYvw8AURPN+P9Whj
         8IDw==
X-Forwarded-Encrypted: i=1; AJvYcCUKvLsK/jy50LkZOO7X8yu1/5BknZXkpuArRlcRN8psj+Xv3AzpVd9Gt31OD2Tq0jYB9EPgYRQChsFJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwFovh1wjTH2enRts3QRx8i5HjItAUzIPf22GQ5jD0Rydrj4OGe
	co74BsytlP7So5Kb+gGuPkhHbQsZu/ZXJgDvI4r4UHhVVFaSh3i72q6sOxOyN0G8T/1QTRdRPbI
	EZzV2
X-Gm-Gg: AY/fxX5L1zDKvlXf7CeZg5/iZ+U1qIG8AxCF7ekfAdpt90fJjOhQnVre7zPWM2gwbfU
	LnLwQDakJppXRiXBDL4AkI/tyl5suA6jWlUATzMitcEP+MEn0NuK+fHF/I6pzVUTbf+xXUwqrn1
	+w6zR2WdRiTxOOf+0jqG9X6hWP6bqw75ENc6c6bPsn64LpYCjc+/F4JtR2yPg5tBh4obqgcRZot
	Fgin5PSmKgpOecZgLR2b7GP/Vjx2dvlUgEzEMsZf+8hgeukfl8ZpvWsI07AIX53vfNzVBPuLfsd
	rlE0SdT2Di7wIohPDJJGboE32p/U6S/dCwI21IImTocjIYinuktjIFoF/hdSA9Mgh4MmJDgCQ+l
	p2koX8oyaz/dFAGmwJ69MivEImxbpzOsPI2RuBns/UT5OmZ9LiJiwAhiY47wCmYecIVbqzQuf/y
	ZIv0w+oxQPHIfTUD1p0A==
X-Received: by 2002:a05:600c:4eca:b0:47e:e2b0:15b8 with SMTP id 5b1f17b1804b1-48025ded313mr10876035e9.4.1768586071299;
        Fri, 16 Jan 2026 09:54:31 -0800 (PST)
Received: from precision ([138.121.131.195])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b34c11dasm3444616eec.2.2026.01.16.09.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 09:54:30 -0800 (PST)
Date: Fri, 16 Jan 2026 14:54:24 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: introduce multichannel async work during
 mount
Message-ID: <7p7wumkoaywahsazb43kkhvdy74nxpgijqfofo7knrvy42cf54@luja4rcxi63s>
References: <20260116153548.223614-1-henrique.carvalho@suse.com>
 <crmq6jjsp5iknahbeo2d6lf7gbmrnmqcqgnfuq4sjxulw3sdku@ik35hhy3zkst>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <crmq6jjsp5iknahbeo2d6lf7gbmrnmqcqgnfuq4sjxulw3sdku@ik35hhy3zkst>

On Fri, Jan 16, 2026 at 02:18:56PM -0300, Enzo Matsumiya wrote:
> On 01/16, Henrique Carvalho wrote:
> > Mounts can experience large delays when servers advertise interfaces
> > that are unreachable from the client.
> > 
> > Decouple channel addition from the synchronous mount path by introducing
> > struct mchan_mount and running channel setup as background work. This
> > prevents mount stalls caused by slow or unreachable interfaces.
> > 
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> > fs/smb/client/cifsglob.h |  7 ++++
> > fs/smb/client/connect.c  | 75 ++++++++++++++++++++++++++++++++++++++--
> > 2 files changed, 79 insertions(+), 3 deletions(-)
> 
> Ack for the fix idea, but I have a few comments on the patch itself
> (inline reply below).

Thanks!

> 
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 7d815dd96ad1..ed2f0a13655a 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1803,6 +1803,13 @@ struct cifs_mount_ctx {
> > 	struct cifs_tcon *tcon;
> > };
> > 
> > +struct mchan_mount {
> > +	struct kref refcount;
> > +	struct work_struct work;
> > +
> > +	struct cifs_ses *ses;
> > +};
> > +
> > static inline void __free_dfs_info_param(struct dfs_info3_param *param)
> > {
> > 	kfree(param->path_name);
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 778664206722..56c5df9df943 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *server);
> > static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
> > static void cifs_prune_tlinks(struct work_struct *work);
> > 
> > +static struct mchan_mount *mchan_mount_alloc(struct smb3_fs_context *ctx);
> > +static void mchan_mount_release(struct kref *refcount);
> > +static void mchan_mount_work_fn(struct work_struct *work);
> > +
> > /*
> >  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
> >  * get their ip addresses changed at some point.
> > @@ -3898,15 +3902,78 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
> > 	return rc;
> > }
> > 
> > +static struct mchan_mount *
> > +mchan_mount_alloc(struct smb3_fs_context *ctx)
> > +{
> > +	int rc;
> > +	struct TCP_Server_Info *server;
> > +	struct mchan_mount *mchan_mount;
> > +
> > +	mchan_mount = kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
> > +	if (!mchan_mount)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
> > +	kref_init(&mchan_mount->refcount);
> > +
> > +	server = cifs_get_tcp_session(ctx, NULL);
> 
> server ref is not put later.
> 

Ack. Thanks.

> > +	if (IS_ERR(server)) {
> > +		rc = PTR_ERR(server);
> > +		goto error;
> > +	}
> > +
> > +	mchan_mount->ses = cifs_get_smb_ses(server, ctx);
> > +	if (IS_ERR(mchan_mount->ses)) {
> > +		cifs_put_tcp_session(server, false);
> > +		rc = PTR_ERR(mchan_mount->ses);
> > +		goto error;
> > +	}
> > +
> > +	return mchan_mount;
> > +
> > +error:
> > +	kfree(mchan_mount);
> > +
> > +	return ERR_PTR(rc);
> > +}
> > +
> > +static void
> > +mchan_mount_release(struct kref *refcount)
> > +{
> > +	struct mchan_mount *mchan_mount = container_of(refcount, struct mchan_mount, refcount);
> > +
> > +	cifs_put_smb_ses(mchan_mount->ses);
> > +	kfree(mchan_mount);
> > +}
> > +
> > +static void
> > +mchan_mount_work_fn(struct work_struct *work)
> > +{
> > +	struct mchan_mount *mchan_mount = container_of(work, struct mchan_mount, work);
> > +
> > +	smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->server, false, false);
> > +	kref_put(&mchan_mount->refcount, mchan_mount_release);
> 
> If you're going to use kref_put just for the kref_init ref (1), makes
> more sense to just ditch it and do regular alloc/free path.
> 

Yes, you are correct. This is vestigial from an earlier version of this
patch, when this struct actually required refcounting. I decided to
simplify the patch and now it's not even needed.

> > +}
> > +
> > #ifdef CONFIG_CIFS_DFS_UPCALL
> > int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
> > {
> > 	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
> > +	struct mchan_mount *mchan_mount = NULL;
> > 	int rc;
> > 
> > 	rc = dfs_mount_share(&mnt_ctx);
> > 	if (rc)
> > 		goto error;
> > +
> > +	if (ctx->multichannel) {
> > +		mchan_mount = mchan_mount_alloc(ctx);
> > +		if (IS_ERR(mchan_mount)) {
> > +			rc = PTR_ERR(mchan_mount);
> > +			goto error;
> > +		}
> > +	}
> > +
> > 	if (!ctx->dfs_conn)
> > 		goto out;
> > 
> > @@ -3925,17 +3992,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
> > 	ctx->prepath = NULL;
> > 
> > out:
> > -	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> > -				  false /* from_reconnect */,
> > -				  false /* disable_mchan */);
> > 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> > 	if (rc)
> > 		goto error;
> > 
> > +	if (ctx->multichannel)
> > +		queue_work(cifsiod_wq, &mchan_mount->work);
> > +
> > 	free_xid(mnt_ctx.xid);
> > 	return rc;
> > 
> > error:
> > +	if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
> > +		kref_put(&mchan_mount->refcount, mchan_mount_release);
> > 	cifs_mount_put_conns(&mnt_ctx);
> > 	return rc;
> > }
> > -- 
> 
> In general, I'd suggest getting ses ref with cifs_smb_ses_inc_refcount()
> instead (you already have the session here, cifs_get_smb_ses() does a
> full search + checks + possible reconnect).
> 
> Then move cifs_put_smb_ses() to the end of mchan_mount_work_fn().
> 

Yes, that is better.

Will send a v2.

Thanks for your review.

-- 
Henrique
SUSE Labs
