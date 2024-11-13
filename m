Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8EA15FD16
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731512405; cv=none; b=hZeBXlJ/PuwCeR5yQhKcx7eIPRtAUGk+o/68jqiELPlEOsFqaatk9qxJD0uzBNQW0X0FRdzPhIX7jePugKxErd82gxBI0vRvHEFEwPR1knTIf7q5Nir6PqaU3CLOCPcK2/IrWp++RXflR5iA8nuZqMcpiGK6DK/geTJvmdQSPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731512405; c=relaxed/simple;
	bh=crRol5NZhyJTT3jvRePD4X6EWpa6OruPzhe9l475hu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FzzwmFESJ95n+WvmnDWTaoLK5PunOEm2PLGA8AyXudjX6v52U97g+2wQCNKo+WQSh38C5iGpr+HIAC7ukAVkNkjm1UT7bmtExg34V33aOX0VvC6u/lY+VtydspPsmA3GBcrDoZLGX5BQ3y3AMdGX6W9+WJXQbL0musrSO1/+hG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Z5XC5nbq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Z5XC5nbq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=crRol5NZhyJTT3jvRePD4X6EWpa6OruPzhe9l475hu8=; b=Z5XC5nbqGY2fpHBfL7rAhpuMe2
	TX+ktjFgsrU7Ke81CukdgRMmE9yvfzjynRtT1UU1OftV+bFbuefMKPSdY/FodPFdfRLl50ksJ/rZa
	lfWp7pGfRYqc4Z1ZxcIXFVPxZ99HJr07FSbbb8KMdLOgJk1vRVIBRq7A7nwwWa/8EtN6ol4nBwkTU
	732ws7kUpfvb++6t8A4cIUYB9nP+h9wYNRmywEYPG5YOusYsBxd2p8HtFTk608p6MFot/iPnz002A
	rTAci9LVvEFohP4iXL3ZSivRUv3Za3qP2Sot0thvy22SPP/wj5tcyJ8lvNrh5HOjF+cPxQ9fE8Azq
	gR8XdV68VtHy6Bx54xU4t7e65frzvvK3FkGQDZgVh5R6r92gmwPGKbod29Z9x7Uyvs039gwMJfZpI
	zszQogP3s8eQKM0wajJEt2zDPSVVzDW0/LNtw9IS4+LJiEy2k3vU7RkE+m9Mn8hqPZdu5uw6L0gQI
	pY+rVlWLSRSY94Co2kosnsnq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tBFTF-00APCR-1A;
	Wed, 13 Nov 2024 15:39:53 +0000
Message-ID: <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
Date: Wed, 13 Nov 2024 16:39:51 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: chmod
To: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Jeremy Allison <jra@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Samuel Cabrero <scabrero@suse.de>
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------xIN6F6WOlUflFY00a8Tah9tH"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------xIN6F6WOlUflFY00a8Tah9tH
Content-Type: multipart/mixed; boundary="------------3PV8ilc6YNMvb2sV5rcI5A9F";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Jeremy Allison <jra@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Samuel Cabrero <scabrero@suse.de>
Message-ID: <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
Subject: Re: chmod
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
In-Reply-To: <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
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

