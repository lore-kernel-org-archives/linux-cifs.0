Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577494F3902
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662136; cv=none; b=VRyrfO44oz3u4+NZLHgLS7AYExfGw10/GuQsjqSO7lPUB7M/1H6yAfpuusnjvpalbNVLF0sGWo9fGYYYbr7wDA9t80E4PdVIFx+lRojzkijp9C5OW4BBN7ESSeyQYrVZhq0vrmeSSgnzBFm3L2aZe1sJmle1aGOyMvptd5igp8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662136; c=relaxed/simple;
	bh=xLcUrF0+42ya0VKrZZdaicTCP2bWIyWMuCPMhm6dw+U=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=sGxUXEqUx+dCKn5hLGbzCzPi+1Yb04/IRXMPWD9Yc423B3APinfYRuhnLEUzc2xKL5JzeDDV0uB7LTPrFZEbvY6eRhBmsVLcJsivlfnk5NuFmJlaPMb/mHxGqiqzoyaffs+TNHchyciYyHLwrzu8XdCA7X4amDHs/PsZm4aV9xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=87BEpiOe; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="87BEpiOe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m9wrowE4knIImgVSXHJ2zIKBQF6p/UyK1B8OWHN7vu0=; b=87BEpiOe8Q0uoV0CGvXG55M9Xo
	5tk44z8aPXaix+MVUv+hBNejHasqUYpGc6zLpoydMEcP+HHysp+qZgZJ9PlW6vQ8BXUa3KD3SlHfD
	ldJbvrOUDxN6rB4uikRa/DGbvQSkG5QeDh/4l8G/4p/mLDayrE26aNacuQcj5bdVo9taMB87IISHV
	OrzInfNVfRtAGid3fPBdGuQD/4eNhd+7Ehj2+l0ovYJ7VXqKCvD2S3bMrt/HoNv6jeE6/gB4qsKHC
	fTMelsKVsZ6BuicDy08QaRp0AfdStqSXvwuva4/i32cm05b8ebx0Km3IgPodTXFqZFXFJhr41df6b
	hswcedEQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x7EsE-00000001fHb-36pN;
	Thu, 17 Sep 2026 13:22:10 -0300
Message-ID: <26c7e0c3802f0fca96aed145d6042cb8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Alexander Bokovoy <ab@samba.org>, Shyam Prasad N
 <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, David
 Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs.upcall: resolve scraped ccache name explicitly
In-Reply-To: <20260917003750.1790143-1-pc@manguebit.org>
References: <20260917003750.1790143-1-pc@manguebit.org>
Date: Thu, 17 Sep 2026 13:22:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> get_existing_cc() selected the credentials cache scraped from the
> initiating process' environment by exporting it via setenv($KRB5CCNAME)
> and then calling krb5_cc_default().
>
> MIT krb5 reads $KRB5CCNAME through secure_getenv(), which returns NULL
> whenever the process runs with AT_SECURE set.  The request-key upcall
> that spawns cifs.upcall triggers an SELinux domain transition, so on
> systems with SELinux enforcing cifs.upcall runs with AT_SECURE=1.  The
> setenv() is therefore silently ignored and krb5 falls back to the
> profile default_ccache_name (KCM: on many distros).  As a result, a
> valid TGT living in a FILE credential cache is never found, and the
> mount fails with:
>
>   cifs.upcall: main: valid TGT is not present in credential cache
>   cifs.upcall: Unable to obtain service ticket
>
> while the same TGT in a KCM cache (selected via the profile default,
> not the environment) works fine.
>
> Resolve the scraped name directly with krb5_cc_resolve(), which takes
> the ccache name as an argument and does not consult secure_getenv(),
> so the FILE ccache is honored regardless of AT_SECURE.  Fall back to
> krb5_cc_default() only when nothing was scraped.
> ...

Applied.
