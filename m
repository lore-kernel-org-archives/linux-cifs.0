Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70A1131188
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542308; cv=none; b=Qs0wU5z+VI/xzxZwJbZja6aQtUE4/GLeTMTxp49F2tWd4pIpBzDBGh280gRKvJz1ST/U1ylCgetKCRA0Cc0nTK+7x4voUjqSq14ol2dZT6esQwMKRgWH6GZdfCiDtu/ybLJPJh9za1+PoL6PZgwDtmPAvPelFd+j2MWSGGs2LU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542308; c=relaxed/simple;
	bh=yidgnp2eXeizX7W6Uz2vJpOpSRPjfAIACyTsTwt/aO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YC4cp36zVSMo/18ktPD3tmjFXVn5nPbETdyZFnoFol+p4QQDvUyk/4TPVmKvNQPgRwKL04NHgZI39e7LL0EGpVf5z5aGOFlFMAwFvJzIzQb16kB/4LiPgicA4dhDTJXwewGVvZKr7+MGMIY/EVOTxroRHUVUHKxq69YowF9boo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=epr4DHq4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="epr4DHq4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=yidgnp2eXeizX7W6Uz2vJpOpSRPjfAIACyTsTwt/aO8=; b=epr4DHq4V36isLbS6aVxx+hI2m
	d+yr2lzvPnzeDFUQa+KRvHufw7Xq/QZAF68Wf73FZt2IFbkWkTMyPhDCHffxlTcvh6bV8lDPONLin
	D4PKdznGPbxKq8GhJF9uqsdstuMnWM5Y3E4lxNwJlCseCIWGl6rt/aX4c+wrNr48rCSW5NU43zhPD
	yJN+FJXcAvHYOqtMBou0g4zEyzsIk6G+pLD1BAqw3JL83So4tYCkq/aaDmDX5JyVMggstc1ieSrsp
	EirbkUzBRc0p4izAi8OjejFuBpNedP73lawXrGdBMBCW5pwrPmt/Fa4QRX/17yzPI5XGiR2RhJ3NO
	07fFcGJnPtapMXy0eOJ4gPmE/vHQE59DpjnKX/LcEr9YkUT6siPtIwamSbX0BckDpkLmuIScmoW7A
	3qK0fPRbxYaLJvXif+C82MqMqztg+2902Yhj5rILp+TeWaGmePTWb4YXCdRs2x45k9nVUR4MA777/
	y/H+G9GVYQwyGlwNJ7FRBbmo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxqd5-007HPy-1W;
	Fri, 19 Apr 2024 15:58:23 +0000
Message-ID: <1ea601ed-b40b-4116-b378-32508a6619d7@samba.org>
Date: Fri, 19 Apr 2024 17:58:22 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Missing protocol features that could help Linux
To: Jeremy Allison <jra@samba.org>, Andrew Bartlett <abartlet@samba.org>
Cc: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
 <c7d80c1538db3a414636977314feba13871907ef.camel@samba.org>
 <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------vWthM8oT5NlLwYqNGG6yzJBQ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------vWthM8oT5NlLwYqNGG6yzJBQ
Content-Type: multipart/mixed; boundary="------------0Y2HB0CSVNKjw37gX8pscK02";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>, Andrew Bartlett <abartlet@samba.org>
Cc: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <1ea601ed-b40b-4116-b378-32508a6619d7@samba.org>
Subject: Re: Missing protocol features that could help Linux
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
 <c7d80c1538db3a414636977314feba13871907ef.camel@samba.org>
 <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
