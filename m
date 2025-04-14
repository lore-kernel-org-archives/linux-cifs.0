Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0547E4C74
	for <linux-cifs@vger.kernel.org>; Mon, 14 Apr 2025 19:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744657381; cv=none; b=BLQMv8jS75QheX0h0ItvaGpIVGeSZJmW2GD5bQoSIVcymLQ7ptYivC0ZyuuEaclREmVHB1eYnDScyk/Z6hPe3o/1/vqRJV8BUkbQrf8+PQPT5fShFO287hLqNZipF0+mUzrC2ZI3nAx49vAQ0UwM9VC0njkfKgHFZ5H5XDay7tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744657381; c=relaxed/simple;
	bh=J3LGH0ep29MPGt2QhXsO8nSZ8hd7UbDIB3o6lLzjnr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bdE9GEOqwRzG4b09I5Rk5LCsA0gUf3/Z96sNsyjONDBPEaCz/2jF/MfnjW+J+v1ZBgKlqn7lbUXABlxsAs2qSreyV51fd8s3lA/1pwSTfYEDrvSKAnFHKDA+FQdDay71nOnZ/lA0scXfhXxqbBmZkMS5v8+xbDfueIxh9KXK85k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZiavqdaM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZiavqdaM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=J3LGH0ep29MPGt2QhXsO8nSZ8hd7UbDIB3o6lLzjnr8=; b=ZiavqdaMODluBd5w9EydhNKeyI
	dmI7y3CM1tG7YPNRO+Q3b3itj2LCOlhZWFNaFNQCEHqt9++OGZZ5JZ+4iy35EySGADEELf3Gseukh
	AYxgLAkEatuvcHM6g/vrRStuE8LU8Tiuqacty0aMRI1pK/an42CMgfxWszPxd+UP/Bxprpo/oaskA
	7XUH85HUgvjLvTurXUPcDZOEsLcZNpQsV605Qll/S4eJuh5XtUuzHNVMJxnX/XuodRwSRsTpQmC1Y
	93UOeW/mZ3WDCAD8msWiSIl69U26ajvkU1IRnkIf0xDIyYj6ixn3t1MH1Rwyb15tvwdAJTiFIKDas
	pRjAYYdZhl2pcgsgs90Rm/yCD1Q+FnFsD9pGgdai1GgpjCCYckmfiGoZd8HvKQUOitA14567Aloa3
	b2Zz9W+Gw18d8TsNyoXWnJQHUDWY6O0n/vRPblIgRPDReJFulMDga/zWPWDZD97N597Q+OcyliUG1
	E1qCW8VT/RALpFnt0RMzab+f;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u4P4z-009pGA-2A;
	Mon, 14 Apr 2025 19:02:49 +0000
Message-ID: <bfe46e3d-5c7c-42ec-987d-d70b4f513e85@samba.org>
Date: Mon, 14 Apr 2025 21:02:47 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Tom Talpey <tom@talpey.com>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>,
 Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------doGG261B5rdjwIn24ltVY12n"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------doGG261B5rdjwIn24ltVY12n
Content-Type: multipart/mixed; boundary="------------jiqNRYb0M6IQPYAl05gH2ydu";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Tom Talpey <tom@talpey.com>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>,
 Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>
Message-ID: <bfe46e3d-5c7c-42ec-987d-d70b4f513e85@samba.org>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
In-Reply-To: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
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

