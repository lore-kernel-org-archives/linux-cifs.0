Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C832399003
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785958529; cv=none; b=qdhgO7G1/RuZTB/Kg7JwHLQ3q6Zel/wHlIEyCa54Qu8SnH6t2LVMdWYFjTomaTRGORDmUDELnHHtwYpse1nps1zEFidJ7DoodFkHq+XyQ8t7gpZVrTh36IHBlXZtXTyU99z67afC1GCGnGokWRpfrvOux+6fkFLKBDo7qrg6LOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785958529; c=relaxed/simple;
	bh=Ng9g+sZm68B3eedUCA65Ga6DDofgkQx8PzcZUCyYa+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I6VjdMPEc7qUvunuh6YFXkv8y6B/v1ci7JtX/iAvPLd2DocuStghGuhScv0zEbD6Vzoh0JcpJ9+gm4MOp312ttrfr8G0/6Arytr74KbNbiAcA6EgKZWdwL9JFYzl4x1R+8NewNjAxmxiIUVbFVlVesSIZy0XWKtaikpgZEQ+oQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=R5Ifr2k/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="R5Ifr2k/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Ng9g+sZm68B3eedUCA65Ga6DDofgkQx8PzcZUCyYa+4=; b=R5Ifr2k/WYrbg76J+RQ1IrYYRG
	q4okelKy7zqIBs/jCDBPo47g3ZV6DRz6iLPiMHlIhoBUNB0Gk6TOdx6LqVgwg1I8QitMCbWZDMmiT
	3u57GBXghYvBD6/Hi72cGp+dYAkJd76LQG+41cOZuDYIR9Z1zvVULRYV9asKfzkM3siPUtzAneTAm
	v1uToRHNH+KoMtXSdukPQjXoR+j9bBn9SrrzmORxH/vKYgGvWQT9Ny20CsfPwmv32fj1euACUt5GJ
	gHW2G9clp52Ic1az6pXvYPuSBMA7LXGhKBIW1J4EeYUaNQY0KdI070AYqgV7rBK2py8mcGS2ryV4J
	ozNPz1oge37aiGK6CyQ/SFK4irzNNGFgIYOeWlm7UfIiqExOi5wyKJW0aK63jJ/lrGjrEGXrBGcYz
	tebUk51Ap7CcxedMeG1AFK8LLuUynYcF6+6q6xUH246EDWi4bn6I8ov1OTDjoMI69lVSbVKwqqLU4
	95RQovNO8ZUvSyJ8f2XbXiIG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wrhOQ-00000002yXz-2yZS;
	Wed, 05 Aug 2026 19:35:12 +0000
Message-ID: <75b978b8-65dd-43ad-b98d-10ec11f5cff6@samba.org>
Date: Wed, 5 Aug 2026 21:35:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH samba] smbd: deny rename if the destination has
 non-POSIX opens
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, metze@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805133145.312198-1-chenxiaosong@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <20260805133145.312198-1-chenxiaosong@chenxiaosong.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------KBuEL7OfYkXKLfpgC0Uk0rX0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------KBuEL7OfYkXKLfpgC0Uk0rX0
Content-Type: multipart/mixed; boundary="------------1ObTU5dguczR6trRa1loX070";
 protected-headers="v1"; hp="clear"
Message-ID: <75b978b8-65dd-43ad-b98d-10ec11f5cff6@samba.org>
Date: Wed, 5 Aug 2026 21:35:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH samba] smbd: deny rename if the destination has
 non-POSIX opens
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, metze@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805133145.312198-1-chenxiaosong@chenxiaosong.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <20260805133145.312198-1-chenxiaosong@chenxiaosong.com>

