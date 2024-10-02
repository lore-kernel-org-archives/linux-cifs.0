Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326E2BAF9
	for <linux-cifs@vger.kernel.org>; Wed,  2 Oct 2024 07:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727855058; cv=none; b=msF168Yk5kDWiEXEA6SGr44qh2L5bol38ZDlZtuFe/+sfpOdSJCcolob//zuzdYv2ZwM0Kb46/agGg3ENTTlGByCjW3cPH4u8F5UJbGfXnGq29DRrPFVVMyHFazhDoZksTbgfiMd9n8B2kQSqfV7eS9FTg4QUwnhuzqyp9FCQJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727855058; c=relaxed/simple;
	bh=oY9GpVLNcEmYqW4eepmmOmBHJ8KexUVA3p6EDNls5Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KP5U82xVI7HJeHantEoBDKRFg9olaV7OyBGTPlrpK7uzbGbS10/MQ5X2Y2X/2w9qW79v8FhWzPw3f+fKo7yssEryUcKLiXFisb1VKanrXck3Axfrj6aqTXoNmvLk8rotiYX8dGtqmT94JyEbYBsZjNJREOjSOhuXbcJ37F1gzvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=FfNwdZir; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FfNwdZir"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=oY9GpVLNcEmYqW4eepmmOmBHJ8KexUVA3p6EDNls5Ks=; b=FfNwdZirMyx47nEWEAZu5ZGk7M
	qM7QCKUfRxFT0eY4gQFR6zItfWAjAGgEq+QPngtE4fccc3uSRuwOjsngkk+kd5o9a8qR9QmR+DeSW
	k/Fz0nudPCAtjFuFxDsqc85T4Zsmyn8UhOih38sq8W+ykmdjgXYtfHS27fmTYLwZJRy4YjlJhZjrh
	ytvGahBlMHuBt0fakvOXNeSnWHgFnJCl/lzzoOeegIkWFGPytKKtUjUc1siGzJ0hxPlSeFs5rrjV7
	4uahf7OiJeFXlZahM0edv7DT4RSD8f6Q1MPc+ltlTtJirKhNmQeG5gMc8v3wGIcSyuIlpB93GFH14
	64KuZGeFmCAgm1xXPlUpEGWx2uRS045X9vtXQwfLIwQdvXmcewIV0zT82IVdCuxywruxBrFxvV+ps
	rJAKS02F4xIa83QwL7bowfvNhCs5zcgMh8HMrDPtGbNf8kbg0V3VKJ+gC+N6O9mE1xyUHgKpS+tS0
	go0WsUy1klu3sunydA87/TSI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1svu1t-003296-0r;
	Wed, 02 Oct 2024 07:44:13 +0000
Message-ID: <56ac8ed5-781d-4ca9-95e6-75a6e52c34e3@samba.org>
Date: Wed, 2 Oct 2024 09:44:12 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB POSIX Extensions specification
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
References: <20241002073519.2fee66fwopzy3dpp@pali>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20241002073519.2fee66fwopzy3dpp@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------sIcR74uqMEPq5ZQHkap7q4yj"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------sIcR74uqMEPq5ZQHkap7q4yj
Content-Type: multipart/mixed; boundary="------------Ih3GYj69kv3uPzl0DWNKIsSz";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Message-ID: <56ac8ed5-781d-4ca9-95e6-75a6e52c34e3@samba.org>
Subject: Re: SMB POSIX Extensions specification
References: <20241002073519.2fee66fwopzy3dpp@pali>
In-Reply-To: <20241002073519.2fee66fwopzy3dpp@pali>

--------------Ih3GYj69kv3uPzl0DWNKIsSz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMi8yNCA5OjM1IEFNLCBQYWxpIFJvaMOhciB3cm90ZToNCj4gSGVsbG8sIEkgd291
bGQgbGlrZSB0byBhc2ssIGlzIHRoZXJlIGFueSBub3JtYXRpdmUgc3BlY2lmaWNhdGlvbiBv
Zg0KPiBTTUIgUE9TSVggRXh0ZW5zaW9ucz8gQmVjYXVzZSBJIHdhcyBub3QgYWJsZSB0byBm
aW5kIGFueXRoaW5nIGluDQo+IE1TLVNNQjIgYW5kIG5laXRoZXIgaW4gb3RoZXIgcmVsYXRl
ZCBkb2N1bWVudHMuDQoNCnRoaXMgaXMgc3RpbGwgdmVyeSBtdWNoIFdJUC4NCg0KaHR0cHM6
Ly9naXRsYWIuY29tL3NhbWJhLXRlYW0vc21iMy1wb3NpeC1zcGVjDQpodHRwczovL2dpdGxh
Yi5jb20vc2FtYmEtdGVhbS9zbWIzLXBvc2l4LXNwZWMvLS9yZWxlYXNlcw0KDQpJJ20gaG9z
dGluZyBXSVAgaHRtbCB2ZXJzaW9ucyBoZXJlOg0KDQpodHRwczovL3d3dy5zYW1iYS5vcmcv
fnNsb3cvU01CM19QT1NJWC8NCg0KLXNsb3cNCg==

--------------Ih3GYj69kv3uPzl0DWNKIsSz--

--------------sIcR74uqMEPq5ZQHkap7q4yj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmb8+cwFAwAAAAAACgkQqh6bcSY5nkYE
7A/+JFDnTh/0tM7SDhJJZmaQygOstfMI7Hl1SOknWqTnndMUwvaxa05WHnGtIqAc0SgHPLhpYP8U
nVwpX4FwYXfMZNnar2kBXD7VcM+WytLZuN9onNfelBefuJMFe5/6/iCsSfa0U1NE/b3iS3+ou1tR
n4Ic2YdotSrcQo3HvnYa+c4t54qIix3KTXuCNr0/Clmznmt8UAG9QGvBYTxRyvoh6JEMerRUsV/c
bJRdV1g4QplnKsz+fJuRZ3LOtAxgoJ0SsbGOXMKuU9729BD4D/uEXNOF0Nq737GCFtvxRuoTl466
fTr0B6f7mINEy2MjMaELkLet2hsgQdagi75ki6tW+pZ8mCwKdoWH3Xr9inYHiH8K3j45MDf3UDgQ
Rt0JxPn0d/bUcwe7ioorkvdtDTrhH0LHFsX+z5Ywgmu7dH/ZXd4OfYtS+PzssDzoVAZwJ9E2sYLB
Nzz3b+xPR/2ApeVE4B4TCHkSaYlsOZQ9bgTIBf6s2ytCOz6JxIcgvnI9pU1S2JiFQlJjyJtsb8sS
ODBOFOIr5oDNqQTQ3egxKRnbuZU+8tfEk47h+vNVVlQ3ZJo9epFVeN5ikdlzREHoftVuLp9l2w0U
zMRnAKbx+lnizh3qzmzorquVodIJM43xQmjtUVZevbKJJ3aus00lOzaifPfWgwsBShMfbgyEmk5K
I3A=
=jPmn
-----END PGP SIGNATURE-----

--------------sIcR74uqMEPq5ZQHkap7q4yj--
