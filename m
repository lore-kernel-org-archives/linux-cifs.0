Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072B11711
	for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 03:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726716865; cv=none; b=PzSvLJjmqaUHgNvlDtaWJTE6FCHsMeCW061Z/ECogDbWU4JHH0t2ReL792oI+e9egRjzt4qx2FSdYtBp7kUIUA11Xt/XEYLsaph9bGAtzSLwMdV5PXkfYGq90DyzGS12htrD6kV0MbyxVBLm7tFJTztI+cjQqiWxh+RQHO7LeKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726716865; c=relaxed/simple;
	bh=ttCH+6bLlG0OGmG5FytRHaZdrMO/O7hOWPg0mtGuG1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PdemDJAwUUPIdMmF8icRtwU7/fbXG75BjY0zIbR6ToBft3f6jtn/gMJcRBB25XuRbIvi20s20BibYIcyZI77Kx11LKoQ3XnY0sj5xGNqO0RJ+wXEHCDRfB8ccCOzzxWkctS5Sq7Oq+4AQl6KyPIjahRaMNlIT2nZg9u4wN7SrXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uyGclpi2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uyGclpi2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=ttCH+6bLlG0OGmG5FytRHaZdrMO/O7hOWPg0mtGuG1o=; b=uyGclpi2NQOPk3eaHJ2TwA2Sbz
	HQJV5ZpOwslFfN8mNyMIxcJFJiUOvQE4DYsv5a/AvVXg7nfabuX2C8FcNKQZi3n097gjYj4IeVTa7
	GtuwHUOOCln7lENHL7Thkt6uryBc1r8COmHzTpxhQBpmogiT2r15qMZqLlyuoMXzLe/W5XoAWdyeT
	2kpJj80Mek5AD262nYc9djE6tQ5ecCWzEq/yZr5HOjSVDFoGOXY1hvJmHUFfmJKCFjPrcmi2moGwg
	soclgmM9gxy8rccvuxtofrgv9p/5EnLqc18F1RTXyyWr89OIEMDkan2ZxsglBaj8gUEYtdPNmpJb8
	11Nrtnk9iBLTTTLjOXpcNiFyQO3ZQnzywE4+wkAwqXtnG3PM9/AnVZzeRwl2fC3GT94jj8pTMjyGB
	DjJJqXxbLbN4rBq8sPfYa0Ov5qEbn4Ll8D+iwWzBbpyXwdke0Rz24L48J+GpyyWpjSw1LXZG4Tn0X
	yK45VOby1i98CEJ0que+ykrd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sr7vq-000q67-0g;
	Thu, 19 Sep 2024 03:34:14 +0000
Message-ID: <4d0749a2-17ee-4774-abed-c2d12d61cedf@samba.org>
Date: Thu, 19 Sep 2024 05:34:10 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Network discovery of nearby Samba servers
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5muLs97YW12d1C4TWS4wHF-mbphVJCqzVe9LBNE6iYLPKQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5muLs97YW12d1C4TWS4wHF-mbphVJCqzVe9LBNE6iYLPKQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------XuMVEsmwYnbiPwSl0psLs7LP"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------XuMVEsmwYnbiPwSl0psLs7LP
Content-Type: multipart/mixed; boundary="------------b2G5Ybgcopa6txoTWX0yXGmt";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <4d0749a2-17ee-4774-abed-c2d12d61cedf@samba.org>
Subject: Re: Network discovery of nearby Samba servers
References: <CAH2r5muLs97YW12d1C4TWS4wHF-mbphVJCqzVe9LBNE6iYLPKQ@mail.gmail.com>
In-Reply-To: <CAH2r5muLs97YW12d1C4TWS4wHF-mbphVJCqzVe9LBNE6iYLPKQ@mail.gmail.com>

