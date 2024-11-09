Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D758D233D6B
	for <linux-cifs@vger.kernel.org>; Sat,  9 Nov 2024 21:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731188087; cv=none; b=ZxkpwuY0zanFOqd2NFUBc1Qo22jOzymhnZxGUmUwhBTIBwKFvYne15wLRzFJx7I9+xHnm0cKL0TsDnswG9QEqW04tcxBqj+YnGKJ1h0G14NjIhi0cpwXXKQgRdScHRwcqrLDyxdHDcrsiCKRoDvDMYrFaHp2ZNEk48dcHjU8BDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731188087; c=relaxed/simple;
	bh=aHyDWy6BM/0mMd0bskq3cDq/6k+Q4KirgArd3/dUE8k=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=sC48zRIlkr0I+21xS27GadIykjQTpmKMa/NL1YxLjES9Le6XA5qlKwmkHQFN+B+2UwzeWYuXKI/p4YA/31ip3orN9nk4AKQS3BrvbsrquupaTitEpsGA5SdtUV59omX0Djx1P9CdLGRtLHPSrtIBOGG81YYnTbo03LOg7g+fyd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Wwo8uuX8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Wwo8uuX8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=aHyDWy6BM/0mMd0bskq3cDq/6k+Q4KirgArd3/dUE8k=; b=Wwo8uuX8QaqnR4bKkImdXEDMGB
	Pxu0033lnTh6rRiB8l4Tz/VV3IkboW5Mc/VfTo8pGHMGE6welxHds2RNadVjt3Z8xRyM0eK1Sr72A
	6qEk23sqLbmM4pbHcfrEjFOC2nIYQcA7wI7n5I06XvUzjsHakr0WzIxL7rFKtg+ynxCAGfPY0kyrW
	oFdVUfEASmc89m4s7UX3IHJIGcS6fvNeqEwrR6UlZOxcPEUj6kdrLyJlGxLnlFpirAubifIit+ZiT
	wt71GHd6STn8SYC9T60oOIPzqLihaKc2aY/sGurngQS3cgxMBcvxSmJnspDIUMtV74gnOVvoNG0ta
	lPOSyhISaQvDPW1bXaPJ7yr5xnz3DV7wOz/E6LGYVoyVamnqddP4uVJxoSgg094wXwYWQ9smJUoQJ
	ocv9qDAe1laHMcH9MZHVM9uh66deLrEIDbReweobq2Esif5hsBJMSE6opi9M8umydsq4qE51QotUQ
	2FXK7/YLNIpJcJwPBBN97yog;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1t9t6P-009oLw-2z;
	Sat, 09 Nov 2024 21:34:42 +0000
Message-ID: <7932bad1-8bc5-48e7-9561-60029d5a6056@samba.org>
Date: Sat, 9 Nov 2024 22:34:40 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ralph Boehme <slow@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: samba-technical <samba-technical@lists.samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 Jeremy Allison <jra@samba.org>, vl@samba.org,
 Stefan Metzmacher <metze@samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
Content-Language: en-US, de-DE
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
In-Reply-To: <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kxJsDW9MTKz3uyXAfD8rm7c9"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kxJsDW9MTKz3uyXAfD8rm7c9
Content-Type: multipart/mixed; boundary="------------0ZlhA8gIZUHnPeOYNX08q0qJ";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: samba-technical <samba-technical@lists.samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 Jeremy Allison <jra@samba.org>, vl@samba.org,
 Stefan Metzmacher <metze@samba.org>
Message-ID: <7932bad1-8bc5-48e7-9561-60029d5a6056@samba.org>
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
 <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
In-Reply-To: <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
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

