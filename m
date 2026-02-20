Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9576630C36C;
	Fri, 20 Feb 2026 08:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771577271; cv=none; b=jmv4kEtyIS53IWFCYGoAoEWs6nBZywjAVlh3ODyihhw0HtCCPw1Ue1S1dxf3auOi2qF8Rg8XDvkW2ZU4s1+/xF8yL6JL6FxQzv9OTtZUgVsQGnNY6td64Gpou3M3Imk8/O4uKJSuUL0UKJpP3yw45YKcY2ErCQTmoCtnzdgy6Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771577271; c=relaxed/simple;
	bh=KCTOcmjLjZEUBbNQus6mck2Zq0MUoWGOaoue6reUXOs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SoFJAgVywEUHwTqhj6KWGcKkVqNpQiFtAEtU22DgO0yL/aoHrvFcIQSndzpJT7JzM9X3c+Ku5BdxtSAz8haVy3RtPAdM8/hW2qarpiIvVJAYsJ1vIBWfdk1pBmFPaPru92iLv5ZiDAWlCYhX9id1If/9zbmJ4sS1jEN/WE/iuks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NdlKUvs9; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NdlKUvs9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qoU/4x8R6qlfBpKUL3kf+2mK3W6ZQH9KLxd9zBZ2Oeg=;
	t=1771577270; x=1772786870; b=NdlKUvs9I1KJvXbg2nYBAmVBzcO3/QGk3fRwysrrOjVXrlU
	sTaSQjWiLu4TTy81nBHp2ATXNL6gIYU7Iss+QrK4QnGBhQsg0o2XerdXWaVEXMwV+kbD9alhut1QU
	fo/etbtkjaCrm/j2QHJQk61xfUYLkAFJF3FrrM4a6h13iFYwBPA6rGoJnQ3R3n4jQx/sBbGTe9z12
	V4scnbcVTzn36zjMLp4Y9/wZUk06A+vu2AKBYrPEwSnQeOGjxE/sMqzbKwHMG4TwVuap1EjnRdo21
	0Q2iAEmwdErn++s2k6WWfo1FpakJaOsukjb6xr1pQLS0pVmPpU1W1n++gUyOpxFQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vtMAo-0000000E3WL-3Adh;
	Fri, 20 Feb 2026 09:47:42 +0100
Message-ID: <6f14c73b7d513de1da06431d0e421e4792a43655.camel@sipsolutions.net>
Subject: Re: [PATCH 15/15] wifi: mac80211: Use AES-CMAC library in aes_s2v()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard
 Biesheuvel	 <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu	 <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org, 	linux-cifs@vger.kernel.org,
 linux-wireless@vger.kernel.org
Date: Fri, 20 Feb 2026 09:47:41 +0100
In-Reply-To: <20260219221527.GC32578@quark>
References: <20260218213501.136844-1-ebiggers@kernel.org>
	 <20260218213501.136844-16-ebiggers@kernel.org>
	 <c62915b1956ee4c5d4bad9315f2bc44aeddbb9bc.camel@sipsolutions.net>
	 <20260219221527.GC32578@quark>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-02-19 at 14:15 -0800, Eric Biggers wrote:
> > > -static int aes_s2v(struct crypto_shash *tfm,
> > > +static int aes_s2v(const u8 *in_key, size_t key_len,
> > >  		   size_t num_elem, const u8 *addr[], size_t len[], u8 *v)
> > >  {
> > >  	u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE] =3D {};
> > > -	SHASH_DESC_ON_STACK(desc, tfm);
> > > +	struct aes_cmac_key key;
> > > +	struct aes_cmac_ctx ctx;
> > >  	size_t i;
> > > +	int res;
> > > =20
> > > -	desc->tfm =3D tfm;
> > > +	res =3D aes_cmac_preparekey(&key, in_key, key_len);
> > > +	if (res)
> > > +		return res;
> >=20
> > Same here, maybe, technically, but also doesn't matter.
> >=20
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> >=20
> > johannes
>=20
> In this case aes_s2v() wouldn't otherwise be able to fail, so ignoring
> the aes_cmac_preparekey() return value would indeed be a simplification.

Right.

> However, since the key length isn't a compile-time constant here, we'd
> have to rely on non-local validation, which isn't ideal.

That's true.

> To ignore the return value entirely I'd prefer a static_assert that the
> length is equal to one of AES_KEYSIZE_*, which isn't possible here.

Indeed.

> It's actually not clear to me where the length validation happens before
> here.  nl80211_associate() for example just copies the length from
> userspace without validating it.  ieee80211_mgd_assoc() only checks that
> the length is at most FILS_MAX_KEK_LEN (64).

Oh, right, I forgot this was FILS and mixed it up with the previous
patch. We probably _should_ check it earlier there, but it won't be
local here either way, and we have the error paths already so that's
fine.

johannes
