Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC346F53E
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061056; cv=none; b=comZFYD+HZX86RcpxJImi6C0f8Wqf9ghF6DfBQ0zZ0ociy0tqtdE77JE8fytherPYCM5A3y+AgJi/peZ713RqubKw64eaFTbLZt1WAZWE7ZnF86gMeiuoIC9NkCM6/cPKluiO3lLBT30+I6pFocWty0G0sNJZS6Yu6xGNflpP/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061056; c=relaxed/simple;
	bh=o2e9w1TIUa2NWVbbxosJSp8BxrUk782XNBnjT8SHpMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Gctg0J3vZTds+w+wNSPxgOIdZwa7+7c3LCTlXX3oKCm0tza/J/qQ72tgBX0ZUfY2CaWt5soe05pm5wCllUfL5v7KnVPk3WyiIjja9QnVKEJkCFPF9Ntu22lshznUh4A3XOO2eDetV6iVeY4hSyZ453iH5Ethf+NI2wolhCJ4PsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=baddCotf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="baddCotf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=o2e9w1TIUa2NWVbbxosJSp8BxrUk782XNBnjT8SHpMA=; b=baddCotfcsUK0NNlwY7CHzORvd
	3xyCjrZUgoVDbibeeEdY1OP2B1H4FG5xfag9WziJD0eyVH4ZiWEos+3sIjiFGd1NAS4CLNMxykMf8
	NwzptF2HMA2rTB8hHoVU3uM5CC9MOQiX/eJVJI/3Nt6Iq48lmOQ8r3XCWyt3ICIeecqqh4RyHcrA0
	qkMqQXC7FuWUFV7oaGDm9u6nsVGEWVZG+UTk1AILbA9SuE71rzbr0eCnDovLcxzdu/Xn7EtlQro4U
	XwpWTg0bg+q9c/csuY0FcQ2P79h9EnQacLLrEdQh3o4v4y/+TWAO3RHgwpvRJFi4zGkFt7q0WnI2C
	FDhz1vceZmPqB/nVAhGfoV/nphXqBrhbmZYI9r0l531GPmpuvNkDHBPTSm4zohRU5I30rQed5ce8R
	A4FL67aykAqLZnyPNIIbeUwz3aeNihKht57kjonuYtwtZpPvk2VrSdbXNIxSOj4xcwBMuN7oOacFA
	A735pdxAqGdrqJYF53KUqkkj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uhrPG-000YOG-1v;
	Fri, 01 Aug 2025 15:10:50 +0000
Message-ID: <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
Date: Fri, 1 Aug 2025 17:10:49 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] Sequence of actions resulting in data loss
To: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
Content-Language: en-US, de-DE
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GOr9pfb50GcW048E2HFhumCw"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GOr9pfb50GcW048E2HFhumCw
Content-Type: multipart/mixed; boundary="------------6oKSb394zrx0GJKhS9PViqF5";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
Subject: Re: [Samba] Sequence of actions resulting in data loss
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
In-Reply-To: <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>

--------------6oKSb394zrx0GJKhS9PViqF5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Li4uYWRkaW5nIGxpbnV4LWNpZnMgdG8gdGhlIGxvb3AuLi4NCg0KT24gOC8xLzI1IDM6MzQg
UE0sIEplYW4tQmFwdGlzdGUgRGVuaXMgdmlhIHNhbWJhIHdyb3RlOg0KPiAkIG1ha2UgdGVz
dA0KPiBlY2hvICduZXcgc2NyaXB0IHZlcnNpb24nID4gbXlzY3JpcHQucmVwbGFjZW1lbnQN
Cj4gLi9yZXByb2R1Y2VyDQo+IHNsZWVwIGZvciA1IHNlY29uZHMuLi4NCj4gKG1haW4pIGZh
aWxlZCB0byByZW5hbWUgbXlzY3JpcHQucmVwbGFjZW1lbnQgdG8gbXlzY3JpcHQ6IE5vIHN1
Y2ggZmlsZSANCj4gb3IgZGlyZWN0b3J5DQo+IChyZWFkZikgZmFpbGVkIHRvIG9wZW4gZmls
ZSAnLi9teXNjcmlwdCc6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCg0Kc28gaXQgc2Vl
bXMgdG8gYmUgc29tZXRoaW5nIGluIHRoZSBjaWZzIGtlcm5lbCBjbGllbnQgZG9pbmcgdGhp
cy4gQ2FuIA0KeW91IHNvbWV3aGVyZSBwb3N0IGEgbmV0d29yayB0cmFjZSB0aGF0IGNvdmVy
cyB0aGlzPw0KDQpAU3RldmU6IGRvIHlvdSBoYXZlIHNvbWUgZmFsbGJhY2sgbG9naWcgaW4g
dGhlIGNsaWVudCB0aGF0IGlzIHRyaWdnZXJlZCANCmlmIGEgcmVuYW1lIGZhaWxzIHdpdGgg
U1RBVFVTX0FDQ0VTU19ERU5JRUQgYW5kIHRoZW4gcmVtb3ZlZCB0aGUgDQooZXhpc3Rpbmcp
IHJlbmFtZSBkZXN0aW5hdGlvbj8NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------6oKSb394zrx0GJKhS9PViqF5--

--------------GOr9pfb50GcW048E2HFhumCw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiM2PkFAwAAAAAACgkQqh6bcSY5nkZh
gA/9GMFK+dBI+eKqqwlI2jVFmXpTvqA2AR0yqXdQ2K6q/w+nHSOF0bPQMqfNX44XLr9H5ZVBSfsU
eg1cNqDXrd/AHn3f8c7ilkUig5f0fYDjcnkq3gDWihUf6+QonORxGcJlOpu9gwfJpWIUBn6UyvAg
va0UVB/cuwHQe/Q8OrxhrO3cvLu4Sv3MNLyW2R/D98E6ubw6gfPWyLmeagFL/KXY8xIDZm1HKDwj
mIMl5947kklhstEFbisYplN+CPjkvuJ/Qj7gRvi8YeOtvsx/m5GCoZF03OpDEC59/8hDNKAGQhpV
ciErKStUye/LvRep8riyvC56jVlH7GAsRFH97h8wgIp/4n0xJ/uIHk7OqcAT3oE+hGrbIvV/zMCV
u0G9WI+LK88sUmkzA6wUSHifYFNPOLxxPeGEG/N1Dli46i+kaiAv4XTDAQJQES04XmRZztpexpD/
itqzDwee+5A6qQpJo+KjaYRZsC58ckXPNGWA3oh20VxrKB2szXJ6DYojk4/OEDDgpgkUGMAF6t/7
GC9zS8gtfJIvx1fcDG4FeoX+tv8yeHH+43bdFbO+K752YGFonpzq0CLb5W4Bc3yK8Zy+dLcZqqo5
NRx4cSD+fjz6RDeC28eDvceJ9vyAW4BFvCSlzE++kyMOIALrADZ4vO9Jzs+zgFooZgpKNL+2NoZj
x1E=
=fuux
-----END PGP SIGNATURE-----

--------------GOr9pfb50GcW048E2HFhumCw--
