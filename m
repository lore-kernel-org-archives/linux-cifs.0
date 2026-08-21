Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD86F37AA74;
	Fri, 21 Aug 2026 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787335858; cv=none; b=s20AThi3is+fYi76NwwN8FqtFFj78LDSThdM+pwc6mP8Vm5aKySeKjMipqhDrUzj3fsPrcqSIBmAzE+BlyoYHEmbChWIqgEJoLHWhqNCQM3oz4+CmvDgU4aqbUnzoqDwEizkv8ykVTyagDkZteYhJugjYHXO6IDH9LYCqxCxsEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787335858; c=relaxed/simple;
	bh=dN0Z6kVTt0beto8FylMr8Ex1yyNhXD9jnO9/i9DQF4A=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=i1IXzPeKDwtWM6vGuT4vQg4PQu3LXU8K3arCIXDWHHXrSegE0Vhb7UegvMgMMoaLpJQ2hueIeXIXw/MYCCnOcgzL3JciphFC2bMjbRIPPMGc6oZg/piiyJQ3Hj0WRmXqZnN7WjxBHq/EtHDriN7Bqo7IsqAyMkUZERgcmkDJAUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=urgoq19a; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="urgoq19a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m/5/0B6dJn5STtFSNXvjSoH9JziFEzbDLiURVERXGt4=; b=urgoq19aowgK84VfEsW7JTF3M8
	duDtVBkovMF9g3j47T9NBxB7N5Pg/XB+9Ueov0bilVUw9O1DI5WC0ReWzNJ/frL4yOKD1337it9pe
	LOWNN6jzacbOBm067h9PmLIi7XsxS9fXqciQ0GdOSZEBf8ERJELkqygUYM1mLcbox+88SK2PfJDb/
	WjY62l+ZFyAGluUpkgQxoeTabUYkqZe2E/xr69xV9Z8ww66KqCCZMxvZfiw1Nz4a7G3rYfOlR1/vY
	XmuOgIXONH7ns40Gt2DQ50vzRqMnoXKFRi4eTOacJHdcP0UqymHYKUnWdIgR+38tL2wTDphry53cs
	e7jxdMNg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxThe-00000000Puf-1cvu;
	Fri, 21 Aug 2026 15:10:54 -0300
Message-ID: <99fd44bd344f26f92aa6c3d6ddd7a37a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org, David Howells
 <dhowells@redhat.com>
Subject: Re: [PATCH] cifs: call pagecache_isize_extended() in cifs_setsize()
 when extending
In-Reply-To: <20260820211310.1471930-1-sorenson@redhat.com>
References: <20260820211310.1471930-1-sorenson@redhat.com>
Date: Fri, 21 Aug 2026 15:10:54 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> cifs_setsize() calls truncate_pagecache() but skips
> pagecache_isize_extended() on extension.  truncate_setsize() shows
> the correct pattern:
>
>   i_size_write(inode, newsize);
>   if (newsize > oldsize)
>       pagecache_isize_extended(inode, oldsize, newsize);
>   truncate_pagecache(inode, newsize);
>
> pagecache_isize_extended() zeroes the tail of the page straddling old
> EOF.  Without it, dirty bytes in that region can be written back to
> the server, exposing stale data in the newly extended range.
> ...

Applied.