--------------3PV8ilc6YNMvb2sV5rcI5A9F
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgUGF1bG8sDQoNCk9uIDExLzEzLzI0IDE6NTEgUE0sIFBhdWxvIEFsY2FudGFyYSB3cm90
ZToNCj4gUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz4gd3JpdGVzOg0KPiANCj4+IElu
IG15IHRlc3RpbmcgYWdhaW5zdCB3aXRoIDYuMTEuNS0zMDAuZmM0MS54ODZfNjQgYWdhaW5z
dCBTYW1iYSBjaG1vZCBpcw0KPj4gbm90IHdvcmtpbmcgb24gYSBwb3NpeCBtb3VudC4NCj4+
DQo+PiBJIGRvbid0IHNlZSBhbiBleHBlY3RlZCBzZXQtc2QgY2FsbCB3aXRoIHRoZSBTLTEt
NS04OC0zLW1vZGUgU0lELCBpdA0KPj4gc2VlbXMgdGhlIGNsaWVudCBpcyBub3QgY29uc2lk
ZXJpbmcgdG8gZG8gdGhpcy4NCj4+DQo+PiBtb3VudCBvcHRpb25zIChhbGwgZGVmYXVsdCBi
ZXNpZGUgZXhwbGljaXRseSByZXF1ZXN0aW5nIHBvc2l4KToNCj4+DQo+PiAvL2xvY2FsaG9z
dC9wb3NpeCBvbiAvbW50L3NtYjN1bml4IHR5cGUgY2lmcw0KPj4gKHJ3LHJlbGF0aW1lLHZl
cnM9My4xLjEsY2FjaGU9c3RyaWN0LHVzZXJuYW1lPXNsb3csdWlkPTAsbm9mb3JjZXVpZCxn
aWQ9MCxub2ZvcmNlZ2lkLGFkZHI9MTI3LjAuMC4xLGZpbGVfbW9kZT0wNzU1LGRpcl9tb2Rl
PTA3NTUsc29mdCxwb3NpeCxwb3NpeHBhdGhzLHNlcnZlcmlubyxtYXBwb3NpeCxyZXBhcnNl
PW5mcyxyc2l6ZT00MTk0MzA0LHdzaXplPTQxOTQzMDQsYnNpemU9MTA0ODU3NixyZXRyYW5z
PTEsZWNob19pbnRlcnZhbD02MCxhY3RpbWVvPTEsY2xvc2V0aW1lbz0xKQ0KPj4NCj4+IElz
IHRoaXMgc3VwcG9zZWQgdG8gd29yaz8NCj4gDQo+IFllcywgYnV0IHRoaXMgaXMgYnJva2Vu
IGZvciBhIHdoaWxlIGFscmVhZHkuICBTYW11ZWwgcmVwb3J0ZWQgc3VjaA0KPiBwcm9ibGVt
IGF0IFNEQyAyMDIzIGJ1dCBub2JvZHkgZml4ZWQgaXQgeWV0Lg0KDQpvaywgSSBnb3QgYSBi
aXQgZmFydGhlci4gSXQgc2VlbXMgdGhlIGNsaWVudCBuZWVkcyB0aGUgbW91bnQgb3B0aW9u
IA0KbW9kZWZyb21zaWQgdG8gdXNlIHRoaXMuIFdoeT8gSXQncyBub3QgZXZlbiBkb2N1bWVu
dGVkIGluIHRoZSBtYW5wYWdlLiANCkZvciBhIHBvc2l4IG1vdW50IHRoZSBiZWhhdmlvdXIg
dG8gc2VuZCBhIGNobW9kKG1vZGUpIGFzIA0KU01CMi1TRVRJTkZPKFNELCBTLTEtNS04OC0z
LW1vZGUpIG11c3QgYmUgdGhlIGRlZmF1bHQuDQoNCkFuZCB0aGVuIHRoZXJlJ3MgYW5vdGhl
ciBwcm9ibGVtLiBUaGlzIGNvbW1pdCBmcm9tIFJvbm55DQoNCjBjNmY0ZWJmODgzNWQwMTg2
NmViNjg2ZDQ3NTc4Y2RlODAwOTc5ODENCmNpZnM6IG1vZGVmcm9tc2lkcyBtdXN0IGFkZCBh
biBBQ0UgZm9yIGF1dGhlbnRpY2F0ZWQgdXNlcnMNCg0KYnJlYWtzIHRoaXMgYWdhaW5zdCBT
YW1iYSBhcyBTYW1iYSByZXF1aXJlcyB0aGF0IHRoaXMgc3BlY2lhbCBTRCBoYXMgDQpvbmx5
IGEgc2luZ2xlIEFDRSB3aXRoIHRoZSBtYWdpYyBTSUQgUy0xLTUtODgtMy1tb2RlIGluIA0K
Y2hlY2tfc21iMl9wb3NpeF9jaG1vZF9hY2UoKToNCg0KICAgICAgICAgaWYgKHBzZC0+ZGFj
bC0+bnVtX2FjZXMgIT0gMSkgew0KICAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQog
ICAgICAgICB9DQoNCkknbSBub3Qgc3VyZSBJIGZ1bGx5IHVuZGVyc3RhbmQgdGhlIHJlYXNv
bmluZyBpbiB0aGUgY29tbWl0IG1lc3NhZ2VzLCANCmJ1dCBJIHRoaW5rIGEgdXNlcnNwYWNl
IGNobW9kKCkgc2hvdWxkIGJlIG1hcHBlZCB0byBhbiBBQ0wgd2l0aCB0aGUgDQpzaW5nbGUg
bWFnaWMgQUNFIGFuZCBub3RoaW5nIGVsc2UuIFNlcnZlciBzaG91bGQgdHJlYXQgdGhlc2Ug
U0RzIHNwZWNpYWwgDQppbnQgdGhlIHdheSwgdGhhdCB0aGV5IHdpbGwgKm9ubHkqIGFwcGx5
IHRoZSBtb2RlIGZyb20gdGhlIFNJRCwgdGhlIG11c3QgDQpub3QgYXBwbHkgdGhpcyBhcyBh
biBTRCAoQUNMKSBpbiB0aGUgZmlsZXN5c3RlbSBhbmQgaGVuY2UgdG8gbWFrZSB0aGlzIA0K
Y2xlYXIgd2UgYXNzZXJ0IHBzZC0+ZGFjbC0+bnVtX2FjZXMgPT0gMS4NCg0KQW0gSSBtaXNz
aW5nIGFueXRoaW5nPyBUaG91Z2h0cz8NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------3PV8ilc6YNMvb2sV5rcI5A9F--

