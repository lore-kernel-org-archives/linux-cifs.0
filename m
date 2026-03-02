Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D9D31064B
	for <linux-cifs@vger.kernel.org>; Mon,  2 Mar 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772473772; cv=none; b=LSB6X6/eTtfWuA/sGk6U/2v8zllHoHenp9lIEBiPzgjQmjIADP4iocYqNkFvqwRXj4ebxSIv1jTC1lfQDWj3nETyQKs3mfEIXl6DY3YM80rl7KywfR4o/3GaJxEdSb5RfF61aMmTkcgcbnskhATdiUzWFwkeRRzKQIULJtTPCHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772473772; c=relaxed/simple;
	bh=E/4d+iT3fad7qnGRBDmaFNVGVrWOGCFgDHLGZXdQ/BE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Pkp6ERklrkmHPEYKARjmuv0diev4BNYq0ibSY6YdUYzpQnpTZ8/MMguDhG/SJNb01zSGm33lM7mSrGUcf7hRMc9qB4A/GFTLJAA21I2WcyrYYFwll7QV5U9UYQmGNC4HVnr/Nzr+v5s2AscHnbLqxfgZph/nysA9cHompCuRKUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1dFEdJW0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1dFEdJW0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=E/4d+iT3fad7qnGRBDmaFNVGVrWOGCFgDHLGZXdQ/BE=; b=1dFEdJW0eaiGUEF1o9HDo93sIM
	HMUjZmTpX8+WBlIMI6a01NckbxBtpr/Z50n4sapPzShYWZwyYGSmultgica49/sTIfFqFVRCHxW/4
	MopFN5peZWAxVLAISqUa9us1acbI7Qn5+AfZIo+NFLuwSoBTca5YOg/M0ehqr3lWDeQ5xdeza254f
	tPnF4j7qgUKh8gvWPDvB3Hc/qrmEda3Sb5DaU8AjJPHS3oZUdIRvFVW0383Zb4/29E9Z8ysMn5FNS
	UdXk9BNvO3MYIBn5D1DvIBHX+QWAGzHQJPR9A1lY7GWvU/RrbfmIizOge0/n3JcM+O1Yi6zKd4yvA
	FB5Ou7Af7bXSNU/E/Np5Je5Ev99r8fUOLM+z3ng0ZkByCFuhRvBIPGi6/x2De53l61gtSR5p4YUsG
	Vk/vcvtwZjo+y8XKm3jEdJpwS1yt1Hq8GWFe9OVouwPWx9qkq7Ye1NDkT3CrZbZGTN3TPPi7rQ5Jo
	VfvYQzMdXV4pOW2AFLzpb9Bq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vx7OU-00000009bVC-0mVh;
	Mon, 02 Mar 2026 17:49:22 +0000
Message-ID: <ec3f44ea-6c3b-48b8-9ebf-a2a23ee5891b@samba.org>
Date: Mon, 2 Mar 2026 18:49:21 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
Subject: SMB3 POSIX: how to handle file deletion if the READ-ONLY attribute is
 set
To: "cifs-protocol@lists.samba.org" <cifs-protocol@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Tom Talpey <tom@talpey.com>, Jeremy Allison <jra@samba.org>,
 Steve French <smfrench@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------cjm9laa74fWUm022WUomoQxM"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------cjm9laa74fWUm022WUomoQxM
Content-Type: multipart/mixed; boundary="------------7jnGMRQQaJH13Br8PiAJLUaO";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: "cifs-protocol@lists.samba.org" <cifs-protocol@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Tom Talpey <tom@talpey.com>, Jeremy Allison <jra@samba.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <ec3f44ea-6c3b-48b8-9ebf-a2a23ee5891b@samba.org>
Subject: SMB3 POSIX: how to handle file deletion if the READ-ONLY attribute is
 set
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

