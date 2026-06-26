Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402DF28541A;
	Fri, 26 Jun 2026 03:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782443837; cv=none; b=sbfL6t4eZbSsvCuL4cQQwwAUtCOhbHwUA6p6xsBTL4k2WX1Eg/QEDutTZb3dpkH1CFtmqmYlw/6zK9wRRAkMmnS3Dw5EsxrlE3tjbFKPuV9VNenaCnCirOWBJNCx8AtwgpKxy9dL09AYMCNIrkfv/XCiYUcLl2gxYrFCq3tE5Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782443837; c=relaxed/simple;
	bh=lMj5XbwW6LcCx2H3HiAUY1KzeQpYX+KMgSRzQYp20tg=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=CiEg20k0MP4k1ojSyrLudSSIlr45BJ9xa6QD0MpEYxCPPmXric5pb6vscs7G1DAuc5q8VGFDlpdQ5HfHaay9fj/0ZJ76SF7LHGmCDLT3VFTH7SKr5ROj3wuAta0P+IccpDslVQMxeW2ehkm7cSnBaFuD9nZ9/IB2EJO7FCYn2Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=KauWZcFo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ch22c1mD; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="KauWZcFo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ch22c1mD"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6F5427A013E;
	Thu, 25 Jun 2026 23:17:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 25 Jun 2026 23:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1782443835; x=1782530235; bh=rKd3v9QCuf/qcqqzuMSxfvxvum0WNtiESqg
	a4mSwIzo=; b=KauWZcFoetVVmqbDAX/lOAJ2LFUeJkQAFt2rSgRHoOM2avm93xI
	wPfZFju/jnNxasfee1DlboCc3DfI2qiaZtS22JxFYKJbBgEoDxHw7RlnERqRG98S
	XvgXKN8iRv6Szo+QAYDmK6EfB5txea1tZBZEa/JonXznIyQGWPGDxntGlMDOYcAt
	DusGcit3i89dgD9KUhw1cRLA7E775djYpes3pXX58JL4s515eatK9yAe37vukFSz
	C1VI0Po4YXOh4qq4MNzCl/R0X49fPfbH3eBcbgz7iUIqca7TWG1U8GYJ8Sl0Ohbl
	Nt18Rj/V72aM2lYGeFnG6GODs2Cn18qqLzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782443835; x=
	1782530235; bh=rKd3v9QCuf/qcqqzuMSxfvxvum0WNtiESqga4mSwIzo=; b=c
	h22c1mD5i5auIhrt4LDCV4GLnqGwHu+MMwVWWOdFhwvRfdJzmc/dWnXjUvPDbtiO
	IvTgsdWqvXV+DBitvYl7b2FccYXmaNyd4ZEWyXlpY5tx0m0WV+89QMyViTK6IQ1/
	HxLkeGlQjdJL5XwmdfTqtZhJYj8Uq86nlAaTlCGZY1IOJhgVFecMv6K5R7Okybut
	PZoD7YBa84S2KZawxFc97+ii9U4ouKOrtRByxt8nCQ54o0eFCb6Yj2X5s7mpSHwN
	2qe98WqO+5rMbR7XDVivoI/ZVbyEDT3FynUM/BFU/c94ZUVLAOjqnsExJ+Y0S9vm
	EKTgsybW0nPDJjPDery1A==
X-ME-Sender: <xms:Ou89ahf-V6Dxv8f739B-rtrjcA_h5uFHCH-Ju7OzsAg56pjfliKROQ>
    <xme:Ou89arGs2HlNOVzCqz35eZ08ymfh5eIfNReXJv29b6rbTLHD_Nz4RxDMOCEexNMuI
    rWAU9CIOdJDVJ2PJCqJVQo8Xu_aIwPLgbU6mvyScwR1ixM5Rw>
