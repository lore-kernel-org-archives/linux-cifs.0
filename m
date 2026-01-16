Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FBC2FDC22
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 22:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768601608; cv=none; b=GIaIpa2HD9XlOxKK4hVNjj7NQDRPHuGrdjya0H7T7pBb1/iQNN6U7fkzpw/DkaMGhzcG3srAgABibwKnihPWmU9uzPl3EOvzJc8eMPYeGUW5kgbmpSU18j1GFX1/IOhkzGDTea6iJY/Xm23zm6MkTSxV8eTwQBV2W7ss/twWE2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768601608; c=relaxed/simple;
	bh=MnLbhjJFP96MzykNFFMPIjF+Co+M/ziVAhR5E3OWbnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5ms9ilp6deeTtyXXJ30vkzXrqupXW2QRG6k4A/DUlOhApK4MvNapahYuVY2iV0ZTtWU5HBweqm1gFXgynC/NgIs83MVzkTrGy2CYqb/Fs1YoVwZHhDEtpzz9O4uye3l3CTMUDz0RfLqONeUxRYqr5HKEhfwHp5DM15MJGGbg0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QoyXCO8g; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QoyXCO8g"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4801c731d0aso13808375e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 14:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768601604; x=1769206404; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XArom+gFbC8JAl5r2wiBoshAQJ9hA8y17FVEFzWviKE=;
        b=QoyXCO8g8rbrC0+ETA4RuBhnh/p0fccdgtd3s6LxDnbqajdoCAB0D0qQMkG7WKwPg5
         67VsG2Z4jnF++wFsnMwKTWYUwWdteRxb5lJyIBauMHIyuprSR2kxdlAvdA32/Yk1ZEhA
         00lL2YbetOX9SSy5fh3h3uPCyS/FpWLPNc27asLjo2Pq3QpDIQMZgWeo/sQvEkYoRCd1
         ezdvMI08PjP91OkiVpeVeEBIxtKfTuJjZbS3DUcjiB3WCxO1yScEjxexECPeY0QKnSYc
         9nWUeM7jhtLlhRCNDcBzdRGTrfO4Je/KsXzuuVPkFFKZ3+VR29FnIooesJSDV/WnI777
         hlmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768601604; x=1769206404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XArom+gFbC8JAl5r2wiBoshAQJ9hA8y17FVEFzWviKE=;
        b=hKG7JKLSqYBE2514Bb3s7beL5Eb0HoAaODNAzTzr994qwoMg5J3jaTdzrHhbDMTTIR
         c2vq+w22p5RDykldkyyZfAJdSArs5KOhXhswFQBbRXjlbbGvJBSJG4D+7RGHwPRDwBzt
         3HqILAqkKCeusR0bEXoqzYlguRaGH2gceOrWvDgepe/LPxagS6TZimOYCxhnQ++8pS7e
         9wPXPAMHqprlZfqc0Ax0kOLbXerP8Xos6vILqgeNDQzXAUHG3FmxxF2BxF4MnQ/ElcZ5
         P3GkVpJX/XCilHdAGqawhSzv2WCNwLWsrrZipDjnszA3S/8tV4QflyFaWJU4d1/L/Ijt
         vIMw==
X-Forwarded-Encrypted: i=1; AJvYcCWtB63M4oOKPYodJrB37qoGj0d889DCC/HSeCni/3hoyjTEvi45PK44etx8zYZF+aMWE+t86jR+GK/g@vger.kernel.org
X-Gm-Message-State: AOJu0YwHERgCcrPprOnDRznSXAeZqxrECEVSwBK8vSK+gWF2DuVU7hyo
	jSR4HvxEbelnfyLvUV6UjNAFIZGsiAaoNYGDmVDYXrnOt/ZQlaVTlxHkpalymVClVx8=
X-Gm-Gg: AY/fxX7FTOv1Ldv3hnMlL1i3gn35Ps/RZ+CBBFePfchMBFY30AlP6NVT+eEJV2Ol4Gg
	J8fAyhWEtivzcgETb1fSKH76jbTlUjw4vrSOD+5BlS0yWwpyPaQYm7XTFocM5oea59J25lI5WlA
	XMnz36NABOAcf+ODiKfHnqmv3ntasW0nItXKhP+U5QrvXwt+vtPzo8UcCO62KG/5UdZ1s6X3a4c
	ztoCkg7ULB9uZGR2PhX3Gw1Ff7O1wO11gNKZSFvfJAqRuRPxeCfTf+bQsSbB6wb7AAGl0fF1pWv
	tbO4oF4MiyHxj/i4WrCso0KpvIuD/4jeLmr1HF1YcRH1dWJUIdXxbvIr0S8IA5+klAq11XZCQ8F
	ylcFtKxzLVi1KlUmaYudJWY75w+t78/uAPMX8sSYOydqaQE8HE4V9OzDFCMA4RVKOfOPnekR0dG
	T9e5NDGBm5xx3oEp+0Qw==
