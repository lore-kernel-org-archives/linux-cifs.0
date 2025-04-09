Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2746D1E5B67
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 06:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744181468; cv=none; b=r8eXtEse8MxhGTmRnAXG4PSWg1d6SBPxXkFcy6EfNtCYyTg8cmKEl0g7BWSHHS3pG6lp5nfsh1IJ7AW3kB1/d7SrqRzkxNhU/tww2Y+4ZDaC3EN5tDB4HL7fSRmOObRuI5r8AEdOk/kywXSKUCWtPKg62LVA2AL0slSUAks5rKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744181468; c=relaxed/simple;
	bh=OqUDHxt2lM6GOYO64Kk+JILA4fNrst+XtR6fS8yM8NQ=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:Cc:From:
	 In-Reply-To:Content-Type; b=RRossJf+j91WHiMoNSVQnN+Ine65Xj/1riw09WRS5GbCjx2AYD4yMEqMRVNCr88ADHPfi5c1NZoECi5H6H1dJiNkYNm7Ih5bAKIsuFmuQXEBLCnF6b5i2jMA/q4e1/9/S5jDoJLTDMtECdYD33+jRM9VUe/Vc61spzzzG9mweTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hJT9o4sD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hJT9o4sD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=OqUDHxt2lM6GOYO64Kk+JILA4fNrst+XtR6fS8yM8NQ=; b=hJT9o4sDO2H5GtGo/wQLjhmVvH
	YNKE8j/mXaalOB+svTLyV9WYcqxpzS3/CkS9j7urzU9TkY+HlXCkweXSKt/kpb7q8Ut517fHIVFxT
	aIvNevqTOlZSO3bHF3sDXAWW3zz0HTPVw1DSJi0SYMzypX8yopt68Y/XikJMBxnltY0OXl7ewpAsD
	bhjkj0pBF9UUhYoFyHIPe11sKMoAljTWujXRuAozH6USerTdiw+do6EHN7I3O9gSGvwgcLjfRcirE
	DaxFDbY/gsqtbBrn260wsSDpkMDUxWZRVspBGTroSOXmaz7YQGeCLnRsCrJx7yxgO9UcRwRqBOzTD
	vqny+kJFDtRQ8L/N2UmUxhNjoFn5XERNWe0mvb1AmVCddcff4fdlM2fBIbJQikhOmEb7PUPgecMR5
	1vAGkjQOVvc9/mXqyEJl86RU64/pdegrPPlCT7SJmzEAbHKaIcZX0RBTgKPCZTeHvo8jkPiB/IYRn
	L3Zx7KaGl6Wv5E8/Mk8pWBrl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2PH3-008rOl-1L;
	Wed, 09 Apr 2025 06:51:01 +0000
Message-ID: <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
Date: Wed, 9 Apr 2025 08:50:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Fwd: SMB2 DELETE vs UNLINK
References: <20250408224309.kscufcpvgiedx27v@pali>
Content-Language: en-US, de-DE
To: Interoperability Documentation Help <dochelp@microsoft.com>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20250408224309.kscufcpvgiedx27v@pali>
X-Forwarded-Message-Id: <20250408224309.kscufcpvgiedx27v@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------fk0yrIjBNJCgLHOxTfrNsu50"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------fk0yrIjBNJCgLHOxTfrNsu50
Content-Type: multipart/mixed; boundary="------------N9KSZi0yac4Bt5xSN73Agp4W";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Interoperability Documentation Help <dochelp@microsoft.com>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
Subject: Fwd: SMB2 DELETE vs UNLINK
References: <20250408224309.kscufcpvgiedx27v@pali>
In-Reply-To: <20250408224309.kscufcpvgiedx27v@pali>

