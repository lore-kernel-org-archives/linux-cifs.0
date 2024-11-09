Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC1A199FAF
	for <linux-cifs@vger.kernel.org>; Sat,  9 Nov 2024 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731168167; cv=none; b=KCkdo4rJw4iZBgDyZ7bQ71JyzH4a8fyHaCnlCWIfjAR5kRrefsK68YtCrj+oMokqMKJzItFmdGDZi8ES2JYDV8fMjXpFjPQ9txr6Wx7e0dISJZZPbdelW7Y4zoIRog1CnuEJhk0eVKgr9/i2+BNHFa5VYRu2bZZuB/J+L2Q/OBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731168167; c=relaxed/simple;
	bh=3ndEaZSkUEK3L30O/5Q72jkM+JUOw8ML+pDEzUQgukM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=pXNs0n8GyiExAG80XK9x9bnXYLPOr9ZZuxWphTXwP6LtGfyAv2jvFS4GDd8HfpH50l+S9P743AbuB+9xYtL+9TF7mzcfBPxP6OZcBfvFXoIeggMk00dEIMHwojLuXyTNHbMwY/mgEf2lS+zikp0BtBTKAOKcOYe36odwQvGGRVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MCtJMv3h; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MCtJMv3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=3ndEaZSkUEK3L30O/5Q72jkM+JUOw8ML+pDEzUQgukM=; b=MCtJMv3hqNE7H50yROuLumEyEq
	2wL/MvO8XfWp0MufihAbezGrLtYv+vkerdQCJtScZqar+QTqpRu321kgfCsMQkyRAV3Ybl2+cO3Xq
	MpkeGqdpzd30wNa45wh0Co1eOMXLlHf8CqSAksyi1sUYUmRPLKfrDUh0Y/P0mXkr9dtnJorSmaEep
	fOT2SdONjLttkEY6HuoUhQHkuRWuXoLyozeDAQwtFt4ThXoT9q4st9SZ9fj8GHGSmkFDn/u2JRQgl
	P5zq87kKkjrFSLE2h4kgK+H/j+5tbYNk8xA3RuKFv0+MpcGPDMDLNp9YuWF/eIBUwrJC583zB5kuM
	7h/Q6ju5kovqw1QHgllPGbcwRshXyELphfv8KsdX0J92eCxGsXmtyjk+Y0BFWX18n5jMSVscizsPr
	cNV3XdtzemQdW33JJ0/Be3jydpNJtGmbtZa1We5AKCAiG7YUtCm0LRzrz1lV38Ql4Qkqe+2fxZ95o
	rgDChmmPUrSAQy4X1ao8sdR6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1t9nMG-009n9r-09;
	Sat, 09 Nov 2024 15:26:40 +0000
Message-ID: <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
Date: Sat, 9 Nov 2024 16:26:38 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ralph Boehme <slow@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------cOEj8OXwS68UUQXua0fyKnEh"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------cOEj8OXwS68UUQXua0fyKnEh
Content-Type: multipart/mixed; boundary="------------LsgPkVcuPDgTiCXaDwff07Y5";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
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

--------------LsgPkVcuPDgTiCXaDwff07Y5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOS8yNCA5OjQzIFBNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4gQ2FuIHdlIGp1
c3QgbWFwIChhY2Nlc3NfbWFzayAoRklMRV9BUFBFTkRfREFUQXxTWU5DSFJPTklaRSkpID09
ICANCj4gKEZJTEVfQVBQRU5EX0RBVEF8U1lOQ0hST05JWkUpKQ0KPiB0byBPX0FQUEVORCwg
cmVnYXJkbGVzcyBvZiBQT1NJWCBtb2RlID8NCg0KdGhpbmtpbmcgYWJvdXQgdGhpcyBhIGJp
dCBtb3JlLCB0aGlzIHNlZW1zIGRvYWJsZSwgYWxiZWl0IG9ubHkgZm9yIFBPU0lYIA0KbW9k
ZS4gRm9yIG5vbi1QT1NJWCBtb2RlIHdlIGNvdWxkIHBvdGVudGlhbGx5IGJyZWFrIFdJbmRv
d3MgYXBwbGljYXRpb24gDQp0aGF0IG9wZW4gb25seSB3aXRoIEZJTEVfQVBQRU5EX0RBVEE6
IEkgY2hlY2tlZCB3aXRoIGEgdG9ydHVyZSB0ZXN0IHRoYXQgDQpXaW5kb3dzIGRvZXNuJ3Qg
ZW5mb3JjZSBhcHBlbmQgYmVoYXZpb3VyIGZvciBGSUxFX0FQUEVORF9EQVRBfFNZTkNIUk9O
SVpFLg0KDQpGb3IgUE9TSVggb3BlbnMgd2Ugc2hvdWxkIGFsc28gYWxsb3cgY29tYmluYXRp
b25zIGxpa2UgDQpGSUxFX1JFQURfQVRUUklCVVRFU3xGSUxFX0FQUEVORF9EQVRBIHRvIG1h
cCB0byBPX0FQUEVORCwgc28gY2xpZW50cyBjYW4gDQp3cml0ZSBpbiBhcHBlbmQgbW9kZSB0
byB0aGUgaGFuZGxlIGFuZCBzdGlsbCBhcmUgYWJsZSB0byBmc3RhdCgpIGl0Lg0KDQpodHRw
czovL2dpdGxhYi5jb20vc2FtYmEtdGVhbS9zYW1iYS8tL21lcmdlX3JlcXVlc3RzLzM4NjMN
Cg0KVGhvdWdodHM/DQoNCi1zbG93DQo=

--------------LsgPkVcuPDgTiCXaDwff07Y5--

--------------cOEj8OXwS68UUQXua0fyKnEh
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcvfy8FAwAAAAAACgkQqh6bcSY5nkZG
ohAAgVzoWwNAYkqYR72AH7Bp2ZTlXerXK7u0Kf1LUAGWuS0xHG/JmmjaR2RJJC/1Ua4lcNwWBQxA
0x3oIlm+4m/EP9NuveT89LZnleOzt/CufOBydgR9yTnAOraEYf9++9PY/+I2jQJKvWXJkczbKCuV
sbBO6WM2iGFg4ywc/edHz3ysim3FMvYe4Pt+0j1jcAtex9Zw4CYgR/8GtbFMY2YXaacmxq8Wl7Ft
AQejEAYOzohmAaMe6J68NauMJSUXjIuK/BKPn8SQtQ2p6kykN/LQBsTQjqih2q1tE/PcdCOJ8F4A
GahCQo/2EffQ+pI2MBTI3bu0zQduzGYvuw0NM+/eAoEpkBjVjMsIcSX/PAzQGntdYcqjR6BM6fNH
QsHOI8LJDoO+9y7kxgvXS+ZCg9HOOE+EFxavqHOzdFCT/qvMDC5dJcC9wCTRjbYidznWmqeG/pvT
+CDfVleT8EuT+/gB7n1gnXKngfmnHJL8tyizuZO4FtGr9BVBQpyaJlPq5xOn0yr5wm3oFrlBUZdn
1UH7G7vlpgzCCzxVprx9viNvwT5n1vUkx33/YN4Y6JQsRnoBA6ZBSQT+QDP4ecsL0AFA+uYMloGa
o7mi33TkY3NT7vGOoP+vfyCtoIVIWT7aLlNz6c44dp0f24ibPJUOz9LudCDNWedk0dmgwAUn1wtE
h3M=
=eYq3
-----END PGP SIGNATURE-----

--------------cOEj8OXwS68UUQXua0fyKnEh--
