Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAEB1B6D17;
	Fri, 15 Nov 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677618; cv=none; b=YukIPkW+JItU1DpGBrq7fQYEqtA9O86GJCdGHkqXhwAxsmcvNrUI9csQ8WSgj0tvflP320xaMJwRSRoQ2oEikZKPyE5S31uK7DXP0iNcSoQsgtZQ0ONNbivJBfhHtnWv2qu+PC8/GcaojV6cait0NBvpWiKHFBzO9FaCsah/lEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677618; c=relaxed/simple;
	bh=O7AJqffs68DOLGQWzdd0YzRLFkQqjrghXm6JMEarXJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWlwSr/BZ7sfywFGim8/uD3iBcqAJ1D2EPTjnFQBSbpYyG6nqW7KFmCV6I/VlKpgqVkPfgkbdFPqusW7+DHQqIa0tBDLvDFpo9wOXamAvJiybDWvwCR0CA59TmmrCATrphepDEJ6J83p5I4rw/CQud4+O3dMd27mCgwPCFo6oI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw6LxWQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw6LxWQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4D4C4CECF;
	Fri, 15 Nov 2024 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731677617;
	bh=O7AJqffs68DOLGQWzdd0YzRLFkQqjrghXm6JMEarXJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fw6LxWQ1b/zKsNwn96v7BTdZzS3OCRsfxBLWZy7sHu0VL4yunlhZSPMEpSgYnuPUw
	 DitEs6A83PvlSfxCkPJjI7x62L5uE+q7HvmKsRsq8k/U8SEUjO0wCeJ4+w0COP+yIT
	 VA0UDI/+V1aItuC/4YDDe77+OThmNiLoIf6LLCk6LSiXuSJEEhLwlMzAdL+4NNbyyx
	 0KkLGgBQV+Gd+7CZ3SYYnku7d1gYjNyLJEWcUDMdUPYKYM4S/6+WIxTRqkgCfldNjg
	 Pa/1iaDbIIKl0S0bVrlxLzWwSWlRMreCLplWUcUYkuecTsb6Y0+ixBWPRiarDKP8D/
	 HcT136dzbaiFw==
Received: by pali.im (Postfix)
	id 899659F1; Fri, 15 Nov 2024 14:33:29 +0100 (CET)
Date: Fri, 15 Nov 2024 14:33:29 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: =?utf-8?B?QmrDtnJu?= JACKE <bjacke@SerNet.DE>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cifs: Add new mount option -o nounicode to disable
 SMB1 UNICODE mode
Message-ID: <20241115133329.3ylyq5ufoqovbdv2@pali>
References: <20241028110340.29911-1-pali@kernel.org>
 <20241028110340.29911-2-pali@kernel.org>
 <20241115132619.GA581468@sernet.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241115132619.GA581468@sernet.de>
User-Agent: NeoMutt/20180716

Hello Björn, I know about iocharset=iso8859-1 mount option, but change
here is something different. As I wrote in the commit message it allows
to easily test that "non-unicode flag of SMB" code path implementation
in cifs.ko that works correctly. For example, thanks to this change I
was able to find few bugs (including parsing of symlinks) in that code
path and fixes for them are in this patch series.

