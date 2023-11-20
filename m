Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eBmWz9cT"
X-Greylist: delayed 2162 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Nov 2023 22:25:14 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8081D7
	for <linux-cifs@vger.kernel.org>; Sun, 19 Nov 2023 22:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=AQDh42dfgAhzP6VLnzcy1sjUyeAtmk2oSjnusNkg7zw=; b=eBmWz9cT857mQ4P2PCW8SANlp6
	CBBRc/gRs2yEg61a2972KvyJafTKuQwZPW2XqP24JKu7TcxZK840Sg8v3C3b2cANIZyABgZZVL56H
	3xH/6ng48+x/nu7EXyPGz3vQSyJvWI45fBuiDO50xYwqyUyXvxqeJJv9hCLHFCk+cNosjEehDtY8h
	78vUQMLvmibNWmp/o/xdOu9qrho8mYALbSHN/LEOVc/DWfpopDrsCg45rZIKNygnNnvqs4lW/X4jl
	gJMlXaPZtTuansIpp9GiofdKmcTV0qTC+n5F1lFbY+rRvK0GmckVFqnsyAMTgp8KuErnoQKvocW2W
	0PRx1qJi9waNJwjyfv2L7rwMz6nxVd0qGKmpOXu8exwW7J39lyNqNDZKoVd5pDiCvmV3M0S7kTVod
	AzY7rtVBvpP76krP7IV7jvSANWwNbxPtZCuQet5A2Bw03n7/HkpO1bkNzC8MpudsS/vDuldDabrJX
	TlgRN3YDg8blDxNuxLPQB8bl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1r4x9i-00751e-1F;
	Mon, 20 Nov 2023 05:49:10 +0000
Message-ID: <ebade998-7c7e-422f-a1fe-680571b1310e@samba.org>
Date: Mon, 20 Nov 2023 06:49:09 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] smb: client: set correct file type from NFS
 reparse points
Content-Language: en-US, de-DE
To: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231119214450.23779-1-pc@manguebit.com>
 <20231119214450.23779-3-pc@manguebit.com>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 t71EGDetLzTlZf4K3t3SwQ==
In-Reply-To: <20231119214450.23779-3-pc@manguebit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------AAWQQE3BmVWdpouOO0eYKILI"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------AAWQQE3BmVWdpouOO0eYKILI
Content-Type: multipart/mixed; boundary="------------XyqA3Vu7R6ipRHxAAHNP2ktw";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Message-ID: <ebade998-7c7e-422f-a1fe-680571b1310e@samba.org>
Subject: Re: [PATCH v2 3/3] smb: client: set correct file type from NFS
 reparse points
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231119214450.23779-1-pc@manguebit.com>
 <20231119214450.23779-3-pc@manguebit.com>
In-Reply-To: <20231119214450.23779-3-pc@manguebit.com>

--------------XyqA3Vu7R6ipRHxAAHNP2ktw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgUGF1bG8sDQoNCk9uIDExLzE5LzIzIDIyOjQ0LCBQYXVsbyBBbGNhbnRhcmEgd3JvdGU6
DQo+IEhhbmRsZSBhbGwgZmlsZSB0eXBlcyBpbiBORlMgcmVwYXJzZSBwb2ludHMgYXMgc3Bl
Y2lmaWVkIGluIE1TLUZTQ0MNCj4gMi4xLjIuNiBOZXR3b3JrIEZpbGUgU3lzdGVtIChORlMp
IFJlcGFyc2UgRGF0YSBCdWZmZXIuDQo+IA0KPiBUaGUgY2xpZW50IGlzIG5vdyBhYmxlIHRv
IHNldCBhbGwgZmlsZSB0eXBlcyBiYXNlZCBvbiB0aGUgcGFyc2VkIE5GUw0KPiByZXBhcnNl
IHBvaW50LCB3aGljaCB1c2VkIHRvIHN1cHBvcnQgb25seSBzeW1saW5rcy4gIFRoaXMgd29y
a3MgZm9yDQo+IFNNQjErLg0KYW55IHBsYW5zIHRvIGFsc28gaW1wbGVtZW50IHRoaXMgZm9y
IFNNQjMgVU5JWCBFeHRlbnNpb25zPw0KDQpDaGVlcnMhDQotc2xvdw0K

--------------XyqA3Vu7R6ipRHxAAHNP2ktw--

--------------AAWQQE3BmVWdpouOO0eYKILI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmVa81UFAwAAAAAACgkQqh6bcSY5nkbC
uA/+KRi3YiIqNzITxycqEi/2QxnMhhE/cdTKuuQjhv673p136TatD3v9HhHsY5t07b+UAP4rIiad
SfeLBAiZON58KlpQ+i5ko95q9eu4lTOAqGp/c2VwgLdSaNO/fv25pAQXHPyJPXKH9fnUwhjb1BWk
hpsXKGNXeHBks92C87rEKCdogtP7N6PrJIxoWjTR1X0xZSfVrY/m8zMVlE/hPLLoLtyZlx7kMvTw
s5lagNlsXFQapi5LQ/dlNR2w/CZCuFpX/u6EE4uVVEe7HJWCWj0Nx6eD1G1zBQpFVRtZ58xOX/sE
WoWN/qScC1Wrsh9WifvCbPalmIWbuN2LA/CHSlrPTXBEQPasC8XH7SLy5aTtZ2ZUKKvVcnkwNG1V
zqEp+0Y49vqPtgdls336SmFy20fCgDlJ060OJtLI8CoA8ieeEFRICWDFyISkZkAM3iV+BRxM/0Xd
s/j7YT+Ky54F4uyZHFEeXviranDr1DyhQFq+j0yAO05KHPnd3tTGS91x2794heBR65Jd0jYG/XgQ
PLr5cAB1l0y3wt0QLI15xPScKyYFeKb6HqUXlECibhd74U3qBfgR1JaTUYV+kGcOhrCqrMget/2C
SflgT0hgcl8d5RF1ocXrATetPM+fDdO/lXaUhW1jiW7EbSVFx8BSKvklG7ifKMbqRnPatu7jEJ/T
7qE=
=oZ6q
-----END PGP SIGNATURE-----

--------------AAWQQE3BmVWdpouOO0eYKILI--