--------------jiqNRYb0M6IQPYAl05gH2ydu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QXMgZGlzY3Vzc2VkIGF0IFNhbWJhWFAsIHdoYXQgYWJvdXQgdGhpcz8NCg0KaHR0cHM6Ly9n
aXRsYWIuY29tL3NhbWJhLXRlYW0vc21iMy1wb3NpeC1zcGVjLy0vbWVyZ2VfcmVxdWVzdHMv
Ni9kaWZmcw0KDQpPbiA0LzkvMjUgODoxOCBQTSwgUmFscGggQm9laG1lIHZpYSBzYW1iYS10
ZWNobmljYWwgd3JvdGU6DQo+IEhpIGZvbGtzLA0KPiANCj4gd2hhdCBzaG91bGQgYmUgdGhl
IGJlaGF2aW9yIHdpdGggU01CMyBQT1NJWCB3aGVuIGEgUE9TSVggY2xpZW50IHRyaWVzIHRv
IA0KPiBkZWxldGUgYSBmaWxlIHRoYXQgaGFzIEZJTEVfQVRUUklCVVRFX1JFQURPTkxZIHNl
dD8NCj4gDQo+IFRoZSBtYWpvciBxdWVzdGlvbiB0aGF0IHdlIG11c3QgYW5zd2VyIGlzLCBp
ZiB0aGlzIHdlIHdvdWxkIHdhbnQgdG8gDQo+IGFsbG93IGZvciBQT1NJWCBjbGllbnRzIHRv
IGlnbm9yZSB0aGlzIGluIHNvbWUgd2F5OiBlaXRoZXIgY29tcGxldGVseSANCj4gaWdub3Jl
IGl0IG9uIFBPU0lYIGhhbmRsZXMgb3IgZmlyc3QgY2hlY2sgaWYgdGhlIGhhbmRsZSBoYXMg
cmVxdWVzdGVkIA0KPiBhbmQgYmVlbiBncmFudGVkIFdSSVRFX0FUVFJJQlVURVMgYWNjZXNz
Lg0KPiANCj4gQ2hlY2tpbmcgV1JJVEVfQVRUUklCVVRFUyBmaXJzdCBtZWFucyB3ZSB3b3Vs
ZCBjb3JyZWN0bHkgaG9ub3IgDQo+IHBlcm1pc3Npb25zIGFuZCB0aGUgY2xpZW50IGNvdWxk
IGhhdmUgcmVtb3ZlZCBGSUxFX0FUVFJJQlVURV9SRUFET05MWSANCj4gYW55d2F5IHRvIHRo
ZW4gcmVtb3ZlIHRoZSBmaWxlLg0KPiANCj4gV2luZG93cyBoYXMgc29tZSBuZXcgYml0cyBG
SUxFX0RJU1BPU0lUSU9OX0lHTk9SRV9SRUFET05MWV9BVFRSSUJVVEUgdG8gDQo+IGhhbmRs
ZSB0aGlzIGxvY2FsbHkgKCEpIGFuZCBpdCBzZWVtcyB0byBiZSBkb2luZyBpdCB3aXRob3V0
IGNoZWNraW5nIA0KPiBXUklURV9BVFRSSUJVVEVTIG9uIHRoZSBzZXJ2ZXIuDQo+IA0KPiA8
aHR0cHM6Ly9sZWFybi5taWNyb3NvZnQuY29tL2VuLXVzL29wZW5zcGVjcy93aW5kb3dzX3By
b3RvY29scy9tcy0gDQo+IGZzY2MvMmU4NjAyNjQtMDE4YS00N2IzLTg1NTUtNTY1YTEzYjM1
YTQ1Pg0KPiANCj4gVGhvdWdodHM/DQo+IA0KPiBUaGFua3MhDQo+IC1zbG93DQoNCg==

--------------jiqNRYb0M6IQPYAl05gH2ydu--

--------------doGG261B5rdjwIn24ltVY12n
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf9W9gFAwAAAAAACgkQqh6bcSY5nkaK
Iw//a9EZmKYx7arqDWiyJEPhzBlGVlMfqPH+oNZlhHRQGpRASyCyiRaSYdZykcgPseJngEpLVfDt
DeIUlH2MSngET9TPQM38gV7l6wGuLfcdXN/IqIMIzinD20KX8KrcWXy3XALar65kRkD+QchDLqAv
MxE17ABhMFit9YFvHDUjrgz407W6ILFBWL4X1PL6sl4BTo3xGyJiiubmMpUPxZzWDSg+pDvZOaDK
OxViLtCueAw9gCqC+qxztJIza62i7MjEjB45EY56mG2ag/czqiLcBShacd8a8Hf3kAyzbdCWn2Dv
wxV2zXSH0sYxeeMaZHF9xcAdbchVTh7TMiC6Imz5UZe2wSKdU/UBPquFKnao0MUQTZ04qRdQ2D0g
46GWPf8YH73IhDmyhHbwDpqQN2+OcG4XxE3zWME1kyxtIWQxqvu8F1Tuq9XhlK7dRkezjIG3rMX8
/rI6zV/uOAiWkuA7McGNJvN3xgXjGhtPFTTc6ZNWRE1vTimV5ND3NOioM0HuURi4tF8K8Vpuav0u
Q9sroqgMt59YIomBNV0DZ1nJDuzSs6ODofTTWOgo0XaM7WhGHFKbO3vwHfjWm2myFFAQkqY35N4l
19lM+tJNV6S05QBH/BeypAakg7rw0Z2JQk8Oiy/ss35Pmq6dfmldWZr6qop0ERwZs8krOqBSGOwB
/Z4=
=YweZ
-----END PGP SIGNATURE-----

--------------doGG261B5rdjwIn24ltVY12n--
