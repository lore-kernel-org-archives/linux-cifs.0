Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FAA4DA55D;
	Thu,  3 Sep 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449085; cv=none; b=hsNBozpDdrDb7YOU8R47ygqdbcWASz/Qm3sji3NWpeW8TFh7AY4ejylcHmyK89ToYmRlMPCsN7eo8dgr05zF4tOyLkAmR4vPXBJ1+GI87zsn6ONl8EdlKMU4JYvKVMxYBavQQ5OmNEh4y38v0qRxlHUPy3zgQ5CA7KiDrVUOpK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449085; c=relaxed/simple;
	bh=X3M3G6869F0v1ecMA3OUiQVI9S2DlcIK30nGnSDzA8c=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=D8q5N2VV2U7No3hvkwaz8LXZr9EDI0ymjOv4cmS2dk0pljQjs6rX3jn0Q4+NfE+KuggmVJWEZZxjELeXOqBmh3rmOUzHHpSlD7+jTTmPBjCO5homnhMjyAnIEettACYVTuHEyAZ7uH4qvfdqXrLJc81+368CT/8QFwyfpBWpEXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Ng+5+/zn; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Ng+5+/zn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X3M3G6869F0v1ecMA3OUiQVI9S2DlcIK30nGnSDzA8c=; b=Ng+5+/znusSrmX35sVzEZvJoQk
	EXh27G+B14xUhtr9ep2J487eQq54VEV56aYqR+gNHTr2ZgdCMjw8ESQwh+CxZCWXU9rSZzn3h4HNm
	FkFTnXjZI3V6jQAlvAljED7LGZQq/13sjznnWnP9XQIyn31tAO9ESEYd+aRZJLu1lDtn/Dmg4GwAG
	E1E/tGzAjsgoz3W+0XmNX4SM/BxieQxDRezQ78y5kkMIodxIWszhbh2Tfzn+QbNjFqRVI3cxB8wNX
	+4hUOcdWpCzDiirFl6tBNOhmxRVWcV5F9ACC6hYP8DTS5JBkJdNWEcPFEN6hzcYw9hwoq3kZGk8Cp
	PZ3TZCbw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x29Iu-00000000cDN-0I9M;
	Thu, 03 Sep 2026 12:24:40 -0300
Message-ID: <38ee9a01d4d7acc40e4403ab03a99108@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH v2] smb: client: fill cache fields after populating
 cache in copy_ref_data()
In-Reply-To: <20260903004901.135233-1-fredric.cover.lkernel@gmail.com>
References: <20260903004901.135233-1-fredric.cover.lkernel@gmail.com>
Date: Thu, 03 Sep 2026 12:24:39 -0300
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
> ...

Applied.
