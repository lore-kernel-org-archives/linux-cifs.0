Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCFA27780C
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225627; cv=none; b=uPnXt8buxfHa/rd/fQ2dU+2KoTqJi3Z/q1LJLR6XZjY9n13tNmnVeqfGPEDn4zEndy7OO437hDuBZKCLqsEXHL2IpizjkLKtED4Y1tSFWdndw8kqTumv8fgLWFZvbv5tFoTi28/mtawVQ+TrYwRIK8Eik1phQF0JgV3K5q+6kqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225627; c=relaxed/simple;
	bh=4e9OV1lO7zq6Z8pylcgU0T0+nkKzPGsrUiLuSsPaYlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cFtRav8OjMRA3D2d32P98+kFR29uFsf2y6R8Mu6RPqHi1t+WJkfG3kLi7oY/d2rpdNpdqlYqbbx7uPDfhDrXVm07wCromgAeqv4or/VpZJbnpr5UKok3+QUZ2U8p6V/Fk4gy4/Gt4yBTW2elpJqEcEreo2f3I048B+fm+j32XSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gJbIaN4D; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gJbIaN4D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=4e9OV1lO7zq6Z8pylcgU0T0+nkKzPGsrUiLuSsPaYlE=; b=gJbIaN4DiOdYOiLe3kXYypq7dq
	6kFZUd4kA4CvYdD3bhD1Ck2cH0YikkL/KtrLoCQQekTtIc95e+UgspA9M0TO2c+8hhXVzHRldNW11
	jFqugpPzOxUJTkWautWnZ/6IsWmGsPjhUgd1T4m6nP+dJmZD5eAhqfsb7ylhW4S+Vjj45Y4UIU4E/
	dD3tqH6sozA6A03UxlDl0fQ/yYbOneho4jADKOXJYuH/2xrELxSfm7JS4hcuYfWf+FYGgaZMvQssf
	kMJei31xIiJsmu4gxQmi3d7pyPPlNQTLqdLQtX2tlTLP4vpodtsm/RbBNNFfmDGBS4wL3OKQM4Z9E
	UvG4SA8UvKtwpz1bMa8kbMB2ZrbIHGH2CXJ0fEI0u1AtWegZrCJ57qfBtVwmbrERtqYTs3e+VjYnL
	cCPRveq/jiDZCeuKxkifO+Tvl6HATI8YvhJHZz/PXia6uWOLT8UV0TXi8psl0sNb//jLkLfaGqu5d
	qmCArrCbvrN/bLk/zS7ZkNnM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2alI-008xub-1T;
	Wed, 09 Apr 2025 19:07:00 +0000
Message-ID: <a5c81acc-1e85-463d-925e-eb5b05af9ee7@samba.org>
Date: Wed, 9 Apr 2025 21:06:58 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Tom Talpey <tom@talpey.com>, Steven French <Steven.French@microsoft.com>,
 Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------bJ0C5iqPbKER7raHFzAq0LXs"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------bJ0C5iqPbKER7raHFzAq0LXs
Content-Type: multipart/mixed; boundary="------------ymg01wZPieuh0cgdJ6fQ0qVI";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Tom Talpey <tom@talpey.com>, Steven French <Steven.French@microsoft.com>,
 Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>,
 Stefan Metzmacher <metze@samba.org>
Message-ID: <a5c81acc-1e85-463d-925e-eb5b05af9ee7@samba.org>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
In-Reply-To: <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
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

