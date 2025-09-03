Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B162BDC0A
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756915839; cv=none; b=eV9zlrXefmbbWzpTOidOSDcnYxUeKoIEOaXT+4tAR7EvNylP2fxL91AuVkN0V4e9/sQuDNYUYjkISZ7BdPuBd4WbJHCMkbT8oo++HQ41hCo4xBx/WYWV+93abGPAHHFZgc7iBCblMrdei/6wqJ/9aoZYl6d94kmOcuaDOAwygzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756915839; c=relaxed/simple;
	bh=/NQqB9otEp/VAfoUBKbhR5lnZZtsmovkcZFI/97P/h0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxRGy0m48KtXm8QM7MDIiPXpD/7zvne56ffy1f9rlWl/Mw42SJzI7nnaJbvWw90Z3vByVHRnfeeJEYo6tNL4/UY3zu1oKfNTOhR4W2F1Rf6Qay7Oh77Vnhr9hkf1msZZZbv8QPmAWOcXCbO02bK+eR/tv3ufx7K+A2zhEsTjqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=SR8C+TJx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SR8C+TJx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=/NQqB9otEp/VAfoUBKbhR5lnZZtsmovkcZFI/97P/h0=; b=SR8C+TJxdXkY9OCtwSCLaWVZeP
	xOyaXrCaq//FwnKrgD+SKsJIjK4eC3oBbbXsYlHxvtO7RjEVgR8r1dohZVJqnVaJDGPEA2SXcYiF7
	YI9cagXJEpZqh4fLomvITr/2ZgjzPE/fEdP9+kTEJEiOyJNMUUQQ62HsFEQzYboAnDlagawW5YROF
	+upPH+4pl3pQzksv6Orjur3B1b+RIffkK8hjwQFNRJ1CJkdHBjkvEcM/wmgjQWzSWMMU2i6wvPk8Z
	lmxKFuUNp1q+sr/YyScAQOxXAm826oj1saE2sVlw7zGfFiMQlfmKvYf9EF6Yrd1KswfN7aYbWpPDx
	a29c0Jui3I/KzRPw/frcyVQCAmcJJOl5hYtrH3Il5CaC7nWwBDv2BxAdVeMeW61vOvBNtuUimCzz0
	VdDin5X34suHAHHQXpcJuSfoXs07jH641r/4Q2tfKCCb8X4bmvU2iahWv2a6Y/m5riMddBG5OFWoz
	UZPAohHmswU8gYwRr2GV/Zib;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1utq4B-002H8U-0i;
	Wed, 03 Sep 2025 16:10:35 +0000
Message-ID: <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
Date: Wed, 3 Sep 2025 18:10:34 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, linux-cifs@vger.kernel.org
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------oIvHjqievCUyIN7Dp1nFbHl0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------oIvHjqievCUyIN7Dp1nFbHl0
Content-Type: multipart/mixed; boundary="------------zb7KUJ0gFl3bJz1dSQ7wGF8U";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, linux-cifs@vger.kernel.org
Message-ID: <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
In-Reply-To: <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>

