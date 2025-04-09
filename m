Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A721D90A9
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 06:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744179913; cv=none; b=He2cC/+GLB3ttgYT8uuQxFi+ZBE2VHXlEId+CaF8sroimH6aGSNv1GEhiKEC1KRuDdJMmsVV+Xff5r3rG8jSK3Fy/dXfPAmJJErCftrJApmIcupwy4yI0rfFoaHXQHhMUJumADvPAwlh2k8Jfqh07LjxQIwYYwQOWHp8lyL74Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744179913; c=relaxed/simple;
	bh=jUkmKwL4hFCIVkAqUyOiOb1SwxnX+MBicB8PqIqnIz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k++Rfu3g4ja1b5lwQojiRIFSz9SrxO6BNXXECFEIW9dtIaYJhEpkk2l/dq2gppoIWz3cwru9/1qvuluE00trZZ+S+0aOF/vc7kZZgyQfm/0jjKeqqvI0FRnDzCto9zdUU3GBOtcDvICOcOgxyxkaZrDzli9hQ14sSLSi/ZLdA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JERV4QZ3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JERV4QZ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=jUkmKwL4hFCIVkAqUyOiOb1SwxnX+MBicB8PqIqnIz8=; b=JERV4QZ3CTZ5/QiRuqtvUKIDOD
	rCGtPX9c101MB9WuBf5aCyqqhrVvo8PjjA723OiavlM4z9g5Qv+sLP9B5e3HbvRxetEKw+L2y51Ch
	nRivPb6HDx8X1/LWWGA/aK5KSGXJRxLzhiZOR0q5n+0onyRShhw24znQ0VfyYYkal1JlXNTNwVj+D
	+NPXIpyNnsVFwyblESUgxfniMTKs8zmwEn/A8liMPCnwU8CBy9NXQljfQYu/CuxD8Vkr4VEmjj3ux
	vyjfO4ijqSqNvzrpSb/de2Ua51sBhlgED80ZvuXY0/6LOhGAMykbQ4J8Nejg4FJQKfBj4nFTMdUmm
	fQeeJOpbw+2tG3JYjt7XNx5QFWt0Rhqgakh30KGBKG9hxlD1NosH6TjPwzkem7TMb7mw5fj2u+NHU
	yUSl94sbjjcbW5BdaSdV6E6vQl0yKZ3pSJ/UgnH2+J/PnRlGJukEl08N25HqZYdCbWJhdmKqY1S3p
	4qJfH+SNDnOWqy/UG5fgdlbA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2OgL-008okN-0I;
	Wed, 09 Apr 2025 06:13:05 +0000
Message-ID: <ef44bc0c-f715-482b-b133-b2fecdb78a27@samba.org>
Date: Wed, 9 Apr 2025 08:12:20 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: directory lease handling perf bug
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 Enzo Matsumiya <ematsumiya@suse.de>
References: <CAH2r5mvSBqF1uW+hZ+1syN=bZsqn6RPPfDgsho6FxpMgJRBHzw@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mvSBqF1uW+hZ+1syN=bZsqn6RPPfDgsho6FxpMgJRBHzw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------mq6JEVi2dugO1boWp1t0vVsu"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------mq6JEVi2dugO1boWp1t0vVsu
Content-Type: multipart/mixed; boundary="------------D0I8qGn0REZ0mtySzIxtLJwO";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 Enzo Matsumiya <ematsumiya@suse.de>
Message-ID: <ef44bc0c-f715-482b-b133-b2fecdb78a27@samba.org>
Subject: Re: directory lease handling perf bug
References: <CAH2r5mvSBqF1uW+hZ+1syN=bZsqn6RPPfDgsho6FxpMgJRBHzw@mail.gmail.com>
In-Reply-To: <CAH2r5mvSBqF1uW+hZ+1syN=bZsqn6RPPfDgsho6FxpMgJRBHzw@mail.gmail.com>

