Received: from mail.sernet.de (mail.sernet.de [185.199.217.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065852629D;
	Fri, 15 Nov 2024 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.199.217.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677502; cv=none; b=bOXVEkYYx7FnkxAWfQnMaVBr8i8fEAHrmYSguviN1V7cy1pYyFtmuMRmc8DGq4FWj28qoolzZPHt3K1guBTb8L78AJdEDhttSx/Xi/D7eJud4On0+OP42tK/RhLDxsuu1DtPCJ+o5RoAa+qfdVMYIFt08PkeOKlT546VsDHptCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677502; c=relaxed/simple;
	bh=8dH40fHeAB8mPKH36k3YfaWAQFM8Z8o4mBCVOtAw02s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EK9EVYcrfSBbrwXzh1tY++BUQ7DxHZjuD9CMUQMDWvC9EbO16YdAZ38d/W7PWTSg0oUtWWQrpc42M9JcPMXJOzVsQEmt3QBuO+ARRv8W23OTNTgMH7SJwoaohY+f1JUiTW+Vf8Vmcc5hiEDPcJTD11eERCt5j5kj0EnP3ALpGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=SerNet.DE; spf=pass smtp.mailfrom=sernet.de; dkim=pass (2048-bit key) header.d=sernet.de header.i=@sernet.de header.b=Pkr/HS73; dkim=permerror (0-bit key) header.d=sernet.de header.i=@sernet.de header.b=DN28LtbG; arc=none smtp.client-ip=185.199.217.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=SerNet.DE
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sernet.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sernet.de header.i=@sernet.de header.b="Pkr/HS73";
	dkim=permerror (0-bit key) header.d=sernet.de header.i=@sernet.de header.b="DN28LtbG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
	s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ScSxaEuZD9+t/9IPOrO9gPFXrhTL//cUtOGatP2bKnU=; b=Pkr/HS73g+lmekF2MNc+/palfC
	ETltO/AnSQ0M5VY9Gsp03DYXx42eHmnbHXvq/4/x+5YtteJlwFHGRknSDPdAOZVIoq/2yoRXHk9aT
	DxFjzvHL3M2bmDQbfXryI8mraw1PS6K4JbHrGtNhDHYO6EapZ3SbYUX2HMCshLHOszbJ3c164ENAf
	VA+W6rCigrqQTf0Sene9MFPJSwvNT4MCnQ36ziCKvdIIqfg09TsnN2Lfm/XypHX9bwamlFVRRiZpi
	SPg2ngizIwdvzmh2A3iLnl4QK226izdmDSNpx3B0OLkTG5FKPJ7quroqdC8fAvVDTF/Rk7DQ+JPv3
	LYHf8rcA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ScSxaEuZD9+t/9IPOrO9gPFXrhTL//cUtOGatP2bKnU=; b=DN28LtbGfx2FuM/UQTlP0GPG6Y
	qeJQUTFj7y9HoqmrFLOrKjnyuKmOY8cEI0Y2GQpizEodkqZWn+wgIII3bvDw==;
Date: Fri, 15 Nov 2024 14:26:19 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke@SerNet.DE>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cifs: Add new mount option -o nounicode to disable
 SMB1 UNICODE mode
Message-ID: <20241115132619.GA581468@sernet.de>
References: <20241028110340.29911-1-pali@kernel.org>
 <20241028110340.29911-2-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241028110340.29911-2-pali@kernel.org>
X-Q: Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht

you can  simply use iocharset=iso8859-1 mount option if you want to get legacy
charsets on the client side to work. I don't think that it's a good idea to
mess with the ancient non-unicode flag of SMB.

Björn

On 2024-10-28 at 12:03 +0100 Pali Rohár sent off:
> SMB1 protocol supports non-UNICODE (8-bit OEM character set) and
> UNICODE (UTF-16) modes.
> 
> Linux SMB1 client implements both of them but currently does not allow to
> choose non-UNICODE mode when SMB1 server announce UNICODE mode support.
> 
> This change adds a new mount option -o nounicode to disable UNICODE mode
> and force usage of non-UNICODE (8-bit OEM character set) mode.
> 
> This allows to test non-UNICODE implementation of Linux SMB1 client against
> any SMB1 server, including modern and recent Windows SMB1 server.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/cifsfs.c     |  4 ++++
>  fs/smb/client/cifsglob.h   |  2 ++
>  fs/smb/client/cifssmb.c    |  5 ++++-
>  fs/smb/client/connect.c    | 32 +++++++++++++++++++++++++++++---
>  fs/smb/client/fs_context.c | 11 +++++++++++
>  fs/smb/client/fs_context.h |  2 ++
>  fs/smb/client/sess.c       |  1 +
>  fs/smb/client/smb1ops.c    |  1 +
>  8 files changed, 54 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 1decf91d3f61..447ed7831f2c 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -611,6 +611,10 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>  					   cifs_sb->ctx->dir_mode);
>  	if (cifs_sb->ctx->iocharset)
>  		seq_printf(s, ",iocharset=%s", cifs_sb->ctx->iocharset);
> +	if (tcon->ses->unicode == 0)
> +		seq_puts(s, ",nounicode");
> +	else if (tcon->ses->unicode == 1)
> +		seq_puts(s, ",unicode");
>  	if (tcon->seal)
>  		seq_puts(s, ",seal");
>  	else if (tcon->ses->server->ignore_signature)
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index dcee43889358..2f77b558abe8 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -651,6 +651,7 @@ struct smb_version_values {
>  	unsigned int	cap_unix;
>  	unsigned int	cap_nt_find;
>  	unsigned int	cap_large_files;
> +	unsigned int	cap_unicode;
>  	__u16		signing_enabled;
>  	__u16		signing_required;
>  	size_t		create_lease_size;
> @@ -1124,6 +1125,7 @@ struct cifs_ses {
>  	bool sign;		/* is signing required? */
>  	bool domainAuto:1;
>  	bool expired_pwd;  /* track if access denied or expired pwd so can know if need to update */
> +	int unicode;
>  	unsigned int flags;
>  	__u16 session_flags;
>  	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index c6f15dbe860a..6218b59b9da7 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -423,7 +423,10 @@ CIFSSMBNegotiate(const unsigned int xid,
>  		return rc;
>  
>  	pSMB->hdr.Mid = get_next_mid(server);
> -	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
> +	pSMB->hdr.Flags2 |= SMBFLG2_ERR_STATUS;
> +
> +	if (ses->unicode != 0)
> +		pSMB->hdr.Flags2 |= SMBFLG2_UNICODE;
>  
>  	if (should_set_ext_sec_flag(ses->sectype)) {
>  		cifs_dbg(FYI, "Requesting extended security\n");
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 612816ec71f5..3d9d736b6e58 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2338,6 +2338,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>  	ses->cred_uid = ctx->cred_uid;
>  	ses->linux_uid = ctx->linux_uid;
>  
> +	ses->unicode = ctx->unicode;
>  	ses->sectype = ctx->sectype;
>  	ses->sign = ctx->sign;
>  	ses->local_nls = load_nls(ctx->local_nls->charset);
> @@ -3928,7 +3929,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>  		   struct TCP_Server_Info *server,
>  		   struct nls_table *nls_info)
>  {
> -	int rc = -ENOSYS;
> +	int rc = 0;
>  	struct TCP_Server_Info *pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
>  	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&pserver->dstaddr;
>  	struct sockaddr_in *addr = (struct sockaddr_in *)&pserver->dstaddr;
> @@ -3980,6 +3981,26 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>  		if (!linuxExtEnabled)
>  			ses->capabilities &= (~server->vals->cap_unix);
>  
> +		/*
> +		 * Check if the server supports specified encoding mode.
> +		 * Zero value in vals->cap_unicode indidcates that chosen
> +		 * protocol dialect does not support non-UNICODE mode.
> +		 */
> +		if (ses->unicode == 1 && server->vals->cap_unicode != 0 &&
> +		    !(server->capabilities & server->vals->cap_unicode)) {
> +			cifs_dbg(VFS, "Server does not support mounting in UNICODE mode\n");
> +			rc = -EOPNOTSUPP;
> +		} else if (ses->unicode == 0 && server->vals->cap_unicode == 0) {
> +			cifs_dbg(VFS, "Server does not support mounting in non-UNICODE mode\n");
> +			rc = -EOPNOTSUPP;
> +		} else if (ses->unicode == 0) {
> +			/*
> +			 * When UNICODE mode was explicitly disabled then
> +			 * do not announce client UNICODE capability.
> +			 */
> +			ses->capabilities &= (~server->vals->cap_unicode);
> +		}
> +
>  		if (ses->auth_key.response) {
>  			cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
>  				 ses->auth_key.response);
> @@ -3992,8 +4013,12 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>  	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
>  		 server->sec_mode, server->capabilities, server->timeAdj);
>  
> -	if (server->ops->sess_setup)
> -		rc = server->ops->sess_setup(xid, ses, server, nls_info);
> +	if (!rc) {
> +		if (server->ops->sess_setup)
> +			rc = server->ops->sess_setup(xid, ses, server, nls_info);
> +		else
> +			rc = -ENOSYS;
> +	}
>  
>  	if (rc) {
>  		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
> @@ -4063,6 +4088,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
>  	ctx->seal = master_tcon->seal;
>  	ctx->witness = master_tcon->use_witness;
>  	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
> +	ctx->unicode = master_tcon->ses->unicode;
>  
>  	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
>  	if (rc) {
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 7dd46cfc9fb3..d970b66e529c 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -127,6 +127,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>  	fsparam_flag("rootfs", Opt_rootfs),
>  	fsparam_flag("compress", Opt_compress),
>  	fsparam_flag("witness", Opt_witness),
> +	fsparam_flag_no("unicode", Opt_unicode),
>  
>  	/* Mount options which take uid or gid */
>  	fsparam_uid("backupuid", Opt_backupuid),
> @@ -930,6 +931,10 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
>  		cifs_errorf(fc, "can not change iocharset during remount\n");
>  		return -EINVAL;
>  	}
> +	if (new_ctx->unicode != old_ctx->unicode) {
> +		cifs_errorf(fc, "can not change unicode during remount\n");
> +		return -EINVAL;
> +	}
>  
>  	return 0;
>  }
> @@ -1520,6 +1525,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>  		ctx->witness = true;
>  		pr_warn_once("Witness protocol support is experimental\n");
>  		break;
> +	case Opt_unicode:
> +		ctx->unicode = !result.negated;
> +		cifs_dbg(FYI, "unicode set to %d\n", ctx->unicode);
> +		break;
>  	case Opt_rootfs:
>  #ifndef CONFIG_CIFS_ROOT
>  		cifs_dbg(VFS, "rootfs support requires CONFIG_CIFS_ROOT config option\n");
> @@ -1816,6 +1825,8 @@ int smb3_init_fs_context(struct fs_context *fc)
>  	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
>  	ctx->nonativesocket = 0;
>  
> +	ctx->unicode = -1; /* autodetect, but prefer UNICODE mode */
> +
>  /*
>   *	short int override_uid = -1;
>   *	short int override_gid = -1;
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 18d39d457145..1514e05e6629 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -127,6 +127,7 @@ enum cifs_param {
>  	Opt_multichannel,
>  	Opt_compress,
>  	Opt_witness,
> +	Opt_unicode,
>  
>  	/* Mount options which take numeric value */
>  	Opt_backupuid,
> @@ -296,6 +297,7 @@ struct smb3_fs_context {
>  	bool compress; /* enable SMB2 messages (READ/WRITE) de/compression */
>  	bool rootfs:1; /* if it's a SMB root file system */
>  	bool witness:1; /* use witness protocol */
> +	int unicode;
>  	char *leaf_fullpath;
>  	struct cifs_ses *dfs_root_ses;
>  	bool dfs_automount:1; /* set for dfs automount only */
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index c88e9657f47a..6a92db287843 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -529,6 +529,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>  	ctx->password = ses->password;
>  	ctx->sectype = ses->sectype;
>  	ctx->sign = ses->sign;
> +	ctx->unicode = ses->unicode;
>  
>  	/* UNC and paths */
>  	/* XXX: Use ses->server->hostname? */
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index abca214f923c..b0fb4a5c586d 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -1189,6 +1189,7 @@ struct smb_version_values smb1_values = {
>  	.cap_unix = CAP_UNIX,
>  	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
>  	.cap_large_files = CAP_LARGE_FILES,
> +	.cap_unicode = CAP_UNICODE,
>  	.signing_enabled = SECMODE_SIGN_ENABLED,
>  	.signing_required = SECMODE_SIGN_REQUIRED,
>  };
> -- 
> 2.20.1
> 
> 
