Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5A012B73
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 19:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714418840; cv=none; b=MQGJnk+tUoToPmIfUy2JdanRyh+UTcZxpAUbSqClrLIx9cq0C7/11FMYlBANOvxjq3uoNIQzHtgL5AopdMIgeK8fWK660gTX3TYODomRkDqNX1RzXKlDglGu4HZn1b9/50khV+pBYUWWvGdj/qsW5jzSDGJnHUrOycSCP+4gIBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714418840; c=relaxed/simple;
	bh=FIVuRAcCfw5nsBqG+6O+kti+htdP7tJRyjf00Hm6xQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJky05crnFBCy+dgIAqUgDTWFwx/EhdfQa0L8IN9jUVeHOrj+tfW9XKwQJpqI8dB9xgUWVcImcuiun9vd6aQSyN4+luYQP2qdhBMsTrMPp/Ht7/DVpu20JwTj/uWyoNETU6tpf7yD4LCpNdyXjSe6POIiDFoeD3IeIZMSmAk7Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Rd+M1sjt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Rd+M1sjt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=FIVuRAcCfw5nsBqG+6O+kti+htdP7tJRyjf00Hm6xQg=; b=Rd+M1sjtMyMTLYpRAsJqLSGuqt
	fgRR585uHMswq4sTHBUnNcKOb+gevBBf/HcR9YOby9eqb6yLQwXzEofuWr55kxFq6d/VrCzEoc6mq
	GkB0Jtiv0P/14ix0fjA9ILBBcc/dFZfw92UnFXy55VKikPuEpJGSs5jDAMbJcLQomCwIJOWKPuNC/
	pviP99KLprt9WTio+tq6LeI0b0GqoxKsHdJgT75YeU/nP0aZwgJdFvGiSJql5uXkhhDrm/xxS2kgp
	+lNQVXIN1zKCvY8GfQYF0cyAjRlxLtQOfXyJmLZWrbzbolsBQyLI5+GRCpy2vAVlSFAmAxRwAqqq/
	1koV5uvkZdRYox8vuMtgKD1nW5Zob90eoR7ajb74bIgAqr+XSdqVsBwQ2oCM7zTPWzGnCGJfJvdtJ
	LZ33R8lvyuEfpI96vH1IdE4yqhRcZkpU1sLgnozbpAvSMjkstpw0/Av76fwcPaAgsk6yuGux3TMvf
	pyjFQHA1718MlC+26FEG9kbz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1Wei-008z7h-0w;
	Mon, 29 Apr 2024 19:27:16 +0000
Message-ID: <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org>
Date: Mon, 29 Apr 2024 21:27:15 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Samba ctime still reported incorrectly
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org>
 <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------K8mR0T935j91PvfHkRZlODEJ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------K8mR0T935j91PvfHkRZlODEJ
Content-Type: multipart/mixed; boundary="------------y6ZigJ6oyZhknznbD3kR9dBV";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org>
Subject: Re: Samba ctime still reported incorrectly
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org>
 <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
In-Reply-To: <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
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

