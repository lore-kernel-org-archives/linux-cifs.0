Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574534689
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753979170; cv=none; b=YsjsfsSmNBdjyPMMGudF0BpK/F0Krk7azUPPQah2I7wO37iK1Ljv3lBhyGtMc2rlJ9s15vwiM/BQchKnFFZrepJSceyFQdhzp2F/XuOZQZBKB9DRf7dCDUdIdqXT0lvdgRynXkKErLD+KPb7FTBc0wABzI9yaiey2eXDWHQka9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753979170; c=relaxed/simple;
	bh=neKR1dx4gT/lZI7f6wQ8wi6Ij/7yMv1mux8VSuqv65M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Cmc7aQZCoBxWwwrrmJAA+MIeXVkvA8rHbGvjhTrWDLdVZTk8kRPTdqGapZsgWrS1FUwq17CRu1ksjKmJXaEq7LZAEBPLs9tbVuqzWcE3xMbxEUmzGbTuEORsowytpePxMzliertSJ1ChV3Jm4SALtccbNPa7+/t9PXhpMeISDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YG8LVwZR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YG8LVwZR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=neKR1dx4gT/lZI7f6wQ8wi6Ij/7yMv1mux8VSuqv65M=; b=YG8LVwZRAmzcn6wdGiqalGYWWw
	lRL1r+CfER8k/bSvWxVYXTPMS5SrbmhLh4RYqu2zvHyK0eOHQQjNOfVBQTyCuBqBju+OqRjbCY5ka
	zca0KZWezXb+G9ndKhVeLBlcnez5QBy+t/XvnqmwbtD8GrnjSDaxNtfEdlcx0dOwJYHMtBIGcjsEO
	iFjrAky+BlAYksl7DV3+MIWNpa7r0PFXwDOzDc67GrQlhF7b+EXyE6lq7zZLfvyEaG8adknUWNpva
	WiIt2STw5wdu2ux1a6Ym0yfNtM4A59KGxC7mBW3CyFWpzN3SHy7Oad1n2tABeiUYxsmC9OzK11C4K
	nHC1yIWTjop8FcXsSxm1ME2QMjkCokOysrTw3p0gZPo2DKWcrjGqYABAVvTan5/gCUhPf26UQDn2y
	IECi/fzGIQ5cC+gu/NkexGX9y22FBvwmHwHTw7TyiKaQ3K72jyF6Q4tQmaAVecaS8F6QaSeRjvxPc
	IcGmqER6K8aoDj6tZ5UOe8uO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uhVtO-000NxP-0j;
	Thu, 31 Jul 2025 16:12:30 +0000
Message-ID: <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
Date: Thu, 31 Jul 2025 18:12:28 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: Matthew Richardson <m.richardson@ed.ac.uk>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
Content-Language: en-US, de-DE
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>,
 Steve French <smfrench@gmail.com>
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------NB6m2zrGgPJLyO808NlPQgg8"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------NB6m2zrGgPJLyO808NlPQgg8
Content-Type: multipart/mixed; boundary="------------GejD4nVtYMDHpAeDA120Z0Ys";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Matthew Richardson <m.richardson@ed.ac.uk>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
In-Reply-To: <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>

