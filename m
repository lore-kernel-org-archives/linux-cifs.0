Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E303D47CF
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780939654; cv=none; b=j7vdJkLqdEpmtSpqmOcvQPHMUNFLvexrJl8C+7pwFTOaPxvjYpihKMPBLEfbivwca+0HzBeisbR8gjyWjy9kZCVkNuAhNa+FVVbLiNyrGotYCwl4fvOzBUk2EbM/KjRgZmWwG7sMmJ39l9G5ULRLyAeHXbuqxwFw9kel1Q/Fqeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780939654; c=relaxed/simple;
	bh=yQ5Uu3oArJU+oEMN/+ZumPK8NC0EN6egZnMgiPueN4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qoxj7tfuTzDke3w/Efir69sENkEH0MIbg0WmSyMXUwuEEHEeYI5WYty3R5akw+N/Xb+BqFU/Uejy3gJ6cYBogGLbjJ9VT4WKPvI14cwdoKw2GOjgN8eJM9TJKCM6z6/FheV/xR32uos5mBF8rcwkKfDyO6EkSP0hJ/RIq2/a+/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fQ5NXdqF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fQ5NXdqF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=yQ5Uu3oArJU+oEMN/+ZumPK8NC0EN6egZnMgiPueN4c=; b=fQ5NXdqFrvLJke0OSXNu+CdONF
	Sx7lksHJLn4Vfhpm4bgJGR8HjjkHRK4MYEEd46UHryf4Fi/8LBCONH6KY8PngqXljExUdGfNEoG13
	Vs8ybJisHVQx3V6us6JIOqL4UkDxadWObVRgf/L75nMT5RM+Ubcy9LBV8xADmveXglUENxha5yeXS
	pFzRgMN/mnuerUiw8yA07VVBDNdS27Mol7avNxD0hlrGl9k4UPzSD54cSx2fTX0nBo53cUqMnMPhz
	YtyOHBIl7fnS0Vo86XZb4KITLWwlW7n8M85sarigOWSJQ5bG6nh68wTiFmFGWokCQViUrndzg5EvM
	4qW90TXmXVRZdjCcpSnFGdnCbqYpdZoMR5/Y2NRzXtIGRxW4yVvB4g8F+jIg/gCG7pqDWZIMLhJHX
	T5/Rh4wSKNJYIIwS7kJAX2URzlAeBQdcEzlQocuZMH4MYRGPH2bSvZ/zV/J2LHu652T2Vuvn9z8gc
	+/9VYE5yAjwchAYs3fF/8Q1K;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wWdl4-0000000EuZ9-2Axe;
	Mon, 08 Jun 2026 17:27:30 +0000
Message-ID: <97d0591a-1f9b-4c5a-a781-b24fdcff8a4c@samba.org>
Date: Mon, 8 Jun 2026 19:27:29 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jrasamba@gmail.com>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
 <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <40942fc2-330b-420b-b188-dafb065d1edb@samba.org>
 <CAH2r5mvK79MPsNL3PjB_pYeZfOhqmgOd5cRo=Vk+vsa8__jjEg@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mvK79MPsNL3PjB_pYeZfOhqmgOd5cRo=Vk+vsa8__jjEg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VUC39G8TdY1pf8M6SOEbl3Qo"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VUC39G8TdY1pf8M6SOEbl3Qo
Content-Type: multipart/mixed; boundary="------------g15c2ZuB6FKW4MyabxhY0m2d";
 protected-headers="v1"
Message-ID: <97d0591a-1f9b-4c5a-a781-b24fdcff8a4c@samba.org>
Date: Mon, 8 Jun 2026 19:27:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jrasamba@gmail.com>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
 <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <40942fc2-330b-420b-b188-dafb065d1edb@samba.org>
 <CAH2r5mvK79MPsNL3PjB_pYeZfOhqmgOd5cRo=Vk+vsa8__jjEg@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mvK79MPsNL3PjB_pYeZfOhqmgOd5cRo=Vk+vsa8__jjEg@mail.gmail.com>

