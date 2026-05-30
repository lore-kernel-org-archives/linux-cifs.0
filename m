Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86528395273
	for <linux-cifs@vger.kernel.org>; Sat, 30 May 2026 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780136198; cv=none; b=p+GfLxzep0wCYF5SofeqHjics5uauSYaL1J33Gja6oZ40gRLrJ3YioOzw4jAKPpqD0Fs07YXKsBgjM+VnGa7XeO7gb4nyqFm1X4o28rN0nIo14zSaMNLRK3dsqWCJ/L8kTMIHCPaYFJwdMuSUhQpRQYEWM1pc+97Nra2dU01obc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780136198; c=relaxed/simple;
	bh=AdkMomJGEaEJBi2NRBYCs/g75EDMfDkRfLf7bu9VtNU=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=ty4zcUgIrsmINy5KIHo9uOpu1nk8zLuzAEUFDEi2aTk6tMswivKIMtJL6Ftrxo+lYUrj6NLFRxWAkE/w/dUrzNqeCoU1e7hhwNnlFdtOyTuUoeLByb1JYSvvqPXiENFe5HRZN4rlmHyciw+kDazShpQLCc42+nQzpRH4hbdVfM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3zgZPCAq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3zgZPCAq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=AdkMomJGEaEJBi2NRBYCs/g75EDMfDkRfLf7bu9VtNU=; b=3zgZPCAqVry/lFslQqf0lNZ/L4
	xicZyThqGDzrWOwDLBbsCtb1ohCz5S2d3vBUph4dUe6gYDVJdViBBVMVvXRVdLf3u0Ut8o6HVkO1F
	CXL0JkFEXdOBGt8QpCISIFa30ooqfWWz4r6/f4uSUsCToZ9v0cQsNdafnXFTIuac+leuFfjfzyI/o
	roV9jat7WpASyf0QY1RohNGSCr/mrJbT6EhYct7sX07P3bNGj5RP4nh8w/8qehClB2IIo7I3FKHm7
	2SCSCpQyLL5BqM/6B4Mti+jxkrQ9hbMyjR2e9qXzRHiPNJTIZ4englQ3wSd1RXna9FJ5K4jgMOkwU
	L1VLbUYiX+C1CvN80jfR++WEU+FErnztQH43GRvrqAdQ5jPLT5/+V3csr8tNXvoh6G/M6Q6Zb9I9k
	E7rQQrMca7vE22IsQg+jLqS349HEzvAxv2zmmHmYdZx9CLq8zgF+q8LIXFc2bldNzINYEt/FhCjSn
	58//el7JWgrteObBWfypV0VI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wTGk0-0000000CnkJ-1TXq;
	Sat, 30 May 2026 10:16:28 +0000
Message-ID: <1f053cac-c952-49cf-af22-16533b70939b@samba.org>
Date: Sat, 30 May 2026 12:16:27 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
To: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Cc: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
 Paulo Alcantara <pc@manguebit.org>
Subject: SMB3 POSIX Spec Reviews
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------40P8BKkSf54hEpBHhTO61xqI"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------40P8BKkSf54hEpBHhTO61xqI
Content-Type: multipart/mixed; boundary="------------F35lqJSMch8e0AU4TX3n15r0";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Cc: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
 Paulo Alcantara <pc@manguebit.org>
Message-ID: <1f053cac-c952-49cf-af22-16533b70939b@samba.org>
Subject: SMB3 POSIX Spec Reviews
Autocrypt-Gossip: addr=jra@samba.org; keydata=
 xsDiBDxEcLsRBADMQzpWoVuu4oiq23q5AfZDbakENMP/8ZU+AnzqzGr70lIEJb2jfcudViUT
 97+RmXptlnDmE4/ILOf6w0udMlQ9Jpm+iqxbr35D/6qvFgrgE+PnNAPlKSlI2fyGuLhpv1QP
 forHV13gB3B6S/ZWHpf/owKnJMwu8ozQpjnMnqOiVwCg8QnSX2AFCMd3HLQsqVaMdlO+jBEE
 AKrMu2Pavmyc/eoNfrjgeRoNRkwHCINWO5u93o92dngWK/hN1QOOCQfAzqZ1JwS5Q+E2gGug
 4OVaZI1vZGsAzb06TSnS4fmrOfwHqltSDsCHhwd+pyWkIvi96Swx00e1NEwNExEBo5NrGunf
 fONGlfRc+WhMLIk0u2e2V14R+ebDA/42T+cQZtUR6EdBReHVpmckQXXcE8cIqsu6UpZCsdEP
 N6YjxQKgTKWQWoxE2k4lYl9KsDK1BaF6rLNz/yt2RAVb1qZVaOqpITZWwzykzH60dMaX/G1S
 GWuN28by9ghI2LIsxcXHiDhG2CZxyfogBDDXoTPXlVMdk55IwAJny8Wj4s0eSmVyZW15IEFs
 bGlzb24gPGpyYUBzYW1iYS5vcmc+wlcEExECABcFAjxEcLsFCwcKAwQDFQMCAxYCAQIXgAAK
 CRCl3XhJ1sA2rDHZAKDwxfxpGuCOAuDHaN3ULDrIzKw9DQCdHb3Sq5WKfeqeaY2ZKXT3AmXl
 Fq7OwE0EPERwvhAEAIY1K5TICtxmFOeoRMW39jtF8DNSXl/se6HBe3Wy5Cz43lMZ6NvjDATa
 1w3JlkmjUyIDP29ApqmMu78Tv4UUxAh1PhyTttX1/aorTlIdVYFjey/yW4mSDXUBhPvMpq52
 TncLRmK9HC6mIxJqS0vi6W9IqGOqDRZph3GzVzJN7WvLAAMGA/sGAyg2rVsBzs77WH0jPO+A
 QZDj+Hf/RFHOwmcyG7/XgmV6LOcQP4HfQHH3DGYihu5cZj3BeWKPDJnjOjB2qmr+FTjYEsjw
 LDBNG7rjRye412rUbNwmEtcD2/dw4xNyu5h2u+1++KVBPf4SqG/a10gDqGJXDHA1Os5MmnQl
 3CTq9sJGBBgRAgAGBQI8RHC+AAoJEKXdeEnWwDasbeIAoL6+EsZKAYrZ2w22A6V67tRNGOIe
 AJ0cV9+pk/vqEgbv8ipKU4iniZclhg==

