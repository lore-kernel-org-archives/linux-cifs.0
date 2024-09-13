Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD57A146593;
	Fri, 13 Sep 2024 20:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726258246; cv=none; b=CU3NpvKb7PCanVet1oRSjo0vh+Q79+/83KNVgTjYRk4MEhBox6igp8IQa86L6ev/KEXYm3tkocrpJ8/79nshjxQvLQ3Esi/AODyztlyGPhvBGLdu0tPWgooj1Dm3e1CyirRLawt89VCp2TJUcdq1eUjwoEpNJXnxzokoVFg+FZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726258246; c=relaxed/simple;
	bh=el57stphE57P23fGPJ9GNRj8pJO3kkwQwz6c6LYQ4Pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbmBzAwQXM5Kla4afi01Iqv2JH9LkYGDW6O0p85Eie/EyeN6jzjIt8N97VYbCpZFWn6f7JzSTmUeFTR053fIeTExtZdX4k3ClNs8UMSU2gvbE+6rCHVtFVHBq5WdKq3CsQQVGrTGQ5nDswOpIXij3BbH/ykBEN9Ye5FBsDllq1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDQnthqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDQnthqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A754C4CEC0;
	Fri, 13 Sep 2024 20:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726258246;
	bh=el57stphE57P23fGPJ9GNRj8pJO3kkwQwz6c6LYQ4Pc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MDQnthqSJ37cmmadtQXjmxxeWDhenpK1Is/pcI5oiZ2hRPv1BftNDw0bixt6aa5lq
	 H2uJHAiAxn79hqfQUZT2Ry8Yr7scAKIPGiqmiNyZGAo+B8Apwl7vAbJp7Lwhfz1oZH
	 LyTvFvmFkdMl4FT2OPphfe7qgS+6zjrzImVkVRxHlzBQ/aR23g2WgtpsCwpcbdz6ig
	 hZs0Xqt481VLSlsgmzIOBUSmxAHqDUpxR+uBOCAUJE1xcNOSNBo3d8kvOCsU9oQSjt
	 oR0UkMlCrUDNoA0YWr5prNA6Bfr/6eu6V3iBGEicABYgLyv2SwJlqJ1cvprZ0fuE8c
	 bFtSdgA5Sbi5A==
Received: by pali.im (Postfix)
	id 378FA725; Fri, 13 Sep 2024 22:10:41 +0200 (CEST)
Date: Fri, 13 Sep 2024 22:10:41 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240913201041.cwueaflcxhewnvwj@pali>
References: <20240913200204.10660-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240913200204.10660-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

Paulo, please look at this patch as it is related to WSL attributes
which you introduced in the mentioned commit. I think that the proper
fix should be to change SMB2_OP_QUERY_WSL_EA code to not trigger that
-EOPNOTSUPP error which is delivered to userspace. I just checked that
this my patch works fine for Native NTFS symlinks and NFS-style reparse
point special files.

On Friday 13 September 2024 22:02:04 Pali Rohár wrote:
> If SMB server does not support WSL EAs then for SMB2_OP_QUERY_WSL_EA
> request it returns STATUS_EAS_NOT_SUPPORTED. Function smb2_compound_op()
> translates STATUS_EAS_NOT_SUPPORTED to -EOPNOTSUPP which cause failure
> during calling lstat() syscall from userspace on any reparse point,
> including Native SMB symlink (which does not use any EAs). This issue
> happen for example when trying to resolve Native NTFS symlink from SMB
> server on Windows 8.
> 
> Avoid this problem by calling SMB2_OP_QUERY_WSL_EA only when detected
> reparse point is of WSL type. Note that this is not solve this problem
> fully as WSL reparse points can be created also on other SMB server
> which do not support Extended Attributes at all.
> 
> Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/smb2inode.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 11a1c53c64e0..d65471aa55e6 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -941,7 +941,20 @@ int smb2_query_path_info(const unsigned int xid,
>  		if (rc || !data->reparse_point)
>  			goto out;
>  
> -		cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
> +		/*
> +		 * Skip SMB2_OP_QUERY_WSL_EA if reparse point is not WSL.
> +		 * The server file system does not have to support Extended
> +		 * Attributes and in this case returns STATUS_EAS_NOT_SUPPORTED
> +		 * which smb2_compound_op() translate to -EOPNOTSUPP. This will
> +		 * present failure during reading of non-WSL special files.
> +		 */
> +		if (data->reparse.tag == IO_REPARSE_TAG_LX_SYMLINK ||
> +		    data->reparse.tag == IO_REPARSE_TAG_AF_UNIX ||
> +		    data->reparse.tag == IO_REPARSE_TAG_LX_FIFO ||
> +		    data->reparse.tag == IO_REPARSE_TAG_LX_CHR ||
> +		    data->reparse.tag == IO_REPARSE_TAG_LX_BLK)
> +			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
> +
>  		/*
>  		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
>  		 * response.
> -- 
> 2.20.1
> 
