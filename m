Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C141131BAD
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713545586; cv=none; b=lXsSYKmI+U5N1CMuRQDWLpRSxyrIp85SNUiqSemwzdL8qK4QB2rfS4MbN/khnL/TVgTqzLZhKzjcQm+NMiAdsf0z7ndrm3aoki62/+RdcYGcyrY3OegeI0G1DsJs53P/08LuZQDKOwJVven6I9YR9V4/eqjayPO0UP+J60pBh3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713545586; c=relaxed/simple;
	bh=CdLUAg6J9P9CgZmrtUFiWuJ3BIHGk3wTFq9/m4uRmuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKrRojrVeNKxVmMn5Wg/ON4aY3AN727ebXB4KRz/zDzQY8l3gVOtk8SOvV5RXQwfLJiqojaYzwrfmDH7UqElPdoCmCcOga6Wt/bTd91G2+mXEFVKsLq+DLrpxyoqZSjdYVnwGgDUoxYi28T4SIde7T9ap8IOhq/lpsviB4zB/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=x2SCEn0Y; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="x2SCEn0Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=CdLUAg6J9P9CgZmrtUFiWuJ3BIHGk3wTFq9/m4uRmuY=; b=x2SCEn0YNrzqzeCmS3kvevJtdl
	lg816d81lX1biP+U/8I/9Q2qdTyp7BLP4gL9DroAG8O0MTGDmSz7ky6l5orEYPQ8gydqKV0cHByc9
	JNIZFaJcfwjvblzQ//wlUfAYFSOuf2Bj6kV34HDVsK4bR7k6pH9KeYjvdi8cVs1mrFLUiara6cc71
	ap3dNaDZh1y4L8wtM5jEgFI5vuyuMTI049pauEPRaHP1DvinZ6GF4hJR8ihCD+HaY+za/+WoaOx1C
	nVylZVTkHcE6N0Didj+KPSIxQ/2bNG5xTWP+lhCTIaLWoRDDGU0923bYne2Z1NyCBQK1jkancdCsN
	GvN0t20Z9tuab75jxitJZ8UEIo0IcJHCZWTcINDjUPhoDKA7rwCzrkSPF3hUyxIShMauWQje9sLVY
	PhI5cvlDt8MldG94l631xWF++A+SsAAdsu/pCWjlePr+prbGN6/5ndDB2ZRHKFYaAMM61l3k0TKqi
	SHruXGf1zmjbyCpCE0lUT08y;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxrTy-007Hw8-01;
	Fri, 19 Apr 2024 16:53:02 +0000
Message-ID: <e69bad72-9139-4b01-afe5-5d34edc077a1@samba.org>
Date: Fri, 19 Apr 2024 18:53:01 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Missing protocol features that could help Linux
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Jeremy Allison <jra@samba.org>
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
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
In-Reply-To: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------mdtgv3JNGIQa0naBBbp00lUM"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------mdtgv3JNGIQa0naBBbp00lUM
Content-Type: multipart/mixed; boundary="------------2A7TsdRsXHAyfa8HrzUIZq0I";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Jeremy Allison <jra@samba.org>
Message-ID: <e69bad72-9139-4b01-afe5-5d34edc077a1@samba.org>
Subject: Re: Missing protocol features that could help Linux
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
In-Reply-To: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
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

