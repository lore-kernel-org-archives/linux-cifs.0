Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9551BC58;
	Sun, 31 Aug 2025 09:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756633454; cv=none; b=Jh/s/MY0sB+38woU2/iCFPRXCLkwZBIgGwfIoulUiQnw+z9ai7sFa0paOtiwKq8tokBmpi39gnDl+xPRP0C3oiZnowE8mua2L6boKxAyf6aD3zJZKjE2ge8tU/Gmv37PBP1eLQ6eISDBDq1VuT+2dWhbFvR5nCXbYO4pR0/IFOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756633454; c=relaxed/simple;
	bh=gSoOfX9liPNKKFwXCdm/G8ev8WQe2y01AGSWbj35bn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCYkaxk0M9vtWQQ/lok2Jw33HnpYVffMkNdPgJGfvCmZmyEhGajs15twXkLwV2aRUrGzJwpXGwMkEzGT3x/8o3l0OHk2ckidjd/Vg5avAGSbDz7A8xtZV3vkBBs9KY637A8FJ4FA1/QmN4D4qet/HoeKqoMtVh2CZ4JQXT1Ru0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYkW2DyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYkW2DyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D42C4CEED;
	Sun, 31 Aug 2025 09:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756633454;
	bh=gSoOfX9liPNKKFwXCdm/G8ev8WQe2y01AGSWbj35bn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aYkW2DyNlVmgY/xWu/JaUKKYOsOGQ57K380l6IPiavzh+FqIbZzjpVAoX/+sB4zIw
	 1TA1YMQPb2LdRmKivP9JMlD6kJEiG1ymNNUkjrU2bs/JWZtDeKob3k26CRtCeATbJi
	 NookxlOyuUlFYn1Ije8oAFYFtOdST9sUeMi+JwIWu9TTY2arIy18iJ9njxT8EnfzSg
	 dPBpN5+JnSyeycllVInyz3pO8q/FmROlt9xNZtB8b+5uRGc2fT8Am+G2N0rbKbmEVt
	 Jzf1JDVonYhkbUUrW8/2WSJ6SNYzHi7uUB4eMw9RTD+DscSl6Ng6dsiohtpoUdwfuB
	 X5vGuM1iYukdA==
Received: by pali.im (Postfix)
	id 0C24F598; Sun, 31 Aug 2025 11:44:10 +0200 (CEST)
Date: Sun, 31 Aug 2025 11:44:10 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: Create native Window socket file compatible
 also with WSL subsystem
Message-ID: <20250831094410.igrsfze7ci5mxkla@pali>
References: <20250712161012.17622-1-pali@kernel.org>
 <20250712161012.17622-2-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250712161012.17622-2-pali@kernel.org>
User-Agent: NeoMutt/20180716

Hello, I would like to remind this change.

On Saturday 12 July 2025 18:10:12 Pali Rohár wrote:
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
>  fs/smb/client/reparse.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index ee4af153e7af..74a36957e8cb 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -381,7 +381,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
>  
>  static int create_native_socket(const unsigned int xid, struct inode *inode,
>  				struct dentry *dentry, struct cifs_tcon *tcon,
> -				const char *full_path)
> +				const char *full_path, umode_t mode)
>  {
>  	struct reparse_data_buffer buf = {
>  		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
> @@ -395,6 +395,8 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
>  		.iov_base = &buf,
>  		.iov_len = sizeof(buf),
>  	};
> +	const __le64 xattr_mode_val = cpu_to_le64(mode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct inode *new;
>  	int rc = 0;
>  
> @@ -405,6 +407,28 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
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
> @@ -714,7 +738,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
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
