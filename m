Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AC92E36E3
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 02:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752459524; cv=none; b=Fhl7Q735HT44A4tiDTbyjdAGkW/G0lSLpJylVwpiB/znNUOLU/3j2uhmvXPbUg6DVeJ58mAL3AwjPjLYEakYfvI9BXjXYyRcJ//s+hVSVKglqPpENP9rkncROIIpjstISYN9Fiu+YmnQaQ6yG6tvXMPNq5qiioKrcd/kejV+9i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752459524; c=relaxed/simple;
	bh=L+qSz+y/joXFHBS4dBaaN7LWWUg3OKu9mglTqQx53nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzUegek9kvFLUM7uANdmYij/37H00qgtptTgpwvSiCKoCJpDWuFTgg+ZcBW5uhH5aDpt4/aR/nLqShpU2a6YDXO+Aauxs0lxPuCYnq/D/k1kpXDDqoL8RC5uitYEyrUiCeaJo8LSZai26KpwhfU9DJtKWj2VUwnDia37zIabcrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zq29Dxmz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zq29Dxmz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=u4xAOrjJsEgpy6ml38zdXtcLvqce4DROPwTsxza3Af0=; b=zq29DxmzuMc2ZW1km77k33zboW
	eIu5A8GER4F9RdqqCcKBgaaIlGCbyQA4ZGRfh3HMSrBitHl1t+NHPSVJ589pE/3IvGCbCRSJ3/kQS
	IV1MDYkoPlBERCsT0G4J8qfG37ugwJkceibJfFcAYlOMxX6Ce5cL3IGwrwkIRojqZY04KY3erCwZE
	M65mGhLtarm1juQGxRGx+L4rV/rTMR0Idu5gVcojH1yk+tMrswigL1E0MRz7maH4Zkkoi5Icxoobn
	A7wpeA/w4XVe/aBOg57arQSDpcVWtkvChZysqyZgRbat/syrf9xSuHUDkCfHdoQOBeGkxC597G0iI
	SIH/1ymnFwRJG28jDL05jRhwMXKiu8DfKVvpDj0XAFJGJfbEV81htyf6qjkWyZTeYe/dFhq3sLjQB
	/b3t3//vrouxzfB0+aynuBTTd+ZIXF+h4hb6+GhUM99+ZlVSYWU/BNP68Fh+mBmoSk7Chg3U91uJS
	SGlXfzJpyiCmj4lqEV/KCLZd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ub8m0-00FFNf-37;
	Mon, 14 Jul 2025 02:18:33 +0000
Date: Sun, 13 Jul 2025 19:18:29 -0700
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	Ralph =?iso-8859-1?Q?B=F6hme?= <slow@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Samba support for creating special files (via reparse points)
Message-ID: <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>

On Sun, Jul 13, 2025 at 06:05:27PM -0500, Steve French wrote:
>It does look like a change in behavior on the client as well (the
>client didn't used to enforce the server correctly setting this flag)
>- see below, but it is tricky, because without the check on the client
>for that capability flag a server could end up with unusable empty
>file on the server if it actually didn't support reparse points.
>
>What is strange is that when I comment out the checks for
>FILE_SUPPORTS_REPARSE_POINTS on the client, Samba does seem to allow
>creating special files via reparse points, it just doesn't properly
>advertise that.

Currently this is only set in one VFS module:

source3/modules/vfs_tsmsm.c:    return SMB_VFS_NEXT_FS_CAPABILITIES(handle, p_ts_res) | FILE_SUPPORTS_REMOTE_STORAGE | FILE_SUPPORTS_REPARSE_POINTS;

Now support has been added more generally I think
this needs to be added into the vfs_default.c
generic return.

It's an oversight I'm afraid.
