Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1799F367F31;
	Mon, 17 Aug 2026 18:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786991631; cv=none; b=asnRrtXAc4LxBvObm1obJRvYGlEG/3bQZl6toT1KqxW/RdXYeWblshLHygoS1htiw8/n1/LyebLCo3fHhRqJGblmN2D1w0SomRRwssMlRmuu3TFgzF1xSG+eMNYdzjTZtMqmHyerQkUSWdD0+0f73NTIbwITuP0pTR1uYM35mvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786991631; c=relaxed/simple;
	bh=+vEwLhAp11Q3ConJs977JF/I/e4d7Krk5LSCMt/nNDM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=B0ZZRgbKiXsGChy5Hpms6cKTuRwJpPkB5PurLRY6qTxOcxGEPWV35YWVY+4jPRDSpXuA31dL6obqeU6uXVSVgGaEnueK827i1QCAJOi95IHCk7pLXk0M+rWGtihHHcqw1gD90ekd/IkS4nH5g1rxn1YaCQWPJ68tk1aD5nIpJag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=0aM0ZyBQ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="0aM0ZyBQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=12fQ1IDI1SIX8X8b0UiLPG4d6Q2+a4MDKkFkrHymHjg=; b=0aM0ZyBQI57wQBGjTHsVFDtYRT
	wP7hWWbxWAK7M+UN3g9dA2yYrDBwqr5MZSXYDhDZWmO+OdLYWSBpRhhXxqvSZF57mAYTjdPvGqdhB
	Dp3kfhzVs10L71ZMCnMm0EREpge5LiPU5hghKLL2gX+ERlUBolDfQP6ustgXJulF+CujEtELaB/Zy
	DyJsTUGEzjLZYYQ9liqM9BYyK8o63AGS8s+AC+O5qdifK/9uev/xOaXFhu8+mVx3xYDiUuVfODZDW
	ejhQsnLsmw2dSoYiIrKADbFGaWUAO6Hi0L3vf7i/SLEP+UXjtH/r7uzQ1YTXonRLDN+F4kzdMQF8o
	T7NTf31Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1ww29b-000000009vY-2uuS;
	Mon, 17 Aug 2026 15:33:47 -0300
Message-ID: <e435ab39a31b51e6fe149dbc541f33f5@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org,
 stfrench@microsoft.com
Cc: stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix ALIGN() overflow in symlink_data()
 error context loop
In-Reply-To: <20260817171651.212730-1-sorenson@redhat.com>
References: <20260817171651.212730-1-sorenson@redhat.com>
Date: Mon, 17 Aug 2026 15:33:47 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> The check added by commit 7d9a7f1f96cd compared the post-ALIGN length
> against the remaining buffer, but ALIGN() itself can overflow: for
> ErrorDataLength near UINT32_MAX (e.g. 0xFFFFFFF9), ALIGN(x, 8) wraps
> to 0, so the subsequent bounds check passes, and the loop advances by
> zero bytes leaving 'p' pointing into stale data.
>
> Fix by checking the raw ErrorDataLength against the remaining space
> before applying ALIGN(), then checking again after.  Since raw_len is
> bounded by the buffer, raw_len + 7 cannot overflow, so the second check
> is an exact post-alignment bounds guard.
>
> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
