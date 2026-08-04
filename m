Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF3A4766B6
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785861780; cv=none; b=N7prLvvCsIt+0apTtpVhi/PwiqAC/m5r9gGErrgSbeeaElyGIepW/Clp56H4jTR0hcYhS1XLpoE44+6OMDhmfG6VnrJqCpemz5P63c8djmJJ66Ynn69cFNtLE9UMYsIX6gxfFiPHBa1vrDxJvE7rSE73WViDX+6gxTaL8jsYI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785861780; c=relaxed/simple;
	bh=7FJzHXnk58JMdrpo+LF6/QdI8Wj/YOi04R0pIbNIjL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kn8haVK2AfiwG+58B2HGHuD1uCr7z5nqyWIVYFIwyOVt4yEenHbo3m2xYrPUjk/k+T8g8a+kM9Ea3JbxISPLag8vopVWcnAH+qg5Tt1q5zGrWq9HSAfTM4hY2Q7KSyFwzOWhntYTDnf5OzEUYLK4cs/MLNMgRiR/nqM/zUVxoJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AS9sLEv/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AS9sLEv/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=7FJzHXnk58JMdrpo+LF6/QdI8Wj/YOi04R0pIbNIjL8=; b=AS9sLEv/pK0FmFhAH4/y6mkE3z
	iqpbfLy0Pu+0TWOI3Q3yKJs3BuCb+w9DX+j8u7jV1JICe4yWg1gtfrBjur8rRQ+s+IMvlZIrLovlE
	GEJUGSHbqS49qZa1TZXUo4P5eFrpp2WnfhwJmzx1Ci2fmBMVLDxuFsP0fv41OSGzFg2X2KpYOU82Q
	44tw5q9WvUiXjpw0rxuZGOZ+5hMLpnkeRo2DO8p7ALUreQ+S+txjJ30SuZ+Lo4aHoQhw8RiDhKht/
	BfLIziVi8VL1L1coTrA76KUEkQ9OY5nIl/wCTFmF/r1FsUH+hNaGUwhPYnFWYAMcIeElsRLhTU5no
	gxuqa3GNXcy2hNKKwplrHPeOn7wI6a3oNBEWhc25OdzyLP2XFFPYCQjUAuNtD/jat9DBc8CM7PFwB
	cS0NM7WzPr58XjztzBO2P6ypxqE4yt+RwQ9an7ADbl9BA9UYrnvIg6ioCvOnc+G1fz+zydzsK5fxi
	np4+KZ522d05sh5E1o3pxacS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wrIDs-00000002hHo-2m8O;
	Tue, 04 Aug 2026 16:42:36 +0000
Message-ID: <6eaf297c-cfba-4681-ab29-6e8515b0fdb3@samba.org>
Date: Tue, 4 Aug 2026 18:42:35 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Steve French <smfrench@gmail.com>
Cc: tanze <tanze@kylinos.cn>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Jeremy Allison <jra@samba.org>, tom@talpey.com,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org,
 Stefan Metzmacher <metze@samba.org>, "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com>
 <c33fecf6-6683-44f6-9eff-f508f172ee7a@samba.org>
 <CAH2r5mtNTaJWc8MAfqEfg5c5LDE6_RuiP_+nd4WcPXBVNxe40Q@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mtNTaJWc8MAfqEfg5c5LDE6_RuiP_+nd4WcPXBVNxe40Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------IpcLG63uJLErsCElnjOupjJr"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------IpcLG63uJLErsCElnjOupjJr
Content-Type: multipart/mixed; boundary="------------kC01hOGgrMP9nh0QeZVZ0JFB";
 protected-headers="v1"; hp="clear"
Message-ID: <6eaf297c-cfba-4681-ab29-6e8515b0fdb3@samba.org>
Date: Tue, 4 Aug 2026 18:42:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Steve French <smfrench@gmail.com>
Cc: tanze <tanze@kylinos.cn>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Jeremy Allison <jra@samba.org>, tom@talpey.com,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org,
 Stefan Metzmacher <metze@samba.org>, "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com>
 <c33fecf6-6683-44f6-9eff-f508f172ee7a@samba.org>
 <CAH2r5mtNTaJWc8MAfqEfg5c5LDE6_RuiP_+nd4WcPXBVNxe40Q@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mtNTaJWc8MAfqEfg5c5LDE6_RuiP_+nd4WcPXBVNxe40Q@mail.gmail.com>

