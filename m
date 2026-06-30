Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6DD3E9C31
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810609; cv=none; b=sukmHRKa700HyrLYYpOCfM5jzRITKJWlyU3L7Lj35ABypQd+nX0pAP4J8bE6bjfodNR/Av5vIT3Xuu8sT5GJvBSFSMC2BsZ40hMtSYtfewy9N5xdWtqu5OcgDWngAUyphj+iSH94m9UyAAAQpAjuqO0KcBiH6jT+6olUlvfwV9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810609; c=relaxed/simple;
	bh=Pl5JHwVRJPp0FR5bFiN7Fcd6Bao3rNBqGXqEclL94CY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sTFUNLOa8i5nj+eibGMdqj4OKWF20ltM6AIw3mpbSt6npIa1fgs6HwLboalBco0pq2EAFFcJwOkmV+N182V8orRamYuYUYnLkerhQ6E3D6yM2qDp189XoWX6IUMiSH9xf/diboCrc2HKy9YUmvPWPvovRz7ApxQ+ZIFwptLNQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OuHDUxK8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OuHDUxK8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=Pl5JHwVRJPp0FR5bFiN7Fcd6Bao3rNBqGXqEclL94CY=; b=OuHDUxK8fhYSIzuP4lv3PWyZnd
	DqQVBLQwgxBEmk5WrYzZJY4yNOLCaZ1pCl36f/WG4Z5xqEX/Ed9buo4ggPXkvoLlAA503r9XyPo/s
	PRvTjrW2bn0cP+Vmpu/xRWkJ9xweIFiycbAhlT0OX6ZMxl8Sc7OgdOCbzt7j3NtIiwJ9lDAb7gX1y
	jcDtAh8Vv4hSD2xr8zqh2iFURZq4qpzklR0CiLQtqFLjPIkhJzxm7B4j9Ghx9+PHfjRHykbPYc8BN
	2wVTSO4i3kCIl69zfR5Pr5ZFrKXl8ezi0aTbmPUz4zhzB3YPDBjGq/V3Ri/tjKzSerDhGzlkO13a5
	Mlaio4Yy6HvSIVyAwJQskW6a/HIRs81ZUGZ3DEBArDUVRfNNBJ8Ql2SF5BuupjmoAQwRxGm6t1rS1
	2F7uSMG5TWCFUBcjpcQast2UN3VbnhziOjs1NfqxAOMHgicq8L3MPs55dHc+Wo0efXBetAmHxAisC
	j7IewQOYXVc1DTL8JgMFNWZ/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1weUTf-00000000zSV-3YAb;
	Tue, 30 Jun 2026 09:09:59 +0000
Message-ID: <694ff16b-9f48-4837-aec7-ba965679dd8f@samba.org>
Date: Tue, 30 Jun 2026 11:09:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: SMB3 POSIX Specification (was: Latest posix extensions spec)
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS
 <linux-cifs@vger.kernel.org>, "samba@lists.samba.org"
 <samba@lists.samba.org>, samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mseJs38GECUG6dv6M+AL7Z1ZDp4k73-C2Wda3Krs2hOEg@mail.gmail.com>
 <CANT5p=quqzYD6YxCoGSb51W=AYeypWrTnZXRC03egqjXjjmeTg@mail.gmail.com>
 <c3eced4c-0360-470d-9add-7a249708f4dc@samba.org>
 <CAH2r5muK1ee-fyGiYKGmxGmo5ovvxem1+=YK0e1fyB3-dWaONQ@mail.gmail.com>
 <ab95aabc-8b7d-4022-bf74-1d4f451681d2@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <ab95aabc-8b7d-4022-bf74-1d4f451681d2@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rYaH5agFd3NkY3NaGx9kNVDQ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rYaH5agFd3NkY3NaGx9kNVDQ
Content-Type: multipart/mixed; boundary="------------FKgarqZ2QXbenioA5LVH2og5";
 protected-headers="v1"; hp="clear"
