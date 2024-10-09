Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F411E1A20
	for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2024 20:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728504007; cv=none; b=IgRygpcklNHLNE2U3/0SopjY1xYwAt9jdIgesXjUWsbgzqbui4hmgKpDJlZTFtcrVjA6jGiaUctlYpgYJozeWwD305xbN4PorypN961achaLbxKCkZ6CUkxnBVZnYfpwXJdPqFxY6oqnMUWhMc6bbhJ5ePzjuRfro2aA7Ms7aF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728504007; c=relaxed/simple;
	bh=zwbnmqHN8mBoR9K8UBvzVRN9o5r0n5r3mCN7hZY/KYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIFG66+uaqPt+6XeMrnu+NAfvvyo5oQO24wfbjiZmMpLgSBagJxv9YzEguNrqywNyXWbwUWdrkXVcYEXrx/9Df0AFRq4zYK1P009UY6n/Xq4/U9pagQSkSQEWSNWwz3Ayl1r+k9vCvJqm3zQNJJf+77FzAGYXOWTouI/sEmduO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=17kGqdqd; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="17kGqdqd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=zwbnmqHN8mBoR9K8UBvzVRN9o5r0n5r3mCN7hZY/KYo=; b=17kGqdqdr+XxpZol9rB1JWrtwu
	0HxeC01jjXliLRT3kSBWxpCLxz5Pauyec5bnIf4I1dq/DsF8NAMDL69CpTgN9DDo4IRRG/W8pNcCH
	kKdm4qNqImGlFoVOV06FTcHOyQcPXLLDP5+nP4I8Yg+/mmHW7NjMs26V3pp0h12Da3PfyURQ4rFZR
	Me9akYnkKEA0nURvI/O6rsquk5WI5pgOVoE9Xc+wIiKCS/ykF9ShsKPjvs1ucM5uUxfC5PtMzbgB6
	YWn7sldWxpJglJQP1uGAAkzSwCvsnVb3yINpJ/17JOhFyqkEidQh9LiUfj4aShWrTzq2+ukHe2S74
	EiZu7SM1+t42k7r58Zdb4ryJ7ykdvKcbgOdv4697/5A9KoGzSIyv0KM+6e+5cuPR7VMliqDYMYDNq
	BsvvBM3NDIf5xyfd5IFAhX9FsqbpuTnexW9EkBKtQPYKyr049fLKqJFl2vjHcobdWgyyhWHzKUh0t
	6U4mbGDU7syjI6r569YDo0kZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sycqo-00463m-07;
	Wed, 09 Oct 2024 20:00:02 +0000
Message-ID: <b84b2bb0-0afe-4f9e-9553-1a0201ed92d3@samba.org>
Date: Wed, 9 Oct 2024 22:00:01 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HucREB0K7EzXlxYf0iVPQIU5"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HucREB0K7EzXlxYf0iVPQIU5
Content-Type: multipart/mixed; boundary="------------OCcSXARbpOBUeya2ZNhBWmHv";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <b84b2bb0-0afe-4f9e-9553-1a0201ed92d3@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
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