--------------g15c2ZuB6FKW4MyabxhY0m2d
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi84LzI2IDE6NDcgQU0sIFN0ZXZlIEZyZW5jaCB3cm90ZToNCj4gT24gU3VuLCBKdW4g
NywgMjAyNiBhdCAxMjozNeKAr1BNIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+IHdy
b3RlOg0KPj4gSXQncyBub3QgYSBidWcsIG1vZGVmcm9tc2lkIGlzIG5vdCByZWxldmFudCBp
biB0aGUgUE9TSVggY29udGV4dC4NCj4gDQo+IFRoZSBleGFtcGxlIEkgdHJpZWQgd2FzIHdp
dGhvdXQgUE9TSVggKG1vdW50aW5nIHdpdGggDQo+IG1vZGVmcm9tc2lkLGlkc2Zyb21zaWQg
bm90IHdpdGggcG9zaXgpIERlZmluaXRlbHkgaXMgYSBidWcNCg0KTmFoLiBJbiBTTUIzIFBP
U0lYIHlvdSB3aWxsIG9ubHkgZ2V0IFBPU0lYIGJlaGF2aW91ciAobGlrZSBiZWluZyBhYmxl
IHRvIA0KZG8gYSBjaG1vZCgpKSBvbiBoYW5kbGVzIG9wZW5lZCBhcyBQT1NJWCBvcGVucy4N
Cg0KVGhpcyBpcyBhbHNvIGluIHRoZSBzcGVjIGZvciB0aGUgY2xpZW50Og0KDQo8aHR0cHM6
Ly9zbWIzcG9zaXgub3JnL3NwZWMvd2lwL3NtYjNfcG9zaXhfZXh0ZW5zaW9ucy5odG1sI2Fw
cGxpY2F0aW9uLXJlcXVlc3RzLWFwcGx5aW5nLWZpbGUtc2VjdXJpdHk+DQoNCi4uLmFuZCB0
aGUgc2VydmVyOg0KDQo8aHR0cHM6Ly9zbWIzcG9zaXgub3JnL3NwZWMvd2lwL3NtYjNfcG9z
aXhfZXh0ZW5zaW9ucy5odG1sI3JlY2VpdmluZy1hLXNtYjItc2V0X2luZm8tcmVxdWVzdD4N
Cg0KVGhlIHNwZWMgaXMgbGVzcyBmb3JnaXZpbmcgYW5kIHJlcXVpcmVzIHRoZSBzZXJ2ZXIg
dG8gZmFpbCB3aXRoIA0KU1RBVFVTX0lOVkFMSURfSU5GT19DTEFTUyBpZiBPcGVuLlBvc2l4
IGlzIGZhbHNlLiBBbHRob3VnaCB3ZSBtaWdodCB3YW50IA0KdG8gcmVsYXggdGhhdCBhIGJp
dCBhbmQganVzdCByZXF1aXJlIHRoZSBzZXJ2ZXIgdG8gc2tpcCBmdXJ0aGVyIA0KcHJvY2Vz
c2luZyBpbiBQT1NJWC1TTUIyIGFuZCBjb250aW51ZSBwcm9jZXNzaW5nIGluIE1TLVNNQjIu
DQo=

--------------g15c2ZuB6FKW4MyabxhY0m2d--

--------------VUC39G8TdY1pf8M6SOEbl3Qo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmom+4EFAwAAAAAACgkQqh6bcSY5nkY0
Wg/8CizgbgQnm0oQf9fyJGOFnLYo2T243r6hzvXeU6U90BcZ6GYNbrfmNo990n2G9PtAKhxXLsrD
JCyuaxQJyGUOt+PoS0R5cTLTfUNwyXjv1/xAkUii5fwhLAihhwBdAQl7C9D3q/sjmZFWEV/dkdeX
qDQUum7W9UO81P5QG/Y/gy3tvkeOJXpyn1FOjarcygvU8xM0dQkXirAjA9DYReqWbHflPH9CPLrO
9zbbLc5sQ4n7skgT88X3NwlmglwrqIvlUddg+bfMgcy2h/GvGM1P4Zdzrv3B2yJa6yWmTMbVO90f
BrsYghfTGFxSfrxHLlL8R+rKLOrN6SH+weFTkpGlhLQaeuR1Z7qQBSmK9DHGB9fcYU/AUlvR/7FH
1XHL6i39wfi94ZU3HtmKrRK4XuF80QrnebC+4XsNJ2DNRuhxvQX27Lk87ZUi6LFYG/MEoN5rK7mW
jKQ5Qey/D6eYDutyLoJwkCnQuFbuE7Wnd3elF7xu35Zj8F7P0G7WLQOvbxSwsEDdAG+nfw1YdePx
7S9AOPtNAHY6vW/heE0zzlLZIphyLeh8gBYIVixkfXkgGTSnv7IZRFDPIv3YBXBjtu0CLJmB8ScP
0JCzinyS4MUNjqF6sC80xtMOuc65fQo/rMYbZTxa/5za55+LNhbYFswbirqa6tuzwF50SgaTtr/b
Mw8=
=pdRh
-----END PGP SIGNATURE-----

--------------VUC39G8TdY1pf8M6SOEbl3Qo--
