Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3158537C90F
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 10:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773744849; cv=none; b=Zp+3mcawfKWA4ST1qJ1pE8WBit3E7HHauFFUwp11m05OYLhEzVbkeNuCd6WaH9hypCeVMMaBO6b9UPGKyyVJLQaFixn3edtysdI8jRTWXsJEUhtSNx9DdPCYOcrNyrpUyvOEU+gK5oCyeKz/e8dj3t6+LrAhFP29CWGDrTAADbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773744849; c=relaxed/simple;
	bh=0s5cAzlUOVtm8msUiLSNyQgNEgHEtgHuOWriE+JTnoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyvkjlZfboOHVAR+w0Z4lpzZiA/2ZiQLsCq0N14tShOxFCN5VM+wr+uZQIGAE99Ij9OCrfTj2aOssR1WirHHOBv4NODGMyskbEar8zG/1Hrhj+E4xCDPyoz7zklzCg9SfJ5+0GCBAFbBlGgn36sAmG/TbJs8YZihS0VEC8EWPw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=A45kn5MM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="A45kn5MM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=0s5cAzlUOVtm8msUiLSNyQgNEgHEtgHuOWriE+JTnoI=; b=A45kn5MMnPGyYhdwI7VFoORb75
	4Kbo7Xfh5gBw+WCJ+leThcvT6GaVZEjfT91gfYi7+0/J6mnIgn1TiqlVTeEpnUrEiy+zc8CG/TN35
	70T1uBRkGEsvbkUAH4lxYWfjS4ZU0IgnUrRGrddd7jmJ7gl9e0PcDWeVuzdeZVK52ArYyuStHj7gp
	7hY6q/E543IAhIVOcgz/lceSZWmcf0bneBcF+wQZxVJVeJp1gfjV7Cav1Rh6g0esLWZ8mH8N4wZ7W
	gA1au1+UhuYQUltRZBwGRJUAAyodvky7nG8L2WSFXTzhgqg17BLj3pPVGA2gFyE3+zBkmV3P/5wYn
	vSDq7vJudqeNXXx8slA1gy5KttwQyq9ZN0qFUi4r3Hzjph9xvRtYPAs1cMMoFCg1pNQTrs+j9za4M
	i3xeXO3tVQyMgpGQuZnZeFOnmGzpwHXX2W0VFtVyeG3v7rnHYUi1KvBmSHAFZ6RWEY5nD96S5E7v2
	ihBhL6uPdrKaMZSG/NmxChvP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1w2S3p-00000001hfV-02Pc;
	Tue, 17 Mar 2026 10:54:05 +0000
Message-ID: <a868b5e3-a7e6-44ba-89e4-40912794f25a@samba.org>
Date: Tue, 17 Mar 2026 11:54:04 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB3 POSIX, byterange locks and close behaviour
To: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>
Cc: Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>,
 CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
 <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
 <CAH2r5mvkGKex_Z+VAZtuZbAEzHM+Ov3O=TH_K4K1_RXVg9iZLA@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mvkGKex_Z+VAZtuZbAEzHM+Ov3O=TH_K4K1_RXVg9iZLA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------w8IWnXfCEUXysW3w8pI92lHU"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------w8IWnXfCEUXysW3w8pI92lHU
Content-Type: multipart/mixed; boundary="------------G0JvZwgtTRxodCW5E3gU3OkR";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>
Cc: Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>,
 CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <a868b5e3-a7e6-44ba-89e4-40912794f25a@samba.org>
Subject: Re: SMB3 POSIX, byterange locks and close behaviour
References: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
 <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
 <CAH2r5mvkGKex_Z+VAZtuZbAEzHM+Ov3O=TH_K4K1_RXVg9iZLA@mail.gmail.com>
In-Reply-To: <CAH2r5mvkGKex_Z+VAZtuZbAEzHM+Ov3O=TH_K4K1_RXVg9iZLA@mail.gmail.com>
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

