Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD60213A244
	for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2024 18:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500063; cv=none; b=Rwulwx9kra/BDOZ4ghJ6Mh8N2Jnzfg3p6LhOT5ppvAOCA79OSZewZSDi5yLlkND1oUcrMpugSxG+DzLKnmTIGxlpBdTDRkGTzDJXn3whMXkT+cjhRiPSJgyX0w1Jr2LdGiZy8evF6glXYE/Vibt6CghbVP96tgIZIMt40EkE/6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500063; c=relaxed/simple;
	bh=n7ooIvy69r4CG9DaMKh3mwQN1GmE9Mye+zOvfL41Hwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R//rdpsgihZO/mm89AhqzsxiUrLFxmCNUOqL2IdAxs36Mn1DNwPdEb5fHudHrxtolwKpTBIBo2RUaeN8MSxO7hPqv/Ul9Wj0DGtj/G7+SXtapMNmXhFtFOYlNCs3AyI/EUCEjh4u00iV76jAQJJkMK8kCTKjMugpDxrlP+u7xC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZFTNZE3+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZFTNZE3+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=n7ooIvy69r4CG9DaMKh3mwQN1GmE9Mye+zOvfL41Hwk=; b=ZFTNZE3+GY1mumtd7BdMR/MdSN
	mKTwSkNw64TH81b0lurq7hZ+WxOaw9ZNmjQOrgxuQ7HG4/0ABG+7UJt0P02xZhdWmX/DnR0EFGCUh
	eWwqfTT71IKOzZQj35WCo0ULQwejug1kpVub3tMVHz8/9yXE3McMYosXFAXjCWkKzoT/jqQ5qAkWU
	bHBBBPT7UVN3vnSYPlPkexs6WRNGTVR5qXboet96LNtw4IxT71YbXWLvUGXbfFtrAeZCj4gCioKPi
	bsI77a4ZTw2nIwpZyWK7KWk9goK8ChXmxe8SdfFDUyHbhGE5P2DMxsZQ6T3idYCiTSgytqAu0Li2A
	//UZ6IEuolOzZNQu5Cp05uewQhNsoTB++Zt+j5d3pCg/r4BoermTy5xCIAaLB5KSamJobJbJXTx3m
	bqBjrwF6SNpq4XRob0ziI7eFO+H9E705+lWrkBnQh3RY2yA6DhD4v9t55UDAZ7zqyfsAGbJ7m8+DQ
	HK3jvkdEE0C4UL96lLilQ4e4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sybp6-0045g8-2v;
	Wed, 09 Oct 2024 18:54:13 +0000
Message-ID: <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
Date: Wed, 9 Oct 2024 20:54:12 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Za4vIQZXxM2o0Z0AAG0lUqsV"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Za4vIQZXxM2o0Z0AAG0lUqsV
Content-Type: multipart/mixed; boundary="------------D6KSnJNAG0ZS08GgGamvou1f";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
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

--------------D6KSnJNAG0ZS08GgGamvou1f
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOC8yNCA1OjE2IFBNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4gSXQgd2FzIGRv
bmUgYXMgcGFydCBvZiB0aGUgU01CMSBleHRlbnNpb25zIC0gdHJ5aW5nIHRvICJwYXNzLXRo
cm91Z2giIGFsbA0KPiBwb3NzaWJsZSBQT1NJWCBvcGVuIGZsYWdzLg0KPiANCj4gSnVzdCBy
ZW1vdmUgaXQuDQoNCm9rLg0KDQpCdXQgdGhlbiB3ZSBzdGlsbCBuZWVkIGEgd2F5IHRvIHBh
c3MgT19BUFBFTkQgb3ZlciB0aGUgd2lyZSB3aXRoIFNNQjMgDQpQT1NJWCBhbmQgd2UncmUg
Y3VycmVudGx5IGxhY2tpbmcgYSBzYW5lIHdheSBpdCBzZWVtcy4NCg0KV2hhdCBhYm91dCB1
c2luZyBvbmUgYml0IG9mIHRoZSAxNyByZXNlcnZlZCBiaXRzIGluDQoNCjxodHRwczovL3d3
dy5zYW1iYS5vcmcvfnNsb3cvU01CM19QT1NJWC9mc2NjX3Bvc2l4X2V4dGVuc2lvbnMuaHRt
bCNwb3NpeC1tb2RlPg0KDQpUaGVyZSBhcmUgbW9yZSBwb3NzaWJseSBpbnRlcmVzdGluZyBv
cGVuIGZsYWdzIHRob3VnaCBhbmQgSSB3b25kZXIgDQp3aGV0aGVyIHBhY2tpbmcgYWxsIG9m
IHRoaXMgaW50byB0aG9zZSAzMiBiaXRzIGlzIGEgZ29vZCBpZGVhLCBidXQgdGhlIA0KYWx0
ZXJuYXRpdmUgb2YgY2hhbmdpbmcgdGhlIFNNQjJfQ1JFQVRFX0NPTlRFWFQgcmVxdWVzdCB0
byBhZGQgYSBuZXcgDQpmaWVsZCAiT3BlbkZsYWdzIiBpcyBub3QgcmVhbGx5IGEgZ3JlYXQg
bG9va2luZyBvcHRpb24gZWl0aGVyLg0K

--------------D6KSnJNAG0ZS08GgGamvou1f--

--------------Za4vIQZXxM2o0Z0AAG0lUqsV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcG0VQFAwAAAAAACgkQqh6bcSY5nkb3
dg/+IUDIHHJDPY5Wle0xhg4MgXFwiFfUuR6At9Lqx6JtHIDC5Q/h/bTjGBPNaYqCzB43L7JuRcIL
P807CmNTY5E4tO1gKRGjuqnVZtRbKNUek45oyHbOBQhD73s47Bergj8k+H2xIh3UfMpoBc3I2ptR
ZOHfySaOaz7tTnP0VLGwD9rU9QByFHbjTWUC9Y6unlyjCSQViWO0uG/8EqJdTS1jmAlZ6ZDs07BD
BrTZOoGuWwN9ehO2FlcBeOqsSS5sebkG2dRFV8BN1rwe0tiSXMkTRqpDSHr2RnO6eQxLdjwkWwA5
Sn77SRDSaiUGtHaQS4bvyMrxSQbFbBhDeZvjuQ3ZnwCU3EBurAzp/CG34g4jmlSlnT5hF5M84x+V
8I2KhbNn1dni2P+0obUkD+uqK6RtPhMpKyDkbIk5Tt04bpyyNMnLmzwB7zHaVv7g4w7dkTgs8WON
NLViQCnxvgDWAN8VxtH+WOLeDHoX7f6R/4JDkF1q9ZAW3KbSYOkXBfUSA/6SR6aXGNh06e7ltdB8
SpG8CV3mur83unI2nMv/7b8R+ODFFkHBtnlOoqGtY0v/BrfMONwzF1Tcaji82wf1psKhl3N7CCDE
EwfRvvZ5gQgy89PSNl8HVLIimjaGFchpx+lNaGP/PmFdoQsk1mAgzS4C6uthefUqN3tBHCBLiKl9
z34=
=V7Ee
-----END PGP SIGNATURE-----

--------------Za4vIQZXxM2o0Z0AAG0lUqsV--
