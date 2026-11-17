Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794959827;
	b=o8kuXdfUEnx3Es3iMc+M5U8Bj7zJA8U5gJvumvKJk3Cvml32wT65XEzT7+X4s0C6sP/Q
	 ouaT6E8S1kcb6CVLzJTez0zOOF3RmtD9wM36z2Dc7Rhv/vtxSwO2PND5NpjB0NnHFbhOP
	 hiWD9YS35aKeDalcWZOIFnV6jqm3wuD43u4/p2ecJyVek2zenuh9PAQBN4k6ViTtjDBbg
	 5yUVvPxfCrXNIWW15S7jMIhFTPUt6ZqQQmWaD+AOnmOMzs29MRWmpcMw+awuDWUS6mfIx
	 JHWb6GSt+TVj+TwftB1I46gRHfU94iV6awi8NgiR2TeuAFkD4puJSFIg5Rvvyv6osLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794959827;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=zBKSUNIiXiILVKYT5fm/zNF8yb/snSQKW4BL97jmOFQ=;
	b=DsSQ2/P8E4hFoDk3kAKHfy0f9XbMbwoS0NqB421inzO615sTjDkw1nTSfeQy+71rZ2hr
	 D3Q7fxlf/BekNPYzP7ccDSogUOLud4JTNGIBargNAEHSslHI9bet9R78CN5Q6Zfhy1Wqs
	 VOt0SyQUS6dyGzIIdFbEiVLjvSJIjhsvedTZjaI68BQMQUXiLEMP3JMJV63Xebjue4OJ3
	 /8dZPZEki+7v/OtnEueJUwRBroH37sn55Lic+BajX1KMhMB56WMMYuSU/vC8w60oNh1Po
	 DMYcCpgCuMQCGEwEF6j7qJshPl2KoTVPjAroGhM7wio46v87Ho/FspR4lWQMD824+Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="XeX/kpqg";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CA7606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 23:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5CA7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XeX/kpqg
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so4150005e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 15:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794959825; x=1795564625; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zBKSUNIiXiILVKYT5fm/zNF8yb/snSQKW4BL97jmOFQ=;
        b=XeX/kpqgO/1P35ogpjLlwilnlvUFxFQSHMnnNShW2FTydkN5BOOFbOVoiZ1Tt8lCdP
         nWleJ1xb2SgrnnY9yQ9J6liP7gVP9z1S3U51juI7aanyRwXBCVGUrHcNBONwbjovMIGA
         ize1km3yalXg/kHQB+YLgd0Je/uGWIV6uDtEnzb6G6RYtBpDw9SqmNxyytBqPn73y2BO
         O8Mc7OCOL9xSyFnV3BpIDzNIJYJeLqnhDNohQQ3Qqk55TRBfkEsdiw8VlNsKlb+LRcaZ
         fHdt6yhQVuwnXlUzL/YnSKjia75t3dr5aQ/WGzE8QhPLylqcImcPLkZpnWJIGYUcACu3
         bT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794959825; x=1795564625;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zBKSUNIiXiILVKYT5fm/zNF8yb/snSQKW4BL97jmOFQ=;
        b=iiX/hX74ZlyraVKJVZdEPIeYdH0Bk/SUApCfe9r8wnORKyhdQZq8QP8/CUlzbSl7lb
         nFd7K9d3xfqDioGh7fwQNg/oMWnim0GsWszWW4jz9+vaKsm96G6POUPl4343DzFrpgb1
         G40WWFY9aLPda+y+PnXy56U4qhmnjxmjMPC1g3i+m2KuDm+l6XmlF2d+a6h6XEJUDntl
         hq0SGmH8J4MnZeOZVy776E2wphgHSL5hFLDXn4JzJjLjmGw2mtpi+yPIB+LcIJ6q1mF2
         MAbA3BcYvd18bBuXJoYHxWRIsUSVfRafNPbdSNGTxz4kQVVtJ0WOc/sciUgukYMv4cXO
         ZJ1g==
X-Forwarded-Encrypted: i=1; AL+hErHx9m01mFJn+WEpBMqeA8T4FQkotic3KAIgp4o+8pFybjJh0ZilHjxZZ5QpzuQZbcuKdCn2aPPjtrkW@vger.kernel.org
X-Gm-Message-State: APuU4Z9MYnZUjK/dlYpHIeA/BOk5ToN3HlSXbFKXCGZmLi3Rn7ZkMRH3
	0AUMCt9Dr8AjhrBGXXN4M4wDiRgmsZKKkFKE/KL8tjJQMRKnpfcseRKl
