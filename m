Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D44270EC5
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 18:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744222709; cv=none; b=r+oQkRpViN6cy0SOQqiq3DAPEjEorzPaQF1kOzh5W+9KwZTNtoU59D6jOTuq2fUXI3xr2jQXmMsgM/F+DtdtwUYp+dX34y9LFURHKsU5jlZ0YzgreYoEMkRzSrec7pqmJLUchXDgdSFu3GXa+ED/TrixdWYGwXjvs0+pZhQyDjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744222709; c=relaxed/simple;
	bh=eL2oEJnAL9vVf+dfgpxTMH6cSGedDGOYLaJmiLDGRWU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Z6T/xu2MeY9WeAATQaGWsOhkHAAhBM7toYAwmBBpBG5vLfXskGo/lwMuqMM0VAvJzTmlIlxMx9I9j7B0MrCiIrYRgdJX2wqN3UQCw7wqKE0Of8i7tz5jZbdM6W34dRwtAZneburf22R0wfdeXarQmKuLh1sYkAtAR7EHZxejAvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hxq/kLbf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hxq/kLbf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=eL2oEJnAL9vVf+dfgpxTMH6cSGedDGOYLaJmiLDGRWU=; b=hxq/kLbfCBqf8J+mp2wKOjAgrb
	/3DfpYnBHO1nLyga+wn31CaioteCqlCNep7g9DBjcE69nVKY5wi31hXTJ190ZKO54xCEXZXD7Yy10
	O7AJEREr68ACDY+zE/2OAIzlgACjKvgP87w1oZ0N3lcjPuL/7Vaeg2aaiMB159FHfPuVwNPRld+Ze
	g/IiW1qFFXBGIbpyEU5DXQv0AFpJwe3JSsLP8VqDE4KJDjNtgTkBRlAwspaoT4U923Ze42dyRTCyS
	Pp/ZWtjUmpHZMwSLMVVm/DSe+KkKra4AYIqJcPNNzFRhCAAke+FZEH94fCY26/544FivFhMtlKbfL
	YwkzYOUpjOkP7ij1j8D7Ak20IKvbCX3K7DbUkaHkdvV6wdt+RMqs4CJw472a6mDQI0lLh+pvBLTz3
	VziEU7AUU6CZUjRolTjr4zbWfTdYkKVF4Hicu9hXXMfH4QGimjhgx1bZzqnCGdNmXMuL+mJqRKksL
	F14Ku5P0NF0Fs+y+hXf3Kx3I;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2a0F-008xVS-2i;
	Wed, 09 Apr 2025 18:18:23 +0000
Message-ID: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
Date: Wed, 9 Apr 2025 20:18:22 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Tom Talpey <tom@talpey.com>, Steven French <Steven.French@microsoft.com>,
 Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>
From: Ralph Boehme <slow@samba.org>
Subject: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------004DSA1vM0zjHiF7aKkzJj5D"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------004DSA1vM0zjHiF7aKkzJj5D
Content-Type: multipart/mixed; boundary="------------0W4MGtXi4LRnJg0Y6djN6hHi";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Tom Talpey <tom@talpey.com>, Steven French <Steven.French@microsoft.com>,
 Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>
Message-ID: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
Subject: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
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

