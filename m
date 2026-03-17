Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E1235E955
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773744407; cv=none; b=EoWYFt4HkOYamg7m+hwCa3cwgECSGF+bPLEAKZs2rnQW7iURnjlfOej2pZ1X6uMq5Nzmzg+Wf1XrVEKgBJtn2yZ5rDuBhOpsSNrzcI9lyx8oKT0d02w5GSRQrVlVadGAT54mb8L6YmuhVjcyyPxTrYuRuVRoODWbfbIvUkVobj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773744407; c=relaxed/simple;
	bh=QKGS3lq/z1skjNdCDgLywQTK2o4+/rewdIcDYZURbj4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WGbqTEXtzOw6KAzxapYPFaEqh5Q/HmA3mukvOlX6Ogm2Y9amHy9cCgAdLtJSBbF92CBNrRiO7rD7KfWVY3CFFgJMIy0xN8ZnpCbpJIekH5miosJyf0ixA4QbvxYIPjBN02CG5ZJfdER1rf3z2zhsl0S3LRUsTePWeyvquV3Y2bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YLFwMPcH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YLFwMPcH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=QKGS3lq/z1skjNdCDgLywQTK2o4+/rewdIcDYZURbj4=; b=YLFwMPcH9B/5nnv1UYG1S0nwIv
	FIiaSLE9m0oiuwjV0C/3b9n3UacY87g115x4irNQC0u/1sgrr6ycizzQtfCqv1jA2QQDh2TvWxoLn
	DSceS6UmSKD0cwDIdyxoSMvCfjBn+TduiHaS2f//ALWKZ4u74HOoZvxxNyzBsiRgzPW8w6KD5CvHh
	HeeyNUQ/JqIWgsk4KFbe0eUu2dsO1uSGqJjlt06kMtuMZph18mJ+6gp4EWP9DnRIAqwujor4Pf1Za
	gkMquafbn9Qo+VY6WGzPNHBvf0KJYOyTy2KF9Zoo8WVdwpLt6ZTs6S/tZejE+E2ajd1ECrPGdkFQ5
	mZH0O5YJjg9H25Bbu6n5UG9oJqxkFa33r2m2lm8TF2OEmBPe9VC4YdbtezXkECcLPWPYRJwxWwvFV
	gpJg9hAytEs1WJ648HLKb+4+jEPwWG9yuU61hKQh7237Ih6DgV4w0J1TMrKm5xz6YPw8OUmAWDdxl
	ucy/r5SUzdYa+cIStVef9r1H;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1w2RwZ-00000001hYa-1mr4;
	Tue, 17 Mar 2026 10:46:35 +0000
Message-ID: <5f88504b-d1cb-4446-81fc-e526dd7a7c88@samba.org>
Date: Tue, 17 Mar 2026 11:46:34 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ralph Boehme <slow@samba.org>
Subject: Re: SMB3 POSIX, byterange locks and close behaviour
To: Stefan Metzmacher <metze@samba.org>, Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
 <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6a8FKRQumllM9lA0Px7qfuul"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6a8FKRQumllM9lA0Px7qfuul
Content-Type: multipart/mixed; boundary="------------5uo5LdgF4MPTS00KvZHLvr22";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Stefan Metzmacher <metze@samba.org>, Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <5f88504b-d1cb-4446-81fc-e526dd7a7c88@samba.org>
Subject: Re: SMB3 POSIX, byterange locks and close behaviour
References: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
 <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
In-Reply-To: <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
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

