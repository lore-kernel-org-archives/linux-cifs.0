Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081E020EB;
	Tue, 10 Jun 2025 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749574559; cv=none; b=hjOQYpOyv9JTvZZG3MhqlFGeFXX0RkaPQ0c57iGSkYvDKjG+tWoBf1w64PuCl8npbDrS00h79l2/6crrjdzgSK0kiSGHAhTvYFh9/7CI8sS1V3Cdmt+kYf6+cuSA1EpzH2J+K5LifSyWhWwHUre+6cMJaXdrx7IyuURToyj8vkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749574559; c=relaxed/simple;
	bh=IU9Fgqop975ZuM3T85byHeBxqf+hSpv65MYGR2Itz2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ay7w74LLKZ1+yytC51mPJhd0DH0eS8NcPrJggxr6BZxWFYb0AKLQk41VPPhgZqbt27/k+4GJAfZoFbeGsjXC+u/B7ypXbx4HVqcBQlYVIt4GQy9M8p9GoqIXla7MBZlMuyXQEeRl6uKF/kUL8j0pgx0frEjtyqAaOBJnIq6tEl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+G2SiSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+G2SiSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB4BC4CEED;
	Tue, 10 Jun 2025 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749574558;
	bh=IU9Fgqop975ZuM3T85byHeBxqf+hSpv65MYGR2Itz2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R+G2SiSJCBDBzN9DWXwF7dU+N5KctyzcrAqDzfuKb1Tq72WUtMdHJfcDYCAoFo64i
	 oSHQlPvgiA7+jL/citQ1j2lhexQKFpKHLKwaCcERTlMQpQdZAhA8wNEFqb8YnAe6Kr
	 WNZRpONntXV7ihRBWNLelHo+cWnaxKibPNXuS+iVG/jEsL5zrOs5J6EsE9j7WyrQ4x
	 urD4hG+Bjcic6O4h/mTwWwRkXxhJGQ2x0VmapY+ag1E7c1tm3OS/DK2QK9pkCmXg5V
	 xbTz2FkdinbRkljKwH3WVn0pnjNGD9iv9LniiwVVdjoXTFfrk5Muymi/zMpO21L8lW
	 d+pALGN8OC5YQ==
Received: by pali.im (Postfix)
	id D2FB94F1; Tue, 10 Jun 2025 18:55:55 +0200 (CEST)
Date: Tue, 10 Jun 2025 18:55:55 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Tom Talpey <tom@talpey.com>
Cc: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Show reason why autodisabling serverino support
Message-ID: <20250610165555.sekma4ybcl63flnw@pali>
References: <20250608164453.6699-1-pali@kernel.org>
 <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
 <CAH2r5muuanOgjzQ8wgd+QoyrU_ZM4tATrfYYQj=b7MapGLMh5A@mail.gmail.com>
 <20250609073650.kj6lxrykguhb7nuo@pali>
 <ac80cb46-5787-4fc9-a405-fd38a505c613@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac80cb46-5787-4fc9-a405-fd38a505c613@talpey.com>
User-Agent: NeoMutt/20180716

For sure I can improve also existing text message. But Tom already sent
NACK so I'm not sure if I should continue with improvement or discard it.

On Tuesday 10 June 2025 11:36:30 Tom Talpey wrote:
> The message text is pretty cryptic: "inode numbers won't match anymore".
> Can this be stated in a more actionable way? The primary consumer of
> the log is the sysadmin, after all.
> 
> At a minimum, stating that hardlink detection won't work, as noted in
> the commit. Perhaps more helpfully, state that it's not a client issue.
> 
> Tom.
> 
> On 6/9/2025 3:36 AM, Pali Rohár wrote:
> > cifs_autodisable_serverino() is already printing at the VFS level
> > information that it is disabling the serverino. It is one time thing as
> > once it is disabled, it is not printing it second time. So it does not
> > flood logs.
> > 
> > In this change I have just extended this existing logging to print also reason.
> > 
> > On Sunday 08 June 2025 22:40:21 Steve French wrote:
> > > Since this could flood logs (e.g. in some DFS cases), probably better
> > > to do these via the usual dynamic trace points (and can document a
> > > simple "trace-cmd -e smb3_disable_serverino" script to avoid risk of
> > > flooding logs.    cifsFYI is an alternative but the world has moved to
> > > the dynamic tracing (eBPF etc.)
> > > 
> > > On Sun, Jun 8, 2025 at 3:57 PM Paulo Alcantara <pc@manguebit.org> wrote:
> > > > 
> > > > Pali Rohár <pali@kernel.org> writes:
> > > > 
> > > > > Before calling cifs_autodisable_serverino() function, show reason why it
> > > > > has to be called.
> > > > > 
> > > > > This change allows to debug issues why cifs.ko decide to turn off server
> > > > > inode number support and hence disable support for detection of hardlinks.
> > > > > 
> > > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >   fs/smb/client/connect.c   | 2 ++
> > > > >   fs/smb/client/dfs_cache.c | 2 ++
> > > > >   fs/smb/client/inode.c     | 3 +++
> > > > >   fs/smb/client/readdir.c   | 3 +++
> > > > >   4 files changed, 10 insertions(+)
> > > > 
> > > > NACK.
> > > > 
> > > 
> > > 
> > > -- 
> > > Thanks,
> > > 
> > > Steve
> > 
> > 
> 
