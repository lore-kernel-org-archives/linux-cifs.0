Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C97F1DF27C
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 19:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737314942; cv=none; b=RI2d4q5FzVNWFOPkD4yY48IEWr85FOF/CuVf1t30M5B4ItTZrH+PHp7msHE01a9wF4CR9F7USZ9z5AeSkq5Ihiops8GneKjml8uHmoIhTBNDcLUXWx7+fSxcRbRyvQqbhIFQuRP03EKTh76D3NsvZJZVu+jZlzbRBetndkLJO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737314942; c=relaxed/simple;
	bh=tq/z47SIheWMYDkTp1EFGOct5ii3ZEnPFcN1WCMrnuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQLU170+ip59ItfRqxZdO6qcriFauyjbK+NAjWm1xxmKMuy/XqVm5kIO308XycL3I5t6ZBkkQuxWly7y6gQOGRRarcyWQWn5DP8NS+uQV61AjO5XXsWOIb3e0XSlyxZKPyRGcJ2JH01gbck6PCD+eoLmsSmGcX6BKAUe/p4g728=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWES3EDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWES3EDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FFBC4CED6;
	Sun, 19 Jan 2025 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737314941;
	bh=tq/z47SIheWMYDkTp1EFGOct5ii3ZEnPFcN1WCMrnuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lWES3EDIeAKAuiygHctDieRFtVf4C29+qZ6vZElGv+AbfRRiGYNMDhO38hbs1KkZY
	 Y2KNXHpnXupIYwXGrL0m202vqQNSZZtt3SOd7xk5oPNFP4nTU0VykL4oZvQ0JI0qRK
	 fjjcctGcEBGmtbyauHwdDnPJP/ZrxC90+53y1aCMqigQv9SOxrhN38gmZ0gjdbEzCq
	 +vadW5EFMWprKUkU7HvzqTB8uO/8kvn6zOVWm80ksVN+KEYMDBkG2swxPPxxRFvnjo
	 WjaHbRb7fs4kEge8GVjMVG4brtez/Mxib3dOmMi6p98VZX28KsKX84n3r7hp9rRQQi
	 mTFlx1vo2EImw==
Received: by pali.im (Postfix)
	id 379A768D; Sun, 19 Jan 2025 20:28:50 +0100 (CET)
Date: Sun, 19 Jan 2025 20:28:50 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: Fix endian types in struct rfc1002_session_packet
Message-ID: <20250119192850.6dat6hi7shoajo5d@pali>
References: <CAH2r5mu+P1n18+EgdzqB_FmcEWXoaEqacqa6osKHtb05B1bBbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mu+P1n18+EgdzqB_FmcEWXoaEqacqa6osKHtb05B1bBbQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 19 January 2025 13:21:39 Steve French wrote:
>     > All fields in struct rfc1002_session_packet are in big endian. This is
>     > because all NetBIOS packet headers are in big endian as opposite of SMB
>     >structures which are in little endian.
>     > Therefore use __be16 and __be32 types instead of __u16 and __u32 in
>     >struct rfc1002_session_packet.
>     >
>     >Reported-by: kernel test robot <lkp@intel.com>
> 
> Do you have a link to the kernel bot reported by (email?)

I should have it somewhere in my mailbox. I if needed I can try to find it.

But robot reported this issue for my own branch (not the master one). So
I though that it is not important to mention exact link for some of my
change which was work-in-progress.

In any case, robot found the issue with incorrect endianity types, so I
wanted to give credits for this robot. Anyway, those type changes should
not change compiled code, just allows code analysis tool to diagnose
other issues.
