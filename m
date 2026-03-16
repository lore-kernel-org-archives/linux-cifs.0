Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61D934F46F
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 10:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773656546; cv=none; b=TWuBoIAWxgvF+C8UreUpQ9Fq9RgXXsSQkFRivgcO9PsL+mcy2PaM/tu969YrpEYP13eV53T5Po8JDFBzI02wUcgLsGOAWGxH51nqjoxWX6YB9NHsujjkugAuybTKwF6Gi9/RCpz4/+vHrB6V9gxOd0SPa/ZyNqjALz6hkao6VKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773656546; c=relaxed/simple;
	bh=pAWC55HyAKzxPwpzeekF29/LOzo8IcAu+BzhG7wjOAI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=BVVwk/uAJ5MnSDbK2WW094RRm18DQmIZvOWFMOPUpMDgBxDUbnKseZoMbEG3kGnGd3mncGHmcnoVU/NRtBmCYcTXaRyueYR9rNabYz1FwdDGOhbeIXkz0GdCp02eW5aflncHfx0KnjrI39d17JAlRhpzxWQfGSdcTXX1mH8uu98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CeFCZYa2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CeFCZYa2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=pAWC55HyAKzxPwpzeekF29/LOzo8IcAu+BzhG7wjOAI=; b=CeFCZYa2Lm3ORNfRrtJ0+pgYH9
	CrF7YVNrbuTKxGVXC85bEytIIu4fz+HqiN/rv8pfcI5tD03gfQ3lHnLLsKB3dD3YTiwCS2oW8gR9L
	BSiyj1O0Q4pIN16ghLAi284HP2fv71nGeqSPKqk8AR67+/K3NnOAHUIRAsXD/qyvkxyP9Xqg7GMPq
	Sj2c0qvtlsLB7YOqPNiQYc9g2PVSwo09dTmUV5W0ei2g0nYIeMGBtfGdTYlXMJ0bt12k7lROys5x1
	4HZqRbruC/yfL3jW8D3Szh3KoMm7/sRhkLgF5VzA+a4iPltz6VFz3TCX84OarrW68ZJm2JAw3ZoFc
	duP3Rp3rtg4xK+bbcPIHwFnop8/zd6aJQhNhkU1p992zRKgQVE6A38iutQvsKy77ZJXlLjuw6y7iW
	7l3tDjkN4SRcseTjrl3rtBX27oj8do2ybr9G0AMkNx8T0oXw5n8QmAU3GECPZKhc7wRfi1A4CVSry
	tsU7Kpeem/3uFVD1mEDAFhV2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1w255U-00000001Rx8-29ZX;
	Mon, 16 Mar 2026 10:22:16 +0000
Message-ID: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
Date: Mon, 16 Mar 2026 11:22:15 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Subject: SMB3 POSIX, byterange locks and close behaviour
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
To: Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ivD5GOOFjolThC8606pmpowp"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ivD5GOOFjolThC8606pmpowp
Content-Type: multipart/mixed; boundary="------------4eTUCu4hAGF5F90OJLcm305v";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
Subject: SMB3 POSIX, byterange locks and close behaviour
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

