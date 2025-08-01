Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05D3182D3
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754065621; cv=none; b=eLlSHBkLucWNdDf6E3Z5Dl5ZBLPf01YjCpfzX0DV9e1fKbb5rgBB2tFoTrSvRNjZ7ZucFP9TQmGXMT3blD8AD0WVedp+8W6c+uhyYeX61hbKLIP3+qxyReNFh9GcrdPFWoofzv0xELhvTQFxLVya1T9bOHp+2ky/ng6jrReAOAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754065621; c=relaxed/simple;
	bh=XObndz6wt8zswpSF2zq9ZkaVwUPzN5qgHqLQIMkx6yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owuOKhi8KbEmS4zOQCV7RyOe96mykPsrGfAV05JCKL3sMk5f1gI/u1Acc1bzdPaDYZ0QUm8d9qj+uEcPRvT9i0VJWIoEf99FCMmpqxzQUo8FCJGfSPUIB90aivN3d7Oev777w9fMw0hCEs2v0J9G65HH9iBvE52Fdk+eV2aMh5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=S+9cEN7m; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="S+9cEN7m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=XObndz6wt8zswpSF2zq9ZkaVwUPzN5qgHqLQIMkx6yk=; b=S+9cEN7mOfWR0vyFmpolDau/t+
	B+YiCxZXD0s0yysPdaBpmj64kemtsq48gEHgA/dBCsclU9gG9C/Sp9GVrTMGOLnANEVOiil2j4fdr
	Ew+5UNTV/CTRWQ6BVnLIxcsWq5hjeqbAvs/l7vTx1JI4jEtXZmi649ayhq8mvBIJk8cSsMc+YKZ4k
	wy4NmkLpFG9bXDd5B0PQiuXFIg6lWqZGWHmC1FkqEsVoZ5Qi4P7zLpV4z0/0znK/owHJMOJiTQ7Mg
	Z968NJYm3BTVyuu4tJT3S8rTVePLR5g71hFKM0vCBJBiQRV1dZAuZOxnygQMzYxKDNPqFj7AhqtEy
	4d6d0q6klCFW57O/lJXgQ2CuLg5nRNzhXot+uIB74PLk4cwzbBvpGXwLkyKobHZ/u1PgMiRGdb54L
	858bq0sdlwnXLxwPrR+enr7WAZvOAP/jpyZCTzUTflpulzYxKlckVrO9JKwAqrK1vBgIW7fBHpLf0
	+FDQdf6mu/feMsWOnjO8QVZt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uhsav-000Z96-2t;
	Fri, 01 Aug 2025 16:26:58 +0000
Message-ID: <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
Date: Fri, 1 Aug 2025 18:26:56 +0200
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
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
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
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
 <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------si3Des9PSJ0ZD3G305VQV4uQ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------si3Des9PSJ0ZD3G305VQV4uQ
Content-Type: multipart/mixed; boundary="------------je3q8h4O51knhjbJ0yswHr3O";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
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
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
 <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
In-Reply-To: <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>

--------------je3q8h4O51knhjbJ0yswHr3O
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8xLzI1IDU6MTYgUE0sIEplYW4tQmFwdGlzdGUgRGVuaXMgd3JvdGU6DQo+IE9uIDgv
MS8yNSA1OjEwIFBNLCBSYWxwaCBCb2VobWUgd3JvdGU6DQo+PiBzbyBpdCBzZWVtcyB0byBi
ZSBzb21ldGhpbmcgaW4gdGhlIGNpZnMga2VybmVsIGNsaWVudCBkb2luZyB0aGlzLiBDYW4g
DQo+PiB5b3Ugc29tZXdoZXJlDQo+ICA+IHBvc3QgYSBuZXR3b3JrIHRyYWNlIHRoYXQgY292
ZXJzIHRoaXM/DQo+IA0KPiBIZXJlIGl0IGlzOg0KPiANCj4gaHR0cHM6Ly9kbC5wYXN0ZXVy
LmZyL2ZvcC9hQXhHTmZKUi9maWxlX2RlbGV0ZV9yZXByb2R1Y2VyX2MucGNhcA0KDQp5ZWFo
LCBpdCBzZWVtcyB0byBiZSB0aGUgY2lmcyBrZXJuZWwgY2xpZW50Lg0KDQpAU3RldmU6IGlz
IHRoYXQgcmVhbGx5IHdoYXQgeW91IHdhbnQgdG8gZG8gaW4gdGhpcyBjYXNlPyBKdXN0IGRl
bGV0ZSB0aGUgDQpyZW5hbWUgZGVzdGluYXRpb24/IFRoZSBhcHBsaWNhdGlvbiBkaWRuJ3Qg
cmVxdWVzdCB0aGlzLi4uDQoNCi1zbG93DQoNCi0tIA0KU2VyTmV0IFNhbWJhIFRlYW0gTGVh
ZCBodHRwczovL3Nlcm5ldC5kZS8NClNhbWJhIFRlYW0gTWVtYmVyICAgICAgaHR0cHM6Ly9z
YW1iYS5vcmcvDQpTYW1iYSBTdXBwb3J0IGFuZCBEZXYgIGh0dHBzOi8vc2FtYmEucGx1cy9z
ZXJ2aWNlcy8NClNBTUJBKyBwYWNrYWdlcyAgICAgICAgaHR0cHM6Ly9zYW1iYS5wbHVzL3By
b2R1Y3RzL3NhbWJhDQo=

--------------je3q8h4O51knhjbJ0yswHr3O--

--------------si3Des9PSJ0ZD3G305VQV4uQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiM6tEFAwAAAAAACgkQqh6bcSY5nkbi
+hAAr0onrYg7Qohf9NpVLlmcH3Wa7vM05ojw3CDXpY8NSHTVjW0Brr4crcH2Thq00WOnpvB+R9w4
F8HobIP5rgEwVbU5HXdSKS7a9JRztZFQkp6/CJBbUvW+L9GaXtTjwELtY+/6Q2gq5j6+w60/rwba
++BB8dYYEbASYMaamSpvpyBlL5NK1cgQyRGUlxd6l5id3jHdi3h/tBGVlYL4Swyo4TT/oVGxHeZA
02B+7LpeJG8caRrWvkuTKVmrfhGlVZ0GZxuwuz2gpJOwC6v1fxk2+5pPFIiv5xFQC+wMCUPOClCp
rzj2WxCgtEKrDDC3wMxbdWttl6NNjGXcc98h4IvLLtVaLzUACxVoQlNTTGMwVPO6q6xxiIUIq8tC
DrLGR/IOZ+VNOXhhyH8XphxRHw/QuqnI3iKv6mtg1WzqHSSwP8dztFuajJPIXcn2FcmYicb7DVqq
QqOJrhQH7DBqc5ovyVnq66oVQBh2bkNt6h1BHMc+0y3Nf7WsdO1a/txsFWOSAeqWiUUinp/KsCZF
HR0lA8pthF85Ue6qWn01XK00vtrOGFsrD8WFm++aGL3j3Uc9B+XUGJIU+ImmrxcS6MDhBnfS+K/v
kA4/NCfVnMRbn2cr6QytQRs1WcgkHRBorAjmkeTsnzHzaZuuVE0Agz948oCE1auVX8Nq4PkyPYJj
Iw0=
=yoQm
-----END PGP SIGNATURE-----

--------------si3Des9PSJ0ZD3G305VQV4uQ--
