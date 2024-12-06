Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85051FF7A1
	for <linux-cifs@vger.kernel.org>; Fri,  6 Dec 2024 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733487103; cv=none; b=dXNG/Zf9sVygECcjrWPSZhNtgm/R0UdJyPjl701h9kxFJ6OXp7Ol9OAWJ2fQFGQ63QfNpCIGjMnS27/5fyisZXOyO+AYSwiOjh66E+7z600nyV+TBmjglyJLUjo5mlCZv9V2VOe/mSNII0uoGKjJzFMsXNATI02qA7eZrTJDNmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733487103; c=relaxed/simple;
	bh=vTIhy9ytAbR7VdCPCVo28qG5enMeEUGPunU7fS6mZCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J8a6q2EPJWJ2ZBLHkRsibtJt8hDFFlANMiIB4fNsR2GIbtN/XIyRhQPjjH00RzBoKIpWIHV1UL3Ohe3JeKgZhZW0rRqlLe93I1cheJ8687jM2KtxUushTcwJWuNkqkaa3VBGBfg3j26v3cObUpuaXu3WQoPjFamCN66qB76Pqf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cicdS1vD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cicdS1vD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=vTIhy9ytAbR7VdCPCVo28qG5enMeEUGPunU7fS6mZCE=; b=cicdS1vD5WthkidFEKrKnC4iHi
	3mTzYn2PLx812lEqUWgQEkXXSrN8pQXoIH2y+Me2WdIVmRAnKuEVv92rOj/oFxRBFxYOaXbWRqbvl
	xJb+LLV2lGz2U38qOPoGht1Qqd0z2y/rB5MneLfY7qzbxzQF7WI1UiWqAst6KNc6ZrX1I74gDRjAs
	FfwYhGh6LBotQ/WHNz+l3lKcug6y1uKCNop7H8C8ReWcNU84CIcbloK4OB8sS2UdJ3XD1BUL2Tch1
	pIa8gv9hiHOYczALOYmMupCfYMsFxoVQTTSGsxV+ylRcA8yk/kqyVXrk7iG9I73/uJ2x9dRs1PTwH
	ziY3+hQkwNXQqNLU1wGTMNq8jDyQ9zlPiOxAzER+gJMldspnNHBGH8Mls3P2fu4XSRoSq8P/CDnLK
	3/7Ifs7EPoHpON6ukfI4SJollLDGI8boHG5Jjd7YI/+pzg9HHH2qdIZTh7vFjt6rdIHy/LL3J1X75
	wh0jK5dQc7h2OWEBlBOImrNg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tJXBE-001BlN-1p;
	Fri, 06 Dec 2024 12:11:32 +0000
Message-ID: <17cb364a-74c9-4403-a1d1-5b5ef1c71e4f@samba.org>
Date: Fri, 6 Dec 2024 13:11:30 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Special files broken against Samba master
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <0a8569561645ad202c5cceba02cda93a@manguebit.com>
 <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
 <CAH2r5muhai7Jp7feS99RSoP5S89PPzhXatv-akRtv+=Gd9+g9g@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5muhai7Jp7feS99RSoP5S89PPzhXatv-akRtv+=Gd9+g9g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Vu9x8oWKFhYUKgcwvDtOi7I4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Vu9x8oWKFhYUKgcwvDtOi7I4
Content-Type: multipart/mixed; boundary="------------puxob4xdNgzQUHztSIn08ojt";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <17cb364a-74c9-4403-a1d1-5b5ef1c71e4f@samba.org>
Subject: Re: Special files broken against Samba master
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <0a8569561645ad202c5cceba02cda93a@manguebit.com>
 <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
 <CAH2r5muhai7Jp7feS99RSoP5S89PPzhXatv-akRtv+=Gd9+g9g@mail.gmail.com>
In-Reply-To: <CAH2r5muhai7Jp7feS99RSoP5S89PPzhXatv-akRtv+=Gd9+g9g@mail.gmail.com>

