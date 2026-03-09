Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7E2F4A16
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773077753; cv=none; b=qyanqPQcJKDUCGTP40jPiy9bI1yaG1LjXnjlt46S+sn3ojFi+6C4oWPvUAxpChB4hx54h+PiZedJ9xurBg2IHDifQ8he9eEq/B/Z1f5ndsalwSTK7TNBsfjqdlB4IzypIjTQkal83SAiLLlMpjURZkRMrg+Aze9FoKAxjCf4dOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773077753; c=relaxed/simple;
	bh=6978ve18JIiLcoNp2i2UaBIyW82v9g7vlV/iVyF6pnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D8yAdVa3SGPpvX3ZaUHlrMcR4h8fTjgNMigTcddRjEYWBrsdzO6HTa3/rxJftXOUd+5/I03AbbDr9Lad7wtlkqOucU/AwzEAbWHe1jzi0tfADmxal6gHK1Izf+qzG8FkOZennFHrjkP+QxAsobK/IhbA+Xgclqp3oPuL53YfNcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=P3pt9KNm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="P3pt9KNm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=6978ve18JIiLcoNp2i2UaBIyW82v9g7vlV/iVyF6pnQ=; b=P3pt9KNmRy3aKdnjZJeC/wFe/e
	8N9mTCGq014KQv8xL2+nqrchv6Q4IboSXh6FRlhyLc0tTtm4EC4H38jfVemeJXgZn+dOz+QYdeen1
	Vwu3ZjkTloGnX2dgGRhNOh5gE5354h0VtpzFE8WP6x1ISfbu4ffT7A7NUsfLqSUreT8JvUx2ohXk0
	jvqUxAuPJEyJIB9Xo/wfnXv1EuH4hBiATOVbXbGn9VGRcRZOxP3I5OkIQug7z9ohoWCWowiH1yEsW
	5UaQJAPPvL9Q4Lp7qkc9Y6slEF7dPJpm7g6uEq437VGzjhZdE01JshWtiZBlafT/f2ovH3dIyxZy8
	mp3zkV1oEKUNkn1OhLnG5TouusvuN9IyvgC2+l+vrE8RYtNoEu+7ZolmC4qhFayeYn5GfqxP75atV
	bbp/p1bk3kDOkjqKLqSQxOfFNIB2ZELJsIhfKOpJiwSR0DPFOKdDdtd57uAkd5uyMGuTAnN1vgLI/
	XLnZb7G2yEDtgeyyezotill9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vzeWD-0000000B6ea-1tpn;
	Mon, 09 Mar 2026 17:35:49 +0000
Message-ID: <031b8f1e-bd28-42e3-bcde-9bf73fe59b63@samba.org>
Date: Mon, 9 Mar 2026 18:35:48 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
 bharathsm@microsoft.com, dhowells@redhat.com,
 Shyam Prasad N <sprasad@microsoft.com>
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <aea738fc-e422-4671-9e0a-429988fe026a@samba.org>
 <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hn9IRhxjMESvfouzbtVUI0pI"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hn9IRhxjMESvfouzbtVUI0pI
Content-Type: multipart/mixed; boundary="------------klw9S0YcyIu1CvMp3iPwcaT0";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
 bharathsm@microsoft.com, dhowells@redhat.com,
 Shyam Prasad N <sprasad@microsoft.com>
Message-ID: <031b8f1e-bd28-42e3-bcde-9bf73fe59b63@samba.org>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <aea738fc-e422-4671-9e0a-429988fe026a@samba.org>
 <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
In-Reply-To: <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>

--------------klw9S0YcyIu1CvMp3iPwcaT0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU2h5YW0sDQoNCk9uIDMvOS8yNiA1OjM3IFBNLCBTaHlhbSBQcmFzYWQgTiB3cm90ZToN
Cj4gVGhpcyBjYW4gYmUgdXNlZnVsIGZvciBzZXJ2ZXJzIGxpa2UgQXp1cmUgU01CIHNlcnZl
cnMsIHdoZXJlIGl0IGlzIG5vdA0KPiBlYXN5IHRvIGV4cGxhaW4gY2xpZW50IHNpZGUgYmVo
YXZpb3VyIHdpdGhvdXQga25vd2luZyB3aGF0IGV4YWN0DQo+IHZlcnNpb24gb2YgdGhlIGNv
ZGUgaXMgcnVubmluZyBvbiB0aGUgY2xpZW50Lg0Kc28gaXQgaXMgcGxhbm5lZCB0aGF0IE1T
IGlzIGdvaW5nIHRvIGltcGxlbWVudCB0aGlzIGluIHRoZWlyIHNlcnZlcnM/DQoNCkkgd2Fz
IGtpbmQgb2YgYXNzdW1pbmcgdGhpcyB3aGljaCBtYWRlIG1lIHdvbmRlciB3aHkgaXMgdGhp
cyBtYWRlIGFuIA0KY29tbXVuaXR5IGV4dGVuc2lvbiBpbnN0ZWFkIG9mIGEgcHJvdG9jb2wg
ZmVhdHVyZSB3aWxsIGZ1bGwgTVMgYmFja2luZyANCmluY2x1ZGluZyBpbmNsdXNpb24gaW4g
TVMtU01CMi4NCg0KVGhhbmtzIQ0KLXNsb3cNCg0K

--------------klw9S0YcyIu1CvMp3iPwcaT0--

--------------hn9IRhxjMESvfouzbtVUI0pI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmmvBPQFAwAAAAAACgkQqh6bcSY5nka5
KxAApDT0pqtGVbbH6DYKkusibspjaXN/d4IAwGV4LMFL6IoM15JCUiXr0YUa1saxQ/vfUxyMnX1i
vwbR4HrH1MlcgfZWxz2yWXMkTtpoT8txttyjYrkhFWQggdUIkF9moe7/BAJRB7+kRUkNSciIq1iM
rYu3Ouie1/yWQM14CvLkXW8qh+6FEg0PCyzaii/wcfiQmE3DJP5jJwQqBWJAtlQ38vOk/8bW+GUR
l/PKITW5pQirvWM/iCj3YLLvNO4gQTkpkFRS7CzCNp7T7DTvIvT8VnrMPN+AMMpc03azwaHiBvFe
vbfyPRPNrMtzaLxalXh65RbbhTJHy/6UkuTwFwWvWgZZNLHuAbZi+jNWPxWJksCVts/zclpBcjMr
YhrxRTFN6IOMpBvYlOLbTdh14TLr9ZpvGcme+Q+LmvTwKN6Fe6OTfa2i+DceKqxej5ar8/hHckBz
DDS/+qCXcv0bNie6vfiZcHbRkmmsQqoGEa9D/CRVc7KrPmt8Z0AUo2HJ90cDO7ChkkwqPMnz2i/7
RzPbIfh92sH16wCYPRsqbXYG3Ubf92jZp9NlEMv3TyjajA4vOsxcHsJX+fIp7wTnUU93ebiLYjeY
byR64KLpfryQhOSQ337MDwQ4UUacgSV3UDkvrqDFxcqT+uDXebA13Kzcv05ka04OV3GggeqfZnCM
iGI=
=4F5k
-----END PGP SIGNATURE-----

--------------hn9IRhxjMESvfouzbtVUI0pI--
