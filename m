Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A349013C3D5;
	Tue, 17 Sep 2024 20:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726605986; cv=none; b=gF4V3MWGFe6vY+/Gy9u5CG/BwLnMO8eWhGT9+PWSmdBRqoc3EbgbGpk/gvSzQHqoGKlFdupyTpIY7IJpMwFygQo1KbqdIPb11xJtI63Ai2PpykqXfRGQE0yhhNr2DMKzmzft9Nmwsza3ZSPzot0tw8mAakdbNqhzHBuYUaae4/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726605986; c=relaxed/simple;
	bh=1mh6w6Wqr+uuHGP7cwBB6Bk8/DpnZSduJXD2KbNEI10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvN4S7jc1AJ3sRm5/p9JotjwlBXQy3s5KBLsmTZc2mPZTl8wF9irGStNpD4gwCTPO4RNpe38x8foNrW29Ny5lrhTPk2DTLcvs74quXNtvrcM65e9O0xbAwuTX8yp4RpDAwb7WLcgFIwt+w8gWJ9CMhomYj8Mbu/AnBqGaLoL2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=aCQ8k+lG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aCQ8k+lG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=1mh6w6Wqr+uuHGP7cwBB6Bk8/DpnZSduJXD2KbNEI10=; b=aCQ8k+lGL9H5vYafl61ajSrzDQ
	T9ZqmJi9BMJq8m8h+Rss4ApbD9gbG8B/5KWjoAa6szfMUBlA6tO8nn5di6xi/0hxs4ursjOiEqKkt
	/SPV/ucjOUWOXWeHPbWuluR/1AOxSjzZJEX9nIpm4VC8Td+0Fwl3oFaC2SaV0B6FlVRtq93P86Bey
	9OA38fIXaAKpPcVYGaRHLCsGzHPqrj/4w8RQLIhWuiYfVFyNMAcBhZeodbXND0HD4EqVXslBydl39
	RIQCFFx9RN9OpZJXp2CHGJO+bkd+ceFzGIBICVT8oHyPoksteNmHod5zZwJA79mACMpX4veBu3yCB
	62geb80+/TH+KL2WACJ1XkgphEEGnOpO8uHq3Y9x3XG3eujN+d9V2v1u3WihGfowa5pZZ/mLXex5d
	mn+RhmUY+++2yysX7eqzmmtpPs1zSL54yUGFlf1HnnMNjwPm8x9UbcuZ/bGbzdC+fTKcPlOm8CFDQ
	GBqw2lYzumK9tKB/G7xdRP3+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sqf5a-000bqX-0E;
	Tue, 17 Sep 2024 20:46:22 +0000
Date: Tue, 17 Sep 2024 13:46:18 -0700
From: Jeremy Allison <jra@samba.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <ZunqmhGHniR/4a9d@jeremy-rocky-laptop.localdomain>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali>
 <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali>
 <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>

On Wed, Sep 18, 2024 at 06:44:39AM +1000, ronnie sahlberg wrote:
>On Wed, 18 Sept 2024 at 06:37, Pali Rohár <pali@kernel.org> wrote:
>>
>> Ok. But then I do not understand why Linux client parses and uses uid
>> and gids which are sent over the wire. If you are saying that the SIDs
>> must be the only source of truth then Linux client should rather ignore
>> uid and gid values?
>
>What I think Jeremy is refering to is that mixing uids and sids in the
>protocol itself is
>a protocol design mistake.
>Because this means that some PDUs in the protocol operate on SIDs but
>others operate on
>UID/GIDs and this means there is great risk of mistakes and have the
>sid<->uid mapping return
>different results depending on the actual PDU.
>
>Sometimes the sid<->uid mapping happens in the server, at other times
>the mapping happens in the client
>and it is very difficult to guarantee that the mapping is consistent
>across PDUs in the protocol
>as well as across different clients.

Thanks Ronnie. You said that much better than I did :-) :-).
