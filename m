Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242A280331;
	Mon, 20 Jul 2026 06:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784530676; cv=none; b=m2LC7e0CBZ8xKldEq7o9rpGQQ1lowe8zTh3pZfSHF/7EPOYaXVWxjvJUQnHDRg5WiLsGvpbvw9f/mC8AkALDB+rdy7LPovC6YB4X23a774frf5EWQmEaG1ClmHbFNSGna8OalRnI/ZFy7OBYVAAuzLQxmeZvh1qKsQIbgxCLvIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784530676; c=relaxed/simple;
	bh=H8i8dyTM2CiQ++f5gZNI2E1Ah2n6Z+rp78ZfyDHpV6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NfL8+MPH45TGDF8e7YxBeLh/uL5nmLQi0ubn8W7sK8OWYLjnyKAmHTdLMIJ7+EtszcHgJWp3Va8VWbLr4sMN+JwBp1FfQH6WUIF7heHreQ0qM4CO+JCs6PlDZRv8GLM4L6XxqlTAglF8DFDbeA0p5eeQSpS8V1qy0bx7Wh3XmFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WDq++Kep; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WDq++Kep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=H8i8dyTM2CiQ++f5gZNI2E1Ah2n6Z+rp78ZfyDHpV6c=; b=WDq++Kep4ITKvqNU52DzOO1EtW
	EFCSS2t+lHr1oOCwpF775yZdQV17oEHDudzAEBrO5fLYhIKK4mZqlIll5wu56aXLrFzB7UJnEly4w
	zxiPUXVEGMaWzwDbLwOhebUKdlT91fIEWyr4OTtC5s+/xmlxhnTwo6uC958UNIuEEUv0wQ48uIG3l
	W4FYM3UwB9eGIHVB+p0iYSJumbwP0vNyb6CV7S2twZf1PZTzvgR7wDDBtIC5ZitTVk1ntO8bqlB0H
	0CLdkaiWBxzVfMkGTYu3+SFlgLS8ECqXQj3ifkop59xIuD6n4eXLe1EIRlDJ4oGZOkJJQ6YZwC43f
	YFgAus0YTR8oGmQ9ebbTefaJbFuXbiPc8wioyIbRdWuSrLAI0Or7CWj+GguJ0VT/jagHgSZb2rIoG
	USSOfzmU8/0rZ1kA2pIhSutl19ACQDZj9pqm8nHoMPxJQKnUeE90UzGxmwRly4Gmj4tejUkCxGqwF
	Dnj2hqSAzeMH2hgUKIgg0hSy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wlhwe-000000061hO-1fwT;
	Mon, 20 Jul 2026 06:57:44 +0000
Message-ID: <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org>
Date: Mon, 20 Jul 2026 08:57:42 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
To: Ze Tan <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, sprasad@microsoft.com, tom@talpey.comm,
 senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <cover.1784258165.git.tanze@kylinos.cn>
 <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0AI0fWX0jKzWB6a9t5h4fT5a"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0AI0fWX0jKzWB6a9t5h4fT5a
Content-Type: multipart/mixed; boundary="------------R7b9F5r18AwwUcLT7esIOCyw";
 protected-headers="v1"; hp="clear"
Message-ID: <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org>
Date: Mon, 20 Jul 2026 08:57:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
To: Ze Tan <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, sprasad@microsoft.com, tom@talpey.comm,
 senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <cover.1784258165.git.tanze@kylinos.cn>
 <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>

