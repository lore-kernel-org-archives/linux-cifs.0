Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE0D1990D9
	for <linux-cifs@vger.kernel.org>; Sat,  2 Aug 2025 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754153454; cv=none; b=Tl5iSSqUBTq44G6QJwkNt4ez9HeuDplVycvGqOecaPURxoj7LVwJ9KsxalK41YlsiByvgW6TNoNGSMeuAOSaVyjNIr4EuEhhXhaUvRjlQSpBR8ZEi4gES8LKkzJmzU4Nuy+j6QCxlXLb4f1SDOeCY4hz7IUi8T64rJhBOrXnZHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754153454; c=relaxed/simple;
	bh=IteVVSgOYwRpPlIb+HK813b5XDmvPrWivR/9WxEeqws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HyZ9Gi4AkilPcbKVJ2l0Rg6Fa+ScBH8bYVAPZNBKxIVxjutOfgwt7mFhItPHATlHk9r8zHIX0Q1rNBf9CpCTQTGQK6c4C0dXYM1VlUfAWnvgIZMgfFcJrujcsVQ6WGXq9/4fudunumPWJHZNnUJUz6HnSNaJQ9PjD/bddfZ2VmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XOvXW78K; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XOvXW78K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=IteVVSgOYwRpPlIb+HK813b5XDmvPrWivR/9WxEeqws=; b=XOvXW78KDCFojjNYgYCU7aJ3ws
	wfm3NVP9ZN5jdbIK9Niqkbk8hkBYe/CcN+HQ/ikJjbrEQLV/MlZSi6xXgz4HP1MUwm+wQ1Bf033g5
	7P6fmJfHruebGLMhgnJFKHgX7VKHTxN5YAR1ypHQjDYY5HXexq5oY00Z4u3qXudhvR0BV/7ll83Rn
	xE2JEzO/TntiIRpP8gDbu5XI2UzB8CbO8cf0H4QWtdH11OBT+w/sBqTSXVWniJvyUIOxfYz29SFqr
	PRwv2leFsEg49ZOKxZ1PJ+7wIf0HUQsdl+4J+TlAhptaHSLJBPDtppPJFOUTAMyVHQ8yzYl0hGFp/
	je55ReioDmdOjRbL4QsJYpR/YFlmaUsWoKm3wp1XJnn82ioqAbULTt0nAsv7XfQLlO9SK1uZJzF06
	OegRG3a65gA0S3Ja0XUAEC4V5YbyUbycGvQKmxdq4C8oPEACO570Fn4oQmCoMqZQYB92J/NTeRtNm
	SIfTyB+skM1WB8YPalNi+beK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiFRU-000hje-0v;
	Sat, 02 Aug 2025 16:50:44 +0000
Message-ID: <478c8616-957c-4e82-86ec-f645c2b43654@samba.org>
Date: Sat, 2 Aug 2025 18:50:41 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] delayed mtime updates: configurable?
To: hede <debian452@der-he.de>, Ralph Boehme via samba <samba@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
 <20250801113523.76290fc7@hpusdt5.der-he.de>
 <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
 <20250801155827.36e722ef@hpusdt5.der-he.de>
 <d93fd05d-aacb-4163-a4be-fe1ee57c3c48@samba.org>
 <20250802103113.0e12da0a@hpusdt5.der-he.de>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20250802103113.0e12da0a@hpusdt5.der-he.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------12Sr0Nb2h7n0rnDhfuygXDuk"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------12Sr0Nb2h7n0rnDhfuygXDuk
Content-Type: multipart/mixed; boundary="------------YSFLzJ0vJn0MtfFs7QQWs5DV";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: hede <debian452@der-he.de>, Ralph Boehme via samba <samba@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Message-ID: <478c8616-957c-4e82-86ec-f645c2b43654@samba.org>
Subject: Re: [Samba] delayed mtime updates: configurable?
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
 <20250801113523.76290fc7@hpusdt5.der-he.de>
 <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
 <20250801155827.36e722ef@hpusdt5.der-he.de>
 <d93fd05d-aacb-4163-a4be-fe1ee57c3c48@samba.org>
 <20250802103113.0e12da0a@hpusdt5.der-he.de>
In-Reply-To: <20250802103113.0e12da0a@hpusdt5.der-he.de>

