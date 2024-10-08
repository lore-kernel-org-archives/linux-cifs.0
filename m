Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1BA158205
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 09:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728380122; cv=none; b=GzTAntgfTjUAIJbEJM8WZxkUU7isQ8RNmlwuQUDkfwxO4lbKlTchjH5OS0QY1qMPYfd8qDNfsssHVZr8slcUCu8HatELbWU9gvOE8fD+9Mo+MELIR2vR7TUI+lqy2e+z4mwbg18U3xlJScqmiTbVpVXqWxTnqgSnnk2Nxid7Spk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728380122; c=relaxed/simple;
	bh=H+2thn8Qa0/kERp/SGnXihj91qwwvRvZOlWlpdbb5/4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=r9JZptL7te0UGfsLXjq1w9fwW3JNFA9qhM76RAZ5BTT3GPV1CtzBDw4O14s41YGtBszk59Bj8pPYAVJ1IrB/Y3H0y5Z34BZwWzP2dnrc7k2hqc7UmshKOQHCl+6TuEkB7pb+fWn878CLPe6n77CoUpA/kprZMw4s5vBxDgGcMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yN+GWnpt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yN+GWnpt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=H+2thn8Qa0/kERp/SGnXihj91qwwvRvZOlWlpdbb5/4=; b=yN+GWnptPr9fWl85qVlf/edgu1
	a/1TxJVh136eZCqdhVeXOLZsNSEKvVSgFDa49DhA9bZHvfhxY3pCOBTuKfr7VxuAiuPcjKd8AwpE0
	YQq9ntWukQIPR1T84mCniSYW4OyrCuxghu9kEsQ0DNg8oSZ71g6ree/vjIEVDnCOxtZ93pJtCVHr/
	ex9CnswwyjS0oyfvSZjWDPqPx79MKLvAlTkNQfXWFbw+uDYGkGGXmC7gzw604O0mB1wk2THcrLXTJ
	3ZxDIeBmjJhW+2Sx2BswGfZmD4SHN9LjD0DhwYZQHK4r6xpcVaHab8ibVCY/fcmEyBRDENnuO3l90
	HO2TGno8SuhUnwO0RyI5BnjKIhrR3qu/YRzb1Ky/Zs9aMW8JdR6jEOiubCnShQacCCN0EV4OoTH8Y
	hqDJjgNOwFbUj9zveENOWLA/MlLzH3PopgP4DqfDkg32QFglkQAnNs/uSZi8yKJ8Cc6BiRf2E4rDV
	r2J36lNek1E8Sn++VP7zFOL7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sy6cg-003tmr-0W;
	Tue, 08 Oct 2024 09:35:18 +0000
Message-ID: <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
Date: Tue, 8 Oct 2024 11:35:16 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------U0l1VdpmMJBkJnrDL04knix1"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------U0l1VdpmMJBkJnrDL04knix1
Content-Type: multipart/mixed; boundary="------------FXWN0tib6Tl0CirrI1D5qxvO";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
In-Reply-To: <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>

--------------FXWN0tib6Tl0CirrI1D5qxvO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOC8yNCAxMDo0NSBBTSwgUmFscGggQm9laG1lIHdyb3RlOg0KPiBPbiAxMC84LzI0
IDEwOjQxIEFNLCBSYWxwaCBCb2VobWUgdmlhIHNhbWJhLXRlY2huaWNhbCB3cm90ZToNCj4+
IFRoZSBwcm9ibGVtIGlzIHRoZSBPX0FQUEVORCBvbiB0aGUgZGVzdGluYXRpb24gZmlsZSBo
YW5kbGUuDQo+Pg0KPj4gV2UgcGFzcyB0aGF0IGZsYWcgaWYNCj4+DQo+PiDCoMKgwqDCoMKg
wqDCoMKgIGlmIChwb3NpeF9vcGVuICYmIChhY2Nlc3NfbWFzayAmIEZJTEVfQVBQRU5EX0RB
VEEpKSB7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmbGFncyB8PSBP
X0FQUEVORDsNCj4+IMKgwqDCoMKgwqDCoMKgwqAgfQ0KPj4NCj4+IElzIHRoaXMgb24gYSBw
b3NpeCBtb3VudD8gT3RoZXJ3aXNlIGl0IHNlZW1zIHRvIGJlIHRoZSBjbGllbnRzIGZhdWx0
IA0KPj4gcGFzc2luZyBGSUxFX0FQUEVORF9EQVRBLg0KPiANCj4gZ2FoLCBpdCdzIGFuICIm
JiIsIG5vdCBhbiAifHwiLCBzbyBpdCdzIHlvdXIgY2xpZW50IEkgd291bGQgc2F5Lg0KDQp0
aGlua2luZyBhYm91dCBpdCwgSSB3b25kZXIgd2hldGhlciB0aGF0IGNvbmRpdGlvbiBpcyBh
Y3R1YWxseSB1c2VmdWwgb3IgDQppZiB3ZSBzaG91bGQgcmVtb3ZlIGl0Lg0KDQpASmVyZW15
IChvciBvdGhlcnMpOiBtYXBwaW5nIGZyb20gRklMRV9BUFBFTkRfREFUQSBhY2Nlc3MgbWFz
ayB0byBvcGVuIA0KZmxhZyBPX0FQUEVORCBzZWVtcyB3cm9uZyBpbWhvLiBEbyB5b3UgcmVt
ZW1iZXIgd2h5IHlvdSBhZGRlZCBpdD8gT3IgDQphbnlvbmUgZWxzZT8NCg0KLXNsb3cNCg==


--------------FXWN0tib6Tl0CirrI1D5qxvO--

--------------U0l1VdpmMJBkJnrDL04knix1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcE/NUFAwAAAAAACgkQqh6bcSY5nkYn
LA//cSR1+6tniebT5gGBrxdIkQDf24gtyA3CrVY3r+WcnZh7xvri4uT20L0VifC+5A9tE2Bg89H7
Dc6h51/Hbz0yNlhzow1Rm4J7lw0/ycAEEUp/4WenaLrrAs4WBlTg5/5JSu3lLnUVZi5H8lgH2Fj6
wwxU5CCTgNqoxWPTQTbenmFm26vhT5McxDHiVN3fephHWMVEW5xCDc2u32iE7NmSg8iJS2XfFWiW
wdY0q5+ckDQsF/NFtNb/UsRW5W+MSx+GM4y9N7eGBw4KRngVohIScE1IjukoMY36Me1+zhPTPW0P
XK6ShdYys6Hw3o2TqAsQi17mD4m0Y2F38FoNF4Z3hIDU+xCYIOKW7AGFap8YgTr5UsFu/PtUAjVZ
ftKyHR+lq6nDpffldi7GmZxHjkiTz5jTVl3zIe3oQDPwJB3/3oGfiHVfLpGejN6u49Ruz5En5xQA
uYq8jHYgEusenlnk6pBAmcd87rTg8yEMyvVMHGFpqtOr4t6FUoNQhMLesODsJcc/SxiEqn4IvLvG
4+w9jrJTOPKJwyl9ucUZt/54mSupm5jEJ5lDq3+ZhC2lruae0VoJUIHh6rfmWIaIHC1MRbbOtfEC
Yrvt5Ubp5P5IDPdiRoLutQEP/lrT0XnN9QUcABOkqM3+3oJavAd9p8YR1uXzjSRW914WGv9KqZbT
Spk=
=1OG3
-----END PGP SIGNATURE-----

--------------U0l1VdpmMJBkJnrDL04knix1--
