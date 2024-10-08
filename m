Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046BA18C352
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728380413; cv=none; b=SiaxpL073gwcydAaKWNTfla3TJGnUn2mMojG3/w+wqJE1w5CKRMeGyWzcizZF/4sfrW7TnA52LjODDqZV3+Bnqrsm3PduUMSips2JIDOprtBxxo4DuQglvX8HB6V4yrq4pGOSxK/JgnIsERqjY1TtLIv6KWCNENDG4kLTH7WHj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728380413; c=relaxed/simple;
	bh=yIwHB+yWsTEqPRI9wGG6v8F6GigvQecjAb2sz2fv524=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pmNRxks2YN6TlrB6CtVc52QYfwc44DSRxyvnONFpAa/6TIcI0ykZfLJiMyBek381oBY6VyaY9c0NvlhmSScqRT7E5PFDSCed9YHHXkDOe0y/3+FrRs2J/0oqWb3lUlugSpGsSGxz6vQbG/D0s7UMZ2mTGTyqdJr3KUl/Z8xHL1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=USq9Ok6Z; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="USq9Ok6Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=yIwHB+yWsTEqPRI9wGG6v8F6GigvQecjAb2sz2fv524=; b=USq9Ok6ZDa9CjguFXCfU3tjW5r
	NdlwcXP7ZUQc6+gmD9FYLFlm0sgalowx2M/xsPanEdQTgJ0+CaLDFHVlRqkCF0BZ4gs1IaW0MNZTN
	VtHLKOY8ty7NahlJjYDLWiefdxmo+WA4X6AavZ6mG0uebzllH/ZReBzadVuqmWnzdDjutJnTPKS/R
	deyd2o+NFlJq8C/oIWNRqya0bXItgDE0xfb7o/QJ/Yj2R9lq1DzNGUsvLUwZi8mfu1HH9KmCUUHrj
	hv2gTq/n/1DitScNciGSvSr8hrLG8JoUN7JDWdyWS4SEjtaZM08uvH1ZIHTL5uh1MbolEHA8AwH1R
	8gd0ymsgmb1cBRECTawxuCt5ENoK7mpwtWDyyARpYP+NK3ekzqvd9t7Wc+dvDTscc2cq4IYi3JwmD
	F3VZm6l03avG7tyKjVmycwPMmIfI+2SLGM79TyBRK3AVNzM+AqIMnCpoATfSqJ5DXD5TzX/msP380
	uxKJqskeXsACRd477WedBoyT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sy6hL-003tqz-1B;
	Tue, 08 Oct 2024 09:40:07 +0000
Message-ID: <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
Date: Tue, 8 Oct 2024 11:40:06 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
References: <20241006103127.4f3mix7lhbgqgutg@pali>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20241006103127.4f3mix7lhbgqgutg@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dpTt3bGIXj0ufLrwZkYJ1BPp"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dpTt3bGIXj0ufLrwZkYJ1BPp
Content-Type: multipart/mixed; boundary="------------i95u50lRC8CQNS0Ol7YQs0dm";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Message-ID: <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
Subject: Re: SMB2 DELETE vs UNLINK
References: <20241006103127.4f3mix7lhbgqgutg@pali>
In-Reply-To: <20241006103127.4f3mix7lhbgqgutg@pali>

