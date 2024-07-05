Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A151E52A
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 13:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720185420; cv=none; b=KVdflv67DjEyOlyR0XH6r/qWuCQx+wJMVteOwYEFLEVon2BWWUX85x54Q7ttLDnFrXWTO+H77lrIsT/g3QAHyL7NmdBz/Bfyok9EYqBFY1j0+00vutZqoUZAT4G0t1w7vgIPsQ5rD9uvwk+QPDViQNqEqQlRQqPlGGcIMxaxZdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720185420; c=relaxed/simple;
	bh=Py+EfLSTS8l9/M3wqqVMiquIbjrzj/NxTeaUFMKdG7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bdwkJBhyme98hULNsjQGuksJRkhR3quEkFYpcOmWgTbv2PECyK1muWS1PpXOW6KJnCkfqDtExOeV3D4jvC7VNDlSKt2/L4q56bBWhveKvNx9NsVu9Bn0Acd605RdnQ0bXpRi4ElfwjLQoWrcJMi7zpMlHzZqPb1x864aYECHu1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tmQKwxUu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tmQKwxUu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Py+EfLSTS8l9/M3wqqVMiquIbjrzj/NxTeaUFMKdG7c=; b=tmQKwxUuDN1kucLJK47CjT5+GS
	/fMX+zWcS/CdXddZs3QPl/cwUIVHLJH8dgTLhKN3UEnfK/p0E/NcC648Ljyb7f3XIzH2QWVixANDJ
	AmyXQ7v+hjPIVvH02Hc87TGbABC6+77JKUK8QDg21sdMtS8xAvdQ0w/wNuAkMwHnEOWiIOkkwY+Vr
	OVm5fA/SuxSKCdfvHOjxf7lavup5tfVzUtVqjQ5cUQQejIFZoTa3t+OVYFoNqOixrUOgeyj+vqzj1
	k3Y2N3copRQ7OQBGZzoC5PF+SF1zv/3HbeyZ1u1LvH7tDEUPM3GjfoK+04Qf/c1y4WOvrGt6Jtkni
	/ALARGdD32+Nl1NaOihNaVh3bLCs5LMNUoCsPZfQq+f+xEXv6zoQ0qCp+wIMGYr7rsFX063fqvndS
	0MhKxit/qy74olvRr3zWw8eTkzdu3HF5cq6TuYG7sJvRQKnot+L7ewpZyqeGxxsMvo4h2NFk+L/XA
	ce8UNSYUtuvYdO9vbRtc5PjU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sPio1-002bL5-26;
	Fri, 05 Jul 2024 13:16:53 +0000
Message-ID: <ef50bdc4-360f-4714-a503-bddbdabcbb14@samba.org>
Date: Fri, 5 Jul 2024 15:16:52 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org,
 sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 sj1557.seo@samsung.com, yoonho.shin@samsung.com, kiras.lee@samsung.com
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com>
 <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
 <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8n0sfubqDLGRZ8ZsrH38eM2S"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8n0sfubqDLGRZ8ZsrH38eM2S
Content-Type: multipart/mixed; boundary="------------NCr22qxyc88nKTEnzS0cpM2c";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org,
 sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 sj1557.seo@samsung.com, yoonho.shin@samsung.com, kiras.lee@samsung.com
Message-ID: <ef50bdc4-360f-4714-a503-bddbdabcbb14@samba.org>
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com>
 <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
 <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
In-Reply-To: <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>

