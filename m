Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D994B3DBBF;
	Wed, 21 Feb 2024 11:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708513796; cv=none; b=cr8TvKAapRJyKX1grX6jYjkahhiehFd2XrCOn2EfPKOrQVCESZYU3dIhRS8pYS9P/97rL3mwkjbfGJF05Qt5eaqFJvRUIUESnwXGPCaCwUgAgMOgz7sK/EIV42clr31POgVs9chtVV1DNCO4EitNgQDXzRuapGnRzjD2J92STLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708513796; c=relaxed/simple;
	bh=r5M9n+h9xvc6qVOXbDJzEKIEsbVMmU0lw/roKeMtLTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3X6UDTD3+FHhRHD80czXFnZHbNIF85t7/syq1r4qPeTYUAYbPVE1th7AucuMhGDZWhARNUZQLDyqhMV1kgNv6C/u7CiQ2Icz0xOk5HBFwiFD+J8bBb92UlPOc0GAM7v2Az4+uwfoEoUsrGln1w1QCG6/0sTF0ToTqsZSMe0hmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBSic3xO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBSic3xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AEDC433F1;
	Wed, 21 Feb 2024 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708513795;
	bh=r5M9n+h9xvc6qVOXbDJzEKIEsbVMmU0lw/roKeMtLTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LBSic3xOtt1tCN9A/92/nAk2C7hX3VhIpgeNenXsYtHYuEpSSvxDhnOfrvD3bvY5H
	 LcDHRGq1Rhm0MUZ5mJ1Op99jpTeYqbJEs1Ytost8WnJVMv7zAE86q7cBhJ7JyYWUsD
	 TIgwV6SDvSJky8V0bgp00hURu2WaiWEKRhGs6kpM=
Date: Wed, 21 Feb 2024 12:09:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Paulo Alcantara <pc@manguebit.com>,
	Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>,
	Leonardo Brondani Schenkel <leonardo@schenkel.net>,
	stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Mathias =?iso-8859-1?Q?Wei=DFbach?= <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <2024022137-ducky-upgrade-e50a@gregkh>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <446860c571d0699ed664175262a9e84b@manguebit.com>
 <2024010846-hefty-program-09c0@gregkh>
 <88a9efbd0718039e6214fd23978250d1@manguebit.com>
 <Zbl7qIcpekgPmLDP@eldamar.lan>
 <Zbl881W5S-nL7iof@eldamar.lan>
 <2024022058-scrubber-canola-37d2@gregkh>
 <ZdUYvHe6u3LcUHDf@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdUYvHe6u3LcUHDf@eldamar.lan>

On Tue, Feb 20, 2024 at 10:25:16PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Tue, Feb 20, 2024 at 09:27:49PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Jan 30, 2024 at 11:49:23PM +0100, Salvatore Bonaccorso wrote:
> > > Hi Paulo, hi Greg,
> > > 
> > > On Tue, Jan 30, 2024 at 11:43:52PM +0100, Salvatore Bonaccorso wrote:
> > > > Hi Paulo, hi Greg,
> > > > 
> > > > Note this is about the 5.10.y backports of the cifs issue, were system
> > > > calls fail with "Resource temporarily unavailable".
> > > > 
> > > > On Mon, Jan 08, 2024 at 12:58:49PM -0300, Paulo Alcantara wrote:
> > > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > > > > 
> > > > > > Why can't we just include eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
> > > > > > arrays with flex-arrays") to resolve this?
> > > > > 
> > > > > Yep, this is the right way to go.
> > > > > 
> > > > > > I've queued it up now.
> > > > > 
> > > > > Thanks!
> > > > 
> > > > Is the underlying issue by picking the three commits:
> > > > 
> > > > 3080ea5553cc ("stddef: Introduce DECLARE_FLEX_ARRAY() helper")
> > > > eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
> > > > 
> > > > and the last commit in linux-stable-rc for 5.10.y:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
> > > > 
> > > > really fixing the issue?
> > > > 
> > > > Since we need to release a new update in Debian, I picked those three
> > > > for testing on top of the 5.10.209-1 and while testing explicitly a
> > > > cifs mount, I still get:
> > > > 
> > > > statfs(".", 0x7ffd809d5a70)             = -1 EAGAIN (Resource temporarily unavailable)
> > > > 
> > > > The same happens if I build
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
> > > > (knowing that it is not yet ready for review).
> > > > 
> > > > I'm slight confused as a280ecca48be ("cifs: fix off-by-one in
> > > > SMB2_query_info_init()") says in the commit message:
> > > > 
> > > > [...]
> > > > 	v5.10.y doesn't have
> > > > 
> > > >         eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
> > > > 
> > > > 	and the commit does
> > > > [...]
> > > > 
> > > > and in meanwhile though the eb3e28c1e89b was picked (in a backported
> > > > version). As 6.1.75-rc2 itself does not show the same problem, might
> > > > there be a prerequisite missing in the backports for 5.10.y or a
> > > > backport being wrong?
> > > 
> > > The problem seems to be that we are picking the backport for
> > > eb3e28c1e89b, but then still applying 
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5
> > > 
> > > which was made for the case in 5.10.y where eb3e28c1e89b is not
> > > present.
> > > 
> > > I reverted a280ecca48beb40ca6c0fc20dd5 and now:
> > > 
> > > statfs(".", {f_type=SMB2_MAGIC_NUMBER, f_bsize=4096, f_blocks=2189197, f_bfree=593878, f_bavail=593878, f_files=0, f_ffree=0, f_fsid={val=[2004816114, 0]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0
> > 
> > So this works?  Would that just be easier to do overall?  I feel like
> > that might be best here.
> > 
> > Again, a set of simple "do this and this and this" would be nice to
> > have, as there are too many threads here, some incomplete and missing
> > commits on my end.
> > 
> > confused,
> 
> It is quite chaotic, since I believe multiple people worked on trying
> to resolve the issue, and then for the 5.10.y and 5.15.y branches
> different initial commits were applied. 
> 
> For 5.10.y it's the case: Keep the backport of eb3e28c1e89b and drop
> a280ecca48be (as it is not true that v5.10.y does not have
> eb3e28c1e89b, as it is actually in the current 5.10.y queue).

I think we are good now.

> Paulo can you please give Greg an authoratitative set of commits to
> keep/apply in the 5.10.y and 5.15.y series.

Yes, anything I missed?

thanks,

greg k-h
