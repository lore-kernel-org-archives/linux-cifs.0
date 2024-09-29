Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED1178372;
	Sun, 29 Sep 2024 12:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727614355; cv=none; b=Sgu72XWtJ0X+GERt1jzXuzDfi6TIUn8l9pkzXdTqLt8gMAI6O6eCeuv8+rhMIwOlPbAYPYYvp26fFJKqp3N/CGDKTn1mNPP7fuQtq/rjZY53t24/HOM7Ww4qUZKSnlZd0AQZxsAjsXgToF4+zkQMBUQSRbSwe7FBPO0NzwNk/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727614355; c=relaxed/simple;
	bh=psI+7EENHy0R9iKk8TYGXcFDf9w3SiwYk/cL5Gf5DT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aWOEpfQBGZ/FV13wBzbaiAVEZ7XNI+gau79SjJoI7ak02HRZ+5/AMs1yBEHxKRNLtI4m7h9OoZj+kwcZsfIYPTTfNuo1D1UkEYl86u5tyWaUqwD4QZGNw1Ac3WDYXUD2lKliYwtSB5U2+PqnJfs0f3FRyyIZA25RD0JpYPELDlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=skH+Kqzu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="skH+Kqzu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=psI+7EENHy0R9iKk8TYGXcFDf9w3SiwYk/cL5Gf5DT8=; b=skH+KqzuAyNIy8IY+M5KS8PDFp
	bDeQAVSrjExsZmEfVUlmukFFodKRsL+PAkGYHeTL5meHIRKb3psi22uNiz2oqGVWtCtBOmnJNLMhG
	Qbn4aXMDcV1ZiuRcR1MswwgSeNHvSO0iTuwwK9Uwq+SC1tcnczsRJuVUAh1mAulJ2HMab3zoy0bdV
	9SS4oq4S+YHieTiIwEXsYokXZ9Tcnn70HzOOZh79rCFdOzRV14lJVnemlfL4SoMiRO5krha/qmdZQ
	PK8DsJ2UcanAXWhAD1dX1zqkD/mBfSI3PtE3S1g4HNj77fObv786dH19UytKN50pUeKu6AO0EmK85
	qQtp7wRekgemaz0QqePiwN9bFuaBe+bmPn/+H3Wh1p1FGZXzpEFIf0KDsV1Qi53OJz/ANXZEcTwAa
	szUAS7HFgGcNeA9GLl12mAH9qn103aMAAr0t614VN95Mxy0aX+ecZ3lXgpKXfTyUXHNaEmSYl8czF
	O8whER6mOeBhfOBmAtrx7ZnR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sutPa-002YfE-28;
	Sun, 29 Sep 2024 12:52:30 +0000
Message-ID: <5431fa20-089d-4d4e-ba9f-926860d4f202@samba.org>
Date: Sun, 29 Sep 2024 14:52:29 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] cifs: Rename posix to nfs in parse_reparse_posix()
 and reparse_posix_data
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-9-pali@kernel.org>
 <CAH2r5mvqrWHX6n58eXGL0EgVuhKBD-aZbgrF1DBG9evdXNNaCg@mail.gmail.com>
 <0105d773-3030-4ee9-8b25-b074768df73c@samba.org>
 <20240929092623.yaqhixsa4eot4k62@pali>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20240929092623.yaqhixsa4eot4k62@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8SlKgr4Dupkhk6B2EzBt8Kq0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8SlKgr4Dupkhk6B2EzBt8Kq0
Content-Type: multipart/mixed; boundary="------------5fFK0auv6Fbv45mOHym5Dcjs";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <5431fa20-089d-4d4e-ba9f-926860d4f202@samba.org>
Subject: Re: [PATCH 8/8] cifs: Rename posix to nfs in parse_reparse_posix()
 and reparse_posix_data
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-9-pali@kernel.org>
 <CAH2r5mvqrWHX6n58eXGL0EgVuhKBD-aZbgrF1DBG9evdXNNaCg@mail.gmail.com>
 <0105d773-3030-4ee9-8b25-b074768df73c@samba.org>
 <20240929092623.yaqhixsa4eot4k62@pali>