--------------R7b9F5r18AwwUcLT7esIOCyw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8xNy8yNiA1OjM5IEFNLCBaZSBUYW4gd3JvdGU6DQo+ICtzdGF0aWMgYm9vbCBrc21i
ZF9pc19wb3NpeF9lYV9uYW1lKGNvbnN0IGNoYXIgKm5hbWUsIHNpemVfdCBuYW1lX2xlbikN
Cj4gK3sNCj4gKwlpZiAoa3NtYmRfaXNfc2VjdXJpdHlfY2FwYWJpbGl0eV9lYV9uYW1lKG5h
bWUsIG5hbWVfbGVuKSkNCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsNCj4gKwlyZXR1cm4gZmFs
c2U7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbnQga3NtYmRfbWFwX2VhX25hbWVfdG9feGF0
dHIoYm9vbCBwb3NpeF9leHRlbnNpb25zLA0KPiArCQkJCSAgICAgIGNvbnN0IGNoYXIgKmVh
X25hbWUsIHNpemVfdCBlYV9uYW1lX2xlbiwNCj4gKwkJCQkgICAgICBjaGFyICphdHRyX25h
bWUpDQo+ICt7DQo+ICsJaWYgKHBvc2l4X2V4dGVuc2lvbnMgJiYNCj4gKwkgICAga3NtYmRf
aXNfcG9zaXhfZWFfbmFtZShlYV9uYW1lLCBlYV9uYW1lX2xlbikpIHsNCg0Kd2h5IHRoZSBj
aGVjayBmb3IgYWxsb3dlZCBuYW1lc3BhY2VzIHZpYSBrc21iZF9pc19wb3NpeF9lYV9uYW1l
KCkgYXQgYWxsIA0KYW5kIG5vdCBqdXN0IHBhc3MgdGhyb3VnaCB3aGF0ZXZlciB0aGUgY2xp
ZW50IHNlbmRzIHVzLCBwYXNzIGl0IGRvd24gYW5kIA0KbGV0IHRoZSB4YXR0ciBzdWJzeXN0
ZW0gZGVhbCB3aXRoIGl0Pw0KDQpTdGlsbCB3cmFwcGluZyBteSBoZWFkIGFyb3VuZCB0aGlz
IHNvIEkgbWlnaHQgYmUgbWlzc2luZyBzb21ldGhpbmcgDQpvYnZpb3VzLiA6KQ0KDQpUaGFu
a3MhDQotc2xvdw0K

--------------R7b9F5r18AwwUcLT7esIOCyw--

--------------0AI0fWX0jKzWB6a9t5h4fT5a
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpdxuYFAwAAAAAACgkQqh6bcSY5nkbj
iQ//f5PwnqJKZ98At3MGhqMb/NCSXnnEk785RIKWfsiZW/YmGYcqe7VvMd9NtYSwam/rY/sDqhF+
tIwwyXbMGNg93jnzc2T+7mjcHx8wDQnnhST4pyD+zcgvveADaQUzbY5HSj3kVgq2FZ8ZNqA/3lS3
34Z6cFFCi6fIjHv88gxwRPq40EhnRu6kuJBvIYXARfX7IBwHjh7TlSIdkRGiMXXhOh9JSriDkdHa
/8oVDmozfJB6jX0WqI4y4FmFXJN6QZUmw/wrRCrarlKazV6/NYDlTiMHidgL4ZKu8sxECjgNrHod
p/vHzM/cd8SzV+nMZWd0BuAkK/gAkKImHmnYipvQR+ks/Tx5AuuL+TgFOl8ihFOENW427Ee4VnIG
EoBUqAc6n/8pfWkQEfT3ovTu6KElH3UnioCp49WM/hEM+lhcmaWclldx+70YCm/ZxLlxaCU1Jmoa
tFPM+yMTvPKbkMz3ZyiDjppSwMfDoY7ya9TFFDjDzz75dJdQrP96ek45P9zKZNJXcVYMb+IImeUA
P4Q6rCgX6GCdltDWsKQZbpuijtHT9IwrFgSxyPTXpVYNWmYMKLhCi75lEVH/OYxSqc9QouihdQym
KGW7d3E/wTfdnZ+7RgcppdbafE8PEaZpkpU+p3yDu12EZEcueuUGBMoQpMFqdHbwC01JGYd86q+M
kXw=
=wCTD
-----END PGP SIGNATURE-----

--------------0AI0fWX0jKzWB6a9t5h4fT5a--
