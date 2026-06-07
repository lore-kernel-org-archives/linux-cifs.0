Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D823002D1
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780853850; cv=none; b=sq126+cLmq1Gz5QbFpTGoz2deembOfQQSihpMArHlydG07A9WrjfkE++R2OkRSbj4bXrBHAh4LTKbxo63pToz8K/czPF8hAqjCOgJB9d3ABrb1eFH68SIy+DRHHIgNWz9jss+AG2RMIRmh3qAyA2rR+nLSp2oxe+cuQaKIUeYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780853850; c=relaxed/simple;
	bh=cFskU93ml3bVwvmrwZDvercwSPEgU2dI1RuzTn3WuMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LOKWn25mdJlLk0rtDGGalsW8aDJOyDqPsAKaQhFxB6Xw1tZNdutMeOpnuTd+XxTUrcyvjfjvMJduA6PPhvqcXC5pEmSyj/7BjpKF/46HZSvt2YEHsupBMBYWJdXUfic3BeQqBX4BaLz/VSppUuCxiQPiXpDjlXNkZYFXtIM5eSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=18UdDqzS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="18UdDqzS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=cFskU93ml3bVwvmrwZDvercwSPEgU2dI1RuzTn3WuMw=; b=18UdDqzSJgh9zqH3MD/PgD4fhU
	9WG3KjjzwdVqyxE1UfQrTIl/5iQQdX6mox6mSEQlFbRTH0Fph9amUSximdA5vyUa1Yq7Zctuw/sK2
	Ta/+iuEBDZpTt85SfUgN312zoxNDml1PxCa5WVlafWms3aNNasRv14V0gk2Yoaa8KchNsXAVPDQeV
	4bqw+ilIQ4Fa6RTI912Z/LHvifgu16cngjJftnQRTQoq5Oam6SH7mXaOGnrwKqK36rnni9+K8uRyc
	R717++xV97qoRfZ7TPFoAplYLMHmZz5Ja9ngs5C740fuLQDC0Fmx9QHSeizpawA8wZYR+aSUJFNGN
	mChIm8zbd/kZ4T8DMMTSpH64qhV+LYrk+V6JwH5W8IOC5s4e+4EBkEvqpn6rbOQuJsD4lTHDE1/8F
	vXC0QlkJLxYSIkHz6KA/FhSnq7G7ybPQAUfg+a92lsg8QrIokKExm1ApmpZAd3zpEZzt/uM+EsPq4
	SIjDr7qtoiWvPs/yJjVuVkHA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wWHR8-0000000EgbA-0QlN;
	Sun, 07 Jun 2026 17:37:26 +0000
Message-ID: <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org>
Date: Sun, 7 Jun 2026 19:37:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jrasamba@gmail.com>,
 Huiwen He <hehuiwen@kylinos.cn>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
 <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gdvXH0uF4zvDHyo4pmnOfHqo"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gdvXH0uF4zvDHyo4pmnOfHqo
Content-Type: multipart/mixed; boundary="------------SkQF4INf2Pj3n92GUXbdn3RS";
 protected-headers="v1"
Message-ID: <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org>
Date: Sun, 7 Jun 2026 19:37:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX
 Extensions
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jrasamba@gmail.com>,
 Huiwen He <hehuiwen@kylinos.cn>
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org>
 <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>

--------------SkQF4INf2Pj3n92GUXbdn3RS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi83LzI2IDY6NTIgUE0sIFN0ZXZlIEZyZW5jaCB3cm90ZToNCj4gdGhlIGNobW9kIGJ1
ZyAod2hlbiBtb3VudGluZyB0byBzYW1iYSB3aXRoIG1vZGVmcm9tc2lkKSBjYXVzZXMgYSBm
ZXcNCj4geGZzdGVzdHMgdG8gZmFpbCAoSSBub3RpY2VkIHRoaXMgd2hlbiB0ZXN0aW5nIHRo
ZSBzd2Fwb24gZml4ZXMgZnJvbQ0KPiBIdWl3ZW4uDQpzZWUgbXkgb3RoZXIgbWFpbCBJIGp1
c3Qgc2VudDogdGhpcyBpcyBleHBlY3RlZCwgbW9kZWZyb21zaWQgaXMgbm90IA0KcmVsZXZh
bnQgaW4gU01CMyBQT1NJWCBjb250ZXh0LiBJZiB5b3UgbW91bnQgd2l0aCBTTUIzIFBPU0lY
LCBjaG1vZCgpIA0Kd2lsbCBqdXN0IHdvcmsuDQo=

--------------SkQF4INf2Pj3n92GUXbdn3RS--

--------------gdvXH0uF4zvDHyo4pmnOfHqo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmolrFUFAwAAAAAACgkQqh6bcSY5nkbv
AA//ZdIyrkDacrwuSs3Mz1c16Q5vxfzJuXtriMhd5SAemAgjppwFzJ1HBG3DbEwynQnKNKw/6aA+
gS/xt9tKuceahRR6EXOm5sMh+y39jp8HWKyDCvwfbhNR2vvxISxf5HsuuULFnZe6bgASz90WdQPX
/snoMZXqhnBnwdWVKa/kqJeamwYs4NXt6SstNRwZhjxUPNgJtcWej+LyPpwCU2hLGmuQpcfd4Vzr
rnJQ6ckgqH3who6q5vFnrgSAJVn6C+vUPb5MJGY57O+tlFQSHgREG7hXKU5/8yBU3fBYrmrrBLwU
Qx4miH7w3KBCSit1pqQFwHc3eXT1MMDldxLalzzuUHuGBhlt8uXbNMDKlwdMbXRUVB2OMi0e75Yb
I8Tirnb+r5mYp9rXfVXE7CVhnKcr7LcdL0lEWKJETEIbu4gocbkk5DoQkzWVFVsWdC+QIFIg2p+/
t+dFFKDdA6e/7wyIZOCmdre/DezNS0+4hCUQ+Hea2I9odgqiid9EHTd5QEpcurhJPyILdokTXL3d
zBL6nQUikUgjt9UykmZdNeUCM1yBwtW3fDUUiuV0CSonEyQcSzBDNPMSGa8OcR8Pvji/hK/vuYaP
CCh4Mvln2Y6xUESgSs2EdnifPPB6MqhFpcS+9/uH2P6l+HcUuAMQm2XdzMk7B4BfkuVP5sR5DW1t
2Kg=
=26IO
-----END PGP SIGNATURE-----

--------------gdvXH0uF4zvDHyo4pmnOfHqo--
