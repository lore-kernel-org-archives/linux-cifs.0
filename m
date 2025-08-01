Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B972CAB
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754043529; cv=none; b=taBIcLIZvq+wQBuQN2BvuWnCcXyC3QG8blhLooEpEerGTiXJg/1YnLg8MMB4yQQcb0vW1XlX1vjp2cehjgSq7gBbuaokV3O5hBaUsqQ0FxMJ7WQrCOH/0RuIVMUzY2DvylghOdzJcy4v/UtLLons3CwNwXvPK+P0GwtaUcaQa+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754043529; c=relaxed/simple;
	bh=mYUjkFaBXVU1TaIVkLHcMyj95pxITKul5PQsnPwQu8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=FFtGrCEuXZuMlXV43eauJipieh+B8XsK+5ojloJXt+w5gPDXYWrUiC1oO2QlYwqDwcsHhQ86GTs3qIIPda5moj/jTd8l6qoIWZYighhZvNEMiVh+Mkmf0/lNUtvjrDkTqrIooT71/NiHluQd75I0inV8B9r/r/ndGkaodJ8g6ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=X4K0gpMx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="X4K0gpMx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=mYUjkFaBXVU1TaIVkLHcMyj95pxITKul5PQsnPwQu8s=; b=X4K0gpMxXcb/bCFJMwih4QO6Yu
	/iBIkeYXlXXwKs9yheMlICY4PI3qwnmQ2H5Xt7uIOqbjN16De4i67/LUXyRik/IR1/uqtkagllSdp
	7HzsIVSAIIfpb97xAoA9tJEidlL+x7dbTXWPd6CO36ri6bZscEJLDVvPl9n+qMS/Fa+zXESDTu9Ci
	ZUC4GcyYnjBif/uscQ3Vu+c/XF3yXas54dryXNFqgrrL5qlnauiaWJsvHXGNT9NKXtd4zyBE1F+iG
	zVI0iNufE3DQ5E4c60t+7uCYre/ogjy/0PZ6+LLuWIO6b4QkhZpkvomd6si4NQPpnvWwWtJZrpjkU
	JyUClkHoLvlPN8Ho31J9mS85z9hFrOmPfXB5yq9DcylFA+ObrHK3M4pRJo7B6DTiDhV+OZ8CzNB3q
	2WSc3Tk/aheZuznULp/cxnqJbXcbdkNvIMFTI1yaLoYPtzhF8vsHnyabfGvQEeR11LORYmuJMJpjr
	2TwBHTggoNdqKKfEeEy0XCYd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uhmqa-000VjH-1I;
	Fri, 01 Aug 2025 10:18:45 +0000
Message-ID: <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
Date: Fri, 1 Aug 2025 12:18:43 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] delayed mtime updates: configurable?
To: hede <debian452@der-he.de>
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
 <20250801113523.76290fc7@hpusdt5.der-he.de>
Content-Language: en-US, de-DE
Cc: CIFS <linux-cifs@vger.kernel.org>, samba@lists.samba.org
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20250801113523.76290fc7@hpusdt5.der-he.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ofu5sKWSxUXphJlyxvhemNyD"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ofu5sKWSxUXphJlyxvhemNyD
Content-Type: multipart/mixed; boundary="------------dBH2Kuigc0vT2HkLR5iQvsz8";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: hede <debian452@der-he.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, samba@lists.samba.org
Message-ID: <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
Subject: Re: [Samba] delayed mtime updates: configurable?
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
 <20250801113523.76290fc7@hpusdt5.der-he.de>
In-Reply-To: <20250801113523.76290fc7@hpusdt5.der-he.de>

