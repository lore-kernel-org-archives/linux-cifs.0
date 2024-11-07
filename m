Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4F42170DA
	for <linux-cifs@vger.kernel.org>; Thu,  7 Nov 2024 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731004902; cv=fail; b=QmpSJC5Asfoh8FHiMOLPiT/A0nldOnYKW9KgOV8ByoCukSfJkP3GUm6qlOSoN8fZOWKkpOjqOnDsJDHbMftwVie1wE9VeyNehwmpTHPhlUUhfJksLM3XRCtldAirUo1Axp0X1QwUbOTFayRAyrrfeAMK5SkiVbXqzU9a1Y4ISYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731004902; c=relaxed/simple;
	bh=ir9ExKYJIguJJdyzwhqSRSsVJHULItQZXm1zXZz2+tk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=FZME2CeTTsjJx4+WUteV1TXp7bYO3O1EDkAwaSA+rdGbBSkQS6gbPMK4SKF+q6ibP6FK6jncCsGERpRJ8FXFsyxVrUEzxxDU2YqwAZtNnB2zzd+9Qjs81UjRNjU2ej5sbx44VAkg948uy9NlcrQ0pdlQH+a8nINN5Pb4iEwaEn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Br8I+hp+; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Br8I+hp+"
Message-ID: <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731004301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kxUGI8wnmJkImFv4kT4TRG0/HFHFHPYOBhj48GK9Xc0=;
	b=Br8I+hp+KYvlWIAUXYyaBe/+nzV+g5CGWonmcyz6iA+mXpAX+zagMaPqHZMyH+WcJ1GBcb
	8EB1Cafel+HEPgyG7dkcLtfN7tUsM6sDQzPrfdgYKokgUWx8wHKZXNUg2VITpWdl0/ntyW
	MRBrP7T+nGzUZZGyFDJSuffEvYtr/QbiIe3s+3Ak1UIwUYJsLOfUQLOF4V+te2Kka3XpcH
	i8GUAMC415XugxZuTz6/V7iDYDhyd3BmGZY8rgRcXtnfkm5hLuFp/IQQEWdhn7qhU+wKrt
	OyNziiMVI9gRmJWPGbJjy/EucbDb73cbJxlixkQ50XLDCqvTieleqntDySnsuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731004301; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kxUGI8wnmJkImFv4kT4TRG0/HFHFHPYOBhj48GK9Xc0=;
	b=nIjrUrc8ZJscFalTeynixczhr/V1jozETb6Iolo2my1U59pj2m1ApuJABLAyPmTdBguefc
	z1KEm9FTDNl4vDSaBMrJF240+YhgPmrBPldoLWIQ4/s5LlqmQHE6p9AaTfWicf01aCcM4o
	0ZsklV3WHh0HCEZ5o+bqam+J29gx/luxAk9s+/F0pUoXuM8MTFdUPyv3bOVoOIDY3x5n9u
	l8pHbgDKTJrPr1fnuAhbvdC3Phuj05xNManI6G3fEFXD95ZTqKF823aOJY8Z2J/puhVUMQ
	yn6mtAIGehsNlj6+8SzXOoPygzVc4+Bo6eRVtykdV6b+jRP7ZFYnPex9S0uw2w==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731004301; a=rsa-sha256;
	cv=none;
	b=q/r/onC7Dt1AgkGOUAbEiwmzjUpK11FJOQ2wh1jYDucEQ7JGpTAQ49tg2pOs3yZ36OAQ8a
	rj87ccZgzhrkIjNY5XzbaumXLwTh53p/HN/P2JN2pHzXJL8dIuH3vDxtMdJVls6Yk1tYSy
	N+1UH4AJt2/v4SpSTYtb6QPaTlZ7G7b+LC4FT9T2iCkqcPfEjn1f0Fzh/34EABuTzPUxV+
	iDaSLgMNCDl1j0HwrlwqV+3p2k8fNjz3Uruj6P/Cj4yqFWjg7sGDVy+e3fZxFewhFq3d9+
	jFpFFYcOO5+emO7lqTqDBKnv6M0JYeXfyPS8pKwDRa2acZEpsBspjN/X56jInA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org,
 lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
 linux-cifs@vger.kernel.org, nspmangalore@gmail.com,
 bharathsm.hsk@gmail.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
In-Reply-To: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
Date: Thu, 07 Nov 2024 15:31:38 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

