Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162138F80
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 08:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744273931; cv=none; b=mV9YxwW3AMLDMz7o1rdh+gE2k9/St7A8atixc6cMmGrtaxzuVmRPAZ6mp3VuLdILKgmhsA9/76kG+fziz5+b36Mple7vkZt5GQaT/CSwX/gJhsiMV3nh3qYlW/WyDIuaKRw6HpvybiUHWk1RK+8fH3vpLDPjk69bSXCYBjFD+Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744273931; c=relaxed/simple;
	bh=MUPrFxy1OY4M37SJZ3j1CQ7mxTbB3uFy1xFtAvpL15Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pyxnF92pZCAQqHnij1yBoZmSeFJViUTsjEudxZANiLY4cIseribz1wGJcuLXYxMetG6+HE39FukpGz6X25tF9Drll7GgWrSqJHDCpgX4rO+DLzq90LUK3gBinU+X9n8dJ4tKKqxR+klWyOMnuyeJoRLnlqsgCeOxrhI4QyP96RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fF4c+tfz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fF4c+tfz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=MUPrFxy1OY4M37SJZ3j1CQ7mxTbB3uFy1xFtAvpL15Y=; b=fF4c+tfzTjvLPPOzbP03vqCqYg
	czF+Ua48VjlOBon96WZhawyuVtRrTDKO1r0L46sQFGC8xdkvCrfCJ61kAlyzMAppy/fdH9EGqpVE3
	QPP61eSbsfMmgsrVDQuMso37BnVY+epHGrD3G5qeYgoAsUBGpeG7lbXdCiVDGNSUWQXnrJKCB8i8D
	CKnQm1SOr/6ImvWZX83LeVZNWoOrhUF+KMN2B+K38piN1Cu4DHLK/XAnhBhcv/CD3RBbEwduSQGHf
	lrr/xFgTq2LdxovoZf0T1+ieCcqFqEniLN7S7aJll2081At8YIX3ZDcSxFwziKgn5c4IHwk6zfBUJ
	oW8t0AWtlyHJCyb7hAeYcnDmPB7ICtfped9QJwFIhxFmoIzt4R2ZSteFRNg/f7Pbpe/VwWh5YP4Wc
	QqK4Ar5qzWSOkcngVyI0yxwPRr406YKAApUUJXMFf9ift5E9QXcl3X/kU7wnyDZvviDliOFBb3Q4B
	OeNUNhN5NkJ/FTG1+vR15HSv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2nKJ-0094Ry-2c;
	Thu, 10 Apr 2025 08:31:59 +0000
