Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D843DF003;
	Tue, 31 Mar 2026 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774945664; cv=none; b=bMuSJWeJ8g+6Kts48RrpJzBTSQHxpEwUxRIhyFgup4NGth5n6UAQiGCD/oviLk4Exop91LKITHLHKbxI0tRE8liTGfz7Ue255BqVdX82qNwNeai15JvWJviSSnzlPE3iEEhisB1vTUNNK9HdPtcpv5FGQru63aHzE582eN06l/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774945664; c=relaxed/simple;
	bh=Yx1Xll+DsQnpK2EeA64/CzyBUEm1aXMFc+DIWQjRQjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/QPHhHtUHvfYwZOcg8jMqVxu8znBOKRLKdeHSQiZEIMTE+7RSW7q4bF/xOGnZMMbON0opgz2hKkYalSP60KobXjFx9pnymT2r1n5lRkA6nT7WG3GcHAA1/6t5m0eqqFdjngb0Agjx5kSAOWqc69X/mFefEJmWzTBaOkneBAvLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=Ph+VFMKM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NuB4IJ5D; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="Ph+VFMKM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NuB4IJ5D"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 82429EC022C;
	Tue, 31 Mar 2026 04:27:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 31 Mar 2026 04:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1774945661; x=1775032061; bh=c9Qkm02a5w
	q082IfjuzHjs6ovjvxof7MtSCn6YRQST4=; b=Ph+VFMKMAXTaagkKOfQt6LOc88
	yW1xEbxyA4OJSVyzbVE3G6tlwapGK+kVDEF5/IMsQpwmhrretPkh9Z48vmnRnjql
	DkC72IROTcpr+o21Qg97aCo/OM1td+jqR3EZNpeHjxyzIUvKxtli8hWjtUz/943u
	BvGuOpq0v/Cy2v+yWhycjsAgZfbPZN0wMoqSdpmoSRstklGAdZiYYcNQx0A2HKbR
	pg3b0LZAaLtyiG5CaY7Xim7F+1kmvgrKaEoakoKbld9Gj5LvbFc7X7MnfRLg3I+2
	jE4/0PdYnXMj77lOUUVeVZOVCBtt4udCZ8dpuQtvg4DSPaIDiXI3kVAxiMbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1774945661; x=1775032061; bh=c9Qkm02a5wq082IfjuzHjs6ovjvxof7MtSC
	n6YRQST4=; b=NuB4IJ5DEhGHPdidAkkluxRjQNz25rkjd+oLUPGfgngZSthWSF9
	nHD4ByVw+5+s4vJi3WPMk5eu2Ing6otcUsNuXBCf0Mu8uBCJvqKxbgQWpii1wFH2
	Jv60f8UdvlOSan3ArasgJHOSSLXwTIw6XkKWp2cSOBhzwGqacf5idGR5/HJRVqnV
	k0a79slXlRELMTN64FElLsf3MlA9Szlrnoi+ds3ssNnTl5NEc+uVpCfX65LHwina
	/KGQJgAtGkX9fG4eaALFL1NwwB/3sfJ1i761ttWl3dJcTUUgGuVNqkBx3GHc+z9o
	TgMFpq42iQKRRKJjQfiSpqbeBq2KnmIgLeQ==
X-ME-Sender: <xms:fYXLadUeXhiOLtQw2KQyqGIgR07FlSRWDQY4P9AqmdDeipLcP08a-Q>
    <xme:fYXLaUoVftJzncRJjqfQHJkSkFMJEyeEF1EqxBQQoW5EL6KU0YEvN1Epo8G2QOrae
    mvPGOXS413RZJaBzAmh0aSP_a5woXsK90mkHy8JBeFLZ_AgkA>
X-ME-Received: <xmr:fYXLaRGu0bxH7jKcZMl2JK5dTkKgAYbJkZcyI10z3JxVrPh7ACIETLEL3oI_a-1Y-NrrPVXygeG0xJIqtBA0EfzYGluNPkflu1ajj8UvPQ8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefgedugedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehueehgf
    dtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhdpnhgspghrtghpthhtohepvddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehghhgrughirdhrrghhmhgvsegtrg
    hnohhnihgtrghlrdgtohhmpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepshhfrhgvnhgthhesshgrmhgsrgdrohhrghdprhgtph
    htthhopehptgestghjrhdrnhiipdhrtghpthhtoheplhhsrghhlhgsvghrsehrvgguhhgr
    thdrtghomhdprhgtphhtthhopehsphhrrghsrggusehmihgtrhhoshhofhhtrdgtohhmpd
    hrtghpthhtohepthhomhesthgrlhhpvgihrdgtohhmpdhrtghpthhtoheprggrphhtvghl
    sehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdgtihhfshesvhhgvghrrdhkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:fYXLaWsXZcct0UDUC8VOT9v26x8tehz4pz4LJDvGTogrmIvD2PZa8g>
    <xmx:fYXLaUQoc5i5zuFSwk75FsuV587PEo_K6KntQPUcVKk8FxCwv84vmw>
    <xmx:fYXLaTHuthN9b-LorOIjQxcO7SaCReFBb4dhwbXijjzEHscVtsGWUg>
    <xmx:fYXLaWd1Pm3wnczhMBAtQQW_JCSbeK01HGB4Ns1R1MIkKsBNl2w_uQ>
    <xmx:fYXLaS3TgabrFuQlWCi6Ts01DRYgZMByI0tHyPuWxLkgL_qR5beDU-dh>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 31 Mar 2026 04:27:40 -0400 (EDT)
Date: Tue, 31 Mar 2026 10:27:38 +0200
From: Greg KH <greg@kroah.com>
To: Ghadi Rahme <ghadi.rahme@canonical.com>
Cc: stable@vger.kernel.org, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH v2 6.1.y] smb/dfs_cache: Fix NULL pointer dereference on
 session connection failure
Message-ID: <2026033136-refining-ladybug-08b0@gregkh>
References: <20260319144929.455978-1-ghadi.rahme@canonical.com>
 <2026032339-irate-monsoon-76ce@gregkh>
 <a7c5ecb2-d46c-4061-a70a-c7b149db56f2@canonical.com>
 <2026033140-endearing-handcraft-b66a@gregkh>
 <0dcbb073-4745-479a-8d55-bdb0a3fe55e8@canonical.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dcbb073-4745-479a-8d55-bdb0a3fe55e8@canonical.com>

On Tue, Mar 31, 2026 at 10:54:08AM +0300, Ghadi Rahme wrote:
> > Then why not backport the specific changes that caused newer kernels to
> not be affected?
> 
> Based on the documentation [1] for submitting patches to stable, the patch
> cannot be over 100 lines long with context.
> 
> The upstream patch exceeds this limit by a lot and cherry picking the
> specific changes from it that remove this function is not feasible without
> causing the driver to break. In other words the removal of
> "find_ipc_from_server_path" is dependent on this refactor.
> 
> > Backport the same changes?
> 
> I can go ahead with this solution, given I get the green light to ignore the
> 100 line rule.
> 
> [1] https://www.kernel.org/doc/html/v4.11/process/stable-kernel-rules.html#

We take "large" backports from mainline all the time, as long as the
maintainers for the subsystem are ok with it.  to take one-off patches
is usually much harder as the change itself is almost always "wrong",
and then future changes are even harder to backport.

So I recommend working with the maintainers here please and see what
they want to do, if anything.

thanks,

greg k-h
