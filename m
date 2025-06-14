Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204692E11DB
	for <linux-cifs@vger.kernel.org>; Sat, 14 Jun 2025 03:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749873057; cv=none; b=MPIs6LsMNBCpKpu9dU48U+MtJzS1DRTavCdG59zQibB/6d7KubhC/crjcLbK6f65clujTdPYaxz/DZtkbzhSPEUptZ6hDne5/ufjXiCBUgIhLqAySIC4ZXm5jTwEM3nHE4LS8BO+PB4Xyi5Ia56BIb9e9+WaDFGBgO2oD/+Oowo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749873057; c=relaxed/simple;
	bh=dIZSOznOpo7BwOafqiBJwg+ACvGJ7fM9QbGc4fbwOQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CkNVAhAF3PdpmCfQMRY2q7uY+/hxa/l6AVEZL9d8CVk2+fo1nzJyeIda61/6/NnPhjcHZ1Q7w/ekM524fG8lh4/QPwIF1icTW2yQvVoVg0VSY4KN+feWDcPIbTy+5EN+FBgwryAsN6bRpC59/I+vP3sIgLwG02ZwLnQzJ4AGnCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 7CEBD72C8CC;
	Sat, 14 Jun 2025 06:42:20 +0300 (MSK)
Received: from pony.office.basealt.ru (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 7218A36D0168;
	Sat, 14 Jun 2025 06:42:20 +0300 (MSK)
Received: by pony.office.basealt.ru (Postfix, from userid 500)
	id 25F12360D4EC; Sat, 14 Jun 2025 06:42:20 +0300 (MSK)
Date: Sat, 14 Jun 2025 06:42:20 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Maria Alexeeva <alxvmr@altlinux.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, pc@manguebit.com, Ivan Volchenko <ivolchenko86@gmail.com>
Subject: Re: [PATCH] fs/smb/client/fs_context: Add hostname option for CIFS
 module to work with domain-based dfs resources with Kerberos authentication
Message-ID: <43os6kphihnry2wggqykiwmusz@pony.office.basealt.ru>
References: <20250516152201.201385-1-alxvmr@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516152201.201385-1-alxvmr@altlinux.org>

Maria,

On Fri, May 16, 2025 at 07:22:01PM +0400, Maria Alexeeva wrote:
> Paths to domain-based dfs resources are defined using the domain name
> of the server in the format:
> \\DOMAIN.NAME>\<dfsroot>\<path>
> 
> The CIFS module, when requesting a TGS, uses the server name
> (<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
> It then composes an SPN that does not match any entities
> in the domain because it is the domain name itself.

For a casual reader like me it's hard to understand (this abbreviation
filled message) what it's all about. And why we can't just change system
hostname for example.

Also, the summary (subject) message is 180 character which is way above
75 characters suggested in submitting-patches.rst.

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
> index a634a34d4086..74de0a9de664 100644
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
> @@ -825,16 +826,23 @@ static int smb3_fs_context_validate(struct fs_context *fc)
>  		return -ENOENT;
>  	}
>  
> +	if (ctx->got_opt_hostname) {
> +		kfree(ctx->server_hostname);
> +		ctx->server_hostname = ctx->opt_hostname;

I am not familiar with the smb codebase but are you sure this will not
cause a race?

> +		pr_notice("changing server hostname to name provided in hostname= option\n");
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
> @@ -1518,6 +1526,21 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
> +		cifs_dbg(FYI, "Host name set\n");
> +		ctx->got_opt_hostname = true;
> +		break;
>  	case Opt_domain:
>  		if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
>  				== CIFS_MAX_DOMAINNAME_LEN) {
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 9e83302ce4b8..cf0478b1eff9 100644
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

Perhaps, smb3_fs_context_dup and smb3_cleanup_fs_context_contents should
be aware of these new fields too.

Thanks,

>  	char *UNC;
>  	char *nodename;
>  	char workstation_name[CIFS_MAX_WORKSTATION_LEN];
> 
> base-commit: bec6f00f120ea68ba584def5b7416287e7dd29a7
> -- 
> 2.42.2
> 