Message-ID: <085204d2-22e6-4de6-aeec-620dba38280b@samba.org>
Date: Thu, 10 Apr 2025 10:31:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>,
 "vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
 <a5c81acc-1e85-463d-925e-eb5b05af9ee7@samba.org>
 <a60852f5-cb90-4614-b35c-91d6507aee0a@talpey.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 xsFNBFRbb/sBEADGFqSo7Ya3S00RsDWC7O4esYxuo+J5PapFMKvFNiYvpNEAoHnoJkzT6bCG
 eZWlARe4Ihmry9XV67v/DUa3qXYihV62jmiTgCyEu1HFGhWGzkk99Vahq/2kVgN4vwz8zep1
 uvTAx4sgouL2Ri4HqeOdGveTQKQY4oOnWpEhXZ2qeCAc3fTHEB1FmRrZJp7A7y0C8/NEXnxT
 vfCZc7jsbanZAAUpQCGve+ilqn3px5Xo+1HZPnmfOrDODGo0qS/eJFnZ3aEy9y906I60fW27
 W+y++xX/8a1w76mi1nRGYQX7e8oAWshijPiM0X8hQNs91EW1TvUjvI7SiELEui0/OX/3cvR8
 kEEAmGlths99W+jigK15KbeWOO3OJdyCfY/Rimse4rJfVe41BdEF3J0z6YzaFQoJORXm0M8y
 O5OxpAZFYuhywfx8eCf4Cgzir7jFOKaDaRaFwlVRIOJwXlvidDuiKBfCcMzVafxn5wTyt/qy
 gcmvaHH/2qerqhfMI09kus0NfudYnbSjtpNcskecwJNEpo8BG9HVgwF9H/hiI9oh2BGBng7f
 bcz9sx2tGtQJpxKoBN91zuH0fWj7HYBX6FLnnD+m4ve2Avrg/H0Mk6pnvuTj5FxW5oqz9Dk1
 1HDrco3/+4hFVaCJezv8THsyU7MLc8V2WmZGYiaRanbEb2CoSQARAQABzR1SYWxwaCBCw7Zo
 bWUgPHNsb3dAc2FtYmEub3JnPsLBlwQTAQgAQQIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIX
 gAIZARYhBPrixgiKJCUgUcVZ5Koem3EmOZ5GBQJllYCkBQkU/N31AAoJEKoem3EmOZ5GlzsP
 +gKNsDpixJ4fzvrEnsItxZuJgMfrdBAz8frY2DBnz/k74sNlW0CfwwU2yRuoEgKiVHX5N24U
 W+iju9knJDUFKb/A5C+D9HbuGVeiuiS59JwHqBxhtGXUYOafXt5JE0LKNdPDtUrx41i6wXBJ
 qXwvT8+gvc86+hp4ZujygyUuR9If8HXWhH10aTiPVte3lTGZjrZsqhY+MASG+Qxipk2a1f85
 jDLbLndtrKbf89AGqx4SRPRYGtNrqR2rDhqySNVzR8SquNTdvKvnrUIJkNSmVMsB6OOQc+Lh
 9gz9hHG8MXjKq6dz7q0JZE7enD/gFeK2CWI1pTjkHVQ9qXqkT7nQdrs1net5IPgXgNFxCLjj
 93ipRMoGh0H8GLMuOWksnyB3Lq1KnyPb7RBV9Apo7juz/Cp8KYqvr0s50b3pblB2NmDTNcxZ
 CkVLhWMGF4bJQvG4SNxarDC5aIwV+KLgLo24gaKV4+ubgMkLzyNoS1Ko4//FesfN8dgIhI3g
 wTJtzQ8hoRthoZRdjsGtZsw9OFZSc6Pp9v+988lTYpdOzl3CGfPpKcNry9ybQ+1teQkaI0fs
 GvG6MLviuuZizBpmBVMY++SpejHuxCF55WmClkMi+4dki5AG0UvFDrwTVKtKxLG4JX5kPDa7
 R6ssRM0q8yPlBCWtotp7Wz0gM/ub50DS09KJzsFNBFRbb/sBEADCSnUsQShBPcAPJQH9DMQN
 nCO3tUZ32mx32S/WD5ykiVpeIxpEa2X/QpS8d5c8OUh5ALB4uTUgrQqczXhWUwGHPAV2PW0s
 /S4NUXsCs/Mdry2ANNk/mfSMtQMr6j2ptg/Mb79FZAqSeNbS81KcfsWPwhALgeImYUw3JoyY
 g1KWgROltG+LC32vnDDTotcU8yekg4bKZ3lekVODxk0doZl8mFvDTAiHFK9O5Y1azeJaSMFk
 NE/BNHsI/deDzGkiV9HhRwge7/e4l4uJI0dPtLpGNELPq7fty97OvjxUc9dRfQDQ9CUBzovg
 3rprpuxVNRktSpKAdaZzbTPLj8IcyKoFLQ+MqdaI7oak2Wr5dTCXldbByB0i4UweEyFs32WP
 NkJoGWq2P8zH9aKmc2wE7CHz7RyR7hE9m7NeGrUyqNKA8QpCEhoXHZvaJ6ko2aaTu1ej8KCs
 yR5xVsvRk90YzKiy+QAQKMg5JuJe92r7/uoRP/xT8yHDrgXLd2cDjeNeR5RLYi1/IrnqXuDi
 UPCs9/E7iTNyh3P0wh43jby8pJEUC5I3w200Do5cdQ4VGad7XeQBc3pEUmFc6FgwF7SVakJZ
 TvxkeL5FcE1On82rJqK6eSOIkV45pxTMvEuNyX8gs01A4BuReF06obg40o5P7bovlsog6NqZ
 oD+JDJWM0kdYZQARAQABwsGQBBgBCAAmAhsMFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmWV
 gKQFCRT83fUAHgkQqh6bcSY5nkYJEKoem3EmOZ5GCRCqHptxJjmeRsyXEACeaIATB75W1nxf
 rO55sGpNwXxfjqQhA2b57y3xQVL9lFOxJ+efy/CLajKxeWMct8WrI5RRcjxObO/csw/ux06F
 BblgnUrp48k9qfbK/ajTCeU9AHJlJF1lVEwVqk+vn7l7Hfos9dATTBq7NoaBgEje166nxWod
 T7TIu8wOjGw5KMevj5evbKQNcTMRITIp6U/YXB0n7Iw/wYPDlFSra4ds/W++ywTM9fzO+G71
 osmHwBHUlRYszF814qDbQwbv3IfdCWltzzbFE3P8t8u5lLkZt721o0i84qLNK7msmvQEP7eQ
 qleNwCHb9hxoGuMTCsgybNlj/igub2I/wLIodboej1WyV7Q/58Wh6k+32YvY5WU9BnFjp+Uv
 RdzAEfUQ7D8heklQxrnkkCv1IVkdI/S8jwDXWIJ/mwbx7hs2pf0v8S1+AWAi1d6xOYru1+ce
 5qlmemqxqvzIt1jOefbG2uApX0m7Y8njC8JW3kQWRh+bRra2NOdy7OYjU4idxn7EVZVHmSxX
 Bermm52f/BRm7Gl3ug8lfcuxselVCV68Qam6Q1IGwcr5XvLowbY1P/FrW+fj1b4J9IfES+a4
 /AC+Dps65h2qebPL72KNjf9vFilTzNNpng4Z4O72Yve5XT0hr2ISwHKGmkuKuK+iS9k7QfXD
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <a60852f5-cb90-4614-b35c-91d6507aee0a@talpey.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------C8fZul9XqU1hVCQwPdZVY0JY"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------C8fZul9XqU1hVCQwPdZVY0JY
Content-Type: multipart/mixed; boundary="------------VvpdYyyneIx03bIKMqPMuqDE";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>,
 "vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
