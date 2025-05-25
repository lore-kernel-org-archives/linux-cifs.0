Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA891EF09B
	for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 10:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748168713; cv=none; b=Sg9hri9YlmDuWa27xbzIm867SCegI0P8pW0i9EfhEnDK86Pul6NZLYMxNyl2KZExAMMQQudoxdfAblUYlJncdK8F2+Upu0nF36gSsyBFz1/zNNyxsokJ19efYsdXB2cAAp4GQdI96E87H/3UIhM0xLYjhcZnQIwLot47T95MhLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748168713; c=relaxed/simple;
	bh=5a7ZSl/TJhu1pxGgraOtcAHPk9ih6BfOUtKxNksp3U4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OrU5J3ZYGYUQwUwaqcXm4gaK9nx3C5/tDt5x404zJGyhVyO+nQiTxqcBj/BJjnzyXAGgI/P332ypYJ0KqEbwtA6e/Ck6W+omhvWu34GGMYEdhngkbRZuBReZUL42BA33SrNpju5E9T0jl7g+eMieGw8dPdF1Gp3ZY91abYSqTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0V9x6duR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0V9x6duR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=5a7ZSl/TJhu1pxGgraOtcAHPk9ih6BfOUtKxNksp3U4=; b=0V9x6duRA0P9Sl1dLu94CqO6Ot
	rStmd6lB7sOasrNOg0G4kAf51vLqB50Y3FW9mk7PzvmEC8aS+CmOZ8drtSs5RlOsfJFsVLgNucnRC
	35j/ekwqICsxiuGOjUxL1rX24z4g25TRAeSiYRGTKFrLFwk2xNcpDS33ZGmqiBwplMSUuRBFAs2Fa
	PsYzGJBp1zsoVLo2s2KRiaFXWbxAXSd56+jD8dOI1VrKiO6+s9qe4hCv+h1D96hdnogRqpN/rkw4p
	W329ho6mZGK9RslnVMkus8a4uLJ+Ftl8YptTVCbjDi/gs6Q/8xZTsdbQpThlX+Yjohqg6uSaKzvAl
	LICLKks1bJoIzVkGtolj33UEoFZ+RY1AIV+cDErYRe+qUTIuYILY27Uw83kmcl1orLI1eOb9QXqck
	DRy/1r8QuYAMY6FGFK9eKaJvoAEbNdwZmQ0pJfm3I1RINMO74ECbyfiA9swZQYcPWBQk/yP8kyvNf
	Wasz6BQCPLWYMe5akwbfVgu7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJ8Lt-007AvA-2B;
	Sun, 25 May 2025 10:13:09 +0000
Message-ID: <debafa1b-90f2-4dec-a4ab-09adcd461583@samba.org>
Date: Sun, 25 May 2025 12:13:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd and special characters in file names
To: Steve French <smfrench@gmail.com>, Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org,
 samba-technical <samba-technical@lists.samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAH2r5mubXak1pe9N96wph5HtggFMAMpYm+5KtqYOz7e1cNGWhg@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mubXak1pe9N96wph5HtggFMAMpYm+5KtqYOz7e1cNGWhg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Gw4TmQqOL1O33JSSr7rK9K0x"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Gw4TmQqOL1O33JSSr7rK9K0x
Content-Type: multipart/mixed; boundary="------------40pBXXaygslm2JpWTjgDYlEP";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org,
 samba-technical <samba-technical@lists.samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <debafa1b-90f2-4dec-a4ab-09adcd461583@samba.org>
Subject: Re: ksmbd and special characters in file names
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAH2r5mubXak1pe9N96wph5HtggFMAMpYm+5KtqYOz7e1cNGWhg@mail.gmail.com>
In-Reply-To: <CAH2r5mubXak1pe9N96wph5HtggFMAMpYm+5KtqYOz7e1cNGWhg@mail.gmail.com>

--------------40pBXXaygslm2JpWTjgDYlEP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8yNS8yNSA0OjM5IEFNLCBTdGV2ZSBGcmVuY2ggdmlhIHNhbWJhLXRlY2huaWNhbCB3
cm90ZToNCj4gSW50ZXJlc3RpbmdseSB0cnlpbmcgdGhpcyB0byBTYW1iYSBJIGRvbid0IGhh
dmUgYW55IHByb2JsZW0gY3JlYXRpbmcNCj4gdGhlIGZpbGVzIHdpdGggdGhlIHJlc2VydmVk
IGNoYXJhY3RlcnMgb24gc21iMy4xLjEgbW91bnQgYnV0IFNhbWJhDQo+IHNlcnZlciByZXR1
cm5zIHRoZSBpbmNvcnJlY3QgZmlsZW5hbWUgaW4gdGhlIEZpbmQgKHF1ZXJ5IGRpcikNCj4g
cmVzcG9uc2UuIEl0IG1hbmdsZXMgdGhlIG5hbWVzIChlLmcuIHRvIEE3VjU1OH5ZKSBldmVu
IHdpdGggcG9zaXgNCj4gbW91bnRzIHdoaWNoIGxvb2tzIGluY29ycmVjdA0KDQpJJ3ZlIGZp
bGVkIGEgYnVnDQoNCmh0dHBzOi8vYnVnemlsbGEuc2FtYmEub3JnL3Nob3dfYnVnLmNnaT9p
ZD0xNTg2Mg0KDQphbmQgYXR0YWNoZWQgYSBXSVAgZml4LiBDYW4geW91IHRlc3QgaXQ/IEl0
J3Mgb24gdG9wIG9mIG1hc3Rlci4NCg0KLXNsb3cNCg==

--------------40pBXXaygslm2JpWTjgDYlEP--

--------------Gw4TmQqOL1O33JSSr7rK9K0x
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmgy7TQFAwAAAAAACgkQqh6bcSY5nkaL
gQ//RHfVHJiNCUTm0NpfnFPX2EuQ0g/wBRhgDJb9B5scTbaeXk9ZKU0DzFFQT+Z/X4fIl564G7x7
Opn8Y4uGLC3EGGCFh67LtOLLG3fxifWh0yuW22Blzx928I3KFBypbI//kn6ThYhu061EqhWBeoyI
qJSmDIq2H7iJDahjr8ZRIpfG2+WNeB2K6gf2+GhK6cjbMbImzdv2Y8lNBCdSvdPhRN+JW4oeYtJi
+W2vXaoN9+wadWsG2c/XpExuGT226pgMIORwy7vsFFdZOZzC/Rn0l5yVR/pIoftRTaAcUj0G2BzI
mK67SjGf5g2H/3fg1C801BcdSwGKAUp0OkUeKLgtC0wxFxqAf7hbM9oA1DMLu3svNJWLB4SAQDwg
TkU3DJzjkP7RvpSR7rup9FVXxCYQWiVPjTkRBRO6N1LBxVECY4c9B0YyCer9ZBYx3MJjiJDErXxh
dAIuUZzl53e9WbnVcvHdBPVGwVypARXHy7WZ7UywYvMX0FqUGMPZtdGZotOGG0L2X3JJ8MvgZxno
vpzd/JzgqFQd1vmoJKFI+TeecTThJYeA2RUpw5QupGRT+WUfpnx6xE7xA0GvNLJADxdEf3v/7UJ6
AbIB/0kMtd4YcT1mcVK8ewvda4UGQ7tmyY99Di2ZKwOiE1lBqewN+8sssHXXUgpmlKFVeiKiutUA
OUg=
=+Ht3
-----END PGP SIGNATURE-----

--------------Gw4TmQqOL1O33JSSr7rK9K0x--
