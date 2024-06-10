Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2080D7404B
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 21:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718054399; cv=none; b=bvL1sFF3fMeZvmrraP9bvBOQO+rK3uZhDsmwHhd26e7WEnA0AOGioznPXq8Yl1bDvexETNQHsjBFyTAD3FHWcz21pT0j5rYrEIiSYQrZxpotwTKR/PfIUmFf8UgAjXsxB7xYhLV1IzwGhqMF5m3qbdjmhaynzn35n3lGHySq5jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718054399; c=relaxed/simple;
	bh=43vDiBYJuuZqKdNbfh/vojfrr2KNv3Bt8+WFQYIvJD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lJNXlsSJBtl3GA3qqwbMRhT236Mb85qoRHBllPZPY93a5Pj+jdbFdd+8iM5qheNuzFK2jMgTbvNItigff+gKYxRfRnefUZhg7NGa2dhyg0IBgt76CDKg3aGzv/zXeFtglQbc33WGVPkB56UlJ2+cQH7dw2gRSRVkRBTIJzy+sWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=r+WJWEI1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="r+WJWEI1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=43vDiBYJuuZqKdNbfh/vojfrr2KNv3Bt8+WFQYIvJD0=; b=r+WJWEI1HmXuu0/rjp0RIV68ej
	wG5Y1o5DCzCs75YM7m47NO8dxszAEM33T4QBhqWrPIF9IWA2z1zfEPwDBOUwJHWJIPRr/J1QiyBV1
	z1imDMvYho/fvVBwdyXa0rkJStvv1H56n2kavB9oGy6wULAJSKN44rAUvZWBg9+l2lhUWDI/TsPEc
	iDnWcG0jhna1JJz0KVJBQDKSMxASDpIUFaoTHFg2/XBurLluO6gnSEwdgdq5cM52/8ST0YyEyTdTb
	AY+N3kddKFRyIxFj+MCePIdsEBCcwClNKF4FkrFraSmaTFywU63F0IFrd+Vawq4le25953haq16pO
	a2J0/TqpVxZ2DuKAE5s5RoeYmDX3Ek9/m5EOBVN6ZwLpZQxEeOKEpT4CidEkUbNcdjaLT+kUVaDwA
	7DFDhyfMoEUmPV4XPv53H3HVHzHntxF8ZFJqFASL6jtyhuIObdRQ1xTeJ/sLaNWwuxM4jhZiG6aXV
	MZPJ1J1wISHetMAsVLWSZdTb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sGmQk-00G1eh-0S;
	Mon, 10 Jun 2024 21:19:54 +0000
Message-ID: <0a043592-7034-4478-9969-9c17983886fb@samba.org>
Date: Mon, 10 Jun 2024 23:19:53 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Steve French <smfrench@gmail.com>, Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org
References: <5659539.ZASKD2KPVS@wintermute>
 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
 <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
 <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iPy1vZPSzhVvePsZpOnuJRYj"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------iPy1vZPSzhVvePsZpOnuJRYj
Content-Type: multipart/mixed; boundary="------------1lgjFsJDANVVPtUGfXBccn20";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org
Message-ID: <0a043592-7034-4478-9969-9c17983886fb@samba.org>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
References: <5659539.ZASKD2KPVS@wintermute>
 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
 <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
 <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
In-Reply-To: <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>