--------------G0JvZwgtTRxodCW5E3gU3OkR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xNi8yNiAzOjQ5IFBNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+Pj4gVGhvdWdodHM/
IEFtIEkgbWlzc2luZyBzb21ldGhpbmc/DQo+Pg0KPj4gSSB0aGluayBpdCdzIHRoZSBqb2Ig
b2YgdGhlIGNsaWVudCB0byBjb29yZGluYXRlIGl0cyBsb2NhbCBwcm9jZXNzZXMuDQo+IA0K
PiBZZXMuDQoNCk5vLiA6KSBBcyBkZXNjcmliZWQgaW4gdGhlIG90aGVyIG1haWwgSSBqdXN0
IHNlbmQ6IGZvciBXaW5kb3dzIHRoZXJlJ3MgDQpubyBwcm9ibGVtIGF0IGFsbCwgc28gV2lu
ZG93cyBjbGllbnQgZG9lc24ndCBkbyBhbnkgImNvb3JkaW5hdGlvbiIuDQoNCkkgZ3Vlc3Mg
YSBjbGllbnQgbWlnaHQgYmUgYWxsb3dlZCB0byAib3B0aW1pemUiIGJ5IHJlc3Vpbmcgb3Bl
bnMsIGJ1dCANCnRoYXQncyBhIGRpZmZlcmVudCBzdG9yeS4gQXMgc29vbiBhcyB5b3UgaGF2
ZSBpbmNvbXBhdGlibGUgb3BlbnMsIHNheSANCm9uZSByZWFkLW9ubHkgYW5kIGEgc2Vjb25k
IHJlYWQtd3JpdGUsIHlvdSBjYW4ndCByZXVzZS4NCg0KPiBCdXQgaXQgd291bGQgYmUgZ29v
ZCB0byBoYXZlIGEgdGVzdCBjYXNlIHRvIHJlcHJvIHRoaXMgdG8gbWFrZQ0KPiBzdXJlIGNs
aWVudCBkb2VzIHByb3BlciBiZWhhdmlvci4gIEluIG1hbnkgY2FzZXMgdGhlIGNsaWVudCB3
aWxsIHJldXNlDQo+IHRoZSBzYW1lIG9wZW4gaGFuZGxlIGZvciBtdWx0aXBsZSBwcm9jZXNz
ZXMsIGJ1dCBpbiBjYXNlcyB3aGVyZSB3ZQ0KPiBoYXZlIHR3byBoYW5kbGVzIG9wZW4sIGl0
IHdvdWxkIGJlIGdvb2QgdG8gaGF2ZSBhIHRlc3QgY2FzZSB0byByZXBybw0KPiB0aGlzLg0K
DQpUZXN0Y2FzZToNCi0gY29ubmVjdCB0byBzZXJ2ZXIgd2l0aCBTTUIzIFBPU0lYDQotIDFz
dCBvcGVuIHdpdGggT19SRE9OTFkNCi0gMm5kIG9wZW4gd2l0aCBPX1JEV1IgKHRvIGJ5cGFz
cyBhbnkgcG9zc2libGUgY2xpZW50IHNpZGUgb3BlbiByZXVzZSkNCi0gcGxhY2Ugc2hhcmVk
IGxvY2sgcmFuZ2UgWzAsMV0gb24gMXN0IG9wZW4NCi0gcGxhY2UgZXhjbHVzaXZlIGxvY2sg
b24gcmFuZ2UgWzIsM10gb24gMm5kIG9wZW4NCi0gY2xvc2UgMXN0IGhhbmRsZSAoYWNjb3Jk
aW5nIHRvIFBPU0lYIHRoaXMgc2hvdWxkIGRyb3AgYm90aCBsb2NrcykNCi0gcGxhY2UgZXhj
bHVzaXZlIGxvY2sgb24gcmFuZ2UgWzAsM10gLT4gc2hvdWxkIHdvcmsNCg0KSSdtIGdvaW5n
IHRvIGFkZCB0aGlzIGEgdGVzdCB0byB0aGUgU2FtYmEgdGVzdHN1aXRlLCBteSBleHBlY3Rh
dGlvbiANCmJlaW5nIHRoYXQgaXQgd2lsbCBmYWlsLg0K

--------------G0JvZwgtTRxodCW5E3gU3OkR--

--------------w8IWnXfCEUXysW3w8pI92lHU
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmm5MswFAwAAAAAACgkQqh6bcSY5nkZ6
pxAAuU+OoxS895dV2vvoNoGKEXy0c8IJ1GFvc1w+5RNZC+nZkWqAPnUG8EnIzzSPVevBvWTY7BW3
dyNXHnpL9RN/oHb4orETvL6Mk+RTN51m/szBIJJ6Zp+8gnSE05rb4bpdrxh1L9K+YK+tqTRSliPU
NghH4qkJ9uTML3+uqdlY25A6GVl/MXMoEqjPOcth7ELjxPsF1y6gb5Nb4U6p5DODuV4M/eKdtIXq
vgmbsdBNEeD4u8WReVKbyC3sppYuO/wTCmPf+HDl73Ibjrgkcrdwa5oC2h+bETGeJzvvhaB6l6tr
MgfryO1IvhYnA55/MQShSUP5LwuyT1GruaMmUlj7KSfXeXuOj+ZrUBoAoP8v68Z/yDkxoAzNWErJ
a0+c7qxCOdt6KWD9sq8DjICGa2rC915OwO/DHWRdWsg3ZfPg+lLCS0MFh5RAXX4/qswoiokWTVJi
84+MJa5dD79GYb7drPxdqwo3rGobH9q1SZOP58pgC/DXlm6gDBV+nORLovyAgGASbG0z4lxs50rl
V0lZna1fZLrLe11k3HEZqvECj6wm1Mgv823gY4CNpwwtm9VuuBpabYY7L56Wj/NaAGNRbvWP7CZD
N8JKgiDO/q7gzZFZrVL22hwDqLwDnhrBEpkoAUeg0gk+ykqZM0jAmC0gMRLm0Nn81wL048Dg5qcb
URI=
=JBLl
-----END PGP SIGNATURE-----

--------------w8IWnXfCEUXysW3w8pI92lHU--
