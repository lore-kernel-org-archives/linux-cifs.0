Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF5F226CEB
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 07:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754551940; cv=none; b=vFCjcxnw9x5J8CKmF4ywbOg2dnz9VC/8gSIur7eqzCB5LhyE3yuAUznsgRmwBCWrUKCvzaASvGDnV0Ax6HKyRFnQVUjevDNdy75HjOvOvmKJzrlLbeapjbVqsYVaIxJTkeyrWtUYGoeoLRr0JNxWs9Mk/vQxo2eVlYR0oSrfFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754551940; c=relaxed/simple;
	bh=m2hYQk7zzWAMJ9gVmxf9OmGaNbH83xylJLkW2PnfBig=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=EZ+8f7BDrastrKjCR0z5NLDmSKg5+97/Vzuw6QzpRwSiTw/604zJlQf3ev8zZ36WCyHM36wc6IzqYqNBgu1j9bG6ZnP2WJzxlkAzC+FqvBC2aB9qARJNPLD2bwrFgNIBFJHqlbiKX+/FezQL2FQ4obl+29jfysxXBQzdBtXM+e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Nc6C6m5l; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Nc6C6m5l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=m2hYQk7zzWAMJ9gVmxf9OmGaNbH83xylJLkW2PnfBig=; b=Nc6C6m5lECTm9NoOAfebxefTgn
	9uwcAgB0XT4cmiu4V1uG2r9Ss1mbXmrtA5Gqsvhz0oACd9gC4pudfi21epz1FhW4pus3X5a7IKlis
	+4dVYoXK7ACeYfhtBOQhC6eYp02QWSaDuoM3gQQP+rSv9ISoAfOBjiUEvCqdPYvC8fDV3NGUbPw4c
	7rtc/4AtQSw1t6NJ62ffx6vrjEDYrzngmIphh9RN41LjQEdD3U7qiNpp3cnp+aanHxreAoamTFeJe
	bKw8/PCXyFMyYg7ec+oSDcuKNOvDMBbLWAzp+ysnNI9IHtc3o4PjCubXZhkkzBKd+YHl/mQx7nveJ
	nWWlZz5HysK1ivF8iGboWPTgGZSY94yDY4S5HqA/7Gtk/WYs1C5Vsd6f71riXmLkU5y6P6d1tLokB
	90/MZkgtZzntBcXWBh2JRXtSSZIGjzHPjJ/WJ7qZc2zKQUHN6+uJBkXVevvjhNymFoN2kt2N0gROn
	KGx10EKyIPjBuTvB4lUQbODZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujv6l-001WJ2-1q;
	Thu, 07 Aug 2025 07:32:15 +0000
Message-ID: <d3c50c5c-b87b-4010-a45e-130436d9c3b0@samba.org>
Date: Thu, 7 Aug 2025 09:32:14 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] Sequence of actions resulting in data loss
To: Steven French <Steven.French@microsoft.com>
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <4ed87f1e-b7e5-473c-83f1-33b79867a86e@tls.msk.ru>
Content-Language: en-US, de-DE
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <4ed87f1e-b7e5-473c-83f1-33b79867a86e@tls.msk.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------vK5v2eY0G0m0hvTGSizGf7Cn"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------vK5v2eY0G0m0hvTGSizGf7Cn
Content-Type: multipart/mixed; boundary="------------OGjKVEoRdR1qjZsqbz9CYOwe";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steven French <Steven.French@microsoft.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <d3c50c5c-b87b-4010-a45e-130436d9c3b0@samba.org>
Subject: Re: [Samba] Sequence of actions resulting in data loss
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <4ed87f1e-b7e5-473c-83f1-33b79867a86e@tls.msk.ru>
In-Reply-To: <4ed87f1e-b7e5-473c-83f1-33b79867a86e@tls.msk.ru>