X-Gm-Gg: AYBFou2WC08BRWrbDl/KSXM6EjTv9R4zPtnIs1pVObZEOFLnN9H5//LADhWRy/ahAeW
	AnUrs0dFwEG/7ksqaMl+exAIM2ekCF7nsPnovYxqSWaBb1QcgZgjHKksWyBjShyGRGn46NLBFI8
	LaO/P4aNj845x8oc/0gBsLmSxdsyXbDftERH+c4IOtEqi5r67Gaw3okwasiCbrRmii04vCh3sft
	uK/PZpjGDGTRUnZJV9OclBjmmeYP/8qJSzP5T+JT20XSK9DJ2U3iO1zw+rBCGgvaPjaaMYoII6V
	KLxaV9YOVDro3jKdJjaGuuCV6GlMMmrAR/P8AmkQjKdlQAFER8d2/MRr/DZm9ONDl44LpKQfP2W
	6ZTu3DgQLSzzB7fZzUG2pb8Yi9oQ9BN1Z0zqq9a06j+4c9T7cH6TTHxBgPIwePCO0cQtsYLKrdR
	EQ/6E31zsksjAi92BcIpPqvalv2H1QjqPmsy5psKFEQr1wHvPS2LCGxCCWrnHsgdhrZcLjSvGbD
	MD6Njwz4KLWO1re0e48YUd1nQCPhgaxZPPAB+O4zeok75MhJaONIN/2JffgpDOD8lDzEwYrVrQD
	grwl2gZOXGciYTSrKSSKUbuBKg==
X-Received: by 2002:a05:600c:3485:b0:4bb:6c5e:b006 with SMTP id 5b1f17b1804b1-4bb7d6cc1fbmr14508645e9.3.1794959824991;
        Tue, 17 Nov 2026 15:57:04 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ddd4614sm11604905e9.6.2026.11.17.15.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 15:57:03 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=b8e4a62509544b067db299bce93de40d8eff238bb48ab78a3f5b1b72ee7a;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 00:56:24 +0100
Message-Id: <DMXW51AXC5LC.WAVN6D92YIE3@gmail.com>
Subject: Re: [PATCH] cifs: fix times assignments in cifs_posix_to_fattr()
From: "koraynilay" <koray.fra@gmail.com>
To: "Paulo Alcantara" <pc@manguebit.org>, "koraynilay"
 <koray.fra@gmail.com>, "Namjae Jeon" <linkinjeon@kernel.org>
Cc: "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Aurelien Aptel" <aaptel@suse.com>,
 <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Sashiko"
 <sashiko-bot@kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261116154526.429315-1-koray.fra@gmail.com>
 <f61c83e614c1afdcdb20c958474ac055@manguebit.org>
In-Reply-To: <f61c83e614c1afdcdb20c958474ac055@manguebit.org>

--b8e4a62509544b067db299bce93de40d8eff238bb48ab78a3f5b1b72ee7a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 17, 2026 at 11:18 PM CET, Paulo Alcantara wrote:
> koraynilay <koray.fra@gmail.com> writes:
>
>> Currently cifs_posix_to_fattr() wrongly sets SMB's CreationTime to
>> fattr->cf_ctime.
>>
>> Fix this by setting fattr->cf_createtime to SMB's CreationTime and
>> fattr->cf_ctime to SMB's ChangeTime, matching the behaviour of
>> __dir_info_to_fattr().
>> ...
>
> Applied.

Thanks! (also for applying the other patches)

Best,
koraynilay

--b8e4a62509544b067db299bce93de40d8eff238bb48ab78a3f5b1b72ee7a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCavzpqAAKCRDmj22qf5IG
XPWVAP9xBbMDNG3wRaQ5otbBeAD3QJd1ciHOLK87Ks45GFkGPQD/Uc49HbHxdsrm
fBmxh1qMDGjqe7DXxQGBQKhWo/58BQw=
=lQhA
-----END PGP SIGNATURE-----

--b8e4a62509544b067db299bce93de40d8eff238bb48ab78a3f5b1b72ee7a--