--------------7jnGMRQQaJH13Br8PiAJLUaO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZm9sa3MsDQoNCmFzIHBhcnQgb2YgdGhlIGZ1bmRlZCB3b3JrIHRvIGZpbGwgaW4gbWlz
c2luZyBwaWVjZXMgaW4gdGhlIFNNQjMgUE9TSVggDQpzcGVjLCBJIHBpY2tlZCB1cCBvbiB0
aGUgb2xkIHByb2JsZW0gb2YgaG93IHRvIGhhbmRsZSBmaWxlcyB3aXRoIA0KUkVBRC1PTkxZ
IGF0dHJpYnV0ZSB3aGVuIGRlbGV0aW5nIHRoZSBmaWxlLg0KDQpDdXJyZW50bHkgdGhlcmUn
cyBubyBtZW50aW9uIG9mIHRoaXMgaW4gdGhlIHNwZWMuDQoNCklpcmMgdGhlIExpbnV4IGtl
cm5lbCBjbGllbnQgaGFzIGZhbGxiYWNrIGNvZGUgdG8gaGFuZGxlIHRoaXMgd2hpY2ggaXMg
DQpub3QgaWRlYWwuDQoNCkEgd2hpbGUgYWdvIE1TIGludHJvZHVjZWQgRmlsZURpc3Bvc2l0
aW9uSW5mb3JtYXRpb25FeCB3aGljaCBpcyBhbHNvIG5vdCANCmlkZWFsIGFzIGl0DQoNCi0g
cmVxdWlyZXMgZXhwbGljaXQgaGFuZGxpbmcgaW4gc2VydmVyIGFuZCBjbGllbnQgYW5kDQoN
Ci0gZG9lcyBub3QgYWxsb3cgdG8gYnVpbGQgYSBzaW5nbGUgcm91bmQgdHJpcCBjbGllbnQg
aW1wbGVtZW50YXRpb24gdGhhdCANCndvcmtzIGluIGFsbCBjYXNlcyBpbmNsdWRpbmcgc3Vi
dGxlIG9uZXMgbGlrZToNCg0KMSkgRmlsZSB3aXRoIEZJTEVfQVRUUklCVVRFX1JFQURPTkxZ
IHRoYXQgYWxsb3dzIERFTEVURSBhbmQgDQpGSUxFX1dSSVRFX0FUVFJJQlVURVMNCg0KMikg
RmlsZSB3aXRoIEZJTEVfQVRUUklCVVRFX05PUk1BTCBhdHRyaWJ1dGVzIHRoYXQgYWxsb3dz
IERFTEVURSBhY2Nlc3MgDQpidXQgbm90IEZJTEVfV1JJVEVfQVRUUklCVVRFUw0KDQpZb3Ug
Y2FuIG9ubHkgZGVsZXRlIDEpIGlmIHlvdSBvcGVuIHRoZSBmaWxlIHJlcXVlc3RpbmcgDQpG
SUxFX1dSSVRFX0FUVFJJQlVURVMgYWNjZXNzLg0KDQpZb3UgY2FuIG9ubHkgZGVsZXRlIDIp
IGlmIHlvdSBkb24ndCByZXF1ZXN0IEZJTEVfV1JJVEVfQVRUUklCVVRFUyBhY2Nlc3MuDQoN
CllvdSBjYW4ndCBoYXZlIHlvdXIgY2FrZSBhbmQgZWF0IGl0LCB5b3UgY2FuJ3QgaGF2ZSAx
KSBhbmQgMikgd29ya2luZyBhdCANCnRoZSBzYW1lIHRpbWUgd2hlbiB1c2luZyBGaWxlRGlz
cG9zaXRpb25JbmZvcm1hdGlvbkV4IGluIGEgc2luZ2xlIHJvdW5kdHJpcC4NCg0KSSB3YXMg
d29uZGVyaW5nIGlmIHdlIGNvdWxkIGRvIGJldHRlciB0aGVuIHRoaXMgYW5kIGNhbWUgdXAg
d2l0aCB0aGUgDQpmb2xsb3dpbmc6DQoNCjxodHRwczovL2dpdGxhYi5jb20vc21iMy1wb3Np
eC1leHRlbnNpb25zL3NtYjMtcG9zaXgtZXh0ZW5zaW9ucy8tL21lcmdlX3JlcXVlc3RzLzE+
DQoNClRoZSBnaXN0IG9mIHRoaXMgaXM6IG9uIGEgUE9TSVggaGFuZGxlIEZJTEVfQVRUUklC
VVRFX1JFQURPTkxZIGdldHMgDQppZ25vcmVkIHdoZW4gZGVsZXRpbmcgZmlsZXMgZ2l2ZW4g
dGhlIHVzZXIgaGFzIEZJTEVfV1JJVEVfQVRUUklCVVRFUyBpbiANCnRoZSBmaWxlc3lzdGVt
Lg0KDQpJJ3ZlIGltcGxlbWVudGVkIHRoaXMgZm9yIHRoZSBzZXJ2ZXIgaW4gU2FtYmE6DQoN
CjxodHRwczovL2dpdGxhYi5jb20vc2FtYmEtdGVhbS9zYW1iYS8tL21lcmdlX3JlcXVlc3Rz
LzQ0NDA+DQoNClRob3VnaHRzPw0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------7jnGMRQQaJH13Br8PiAJLUaO--

--------------cjm9laa74fWUm022WUomoQxM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmmlzaEFAwAAAAAACgkQqh6bcSY5nkZg
HQ//Z1+ED2s2kiu8y1ArD2vKvaS87FOWL+kbvG70wpd1U1nz4WhbQvxanTP8wxZL3Jo06g1OsXV/
jD03GBs2zorqciHlOBf1bHw46kkovYyfviKilUoU842aen/ZN/yFaHxAp5nfUW8HwlVEl/gId84w
MTvomsfuQ3syBj5/MXRfF2Fqb3kkW4l7GdV16LmjmT+S7BogrLWFrxrpHPuiQYL55xqiKSUPbbz8
TE1G9xv8VI1WS3Vtu7viv9IurvdPOOItWARrCKWqq4vXn7+1w100uR48s39jmH3X4ifgJlAfnLjO
QKXFgVs9nC8SHjzJaWDVM4TU7n/BEizx4/3dNZzQqQ2UVDI4cgACFh9OprfXEfat/BWafbfWkCOB
ftooN66y9tuz39YpxaTX9jqX2zntQFHCzWcGU8vDN9b158pOlji7TeBFA7C8dp5vZS8A+3U3qIaF
duZDPB2p6A9FtqJyI+X0XwvahiR3MBTl0b7fXncSX4JlZaxm6Ntld3sXtq1hXAcieQIoS0BgCmiV
nuanWPTCgKQKu7nb8prYXtfbEx736OkJWlX02C+jCsCNqg9flNN93p8H21yUz8PMXHdFxNSOaJBN
EkbBlyNfxyr3e907eFisMzOY9OBC/AHTYR3VP3svRu1V/HGNeIStVQ6daqCTaIBeR9LfBqvJaJ8/
cpc=
=7i3+
-----END PGP SIGNATURE-----

--------------cjm9laa74fWUm022WUomoQxM--