--------------y6ZigJ6oyZhknznbD3kR9dBV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8yOS8yNCA3OjE3IFBNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4gT24gTW9uLCBB
cHIgMjksIDIwMjQgYXQgMTA6NTE6MjFBTSArMDIwMCwgUmFscGggQm9laG1lIHdyb3RlOg0K
Pj4gSGkgU3RldmUsDQo+Pg0KPj4gT24gNC8yOC8yNCA5OjQxIFBNLCBTdGV2ZSBGcmVuY2gg
dmlhIHNhbWJhLXRlY2huaWNhbCB3cm90ZToNCj4+PiBJIGRpZCBhbm90aGVyIHRlc3Qgb2Yg
dGhlIFNhbWJhIHNlcnZlciBjdGltZSBidWcgb24gU2FtYmEgbWFzdGVyDQo+Pj4gKDQuMjEu
MHByZTEpIGFuZCBTYW1iYSBzZXJ2ZXIgaXMgc3RpbGwgYnJva2VuIGluIGhvdyBpdCByZXBv
cnRzIGN0aW1lLg0KPj4+IEFuIGV4YW1wbGUgc2NlbmFyaW8gaXMgc2ltcGxlLCBjcmVhdGlu
ZyBhIGhhcmRsaW5rIGlzIHN1cHBvc2VkIHRvDQo+Pj4gdXBkYXRlIGN0aW1lIG9uIGEgZmls
ZSAoYW5kIHRoaXMgd29ya3MgZmluZSB0byBXaW5kb3dzIHNlcnZlciBhbmQNCj4+PiBrc21i
ZCBldGMpIGJ1dCBTYW1iYSBzZXJ2ZXIgbWlzdGFrZW5seSByZXBvcnRzIGN0aW1lIGFzIG10
aW1lICh1bmxlc3MNCj4+PiB5b3UgbW91bnQgd2l0aCB0aGUgInBvc2l4IiBtb3VudCBvcHRp
b24pLsKgIFRoaXMgZS5nLiBicmVha3MgeGZzdGVzdA0KPj4+IGdlbmVyaWMvMjM2IHdoZW4g
cnVuIHRvIFNhbWJhDQo+Pj4NCj4+PiBNb3JlIGluZm9ybWF0aW9uIGlzIGF0Og0KPj4+IGh0
dHBzOi8vYnVnemlsbGEuc2FtYmEub3JnL3Nob3dfYnVnLmNnaT9pZD0xMDg4Mw0KPj4NCj4+
IEkgd29uZGVyIGlmIHRoaXMgaXMgYSBidWcgZ29pbmcgYmFjayBhcyBmYXIgYXMgDQo+PiBj
OWRjYTgyZWQ3NzU3ZjQ3NDVlZGY2ZWU2MDQ4YmQ5NGQ4NmM0ZGJjDQo+Pg0KPj4gQEplcmVt
eTogZG8geW91IHJlbWVtYmVyIHdoeSB5b3UgY2hvc2UgdG8gcmV0dXJuIG10aW1lIGluIA0K
Pj4gZ2V0X2NoYW5nZV90aW1lc3BlYygpIGFuZCBub3QgY3RpbWU/DQo+IA0KPiBJZiB5b3Ug
bG9vayBjbG9zZWx5IGF0IHRoYXQgY29tbWl0LCB5b3UnbGwgc2VlDQo+IHRoYXQgaXQncyBh
Y3R1YWxseSBub3QgY2hhbmdpbmcgdGhlIGxvZ2ljIHRoYXQNCj4gcHJldmlvdXNseSBleGlz
dGVkIDotKS4NCg0KeWVhaCwgc3VyZSwgYnV0IGl0IHdhcyBhIGRlY2VudCByZWZhY3Rvcmlu
ZyBzbyBJIHdhcyB3b25kZXJpbmcgd2hldGhlciANCnlvdSdkIGNvbnNpZGVyZWQgdGhlIGFj
dHVhbCBsb2dpYyB5b3Ugd2VyZSB0b3VjaGluZyB3YXMgY29ycmVjdC4gOikNCg0KPiANCj4g
LcKgwqDCoMKgwqDCoCBwdXRfbG9uZ19kYXRlX3RpbWVzcGVjKHAsIG1fdGltZXNwZWMpOyAv
KiBjaGFuZ2UgdGltZSAqLw0KPiArwqDCoMKgwqDCoMKgIHB1dF9sb25nX2RhdGVfdGltZXNw
ZWMocCwgY190aW1lc3BlYyk7IC8qIGNoYW5nZSB0aW1lICovDQo+IA0KPiBQcmV2aW91c2x5
IHdlIHdlcmUgdXNpbmcgbV90aW1lc3BlYyBhcyBjaGFuZ2UgdGltZSwNCj4gYW5kIGNfdGlt
ZXNwZWMgaW4gdGhpcyBjaGFuZ2Ugbm93IGNvbWVzIGZyb206DQo+IA0KPiArwqDCoMKgwqDC
oMKgIGNfdGltZXNwZWMgPSBnZXRfY2hhbmdlX3RpbWVzcGVjKGZzcCwgc21iX2ZuYW1lKTsN
Cj4gDQo+ICtzdHJ1Y3QgdGltZXNwZWMgZ2V0X2NoYW5nZV90aW1lc3BlYyhzdHJ1Y3QgZmls
ZXNfc3RydWN0ICpmc3AsDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IHNtYl9maWxlbmFtZSAq
c21iX2ZuYW1lKQ0KPiArew0KPiArwqDCoMKgwqDCoMKgIHJldHVybiBzbWJfZm5hbWUtPnN0
LnN0X2V4X210aW1lOw0KPiArfQ0KPiANCj4gU28gSSBhY3R1YWxseSB3YXNuJ3QgY2hhbmdp
bmcgd2hhdCB3ZSBhbHJlYWR5IHdlcmUNCj4gZG9pbmcgOi0pLg0KPiANCj4gTm93IGFzIHRv
ICp3aHkqIHdlIHdlcmUgdXNpbmcgbV90aW1lIGluc3RlYWQgb2YgY190aW1lLA0KPiBteSBn
dWVzcyBpcyB0aGF0IHdlIHdlcmUgdHJ5aW5nIHRvIGVtdWxhdGUgTlRGUw0KPiBzZW1hbnRp
Y3Mgd2hpY2ggd2VyZSBub3QgZG9jdW1lbnRlZCBvciB3ZWxsIHVuZGVyc3Rvb2QgYXQgdGhl
DQo+IHRpbWUgKHdoZXJlICJ0aGUgdGltZSIgaXMgcHJvYmFibHkgcHJpb3IgdG8gMjAwOSA6
LSkuDQoNCkhtLCBzbyB3aGF0IGRvIHdlIGRvPyBNUy1GU0Egc2VlbXMgdG8gaW5kaWNhdGUg
TlRGUyBjdGltZSBoYXMgcHJldHR5IA0KbXVjaCB0aGUgc2FtZSBzZW1hbnRpY3MgYXMgUE9T
SVggY3RpbWU6DQoNCjIuMS4xLjMgUGVyIEZpbGUNCg0KTGFzdENoYW5nZVRpbWU6IFRoZSB0
aW1lIHRoYXQgaWRlbnRpZmllcyB3aGVuIHRoZSBmaWxlIG1ldGFkYXRhIG9yIA0KY29udGVu
dHMgd2VyZSBsYXN0IGNoYW5nZWQgaW4gdGhlIEZJTEVUSU1FIGZvcm1hdCBzcGVjaWZpZWQg
aW4gW01TLUZTQ0NdIA0Kc2VjdGlvbiAyLjEuMS4NCg0KTGV0J3Mgc2VlIGhvdyBtYW55IHRl
c3RzIGNvbXBsYWluOg0KDQo8aHR0cHM6Ly9naXRsYWIuY29tL3NhbWJhLXRlYW0vZGV2ZWwv
c2FtYmEvLS9waXBlbGluZXMvMTI3MjMzMzU0Mz4NCg==