--------------YSFLzJ0vJn0MtfFs7QQWs5DV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8yLzI1IDEwOjMxIEFNLCBoZWRlIHdyb3RlOg0KPiBPbiBGcmksIDEgQXVnIDIwMjUg
MTg6MjM6MjIgKzAyMDAgUmFscGggQm9laG1lIHZpYSBzYW1iYQ0KPiA8c2FtYmFAbGlzdHMu
c2FtYmEub3JnPiB3cm90ZToNCj4gDQo+PiBpdCBkb2VzIGl0IG9uY2UsIGJlZm9yZSB0aGUg
d3JpdGUuIFVuZm9ydHVuYXRlbHkgdGhhdCBtZWFucyBzdGlja3kNCj4+IG10aW1lIGlzIGlu
IGVmZmVjdCB3aGljaCBtZWFucyB0aGUgdGltZSBleHBsaWNpdGx5IHNldCBpcyAic3RpY2t5
Ig0KPj4gYW5kIGFueSBzdWJzZXF1ZW50IHdyaXRlIG11c3Qgbm90IHVwZGF0ZSB0aGUgbXRp
bWUgYnV0IHRoZQ0KPj4gZXhwbGljaXRseSBzZXQgbXRpbWUgbXVzdCBiZSBwcmVzZXJ2ZWQu
DQo+IA0KPiBXaGF0IEkgY2FuIG9ic2VydmUgaGVyZSBpcywgdGhlIHRpbWUgInByZXNlcnZl
ZCIgb24gc2VydmVyIHNpZGUsIGZvcg0KPiB0aGUgZmlsZSBpbiB0aGUgZmlsZSBzeXN0ZW0g
b24gZGlzaywgYmVmb3JlIHRoZSBmaW5hbCBjbG9zZSBoYXBwZW5zLA0KPiBzZWVtcyB0byBi
ZSBzb21lIGZpbGUgY3JlYXRpb24gdGltZS4gTm9uZSBvZiB0aGUgY2xpZW50IHRpbWVzdGFt
cHMuDQo+IFRoZSBjbGllbnQtc2VudCAic3RpY2t5IiB0aW1lIHRoZW4gc2VlbXMgdG8gZ2V0
IGFwcGxpZWQgb25seSBpbiB0aGUNCj4gZW5kLCBhZnRlciB0aGUgZmluYWwgY2xvc2UuDQoN
CmhtLCBubyBpZGVhLCB0aGlzIHNob3VsZCBub3QgYmUgdGhlIGNhc2UuIFNvcnJ5LCBidXQg
SSBkb24ndCBoYXZlIHRoZSANCnJlcXVpcmVkIGRheSBvciB0d28gdG8gZG8gYSBmdWxsIFJD
QS4NCg0KLXNsb3cNCg==

--------------YSFLzJ0vJn0MtfFs7QQWs5DV--

--------------12Sr0Nb2h7n0rnDhfuygXDuk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiOQeIFAwAAAAAACgkQqh6bcSY5nkaf
OBAAu2cOhzlWy0sQlCnNhS7QeE+RTLc8sm2S0WDVi9Gawe2/9Ipj7t/vUYq2ChAYYo/NKZBngYum
WYGwCD3xSVmnlfT5q4Wj7kp7WvEAUkdWIn7HbbaYk3/5B3dLkjCOsFrZ/TDqM0CAvNbNn7DXaj15
yAD1GZW0b9dC8NSkDgNrKVPUKo0HYxUSuXqLcimq72qj7h6dFu5Cjig/tPJ76CND2BiTPRzbRfpn
MG3s4P9hiWI505FVtNRZFPiOpy/oi4HMQFlYyN28dFpXLBsfKkWD/a7jZhMOKSUokB4Sn2f0mAMA
FERnazlnuCStJnVDg7S4RYnY0RROvOrswXHfGWQMTRWzGUU3G8SrwHuZbBZM9z1u3WLMzgPX8P3a
PJHMoOUj+8ux/00f4ud06paynq1eeVeiy6bRdLJSmd2AAAv8vhWKwyczmp9XrcDz8f6SQ/3k3TET
+wZ3c+TGeTFs/qBOj+pk05xi4jjxVSPfwjWKdf68Byw13hGucY14nHMeb65f4cCzAHiS1seHSfGE
/ock6/XISKEMuNd+fVIglSgKyye40fK+HZv4bl5yZgp/eAJL1kixDbsP47LMr8fyJrer7VA6Csz2
oT7uJvT9+79+WKyhCl46MiYMypjrRQJlAtPDq8QJOTsGuig+P5tZ4RRv5j9xWp8K6Wx/gqSOw6Jb
1Hw=
=cZ8e
-----END PGP SIGNATURE-----

--------------12Sr0Nb2h7n0rnDhfuygXDuk--
