Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757D296BCF
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796491; cv=none; b=QBYEe0+Tt55ADitObu6uHImC3HhWJc2ixZewLIOAeZ8p1vUJvhcN97MhDAnD6w6ZAwMbeifbGHx0tnmWDZYzCAfs9eSOUFlUpcBfbBJfgMUIRqBrs/4UfdNRqJjC1/YFnBOoPIWnpTllxhnDdE3O8rMbAjaZyh28aA0II3XNSeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796491; c=relaxed/simple;
	bh=NcEHhzc7KlhpD/55xsrZL+At8Q6ySDc5lAbroXbhSJc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WjnEbo/sSMoFOTjPWuYA9dRgyjE+By+FcoEYCAkApjEmtDfamVQQi4GzCFvvvuJBjU4W0+QjmuRznE5YUcYgXsCb4Nm18I2ZEC3J4FhEcI6q//2PK1LhXMPciZ86iiflDogYKKr49C53tvF0xyEzXzoYtMXyj5EdHTOPJVAh/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=KygqpHUa; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="KygqpHUa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NcEHhzc7KlhpD/55xsrZL+At8Q6ySDc5lAbroXbhSJc=; b=KygqpHUa4bhmNQAafNAeVHyoZ2
	cZfHMkRXgNf2n4skzTbghbiPivhPlIECW7UkMyga4DUVl42MyxvU6tVjnW7JhpoE7qyUQW7Zjiv8e
	7AIWr16vVCz9P1L1g0BitlW4XayJvJZ7iPkgt50m+Lp3NdsjL/t9MsUUxq/P9MDCRyZv80L1EJVr0
	CfKjdmrI/GowO8yKNx4o/IfQPmBTWtgIasJlEqNmjI5BR4vRaYDF6OOljf/PrL7MAZBe+aoTRCqxK
	LdwYA/j657ONv2VAl0XeUTEqVPqN3/ok4MDUHmAisQLZP4HTR1HewPfRlxTNaz5deBCMieaCMBQEe
	D6SSsLUw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPXD-000000004fn-3SCX;
	Wed, 26 Aug 2026 23:08:07 -0300
Message-ID: <8787607f97072dee304251cd2fd7ba34@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 2/7] smb/client: validate new EOF for zero range
In-Reply-To: <20260823151053.935889-3-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-3-huiwen.he@linux.dev>
Date: Wed, 26 Aug 2026 23:08:07 -0300
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
> When FALLOC_FL_ZERO_RANGE is used without FALLOC_FL_KEEP_SIZE,
> smb3_zero_range() may extend EOF without checking RLIMIT_FSIZE, allowing
> the file to grow beyond the caller's file-size limit.
>
> Fix this by calling inode_newsize_ok() before sending the zero-range
> request when the operation would extend EOF.
> ...

Applied.
