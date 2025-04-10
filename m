Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAC12045B3
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 08:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744274039; cv=none; b=k6ZZ4ZpqBjA0Uf6W0HXTxsNebRIrstmLA5wDZrYrEldBHcgp5VBgJGkPy9SehI/m4E4/WlyLs7zW2CQ6XlJX/SetPWCw2WkL4lhwRzWXNOjpZjknAY/eTE1h3qTa2qZ86Try0cmqXkM7BQig92/4lWfMNuuy272v+MZ6d0q2WAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744274039; c=relaxed/simple;
	bh=uipzv4lbUp1HDr06giaCBYq5HoKcMQO+vUXhUyohBu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTSZpQYLxHswNXMpE0X2Whd1FQQdSWtKsI3jAnF/rFPXOalL+w8EffsNfe/C/iednjJJXw/fs34bhbRB3Jr28ve8+NgOLAK8rdnhZVjJEvwaGsXnaTMLlHfCNtrwXXCZfFhly3jELj9VbURVaUK5zwi8AWaMvlZeqJiPuZHJzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uj/1vv63; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uj/1vv63"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=uipzv4lbUp1HDr06giaCBYq5HoKcMQO+vUXhUyohBu0=; b=uj/1vv63Wse2tdsTeuo3sv5YWf
	14V3fV1JfUDiFR3NPXZeLK0iIs3Yh59/Ve3sF4ZInFMy1ytRfs5pp/ANbHoonSFphWws+BHU5Ra8y
	gs68D59Xbr+x4MYbpA0pfgff02Xipku+108lUchVQMi+BzotILnhTVJKYuV1BHwLR/5Win212bRE+
	fa1Yf6NiNVehf+lTuvUn9//fuWEoK9ecx91O0dKBzepFaXlAPsFmp4zEXsyxWTkMnTJMAuKwTsbST
	GtiqagYkAgzIgBjU7Blgta8VmkIIDuClR8Vd9jsY01yxZmkEmOghtDwGjNvNXNhzMvpfU/GoqqSj3
	hBHopi1Bmw56+MK5qkhk7At4e7ostF+4V7KecQH/aXw4xAJzn2YWo8uLJTMAuMYBO4aDXFu8jCRhj
	V42jJNr13GlnM7SBAG8tRJcQeQ4nzCvj/vh9HxYfEcO/1JIWKcc7ukCMEzgRxeOa4oEns4lXy3I0B
	lcio9xpbQnakF7VIpF2cx1IX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2nMB-0094Ul-0o;
	Thu, 10 Apr 2025 08:33:55 +0000
Message-ID: <9f7da486-5d85-4ef3-8fcf-14b408d78700@samba.org>
Date: Thu, 10 Apr 2025 10:33:54 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: Jeremy Allison <jra@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Tom Talpey <tom@talpey.com>, Steven French <Steven.French@microsoft.com>,
 "vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <Z_b4DS3kOpbCI4pG@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <Z_b4DS3kOpbCI4pG@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------C093IENLqWg8z5ajy0KARBUG"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------C093IENLqWg8z5ajy0KARBUG
Content-Type: multipart/mixed; boundary="------------FKN8XcEw0esKQXnTSwJXMhZU";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Tom Talpey <tom@talpey.com>, Steven French <Steven.French@microsoft.com>,
 "vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
Message-ID: <9f7da486-5d85-4ef3-8fcf-14b408d78700@samba.org>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <Z_b4DS3kOpbCI4pG@jeremy-HP-Z840-Workstation>
In-Reply-To: <Z_b4DS3kOpbCI4pG@jeremy-HP-Z840-Workstation>
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

--------------FKN8XcEw0esKQXnTSwJXMhZU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8xMC8yNSAxMjo0MyBBTSwgSmVyZW15IEFsbGlzb24gd3JvdGU6DQo+IERvZXMgV2lu
ZG93cyBldmVyIHNlbmQgRklMRV9ESVNQT1NJVElPTl9JR05PUkVfUkVBRE9OTFlfQVRUUklC
VVRFIG92ZXINCj4gdGhlIHdpcmUgPw0KDQpObywgaXQncyBsb2NhbCBvbmx5LCBjZiBNUy1G
U0NDIGFuZCB0aGUgdGhyZWFkICJTTUIyIERFTEVURSB2cyBVTkxJTksiIA0Kb24gdGhlIExp
bnV4IGNpZnMgbWFpbGluZyBsaXN0Lg0KDQo8aHR0cHM6Ly9sZWFybi5taWNyb3NvZnQuY29t
L2VuLXVzL29wZW5zcGVjcy93aW5kb3dzX3Byb3RvY29scy9tcy1mc2NjLzQ3MThmYzQwLWU1
MzktNDAxNC04ZTMzLWI2NzVhZjc0ZTNlMT4NCg0KDQo=

--------------FKN8XcEw0esKQXnTSwJXMhZU--

--------------C093IENLqWg8z5ajy0KARBUG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf3gnIFAwAAAAAACgkQqh6bcSY5nkax
jg/9GNF1fezg8f7GIjf4djyu78H181afc7GUBWUWefJc1nBn+eysjyI/dtLq99PtaQLml4y2PBOM
iZXsnSKhz4lqHistW6JinrrX8m/v3KeKpi/zAaCdYL5HFSBFNaLAxDMklvH5KnAR5/zmFqW6pBZJ
oHjXGGj9zklMaXMEmMnNgwNtSJq4qZaFAhuAUFin+RCreVMuT2b5uemvv451BiK77k3W8mlupSrw
Gw5Ocr2+DpMUTHomFjd6gXca6QkPXjLJ20JZkuAtjqq31mjJvO+WgXcLdvQT7pM/VmGUTQMuE5Pl
VEx4JERbqmOjt5dAbRJoI/3jlgIDk2K9H/CF6wwV9YP9rN4W9ah3n1iXkMO1E4qdBXsnjjoVLwG9
3NHstF2SEx9pr7HPctEicGGAYD9iv9+xbFuXZRBwitryYEdmPhur+XbIJEdKgy8OwzukI4DjYouP
loitIjpe/c24CHQc+uN7mHvjwrBcIaqFriDvtJeLCUmQa9QXvkX622YISOfYI1eDnvH4OX/y0I0I
PuFV3oA6pIZYmLsCQidwrW+gf+Z+eRSlGaDJU6j/1LfHCFkirQGFNpU4fTRIGEKDscT9IO8mWS/N
NY932eDvV0I8wjP6koLZYibwH3MDjg5HtW9atfNMdcwzNuLfq1eFPnhUCdFE8R3R0EEsvjhH5EgU
mec=
=nIDK
-----END PGP SIGNATURE-----

--------------C093IENLqWg8z5ajy0KARBUG--
