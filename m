Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B2C192586
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 08:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728377136; cv=none; b=ICAEyfJOwOW2OQ6av/TFwD7FRWMpEnifYN4B/IF9vVQcIgpNhiXwqRp0hAyURNOvQVDB/c3I6pUonN99UuFXTLwFlUyZu9zvNvr/edWEOtAmjmGecs2EvSr1NEtRPycxg6o6CFtiKmFJLIZa77MdxyxFXTKrsYKowbg+UMwwk7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728377136; c=relaxed/simple;
	bh=Hm5otLLhbWBorCl/HTdsaF1Y1gQn1T7Xa7TB+mZVSNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mlpWmpoWvuEhGvtdsSSlxM36xIgzuh0dV12+pUMX+C0XKgOLPH7IAA6jf3e/J0avonaeWnpSvDS0uhDPd+F0dXHN5wxysutH569MZevoIdmaRyAy/NAAbX2vaikiY7KtXnCucgcSJ5gRdHpG43kxaYO1FRDNgUwaroRRKr2epmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VoSyU/m8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VoSyU/m8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Hm5otLLhbWBorCl/HTdsaF1Y1gQn1T7Xa7TB+mZVSNI=; b=VoSyU/m8cAyiTHfwQ7leVbURLZ
	r/jk0HRgwdkVKIfj/0iGWZAbrA/q2Oce1XymUVabaxA0Jy2wXpL50fa8vKvSiUn42g6+qgb/1wFnd
	3Yop/kLPnYgaVS4yziZc/fZ0p7VtLjQJZG8smJxNESln/xMesaIiK+KbI7txNb2N4LqO6CLyOTVyu
	xr9LvOKqVO9kadjZgICP0+iMlAa/2PoTg1tJmrDDD0lpektOe6v1i6fQTWP89psz1E2iLx9CFy7KP
	qU9ryH81qsIxDt7EhXoDpeN1JQy1p+1Ew6I0FV01H2bpAaKmQKFc7zqlJvG4EODmeQUXxym2Y4wtY
	87+sAAhEie+E2f9qjtNmP7Kd7b9MfpEaMz1KHR86dgvhLLEYCRGRaxtmRjHmcCl0uErKjuKj95Yi7
	JQFK1cD9s1X2Yl81gY9CxZFNHt8d2O2sd+ExtDcQ03vWdFt+tU568r5Q8vnBhCxHYbdEeQWTrozas
	HhCUtLaBPMflTJ9zogsiWz2R;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sy5qV-003tHG-0K;
	Tue, 08 Oct 2024 08:45:31 +0000
Message-ID: <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
Date: Tue, 8 Oct 2024 10:45:30 +0200
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
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HzMG1mJ8gb3FdEBRqLdklFOE"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HzMG1mJ8gb3FdEBRqLdklFOE
Content-Type: multipart/mixed; boundary="------------gOEJz0wNBYs0scASZTBXlzaW";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Message-ID: <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
In-Reply-To: <77aff6ef-291d-4840-82e2-b02646949541@samba.org>

--------------gOEJz0wNBYs0scASZTBXlzaW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvOC8yNCAxMDo0MSBBTSwgUmFscGggQm9laG1lIHZpYSBzYW1iYS10ZWNobmljYWwg
d3JvdGU6DQo+IFRoZSBwcm9ibGVtIGlzIHRoZSBPX0FQUEVORCBvbiB0aGUgZGVzdGluYXRp
b24gZmlsZSBoYW5kbGUuDQo+IA0KPiBXZSBwYXNzIHRoYXQgZmxhZyBpZg0KPiANCj4gIMKg
wqDCoMKgwqDCoMKgIGlmIChwb3NpeF9vcGVuICYmIChhY2Nlc3NfbWFzayAmIEZJTEVfQVBQ
RU5EX0RBVEEpKSB7DQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZmxhZ3Mg
fD0gT19BUFBFTkQ7DQo+ICDCoMKgwqDCoMKgwqDCoCB9DQo+IA0KPiBJcyB0aGlzIG9uIGEg
cG9zaXggbW91bnQ/IE90aGVyd2lzZSBpdCBzZWVtcyB0byBiZSB0aGUgY2xpZW50cyBmYXVs
dCANCj4gcGFzc2luZyBGSUxFX0FQUEVORF9EQVRBLg0KDQpnYWgsIGl0J3MgYW4gIiYmIiwg
bm90IGFuICJ8fCIsIHNvIGl0J3MgeW91ciBjbGllbnQgSSB3b3VsZCBzYXkuDQoNCg0K

--------------gOEJz0wNBYs0scASZTBXlzaW--

--------------HzMG1mJ8gb3FdEBRqLdklFOE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcE8SoFAwAAAAAACgkQqh6bcSY5nka6
NRAAgEKwVS4gatj+mfuzuDGrEb/R+SPidj9/6pqdP2pbpLzQYZSxwt2NbcPzDAnh3DZelfOgmVK2
kwDL/sd92a2HZJS6rI8ybTvX5J+IkR8q8TTWY84gH6nnFBpwL5f2yBh9JwIGXjrJC2IJg7oYIoRF
WcQSQcpuXvvX2knh4HrY1awefl7hH8FJVPFw/mfrNWW1JnEkbCo7DVldwzU7JchlZBLNToR0cc6X
78aqixYassYibBZHMzybps9dxXJH1Kh95GtbDwfEM6EMjjwg70xm9LGI59/su2zmUZ7gS9f7z7CJ
IvFDPBeDIl3A+u3t6rK8DXQYpxC6R65KciLo4SEUjQFUo0kUnP5Mlaroxp1593jFvRIO21TOztuS
9MDWFaMoj+Cz4MJiDAMBLpXmFRVbQo05HjIOvglRxCkGk+/7qt4JOyjPb4viR5N/ArXPpzZLIemM
7EkrvsRQQA4+E8mna+k430gtXo7OLI7NijguZik0GVrLG/K7VLXwnyTF7aPX9LtqV0ensCPrnwbx
ruQYL2DwwZMuoRpGvrQwC7M6PMx3xq77aszdla2ihQsQF1xc9+zWJ7DYvnU++V9VEs8LJIQroiDq
qyQ+93d3hwSD/drz76fp2gcOYS/Y4Z3iVw4xO53jfUukKk0QEo6Ptza2VTEGRyLPuwanELvdOe0T
Cjo=
=Tv/Q
-----END PGP SIGNATURE-----

--------------HzMG1mJ8gb3FdEBRqLdklFOE--