--------------kC01hOGgrMP9nh0QeZVZ0JFB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SSBndWVzcyBpdCdzIGEgcHJvcGVydHkgb2YgdGhlIGZpbGVzeXN0ZW0gb2JqZWN0IGFueXdh
eSwgYW5kIGZvciBvYmplY3RzIA0KdGhhdCBkb24ndCBzdXBwb3J0IHRoZW0gdGhlIHNlcnZl
ciBqdXN0IHJldHVybnMgdGhlIG1vZGUgd2hlbiBxdWVyaWVkLCANCmFuZCBmYWlscyB3aGVu
IHJlY2VpdmluZyBzZXQgcmVxdWVzdC4gV2hlbiBjcm9zc2luZyBtb3VudHBvaW50cyB0aGlz
IGNhbiANCmFsd2F5cyBoYXBwZW4sIGJvdGggbG9jYWxseSBvbiB0aGUgY2xpZW50LCBhbmQg
b24gdGhlIHNlcnZlciwgc28gDQphcHBsaWNhdGlvbnMgaGF2ZSB0byBsaXZlIHdpdGggdGhh
dC4NCg0KT24gNy8yOS8yNiAxMjowMyBBTSwgU3RldmUgRnJlbmNoIHdyb3RlOg0KPiBJIGFn
cmVlIC0gUE9TSVggQUNMcyBzaG91bGQgYmUgaW5jbHVkZWQgaW4gdGhlIHVwZGF0ZWQgdmVy
c2lvbiwgYnV0DQo+IGludGVyZXN0aW5nIHF1ZXN0aW9uIGlzIHdoZXRoZXIgdGhleSBjb3Vs
ZCBiZSBtYWRlIG9wdGlvbmFsIHNvIGFzDQo+IHNlcnZlciBjb3VsZCBzdXBwb3J0IHRoZSBM
aW51eCB4YXR0cnMgYnV0IG5vdCBzdXBwb3J0IFBPU0lYIEFDTHMNCj4gDQo+IE9uIE1vbiwg
SnVsIDI3LCAyMDI2IGF0IDExOjU44oCvUE0gUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9y
Zz4gd3JvdGU6DQo+Pg0KPj4gT24gNy8yOC8yNiAyOjM1IEFNLCBTdGV2ZSBGcmVuY2ggd3Jv
dGU6DQo+Pj4gV2hhdCBvdGhlciBwcm90b2NvbCBpbXByb3ZlbWVudHMgc2hvdWxkIGdvIGlu
dG8gdGhlIG5ldyB2ZXJzaW9uIG9mIHRoZSBwcm90b2NvbD8NCj4+IFBPU0lYIEFDTHMgZW5k
LXRvLWVuZCBjb21lcyB0byBtaW5kLg0KPiANCj4gDQo+IA0KDQo=

--------------kC01hOGgrMP9nh0QeZVZ0JFB--

--------------IpcLG63uJLErsCElnjOupjJr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpyFnsFAwAAAAAACgkQqh6bcSY5nkaT
MA//VCdQychbEwYwg5GP1r/NbIsY1b3s1P1/oqXiceze3uo/yj5+YqSD0xa+Qfra7xIbizoHzKyF
gkeDo3fScDtxNB41bO4qf3BdHXOMbmJZ1gpk9zK5pvssCr0W3eyUZFkaFneAxr557O6arYVCtx8I
jj9dF8BvKcnPB4FKCSdopoEc/U80PJIyjoSJHldYmBxzyDjM3mrHJKiabc2O65ULGB+z6SN++TBD
1gVdowSbziCqCdUcdk4bdnDnRsw/4KEeSfj1Ew3dMfWZp0aFZx7oh03yhnpMlPwqVTx7L1rFmcXC
RcWFG4ObwYcEL5ZfwoR6DqpCS/jxYQ3Rb/Uw98t0KbipQvsVoLD+eHggvh8QowA4rcUhCRGcX5bD
6FCMK8vKAna813dvsDF+1uMI78PWFMKn0jODmkl0nAvXQ93B2OvDrb3Cf9sf1t/wty5/Ehv6uotd
NQxSrEXAPhBh52zW0MWqFWhWnUAxE53AAZV+NgpxlvTKlj8qvBeoND2f9MDvP2DIjfF+C4Oz6qbI
uldqFBIQdGNs+zcuqZP1ilo7CGB07CMiXkMSQch/pwDCU7PVCB/wj8L496w8OhN9cnDsoGyPDeDc
jUDcD7M037a3v7hdIHfWvzLSWLc689bQbZRDzu7Pkq+aX51WT2yLSVPJop4J28wx3jbXtMJCLu+G
dKE=
=n+0y
-----END PGP SIGNATURE-----

--------------IpcLG63uJLErsCElnjOupjJr--
