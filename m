Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D533115B1;
	Fri, 20 Feb 2026 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771578082; cv=none; b=KCxwhVuqZ4+huSHZjcGKaMQXmV7TDBzFB72mxOnRnJUzQ82OenK5WtfGYe8F9lkbfMieBTrpxMWAIlwzMkvg1buFCWtYZc43j87AojwXdCIiyBgLhVL9hUz4Cxtrh1KSEMXd1hC3NCj0EIA3Cgpxi6z2W49fmLbjNRvVbUOo6V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771578082; c=relaxed/simple;
	bh=xT43E9Mw/MhVpOUDZdIZqemFKn/S+rp/rN+fbSVYGS0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cB6u1dWZYfz4BR3FzRnlUMsdYvE/rdCSsv4rrj4/yKwzU8RTZJWAQXAYUq7YJQJfSeAVaLlbjHjN5nmWikBYoJCoBXWG5okZZlMSJs3UgazIGBc0N0lG2nmOHvr2W2Y07RVvt9kk/P7UR1UMiaphjotBHppqiOUGWh6KRCxA7qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RL2mb5ip; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RL2mb5ip"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9JHCDgsaPyKfVh78aF3xe4hH753iI0GW0P5ZJDCxIqo=;
	t=1771578081; x=1772787681; b=RL2mb5ipRUSFHtWE4KMIM9clsZxdZ1GDoOwuDV0UpzxjTbj
	VqqVC78lE6ujttKxolaSSvjrD7M1vRSHc2sGAjbRzZgqwYYtTasuWkRLtZ0k7/V81s36C28ihPPSl
	VvudZdHJ4WweGxvTPMvTgADF1F+28wJRCkLoJQFGp6XX1256wHScY3YK++O8uR581g3BRX4faq6RQ
	+yF/3RyGgvQay6P8Vcd3QD/d0jitN2j48KsH1783UWxdTxdMPcFiXCwNoaauASse4G0Bz9tYmsT5m
	NENsGsXDmQXwUMyJSCp+AAZF3ZJ1px3YD7k3szf3pGQ4f0upH55Q9zDR8rJTAISA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vtMNv-0000000E3s8-1FlF;
	Fri, 20 Feb 2026 10:01:15 +0100
Message-ID: <f7091e036f1694d945e728aa58cb7d55ac07f3e1.camel@sipsolutions.net>
Subject: Re: [PATCH 14/15] wifi: mac80211: Use AES-CMAC library in
 ieee80211_aes_cmac()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard
 Biesheuvel	 <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu	 <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org, 	linux-cifs@vger.kernel.org,
 linux-wireless@vger.kernel.org
Date: Fri, 20 Feb 2026 10:01:14 +0100
In-Reply-To: <20260219220211.GB32578@quark>
References: <20260218213501.136844-1-ebiggers@kernel.org>
	 <20260218213501.136844-15-ebiggers@kernel.org>
	 <c3b53ea083fa26c863c6a954d13bbd2ef91e1732.camel@sipsolutions.net>
	 <20260219220211.GB32578@quark>
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

On Thu, 2026-02-19 at 14:02 -0800, Eric Biggers wrote:
> > Looks good to me in principle, I suppose we should test it? :)
>=20
> Yes, I don't expect any issues, but testing of this patch would be
> appreciated.  I don't know how to test every kernel subsystem.

Done, works fine. I checked FILS (which is against hostapd userspace
implementation) and validated the MME MIC against wlantest.

> > > +		err =3D aes_cmac_preparekey(&key->u.aes_cmac.key, key_data,
> > > +					  key_len);
> > > +		if (err) {
> > >  			kfree(key);
> > >  			return ERR_PTR(err);
> > >  		}
> >=20
> > Pretty sure that can't fail, per the documentation for
> > aes_prepareenckey() and then aes_cmac_preparekey(), but it doesn't
> > really matter. We can only get here with a key with size checked by
> > cfg80211_validate_key_settings() already.
>=20
> aes_cmac_preparekey() indeed always succeeds when passed a valid key
> length, as documented in its kerneldoc.  But in this case I recommend
> just checking the error code anyway, since ieee80211_key_alloc() can
> already fail for other reasons (i.e., it needs the ability to report
> errors anyway) and the key length isn't a compile-time constant here.

Right, sure.

> > Since you're probably going to send it through the crypto tree:
> >=20
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> For library conversions like this I've usually been taking the library
> itself through libcrypto-next, then sending the subsystem conversions
> afterwards for subsystem maintainers to take in the next release.  But
> I'd also be glad to just take this alongside the library itself.

OK, whichever you prefer. Feel free to take it, this code did change
recently for some additional error checking, but it otherwise almost
never changes, so there shouldn't be conflicts.

johannes
