Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234823CE4B6
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780939313; cv=none; b=uAY2pYQGKcpTprHGNKMI5y+0cRgKpL2BNzVnlqmLcnXS/R1NRBZhnWrv+tNRzQpoOMlrxqDOc8OzpQbVvDk+aMRM3WkwIZKEmuLdyJTJGmIlXnbMYQQs/46RJSoY4C9mb0GG5lNrQ71nLWS5NiFybzK6QoGQLb6mwuP8O7D3nn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780939313; c=relaxed/simple;
	bh=v6g3CMp0smqnbFo9QjLmtQKyERqIT5IS3Jf891Ra/rA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=el1zv0WWoOBieTzxVk8s94zKRZ8GngWImGXeDYOwEoJ9GOretbAGywxHCEgfCjzAxd11DZ8IFlwkxLz+mH7sHoSRj0TZwtkpaRgCO5nzaYzcA2Elj6IpplQ4dSSMgXfm/LnNpwlQ5onBHePFf1iBKpB9Im5Lw6Z69IBBGw8WmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WZ2pjHMW; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WZ2pjHMW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=v6g3CMp0smqnbFo9QjLmtQKyERqIT5IS3Jf891Ra/rA=; b=WZ2pjHMWNbsT4W2I2ccmnJ4Hsv
	yOA13403OedNhxqTRpMvDHPNaVT4pnRqKIYayLLDwQBr6DhDYHZsZwCd9NqVnRMdHL6PaYKEXWqnc
	WW+EW8Pz2S82+G3B2m5kv9/elycuqITv9NgJoEM66EypFdQYXFBdo3UrCdNADUGZwiQfHRcS7ummy
	TrgEdCFghogwC5f9b+ThCL8sz0efwPh8+XKyPATigTryZs1UAx2X93cKKSnOLs4o9VFfyw0Nu/21m
	g2PRLAYr0WNev5mPEL+5g90NSJVmoZLFZALguVtiMHmF6e/QC9apzxJBSgaR5q/TgfYBZvmVp8Ojx
	vLZdpyBXkuMxeiFdbQghDJLYYIHXbTz5CpT+pluIg3ZCFZ5pOXQjcdFnARCokWcUp/7d6ZFcm4sBP
	TWouGPxsh3eGi5ktmhjTnSpZezr3GDuB1sWNsAQJX9qUebcfoLv4y+SeM5SdH5kWHnoSVG5r9ZMjw
	b+bPWsttvNJLq6Mmxn0Ig7e6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wWdfT-0000000EuSL-0Nm1;
	Mon, 08 Jun 2026 17:21:43 +0000
Message-ID: <1087073d-02a2-4acf-bb79-5c9be77858fe@samba.org>
Date: Mon, 8 Jun 2026 19:21:42 +0200
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
 CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jrasamba@gmail.com>,
 Huiwen He <hehuiwen@kylinos.cn>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
 <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
 <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org>
 <CAH2r5mumYk1bcnwwgm8ogP9gaKSZzZX_TFdv+cm9CyxCiT11zw@mail.gmail.com>
 <CAH2r5mtH3H8t1xOOwL+8=2CT6XPdndDkwb-438GQoibCgeF-tQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mtH3H8t1xOOwL+8=2CT6XPdndDkwb-438GQoibCgeF-tQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eUK4q8AL0QEoe0UPgyXJr31b"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------eUK4q8AL0QEoe0UPgyXJr31b
Content-Type: multipart/mixed; boundary="------------D10TiC1um2tmYnnOEnezxCMh";
 protected-headers="v1"
Message-ID: <1087073d-02a2-4acf-bb79-5c9be77858fe@samba.org>
Date: Mon, 8 Jun 2026 19:21:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jrasamba@gmail.com>,
 Huiwen He <hehuiwen@kylinos.cn>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
 <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
 <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org>
 <CAH2r5mumYk1bcnwwgm8ogP9gaKSZzZX_TFdv+cm9CyxCiT11zw@mail.gmail.com>
 <CAH2r5mtH3H8t1xOOwL+8=2CT6XPdndDkwb-438GQoibCgeF-tQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mtH3H8t1xOOwL+8=2CT6XPdndDkwb-438GQoibCgeF-tQ@mail.gmail.com>

