Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49CB334371
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755709866; cv=none; b=ZC+r0/gRZncncI7cwVpS+EADmWhJ5K2AisCu6mw8A+wdbJlNlvIgDDOug09pQlRDNPELUVCmLugx4DV4OiqzAiATCmrw47CLY+0W0LqThBHHw1yph+sLYvuuHWWtdfJ1C9ItxztDaQKQqj/8rSfxyQoK8VbjHiS/PCwpKkA57nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755709866; c=relaxed/simple;
	bh=WEZkXEJg+hGB+jnpYbUZvIYD5Hy2rCcX9Uf7esTs+7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Jw9gPuOhmdoXteyH3d/ozTvsFSLvC0OenYgiLB4O6LGxOEi09QOvwR52lq0lcUOg/dSCzDugrPqIj1el3YLhJGUs6yfGPlHNaTW2QgHoK67v7N4zFtAmoXT6Y8gldqsxaBqi1gan2Y2ViVxohEtAoyJIUtvsZl3HJxP3yBv0C5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nfDaDrZh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nfDaDrZh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=WEZkXEJg+hGB+jnpYbUZvIYD5Hy2rCcX9Uf7esTs+7U=; b=nfDaDrZh274HL8YnoJmE79dM29
	o4seJKqfy/B8NXkEdT/5+CTofbyvhPgi82JwMSWunSEN+/LCaYMdS4mMAlasrlG79jWj8Ba9gSZvm
	PsCY3yqAw47LIc1en7Tf0qGR9Xi2A/jhWnQjblNuGGYPSuKIqjBFyT+PTy/tGOJu+P4tR8FxChrZP
	9BoS2ODUM2E1/j20am127r60gvPnPadc2pE9Uhtzx3h/x2ZhlfU5gJQQImU6WDmwBbmd5Vv+9TnH/
	ThfzJcV8bnT2KzXu2uSo5yGLSHycJLnxIz3t4qQn296pyKrJF04aWYgI9/w76sMSHttlQO7nWvG0w
	RCFB80838gqstDw6Q7j5cJtP1WlUz47SHruD/CFwgb6B6f4OY88K1BxBGnqu9ZefZU8ipW/chtrTu
	TqaHJz6LtFD0ClLArjwh0WAzFvIE+sfkv3jRwbL6KkiUcyJu955Ky7LhZeZZ/MWy9YIfg7Cr6SgS4
	WndwWP+wCFXvurwOmAEcwm1L;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uomKt-003szc-2J;
	Wed, 20 Aug 2025 17:10:55 +0000
Message-ID: <b5349366-04ee-48cd-8126-9af10c2404ea@samba.org>
Date: Wed, 20 Aug 2025 19:10:55 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: [PATCH] ksmbd: allow a filename to contain colons on
 SMB3.1.1 posix extensions
To: Steve French <smfrench@gmail.com>
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
 <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>
 <CAH2r5muNhfk-CHLYLcKMU+yXGqfiQtrZZ5ogf0PJcTsGTiBAJQ@mail.gmail.com>
 <CAH2r5mtB0aNQMYzUhgu0_xRzkWL1xYoRa6b5a5CiKUhV+WU_QQ@mail.gmail.com>
Content-Language: en-US, de-DE
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mtB0aNQMYzUhgu0_xRzkWL1xYoRa6b5a5CiKUhV+WU_QQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tt0ffR1Ov6DmzMfCq6rK3r2G"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tt0ffR1Ov6DmzMfCq6rK3r2G
Content-Type: multipart/mixed; boundary="------------RrmNcCiGURyy7E02kAtUKq9M";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <b5349366-04ee-48cd-8126-9af10c2404ea@samba.org>
Subject: Re: Fwd: [PATCH] ksmbd: allow a filename to contain colons on
 SMB3.1.1 posix extensions
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
 <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>
 <CAH2r5muNhfk-CHLYLcKMU+yXGqfiQtrZZ5ogf0PJcTsGTiBAJQ@mail.gmail.com>
 <CAH2r5mtB0aNQMYzUhgu0_xRzkWL1xYoRa6b5a5CiKUhV+WU_QQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtB0aNQMYzUhgu0_xRzkWL1xYoRa6b5a5CiKUhV+WU_QQ@mail.gmail.com>

--------------RrmNcCiGURyy7E02kAtUKq9M
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8yMC8yNSA2OjQzIFBNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IEFkZGluZyBzYW1i
YS10ZWNobmljYWwgaW4gY2FzZSBvcGluaW9ucyBvbiB0aGlzDQoNCnllcy4gOikNCg0KTm8g
cmVtYXBwaW5nIGZvciBQT1NJWCBwbGVhc2UuIFRoYXQgbWVhbnMgbm8gc3RyZWFtcyBzdXBw
b3J0IGZvciBQT1NJWCANCmFuZCB0aGF0J3MgZ29vZC4NCg==

--------------RrmNcCiGURyy7E02kAtUKq9M--

--------------tt0ffR1Ov6DmzMfCq6rK3r2G
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmimAZ8FAwAAAAAACgkQqh6bcSY5nkah
1Q//Rvcp08uAkwJsMOTdK7xev+Qdvv8Z2WV0U5CcgNoCvae1c02INfFlzuqqEKnf6vInuCbqVl6L
dDscyzHxEfF/wGj34ZhC0oAsxRAGrUeFUEApMANjUvMD5dvGDOPSDgY4dVIjPZcatAfjPoVokKKc
364vvCysje06xc4YAk7kPpc0cRKL19G4K60x2osXaRYSxJNF2kab7H3CVpfOWYcYUmc1oDMNPB/k
hJM3SXklCkeD46cyne7gIzioLZZqbXByx3/DcKhHGbAbC8g1mgb8FBIFN8nmz1VfQ4ZyrCoLiRSH
floSJD2a4hxuhvZp9IRi8/PGcalOWuBaGR85XE6CIbSMfeJmq/BLYG4bkpL6V2gPKUUTgn6uof+L
0WvA0mm1f91Vmry9sQpJzF14T+Re0+m7DHPsGQ4jIdSmr2mIaEo4ZQC7T4O+VNbMv8RbaeK5wlQt
GSKijgpn9FllpxeyPWr1KGHqdPvwc5Ekcy+tOfmCpmSS3X4kRLqK7bXECWTKoMFBveGpG+S6dHj4
893WllPNji1pFwU0ByXz+4cf/P7ftj53sfkysuainmD046/uJY2SiSCGyHJYbfzjHbnthgykU92B
HCql5k7LYLEhqbJUqYnBcJhPP4xI707G87mS4bLgSGwG4iJ8wTUdu3FxE4AEJL96invWrMnzVg9H
Xx4=
=J49c
-----END PGP SIGNATURE-----

--------------tt0ffR1Ov6DmzMfCq6rK3r2G--
