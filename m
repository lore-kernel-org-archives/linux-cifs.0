Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFE728C86E
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754065414; cv=none; b=Y/74As65To/l+YA/0OTaJnOq8OaqMBoK0Vo6Upj5QAaBQDipSX0YFjC8o2FJMIeNdCVZgjB2STt0D7ssUzUvvYUT8iUTuVE/G5tRzEzv9kIBxZM91lMtDXOUs9NLMqzJawA86k7rohA0FoAoAaHYSWpvu9Uo+pYH6vSP+W9nSuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754065414; c=relaxed/simple;
	bh=McDvnXIENc12c+N3YhZ0ZOUwurucgX2BzeoaPpjpnh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onuMgAsA3xqQdkoi7V6716hIsW2hLiBBIU4KajwT0TsSWD2TdU1yHoxkn/1iWPMG8RQRWocIbrg8gD+PVet5t1Sjn6V9HDoeb1DMufGv0JL/KE44TL8Wf0vROKVNd2Qa35Hg8NVSnpJ3t0EhSiuzjKAWNMaqIO7b1OlMQ+g2H3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=D/jXFHOh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="D/jXFHOh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=McDvnXIENc12c+N3YhZ0ZOUwurucgX2BzeoaPpjpnh0=; b=D/jXFHOhqY7SsdgRrNOxMU3th3
	VPIOhyPP/BUnOxjhSJlWZqwbxGmcwyjuLEbjTq8d2999//t85FnfE2/4TKboSv37ubmIP7+m6Jo9p
	3INQo6b80zAgfoso3girN4KLT77XRAHU+i1oUx9jaSMTBxiUlcq2xTfSczLl2YtKTETydW4VcKGiT
	R7YVIjmxA1pF8X7laIrpgw3zLXVnlJ2mcmgGYFuKN692KXWwIfeV+TIgVtabv714y4+K3B4sZKzuj
	0Gg7eI5GsabzWOsg3QT9ixgf9k9vJPDcFSd2qDuUVd+1VUG96gqwS0qNamIOxWNkj/DCqFWTOI3u+
	3myNFNKbKz3oPhEBQNOW0T5v09D2sn/wLoRl5szv/7qMGYpRr823UFjvCRw5t6whlES2seO7iE+Rt
	gfC+kaw8rBSF+Zy2PYEzz089QRc1dEpr0HUYDyOI2pr8LLTUverQIwkBeKlThOmpSQn+w1knSuwnc
	HDTn1AeYP/CzvFowfSsrKwqX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uhsXU-000Z5b-0V;
	Fri, 01 Aug 2025 16:23:24 +0000
Message-ID: <d93fd05d-aacb-4163-a4be-fe1ee57c3c48@samba.org>
Date: Fri, 1 Aug 2025 18:23:22 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] delayed mtime updates: configurable?
To: hede <debian452@der-he.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, samba@lists.samba.org
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
 <20250801113523.76290fc7@hpusdt5.der-he.de>
 <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
 <20250801155827.36e722ef@hpusdt5.der-he.de>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <20250801155827.36e722ef@hpusdt5.der-he.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kOEuCXZofMYlGAGW8RcafmVR"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kOEuCXZofMYlGAGW8RcafmVR
Content-Type: multipart/mixed; boundary="------------e4gIlgdh7eqGSxRuuqfIcJgW";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: hede <debian452@der-he.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, samba@lists.samba.org
Message-ID: <d93fd05d-aacb-4163-a4be-fe1ee57c3c48@samba.org>
Subject: Re: [Samba] delayed mtime updates: configurable?
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
 <20250801113523.76290fc7@hpusdt5.der-he.de>
 <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
 <20250801155827.36e722ef@hpusdt5.der-he.de>
In-Reply-To: <20250801155827.36e722ef@hpusdt5.der-he.de>

