Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9388634F
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752472908; cv=none; b=DGB26EfbN09QPE7s/ybKvF2zIPQCwjEbwTJIcaTATuYyjBMxx80CcM3Ua2FOCmvJr5TdIZoowiifWv7V5YRvqshmiEvDi4WP3Ec9bDzxYd8UlImgZPQmQZiVPURN6htHjumlTusyE46YIEPhV31C4xfiBBEcuPD55o6nKY7Gnqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752472908; c=relaxed/simple;
	bh=AqpX7lN/Shu69jCJQIRcNfuz3xVwedws5uKQ2Zo9uqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gINp/wgquk+evyeqULNU3lcWXCWe4vqk0xTM03NuIPzm2onBeevCnm+3R+eePGTFnIwV3MJz69UbhLfAGuHsy5WCjn14qSShX/bmFVyX7X8xM6V4Ps+DGTR9sF1D6EWctiEKdXZEKJ07O0EhGvLngh8oR4I+o4/IgPLkF/Drx0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Q/+8+H2z; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Q/+8+H2z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=AqpX7lN/Shu69jCJQIRcNfuz3xVwedws5uKQ2Zo9uqA=; b=Q/+8+H2zluNbRGYD0YVB9CkVDZ
	pSM1vxvLjz9KAnVK1r783975PyAKxDlUxzXxBkxm611FqmxpCgJS9qRPehAt/hV/FuSR1ydI1XPJq
	ftM0P2A05MTIHxRQcsw00dd1PFtxHRNAqg1dh3JaStW800SWhk7rEJ1OonlgyKoyKN7N36e20pyEl
	fDZr0M+MGKFmKa8YAnz9Q5Quqcyvb8m+ISY7PBXEM5nQfc2psBV4+XEDU9AhVw9NaEHQANVbPZ1oQ
	Ox5hf/tmWWyf30MEQ3Ow8hvc9m2D3Dr7GqD7XoJLlkVMwJKBG4W2+RwQG/BJJcZwCS2KyI8YHpmFn
	R6ZRUorwOP7dozYiAgOKfAsU+6U2KHO7Mq/IcX8af335Vxw0LacKIM8n9rn3ofMK2UTM0uGOx+n2g
	bw+kdq+Vq2tQapIuaeoNBvSkK0d6t6PpJfbnudRAmBPVmymPi0vxAl3HOCD3ZiUSzB2VO/MCXl+0m
	FCw4WvdsMh6fv5MHWaNrnao4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ubCFy-00FGSt-2F;
	Mon, 14 Jul 2025 06:01:42 +0000
Message-ID: <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
Date: Mon, 14 Jul 2025 08:01:40 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Samba support for creating special files (via reparse points)
To: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
 vl@samba.org
Cc: samba-technical <samba-technical@lists.samba.org>,
 =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0qp0LvcipNDGpKGzY0hDN7v0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0qp0LvcipNDGpKGzY0hDN7v0
Content-Type: multipart/mixed; boundary="------------4Vk7oR8trxPVmUfrc0Oa0UR0";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
 vl@samba.org
Cc: samba-technical <samba-technical@lists.samba.org>,
 =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
Subject: Re: Samba support for creating special files (via reparse points)
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
In-Reply-To: <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
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

--------------4Vk7oR8trxPVmUfrc0Oa0UR0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8xNC8yNSA0OjE4IEFNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4gSXQncyBhbiBv
dmVyc2lnaHQgSSdtIGFmcmFpZC4NCg0KaG0uLi4gaXQgc2VlbXMgcmVwYXJzZSBwb2ludHMg
c3VwcG9ydCBpcyBtYW5kYXRvcnkgZm9yIFNNQjMgUE9TSVggc28gSSANCndvbmRlciB3aGF0
IHRoaXMgYWRkaXRpb25hbCBjaGVja3MgYnV5cyB1cy4NCg0KV2hpbGUgSSBhZ3JlZSB0aGF0
IGdlbmVyYWxseSB3ZSBzaG91bGQgbGlrZWx5IHNldCB0aGlzLCBmb3IgU01CMyBQT1NJWCAN
CnRoZSBjbGllbnQgc2hvdWxkIHByb2JhYmx5IG5vdCBjaGVjayB0aGlzIGFuZCB3ZSBzaG91
bGQga2VlcCBpdCBvdXQgb2YgDQp0aGUgc3BlYy4NCg0KVGhvdWdodHM/DQo=

--------------4Vk7oR8trxPVmUfrc0Oa0UR0--

--------------0qp0LvcipNDGpKGzY0hDN7v0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmh0nUUFAwAAAAAACgkQqh6bcSY5nkZL
9Q/9FCx+iZfnDpv4adAZUhhcQLWQf7jzJgALlNXDNQDjDprKNLIs8GCeAn1GbQYN3f/nvw5zryYp
T85betNYc9Sbq3F5hzFycZD1tj+vRo0VPLBxrjlqVnWl4zjj7XCeYQSd6D4FRaxlYKGE9EKW6vsQ
FoQGwO1pVOiwZLAQvrTn7c7n0G+aaQPJLjgwkuPoXqCcIBZM0JmG7N1SM9OI7UHSFaKHsjLcfvKq
ggFkzN8or3XlQ+1+mYffdwb1qfYQm3WCvT3QV09sdBmMhqvnf4uUvL5rvuJDUC6zENXWNWfBfVta
LbQgj0VUJzYmLZ9+RAu34PbJ8iUZJPY1Jferh565iRtLZBDSRDhLstQ955mwA/dRCGdliTVdFaVN
o1XJdHAw9+29TWpCe16wzV+yBaSAJ7T1kz/PWwxZiUCyuEZdIYSz082nNS6AwK3N+Pou/m+tJRlT
bjGgTTRkYv/zlZnEthvX6q2qZDnfwCOnBm4L+e6URSGBzcFJrV0wbnIX/KDgRHvQ3xYre3Hf1DE0
8NFdblEiQl90+aLZp5n/uYYFvc6WRGbZfY6RNaCiY0mD2tjeB+Xrnkc3uB3S8tyL8yXN+lv1y7af
ye1dOu7TGQMPKabFZf1PBbJ6sgUk5c1+rk1iIA+h/1Amd5wz4OvGXTSrRZW8cCvMrto9wLaywqXT
OWA=
=WI+0
-----END PGP SIGNATURE-----

--------------0qp0LvcipNDGpKGzY0hDN7v0--