--------------2A7TsdRsXHAyfa8HrzUIZq0I
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8xOC8yNCAyMjoyMSwgU3RldmUgRnJlbmNoIHZpYSBzYW1iYS10ZWNobmljYWwgd3Jv
dGU6DQo+IFdhcyBmb2xsb3dpbmcgdXAgb24gYSByZWNlbnQgcXVlc3Rpb24gYWJvdXQgc3Vw
cG9ydCBmb3IgTGludXggZmVhdHVyZXMNCj4gdGhhdCBhcmUgbWlzc2luZyB0aGF0IGNvdWxk
IGhlbHAgdXMgcGFzcyBtb3JlIHhmc3Rlc3RzDQo+IA0KPiBMb29raW5nIGF0IHRoZSBzdGFu
ZGFyZCBmc3Rlc3RzIGZvciBMaW51eCAoeGZzdGVzdHMgdGhhdCBhcmUgc2tpcHBlZA0KPiBv
ciBmYWlsIGZvciBjaWZzLmtvKSB0byBmaW5kICdmZWF0dXJlcycgdGhhdCB3b3VsZCBoZWxw
LCBwZXJoYXBzDQo+IGV4dGVuZGluZyB0aGUgY3VycmVudCBQT1NJWCBFeHRlbnNpb25zIG9y
IGFkZGluZyBhIGNvdXBsZSBvZiBTTUIzLjEuMQ0KPiBGU0NUTHMsIEkgc3BvdHRlZCBhIGZl
dyBvYnZpb3VzIG9uZXM6DQo+IA0KPiAgIDEpIHJlbmFtZWF0MiAoUkVOQU1FX0VYQ0hBTkdF
KSBhbmQgcmVuYW1lYXQyKFdISVRFT1VUKSAgMikgRklUUklNDQo+IHN1cHBvcnQgMykgdHJ1
c3RlZCBuYW1lc3BhY2UgKHBlcmhhcHMgeGF0dHIvRUEgZXh0ZW5zaW9uKSA0KSBhdHRyDQo+
IG5hbWVzcGFjZSA1KSBkZWR1cGxpY2F0aW9uIDYpIGNoYXR0ciAtaSA3KSB1bnNoYXJlIChu
YW1lc3BhY2UgY29tbWFuZCkNCj4gOCkgZGVsYXllZCBhbGxvY2F0aW9uIDkpIGRheCAxMCkg
YXR0ciBuYW1lc3BhY2Ugc2VjdXJpdHkgMTEpIGZzdHJpbQ0KPiAxMikgY2hhdHRyICtzIDEz
KSBleGNoYW5nZSByYW5nZQ0KPiANCj4gQW55IHRob3VnaHRzIG9uIHdoaWNoIG9mIHRoZXNl
IHdoaWNoIHdvdWxkIGJlICdlYXN5JyBmb3Igc2FtYmEgYW5kL29yDQo+IGtzbWJkIHNlcnZl
ciB0byBpbXBsZW1lbnQgKGUuZy4gYXMgbmV3IGZzY3Rscyk/DQoNCndlbGwsIEkgZ3Vlc3Mg
bm9uZSBvZiB0aGVzZSB3aWxsIGJlIHJlYWxseSAiZWFzeSIuDQoNCklpcmMgd2hlbiBJIGxh
c3QgYnJvdWdoIHVwIGZpbGUgYXR0cmlidXRlcywgd2UgdmV0dGVkIHRvd2FyZHMgcG9zdHBv
bmluZyANCnRoaXMga2luZCBvZiBzdHVmZiB1bnRpbCB3ZSBoYXZlIGZ1bGwgc3VwcG9ydCBm
b3IgdGhlIGNvcmUgU01CMyBQT1NJWCANCmZlYXR1cmVzIGluIFNhbWJhLiBJaXJjIHRoZSBv
bmx5IHJlYWwgdGhpbmcgbWlzc2luZyB0aGVyZSBpcyANCnN5bWxpbmsvcmVwYXJzZSBwb2lu
dCBoYW5kbGluZyBhbmQgZm9yIHRoYXQgd2UgbmVlZCB0byBzZXR0bGUgb24gd2hpY2ggDQpy
ZXBhcnNlIHR5cGUgdG8gdXNlIChXU0wgdnMgTkZTKSBhcyBkaXNjdXNzZWQgeWVzdGVyZGF5
LiBJdCB3b3VsZCBiZSBhIA0KKmh1Z2UqIGhlbHAgU3RldmUsIGlmIHlvdSBjYW4gcHVyc3Vl
IHRoaXMgaW50ZXJuYWxseSwgdGhpcyBoYXMgYmVlbiBhIA0KYmxvY2tlciBmb3IgdGhlIHdo
b2xlIHByb2plY3Qgc2luY2UgcXVpdGUgc29tZSB0aW1lLi4uDQoNCi1zbG93DQoNCg==

--------------2A7TsdRsXHAyfa8HrzUIZq0I--

--------------mdtgv3JNGIQa0naBBbp00lUM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmYioW0FAwAAAAAACgkQqh6bcSY5nkai
yg//ShKTodwJKbzqEMo/gLLtz+Q2zUykb0yTcw8P1UB4VkeSwJTldq0dqNCXOOqxMcGp0pNMVl69
Ra7qziNgxSd4DfCqPJCP7km+xmmDVCjMNumiAoqtJ2T7+VhvKLRCunIxND1GvjBHcVj60qKTIOdF
Dq1s4t9fL7UYotoP8UquCXuN7mZyxL+qLFqi408eAivxbchhgU56nQ1LaTzTtp79ifzKXiGiKm06
gqDNOD0fKYNnG3gz+6RAJb48lEsPnWZSyO2vFw+9fvqGnlT2l5TRURFW0y0RA/KOIMVjTUpPjs37
LCxboqG3vROgfJZbvUjgmd7Xqt/Qc2utbVPB4XE61sZHElH2upqiwcRdy3f80JMkwXR/qY4IVDR3
zo3/GoMSwKTE1kZnUJQfVZesbXGOZhwzNJuD1GRR1wcASMBCX6MFf6aJDkxP7kf2nFHlv4RkKV4Z
gS0y2PKHbCPLWif+zwRN9lygvn4kNILYd5AnjDAAQESBLAOEmDBaWamUIQEjr9RnhwBvOTCd+A5e
BVJdw5cudOAnrnDoAaD4JlDOjOBMNzdzPk0REEhe3OAW6Qfi0A1pbngb9IQllQwSWWmlomI14PrA
gcOvFFoxs5fbBut7xACD+ujz8MCj6pGiyiogxPsiol+ykxqjF1rHa4XB510qkkVsqp6A4YtHGR5q
6Dg=
=Iaqv
-----END PGP SIGNATURE-----

--------------mdtgv3JNGIQa0naBBbp00lUM--
