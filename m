Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82473A6B83
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 22:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625072; cv=none; b=JMhc70ka3fFTkyBq8ahqYSJ8hgF9vB2hDVM/o90ecL76y+H6Aj/mvo/9tDn8+vX/Rx5uByvl/INTappSJuvVSlUs7lp7zdZC3VFz6fSnlic2aQg7mK8JPqBlDsOPVRvzDEAXBpAukBMLlNXaeCoegPy3mYLnwN78YHMO4s2ehyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625072; c=relaxed/simple;
	bh=wNNZUXPgsGe4+IV8HrblqK9mKXikrqi3rqjPTw30B14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cui/6jbh71aJq8PY4QQFyOW+BjsmxO8jJbWsI6kHn7nAr+5bTwi2KwHkqFKUKXaPPQj6YxoyqnyltZxpipuLIIOWh0tOfUedVFa7jlgAcuZevbcu+vOAePZZseQV7ScpL4GeWGHnVLuIEoAAaxHsPBpgXtUTpv1B4gL+9fM4Bio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Az9OdeNP; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Az9OdeNP"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67c2d57a5ceso10699334a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778625068; x=1779229868; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2a1ZYcBd66Nt4mXEnW8udf5tYEPH+eDGBIx8+G3OmkQ=;
        b=Az9OdeNPhqC38PJ3y17Tvim5ngJicVEdgUV+fiI/11JRPvZPah+orojPfDHIpLOHX4
         l0/WhCqDGWCSGK1f3r3ELwmRIEreZXaSVimrgvrC6Ci5q6vNGTva0dWa+JtKohrOf4K3
         jUUPZ/dZFm7BL3rU59eQJ4MqjIXVZLW+wVo8hM4emyntGWfb30AkW28MY6OYIK2Vg8xW
         32zyC8dZ79JphxSHFlrCeSZyKMXe0IoyygAEfjeC0Dnq6jbMCmj7yD8YiV99VPd0xwam
         bFB1WT4vV+b5zA1HHRUorUf2XON6d+qSPYKwl7uCuaqCnXh0bA+pgiHlxLZirrmsk7XN
         zhgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625068; x=1779229868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2a1ZYcBd66Nt4mXEnW8udf5tYEPH+eDGBIx8+G3OmkQ=;
        b=MDs1ZEfDXEqaEQHXvl/ZuNuyw6FDRJSPfsIwTmWD30zcU6NrpHLHJVW2w0KHhBSJn1
         m6tvwG7gCMaVdgikIWUuZpYYKWbD2ve2Wl4sOx0qBv3MAqwEYm223cVyKfaH4ggCCsfX
         WNUHhIextuCF8VLRneLLIb6yoqg7GRSilJGMoUPifLAT1v9ZWnGYmQY/tt1Y5aVMmYvg
         n5sk1QgTAIs6ZJab0jPcfg3ukA9n9g1tqOgEHVypqOt/D5VEmdigMjVIkoUiyb0G43VK
         KATeceM8/4ADCEvGkZSuqHKaV/TNYe2admo1GftJT721+cHK3eVEnXTrdVsbXYSmTTBr
         pYUQ==
X-Forwarded-Encrypted: i=1; AFNElJ9uufZoY3FKWG+uT6jcyaGh8atX5QDathJUfqipNiPiiXM47KvgqUFgiluTAyeri1sMO/UIf33DTZM9@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8uGSM+fyzM7u7CJCyz4PsU0QQKq4GDbbqWgv8CjRIzmC4c04v
	35jn4rhN9BPorp78NgbjO+RFrwbxJd89pa7VVdJmSZF1Uxyw1efrdEB+0HVDX/fhr7M=
X-Gm-Gg: Acq92OHKSL7NSm+UYlc7RE0yp5VDLSQ4rmmoTiDXis/5Nm6+ncuQX6Ewm15zwyMAdNV
	j/5Gd0n5LRMr38ceGhj+cZubIgmgSNn1TTBjny6pi1zZFPXDVox2kEMI5ucbOB3w4nZn8JYD1Nt
	8TO82elD3qVTcJY/CnKxUYAA4y/9fLJJ0wGF0lJsXmRg3VfQ33DFDPay59aYSWf1CPRD+QlbUjK
	j6HwHOWqvrTLWIKW9SrpwLzHG9t2HotsVQa+q6hDf/EubMM55H35qb+lGjjTUq3/UseqG32bbpW
	kDVrlG16nJ9ga9SAd1O39SXxkwuUrdb5CZ5bKj9iME6htwiDehWzAlIUP9Lrozrk5GRx6b/3Wrr
	StYFwjyQ775Be4FtsBiZTCaV/P6GSVp1zsTi5TDQaeRjaewF1CG1z5A4TWtxUddxRY/DwaFebIW
	G/cRQLhdGvClVnwdZeki1//7/dtmb7VxUiDVpIMIzpvUodKU/4kORRfyq1e93sgkCT