--------------1ObTU5dguczR6trRa1loX070
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC81LzI2IDM6MzEgUE0sIENoZW5YaWFvU29uZyB3cm90ZToNCj4gRnJvbTogQ2hlblhp
YW9Tb25nIDxjaGVueGlhb3NvbmdAa3lsaW5vcy5jbj4NCj4gDQo+IENoZWNrIHRoZSBkZXN0
aW5hdGlvbiBzaGFyZSBtb2RlIGVudHJpZXMgd2l0aA0KPiBoYXNfb3RoZXJfbm9ucG9zaXhf
b3BlbnMoKSBiZWZvcmUgcmVwbGFjaW5nIGl0LCBhbmQgcmV0dXJuDQo+IE5UX1NUQVRVU19B
Q0NFU1NfREVOSUVEIGlmIGEgbm9uLVBPU0lYIG9wZW4gZXhpc3RzLg0KdGhhbmtzIGZvciBs
b29raW5nIGludG8gdGhpcyENCg0KSSdtIGFmcmFpZCB0aG91Z2ggdGhhdCB0aGUgaXNzdWUg
aXMgbW9yZSBzdWJ0bGUgdGhlbiBqdXN0IGFkanVzdGluZyB0aGUgDQpjaGVjayBpbiB0aGF0
IHBsYWNlLg0KDQpJbiBmYWN0LCBiYWNrIHdoZW4gSSBpbXBsZW1lbnRlZCBEaXJlY3Rvcnkg
TGVhc2VzLCBJIGFkZGVkIHRoZSBmdWxsIA0KbG9naWMgdG8gY2hlY2sgZm9yIG9wZW4gZmls
ZXMgYW5kIHBvc3NpYmxlIEgtbGVhc2VzIG9uIHRoZW0gb24NCi0gdGhlIHNyYyBvZiB0aGUg
cmVuYW1lDQotIGlpcmMgYWxzbyB0aGUgcGFyZW50IG9mIHRoZSBzcmMgb2YgdGhlIHJlbmFt
ZQ0KLSB0aGUgcGFyZW50IG9mIHRoZSBkc3QNCi0gYW5kIHRoZSBkc3QNCg0KQWxsIHRoYXQg
bG9naWMgbGl2ZXMgaW4gYSBmZXcgbGV2ZWxzIGF2b3ZlIHJlbmFtZV9pbnRlcm5hbHNfZnNw
KCkgaW5zaWRlIA0Kc21iZF9zbWIyX3NldGluZm9fbGVhc2VfYnJlYWtfY2hlY2soKS4NCg0K
VGhlIGZ1bmN0aW9uIHRoYXQgZGVhbHMgd2l0aCB0aGUgZHN0IGlzIA0Kc21iZF9zbWIyX3Nl
dGluZm9fcmVuYW1lX2RzdF9jaGVjaygpLiBUaGF0IG9uZSBhbHJlYWR5IGNvcnJlY3RseSB1
c2VzIA0KaGFzX290aGVyX25vbnBvc2l4X29wZW5zKCkgd2hpbGUgaG9sZGluZyBhIGxvY2sg
b24gdGhlIGxvY2tpbmcudGRiIA0KcmVjb3JkIG9mIHRoZSBkZXN0aW5hdGlvbi4NCg0KVGhl
IGNoZWNrIHdpdGggZmlsZXNfZm9yYWxsKCkgaW5zaWRlIHJlbmFtZV9pbnRlcm5hbHNfZnNw
KCkgaXMgYSBjbHV0Y2ggDQp0aGF0IGFscmVhZHkgY2hlY2sgZm9yIG9wZW5zIGluIHRoZSBz
YW1lIHByb2Nlc3MsIG5vdCBnbG9iYWxseS4gQW5kIHdlIA0KY2FuJ3QgZXhwYW5kIGl0IHRv
IGJlIGdsb2JhbCwgYXMgdGhhdCByZXF1aXJlcyB0YWtpbmcgdGhlIGxvY2sgb24gdGhlIA0K
bG9ja2luZy50ZGIgcmVjb3JkIHdoaWNoIGlzIHByb2hpYml0dGVkIGJ5IHRoZSBmYWN0IHRo
YXQgd2UgYWxyZWFkeSBoYXZlIA0KdGhlIGxjayBvbiB0aGUgc3JjIHdoZW4gcmVuYW1lX2lu
dGVybmFsc19mc3AoKSBpcyBjYWxsZWQuIExvY2tpbmcgdHdvIA0KcmVjb3JkcyBzaW11bHRh
bmVvdXNseSBpcyBub3QgYWxsb3dlZCBpbiBTYW1iYSwgYXMgaXQgY291bGQgbGVhZCB0byAN
CmRlYWRsb2Nrcy4NCg0KU28gSSBndWVzcyB0aGUgYmVzdCB3ZSBjYW4gZG8gaXMgcmVtb3Zl
IHRoZSByZWR1bmRhbnQgY2hlY2sgYWx0b2dldGhlciANCmZyb20gcmVuYW1lX2ludGVybmFs
c19mc3AoKSBhbmQgcmVseSBvbiB0aGUgY29ycmVjdCBsb2dpYyBmcm9tIA0Kc21iZF9zbWIy
X3NldGluZm9fbGVhc2VfYnJlYWtfY2hlY2soKS4gV2UgaGF2ZSB0byBsaXZlIHdpdGggdGhl
IHRvY3RvdSANCnJhY2Ugd2luZG93IGFueXdheSwgaXQganVzdCBlbmxhcmdlcyB0aGUgd2lu
ZG93IGEgYml0LCBidXQgb25seSBmb3IgdGhlIA0KY2FzZSBvZiBvcGVuIGZpbGVzIGJ5IHRo
ZSBzYW1lIGNsaWVudC4gT3BlbnMgZnJvbSBvdGhlciBjbGllbnRzLCBhcmUgbm90IA0KZGV0
ZWN0ZWQgYW55d2F5IGJ5IHRoZSBmaWxlc19mb3JhbGwoKSBhcyBzYWlkIGFib3ZlLg0K