--------------zb7KUJ0gFl3bJz1dSQ7wGF8U
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgUGF1bG8sDQoNCk9uIDkvMi8yNSA5OjA5IFBNLCBQYXVsbyBBbGNhbnRhcmEgd3JvdGU6
DQo+IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+IHdyaXRlczoNCj4gDQo+PiBXaHkg
bm90IHNpbXBseSBmYWlsIHRoZSByZW5hbWUgaW5zdGVhZCBvZiB0cnlpbmcgdG8gaW1wbGVt
ZW50IHNvbWUNCj4+IGNsZXZlciBidXQgY29tcGxleCBhbmQgZXJyb3IgcHJvbmUgZmFsbGJh
Y2s/DQo+IA0KPiBXZSdyZSBkb2luZyB0aGlzIGZvciBTTUIxIGZvciBhIHZlcnkgbG9uZyB0
aW1lIGFuZCBoYXZlbid0IGhlYXJkIG9mIGFueQ0KPiBpc3N1ZXMgc28gZmFyLiAgSSd2ZSBn
b3QgYSAic2FmZXIiIHZlcnNpb24gWzFdIHRoYXQgZG9lcyBldmVyeXRoaW5nIGENCj4gc2lu
Z2xlIGNvbXBvdW5kIHJlcXVlc3QgYnV0IHRoZW4gaW1wbGVtZW50ZWQgdGhpcyBub24tY29t
cG91bmQgdmVyc2lvbg0KPiBkdWUgdG8gYW4gZXhpc3RpbmcgQXp1cmUgYnVnIHRoYXQgc2Vl
bXMgdG8gbGltaXQgdGhlIGNvbXBvdW5kIGluIDQNCj4gY29tbWFuZHMsIEFGQUlDVC4gIE1v
c3QgYXBwbGljYXRpb25zIGRlcGVuZCBvbiBzdWNoIGJlaGF2aW9yIHdvcmtpbmcsDQo+IHdo
aWNoIGlzIHJlbmFtaW5nIG9wZW4gZmlsZXMuDQoNCm1heWJlIEknbSBiYXJraW5nIG9mIHRo
ZSB3cm9uZyB0cmVlLCBidXQgeW91ICpjYW4qIHJlbmFtZSBvcGVuIGZpbGVzOg0KDQokIGJp
bi9zbWJjbGllbnQgLVUgJ1VTRVIlUEFTUycgLy9JUC9DXCQNCnNtYjogXD4gY2QgVXNlcnNc
YWRtaW5pc3RyYXRvci5XSU5DTFVTVEVSXERlc2t0b3BcDQpzbWI6IFxVc2Vyc1xhZG1pbmlz
dHJhdG9yLldJTkNMVVNURVJcRGVza3RvcFw+IG9wZW4gDQp0LXBoLW9wbG9jay1iLWRvd25n
cmFkZWQtcy5jYWINCm9wZW4gZmlsZSANClxVc2Vyc1xhZG1pbmlzdHJhdG9yLldJTkNMVVNU
RVJcRGVza3RvcFx0LXBoLW9wbG9jay1iLWRvd25ncmFkZWQtcy5jYWI6IA0KZm9yIHJlYWQv
d3JpdGUgZm51bSAxDQpzbWI6IFxVc2Vyc1xhZG1pbmlzdHJhdG9yLldJTkNMVVNURVJcRGVz
a3RvcFw+IHJlbmFtZSANCnQtcGgtb3Bsb2NrLWItZG93bmdyYWRlZC1zLmNhYiByZW5hbWVk
DQpzbWI6IFxVc2Vyc1xhZG1pbmlzdHJhdG9yLldJTkNMVVNURVJcRGVza3RvcFw+DQoNCi4u
LmdpdmVuIHRoZSBvcGVuIGlzIHdpdGggU0hBUkVfREVMRVRFIChoYWQgdG8gdHdlYWsgc21i
Y2xpZW50IHRvIA0KYWN0dWFsbHkgYWxsb3cgdGhhdCkuDQoNCklmIHRoZSByZW5hbWUgZGVz
dGluYXRpb24gaXMgb3BlbiBhbmQgdGhlIHNlcnZlciByaWdodGx5IGZhaWxzIHRoZSANCnJl
bmFtZSBmb3IgdGhhdCByZWFzb24sIHRoZW4gbWFza2luZyB0aGF0IGVycm9yIGlzIGEgbWlz
dGFrZSBpbWhvLg0KDQpXaGVuIGRvaW5nDQoNCiQgbXYgYSBiDQoNCnRoZSB1c2VyIGFza2Vk
IHRvIHJlbmFtZSBhLCBoZSBkaWQgTk9UIGFzayB0byByZW5hbWUgYiB3aGljaCBiZWNvbWVz
IA0KaW1wb3J0YW50LCBiZWNhdXNlIGlmIHlvdSBkbw0KDQpyZW5hbWUoImIiLCAiLnJlbmFt
ZWhhY2tYWFhYIikNCg0KdW5kZXIgdGhlIGhvb2QgYW5kIHRoZW4gcmVhdHRlbXB0IHRoZSBy
ZW5hbWUNCg0KcmVuYW1lKCJhIiwgImIiKQ0KDQphbmQgdGhlbiB0aGUgdXNlciBzdWJzZXF1
ZW50bHkgZG9lcw0KDQokIG12IGIgLi4NCiQgY2QgLi4NCiQgcm1kaXIgRElSDQoNCndoZXJl
IERJUiBpcyB0aGUgZGlyZWN0b3J5IGFsbCBvZiB0aGUgYWJvdmUgd2FzIHBlcmZvcm1lZCBp
bnNpZGUsIHRoZSANCnJtZGlyIHdpbGwgZmFpbCB3aXRoIEVOT1RFTVBUWSBhbmQgKm5vdyog
dGhlIHVzZXIgaXMgY29uZnVzZWQuDQo=

--------------zb7KUJ0gFl3bJz1dSQ7wGF8U--

--------------oIvHjqievCUyIN7Dp1nFbHl0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmi4aHoFAwAAAAAACgkQqh6bcSY5nkaz
IBAAiowDrOJo13a8WgMV4NtcWm/WptWMC9iw1oZQWU6BsY2oX+3LZOkAZjxSlT0JkSY4cgqQYrSL
Vt9kD61GC2DB22c6QAx5/sEs/C6sMUlhNgDokzjBhGEax3z66GFoo1yDB1xHdepwTTnvOqykCb15
of1N2pIU0wa9MddDlbuhll6gI2ou1jgg6a7AOdXzapS30MC8iYYWab4NZBNg30uBydvJ1yYjGqVW
2JoDrEdP8qOKf+pEmYO8FAc0wHgN+d9G5uIWQOk4Y4VWyzwc0HhwPTrsXAcoD77OHNRbsNeycKAM
vQXayC1A76horCsCgEoQ7O2e6LH6g/BdXgJSW2deCDt6kQOjLqRHqNKh02Ua6yzl+bSFcV+3fiNF
uA1s6j0Unv4lyUEx4hFj0lfzdPSy3W/eQkApJuo8dilF9dKQRc9XAjDeB+sdk/vIrTNBZAdRVj7K
hdad4jx2lJ3zKzT/UFYvMF0OX4PMlbSvsy3ImhMkpPKTCkpfUMmOVTcfz11fQaf9usLFA8AU+qUW
SqzXbVEJ0ZY0r4HF/xGQ9RTPWEvrgR1lPOYYUlmP7tiSrfhWK1Y81lBzECTe4j+FH5RGsZi9a6yB
bPv/+Bho/sVwnQmcGgJLS6UuEgt71AATH6+ckQdQpSRC4UX/8rAJIFEc2PNlVlApg0iUtjDWpwFx
JtI=
=sqnI
-----END PGP SIGNATURE-----

--------------oIvHjqievCUyIN7Dp1nFbHl0--
