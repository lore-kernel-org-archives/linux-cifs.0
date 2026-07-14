Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F16345BD7A
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784032525; cv=none; b=Pkk8s/qXrue2s71C9pgiBZA6Et9Cotp1MG89TV1J+88muQqcbl3qWtLET2sBmkCu6bKROy/WkE7Ci6b3BCmNqWoMna7DFcZ7Zkm2ETNrjOF/2dWGJ2DrgORhQdYqsYndQpKlU+WtKvesYgM0VVp2hDIIc9ABRhiWEAjMZFVXz0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784032525; c=relaxed/simple;
	bh=Ec3+YbcSpH30JoDTpFiZFv0QYL8JiiF+s4fxHbsPcEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hhA+eUGwCjIc7mLURubIV1o4AowFQWVDgYQIgUSnOxw3JYuNtt/54XH0U0432iC7P7IkyzDoqhOxgbwPD/6Rb20pAr/tTbclpR/xUBvDE8FDRhiXTN16jAVUj45LciG+ERSd9jeXjLVKgLK39LA0B8nu0Q1F6MyYzPfpAhvB0QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Zq1h4Kly; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Zq1h4Kly"
Message-ID: <755b2ab6-8aee-49e4-89b0-a05589f0b64b@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784032516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkIZtbrULbfjGPwQkLykRWEVa7gV44FDDRYHwLR9Ejk=;
	b=Zq1h4Klygt5lxHqtO3V4beCnksARwqUhZ81ysfMb1PPhpEFMaMwviaZNbt6x392JwsJudR
	OxIJXXhuu/uOh1tAT8ywS6wIDW+0J+0zJIOLokxklQzYroN866N56Xv8nArV+SxOHPlTbA
	N0Ej3tVNgETxFRpbyad59/8F/EW64noZlHDLfrcMvfpxXx9uL8nK7HVKEXVyVDaSBL7bwh
	qWRMouzgFXxz8o4tKfIcl1/FHFtcDtnV5yYg11D5VkrDS9LzVg+t5SZOpnwrN6KJaKrB6X
	p3+HrUA4WLFP+hDdcmWvYSglvBZ+rDq++UjKe7G97FX5iBOdnBtMxko373g/nQ==
Date: Tue, 14 Jul 2026 20:35:16 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export
 symbols
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Steve French <stfrench@microsoft.com>, Youling Tang
 <tangyouling@kylinos.cn>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>
References: <20260714122120.743185-1-andriy.shevchenko@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260714122120.743185-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Andy, could you also submit a patch to update 
fs/smb/client/smb2maperror.c as well?

在 2026/7/14 20:21, Andy Shevchenko 写道:
> Replace EXPORT_SYMBOL_FOR_MODULES() with EXPORT_SYMBOL_IF_KUNIT()
> to mark the symbols as visible only if CONFIG_KUNIT is enabled.
> 
> Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
> use these marked symbols. This is the standard way for all KUnit
> tests.
> 
> Signed-off-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> ---
>   fs/smb/client/smb1maperror.c      | 24 ++++++++++++------------
>   fs/smb/client/smb1maperror_test.c |  1 +
>   2 files changed, 13 insertions(+), 12 deletions(-)

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