--------------y6ZigJ6oyZhknznbD3kR9dBV--

--------------K8mR0T935j91PvfHkRZlODEJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmYv9JMFAwAAAAAACgkQqh6bcSY5nkav
Tw/8DC0CoBZKep+j/rZx2L4VAVCwVdnwNL328U2KF4wdGhORWT8L2/8JaCt+UDYubXYuaPXqvARg
Orx4FG7DabtNklInEMMnD0nC1iJ4bKa7y0eP7EQszl/JU7gf9qhw7iAFs4IgrZwERS8H641UCV0p
4xjLWaMilRS7LuuPcF0nBx9+1WHDTsxh80XvfclsObAqiPkOcOrBrpQlte81Ml3wZNMt2hrpMNWb
QMjFq9UAJUGQCgqyCiwm/1R73WWmA8+MKkb3U9A6EO7fxVj8LEYA660G9FlLHEbZFaLqDyIG+yjK
vKnJQXaK3D6ODKwGsal/sQC0VsHjE8WlrtANOp1rcLudeWbU8X/kPeEyWJ6S9UJVcHzV7Edaw7UU
2rtdbIdtS/mTQgsL7DFMw4FHcnDiWU1qQQumwrv9pSnaJ8/buT1pQtiXk3hUBIwavY9W2bi9nWW2
1pFLanr+/eX2Fsw4r9K7rxxjMD1Nb8+dRM4PstOHZKIhs4ZA0lxDjWh9Vm8037pCGpVt2H6oxvej
ntQ/eaYCnGnzZXDCDUv7qYDQa3YthDKZz7Agy/V7vcXErfSECjwxuj3rWOtQ0iq02xDhr/4X5fms
yEGEeApQAXPQU4F1kzZE8x0bTpncvp66w2SPIkqKJ6oJ+K+uIugKcnss1NmOKSeyBYmGtG/trGWl
e68=
=Q8o3
-----END PGP SIGNATURE-----

--------------K8mR0T935j91PvfHkRZlODEJ--
