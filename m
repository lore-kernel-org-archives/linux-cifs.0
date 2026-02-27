Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7E3378D80
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772217968; cv=none; b=HrrRYDbt3Tp2wwrNKOlux/J44LxCe3W7HBJlc9039+jA06waZdFCETdwBAzQKY4Avb5m1zkLZxTN7tT8ZBAtsx2S3Q1SWAz6WCNUcZsOBj8LtqLCdEz4g+4R2+Hrlx+QPCAzBd4QVSfcfO2g8v37bVBtpLQMzwhPrgpXOctTCSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772217968; c=relaxed/simple;
	bh=48KORHbib8pfpsU2BEIhjTzxb8XneS2ZO68tjOQwaGY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NiR7+iveW79+j/VdLWeIMosMg4aS5Id7YDcXdx9HgpZznEJ8zIuob9OwpB+3yGT7bpN5U3ZVzxWS454wucMA4X6CmsVdmdOFV9XJb9ayJ9Q8V+yVVvI/3zzJOVaWk6KCHe0fddSpaS/vyJ13EW+uFSiqm/Hfaa6/FEKBeoGxtP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=yRj2GNFr; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="yRj2GNFr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i9fVMrh03zrA1g+IhlXhEglrhxuKeIfJzjW9g7YdwEU=; b=yRj2GNFrMUwdXKAJJwmlYH/Fsm
	/JbpBk9bBeJ1DjC+APvLRz5Kzjh4kBrDG4X+jaNZ2lXUc5ju7MwYMzerAu5IKtB+xoKyXB1zpcD1F
	GtUgrAroA/f6YegALBa2sNjsV3e+woUC/YQm47reOLERsK93PKLvs9DLq2pSDjjpc2vILZAWDhplQ
	UcFexcjPce4IWpakqM2ibISeplwKFzRf9CmH6J7McambLjFmwaa8DfhrCErsEaBc0B2+og63UEkgE
	qVq8unNxwsLWNrdO8cJWE7i85jAjthRly/fIcH+S0+g/G5GtsxSTsHykr6BIs4Pv4xxVXTd08hwup
	b1sBcOwQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vw2qg-00000000xF3-1rNC;
	Fri, 27 Feb 2026 15:46:02 -0300
Message-ID: <fcfa2783d489660bd152189ed34d9ddc@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Maria Alexeeva <alxvmr@altlinux.org>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 tom@talpey.com, vt@altlinux.org, Maria Alexeeva <alxvmr@altlinux.org>,
 Ivan Volchenko <ivolchenko86@gmail.com>
Subject: Re: [PATCH v3 1/1] fs/smb/client/fs_context: Add hostname option
 for CIFS module to work with domain-based dfs resources with Kerberos
 authentication
In-Reply-To: <20251230164759.259346-2-alxvmr@altlinux.org>
References: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
 <20251230164759.259346-1-alxvmr@altlinux.org>
 <20251230164759.259346-2-alxvmr@altlinux.org>
Date: Fri, 27 Feb 2026 15:46:02 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Maria Alexeeva <alxvmr@altlinux.org> writes:

> Paths to domain-based dfs resources are defined using the domain name
> of the server in the format:
> \\<DOMAIN.NAME>\<dfsroot>\<path>
>
> The CIFS module, when requesting a TGS, uses the server name
> (<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
> It then composes an SPN that does not match any entities
> in the domain because it is the domain name itself.
>
> To eliminate this behavior, a hostname option is added, which is
> the name of the server to connect to and is used in composing the SPN.
> In the future this option will be used in the cifs-utils development.
>
> Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
> Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
> ---
>  fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++------
>  fs/smb/client/fs_context.h |  3 +++
>  2 files changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index d4291d3a9a48..f0d1895fe4bb 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>  	fsparam_string("password2", Opt_pass2),
>  	fsparam_string("ip", Opt_ip),
>  	fsparam_string("addr", Opt_ip),
> +	fsparam_string("hostname", Opt_hostname),
>  	fsparam_string("domain", Opt_domain),
>  	fsparam_string("dom", Opt_domain),
>  	fsparam_string("srcaddr", Opt_srcaddr),
> @@ -866,16 +867,23 @@ static int smb3_fs_context_validate(struct fs_context *fc)
>  		return -ENOENT;
>  	}
>  
> +	if (ctx->got_opt_hostname) {
> +		kfree(ctx->server_hostname);
> +		ctx->server_hostname = ctx->opt_hostname;
> +		pr_notice("changing server hostname to name provided in hostname= option\n");

This is just too verbose.  Consider using pr_notice_once() or
cifs_dbg(VFS | ONCE, ...).

> +	}
> +
>  	if (!ctx->got_ip) {
>  		int len;
> -		const char *slash;
>  
> -		/* No ip= option specified? Try to get it from UNC */
> -		/* Use the address part of the UNC. */
> -		slash = strchr(&ctx->UNC[2], '\\');
> -		len = slash - &ctx->UNC[2];
> +		/*
> +		 * No ip= option specified? Try to get it from server_hostname
> +		 * Use the address part of the UNC parsed into server_hostname
> +		 * or hostname= option if specified.
> +		 */
> +		len = strlen(ctx->server_hostname);
>  		if (!cifs_convert_address((struct sockaddr *)&ctx->dstaddr,
> -					  &ctx->UNC[2], len)) {
> +					  ctx->server_hostname, len)) {
>  			pr_err("Unable to determine destination address\n");
>  			return -EHOSTUNREACH;
>  		}
> @@ -1591,6 +1599,21 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>  		}
>  		ctx->got_ip = true;
>  		break;
> +	case Opt_hostname:
> +		if (strnlen(param->string, CIFS_NI_MAXHOST) == CIFS_NI_MAXHOST) {
> +			pr_warn("host name too long\n");
> +			goto cifs_parse_mount_err;
> +		}
> +
> +		kfree(ctx->opt_hostname);
> +		ctx->opt_hostname = kstrdup(param->string, GFP_KERNEL);
> +		if (ctx->opt_hostname == NULL) {
> +			cifs_errorf(fc, "OOM when copying hostname string\n");
> +			goto cifs_parse_mount_err;
> +		}

No need to kstrdup() @param->string.  You can simply replace it with

                ctx->opt_hostname = no_free_ptr(param->string);

> +		cifs_dbg(FYI, "Host name set\n");

When debugging is enabled, there will be messages logged saying that
'hostname=' has been passed, so no need for this debug message.

> +		ctx->got_opt_hostname = true;
> +		break;
>  	case Opt_domain:
>  		if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
>  				== CIFS_MAX_DOMAINNAME_LEN) {
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 7af7cbbe4208..ff1a04661ef5 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -184,6 +184,7 @@ enum cifs_param {
>  	Opt_pass,
>  	Opt_pass2,
>  	Opt_ip,
> +	Opt_hostname,
>  	Opt_domain,
>  	Opt_srcaddr,
>  	Opt_iocharset,
> @@ -214,6 +215,7 @@ struct smb3_fs_context {
>  	bool gid_specified;
>  	bool sloppy;
>  	bool got_ip;
> +	bool got_opt_hostname;
>  	bool got_version;
>  	bool got_rsize;
>  	bool got_wsize;
> @@ -226,6 +228,7 @@ struct smb3_fs_context {
>  	char *domainname;
>  	char *source;
>  	char *server_hostname;
> +	char *opt_hostname;
>  	char *UNC;
>  	char *nodename;
>  	char workstation_name[CIFS_MAX_WORKSTATION_LEN];

You're introducing a new field to smb3_fs_context structure but forgot
to update smb3_fs_context_dup() and smb3_cleanup_fs_context_contents().

This will break automounts as well as leak
smb3_fs_context::opt_hostname.
