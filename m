Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OjnVDi1W"
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BFD100
	for <linux-cifs@vger.kernel.org>; Mon, 20 Nov 2023 06:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=hZ8GqqcTKrz1XI+HEzBJa2c/IAX1LMk1dvqy52WeKN0=; b=OjnVDi1WVVgU1dGlsu+C1fXZlL
	c8YArdHi0EphTsBWvzCyq6l8CSsHy9E2BvO5WtHXF/VSoyf64JvepIynXxZgCfSWZUKskNzhJrV6o
	gHVZsnAhijz0yVPHRMWrS/JQdsxcgD04EtgdzrRlAvTKXb5WgBNpdxIa7U+zQCi/KfEugnCUYB4h3
	6BZtzG7LwFGW6Ntm5n+qNKbcfZDm89Qj8Kbt20FuS2lyBytcOQ9DKCEaCYsTyH4s/hs2iL0BNhKiA
	ftTP0ABVMmyGsqCGMMLMbgNSeIpGWpgNQDMkV5GIMX1+vb8EY+SaGVRBIaoBy2PotZTVnsPgOINcm
	KUGGupC5s65jsfARYXLUBIvgi2aplgeJmNuiQsQ6poycwZPzH069ATgiPTed39NbvKGUlCKSZYuDw
	56hzZFS3+tCU9o7ONkNvVDdbmusz+G3mWWMfWO46jmG6djlZuycsV/gJN8sAUoJ7+K1UavBl+FhNe
	pKiRG0u15/hN68Bu4AbCVyDd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1r55FR-007AYe-2M;
	Mon, 20 Nov 2023 14:27:37 +0000
Message-ID: <5958d09c-d8d3-4401-8c9b-ac4c12f06c30@samba.org>
Date: Mon, 20 Nov 2023 15:27:36 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] smb: client: set correct file type from NFS
 reparse points
Content-Language: en-US, de-DE
To: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231119214450.23779-1-pc@manguebit.com>
 <20231119214450.23779-3-pc@manguebit.com>
 <ebade998-7c7e-422f-a1fe-680571b1310e@samba.org>
 <14fd545cbbdfda52300ad19b66a02f5a@manguebit.com>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 t71EGDetLzTlZf4K3t3SwQ==
In-Reply-To: <14fd545cbbdfda52300ad19b66a02f5a@manguebit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------t8pHZKqIxoutf3W725ixS9VC"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------t8pHZKqIxoutf3W725ixS9VC
Content-Type: multipart/mixed; boundary="------------EP6gTMt7quYBhZ61XsNfQGoQ";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Message-ID: <5958d09c-d8d3-4401-8c9b-ac4c12f06c30@samba.org>
Subject: Re: [PATCH v2 3/3] smb: client: set correct file type from NFS
 reparse points
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231119214450.23779-1-pc@manguebit.com>
 <20231119214450.23779-3-pc@manguebit.com>
 <ebade998-7c7e-422f-a1fe-680571b1310e@samba.org>
 <14fd545cbbdfda52300ad19b66a02f5a@manguebit.com>
In-Reply-To: <14fd545cbbdfda52300ad19b66a02f5a@manguebit.com>

