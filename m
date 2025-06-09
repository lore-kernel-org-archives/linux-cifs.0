Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548773D544;
	Mon,  9 Jun 2025 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749454614; cv=none; b=dnD67tTu6bxyas4ckYvoMgWpQ0ORROhCE/Rn418znwlp5UO+XRSBHYssLlHwwprVnYlXt8pptQmc/9rNeOY12P3Ob1FKklYVir6B+gn4Om1Kg798SrlKzEZtVA+/dKP/xoTOIVQCqOJmjzR6YEe96rnz2Cqz2r1NUZ9b1ayEJyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749454614; c=relaxed/simple;
	bh=QD50IMlcQ1GH3mNhqbad601Rfmh7cADft1xxz1dg+Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEOcuftFzE6XVgRudczx+3+ijwmkDk/a3KVn0y2gvaXn9jJsjWszYm+Ig4hZpymsJeul+CJXDfENFL0M3Hqy2P6YVmITyG/3OOxRtmarLBdQr/yIWWVyGcH2ENvBq2h/Ez8Tv2SWPQRgNn21OsYtDPqQKk2grLZl3NNOdZGKzVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHxXgC+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHxXgC+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B0EC4CEEB;
	Mon,  9 Jun 2025 07:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749454613;
	bh=QD50IMlcQ1GH3mNhqbad601Rfmh7cADft1xxz1dg+Ec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rHxXgC+5F2HM0tZIbnla8noPw3L5U6rSmRemUD4oLRGCnA0FlSX1BgciaLKbluQa/
	 JXloYkwGODTxdB8CpiugLkZsQZoyt7Vno3NWw7iYubuFD9r3RJBDF4PzfffFNfBYtv
	 tXgK/NBeOb/9DUo/DIfIhnBHrl0g/wFHoagGAxpKG2xrBLNCp8Ubz8JGw7Irm3M0Kr
	 68du+HTjWq58+UhOC+j34JWnnu5qpLltYN3DWmIKZ+G/bFqXXz6nh5TSzzn4fX2i/e
	 QNq0Vx3pt6JibJul37e0GdSISpAsYKpKh7IFElF+TKMT/S4fPcQEuSo7Nmn+Ri4BlL
	 eqHnrL0MR6txw==
Received: by pali.im (Postfix)
	id D14D2C75; Mon,  9 Jun 2025 09:36:50 +0200 (CEST)
Date: Mon, 9 Jun 2025 09:36:50 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Show reason why autodisabling serverino support
Message-ID: <20250609073650.kj6lxrykguhb7nuo@pali>
References: <20250608164453.6699-1-pali@kernel.org>
 <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
 <CAH2r5muuanOgjzQ8wgd+QoyrU_ZM4tATrfYYQj=b7MapGLMh5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muuanOgjzQ8wgd+QoyrU_ZM4tATrfYYQj=b7MapGLMh5A@mail.gmail.com>
User-Agent: NeoMutt/20180716

cifs_autodisable_serverino() is already printing at the VFS level
information that it is disabling the serverino. It is one time thing as
once it is disabled, it is not printing it second time. So it does not
flood logs.

In this change I have just extended this existing logging to print also reason.

On Sunday 08 June 2025 22:40:21 Steve French wrote:
> Since this could flood logs (e.g. in some DFS cases), probably better
> to do these via the usual dynamic trace points (and can document a
> simple "trace-cmd -e smb3_disable_serverino" script to avoid risk of
> flooding logs.    cifsFYI is an alternative but the world has moved to
> the dynamic tracing (eBPF etc.)
> 
> On Sun, Jun 8, 2025 at 3:57 PM Paulo Alcantara <pc@manguebit.org> wrote:
> >
> > Pali Rohár <pali@kernel.org> writes:
> >
> > > Before calling cifs_autodisable_serverino() function, show reason why it
> > > has to be called.
> > >
> > > This change allows to debug issues why cifs.ko decide to turn off server
> > > inode number support and hence disable support for detection of hardlinks.
> > >
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  fs/smb/client/connect.c   | 2 ++
> > >  fs/smb/client/dfs_cache.c | 2 ++
> > >  fs/smb/client/inode.c     | 3 +++
> > >  fs/smb/client/readdir.c   | 3 +++
> > >  4 files changed, 10 insertions(+)
> >
> > NACK.
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
