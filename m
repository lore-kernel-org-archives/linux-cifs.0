Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD47242D93
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 08:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752481403; cv=none; b=lQtupY8/i7y9ZeDB6VCGKYvLAVDzlHQMzs4AFa2d36S04ueUblOZ2oyYyHp4fG3S1L6JVHC0C2LsHtpfqZgAvO/yjt8Kb/jaQsgnWgdX3Ad0lT0nLpIybncUH6g2LvGIwIkErQKifhSShQToH00mjL5pygchn6P4Ca2r74Si6Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752481403; c=relaxed/simple;
	bh=x4YzWj4GqVdDA0sKrEqc2L64WaPLS/TaCaQCEn1PqHA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=M5osju1ZD/I2KNCkq/T33uAmqmL/PNxNpfw0JkagFXmFY2z1vJR24YOx9iMBScsVMr5wdiS9u68/bUadCxRl99OIlaHwT/xFAz99RtI8CW13kdxBgwwgHAWSxnA8omZQkvqdO7Bi/Xf1p0NWRpq5GfSyGsUxU4qnC+sHM+IaQuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fMrcMHYw; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fMrcMHYw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=x4YzWj4GqVdDA0sKrEqc2L64WaPLS/TaCaQCEn1PqHA=; b=fMrcMHYws1P00w4C2BKDQQJ89r
	oqT2GnL9dA2l46c7gWF+gmo7RuEX5GNvJEe+Jl25GQhjLlZhET8mHKOg0d/p4mz9WmsEXi6Gq1Or4
	otVc33nW0jX4cQvGUrPxUNFElfGUwoR53gJTzYAhFMHp2ufYAw2PBpyTq/1Cc1VwBlFC4Kzo+Akw6
	wJGYoXk/+3RrRF9n0PHAPD3rhZ6TqzjeVRQKAY3gjr/SeU1/KpPEsFrYPfwCDiaWRGGzIuXwPsJk9
	DZKGN6ZYhpXZUosTB9GofiuNqA/0Qsg42EwvO1yd50FexeEkevoQhzNh8WVrlWU3bK0tQyMNcIk5m
	NrN/f1y42QdncGC94km4xP31yHkdubZPzBRUZRSp/4o6m2w8atZfbsKUFxax1/J+iXvLx62fSfBge
	hjTkU7RH4oDyTngWloJl4UyL8oDNwn2T/NAV76e6QngdOtjvDtVFeg9tHwluqAeQ7rxmTZ1nmJUPk
	A+NgquMDJsnDjnPu9qJruuW2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ubET0-00FHte-2D;
	Mon, 14 Jul 2025 08:23:18 +0000
Message-ID: <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org>
Date: Mon, 14 Jul 2025 10:23:17 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Samba support for creating special files (via reparse points)
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
 vl@samba.org
Cc: samba-technical <samba-technical@lists.samba.org>,
 =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
 <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0Y1Q7M3zbH6bM0Gmi9RkPc1V"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0Y1Q7M3zbH6bM0Gmi9RkPc1V
Content-Type: multipart/mixed; boundary="------------PULKC1GUuxdIF2FZOcmCoZCN";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
 vl@samba.org
Cc: samba-technical <samba-technical@lists.samba.org>,
 =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org>
Subject: Re: Samba support for creating special files (via reparse points)
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
 <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
In-Reply-To: <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
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