--------------1lgjFsJDANVVPtUGfXBccn20
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xMC8yNCAxMDo1MyBQTSwgU3RldmUgRnJlbmNoIHdyb3RlOg0KPiBPbiBNb24sIEp1
biAxMCwgMjAyNCBhdCAzOjQ44oCvUE0gQW5kcmV3IEJhcnRsZXR0IDxhYmFydGxldEBzYW1i
YS5vcmc+IHdyb3RlOg0KPj4NCj4+IE9uIE1vbiwgMjAyNC0wNi0xMCBhdCAxNTowNSAtMDUw
MCwgU3RldmUgRnJlbmNoIHdyb3RlOg0KPj4NCj4+IFllcyAtIHRoZSByZXByb2R1Y2VyIGhl
bHBzLiAgVGhlIGJ1ZyBpcyBlYXN5IHRvIHJlcHJvZHVjZS4NCj4+DQo+Pg0KPj4gSSB3YW50
ZWQgdG8gdmVyaWZ5IHRoYXQgdGhlIHN1Y2NlZWRpbmcgY2FzZXMgYXJlIHRoZSBzYW1lIHRo
YXQgSSBzZWU6DQo+Pg0KPj4gLSB3b3JrcyB3aXRoICJjYWNoZT1ub25lIg0KPj4NCj4+IGFu
ZA0KPj4NCj4+IC0gd29ya3Mgd2l0aCAibm9icmwiDQo+Pg0KPj4gYW5kDQo+Pg0KPj4gLSB3
b3JrcyB3aXRoICJ2ZXJzPTEuMCINCj4+DQo+Pg0KPj4gQWxsIG90aGVyIGNvbWJpbmF0aW9u
cyBmYWlsIC4uLg0KPj4NCj4+DQo+PiBTaG91bGQgYmUgc3RyYWlnaHRmb3J3YXJkIHRvIGZp
eCBpbiBjaWZzLmtvLiAgV2lsbCBsb29rIGF0IGEgZml4IGZvcg0KPj4NCj4+IHRoaXMgbGF0
ZXIgdG9kYXkuDQo+Pg0KPj4NCj4+IEF3ZXNvbWUsIHRoYW5rcy4NCj4+DQo+Pg0KPj4gTm90
ZSB0aGF0IHRoZSBwcm9ibGVtIHdpdGggU01CMy4xLjEgUE9TSVggZXh0ZW5zaW9ucyBpcyBh
IFNhbWJhIGJ1ZyAtDQo+Pg0KPj4gYSBzZXJpb3VzIHJlZ3Jlc3Npb24gaW4gdGhlIHNlcnZl
ciAoYnV0IHRyaXZpYWwgZml4KS4gIFdlIGFyZSB3YWl0aW5nDQo+Pg0KPj4gb24gc29tZW9u
ZSB0byBtZXJnZSB0aGUgb25lbGluZSBmaXggdG8gdGhlIHNlcnZlciAod2hpY2ggd2UgdGVz
dGVkIG91dA0KPj4NCj4+IG9rKSBmcm9tIERhdmlkLg0KDQpubywgUmFscGguDQoNCj4+DQo+
Pg0KPj4gSXMgdGhlcmUgYW4gTVIgZm9yIHRoaXM/ICBJIGNvdWxkbid0IGZpbmQgaXQuDQo+
IA0KPiBJIHdhcyBwdXp6bGVkIHdoeSB0aGVyZSB3YXNuJ3QgYSBmaXggaW1tZWRpYXRlbHkg
YXBwbGllZCBzaW5jZSBpdCB3YXMNCj4gdGVzdGVkIChhbmQgY291bGQgYWRkIG15IFJldmll
d2VkLWJ5IGlmIHRoYXQgaGVscGVkKSwNCg0KYXMgd3JpdHRlbiBiZWZvcmUNCg0KZml4ICsg
dGVzdCA9IE1SICsgcmV2aWV3ID0gbWFzdGVyDQoNClRoZSB0ZXN0IGlzIHN0aWxsIG1pc3Np
bmcgYW5kIEkgd2FzIG9uIHZhY2F0aW9uIGFuZCBhbSBzd2FtcGVkIHdpdGggd29yay4NCg0K
VGhhbmtzIQ0KDQo=

--------------1lgjFsJDANVVPtUGfXBccn20--

--------------iPy1vZPSzhVvePsZpOnuJRYj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmZnbfkFAwAAAAAACgkQqh6bcSY5nkbC
fw/+MvEOXzLfNAj9JAjgb8GO2HxGKyEDeMarOzAsHxdvI1nb7E+ZmjekLzlcDgJspIfbyNiKPqrR
0PKQIZgDAPfymwKcJfmxjIXZugTrDzmDEFjlhPRJymyYm1L7H48fKr7+4iFYM4CZij/eHXgqL3tW
SaMp3AUC3NhcqQY1mImo9qMkRK+4xJVLwwimy0V6LmzyyhyYcMn3bAmBnww6/15fh9zqQiH+/x69
FdyiLlhDfAijPsfMxR2f1l5ug2oaDj6Rd6XJPA1PA8kJeegtJevBYyK8BP0BjEvsUJsp6fVEicDo
rjyAniAsbVf38dsivWmENDofuVWZihEVfsw2UGGE6EtSWIoxFBVJPNBAncQVCmZK9zfROUjwaiqp
gcu7pZr7axjhLBdpK0hDqXKlWQvN7wSsG0al/5t/xXyNu0VMr4l+Ph/VpS7TKVhss2EB4yfxJWVE
Qg8BYWltoLWVozfD//w1NkfmLot91BTkT6tuqPd7zbs5nIh4nv5D9lrho6eq05nmC7ab2BOfz0zs
+Gp3ny5WarxsYmRCM4TTWY6qO/XmMlDAbEj0R92DdF6cr4vFno8s+CoL+p5p6fpnLgwNVhj6ry5s
gwj12kKsHJhl/LOSjNSMQIUoZ16mPvPyUX1YMy+DuV/VGDterClG+hkWDIe1gRT7zwCDd7730+/X
rdM=
=Ew9L
-----END PGP SIGNATURE-----

--------------iPy1vZPSzhVvePsZpOnuJRYj--
