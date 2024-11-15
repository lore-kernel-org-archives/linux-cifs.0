Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477741E4A6
	for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 16:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731688195; cv=none; b=hbnS9iHdwrG95InwyHtkVtN5A9dhn6Dvn5dNaCjgVpuUOLKv20KsIY1l9fLg/f7hQSyV+PfKvi/EcD2diiwoZkLyhudnjjhvG8VoPaVxau/jjQ3pqdWFFa1jOPwHOJETsEjZwBZY8CS+SZMF7TTxJnXya61dOkxPo4zUA0jWWDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731688195; c=relaxed/simple;
	bh=sDT6yfMa0A7RGKTIU5mEeBbajBtML9M5fCJOROK1GBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgGa3P/klku1Za+0JnQdB7z0OH+yptLRT9qT5BB0xI7zTrE6Yz67U44+ptwIVBp1d0BnKyxYTMYSZ2O0J+gGsyYTZn5DuEJtgWevLOMuOzicnqf1O/dWlTZxqjNWAel/+EwSAdb3wI5HCYS9PJsIPEZwLtFVeRFoBNTRIWtw2mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EKc32LIq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EKc32LIq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=sDT6yfMa0A7RGKTIU5mEeBbajBtML9M5fCJOROK1GBg=; b=EKc32LIq+cyWMUWZSXrUCN/c6z
	rl8bFdXMvkg6E4U84fRP6/IvIlkj7ND2/vR914ZLpS+HKnZ7TVircy2ZN3f0E9ideCVTGdSOWd3Uw
	y2oMgY2Xp+rtmZd1KoUp3TTuor9jvIft1J6Qm8nf8brkMS4efJtQBXCLUcePeFCKHW4MZlF1VLdOP
	fmany9rS8OsC8xh9R3yRSvZBHtoo7BYFQ0/1KGObrvaSn+PRbbgbKIdWTGNTsckwDdNSSPi5jqeoK
	NtDRHbQ62uRfenlp5wDaNKgHhAZITfibdNXJ57WX6FazMfZnCpu84KrhkL2BT76iEGgVuMDANwC+D
	6VPAb7m3JwmGKryJZ47+0pnSZd10Ilji82C8hkm4w/9JC8qS2E8Qfy6MiZd2UPph/G5SvAXO4WEXC
	dy2BI+TtyC8C5YN14yaIGsWlDfuJQQ//yE0196YBjNel7PtzxpyUL1oCtjycdblSqAopV8QZaA5wJ
	iQCC1KpgPQS3taGCdMeIMg6w;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tBzCg-00AjPX-1r;
	Fri, 15 Nov 2024 16:29:50 +0000
Message-ID: <8663f904-36b0-4f7a-baf8-576c85b7cbd2@samba.org>
Date: Fri, 15 Nov 2024 17:29:49 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using file type information from POSIX mode
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 Steven French <Steven.French@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>, paalcant@redhat.com
References: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
 <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
 <20241115144631.qkteeweaz44knr4c@pali>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20241115144631.qkteeweaz44knr4c@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------weyHaPj4EqMKl65X3mIoTPmC"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------weyHaPj4EqMKl65X3mIoTPmC
Content-Type: multipart/mixed; boundary="------------zMEVDIbjiu140uyt7mz0DOmh";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 Steven French <Steven.French@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>, paalcant@redhat.com
Message-ID: <8663f904-36b0-4f7a-baf8-576c85b7cbd2@samba.org>
Subject: Re: Using file type information from POSIX mode
References: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
 <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
 <20241115144631.qkteeweaz44knr4c@pali>
In-Reply-To: <20241115144631.qkteeweaz44knr4c@pali>

