Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F0B346AC0
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784967877; cv=none; b=TWvVppTnifqXyFz25hD3dpHhdpTjC/wqjpE6beL4BSqvgebAPPtaRQ6QVsCBNLDX19TdYhAypxJgUWq+kodDkyTFGw6jSSxfnOom+qOLRQNrunF4qGRNWnclcFsjnDUQemA9/8eKQp7dJ1I7Xnjye4T9/Cx+j5WAbcSANXiz81Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784967877; c=relaxed/simple;
	bh=4IUrCfImkBXCaMT/sc0edjbIMae8iIMDgZG3kss9wZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9lgb+n6W+qXnY7QDezJc3btUDJkt0uRpGZQAKPP56yUi7LCOtPRZWT3yMvNPTX0nyJspRkWvBRhkf5Aj+G7s5djgAHLGamCcEpPqVOQI0ZlD6KW2hu2JQ7b5P3kgEPJkpQ+Q0UGoA6qN33ddrDKHpWufL+fuSeYSkqL6Ic3zHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=s0OET98L; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="s0OET98L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=4IUrCfImkBXCaMT/sc0edjbIMae8iIMDgZG3kss9wZQ=; b=s0OET98LaYiOai4PmwACBO/HwE
	fJoV/U68b/Mq3EE3Hl21zO/N36EGuIt/NVYjoftBI3WwO8s84KNf1P6OdDB4joXP79WjEzXbPjC2W
	VkQX5d0pARQrqWB0tmgCpLahHOXr1dWsIf96V93ML+jKBpetJzG3S18gnXZuzTY19/Tjmn/A5P0aM
	bhtT82lKT8cs8JHdgiuBxFY57asF8rVhSpMpt6ldKdsq2kTLUzb40TIfTzz9fCGYGM8HFkB7kLP6N
	MZPG6jzysoFyFWYCfgWUmFPvo4Q0qrsiOH1qDl+VLfx0mWChFY/XA+Za3tgeFhHnrC4QWsn/bnvwh
	A7d5ojAvnhMtbs2P7cgb2jFLS/qBWOLFkzUoaOrcgZLclcyLJPi1wQa0uSFSMWRKLKpuaCsMbor71
	bnbXtc23PkGuzlpYwvo+BK+ttWypxEox7ybtYqTvSXhTVUmN5lPS2vhd3cHIhAZvB15nu8vJneg53
	ZeZhCMbpSQjefBoSgWMQJv1T;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wnXgM-00000000KSF-3Aej;
	Sat, 25 Jul 2026 08:24:31 +0000
Message-ID: <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
Date: Sat, 25 Jul 2026 10:24:30 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: tanze <tanze@kylinos.cn>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
 "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ryfJrgOewFBMOWFHEkzgs0ZE"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ryfJrgOewFBMOWFHEkzgs0ZE
Content-Type: multipart/mixed; boundary="------------apdPdAdXaVEeFsYlRNU841Q5";
 protected-headers="v1"; hp="clear"
Message-ID: <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
Date: Sat, 25 Jul 2026 10:24:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: tanze <tanze@kylinos.cn>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
 "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>

