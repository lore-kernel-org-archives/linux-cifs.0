Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1F4167DAC
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733769596; cv=none; b=gIn9KPYn4UAiWeYqr8Stm6e8DiEmQDR3jChR/IzcOCRC1N66/vwJYPQrtd47MNgbeFA9dpWZu43m5K5Ha4yDYNiTbw6LsAq9Nq95TnNWajD/KjOvIlPZ/xXd0pGBYcXx1jsM9yO7Vpx0VkMTI7sbh3s2chcdPhb/p38KhuYwGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733769596; c=relaxed/simple;
	bh=5zLexGgNQW8FW3zzPwoHFGKKnkKPbtWfYN57yqJYcEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6abjTMeTN4MrGRblGweHJdR1l1y+Bhy4DGw8fOdolqbdu5uc/LzikZZVTX/Y4J2xNydeVLhoa+yOxx0Zu/MzQvwKYzepgwTb5oZJTVR/h+ywf7kAAjByOAbEO8ulzxB8N973wiOku5QBwsrWeTYTD/kTVgoaWCyh001g2KHGpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPzo9qjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPzo9qjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA8FC4CED1;
	Mon,  9 Dec 2024 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733769596;
	bh=5zLexGgNQW8FW3zzPwoHFGKKnkKPbtWfYN57yqJYcEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LPzo9qjmFE+J8n0fJ8Oq38E5B8xxejMSGuCJaL8B+bUUFtoi+AKtTcdIGjizEg+Ew
	 p/UpuXXgYJzZt4iNgKfSXnD2H3H44yoadu1qmxYp/Na8plhz9fzluDfDytq4fq7r4H
	 T7ykcjZoo5LqqB6lHAs1EJIzcO5b9N640AFv4KEtrNnAXb5mTFGJNKnHb5vPoGv15P
	 7qOI9/i9bJ23rQGjiGYBWPxWhutv4WeKyq5M+YI9WkljNsMrhLZjrOz/dGsLgVkhlp
	 YiDIPxvJX46+zvuwvSTA1Xpd5j7a/5rr+eAB96KO9e14MrUniz1XdlrKPKOxei6+R8
	 Rprk/FhsWlviA==
Received: by pali.im (Postfix)
	id E18E78A0; Mon,  9 Dec 2024 19:39:46 +0100 (CET)
Date: Mon, 9 Dec 2024 19:39:46 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>,
	Steven French <Steven.French@microsoft.com>,
	Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
Message-ID: <20241209183946.yafga2vixfdx5edu@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
User-Agent: NeoMutt/20180716

Hello, this patch is incomplete and still does not fix the main problem
that SMB2_OP_QUERY_WSL_EA command does not work with any Windows SMB
server except the last Windows Server version. On non-recent Windows
versions it is not possible to set both EAs and reparse point at the
same time and Windows SMB server is returning error when trying to query
EAs on file with reparse point.

Which basically means that it is not possible to query data about the
special files from Windows SMB server (except 2022 version).

More details are in the email which I wrote in September:
https://lore.kernel.org/linux-cifs/20240928140939.vjndryndfngzq7x4@pali/

I proposed similar but extended patch which skips asking for EAs based
on reparse point:
https://lore.kernel.org/linux-cifs/20240913200204.10660-1-pali@kernel.org/

But it was somehow rejected as the proper solution should be different:
https://lore.kernel.org/linux-cifs/20240917210707.4lt4obty7wlmm42j@pali/

And that is why I'm surprised that the batch below was accepted...

Are you planning to implement a proper solution? If not that I would
propose to reconsider my original idea, which will workaround also
Windows SMB server, and not only Samba server.

As I wrote in previous emails, I think that this is a serious issue as
it disallow to use any reparse points against non-recent Windows Server
systems.

On Wednesday 27 November 2024 20:23:29 Ralph Boehme wrote:
> From a57c32da874f285af266b7fbbaefb7940991d049 Mon Sep 17 00:00:00 2001
> From: Ralph Boehme <slow@samba.org>
> Date: Fri, 15 Nov 2024 13:15:50 +0100
> Subject: [PATCH 1/3] fs/smb/client: avoid querying SMB2_OP_QUERY_WSL_EA for
>  SMB3 POSIX
> 
> ---
>  fs/smb/client/smb2inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index e49d0c25eb03..ab069d5285c5 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -941,7 +941,8 @@ int smb2_query_path_info(const unsigned int xid,
>  		if (rc || !data->reparse_point)
>  			goto out;
>  
> -		cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
> +		if (!tcon->posix_extensions)
> +			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
>  		/*
>  		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
>  		 * response.
> -- 
> 2.47.0
