Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BC3EA947
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918615; cv=none; b=qHbutAw3Xgxgb4PTOSiME/ADOvY4IccyugQEhHO5I2q3UTxvp6e6hzZZBD/yP9aZzae7huTtl59truNvYU4a2qfuD2aVUnuW8mDCK9H//JyEUe2B5xBDTPWkhfke+zAao3/A66fv8l/wxNVy8YbL7isYqzT/NbFP7Tqlw8ADs6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918615; c=relaxed/simple;
	bh=cujtgfeIMVxgqkBN8GxM8uRvP+6k5unMFkQQDdh5rkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/tXa/aNWXbfFipFif6oGot6sUinBoY2fmme9SRrX5YB+4BZ6JLwJOiq0X0m9Kgaz2SnYKFMXUHTXwHuy5MieYtm51ugA+WsM/esX6aPIA2Xysv3LeuPPMa9xPK/H86Ho5Hgdss2QZB4Ye6CSd2QpyYK1NjkIX7QVu8U1CZKj/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oyghbZjC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oyghbZjC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=cujtgfeIMVxgqkBN8GxM8uRvP+6k5unMFkQQDdh5rkE=; b=oyghbZjCq6DBGlUFWy+gDgxuzR
	3RaTp0XN/n4+sIlw14X7f5r4YrFxvlCCkrtpncRFgs/hzJftlTHaeDmIaWBkC/DKKEGNulUHPY70Y
	KJQ8QEqg78Vs4fXtks+Nn6ighwUw3+J0VasAQrr93k36tFB3U72DLZQQYw5eg1rTymiw1IILPr+dk
	Xb6azbQEKxNE7rdz1T5ncTc6fp3k0GcqoA0iGNz79/SaRweq6YAf4mSyEHXYnmBHy5BrOLe5V/av0
	6/YrsPgnl95A555lxnr+6sBGSXhAsxkKETeelzhKvfUlRzAryPIZFM9V4dGXsKxrxuNz3vwiI51lr
	6SrxZLn32TSEYAswvfGBAU/pcPILCjxYWB8qi9QEi551KjcO6FIOWrivZZ6JT1wXFoWoy68scClRW
	hH9URdnV5gVBObSrBe/rcPCKEkReA6Lx/+2sFvK19l0Vk3G277fStgz0PfSAaq0n7hPDra0KOyt1f
	ACrm4MRQg3Jy3T+cRqyY54LU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wrX0o-00000002qKZ-45BV;
	Wed, 05 Aug 2026 08:30:07 +0000
Message-ID: <20390239-0e72-40ee-95d5-1f6235ff8c46@samba.org>
Date: Wed, 5 Aug 2026 10:30:06 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH smb3-posix-extensions] FSA: allow rename over files with
 only POSIX opens
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805082018.309542-1-chenxiaosong@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <20260805082018.309542-1-chenxiaosong@chenxiaosong.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zIaq0P7IPvJnHIYY3CF6PHCq"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zIaq0P7IPvJnHIYY3CF6PHCq
Content-Type: multipart/mixed; boundary="------------8a4KAX2p4IL0O0BNDou9NicW";
 protected-headers="v1"; hp="clear"
Message-ID: <20390239-0e72-40ee-95d5-1f6235ff8c46@samba.org>
Date: Wed, 5 Aug 2026 10:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH smb3-posix-extensions] FSA: allow rename over files with
 only POSIX opens
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805082018.309542-1-chenxiaosong@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <20260805082018.309542-1-chenxiaosong@chenxiaosong.com>

