Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1nDj4GCC"
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6699E
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 02:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=2Jn15/k5vJP8pi0QTnlKuZQ4xKsocWVvfj3sw3t0KbY=; b=1nDj4GCC0pmA7hg9rzWW8WHRAX
	kQWLaoA0rUx/5lqWhjZuHslqTGNeIFSKTWXWeodZvI7tIHecggHBxIVoJ99y182yJyhjPzl0IkC2f
	+alcGxQRGa9qt4M2vAY374GOvO1PlYNhjpKZC6l5tCXqYvBFtK86yirmcgDmk6vQ/HfhnDc9vNHGw
	IApypVwzmtwLHjFoQxb3evblerUcx8FwTfFoHzpbYyjIgO4GQ04Z/UWlfppsU0IQqlMwIuT+5KUpL
	suTTqlpNvRRsaB1W18m4QVcq/tngHVBM38DJK865dzdSjIWTfUUlH/19sbUrfd9oXFC2FMXXhIiyN
	5rf75de1Ih5VtHvxwvcfelWb886vOUx5KUt+1wNU6fBt1YfDxWsVMqMusKwN3YpZb+Ts9g7DXe3IO
	gijcCnAMr4S6MfnHpprE4pUUmysZt24iRzAWChL9HD+z8FPMV3Z4DTLAE+vcYj/GTzWlCpsAnLeav
	cs+G5ATyTULotmZhdXHPpdpD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rASEp-0020K0-2h;
	Tue, 05 Dec 2023 10:01:12 +0000
Message-ID: <e20433c2-82e8-41e0-aa29-279dd64996fc@samba.org>
Date: Tue, 5 Dec 2023 11:01:10 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Name string of SMB2_CREATE_ALLOCATION_SIZE is AlSi or AISi ?
Content-Language: en-US, de-DE
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Interoperability Documentation Help <dochelp@microsoft.com>
References: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 t71EGDetLzTlZf4K3t3SwQ==
In-Reply-To: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0Tcmi1keqLPVSI8orUTJCmbG"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0Tcmi1keqLPVSI8orUTJCmbG
Content-Type: multipart/mixed; boundary="------------YViavzEWVlXIsEGAMA5oh6wH";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Interoperability Documentation Help <dochelp@microsoft.com>
Message-ID: <e20433c2-82e8-41e0-aa29-279dd64996fc@samba.org>
Subject: Re: Name string of SMB2_CREATE_ALLOCATION_SIZE is AlSi or AISi ?
References: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
In-Reply-To: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>

--------------YViavzEWVlXIsEGAMA5oh6wH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTIvNS8yMyAwODo0OCwgTmFtamFlIEplb24gdmlhIHNhbWJhLXRlY2huaWNhbCB3cm90
ZToNCj4gSSBmb3VuZCB0aGF0IG5hbWUgc3RyaW5ncyBvZiBTTUIyX0NSRUFURV9BTExPQ0FU
SU9OX1NJWkUgYXJlIGRpZmZlcmVudA0KPiBiZXR3ZWVuIHNhbWJhIGFuZCBjaWZzL2tzbWJk
IGxpa2UgdGhlIGZvbGxvd2luZy4gSW4gdGhlIE1TLVNNQjINCj4gc3BlY2lmaWNhdGlvbiwg
dGhlIG5hbWUgb2YgU01CMl9DUkVBVEVfQUxMT0NBVElPTl9TSVpFIGlzIGRlZmluZWQgYXMN
Cj4gQUlTaS4NCj4gSXMgaXQgYSB0eXBvIGluIHRoZSBzcGVjaWZpY2F0aW9uIG9yIGlzIHNh
bWJhIGRlZmluaW5nIGl0IGluY29ycmVjdGx5Pw0KPiANCj4gc2FtYmEtNC4xOS4yL2xpYmNs
aS9zbWIvc21iMl9jb25zdGFudHMuaCA6DQo+ICNkZWZpbmUgU01CMl9DUkVBVEVfVEFHX0FM
U0kgIkFsU2kiDQo+IA0KPiAvZnMvc21iL2NvbW1vbi9zbWIycGR1LmggOg0KPiAjZGVmaW5l
IFNNQjJfQ1JFQVRFX0FMTE9DQVRJT05fU0laRSAgICAgICAgICAgICAiQUlTaSINCg0KbG9v
a3MgbGlrZSBhIGJ1ZyBpbiBNUy1TTUIyOiB0aGV5IGhhdmUgdGhlIHZhbHVlIGFzIDB4NDE2
YzUzNjksIHdoaWNoIGlzIA0KIkFsU2kiLCB3aXRoIGFuICJsIiBsaWtlIGluICJsImFrZS4N
Cg0KQWRkaW5nIGRvY2hlbHAgdG8gY2MuDQoNCkBkb2NoZWxwOiBsb29rcyBsaWtlIHlvdSBo
YXZlIGEgc21hbGwgYnVnIGluIE1TLVNNQjIuIDopDQoNCi1zbG93DQo=

--------------YViavzEWVlXIsEGAMA5oh6wH--

--------------0Tcmi1keqLPVSI8orUTJCmbG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmVu9OcFAwAAAAAACgkQqh6bcSY5nkaZ
Tg/8Ds0JqAU0mHbt+Ad3o6axSBHX8zIzOav48aTvwzviwIsn4qcjWRZ9Rb6cLBjaHBQzphzjrN+g
geEmJ7LruDi3L3crIlrV6f5jlKikvePih0W8Q+JW/7hjcQLc+fk0Xw/lmjk1OP6ifmq1NJNuByLh
4e0/rsxjhvjl/jqOeFop5Ap+DLqh7Dxjf8EP7JYvVOq7/T3g6Hkg5ZTi9GAFEGzUd/Op3GAlsnwG
Dg5hD92tkXGH+WVDghd0vrZxNe5TG3fpf434WsoffustKAjUj2Gi4uSWX3tLQcEuxh93hYgpslj7
H3BLzniMXx0tJrD0sTdaE70249+hPkZnaKNzrG7oVRItFR/9ZByTHRfrtij2zAgzhSZewj9PfetR
J4GpR8NOa04CtcTI+rPlOaCbc7QQYNfU0vPFornd48z8DdQR87Q6dAmeUxlOjKZv/rrR+7c+w0dF
BF+jKe0JicBBglNZl2jKdZqg0kOrL6MdxscmaxKLoDV/ZHgUmfN/Kn5lSxruIBxypmVKeiOvrwvp
zyZO4rOe+wpLIhn4/tTBCD5KyinCCx6XFuXeGUyiCaAvVxs/scbSatUfVhjnWdFxyeh47a2XUtEI
XojzbMttoYmjWn0RgsixaVxkIH7Kyy3tud0zWSJDnRYHInTQRT4TxOxDr+F9RHrTw12Akm/heRD9
/dY=
=zTcv
-----END PGP SIGNATURE-----

--------------0Tcmi1keqLPVSI8orUTJCmbG--