--------------4eTUCu4hAGF5F90OJLcm305v
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZm9sa3MsDQoNCndoaWxlIHdvcmtpbmcgb24gdGhlIHBhcnQgZm9yIGJ5dGVyYW5nZSBs
b2NrcyBvZiB0aGUgU01CMyBQT1NJWCBzcGVjLCBJIA0Kbm90aWNlZCBhIHByb2JsZW0gaW4g
dGhlIHByb3RvY29sOg0KDQpOZWl0aGVyIE1TLVNNQjIrIG5vciB0aGUgU01CMyBQT1NJWCBl
eHQgaGFzIGEgd2F5IHRvIHNlbmQgYSBjbGllbnQgc2lkZSANCmlkZW50aWZpZXIgZm9yIHRo
ZSBwcm9jZXNzIChsaWtlIHRoZSBwaWQpIHRvIHRoZSBzZXJ2ZXIuIFRoYXQgbWVhbnMgd2hl
biANCnByb2Nlc3NpbmcgU01CMi1DTE9TRSB3ZSBoYXZlIG5vIHdheSB0byBjb3JyZWxhdGUg
b3BlbnMgYnkgdGhlIHNhbWUgdnMgDQpkaWZmZXJlbnQgYXBwbGljYXRpb25zIChwaWRzKSBv
biB0aGUgY2xpZW50Lg0KDQpTdXBwb3NlIG9uIHRoZSBjbGllbnQgdGhpcyBoYXBwZW5zOg0K
DQoxLiBhcHBsaWNhdGlvbiBBIChwaWQ9WCBvbiB0aGUgY2xpZW50KSBvcGVucyBmZDE9b3Bl
bigiZmlsZSIpIGFuZCBzZXRzIGEgYnJsDQoyLiBhcHBsaWNhdGlvbiBBIChwaWQ9WCBvbiB0
aGUgY2xpZW50KSBvcGVucyBhbm90aGVyIGZkMj1vcGVuKCJmaWxlIikgDQphbmQgc2V0cyBh
IGNvbXBhdGlibGUgYnJsDQozLiBhcHBsaWNhdGlvbiBCIChwaWQ9WSBvbiB0aGUgY2xpZW50
KSBvcGVucyBhbm90aGVyIGZkMz1vcGVuKCJmaWxlIikgDQphbmQgc2V0cyBhIGNvbXBhdGli
bGUgYnJsDQo0LiBhcHBsaWNhdGlvbiBBIGNsb3NlcyBmZDENCg0KQWNjb3JkaW5nIHRvIFBP
U0lYIHJ1bGVzIHdlIGhhdmUgdG8gZHJvcCBhbGwgYnJscyBvbiAiZmlsZSIgd2hlbiBjbG9z
aW5nIA0KYW55IGZkIG9uICJmaWxlIiwgYnV0IHRoaXMgY2FuJ3QgYmUgaW1wbGVtZW50ZWQg
b24gdGhlIHNlcnZlciwgYXMgd2UgDQpoYXZlIG5vIHdheSB0byB0aWUgb3BlbnMgZnJvbSB0
aGUgc2FtZSBjbGllbnQgc2lkZSBwcm9jZXNzIHRvZ2V0aGVyLg0KDQpJdCdzIGFsc28gbm90
IHBvc3NpYmxlIHRvIGltcGxlbWVudCBPRkQgbG9ja3MgaW4gdGhlIHByb3RvY29sLCBzYW1l
IHByb2JsZW0uDQoNClVzaW5nIE9GRCBsb2NrcyBpbiB0aGUgYmFja2VuZCBvbiB0aGUgc2Vy
dmVyIGRvZXNuJ3QgaGVscC4NCg0KU01CMSBoYWQgcGlkbG93L3BpZGhpZ2ggaW4gdGhlIGhl
YWRlciBhbmQgTVMtRlNBICIyLjEuNS44IFNlcnZlciANClJlcXVlc3RzIGEgQnl0ZS1SYW5n
ZSBMb2NrIiBoYXM6DQoNCi0tLTg8LS0tDQpUaGUgc2VydmVyIHByb3ZpZGVzOg0KDQpMb2Nr
S2V5OiBBIDMyLWJpdCB1bnNpZ25lZCBpbnRlZ2VyIGNvbnRhaW5pbmcgYW4gaWRlbnRpZmll
ciBmb3IgdGhlIGxvY2sgDQpiZWluZyBvYnRhaW5lZCBieSBhIHNwZWNpZmljIHByb2Nlc3Mu
DQotLS04PC0tLQ0KDQphbmQgdGhpcyBwYXJ0IG9mIE1TLUNJRlMgIjMuMy41LjE1IFJlY2Vp
dmluZyBhbiBTTUJfQ09NX0xPQ0tfQllURV9SQU5HRSANClJlcXVlc3QiOg0KDQotLS04PC0t
LQ0KTG9ja3MgcHJldmVudCBhdHRlbXB0cyB0byBsb2NrLCByZWFkLCBvciB3cml0ZSB0aGUg
bG9ja2VkIHBvcnRpb24gb2YgdGhlIA0KZmlsZSBieSBvdGhlciBjbGllbnRzIG9yIFBJRHMg
ZnJvbSB0aGUgc2FtZSBjbGllbnQuDQotLS04PC0tLQ0KDQouLi5pbXBsaWVzIHRoZSBTTUIx
IHNlcnZlciBwYXNzZXMgdGhlIFBJRCBhcyBMb2NrS2V5IHRvIHRoZSBGU0EgbGF5ZXIuDQoN
ClNNQjIrIGRvZXNuJ3QgaGF2ZSBhIFBJRCBub3IgaGFzIFBPU0lYLVNNQjIgYW5kIEkgd29u
ZGVyIGlmIHdlIG5lZWQgb25lLCANCmF0IGxlYXN0IGZvciB0aGUgbG9jay91bmxvY2sgU01C
MiByZXF1ZXN0cy4gU01CMl9MT0NLX0VMRU1FTlQgaGFzIGEgDQozMmJpdCByZXNlcnZlZCBm
aWVsZCB3aGljaCB3ZSBjb3VsZCByZXB1cnBvc2UsIGJ1dCB0aGVyZSdsbCBiZSBkcmFnb25z
LCANCnNvIHdlIG1pZ2h0IG5lZWQgYSBkaWZmZXJlbnQgd2F5IHRvIGV4dGVuZCB0aGUgcHJv
dG9jb2wuDQoNCldlIGFsc28gaGF2ZSBhIDMyYml0IHJlc2VydmVkIGluIEZpbGVQb3NpeElu
Zm9ybWF0aW9uLCB0aGF0IHdvdWxkIGZpdCANCnRoZSBiaWxsLg0KDQpUaG91Z2h0cz8gQW0g
SSBtaXNzaW5nIHNvbWV0aGluZz8NCg0KVGhhbmtzIQ0K