--------------8a4KAX2p4IL0O0BNDou9NicW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Q2FuIHlvdSBwbGVhc2UgY3JlYXRlIGEgTVIgb24gZ2l0bGFiPw0KDQpUaGFua3MhDQoNCk9u
IDgvNS8yNiAxMDoyMCBBTSwgQ2hlblhpYW9Tb25nIHdyb3RlOg0KPiBGcm9tOiBDaGVuWGlh
b1NvbmcgPGNoZW54aWFvc29uZ0BreWxpbm9zLmNuPg0KPiANCj4gVXBkYXRlIEZpbGVSZW5h
bWVJbmZvcm1hdGlvbiBwcm9jZXNzaW5nIGZvciBhbiBleGlzdGluZyBkZXN0aW5hdGlvbi4N
Cj4gSWdub3JlIFBPU0lYIG9wZW5zIHdoZW4gY2hlY2tpbmcgd2hldGhlciB0aGUgZGVzdGlu
YXRpb24gaXMgb3Blbiwgc28gdGhlDQo+IHJlbmFtZSBjYW4gY29udGludWUgaWYgYWxsIGRl
c3RpbmF0aW9uIG9wZW5zIHVzZSBQT1NJWCBzZW1hbnRpY3MuDQo+IA0KPiBLZWVwIHJldHVy
bmluZyBTVEFUVVNfQUNDRVNTX0RFTklFRCBpZiB0aGUgZGVzdGluYXRpb24gaGFzIG9uZSBv
ciBtb3JlDQo+IG5vbi1QT1NJWCBvcGVucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoZW5Y
aWFvU29uZyA8Y2hlbnhpYW9zb25nQGt5bGlub3MuY24+DQo+IC0tLQ0KPiAgIGZzYV9wb3Np
eF9leHRlbnNpb25zLm1kIHwgMTUgKysrKysrKysrKysrKysrDQo+ICAgMSBmaWxlIGNoYW5n
ZWQsIDE1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9mc2FfcG9zaXhfZXh0
ZW5zaW9ucy5tZCBiL2ZzYV9wb3NpeF9leHRlbnNpb25zLm1kDQo+IGluZGV4IGUwMzEwMmQu
LjdkYmRmNzcgMTAwNjQ0DQo+IC0tLSBhL2ZzYV9wb3NpeF9leHRlbnNpb25zLm1kDQo+ICsr
KyBiL2ZzYV9wb3NpeF9leHRlbnNpb25zLm1kDQo+IEBAIC02MTcsMyArNjE3LDE4IEBAIE9w
ZW4uR3JhbnRlZEFjY2VzcyBkb2VzIG5vdCBpbmNsdWNlIEZJTEVfV1JJVEVfQVRUUklCVVRF
UyBhbmQNCj4gICBub3QgQWNjZXNzQ2hlY2soU2VjdXJpdHlDb250ZXh0LCBGaWxlLlNlY3Vy
aXR5RGVzY3JpcHRvciwgRklMRV9XUklURV9BVFRSSUJVVEVTKToNCj4gICANCj4gICAtIHRo
ZSBvcGVyYXRpb24gTVVTVCBiZSBmYWlsZWQgd2l0aCBTVEFUVVNfQ0FOTk9UX0RFTEVURS4N
Cj4gKw0KPiArIyMjIyMgMi4xLjQuOC4zIEZpbGVSZW5hbWVJbmZvcm1hdGlvbg0KPiArDQo+
ICtXaGVuIHByb2Nlc3NpbmcgdGhlIGZvbGxvd2luZyBjb25kaXRpb24gZnJvbSBNUy1GU0Eg
Mi4xLjUuMTUuMTI6DQo+ICsNCj4gKy0gSWYgdGhlcmUgd2FzIG5vdCBhbiBvcGxvY2sgdG8g
YmUgYnJva2VuIGFuZA0KPiArICAqKlRhcmdldExpbmsuRmlsZS5PcGVuTGlzdCoqIGNvbnRh
aW5zIGFuICoqT3BlbioqIHdpdGggYSAqKlN0cmVhbSoqDQo+ICsgIG1hdGNoaW5nIHRoZSBj
dXJyZW50ICoqU3RyZWFtKiosIHRoZSBvcGVyYXRpb24gTVVTVCBiZSBmYWlsZWQgd2l0aA0K
PiArICBgU1RBVFVTX0FDQ0VTU19ERU5JRURgLg0KPiArDQo+ICtGb3IgdGhpcyBjaGVjaywg
dGhlIG9iamVjdCBzdG9yZSBNVVNUIGNvbnNpZGVyIG9ubHkgbWF0Y2hpbmcgb3BlbnMgZm9y
IHdoaWNoDQo+ICsqKk9wZW4uSXNQb3NpeCoqIGlzIEZBTFNFLiBJZiBvbmUgb3IgbW9yZSBz
dWNoIG9wZW5zIGV4aXN0LCB0aGUgb3BlcmF0aW9uDQo+ICtNVVNUIGJlIGZhaWxlZCB3aXRo
IGBTVEFUVVNfQUNDRVNTX0RFTklFRGAuIElmIGFsbCBtYXRjaGluZyBvcGVucyBoYXZlDQo+
ICsqKk9wZW4uSXNQb3NpeCoqIHNldCB0byBUUlVFLCB0aGlzIGNoZWNrIE1VU1QgTk9UIGZh
aWwgdGhlIG9wZXJhdGlvbiBhbmQNCj4gK3Byb2Nlc3NpbmcgTVVTVCBjb250aW51ZSBhcyBz
cGVjaWZpZWQgaW4gTVMtRlNBIDIuMS41LjE1LjEyLg0KDQo=

--------------8a4KAX2p4IL0O0BNDou9NicW--

--------------zIaq0P7IPvJnHIYY3CF6PHCq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpy9I4FAwAAAAAACgkQqh6bcSY5nkZ+
jg//TDOanvt/A9gGTk0h7owEswwQHHG9OnM1Yor+j30JGs6PhCJorzncHlzBWEeG3acmhnmkBJwM
7e2t7CJadcEYxXd0/YQ70gUlJNLy30mzF+9D9JxdFky6MW+jqpS0k6WyREzjF3W9a9aCqM1jl7iD
8gQEME5dVGzSAY1eoV4nzlAt8g+M/ZPZyIIagcdwujAhCt2CCYaoGaon7DApD07yhbH5lrisQ1AV
T75XDWHRKoW0rWBRXQ2Bsx8FMgiUatvwaLJdWLvYyAmZ/Zvx7UvFL1zl/jcTgEevoPNCUlIAxy8d
sbGDvA3ep0S9jLuWWRQMnCtGTEblkQHYpFAEf5cvdDYNFnHQjDuHlWClAYToqk1J1x4XkC+Ct4KF
PL8ASCGAEsBhO4BD9hgUAqm/jc8m+RNdpmXBdCKd9G2asVcPx86M03sYUCSETEoDojVyGsnQkULi
r32fQ3JkY8V3/eYgNAdipYoVExrdfLqXEa3ZPoowz57oyayJ0W4ulULeuUhM3uWx2II8gcZiZIzo
GUfXo70FwgZWmKWHY9bqkZ42ruOm4VYoirCAG5GzyVk8kZPJExL0nwpajPE2LR/2MCaRAbsjF1aK
rIOst5e91/Tc1Ao+Dbz5OIHq9VmgYyAP25OMBYL20fd6/twq/iUupJ77oyRTvmK8P9+Gsvsq747i
bFw=
=rUNm
-----END PGP SIGNATURE-----

--------------zIaq0P7IPvJnHIYY3CF6PHCq--