--------------N9KSZi0yac4Bt5xSN73Agp4W
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGVsbG8gZG9jaGVscCwNCg0KaXQgc2VlbXMgdGhlIHVwZGF0ZXMgZm9yIFBPU0lYIHVubGlu
ayBhbmQgcmVuYW1lIG1hZGUgaXQgaW50byBNUy1GU0NDDQoNCjxodHRwczovL2xlYXJuLm1p
Y3Jvc29mdC5jb20vZW4tdXMvb3BlbnNwZWNzL3dpbmRvd3NfcHJvdG9jb2xzL21zLWZzY2Mv
ZjFmODhiMjItMTVjNi00MDgxLWE4OTktNzg4NTExYWUyZWQ5Pg0KDQpidXQgSSBkb24ndCBz
ZWUgYWNjb21wYW55aW5nIHVwZGF0ZXMgdG8gTVMtRlNBIGFuZCwgaWYgc3VwcG9ydGVkIG92
ZXIgDQpTTUIsIE1TLVNNQjIuDQoNCklzIHRoaXMgY29taW5nPyBJZiB0aGlzIGlzIHN1cHBv
cnRlZCBvdmVyIFNNQiBieSBXaW5kb3dzIGl0IGlzIG5vdCANCnN1ZmZpY2llbnQgdG8gaGF2
ZSBpdCBidXJyaWVkIGluIE1TLUZTQ0MuIDopDQoNClRoYW5rcyENCi1zbG93DQoNCi0tLS0t
LS0tIEZvcndhcmRlZCBNZXNzYWdlIC0tLS0tLS0tDQpTdWJqZWN0OiBSZTogU01CMiBERUxF
VEUgdnMgVU5MSU5LDQpEYXRlOiBXZWQsIDkgQXByIDIwMjUgMDA6NDM6MDkgKzAyMDANCkZy
b206IFBhbGkgUm9ow6FyIDxwYWxpQGtlcm5lbC5vcmc+DQpUbzogbGludXgtY2lmc0B2Z2Vy
Lmtlcm5lbC5vcmcNCkNDOiBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4sIFN0ZXZlIEZy
ZW5jaCA8c2ZyZW5jaEBzYW1iYS5vcmc+LCBQYXVsbyANCkFsY2FudGFyYSA8cGNAbWFuZ3Vl
Yml0LmNvbT4sIE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+LCBSYWxwaCAN
CkJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+DQoNCk9uIEZyaWRheSAyNyBEZWNlbWJlciAyMDI0
IDE5OjUxOjMwIFBhbGkgUm9ow6FyIHdyb3RlOg0KPiBPbiBGcmlkYXkgMjcgRGVjZW1iZXIg
MjAyNCAxMTo0Mzo1OCBUb20gVGFscGV5IHdyb3RlOg0KPiA+IE9uIDEyLzI3LzIwMjQgMTE6
MzIgQU0sIFBhbGkgUm9ow6FyIHdyb3RlOg0KPiA+ID4gT24gRnJpZGF5IDI3IERlY2VtYmVy
IDIwMjQgMTE6MjE6NDkgVG9tIFRhbHBleSB3cm90ZToNCj4gPiA+ID4gRmVlbCBmcmVlIHRv
IHJhaXNlIHRoZSBpc3N1ZSB5b3Vyc2VsZiEgU2ltcGx5IGVtYWlsICJkb2NoZWxwQG1pY3Jv
c29mdC5jb20iLg0KPiA+ID4gPiBTZW5kIGFzIG11Y2ggc3VwcG9ydGluZyBldmlkZW5jZSBh
cyB5b3UgaGF2ZSBnYXRoZXJlZC4NCj4gPiA+ID4gDQo+ID4gPiA+IFRvbS4NCj4gPiA+IA0K
PiA+ID4gT2suIEkgY2FuIGRvIGl0LiBTaG91bGQgSSBpbmNsdWRlIHNvbWVib2R5IGVsc2Ug
aW50byBjb3B5Pw0KPiA+IA0KPiA+IFN1cmUsIHlvdSBtYXkgaW5jbHVkZSBtZSwgdGVsbCB0
aGVtIEkgc2VudCB5b3UuIDopDQo+ID4gDQo+ID4gVG9tLg0KPiA+IA0KPiANCj4gSnVzdCBu
b3RlIGZvciBvdGhlcnMgdGhhdCBJIGhhdmUgYWxyZWFkeSBzZW50IGVtYWlsIHRvIGRvY2hl
bHAuDQoNCkhlbGxvLCBJIGhhdmUgZ29vZCBuZXdzIQ0KDQpkb2NoZWxwIG9uIDA0LzA3LzIw
MjUgdXBkYXRlZCBNUy1GU0NDIGRvY3VtZW50YXRpb24gYW5kIG5vdyBpdCBjb250YWlucw0K
dGhlIHN0cnVjdHVyZXMgdG8gaXNzdWUgdGhlIFBPU0lYIFVOTElOSyBhbmQgUkVOQU1FIG9w
ZXJhdGlvbnMuDQoNCmh0dHBzOi8vbGVhcm4ubWljcm9zb2Z0LmNvbS9lbi11cy9vcGVuc3Bl
Y3Mvd2luZG93c19wcm90b2NvbHMvbXMtZnNjYy9mMWY4OGIyMi0xNWM2LTQwODEtYTg5OS03
ODg1MTFhZTJlZDkNCk1TLUZTQ0MgNyBDaGFuZ2UgVHJhY2tpbmcNCg0KaHR0cHM6Ly9sZWFy
bi5taWNyb3NvZnQuY29tL2VuLXVzL29wZW5zcGVjcy93aW5kb3dzX3Byb3RvY29scy9tcy1m
c2NjLzJlODYwMjY0LTAxOGEtNDdiMy04NTU1LTU2NWExM2IzNWE0NQ0KTVMtRlNDQyAyLjQu
MTIgRmlsZURpc3Bvc2l0aW9uSW5mb3JtYXRpb25FeCBoYXMgDQpGSUxFX0RJU1BPU0lUSU9O
X1BPU0lYX1NFTUFOVElDUw0KDQpodHRwczovL2xlYXJuLm1pY3Jvc29mdC5jb20vZW4tdXMv
b3BlbnNwZWNzL3dpbmRvd3NfcHJvdG9jb2xzL21zLWZzY2MvNDIxNzU1MWItZDJjMC00MmNi
LTlkYzEtNjlhNzE2Y2Y2ZDBjDQpNUy1GU0NDIDIuNC40MyBGaWxlUmVuYW1lSW5mb3JtYXRp
b25FeCBoYXMgRklMRV9SRU5BTUVfUkVQTEFDRV9JRl9FWElTVFMgDQorIEZJTEVfUkVOQU1F
X1BPU0lYX1NFTUFOVElDUw0KDQpodHRwczovL2xlYXJuLm1pY3Jvc29mdC5jb20vZW4tdXMv
b3BlbnNwZWNzL3dpbmRvd3NfcHJvdG9jb2xzL21zLWZzY2MvZWJjN2U2ZTUtNDY1MC00ZTU0
LWIxN2MtY2Y2MGY2ZmJlZWFhDQpNUy1GU0NDIDIuNS4xIEZpbGVGc0F0dHJpYnV0ZUluZm9y
bWF0aW9uIGhhcyANCkZJTEVfU1VQUE9SVFNfUE9TSVhfVU5MSU5LX1JFTkFNRQ0KDQpTbyBu
b3cgYm90aCBjbGFzc2ljIFdpbmRvd3MgREVMRVRFIGFuZCBQT1NJWCBVTkxJTksgaXMgYXZh
aWxhYmxlIGFuZA0KZG9jdW1lbnRlZC4NCg==

