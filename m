Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A6C14E2FD
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 08:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728376923; cv=none; b=ilG5iA+aC8fzxWOWKuFdJJYduKUW4hkBm/mY1V7XQUBh7ZUrk4hM2hRbPM8t6ThkgtxTG7OaPOa6wJU22WLwV8TjWJxjCmqtYZrT0xqq6ic9T1/xmVSiNR3R7g0WSHW/B/GjdTflxJ1w1hVQoV8SxXb+1OCbiMPXom7sfGDG1ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728376923; c=relaxed/simple;
	bh=1cJpLOZtXceCzY67/Sjfj7XQRWHy7K7X/qXClynkKlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwBp7I270CXvkRI8Cuo6joN3lvlYZzYiStE29Y3UjfNFUA4aDimKUg1KcZQZ39T0JIAPWp8QZq7us4CVB1pfQV4LVXYyELEHOUi1HHPZT1DBuZmfrqbTHtiPcMUKSxc2Tl0hC4WGIpxVVq43ygphH27W723ehjCia2RDnYnUEiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=K4d9EFPO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="K4d9EFPO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=1cJpLOZtXceCzY67/Sjfj7XQRWHy7K7X/qXClynkKlg=; b=K4d9EFPOG8SSl3F6pyoOp3nA7N
	xKakiM50kRFJMYxvMBR+PT1NNueSgvzUOtOk76SpVBP4ayFx0nLwReaN98mT/48mqMvXlwXgxdG3R
	tiMSZ53di+AEt1TilQZHYU5mN0QvGTD2NkjlrIzsqcUKBS97vVPNG3AvH6qgsiIPBHM/wIhyMn3sF
	cY7bVIo8I+N8Avv5tvDAzzxgjlOCUvmzS95m2yRzf8/Dyft0STk3WRKNzTansKWNjiUpiI4Lkp7RP
	BHNmg4CCmPpE64B5BWuSUnA+p3xH74WDhIwB5mI/wpEr4aOPo7X7NVM9l6XQCAOPWj4heDdX1knLG
	3Z21R6vErml3Y4JNFGFq4s+JWLnqxv1zeQpZdjcBgKOTktS7aIIZ+84Q59D+GcPgZ+a6IHWnJbno3
	nA98+ficbkosjNgvhFKiAT0PC9+R7wz1NK5mkGeUgzN/DqyX7ssDDEBUBrdSKPnaipJWm5GWOK51u
	/ONtIa4i+k6akve51SbRE+N8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sy5my-003tBq-2E;
	Tue, 08 Oct 2024 08:41:52 +0000
Message-ID: <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
Date: Tue, 8 Oct 2024 10:41:51 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
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
In-Reply-To: <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------AAewAaz9WoQ05Gu2dUoMs4LY"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------AAewAaz9WoQ05Gu2dUoMs4LY
Content-Type: multipart/mixed; boundary="------------MiKPVQzyrkFujj1P9MCxv0zG";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
In-Reply-To: <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>

