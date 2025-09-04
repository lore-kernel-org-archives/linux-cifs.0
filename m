Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDB12376F8
	for <linux-cifs@vger.kernel.org>; Thu,  4 Sep 2025 06:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756965853; cv=none; b=nToFVn8RP0DWSUtsVewskxM4T3tCn35iWvcAZucf9mkvvcpCW6OChhEGQSIJr0U6fxeucgkdcDt5DveqXcTY4lsRmfntPhby7mqobW1Dv9/06vCKphbtnBfR3DlUKdJBOqCeBW0deQY07LNtZElHrtUubjtBGd/8+C+po/cFsa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756965853; c=relaxed/simple;
	bh=fp0EyKzfC12L4r48f6UzZZ7ycZTvVOY2LsUKfS7CqQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kIRmrEvc+QQVOY5knoc0O1l53+5BKBHgRtyH0Go5bqH8x7XiPHHfsIwGQBDZpCy6j+IRgaK0/U8Vaz7vCan/oyD1BhCh7wSpdQqNbiAXTwRbi+MrH+KaI2ztF1oFpiGITwxi1AyjmRcikNKAmtjOeXVdX+JXTzS83aUMwrerpF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bKuc4xXQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bKuc4xXQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=fp0EyKzfC12L4r48f6UzZZ7ycZTvVOY2LsUKfS7CqQ4=; b=bKuc4xXQ91K41Cm3DstIPsi5Ia
	5BDxEdZAelYxQtuGbodft5DHU2pLEbgXXNSLAglU9CivvoHwgnSDLDFA+kghlBeBgsoYfGdmkU2XN
	p80crSzo+iZcTn1CyNY3GqwKm9n9BTYryRX93XmccLZeTRPdbtuV115w2QdYpshSxP42mrc+mdrhx
	fUn8VxKSQM6oaoOuUgxnUlnqKXxeWsa+g26UNKG4SXZLNFwK7VJQQjYeayJ5jvQRMAhJQSxUMWmar
	MLtnH+X1zhFJxUSO+vT2qFnzXvhbLeeDWQ1AH3Xw6mbUitBN9ZVzOdcbMSDkexYB6JvDkd3ar95GO
	co82UgcN7qxrhSH6Aqo+UgfJo4XTmaZ6LlghcxjkN2bE8+WwD013pEiqSYdCeL/CtRDFeX57w7h7h
	tP0f9ElWkjlHpRf4u3TOq2g5DFd657iONiF3MVmKzbuSCwdkCLG2t1pHEmnxrlXOVvt2oHKFLUV28
	TrNz0PxKmSC0R8c/152beqyc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uu34p-002LvW-22;
	Thu, 04 Sep 2025 06:04:07 +0000
Message-ID: <d27b2c93-b450-4c24-97e8-9cbe5c495637@samba.org>
Date: Thu, 4 Sep 2025 08:04:06 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>, Steve French <smfrench@gmail.com>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
 <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
 <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
 <e2a50c26-42ad-4060-9da4-96f89517ee1b@samba.org>
 <7dbf8f8019d8e5a0cd16c47b4ae319e2@manguebit.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <7dbf8f8019d8e5a0cd16c47b4ae319e2@manguebit.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QAMWXqggml0Cn0B0JcYhOjun"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QAMWXqggml0Cn0B0JcYhOjun
Content-Type: multipart/mixed; boundary="------------wG0XugKK41J5b0VAY0n1z5Vg";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.org>, Steve French <smfrench@gmail.com>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <d27b2c93-b450-4c24-97e8-9cbe5c495637@samba.org>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
 <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
 <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
 <e2a50c26-42ad-4060-9da4-96f89517ee1b@samba.org>
 <7dbf8f8019d8e5a0cd16c47b4ae319e2@manguebit.org>
In-Reply-To: <7dbf8f8019d8e5a0cd16c47b4ae319e2@manguebit.org>

