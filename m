Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A30335BD5
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575145; cv=none; b=Q7WUBrS7YkMfemB6neWYBCsXatYyiAMkr6jVN3oGyhr9cgYLwrs0xfzcM2RI5P4YmYDMOxyczZBsF5i7OXHH2KWhSgWEJGV+Dqxe5oHVK5pKsHKUz77lkgjmfe7BJZPNaNqEdpag17nrnMnME7snb9ezLVR+LxZmYAo5sAlJELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575145; c=relaxed/simple;
	bh=F4abNLydaKcqRPEKAAc0gYIuhdlowtaHe1cJ5yypFWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1750lqOZViRQ6NOnQkHVacqZiPAaoLUbIFTtU1ls8KsH6pQlc6jIu7ycDdF+IzXrE1OOogtF8TxBAfxhjI2J4NaC0uromqTuue1XFKigjxrqrFt7YxoAiTb3ZOC7J9HXnTqCb8FHaXetT6S3c+vsD6LJ11IuNIQwiezR1UBPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UUFqju+R; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UUFqju+R"
Message-ID: <38a0be75-0884-4808-a840-fc9e8f2ee6a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768575141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y0iS07UhcO93opcTApL0esV4GIKBsbnOSJb13yUaHgw=;
	b=UUFqju+Rmoomph14TVysbnPY1ypFLPpSVWS8WGEzhUkR05zcjol/9y181bEj8rbBUAW07y
	ivJySxBM2nfqE3lx7X4qcnD/5C3mOgLJjr2QNgzimosyDozavdJLEs56IhxgOZ+c2siIoK
	y6c7aK0O1BORfktsa4sS+j84BrPY7qs=
Date: Fri, 16 Jan 2026 22:51:28 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/5] cifs: Autogenerate SMB2 error mapping table
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260106071507.1420900-3-chenxiaosong.chenxiaosong@linux.dev>
 <CA+5B0FOT_H1vO+9cfSbpFsUauQ_V1KM0GGKjp=+_K+z-SEWNeA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CA+5B0FOT_H1vO+9cfSbpFsUauQ_V1KM0GGKjp=+_K+z-SEWNeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In the future, when adding new elements to SMB2_ERR_LIST, we would need 
a script to reorder them, which seems difficult to maintain.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/16/26 21:48, Aurélien Aptel wrote:
> #define SMB2_ERR_LIST \
>   X(STATUS_WAIT_1, 0x00000000, -EIO, <whatever else>) \
>   X(STATUS_WAIT_2, 0x00000001, -EIO, <whatever else>) \
> ...

