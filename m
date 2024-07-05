Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255813D243
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720182320; cv=none; b=qB1jzOFoyBBrrIx2ooa4w1yr4Vl6mKU6gK7vqNjMTGCef4YFdIhWXqH1iF47SqrMCpxwdKxrxKGNyBdmYyJS35TFuMKHf1g+8ASHRgSzVhxk0IpsJoctfHM0GBRuhwaXQB9RPazaTKDfavypB1uO836/5gfyDFhYGfyAhUVC6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720182320; c=relaxed/simple;
	bh=PMaGtBgVM41AbCRdvdos+dxmNefjLUTT7kn52gEumJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LG1jVAxhVxYitV89loQXPEpP1wYRo3PO39z05tQ6ZW9pxNvdOeJBI11XSE69YO0OdyAm/QSGnuZniqdDMw2ezV1PFN8Ak8CK0d8EiCKNOR7L3+CVpsmJBHs4pM4JqVBClwaEyUmg93KeccGb1onsftNpZ9KV7y5uGivGOS9KV6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Cq6PpNLQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Cq6PpNLQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=PMaGtBgVM41AbCRdvdos+dxmNefjLUTT7kn52gEumJ4=; b=Cq6PpNLQ29Y4eu/WzUXi06jLzi
	eFySuoR7NsYeoQdRkXECmLAFZyrGKJto1wmUaSZ/dhpGTuwEBeUkGFG6sd5dBQ3g3kZIx+RvWB6xh
	LfxJIQKH1V2qzBIr4Bm/FanVq07JTDHMereCd8BXJNeIM3L9Yl0t4YtKcH2Pn5vLPFHcdtYABeT2w
	dXu/5QL8jeVVdLkBWiYGutVC1Zz8lAfjM1n/uV5JcboY5fbPEtdYGNF5656QhUyVDrCQNPwML6tYA
	3a4RmAUKWU48JGBgwEN3DE+r2IJlajwdyn8BOmwxWxqqMQimao5qpA/2SvumC4wAfWewCMM2cRdzB
	hU0bZ2XTPAXZ10M9pa1JVrTQEWTq5bo/dAv+wAAgCx08Quq10smhEKeVIeZL6SGkvSDoKfjA/vnRn
	Smc36Q+wqb4HOKK4Ja8LQpACL9cus/DG1tdZQ20jLzQ7KgIhEdHCH1Aw6Y4BzmlmQHACExR9JV+vz
	DSUxMZKsup1sLCdH60qfrOGF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sPhVY-002aic-2j;
	Fri, 05 Jul 2024 11:53:44 +0000
Message-ID: <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
Date: Fri, 5 Jul 2024 13:53:43 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
To: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com,
 kiras.lee@samsung.com
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20240705032725.39761-1-hobin.woo@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FdlTas3tp8gycoMZcU3HGcgH"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FdlTas3tp8gycoMZcU3HGcgH
Content-Type: multipart/mixed; boundary="------------WlfwOtatYzaVycNul79Jr7u0";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com,
 kiras.lee@samsung.com
Message-ID: <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com>
In-Reply-To: <20240705032725.39761-1-hobin.woo@samsung.com>

--------------WlfwOtatYzaVycNul79Jr7u0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy81LzI0IDU6MjcgQU0sIEhvYmluIFdvbyB3cm90ZToNCj4gbWF5X29wZW4oKSBkb2Vz
IG5vdCBhbGxvdyBhIGRpcmVjdG9yeSB0byBiZSBvcGVuZWQgd2l0aCB0aGUgd3JpdGUgYWNj
ZXNzLg0KPiBIb3dldmVyLCBzb21lIHdyaXRpbmcgZmxhZ3Mgc2V0IGJ5IGNsaWVudCByZXN1
bHQgaW4gYWRkaW5nIHdyaXRlIGFjY2Vzcw0KPiBvbiBzZXJ2ZXIsIG1ha2luZyBrc21iZCBp
bmNvbXBhdGlibGUgd2l0aCBGVVNFIGZpbGUgc3lzdGVtLiBTaW1wbHksIGxldCdzDQo+IGRp
c2NhcmQgdGhlIHdyaXRlIGFjY2VzcyB3aGVuIG9wZW5pbmcgYSBkaXJlY3RvcnkuDQoNCmFm
YWlyIHRoaXMgc2hvdWxkIGNhdXNlIGEgZmFpbHVyZSBsaWtlIEVBQ0NFU1Mgb3IgRUlTRElS
IGFuZCBqdXN0IGJlIA0KaWdub3JlZC4gV2hhdCBkb2VzIGEgV2luZG93cyBzZXJ2ZXIgcmV0
dXJuIGluIHRoaXMgY2FzZSwgb3IgU2FtYmEgZm9yIA0KdGhhdCBtYXR0ZXIgYXMgaXQgKGhv
cGVmdWxseSkgd2lsbCBiZWhhdmUgbGlrZSBXaW5kb3dzLg0KDQotc2xvdw0KDQo=

--------------WlfwOtatYzaVycNul79Jr7u0--

--------------FdlTas3tp8gycoMZcU3HGcgH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmaH3scFAwAAAAAACgkQqh6bcSY5nkYl
+BAAtRbTU+XteXwL8oZphsEhu3VL8C1FP5O5NQqvTgyH6r7sdx5hNbCLg1S8IRQ9DxUeYYuT/Ny7
rYAKkVKvcJaVrzGf+wQMYpGS5ZtlbIEAP3giWEav0s+UOu+dfp4HsF4EtfhZa6c8e/jzo3D0S3Zc
Zf+g2y9u7M5/YZQ3YB508sdea00nTiqHIRh+9b8Mq6Tjs4lT9kUiPbLTfU/PBem01YP/nQZwkXPo
mv90X3BL8LSj0ZyK+7eQa8mFTypyK88QIDo+kEyA+FN1C+xDKFYrY/wnlVPNP2MTTT17bN9HTkOw
zeANI8xZpqB9P/+3mlcqezjmczOGBru3JOEUiW7ldQQCVJtS15wGkrXAP6lf7TDbPGAgH/KElpZ1
RZuJ2PSQ2jp69b0sTjBJu1XA+VKoCbhs1awyCYPC4FU3c1uPheTGlwRj8NZF+qGlXDOgo8K0vlnd
jGhSUAkvpua/Z6sDawoVX9kgMKzPZkastUrYFUUkIE4lMwndhfv/g3tvRsezEspTDP4YCpVdTPy/
RbBbji6ilgjeL3vYewJT/rE2jQG8c+4C79qcLaechOTnJVNQ6pJZWedjMivdK5jVpdh2QeQuhmhW
jRHT9Bz58p4Q/UBxVCV/pX4TtxYXFI1aPLGixKBJ1ebg30l+qpgTW5tWi3snxpK6mpjxxxyk78Ru
Bu4=
=H1Bk
-----END PGP SIGNATURE-----

--------------FdlTas3tp8gycoMZcU3HGcgH--
