Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E401FF5F2
	for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2024 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436036; cv=none; b=WxLcoKQrYilEwBiAyIPAVjtJYi83BbRJBUOX67v3tqoBFVoXVwnk2fWBQdPoW6DwzRM4vLRMQNhYR0eS5K69TKJv4RB004HsC3JU6V86yI1F1NDNIPCPoe8nL0hCPFLxtFmhI4TrFlOq9mnToC9/bqCeZ5KX+PWjCJmFYNBEjxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436036; c=relaxed/simple;
	bh=hsMDDiN0ad5NeyAJDN7iOJ2t7Xros8wghBW4UeLx/KI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=YxwZJ2752M/SO+bRBSdXiT193wlEM3JWadkPPCQ3Z+WKg0or/cNPx6hSeaHNuMGnAPzJDAcEPB34NrMDXkE1MYH10vGHpFxyZ07YMUK0o2B6lUQhw9AteoREsM4F/NERWRJb8eI+BGIFdsL8Mf81Vc2ui7fNVwVeJgEihBLliek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=KJf+fAIp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KJf+fAIp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=hsMDDiN0ad5NeyAJDN7iOJ2t7Xros8wghBW4UeLx/KI=; b=KJf+fAIpmxGRteD2fOyGy0pC+3
	i+RYcb5P5ZixExqF9KAM1i38cfvApn1l2Ryckc6xi6R+7hWCO1c2AVA/XuBPZ4b7GwfdvOFik9lCR
	KCob671ws3KVJGHSOB1FAQytpxH+QILowAvjjg7kT59W6P38Plf54KFjzd8YpSBFfC2T4EyxMyzVe
	8mhcndvqxixFf00aVn4JvsAVtKUAomMbg5G9RssmZI0Ib2FDm/utK6adXcDY+3gwSpoAf/QXnBEhM
	dtmsZZKVlJxhCLvKB5tWvoBrHZRT2eLqBm4FPLSchbh1EHe9AmNEOOUGfjjZkm31W8Uw56ZerZrdr
	0194h5KoeKjgD5B8nZdEWmhFmxGjrqkgXBEL+Q5iSn8Ow7Uw9W7lx1hLnXJ7VIgurdv8a9grG2Bnd
	dYVqsprIszWSKrGdK1pNaDerrlSZcVQBO2Uv9MRIjcStYcNljXjRMt6rAGhXtRm89fSGmzkxMrELy
	kotB65BrvgBzT1kZse6H95e1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tAvbb-00AG28-2n;
	Tue, 12 Nov 2024 18:27:11 +0000
Message-ID: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
Date: Tue, 12 Nov 2024 19:27:11 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Steven French <Steven.French@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
From: Ralph Boehme <slow@samba.org>
Subject: chmod
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------5rm0im0iOS7eMunhIyLVEwLA"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------5rm0im0iOS7eMunhIyLVEwLA
Content-Type: multipart/mixed; boundary="------------S0CbbFRiLRgN9rsH6GRlyNdG";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steven French <Steven.French@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Message-ID: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
Subject: chmod

--------------S0CbbFRiLRgN9rsH6GRlyNdG
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZm9sa3MhDQoNCkluIG15IHRlc3RpbmcgYWdhaW5zdCB3aXRoIDYuMTEuNS0zMDAuZmM0
MS54ODZfNjQgYWdhaW5zdCBTYW1iYSBjaG1vZCBpcyANCm5vdCB3b3JraW5nIG9uIGEgcG9z
aXggbW91bnQuDQoNCkkgZG9uJ3Qgc2VlIGFuIGV4cGVjdGVkIHNldC1zZCBjYWxsIHdpdGgg
dGhlIFMtMS01LTg4LTMtbW9kZSBTSUQsIGl0IA0Kc2VlbXMgdGhlIGNsaWVudCBpcyBub3Qg
Y29uc2lkZXJpbmcgdG8gZG8gdGhpcy4NCg0KbW91bnQgb3B0aW9ucyAoYWxsIGRlZmF1bHQg
YmVzaWRlIGV4cGxpY2l0bHkgcmVxdWVzdGluZyBwb3NpeCk6DQoNCi8vbG9jYWxob3N0L3Bv
c2l4IG9uIC9tbnQvc21iM3VuaXggdHlwZSBjaWZzIA0KKHJ3LHJlbGF0aW1lLHZlcnM9My4x
LjEsY2FjaGU9c3RyaWN0LHVzZXJuYW1lPXNsb3csdWlkPTAsbm9mb3JjZXVpZCxnaWQ9MCxu
b2ZvcmNlZ2lkLGFkZHI9MTI3LjAuMC4xLGZpbGVfbW9kZT0wNzU1LGRpcl9tb2RlPTA3NTUs
c29mdCxwb3NpeCxwb3NpeHBhdGhzLHNlcnZlcmlubyxtYXBwb3NpeCxyZXBhcnNlPW5mcyxy
c2l6ZT00MTk0MzA0LHdzaXplPTQxOTQzMDQsYnNpemU9MTA0ODU3NixyZXRyYW5zPTEsZWNo
b19pbnRlcnZhbD02MCxhY3RpbWVvPTEsY2xvc2V0aW1lbz0xKQ0KDQpJcyB0aGlzIHN1cHBv
c2VkIHRvIHdvcms/DQoNClRoYW5rcyENCi1zbG93DQo=

--------------S0CbbFRiLRgN9rsH6GRlyNdG--

--------------5rm0im0iOS7eMunhIyLVEwLA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcznf8FAwAAAAAACgkQqh6bcSY5nkbZ
7g/+PdKo86OtMTYfLIPyO+lQLthSRNB/Fz0q/g/Q1Sr+w5Oq0VsRFwl8+yO/DPQodQceZ9LqCVyX
ZhQ7t/JP4MCq0Wb3Ci3KAD4NWNpOogb4M303AauBs6I2ilqJF2zuuak342RczOgAdfwhu3yzYFmJ
4LXN8LK8t9KtxEIO2kmn2k3d+SDX0zFfwf2BlSEdUU0XEBM2P2AeLLrTOqdK4BMpbWn7qUZ4FGjr
33M9oMChwdgEw4IdWOSqOCqW+9xit02Hkgd5kp+ChHZiQJ13Lfsq5Djh/dzZAL6UYvIJI28hpdTC
JS2pDH7dj+unmyruiaL6grvum/OG2lg3qPpb6VRM5UXneDs3cCJhhZqTAkkkGmtoO+WqPmwmsCw6
hFT1Px+kKtyGTcsMKRYMsaEuVXm/S9dUW9wJdfKFUIZQMJS7T/REs87B2x9RoWhQO6jSXQZHOR0g
VIxzgRdjsfhKdGN7NZ4L2Mx8KZ9vyp1d/kVi/Q+NVU0b5nAVSaApgksfAHUe6dMhs4D1qHE1LIht
B2goRm7wSXEkKdrIqI4AYwx10LkCaoBaQBb25PjaqFOS2KpUGY/lbkxpOu6veR3jFMmhJO6vxah3
ACwyXIFKHYY9K0JoNmtYaHJBbJv1PE+Yp+ImLaP5IHxi+tgdpn+k9M4iVHNeaUZVMQpRyg2QY5vs
iGc=
=chu/
-----END PGP SIGNATURE-----

--------------5rm0im0iOS7eMunhIyLVEwLA--
