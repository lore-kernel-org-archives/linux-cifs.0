Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0A27EEEC;
	Tue, 30 Jan 2024 22:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654975; cv=none; b=a58ZXQcarW+CGfich/iQSQ0ae9mEvUjSaAXrVxwr6/qTLapgmOoG02+UkKU76A6Gz2jXj7GP58rJM1p6xjMMjVMDRISE6ZLbV9zJ1s2vCH8Bc/M8UJH0jW4X891+ijb9eXdY+WXwyjRYeCv0S9FYvz7MoXWTKT1ge11Z158VFo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654975; c=relaxed/simple;
	bh=SfTsQHUzwYOw6tm15w1BnAL1U6wbM5O1XydpH8hAt6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a87T3Hpbah/Zk99sWOdZYLW0Ntic8LtQ9F14n68b8rz03+ZjNW/RShpMKwebWhGfoIKOLAxX+6cdcIKNukpn6mBPN3pg3t3ts5oqk/oe3Cl1Fc/KLE7Rbq9Mflpj9iNm4utqZQ5SyWHcTzGaff/Ice6gLGkr5CTmjE/wIu8TWr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=PL0mbISt; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="PL0mbISt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WEOMV/N84hcohRbOjwt+Vy6+eT6U/+PkTZW1Mypb99k=; b=PL0mbIStanoePOnz0peeH4kIAN
	FyiEBY3Eh5jFJ21PabLv4AV2LCFoTeMtJrh8ykxNUggQUstaPdADobls39RjCsV4ekzI6Bp2n+9RW
	HwbJn8hhGpwC10RlMDp5g3G5gY1Yv6BFT3qYMBygbEwCRKeyY4n2iWofQUGEVN1FzQ1MKS+f56p9X
	oesl88+epQm07BfW/oO6h7kLnLSmbNnItjw3a9cdKkjp+vRHC7VmD6W+cc7EL3jwwCoWDN08z0bSU
	QdhaRjgCAUKpNGsrZ8frSWLJSFj2c0BhUHlkZv0skL8DA8WifRTYn6dxfWZyHL6DIDyvjDMtd5nrX
	yakVGTNg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1rUwuz-006Vho-80; Tue, 30 Jan 2024 22:49:25 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 7C2CCBE2DE0; Tue, 30 Jan 2024 23:49:23 +0100 (CET)
Date: Tue, 30 Jan 2024 23:49:23 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Paulo Alcantara <pc@manguebit.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>,
	Leonardo Brondani Schenkel <leonardo@schenkel.net>,
	stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Mathias =?iso-8859-1?Q?Wei=DFbach?= <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <Zbl881W5S-nL7iof@eldamar.lan>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <446860c571d0699ed664175262a9e84b@manguebit.com>
 <2024010846-hefty-program-09c0@gregkh>
 <88a9efbd0718039e6214fd23978250d1@manguebit.com>
 <Zbl7qIcpekgPmLDP@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zbl7qIcpekgPmLDP@eldamar.lan>
X-Debian-User: carnil

Hi Paulo, hi Greg,

On Tue, Jan 30, 2024 at 11:43:52PM +0100, Salvatore Bonaccorso wrote:
> Hi Paulo, hi Greg,
> 
> Note this is about the 5.10.y backports of the cifs issue, were system
> calls fail with "Resource temporarily unavailable".
> 
> On Mon, Jan 08, 2024 at 12:58:49PM -0300, Paulo Alcantara wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > 
> > > Why can't we just include eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
> > > arrays with flex-arrays") to resolve this?
> > 
> > Yep, this is the right way to go.
> > 
> > > I've queued it up now.
> > 
> > Thanks!
> 
> Is the underlying issue by picking the three commits:
> 
> 3080ea5553cc ("stddef: Introduce DECLARE_FLEX_ARRAY() helper")
> eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
> 
> and the last commit in linux-stable-rc for 5.10.y:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
> 
> really fixing the issue?
> 
> Since we need to release a new update in Debian, I picked those three
> for testing on top of the 5.10.209-1 and while testing explicitly a
> cifs mount, I still get:
> 
> statfs(".", 0x7ffd809d5a70)             = -1 EAGAIN (Resource temporarily unavailable)
> 
> The same happens if I build
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
> (knowing that it is not yet ready for review).
> 
> I'm slight confused as a280ecca48be ("cifs: fix off-by-one in
> SMB2_query_info_init()") says in the commit message:
> 
> [...]
> 	v5.10.y doesn't have
> 
>         eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
> 
> 	and the commit does
> [...]
> 
> and in meanwhile though the eb3e28c1e89b was picked (in a backported
> version). As 6.1.75-rc2 itself does not show the same problem, might
> there be a prerequisite missing in the backports for 5.10.y or a
> backport being wrong?

The problem seems to be that we are picking the backport for
eb3e28c1e89b, but then still applying 

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5

which was made for the case in 5.10.y where eb3e28c1e89b is not
present.

I reverted a280ecca48beb40ca6c0fc20dd5 and now:

statfs(".", {f_type=SMB2_MAGIC_NUMBER, f_bsize=4096, f_blocks=2189197, f_bfree=593878, f_bavail=593878, f_files=0, f_ffree=0, f_fsid={val=[2004816114, 0]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0

Regards,
Salvatore