--------------e4gIlgdh7eqGSxRuuqfIcJgW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8xLzI1IDM6NTggUE0sIGhlZGUgd3JvdGU6DQo+IE9uIEZyaSwgMSBBdWcgMjAyNSAx
MjoxODo0MyArMDIwMCBSYWxwaCBCb2VobWUgPHNsb3dAc2FtYmEub3JnPg0KPiB3cm90ZToN
Cj4gDQo+PiBubyBpZGVhIHdoYXQgdGhlIGNsaWVudCBpcyBkb2luZyBoZXJlLCBidXQgZnJv
bSBhIHNlcnZlcg0KPj4gcGVyc3BlY3RpdmUsIHdpdGggY3VycmVudCBTYW1iYSwgdGhlIHdy
aXRlIHdpbGwgKmltbWVkaWF0ZWx5Kg0KPj4gdXBkYXRlIHRoZSBtdGltZSBvbiBkaXNrIGFu
ZCByZXBvcnQgdGhpcyB1cGRhdGVkIHZhbHVlIHdoZW5ldmVyIGl0DQo+PiBpcyBxdWVyaWVk
LiBXaGVuIHRoZSBoYW5kbGUgaXMgY2xvc2VkLCB0aGUgc2VydmVyIGRvZXNuJ3QgdXBkYXRl
DQo+PiB0aGUgbXRpbWUuDQo+IA0KPiBBY2NvcmRpbmcgdG8gYSBuZXQtdHJhY2UgaXQgc2Vl
bXMgdGhlIGNsaWVudCB1cGRhdGVzIG10aW1lIHNldmVyYWwNCj4gdGltZXMgZm9yIGEgc2lu
Z2xlIHdyaXRlIGV2ZW50Lg0KaXQgZG9lcyBpdCBvbmNlLCBiZWZvcmUgdGhlIHdyaXRlLiBV
bmZvcnR1bmF0ZWx5IHRoYXQgbWVhbnMgc3RpY2t5IG10aW1lIA0KaXMgaW4gZWZmZWN0IHdo
aWNoIG1lYW5zIHRoZSB0aW1lIGV4cGxpY2l0bHkgc2V0IGlzICJzdGlja3kiIGFuZCBhbnkg
DQpzdWJzZXF1ZW50IHdyaXRlIG11c3Qgbm90IHVwZGF0ZSB0aGUgbXRpbWUgYnV0IHRoZSBl
eHBsaWNpdGx5IHNldCBtdGltZSANCm11c3QgYmUgcHJlc2VydmVkLiBZZXMsIHRoYXQgaXQg
aXMgYSBsaXR0bGUgcGllY2Ugb2YgaW5zYW5pdHksIGJ1dCB0aGF0IA0KaXMgd2hhdCBXaW5k
b3dzIGRvZXMgYW5kIHNvIFNhbWJhIGJlaGF2ZXMgdGhlIHNhbWUuDQoNClRoZSB3YXkgb3V0
IG9mIHRoaXMgd291bGQgYmUgdXNpbmcgU01CMyBVTklYIEV4dGVuc2lvbnMgKHN0aWxsIGEg
dmVyeSANCm5ldyBmZWF0dXJlLCBzbyB5b3VyIG1tdiB3aXRoIFNhbWJhIGFuZCBrZXJuZWwg
dmVyc2lvbiksIG1ha2luZyBzdXJlIHdlIA0KZG9uJ3QgdXNlIHN0aWNreSBtdGltZSBsb2dp
YyBvbiBQT1NJWCBoYW5kbGVzLiBVbmZvcnR1bmF0ZWx5LCB0aGF0IHdhcyANCm92ZXJsb29r
ZWQgd2hlbiBpbiB0aGUgY3VycmVudCBpbXBsZW1lbnRhaW9uIGluIFNhbWJhLCBJIGhhdmUg
Y3JlYXRlZCBhIA0KV0lQIE1SIGhlcmU6DQoNCmh0dHBzOi8vZ2l0bGFiLmNvbS9zYW1iYS10
ZWFtL3NhbWJhLy0vbWVyZ2VfcmVxdWVzdHMvNDEzMw0KDQpJdCdzIHN0aWxsIGEgcXVlc3Rp
b24gd2h5IHRoZSBjbGllbnQgc2VuZCB0aGUgZXhwbGljaXQgc2V0IG10aW1lLCBtaWdodCAN
CmJlIHRoZSBhcHBsaWNhdGlvbiBvciBzb21lIGxvZ2ljIGluIHRoZSBrZXJuZWwuDQoNCi1z
bG93DQoNCi0tIA0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCBodHRwczovL3Nlcm5ldC5kZS8N
ClNhbWJhIFRlYW0gTWVtYmVyICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTYW1iYSBTdXBw
b3J0IGFuZCBEZXYgIGh0dHBzOi8vc2FtYmEucGx1cy9zZXJ2aWNlcy8NClNBTUJBKyBwYWNr
YWdlcyAgICAgICAgaHR0cHM6Ly9zYW1iYS5wbHVzL3Byb2R1Y3RzL3NhbWJhDQo=

--------------e4gIlgdh7eqGSxRuuqfIcJgW--

--------------kOEuCXZofMYlGAGW8RcafmVR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiM6fsFAwAAAAAACgkQqh6bcSY5nkZ0
sw//bMjbySFaPPSSDMzdHwOvBvaedIXngrWZxPyGNP6itB4+03JOvY4Xmkq4qcEYlF97g7EtJha1
YSZjMuazUxDnEUQv0OUprpItngWYxXVynuwvYMIy++a/yUaCDPkT45hnRHAPvPu16laeLd/7pnPj
5Wtwq9h1qnq3fhOp166K1CuSkYTeVka0vmCDvaY6l19PLlqXXif/tj6ISKPEUetYt7OaDdgRlnZ6
n/7+J+DQsqQ0KM6nK8EQf2VHbfdLsaKQ1YxTTG4twZwpgd+5wQlYrJWHAJVS9m/tjUlaiXy2BY/c
rgXGQfG3Pz4TuLQMIP51kQa3e4AWMavy6kPtI5xVpijgaBR19xhsFM4suDK7HZIZaPYosqNK/98s
3iACHtI48ZP1d4Dh/qGaitjA8TguWLgwVbC3s5Icwa94nZVRXSNutLhBgfHV2PF4dofAeW4Ptx55
wFB+VhYtpA9wgB68g6CeAWpxWPeyeur8zVMRnimPg0bWLPPaCM7PbgHfEnS49YoBo1MPCLXs+Rxd
qEmw1SzUSfuQKAAAGPpSo86owkdpznUrFa2Ea+10vpYg3uyRwOobiVAmXp3jonrzwKjIK7UIvU7y
JSWR5oJHfyziGumrOsHODqNKNGBQrm0fZ04KX+AXgFBNdm1tKNpT0B2//i4WkzrJ9EnCnWgCIj/x
BhU=
=RTqH
-----END PGP SIGNATURE-----

--------------kOEuCXZofMYlGAGW8RcafmVR--