Message-ID: <085204d2-22e6-4de6-aeec-620dba38280b@samba.org>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
 <a5c81acc-1e85-463d-925e-eb5b05af9ee7@samba.org>
 <a60852f5-cb90-4614-b35c-91d6507aee0a@talpey.com>
In-Reply-To: <a60852f5-cb90-4614-b35c-91d6507aee0a@talpey.com>
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

--------------VvpdYyyneIx03bIKMqPMuqDE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8xMC8yNSA3OjIzIEFNLCBUb20gVGFscGV5IHdyb3RlOg0KPiBPbiA0LzkvMjAyNSA5
OjA2IFBNLCBSYWxwaCBCb2VobWUgd3JvdGU6DQo+PiBPbiA0LzkvMjUgODo0MyBQTSwgU3Rl
dmUgRnJlbmNoIHdyb3RlOg0KPj4+IE9uIFdlZCwgQXByIDksIDIwMjUgYXQgMToxOOKAr1BN
IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+IHdyb3RlOg0KPj4+PiB3aGF0IHNob3Vs
ZCBiZSB0aGUgYmVoYXZpb3Igd2l0aCBTTUIzIFBPU0lYIHdoZW4gYSBQT1NJWCBjbGllbnQg
DQo+Pj4+IHRyaWVzIHRvDQo+Pj4+IGRlbGV0ZSBhIGZpbGUgdGhhdCBoYXMgRklMRV9BVFRS
SUJVVEVfUkVBRE9OTFkgc2V0Pw0KPj4+Pg0KPj4+PiBUaGUgbWFqb3IgcXVlc3Rpb24gdGhh
dCB3ZSBtdXN0IGFuc3dlciBpcywgaWYgdGhpcyB3ZSB3b3VsZCB3YW50IHRvDQo+Pj4+IGFs
bG93IGZvciBQT1NJWCBjbGllbnRzIHRvIGlnbm9yZSB0aGlzIGluIHNvbWUgd2F5OiBlaXRo
ZXIgY29tcGxldGVseQ0KPj4+PiBpZ25vcmUgaXQgb24gUE9TSVggaGFuZGxlcyBvciBmaXJz
dCBjaGVjayBpZiB0aGUgaGFuZGxlIGhhcyByZXF1ZXN0ZWQNCj4+Pj4gYW5kIGJlZW4gZ3Jh
bnRlZCBXUklURV9BVFRSSUJVVEVTIGFjY2Vzcy4NCj4+Pg0KPj4+IEkgYWdyZWUgdGhhdCB0
byBkZWxldGUgYSBmaWxlIHdpdGggUkVBRF9PTkxZIHNldCBzaG91bGQgYnkgZGVmYXVsdCAN
Cj4+PiByZXF1aXJlDQo+Pj4gV1JJVEVfQVRUUklCVVRFUyAoYW5kIGRlbGV0ZSkNCj4gDQo+
IFNpbmNlIHdoZW4gZG9lcyBQb3NpeCByZXF1aXJlIHRoaXM/Pw0KDQpPYnZpb3VzbHkgaXQg
ZG9lc24ndC4NCg0KTGV0IG1lIHRyeSB0byBhc2sgaXQgZGlmZmVyZW50bHk6IGRvIHdlIHdh
bnQgdG8gcmVsYXggV2luZG93cyBzZWN1cml0eSANCm1vZGVsIG9uIGEgUE9TSVggaGFuZGxl
IGZvciB0aGlzIG9wZXJhdGlvbiwgZXZlbiBpZiB3ZSBjYW4gYnVpbGQgc2FuZSANCnNlbWFu
dGljcyBpbnRvIHRoZSBwcm90b2NvbCB0aGF0IGRvZXNuJ3QgcmVxdWlyZSB0aGlzPw0K