--------------i95u50lRC8CQNS0Ol7YQs0dm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvNi8yNCAxMjozMSBQTSwgUGFsaSBSb2jDoXIgd3JvdGU6DQo+IEJ1dCBzdGFydGlu
ZyB3aXRoIFdpbmRvd3MgMTAsIHZlcnNpb24gMTcwOSwgdGhlcmUgaXMgc3VwcG9ydCBhbHNv
DQo+IGZvciBVTkxJTksgb3BlcmF0aW9uLCB2aWEgY2xhc3MgNjQgKEZpbGVEaXNwb3NpdGlv
bkluZm9ybWF0aW9uRXgpDQo+IFsxXSB3aGVyZSBpcyBGSUxFX0RJU1BPU0lUSU9OX1BPU0lY
X1NFTUFOVElDUyBmbGFnIFsyXSB3aGljaCBkb2VzDQo+IFVOTElOSyBhZnRlciBDTE9TRSBh
bmQgbGV0IGZpbGUgY29udGVudCB1c2FibGUgZm9yIGFsbCBvdGhlcg0KPiBwcm9jZXNzZXMu
IEludGVybmFsbHkgV2luZG93cyBOVCBrZXJuZWwgbW92ZXMgdGhpcyBmaWxlIG9uIE5URlMg
ZnJvbQ0KPiBpdHMgZGlyZWN0b3J5IGludG8gc29tZSBoaWRkZW4gYXJlLiBXaGljaCBpcyBk
ZS1mYWN0byBzYW1lIGFzIHdoYXQNCj4gaXMgUE9TSVggdW5saW5rLiBUaGVyZSBpcyBhbHNv
IGNsYXNzIDY1IChGaWxlUmVuYW1lSW5mb3JtYXRpb25FeCkNCj4gd2hpY2ggaXMgYWxsb3dz
IHRvIGlzc3VlIFBPU0lYIHJlbmFtZSAodW5saW5rIHRoZSB0YXJnZXQgaWYgaXQNCj4gZXhp
c3RzKS4NCg0KaW50ZXJlc3RpbmcuIFRoYW5rcyBmb3IgcG9pbnRpbmcgdGhlc2Ugb3V0IQ0K
DQo+IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IHVzaW5nICYgaW1wbGVtZW50aW5nIHRoaXMg
ZnVuY3Rpb25hbGl0eSBmb3INCj4gdGhlIExpbnV4IHVubGluayBvcGVyYXRpb24/IEFzIHRo
ZSBjbGFzcyBudW1iZXJzIGFyZSBhbHJlYWR5DQo+IHJlc2VydmVkIGFuZCBkb2N1bWVudGVk
LCBJIHRoaW5rIHRoYXQgaXQgY291bGQgbWFrZSBzZW5zZSB0byB1c2UNCj4gdGhlbSBhbHNv
IG92ZXIgU01CIG9uIFBPU0lYIHN5c3RlbXMuDQoNCmZvciBTTUIzIFBPU0lYIHRoaXMgd2ls
bCBiZSB0aGUgYmVoYXZpb3VyIG9uIFBPU0lYIGhhbmRsZXMgc28gd2UgZG9uJ3QNCm5lZWQg
YW4gb24gdGhlIHdpcmUgY2hhbmdlLiBUaGlzIGlzIHBhcnQgb2Ygd2hhdCB3aWxsIGJlY29t
ZSBQT1NJWC1GU0EuDQoNCj4gQWxzbyB0aGVyZSBpcyBhbm90aGVyIGZsYWcNCj4gRklMRV9E
SVNQT1NJVElPTl9JR05PUkVfUkVBRE9OTFlfQVRUUklCVVRFIHdoaWNoIGNhbiBiZSB1c2Vm
dWwgZm9yDQo+IHVubGluay4gSXQgYWxsb3dzIHRvIHVubGluayBhbHNvIGZpbGUgd2hpY2gg
aGFzIHJlYWQtb25seSBhdHRyaWJ1dGUNCj4gc2V0LiBTbyBubyBuZWVkIHRvIGRvIHRoYXQg
cmFjeSAodW5zZXQtcmVhZG9ubHksIHNldC1kZWxldGUtcGVuZGluZywNCj4gc2V0LXJlYWQt
b25seSkgY29tcG91bmQgb24gZmlsZXMgd2l0aCBtb3JlIGZpbGUgaGFyZGxpbmtzLg0KPiAN
Cj4gSSB0aGluayB0aGF0IHRoaXMgaXMgc29tZXRoaW5nIHdoaWNoIFNNQjMgUE9TSVggZXh0
ZW5zaW9ucyBjYW4gdXNlDQo+IGFuZCBkbyBub3QgaGF2ZSB0byBpbnZlbnQgbmV3IGV4dGVu
c2lvbnMgZm9yIHRoZSBzYW1lIGZ1bmN0aW9uYWxpdHkuDQoNCnNhbWUgaGVyZSAodGFraW5n
IG5vdGUgdG8gcmVtZW1iZXIgdG8gYWRkIHRoaXMgdG8gdGhlIFBPU0lYLUZTQSBhbmQNCmNo
ZWNrIFNhbWJhIGJlaGF2aW91cikuDQoNCi1zbG93DQo=

--------------i95u50lRC8CQNS0Ol7YQs0dm--

--------------dpTt3bGIXj0ufLrwZkYJ1BPp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcE/fYFAwAAAAAACgkQqh6bcSY5nkah
lQ//VImRotczqZDOQzOPvOp7YVcUOmAGk+7xtbB7DYTjIvGwgIUbwaWPCjV/5NrYz+U5/2Qp2Fo8
g7BqmGIB78OFHjulO8ncjdcf5PSDfHhGlqGrYE7RZVURzcKwOVb+df8fZbXn3N2R4jN+FGPUxcMM
NYUtma3ls0Ra27LnYXcXgWZvLzey+wYjYw7UfRyWMKGLxpZ2mJFeUNAcpZ3d8GjW6jFsC145+G+2
BqCjJetw4ekRIXoTmcP9Ta4L11HhPnSOQs8sC1ft5MiiuuMqpfyj6erRespYPzPIhqbLTw92RvNO
2A0GKdAxhZgjNBQ9mmIwxbCftNzhv4mxtYvXYJKpivNZnIA9arVtPOJ0md6SKkb3Z5wEigBRigYn
42aQk/tt8cPrr179kvonhwk1mlUcEmb10HQNE9Eotc6DbY9e3E/u1KfHYekJA/jOTEgCYWc/b4wC
sp3CI9K1sPmvIpPdMCRRtLf/QFMPT1FigosCiZNDoXoaGxkJmiVtGMkWQLuT5+7RlaqBCzvjKtiL
3Qlrvx1woMy1Z/gRMrRpa958MJWASf7uaj4A/4akN/gWyFl0r6J7KRMEzwYYC6BqTzoQZkY/zNTL
XflB4Ft0N4CO4funY8fL0IhM7xudnobmr5H6dDDPefQJt9Y8S2CdZtmXh+XKCTfDLyB3KK/FwBjC
5i0=
=79xo
-----END PGP SIGNATURE-----

--------------dpTt3bGIXj0ufLrwZkYJ1BPp--