X-ME-Received: <xmr:Ou89anioXw0noAddWVLfk044Tw1Lq3mz_M8Adu9ro14-EbzSO1sWBhEQPoZlGsml_w>
X-ME-Proxy-Cause: dmFkZTGpDcr2aQCDcyqgmulEIoD+DA2popr0XhYMgIhrlVGduc9/ed82TwKLsNJm75UNnI
    pZly5KyBF5JYFpX2QH9D01R/6Ax8+zpDHs18KxhnPubxE2qXIO4ZKUPrfaIYhN1MjUL/Te
    bS/HQRt4cLV2ibxVFgBSXcxdXEL8NffIfv9Ne4rKST5r81KmYacQaUYe0uZRbBg2PBDs9Q
    MeagNwePO2lkiDdvsy7qlYNBL0P8M06dNOcTow99J6TnNRK3ssd2SO+mh85h7CGjMdTx7/
    UYe5V8iVdJWyJhVKZS1P4aesy8kuzcldrsFPKVkdCFR/LIn/ixskfKAIDo3yodzMj581VS
    1+sRi9PaVR06Qjke0JJNoBpkbKWUEc1pLsdUPACRYM5vrpdhPI5AEU/bYXMTHV2ECOGTMS
    eMn83wSkSnzFEZfUT3vAiMlptcG7zTnFLlqNqupUP6EyME0gZX3zrdQQRIeAYAu21Oh+lf
    rWtEEJqGapYapCOTwnawXhakHwxV4oXeKZNPxZyDGD2f/Mo0tN4BofN0v0AETGUqnZLIAM
    fqclYzDIHUhnJRi6UDupKMYi6cZZBt5VZgpCH6EL/Cm8JRtyCrLZw0G/TS4+OmhiIMgcy6
    N/t7aP529Eo9xUvay7iLsWvjrjMORe5QQSri/k6zd7RcplJ9AsqQ/ykwNzyw
X-ME-Proxy: <xmx:Ou89av31577nuWjLNN1D84prhJwnxbA7byPPqdKR2CkHiCGlYvc4nQ>
    <xmx:Ou89aidEUqPwrz_pCFuHL41Nhuq-CzYy09m6xiSD-Oc62tXmZOETDw>
    <xmx:Ou89atxL5Etlb8zog4a-69Ip7H1Vw48ro1NT_BgIhfbXckocpHH90Q>
    <xmx:Ou89aiyLtmkkBNrHuF-9V-KPxX5h8VWg-FTiN9xB6HDltETj1mnSuw>
    <xmx:O-89aqgC2KgSwyzK5Ai3rs8bdjhIdX6wv016G6vifTePKk6-KNEUzWj3>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Jun 2026 23:17:11 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "David Howells" <dhowells@redhat.com>
Cc: "Christian Brauner" <christian@brauner.io>,
 "David Howells" <dhowells@redhat.com>, "Paulo Alcantara" <pc@manguebit.org>,
 "Christoph Hellwig" <hch@infradead.org>, netfs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/15] cachefiles: Fix file burial to take lock when
 unsetting S_KERNEL_FILE
In-reply-to: <20260625140640.3116900-5-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
  <20260625140640.3116900-5-dhowells@redhat.com>
Date: Fri, 26 Jun 2026 13:17:07 +1000
Message-id: <178244382730.27465.10343171995116134377@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Fri, 26 Jun 2026, David Howells wrote:
> Fix cachefiles_bury_object() to lock the inode of the file being buried
> whilst it unsets the S_KERNEL_FILE flag.

It might be worth adding
  lockdep_assert_held(&inode->i_rwsem);
in __cachefiles_unmark_inode_in_use()
and __cachefiles_mark_inode_in_use()
though all uses look safe after this patch.

Thanks,
NeilBrown


>=20
> Fixes: 07a90e97400c ("cachefiles: Implement culling daemon commands")
> Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40=
redhat.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: NeilBrown <neil@brown.name>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/cachefiles/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
> index a464c4646c04..d4309dfb55df 100644
> --- a/fs/cachefiles/namei.c
> +++ b/fs/cachefiles/namei.c
> @@ -375,7 +375,7 @@ int cachefiles_bury_object(struct cachefiles_cache *cac=
he,
>  					    "Rename failed with error %d", ret);
>  	}
> =20
> -	__cachefiles_unmark_inode_in_use(object, d_inode(rep));
> +	cachefiles_do_unmark_inode_in_use(object, d_inode(rep));
>  	end_renaming(&rd);
>  	_leave(" =3D 0");
>  	return 0;
>=20
>=20
>=20

