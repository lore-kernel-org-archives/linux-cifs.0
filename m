Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E01219A2A3;
	Thu, 10 Oct 2024 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728596883; cv=none; b=UC9yPq6XvSseGyXtku2x1IoAyl84eSHx//R93f/Ldm3/+OdBmPHGObdI+6p8M1qrZwVa+KyOtUrsHjJhojyHqbv1LJa3OzfiS57qOTD1TN7b10Fg3j90L5iGMdd9ii/jE5OpXrKmMmPpMF6rigDZZRaiUulFzNzO0cDQcWG/7Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728596883; c=relaxed/simple;
	bh=D3yd35fLeb90DjNLh12oyZ8kgTZYfPyxEjgP6miBncE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHjkk3QySWPuPEtDR8yGEW9P0VVuem+lhFbrxdXy3DWNKmqoi4RskywqKx60kqAX0PKCLxtSQ6mTRHK0eMmoB5zdN5g3143DQOE2lQoEAsCse21OdL28nQfStYtZf90WBdq/77tq5n/IFE9Tw33rhYc34rbMhySQ7/A+uI/kdBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wsg4YFh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wsg4YFh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068ECC4CEC5;
	Thu, 10 Oct 2024 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728596883;
	bh=D3yd35fLeb90DjNLh12oyZ8kgTZYfPyxEjgP6miBncE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wsg4YFh+ljAFltwuxHGpYZ0/J2Rx69N3vXKL4EbTLn1jop1Bx4PRtyUxeem7F9kMs
	 Nfom7Id8t3kTYbowh7AnQDf2x7CrkYJOrqzajXoJAuZSETp4beOuCtfPfFDj1JstWK
	 BeV8/4ifNAFi4ZKBkVFin0e2mQH8/0v2KD4m8hB8qUMVDyBke9N8I6M84POzd7m2mu
	 JhmUm9DzfQcf0PLzkgFk57k9dAPdwdJNOH9BcDNrtjlwiqMANu9bR4GYLrJZPTiY5z
	 CnEEA+Zh7prpJCkCTx1NR99mRoRtePKDud26rugIxoQi0nNnhucW7Y70eL8EGtWN+Z
	 o4HwNRXkE2h6Q==
Received: by pali.im (Postfix)
	id BBC2381B; Thu, 10 Oct 2024 23:47:56 +0200 (CEST)
Date: Thu, 10 Oct 2024 23:47:56 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] cifs: Add support for creating native Windows sockets
Message-ID: <20241010214756.24pohg4dqbrntf6w@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241006100046.30772-4-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241006100046.30772-4-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Sunday 06 October 2024 12:00:42 Pali Rohár wrote:
> Native Windows sockets created by WinSock on Windows 10 April 2018 Update
> (version 1803) or Windows Server 2019 (version 1809) or later versions is
> reparse point with IO_REPARSE_TAG_AF_UNIX tag, with empty reparse point
> data buffer and without any EAs.
> 
> Create AF_UNIX sockets in this native format when -o reparse=native or
> -o reparse=native+<something> mount option is used.
> 
> This change makes AF_UNIX sockets created by Linux CIFS client compatible
> with AF_UNIX sockets created by Windows applications on NTFS volumes.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/cifsglob.h |  6 +++---
>  fs/smb/client/reparse.c  | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 7632d2ba5390..570b22d02f7e 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -155,9 +155,9 @@ enum securityEnum {
>  
>  enum cifs_reparse_type {
>  	CIFS_REPARSE_TYPE_NONE, /* disable creating new reparse points */
> -	CIFS_REPARSE_TYPE_NATIVE, /* native symlinks only */
> -	CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks, nfs for others */
> -	CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks, wsl for others */
> +	CIFS_REPARSE_TYPE_NATIVE, /* native symlinks and sockets only, no support for others */
> +	CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks/sockets, nfs for fifos/block/char */
> +	CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks/sockets, wsl for fifos/block/char */
>  	CIFS_REPARSE_TYPE_NFS, /* nfs for everything */
>  	CIFS_REPARSE_TYPE_WSL, /* wsl for everything */
>  	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NATIVE_NFS,
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 38fe0a710c65..f1488f870320 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -379,6 +379,35 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
>  	return 0;
>  }
>  
> +static int create_native_socket(const unsigned int xid, struct inode *inode,
> +				struct dentry *dentry, struct cifs_tcon *tcon,
> +				const char *full_path)
> +{
> +	struct cifs_open_info_data data = {
> +		.reparse_point = true,
> +		.reparse = { .tag = IO_REPARSE_TAG_AF_UNIX, },
> +	};
> +	struct reparse_data_buffer buf = {
> +		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
> +		.ReparseDataLength = 0,

Correctly, this should be:

  .ReparseDataLength = cpu_to_le16(0),

> +	};
> +	struct kvec iov = {
> +		.iov_base = &buf,
> +		.iov_len = sizeof(buf),
> +	};
> +	struct inode *new;
> +	int rc;

Here is missing initialization of rc:

  int rc = 0;

> +
> +	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> +				     tcon, full_path, false, &iov, NULL);
> +	if (!IS_ERR(new))
> +		d_instantiate(dentry, new);
> +	else
> +		rc = PTR_ERR(new);
> +	cifs_free_open_info(&data);
> +	return rc;
> +}
> +
>  static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
>  			       mode_t mode, dev_t dev,
>  			       struct kvec *iov)
> @@ -602,6 +631,13 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
>  {
>  	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
>  
> +	if (S_ISSOCK(mode) && (
> +	     ctx->reparse_type == CIFS_REPARSE_TYPE_NATIVE ||
> +	     ctx->reparse_type == CIFS_REPARSE_TYPE_NATIVE_NFS ||
> +	     ctx->reparse_type == CIFS_REPARSE_TYPE_NATIVE_WSL)) {
> +		return create_native_socket(xid, inode, dentry, tcon, full_path);
> +	}
> +
>  	switch (ctx->reparse_type) {
>  	case CIFS_REPARSE_TYPE_NATIVE_NFS:
>  	case CIFS_REPARSE_TYPE_NFS:
> -- 
> 2.20.1
> 
