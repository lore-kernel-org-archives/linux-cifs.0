Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA51FDF92
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524827; cv=none; b=L+GN22gdWkAUuraQPOStmZOJsrtin+8gae7VmOAePgIK2y4bQlkLtOWelub7jVmxbZcSVmGSl/I1HrZwdTHm4VnwBmsxoTu2mYK+F41rEFMpY+vED3Z+eQUXYsUvlogJbyn+Zz1tOHSFoEWK0Sk4FzR7ypulUHJzbjKDpxoCu3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524827; c=relaxed/simple;
	bh=mlEQdSjajSaBw2roeWuilv3457cMRJxEwLZolFOK3Tc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IajWC+UeNrFOBF2BBrRVB4sPMEU9cx6JzjxC8eluj8p2jPphuv6j5WFNxBHUFUoEXuke/USdieV8j3omabe6CiXB8n5Y+wba05jVrLsrO2mxwm2s4OcvFJH90qBmoevR8Yg2eCEhAr0Hf449yxobdOku69Rv+UeGOVpXo8BA0/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qrnyVLRD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qrnyVLRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=mlEQdSjajSaBw2roeWuilv3457cMRJxEwLZolFOK3Tc=; b=qrnyVLRDe6sBYdi4RoahDrpyj4
	VdHpctFcFPiLpmlVNUP4WAe2Gwh5lnmCBawgMx3Kg5fFETc+rG3l+KPIN8iXQT3gAkSfMptDMom9Y
	D0t05oRUATG/fAjsN4i8hwPZrIL5wteL/09DHVAPE36r2xOtjyrpNpgRm8cbUlgN0DoMvf4ElP8s4
	BGdUMQMpoIpqTbPvSW6rva2Wa/FX/B0C1mIdP5rjPzOhewZxBA4D9oMRE4UmYmJ74tX26tdbdG73W
	9EqSagcXsrMWcq3sbiZWvsOIZV/VFu3HG6/nHk83bwKffPIcF0FqvnYmjANxpjYXPmHuh1l7Pgdaq
	DPeIiOLjspC7xtHMVyN0Hfdo/GV3B53RUnjXeqGRuUvs+G4nPhmNogUeXMgCDzir5MTRoHSIIJvZU
	fuwbHJg8d8Bg9yp9m1Rn+82QIPAnZCn54tO+N0kuk8cXZeyNu6VeDVbqrNgba8RYL2NVy/lbJVUCW
	/QnnOq8FYJvMnwVh+DvBs7oC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tBIhi-00AQi9-1Y;
	Wed, 13 Nov 2024 19:07:02 +0000
Message-ID: <0447a472-9b60-478a-98e4-9f07a058380b@samba.org>
Date: Wed, 13 Nov 2024 20:07:01 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: chmod
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Samuel Cabrero <scabrero@suse.de>
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
 <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------T409Zwt9dsC8wAepNoGJ0581"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------T409Zwt9dsC8wAepNoGJ0581
Content-Type: multipart/mixed; boundary="------------eDKx1ljkY1YBZGQzzeD2bYOm";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Samuel Cabrero <scabrero@suse.de>
Message-ID: <0447a472-9b60-478a-98e4-9f07a058380b@samba.org>
Subject: Re: chmod
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
 <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
In-Reply-To: <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
Autocrypt-Gossip: addr=jra@samba.org; keydata=
 xsDiBDxEcLsRBADMQzpWoVuu4oiq23q5AfZDbakENMP/8ZU+AnzqzGr70lIEJb2jfcudViUT
 97+RmXptlnDmE4/ILOf6w0udMlQ9Jpm+iqxbr35D/6qvFgrgE+PnNAPlKSlI2fyGuLhpv1QP
 forHV13gB3B6S/ZWHpf/owKnJMwu8ozQpjnMnqOiVwCg8QnSX2AFCMd3HLQsqVaMdlO+jBEE
 AKrMu2Pavmyc/eoNfrjgeRoNRkwHCINWO5u93o92dngWK/hN1QOOCQfAzqZ1JwS5Q+E2gGug
 4OVaZI1vZGsAzb06TSnS4fmrOfwHqltSDsCHhwd+pyWkIvi96Swx00e1NEwNExEBo5NrGunf
 fONGlfRc+WhMLIk0u2e2V14R+ebDA/42T+cQZtUR6EdBReHVpmckQXXcE8cIqsu6UpZCsdEP
 N6YjxQKgTKWQWoxE2k4lYl9KsDK1BaF6rLNz/yt2RAVb1qZVaOqpITZWwzykzH60dMaX/G1S
 GWuN28by9ghI2LIsxcXHiDhG2CZxyfogBDDXoTPXlVMdk55IwAJny8Wj4s0eSmVyZW15IEFs
 bGlzb24gPGpyYUBzYW1iYS5vcmc+wlcEExECABcFAjxEcLsFCwcKAwQDFQMCAxYCAQIXgAAK
 CRCl3XhJ1sA2rDHZAKDwxfxpGuCOAuDHaN3ULDrIzKw9DQCdHb3Sq5WKfeqeaY2ZKXT3AmXl
 Fq7OwE0EPERwvhAEAIY1K5TICtxmFOeoRMW39jtF8DNSXl/se6HBe3Wy5Cz43lMZ6NvjDATa
 1w3JlkmjUyIDP29ApqmMu78Tv4UUxAh1PhyTttX1/aorTlIdVYFjey/yW4mSDXUBhPvMpq52
 TncLRmK9HC6mIxJqS0vi6W9IqGOqDRZph3GzVzJN7WvLAAMGA/sGAyg2rVsBzs77WH0jPO+A
 QZDj+Hf/RFHOwmcyG7/XgmV6LOcQP4HfQHH3DGYihu5cZj3BeWKPDJnjOjB2qmr+FTjYEsjw
 LDBNG7rjRye412rUbNwmEtcD2/dw4xNyu5h2u+1++KVBPf4SqG/a10gDqGJXDHA1Os5MmnQl
 3CTq9sJGBBgRAgAGBQI8RHC+AAoJEKXdeEnWwDasbeIAoL6+EsZKAYrZ2w22A6V67tRNGOIe
 AJ0cV9+pk/vqEgbv8ipKU4iniZclhg==