--------------D10TiC1um2tmYnnOEnezxCMh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi84LzI2IDI6MDEgQU0sIFN0ZXZlIEZyZW5jaCB3cm90ZToNCj4gWWVzIC0gY2htb2Qg
c2VlbXMgdG8gd29yayBtb3N0bHkgb2sgd2l0aCBwb3NpeCAobm90IHVzaW5nIG1vZGVmcm9t
c2lkLA0KPiB0aGUgbW9kZWZyb21zaWQgYnVnIEkgd2FzIHRhbGtpbmcgYWJvdXQgd2FzIG5v
dCBtb3VudGluZyB3aXRoIHBvc2l4KQ0KPiBidXQgdGhlcmUgYXJlIGEgZmV3IGV4YW1wbGVz
IG9mIHByb2JsZW1zIHdpdGggcG9zaXggYW5kIGNobW9kLiAgIGUuZy4NCj4gbW91bnRlZCB0
byBTYW1iYSB3aXRoIHBvc2l4DQo+ICAgICAgIGNobW9kIDA3NjQgL21udC9zY3JhdGNoL2Zp
bGUNCj4gd29ya3MgZmluZSBhbmQgbG9jYWwgYW5kIHJlbW90ZSBtb2RlIGJpdHMgbWF0Y2gg
YnV0IHNldHRpbmcgdGhlIHN0aWNreQ0KPiBiaXQgcmVtb3RlbHkgaXMgaWdub3JlZA0KPiAg
ICAgICBjaG1vZCArdCAvbW50L3NjcmF0Y2gvZmlsZQ0KPiB0aGUgbW9kZSBzdGF5cyBhdCAw
NzY0Lg0KZ29vZCBjYXRjaCwgdGhhbmtzLiBUaGF0J3MgaW5kZWVkIGEgYnVnOg0KDQpodHRw
czovL2J1Z3ppbGxhLnNhbWJhLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MTYwOTgNCg==

--------------D10TiC1um2tmYnnOEnezxCMh--

--------------eUK4q8AL0QEoe0UPgyXJr31b
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmom+iYFAwAAAAAACgkQqh6bcSY5nkZz
tg/9Fwq/Dt+YxIodMLMjuFgtHcgzvzo18nG+btCoocmq0RhYVd22nlTyyV8smxPcMXblZfnn7ZWw
h2R0+8Ue31kQ4h2FRqGWpcjV+TrGDxoWOJVmWyd3pV5sJIG+/iJBLMs5FNfbZdd4KCU1/NzWvDUm
XfHtMVLJXPgSPdRd+z/drEiGriwDyzqfFEte3Lnm63WxR7H8ipDl21FPl3y9p/rEEnWy+xp4nPh2
Va/5FekY6MiKNF7tksWf21EDH6eX4TNgh+RHQ5lkdHQ7kRvPu4hw1TnIcJZ6nPQuorhHsK+v06BX
+L782La5zT1P56J13TJOq1fG8wi1BEdBWiy2BP6J8+jrGtcCns5GM4ucR74KNFpeJWD4tWxz4/Zp
YRGnKZ0Qt55wHGgN1FcCBI3qlSAL3RHSQADnwysDINlf9iunlKCfGAMqCFu7N9fAxhtcYNX8YXQQ
+SN9B1kyODPoD1t43sfwheLsCbixWqBE/+cO3AZplbM3hUbhTnq8JAR3Z4gvrgvZ/LHJhaMfAhJ0
2IiCy7C59AP+BVMs+fwlmWkBgAIdZM9eVTX4fnYMdodg89BLlJ50ss3RkxTODXLXNb/ir+wRcZYr
mhqEqNtMtrN5E3mmwrVPS7W6BDbO0VW60XA3Ox5V3CgbNHmTai0vG+WESMa+HVblHWwwnvDX1fry
TWw=
=zvRs
-----END PGP SIGNATURE-----

--------------eUK4q8AL0QEoe0UPgyXJr31b--