--------------0ZlhA8gIZUHnPeOYNX08q0qJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEvOS8yNCA0OjI2IFBNLCBSYWxwaCBCb2VobWUgdmlhIHNhbWJhLXRlY2huaWNhbCB3
cm90ZToNCj4gT24gMTAvOS8yNCA5OjQzIFBNLCBKZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4+
IENhbiB3ZSBqdXN0IG1hcCAoYWNjZXNzX21hc2sgKEZJTEVfQVBQRU5EX0RBVEF8U1lOQ0hS
T05JWkUpKSA9PSANCj4+IChGSUxFX0FQUEVORF9EQVRBfFNZTkNIUk9OSVpFKSkNCj4+IHRv
IE9fQVBQRU5ELCByZWdhcmRsZXNzIG9mIFBPU0lYIG1vZGUgPw0KPiANCj4gdGhpbmtpbmcg
YWJvdXQgdGhpcyBhIGJpdCBtb3JlLCB0aGlzIHNlZW1zIGRvYWJsZSwgYWxiZWl0IG9ubHkg
Zm9yIFBPU0lYIA0KPiBtb2RlLiBGb3Igbm9uLVBPU0lYIG1vZGUgd2UgY291bGQgcG90ZW50
aWFsbHkgYnJlYWsgV0luZG93cyBhcHBsaWNhdGlvbiANCj4gdGhhdCBvcGVuIG9ubHkgd2l0
aCBGSUxFX0FQUEVORF9EQVRBOiBJIGNoZWNrZWQgd2l0aCBhIHRvcnR1cmUgdGVzdCB0aGF0
IA0KPiBXaW5kb3dzIGRvZXNuJ3QgZW5mb3JjZSBhcHBlbmQgYmVoYXZpb3VyIGZvciBGSUxF
X0FQUEVORF9EQVRBfFNZTkNIUk9OSVpFLg0KPiANCj4gRm9yIFBPU0lYIG9wZW5zIHdlIHNo
b3VsZCBhbHNvIGFsbG93IGNvbWJpbmF0aW9ucyBsaWtlIA0KPiBGSUxFX1JFQURfQVRUUklC
VVRFU3xGSUxFX0FQUEVORF9EQVRBIHRvIG1hcCB0byBPX0FQUEVORCwgc28gY2xpZW50cyBj
YW4gDQo+IHdyaXRlIGluIGFwcGVuZCBtb2RlIHRvIHRoZSBoYW5kbGUgYW5kIHN0aWxsIGFy
ZSBhYmxlIHRvIGZzdGF0KCkgaXQuDQo+IA0KPiBodHRwczovL2dpdGxhYi5jb20vc2FtYmEt
dGVhbS9zYW1iYS8tL21lcmdlX3JlcXVlc3RzLzM4NjMNCg0KaW4gYWRkaXRpb24sIEkgZ3Vl
c3MgZm9yIFNNQjMgUE9TSVggd2UgbWlnaHQgd2FudCB0byByZXF1aXJlIHRoYXQgdGhlIA0K
Y2xpZW50IHNldHMgb2Zmc2V0PS0yIGluIFNNQjItV1JJVEVTIG9uIGEgaGFuZGxlIG9wZW5l
ZCB3aXRoIGFwcGVuZCANCnNlbWFudGljcywgcmV1c2luZyB0aGUgbG9naWMgZnJvbSBNUy1G
U0EuDQoNClRoaXMgYXZvaWRzIGJyaW5naW5nIGluIHRoZSBhbWJpZ3VpdHkgb2YgUE9TSVgg
dnMgTGludXggcHdyaXRlKCkgDQpPX0FQUEVORCBiZWhhdmlvdXIgaW50byB0aGUgcHJvdG9j
b2wgYnkgY2xlYXJseSBzcGVjaWZ5aW5nOiBpZiBhIGhhbmRsZSANCmlzIG9wZW5lZCBpbiBh
cHBlbmQgbW9kZSwgYWxsIHdyaXRlcyBhcmUgdXNpbmcgd3JpdGUoKSB3aXRoIE9fQVBQRU5E
IA0Kc2VtYW50aWNzIHdoaWNoIGFyZSBjbGVhcmx5IHNwZWNpZmllZC4NCg0KTG9va2luZyBh
dCBwb3NzaWJsZSBzZXJ2ZXIgaW1wbGVtZW50YXRpb25zLCBpdCBzZWVtcyBib3RoIExpbnV4
IGFuZCANCkZyZWVCU0Qgbm90ZSBpbiBtYW4gcHdyaXRlKCkgdW5kZXIgQlVHUywgdGhhdCBh
IHB3cml0ZSgpIG9uIGEgaGFuZGxlIA0Kb3BlbmVkIHdpdGggT19BUFBFTkQgaWdub3JlcyB0
aGUgb2Zmc2V0LCBzbyB3ZSBpbiBTYW1iYSB3ZSBjYW4gY29udGludWUgDQp0byB1c2UgcHdy
aXRlKCkgaW4gU01CX1ZGU19QV1JJVEUoKSBkZWZhdWx0IGJhY2tlbmQuDQoNClRvIGF2b2lk
IHJlbHlpbmcgb24gQlVHUywgd2UgY2FuIGNoZWNrIGZvciBhbmQgdXNlIHB3cml0ZXYyKCkg
d2l0aCANCmZsYWdzPVJXRl9BUFBFTkQsIGF0IGxlYXN0IG9uIExpbnV4Lg0KDQotc2xvdw0K
DQo=

--------------0ZlhA8gIZUHnPeOYNX08q0qJ--

--------------kxJsDW9MTKz3uyXAfD8rm7c9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcv1XEFAwAAAAAACgkQqh6bcSY5nkY9
ig/+LNW+16VjYLPh9750o7KFgn0GBCEYC0Oa2JrDQkX3r16p6T723sDrCEQFfJjFwjPI/u707Cpf
OOqryhkjZkoMiAi6u9cWfGyX0uJQ72/EytDidSgFhytvGHUlQ0yc7Zf16qtaM2oA1iL8eOO7mDZT
bB8i/2TgJ7PvRpzB0fauSb7rI3gghi2Wr+cWS5u5D9+TFLq1uRn/kg+zkQqZAo6vSoGlmioOUofi
BizQZTFYprcflxFcdSE7ypwa5kNI4vkEmhiUMDlV74IwcGSOt+9PEjW12Si9Pjy/QymeoS75jRuX
xt8s/yw6JAZVbs1IQJqt/pKnbFOINfvmt8FHmyMwIehEcYR6YCN64XhbZcBBcgp5jMz5+5L3GYoz
gEi2jqkNT+qdWuGhyXU+L0STMmLSscxCPp9P1Xfo2Ffmp9k928vB3ntbAySEl5e6FED/kbVBwHVF
TWUyrndPHMhs4Yv6J8iyJjk2pTD2jnp+kZUWXnOLCrWVpxZmNIYvKPIplz5C8H6O94iHlRgDlC35
ctjLDCU6SuXJ0bd8hcwxSsbN628j83NaC7827iZWIrHkU4DC4sb1ijVezwHJxt4Y5tdhXds2Jof7
6KVcpQZQYL7+4VnhjJmcWdmHbN4YnRlHme1FF4O/3jvsAvzsrnZn0SqHfCyt1PeCkGSZEgi206O8
sPY=
=N1wJ
-----END PGP SIGNATURE-----

--------------kxJsDW9MTKz3uyXAfD8rm7c9--
