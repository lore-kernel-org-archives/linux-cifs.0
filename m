Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDED480DED
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 15:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128941; cv=none; b=QXetYhkr12wUgm32HdbhcguuVXG0AvuSg7uiUy9Rq3qJS9n2cE1ChcsJGRTJDDOXPE768f/Ho5NjL19rRAxSkIgsoZlsBnWa4K/NLrM/2Rtxy7LiPR0c5OsoIz60CIb5aF99ZGH4cAy6aD9k4X6lVZNWfCYFr2trS7WnQHtInz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128941; c=relaxed/simple;
	bh=xk6a94Qp22bv/p3ihS+y64AG0dLZ++bLvLtPcw1yJY4=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:To:From:
	 In-Reply-To:Content-Type; b=oDxoxTnSVQsW4AgE3jVct36XQODO2vuURYP4zbeHFRh6WPq0aZm6u5XRS44yrMEPnKOH/04EUiql972vqCwEAB16+9983N9BsZV1cjegoUHgLd4gMlPXnjRsAZVJ3k6FdN7q1Hp2TsEsGt8K8KfP4chTBNXOdHlgFxA6/CE3fTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ZJYM49Lv; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ZJYM49Lv"
Message-ID: <73f4bc4e-3bdc-4bf2-b145-c9b6fc480451@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784128935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lMrpeHkCJR2kZ4SVdRW/s7XnStJh128BkknZf6umg0=;
	b=ZJYM49Lv7PS1ujCEQyNcA7STHcmXoktKQAZfzrE1LkeshyCYab9TIJksP6xnJhURqQtOig
	Sn1xufCfDAd5mX5Rx1VrWc65P3ml9Yqmfqk4tWuF/J6CTIi8vqZj0eharthIZl6Edr9Mak
	XykGJfWiFn5PYaFW5Dlrz6ZxFObvDRjr8EijOdgNFwaWKiFSjOk9iM8lYTx5cHRyUNF4/T
	VNk+WL13i82sJepYPzJ7YXoAQLM3bEffxGQHpDLCHzuv0X4jKxNw22P2voSn03xJXk8Jcn
	sqnmVvtg2U9/kTu2AUweE2LiRIadqeIQKMXo73V5ZVB1Nm8GJa/4E+r0y/pB0A==
Date: Wed, 15 Jul 2026 23:22:29 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] smb/server: fix some bugs in preparation for change
 notify support
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, andriy.shevchenko@linux.intel.com
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Gaël,

Could you update your patch "ksmbd: defer CHANGE_NOTIFY completion 
instead of STATUS_NOT_IMPLEMENTED" so that my remaining notify feature 
patches can be rebased on top of it?

https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/

在 2026/7/15 21:55, ChenXiaoSong 写道:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> I have implemented the ksmbd change notify feature, please see the following GitHub link (some minor changes are also needed):
> https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/
> 
> However, to make this feature work properly, some pre-existing bugs need to be fixed first.
> 
> ChenXiaoSong (3):
>    smb/server: fix signing when a response uses more than one iov
>    smb/server: cancel async requests when closing connection
>    smb/server: stop new async work when closing connection
> 
>   fs/smb/server/connection.c | 21 +++++++++++
>   fs/smb/server/smb2pdu.c    | 76 ++++++++++++++++++++++++++------------
>   2 files changed, 74 insertions(+), 23 deletions(-)
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

