Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0527129E10F;
	Tue, 31 Mar 2026 07:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774941026; cv=none; b=ZtnFhQVDR0ZXffcoNxRvnwCaxSIgTQqY2PfPDkHtwjWyMMosppQ+jhccQ14YNa9P1jPfuaxxqyBz5ysvygIrlFM0gJV8IraBfxgBL6pbwcQOAj7rPubkICKeRKD52Gi85YNUYhr7ITjSfyUXvGObDffB6zBR9VstJ2M0A+vOba4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774941026; c=relaxed/simple;
	bh=ec/xlGvb/OQavUWdxQ0dAivWFuVfBigJZln3uRdMZbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIfbw9kO0OzKdw+Y1/V+Q2QEhL0jokUBrkrx/RAY0Wh9ZpDpIAYxJ9lXKMnmLHa5nM21jEIB8HTZFbM0sjldBofeDgbXoLtZAHO/5LFf6uSfBmbVZzcyfZc1tZ8NsiDgLSPtslsRP4pRsCJIBGpz8Zezm8NE1EJqbzY8aXFTMis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=n2yKjeH8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mg152J8z; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="n2yKjeH8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mg152J8z"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2A43A1400076;
	Tue, 31 Mar 2026 03:10:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 31 Mar 2026 03:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1774941024; x=1775027424; bh=esmbZsKpw1
	HVHjembzXJErEZAoM9KmGX7HNGrJiFJW4=; b=n2yKjeH8mgs0W9ryngcdQs5zZz
	MqczXGk7P8txtrJleotI329rVGgZAyjXVaNzqfU7mBzH+07opmm0Z6L0oHoVQc12
	fjKt7bTlaH8cVBw9eSEPavJHdfev+hOAfVOdbOCLnCXSjraM7JrmPWM2aESBoOvV
	pBmDK84fx9BtAfOn/pdouHmDdOedhbfW6l2hHI6Di/5AcljkVjztSVpA8lsC5ruf
	f8a7Gs2Tok+aryjPSXwpEpYZBofplXtSB9kvfxl/gYJe2BQO9nuhPVm66EUKlSLD
	CMVmQOTA8DiE8qLNmSp5KxOEhuN57nYQbZzRN9ydg0hMeNrDWMk6hluxk/9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1774941024; x=1775027424; bh=esmbZsKpw1HVHjembzXJErEZAoM9KmGX7HN
	GrJiFJW4=; b=mg152J8z0Qf64andBA0qR3mSHVEbMcr28NGIQIYltVgumXaJqm3
	c8KQTR9W6M5xNmC2FfC7KS85Syb4npIlMRDthxXS5nRzAty/RN3i0M0Mj5G10JZh
	gJ1WN9UpumXVYSRyLfSB0fOX3TR655O3RRaB4r/ZVNsjrafccI350K0HqZ52oERQ
	WdDJjgbLkXscknm4Tba/eYHCzzgoO8MBvwe8uEN9YOMv2Dck2uUHFg/vO4eHRl2c
	ypXXgBN+jN1nJqsOFt1tTYbT/xeTaAmVNOq1Et5rt5L/B3+I2nKs3m+gpivnXwil
	Gm2S1itJPjdw7gXwlQsEC6VsK1/fRwBI9HQ==
X-ME-Sender: <xms:X3PLad8Lo1WwDGqIwq2EoP6bQKBDKnuloNuUIt110T5A-KaS3-uLuw>
    <xme:X3PLaYz-BQffwmhuXGq3ClbpH-5BLB_w59oS75FPsjGut-0DIqZvo2gbXPVBs8Vco
    cgWf1MnQzIIPhH-BFoxQLx9An-l_Bv2udQiKHDUH_bWPfcU>
X-ME-Received: <xmr:X3PLaStLGXtM-szUQIpez0ROckJnX5atIXS2bK62N2eKM0oPYL1dhkZPgJFxwyCcoKhgbjnEm2MkL0RLdhVIu16DzA8trnqOCpG_NI9LcCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefgeduvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvdevvd
    eljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepghhhrgguihdrrhgrhhhmvgestggrnhhonhhitggrlhdrtghomhdprhgtphhtthhope
    hsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsfhhrvghn
    tghhsehsrghmsggrrdhorhhgpdhrtghpthhtohepphgtsegtjhhrrdhniidprhgtphhtth
    hopehlshgrhhhlsggvrhesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshhprhgrshgr
    ugesmhhitghrohhsohhfthdrtghomhdprhgtphhtthhopehtohhmsehtrghlphgvhidrtg
    homhdprhgtphhtthhopegrrghpthgvlhesshhushgvrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqtghifhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:X3PLaX1XAIMH2y07iW6W3DF2alnY2veLO6Yyp698bzyCGwFUp6KvJA>
    <xmx:X3PLae6btaGtLatzSFE-UFAmp1H5SLF3jWUA1PIqoo0cwOEmX1RVaQ>
    <xmx:X3PLaZPppMXW_AkyJm8v6e568SYZWLiw3kyYRp2uz2JEfJL35oBuvQ>
    <xmx:X3PLaSGKxLnbNBvcPrHrfzoe2zF8rBEvlfdE_XUaTGtO93dy92KCzA>
    <xmx:YHPLaYdYmvrpmhll_AsinPv1xMU6rrGopTbwK0aaYiS6JwKhu6oGigbs>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 31 Mar 2026 03:10:22 -0400 (EDT)
Date: Tue, 31 Mar 2026 09:10:20 +0200
From: Greg KH <greg@kroah.com>
To: Ghadi Rahme <ghadi.rahme@canonical.com>
Cc: stable@vger.kernel.org, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH v2 6.1.y] smb/dfs_cache: Fix NULL pointer dereference on
 session connection failure
Message-ID: <2026033140-endearing-handcraft-b66a@gregkh>
References: <20260319144929.455978-1-ghadi.rahme@canonical.com>
 <2026032339-irate-monsoon-76ce@gregkh>
 <a7c5ecb2-d46c-4061-a70a-c7b149db56f2@canonical.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7c5ecb2-d46c-4061-a70a-c7b149db56f2@canonical.com>

On Tue, Mar 31, 2026 at 09:59:01AM +0300, Ghadi Rahme wrote:
> > Again, wrong git id :(
> 
> Thank you for reviewing this.
> 
> There is not direct fix to this issue upstream however upstream is no longer
> affected by this issue.

Then why not backport the specific changes that caused newer kernels to
not be affected?

> The commit ID I referenced is the commit that indirectly resolved this issue
> by completely refactoring the code which led to the removal of the function
> I patched.
> 
> Is there a better way I can convey this in a V3 maybe?

Backport the same changes?

thanks,

greg k-h
