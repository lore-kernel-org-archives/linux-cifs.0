Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787042500D3
	for <linux-cifs@vger.kernel.org>; Tue,  3 Dec 2024 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733257560; cv=none; b=k8+3jGNQBuZzCT0Q8h0L+ZEoU5iyuOKR3he0aKQb9uZ5SZeIgu4NmSzI7BazFKPytFI/smm+36rKwhR0dq7CnxnVs4i9yXJi4QR9MvtmR9UT5WveDZjtzzeK7W5K+rP8kUPqnxw++2BbiSvSUUB23ymcKi2cA1FfawHflyEDfSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733257560; c=relaxed/simple;
	bh=ztPxnl09CQfF38p7xO90SEKX7CEmA/oUM30fqrjo77w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=moRnLcDswmC60kaEkxn18KW4XoHmKXNrjjxYBkmJHJpl84ZyPjNrbOeE9LYXEnTj6LGAO79EELd9LFqvlQYIa6YunK4UF68uc0bZei174A0bpGlRjuyfNmcIUcsG1orx7jvv/S+MQlDcnNV+UZsJJEGo9Kuz44bVLnbwz0YkUao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cbu5sIJQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cbu5sIJQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ztPxnl09CQfF38p7xO90SEKX7CEmA/oUM30fqrjo77w=; b=cbu5sIJQVWaZLTaNmyiezKHl2x
	QRW/MdhFvQeoKcJ8tlcojlhfpclqMJIpbfVT7GpgCQHuLQPSf7sq+iHE+cNgowdWqfTIaIVRH1OTs
	O/ZvgyFXkc7WMQCLEoBSyNmVKRyTCQYGw5fJiWAClA6/VazO7VKftMEcXu70cYgD8Op7YUqFM5HRe
	9xALyjiATq1HgqHzeENWVlZhzSbpSTrnqONFMigxDUXbkBawnEo90dJtMcJeJzyAAi8JYfj6tnz7A
	u3I9QBUqNpAH6tMBQG3TGKfsBW01zLVbfwqu+q41J/nM+osrK+6svWtUSUOeuQmxdcypZHWbJqqo8
	/5z8NStxdJN95h/1mT9gLWwRticPsv3bHTBXbEXKqx/bJNhEU1rJC1jWsh8ddUaCipbiYz2wnTtKT
	Qmb8z32wNzo+8+vUJ3EI2b4Xsn2pPZgkwypn7D/E6IwG9rb6n4sXyQTw0d7Jigl48Ne9BYPkjHJ57
	x49aGMjQfMURBCB0/2RrRzKr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tIZT2-000NO6-0A;
	Tue, 03 Dec 2024 20:25:56 +0000
Message-ID: <cb0a9829-203e-4d11-b9bf-277e4a1e1850@samba.org>
Date: Tue, 3 Dec 2024 21:25:54 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Special files broken against Samba master
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <0a8569561645ad202c5cceba02cda93a@manguebit.com>
 <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
 <CAH2r5mvrjGgtf4o+dk9KcEqM+QtvYodhbBNzcK5SDyyepK+Xog@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mvrjGgtf4o+dk9KcEqM+QtvYodhbBNzcK5SDyyepK+Xog@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gvc0tcrlqni1xL2GYSQve89J"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gvc0tcrlqni1xL2GYSQve89J
Content-Type: multipart/mixed; boundary="------------bmy0VurWfL7VjQlmsQ1TqMaN";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <cb0a9829-203e-4d11-b9bf-277e4a1e1850@samba.org>
Subject: Re: Special files broken against Samba master
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <0a8569561645ad202c5cceba02cda93a@manguebit.com>
 <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
 <CAH2r5mvrjGgtf4o+dk9KcEqM+QtvYodhbBNzcK5SDyyepK+Xog@mail.gmail.com>
In-Reply-To: <CAH2r5mvrjGgtf4o+dk9KcEqM+QtvYodhbBNzcK5SDyyepK+Xog@mail.gmail.com>

