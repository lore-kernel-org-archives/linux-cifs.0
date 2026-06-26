Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDDF3161A1
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782497111; cv=none; b=g5eUfzGutu07sg2pBuNt7QfjP6RChUz4b6kwrc3taU5Rs39LndLdBe9jDtvio8sT2SkSBcs2XqZn9I/gf2NSfkNQNAga+Fo23DjX0UMEWsHcEqNbUZGP4/WLFuqIorByjsVLa629oPuJ5kzce6B99UlWs1IcSNQOiTFxBufed+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782497111; c=relaxed/simple;
	bh=3T+CkeQLcvHQ9UO+s/q1z2RiZ8mgcxHOJUy2RfAFZ8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lDrRKkcqKqWJOvkwh1hMUNP1UiadHXyKKeAWPWRk5lSJWOjhjYF2ew+rJ8amC1JJI+wBI8+oFa8pNgbQfnWAztXMavkSUA3Disk8BU7OsuHhEw+2629vXJ94ByYw2Twh5GfDEWq4/YL1QZNQD65dj2e8xbDyQbBsVIeCWFbQuHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NzRMkzba; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NzRMkzba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=3T+CkeQLcvHQ9UO+s/q1z2RiZ8mgcxHOJUy2RfAFZ8w=; b=NzRMkzbaEJ7CnkdZfn2mAHjoFP
	jVxi77TCrgXuGytaV01mpJr5zoHbdepF1tkjftnzPvGruvwZPHOPFgzVOB1RV+ILS8PSBYAWNdO+g
	GynEMRShUteHxlvHmRp9QoKxLYkE/n601kNq7ui2j2TKxbQs9OqbfOLOy6yYOfX0fTWM36CCtW+ES
	RfVNYRIZ4RFv2ZSp7XpLfCJDir4yz17ORbHFlGCqz6Ejss3lvUOQhAo1mbpGrHNB5rasQM1oNcL9K
	Z2RScLlT6KBHxIyxeL82KInhTz0aLyvcDcJYQXe0V5cTS5iSL56AF5bZElljtr7AF9c+bsD0DGHnI
	qClIDYOLauYWZ+XOMutp4vw1DQngZbz1t7ucXTi2Svb4M2RHZx7S16pekaEYYbbdusdP6K8tC/Q2q
	c4jTv6j4sjLA6CjpA2W0eOo34NiFYNx1Mkaj5MkYck6dzY3b8vBNcuya+hKDqwSqNEcrtQCINm70B
	FA3D8rDQPIgW5xDxD9JdzTCu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wdAVI-000000001Tt-0P7j;
	Fri, 26 Jun 2026 17:38:12 +0000
Message-ID: <db73693a-d134-4a97-b4ba-5451c951c92c@samba.org>
Date: Fri, 26 Jun 2026 19:38:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Max-Ulrich Farber <m.u.farber@freenet.de>, linux-cifs@vger.kernel.org
Cc: sfrench@samba.org
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <DJJ5DFOAO268.3SBYMHO182EDE@suse.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <DJJ5DFOAO268.3SBYMHO182EDE@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YgROlG0W1dC5RB3BVQoE05eu"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YgROlG0W1dC5RB3BVQoE05eu
Content-Type: multipart/mixed; boundary="------------X4cR1BkYD1XR36FdH0MBVRZ6";
 protected-headers="v1"
Message-ID: <db73693a-d134-4a97-b4ba-5451c951c92c@samba.org>
Date: Fri, 26 Jun 2026 19:38:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Max-Ulrich Farber <m.u.farber@freenet.de>, linux-cifs@vger.kernel.org
Cc: sfrench@samba.org
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <DJJ5DFOAO268.3SBYMHO182EDE@suse.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <DJJ5DFOAO268.3SBYMHO182EDE@suse.com>

--------------X4cR1BkYD1XR36FdH0MBVRZ6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8yNi8yNiA3OjEyIFBNLCBIZW5yaXF1ZSBDYXJ2YWxobyB3cm90ZToNCj4gVGhlIHdl
YnNpdGUgaHR0cHM6Ly93d3cuc21iM3Bvc2l4Lm9yZyBsaXN0cyBMaW51eCA2LjEzIG9yIGxh
dGVyIGFzIGENCj4gcmVxdWlyZW1lbnQuDQoNCndlbGwsIHllcywgSSd2ZSBsaXN0ZWQgNi4x
MyB0aGVyZSBhcyBpaXJjIHRoYXQgd2FzIHRoZSB2ZXJzaW9uIHNvbWUgDQppbXBvcnRhbnQg
Zml4ZXMgd2VudCBpbi4gWW1tdi4gOikNCg0K

--------------X4cR1BkYD1XR36FdH0MBVRZ6--

--------------YgROlG0W1dC5RB3BVQoE05eu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmo+uQMFAwAAAAAACgkQqh6bcSY5nkYS
hw//QD47oNn2eUHksZoeODkN0YaZvM8Shq1qZYW3ZywP8IGkbpNOU0qrjur/TcraT4Obqq5PhAc/
pIsPv8Etq9GnhAKXj+PLbvxayEaSlJ6mTUDtJ9/0hfsgO8FS7ypgANezVI1uX6oFZh5Jf6oPsHv+
dVCiMRlgzMDzMVBkgDZZliRQ6Y7uArqifZD0MOK4C7ODMrCUIvNNvOiD2NeEKicKK8YVGHSndDAs
licWkHe/pm1/zsqGZDYA0Lt+C2tFNT/MOW67h7j/ZBv0p3c3EvoBzYlc6hn2nwa3MSDgV/Zex46m
Y2uF5Ry1Bb9rb3ycQS1U3Qai8w/VG/H0gJgsuXXrYxXDKeuR1OEGABQn46888vK2x2k3FYc2GQro
zQfo/7PJxWvgc99ChlhMrwvGWWAqFzoMTbfAhByaA5IMXZAdHwEy1oiNyA/nWOwa3a+abuNB6P1B
zPJOL5EhYz8OqMc2ZlltegGfBM6vO65LYMRC6bzLyY8gSoGI+gJsXlT2mQEfDMSXDux0sxSKRR4o
Ugp1E7jG3Ky6SG0+5tFVYuKw/1eKJ+cGzht3uTiOW8iinC/vb6+JC6+5LWUNRIdlQr82l6mbfm6l
vC3rd5dtQ4GFMa7qp3HBmklFn1Sp/GqG2eFCVS0XVSaAJpBSfAUw3PgDRbA9u2trVthtG5LPjszY
Q8s=
=uxdz
-----END PGP SIGNATURE-----

--------------YgROlG0W1dC5RB3BVQoE05eu--
