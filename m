Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A401F2384;
	Tue,  7 Jan 2025 20:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736281467; cv=none; b=OX9ajXTHb6OzBkimUZY/+Gs0ArFQ1JKHhaNofS97+aNkA4qFTTtwAhjeBqjYggJ8OvfavYbyzHwmJG1M42SKl/G1Z/FIprjXcJw00yT2a3uyNxBBYnQ0sGaOhUub+nMYSWXYqchwXmgT2xckin5muWExpLXykKuWUv2rsAcrENY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736281467; c=relaxed/simple;
	bh=j5VmwBlEF/J26s3L5ZSV/k29majKv/wLO9yOgUzHePE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AV4ztVKarIgJwHCHyv6/vPsVUAS4Jcicv5hnYnUcWaC4HErQgdrIck6HbG+meZJwklUsKC4SV2tlnZirF7ZASObP6SoXo3tiBsjJrwr+1MZ5J6NCsRQDwjwgxRIXZhz5X8nQVfeGM8KNltQuaR9NIR1OfW8Eyq9feWea/HFaUjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tv2KbLmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tv2KbLmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DBBC4CED6;
	Tue,  7 Jan 2025 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736281467;
	bh=j5VmwBlEF/J26s3L5ZSV/k29majKv/wLO9yOgUzHePE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tv2KbLmnt95vaZLQS+xvR/7GYApkjoqpPFBYYYeAiG2Vnoms1hJ/IP0d4JE/YNBQM
	 dGRkgpya61PcpA/cHPTPZvIg8SbnQWHYu+bzWpWKBfSTxOxTL1pWz5nH/MBZPFxehq
	 6FsWuVsfn8Ch5VhjK4FkvizYuxEDurk/VWqfj4xb7q1F59BxcdxCvDs48us/xX+etP
	 rkvT5dqHLKrboFYze3hZHZXS2BcsIo4jzDswHVgfPWdQvCGtJf6X6JCETaXCBQeNO9
	 /76FcIh6tlVHwjdb3cexEDcbNK8txmysLWMzmjhRiAi7LrjFarDuNbnHTjFhP4YxnH
	 Dl04MB7LTJa2g==
Received: by pali.im (Postfix)
	id 345C17D5; Tue,  7 Jan 2025 21:24:16 +0100 (CET)
Date: Tue, 7 Jan 2025 21:24:16 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cifs: Fix getting reparse points from servers without
 EAs support
Message-ID: <20250107202416.6z4bw5wdgjnymkjg@pali>
References: <20241224131859.3457-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241224131859.3457-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

Hello, do you have any comments for this fix?

On Tuesday 24 December 2024 14:18:59 Pali Rohár wrote:
> If SMB server does not support EAs then for SMB2_OP_QUERY_WSL_EA request it
> returns STATUS_EAS_NOT_SUPPORTED. Function smb2_compound_op() translates
> STATUS_EAS_NOT_SUPPORTED to -EOPNOTSUPP which cause failure during calling
> lstat() syscall from userspace on any reparse point, including Native SMB
> symlink (which does not use any EAs).
> 
> If SMB server does not support to attach both EAs and Reparse Point to path
> at the same time then same error STATUS_EAS_NOT_SUPPORTED is returned. This
> is the case for Windows 8 / Windows Server 2012. It is known limitation of
> NTFS driver in those older Windows versions.
> 
> Since commit ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> Linux SMB client always ask for EAs on detected reparse point paths due to
> support of WSL EAs. But this commit broke reparse point support for all
> older Windows SMB servers which do not have support for WSL and WSL EAs.
> 
> Avoid this problem by retrying the request without SMB2_OP_QUERY_WSL_EA
> when it fails on -EOPNOTSUPP error.
> 
> This should fix broken support for all special files (symlink, fifo,
> socket, block and char) for SMB server which do not support EAs at all and
> for SMB server which do not allow to attach both EAs and Reparse Point at
> the same time.
> 
> Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/smb2inode.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index e8bb3f8b53f1..58276434e47b 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -875,6 +875,7 @@ int smb2_query_path_info(const unsigned int xid,
>  	bool islink;
>  	int i, num_cmds = 0;
>  	int rc, rc2;
> +	bool skip_wsl_ea;
>  
>  	data->adjust_tz = false;
>  	data->reparse_point = false;
> @@ -943,7 +944,13 @@ int smb2_query_path_info(const unsigned int xid,
>  		if (rc || !data->reparse_point)
>  			goto out;
>  
> -		if (!tcon->posix_extensions)
> +		skip_wsl_ea = false;
> +retry_cmd:
> +		/*
> +		 * Skip SMB2_OP_QUERY_WSL_EA if using POSIX extensions or
> +		 * retrying request with explicitly skipping for WSL EAs.
> +		 */
> +		if (!tcon->posix_extensions && !skip_wsl_ea)
>  			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
>  		/*
>  		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
> @@ -961,6 +968,35 @@ int smb2_query_path_info(const unsigned int xid,
>  		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
>  				      &oparms, in_iov, cmds, num_cmds,
>  				      cfile, NULL, NULL, NULL);
> +		if (rc == -EOPNOTSUPP && !tcon->posix_extensions && !skip_wsl_ea) {
> +			/*
> +			 * Older Windows versions do not allow to set both EAs
> +			 * and Reparse Point as the same time. This is known
> +			 * limitation of older NTFS driver and it was fixed in
> +			 * Windows 10. Trying to query EAs on file which has
> +			 * Reparse Point set ends with STATUS_EAS_NOT_SUPPORTED
> +			 * error, even when server filesystem supports EAs.
> +			 * This error is translated to errno -EOPNOTSUPP.
> +			 * So in this case retry the request again without EAs.
> +			 */
> +			skip_wsl_ea = true;
> +			num_cmds = 1;
> +			goto retry_cmd;
> +		}
> +		if (rc == 0 && skip_wsl_ea &&
> +		    (data->reparse.tag == IO_REPARSE_TAG_LX_CHR ||
> +		     data->reparse.tag == IO_REPARSE_TAG_LX_BLK)) {
> +			/*
> +			 * WSL CHR and BLK reparse points store major and minor
> +			 * device numbers in EAs (instead of reparse point buffer,
> +			 * like it is for WSL symlink or NFS reparse point types).
> +			 * Therefore with skipped EAs it is not possible to finish
> +			 * query of these files. So change error back to the
> +			 * original -EOPNOTSUPP.
> +			 */
> +			rc = -EOPNOTSUPP;
> +		}
> +
>  		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
>  			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
>  			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
> -- 
> 2.20.1
> 