--------------ymg01wZPieuh0cgdJ6fQ0qVI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC85LzI1IDg6NDMgUE0sIFN0ZXZlIEZyZW5jaCB3cm90ZToNCj4gT24gV2VkLCBBcHIg
OSwgMjAyNSBhdCAxOjE44oCvUE0gUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz4gd3Jv
dGU6DQo+PiB3aGF0IHNob3VsZCBiZSB0aGUgYmVoYXZpb3Igd2l0aCBTTUIzIFBPU0lYIHdo
ZW4gYSBQT1NJWCBjbGllbnQgdHJpZXMgdG8NCj4+IGRlbGV0ZSBhIGZpbGUgdGhhdCBoYXMg
RklMRV9BVFRSSUJVVEVfUkVBRE9OTFkgc2V0Pw0KPj4NCj4+IFRoZSBtYWpvciBxdWVzdGlv
biB0aGF0IHdlIG11c3QgYW5zd2VyIGlzLCBpZiB0aGlzIHdlIHdvdWxkIHdhbnQgdG8NCj4+
IGFsbG93IGZvciBQT1NJWCBjbGllbnRzIHRvIGlnbm9yZSB0aGlzIGluIHNvbWUgd2F5OiBl
aXRoZXIgY29tcGxldGVseQ0KPj4gaWdub3JlIGl0IG9uIFBPU0lYIGhhbmRsZXMgb3IgZmly
c3QgY2hlY2sgaWYgdGhlIGhhbmRsZSBoYXMgcmVxdWVzdGVkDQo+PiBhbmQgYmVlbiBncmFu
dGVkIFdSSVRFX0FUVFJJQlVURVMgYWNjZXNzLg0KPiANCj4gSSBhZ3JlZSB0aGF0IHRvIGRl
bGV0ZSBhIGZpbGUgd2l0aCBSRUFEX09OTFkgc2V0IHNob3VsZCBieSBkZWZhdWx0IHJlcXVp
cmUNCj4gV1JJVEVfQVRUUklCVVRFUyAoYW5kIGRlbGV0ZSkNCg0KZGVsZXRlIHdpbGwgYmUg
Y2hlY2tlZCB0aGUgdXN1YWwgd2F5LCBzbyBub3RoaW5nIHNwZWNpYWwgdGhlcmUuDQoNCj4g
cGVybWlzc2lvbiAoYmV0dGVyIHRvIGJlIHNhZmUNCj4gaW4gcmVzdHJpY3RpbmcgYSBwb3Rl
bnRpYWwgZGFuZ2Vyb3VzIG9wZXJhdGlvbikuDQoNCnllcywgdGhhdCB3YXMgbXkgdGhvdWdo
dCBhcyB3ZWxsLg0KDQo+IA0KPiBCdXQgdGhpcyBpcyBhIGdvb2QgcXVlc3Rpb24gLi4uDQoN
ClRoYXQncyB3aHkgSSBicm91Z2h0IGl0IHVwIDopKSkNCg0KVGhhbmtzIQ0KLXNsb3cNCg0K
DQo=

--------------ymg01wZPieuh0cgdJ6fQ0qVI--

--------------bJ0C5iqPbKER7raHFzAq0LXs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf2xVIFAwAAAAAACgkQqh6bcSY5nkbB
wBAAtcDohf4Xqd4XL8b2k58vFOMNprsqFejVvNNnK4vzd6PhMp93EbxJyrQVgVXRMTf06KGS0Ij2
Xk4LHR3/NIGEJUos7cWRfl/ERX3s+zrGnKjO0wZiM2aKUKozQfI8/7MoZuvqmFDwSNR35y148P02
qEHUb8rHNrJU9h/JgzW7M4J6DZlLNAnc91C5/ChzUGW1kAPxUV4/5JnBPvX4VqVTeLWb8XCQtoPv
kmuWwt4SdMH7ZrXTXYww+7TyculDgqsh6XXJTtj05mDfI1TfR1yqFzY2xnRhWPu6QDWZnPcRawNC
3yexMa9sy7Qq5esHAUQABw7JoF1rcB0p8C7OdWyoA7TYHDKUMf4WFG2I6isTUuv5OQAz2PIIQLL2
ZrKLxD0tUxByelTyCY+fjf2zcwxCADN5CnXmm+KyKoBFboEnQqMhoJOdnFqngEBTGbOnCOdiijLh
lQMllVh4fjtoPOWjMv4klfVGhTHAOjzTJAALTY/xDmXpjqN9EHNI0+vMp5SFwwnsIncdaTtgGME4
p3ht0ly1tX976y4kpDvHzcwAcIok284HWiBuNGPbqIZmDDWPn+MdYh/q1Tv6kIZuKl8xCkyjZbrX
6OhoiBIC05ubkh+anNQTswZH1e55W35uN0T71l55QP4Ng4XLi716hxQskg0VRjgA60R66GD/Gtz8
3vg=
=7quf
-----END PGP SIGNATURE-----

--------------bJ0C5iqPbKER7raHFzAq0LXs--
