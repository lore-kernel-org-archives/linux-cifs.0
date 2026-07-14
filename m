Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCFD47DF88
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784038044; cv=none; b=lRmqD8x3k5NBsxD3L+LpHIBH6LBC78iqXeEdlXdmQz1s6Ee5huPkI972fsLAzWGgBJq0Y45qXeLwEzqDHerkBsvYJpVfWkXA9ckHEmVYUcmlpfpPuSBl7W2I0djigWUfgiGELbIMCJYnjIXdfmFvdWE+l2wQeYKoO37VA7i2sIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784038044; c=relaxed/simple;
	bh=v4qriFRrFYY1UfQsY40nHjIUo6IsgZmd2DvJbtLJRKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bFDkc3YKfMB3u/9HTkd970mZ4mTzvMNQSwNexbejzF3RgSpoKyIH9Zja4Ly0kWrEdj1nKOiqZbyY64VvYoNtwiWhi+ttQe0RjF9ummLcB0rATw1eXUreDv2hx1r77Siipob9aCnCnLcRHFJjpmPKi7EKK3Va86BSM9Dq/LxJuyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Q0nd8Caj; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Q0nd8Caj"
Message-ID: <d9053c4a-e7a3-48a6-a806-56d6c05290ab@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784038027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nMjMZl9xoaLYaWrx88avNlza65vK2bBkso1PKbSLA+U=;
	b=Q0nd8CajuuqCQiCOzP9fDwlWqL6WbTmk43gJwDeW9451hSLqDyP7qJJ9Ace6QgxSM0Au0R
	8SBzpLZN/+t9ubDkR4/7Apg3zM23oWU21ZC4teb3YtF4Py6jkzlyEVn+6ifvdjYUFRZCTf
	opFMZXO29pHK7OpExreW3prfUt1KmO3WT8nGr2jwdnS6FaD0e4sYOopcxkiYOGVL5f1Llh
	akti44dKn3I5YiJc1aBSboZuG9HERtt4wBKWrd/mJjZKvnosh4kinPHQCQaW78vbcJrTF3
	34qFvetA4CnBFR1IV2gxX5KUruzavbsK0QwGL6mNMqRGXph5orvmRfyzP7Pfzg==
Date: Tue, 14 Jul 2026 22:07:00 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export
 symbols in SMB2
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Steve French <stfrench@microsoft.com>, ChenXiaoSong
 <chenxiaosong@kylinos.cn>, David Howells <dhowells@redhat.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>
References: <20260714135333.813314-1-andriy.shevchenko@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260714135333.813314-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

在 2026/7/14 21:53, Andy Shevchenko 写道:
> Replace EXPORT_SYMBOL_FOR_MODULES() with EXPORT_SYMBOL_IF_KUNIT()
> to mark the symbols as visible only if CONFIG_KUNIT is enabled.
> 
> Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
> use these marked symbols. This is the standard way for all KUnit
> tests.
> 
> Signed-off-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> ---
>   fs/smb/client/smb2maperror.c      | 12 ++++++------
>   fs/smb/client/smb2maperror_test.c |  1 +
>   2 files changed, 7 insertions(+), 6 deletions(-)

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