On Friday 15 November 2024 14:26:19 Björn JACKE wrote:
> you can  simply use iocharset=iso8859-1 mount option if you want to get legacy
> charsets on the client side to work. I don't think that it's a good idea to
> mess with the ancient non-unicode flag of SMB.
> 
> Björn
> 
> On 2024-10-28 at 12:03 +0100 Pali Rohár sent off:
> > SMB1 protocol supports non-UNICODE (8-bit OEM character set) and
> > UNICODE (UTF-16) modes.
> > 
> > Linux SMB1 client implements both of them but currently does not allow to
> > choose non-UNICODE mode when SMB1 server announce UNICODE mode support.
> > 
> > This change adds a new mount option -o nounicode to disable UNICODE mode
> > and force usage of non-UNICODE (8-bit OEM character set) mode.
> > 
> > This allows to test non-UNICODE implementation of Linux SMB1 client against
> > any SMB1 server, including modern and recent Windows SMB1 server.
> > 
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/cifsfs.c     |  4 ++++
> >  fs/smb/client/cifsglob.h   |  2 ++
> >  fs/smb/client/cifssmb.c    |  5 ++++-
> >  fs/smb/client/connect.c    | 32 +++++++++++++++++++++++++++++---
> >  fs/smb/client/fs_context.c | 11 +++++++++++
> >  fs/smb/client/fs_context.h |  2 ++
> >  fs/smb/client/sess.c       |  1 +
> >  fs/smb/client/smb1ops.c    |  1 +
> >  8 files changed, 54 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index 1decf91d3f61..447ed7831f2c 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -611,6 +611,10 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
> >  					   cifs_sb->ctx->dir_mode);
> >  	if (cifs_sb->ctx->iocharset)
> >  		seq_printf(s, ",iocharset=%s", cifs_sb->ctx->iocharset);
> > +	if (tcon->ses->unicode == 0)
> > +		seq_puts(s, ",nounicode");
> > +	else if (tcon->ses->unicode == 1)
> > +		seq_puts(s, ",unicode");
> >  	if (tcon->seal)
> >  		seq_puts(s, ",seal");
> >  	else if (tcon->ses->server->ignore_signature)
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index dcee43889358..2f77b558abe8 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -651,6 +651,7 @@ struct smb_version_values {
> >  	unsigned int	cap_unix;
> >  	unsigned int	cap_nt_find;
> >  	unsigned int	cap_large_files;
> > +	unsigned int	cap_unicode;
> >  	__u16		signing_enabled;
> >  	__u16		signing_required;
> >  	size_t		create_lease_size;
> > @@ -1124,6 +1125,7 @@ struct cifs_ses {
> >  	bool sign;		/* is signing required? */
> >  	bool domainAuto:1;
> >  	bool expired_pwd;  /* track if access denied or expired pwd so can know if need to update */
> > +	int unicode;
> >  	unsigned int flags;
> >  	__u16 session_flags;
> >  	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
> > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > index c6f15dbe860a..6218b59b9da7 100644
> > --- a/fs/smb/client/cifssmb.c
> > +++ b/fs/smb/client/cifssmb.c
> > @@ -423,7 +423,10 @@ CIFSSMBNegotiate(const unsigned int xid,
> >  		return rc;
> >  
> >  	pSMB->hdr.Mid = get_next_mid(server);
> > -	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
> > +	pSMB->hdr.Flags2 |= SMBFLG2_ERR_STATUS;
> > +
> > +	if (ses->unicode != 0)
> > +		pSMB->hdr.Flags2 |= SMBFLG2_UNICODE;
> >  
> >  	if (should_set_ext_sec_flag(ses->sectype)) {
> >  		cifs_dbg(FYI, "Requesting extended security\n");
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 612816ec71f5..3d9d736b6e58 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -2338,6 +2338,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
> >  	ses->cred_uid = ctx->cred_uid;
> >  	ses->linux_uid = ctx->linux_uid;
> >  
> > +	ses->unicode = ctx->unicode;
> >  	ses->sectype = ctx->sectype;
> >  	ses->sign = ctx->sign;
> >  	ses->local_nls = load_nls(ctx->local_nls->charset);
> > @@ -3928,7 +3929,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
> >  		   struct TCP_Server_Info *server,
> >  		   struct nls_table *nls_info)
> >  {
> > -	int rc = -ENOSYS;
> > +	int rc = 0;
> >  	struct TCP_Server_Info *pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
> >  	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&pserver->dstaddr;
> >  	struct sockaddr_in *addr = (struct sockaddr_in *)&pserver->dstaddr;
> > @@ -3980,6 +3981,26 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
> >  		if (!linuxExtEnabled)
> >  			ses->capabilities &= (~server->vals->cap_unix);
> >  
> > +		/*
> > +		 * Check if the server supports specified encoding mode.
> > +		 * Zero value in vals->cap_unicode indidcates that chosen
> > +		 * protocol dialect does not support non-UNICODE mode.
> > +		 */
> > +		if (ses->unicode == 1 && server->vals->cap_unicode != 0 &&
> > +		    !(server->capabilities & server->vals->cap_unicode)) {
> > +			cifs_dbg(VFS, "Server does not support mounting in UNICODE mode\n");
> > +			rc = -EOPNOTSUPP;
> > +		} else if (ses->unicode == 0 && server->vals->cap_unicode == 0) {
> > +			cifs_dbg(VFS, "Server does not support mounting in non-UNICODE mode\n");
> > +			rc = -EOPNOTSUPP;
> > +		} else if (ses->unicode == 0) {
> > +			/*
> > +			 * When UNICODE mode was explicitly disabled then
> > +			 * do not announce client UNICODE capability.
> > +			 */
> > +			ses->capabilities &= (~server->vals->cap_unicode);
> > +		}
> > +
> >  		if (ses->auth_key.response) {
> >  			cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
> >  				 ses->auth_key.response);
> > @@ -3992,8 +4013,12 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
> >  	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
> >  		 server->sec_mode, server->capabilities, server->timeAdj);
> >  
> > -	if (server->ops->sess_setup)
> > -		rc = server->ops->sess_setup(xid, ses, server, nls_info);
> > +	if (!rc) {
> > +		if (server->ops->sess_setup)
> > +			rc = server->ops->sess_setup(xid, ses, server, nls_info);
> > +		else
> > +			rc = -ENOSYS;
> > +	}
> >  
> >  	if (rc) {
> >  		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
> > @@ -4063,6 +4088,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
> >  	ctx->seal = master_tcon->seal;
> >  	ctx->witness = master_tcon->use_witness;
> >  	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
> > +	ctx->unicode = master_tcon->ses->unicode;
> >  
> >  	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
> >  	if (rc) {
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 7dd46cfc9fb3..d970b66e529c 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -127,6 +127,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
> >  	fsparam_flag("rootfs", Opt_rootfs),
> >  	fsparam_flag("compress", Opt_compress),
> >  	fsparam_flag("witness", Opt_witness),
> > +	fsparam_flag_no("unicode", Opt_unicode),
> >  
> >  	/* Mount options which take uid or gid */
> >  	fsparam_uid("backupuid", Opt_backupuid),
> > @@ -930,6 +931,10 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
> >  		cifs_errorf(fc, "can not change iocharset during remount\n");
> >  		return -EINVAL;
> >  	}
> > +	if (new_ctx->unicode != old_ctx->unicode) {
> > +		cifs_errorf(fc, "can not change unicode during remount\n");
> > +		return -EINVAL;
> > +	}
> >  
> >  	return 0;
> >  }
> > @@ -1520,6 +1525,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
> >  		ctx->witness = true;
> >  		pr_warn_once("Witness protocol support is experimental\n");
> >  		break;
> > +	case Opt_unicode:
> > +		ctx->unicode = !result.negated;
> > +		cifs_dbg(FYI, "unicode set to %d\n", ctx->unicode);
> > +		break;
> >  	case Opt_rootfs:
> >  #ifndef CONFIG_CIFS_ROOT
> >  		cifs_dbg(VFS, "rootfs support requires CONFIG_CIFS_ROOT config option\n");
> > @@ -1816,6 +1825,8 @@ int smb3_init_fs_context(struct fs_context *fc)
> >  	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
> >  	ctx->nonativesocket = 0;
> >  
> > +	ctx->unicode = -1; /* autodetect, but prefer UNICODE mode */
> > +
> >  /*
> >   *	short int override_uid = -1;
> >   *	short int override_gid = -1;
> > diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> > index 18d39d457145..1514e05e6629 100644
> > --- a/fs/smb/client/fs_context.h
> > +++ b/fs/smb/client/fs_context.h
> > @@ -127,6 +127,7 @@ enum cifs_param {
> >  	Opt_multichannel,
> >  	Opt_compress,
> >  	Opt_witness,
> > +	Opt_unicode,
> >  
> >  	/* Mount options which take numeric value */
> >  	Opt_backupuid,
> > @@ -296,6 +297,7 @@ struct smb3_fs_context {
> >  	bool compress; /* enable SMB2 messages (READ/WRITE) de/compression */
> >  	bool rootfs:1; /* if it's a SMB root file system */
> >  	bool witness:1; /* use witness protocol */
> > +	int unicode;
> >  	char *leaf_fullpath;
> >  	struct cifs_ses *dfs_root_ses;
> >  	bool dfs_automount:1; /* set for dfs automount only */
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index c88e9657f47a..6a92db287843 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -529,6 +529,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
> >  	ctx->password = ses->password;
> >  	ctx->sectype = ses->sectype;
> >  	ctx->sign = ses->sign;
> > +	ctx->unicode = ses->unicode;
> >  
> >  	/* UNC and paths */
> >  	/* XXX: Use ses->server->hostname? */
> > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > index abca214f923c..b0fb4a5c586d 100644
> > --- a/fs/smb/client/smb1ops.c
> > +++ b/fs/smb/client/smb1ops.c
> > @@ -1189,6 +1189,7 @@ struct smb_version_values smb1_values = {
> >  	.cap_unix = CAP_UNIX,
> >  	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
> >  	.cap_large_files = CAP_LARGE_FILES,
> > +	.cap_unicode = CAP_UNICODE,
> >  	.signing_enabled = SECMODE_SIGN_ENABLED,
> >  	.signing_required = SECMODE_SIGN_REQUIRED,
> >  };
> > -- 
> > 2.20.1
> > 
> > 
