Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF321DFE12
	for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748263164; cv=none; b=LKIjkiwEGxiBMo6JUGeebr4LsqyYGvIl06Q9e9bNZsVDrwkcmSI7dVXdrVGBoKzLBcGpOCQ4Rs3PqsQ8Orh5QZqwDHd+qZIAlIUVnbZynCmzYykXwmk5zKk7svqUhbRASzbm8aV+88dddhXtzgwmmvylNTJxDjhTfa8oFGdgkN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748263164; c=relaxed/simple;
	bh=suOHwoMLc0kObM/fglxADRqfgxfqsJQJaSM5dTiLxAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VqF4D+3QrJAyVjEHn0o93IxzSfzrz8Yjq1fmJNL0w9i1Xs/Tg7HMAaakv4VKDaMeYRPLryKPZy3b3Nbcf0x17JPBvUQEraIsfY4jQnx0SXM2UBd7q/k6910vtgK4n7+8UjumpsJKIi/fiNsBs7ZfZMpBWj04PrqcBvNKfqOwJRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=afxstW1S; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="afxstW1S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=suOHwoMLc0kObM/fglxADRqfgxfqsJQJaSM5dTiLxAs=; b=afxstW1S8ecuOTzGdjIFlD38qw
	dZX/eLAXQrLWasrX5KgEdYPYns0uNUB+yiIFCs84Dbh4f48pRCYwNnCw76C/dvAAyeTfaK+A78ttj
	tdlugcoVuyMJq4YZjiRNglWe1DKtDhEFWG9VrkkW3InOuuGKvO8sQrJ91AxuS8Fz0kuZT+VDlSJwZ
	s5waSTjN01ZVoxfxdnC3PWuulLDDeXO8j3627js9+YhJVlnuJH/fhS+NPnODJuKKai/6vP04b5Tna
	gx+OuqKDk/yVfVtyoDQEKvI7jZ4on8s/iEqlE04WzYD/J/TBRmn17M4zj0eOcow3RGafCKh6ZQ8Qw
	nR3N1rtD0DBMpPbvMOZlurraiI/MveHfEDwQdKeAZKzsuQtu5nveOzzggB5WcLxhxhTk1M7z1LLKR
	N3v6b8dslogto+Y+y85y1iiPnyYh/llOJiu+vCJzHXV0hNgOo8Gs/EOabGvgUaa9KsdCD+IxFSMFS
	7u6OaRbZ+hcPSj4Usfkj/jt/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJX6n-007KTG-0f;
	Mon, 26 May 2025 12:39:13 +0000
Message-ID: <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
Date: Mon, 26 May 2025 14:39:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd and special characters in file names
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------sz0SFVd4yYQ1OuDM102Vd8Z0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------sz0SFVd4yYQ1OuDM102Vd8Z0
Content-Type: multipart/mixed; boundary="------------3olz3oQWckX0QQnCLFkZ398l";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org
Message-ID: <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
Subject: Re: ksmbd and special characters in file names
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
In-Reply-To: <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>

--------------3olz3oQWckX0QQnCLFkZ398l
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8yNi8yNSAxOjM3IFBNLCBOYW1qYWUgSmVvbiB3cm90ZToNCj4gT24gTW9uLCBNYXkg
MjYsIDIwMjUgYXQgNzo0NeKAr0FNIFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29t
PiB3cm90ZToNCj4+IElmIHRoZSBQT1NJWC9MaW51eCBjb250ZXh0IGlzIGluY2x1ZGVkIGlu
IHRoZSBTTUIzLjEuMSBvcGVuIHRoZW4gd2UNCj4+IG1vdW50ZWQgd2l0aCAoImxpbnV4IiBv
ciAicG9zaXgiKQ0KPiBTdWNoIGEgY29udGV4dCBjb3VsZCBiZSBjcmVhdGVkIGluIHNtYjJf
Y3JlYXRlIGNvbnRleHQgbGlrZSBhcHBsZSBjb250ZXh0KEFBUEwpLg0KPiBIb3dldmVyLCBJ
IHdvbmRlciBpZiB0aGVyZSBpcyBhbnkgcGxhbiB0byBhZGQgaXQgdG8gU01CMy4xLjEgcG9z
aXgNCj4gZXh0ZW5zaW9uIHNwZWNpZmljYXRpb24uDQpJdCdzIGJlZW4gcGFydCBvZiB0aGUg
c3BlYyBzaW5jZSB0aGUgYmVnaW5uaW5nLiBZb3UgY2FuIGZpbmQgaXQgaGVyZToNCg0KaHR0
cHM6Ly9naXRsYWIuY29tL3NhbWJhLXRlYW0vc21iMy1wb3NpeC1zcGVjLy0vcmVsZWFzZXMN
Cg0KUE9TSVgtU01CMiAyLjIuMTMuMi4xNiBTTUIyX0NSRUFURV9QT1NJWF9DT05URVhUDQo=


--------------3olz3oQWckX0QQnCLFkZ398l--

--------------sz0SFVd4yYQ1OuDM102Vd8Z0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmg0YO8FAwAAAAAACgkQqh6bcSY5nkbQ
yg//ZWDnzvI+vaIbfBesxtqDMoLvm7DU3qaKd+aE5Fd6MUfyL4pDP4qfLFbt/SbHYUV8kPgdsaYx
02aOiXqa0u/GeSL7oVT7vYhTzGOvVDWJrkx2PmzKuJyvm9fgwDK4hhuNg1r/nifPBxy7m1dFuQ8b
XsthUpCX+TL70Czf59TW0oNlI5MrFM4XcLDmKkik7QcQsBE0YlUnlHq4jFk6PmEc+Ud6LQChG8nO
UU0VfFD/S1IkdBrj5ZanItAhXM8Y9jOJsH99SWSqs5e1IOIwM7TOhjWl9hX00mkNvMnBnCV/79PY
BGLsf82kv2mEdqqHbLDhEak6cgmxADdMYoHE5bNEsD3qgc2L7DWpqvI+naK1FSTfO9f/c+cQkVt/
JhQVIcBvNCC6Cm7SNrxEb8SoXfF0OKi0btlM1g1oy04Ia24g1BC0Jolw23zW6CncEMn1l1UtnpXX
I0L/eY1mT7T6jYaz174jDCX/5AsHfnpFkBAt7wmmopyhkVY8AOt5Mz4zN5WSEBSa2Ax/aM+6FD9L
hHzdmG8+TjCttvThkFnKJdmdI928NkjuUrNAEPshts544DxQSPHC0D+kypm2Lnshg2ZPwNbAEpBR
nuqP79Eot9BKSK9Dt17/GvcyaCtSey5bwufGzSMNTndL+Ip35LyvY0SrLPVnty9zIbmdU3WVv14d
RpE=
=p7mm
-----END PGP SIGNATURE-----

--------------sz0SFVd4yYQ1OuDM102Vd8Z0--
