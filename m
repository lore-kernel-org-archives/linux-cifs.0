Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C53F1DF99B
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 20:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728418581; cv=none; b=p2L4fcHLIvV9hMZc734SwvUU16wb4xhKPyC2l+/fFIPc2JlFyPC8uv9ZVD7zt0BpRhdbfBPZ1LSZ5UnZ/SymrvVtq7QKWtD+gO4MooM7yiodgJ9Nm1jUkHvF/9ZhaM5TD6m8HEgEBHbf0eY68AqjXKJWbfaI2ovIH11LV98flfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728418581; c=relaxed/simple;
	bh=ElFGt66Yn/T49rF6BEClnBcY5BClntfjirCQh1DWdfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IzfdXUqArvvUVyoBJdXZPqMhuOMP0qXyxHk2T1+l4heF3FQCUz+bsd/cJgSqqfkyBwjLvoXJCr2UfH5WP6Koik5o7gbBZKHUpELEduDikBFFWNNzuA2dUJR5FEdS8khTbLhm0UniIHIScTyE2LlDQHWehRT8r1BSsWSOXVLqSh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ns3w2y8D; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ns3w2y8D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ElFGt66Yn/T49rF6BEClnBcY5BClntfjirCQh1DWdfE=; b=Ns3w2y8DwrR+NOAJWUhtSgxHsr
	SRgz1sBA8f7pOM8zOEa9dBYLcu2H57ed2D+cCwY8jpMVG+wEEB61plybDnmzmZQhUV0xzYU8LU+Wn
	ZNGANIMCUxfyWKi/qmlVjHVl856hmZigJpPUWSzf5znhxQXJlSFhsUxcaRdgejJDuq4f1+CoG7CUd
	HS5WnN3A6wCFMhZDfwa3fNBt9HcOvGIFvw4G1n9v46akKC7XV22LiLMR7T/dYPg/3C8n0xeR1idiJ
	3GhP4ooaClUm9YnDpTBIa+H7xFUoHNKQifQfok0IMUIxb/uaZ+ML8aWEEuZT34wNykEGv8kiuKjma
	IwBEecXAfVuarHSPEW1/JfQEPmecBgm1tCA3w4yxXB5wAUE9hp3Fpc50jPqQmhgRM5bHmCIZqGT9C
	6LAi/1LCtF0zlzsCfFqnAPvCAmHjM4kMOsPRSK9TNM1EuPgxb+WqNchbzVg/7XZNxvfbo2ZS0VVzI
	uMko0ouK1rTwnr40JlVNK+oH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1syGcy-003xO3-36;
	Tue, 08 Oct 2024 20:16:17 +0000
Message-ID: <71a334fd-f5c8-4213-a703-33617d7a5b1b@samba.org>
Date: Tue, 8 Oct 2024 22:16:16 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
 <20241008181827.cgytk5sssatv6gvl@pali>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20241008181827.cgytk5sssatv6gvl@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Az82hiCtv0GkTWHWfIuKnE44"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Az82hiCtv0GkTWHWfIuKnE44
Content-Type: multipart/mixed; boundary="------------qqFr4rqAfa2Y0Dqv1pXSqKv0";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Message-ID: <71a334fd-f5c8-4213-a703-33617d7a5b1b@samba.org>
Subject: Re: SMB2 DELETE vs UNLINK
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
 <20241008181827.cgytk5sssatv6gvl@pali>
In-Reply-To: <20241008181827.cgytk5sssatv6gvl@pali>

--------------qqFr4rqAfa2Y0Dqv1pXSqKv0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOC8yNCA4OjE4IFBNLCBQYWxpIFJvaMOhciB3cm90ZToNCj4gU28gdGhlIGJlaGF2
aW9yIHdoZW4gdGhlIFBPU0lYIGV4dGVuc2lvbiBpcyBhY3RpdmUgd291bGQgYmUgc2FtZSBh
cyBpZg0KPiBldmVyeSBERUxFVEVfT05fQ0xPU0UgYW5kIGV2ZXJ5IERFTEVURV9QRU5ESU5H
PXRydWUgcmVxdWVzdHMgd291bGQgc2V0DQo+IHRob3NlIG5ldyBOVCBmbGFncyBGSUxFX0RJ
U1BPU0lUSU9OX1BPU0lYX1NFTUFOVElDUyBhbmQNCj4gRklMRV9ESVNQT1NJVElPTl9JR05P
UkVfUkVBRE9OTFlfQVRUUklCVVRFPw0KDQp5dXAuDQoNCi1zbG93DQo=

--------------qqFr4rqAfa2Y0Dqv1pXSqKv0--

--------------Az82hiCtv0GkTWHWfIuKnE44
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcFkxAFAwAAAAAACgkQqh6bcSY5nkaq
Zw/8DObQqyr8I6MBP36xuqBMtQKL7GkjfRz8oh+LiiMVdYD3NbcXcGdxCsN3wTTD8rolNlYK8pYQ
3U9t+xhh5GLGbQ5tpWqBiBcl2Uq/siYpkSKkxUnY4fffwAHKd2nuZwInNXPNk4H0kHnLMhCdUbFf
6WVxif2sU7kqZ+KpV+JRbJrBPOpfAJpHfyZrTR5tS0vEFDUk1tIjGqk+1j3mOT5hiF1V3Yxi/i19
SvzvcNN92R9D/tlzwi6onOTcsOZAteDJXRG92txoyyx4snEpDVLBiepnUQxbk05+27OaN2QOti9Y
6QuSLC0xvqfQCHrGuon149WREgfIaILRl3mCSkKYAjJtuXH4cA21OC0L1B6MRvmY4sY1iN2kh388
tvlsAYAv2ZerjFHW2PezARUaNQSU6xrMgxAcv7s/4U7FMtc+xCO+v5C8FS7Cadm1zHkTTkiBYm7i
hoSKdfJbDf/Zrm3ihwSiPJD9B/9NO8p8hcLdj1B27xE0Y+X0Gl1v2qGueQYLX9VgpTKWDC4DvtHn
DtKfClk4LlYqBNXIkWafQXbr1c0xscKO8eYn40EDbZ3k8E/fnCiryxQoLE/BUF3Bgzq8NP7O3Drw
Jl/JO4fnZNtZtaUBX4sNDnpujJfo/NQF5IwKBD0qF2qPVs7qnSZWfyzMVsQN+wwgpOfluJ3JmD+M
Xtc=
=kamJ
-----END PGP SIGNATURE-----

--------------Az82hiCtv0GkTWHWfIuKnE44--