Autocrypt-Gossip: addr=jra@samba.org; keydata=
 xsDiBDxEcLsRBADMQzpWoVuu4oiq23q5AfZDbakENMP/8ZU+AnzqzGr70lIEJb2jfcudViUT
 97+RmXptlnDmE4/ILOf6w0udMlQ9Jpm+iqxbr35D/6qvFgrgE+PnNAPlKSlI2fyGuLhpv1QP
 forHV13gB3B6S/ZWHpf/owKnJMwu8ozQpjnMnqOiVwCg8QnSX2AFCMd3HLQsqVaMdlO+jBEE
 AKrMu2Pavmyc/eoNfrjgeRoNRkwHCINWO5u93o92dngWK/hN1QOOCQfAzqZ1JwS5Q+E2gGug
 4OVaZI1vZGsAzb06TSnS4fmrOfwHqltSDsCHhwd+pyWkIvi96Swx00e1NEwNExEBo5NrGunf
 fONGlfRc+WhMLIk0u2e2V14R+ebDA/42T+cQZtUR6EdBReHVpmckQXXcE8cIqsu6UpZCsdEP
 N6YjxQKgTKWQWoxE2k4lYl9KsDK1BaF6rLNz/yt2RAVb1qZVaOqpITZWwzykzH60dMaX/G1S
 GWuN28by9ghI2LIsxcXHiDhG2CZxyfogBDDXoTPXlVMdk55IwAJny8Wj4s0eSmVyZW15IEFs
 bGlzb24gPGpyYUBzYW1iYS5vcmc+wlcEExECABcFAjxEcLsFCwcKAwQDFQMCAxYCAQIXgAAK
 CRCl3XhJ1sA2rDHZAKDwxfxpGuCOAuDHaN3ULDrIzKw9DQCdHb3Sq5WKfeqeaY2ZKXT3AmXl
 Fq7OwE0EPERwvhAEAIY1K5TICtxmFOeoRMW39jtF8DNSXl/se6HBe3Wy5Cz43lMZ6NvjDATa
 1w3JlkmjUyIDP29ApqmMu78Tv4UUxAh1PhyTttX1/aorTlIdVYFjey/yW4mSDXUBhPvMpq52
 TncLRmK9HC6mIxJqS0vi6W9IqGOqDRZph3GzVzJN7WvLAAMGA/sGAyg2rVsBzs77WH0jPO+A
 QZDj+Hf/RFHOwmcyG7/XgmV6LOcQP4HfQHH3DGYihu5cZj3BeWKPDJnjOjB2qmr+FTjYEsjw
 LDBNG7rjRye412rUbNwmEtcD2/dw4xNyu5h2u+1++KVBPf4SqG/a10gDqGJXDHA1Os5MmnQl
 3CTq9sJGBBgRAgAGBQI8RHC+AAoJEKXdeEnWwDasbeIAoL6+EsZKAYrZ2w22A6V67tRNGOIe
 AJ0cV9+pk/vqEgbv8ipKU4iniZclhg==

--------------0Y2HB0CSVNKjw37gX8pscK02
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8xOS8yNCAxNzo1NSwgSmVyZW15IEFsbGlzb24gd3JvdGU6DQo+IFBPU0lYIGxvY2tz
IGNhbiBiZSBzcGxpdC9tZXJnZWQvb3ZlcmxhcHBlZC4gV2luZG93cyBsb2Nrcw0KPiBtdXN0
IGJlIGRpc3RpbmN0LiBDdXJyZW50bHkgb3ZlciBTTUIzIHdlIG9ubHkgZXhwb3NlIFdpbmRv
d3MNCj4gbG9ja3MuDQoNCm1heWJlIHRoZXkgY2FuIHVzZSB0aGUgZXhwZXJpbWVudGFsIFNN
QjMgVU5JWCBleHRlbnNpb25zPyBUaGF0IHNob3VsZCANCmFsc28gZW5hYmxlIFBPU0lYIGxv
Y2tpbmcgYmVoYXZpb3VyIGZvciB0aGUgY2xpZW50Og0KDQpzbWIzIHVuaXggZXh0ZW5zaW9u
cyA9IHllcw0KDQpDaGVlcnMhDQotc2xvdw0KDQo=

--------------0Y2HB0CSVNKjw37gX8pscK02--

--------------vWthM8oT5NlLwYqNGG6yzJBQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmYilJ4FAwAAAAAACgkQqh6bcSY5nkYF
qQ//Tvp3ZsI0UBOWuHn8nWNCrUaHTJvznfFhi3dlBpWreX8bT3+GLT4sxPXO0UVsiW2Io9xBussX
rkd31y9QwPBH3XdhVoqE1JHMXIXp8zSpFUdJU7K2T3IJcNiaOkKJMdxGUYF53dFJKp7VXLUvYVdM
Wyu2230+tr0lLiLzPUSKCV0/Aa084jIqdkMEvnfntlcaqUsEx+J+Zu24ldpTTfxMLuJr9v4QkxoM
6qZ7P+u7eFSxCBddXP2r8hKoSHRXBXmo7+JHECFqflNhsXMrE7mLUQwoKjkwrpaYLsZ1sMhEt+xr
ff7L57BmuxRqHqRTgJJp7R9W1vtZ3CWUUnvouLue7j9QWkKY14awLE8Ukvpz5wnoFE1TQJB/uyOn
ARXh+8lcAD39gA03+gAYZlswJxVcfvlVVSlLRkfGdSZmtN9IEb+za4FEwsM8jt/kcRmTW9SIz/uC
RlVki8yzpzhTl/B5hLgbqgsqSFDKzwZyvHa6Xiv2OeA0pwJMoI6A9ubeW70FrJdWo1lt2roJhYrZ
bL2a3rSv5RbvNksyhGn3UZYWn5vBatF7+qq7yf1qGmVevI2BRyi9OCeKsrcYozcJ99Ge5GPtqrJo
h2NtEjvX9ytcrgGJC7Dm4yKKUnm8eaKxdi9jBMzFb4sZ+XVzqfrOea2JpDBpaCGxTrh26KPgLH6h
uBI=
=dUum
-----END PGP SIGNATURE-----

--------------vWthM8oT5NlLwYqNGG6yzJBQ--
