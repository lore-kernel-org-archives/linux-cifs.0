Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506314;
	b=uJEJ7sYATojBcLbHhFDuE3h5qX2HmmvJT0j6g+B0ScWgTiIinnskE+bNgUJi+RsdsgMn
	 pL1wrjDKvyzJ3quBLU0qrFGD/NZEUH/ju6EW+Ai5XyDyyPgg6Fi34Tr2dMj2DlTHSiGrF
	 elLsqrvI3jJmIKXXtW28gCLCh7wqisxHR8LSmta7GBLueIQWNbbYYgtVwF8eqaCFAuz76
	 UZ7zhXim1OVKDUNxrvWc0+lsqLEa/2BmbYIwKTAStrMUpQraQgpRGHCAT8WVezGKAwBwp
	 XqsKiKLjtGNt3BjSBiDw3sBbFmFZls/Pw+DptDzZHumamH6mSMRAoYiwYIZ0rWlW3Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506314;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:Autocrypt:
	 In-Reply-To:Content-Type;
	bh=xEE2lr8yBYkGH8x8wIl41RY9UtBu/AyiBsdWOUc273k=;
	b=X0OrNi2gOU4Up2TLyRwL0hTsV6uHp2tCQaWdVGGeU7K+p9rj3PnW1gn4bh25mGyx8aQW
	 7KSgLQNkr838KLSLfOhYeM9YlhYPK3NOsHFMBWO2VcSVn9BdlcIGQ6S2ZibeKwjoGtLB0
	 4k5ildOSSd0u0LcRmySpyg66a2M/CGSS7Gvz8guva+nKLtkOHai8Bt0TE2WcHCK9UXMVy
	 52oDJBwNQnWdGYCBd0gIe5TG+zuE7T8KTrsEmnEUioVTvcJ4r71Lc0Llg0R7dtuY5OzoI
	 P+7hoNzXVrHedAXoYb5dNbqyvP31urLsfUIXuN9c7ZtKDtVNqa+/xgne0/RO7NtAqkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=uHwUCU2X;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A219D606A32E;
	Tue, 20 Oct 2026 14:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A219D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=uHwUCU2X
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xEE2lr8yBYkGH8x8wIl41RY9UtBu/AyiBsdWOUc273k=; b=uHwUCU2XowstP+U0rGO/ENim7q
	TWqPWW9i5FQSGBY9e71g+WlOI7DJdtmFf65GqGWmYr9qf1W3IIZYXV7P1fkmlIpk/wfA1I4NaBseZ
	mhmagBh72BWUm6ZgjScF7jeE6ON6eGZJPMKJr+f9WxP3TSHqZpHSQDEWe1Nny2x0/HSIbVLsFV4OU
	nf0c8z0nvcYNPheN0krNfw85kEVJIwzo5mwcM9ShwpOlUpnBAgWstW8KXm3JoYQeqFPCdFiPDRC8m
	8S3iUs25vY/m4g4o2qHa7X9KF365zGpNkUzj8LFXvcFv91dBchvwG/Ee5qxtcVI9pJJlSZZjTXUQn
	qBS+dyY7duwQi8fSwe1d8zUXJwDuhFgJRfSxOSRFTOiyYQdo3HY39sURHnP9WSHUZsvOs/R0//fio
	XRLWm5Eg9ZbOSUZ++kzACNiZsSb0oMb7C4vTksUwA8BfQkQQTntYVsx6dGMlt7XJ8ZhWGQHnbDW34
	z13qZeVqR+qANFJ6wL7iLjZ9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xJAlx-00000003oJo-1MDl;
	Tue, 20 Oct 2026 14:25:01 +0000
Message-ID: <9b5b0f6c-9105-4e30-8608-6f222b0e2a6e@samba.org>
Date: Tue, 20 Oct 2026 16:24:53 +0200
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Wang Zhaolong <wangzhaolong3@outlook.com>,
 Stefan Metzmacher <metze@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Jan Koester <jan.koester@gmx.net>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky
 <senozhatsky@chromium.org>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@fygo.io>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 wang zhaolong <wangzhaolong@fnnas.com>
References: <cover.1792345559.git.jan.koester@gmx.net>
 <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
 <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
 <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tFEd2ng5PyLkGb1QP1vDlpIm"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tFEd2ng5PyLkGb1QP1vDlpIm
Content-Type: multipart/mixed; boundary="------------R0OMzfJMomT3H9RsvuXJy2A0";
 protected-headers="v1"; hp="clear"
Message-ID: <9b5b0f6c-9105-4e30-8608-6f222b0e2a6e@samba.org>
Date: Tue, 20 Oct 2026 16:24:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Wang Zhaolong <wangzhaolong3@outlook.com>,
 Stefan Metzmacher <metze@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Jan Koester <jan.koester@gmx.net>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky
 <senozhatsky@chromium.org>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@fygo.io>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 wang zhaolong <wangzhaolong@fnnas.com>
References: <cover.1792345559.git.jan.koester@gmx.net>
 <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
 <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
 <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>

