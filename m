Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A7E440A02
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 09:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837022; cv=none; b=Cdt7OUpPT7o1HY5Ms8FiHKi1a/pINb1VmsBbVd4jTPkjAnf6CKzVN3tAvBDHoy+wC1JkDb7miwS2bb6RZUt2S735ITQe0atrcRfbojATz12DDCuVsnz7rRir8hpK4NBlsP765rNv/SKnzBnFANE/mnA5weNDphqI7FA8LTMAWeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837022; c=relaxed/simple;
	bh=GBNGogOYScItBxvNM0rCMPselAjBORs2LBMSVZGtEoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXoW1TQlg/b8BRTnlArv6BgTf57eQgklTM8xv6lx0pqXIdKzd7ESAqEViqcM1aKV0UJBG6PK0kUIy1ZJjjkke8cjJwN9uqB6RSoVkVpdBilxCoOIe0O9fTz41MJQCSp/AjpTPZTQ8NdA2kUkYOushfySwjFX36lBdQ7bbQvKfKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Wg4M+gc8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Wg4M+gc8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=GBNGogOYScItBxvNM0rCMPselAjBORs2LBMSVZGtEoI=; b=Wg4M+gc8GfNK2iGGkXe+5+rgKT
	32NddOLcfSzwiRqLwt6iRt3wgFtjddT51ktLNLikQXKDRJxKEbmQonBqgvATw5uD3DB2DV2HSgnQK
	DTyrUp2uMoI8+15iefMEvI91NEIBCoIJGOmA1bFw/z7g7a3u2a+EgE8w95wU8Byy0aoAZPLZoOB+8
	w4711hZF9jiheGQJen4HISgis5cj66mA1VJHy5vuVKyJinBTZ3ef74IlIOymbRexNwMT5aYvYad6/
	3wYgeVnVEcbmGhoUZQ95qMi/CY8cEaqsrmxjccmfsHm13BY0uAnKkgzlPD68p8zRl4sQ1A1rWYVnP
	/VrwMKERuBcGEdGuGaSAr473tZB1zJdiUJOfIXoqM33bFOKk3TvIzHkmc84hlFJ9Aazli35RMe29H
	Y+aC2vrQ9QUji7yi1eTh7l6HTSiUr+LczgYW3q+LNTYqi8jJCBpmXxMGDTuS4Ox7IScK80Brzo7rb
	chdJYEfssiSZCT6SWwsEkNVZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wrBmh-00000002bts-0EsB;
	Tue, 04 Aug 2026 09:50:07 +0000
Message-ID: <a6a6913b-7a85-48a8-ba65-13fae188c33b@samba.org>
Date: Tue, 4 Aug 2026 11:50:06 +0200
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
 linux-cifs@vger.kernel.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
 <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
 <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------B440bB1gacgplVQu3DRujJFb"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------B440bB1gacgplVQu3DRujJFb
Content-Type: multipart/mixed; boundary="------------W0iD6Hd3ZH6i8AFLpZ8Hhvkf";
 protected-headers="v1"; hp="clear"
Message-ID: <a6a6913b-7a85-48a8-ba65-13fae188c33b@samba.org>
Date: Tue, 4 Aug 2026 11:50:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
 <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
 <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>

--------------W0iD6Hd3ZH6i8AFLpZ8Hhvkf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkhDQoNCk9uIDgvNC8yNiAxMTowNSBBTSwgQ2hlblhpYW9Tb25nIHdyb3RlOg0KPiBUaGlz
IHNlZW1zIHRvIGJlIHRoZSBydWxlIGZvciBkZXRlcm1pbmluZyB3aGV0aGVyIHRoZXJlIGFy
ZSBhbnkgb3BlbiANCj4gY2hpbGQgZmlsZXMgb3Igc3ViZGlyZWN0b3JpZXMgdW5kZXIgdGhl
IG9sZCBkaXJlY3Rvcnkgb2YgcmVuYW1lIG9wZXJhdGlvbi4NCg0KYWgsIGNyYXAsIHRoYXQg
d2FzIGFjdHVhbGx5IGZvciBQT1NJWCBkZWxldGlvbiBzZW1hbnRpY3MsIHNvcnJ5IGZvciB0
aGUgDQpjb25mdXNpb24hIDopDQoNCj4gRm9yIGNoZWNraW5nIHdoZXRoZXIgdGhlIG5ldyBm
aWxlIG9mIHJlbmFtZSBvcGVyYXRpb24gaXMgb3BlbiwgdGhlcmUgDQo+IGRvZXMgbm90IHNl
ZW0gdG8gYmUgYSBQT1NJWC1zcGVjaWZpYyBydWxlLg0KaG0sIGl0IHNlZW1zIHRoaXMgb25l
IGlzIGluZGVlZCBtaXNzaW5nLiBHb29kIGNhdGNoLCB0aGFua3MhDQoNClRoZSBiZWhhdmlv
dXIgc2hvdWxkIGJlOg0KDQotIGlmIHRoZXJlIGFyZSBvbmUgb3IgbW9yZSBub24tUE9TSVgg
b3BlbnMgb24gdGhlIGRlc3RpbmF0aW9uLCBNVVNUIGZhaWwgDQp3aXRoIFNUQVRVU19BQ0NF
U1NfREVOSUVEDQotIGlmIHRoZXJlIGFyZSBvbmx5IFBPU0lYIG9wZW5zLCB0aGUgb3BlcmF0
aW9uIGNhbiBwcm9jZWVkDQo=

--------------W0iD6Hd3ZH6i8AFLpZ8Hhvkf--

--------------B440bB1gacgplVQu3DRujJFb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpxtc4FAwAAAAAACgkQqh6bcSY5nkbQ
+A//crI5XlQ02c4z4sK/9HwTd7VaPYGKkn03MeWwbmSHkXToRzyVv7RL0J8lB9eJG1fuTDLXZbjY
LAFIgVY1u98BYRdh8Q+OEQoxu6hLNKFR11Z9WGF+A3s/0PpLVMNavixz3LvXKVNvRemjH+YZM9M3
4foqlAV5XQNA96bxI5/4aodPx4CFAbFroSpJ52zcrM881gbAnLa+wH6P0fiLGTjO8C0j5LoAENvn
LDh5lOAx8ggfvOxKtQQnISwMehvG3WUzdCMNbK+wd5bf3TU/OzZxH3yqbNt0x5wlbXpJK1NX8Hm3
Rt5tq3y9Sg0OKqB4XHUHVlnIiaHwEh+yRe91WA31jh20rYsuN6V7ULgvvcZFjd8CWQmzNQziJ/30
B56nk0d6+wNqylt/c5nTN3tAQEgXfT3hoakgv0krn/XwSiBn/N8SovnV2jDW6PRpuf0ckVgl8lr7
PB5GE2AczXcCIhvFVvzh441hgSGQMpVrIawquouCZic5pTxXjZWsW9oQE1JG7OmORpIyIF6Oj9Js
bja6iz6iGrwdlEQvsTeNIJeKx3NO4E7pzIvkW5b8hl/QEYJAycb5aM/KyXFR4YE+kvIltpUgg99u
Bbq9QQqx/jFO/Kw569rgn3lRCwOeLtDHzy14Ms4s57DwCkndmqeKUd1rL+pTarVBjmxnfkY+g1i5
+6I=
=UPSL
-----END PGP SIGNATURE-----

--------------B440bB1gacgplVQu3DRujJFb--
