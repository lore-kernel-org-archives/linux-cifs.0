Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517235AC1C;
	Wed,  8 Apr 2026 05:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775626751; cv=none; b=g7oxeLuOE7zkN/+vVoRF+yx32r7mF0eyJm2CNFzkkLQAloWrDj54au1RxG2uGS5ke0aThq6dFs4vh8wwvyAjcGG3hojoSNGJRxIJkKJGTqvJDS6EFhvZBP5ILCFPMF6RTig1reL+TCx3tlmld+h7NUJCWtwmfg5QukxKjorjfzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775626751; c=relaxed/simple;
	bh=OkZvr+eCSst2bY3IG17Uk5qWPQqKNgOnupWO0q74pVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lymLWfSxJRBzAu9Ag5HY264rAGDjdmIPkiFz3v+x09ROsA0PwdgXNT2f1BKbi6Uze1RNH+RE3H6574nT8rIpl5uptm6seH8OjLp99SwtJ/EaFvPjUTmSfR9poyj9romVOC7d0csgVUbXUGoQFIFZRNJtEVWPh6LEcGo2iwOsieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejM+kWyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejM+kWyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D9AC19424;
	Wed,  8 Apr 2026 05:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775626751;
	bh=OkZvr+eCSst2bY3IG17Uk5qWPQqKNgOnupWO0q74pVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ejM+kWyA7B31Cy0GSrnTOym8PFt+eHbZLk+WWxr/pkUrgrqAqBJ2HahAyQYri9uJE
	 cHtEpPkeNZbt/nZVEesKsD2OU8ZhVdewN8H2q+KcWSerU6LEO/ZyUL8qZ8MVZ8l5cz
	 DFAYpRZgEnAs+qjg+VMuFzb1UUB5j38ME1wk9+gc=
Date: Wed, 8 Apr 2026 07:39:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org, stable <stable@kernel.org>
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
Message-ID: <2026040822-shortly-chump-8518@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>

On Wed, Apr 08, 2026 at 10:51:12AM +0800, ChenXiaoSong wrote:
> Sashiko reported another out-of-bounds issue:
> https://sashiko.dev/#/patchset/2026040635-banking-unsoiled-3250@gregkh
> 
> Should we add the following checks in check_wsl_eas()?
> 
> ```
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>         ea = (void *)((u8 *)rsp_iov->iov_base +
>                       le16_to_cpu(rsp->OutputBufferOffset));
>         end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
> +       if (ea + outlen > end)
> +               return -EINVAL;

Then you would miss any "first" structures here, as I think the for loop
catches this later on with the line:


> +
>         for (;;) {
>                 if ((u8 *)ea > end - sizeof(*ea))
>                         return -EINVAL;

That one, right?

Or am I misreading this?

Pointer math is "fun" :(

thanks,

greg k-h