--------------5uo5LdgF4MPTS00KvZHLvr22
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xNi8yNiAxMjo0NiBQTSwgU3RlZmFuIE1ldHptYWNoZXIgd3JvdGU6DQo+PiBUaG91
Z2h0cz8gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCj4gDQo+IEkgdGhpbmsgaXQncyB0aGUg
am9iIG9mIHRoZSBjbGllbnQgdG8gY29vcmRpbmF0ZSBpdHMgbG9jYWwgcHJvY2Vzc2VzLg0K
DQpXZWxsLCBmb3IgV2luZG93cyB0byBXaW5kb3dzIHRoZXJlIGlzIGFjdHVhbGx5IG5vIHBy
b2JsZW0gd2l0aCB0aGUgDQpsb2NraW5nIHNlbWFudGljcyBhbmQgbm8gbmVlZCB0byBjb29y
ZGluYXRlLCBhcyBmb3IgV2luZG93cyB0aGUgc2ltcGxlIA0KcnVsZSBmcm9tIE1TLUZTQSAy
LjEuNS41ICJTZXJ2ZXIgUmVxdWVzdHMgQ2xvc2luZyBhbiBPcGVuIiB3b3JrcyBqdXN0IGZp
bmU6DQotLS04PC0tLQ0KQWxsIGVsZW1lbnRzIGZyb20gT3Blbi5TdHJlYW0uQnl0ZVJhbmdl
TG9ja0xpc3Qgd2hlcmUgDQpCeXRlUmFuZ2VMb2NrLk93bmVyT3BlbiA9PSBPcGVuIE1VU1Qg
YmUgcmVtb3ZlZC4NCi0tLTg8LS0tDQoNClRoZSBwcm9ibGVtIG9ubHkgZXhpc3RzIGlmIHdl
IHdhbnRlZCB0byBoYXZlIFBPU0lYIGxvY2sgc2VtYW50aWNzIG92ZXIgU01CLg0KDQo+IEkg
Z3Vlc3MgdGhlIGNsaWVudCBjYW4gaGF2ZSBqdXN0IGEgc2luZ2xlIG9wZW4gdG8gdGhlIHNl
cnZlciBmb3IgbG9jYWwgDQo+IGZkMSBhbmQgZmQyLA0KPiBidXQgaW4gdGhlIGVuZCBpdCdz
IGEgbG9jYWwgcHJvYmxlbSBvbiB0aGUgY2xpZW50Lg0KDQpKdXN0IGNoZWNrZWQgd2l0aCBh
IHNpbXBsZSBwb3dlcnNoZWxsIHNjcmlwdCBmcm9tIGEgV2luZG93cyBjbGllbnQgZG9pbmcg
DQp0d28gb3BlbnMgb24gdGhlIHNhbWUgZmlsZTogYm90aCBvcGVucyBhcmUgc2VudCB0byB0
aGUgc2VydmVyLg0KDQpJdCdzIG5vdCBhIGNsaWVudCBwcm9ibGVtIGFzIFdpbmRvd3MgY2xp
ZW50IGRvbid0IGhhdmUgYSBwcm9ibGVtLi4uDQoNCkFsc28sIHJldXNpbmcgb3BlbnMgbG9j
YWxseSBvbiB0aGUgY2xpZW50IGlzIG9ubHkgcG9zc2libGUgZm9yIA0KY29tcGF0aWJsZSBv
cGVucy4NCg0KPiBJIGd1ZXNzIGEgV2luZG93cyBjbGllbnQgaGFzIHRvIHNvbHZlIHNpbWls
YXIgcHJvYmxlbXMgd2l0aCBtdWx0aXBsZQ0KPiBhcHBsaWNhdGlvbnMgcnVubmluZy4NCg0K
Tm8sIHRoYXQncyB0aGUgcG9pbnQsIFdpbmRvd3MgbG9jayBqdXN0IGRvbid0IHN1ZmZlciBm
cm9tIHRoZSBwcm9ibGVtLg0KDQpUaGlua2luZyBhIGJpdCBtb3JlIGFib3V0IE9GRCBsb2Nr
czogSSdtIG5vdCBzdXJlIHdoeSBJIHdhcyB0aGlua2luZyANCnRoYXQgaXQgd291bGQgYWxz
byBub3QgYmUgcG9zc2libGUgdG8gaW1wbGVtZW50IE9GRCBsb2NrcyBiZWhhdmlvdXIgb3Zl
ciANCnB1cmUgU01CMiB3aXRob3V0IGV4dGVuc2lvbnMsIHdpdGggc29tZSBzZXJ2ZXIgb3Ig
Y2xpZW50IHNpZGUgZXh0cmEgDQpoYW5kbGluZyBvZiBsb2NrIHR5cGUgY29udmVyc2lvbiwg
c3BsaXR0aW5nLCBzaHJpbmtpbmcsIG9yIGNvYWxlc2NpbmcgDQp3aXRoIGFuIGV4aXN0aW5n
IGxvY2suDQo=

--------------5uo5LdgF4MPTS00KvZHLvr22--

--------------6a8FKRQumllM9lA0Px7qfuul
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmm5MQoFAwAAAAAACgkQqh6bcSY5nkae
Ng/8Db8sO+0uT3f8RbdswUC5ENbYu29xT75QdRdx5/lnzbgTv6kiKobgu4LCvXBHiaS7k3GdQpWH
FbMYcyF686itUxICad+3JNF0gIwJwcpp2wIgdaRDScwDM9W9RskZn7hH5bmIxDkbZi7RPZ5pqjPW
t++ag9+YYnkBESgajKu/CK8L3hxs29/HkUshgG6yLIi13OXLAE4xEamxC+hkGNE+t/f5fkPT9TnX
HBLWLsQtGYSxlKtsb5z/+UhUsRXTvvpFm0vWagAwS2bQG4XDwljM1WqL1PMFY/iFcafwi2nmVPf4
PiY7QfgPEvpGnz+eZ6S4nQY/PXdg4cVMxIYG4Ae48GOQnm34iinI30XPqZjHl8BCu61GKx127Xdz
0s5A2el8+J2mOlzKTi2aZBKvVVX++HDdfHpLjLmBU/6NZAAxrdxRFI9dOPQcdWKbUMRrIixhI9K4
K38Wjztsmr0nEOpdnfMq7uKoTonZ2lfniBM2RNK3+1QCpE6hkZmuxlJZzWjPjen7V1ZoD5cUhjMN
WY+h+Mn3HwNvHCf0w74sJN6s32QreuHimwU5TrdqHeiYcsCoIvOX8ZjZRQNVnHhJQfwEfCQgHvk3
vGKBgJF7CCbd9JPZHu9iXvO/KFNXTH3MOm+P7+s0cVY2P6nSsUOGgwO3t4k47gcOkaZlva9jE6Ss
+WY=
=K3hg
-----END PGP SIGNATURE-----

--------------6a8FKRQumllM9lA0Px7qfuul--
