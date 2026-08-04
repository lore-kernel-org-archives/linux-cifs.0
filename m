Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FFE3B14AA
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833057; cv=none; b=b81GD3B3bCltkNa3Sqll9F2LS3yFyg/dFivgcN0xKb/CIP6ceIjvUOJLu91eaz/WY212o+eV+yZA48rU+FkROK4rduyauDakovvdA0d/TDdNd7wAuWYNlZHd/q/NwXS2W/mabUR7cOnIqwWDP+Hd9XQGJ1oSPdoqWbiKyBqed+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833057; c=relaxed/simple;
	bh=8HAudPSrZOtJUEbCJUCbDiN9/fJnDjMW/3SOQZJLxFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKHJZXd1TdNl65wNs6yK0ZC5pIAyLXtjEnYzRGOZehwyI0FZHgTVKZWClExsaj11PhOgGbOVjiMY3apUGn1Nqh/utezORyF14v1ZbCItq9BMs/35meMGX5NJ+6EbdeNzXokCd+VWiNGe475mgrc7ai85NEzGIXhfyioe8MT90aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UFp/dkAi; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UFp/dkAi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=8HAudPSrZOtJUEbCJUCbDiN9/fJnDjMW/3SOQZJLxFI=; b=UFp/dkAi7ajdYq0qyyMsBcwyig
	krQLEGVxiWJyzDHq/VtXvvybyrLNa3LBKcp5S3EMtdG3j/MrUs43OnK8htWZ5beV7RL7v6uMJvtyq
	ObvW2pDkTb9kkOZqZSjSwR/j2nNNY+4sKgLkHV8DVmz7NFQQ7Anzy9WLSubntBaupD99sqJ9Ucr1x
	zgZ89AvdXRMcBWo4CMs01+OtfwLP1/yobZkSryJTfqLARYNmwXTApYzTzbc7hQDqoBlDEJEhXZs56
	0b23v4aFEfoEDa/Aa7J60iJioo2GH5F27iQQ4ua6utnpvDlHjSCefKDncXrygGZILSlTaJgOEQkQV
	Gv18+oTAGi/9gb3I5fFzd82+H/dOEZmwV7MhmJGCpWn7AwB+A3etjyVU8c98pDrCh3QJn1syWF734
	9oSQJyElKcm/qXzFGJqyRk30M98BhRxkyRezrtK+jNvgyqM+Jel2wL1wB31RC3Rb5nVxcx+C7gI6C
	lm8AZvhGhFgLsyLWkRWxMmiu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wrAkl-00000002afy-1URE;
	Tue, 04 Aug 2026 08:44:03 +0000
Message-ID: <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
Date: Tue, 4 Aug 2026 10:44:02 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Fn2Bnsgxe0gs0Q00aQPDBAMq"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Fn2Bnsgxe0gs0Q00aQPDBAMq
Content-Type: multipart/mixed; boundary="------------G430bJ1mA40nWFot3yCAVpzN";
 protected-headers="v1"; hp="clear"
Message-ID: <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
Date: Tue, 4 Aug 2026 10:44:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>