In-Reply-To: <20240929092623.yaqhixsa4eot4k62@pali>

--------------5fFK0auv6Fbv45mOHym5Dcjs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8yOS8yNCAxMToyNiBBTSwgUGFsaSBSb2jDoXIgd3JvdGU6DQo+IEhlbGxvIFJhbHBo
LCB0aGFuayB5b3UgZm9yIGluZm9ybWF0aW9uLiBTbyBpbiBjYXNlIFNhbWJhIGlzIG5vdA0K
PiBnb2luZyB0byB1c2UgSU9fUkVQQVJTRV9UQUdfTkZTIGFzIHByaW1hcnkgd2F5IHRvIHNl
cnZlIHNwZWNpYWwNCj4gZmlsZXMsIHRoZW4gaXQgc3RpbGwgbWFrZXMgc2Vuc2UgdG8gZG8g
dGhpcyBzdHJ1Y3R1cmUgcmVuYW1lIHdpdGggbXkNCj4gcGF0Y2g/DQoNCnRoYXQncyB1cCB0
byBQYXVsbyBhbmQgU3RldmUuIEkgY2FuIG9ubHkgdGFsayBwcm90b2NvbC9zcGVjIGFuZCBz
ZXJ2ZXIuIDopDQoNCj4gQW55d2F5LCBXaW5kb3dzIGNsaWVudHMgbW9zdGx5IGRvIG5vdCB1
c2UgSU9fUkVQQVJTRV9UQUdfTkZTLg0KDQpUaGV5IGRvbid0ICpjcmVhdGUqIGl0LCBidXQg
dGhleSBjYW4gKnJlYWQqIGFuZCBwcmVzZW50IGl0LiBCdXQgSSBndWVzcyANCnRoYXQncyB3
aGF0IHlvdSBtZWFudC4NCg0KPiBGcm9tIG15IGtub3dsZWRnZSBvbiBXaW5kb3dzIHRoaXMg
dGFnIGlzIHVzZWQgb25seSBieSBXaW5kb3dzIE5GUw0KPiBzZXJ2ZXIuIFNvIHNjZW5hcmlv
IHdoZW4gV2luZG93cyBzZW5kcyBJT19SRVBBUlNFX1RBR19ORlMgb3ZlciBTTUINCj4gd291
bGQgYmUgcmFyZS4uLiBJdCB3b3VsZCBiZSBuZWVkZWQgdG8gZXhwb3J0IE5GUyBzaGFyZSB2
aWEgV2luZG93cw0KPiBORlMgc2VydmVyIGZyb20gU01CIG1vdW50IGNvbm5lY3RlZCB0byBT
YW1iYSBzZXJ2ZXIuDQoNClRoYXQncyBvdXQgb2Ygc2NvcGUgYXMgZmFyIGFzIFNNQjMgUE9T
SVggRXh0ZW5zaW9ucyBhbmQgSSBhcmUgY29uY2VybmVkLiA6KQ0KDQo+IE5vdGUgdGhhdCBX
aW5kb3dzIE5GUyBjbGllbnQgc3RvcmVzIGRhdGEgYWJvdXQgc3BlY2lhbCBmaWxlcyBpbiBF
QXMuDQo+IFNvIGZvciBleGFtcGxlIGlmIHlvdSBtb3VudCBleHBvcnQgZnJvbSBMaW51eCBO
RlMgc2VydmVyIGJ5IFdpbmRvd3MNCj4gTkZTIGNsaWVudCwgdGhlbiBORlMgc3ltbGluayB3
b3VsZCBiZSB2aXNpYmxlIHRvIFdpbmRvd3MNCj4gYXBwbGljYXRpb25zIGFzIHJlZ3VsYXIg
ZmlsZSB3aXRoICJOZnNTeW1saW5rVGFyZ2V0TmFtZSIgRUEuIE1vcmUNCj4gaW5mbyBpcyBp
biB0aGlzIGVtYWlsOiBodHRwczovL21hcmMuaW5mby8/bD1zYW1iYS0NCj4gdGVjaG5pY2Fs
Jm09MTIxNDIzMjU1MTE5NjgwDQo+IA0KPiBBbmQgdGhpcyBpcyB3aGF0IGFyZSBXaW5kb3dz
IGFwcGxpY2F0aW9ucyB1c2luZyBpZiB0aGV5IHdhbnQgdG8NCj4gYWNjZXNzIGRhdGEgb2Yg
c3BlY2lhbCBmaWxlcy4gU28gYXBwbGljYXRpb24gYWNjZXNzDQo+ICJOZnNTeW1saW5rVGFy
Z2V0TmFtZSIgRUEgYW5kIG5vdCBJT19SRVBBUlNFX1RBR19ORlMgcmVwYXJzZSB0YWcuDQoN
CkZvciBzeW1saW5rcyBTTUIzIFBPU0lYIEV4dGVuc2lvbnMgd2lsbCB1c2Ugd2hhdCBXaW5k
b3dzIHVzZXMgbmF0aXZlbHk6IA0KSU9fUkVQQVJTRV9UQUdfU1lNTElOSy4NCg0KPiBUbyBt
eSBrbm93bGVkZ2UgbmVpdGhlciBTYW1iYSwgbm9yIExpbnV4IENJRlMgY2xpZW50IHN1cHBv
cnRzIA0KPiAiTmZzU3ltbGlua1RhcmdldE5hbWUiIEVBIGZvciBjcmVhdGluZyBvciBwYXJz
aW5nIHN5bWxpbmsuDQoNCmZvciBTYW1iYTogeXVwLg0KDQotc2xvdw0K

