Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D706A2F44
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 05:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714368727; cv=none; b=h4edqN2qt3kYvpVPRe/4BmDxe3AvOd2eWUPSxFdQex50+cUYpfzQOfp0R1ORUtiEW3dmFSxfUoiOy5/dzOJhZpobwdSO3OdFOdK1fZLM8Om7ol+sKHuxS4kKGUrF6j6th52ofkF8kwwBBC/OIC4WKtKZJMlooS+dw+foVov2mmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714368727; c=relaxed/simple;
	bh=p3Eum7I6d+MgZJIrdOjx0mNYw+5CYzm3MhSzTQ0hvYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fyRVR3gC76VVPJfGfIj/AvFLHmwIEH+n1f9xp0UF6FFiqQIVOiOh8M89a8QddCvwVmQlMYicUfKdfiy6WbA9TqthVOH9z4tzukDhP1+d12tHDdos2r5C+QUIHVeLnhDcMUphsPq0u7DkGNy9OUmh811mcGo9rgb06lGrhF6UCeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=R+5Sd3XN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="R+5Sd3XN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=p3Eum7I6d+MgZJIrdOjx0mNYw+5CYzm3MhSzTQ0hvYI=; b=R+5Sd3XNJaLVc1j21oKtBfcOPW
	lpLXiogsc5ck4ZzbzEDxSTtjjss5IC6GXv+bTyoMHu1OmAQZNjaJVoLmX1IZb5txwKFf2bJaTxLgV
	za1pdvjS5Ect4ukUnp0MtHtcA3M5/8Bx4x0AhxgFAkvvLD7dkEbMVGZjEGzv0G7tNaiWW+DNS+TDA
	iuZg3KdmEne1MFZK/fr377ux7mU9aB5Apgnpkru1w3P3Z8ZGkC1k2P0gWD2lhMMYoOyDzi+N2pv/q
	waqEtQk6bps9khp/E5a2yLdsiHPObjRJgMK512TcVMTUYhHNYNyBFOCRoVMoaNTMlVEndK5cI/4wA
	00ZmHFJGXfr4LmyMRqEXVEQLu/UTTpULp8xcdvFbz0M/EkaE/4jpTMbS/pV6r/ZOjdQjuP3E3c+Nn
	jlNcVfuiDeGDae8QTSiGilJxD/UZOx4mXFK/UvypmW1z98pc6b5OqgB6TpoeFsOWVvZjOTcq9LrsK
	Ec0y9Chv2HNLoH5fl0/VKEnI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1JcK-008pXz-14;
	Mon, 29 Apr 2024 05:31:57 +0000
Message-ID: <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
Date: Mon, 29 Apr 2024 07:31:54 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: query fs info level 0x100
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>,
 Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------o9RmA0wNNX5GWx15gD3Ex9gS"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------o9RmA0wNNX5GWx15gD3Ex9gS
Content-Type: multipart/mixed; boundary="------------dIbrp0mITgGTkMrG8DbDZ0U9";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>,
 Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
Subject: Re: query fs info level 0x100
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
In-Reply-To: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
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

--------------dIbrp0mITgGTkMrG8DbDZ0U9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8yOS8yNCAxOjI3IEFNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IFRyeWluZyBzb21l
IHhmc3Rlc3RzIHRvIGN1cnJlbnQgU2FtYmEgKG1hc3RlciBicmFuY2gsIFNhbWJhIDQuMjEp
LA0KPiB0aGV5IGZhaWwgYmVjYXVzZSBxdWVyeSBmcyBpbmZvIChsZXZlbCAweDEwMCkgaXMg
cmV0dXJuaW5nDQo+IFNUQVRVU19JTlZBTElEX0lORk9fQ0xBU1MpIC0gdGhpcyB3b3JrcyB0
byBrc21iZCBhbmQgSSB0aG91Z2h0IGl0IHVzZWQNCj4gdG8gd29yayB0byBTYW1iYS4gICBJ
IGRvIHNlZSB0aGUgU01CMy4xLjEgb3BlbnMgd2l0aCB0aGUgUE9TSVggb3Blbg0KPiBjb250
ZXh0IHdvcmtzIC0gYnV0IHRoZSBxdWVyeSBmcyBpbmZvIGZhaWxpbmcgY2F1c2VzIHhmc3Rl
c3RzIHRvIGZhaWwuDQo+IA0KPiBJcyB0aGF0IG1pc3Npbmcgcm9tIGN1cnJlbnQgbWFpbmxp
bmUgU2FtYmE/DQoNCmhhdmUgeW91IGVuYWJsZWQgU01CMyBVTklYIEV4dGVuc2lvbnM/DQoN
CnNtYjMgdW5peCBleHRlbnNpb25zID0geWVzDQoNCkNoZWVycyENCi1zbG93DQo=

--------------dIbrp0mITgGTkMrG8DbDZ0U9--

--------------o9RmA0wNNX5GWx15gD3Ex9gS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmYvMMsFAwAAAAAACgkQqh6bcSY5nkZT
Eg/+Kml14KKdpzxXKljkQr9atTF7jhMlewAs5k4GcXvNNs5cvy4sI2cNxijc3rI0vUb6Fn49W7qo
DHe2/uJ68BhLouV9zLjBDIyKEZPsA6yE3ch9RIH0fd7pHzoVN6QiudIMghM8OUnUlrSrApEJx8sW
Z5vZKcz431bsjNFFrkxhUpLX/mzZE5Bv693Y+0h5uJwIHugxAuVc/kjIRvBRS/NSZwtMASv7W7EQ
wKKDOcxDY63NXAhdgkbBjnMYR2DB0OFdd2Bx2S+4on100dqVyoS3FGvf8AWWosoHeroJwVlJUpL9
T09oYDrxABYLJC+SMyc05Rt9PsWJiQK2YGFAiU+tNXa57b+6ZwjOBcLOZLV+GoXNT7wEVpFpJZNm
xgy/tsY7WSl3WEJKr2EUuMNPCoQEJZ79GLM8cTL0GgOO6OykC6qZ02e9u21VEGyCC4X/CfGxjt9S
hugzOrrO4BX95fQcpDLcrviB6Wl/PEdUg56yB/w5i4SvTgd7uiiajCw8MJUy1TkyycQ+VDpOcJ/T
58cYYPM3feglgT/3bF3aW34CSInx1DVMyaK0a3jekpZ1LI2Srx/OkA99vdnNIysBNyJ41cSk8xng
I7BlAcQTktRkiktBkmJDWCYxFb9eUcZdiZq1W7VykUGuI2fLMN5muPbgTP6/LQBIw515KZVW0xTs
a5Q=
=z2xR
-----END PGP SIGNATURE-----

--------------o9RmA0wNNX5GWx15gD3Ex9gS--