--------------1ObTU5dguczR6trRa1loX070--

--------------KBuEL7OfYkXKLfpgC0Uk0rX0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpzkGwFAwAAAAAACgkQqh6bcSY5nkZK
hw//TkIhoVgz6LSB31TWpPqYtp2HDMwHLXyWCavU1oaACTPdLA9R+zoyLDdTVKPP9piJsjXC8/Cl
62rtbqWTIc4QngPlyomASS2fnbTTuc9Twk2Q04A4a5Cypz7OQtkbYIWtyD6LBZMMEIfv5+OZ+nQH
LVMRHjeASxZ5ySayERo0ReEu4IIG+bJqKMr/mxmJmD+X+iG+DvHV/U8EY+JS0vRAq54tTd4Yv0Xq
Yqs0SIj4+iAI/8TzMJ41gMfzzGSLxe78mhHDBshUbNSi9Z0ZWWQ5/1g8/jyQ5U1HdaWvTUrqFw8A
aDF0xV8TnK30pb1jxUyLWxL7UJNqItkdv/c+H6nY2JZF4J9WybJSL+FrUZRUsciQhOgbmb+JjReQ
/i67RO+fKVg0qoYPhv2eb/5VJKCiqC7MXOFcWX2H9qOR7n+3yVC3sLwxQ5XhKD8SUrZMp9omTkJY
BeLchKx0+h9qwNMqQEBjat9vxucAgzLebEaHd3MVivlnwqm1LzhTByAj25+0bxbEOCqXVb/PN8qK
bSHrqei3IKcFkl36laVd81cxCmm9wCT99pyfoir+TQAbSpjTSnlikTaAlvR2owrk/HK2HAc3csdq
TIET4eeKs+wLIa4HskTJ21f+ki/EKXgBf8up9UXJrx2KGA7lLhRcJuC05Jdr5zjEkWjXyGelRSQ7
O3o=
=2+j2
-----END PGP SIGNATURE-----

--------------KBuEL7OfYkXKLfpgC0Uk0rX0--