X-Received: by 2002:a05:600c:c178:b0:477:a977:b8c5 with SMTP id 5b1f17b1804b1-4801e34cd0emr61251725e9.31.1768601604426;
        Fri, 16 Jan 2026 14:13:24 -0800 (PST)
Received: from precision ([138.121.131.195])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6c2de1f29sm2112592eec.15.2026.01.16.14.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:13:24 -0800 (PST)
Date: Fri, 16 Jan 2026 19:13:18 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
Message-ID: <hpnpl6ovgtsmkzqazwohzpdxayt33nf7e7j7wi4h7rwevdjvbv@ztx7lx66oavv>
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116220641.322213-1-henrique.carvalho@suse.com>

V2 -> V1: remove vestigial fields from mchan_mount and replaced
get_smb_session function for smb_ses_inc_refcount, as suggested by Enzo.

On Fri, Jan 16, 2026 at 07:06:40PM -0300, Henrique Carvalho wrote:
> Mounts can experience large delays when servers advertise interfaces
> that are unreachable from the client.
> 
> To fix this, decouple channel addition from the synchronous mount path
> by introducing struct mchan_mount and running channel setup as
> background work.
> 
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cifsglob.h |  5 ++++
>  fs/smb/client/connect.c  | 58 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 60 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3eca5bfb7030..ebb106e927c4 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1796,6 +1796,11 @@ struct cifs_mount_ctx {
>  	struct cifs_tcon *tcon;
>  };
>  
> +struct mchan_mount {
> +	struct work_struct work;
> +	struct cifs_ses *ses;
> +};
> +
>  static inline void __free_dfs_info_param(struct dfs_info3_param *param)
>  {
>  	kfree(param->path_name);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index ce620503e9f7..d6c93980d1b6 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *server);
>  static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
>  static void cifs_prune_tlinks(struct work_struct *work);
>  
> +static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
> +static void mchan_mount_free(struct mchan_mount *mchan_mount);
> +static void mchan_mount_work_fn(struct work_struct *work);
> +
>  /*
>   * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
>   * get their ip addresses changed at some point.
> @@ -3899,15 +3903,61 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
>  	return rc;
>  }
>  
> +static struct mchan_mount *
> +mchan_mount_alloc(struct cifs_ses *ses)
> +{
> +	struct mchan_mount *mchan_mount;
> +
> +	mchan_mount = kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
> +	if (!mchan_mount)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
> +
> +	spin_lock(&cifs_tcp_ses_lock);
> +	cifs_smb_ses_inc_refcount(ses);
> +	spin_unlock(&cifs_tcp_ses_lock);
> +	mchan_mount->ses = ses;
> +
> +	return mchan_mount;
> +}
> +
> +static void
> +mchan_mount_free(struct mchan_mount *mchan_mount)
> +{
> +	cifs_put_smb_ses(mchan_mount->ses);
> +	kfree(mchan_mount);
> +}
> +
> +static void
> +mchan_mount_work_fn(struct work_struct *work)
> +{
> +	struct mchan_mount *mchan_mount = container_of(work, struct mchan_mount, work);
> +
> +	smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->server, false, false);
> +
> +	mchan_mount_free(mchan_mount);
> +}
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>  {
>  	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
> +	struct mchan_mount *mchan_mount = NULL;
>  	int rc;
>  
>  	rc = dfs_mount_share(&mnt_ctx);
>  	if (rc)
>  		goto error;
> +
> +	if (ctx->multichannel) {
> +		mchan_mount = mchan_mount_alloc(mnt_ctx.ses);
> +		if (IS_ERR(mchan_mount)) {
> +			rc = PTR_ERR(mchan_mount);
> +			goto error;
> +		}
> +	}
> +
>  	if (!ctx->dfs_conn)
>  		goto out;
>  
> @@ -3926,17 +3976,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>  	ctx->prepath = NULL;
>  
>  out:
> -	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> -				  false /* from_reconnect */,
> -				  false /* disable_mchan */);
>  	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
>  	if (rc)
>  		goto error;
>  
> +	if (ctx->multichannel)
> +		queue_work(cifsiod_wq, &mchan_mount->work);
> +
>  	free_xid(mnt_ctx.xid);
>  	return rc;
>  
>  error:
> +	if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
> +		mchan_mount_free(mchan_mount);
>  	cifs_mount_put_conns(&mnt_ctx);
>  	return rc;
>  }
> -- 
> 2.50.1
> 
