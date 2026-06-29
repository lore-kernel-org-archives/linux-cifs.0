Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3993603E9
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 21:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782767145; cv=none; b=A6CNkibPQBy+bVkNZ9ROdhNSIHsObInrPgNkd+THu6dSdEnl9EAbKT8qB0K5j4RDDbMfRWGDuuX+PofmLT5yX1Lrm0Hhg78D6JGJERzkuBxpxjiioeH/wOHYW/LoPmlzW3G2VhaZ4p4a8nwRfZeP0+/aTBcwpcZmDaCY9UnwSjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782767145; c=relaxed/simple;
	bh=adet6hHW6Cr5PRr8ii1a0OHfcpR8cuUYNLciTYb2fHw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=sFdDwigj2BFo4r7wWEjonfp2JwbzHKhg1tTkq3CWA7vZLwTneubb9jwxvRJUvg3XqsnSjYK3evFilqbLrs1iWRNWMGEqjW8JYZWochN18txVILhYuCjIZhYEOc/+ucGKdW2zfcZFH4wDfehrxBC1zLPql1OuK1N715/v3ToiHRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=iMId/oKo; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="iMId/oKo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tnxf9yl96lHfDUXeoVS5jyvCrgTrwNgPOHnoylbPG/c=; b=iMId/oKo2Y2chMNW4xasN2tDCB
	PEvf9lP5UQChwfnVeIxe1w5odgkbAsCt/YYUOaAggxPX5DL6Mo286nvKVaZ1I9ezKsM9lmDciVtr1
	NoZbfHVvkyObATITYOKUF7vgoB1+m8ReUZ/lRmBbjh9hmo2zWZEZGH+tS4/c+tsUn87IEi6UqssrK
	E1Jy6h52hJDlln0wci69iKKOUupdp3un44QTJX13dLpyPEIAFNk/2dnN+C8iSt44XqTbzOQjt0RyE
	/fnFT+n2+LXvLBb5Bv4ptY6UxK8iaU2/rD3g51vgergAjEsGm8U2fa8mJQzkZXksQCRhhmXvsiBtL
	Q4EVyPkg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1weJAb-00000002Mi8-15Gf;
	Mon, 29 Jun 2026 18:05:33 -0300
Message-ID: <16d7db05ac86fa6c7820c0f4996a3fcf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com, Enzo
 Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH 1/3] cifs.upcall: fix regression with krb5 + creduid
In-Reply-To: <20260629202145.97856-1-ematsumiya@suse.de>
References: <20260629202145.97856-1-ematsumiya@suse.de>
Date: Mon, 29 Jun 2026 18:05:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> With 'mount.cifs -o sec=krb5,cruid=XXX' (where XXX > 0), get_uidgid()
> maps XXX to 0, as mount.cifs is running as root.
>
> This makes kerberos lookup for credentials for UID 0, which, if not
> existent, will fail with -ENOKEY.
>
> To fix this, simply ignore UID/GID mapping (get_uidgid() call) when
> arg->uid == 0, as cifs.upcall is already running as root anyway, and
> then kerberos will use 'uid' (which might be 0 or cruid) for lookup.
>
> Fixes: 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
> Reported-by: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  cifs.upcall.c | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