--------------4eTUCu4hAGF5F90OJLcm305v--

--------------ivD5GOOFjolThC8606pmpowp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmm32dcFAwAAAAAACgkQqh6bcSY5nka6
7BAAny3YnkOyZFawLfYkVtr6NJqDNqMC1rChN/zyNEF4WfBUQ1thNL+UH5d3DVJ2yh3wmgUWmvzW
asTzVWHzxuVzQk7hXiSHRblvFy8yref1wK8c6PTfNzK/JrZfv+lN9hWT94P+EFZyKRPgX7VEaRfH
WYMwtoILSrwKHL0UHS3fblIs8gvZFvg62semXVHNTswas7EkdQIfNT9zNJdWKhelXcOfJb4EQpiV
Bkgi25I/RUcAXo01i2qTJX02EiP/MSeF+wp2dAHnZ/JPlMlYdDKkbhhudIwJ2t6ALS5TcM7e3uuS
aHTWwShtiE1qCz15Cq/6d1RGuE39Ra3z5ojhMXG+H8s8xYjHIWbJ8xjqqSY1hS2miuVVAO9E0Zae
GdE82Q1Q9rKBcc3sLDLTUObdZ8Z2FkTFT32zEs9IVxZ0FKkl4IuECDiDa/knUY2j6wcP9kfBl7yF
2Apd95Oia3VPxa8FMTKzoOwbYEMA5amRjwccN5JatEyBKEiwcyMYSia8sZCsNhVftKZzAotHp96r
fybSZhYRDoi8L5sLs+d8T8AkVvnr2CwRBpT/hkLoeQ6gM8wPj5f8ONCOg+ODzNXxaGD8aeIGO0sm
E2NfI50RJKCt5rag6vfiYmJn4/T+4RZ3NQs4KJOQhuNbj/fTHty4QDoJITTX9AtGWWzoekkdvvO7
9oE=
=jrwD
-----END PGP SIGNATURE-----

--------------ivD5GOOFjolThC8606pmpowp--
