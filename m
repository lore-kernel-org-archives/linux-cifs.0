Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433ED334C3B;
	Wed, 23 Sep 2026 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126657; cv=none; b=NJ1F8C7K2Walp9dRbCLk+CLz76Njk9S9Kg4/mlsTqM+SE0kd4LyVXDT+tl6LkIRK76YQ+Hc3w4ejeIv10O2LZ3NSWh3gTcbsYlEk5iJTA1BD3tlk8kgbb0u3pHwY89jGV/R/QPE2qBKqii5zdMYNMdkRSuBAm0eIFESnFjv0eVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126657; c=relaxed/simple;
	bh=8ggiHRtMy9F9Vjx4ARo/KUmW8xW2/XjjSzqhyVeNpx8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=P2V9+C2lBthWg9fjIv8ES1g8nBcFX7bAAnFXrveBziGdcjPaV0wtSwBiJZt7iCvLIwSCKnGOBRqjeTQMQfRpSjDMeMq3ewzFhhpRJNpP/DiobcFYTBaYUE6x5yzVtmj8sgkZ1ZKW+zxRLCW1K4hKDe2KzNxP588+vC5nYtGr51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=hEGEC2sW; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="hEGEC2sW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8ggiHRtMy9F9Vjx4ARo/KUmW8xW2/XjjSzqhyVeNpx8=; b=hEGEC2sWt7GTzWhEDIg1cffWxQ
	KGbwBFbjIRKDLwViCj+DvsZpEz3jS22WsKR01Aj6OYA6hztf98kpCIZGlVvEfC2OuBMBpGrGDrNvC
	LCJQQXUxKC9ffeRwB+oLFA8yz2SWVhKByREL3FdGErRG4xfYKJOHZu5dZNJaMn4dpF82PuAkSrN0N
	FUwujMAdwesSi7O/WZtGhERGBd+ITft9zvjRaI0kSApeV1Kd9QqpbsaUV0QocL3mBp5awv+NkTLv3
	WAUuP5NYEqCqYGHKEb/TkmfKhFgwIEuPFBGH9rh25d6n7/R2LNN45xUxE2Y08AOKxG8dXcR9sFuHt
	A1qjlMAQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x9BiR-000000023kq-02uZ;
	Tue, 22 Sep 2026 22:24:07 -0300
Message-ID: <975146f7abe1950650803a6732f1ad48@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH] smb: client: use GFP_KERNEL in get_targets()
In-Reply-To: <20260922173759.67445-1-fredric.cover.lkernel@gmail.com>
References: <20260922173759.67445-1-fredric.cover.lkernel@gmail.com>
Date: Tue, 22 Sep 2026 22:24:06 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> Currently, get_targets() uses GFP_ATOMIC to allocate the cache target
> iterator and to duplicate t->name. The callers of get_targets() are
> in a sleepable context; therefore, switch to GFP_KERNEL to reduce
> risk of failure and reduce pressure on emergency pools in low-memory
> scenarios.
> ...

Applied.