--------------5fFK0auv6Fbv45mOHym5Dcjs--

--------------8SlKgr4Dupkhk6B2EzBt8Kq0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmb5TY0FAwAAAAAACgkQqh6bcSY5nkbr
aA/7BIG7fQ4Z6a4fgdSntU2QxWZoWuYpHt6+VxX9lAhpIcpqqCuqAisnesatZt9TSLsxy5LEdOd3
U4vQsV2WmVICWk5B1rrUGgSRRnranm5jBdSgfJTZP+HmHIU5c8ziNyIxAAGQ5JYFmjfvTttfSGA6
urENbMt/D314HJfzbJXH6UFa2eU+f1bcq9eQUD5GmtyuED6wXj/OdPa+ujPt9SQKmA283cOx3vmv
o5C2ZAitzh/0/hkTVGLlw2EEBTioaBG22ha600VJCXvdKh4t3gs7JM0xU1pNH+7nOXAIVIzhWw0y
1Fsj+femh9byInGKSwuhlVUtcudspCcW99scpiuEdf5fA3Hd7vLxLUz1c/+lLT/ekUCxyjiNbTyB
DIsgV9kIdmV6UDWKc+idvH9wQgM1yE1NeZUiCV7czP3C4Ubt3jtC8xIK0fNk0B/eZiCgewzu7oRB
BLZoTMkxaPHeK6X42LrIDtgH1atwzOX16emtynlGQ/5pTVyuzWdr/OfyBd0vcWyBVxChljiwptDC
EnRtrZ7OQeZlypJNm5kD/pVlj0V/P9fGWPP51437+ptWHcMHjJAzdiiL8KemKeYPZ5ovqmn1vQ/M
pz55nQxLJhZ8CH4utmifdkyyHDW592+2lYWzPbiVNXEDRtvHJ5F4ce31pc5G3ohFMPerWeDtSJ/5
TDM=
=uea8
-----END PGP SIGNATURE-----

--------------8SlKgr4Dupkhk6B2EzBt8Kq0--