--------------NCr22qxyc88nKTEnzS0cpM2c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy81LzI0IDI6MzMgUE0sIE5hbWphZSBKZW9uIHdyb3RlOg0KPiAyMDI064WEIDfsm5Qg
NeydvCAo6riIKSDsmKTtm4QgODo1NCwgUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz7r
i5jsnbQg7J6R7ISxOg0KPj4NCj4+IE9uIDcvNS8yNCA1OjI3IEFNLCBIb2JpbiBXb28gd3Jv
dGU6DQo+Pj4gbWF5X29wZW4oKSBkb2VzIG5vdCBhbGxvdyBhIGRpcmVjdG9yeSB0byBiZSBv
cGVuZWQgd2l0aCB0aGUgd3JpdGUgYWNjZXNzLg0KPj4+IEhvd2V2ZXIsIHNvbWUgd3JpdGlu
ZyBmbGFncyBzZXQgYnkgY2xpZW50IHJlc3VsdCBpbiBhZGRpbmcgd3JpdGUgYWNjZXNzDQo+
Pj4gb24gc2VydmVyLCBtYWtpbmcga3NtYmQgaW5jb21wYXRpYmxlIHdpdGggRlVTRSBmaWxl
IHN5c3RlbS4gU2ltcGx5LCBsZXQncw0KPj4+IGRpc2NhcmQgdGhlIHdyaXRlIGFjY2VzcyB3
aGVuIG9wZW5pbmcgYSBkaXJlY3RvcnkuDQo+Pg0KPj4gYWZhaXIgdGhpcyBzaG91bGQgY2F1
c2UgYSBmYWlsdXJlIGxpa2UgRUFDQ0VTUyBvciBFSVNESVIgYW5kIGp1c3QgYmUNCj4+IGln
bm9yZWQuIFdoYXQgZG9lcyBhIFdpbmRvd3Mgc2VydmVyIHJldHVybiBpbiB0aGlzIGNhc2Us
IG9yIFNhbWJhIGZvcg0KPj4gdGhhdCBtYXR0ZXIgYXMgaXQgKGhvcGVmdWxseSkgd2lsbCBi
ZWhhdmUgbGlrZSBXaW5kb3dzLg0KPiAgRnJvbSB3aGF0IEkndmUgY2hlY2tlZCB0aGUgcGFj
a2V0IGR1bXAsIFNhbWJhIGRvZXNuJ3QgcmV0dXJuIGFueQ0KPiBlcnJvcnMgaW4gdGhlIHNh
bWUgY2FzZS4NCj4gU2FtYmEgc2VlbXMgdG8gb3BlbiBpdCB3aXRoIE9fUkRPTkxZIGlmIGl0
IGlzIGRpcmVjdG9yeSwgU28gdGhlcmUgaXMNCj4gbm8gcHJvYmxlbSwgaXMgaXQgcmlnaHQ/
DQoNCkhtLCBpdCBzZWVtcyBteSBtZW1vcnkgaXMgcGxheWluZyB0cmlja3Mgb24gbWUuIFNh
bWJhIGluZGVlZCBmb3JjZXMgDQpPX1JET05MWSBmb3IgZGlyZWN0b3JpZXMgaW4gdGhlIHNl
cnZlcnMgYW5kIGlnbm9yZXMgdGhlIGNsaWVudCByZXF1ZXN0ZWQgDQphY2Nlc3MgbWFzay4g
SW50ZXJlc3RpbmdseSB3ZSBkb24ndCBzZWVtIHRvIGhhdmUgYW55IHRlc3QgZm9yIHRoaXMg
Y2FzZSwgDQphdCBsZWFzdCBJIGNvdWxkbid0IGZpbmQgYW55IHdpdGggYSBxdWljayBzZWFy
Y2guIFF1aWNrbHkgcHV0dGluZyANCnRvZ2V0aGVyIGEgdG9ydHVyZSB0ZXN0IHNob3dzIFdp
bmRvd3MgYmVoYXZlcyB0aGUgc2FtZS4gTVMtRlNBIGRvZXNuJ3QgDQptZW50aW9uIGFueSBz
dWNoIGNoZWNrIHNob3VsZCBiZSBkb25lIGZvciBkaXJlY3RvcmllcyBhcyB3ZWxsLiBHZXRp
bmZvIA0Kb24gc3VjaCBhIGhhbmRsZSBldmVuIHJldHVybnMgdGhlIG9yaWdpbmFsIHVubW9k
aWZpZWQgY2xpZW50IGFjY2VzcyANCm1hc2ssIGluY2x1ZGluZyB0aGUgd3JpdGUgYWNjZXNz
Lg0KDQpTb3JyeSBmb3IgdGhlIG5vaXNlISA6KQ0KDQotc2xvdw0K

--------------NCr22qxyc88nKTEnzS0cpM2c--

--------------8n0sfubqDLGRZ8ZsrH38eM2S
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmaH8kQFAwAAAAAACgkQqh6bcSY5nkbC
2xAApQdr03TqkxZM0aIQmQzC071JKrmyUB5zbQAEQdeqAMhDr9ngWfIK5LJ4pg9w1ctXGxY5CeEl
/fIJxP7T3jACEl+VEWm6zORrYCn1CxsIAD07ErhKL+shuPtyiEK4WclVHb+Kc7XuyOK0HL3xfIn6
VoTqQyRrU5JivAo+/yIaH9k/8bXF5EDjHnf4mznMemyxt4C5ReCUl5mzcjqXbop6UJiduY7oinIi
wxDr1Sy0HYA8Kjh373LVjDB+sT8+dmLLbBtqscy0wKyobfECmFnd2da6JbwLOdTzLjUceD17XdrE
+i3yiwc5Qa+yevDyOCntEb0Aw+Tux6y0laxn0Cdb+NV6j1mWTlQ2GTtph/sdRp4rk0pwgFuR1SaM
MDtALnRNlONxtXaKQOq/yPQ1XE5vfjwViewbLytFFhrnM/tLWyrIqnEMBniGvBRMrrqSXwn1Amr5
vQ5FIcZkhUzZCVJgB0t6xxD/qoly1L5sHMYB7Spy1QTUIetoowRggRFm6DX3pY7R+vB0rWJTFmWv
ZM0zsOv08Od7f+4xLvOaT+iJZaT5FA/r7260d/9HxHlT1JfOUAd8vcZQ9QCDbBuddku8pGCvBObB
3UdDFySKF3alCHAVRXFVXtVeLMTvLJH2V1tvQNDMEfu9b9UiUjjgu9NjPYGg04wLlFB0goi9nWhn
mHY=
=HeIC
-----END PGP SIGNATURE-----

--------------8n0sfubqDLGRZ8ZsrH38eM2S--
