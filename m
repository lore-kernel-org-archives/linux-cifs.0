Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA8416132A;
	Tue, 17 Sep 2024 20:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726605873; cv=none; b=PkavAm6XNQ2A/UrhCgidwi1qXlayN0AXFjVSB9pauNsjTirGcC1awEz17lpdPRMYjP4XoMgtONtD0tEeVX9jHEfdjAljR3/+PSgb0YPcvBrJzxa4O9nqwN6PywQOtQStnRDUvPL4VfEOEcvd10gug8gC7F5+/VOb2+Nqq9xyUq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726605873; c=relaxed/simple;
	bh=uTGaGZM70hTwl0i4dFzzgNwE7MD0ylyadmz45do0kwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+sax1Yt3YFGWd7I0/LfcySxjufXVl/1AWg4IekkQXc2SLSw/Zj9xwMNGR8JXcEVico+gmSrNKWUe1lqq+jRZdpZ0Bjo6yOiewuWfrAjEk64zrHMroIWD1jTYVUz5OoyyQyszk54+a3m19pSiklQb1aEEf9uhr3Jg0Vtwq4thd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CZYuthV5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CZYuthV5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=uTGaGZM70hTwl0i4dFzzgNwE7MD0ylyadmz45do0kwo=; b=CZYuthV5G1dhIfl8TEal0WOhtH
	UH5c8iT5bVCGvnxi46EAazUe4V+z0EhLMUr44uC3AzRphcMDEotbq6qrRoHr6OvyA63EJ5q2N0mpO
	YaiyeUJf5rpPVnDAgxGxncXp/ksq54kWiWWu8sNRPlTLAwqw7amBT0weTdvdRaVw4qJkIe+dxWZu5
	dMWRtXE8ESAER188UKa2qbTml2B1gYxeYrg/+tBwDB4r9r2KxoIy0UTQCg12FB8YO3nGkhxiY7iYY
	3lkF9Pg98nDJPWn8POJGDw0umaA/s2mJPS0bcorxn0GZyMsTdHNkITcASGHCtzR+iEjk6/1JELfQ/
	guK3BwDzbAQNsfnwXYzVkZ3F1ZZFoyr/hazBXMudchRyfp4LHiJ/Ma8gN4WFdGttcur+QIWnkK3Wj
	f4j1n3Vy8AF59a3ofnqI6BF1wUiqedzMxlNlyp17EmK7vGPqfv4jWmt92+Y0b+urunb2kVqy6rfwJ
	Mh+XI/UEqRx7KxZClUjw8eHD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sqf3k-000bnB-1v;
	Tue, 17 Sep 2024 20:44:28 +0000
Date: Tue, 17 Sep 2024 13:44:25 -0700
From: Jeremy Allison <jra@samba.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <ZunqKeh8oS25BOFL@jeremy-rocky-laptop.localdomain>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali>
 <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240917203431.w5dejuwfkmabrewz@pali>

On Tue, Sep 17, 2024 at 10:34:31PM +0200, Pali Rohár wrote:
>On Tuesday 17 September 2024 13:31:22 Jeremy Allison wrote:
>> It will break all SID -> uid / gid mapping that servers must
>> carefully set up.
>>
>> On the wire - SIDs must be the only source of identity.
>
>Ok. But then I do not understand why Linux client parses and uses uid
>and gids which are sent over the wire. If you are saying that the SIDs
>must be the only source of truth then Linux client should rather ignore
>uid and gid values?
>

Yes. I think that should be the case. It's not my code
though, so take that as my free 2 cents opinion :-).

Samba will never expose uids / gids on the wire over
SMB2+ though (it's too late for that mistake we made
in SMB1).
