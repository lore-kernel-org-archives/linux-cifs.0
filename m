Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB8B1B95B
	for <linux-cifs@vger.kernel.org>; Fri, 29 Nov 2024 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732897337; cv=none; b=sfk9ta6Py+OGijeDq1oSLcSD4bvN/93D0fqGexT8eElv2Lxo5J4X6U+lGkWUK6/wxwfrOHMQ5meHDvAMSZFBSMEHj3FUgOObxbP3+6ue3fHyJzrD9VqHmA8Z+vXPzDcMGDcbw4zSP0mkLhrYR7MlMX3UKIC0cF1MlJjDOieVhBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732897337; c=relaxed/simple;
	bh=KxQb7vGvYOOLTCN6/uHGhmb+QvUAEh/oCdCRT4j8Do0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=q5HFw/nk8MVhovMDelGu6y/MW4pN/Zmj49nZgyVbBXDcP1UcZSLBD/RGcuTJOWUAadHvs+qXxo65Ar10qHQ8U5GpL/Ziu9dzfNMVcMr1YhRcMoi2gSQJfB+c+m6KtsE6d2g1E6AEQbbJTdSfUjB2Vx3i7fBCbUaSqvG4rbcU8oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=14Er4vvD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="14Er4vvD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=KxQb7vGvYOOLTCN6/uHGhmb+QvUAEh/oCdCRT4j8Do0=; b=14Er4vvDdHnNPhKWJ1MWTTUv5j
	/VLaFKLbDACrPDWl89ynKYraCZDn00wmMqH/QjZu0UXmW9UEzP0ZgY8DIorDwYP3YAZXkNko1dC1D
	fxqk9DiYJs7gbC5emrKgp23Xi1dusDB8TEZnEEG7kQPctwcs9Cep/sXbE56/KXJmDsbrZhCFXVnFd
	eXfOd4cqZuCBlD/QRkPy0/emw4Rr7XV8xtvbDzvrrfROL1c8tdR8HUVZsf6Ex5C2CCo6h0ty6dsaE
	mqdqWhP+NWzbM2nQXd5ocE5cQGdXp3OMlBJESfF0gRyexp57/9aj3s9ciqze5TdbJbckThsoNGtQO
	R/6nD+q3SIgqm+kcoxb3DlsQIrWxZUKqIszmHDNicVSo7HiAKligHOBVLA60i5IhQvEVDO5ONRViG
	tSwFmQ8kVm0TglWYebgBetRzpfEzjAbx6hwy1/fL9cLetfP43qmz8cESDXCh7JW/qQslSMshC5UCR
	G3oNm4r5QjetkgPR/VO+CRZd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tH3ky-0022Gv-2V;
	Fri, 29 Nov 2024 16:22:12 +0000
Message-ID: <6c44d87f-de98-4efd-b016-a491e9c57cb5@samba.org>
Date: Fri, 29 Nov 2024 17:22:11 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] Random EINVAL when opening files with SMB3 POSIX
 extensions enabled
To: Andrew Gunnerson <accounts.samba@chiller3.com>,
 Steve French <smfrench@gmail.com>
References: <9995d904-6d0b-4086-b49c-944e845f127e@app.fastmail.com>
 <fa1f85a7-b086-485c-bb25-3c3d8c4cc490@samba.org>
 <53b97278-a054-4bf1-97cb-e2d648c6868a@app.fastmail.com>
Content-Language: en-US, de-DE
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <53b97278-a054-4bf1-97cb-e2d648c6868a@app.fastmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0gMYHnroEb8KsABHFtYnvWX3"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0gMYHnroEb8KsABHFtYnvWX3
Content-Type: multipart/mixed; boundary="------------lCLdMTvm9a63GUXFARcAvDWe";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Andrew Gunnerson <accounts.samba@chiller3.com>,
 Steve French <smfrench@gmail.com>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <6c44d87f-de98-4efd-b016-a491e9c57cb5@samba.org>
Subject: Re: [Samba] Random EINVAL when opening files with SMB3 POSIX
 extensions enabled
References: <9995d904-6d0b-4086-b49c-944e845f127e@app.fastmail.com>
 <fa1f85a7-b086-485c-bb25-3c3d8c4cc490@samba.org>
 <53b97278-a054-4bf1-97cb-e2d648c6868a@app.fastmail.com>
In-Reply-To: <53b97278-a054-4bf1-97cb-e2d648c6868a@app.fastmail.com>

