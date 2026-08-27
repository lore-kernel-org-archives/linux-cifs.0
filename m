Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3019E3803FD
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796471; cv=none; b=LoD8YGBCoU5RzaGXjdTc6a2dqxezYdtOr0qQ2yqxEEeJReuUKTAa8AVqhlBQN/0VK2Bh7ZCDYBGtKoymrbaUItlSqhNkBLSqmL9G7Qms4fnu7zkfew1CUEl2FjOOx+rdYWlS8mYqwddqnUOE+0oIfPz9uimc0leXaFIkZhU4WG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796471; c=relaxed/simple;
	bh=yzcmpMNwHpzjITXqZlA+BymtvtdZo6EmBogo0Y+qhZo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=nCu4Rd5qO73xSeTk04uHnWjFPVh+LyjwoE7iW0MQWwPWiHqP9ZhoLNZ8rX32/P/1EYvTXF5LMkeF2QK+YXSfyPQYciyvnjh1+HcOeOYLpysTyzifqPkbMvwEJp/GX649wN3Y26kBnXTv5WcLoEjESCB29Q3Xhz21mPDES6Bzx+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Ywq0gdpU; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Ywq0gdpU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yzcmpMNwHpzjITXqZlA+BymtvtdZo6EmBogo0Y+qhZo=; b=Ywq0gdpU/XmU/wsahor1RuxTQz
	OAJwMrMz6E3RhUrZmyt3biMJ8ckYDntXgJV0z43S9E9oSCXT5HFsqdEpcX4bQzbGAueuQ2mk0cWrT
	JQ5im2gmWQl8iCc1Zg770Htezs+LpXN0UHVjoS7kXmIcW+fiLG4g/GrCBTJEdKeRU0pPk+V0KwZwn
	CFuO5iREkj11KapQ68Has/aJfSvGGTPIiSn03OlsWRGWCfMoqXYV7QGHAYVeQSjadmfWvkvKltZO2
	aIX3Q4l9ywx89Bx0hsy5Nxx+zzEOdw7nZVpUrlYUIpuv5bbwdb1tjzFkiKdUxoGpaYBFFvHYWSlGH
	Outk3guw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPWp-000000004fO-1hHq;
	Wed, 26 Aug 2026 23:07:43 -0300
Message-ID: <7981793b5cf9e64a21f06255d1da2500@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 1/7] smb/client: validate new EOF for insert range
In-Reply-To: <20260823151053.935889-2-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-2-huiwen.he@linux.dev>
Date: Wed, 26 Aug 2026 23:07:43 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Huiwen He <huiwen.he@linux.dev> writes:

> From: Huiwen He <hehuiwen@kylinos.cn>
>
> smb3_insert_range() does not check if the new file size
> (i_size + len) is valid. This allows FALLOC_FL_INSERT_RANGE to bypass
> RLIMIT_FSIZE, exceed s_maxbytes, or produce a size outside the loff_t
> range.
>
> Use check_add_overflow() to calculate the new EOF. Validate it with
> inode_newsize_ok() before modifying the file.
> ...

Applied.
