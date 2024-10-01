Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454A19D88D
	for <linux-cifs@vger.kernel.org>; Tue,  1 Oct 2024 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727787309; cv=none; b=Mt0L67J5cdHRjcZ+6UAJjpNwmgHQ6Rm8TnDur+Q6pGfaFkWy6gzVi4CtzIWftH7/+dHnAPU96MICiEYW4wmc4f3j8Rt23zWhZdntAXwO1yJ0WRO9u+PQfxkv7wj/3vjpdVm8dyYMCPFucGHhhXsbWHlcShVJxck1mhFlEFcwEP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727787309; c=relaxed/simple;
	bh=I9tAKtXhAEoNUIUpdOSQ7fW72f92mtJgZDd0QfaA4dU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fc67ZXBDekyrL3OdZ0ElVP1JvtTc3zIcqHbAiGvwNPWK4I6njw/ImW9kUhF2x6yKEsZ8b8oKNCkYScyt/GHZw6sG7lJBXCsj9fX8sgdsH0JFTRrKk1v/TmdoevwQgmkJQVLQ8ZmN/yDcXurw9aFoP0XQqlaOBFoxcseV79rqd10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=h7fH6VBY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="h7fH6VBY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=I9tAKtXhAEoNUIUpdOSQ7fW72f92mtJgZDd0QfaA4dU=; b=h7fH6VBYFGkgpkPusA1if0p1+5
	zPlh8YTCIt27dnhDRaVJg40hToHfgZmKKm9iNWxDnJhxy1q6CDn/sHVBMSfFpOp3coPPUviZaMbxY
	U2uDhxlmLFkZfjXwpfHkJWCWOMKV9k9aiKwWHosv9OvcUOaSb42wb6MS4Clh8dKmoM31NUzL7SMrs
	vO7wP4G76KE0ckLpJA8NEvyZYdq7xl0GMEoyI2SwrvmiCVu9E8Ty4kCLmbg1ekqijPEDbH2I0QYO0
	LPFSMaAz1/ShNWZnhAv4dhsN3gd0iFiCCNdcNeXLR5tFX7EIo1Hv4B+dbA26Qu23ExCMKYZv3ppLV
	nuNlXf+RUISdwB8r2FAIK1IL1b2zkxJCLAd0EsdNLqstVTeCcIhF8cgygwKh3g9GY8iYLrF95pF2i
	44a90seVAxd2KvzEB+AoqB7tsytlEUZfCiwvaTWaDPg8XR6q+DBRIYOqVo/w1j/iDp8Kl/rzU68vs
	cwMrbVsegIEictNjYQyZI0xJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1svcP4-002ted-1b;
	Tue, 01 Oct 2024 12:54:58 +0000
Message-ID: <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
Date: Tue, 1 Oct 2024 14:54:57 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
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
In-Reply-To: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------AYUhX4xCD030kYZlfP1FTU91"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------AYUhX4xCD030kYZlfP1FTU91
Content-Type: multipart/mixed; boundary="------------qPZflcvuPeb03oIhDPVGhJMA";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Message-ID: <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>

--------------qPZflcvuPeb03oIhDPVGhJMA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU3RldmUNCg0KT24gOS8zMC8yNCAxMDoxMyBQTSwgU3RldmUgRnJlbmNoIHZpYSBzYW1i
YS10ZWNobmljYWwgd3JvdGU6DQo+IEkgbm90aWNlZCB0aGF0IFNhbWJhIG1hc3RlciBpZiBt
b3VudCB3aXRoICJwb3NpeCIgdGhlbg0KPiBGU0NUTF9TUlZfQ09QWUNIVU5LX1dSSVRFIHdp
bGwgcmV0dXJuICJTVEFUVVNfSU5WQUxJRF9IQU5ETEUiIHdoZXJlDQo+IHRoZSBzYW1lIHRo
aW5nIHdvcmtzIGZpbmUgaWYgeW91IG1vdW50IHdpdGhvdXQgInBvc2l4IiAoc28gbG9va3Mg
bGlrZQ0KPiANCj4gQW4gZWFzeSByZXBybyBpcyB3aXRoIHRoZSB4ZnN0ZXN0IHRvb2wgImNs
b25lciINCj4gDQo+IGUuZyAuL3NyYy9jbG9uZXIgL21udC9haW8tdGVzdGZpbGUgL21udC9j
bG9uZS1vZi1haW8tdGVzdGZpbGUNCj4gDQo+IEl0IHdvcmtzIGZpbmUgdG8gb3RoZXIgc2Vy
dmVycyAoZS5nLiB0byBrc21iZCB3aXRoIG9yIHdpdGhvdXQgInBvc2l4Ig0KPiBtb3VudCBv
cHRpb24pDQoNCm5vIGlkZWEgd2hhdCBjb3VsZCBiZSBjYXVzaW5nIHRoaXMuDQoNCkNhbiB5
b3UgcGxlYXNlIGdldCB1cyBhIFNhbWJhIGxvZyB3aXRoIGxldmVsIDEwIHBsdXMgc3RyYWNl
IC12dHQgLXAgUElEIA0KLW8gc3RyYWNlLnR4dCBvZiB0aGUgc21iZCBvZiB0aGUgY29ubmVj
dGlvbj8NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------qPZflcvuPeb03oIhDPVGhJMA--

--------------AYUhX4xCD030kYZlfP1FTU91
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmb78SEFAwAAAAAACgkQqh6bcSY5nkaB
ZQ/+PUNw9ceTSNR5TM2qvPF6fSAA7TvVvRt/OXxuyyz/LUC9UzLPQGHEi3jRT/ZttxlvFLvbLc2X
Pl1jL7+AIwHVlmO1iH6gQwRUh/TanuI5q0/yUh4S7aLm+XS+1ZudmSz95pbWCaMjwhZeFo/GioB2
zbwGFQ7sy4h91ZT5OkINHrtyutCBJF0kat7TPlxtkDYA7xWmPQN4sbxojAAE6tksMyrzrG21S/N/
lOj5rStADMGXMaN1irFvJWH5A5Dc+bZxOWQ/XmdTgDCCZN9r5PPGvua7S/qia099mTMe47pt1LWX
XDS7HkzT6GFaw88m50hF3DkQoIYHlUSqCOxJvItjpEDV0m7eXA4hVG6zbKoqIuZEh6aE3S7c8FAE
TDZRhKXQk1BXqZ1CemxNasW43TIdBJwJHncubqKDkPe/cuNZvqYp5OqoG+6+Nto1gskzG1e1YEMD
xnuSL9DYAeJkbyd8A2LZnx+mq89zkH1kUQNfCL6MAajBMCOpjtp0owzq2fGE7XHjzUUQS1anc8Jc
Dju51Tp1SmITP4pr0X8kyYlL7nqOGnvxnyAVjBjM3gtaUYz20H8FJKzGE8J2uqc+4iVam7q09olo
Ikqe4W2WORczEYMnqv1oEXsbQdTOY4ezP7MML3wqw6Y39jkX27dbj7qFiidO//h0w5TorsXkvhv2
5o8=
=uIvc
-----END PGP SIGNATURE-----

--------------AYUhX4xCD030kYZlfP1FTU91--
