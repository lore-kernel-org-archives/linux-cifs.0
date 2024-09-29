Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4948CDD;
	Sun, 29 Sep 2024 22:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727647870; cv=none; b=nMEb4o6MU9lJQqzxF7lPTWsU9U49vj/hmeYltKQI1mm1mGeCeDqTyCNKHv6MgVD9/ad473iXosUscQPGcf+4mW93xONZ615FBjBIvvHh3o4f4xhhdcVwvEj4ON4JzczZ50CNXPQU0TZ+orEwsBt0wZW0K1uhA8leMhYDmjD928I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727647870; c=relaxed/simple;
	bh=QZvnrEc1Gx1llNZzCoBg8oyjH8IY/uuCywDKrum0vLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUzFphrUuIhmdJ6If4kEivahvzZ4JHewcxlF302wfhCJE+CeWx/FWDhu324gcRGrL1x36uHnuoZuB1J8zsFnUOerIzKW7E8HmouaPUlbivbbf/kMcLJr0c6ZjWcs1t/vNy+gGajMqWSCjWDW/EWCZvWtfSLheVxq0ZMme/5v4dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UW/FhEoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UW/FhEoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A10EC4CEC5;
	Sun, 29 Sep 2024 22:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727647868;
	bh=QZvnrEc1Gx1llNZzCoBg8oyjH8IY/uuCywDKrum0vLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UW/FhEohBlsSgmIwMhq0imcmJTydf23XnQ3bLrRQ1bHkHWT+fdOqI+G+ynDfY/9i8
	 fg4mtHDiRfff9XffHDeovo32jO/aNSEsJXUAfEsAIEYa0l5Q/LtoM3ErZiO7ktxCK7
	 isGx10YO50Qv1buGbpjJ+vRBf1nJQpFY4M460aKbuj9MQ2Ycqte6fdCRHulossW3kL
	 oAOFpHVId+F9nHohkcqqPUPtS5a+nyQnk13YTKvIXerB1R/+yoQk61BsLa2YWxRsp8
	 CzpOpcek1OBbYMKWy9qFllj96Y+iHyk1fD5vjotRvZxLLQspNKBlxM6l66HzkZT3qi
	 FoEsn//vPYP7w==
Received: by pali.im (Postfix)
	id 4730F872; Mon, 30 Sep 2024 00:11:03 +0200 (CEST)
Date: Mon, 30 Sep 2024 00:11:03 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] cifs: Improve creating native symlinks pointing to
 directory
Message-ID: <20240929221103.v4tpbj6pdwt44ld7@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-3-pali@kernel.org>
 <CAH2r5muBtrnwm4YXm_DuncR7bK68xwY3OP2GwV07-LEm-BPWTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muBtrnwm4YXm_DuncR7bK68xwY3OP2GwV07-LEm-BPWTw@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 29 September 2024 16:54:20 Steve French wrote:
> Here is a version of the same patch without the function rename (so
> presumably easier to backport) and also that fixes to minor checkpatch
> warnings (and merged this and also patches 3, 4 and 6 into
> cifs-2.6.git for-next pending additional review and tesitng):

That is fine for me. Just one minor nit suggestion.

> @@ -69,7 +192,8 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
>  	iov.iov_base = buf;
>  	iov.iov_len = len;
>  	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> -				     tcon, full_path, &iov, NULL);
> +					tcon, full_path, directory,
> +					&iov, NULL);

After reverting back the original function name, you can indent/align
arguments for all smb2_get_reparse_inode occurrences.

>  	if (!IS_ERR(new))
>  		d_instantiate(dentry, new);
>  	else
> @@ -137,7 +261,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
>  	};
>  
>  	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> -				     tcon, full_path, &iov, NULL);
> +					tcon, full_path, false, &iov, NULL);
>  	if (!IS_ERR(new))
>  		d_instantiate(dentry, new);
>  	else
> @@ -283,7 +407,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
>  	data.wsl.eas_len = len;
>  
>  	new = smb2_get_reparse_inode(&data, inode->i_sb,
> -				     xid, tcon, full_path,
> +					xid, tcon, full_path, false,
>  				     &reparse_iov, &xattr_iov);

Here the misaligning on + line is visible too.

>  	if (!IS_ERR(new))
>  		d_instantiate(dentry, new);
