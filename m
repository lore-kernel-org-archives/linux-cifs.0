Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3C311969
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893807; cv=none; b=XF/PRq85MncwO/jKTFcHQEZKUDBml2z+Nm/we3flZYJ8ob1R9xFE/Ji2B2NFcPP35wz3e/Dd96tM0ezqSTjLyXqpmifWJB6Wz1HpdbWUTm8BRZQK6PBfVmTjm8WfTT25vT8wtCkxnKO32retJwmqQqy0WeN0WcK7zkQ9obUJfbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893807; c=relaxed/simple;
	bh=ltgiJ3I8hVMxuwXqDL3tfh5XlJBCdz7Xp4yEq+zXBuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uspq/mYJZ+Bbli0rBK/Uj+3TGj8GLiTN86uBmm9XKpYGxtdwVcoYJ5C6/aaPyLJlz66NH93kjXUH4OXLNMJxCALGmxipL49oIk/ZIEh9xmdaWSBxeQELgSlahVOB2DUxZq9+RROoIDOusgYpaYgejLj01rvIRXkhCdslV1GVnAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=n+rn9jed; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="n+rn9jed"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=ltgiJ3I8hVMxuwXqDL3tfh5XlJBCdz7Xp4yEq+zXBuo=; b=n+rn9jed+1BbHvS6s/46apggda
	h388QtbGIUExIuN8EujHF04mB7KRVJREKemS2MDg/Yvj/kdQ2opguYhXA429ClzNNmpQ+b2AcrCih
	gvg6nUytpSar7JYxHTK8PmVO1SZWe3d3QzfZ9Vo2kUj4fdwfVG7anJV43qqRwvcZCtqvRYFIOSFyD
	kT5s7n0ho1C/atVbAUypiLF4EQXqbCj4ddFANjm4/4u0uppAzw9FibIEhcDdmfXxGVuaPBWJkYvkO
	oRCGsIE4JvqV6tr4yeF/jjkcitCOSp640oNBWm3Tp/LXJaTetX8H4Skw2pkVHvRvEVP5SCiEOa4ut
	g9fcV9/VnavIzefY9JuLfPbdzeoMGEpAeScWSpcYYUreDekegvYBxuQnfwpiigW4/4qAkiaRZoaHV
	fmqhPBlV9IxWZomsW2S5zLRNvebTBl808WLIguG4yPSLkraom2J/Vd5ZqWltNBb1dyCunwn/m/VS5
	lK11KbeXUoa7OM75YfFRejo9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wnEPX-0000000096I-0hAA;
	Fri, 24 Jul 2026 11:49:51 +0000
Message-ID: <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
Date: Fri, 24 Jul 2026 13:49:51 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Ze Tan <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, jra@samba.org, tom@talpey.comm,
 chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
References: <cover.1784888897.git.tanze@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <cover.1784888897.git.tanze@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8fUOjiAygWTcPpTz35A3LVjG"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8fUOjiAygWTcPpTz35A3LVjG
Content-Type: multipart/mixed; boundary="------------y2uKadEz8eA8kAto7Djbljm4";
 protected-headers="v1"; hp="clear"
Message-ID: <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
Date: Fri, 24 Jul 2026 13:49:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Ze Tan <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, jra@samba.org, tom@talpey.comm,
 chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
References: <cover.1784888897.git.tanze@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <cover.1784888897.git.tanze@kylinos.cn>

--------------y2uKadEz8eA8kAto7Djbljm4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8yNC8yNiAxMjozOSBQTSwgWmUgVGFuIHdyb3RlOg0KPiBOYXRpdmUgeGF0dHJzIGFy
ZSByZXR1cm5lZCB3aXRob3V0IGEgcHJlZml4IHdoZW4gRUFzIGFyZSBsaXN0ZWQuIFRoZWly
DQo+IGNvcnJlc3BvbmRpbmcgdXNlci4qIGJhY2tpbmcgeGF0dHJzIGFyZSBoaWRkZW4gaW4g
bmF0aXZlIG1vZGUuDQpzb3JyeSwgYnV0IEkgZG9uJ3QgcmVhbGx5IHVuZGVyc3RhbmQgaG93
IHRoaXMgaXMgc3VwcG9zZWQgdG8gd29yay4uLiA6KQ0KDQpNYXliZSB5b3UgY2FuIHByb3Zp
ZGUgYSBzaW1wbGUgdGFibGUgdGhhdCBzaG93cyB0aGUgcmVwcmVzZW50YXRpb24gb24gDQpz
ZXJ2ZXIsIGNsaWVudCBhbmQgcHJvdG9jb2wgZm9yIHRoZSByZWxldmFudCBuYW1lc3BhY2Vz
Pw0KDQogRnJvbSB5b3VyIGNvbW1pdCBtZXNzYWdlIGFsb25lLCBJIGNvdWxkbid0IHRlbGwg
aG93IHRoZSB1c2VyIG5hbWVzcGFjZSANCmlzIGludGVuZGVkIHRvIGJlIGhhbmRsZWQuDQoN
ClRoYW5rcyENCg0KDQo=

--------------y2uKadEz8eA8kAto7Djbljm4--

--------------8fUOjiAygWTcPpTz35A3LVjG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpjUV8FAwAAAAAACgkQqh6bcSY5nkbn
mRAAotSQ0SNplozFsDoJERHMQ9NFX/Flvv1ehj3CALntExWo+zui2PfHVnrksG5kxg1H35tYtQcF
DHTwx5FgenQfJmvEDkMd3cH6BmXGNMRpSqjxpjzd79+2Ft/lFMQPPFQyJ11iEKJ8YIk0fCA0S8ax
2NXDQ5U82FceHsMrbXBOijmxYJYoqUFdRQWPGkOHzJ6ut8CGw82pOqplzf4qETHaJdVA3FzOwfg9
7+W79AN8qjsWXA8bTnOxibIuKRIV7vbmvejopeDvsM5pzsvRLgoBw/oylB1BZqVcO2PbAgLBF8wz
H1KBAFuFrH0jmtvCs38dR5ZnGvQ0JWtMiKN3X6mQW90PISM2C9SE6dv7awCG5SN/HNbeVrRWxuwf
X6sSboTMLzpJKsj1/sMDY9hyXN2+HhiXfMgG3GfqzCkA9lne6UFNtAN8O/a+t8esWmVH2hLMQqw3
KVXyS8CxVc9GMHBGsA4KR7GciwJb5l05H+q5h1EZAwa1SUujl2B/UROtOhtMA0thEhgpJqTFVVUY
PFXfRx+b2uL3fiV0dM3F/IOQtbrH3p1Ds41pdPojlGdbEKeT4MsSbReAzCBshnrRnbncXA1l5glb
j3fFh9GUJ4EBJ9h582mdmE0GACM+zVMqMms/DL5TGXZToMV/vgw5JF0aMqkmvifcymMuYKpv4l9R
8ZI=
=o4gq
-----END PGP SIGNATURE-----

--------------8fUOjiAygWTcPpTz35A3LVjG--
