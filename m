Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BAC78C60
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724257517; cv=none; b=CrfMsCeiGlttj0YeRE8CKgqE7TDayNbLPLfYtCagry1bFrX4IxIyQwHoBKQu5FmBv7P/BT4JS0hYe85AkKrscfsfGxikGieHDV6Qduttu2F43zL8Pk/HV7pRMEr1k+Llyw1fdLYxhE71zhaROgd9tacXkKwTbbUcXtW/0rXlCc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724257517; c=relaxed/simple;
	bh=qVwRaNUS929dJN12CJsugsT1bxV7ktNGouRjht4AW7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nsLWTXPWG6nZkhaysRmqFzESkgztpsdH2QwpnEueez9DS/l3kEwt8lg0rsT+tcPfMqGMhxw0ArpPKQNeIbCaWo0b9ptai9I42cJKDrtKlmja/zVZuikpPwk1lkur1wLgJJzJ6O5Pl4c33Db7nr+BPXyuw6Mgi8/CNQrS+hLitxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kTYYHtpV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kTYYHtpV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=qVwRaNUS929dJN12CJsugsT1bxV7ktNGouRjht4AW7w=; b=kTYYHtpV/elApte76iKn+BkbXz
	GYMtiZ6vor93hPbS4v0b+JetDPfS/+dGTsVwlTDuhK9REVj/kFX96WbQGOg3MRpI12B+j4O7i4pCI
	gzOvjp98wx5MkYfFBItXCUyDpfXmCd9w7t9n7m+sWwKrQThM7vjrWkClB8sEnj2d7mLUgekteXTVA
	0ChwooNbcAOGoOdfQc9fx94Az1MxA4FzJWAjfDgwWKpx6v/he+EdwhUm8Fo4DIBvh/rJnXm248bYf
	mdKPKED8Wnc+bHyQNagmBjSWF4yCOJvbm21aG3V++tEFH9emqSI4EaBZb4dzvtEcA+iQeeXOgwkk7
	zl2iRVP2q8DDmF6B37QNGNPg0332GwUImqp4wLOmLZ7HZC/Po69oJ2G85iP3x//pRR8qnihv1S3NB
	aIY4cxSPZNd7gIIy1Qp2CBpnskxEU493KYrxR+2NuHdv1+g+Cp905lDd6ACUEVdBj5g5FdqOSefej
	F6GDcDavKEbuk3Ajk13kwVtc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sgnvz-007V4y-1h;
	Wed, 21 Aug 2024 16:11:43 +0000
Message-ID: <f1bc4bde-f1ff-4b52-9cf4-822f94b31a75@samba.org>
Date: Wed, 21 Aug 2024 18:11:42 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Samba server multichannel session setup regression?
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS
 <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>
References: <CAH2r5mtUTOFgaQMbsWwkAD-XDRiVwyAGT=Q7n9i5Sd6Wf=9q+Q@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mtUTOFgaQMbsWwkAD-XDRiVwyAGT=Q7n9i5Sd6Wf=9q+Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Df5GuAkqejEExWAZtpG1RR6N"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Df5GuAkqejEExWAZtpG1RR6N
Content-Type: multipart/mixed; boundary="------------EF4z5S2hfCFiyF8MmTKKKTp5";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS
 <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>
Message-ID: <f1bc4bde-f1ff-4b52-9cf4-822f94b31a75@samba.org>
Subject: Re: Samba server multichannel session setup regression?
References: <CAH2r5mtUTOFgaQMbsWwkAD-XDRiVwyAGT=Q7n9i5Sd6Wf=9q+Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtUTOFgaQMbsWwkAD-XDRiVwyAGT=Q7n9i5Sd6Wf=9q+Q@mail.gmail.com>

--------------EF4z5S2hfCFiyF8MmTKKKTp5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU3RldmUsDQoNCk9uIDgvMjEvMjQgNTo1NyBQTSwgU3RldmUgRnJlbmNoIHdyb3RlOg0K
PiB0cnlpbmcgdG8gc2V0dXAgYWRkaXRpb25hbCBjaGFubmVscy4gIEFueSBpZGVhcyB3aGF0
IGNoYW5nZWQ/DQpjYW4geW91IHNob3cgdXMgYSBuZXR3b3JrIHRyYWNlIHBsZWFzZT8NCg0K
VGhhbmtzIQ0KLXNsb3cNCg==

--------------EF4z5S2hfCFiyF8MmTKKKTp5--

--------------Df5GuAkqejEExWAZtpG1RR6N
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmbGEb4FAwAAAAAACgkQqh6bcSY5nkaL
BRAAxDBnNnBv46NfK0LFZDP9G7UNyk/dBy+odDrEx4/PnfuSi7ylUYYkdcNC2Cc6adk8bCvIQM7o
Xes7aGJ2yRFLoWqman8gkGOzmXZVGQpP3Jh8oZretmzoWmVE0HS88WTUAxjQndaFsCpSRaUHaR9e
Gfi6CUf1SJxoKef7x/hClByYB0+4s4Y+qmdyU/x6XkYqD03+WsnIc3VFrV2zTjGy1/d4ssC5YP62
01TKGirKvOs2vciouiw2rQgvRARqNrFx5fS9F8AdhsUf/TZSWhqMLJo4BnQSE8q723V7EAd76bxr
V16RvxMSEQWOw+PXdd3sSytnGX8yyk/YH1yHuuISHr4rzRR8TR9S3AUA/hhFmN7Fo9pQ50W7rI5S
J9Eb8ojCoA6SK4+LRg/bvMDCnQIlmPUa5Z55D6LyUb+YnEWsVnYxbXsnDGZNTmMFHaGOARHJcoV2
T9p1MIR2Nk6nsJO6Kygk17D4ThgbxjCdDJ1TnXwOZ6zMAfGadSNje+Qt//EU/XbpEjzLqBzY9VDs
RXXg6CF6qxZCiHEGTUBjBFAhLOc/1uVSc4NBJy9HqulILowGRLvco/Xyslpndw3YzKEh/mPP6nNA
vMUAFpIzi4lS0ObMDaK5pVeK+Yib7EwzK9mzUmQSqnCHkl/TXjqeQEtUINpcjuUc+86D6LZVHNHZ
sRw=
=qFC5
-----END PGP SIGNATURE-----

--------------Df5GuAkqejEExWAZtpG1RR6N--