--------------D0I8qGn0REZ0mtySzIxtLJwO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU3RldmUsDQoNCk9uIDQvOS8yNSAxMjowOCBBTSwgU3RldmUgRnJlbmNoIHdyb3RlOg0K
PiBUaGUgZGlyX2NvbnRleHQgcGFzc2VkIGludG8gY2lmc19yZWFkZGlyKCkgbmV2ZXIgc2Vl
bXMgdG8gbWF0Y2ggdGhlDQo+IGNhY2hlZCBkaXJfY3R4dCBwb2ludGVyIHNvIHdlIHdvbid0
IHNldCBjZGUtPmlzX3ZhbGlkLiBPbiBlYWNoIGNhbGwgdG8NCj4gY2lmc19yZWFkZGlyIChm
b3IgdGhlIHNhbWUgZGlyZWN0b3J5KSBpdCBsb29rcyBsaWtlIGN0eCBpcyBkaWZmZXJlbnQu
DQoNCndoZW4gZG9pbmcgc29tZSBxdWljayB0ZXN0aW5nIHllc3RlcmRheSBJIGhhZCBub3Rp
Y2VkIHRoYXQgZm9yIGEgc2ltcGxlIA0KbHMgLWwgdGVzdCB0aGUgU01CMl9GSU5EIGlzIG5v
dCBkb25lIG9uIHRoZW4gIFNNQjJfQ1JFQVRFIHRoYXQgYWNxdWlyZWQgDQp0aGUgUkggbGVh
c2U6IEkgc2VlIHR3byBTTUIyX0NSRUFURSBvbiB0aGUgZGlyZWN0b3J5LCB0aGUgZmlyc3Qg
b25lIA0KZ3JhYnMgdGhlIFJIIGxlYXNlIGFuZCB0aGUgc2Vjb25kIG9uZSBpcyB1c2VkIGZv
ciB0aGUgcXVlcnktZGlyLiBHdWVzcyANCnRoYXQgZXhwbGFpbnMgaXQ/DQoNCi1zbG93DQo=


--------------D0I8qGn0REZ0mtySzIxtLJwO--

--------------mq6JEVi2dugO1boWp1t0vVsu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf2D8UFAwAAAAAACgkQqh6bcSY5nkYA
aA/+LmPKTjIjEtBd4zxvvC1ASVBWuQ6QQNNMCi3R25w4ba0u0XXLnrkDy5aTlI3k9QFCwD/FMSvV
ZJW3G/ZbFNUO56OCDN7FvMyzE1p9DNghOK1QZNGzNmKIVhColPg+FxhMgGvmwz1vQOY/MZ1v/U5h
rlJjTyTZuPr3bY2EHVAw+S8LTwZ/JKypXKjrxHRGwTbh98XuQrW8NBKpzPUMRK5OXRObFHWJGkS1
/VCBrkHqH38uOLfJCEq5IRbqe1si41xx4vubU+8zrdrSWXP8c2t41rj401N2tatFd2svqH46uzmg
1ucHCj7oQIyy0EpUrB8OJRZJc3J2S5K824biODHQxzNVR7fNXlDG0yzk0rGQ5SMlSXKQLPdnL2qw
HZe8ofvMI0eijLunnzpnNF6zBvjuQDTaZDIckReZmJxdbUzKNGBCwg0ZgxlOMh+RK0S2xJwKgd+G
RGhiW8Zc6HVrmaio1N68Zzx1ZNUpKvQE6pzSyF97uwvNOBuaH076bM0gPDg0YiUPbMKz1ul4U+nD
FiMdnYOmHlscs+5ywtQ2INfBwdA7UVR3MocO8tvQmRWjZmPT67wb0+xRKdtV799fsy8o5llS48v1
QmW8ze8BViZ+5CVHiU1TQR/vj7fwLmjQPNwSXNRYDivCHQAT5A5w3oXDGe+Kv3Xs6mAC5sBFtFVU
SW4=
=vORL
-----END PGP SIGNATURE-----

--------------mq6JEVi2dugO1boWp1t0vVsu--
