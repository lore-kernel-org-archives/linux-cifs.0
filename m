Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC28D3C73D1
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 00:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785804560; cv=none; b=tSVCdZBBmdQkC/YvGW0sBAR4qFRFAUobRutvTAtQI6o3Rq/tYhF5rLwx4F65t6LJHfjO5AIYGxSue/N58GP2nRT4PQrGgajYq4i9gGXUpmi2rSJPMhp+u8LUH0tzEpt3R5nVy6MCqq8l2lAS2Z/Ndr5E0n/NehwoPGB57EY13YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785804560; c=relaxed/simple;
	bh=vXCgujTA1KJJLV/pAANMZRrF3PP4OhBlUh8j3iHsy/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XU/GHEsjnqoBABNrsu8E+SXLcI4GRxiKlyOBF5u5qKXQ7rmCxJKKpGi0ZBaf3UmpCBWl7QZqgmBDfTzw3NPNrcvjnyl6kbywZ2F4VbUWH/xBvQU1H8ZjCcsXC9SQtoYkuGbvExq2WgHYg9Xq6MFteNnF9FMJv/jDLMwJ1Uj/Ol4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=oKJQ61pa; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="oKJQ61pa"
Message-ID: <2300ce0f-5a23-497f-b481-29f42721554f@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785804553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dOvtuB8v19cPMbRM9ffxFPffUs2IU0wf8H9nl9VOqos=;
	b=oKJQ61paKpL+u5fTA2oJiHyENFiD1OwIm+Gekt1og9O4Qttj4Slf4n5BClb4FusWZ0E0pW
	VnBpvOIuMhIBeXEKgkD1xIXihu3E+0hCk1d8WJGbc1hwNzp5aUGKqp/Z7GlPA99jgL8HmH
	SYpJRmXdSeELrDBoZMWDkd6DxyQ7aB+rt6EkkE4C9ZrfALC+QBINMZW+1ev5iAgzVKN/Cg
	zCVEDkBTwCu6gzHZ+T7XRMGZXH2TYADPP4789vktXCozpuP1nacRhlpMX3E6sOgVEN/oMz
	rDvfIuWWPuITcP8hLkV22N/j0WWMnziPv6G5kKZWTGURSprh16NFVs7rFR24Ow==
Date: Tue, 4 Aug 2026 08:48:14 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/2] smb: client: fix dangling pointer in DFS target
 hints
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, sfrench@samba.org
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
 <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

It seems that patch 02 should be applied first.

Looks good to me.

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 7/25/26 06:01, Fredric Cover wrote:
> This series addresses a Use-After-Free bug where ce->tgthint was left
> pointing to freed memory after free_tgts() was called.
> 
> To fix this, Patch 1 hardens the DFS cache readers against ce->tgthint
> being NULL. Also, Patch 1 hardens callers of get_tgt_name(), which
> returns an error pointer when ce->tgthint is NULL.
> 
> Patch 2 clears ce->tgthint in free_tgts(), eliminating the dangling
> pointer.
> 
> v2 -> v3:
>   - Resent series with proper thread structure and subject headers.
> 
> v1 -> v2:
>   - Addressed automated review by Sashiko:
>     https://sashiko.dev/#/patchset/20260724023539.1596955-1-fredric.cover.lkernel%40gmail.com
>   - Split into a 2-patch series to harden readers against NULL and
>     ERR_PTR target hints.
> 
> Fredric Cover (2):
>    smb: client: harden DFS cache against invalid target hints
>    smb: client: clear ce->tgthint in free_tgts()
> 
>   fs/smb/client/dfs_cache.c | 33 ++++++++++++++++++++++++++-------
>   1 file changed, 26 insertions(+), 7 deletions(-)
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

