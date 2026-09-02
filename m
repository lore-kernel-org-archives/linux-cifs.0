Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7423603E0;
	Wed,  2 Sep 2026 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368117; cv=none; b=So/QVS7aFjukmnS8VKlkJRCbL9XI4K3pVmyaZTKHFIswQZIrtpxs0+Yxatxrq1gpRsLfUvdIqB/jsTPbOK7VRe1JG7nJUL7JB0TXNxjNc8r5v/tCRhorK9jRUKojxJ/NaqMvYiqOrKjRuS6EDIHNRLYeJWm9bNCJGMQEEzGpBSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368117; c=relaxed/simple;
	bh=x3fR40GsGchzq4r3xEPljHPTVZ7bNMdKdRaHTamnel0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JTMZpuRexuX24jjAQHnsviSGAyfbPkhKde7uuMGzFI1PBXRca6qyk6y1qu4NG41cvgPrUVELsuXwrF4edmRxrp6PHB1/g5bZHrZ0NDPuuXz3x6JXWXLUCqRYI9Hw4ZhepCXiOn5LB3f0HQpM0D1upMy0TaGYysOYcwKn0XoBh+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=9ijE/K1m; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="9ijE/K1m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HEHd+vbDtLoL/KZjIArOK8eFq0LMY/ZqwHoqxFXP5T8=; b=9ijE/K1mA7YBKJRd/LWrnjwn0j
	sF4JDo411w5srJ4lv4PMw8ojhH03zZh0Z2isfX858nepfJKxnaJUNHuSrCAEJYYQe4dTZ2TkVGUio
	znz3nrmzuI8EkO3kbPhY3wu2i+VaWBvP28mEiyiyQNo1V8jXkoTuLgmJyJCmC2Sqo06fwDBK6aaG8
	uW7hGwJBmyYBesL1nBDwvgMeceS4aFwGQbwflI85yfokWe0a4SeVEizlEMs6Wa4nvy4HFcBBqaTrp
	RqKyn8MpliMNj/SjlX5YwNrElQNVoI5mfhWAkXKdFF3D5hIuNc/TAxzAiTsFdrsTKYYGmrOZ00UZ7
	Oz3iRuXg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1oEq-00000000Wi9-3w3w;
	Wed, 02 Sep 2026 13:55:04 -0300
Message-ID: <1dff7e86f70a6d5c407da8fa4d8d589a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH 1/2] smb: client: fill cache fields after populating
 cache in copy_ref_data()
In-Reply-To: <20260826191033.162320-2-fredric.cover.lkernel@gmail.com>
References: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
 <20260826191033.162320-2-fredric.cover.lkernel@gmail.com>
Date: Wed, 02 Sep 2026 13:55:04 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> In copy_ref_data(), struct cache_entry *ce has its fields populated
> at the beginning of the function. Later, if alloc_target fails with
> an ERR_PTR, free_tgts() is called on the cache, leaving the cache
> metadata populated without any targets. Critically, this extends
> ce->etime, making the cache appear valid for longer without any
> targets.
>
> Also, free_tgts() does not set ce->numtgts to zero. On error, when
> the cache is freed, ce->numtgts is not zeroed, and other cache users
> may attempt to access nonexistent entries.
>
> Update fields after copying targets to prevent partial-state updates.
> Set ce->numtgts to zero at the end of free_tgts().
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
>  fs/smb/client/dfs_cache.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
> index 86dba25b7a5a..b0388c460499 100644
> --- a/fs/smb/client/dfs_cache.c
> +++ b/fs/smb/client/dfs_cache.c
> @@ -123,6 +123,7 @@ static inline void free_tgts(struct cache_entry *ce)
>  		kfree(t);
>  	}
>  
> +	ce->numtgts = 0;

Since you're now setting ce->numtgts to 0 in free_tgts(), you could get
rid of the same setting in update_cache_entry_locked() after free_tgts()
is called.

The rest looks good.
