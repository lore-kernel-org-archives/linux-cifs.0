Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9864529B795
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 00:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789259967; cv=none; b=RYLVHMTFK9FRbYN/KE5vTYH/Ppe2q/f+A+oIz+fDyYrQH5mI3eOb/isqB46QEZ7riidRR7lcIqftfGJnwYF73lU8E6+jdZtPTllEV6pIjnx7FZ1GFoBamNGmIHlrKRvGtgTBJ50L1lxsDC1DgbJDpHdZSxxVE85SKctgKZN0ZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789259967; c=relaxed/simple;
	bh=MJe/G020RyY50IzEP8UcPim9Ltz6d9JiWgYTsls34oI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=paB4MH1+T+dHDN238f4ksZfDNtU/oNLwP0GjG08jyh9XdPMbIhLFdTZ0bxVSlRe6U7e4JkDCDx1NEYXOr89wVgku/pUzafSKZKxBoysAhK81HU86NvMy+p7eBhMZcG/yjhQzpFFHlL65/xNPY3g6i7+qZHj+Z3DN6JywwIiHyq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXNvzZrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXNvzZrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449551F0089B
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 00:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789259966;
	bh=MJe/G020RyY50IzEP8UcPim9Ltz6d9JiWgYTsls34oI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bXNvzZrxlsKOEac/ugHIzydqSwarZ+Nw5g22HONVJOsctk61eGXHh1vQUYAyLmfvg
	 W9/4aMNNmmTZTGa+fIC7Dfkvu6BSUok/LmcN3ljppOG4IumOGGoBhSJQ+XItQNomb7
	 fjyTJifaqEHlsIaG1rMiFNQLrNbpkOA7SVb1+LKorYZF5dN4wOuB0Zck40kHw2p9Xx
	 6cEOguyO8y0PvMuEIv7mR8Gkan+PUGrs6afBLKLE/Ygho2QZf43XPF1vlFsQWBJ7Br
	 d/JoIfa9wYL3qW+ekqdpqt/5jzNdq3zuLzELdf4LPW6NgBowXzeJlAx/bkKtZh1wO7
	 8t70rHRCqOkjg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c29667ed561so269189066b.2
        for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 17:39:26 -0700 (PDT)
X-Gm-Message-State: AFuF++lMdFwpgFuPrA8dJymq9qkS/YvkoWXH6xx/XDc47KyaKgPxOiYn
	i+2pn6lIpR/jU5DZEER3vwsZp7PlFmULfVdANdSgQhZe5WhMFXUPjMRjGR7nuykYsr3mwrfqxAk
	ddWuwP2+l0Qo/TiNM/2Qcdt4/iSLyvX0=
X-Received: by 2002:a17:907:94cf:b0:c26:19de:9ae8 with SMTP id
 a640c23a62f3a-c29666d637bmr525227066b.39.1789259964707; Sat, 12 Sep 2026
 17:39:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260912165503.521597-1-pc@manguebit.org>
In-Reply-To: <20260912165503.521597-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 13 Sep 2026 09:39:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8OL=Lfxx4wmNWb8AXvgmkcJ5DzML-bJz7FBNQgdRx9AQ@mail.gmail.com>
X-Gm-Features: AcwNN1XHMOzYmFbHiG6rxmtWifCC631aPkcSniM5Yx7reYgSaC1lGv02WvDGhpA
Message-ID: <CAKYAXd8OL=Lfxx4wmNWb8AXvgmkcJ5DzML-bJz7FBNQgdRx9AQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix rlist race and missing initialization
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 13, 2026 at 1:55=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> TCP_Server_Info.rlist is allocated via kzalloc which zeros both ->next
> and ->prev to NULL instead of pointing to itself, making list_empty()
> always return false and list_add() dereference a NULL ->prev pointer.
>
> Also, cifs_signal_cifsd_for_reconnect() can be called concurrently
> from multiple cifsd threads, allowing the same server's rlist node to
> be added twice into the local list, corrupting it.
>
> Closes: https://sashiko.dev/#/patchset/20260911204446.1719356-1-pc%40mang=
uebit.org
> Fixes: df0e03a4fb94 ("smb: client: fix potential deadlock when reconnecti=
ng channels")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