--------------puxob4xdNgzQUHztSIn08ojt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU3RldmUNCg0KdGhhbmtzIGZvciBkaWdnaW5nIGludG8gdGhpcyENCg0KT24gMTIvNS8y
NCAxOjA2IEFNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IEkgdXBkYXRlZCBwYXRjaCAyDQo+
ICgwMDAyLWZzLXNtYi1jbGllbnQtSW1wbGVtZW50LW5ldy1TTUIzLVBPU0lYLXR5cGUucGF0
Y2gpIHRvIGFkZHJlc3MNCj4gdmFyaW91cyBjaGVja3BhdGNoIHdhcm5pbmdzLA0KDQpvaCwg
c29ycnkgZm9yIHRob3NlISBJJ2xsIHRyeSB0byByZW1lbWJlciB0byBydW4gaXQgbXlzZWxm
IG5leHQgdGltZS4NCg0KPiBhbmQgYWRkZWQgb25lIHNtYWxsIGNoYW5nZXNldCB0byBmaXgN
Cj4gbW91bnRzIHRvIG9sZGVyIHNlcnZlcnMgd2hpY2ggZG9uJ3QgZmlsbCBpbiB0aGUgZmls
ZSB0eXBlIGluIHRoZSBsZXZlbA0KPiAxMDAgTW9kZSBmaWVsZCAoMDAwNC1zbWIzLjEuMS1m
aXgtcG9zaXgtbW91bnRzLXRvLW9sZGVyLXNlcnZlcnMucGF0Y2gpLA0KPiBhbmQgdXBkYXRl
ZCB0aGVtIGluIGNpZnMtMi42LmdpdCBmb3ItbmV4dC4gIExldCBtZSBrbm93IGlmIGFueQ0K
PiBvYmplY3Rpb25zLg0KDQpobSwgbm90IHN1cmUgSSBsaWtlIGFkZGluZyBjb2RlIHRvIHN1
cHBvcnQgbm9uIGNvbXBsaWFudCBTTUIzIFBPU0lYIA0Kc2VydmVyIGltcGxlbWVudGF0aW9u
cyBhdCB0aGlzIGVhcmx5IHN0YWdlIG9mIGltcGxlbWVudGluZyB0aGVtIGFjcm9zcyANCnZh
cmlvdXMgcHJvamVjdHMsIGNsaWVudHMgYW5kIHNlcnZlcnMuIENhbid0IE5hbWphZSBqdXN0
IGZpeCBpdCBpbiBrc21iZD8NCg0KPiBJdCBsb29rcyBsaWtlIGl0IGRvZXMgbWFrZSBhIGJp
ZyBpbXByb3ZlbWVudCBpbiByZXBvcnRpbmcNCj4gc3BlY2lhbCBmaWxlcyB3aGVuIG1vdW50
ZWQgdG8gU2FtYmEsIGJ1dCB3YW50IHRvIGZpZ3VyZSBvdXQgd2h5IHRoZQ0KPiBkZW50cnkg
Y2FjaGUgKHJldmFsaWRhdGUgY2FsbCkgc3RpbGwgcmVxdWlyZXMgdGhlIGV4dHJhIHJvdW5k
dHJpcCBwZXINCj4gZmlsZSB3aGVuIGRvaW5nICJscyAtbCIgKHRoZXJlIG1heSBiZSBhIHdh
eSB0aGF0IHRoaXMgZW5oYW5jZWQgcXVlcnkNCj4gZGlyIG91dHB1dCBjb3VsZCBiZSByZWNv
Z25pemVkIGFzIHN0aWxsIHZhbGlkLCBhbmQgcmVkdWNlIG5lZWQgZm9yDQo+IGV4dHJhIHF1
ZXJpZXMpLg0KDQppdCBzaG91bGQgb25seSBkbyBhbiBleHRyYSByb3VuZHRyaXAgd2hlbiBu
ZWVkZWQgZm9yIHN5bWxpbmtzLCBjaGFyYWN0ZXIgDQphbmQgYmxvY2sgZGV2aWNlcyBhcyBm
b3IgdGhvc2Ugd2Ugd2VlIG5lZWQgYWRkaXRpb25hbCBpbmZvLiBCdXQgZm9yIA0KZmlmb3Mg
YW5kIHNvY2tldHMgdGhlIFNNQjItRklORCBQT1NJWC1pbmZvbGV2ZWwgaXMgc3VmZmljaWVu
dCBhbmQgaW4gbXkgDQp0ZXN0aW5nIEkgZGlkbid0IHNlZSBleHRyYSByb3VuZHRyaXBzIGZv
ciB0aG9zZS4NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------puxob4xdNgzQUHztSIn08ojt--

--------------Vu9x8oWKFhYUKgcwvDtOi7I4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmdS6fMFAwAAAAAACgkQqh6bcSY5nkY6
wQ//VpxBkw48+vPHEIMWd+lErYDsMQpe7JqXJbo4Ajd4wl5rA3ozvQd3o5JBC0ecX1hAwt2A6M8r
+O23RC74FM10vpEimS4EQUSchOAu3DJfTIV77SQb4aA7Coof+LwAAgR5i2ivLvrDwPxn+W5g7b5i
l6/TiCDW5240CkiALE3p4rdFMb4+YZcbYwS/2F/csntFwktYwxnHYKWrpDeVG1kFzmKQXMFAWKbc
qef107kCuab9LF+ZtkDDmdxolK7ewHo/PrQ0giACeJtLYh0hKSYJ9Mw6rpfY1Pd2dh1BKbaCHiyp
fZtUhjXH+yWEMyBqqujjLqon3MzYzEqtPSy4cDDyw5+CykCIr9beBMqKXRKB70DKIWnIHjoJftVT
hdgYLfbnfHOEFChXkbexUMn+XQGZNG/g7A3KrkvSiXfOBHNI1s8ixeFijYSbDlbRagqlUvGwcmLH
Lvx/p3ZoYqjL8lplF7liyqKCD2dm/zzy961Poc3IX1xhM2amWuvzBUFFWqU3+v9tc2YXupu7NsxB
bn24q0niBJk9+iCQpKMBuKKjnnkRSFnVkn1LfgCVfHpBkcWsj+r3dUfqVvZEL1p+BlK//1TIa3mU
OffJ/L9S0oUlhlkYcG3OGLUkK3ReiQkopTSmeseA3K0r/Q5PGD6fVx1jCvtFTz3LvWqmUuzUwZZU
3xo=
=K3bF
-----END PGP SIGNATURE-----

--------------Vu9x8oWKFhYUKgcwvDtOi7I4--
