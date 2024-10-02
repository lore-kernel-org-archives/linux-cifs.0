Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE941946B9
	for <linux-cifs@vger.kernel.org>; Wed,  2 Oct 2024 07:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727855148; cv=none; b=XMPTsVb/LpaZM8wKLfLMoZTH2JmXI/RbrK4O9cGQHi3QJdOTWH621vPVmaWZiFAXhlUpSXvZbeVGAKLoohUQfSp393tvBPu9fovITeqYvMc2WS/wZWXys4cLEu0LRK+/wr6yYavdpf3pUmA1wxytmCmFfn91NPZfm7j9GF9zDb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727855148; c=relaxed/simple;
	bh=5LELXkW0C9Fmcl77BcJ1Ngqlc1VgztzkMxiP97f5cZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RVW2xVT6UNRLacrR1oR+VC70J/vv8ZDRVdh/6nlqXsCqU7XAYdr92FW6KitArxAF5o7n3uw+J0Dz+uIYnYH/OI2cA7UNsL+DAOIx2fE8GoYJ8utr6Q7E2nFjS3Ckz5F6ABSlf+TMxQFTGu4Cy4f4mJ8FreT55LJ4XZlwUQkQgZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PDjz37pt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PDjz37pt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=5LELXkW0C9Fmcl77BcJ1Ngqlc1VgztzkMxiP97f5cZg=; b=PDjz37ptrKlxmtmtU54bBJTHjn
	kN4EJnwnkzQ7Gj/pHWd6Les6Fvs+gIF+iP7D/7pGgfPSuVWM2ehe0LsAtxVUANBWzEMZ3RZxKHi8a
	/tv0GkdIuU7O1l+b5QiRe+WZv4IJIHcMDfpR983frSC+e8A3XjCnquz90ZhGeBu2ys28535u9wN7P
	Bw8dQ1Nlwh3QGIMMsWJKIwgJYvKSKrIMHugSsmGHqB8Q/CpkGc86p1XrOuZFor2EX2Un0TQDQTkpa
	ktGY7Io6QvrI3KFCQel83VXuH/x0bD4mms2aOk/5LTxAysypxqinF/nlTzDR7TxS0rWAfZZ6N6Whv
	4wrtkWISoyHLT1pwLBZCcQaWALmh7Ur6sTa8Mpxv+TSimoCpUtcOT5bj0FAGqpvsbitl6n/r9M6rM
	rcfT5Q0H/I5CAobUZ4fvN8yR4ybLmbHcVMFWj45BM2e1mavwFuzwjcLnrvoqJbZzPdnvBgk2+BMOW
	6Vhi4gcla7eorWQIrMUocFxN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1svu3L-0032C2-2G;
	Wed, 02 Oct 2024 07:45:43 +0000
Message-ID: <682404ea-15d8-4b18-be2a-b2e50abbb932@samba.org>
Date: Wed, 2 Oct 2024 09:45:43 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5mv0onp+Zx8yhKAsu4wXZ-D2XMmARgZhPDaJx4DWQ-We4Q@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mv0onp+Zx8yhKAsu4wXZ-D2XMmARgZhPDaJx4DWQ-We4Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lJZ9LjPFtr7N0CAkwQ8ZRKd9"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lJZ9LjPFtr7N0CAkwQ8ZRKd9
Content-Type: multipart/mixed; boundary="------------wGIZTKe02ZiDA7OOMKBRaOqw";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <682404ea-15d8-4b18-be2a-b2e50abbb932@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5mv0onp+Zx8yhKAsu4wXZ-D2XMmARgZhPDaJx4DWQ-We4Q@mail.gmail.com>
In-Reply-To: <CAH2r5mv0onp+Zx8yhKAsu4wXZ-D2XMmARgZhPDaJx4DWQ-We4Q@mail.gmail.com>

