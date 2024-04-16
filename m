Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686A974437
	for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2024 12:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271256; cv=none; b=GB7XiqHyTcTgCJYSo0xiPQ5N9zsMWHtCavfy4t9H0L0PicuYLYJiJipqlx3dkrha5r2h98sJ2jxUL0ypNUjDWLX9Yh8KH2ypUFE9cpQ32lIs7yvHZbRFTxoLUMVA4fqzd6l1XGQtWPeNcgFTyR5DzCKpa+2imtPzZezAXdUrDbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271256; c=relaxed/simple;
	bh=JJabWy6D9tHnLkvybQYkFr6QJhPWzpKHWVKmR0Z0AOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X0Xlbxtv59/mBXsAtFEgqgc69Soa6/J6vmsE5HhrfMpdxxJ4OCzen24VMjcUY2PVRAixsmbGpV7PGs30QioXOfxDd4z5CPRYc9pMNOX/SrEGP1L3BR6lWX0v+Bx7qe7iE4TG7CBLtZh2yDtRGFaDW2+G+3JcbxTDcRusUVP5W1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lG5eLmpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lG5eLmpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAB4C3277B
	for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2024 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713271256;
	bh=JJabWy6D9tHnLkvybQYkFr6QJhPWzpKHWVKmR0Z0AOA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lG5eLmpk5rhRnOk0gNuT6pJ9oUuy9t79vPQo8sglFOaNGA1JnUCqlbX5n98s8ijhd
	 h0PQxen2P98IQzyZahXM5QNTVOD24wK56lHAZibK+VF6uCqYW6SuZTBAkISJoAbS6R
	 Of5vBIg0dJCNmnyQjx/tuoY8OkMOgk5nx0hbznaWa36uMhUNCZPIbna/IRmsq6+Qd/
	 SaNyoJRsnmvHanBHeL2eMC9+zNiOfZ/d+qtb+PEroEYx20wpfeQ6k7ay74fqaeE9n4
	 ATyXGaf3pqWmTGmM2JGn9xWTL4a7qYpFTAaR5w3USwPQBw+B0kXGJLeOByyhFv37q5
	 bgjITcN9Audjg==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-22f01274622so2821991fac.1
        for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2024 05:40:55 -0700 (PDT)
X-Gm-Message-State: AOJu0YySF2zDzOQx/DpCJxKMMH/PRwAksADPBqaWxCxTTf5VSVUZ26io
	ypY98Q9PLmNgMokLP03MLJRin0zSimMsYF3IqhW/+e0x/9Jm20CiNwNzHpz94ZNcrPBGuspfX6X
	UG6bJmMUke3a4q/VEsu/MNNDBHyY=
X-Google-Smtp-Source: AGHT+IFZEIPpaxGcjsM29bTxpv4vSPiy/L+jPC5SveIR69bMee+W/mcwgBBvOA8ocvLPD828RXj2VRj6Q7DP1OwjdRI=
X-Received: by 2002:a05:6871:294:b0:233:60e7:52bf with SMTP id
 i20-20020a056871029400b0023360e752bfmr16111715oae.50.1713271255268; Tue, 16
 Apr 2024 05:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKYAXd_8b00geiawuUQ3F4htQvucjH7KGpbOFV1Js7Pwf-JQig@mail.gmail.com>
 <20240415131247.2162106-1-mmakassikis@freebox.fr>
In-Reply-To: <20240415131247.2162106-1-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 16 Apr 2024 21:40:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_be_Jwm0VejViiC9Zcc8CR7ULRVsczrhaxusJNV4tZSA@mail.gmail.com>
Message-ID: <CAKYAXd_be_Jwm0VejViiC9Zcc8CR7ULRVsczrhaxusJNV4tZSA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 4=EC=9B=94 15=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 10:13, =
Marios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> File overwrite case is explicitly handled, so it is not necessary to
> pass RENAME_NOREPLACE to vfs_rename.
>
> Clearing the flag fixes rename operations when the share is a ntfs-3g
> mount. The latter uses an older version of fuse with no support for
> flags in the ->rename op.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