--------------G430bJ1mA40nWFot3yCAVpzN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Rm9yIFBPU0lYIHRoZSByZWxldmFudCBwaWVjZSBpcyBQT1NJWC1GU0EgMi4xLjQuMiAiU2Vy
dmVyIFJlcXVlc3RzIA0KQ2xvc2luZyBhbiBPcGVuIi4NCg0KVGhlIGltcG9ydGFudCBudWFu
Y2UgYmVpbmcgdHJlYXRpbmcgIlBPU0lYIG9wZW5zIiBkaWZmZXJlbnQgZnJvbSANCm5vbi1Q
T1NJWCBvcGVucywgYmFzaWNhbGx5Og0KDQotIGFsbG93IHJlbmFtZSBpZiB0aGVyZSBhcmUg
b25seSBvdGhlciBQT1NJWCBvcGVucw0KLSBmYWlsIHRoZSByZW5hbWUgaWYgdGhlcmUncyBv
bmUgb3IgbW9yZSBub24tUE9TSVggb3BlbnMNCg0KRm9yIFNNQjMgUE9TSVggd2UncmUgbm90
IHBsYW5uaW5nIHRvIHVzZSBGaWxlUmVuYW1lSW5mb3JtYXRpb25FeCwgYXMgDQp0aGVyZSdz
IG5vIG5lZWQgZm9yIGl0LCB0aGUgYWJvdmUgcGllY2Ugb2YgdGhlIHNwZWMgbmljZWx5IGFj
aGlldmVzIHRoZSANCmRlc2lyZWQgYmVoYXZpb3VyLg0KDQpDaGVlcnMhDQotc2xvdw0KDQoN
Ck9uIDgvNC8yNiAxMDoyOCBBTSwgQ2hlblhpYW9Tb25nIHdyb3RlOg0KPiBBY2NvcmRpbmcg
dG8gTVMtRlNBIDIuMS41LjE1LjEyLCBsZXZlbCAxMCAoRmlsZVJlbmFtZUluZm9ybWF0aW9u
KSwgYW4gDQo+IG92ZXJ3cml0ZSByZW5hbWUgbXVzdCBmYWlsIHdpdGggU1RBVFVTX0FDQ0VT
U19ERU5JRUQgaWYgdGhlIGV4aXN0aW5nIA0KPiB0YXJnZXQgc3RpbGwgaGFzIGFuIG9wZW4u
DQo+IA0KPiBNUy1GU0EgMi4xLjUuMTUuMTIgRmlsZVJlbmFtZUluZm9ybWF0aW9uOiBodHRw
czovL2xlYXJuLm1pY3Jvc29mdC5jb20vIA0KPiBlbi11cy9vcGVuc3BlY3Mvd2luZG93c19w
cm90b2NvbHMvbXMtIA0KPiBmc2EvODdmODZjOWItNmMyYS00ODAzLTg0YjctMTMxYTc0YTQz
NGZhDQo+IA0KPiBPbiA4LzQvMjYgMTU6NTMsIE5hbWphZSBKZW9uIHdyb3RlOg0KPj4gT2th
eS4gV2UgY2FuIGltcGxlbWVudCB0aGlzIGluIGtzbWJkIGFuZCBjaWZzLmtvIHRvIHBhc3Mg
Z2VuZXJpYy8wMzUgDQo+PiB0ZXN0Lg0KPj4NCj4+IFRoYW5rcyBmb3Igc2hhcmluZyBpdC4N
Cj4gDQoNCg==

--------------G430bJ1mA40nWFot3yCAVpzN--

--------------Fn2Bnsgxe0gs0Q00aQPDBAMq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpxplIFAwAAAAAACgkQqh6bcSY5nkZV
9w//SzWWdNWRBkE1V/j0pMMKZH4wdTXYtEOEgtYCbC9tY1MxMhsf0zlHraT9+HFIE9RoMw87TsKv
DxTijMawiBhyDbJDj+12bt+e3AbWeAzq5IX5gSjCHTH+3KZyjL59FRe/SIt/AlElj6HFGFJUjAGm
7noojrFmtb9s5vCKmLqJp/ddyAM/o9MDfRU2PoAIDjjOKWudmjFqOTebaOj3RYiatJl89T8kUzmT
c2+6NCdxIKaHi5mjy8fZcoXSPW0BeUqeYRlkMFe3OgG944dQhF94eqyg/E/pQo8k56LgOvW/pQEY
f9df30X5FmgTpXlkutN96ZHk5Wrbet0CrPe6czmmL6/52VNhO1Fcr2xOMk5xwx4dGA1SjcKjuIgf
7LSH8q7sGJEsKEi0QFU3anksVxeuAk5A8rDhatpt+o9Oq24NyGHKqri1PWG6cCXeuhsix4g5LAUK
YhtZbUmu/99Nwh4hdlEkRf3wi9QZcmMsUEuLAX2mEuQLE36m0o7vszyKvgWnat56TGz6KmGPbcDj
QnicyrKXpzhR8+RkbDOP2E3AIOoQkAj2cQtmtjnGPodPgmPnYoFxUCBB2I9eFSU27m7GKEH9ohnE
ubUmPqk7oDM9mIqmULFS7Owi7PXwpWD5IEO0iZSN7HZqnDAW90DjkGJzFQtfNPYRHKAdRv+msNm8
8po=
=UAGD
-----END PGP SIGNATURE-----

--------------Fn2Bnsgxe0gs0Q00aQPDBAMq--