--------------N9KSZi0yac4Bt5xSN73Agp4W--

--------------fk0yrIjBNJCgLHOxTfrNsu50
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmf2GNQFAwAAAAAACgkQqh6bcSY5nkbq
6xAAlMm3jrQ0n4/ASmiufy32Asu2FmrMyIFysqOKwbjdXv+3Cm8MT4HB70nxuu3OU6lXYrrNt/nh
tKGFtbp1QQUFSSiIafCADqbAaYqmjcAlFpFuKGWfasYHOzgU7ht7OpJfYrJI71VRYkvoS7j0iGUd
FNXLUgPHn4A8Lr/ROdHzun28ALug16Hofp1OxrlQxzWkLemOum7f4xUxEYq8oAtIpUtX4ACMG8uw
qo51dYO0O+DjvmuJ5MjwHkaYF/1r4rfkXEIy7k4T2s6U1o+iuJEtwjZkOxIf2FaaCnxEpK18yWCb
mBdswxxcMnrn5zmaNJXuCI3W/SdWEC3M9u924MckLOqV8cuawSMkV0oICgnsEqT0UD7Q8hc9uqZ5
CrsmVR1lmsKmh4LoiMbt2IyeJy1iyzRP7TVtbVUDYO3ws3j8xdqu4PAQqYfcQ3NxL3PD70QZQv53
0n6Fofz+0rsqXF+s1FhqnK85AIgWpRvs01/qOkSeRl4bEsOKSZeRjKMVS+2vPfveFyXgDLqI6uSf
iN3+sNChKUslqzjjZERRoG39fCXxhln3XdhuuKuoW0j3os8ZUkjYsmOeOJHUL4Y803Pt4uXl2YgV
L0ZPi3YegThItNzWqKyRB+tGfUOYhvQf6H8UGzUp3lJc/p71KTbHL+LbWzJJ8bukIoX+3rp52Rye
77g=
=5KpD
-----END PGP SIGNATURE-----

--------------fk0yrIjBNJCgLHOxTfrNsu50--