--------------wGIZTKe02ZiDA7OOMKBRaOqw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMi8yNCA2OjExIEFNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IEhlcmUgaXMgYXQg
bGVhc3QgdGhlIGxvZy5zbWJkIG9mIHRoZToNCj4gICAgIC4vc3JjL2Nsb25lciAvbW50Mi90
ZXN0ZmlsZXNyYyAvbW50Mi9jbG9uZS1vZi10ZXN0ZmlsZXNyYzIgICh3aGljaA0KPiByZXR1
cm5lZCAiQmFkIGZpbGUgZGVzY3JpcHRvciIgb24gdGhlIGNsb25lIGlvY3RsKQ0KPiBTZWUg
bGluZSA0NzM5DQoNCnNhbWUgb24gdGhlIHNlcnZlciwgd2UncmUgZ2V0dGluZyBhbiBFQkFE
RiBmcm9tIHRoZSBmaWxlc3lzdGVtL2tlcm5lbDoNCg0KWzIwMjQvMTAvMDEgMjM6MDQ6MjAu
NDQ5MTM2LCAxMCwgcGlkPTMzMjE5LCBlZmZlY3RpdmUoMTAxNywgMTAxNyksIA0KcmVhbCgx
MDE3LCAwKSwgY2xhc3M9dmZzXSANCi4uLy4uL3NvdXJjZTMvbW9kdWxlcy92ZnNfZGVmYXVs
dC5jOjI0MTQodmZzd3JhcF9vZmZsb2FkX2Zhc3RfY29weSkNCiAgIHZmc3dyYXBfb2ZmbG9h
ZF9mYXN0X2NvcHk6IGNvcHlfZmlsZV9yYW5nZSBzcmMgW3Rlc3RmaWxlc3JjXTpbMF0gZHN0
IA0KW2Nsb25lLW9mLXRlc3RmaWxlc3JjMl06WzBdIG4gWzEwNDg1NzZdIGZhaWxlZDogQmFk
IGZpbGUgZGVzY3JpcHRvcg0KDQpJIGd1ZXNzIG9ubHkgYW4gc3RyYWNlIHdpbGwgdGVsbCB1
cyB3aGF0J3Mgd3Jvbmcgd2l0aCB0aGUgZmRzLg0KDQotc2xvdw0K

--------------wGIZTKe02ZiDA7OOMKBRaOqw--

--------------lJZ9LjPFtr7N0CAkwQ8ZRKd9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmb8+icFAwAAAAAACgkQqh6bcSY5nkZt
+g/8DYT5Xkvo9yY9ZnYROht+MhZel7hrggcf8WHD6KmG2TRHZCS9AYa1x6NhNHiFOSyDetdkBkLv
WRP7KHhsJy6J4uEQLH9X03iHG1G+EcGmhRUoj5yQhlzawrNs4t8gYddLllCnNw0FK9cZMeGLuxcw
C/FVE8KUD8tB7fQomPZvFj/ng6xHDjG/2MsMJkb8y5U406/nU98mzPdGXoOXyAUQKP2INzWylFC8
PfeCkxOY7Jzr84tSI77I8p6KAPlfrwNpxa/VpuxMVnwNQNiz97pVpQmvWuo18d2+DdkmjaVVMaPb
+CyEMlQflIDgz/RG/bCIuGWAiuggSxcS8yQw7sfnm8Y5YMlam4ZnPJjB47kR2dJZlYHfNk+riZoS
wyo1BkKwC6jKfD0yumMxMWtqmccTYFbLKDBXbGr1KASXONW9GTPz01+DFYs5b4mktugnmuDZrE8R
jcVhdnXpTpHqAQ2ZpXWzy971xh52gUnBV4v2vvwqlA7Okm+E4HpkUZTyzmcP0qV/e+P5ia04w8nX
BJ+rfZkztdA/ZSFCNWAIX6xlYeZkxdaiXqo2qN1IPwV2VGW2j7HcNfuGZSC21jE2Us7wT0T9To3t
ZT5kUV9kEOcX2lCkdsjSL3FDrcWHJJ1htwJhDFz8vCxoZ0FHK1yLBOsJxLd6Jo6yMQJpBNaLgYKK
BKI=
=yiIu
-----END PGP SIGNATURE-----

--------------lJZ9LjPFtr7N0CAkwQ8ZRKd9--