--------------b2G5Ybgcopa6txoTWX0yXGmt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xOS8yNCAzOjUwIEFNLCBTdGV2ZSBGcmVuY2ggdmlhIHNhbWJhLXRlY2huaWNhbCB3
cm90ZToNCj4gVG9kYXkgZHVyaW5nIG9uZSBvZiB0aGUgcHJlc2VudGF0aW9ucyBhdCBTREMs
IHRoZSBBcHBsZSBkZXZlbG9wZXJzDQo+IG1lbnRpb25lZCBhIHRvb2wgY2FsbGVkICJCb25q
b3VyIiAoIkF2YWhpIiBpbiBMaW51eCkgdGhhdCBpcyB1c2VkIHRvDQo+IGZpbmQgbmVhcmJ5
IGZpbGUgc2VydmVycyB0byBtb3VudCB0by4gICBJcyB0aGlzIChBdmFoaSkgcG9zc2libGUg
Zm9yDQo+IHVzIHRvIHVzZSBmcm9tIExpbnV4IHRvIGZpbmQgbmVhcmJ5IFNhbWJhIHNlcnZl
cnMgdG8gbW91bnQgdG8/ICBJDQo+IGNvdWxkbid0IGZpbmQgaW5zdHJ1Y3Rpb25zIG9uIGhv
dyB0byBzZXR1cCBTYW1iYSBmb3IgdGhpcy4NCg0KdGhlIHByb3RvY29sIGlzIG1ETlMsIEF2
YWhpIGlzIHRoZSBtYWluIGltcGxlbWVudGF0aW9uIG9uIExpbnV4LiBTYW1iYSANCnN1cHBv
cnRzIGl0IGlzIHNpbmNlLCB3ZWxsLCBmb3JldmVyLiBNYWMgc2VydmVycyBhbmQgY2xpZW50
cyB3aWxsIGFsc28gDQp1c2UgaXQuIFVuZm9ydHVuYXRlbHkgTVMgaW52ZW50ZWQgdGhlaXIg
b3duIHNoaXQgZm9yIHRoZSBzYW1lIHB1cnBvc2UuDQoNCi1zbG93DQo=

--------------b2G5Ybgcopa6txoTWX0yXGmt--

--------------XuMVEsmwYnbiPwSl0psLs7LP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmbrm7MFAwAAAAAACgkQqh6bcSY5nkYw
BA/9F8VyLroJ2zu+6Z+0EMZ1j0dTIhdW/w0BKSaEySXdrgMh/uXFuIEDrMrE5162GDV+tfuyOJlw
epOTvJKblwP21+vN5xexhGvh+6u8X8YO9KPyzCOopTQondj+Thdn7wCZDcJhl7IA+JRtn2hyinFx
c5g/3Tb4sUVVTKlXFRX9b6Dm5SyBFbEueiDfEtfh33Kypy+jcSpYPdZa/+YIzWn8HdKg1jxUdvSO
DXah7UP5UTbf5F+1XY1lAJEi87uiaQtKQLyeBN7RPpmQglK3iOW1MImliOKb6XO8GSy42+0c36Dl
nJpXuegHdP0zDFms2UpwFJir2XMw3mHd71tCg73Rz2eI6TxDglJYzUvaRSDrKjHbTlas6spgqo4k
QPWQNjdu9oUO8HKUA1ftS2HtLx/0sAWn3kDPv/Bfxn/ks4XgpN7J99aVCkkUNgfYKuwGcCEsuFBO
Xv80lCyh2m+sLnwyD/BFEeIh2/24coAulXJwW1EI7sJqxjuRVFpdOs9s4uP0PstgHT+tYYjV9tZl
rNZrLNIbVBNaxhCChxcpBIcEG/ZLP68cXXyBV/BmRAbfB1baooWuDoXnWZQCuvFSS798sIqGAwjI
nmjeInjE0xI3oA5wdCjpOckdQUUvJw9f7scchT0annPoOJolRjk50hPEnEh1rNnERszcaEiDB/gz
kqM=
=8Svm
-----END PGP SIGNATURE-----

--------------XuMVEsmwYnbiPwSl0psLs7LP--