--------------R0OMzfJMomT3H9RsvuXJy2A0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjAvMjYgMzo1NCBQTSwgV2FuZyBaaGFvbG9uZyB3cm90ZToNCj4gSSdtIHdvcmtp
bmcgb24gYWRkaW5nIEFjdGl2ZSBEaXJlY3RvcnkgRG9tYWluIENvbnRyb2xsZXIgc3VwcG9y
dCB0byBrc21iZCwNCj4gcmF0aGVyIHRoYW4ganVzdCBhbGxvd2luZyBrc21iZCB0byBqb2lu
IGFuIGV4aXN0aW5nIEFEIGRvbWFpbiBhcyBhIG1lbWJlcg0KPiBzZXJ2ZXIuDQo+IA0KPiBU
aGUgaW5pdGlhbCBnb2FsIGlzIGEgc2luZ2xlIHdyaXRhYmxlIEFEIGRvbWFpbiBjb250cm9s
bGVyLCBzdXBwb3J0aW5nIG9uZQ0KPiBmb3Jlc3QsIG9uZSBkb21haW4gYW5kIG9uZSBzaXRl
LCB3aXRoIG1vc3Qgb2YgdGhlIG5ldyBBRCBzZXJ2aWNlcyBpbXBsZW1lbnRlZA0KPiBpbiBS
dXN0IHVzZXJzcGFjZSBjb21wb25lbnRzLg0KPiANCj4gVGhlIHBsYW5uZWQgZnVuY3Rpb25h
bGl0eSBpbmNsdWRlczoNCj4gDQo+IC0gQUQgZGlyZWN0b3J5IHNlcnZpY2VzLCBpbmNsdWRp
bmcgTERBUCwgRE5TIGFuZCBDTERBUCBkaXNjb3ZlcnkuDQo+IC0gS2VyYmVyb3MgS0RDIGFu
ZCBQQUMgc3VwcG9ydC4NCj4gLSBORVRMT0dPTiBhbmQgZG9tYWluIHNlY3VyZS1jaGFubmVs
IGZ1bmN0aW9uYWxpdHkuDQo+IC0gSW50ZWdyYXRpb24gd2l0aCBrc21iZCBhdXRoZW50aWNh
dGlvbiwgaWRlbnRpdHkgbWFwcGluZyBhbmQgYXV0aG9yaXphdGlvbi4NCj4gLSBXaW5kb3dz
IGRvbWFpbiBqb2luIGFuZCBsb2dvbiwgaW5jbHVkaW5nIFNZU1ZPTC9ORVRMT0dPTiBhbmQg
R3JvdXAgUG9saWN5IHN1cHBvcnQuDQoNCm1heSBJIGFzazogd2h5PyBXaGF0J3MgdGhlIGJl
bmVmaXQgb3ZlciB1c2luZyBzb21ldGhpbmcgbWF0dXJlIGFuZCBPcGVuIA0KU291cmNlIHRo
YXQgYWxyZWFkeSBkb2VzIGFsbCB0aGF0IGFuZCBtb3JlPw0KDQpKdXN0IGN1cmlvdXMuIDop
DQoNCkNoZWVycyENCi1zbG93DQo=

--------------R0OMzfJMomT3H9RsvuXJy2A0--

--------------tFEd2ng5PyLkGb1QP1vDlpIm
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmrXebUFAwAAAAAACgkQqh6bcSY5nka6
jBAAtQuNOFMRE1Im7VWweQ4oWctTZATaHT3MmX6LZOmr1zcrYOLYZIl/QAzHbJYTLSdVLrwJl7G7
oaIWpMS5USTOG79zqt26FDqb7Gx8ibPNVmMsvqh1u+X4YURHEF4iZVqrIZBCLqelVmtOJ4Ok5CEt
4ADjGYA/aGHly8PxLus4dfooW3BpNeWwPUyjKk1OAk2w62ur19lL76jn9iEMR5YXc0ZYH949X/zY
2QgFrz42o60LcKb0hrpKh0VhqOb0+L9c4tBr8HzSP2T5wnlRym9XwJWbjJdqyv4+OWeyIlsLnK/g
MJjYMSrnJnlcv//gXcPuzwEu8OHOkZ0ZME5Q8AU8XrcF1p6ha7pP3pO3xInJpIuIY3GiyugAA3qC
21/1ZjdakCLDdUmyVABH42pw7LG4DSd55yo+UaaVIkAox4SA1Gg1est7C3qS5bak0WqcmgzuqFdl
7L7Viue73M4YQ1jCwiSG620jEr2GqNI+UTdMQTUz/DbtbCR4+wVk/RmcRAQrq0+sGsBrfGO2E4vu
u+AmbnWw9eEzNh1PpBBurvIIAPR1l1mvD/g0xH1DzhCH/4q8ZULMNHZW0+U4n/uhcClGIEWP2wBt
fWmEnDGOWMk/YEmChKIOvhGGFCJESOyYragRXKS4x0CZiPORkVMn/hotuynOGro8elR9/rzBgahB
m6M=
=dOtr
-----END PGP SIGNATURE-----

--------------tFEd2ng5PyLkGb1QP1vDlpIm--