Message-ID: <694ff16b-9f48-4837-aec7-ba965679dd8f@samba.org>
Date: Tue, 30 Jun 2026 11:09:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: SMB3 POSIX Specification (was: Latest posix extensions spec)
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS
 <linux-cifs@vger.kernel.org>, "samba@lists.samba.org"
 <samba@lists.samba.org>, samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mseJs38GECUG6dv6M+AL7Z1ZDp4k73-C2Wda3Krs2hOEg@mail.gmail.com>
 <CANT5p=quqzYD6YxCoGSb51W=AYeypWrTnZXRC03egqjXjjmeTg@mail.gmail.com>
 <c3eced4c-0360-470d-9add-7a249708f4dc@samba.org>
 <CAH2r5muK1ee-fyGiYKGmxGmo5ovvxem1+=YK0e1fyB3-dWaONQ@mail.gmail.com>
 <ab95aabc-8b7d-4022-bf74-1d4f451681d2@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <ab95aabc-8b7d-4022-bf74-1d4f451681d2@samba.org>

--------------FKgarqZ2QXbenioA5LVH2og5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

K21haWxpbmcgbGlzdHMNCg0KQWxsIHRhc2tzIGNvbXBsZXRlZC4NCg0KV2Ugbm93IGhhdmUg
YSAxLjAuMCByZWxlYXNlIG9mIHRoZSBzcGVjLCB5YXkhDQoNCmh0dHBzOi8vc21iM3Bvc2l4
Lm9yZy8NCg0KLXNsb3cNCg0KT24gNi8yOS8yNiAxMDowMSBQTSwgUmFscGggQm9laG1lIHdy
b3RlOg0KPiBZZWFoLCB0aGF0J3MgYmV0dGVyLCB0aGFua3MhIEknbGwgYWRkIGl0IHRvbW9y
cm93IGFuZCB0aGVuIHdyYXAgDQo+IGV2ZXJ5dGhpbmcgdXAgaW50byBhIHJlbGVhc2UuDQo+
IA0K

--------------FKgarqZ2QXbenioA5LVH2og5--

--------------rYaH5agFd3NkY3NaGx9kNVDQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpDh+cFAwAAAAAACgkQqh6bcSY5nkZO
WhAAokY+Bk+TRi2R0BNFq06m7SJtnc2Rz8RVETcyFMXGGZIyrSCtCX1t16bbo3mT0H2ab02wGW99
cmyo4bdM8+yYnAhplWsy7n2DS6fpnI7RO5+0ca6WhxuuupNCXpALhPzBuselb01QSFRVjioOLl84
VPmiYfKWR86x2MJZfGtHtAkB/JUeVpEUS9xC4/pcJZXrjc2GTXfPoRt9zxJt+I0zroSY7XoVN0Bd
tS1BlJ3M0to8IMosgAwZ4NIJE3V4F2488Y+1UjEQvq8S+7HS3rLxGKsrQ3JFOLaj/rFIgBj1CQzz
W1zw3q4d2M3roX3TM5R5oN/KKA/yZwhN3unkFnyOMRJSBBiev0mX27sjH2GAxQHTnl0GwuCyycSm
Nibyte9LD0ZM4WW0ZLmU9+LoDuh+O8P/Sjv8kbksQ+10jdnhvGcCfIDPwN2w3H6EMrt5Gw8Ga8ld
B9XNN1PDON6nzDD/pzCw6CVyuJDzIRPDo/9SUNNbUbpvG5BvHi0V3s7zWC6GKR4Ld+0lUUOxgln1
aY/FHRSJDNzh7dxoZi6DWemI//9EugF7v7ygPq4pugtB5gVdxZaOuwxhZWvWWfgB3UlJwd8yA0DN
5v8pVJc0v3dI4l6mK1I5lw2U/XB1pf8j4j197escasSTd3A9jz/1QTMCniy9fkIvbv9OSJXVQc3A
73c=
=YIVX
-----END PGP SIGNATURE-----

--------------rYaH5agFd3NkY3NaGx9kNVDQ--