--------------dBH2Kuigc0vT2HkLR5iQvsz8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Li4uYWRkaW5nIGxpbnV4LWNpZnMgdG8gdGhlIGxvb3AuLi4NCg0KT24gOC8xLzI1IDExOjM1
IEFNLCBoZWRlIHZpYSBzYW1iYSB3cm90ZToNCj4gT24gU3VuLCAyNyBKdWwgMjAyNSAxODo0
NToxNyArMDIwMCBoZWRlIHZpYSBzYW1iYQ0KPiA8c2FtYmFAbGlzdHMuc2FtYmEub3JnPiB3
cm90ZToNCj4gDQo+PiBIaSwNCj4+IA0KPj4gU01CIDIuMSBhbmQgdXAgc2VlbXMgdG8gaGF2
ZSBhIGRlbGF5ZWQgbXRpbWUgdXBkYXRlLiBJZiB3cml0aW5nIHRvDQo+PiBhIGZpbGUgb24g
dGhlIGNsaWVudCwgdGhlIG1vZGlmaWNhdGlvbiB0aW1lIChtdGltZSkgZm9yIHRoaXMgZmls
ZQ0KPj4gZ2V0cyB1cGRhdGVkIHNvbWUgdGltZSBhZnRlciBjbG9zaW5nLiBUeXBpY2FsbHkg
fjEgc2Vjb25kIGFmdGVyDQo+PiBjbG9zaW5nIHRoZSBmaWxlLg0KPiANCj4gSXQncyBhIGZl
YXR1cmUsIG5vdCBhIGJ1Zy4gU29tZWhvdy4NCj4gDQo+IEl0J3MgdGhlIGRlZmVycmVkIGNs
b3NlIGZlYXR1cmUgaW1wbGVtZW50YXRpb24gd2l0aGluIGNpZnMua28gd2hpY2gNCj4gZGVs
YXlzIHRoZSBtdGltZSB1cGRhdGUuIFdpdGggImNsb3NldGltZW89MCIgdGhlIHByb2JsZW0g
aXMgZ29uZS4NCg0Kbm8gaWRlYSB3aGF0IHRoZSBjbGllbnQgaXMgZG9pbmcgaGVyZSwgYnV0
IGZyb20gYSBzZXJ2ZXIgcGVyc3BlY3RpdmUsIA0Kd2l0aCBjdXJyZW50IFNhbWJhLCB0aGUg
d3JpdGUgd2lsbCAqaW1tZWRpYXRlbHkqIHVwZGF0ZSB0aGUgbXRpbWUgb24gDQpkaXNrIGFu
ZCByZXBvcnQgdGhpcyB1cGRhdGVkIHZhbHVlIHdoZW5ldmVyIGl0IGlzIHF1ZXJpZWQuIFdo
ZW4gdGhlIA0KaGFuZGxlIGlzIGNsb3NlZCwgdGhlIHNlcnZlciBkb2Vzbid0IHVwZGF0ZSB0
aGUgbXRpbWUuDQoNCkEgbmV0d29yayB0cmFjZSB3aWxsIHRlbGwgeW91IHRoZSB0cnV0aCBh
Ym91dCB3aGF0J3MgZ29pbmcgb24uDQoNCkNoZWVycyENCi1zbG93DQoNCi0tIA0KU2VyTmV0
IFNhbWJhIFRlYW0gTGVhZCBodHRwczovL3Nlcm5ldC5kZS8NClNhbWJhIFRlYW0gTWVtYmVy
ICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTYW1iYSBTdXBwb3J0IGFuZCBEZXYgIGh0dHBz
Oi8vc2FtYmEucGx1cy9zZXJ2aWNlcy8NClNBTUJBKyBwYWNrYWdlcyAgICAgICAgaHR0cHM6
Ly9zYW1iYS5wbHVzL3Byb2R1Y3RzL3NhbWJhDQo=

--------------dBH2Kuigc0vT2HkLR5iQvsz8--

--------------ofu5sKWSxUXphJlyxvhemNyD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiMlIMFAwAAAAAACgkQqh6bcSY5nkYE
IhAApKqPN8F5PXVbiTC6QTzz6U14LqCcJChOrfNJshlRDH21bbIl1KnNqkQB8PK2oJ7RiUUIjRBn
Gu3XRlmwF3/QBAUjXkJI6iybBPXxSSeZOnmc0OQvkk8qfLyu/fuWHaauiStA34b73dxjnvwoE4fD
96uKa8TLvRexnKpcJiQruVSJi9F53p6cvGbzzRcuu+l+DwUACaoFlu3GnhDrypHVFyStvqdON/KY
lUVUWPyTRtBhvZJuB3Q3/npI9Zt3YWkf9x6CCved1SLaGT2y0NmymCXQDcO5SiDUYgFYeE/Uj3go
u+vxzVJ7qYvEzi6L6sy9qrb/ED0cv0vg2c6yUlJ7J1ApTAf34wmSIH/xfqPOqIxZuWV0gf4xRV+t
ANldKzGk4vgJY7rV/tKuN77ZWa0qdwqFUqzEEQb8DgltQVZgnizK9/QvVSWm+bRr/ZxD3OiomVhx
CEjHz0SfThxWCE9gD2Vz+b6Zn8wCQYx3okQxROFKWpbGNZI1g5G7hxgfFxLSTZPJc5SoTdwckCMP
dZ7Nyd7OPtgDOZzggbgRq5gw//BscAj4hyKjXxRsJrOKZiC7QQB4UyDIOZ62VaIIN/+OVYJWH+ir
DlocHFEsl/pbGSR/zypUVXcvcoj1qhf5lEtDL3rDinAzyS8cB2jj43E1TYu3kUtdRRYnoesAclQo
8yk=
=M+rz
-----END PGP SIGNATURE-----

--------------ofu5sKWSxUXphJlyxvhemNyD--