--------------bmy0VurWfL7VjQlmsQ1TqMaN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU3RldmUhDQoNClRoYW5rcyBmb3IgdGVzdGluZyEga3NtYmQgbmVlZHMgdG8gYmUgdXBk
YXRlZCB0byBpbXBsZW1lbnQgdGhlIGN1cnJlbnQgDQpzcGVjLiBUaGUgbmV4dCBtYWpvciBT
YW1iYSB2ZXJzaW9uIDQuMjIgd2lsbCBzaGlwIHRoaXMgc3R1ZmYsIHNvIEknZCBiZSANCmdv
b2QgaWYgY2lmcy5rbyBmb2xsb3dzIGFsb25nIGFzYXAuDQoNClRoYW5rcyENCi1zbG93DQoN
Ck9uIDEyLzMvMjQgODo1NiBQTSwgU3RldmUgRnJlbmNoIHdyb3RlOg0KPiBMb29rcyBsaWtl
IGEgYmlnIGltcHJvdmVtZW50IC0gZmV3ZXIgcm91bmR0cmlwcyB0byBTYW1iYS4gIEhhdmVu
J3QNCj4gdHJpZWQgdG8gV2luZG93cyB5ZXQsIGJ1dCBpdCBkb2VzIGxvb2sgbGlrZSBpdCBi
cmVha3MgbW91bnRzIHRvIGtzbWJkDQo+IHNvIEkgbWF5IG5lZWQgYSBtaW5vciBjaGFuZ2Ug
dG8gY2lmcy5rbyBvciBrc21iZC4NCj4gDQo+IE9uIFR1ZSwgRGVjIDMsIDIwMjQgYXQgNDow
NOKAr0FNIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+IHdyb3RlOg0KPj4NCj4+IE9u
IDEyLzIvMjQgMTE6NDAgUE0sIFBhdWxvIEFsY2FudGFyYSB3cm90ZToNCj4+PiBSYWxwaCBC
b2VobWUgPHNsb3dAc2FtYmEub3JnPiB3cml0ZXM6DQo+Pj4+IEknbSBzdXJlIEknbSBkb2lu
ZyB0aGluZ3Mgd3JvbmcuIENhbiB5b3UgaGVscCBtZSBnZXR0aW5nIHRoaXMgYWNyb3NzIHRo
ZQ0KPj4+PiBsaW5lPw0KPj4+DQo+Pj4gUGF0Y2hlcyBsb29rIGdvb2QsIHRoYW5rcy4gIEl0
IHdvdWxkIGJlIGdyZWF0IG1ha2luZyBzdXJlIGl0IGRpZG4ndA0KPj4+IHJlZ3Jlc3MgYWdh
aW5zdCBORlMgc2VydmVyIG9uIFdpbmRvd3MsIGJ1dCBTdGV2ZSBjYW4gZG8gdGhhdC4NCj4+
DQo+PiBncmVhdCwgdGhhbmtzIGZvciB0YWtpbmcgYSBsb29rISBJIHdhcyBleHBlY3Rpbmcg
SSB3YXMgbGlrZWx5IGRvaW5nIHNvbWUNCj4+IHN0dXBpZCBiZWdpbm5lciBtaXN0YWtlcywg
YnV0IGlmIHlvdSB0aGluayB0aGUgY2hhbmdlcyBsb29rIGdvb2QsIGhlcmUncw0KPj4gYSB2
MiB3aXRoIGp1c3QgbXkgKzEgYWRkZWQsIHdpdGhvdXQgY29kZSBjaGFuZ2VzLg0KPj4NCj4+
IFRoYW5rcyENCj4+IC1zbG93DQo+IA0KPiANCj4gDQoNCg==

--------------bmy0VurWfL7VjQlmsQ1TqMaN--

--------------gvc0tcrlqni1xL2GYSQve89J
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmdPaVIFAwAAAAAACgkQqh6bcSY5nkYo
qw//acCborYwra661VoNKcwy1Je+OqShtYE2zOIb/TRN0KEA4QnIwe78XMa86cjQfHm4gx/1x6yr
pSXPVpnPif4EyEagssWXkGAYMvTM79x9n5BjRTlpPH/NZ9X6AKTv3C69DfCrVNQmQHtkBD0PUgHi
ObslvPkpgsL4NDJufjomhIozVBz9afqWEF4znsO79BJtcacCDOHVgo6DoVfPxp3qlbbREyKVoTf0
VdBAIuewDWKoUUsBqV/8aEPtZ+wjmEjluTfEHPDnMckT8m71KlTAgA6Ivrl9LxI0WmsMQhmdhMoF
eXb1TttcOtplxLB2rmhAPC1f0uvJdW2/pds5q+5EW638iu3ErEc8rDbNqQ3MgOzwYM6OlumleGFX
bxMHkCVADJsPtDWP5FL7GDH3fHr0JGbRHi1yZ/DimZFWTfwAYuj4XXmRQrPvJgWc5eopbRDAYD8v
V2D4yG9pZPZdMW6QroOQK6lZFFMcVV1NM/dXrnemkTbVrfPl6/lobjeOf6IpbYJNGvMAYnvUGcna
LhrdJisu3LIXda+M55eHmiyN5QwSCZo+A1jdIKklU898m2c/eGoJyLDV9kIs0aPfx7I6GJ9Mxce7
eEFqXDf32ItEs4mi4z/HjiTdiNTcl4G+Erj5xaWskxjH6jbUDXDxdrTTLcz0vs3mhFsu8dwEr0Rt
qAk=
=orJF
-----END PGP SIGNATURE-----

--------------gvc0tcrlqni1xL2GYSQve89J--