--------------OGjKVEoRdR1qjZsqbz9CYOwe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC83LzI1IDg6MzkgQU0sIE1pY2hhZWwgVG9rYXJldiB3cm90ZToNCj4gT24gMDEuMDgu
MjAyNSAxNToxOSwgUmFscGggQm9laG1lIHZpYSBzYW1iYSB3cm90ZToNCj4+IE9uIDgvMS8y
NSAxOjIwIFBNLCBKZWFuLUJhcHRpc3RlIERlbmlzIHZpYSBzYW1iYSB3cm90ZToNCj4+PiBT
b3JyeSBhYm91dCB0aGF0IGFuZCB0aGFuayB5b3UgZm9yIHdhcm5pbmcgbWUuDQo+Pj4NCj4+
PiBwY2FwOiBodHRwczovL2RsLnBhc3RldXIuZnIvZm9wL3ZrdWM4N3lKL2ZpbGVfZGVsZXRl
X3JlcHJvZHVjZXIucGNhcC56c3QNCj4+PiByZXByb2R1Y2VyOiBodHRwczovL2RsLnBhc3Rl
dXIuZnIvZm9wL2RvUUtjd3Z2L3JlcHJvZHVjZXIzLnNoDQo+Pg0KPj4gbG9va3MgbGlrZSB0
aGUgY2xpZW50IGlzIGRvaW5nIGl0Og0KPj4NCj4+IGFmdGVyIHRoZSBzZXJ2ZXIgcmlnaHRs
eSByZWZ1c2VzIHRoZSByZW5hbWUgaW4gcGFja2V0cyAxMDItMTA5ICh0aGUgDQo+PiBjbGll
bnQgdHJpZXMgbXVsdGlwbGUgdGltZXMpLCBpbiBwYWNrZXQgMTEwIHRoZSBjbGllbnQgaXQg
c2V0cyBkZWxldGUtIA0KPj4gb24tY2xvc2Ugb24gdGhlIHRoZSBYLnNoIGFuZCBhIGJpdCBs
YXRlciBhZnRlciB0aGUgbGFzdCBvcGVuIGhhbmRsZSB0byANCj4+IFguc2ggaXMgY2xvc2Vk
LCB0aGUgc2VydmVyIHJpZ2h0bHkgZGVsZXRlcyB0aGUgZmlsZS4NCj4+DQo+PiBUaGUgZGVs
ZXRpb24gbWlnaHQgYmUgZG9uZSBieSB0aGUgYG12YCBjb21tYW5kIG9yIGl0IG1pZ2h0IGJl
IHNvbWUgDQo+PiBjb2RlIGluIHRoZSBjaWZzIGtlcm5lbCBjbGllbnQgdHJpZ2dlcmVkIGJ5
IHRoZSByZW5hbWUgZmFpbHVyZS4NCj4+DQo+PiBJIGd1ZXNzIHRoZSBuZXh0IHN0ZXAgd291
bGQgYmUgdG8gd3JpdGUgYSBtaW5pbWFsIEMgUE9TSVggcHJvZ3JhbW0gDQo+PiB0aGF0IHJl
cGxpY2F0ZXMgdGhpcyB0byBoYXZlIGZ1bGwgY29udHJvbCBvdmVyIHRoZSBhcHBsaWNhdGlv
bi4gSWYgDQo+PiB0aGF0IHN0aWxsIGZhaWxzIGl0IG11c3QgYmUgc29tZXRoaW5nIGluIHRo
ZSBjaWZzIGNsaWVudCBpbiB0aGUga2VybmVsLg0KPiANCj4gQlRXLCB0aGlzIGlzIGV4YWN0
bHkgdGhlIHNjZW5hcmlvIHdoaWNoIEkgcmVwb3J0ZWQgYmFjayBpbiBNYXItMjAyNCwNCj4g
aHR0cHM6Ly9saXN0cy5zYW1iYS5vcmcvYXJjaGl2ZS9zYW1iYS8yMDI0LU1hcmNoLzI0ODM0
NC5odG1sDQoNCnRlbGwgU3RldmUhIDopDQoNCkBTdGV2ZTogYXJlIHlvdSBhd2FyZSBvZiB0
aGlzIGlzc3VlPw0KDQpDaGVlcnMhDQotc2xvdw0KDQotLSANClNlck5ldCBTYW1iYSBUZWFt
IExlYWQgaHR0cHM6Ly9zZXJuZXQuZGUvDQpTYW1iYSBUZWFtIE1lbWJlciAgICAgIGh0dHBz
Oi8vc2FtYmEub3JnLw0KU2FtYmEgU3VwcG9ydCBhbmQgRGV2ICBodHRwczovL3NhbWJhLnBs
dXMvc2VydmljZXMvDQpTQU1CQSsgcGFja2FnZXMgICAgICAgIGh0dHBzOi8vc2FtYmEucGx1
cy9wcm9kdWN0cy9zYW1iYQ0K

--------------OGjKVEoRdR1qjZsqbz9CYOwe--

--------------vK5v2eY0G0m0hvTGSizGf7Cn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiUVn4FAwAAAAAACgkQqh6bcSY5nka4
Cg//Y407gF0GNIwk8xY71x3BnmJWZ5ZdOOQ+Das5DjRmHJftbEpFZ0UqzaAk2MNaYLv2K4xhP4PD
A9117q+c6tGsVE8ezGh0v52HicJVDDPOSJ9ZxQnBZxUUbgw2WtujiaF0fCBqiHRCDJaF0hdCCJ+d
J3jnW5wibU/pDmKN4gbCRB+lgi7n2Dmo8yfk/Wrr7nKz/p6ikx22Hj0gPxQENoawgZgCra8LG+1C
L6Qoyh55QXZQ3Xn+zMzW50J/OD2KcwNslXVtm1UoHdnKMHIT49TWg4j9wsid9rr2k6cbHCdvsrDA
a0Gj8xjnclv97PXBls7oDeOZjaY/GNsg4NAFldtyXRaCtZZ4TtA3prkt5hlXVbk4nMcYNeaDBosY
+LPvCjIceLTR45tznV78B+VHQ//N7rORrVlBhepEmatPqNLW/esKvOKhU1fXF24EUC2Hl3JN6jla
PBAwfRn3FnOz068HhbMpMApLWO2KLEYqucabKgYOktrBfG922YAcandKtyXDXytr3gCqIfZFYWoq
eziBERJztu0PxiELipirV07fEC1ZYKqZaJvsDDDs2S2U43xu2YSi43ry3xJJZqzIz8JtHxyFfn+q
kVBeLEyKP2Vv4KBgIhVrxaV5ThHH+jsna2vlFmcOcYT8h/d+OrfFvtL+TBc24Z5t6KssJZNuvFtZ
Q6E=
=gWsP
-----END PGP SIGNATURE-----

--------------vK5v2eY0G0m0hvTGSizGf7Cn--