--------------EP6gTMt7quYBhZ61XsNfQGoQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEvMjAvMjMgMTU6MTcsIFBhdWxvIEFsY2FudGFyYSB3cm90ZToNCj4gSGkgUmFscGgs
DQo+IA0KPiBSYWxwaCBCb2VobWUgPHNsb3dAc2FtYmEub3JnPiB3cml0ZXM6DQo+IA0KPj4g
T24gMTEvMTkvMjMgMjI6NDQsIFBhdWxvIEFsY2FudGFyYSB3cm90ZToNCj4+PiBIYW5kbGUg
YWxsIGZpbGUgdHlwZXMgaW4gTkZTIHJlcGFyc2UgcG9pbnRzIGFzIHNwZWNpZmllZCBpbiBN
Uy1GU0NDDQo+Pj4gMi4xLjIuNiBOZXR3b3JrIEZpbGUgU3lzdGVtIChORlMpIFJlcGFyc2Ug
RGF0YSBCdWZmZXIuDQo+Pj4NCj4+PiBUaGUgY2xpZW50IGlzIG5vdyBhYmxlIHRvIHNldCBh
bGwgZmlsZSB0eXBlcyBiYXNlZCBvbiB0aGUgcGFyc2VkIE5GUw0KPj4+IHJlcGFyc2UgcG9p
bnQsIHdoaWNoIHVzZWQgdG8gc3VwcG9ydCBvbmx5IHN5bWxpbmtzLiAgVGhpcyB3b3JrcyBm
b3INCj4+PiBTTUIxKy4NCj4+IGFueSBwbGFucyB0byBhbHNvIGltcGxlbWVudCB0aGlzIGZv
ciBTTUIzIFVOSVggRXh0ZW5zaW9ucz8NCj4gDQo+IEFic29sdXRlbHkuICBKdXN0IHdhbnRl
ZCB0byBtYWtlIHN1cmUgdGhhdCB0aGVzZSB3b3JrZWQgb25seSBpbiB0aGUgY29kZQ0KPiBw
YXRocyB3aGVyZSB3ZSBhY3R1YWxseSBoYW5kbGUgcmVwYXJzZSBwb2ludHMuDQo+IA0KPiBJ
IGFsc28gcGxhbiBzZW5kaW5nIHBhdGNoZXMgdG8gc3VwcG9ydCBjcmVhdGluZyBzcGVjaWFs
IGZpbGVzIHZpYSBORlMNCj4gcmVwYXJzZSBwb2ludHMgYW5kIG1ha2UgaXQgZGVmYXVsdCB3
aGVuIG5vdCB1c2luZyBTRlUgdmlhIG1vdW50IG9wdGlvbi4NCg0KYXdlc29tZSEgOikNCg0K
LXNsb3cNCg==

--------------EP6gTMt7quYBhZ61XsNfQGoQ--

--------------t8pHZKqIxoutf3W725ixS9VC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmVbbNkFAwAAAAAACgkQqh6bcSY5nkbI
sBAAr7rfiG4cb8I87IhgnWBw2bu1fnOEbn9LzqaEHqD10ctj3knKQGv3D+OPUudNF3ceNoU9JAyB
oStbTW/3gflHDvrBzaGW8bJcKI8iDmxWZbi0p4mf5rMS4W0URxvpo1OyE+DhNcnBhpkr+O/4s+Y+
bNCawpkpRoe6gmfUiPLJ0vmxPWeiguTiWiVHLt18V3aSeP+CSVxXgGmDLlOQuWntZyyLym1KG1Hu
gAAJiBAfoG6xvlVjk0SDf3YXSih9lv1cqiIk2Zu5dARcOg00SFOQackevgOABTdsCKq6UZL9CbF+
2VFIbAlREb26Am0g7k9Ryf8r/KrVFbxVcQE5YBt+AhUsWx477/MI9iA+LeC30RJ1kqehzM4q8kXD
4/cehqt4nZBzG2Qz5A3A+pHtoHz07OOJG6kwo8x736/oOIq4TkIKbwsnkYabThCnqYVaQL0sNfm7
QmLnN/0kANa++zptkTsidXG5IcW6+eq/saA7aYuIH6eJFUGrT4HM0wcOoVntFNTsHur2nygh348M
Rdq9Tyi8uF+klnpw7Y+ZzY1PKGMzceyBLJK2bxFUH6KUNxQ1NxtxhW8B+DmqX1eqVpwOieXcrriT
sgd1cZ7MhZ9Nnlx/6ZSE1X8AmRUkWNJM86m9De553PhxkOWHPMABIJB+FMI/7prGzOP/lLrOpZXo
HZg=
=4I4g
-----END PGP SIGNATURE-----

--------------t8pHZKqIxoutf3W725ixS9VC--