--------------lCLdMTvm9a63GUXFARcAvDWe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEvMjgvMjQgOTo0NiBQTSwgQW5kcmV3IEd1bm5lcnNvbiB3cm90ZToNCj4gVGhhbmtz
IGZvciB0aGUgcmVwbGllcyENCj4gDQo+IE9uIFRodSwgTm92IDI4LCAyMDI0LCBhdCAwNDoz
NCwgUm93bGFuZCBQZW5ueSB2aWEgc2FtYmEgd3JvdGU6DQo+PiBJIGRvIG5vdCB1c2UgdGhl
IFNNQjMgVW5peCBleHRlbnNpb25zLCBidXQgcGVyaGFwcyB5b3UgbWF5IG5vdCBiZQ0KPj4g
ZWl0aGVyLCBoYXZlIHlvdSB0cmllZCByZXBsYWNpbmcgJ3NlcnZlciBtaW4gcHJvdG9jb2wg
PSBTTUIyJyAod2hpY2ggaXMNCj4+IHRoZSBkZWZhdWx0IGFueXdheSkgd2l0aCAnc2VydmVy
IG1pbiBwcm90b2NvbCA9IFNNQjMnID8NCj4gDQo+IEkgdG9vayBhIHBhY2tldCBjYXB0dXJl
IGFuZCBkbyBzZWUgdGhlIHRoZSBjbGllbnQgbWFraW5nIFBPU0lYIGV4dGVuc2lvbg0KPiBy
ZXF1ZXN0cywgbGlrZSBTTUIyX0ZJTEVfUE9TSVhfSU5GTy4NCj4gDQo+IE9uIFRodSwgTm92
IDI4LCAyMDI0LCBhdCAwNDo1MywgUmFscGggQm9laG1lIHdyb3RlOg0KPj4gY2FuIHlvdSBn
cmFiIGEgbmV0d29yayB0cmFjZSB3aGVuIGl0IGhhcHBlbnM/DQo+IA0KPiBTdXJlIHRoaW5n
ISBJIGRpc2FibGVkIFNNQiBlbmNyeXB0aW9uIGZpcnN0IHNpbmNlIGl0IHNlZW1lZCB0byBt
YWtlIHRoZSBwY2Fwcw0KPiB1c2VsZXNzLg0KPiANCj4gMS4gcGNhcCB3aGVuIHJ1bm5pbmcg
YGNhdCA8ZmlsZT5gLCB3aGljaCBmYWlscyB3aXRoIEVJTlZBTDoNCj4gDQo+ICAgICAgaHR0
cHM6Ly9maWxlcy5wdWIuY2hpbGxlcjMuY29tL2lzc3Vlcy9zYW1iYS9wb3NpeF9leHRlbnNp
b25zLzIwMjQtMTEtMjgvcG9zaXhfZW5hYmxlZF9icm9rZW4ucGNhcA0KPiANCml0J3MgYSBj
bGllbnQgcHJvYmxlbS4NCg0KU2VlIHBhY2tldCAzMDogdGhlIGNsaWVudCBpc3N1ZXMgYW4g
UE9TSVggU01CMi1DUkVBVEUgd2l0aCBhIHBhdGhuYW1lIA0Kc3RhcnRpbmcgd2l0aCBhICIv
IiB3aGljaCBpcyBub3QgYWxsb3dlZC4gSWYgeW91IGNoZWNrIHRoZSB3b3JraW5nIGNhc2Vz
IA0KdGhlcmUgdGhlIHBhdGhuYW1lcyBhcmUgcmVsYXRpdmUgYW5kIGRvbid0IHN0YXJ0IHdp
dGggIi8iLg0KDQpAU3RldmU6IGRvIHlvdSBoYXZlIGFueSBpZGVhIHdoYXQgY291bGQgYmUg
Y2F1c2luZyB0aGlzIGluIGNpZnMua28/DQoNCi1zbG93DQoNCg0KDQo=

--------------lCLdMTvm9a63GUXFARcAvDWe--

--------------0gMYHnroEb8KsABHFtYnvWX3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmdJ6jQFAwAAAAAACgkQqh6bcSY5nkZs
yxAAoaXcGzrnmjY0ZSt7KjslznXj2agOeXO8PZ9LM8uH5t9QV2/a9yDIMPHHk8lV5scoDZniZzBT
BJuqOr5T9DdpgD+VdRg8QviPwhJPYfIe0laWzLaud8CkBqFp/tfoEczPqgYwCo9piOPive0tpgI0
SpsolFLbQU7PQ113FDGWt8XAbO2sfFZAEe5PTv/j373wByfZSPgN1hdHJyz4Qi8UYOGSt247O3aA
uhjF0ZnecQ6Fc29RGA8i36a6VKiFYPGzZI7FMG1htQ7CtVy9pq3vHwxETAzRty7bVB2Nq4Qpi4M2
Gl1D0Rao8yZ5SEJvVOuvHkBPjUizDJ7VG5gVySBVifby2iUMCcs3qUoPRfkRKs0rKDWCdB17SInY
OL73g2yj7ebgzh7JIXbSEgktyr3w9BNV8G/ZwWRSQqMrncOpXn1o0JlpOtx4rckIFSowFhqP27de
N+5qSCtBCSukXQIe1iRqK6/DNslR5zZjSF9TG9tLrw/tnVzhAqwLOHrWuGGaZn0UyWVwmMA2YHo5
b5HBT/xVEoPtXqMfuCFv9WKoLFlgd4ldzmJnua8y7Bgpb/5FpwYGICfv5P0HBhjiqdO7DlxgYnDp
Wa8EpAptsPgHvleftqh01LnzSppyfGYP5552PxUuGqQAXqCz5EYGblRZvxPTGQ8JSQqDf57mzzxX
5hY=
=7Jc0
-----END PGP SIGNATURE-----

--------------0gMYHnroEb8KsABHFtYnvWX3--
