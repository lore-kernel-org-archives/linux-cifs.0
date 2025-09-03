Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09739286D7B
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756914529; cv=none; b=jB/fQPVNiQk0poHBjCVQKm0vw97sB/DB5Bt64KGcumr22VsCqKqq238UUkRWiJdP1+wT/JBq48qeK7M4pdtlKuuNMe4MRDWycdyYQK6JY59XN9dXdIzTkyr5feY19YA7QP+6LjgK0rY8DbcTD505kBmbk2IsH0csKIKnKPmq5E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756914529; c=relaxed/simple;
	bh=99ewMKPJ0gG75qCVLXl1KnshjsdQ8d1sbQkbU3XXgGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pA4sTuafuNv0J7e+DKbgxF8ar6xq61mezpoRshLzlddYiiH9iVtxosvrF/1XYYeghufyUxowhRjJAcSZUUq5u6FQvGkof5Zq4JMr3Xo7Y4iXbzbOTad8A7kBZXj8GGuVEq/Tw4OUIKc67CVvWlfi1ys8Fbznk5InQbE/qqqq4xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Y4PeWRH7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Y4PeWRH7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=99ewMKPJ0gG75qCVLXl1KnshjsdQ8d1sbQkbU3XXgGU=; b=Y4PeWRH74G1EyuFB9JI+pkwG6D
	1ELc4Xtgl5pWDdV1mFdx/45xn0z5Nq2q/JBql98HDMdWlfKrula8ISSKQPz1L64hj9XmTGoD+bV1r
	Zt5+wROZsz19giISYXFvvaMdHJzmZRJFO98IkRkBAzchf9oNpF08UoY3r05EzXbkM5qjwn2AewWjo
	nBrbqMOUAXVIWnRNWqaBGmdPgVwt+kwtFw626d/OaIQokQcpTVimCE9XuIiBwVICtDg7jiAlq3I28
	r2DSPAUZQcnY+rAd/zH3yinGGW78i5F+km1mx6UlSU8H5xhv3bWGHfdEhdzpc58N2JlnsrLAjEYwc
	wZaLOwfr+1LAKeSIw8bCCQAxARLpg6hc4bDlnG2ex4V6WDWYCCb3AKaFagDHo364HKDz6haJKJeyh
	evRHmBnPzDeGsif+1W9g+nN8i2FYSmKpQzL45w5NKu164HcTDAsaHgGON3xo7ZKFVOxiZHyTOD07z
	34hVCS2bEf4/FkzIxyt/y/me;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1utpiw-002GuW-1q;
	Wed, 03 Sep 2025 15:48:38 +0000
Message-ID: <e2a50c26-42ad-4060-9da4-96f89517ee1b@samba.org>
Date: Wed, 3 Sep 2025 17:48:36 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>, Steve French <smfrench@gmail.com>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
 <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
 <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------fCwaHAalYrn1JKN6v458qnQ2"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------fCwaHAalYrn1JKN6v458qnQ2
Content-Type: multipart/mixed; boundary="------------qK02CW3SI0ReWJgQUpPmhlWj";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.org>, Steve French <smfrench@gmail.com>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <e2a50c26-42ad-4060-9da4-96f89517ee1b@samba.org>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
 <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
 <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
In-Reply-To: <b29ed180e00cf6197644e54d944c59fc@manguebit.org>

--------------qK02CW3SI0ReWJgQUpPmhlWj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8yLzI1IDk6MzkgUE0sIFBhdWxvIEFsY2FudGFyYSB3cm90ZToNCj4gUmFscGggQm9l
aG1lIDxzbG93QHNhbWJhLm9yZz4gd3JpdGVzOg0KPiANCj4+IExpa2VseT8gSG93PyBEb2Vz
IGEgV2luZG93cyBjbGllbnQgYWxzbyBkbyB0aGlzIHN0dWZmIHdoZW4gdGhlIHJlbmFtZQ0K
Pj4gZGVzdGluYXRpb24gaXMgb3Blbj8gQWxsIHRoaXMgYWRkaXRpb25hbHkgY29tcGxleGl0
eSBpcyBvbmx5IHdhaXRpbmcgZm9yDQo+PiBidWdzIHRvIGhhcHBlbiBhbmQgbm93IHRoYXQg
d2UgaGF2ZSBQT1NJWCBFeHRlbnNpb25zIGJhY2sgd2Ugc2hvdWxkDQo+PiBwaGFzZSBvdXQg
dGhpcyBjcmFwLg0KPiANCj4gQ2xhaW1pbmcgUE9TSVggc3VwcG9ydCBhbmQgYmVpbmcgdW5h
YmxlIHRvIHJlbmFtZSBvcGVuIGZpbGVzLCB0aGF0IHdvdWxkDQo+IGJlIGV2ZW4gd29yc2Us
IG5vPw0KDQp3aXRoIFNNQjMgUE9TSVggc3VwcG9ydCBhbGwgdGhpcyBqdXN0IHdvcmtzIGlu
Y2x1ZGluZyByZW5hbWVzLCB3aGF0IGFyZSANCnlvdSBhbGx1ZGluZyB0bz8NCg==

--------------qK02CW3SI0ReWJgQUpPmhlWj--

--------------fCwaHAalYrn1JKN6v458qnQ2
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF4BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmi4Y1UFAwAAAAAACgkQqh6bcSY5nkbG
RA/2K8cqUzaqBHCG6leJqSCh1T8zhxeuO74sGJ+EWl9eow35vm9OYNDjvoVs8FpVMX6Qf5dvvix7
MRPZin6rrIclJOuU/pxw3HpJWS2KGqtxFQqU0lRARJN5ZlCYXuuRUEOVsWYSCbCGklyW+oqzj06e
NKYhuc31grqsAGA3Typa2NqzQM4f+D6tR5OucFDpGwP2CaA2y0ENS4a6AhmRvW/5ukiZXMXTSgT6
SpWPpMOoCsZs2qpgjDPIXZBa+9M5rIw8mIXbVmnsFu+ACYtXAWRmgFrlDm+a3JJo4g9g+adMowUP
bzXF2HMsMjKCkDrKbIqo+if73261aBZ6qwPk0pciW0bp4F9ii6eu4bpYXtoCC4wJi/X3Onoqp4d3
XEPI11O1Xob4RP2TJf6RHu/2ImNTXsLE8GLOR9gwyDuuGaRpJnXZmJ0ErVlPJ00mzsK8/6MXmhvE
3fxUJra75mJN34mW2ocDbaRSzSmG9IVxBDFdvCOaCU5b5dWBrRcT57GoGNq6mSR3TsH+YVx3RyLb
LL2g8MOUEw3xPAtllW40KRjEj4rR2BfGjqCRxAiZEZV6oTuHDXA8MG72pidmMhm9MF4j0Udk0ZAm
NQX1j7C/zqxuONPp3OvXG4zX8wQGhlWo6gZcVxzPXd1NoZYmDKLShH15+J31A3TKYUc5WvTRaXsR
6w==
=kDS8
-----END PGP SIGNATURE-----

--------------fCwaHAalYrn1JKN6v458qnQ2--