--------------eDKx1ljkY1YBZGQzzeD2bYOm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEvMTMvMjQgNDozOSBQTSwgUmFscGggQm9laG1lIHdyb3RlOg0KPiBBbSBJIG1pc3Np
bmcgYW55dGhpbmc/IFRob3VnaHRzPw0KDQpkaWQgc29tZSBtb3JlIHJlc2VhcmNoIG9uIHdo
YXQgdGhlIG9wdGlvbiBtb2RlZnJvbXNpZCBhY3R1YWxseSBkb2VzIGFuZCANCkkgZ3Vlc3Mg
dGhlIHByb2JsZW0gaXMgdGhhdCB0aGUgYmVoYXZpb3VyIGlzIGxpa2VseSBjb3JyZWN0IGZv
ciANCm1vZGVmcm9tc2lkLCBpdCBqdXN0IGRvZXNuJ3Qgd29yayBmb3Igc21iMyBwb3NpeCwg
c28gcG9wdWxhdGVfbmV3X2FjZXMoKSANCm5lZWRzIHRvIGJlIHR3ZWFrZWQgdG8gbm90IGlu
Y2x1ZGUgc2lkX2F1dGh1c2Vycy4NCg0KLXNsb3cNCg==

--------------eDKx1ljkY1YBZGQzzeD2bYOm--

--------------T409Zwt9dsC8wAepNoGJ0581
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmc0+NUFAwAAAAAACgkQqh6bcSY5nkY+
8RAAvRH5XsA/cTFVOfwubeYqQZis+JpzbEIcV+9mX7Sjjyaj6sApoJrQh/hGrpphwkYcowgcDcwb
LrTlgbRfrS3giiLiOUiCBkXDqk3sQIPfu9dBj4ej9wAfjOv1mnVd5aCauT/l/JFyR+8Rk7bHCdqc
4uUoS8RZ3/v3lUqGrrn2GCU1Q42jcf7Q8w2e9KfeA5z5v3meZ+PGR4M9XVAN6WlV2pc6f46D9TfR
scgo+xkqd+++pXOp9glNsJ6RO48JQ4HjCyjmkiUkcQxJFb8tRBulSBNPuLw3xtTnLMqLeuv1fA1M
xirAAP370R/Jw/obBezbSNk1/287z9EcdEqG7kddrb/Z5jVT7i8ZyHubCenJJrS1mISZaOPpSFXW
e/4UNpCUwbsat+kOQ6MS+mm4bskOg2HvwFUuHAhBsmd3nN3joxG4LB68r4pYn58uq4c2FfSGjADj
Y/doIOndFNpUI6biUEfnUzrqpSweERopALbC9jbkhf+B9lUk2ZU0/jMHp4y0qDSCjdDd78qIqx55
OIPxpkFm/qNz1xhWiFUYlu4G84m4GcU6UQdwp/Q4erYWHlAtEfvqo3I2aSn/Xtfq1CBqEFJ+cbsD
WNVqXCw8od+/gIkJqggUq0K2FeL7sLiKMBOgfFosQAus4chdv6MHy0hF+a9bSOwDDmPMOyVR3L6F
Ak8=
=PmQK
-----END PGP SIGNATURE-----

--------------T409Zwt9dsC8wAepNoGJ0581--