--------------MiKPVQzyrkFujj1P9MCxv0zG
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOC8yNCA2OjU1IEFNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IEhlcmUgYXJlIHRo
ZSBsb2dzIGZyb20gc2ltcGxlIGV4cGVyaW1lbnQgKG1vdW50ZWQgd2l0aCAibGludXgiKSB0
bw0KPiBjdXJyZW50IFNhbWJhIG1hc3Rlci4gSXQgZ2V0cyBOVF9TVEFUVVNfSU5WQUxJRF9I
QU5ETEUgKGJ1dCB3b3JrcyB3aXRoDQo+IGRlZmF1bHQgbW91bnQgLSBpZSBub3QgbW91bnRp
bmcgd2l0aCAibGludXgiIChvciBlcXVpdmFsZW50ICJwb3NpeCIpDQo+IA0KPiByZXBybyBp
cyBzaW1wbGU6DQo+IA0KPiB4ZnN0ZXN0cy1kZXYvc3JjIyAuL2Nsb25lciAvbW50Mi90ZXN0
ZmlsZXNyYw0KPiAvbW50Mi9jbG9uZS1vZi10ZXN0ZmlsZXNyYy1tb3VudGVkLXdpdGgtbGlu
dXgNCg0KLi4uDQoyMzo0OTo1NC44MTcxNDMgb3BlbmF0KDEzLCAiY2xvbmUtb2YtdGVzdGZp
bGVzcmNtbnRwb3NpeCIsIA0KT19SRFdSfE9fQ1JFQVR8T19FWENMfE9fQVBQRU5EfE9fTk9O
QkxPQ0t8T19OT0ZPTExPVywgMDc3NykgPSAyNw0KLi4uDQoyMzo0OTo1NC44Mzc3ODYgY29w
eV9maWxlX3JhbmdlKDI4LCBbMF0sIDI3LCBbMF0sIDEwNDg1NzYsIDApID0gLTEgRUJBREYg
DQooQmFkIGZpbGUgZGVzY3JpcHRvcikNCg0KVGhlIHByb2JsZW0gaXMgdGhlIE9fQVBQRU5E
IG9uIHRoZSBkZXN0aW5hdGlvbiBmaWxlIGhhbmRsZS4NCg0KV2UgcGFzcyB0aGF0IGZsYWcg
aWYNCg0KICAgICAgICAgaWYgKHBvc2l4X29wZW4gJiYgKGFjY2Vzc19tYXNrICYgRklMRV9B
UFBFTkRfREFUQSkpIHsNCiAgICAgICAgICAgICAgICAgZmxhZ3MgfD0gT19BUFBFTkQ7DQog
ICAgICAgICB9DQoNCklzIHRoaXMgb24gYSBwb3NpeCBtb3VudD8gT3RoZXJ3aXNlIGl0IHNl
ZW1zIHRvIGJlIHRoZSBjbGllbnRzIGZhdWx0IA0KcGFzc2luZyBGSUxFX0FQUEVORF9EQVRB
Lg0KDQotc2xvdw0K

--------------MiKPVQzyrkFujj1P9MCxv0zG--

--------------AAewAaz9WoQ05Gu2dUoMs4LY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcE8E8FAwAAAAAACgkQqh6bcSY5nkas
yxAAkxeoS2BwbkUN7F3WWelRWbcXkMoma/W1NN+N++T4OIF6P7Z0sMSvNej12LZIKWc++evOWB9u
RnXJBErWRG3DrfV8LR3PdBVhlDgy1OzHV/BalcDvG6qxiSshOCQAHrqxzx1Ms60yXnq3mXSA1F3/
pZ10qCtHFUvij+V0hdEkhAa2zNPWonaBpTLuJt7FaBGPLmtb+gzUN1s0M3E7Zbc+hHQlbu9h/Lru
96jANG/Gb2W1qpBa/2+2iG1/3PB/oTcsbw9afT3Efo7KPCe7XtlYymVDOZtsy00k5mJf3Ru2gPmY
8dfnwHxlVlFAe/V3siEDLTs3CGHryAIjyjdsE9sQQBFtXNVGINBEF4H7HmFwXsmpP62bmNxGglhL
wSy3yNQD3cIx95sLdK6m7sJaodkMTi4JyfuM+Wy4KXwGcXvW1GwXDzRkwG4HmzuBLJocaOpPVrER
VQrStD+ldTa1+gn++WSshLF8vMaB5SML8M9ThN4ehHVnZKwyTI6SlZRp5cXHnPNc0vWVUVIlWUwV
KPIo9VIkXmkTcF0entHfr4zdtUDOrczHabhRv8VXyUQqV3yQjnF8OrXt681bhhm/8lpLPLfWGHH4
S5TMI3rCnA28Fwfxa17h7q0x5zhY2grKyRnc+9DDHxQy+6EwFd41GY3A88YwWsSdbUVtGzYFD86Q
DHI=
=w5f2
-----END PGP SIGNATURE-----

--------------AAewAaz9WoQ05Gu2dUoMs4LY--
