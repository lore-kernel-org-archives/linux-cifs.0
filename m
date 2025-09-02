Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C725334DCDB
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 19:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756839957; cv=none; b=cXfeuT0SsYpVTWnx5Ak+MWDtQcILSxg0Bg2lZcrrr7OTbNGHvn7bK2Bm4b3KU+5/Yxx1ZmiB5+befzJP5PSUkwDT6paboWpOsd6yTERpCaHuKrvimJWbDh1zNcnn12GrFO74hbR++4IXQBqVvBHAMw482efVVEL07Pwv8c1bRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756839957; c=relaxed/simple;
	bh=19XCJyutuRur/llnDcQY6qCyf9jYfh0a2nOzBZl5+pg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QW+JKUCPgFPN/9i+M/fLWoAkroqwxGbMaScMrG5KlU//KauCR3FYxjXZkyIfpui7DoqHctk2taLdYXnMh30ily84MZOGZYXfHUhtRwP1TzGtTlfvYkBRY2DuUazeH0Fuw2HBJ23Ll+TyfPKMYDsSNIrXCSoottCweXZ/oycuVw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=caLvYsDA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="caLvYsDA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=19XCJyutuRur/llnDcQY6qCyf9jYfh0a2nOzBZl5+pg=; b=caLvYsDATeqNbJSSBBcyu/EAoh
	VuYKa5v2F9d2uC7EwbLwXygozMUcSUW1roA0RzhuLjhGzfsznx2igeRHlEL+HVbL61mxtxkmx7cyg
	6l/ertrOlz94HoQRQJX+Z0IPQ5Kb7rtOwCLpBJULnHc9yEME+FX3RloPELjh0CMzJtkB50AM0lLlf
	tevgRAV/tCsRVQTOQ2QmKvUU0hbWtGbOig+hZxh5Fs96cYWtC41Kn3z8lu4Ow+gUuxTnXtKh3YtSY
	yhhEdfUGY4BfROChCNkO4IGe7O3X1PM/mYX6ha8Kwd3WSqbzUIZMp4A8KokJ//8BmqgqDVDzA8FYS
	CFC6hwnOaR15Ar8Wi1N1e8kl1pd5PkUmAO4X2QMNoZuhO/0ACy+MQtZbjVS9iFvNkKUtj7MKoeXP7
	ResH02NPqHtwJl+aKVz4BRJat5Khd+4UfJTt44GetFtJgQnP6dSQT5aktasRJcE9ySgMtp4WDHr8H
	HhHSKSxFmnM/bhpvwqtu1o00;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1utWKH-0026GD-2k;
	Tue, 02 Sep 2025 19:05:53 +0000
Message-ID: <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
Date: Tue, 2 Sep 2025 21:05:53 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
 Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------XXLTnPtcLhUHDHHhusbf7zuJ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------XXLTnPtcLhUHDHHhusbf7zuJ
Content-Type: multipart/mixed; boundary="------------FQBQusuDxmudP4NbVOabLKOd";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
 Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia
 <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>,
 Scott Mayhew <smayhew@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
In-Reply-To: <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>

--------------FQBQusuDxmudP4NbVOabLKOd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8yLzI1IDg6NTkgUE0sIFN0ZXZlIEZyZW5jaCB3cm90ZToNCj4gT24gVHVlLCBTZXAg
MiwgMjAyNSwgMTo1N+KAr1BNIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmcgDQo+IDxt
YWlsdG86c2xvd0BzYW1iYS5vcmc+PiB3cm90ZToNCj4gDQo+ICAgICBIaSBQYXVsbyENCj4g
DQo+ICAgICBXaHkgbm90IHNpbXBseSBmYWlsIHRoZSByZW5hbWUgaW5zdGVhZCBvZiB0cnlp
bmcgdG8gaW1wbGVtZW50IHNvbWUNCj4gICAgIGNsZXZlciBidXQgY29tcGxleCBhbmQgZXJy
b3IgcHJvbmUgZmFsbGJhY2s/DQo+IA0KPiANCj4gDQo+IFRoYXQgd291bGQgbGlrZWx5IGJy
ZWFrIGV2ZW4gbW9yZSAoYWx3YXlzIGZhaWxpbmcgcmVuYW1lIG9uIHRob3NlIA0KPiBjYXNl
cykuDQoNCkxpa2VseT8gSG93PyBEb2VzIGEgV2luZG93cyBjbGllbnQgYWxzbyBkbyB0aGlz
IHN0dWZmIHdoZW4gdGhlIHJlbmFtZSANCmRlc3RpbmF0aW9uIGlzIG9wZW4/IEFsbCB0aGlz
IGFkZGl0aW9uYWx5IGNvbXBsZXhpdHkgaXMgb25seSB3YWl0aW5nIGZvciANCmJ1Z3MgdG8g
aGFwcGVuIGFuZCBub3cgdGhhdCB3ZSBoYXZlIFBPU0lYIEV4dGVuc2lvbnMgYmFjayB3ZSBz
aG91bGQgDQpwaGFzZSBvdXQgdGhpcyBjcmFwLg0K

--------------FQBQusuDxmudP4NbVOabLKOd--

--------------XXLTnPtcLhUHDHHhusbf7zuJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmi3QBEFAwAAAAAACgkQqh6bcSY5nkbi
vg//X9mFNkaMLwbkXBOL7YiBN1q0npJnHMLPckiTPzkWdghl7fp6gISGxCNHpSsp3vR5SC/3OZTe
l2J6Y0WssJX2Ho1rMm/mSTeh0mXBosC4Eij30o3xsSh61RvA5QpexBfIZJm75wO2X1jqsZxSwCLm
McOlPWxBhRkz/xb7iV+aNa8TXNRdth8h1GzSd47Ev+YHXKDMsQOwvtxGR/4eVu/Xr1Bra/Tjmfng
e/XcF3K8BiPGUYjyWHK5eR2U0qMlYf7VK1sk3uV00/h9bZd1SGQZPqG/tbyUTM53NXZMcrstVI4g
B8BOS70Qw7T4SYIOrVmqMg2tJ7TZVdC2por/fKgmdXXY+sJGABSoOL+aTiIgfG32RtaKyPYvzWGw
K0qBt0TbiliEfy2Z1p2cAItG6sbJBDmA1EOrt/1CktvjCD7qe6pXXABL4NZ1E41Qz6TwMiCwjQNq
5HHl5QKyHg8pKDfpyXZ9AWrbZgBV30/av+ppoctDvnEIXK2cdEVoEMKvJ6W2sa9Au9AZU32em0/g
dMFDYjB3Vk1fpB8Xhc+bVebyj2NF+ypXEJe5WS0o+KkstaOCvPCgwApx+taMzPfpvLr6+VcHk6Qh
yzrbACwvpnLDhzCD6D+3Bk7ul1wc9dK2fnLkChHsoVCneBA4lQVxJXogJUGRdjwHIV+JJQRBdkPW
Rkk=
=8BQS
-----END PGP SIGNATURE-----

--------------XXLTnPtcLhUHDHHhusbf7zuJ--
