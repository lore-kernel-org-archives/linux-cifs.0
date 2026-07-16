Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665733ACF1B
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 23:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245395; cv=none; b=E9nlOWqiagZ8WtA+x5Vm1ZKlEX5mSPFdYlogH9GVipSoewoFuptBhiX8IlpFg8Lq8MYilBAAx8jwEczLGqdIZQ132yNaSViHjrBXX146yOFCtyemPyT0xKMDQDZZsnZvkepCodacjO2VVkrG4NU943x7m3RQr4Muv7pLseGwf90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245395; c=relaxed/simple;
	bh=Cwe0zB8RX9jcCe5vLUMuUagCfikMSAytAmr6bv02UEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LQ/ZsuRHXdtJxr8MVXO3oLF5rGZdkjSolHYK0lQoqceOHzPfsg+OVSq5IkIpcIkkMkAVSQ3GLDvjnJNuOb5CbXci6SpMshvLfZt6xJk6qnL+aRqz+086JtfPUalY4phSjZBLwEh0HxcA5rpEnSDuLBdtiMiE7A9oRHRk6Z0ybKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=f8dXWLtM; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="f8dXWLtM"
Message-ID: <7d806e83-2535-433d-8aa3-f8b452ecbb83@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784245389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6JAQ5MlnKsZb3cPFrd6OjXzLLbdX7ZbH6LwjRbylG4=;
	b=f8dXWLtMSbFlk0Crwuyx1XTrliVpM415zvJXe9b4DMUX5kBU6hGK1QEguAYGan23llxn2T
	hWkMJg4v86BcmaCSFIMbcda3cAQ/Sdrxu3RiA775/judACT1kn9PHjFLnUFVcuha2+lHtB
	yyB/xi8sj7sAWLBj185HLOIgh9Kd7OvNntTnH+p7a6/eUWGaUSp1wvWhhYlOp6SOCHwJYk
	gsIzLc25OD0zteVPfrPKmtiXwTD16UCS41uOgtfqgGnxSd6SRIb5gRM3CcKrIwTwnxoDbj
	C3b9ZXre8G98CjkJIGyxGezKOACNS9uMEDbr7r8KXYRVA85ShJvYW7uH+Qw3dw==
Date: Fri, 17 Jul 2026 07:43:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] smb/server: fix signing when a response uses more
 than one iov
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, gael.blivet@gmail.com, linux-cifs@vger.kernel.org
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
 <20260716001156.671587-2-chenxiaosong@chenxiaosong.com>
 <alk9-WOWQeHaq0wV@ashevche-desk.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <alk9-WOWQeHaq0wV@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The warning is triggered only when invalid arguments are passed.

在 2026/7/17 4:24, Andy Shevchenko 写道:
>> +	WARN_ON_ONCE(work->iov_idx < 1 ||
>> +		     work->iov[work->iov_idx].iov_base != hdr);
> The second part of this check is basically always true. What's the point?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