--------------VvpdYyyneIx03bIKMqPMuqDE--

--------------C8fZul9XqU1hVCQwPdZVY0JY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf3gf8FAwAAAAAACgkQqh6bcSY5nkaF
XA/9F7AepJ0eZNIUC1Aj1UrXXi0Gk7zXxUr+h6t/Bonkqr6mD35iWsYXlwD5S1JsFgtmkLZPH/RK
YL5v8uPZfIky8lEA293YKt3MgQ2tIzM7DodKEu5wWDngf/MIbmtM167VFaAa8NaGG05xVIMdqpiJ
A6jnXgfmu0K21g1GbGpb9H23qznAL2+LoJgP4VVuoJSIfApggZUukiNFE2ty9NkfH3QzKIAbKN2L
rb9OaH0nuNfjzwRCzijIvT1t6KEEY8gkhk7e3xJow0JBasiFcz5hRHsdXYk0SOwFX2+79Mt6mINF
HzVDrfq47uYrgXbU7UpBYL3U7hK+6naKVB5ZMpAkZta53Q1owTxEJOPeldjyaTl1qpWd1w/DymNY
gHaFGfziw9sKpNpGbLBLYL3uEEqpsEtPUgj66yrAtzWXHDwn6Pb/nNP3qNZqfTkOe+BondtsOXxj
fEQN796o/of8+LTjoRVOcH/QoXPrpFeRnjR1DUpOTdocBMNGaJxn5N0BFHcPFGAC+/ryV2JOyJ+p
oc5Su8yH6gC5VnM9uua1M8VKEP3ecT8RFvGzXHtMG1hYH4wi4UgQTz/6sTeGpfAAxRkJ5mFxKoYu
tfJjjNj3tcBmSihD5f8fi7hRv2HF5S6GRooDsa7dEisYyz37W/WqfHuZdHUmVneg9jvhsRcbrsZi
7F4=
=Her/
-----END PGP SIGNATURE-----

--------------C8fZul9XqU1hVCQwPdZVY0JY--