X-Received: by 2002:a17:907:8690:b0:bcd:2496:69ab with SMTP id a640c23a62f3a-bd3c18341cfmr41005866b.39.1778625068281;
        Tue, 12 May 2026 15:31:08 -0700 (PDT)
Received: from precision (46-253-188-52.dynamic.monzoon.net. [46.253.188.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcaf0660dbbsm729488366b.2.2026.05.12.15.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:31:08 -0700 (PDT)
Date: Tue, 12 May 2026 19:31:07 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Rajasi Mandal <rajasimandal@microsoft.com>, Rajasi Mandal <rajasimandalos@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] smb: client: avoid ctx corruption on failed
 multichannel remounts
Message-ID: <agOgelA6HpKstxZ6@precision>
References: <20260501060907.3859641-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501060907.3859641-1-charsyam@gmail.com>

On Fri, May 01, 2026 at 03:09:07PM +0900, DaeMyung Kang wrote:
> smb3_reconfigure() moves string fields out of the live mount context
> (cifs_sb->ctx) before updating multichannel state. If the remount fails
> after that point, the live context can be left with NULL strings or with
> options that do not match the session state.
> 
> Snapshot cifs_sb->ctx on entry, build the new context separately, and
> replace cifs_sb->ctx only after the staged reconfigure work succeeds.
> Restore the snapshot on failure paths before committing session-side
> state.
> 
> Also make smb3_sync_session_ctx_passwords() all-or-nothing, and keep the
> ses->password commit before smb3_update_ses_channels() so newly added
> channels authenticate with the new credentials.
> 
> Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
> Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
> Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v/
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>

Thanks, this looks good to me now.

Just two things.

First, we don't need the update_password and update_password2
booleans in smb3_sync_session_ctx_passwords, I believe? I suggest
cleaning that up.

Minor nit, restore_new_ctx is a bit misleading, cleanup_new_ctx is
clearer, what do you think?

Other than that, you can add

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

> ---
> v5: (feedback from Henrique Carvalho)
>  - Drop mchan_rc / scale_busy; the early failure paths now restore
>    cifs_sb->ctx from a snapshot taken on entry.
>  - Build new_ctx separately and replace cifs_sb->ctx only on success.
>  - Make smb3_sync_session_ctx_passwords() all-or-nothing: allocate
>    both copies first, commit only when both succeed.
>  - Switch smb3_sync_ses_chan_max() max_channels parameter to size_t
>    to match struct cifs_ses::chan_max.
>  - Shorten the commit message and follow nearby CIFS log style.
> 
>  fs/smb/client/fs_context.c | 163 +++++++++++++++++++++++++------------
>  1 file changed, 110 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index b9544eb0381b..1f0cbcf78e17 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -767,7 +767,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>  static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
>  					    void *data);
>  static int smb3_get_tree(struct fs_context *fc);
> -static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
> +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels);
>  static int smb3_reconfigure(struct fs_context *fc);
>  
>  static const struct fs_context_operations smb3_fs_context_ops = {
> @@ -1041,24 +1041,35 @@ do {									\
>  
>  int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
>  {
> +	char *password = NULL, *password2 = NULL;
> +	bool update_password = false, update_password2 = false;
> +
>  	if (ses->password &&
>  	    cifs_sb->ctx->password &&
>  	    strcmp(ses->password, cifs_sb->ctx->password)) {
> -		kfree_sensitive(cifs_sb->ctx->password);
> -		cifs_sb->ctx->password = kstrdup(ses->password, GFP_KERNEL);
> -		if (!cifs_sb->ctx->password)
> +		password = kstrdup(ses->password, GFP_KERNEL);
> +		if (!password)
>  			return -ENOMEM;
> +		update_password = true;
>  	}
>  	if (ses->password2 &&
>  	    cifs_sb->ctx->password2 &&
>  	    strcmp(ses->password2, cifs_sb->ctx->password2)) {
> -		kfree_sensitive(cifs_sb->ctx->password2);
> -		cifs_sb->ctx->password2 = kstrdup(ses->password2, GFP_KERNEL);
> -		if (!cifs_sb->ctx->password2) {
> -			kfree_sensitive(cifs_sb->ctx->password);
> -			cifs_sb->ctx->password = NULL;
> +		password2 = kstrdup(ses->password2, GFP_KERNEL);
> +		if (!password2) {
> +			kfree_sensitive(password);
>  			return -ENOMEM;
>  		}
> +		update_password2 = true;
> +	}
> +
> +	if (update_password) {
> +		kfree_sensitive(cifs_sb->ctx->password);
> +		cifs_sb->ctx->password = password;
> +	}
> +	if (update_password2) {
> +		kfree_sensitive(cifs_sb->ctx->password2);
> +		cifs_sb->ctx->password2 = password2;
>  	}
>  	return 0;
>  }
> @@ -1072,7 +1083,7 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
>   * with the session's channel lock. This should be called whenever the maximum
>   * allowed channels for a session changes (e.g., after a remount or reconfigure).
>   */
> -static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
> +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
>  {
>  	spin_lock(&ses->chan_lock);
>  	ses->chan_max = max_channels;
> @@ -1082,12 +1093,15 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>  	struct smb3_fs_context *ctx = smb3_fc2context(fc);
> +	struct smb3_fs_context *new_ctx = NULL;
> +	struct smb3_fs_context *old_ctx = NULL;
>  	struct dentry *root = fc->root;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
>  	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
>  	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
>  	char *new_password = NULL, *new_password2 = NULL;
>  	bool need_recon = false;
> +	bool need_mchan_update;
>  	int rc;
>  
>  	if (ses->expired_pwd)
> @@ -1097,6 +1111,16 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	if (rc)
>  		return rc;
>  
> +	old_ctx = kzalloc_obj(*old_ctx);
> +	if (!old_ctx)
> +		return -ENOMEM;
> +
> +	rc = smb3_fs_context_dup(old_ctx, cifs_sb->ctx);
> +	if (rc) {
> +		kfree(old_ctx);
> +		return rc;
> +	}
> +
>  	/*
>  	 * We can not change UNC/username/password/domainname/
>  	 * workstation_name/nodename/iocharset
> @@ -1106,16 +1130,22 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	STEAL_STRING(cifs_sb, ctx, UNC);
>  	STEAL_STRING(cifs_sb, ctx, source);
>  	STEAL_STRING(cifs_sb, ctx, username);
> +	STEAL_STRING(cifs_sb, ctx, domainname);
> +	STEAL_STRING(cifs_sb, ctx, nodename);
> +	STEAL_STRING(cifs_sb, ctx, iocharset);
>  
> -	if (need_recon == false)
> +	if (!need_recon) {
>  		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> -	else  {
> +	} else {
>  		if (ctx->password) {
>  			new_password = kstrdup(ctx->password, GFP_KERNEL);
> -			if (!new_password)
> -				return -ENOMEM;
> -		} else
> +			if (!new_password) {
> +				rc = -ENOMEM;
> +				goto restore_ctx;
> +			}
> +		} else {
>  			STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> +		}
>  	}
>  
>  	/*
> @@ -1125,11 +1155,29 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	if (ctx->password2) {
>  		new_password2 = kstrdup(ctx->password2, GFP_KERNEL);
>  		if (!new_password2) {
> -			kfree_sensitive(new_password);
> -			return -ENOMEM;
> +			rc = -ENOMEM;
> +			goto restore_ctx;
>  		}
> -	} else
> +	} else {
>  		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
> +	}
> +
> +	/* if rsize or wsize not passed in on remount, use previous values */
> +	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
> +	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
> +
> +	new_ctx = kzalloc_obj(*new_ctx);
> +	if (!new_ctx) {
> +		rc = -ENOMEM;
> +		goto restore_ctx;
> +	}
> +
> +	rc = smb3_fs_context_dup(new_ctx, ctx);
> +	if (rc)
> +		goto restore_ctx;
> +
> +	need_mchan_update = ctx->multichannel != cifs_sb->ctx->multichannel ||
> +			    ctx->max_channels != cifs_sb->ctx->max_channels;
>  
>  	/*
>  	 * we may update the passwords in the ses struct below. Make sure we do
> @@ -1140,54 +1188,55 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	/*
>  	 * smb2_reconnect may swap password and password2 in case session setup
>  	 * failed. First get ctx passwords in sync with ses passwords. It should
> -	 * be okay to do this even if this function were to return an error at a
> -	 * later stage
> +	 * be done before committing new passwords.
>  	 */
>  	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
>  	if (rc) {
>  		mutex_unlock(&ses->session_mutex);
> -		kfree_sensitive(new_password);
> -		kfree_sensitive(new_password2);
> -		return rc;
> +		goto restore_new_ctx;
>  	}
>  
>  	/*
> -	 * now that allocations for passwords are done, commit them
> +	 * If multichannel or max_channels has changed, update the session's channels accordingly.
> +	 * This may add or remove channels to match the new configuration.
> +	 */
> +	if (need_mchan_update) {
> +		/* Prevent concurrent scaling operations */
> +		spin_lock(&ses->ses_lock);
> +		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> +			spin_unlock(&ses->ses_lock);
> +			mutex_unlock(&ses->session_mutex);
> +			rc = -EINVAL;
> +			goto restore_new_ctx;
> +		}
> +		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
> +		spin_unlock(&ses->ses_lock);
> +	}
> +
> +	/*
> +	 * Commit session passwords before any channel work so newly added
> +	 * channels authenticate with the new credentials.
>  	 */
>  	if (new_password) {
>  		kfree_sensitive(ses->password);
>  		ses->password = new_password;
> +		new_password = NULL;
>  	}
>  	if (new_password2) {
>  		kfree_sensitive(ses->password2);
>  		ses->password2 = new_password2;
> +		new_password2 = NULL;
>  	}
>  
> -	/*
> -	 * If multichannel or max_channels has changed, update the session's channels accordingly.
> -	 * This may add or remove channels to match the new configuration.
> -	 */
> -	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
> -	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {
> -
> +	if (need_mchan_update) {
>  		/* Synchronize ses->chan_max with the new mount context */
>  		smb3_sync_ses_chan_max(ses, ctx->max_channels);
> -		/* Now update the session's channels to match the new configuration */
> -		/* Prevent concurrent scaling operations */
> -		spin_lock(&ses->ses_lock);
> -		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> -			spin_unlock(&ses->ses_lock);
> -			mutex_unlock(&ses->session_mutex);
> -			return -EINVAL;
> -		}
> -		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
> -		spin_unlock(&ses->ses_lock);
>  
>  		mutex_unlock(&ses->session_mutex);
>  
> -		rc = smb3_update_ses_channels(ses, ses->server,
> -					       false /* from_reconnect */,
> -					       false /* disable_mchan */);
> +		smb3_update_ses_channels(ses, ses->server,
> +					 false /* from_reconnect */,
> +					 false /* disable_mchan */);
>  
>  		/* Clear scaling flag after operation */
>  		spin_lock(&ses->ses_lock);
> @@ -1197,22 +1246,30 @@ static int smb3_reconfigure(struct fs_context *fc)
>  		mutex_unlock(&ses->session_mutex);
>  	}
>  
> -	STEAL_STRING(cifs_sb, ctx, domainname);
> -	STEAL_STRING(cifs_sb, ctx, nodename);
> -	STEAL_STRING(cifs_sb, ctx, iocharset);
> -
> -	/* if rsize or wsize not passed in on remount, use previous values */
> -	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
> -	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
> -
>  	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> -	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
> +	memcpy(cifs_sb->ctx, new_ctx, sizeof(*new_ctx));
> +	kfree(new_ctx);
> +	new_ctx = NULL;
> +	smb3_cleanup_fs_context(old_ctx);
> +	old_ctx = NULL;
>  	smb3_update_mnt_flags(cifs_sb);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	if (!rc)
>  		rc = dfs_cache_remount_fs(cifs_sb);
>  #endif
>  
> +	return rc;
> +
> +restore_new_ctx:
> +	smb3_cleanup_fs_context_contents(new_ctx);
> +restore_ctx:
> +	kfree(new_ctx);
> +	kfree_sensitive(new_password);
> +	kfree_sensitive(new_password2);
> +	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> +	memcpy(cifs_sb->ctx, old_ctx, sizeof(*old_ctx));
> +	kfree(old_ctx);
> +
>  	return rc;
>  }
>  
> -- 
> 2.43.0
> 