--------------OCcSXARbpOBUeya2ZNhBWmHv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOS8yNCA5OjQzIFBNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4gT24gV2VkLCBP
Y3QgMDksIDIwMjQgYXQgMDg6NTQ6MTJQTSArMDIwMCwgUmFscGggQm9laG1lIHdyb3RlOg0K
Pj4gT24gMTAvOC8yNCA1OjE2IFBNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4+PiBJdCB3
YXMgZG9uZSBhcyBwYXJ0IG9mIHRoZSBTTUIxIGV4dGVuc2lvbnMgLSB0cnlpbmcgdG8gInBh
c3MtdGhyb3VnaCIgDQo+Pj4gYWxsDQo+Pj4gcG9zc2libGUgUE9TSVggb3BlbiBmbGFncy4N
Cj4+Pg0KPj4+IEp1c3QgcmVtb3ZlIGl0Lg0KPj4NCj4+IG9rLg0KPj4NCj4+IEJ1dCB0aGVu
IHdlIHN0aWxsIG5lZWQgYSB3YXkgdG8gcGFzcyBPX0FQUEVORCBvdmVyIHRoZSB3aXJlIHdp
dGggU01CMyANCj4+IFBPU0lYIGFuZCB3ZSdyZSBjdXJyZW50bHkgbGFja2luZyBhIHNhbmUg
d2F5IGl0IHNlZW1zLg0KPj4NCj4+IFdoYXQgYWJvdXQgdXNpbmcgb25lIGJpdCBvZiB0aGUg
MTcgcmVzZXJ2ZWQgYml0cyBpbg0KPj4NCj4+IDxodHRwczovL3d3dy5zYW1iYS5vcmcvfnNs
b3cvU01CM19QT1NJWC8gDQo+PiBmc2NjX3Bvc2l4X2V4dGVuc2lvbnMuaHRtbCNwb3NpeC1t
b2RlPg0KPj4NCj4+IFRoZXJlIGFyZSBtb3JlIHBvc3NpYmx5IGludGVyZXN0aW5nIG9wZW4g
ZmxhZ3MgdGhvdWdoIGFuZCBJIHdvbmRlciANCj4+IHdoZXRoZXIgcGFja2luZyBhbGwgb2Yg
dGhpcyBpbnRvIHRob3NlIDMyIGJpdHMgaXMgYSBnb29kIGlkZWEsIGJ1dCB0aGUgDQo+PiBh
bHRlcm5hdGl2ZSBvZiBjaGFuZ2luZyB0aGUgU01CMl9DUkVBVEVfQ09OVEVYVCByZXF1ZXN0
IHRvIGFkZCBhIG5ldyANCj4+IGZpZWxkICJPcGVuRmxhZ3MiIGlzIG5vdCByZWFsbHkgYSBn
cmVhdCBsb29raW5nIG9wdGlvbiBlaXRoZXIuDQo+IA0KPiBTTUIxLzIvMyBoYXMgRklMRV9B
UFBFTkRfREFUQS4NCj4gDQo+ICDCoEZyb20gdGhlIGRlZmluaXRpb24gb2YgTnRDcmVhdGVG
aWxlICh0aGUgTlQga2VybmVsDQo+IHN5c3RlbSBjYWxsKS4NCj4gDQo+IGh0dHBzOi8vbGVh
cm4ubWljcm9zb2Z0LmNvbS9lbi11cy93aW5kb3dzL3dpbjMyL2FwaS93aW50ZXJubC9uZi0g
DQo+IHdpbnRlcm5sLW50Y3JlYXRlZmlsZQ0KPiANCj4gIklmIG9ubHkgdGhlIEZJTEVfQVBQ
RU5EX0RBVEEgYW5kIFNZTkNIUk9OSVpFIGZsYWdzIGFyZSBzZXQsIHRoZSBjYWxsZXIgDQo+
IGNhbiB3cml0ZSBvbmx5DQo+IHRvIHRoZSBlbmQgb2YgdGhlIGZpbGUsIGFuZCBhbnkgb2Zm
c2V0IGluZm9ybWF0aW9uIG9uIHdyaXRlcyB0byB0aGUgZmlsZSANCj4gaXMgaWdub3JlZC4N
Cj4gSG93ZXZlciwgdGhlIGZpbGUgaXMgYXV0b21hdGljYWxseSBleHRlbmRlZCBhcyBuZWNl
c3NhcnkgZm9yIHRoaXMgdHlwZSANCj4gb2Ygd3JpdGUgb3BlcmF0aW9uLiINCj4gDQo+IENh
biB3ZSBqdXN0IG1hcCAoYWNjZXNzX21hc2sgKEZJTEVfQVBQRU5EX0RBVEF8U1lOQ0hST05J
WkUpKSA9PSAgDQo+IChGSUxFX0FQUEVORF9EQVRBfFNZTkNIUk9OSVpFKSkNCj4gdG8gT19B
UFBFTkQsIHJlZ2FyZGxlc3Mgb2YgUE9TSVggbW9kZSA/DQoNCkhtLCBpbnRlcmVzdGluZyBm
aW5kDQoNCkJ1dCBJIGd1ZXNzIHRoaXMgd29uJ3QgaGVscCBhcyB3aXRoIFBPU0lYIHlvdSBj
YW4gb3BlbigpIGEgZmlsZSB3aXRoIA0KT19BUFBFTkQgYnV0IHRoZW4gc3RpbGwgY2FsbCBw
cmVhZC9wd3JpdGUgb24gdGhlIHJlc3VsdGluZyBmZC4NCg0KSG93ZXZlciwgaWYgd2UgcmVx
dWlyZSBTTUIzIFBPU0lYIGNsaWVudHMgdG8gbWFwIE9fQVBQRU5EIHRvIGFuIA0KYWNjZXNz
X21hc2sgb2YgKm9ubHkqIEZJTEVfQVBQRU5EX0RBVEF8U1lOQ0hST05JWkUsIHByZWFkL3B3
cml0ZSB3b3VsZCANCmZhaWwgYXMgdGhlIGhhbmRsZSBsYWNrcyBGSUxFX1JFQURfREFUQS9G
SUxFX1dSSVRFX0RBVEEuIFJpZ2h0Pw0KDQo=

--------------OCcSXARbpOBUeya2ZNhBWmHv--

--------------HucREB0K7EzXlxYf0iVPQIU5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcG4MEFAwAAAAAACgkQqh6bcSY5nkb/
+xAAisiiEdh4JfaZ2wpESowRTs5AfurIzKa8eEReDGWbApK5e8HLFtUUIxxYIPwd933pqBFMH9XB
XDSKdb+2/k0s/F4G21pdrne/F0WD7mU2xl/i8zIQKx+sMUpKsPLzXYez7lsOe/Y0AunU5e08kwWB
4E81i4/qdt5HFDCMFsC6tS+UOIAY05y88bRknAYver68W4dJ1Guz+fARj1QsOB/ZpXtxbgWHSyme
akbp8e9jy31f+L8Kd73AgiesJiqBCXpLhL0AEZqH1cbrbDfj/NpsaQQW3SjyHfEoF230qqx6zv5d
Z4fxcC891b6F6I6F6CuiAlKQXB1U7goN5xsxtxENP0Wt2NBIZNupCGZmqsOwCmoGRP1IDKCnaaK7
Abk+wXDw1JvPErV8J7n1xhU5BBjfFPIngo9oeAP6oJHfiQJleljXYO6kZurIu/YK7uepRhe5/mhn
xjJdM9DjhBosBXla+rBv/Y1CorahuBW63VjCSyf9wpBMxkoyBnvtsFVLiZo4uo2yV0Jkv1lWm6wQ
LiIrsMmyXLNwcp6gwXdsZ3Jnc4nsOb8sPXFkLJ8gHdYwJ9yhmUxA0iiYNG1ortiLVRJWx7whjDIx
RH4RL2rya/P1wLiByhjpOY9yrtI7lFbzWE1FkNEY8fD0lbwAwBpgZm5tQzdpigVi5Q9UngWQvZ1F
1sw=
=Sn9m
-----END PGP SIGNATURE-----

--------------HucREB0K7EzXlxYf0iVPQIU5--