--------------0W4MGtXi4LRnJg0Y6djN6hHi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZm9sa3MsDQoNCndoYXQgc2hvdWxkIGJlIHRoZSBiZWhhdmlvciB3aXRoIFNNQjMgUE9T
SVggd2hlbiBhIFBPU0lYIGNsaWVudCB0cmllcyB0byANCmRlbGV0ZSBhIGZpbGUgdGhhdCBo
YXMgRklMRV9BVFRSSUJVVEVfUkVBRE9OTFkgc2V0Pw0KDQpUaGUgbWFqb3IgcXVlc3Rpb24g
dGhhdCB3ZSBtdXN0IGFuc3dlciBpcywgaWYgdGhpcyB3ZSB3b3VsZCB3YW50IHRvIA0KYWxs
b3cgZm9yIFBPU0lYIGNsaWVudHMgdG8gaWdub3JlIHRoaXMgaW4gc29tZSB3YXk6IGVpdGhl
ciBjb21wbGV0ZWx5IA0KaWdub3JlIGl0IG9uIFBPU0lYIGhhbmRsZXMgb3IgZmlyc3QgY2hl
Y2sgaWYgdGhlIGhhbmRsZSBoYXMgcmVxdWVzdGVkIA0KYW5kIGJlZW4gZ3JhbnRlZCBXUklU
RV9BVFRSSUJVVEVTIGFjY2Vzcy4NCg0KQ2hlY2tpbmcgV1JJVEVfQVRUUklCVVRFUyBmaXJz
dCBtZWFucyB3ZSB3b3VsZCBjb3JyZWN0bHkgaG9ub3IgDQpwZXJtaXNzaW9ucyBhbmQgdGhl
IGNsaWVudCBjb3VsZCBoYXZlIHJlbW92ZWQgRklMRV9BVFRSSUJVVEVfUkVBRE9OTFkgDQph
bnl3YXkgdG8gdGhlbiByZW1vdmUgdGhlIGZpbGUuDQoNCldpbmRvd3MgaGFzIHNvbWUgbmV3
IGJpdHMgRklMRV9ESVNQT1NJVElPTl9JR05PUkVfUkVBRE9OTFlfQVRUUklCVVRFIHRvIA0K
aGFuZGxlIHRoaXMgbG9jYWxseSAoISkgYW5kIGl0IHNlZW1zIHRvIGJlIGRvaW5nIGl0IHdp
dGhvdXQgY2hlY2tpbmcgDQpXUklURV9BVFRSSUJVVEVTIG9uIHRoZSBzZXJ2ZXIuDQoNCjxo
dHRwczovL2xlYXJuLm1pY3Jvc29mdC5jb20vZW4tdXMvb3BlbnNwZWNzL3dpbmRvd3NfcHJv
dG9jb2xzL21zLWZzY2MvMmU4NjAyNjQtMDE4YS00N2IzLTg1NTUtNTY1YTEzYjM1YTQ1Pg0K
DQpUaG91Z2h0cz8NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------0W4MGtXi4LRnJg0Y6djN6hHi--

--------------004DSA1vM0zjHiF7aKkzJj5D
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf2ue4FAwAAAAAACgkQqh6bcSY5nkZ+
chAAlBxYxMmJvWTCCeym5jj/L+N5XOeDXsjw369kRjtGOurPdeO35tU2AgafBgRUDS7aN7Izz9lG
OCwETliwnjS3Ps7GYHbB8Y1lXwhXc1eSSQZ3FNQfEp9ksY/cJ8mXYU5hsFzbPDnGNU1ao8qRXG9W
kGiDcQGhP1IUuVNA+alW43+bWAyEM/0Nj5SJ8v9zQPbCZPPsn0W3/q8gIF/Iyw18QLlos388HqoZ
TCC6VPmtRAwfCtJZ5BzFVApyfSKAFqaJGinwlTtxrb4fvjiHQ24gsW+mYojhIJ2fMq0uuul2Sj9E
PeGWyERaHAPEOYz+t46J1Xg+KijYEJWZgqOyo5xB1Dw9JuPuRgXT7Cjd0q37JsD+mns3cWuNLz0E
lANTiiyayB4B25kpcL0td3xAizL/D4NyYaFgt/5sU9tkMHO9WPl787rOx+yrJJh8LyUB+Pv9Ji+V
PXrPcL5VpoVQKz88ZoeLcudwq3nWjfEQGU6BpnqJPB3wPWU6mIxVC2FAf40aKrVmmhjsRCFSoWz4
+tvQL3kyQGYoUlypvVPyWWmi5gI4rdJ8YrHYwsw3i3XdYVuiFIZFF7NCA3WNgnYFpbtP29kXYVK/
zAZShupHRSHzMhMXblX07Sic/1JbGPh3frQjVqPFYz7oH+71couJ7vc4/vMJX1wfHHxeAy0gULcd
WsM=
=v0BM
-----END PGP SIGNATURE-----

--------------004DSA1vM0zjHiF7aKkzJj5D--
