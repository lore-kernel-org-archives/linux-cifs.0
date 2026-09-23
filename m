Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7874B3346BE
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 01:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126390; cv=none; b=tt/MEmBQXqFbuBrzMriEEFdHROw13c5V8Io0oxfGZ10I2qzmFQkVugO5rPkop5DtOs1Bew+rQ8CTu5PlEHOn1ZfedeePiVNSwWkSZCoG/IF11D4yhumsxh1ZM6wGzLJzoAFFvjkIxe6HKk6GKqHxLbec6uuuqeD8swGIjAGygP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126390; c=relaxed/simple;
	bh=ZKoyvaMi12huEOANSf2j7I41Oizq3VndqW1MZSIdvPE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=gF7B1zsdK4/vhEj+DKrIPjSaRUA8P6tfWHVhN0lnBF/yt7MuxmmwzkNIfKS9tc943JmaTZ0UotHG0J7h5EGfay3osNxr1o76FrQ6hHLto7G1kCnJeN/z0S+jhwMQEZAK1RCj0R8pqpk9tTl1ReAPW/n1s7kyXbNMiOxlIrhXgeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=BGeWMzyR; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="BGeWMzyR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZKoyvaMi12huEOANSf2j7I41Oizq3VndqW1MZSIdvPE=; b=BGeWMzyRMP3yGDzmAWixRS1E7+
	3cwhlaAsB+HI1FLc8wLAcH5utM5alPX/ZJProeqMpmM/kq5hpoNalIeJgvT5/EnD3vLQFCwjGuCXG
	M6Z329KGQsVacBfcNnX6xbMu3AgVBTeBMepPm4aUlT+pSY/Qys75YHNjJK+mNWUDNM3vBEtf1zEpR
	xYdxzNczdydtfcV5q3EuvdncTS1glSgyNmKtVmVep0KvkT+V8Bw9vzj9Fx6q4NCLuzuwykNFSzzdn
	AMDu42cJy5MO97NTruTdUMbWNilEnga5y8ZHW6orK/djo40GiCKNiO6qBd0ITB8VovlWeNVq1wOYR
	2vqj+8yw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x9BeD-000000023jV-2YJp;
	Tue, 22 Sep 2026 22:19:45 -0300
Message-ID: <a7f6434f849ddcd4e96ed87003575a32@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ZhangGuoDong <zhang.guodong@linux.dev>, linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v2 2/3] smb/client: update POSIX extension specification
 references
In-Reply-To: <20260921014130.147229-3-zhang.guodong@linux.dev>
References: <20260921014130.147229-1-zhang.guodong@linux.dev>
 <20260921014130.147229-3-zhang.guodong@linux.dev>
Date: Tue, 22 Sep 2026 22:19:45 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ZhangGuoDong <zhang.guodong@linux.dev> writes:

> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> The POSIX extension specifications have now been published:
> https://smb3posix.org/
> ...

Applied.
