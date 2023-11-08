Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BD837151
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="b2MZYspJ"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1482121
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 11:31:22 -0800 (PST)
Message-ID: <bd3b5bc3626faf170ff83d4e35de490a.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699471881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KA4tTBQb2AIozl2engjMAXBr0HlbXvYntWVT7j+BSq4=;
	b=b2MZYspJttKIap7zsKlnBIfvBiWIUXKRf5CGprqAHisAb8XyYS8YOd7kisEurDsECr6qbE
	eKgy1ZlQHJUFufqN+1m0OSagRwpVmcq0zxAKDM+iRXiImgvMB2Y4hSDSwinCsP9dQ7+u3r
	abrWO1l0olTQ/sN8S4GlDG+qXVFka15N8vqz+6ilXxv1bJelMisXtjxQLV0gYJ/mVWt1DJ
	yyafRd+rLH0Rn2bpXrspsiLjSNY6PV9ZUVvhWlAjvQ/1YZjxIACG762c8E0Rf/d8bv9Rlq
	chFPZCPxitQtlVbGTeJff8haAZdICwYTPIxMcozcWC1UHzR67c65Iv2OFOY+cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699471881; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KA4tTBQb2AIozl2engjMAXBr0HlbXvYntWVT7j+BSq4=;
	b=drmbBp0xhMVtYjgW3g0S0WmaIF/UbmYpJw9kUdQKJ8RcN29BP1Rr7kv9mpJ+AAw/an/Anc
	JeL/8Fxxdb8yF3TnhLapMCXcrqrqLDyZZ9w2zq15Vx2cS9rLiRKaxKOnvrXs0xN/TwyWKE
	9XekAM+WhRU4me9EzC9ZLrGhMJshawCjhGBj2nUsHyHRs81xDtA/Xr0e/S3jDMOG7uS52Y
	f0IRjGE0rQ5HelqNrMkmfMqaFnxd+gJNmmfFbVfwovDKbCTjhtqJu3YPvO5Y9B5MTN4Hb0
	6EjqNYqAw/mtVr6SFU6PtXzayv9JZJz5+2qFo99bqY4qt7iXu/iH/tyLWoc7tA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699471881; a=rsa-sha256;
	cv=none;
	b=so3aBbcwt066KTHz1Tyt6ayh2J5nvRTyR8ZhmzJj84h7ab9BlmW4XZLWdeM3L0g22VFAAo
	n6qN0Y1LiHfxjEmiM92Y0xqLVFOVFGiM/En71jlg6b3GHHakL6yPTFTAFtHmrGDKVyeZHs
	wtes/uzoscvjIxvdlTbYtp1TJvWPD5ICUBVOOCi7io93WXZ7GFMpPd3gmJ3yxH1s6X3ZdZ
	ZttG9FLJyezVB9/uqtR5vUU9X1aVFUsX1stieotjsbSkKliMct/5VxayChD+cwOqQcuveD
	VhIAO7nBzf93H+AuCCZyByfLJ7gP/i4CKDQnaRPVqr/+79Sb2ZDhQ2iT2r9Ucg==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting
 multichannel
In-Reply-To: <CAH2r5mvAYAJKGvG-Jm42L-5EG6CYxVS4bNs1y_+0477RO2e20Q@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-11-sprasad@microsoft.com>
 <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com>
 <CAH2r5mtSZGJJYqFK1N+uT5gcr8vkUhLdYNE_VQ3nP67XxnnpPQ@mail.gmail.com>
 <5deda9f23865fafcbd99d57424791138.pc@manguebit.com>
 <CAH2r5mvAYAJKGvG-Jm42L-5EG6CYxVS4bNs1y_+0477RO2e20Q@mail.gmail.com>
Date: Wed, 08 Nov 2023 16:31:17 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> I just updated the patch in for-next (see attached)

Thanks.

> I removed the unneeded export of smb2_query_server_interfaces() but it
> looks like the logging of failed network interface queries is fine
> (and is an FYI message so not turned on automatically) - I could
> definitely see cases where FYI logging is turned on to see why query
> server interfaces failed even in the EOPNOTSUPP case - so the debug
> FYI looks ok to me

Yeah, no problem.