--------------xIN6F6WOlUflFY00a8Tah9tH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmc0yEgFAwAAAAAACgkQqh6bcSY5nkbH
VxAApvlEVoNtLRJZpWgWIJvl9WDlmvWuEBKM9FqmqEUynxNtc8jLGmd/WqrCgXWlVlsorj4wCJst
cBkTY7iiOroC1msA50q0qQ1ZNu0NdHk/ss1bdmCow2AB8i9jD+nGlQ1HNKirIxuMmSxvtm6vu/0+
pLaQVMaR07nOIFFEelrOxoG3vVilNkz5oTpM4Jv/aARx3lA+/t3wCl5CXaoWRAPIVEZGeqD44hdR
L4Zz2mVge8ITW+lMXOJ/og/bQ0SM1f46Ggle8rdKjfdK+cPpE2xtXb/buId3p1vWDYpzfNnsQZEO
/uola9wsZqUz2IfWQOfqBCvb0xk0DZEMigPbooCHY2Lc4C2zhzdFtL9mcHGcAttJpZfkPhmt4vTk
xNHz46JsF9oFjuqO08a3FCHu1/5A3mj+4CP9Mm6c+W4QkRAOlKjZ8pSAWEBnQtffxJ6vCDuWyQpU
SqwfOAvnBUNuouR06wE6mF0wDIvnHBpej70PChoh82JxrMglNtqEo+a4RS8ovK3yzsEpXEXFB6vQ
xgdUcZLfCFazdQ+Z1lVUKXQcnTdSZYE4L4FeuurhlwSBMkDfjUnJUNHalP1NAmXgslTR5sE2qVEf
SQTLjM35UV6Ogh8J7cp1mhSNvHD1SWQ3nQVVzzxDzAPzIhkGR8JJupwx+KhkdrJ9ZLmicsYKlG4p
p7M=
=S4UR
-----END PGP SIGNATURE-----

--------------xIN6F6WOlUflFY00a8Tah9tH--