--------------wG0XugKK41J5b0VAY0n1z5Vg
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8zLzI1IDY6MTkgUE0sIFBhdWxvIEFsY2FudGFyYSB3cm90ZToNCj4gUmFscGggQm9l
aG1lIDxzbG93QHNhbWJhLm9yZz4gd3JpdGVzOg0KPiANCj4+IE9uIDkvMi8yNSA5OjM5IFBN
LCBQYXVsbyBBbGNhbnRhcmEgd3JvdGU6DQo+Pj4gUmFscGggQm9laG1lIDxzbG93QHNhbWJh
Lm9yZz4gd3JpdGVzOg0KPj4+DQo+Pj4+IExpa2VseT8gSG93PyBEb2VzIGEgV2luZG93cyBj
bGllbnQgYWxzbyBkbyB0aGlzIHN0dWZmIHdoZW4gdGhlIHJlbmFtZQ0KPj4+PiBkZXN0aW5h
dGlvbiBpcyBvcGVuPyBBbGwgdGhpcyBhZGRpdGlvbmFseSBjb21wbGV4aXR5IGlzIG9ubHkg
d2FpdGluZyBmb3INCj4+Pj4gYnVncyB0byBoYXBwZW4gYW5kIG5vdyB0aGF0IHdlIGhhdmUg
UE9TSVggRXh0ZW5zaW9ucyBiYWNrIHdlIHNob3VsZA0KPj4+PiBwaGFzZSBvdXQgdGhpcyBj
cmFwLg0KPj4+DQo+Pj4gQ2xhaW1pbmcgUE9TSVggc3VwcG9ydCBhbmQgYmVpbmcgdW5hYmxl
IHRvIHJlbmFtZSBvcGVuIGZpbGVzLCB0aGF0IHdvdWxkDQo+Pj4gYmUgZXZlbiB3b3JzZSwg
bm8/DQo+Pg0KPj4gd2l0aCBTTUIzIFBPU0lYIHN1cHBvcnQgYWxsIHRoaXMganVzdCB3b3Jr
cyBpbmNsdWRpbmcgcmVuYW1lcywgd2hhdCBhcmUNCj4+IHlvdSBhbGx1ZGluZyB0bz8NCj4g
DQo+IFdoYXQgSSBtZWFuIGlzIHJlbmFtaW5nICpvcGVuIGZpbGVzKiwgd2hpY2ggaXMgY3Vy
cmVudGx5IGJyb2tlbiBpbg0KPiBjaWZzLmtvIGZvciBTTUIyKy4NCg0Kc3VyZSwgdGhpcyB3
b3JrcyBpbiB0aGUgcHJvdG9jb2wgYW5kIHNob3VsZCB3b3JrIGluIGFueSByZWFzb25hYmxl
IGNsaWVudC4NCg0KDQo=

--------------wG0XugKK41J5b0VAY0n1z5Vg--

--------------QAMWXqggml0Cn0B0JcYhOjun
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmi5K9YFAwAAAAAACgkQqh6bcSY5nkb4
EQ//fjnZM99sbufwJ0RRwffAuKWGv+OGQsTyxM/v97W/7qo9A43RUmAnLRwKHtO/ZMvJlAPpJDwM
15L4J0tjVe2BVi3hUtkaYRB72uMS+4fOF5tK06Yl8l8drIDXkRFDZe/J/bgS/DyLRDACZeDHgfgo
Oe83fi4rPlERu7efi/El4uxm544KTe3QWRDYMOLtjprawiNF22biD5kC7Q7Om+PPG4hug9YrjyYX
JVpQma3b3H+a+6FmIUS/GuwVHCKKA0RP/GzbvU9Ik2hPt2h1mxGXbEIp7FYuk6R4aeKS6H+OaS7Y
nYfX635pSM4sB2k2k9fOjH/F4ZlN5q0Jh8e0TLHDEXenTsxtztO5/LVwgAz1jK44lfl2Q3/en34S
maeNRrIlpfWloFASQpk6tTsW9PWdFVAQ3QYn4DZizRttDlyTseMFpFnwQPwZQXbArSLN6ncYuo8G
iNK7Ineu++KiLk4UQrEFwykelPh31pLQLffn16LR7iYsiH5CdWjcdPIXzrjMThbQldezfv2ZJe+i
KpnFXNF/cGwZemQdSIbUhmc08LcEfjvV0zHXmQ26XJ7OMxTI7wTXY7VfH9HMpPHCknENfCyDrwqe
Fyt99Lp1WRh1TMxd1oskDNCilmj9EyecAVWKC0NKuMR/m04gafJlmYaMbVOomtoN1C7sxzN6uA3b
2Fs=
=SaZw
-----END PGP SIGNATURE-----

--------------QAMWXqggml0Cn0B0JcYhOjun--