--------------F35lqJSMch8e0AU4TX3n15r0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGV5IGZvbGtzLA0KDQphbnlvbmUgYWJsZSB0byByZXZpZXcgdGhlIGFkZGl0aW9ucyBJIG1h
ZGUgdG8gdGhlIHNwZWM/DQoNClBPU0lYLUZTQTogUE9TSVggZmlsZSBkZWxldGlvbiBzZW1h
bnRpY3MNCjxodHRwczovL2dpdGxhYi5jb20vc21iMy1wb3NpeC1leHRlbnNpb25zL3NtYjMt
cG9zaXgtZXh0ZW5zaW9ucy8tL21lcmdlX3JlcXVlc3RzLzE+DQoNCkZTQTogYnl0ZXJhbmdl
IGxvY2tzDQo8aHR0cHM6Ly9naXRsYWIuY29tL3NtYjMtcG9zaXgtZXh0ZW5zaW9ucy9zbWIz
LXBvc2l4LWV4dGVuc2lvbnMvLS9tZXJnZV9yZXF1ZXN0cy80Pg0KDQpGU0E6IHF1ZXJ5aW5n
IEZpbGVQb3NpeEluZm9ybWF0aW9uIGFuZCBGaWxlRnNQb3NpeEluZm9ybWF0aW9uDQo8aHR0
cHM6Ly9naXRsYWIuY29tL3NtYjMtcG9zaXgtZXh0ZW5zaW9ucy9zbWIzLXBvc2l4LWV4dGVu
c2lvbnMvLS9tZXJnZV9yZXF1ZXN0cy81Pg0KDQpTTUIyOiBDbGllbnQgRGV0YWlsczogbWFw
IFBPU0lYIGZ1bmN0aW9ucyB0byBIaWdoZXItTGF5ZXIgVHJpZ2dlcmVkIEV2ZW50cw0KPGh0
dHBzOi8vZ2l0bGFiLmNvbS9zbWIzLXBvc2l4LWV4dGVuc2lvbnMvc21iMy1wb3NpeC1leHRl
bnNpb25zLy0vbWVyZ2VfcmVxdWVzdHMvNj4NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------F35lqJSMch8e0AU4TX3n15r0--

--------------40P8BKkSf54hEpBHhTO61xqI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmoauPsFAwAAAAAACgkQqh6bcSY5nkba
RA/9FEcQPziq3n/IDxZLgmgV8R2qb4/eAf/2vkJ2F8+LAj5QxFLonoP34z1kg6v+ZrmXz5ti/qz4
aIxBHn+2M9zecbmVadkV+Tc4UmqnSGtHkwER2fYctB05NCBPrVRdOtuwz4D4fT+irhXqtNHM01g1
8g+SUDP9RdtRAM7s8a5LVcSClXpYKw1XzrZD5I91BwcIYwAl0bk4IpN5OPqUCve1aCKHW2Y5F7V3
v19SqLR0MhNvM/s9VMijkKxVRkXZ7lY3G5+pDbF19N2roAJDBi5zK5WleCHPFAxKQYD73OPL1IIx
MJB1N/ncNNdx/osOgTKMYknu4L3EjAxFSyXt7K5NJLlw+wAqOFmYflipelZKHPw+mxKHZyQpC0ar
vgqvEP0p/M5fNz0SufSpBmh414FdOdY7z54SuvJ4+yEznBQaVTUheipcuKGsFEto1s0w2fNd3pJy
StOLxAwmR3a6rV2aCzh30UUoo5OX8zMR3kqJ+kbcKlfJqGpAZvO2hX1kXkasFR+0xu/2kox0eFGa
JdyEUEaLvES4H53DvLvdlon0DBu8d7uKd15C9HkEa8XVoEGteA+Y+5bV6NBJVQnx4fGfvZy5/zhS
G7f3P5xga2G80UdW91aWQ4mnX+a0V8qHZ6Om2qm9H38RyGLcESkibPTvFblMck5YG9IJyfS55uEU
jPM=
=FVgJ
-----END PGP SIGNATURE-----

--------------40P8BKkSf54hEpBHhTO61xqI--