meetakshisetiyaoss@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> We recently introduced a password2 field in both ses and ctx structs.
> This was done so as to allow the client to rotate passwords for a mount
> without any downtime. However, when the client transparently handles
> password rotation, it can swap the values of the two password fields
> in the ses struct, but not in smb3_fs_context struct that hangs off
> cifs_sb. This can lead to a situation where a remount unintentionally
> overwrites a working password in the ses struct.

I don't see password rotation being handled for SMB1.  I mounted a share
with 'vers=1.0,password=foo,password2=bar' and didn't get any warnings
or errors about it being usupported.  I think users would like to have
that.

What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't see their
password getting updated over remount.

If you don't plan to support any of the above, then don't allow users to
mount/remount when password rotation can't be handled.

> In order to fix this, we first get the passwords in ctx struct
> in-sync with ses struct, before replacing them with what the passwords
> that could be passed as a part of remount.
>
> Also, in order to avoid race condition between smb2_reconnect and
> smb3_reconfigure, we make sure to lock session_mutex before changing
> password and password2 fields of the ses structure.
>
> Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing on the server by allowing password rotation")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 69 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 60 insertions(+), 9 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 5c5a52019efa..73610e66c8d9 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -896,6 +896,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	struct dentry *root = fc->root;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
>  	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
> +	char *new_password = NULL, *new_password2 = NULL;
>  	bool need_recon = false;
>  	int rc;
>  
> @@ -915,21 +916,71 @@ static int smb3_reconfigure(struct fs_context *fc)
>  	STEAL_STRING(cifs_sb, ctx, UNC);
>  	STEAL_STRING(cifs_sb, ctx, source);
>  	STEAL_STRING(cifs_sb, ctx, username);
> +
>  	if (need_recon == false)
>  		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
>  	else  {
> -		kfree_sensitive(ses->password);
> -		ses->password = kstrdup(ctx->password, GFP_KERNEL);
> -		if (!ses->password)
> -			return -ENOMEM;
> -		kfree_sensitive(ses->password2);
> -		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
> -		if (!ses->password2) {
> -			kfree_sensitive(ses->password);
> -			ses->password = NULL;
> +		if (ctx->password) {
> +			new_password = kstrdup(ctx->password, GFP_KERNEL);
> +			if (!new_password)
> +				return -ENOMEM;
> +		} else
> +			STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> +	}
> +
> +	/*
> +	 * if a new password2 has been specified, then reset it's value
> +	 * inside the ses struct
> +	 */
> +	if (ctx->password2) {
> +		new_password2 = kstrdup(ctx->password2, GFP_KERNEL);
> +		if (!new_password2) {
> +			if (new_password)

Useless non-NULL check as kfree_sensitive() already handles it.

> +				kfree_sensitive(new_password);
>  			return -ENOMEM;
>  		}
> +	} else
> +		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
> +
> +	/*
> +	 * we may update the passwords in the ses struct below. Make sure we do
> +	 * not race with smb2_reconnect
> +	 */
> +	mutex_lock(&ses->session_mutex);
> +
> +	/*
> +	 * smb2_reconnect may swap password and password2 in case session setup
> +	 * failed. First get ctx passwords in sync with ses passwords. It should
> +	 * be okay to do this even if this function were to return an error at a
> +	 * later stage
> +	 */
> +	if (ses->password &&
> +	    cifs_sb->ctx->password &&
> +	    strcmp(ses->password, cifs_sb->ctx->password)) {
> +		kfree_sensitive(cifs_sb->ctx->password);
> +		cifs_sb->ctx->password = kstrdup(ses->password, GFP_KERNEL);

Missing allocation failure check.

> +	}
> +	if (ses->password2 &&
> +	    cifs_sb->ctx->password2 &&
> +	    strcmp(ses->password2, cifs_sb->ctx->password2)) {
> +		kfree_sensitive(cifs_sb->ctx->password2);
> +		cifs_sb->ctx->password2 = kstrdup(ses->password2, GFP_KERNEL);

Ditto.

> +	}
> +
> +	/*
> +	 * now that allocations for passwords are done, commit them
> +	 */
> +	if (new_password) {
> +		kfree_sensitive(ses->password);
> +		ses->password = new_password;
> +	}
> +	if (new_password2) {
> +		kfree_sensitive(ses->password2);
> +		ses->password2 = new_password2;
>  	}
> +
> +	mutex_unlock(&ses->session_mutex);
> +
>  	STEAL_STRING(cifs_sb, ctx, domainname);
>  	STEAL_STRING(cifs_sb, ctx, nodename);
>  	STEAL_STRING(cifs_sb, ctx, iocharset);
> -- 
> 2.46.0.46.g406f326d27