--------------apdPdAdXaVEeFsYlRNU841Q5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgWmUsDQoNCk9uIDcvMjUvMjYgODo1NiBBTSwgdGFuemUgd3JvdGU6DQo+IEZvciBhIGhh
bmRsZSBvcGVuZWQgd2l0aCBhbiBTTUIzIFBPU0lYIGNyZWF0ZSBjb250ZXh0LCB0aGUgbWFw
cGluZyBpbg0KPiB0aGlzIHNlcmllcyBpczoNCj4gDQo+ICDCoCDCoCBDbGllbnQtdmlzaWJs
ZSB4YXR0csKgIMKgIMKgIMKgIFByb3RvY29sIEVBIG5hbWXCoCDCoCDCoCDCoCBTZXJ2ZXIg
eGF0dHINCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIMKgIMKgIHVzZXIuZm9vwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgZm9vwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqB1c2VyLmZvbw0KPiAgwqAgwqAgc2VjdXJpdHkuY2FwYWJpbGl0ecKgIMKgIMKgIMKgIMKg
c2VjdXJpdHkuY2FwYWJpbGl0eSDCoHNlY3VyaXR5LmNhcGFiaWxpdHkNCj4gIMKgIMKgIHNl
Y3VyaXR5Lnhmc3Rlc3RzwqAgwqAgwqAgwqAgwqAgwqBzZWN1cml0eS54ZnN0ZXN0cyDCoHNl
Y3VyaXR5Lnhmc3Rlc3RzDQo+ICDCoCDCoCB0cnVzdGVkLmZvb8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgdHJ1c3RlZC5mb28gwqB0cnVzdGVkLmZvbw0KdGhhbmtzIQ0KDQpJJ20gcGVy
c29uYWxseSBzdHJvbmdseSBsZWFuaW5nIHRvd2FyZHMgaGF2aW5nIGEgcHJvdG9jb2wgZGVz
aWduIHRoYXQgDQpjYXJyaWVzIHRoZSBuYW1lc3BhY2UgZm9yICphbGwqIG5hbWVzcGFjZXMg
aW5jbHVkaW5nIHVzZXIuIFNwZWNpYWwgDQpjYXNpbmcgdGhlIHVzZXIgbmFtZXNwYWNlIGp1
c3QgZm9yIHRoZSBzYWtlIG9mIGF2b2lkaW5nIGEgY2xlYW4gZGVzaWduIA0Kd2l0aCBhIHBy
b3RvY29sIHZlcnNpb24gYnVtcCBzaG91bGQgYmUgYXZvaWRlZC4NCg0KQXMgc2FpZCBiZWZv
cmUsIEknbSBoYXBweSB0byBoZWxwIGFuZCB3b3JrIG9uIHRoZSBwcm90b2NvbCBzcGVjIGFu
ZCANCmRvY3VtZW50YXRpb24gc2lkZSBvZiB0aGluZ3MuDQoNCkkgc3VnZ2VzdCB3ZSB3YWl0
IGZvciBtb3JlIGZlZWRiYWNrIG9uIHRoZSBkZXNpZ24gZnJvbSBvdGhlcnMsIA0KcGFydGlj
dWxhcmx5IFZvbGtlciwgbWV0emUsIEplcmVteSBhbmQgVG9tLg0KDQpUaGFua3MhDQotc2xv
dw0K

--------------apdPdAdXaVEeFsYlRNU841Q5--

--------------ryfJrgOewFBMOWFHEkzgs0ZE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpkcr4FAwAAAAAACgkQqh6bcSY5nkb3
KQ//TVYgW9YBdczqDu465yBTfluISM46CAj2CY3bMmHt/hHszbaelt4HJMxttBXHn++TZq7dODgj
X1hf8KN/qKnl4JfjRRvE59wpBQFUjU2sidophxg37Z8lWsz0VRVuN89xp0cuy3PVEqWbBmYV7Kui
r6RTgeD3D3oJu8i2tMvC+87XWjD3wfuVgjnhSAlbIgZbYOScnvZSSa2Cv0loKpX1TU+eFKg3KJPT
qoI3xIX5VcjkT8cHRj5q8dK/12yjhXtqM0s//7LaLN3s2p6qYdd2je1NMLbsAHbedH6khrTUAbRY
lATsQZBEIUWaAeh5rkOYif3mZPfA+cDUigyBznE7uYDyVAmf+2JCBLrIZi4XxwqLE2KFuHOxUUZ/
9VpWDWYM7cDoBBfquFeoOvC+dbPIB7plxrggrXizMfGQ0BzfpnUVjFCNrqoNGVTa1PVk7TIJkgUz
BJwPMN53q6oYNGcMRrg+ZI6K3Br/7l/pHqaGBaVTjzpABFOxOE5axY2DY6T7NJKOl0R4EzA0vx55
RWfL4npTCjCOUIyE1KYb//I35RFRVCkM0TwnnpaQAzKYvi9HyVCOaWLpSO94wIf9mqaXjAvGi8CG
4zGO9mzaEw8C/zHpaf12bpX3h8xb+UXQOh/0pOOrq+QLZ8E1q09XICQfV6903pf617oIy5l6niAd
M3U=
=AAFO
-----END PGP SIGNATURE-----

--------------ryfJrgOewFBMOWFHEkzgs0ZE--