--------------GejD4nVtYMDHpAeDA120Z0Ys
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Li4uYWRkaW5nIGxpbnV4LWNpZnMgYW5kIFN0ZXZlIHRvIHRoZSBsb29wLi4uLg0KDQpMb29r
cyB0byBiZSBhIGNsaWVudCBpc3N1ZTogdGhlIGNsaWVudCBpcyBjaGVja2luZyBmb3IgZXhp
c3RlbmNlIG9mIHRoZSANCnRhcmdldHMsIHRoZSBzZXJ2ZXIgcmV0dXJucyBFTk9FTlQgYW5k
IHRoZW4gdGhhdCdzIGl0LiBUaGVyZSBubyBhdHRlbXB0IA0KdG8gY3JlYXRlIGVpdGhlciBh
IHN5bWxpbmsgbm9yIHRoZSBmaWZvIGFzIHJlcGFyc2UgcG9pbnRzLg0KDQpAU3RldmU6IGFu
eSBpZGVhIG9mIHdoYXQgY291bGQgYmUgZ29pbmcgd3Jvbmc/IElpcmMgdGhpcyBpcyBzdXBw
b3NlZCB0byANCmJlIHdvcmtpbmcgaW4gdGhlIGNsaWVudC4NCg0KLXNsb3cNCg0KT24gNy8z
MC8yNSAyOjMxIFBNLCBNYXR0aGV3IFJpY2hhcmRzb24gd3JvdGU6DQo+IEhpLA0KPiANCj4g
SSd2ZSBjcmVhdGVkIGEgZmV3IG5ldHdvcmsgdHJhY2VzIHdoaWNoIHdpbGwgaG9wZWZ1bGx5
IGhlbHAuIEVhY2ggb25lIA0KPiBjb250YWlucyB0aGUgaW5pdGlhbCBtb3VudCBjb21tYW5k
LCBmb2xsb3dlZCBieSBhIHNpbmdsZSBjb21tYW5kLiANCj4gVGhleSdyZSBob3N0ZWQgaGVy
ZToNCj4gDQo+IGh0dHBzOi8vZmlsZWJpbi5uZXQvenZkeDA3aTJtM2x0YTEyOQ0KPiANCj4g
V29ya2luZzoNCj4gDQo+IHNhbWJhX3N0YXRfc3ltbGluay5wY2FwID0gc3RhdCAvbW50L3N5
bV9hX2xvY2FsDQo+IA0KPiBOb3Qgd29ya2luZzoNCj4gDQo+IHNhbWJhX2xuX3MucGNhcCA9
IGxuIC1zIC9tbnQvYS50eHQgL21udC9hLnN5bWxpbmsNCj4gDQo+IHNhbWJhX21rZmlmby5w
Y2FwID0gbWtmaWZvIC9tbnQvZmlmb19uZXcNCj4gDQo+IEhvcGVmdWxseSB0aGF0IHdpbGwg
Z2l2ZSBzb21lIGlkZWEgYWJvdXQgd2hhdCdzIGhhcHBlbmluZ8KgIGJ1dCBsZXQgbWUgDQo+
IGtub3cgaWYgeW91IG5lZWQgYW55IG90aGVyIHRyYWNlcyBvciBkZWJ1ZyBpbmZvLg0KPiAN
Cj4gVGhhbmtzLA0KPiANCj4gTWF0dGhldw0KPiANCj4gDQo+IE9uIDI5LzA3LzIwMjUgMTg6
MjIsIFJhbHBoIEJvZWhtZSB3cm90ZToNCj4+IEhpIE1hdHRoZXcsDQo+Pg0KPj4gYXMgYSBz
dGFydGluZyBwb2ludDogY2FuIHlvdSBzZW5kIHVzIGEgbmV0d29yayB0cmFjZSBvZiB0aGlz
Pw0KPj4NCj4+IElpcmMgdGhlIG1haWxpbmcgbGlzdCBzZXJ2ZXIgaXMgbm90IHBhcnRpY3Vs
YXJpbHkgZm9uZCBvZiANCj4+IGF0dGFjaGVtZW50cywgc28gZWl0aGVyIHB1dCBpdCBzb21l
d2hlcmUgdG8gZ3JhYiBpdCBvciBmaWxlIGEgU2FtYmEgDQo+PiBidWcgYW5kIGF0dGFjaCBp
dCB0aGVyZS4NCj4+DQo+PiBDaGVlcnMhDQo+PiAtc2xvdw0KPj4NCj4gDQoNCg==

--------------GejD4nVtYMDHpAeDA120Z0Ys--

--------------NB6m2zrGgPJLyO808NlPQgg8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiLlewFAwAAAAAACgkQqh6bcSY5nkZg
Hw/7BMMLlkKtLAQM0Y3aJo0ie1rWZvxrFLFsjXT4Rfylk+7YMRZba090QGtirSIag8V+VyQ30+Ab
HRIQNTZE2yvAeS9Wec2e77ItQwI/IPXDU6CIII71OMoBlG4253QXnb20yb47pimLovMi5fgUm001
dyNlcLfH8mGLD+XoEqBULkFh6fqWoX0mWPTQ13eDGJK67qKTYywp7mbuSEmLnRvm19wITGY3oIp7
1D6+B+6RQNZzXLZOwrbTtzTyRMFJ6f2z3dOFio6ccFe+qOZWWas6/ii83jrvHLt1QmcUO0Dd3kk/
QsPovfICTor3QI+OawnnudsArucEEWEYNetOpeHrp76Nbijb3D0/PG62dg3jQGk0azcQkvAEpyP1
HFd7SR0/3gNLncTzvGiJaNhQGbyqWsWTpO+8qPtD5SWIh2aNkqnkzkIdd8IFSey+xMq2PAuxyP13
ouw/QguM9gwGXL9J6Ds7lH9p24BuZawF2887SIoHjk7c3+cgJCsdWf0NTzo3uURuyk3rl6OWRhxp
WFRJyjdAnbE22TLDtxMeitWQK3VxxLGYDGl07KpKLkbSWMie9JojZq4S42p3y+UU2XHMQ15bocGz
Ogh6eM/Qkgqi3FER51zRsRy+2jk9/h+WfV6NPs+xtsNH766MKdfBN8jQ3rBE7sL1RQO8Y9nn7JeX
M/4=
=REyA
-----END PGP SIGNATURE-----

--------------NB6m2zrGgPJLyO808NlPQgg8--
