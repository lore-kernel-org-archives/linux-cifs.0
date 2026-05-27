Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17CB3B810D
	for <linux-cifs@vger.kernel.org>; Wed, 27 May 2026 07:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868701; cv=none; b=gGXgQlYMFbAwnCx1NT1G8DjZmUFuZwA1USeK/JgekzNuGokma+vOslInrt9BS+GnQBBcnU1/gtA8XULMJai65Dv8grzbTW3rRNQrLoIl8sdaQr2oR+/n3TixgNyTzWFBsV2zNnrr4er/n0cLlf6Zn3/qDNYI56o8gRdKrWnrk10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868701; c=relaxed/simple;
	bh=jl4Jt/j3EjesqJwxfEsJIR+EsqlbVhBZg1Ex49F0qAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NXZDH9Oj/z5gWqeXHagHECjO/VaBk8380BYQF5hbpTE/ptIyDSIDTkajLahsz2y9pgSziI3lIn4IY2O9E3OVyk4OaG8hEJ+tm87FpvnM6SuUZPBvvi4o/gcFDovz0NkQOVdgVGVDKypGKUZ9OfbyGccimltau+eIP/RvOl4ZdyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DCWk7liu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DCWk7liu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=jl4Jt/j3EjesqJwxfEsJIR+EsqlbVhBZg1Ex49F0qAQ=; b=DCWk7liug0Xgi/uK7wfKlmjH3n
	uPnjYBxtuCsqn2/oxrNO0erx8aORQNQH+5rSAHC/1vwLoNsipcaJVZ9PeNGI/QBBycR1JJPsfPDmG
	0eLni96067b849wfRTlrbMHNr7xTOirjfXmjCzF93vDAL6rxVQ5jM/YGHOLgltsAUiUh1z93j8+yl
	qushyTjoK9HrKxBDIqa2oo8o/xdOV35nBdRxHpVu1zSHnyTaJwn7ufO/BYSINvwex81vmuRKRXCCP
	qpVC8IVy2Mw2U3s7pcAzdxuhHpT+GL6AyfxCxxbW6m5til+XaqCE8sKHd8lX2R1mc6x6ey2gJjr8H
	FYs4kyXIuV+qiykKz+L4w/LtgAHXf+3XRd/oeVuATrMiu47yKKlTAMgSurBAtFNVI27OXaU8mei/4
	Eoz57Hg19kY8NORYwkh0pnyMC1x8ZSyhGf0eXqr+O7L33YuJDoXaVfa7KnbDsoPgRXlsxqMx88XrS
	jLbz/h/+4uh9zgQDxx6Gw+dJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wS99X-0000000BzCj-3xDD;
	Wed, 27 May 2026 07:58:12 +0000
Message-ID: <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
Date: Wed, 27 May 2026 09:58:10 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Pz0c4HLK6sMpAzd76AegfawV"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Pz0c4HLK6sMpAzd76AegfawV
Content-Type: multipart/mixed; boundary="------------lnfb0rLK90ap2fK22aEPq6Iy";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Message-ID: <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
In-Reply-To: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>

--------------lnfb0rLK90ap2fK22aEPq6Iy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU3RldmUNCg0KT24gNS8yNi8yNiAxMDozMiBQTSwgU3RldmUgRnJlbmNoIHZpYSBzYW1i
YS10ZWNobmljYWwgd3JvdGU6DQo+IGNobW9kIGFuZCBjaGdycCB3ZXJlIGJlaW5nIGlnbm9y
ZWQgd2hlbiBtb3V0aW5nIHdpdGggdGhlIFNNQjMuMS4xDQo+IFBPU0lYIEV4dGVuc2lvbnMu
IEFkZCBzdXBwb3J0IGZvciBjaG1vZCBhbmQgY2hncnAgd2hlbiBtb3VudGluZw0KPiB3aXRo
IHRoZSBTTUIzLjEuMSBQT1NJWCBFeHRlbnNpb25zLg0KdG8gbXkga25vd2xlZGdlIGNob3du
IG92ZXIgU01CMyBQT1NJWCBpcyAqbm90KiBkb25lIHVzaW5nIHRoZSANClMtMS0yMi0xLTx1
aWQ+IGVuY29kaW5nLCBidXQgdXNpbmcgYSBwbGFpbiBTTUIyLVNFVElORk8gU0QgZW5jb2Rp
bmcgdGhlIA0KPHVpZD4gYXMgdGhlIHVzZXIgU0lELCBzbyBiYXNpY2FsbHkganVzdCB3aGF0
IHlvdSB3b3VsZCBzZW5kIHRvIGEgDQpXaW5kb3dzIHNlcnZlci4gVGhlcmUncyBubyBuZWVk
IGZvciBhbnkgc3BlY2lhbCBwcm90b2NvbCBzYXVjZSB0byBoYW5kbGUgDQpjaG93biwgd2Ug
Y2FuIGp1c3QgdXNlIHRoZSBleGlzdGluZyBwcm90b2NvbCBwaWVjZXMuDQoNCk9ubHkgZm9y
IGNobW9kKCkgd2UgdXNlIHRoZSBTLTEtNS04OC0zLTxtb2RlPiBTSUQuDQoNClNhbWJhIG5l
dmVyIGhhZCBzdXBwb3J0IGZvciBjaG93bi9jaGdycCB3aXRoIHRoZSBzcGVjaWFsIFNJRHMg
KGFmYWljdCANClMtMS01LTg4LTF8Miwgbm90IFMtMS0yMi0xfDIgYnkgdGhlIHdheSkuDQo=


--------------lnfb0rLK90ap2fK22aEPq6Iy--

--------------Pz0c4HLK6sMpAzd76AegfawV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmoWpBMFAwAAAAAACgkQqh6bcSY5nkbK
RQ/+PheirpETPAa3p4C8RASZMzQEAxe/KOtdgAlXYrPdsXw3aad+ka3PAW4L8VBGj6W+Ei5AtuoM
n2jUU04LzFTHxgZX6Y+EgeW8PolVp1BWwczpdPC3NyBjgSZTGp1vN+xZcuUA7FV5Kg0sjfTJVfqb
KAv508Lz6WSgDY+vI5wx/EDW0uZX84EpNiInXwJe03W9VUM4Z+ND5CQzqQ9u3oxMkGUhm7azTNl+
5hUjJ91qZgozUAG36sIukigHZzgIGHH7/y7KKMxowR4x/LHD4Odce59cejC0NVJIKBmwY+SPDlad
PRh6hoOg7auqLWZPFI03wsmjr340inen1sG4uk8s6thWnaA/Wnu7rIaqrDlutVIguE6XVM7om+Wk
QLlLG7TqUVr7buSpn0TXBKXT50Yp+ckYxTMKi2R5n1hZCuvcUBQ2Dgq8/gh8WDJ6vWOSelUDYvS5
hoxek06+kx+7BMPNr7K+eZywkJ9bWISc5t6DzNqPKL1k3F6OH0GcTxPonZGgzaF6M1FU+U5mX4Lx
+c5kfle+4j8+wHCvRzMAXlcWFxke8jTpJEVcOJ2WlXpxUkJ1TYpHUcTYb1xSoNRhAnpK8ZeDUwnP
W2uH9XVQA1TDLhw4cAEufF9ap2TY2JEzZfOYGlUB6fz29r1uPXGFDdoQbFlTB5jeV0JxJkBlkBqU
wIQ=
=arTE
-----END PGP SIGNATURE-----

--------------Pz0c4HLK6sMpAzd76AegfawV--
