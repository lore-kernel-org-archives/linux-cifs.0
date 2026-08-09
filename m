Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6041E0E14;
	Sun,  9 Aug 2026 12:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786277356; cv=none; b=GUfbOz+MBFde5xF4velj3Sil8/QefgiQ1dWsVho4ZruKZvPwH1dz74+ICY3wHQZKUEb8/u/fT7dMph5Wbwwxaq7FE9mi7MGovzhmmRLma7+xhQm5iEwszLLVHgER5iV1qktk0TivVa9hvM2vSb6lV+dffOr4gk8lC0msEiVAMMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786277356; c=relaxed/simple;
	bh=IqPdKGKQyYmNZaylBUAsnOsahOGj2I5gtdG1f7+uRtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTIVMGFmq+w1itSbYQhieRMeoHN5hyDgskkp0tekMofD/epoFp+tDR1jFfUN80JKs7EZyrr3xUyK9KlG/VR53bnqRr7sZsIEBlDTimQKc5Hq2CObPpuS1JKfpVYwa1EgCSfkGlTn+S32A7OlzYGgQw5KzDBwKpnjIpvK6h+dj4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTq1DEI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTq1DEI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466B11F000E9;
	Sun,  9 Aug 2026 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786277354;
	bh=8zSl3hWXbGg/nlZvaYT573A2vU65zYYRnJTK6P1QwZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KTq1DEI1uC75QqedTDY7FPPmY0QDlYxKWqNj/aZ6wZOoQjzsGgCkfthaEQDMsYoft
	 Njs2ibVcqkpmVSaS2EWCcueakbzryxPxQwIJzl1yPpZO2+5vLrtMqZKCfh3lMjG8Td
	 xycHO753b3gOh9SixBz39fSwpR8Or+wY3qndYAx/mMlT/7ZrCzQNv0v7mYgWCAW236
	 u+5YN/0legtEp46iOoV2K+49LZA7bK3qrRWD09JKo4pR3bOvqf++1ve2oxGW1bAo4f
	 CL3SR46I2IAC7jjaxxq6fHyy3fgZ5UPSIY60c3EHPVoEuPhaATc5zEPfCKOjd/lELt
	 ra4CZ2vU6xA0w==
Received: by pali.im (Postfix)
	id C016D7C6; Sun,  9 Aug 2026 14:09:13 +0200 (CEST)
Date: Sun, 9 Aug 2026 14:09:13 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 09/11] cifs: Create native Window socket file
 compatible also with WSL subsystem
Message-ID: <20260809120913.ohng2tilnv3dc6wo@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-10-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706184819.22124-10-pali@kernel.org>
User-Agent: NeoMutt/20180716

Just to note that this change depends on previous change:
08/11 cifs: Extend ->set_EA() callback to allow operate on reparse point

(without it, compile errors happens)

On Monday 06 July 2026 20:48:17 Pali Rohár wrote:
> After creating a native socket via the IO_REPARSE_TAG_AF_UNIX reparse
> point, try to set also the WSL EA $LXMOD.
> 
> This makes the native Win32 / NT socket file recognized also under
> WSL subsystem. WSL subsystem uses same reparse point tag but requires also
> to be EA $LXMOD set.
> 
> Fixes: 45a99d5d1173 ("cifs: Add support for creating native Windows sockets")
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index e2ea59a17c9c..50eeea127a42 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -384,7 +384,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
>  
>  static int create_native_socket(const unsigned int xid, struct inode *inode,
>  				struct dentry *dentry, struct cifs_tcon *tcon,
> -				const char *full_path)
> +				const char *full_path, umode_t mode)
>  {
>  	struct reparse_data_buffer buf = {
>  		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
> @@ -398,6 +398,10 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
>  		.iov_base = &buf,
>  		.iov_len = sizeof(buf),
>  	};
> +#ifdef CONFIG_CIFS_XATTR
> +	const __le64 xattr_mode_val = cpu_to_le64(mode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> +#endif
>  	struct inode *new;
>  	int rc = 0;
>  
> @@ -408,6 +412,28 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
>  		d_instantiate(dentry, new);
>  	else
>  		rc = PTR_ERR(new);
> +
> +	/*
> +	 * Try to set also optional WSL EA $LXMOD but ignore errors.
> +	 * WSL socket and native Win32/NT sockets uses same reparse point
> +	 * tag IO_REPARSE_TAG_AF_UNIX. WSL subsystem additionally requires
> +	 * EA $LXMOD to be set with the S_IFSOCK value. So setting this EA
> +	 * allows native socket to be recognized also by WSL subsystem.
> +	 * Note that setting of both EAs and reparse points is not supported
> +	 * by NTFS filesystem on Windows 8 / Windows Server 2012 and always
> +	 * fails. So ignore failures from this set_EA call.
> +	 */
> +#ifdef CONFIG_CIFS_XATTR
> +	if (!rc && tcon->ses->server->ops->set_EA &&
> +	    (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
> +		tcon->ses->server->ops->set_EA(xid, tcon, full_path,
> +					       true /* open reparse point */,
> +					       SMB2_WSL_XATTR_MODE,
> +					       &xattr_mode_val,
> +					       SMB2_WSL_XATTR_MODE_SIZE,
> +					       cifs_sb->local_nls, cifs_sb);
> +#endif
> +
>  	cifs_free_open_info(&data);
>  	return rc;
>  }
> @@ -717,7 +743,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
>  	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
>  
>  	if (S_ISSOCK(mode) && !ctx->nonativesocket && ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
> -		return create_native_socket(xid, inode, dentry, tcon, full_path);
> +		return create_native_socket(xid, inode, dentry, tcon, full_path, mode);
>  
>  	switch (ctx->reparse_type) {
>  	case CIFS_REPARSE_TYPE_NFS:
> -- 
> 2.20.1
> 