--------------PULKC1GUuxdIF2FZOcmCoZCN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8xNC8yNSA4OjAxIEFNLCBSYWxwaCBCb2VobWUgdmlhIHNhbWJhLXRlY2huaWNhbCB3
cm90ZToNCj4gT24gNy8xNC8yNSA0OjE4IEFNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4+
IEl0J3MgYW4gb3ZlcnNpZ2h0IEknbSBhZnJhaWQuDQo+IA0KPiBobS4uLiBpdCBzZWVtcyBy
ZXBhcnNlIHBvaW50cyBzdXBwb3J0IGlzIG1hbmRhdG9yeSBmb3IgU01CMyBQT1NJWCBzbyBJ
IA0KPiB3b25kZXIgd2hhdCB0aGlzIGFkZGl0aW9uYWwgY2hlY2tzIGJ1eXMgdXMuDQo+IA0K
PiBXaGlsZSBJIGFncmVlIHRoYXQgZ2VuZXJhbGx5IHdlIHNob3VsZCBsaWtlbHkgc2V0IHRo
aXMsIGZvciBTTUIzIFBPU0lYIA0KPiB0aGUgY2xpZW50IHNob3VsZCBwcm9iYWJseSBub3Qg
Y2hlY2sgdGhpcyBhbmQgd2Ugc2hvdWxkIGtlZXAgaXQgb3V0IG9mIA0KPiB0aGUgc3BlYy4N
Cg0Kb25lIGFkZGl0aW9uYWwgdGhvdWdodDogaXQgc2VlbXMgbGlrZSBhIHZhbGlkIHNjZW5h
cmlvIHRvIGJlIGFibGUgdG8gDQpzdXBwb3J0IFNNQjMgUE9TSVggb24gYSBzZXJ2ZXIgdGhh
dCBkb2VzIG5vdCBzdXBwb3J0IHhhdHRycyBvbiB0aGUgDQpiYWNraW5nIGZpbGVzeXN0ZW0g
YW5kIGhlbmNlIG1heSBub3QgaGF2ZSBhIHdheSBvZiBzdG9yaW5nIGFyYml0cmFyeSANCnJl
cGFyc2UgcG9pbnRzLg0KDQpJbiBTTUIzIFBPU0lYIHdlJ3JlIGp1c3QgdXNpbmcgdGhlbSBh
cyBhIHdpcmUgdHJhbnNwb3J0LCBub3QgbmVjZXNzYXJpbHkgDQpleHBlY3RpbmcgZnVsbCBz
dXBwb3J0IGZyb20gdGhlIHNlcnZlci4NCg0KSGVuY2UsIGZvciBTYW1iYSBJIHNlZSB0aGUg
Zm9sbG93aW5nIGNoYW5nZQ0KDQogICAgIHNtYmQ6IGFubm91bmNlIHN1cHBvcnQgZm9yIEZJ
TEVfU1VQUE9SVFNfUkVQQVJTRV9QT0lOVFMgaWYgdGhlIA0Kc2hhcmUgc3VwcG9ydHMgRUFz
DQotLS0NCiAgc291cmNlMy9zbWJkL3Zmcy5jIHwgMyArKysNCiAgMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvc291cmNlMy9zbWJkL3Zmcy5jIGIv
c291cmNlMy9zbWJkL3Zmcy5jDQppbmRleCA3Njg5NWY1MmUwMzkuLmVhM2ZhNGM4Nzg0ZiAx
MDA2NDQNCi0tLSBhL3NvdXJjZTMvc21iZC92ZnMuYw0KKysrIGIvc291cmNlMy9zbWJkL3Zm
cy5jDQpAQCAtMTM0NSw2ICsxMzQ1LDkgQEAgdWludDMyX3QgdmZzX2dldF9mc19jYXBhYmls
aXRpZXMoc3RydWN0IA0KY29ubmVjdGlvbl9zdHJ1Y3QgKmNvbm4sDQogICAgICAgICBpZiAo
bHBfbnRfYWNsX3N1cHBvcnQoU05VTShjb25uKSkpIHsNCiAgICAgICAgICAgICAgICAgY2Fw
cyB8PSBGSUxFX1BFUlNJU1RFTlRfQUNMUzsNCiAgICAgICAgIH0NCisgICAgICAgaWYgKGxw
X2VhX3N1cHBvcnQoU05VTShjb25uKSkpIHsNCisgICAgICAgICAgICAgICBjYXBzIHw9IEZJ
TEVfU1VQUE9SVFNfUkVQQVJTRV9QT0lOVFM7DQorICAgICAgIH0NCg0KICAgICAgICAgY2Fw
cyB8PSBscF9wYXJtX2ludChTTlVNKGNvbm4pLCAic2hhcmUiLCAiZmFrZV9mc2NhcHMiLCAw
KTsNCg0KaHR0cHM6Ly9naXRsYWIuY29tL3NhbWJhLXRlYW0vc2FtYmEvLS9tZXJnZV9yZXF1
ZXN0cy80MTA0DQoNCkZvciB0aGUgY2xpZW50IHRoaXMgd291bGQgbWVhbiwgaXQgbXVzdCBh
bGxvdyByZXBhcnNlIHBvaW50cyBmb3IgdGhlIA0Kc3BlY2lhbCBmaWxlcyBpZiBTTUIzIFBP
U0lYIGlzIG5lZ290aWF0ZWQuDQoNCk1ha2VzIHNlbnNlPw0KDQotc2xvdw0K

--------------PULKC1GUuxdIF2FZOcmCoZCN--

--------------0Y1Q7M3zbH6bM0Gmi9RkPc1V
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmh0vnUFAwAAAAAACgkQqh6bcSY5nkb4
hQ/+OwWJv4tQ2E72XPRbiPw+Gn8eXRg+sPTqE0nonBgCBBcITdauDiQ1N7RXun91gHbhYuCit6IH
TKmR8OLSbZKhUw0vIQDApFxPykS3lalhjw4ZYN9AogpFw2HtGtt4/JqIBkSfJHgov2oQ94XW5BTi
s6c1uoE++p05vzxjY6Mk1Pbwpea708mEmUALnFf2PLwoUgvq8KG92ZM2JglGjsynoW/E7ymvMSwV
L9L7yH4vJZkaMF2XNrBI1flLvAaSszHNG3XFRuKJ3h8q493uXcrMkg81CwmmLIx4/2IoKVeZdsrf
SXRYOVPlsxMadLVwBsAi/XawfAfjHripQ2TN0Y4a2RXICceqk+RxzjcpQcjKzCXRENP7014e93XU
1MMGwfo7eoQd+ir3NB8LWSaHLDRKm1gXoGDlwcg8sx6Kf0mbYULFdyaEJiv7kfamEMI3KV9imyYf
FCFfkxzlg2gl8oGDydVGvKOvVAg4+O8d6XJzlwIe71Sp1a4HqoPK0ye5mAaBx5jIh+SIXXFan74a
OnZPuih+dUSaDl+WhW4CLBGo/fwHThIpZbyOYgT13iR7p8CnrpVV6pID9J9nns6GtLU47IrCp1Vp
iKI1okU5L8UhIPLVVDS73v864jCsAwa500Di/iSPdy2dd8DKd8yZHAkJ4govtIfM5v5a6i92/EKV
bb0=
=j+L6
-----END PGP SIGNATURE-----

--------------0Y1Q7M3zbH6bM0Gmi9RkPc1V--