--------------zMEVDIbjiu140uyt7mz0DOmh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgUGFsaSwNCg0KT24gMTEvMTUvMjQgMzo0NiBQTSwgUGFsaSBSb2jDoXIgd3JvdGU6DQo+
IEkgd291bGQgbGlrZSB0byBwb2ludCBvdXQgYWJvdXQgb25lIGNvbW1lbnQgd2hpY2ggSSBh
bHJlYWR5IGRpc2N1c3NlZA0KPiB3aXRoIFJhbHBoIHByaXZhdGVseS4NCj4gDQo+IE1vZGUg
YXMgZGVmaW5lZCBpbiB0aGF0IHNwZWMgaW4gc2VjdGlvbiAiMi4xLjEgcG9zaXggbW9kZSIg
aXMgX25vdF8NCj4gY29tcGF0aWJsZS9zYW1lIGFzIHRoZSBVTklYIG1vZGUgdXNlZCBieSB0
aGUgTGludXgsIEJTRCBhbmQgb3RoZXIgVU5JWA0KPiBzeXN0ZW1zLg0KPiANCj4gVGhlIHJl
YXNvbiBpcyB0aGF0IFNfSUZSRUcgLyBTX0lGRElSIC8gU19JRkxOSyAvIFNfSUZDSFIgLyBT
X0lGQkxLIC8NCj4gU19JRklGTyAvIFNfSUZTT0NLIGNvbnN0YW50cyBkb2VzIG5vdCBtYXRj
aCB3aXRoIHRoZSB2YWx1ZXMgZGVmaW5lZCBpbg0KPiB0aGF0IFNNQiBleHRlbnNpb24gIjIu
MS4xIHBvc2l4IG1vZGUiLg0KDQppdCBpcyBub3QgYmluYXJ5IGNvbXBhdGlibGUgYW5kIEkg
c3RpbGwgZG9uJ3Qgc2VlIGEgcmVhc29uIHdoeSB3ZSB3b3VsZCANCndhbm5hIGhhdmUgdGhh
dCBnaXZlbiB0aGUgdWdseSBzbWVsbGluZyBraXRjaGVuIHNpbmsgaXQgaXMuIFdlIGNhbid0
IA0KcmVseSBvbiB0aGF0IGhpc3RvcmljIGNydWZ0LCB3ZSBNVVNUIGltcGxlbWVudCBhIHNh
bml0aXplZCB2ZXJzaW9uIG9mIA0KdGhpcyBvbiB0aGUgd2lyZSBhbmQgdGhlbiBwYXJzZSBp
dCBpbnRvIHRoZSBmb3JtYXQgdXNlZCBieSB0aGUgT1Mgd2UncmUgDQpydW5uaW5nIG9uLg0K
DQpXaGVuIGltcGxlbWVudGluZyB0aGUgcHJvdG9jb2wgeW91J2xsIGhhdmUgdG8gaW1wbGVt
ZW50IGEgZmFpciBiaXQgb2YgDQp3aXJlIHBhcnNpbmcgYW55d2F5LCBzbyBoYXZpbmcgc29t
ZXRoaW5nIGxpa2UgdGhlc2UgZnVuY3Rpb24gd2hpY2ggDQppbXBsZW1lbnQgdGhlIHBhcnNp
bmcgU2FtYmEgZG9lc24ndCBzZWVtIHRvIGJlIGEgYnVyZGVuOg0KDQo8aHR0cHM6Ly9naXQu
c2FtYmEub3JnLz9wPXNhbWJhLmdpdDthPWJsb2I7Zj1saWJjbGkvc21iL3V0aWwuYztoPTQ3
M2I0NzlhMmFiZjYwY2IyOGVlNDM3NGI1ZDkwY2I2ZGRhODIyMTM7aGI9SEVBRCNsMTk4Pg0K
DQotc2xvdw0K

--------------zMEVDIbjiu140uyt7mz0DOmh--

--------------weyHaPj4EqMKl65X3mIoTPmC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmc3dv0FAwAAAAAACgkQqh6bcSY5nkY5
9g/+JeZ81uWC1lyVBw44RG3PhrbXL3JLT5mm1rahSw89NDCBEvYpzbl5374ZuxGCzw/e0PIXNJ9C
hBlDpZPmEr5mNyedf/dljZaQuc+Zn7ZeKM08DdOu8CbOYRIl5yu1zbXyjbe5ddh/XibLXWIDIzle
X4rlHxj013doK5L01yVx9gdhsiaLUtd61bjq0p5TQppgHRqYDLtS2rPhxyo8nqer/78YVVFqcG60
Cf66Sz9JCDbjdNfXkZuu45CF9YepkItRObgOzbs50NVUslivbZWmri09ERdtMd67Sg7hwM08DZUc
QMoyf3njowjdvKbZG7hJn4uh6xeOUFqrnPy9bt+jnFKtT5RQtYglZlckilDK72fZE4P2ZnFeoh7N
wvd1Mo2zxTV18+MA4ghXmqEtoGjubUvpHecFiMZzTAMA4ex0QKRKPKyYYbm11oBeBJ+Rnr2O3sjK
e+OelrySP8u+hV2thZXZFS7DXUPLb6s8HVEpWRath6qPZvx/Qobz1v/GdTciplRFMo36jVP5Iy4a
lTpWAZUtYLNGuJHWKdGho5PO7vlejXqunmvefP1ZH7A09kfybX/XEkDkC9AhiVX2EfAM0hnxdVAJ
rxVNL/uqnfLCdNXSeo+lv1wITnLCna8Pxav1D+j6vIvvbikyqi3luDBtYyfeu+V6v5Lpa84Lzq6h
6xQ=
=aFYn
-----END PGP SIGNATURE-----

--------------weyHaPj4EqMKl65X3mIoTPmC--
