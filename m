Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B85619067C
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 07:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782633140; cv=none; b=rBp1xCikOTJiRMXdHMz6Hr33vPISrbRMHBD0pjwYCWVEzRrHjJ2amJHMiW9yj6kiXPsZZoV+IkNTUUKjeEFAoRhyibhieYfk9qDx6lgprv17rL9/8PwbTHTaRxkWJoPe6m7JWhyAxSIJZV0+sH4UNodFCP9V36OYGe2Jaw/fEXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782633140; c=relaxed/simple;
	bh=h1soUnYGY+dQolL6Z3UpjNthIWytuu5ZftFJIykzq+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tb9+lvhO8L1gesDwKPu7f5jEEOUaw9ke19STpDwLInQMGFrwAl0CvHodu47lotOQgCpwbOexC6bZ+6r+PiU6KWpC/wo0+EiG+gu+IiZybk8OSmgo9fuQHR3f9/PmT/aSeeRVMVUKyKKtZOvygnAKb9nFLFD2nGi1xT9sFXARUjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RNXENx1N; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RNXENx1N"
Message-ID: <9526a947-446d-4db9-8901-6e730ff440d7@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782633126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yxGuATbpxyoep/ZktiVqqFVsgckLjpydoO3YMno0AYQ=;
	b=RNXENx1NTw6NFHpxcxL/SyagqRCOaFGL1AmSSXyQZzzel/BBXcVLRJkZBqSSlVbsZL6j8f
	kMQ0GOJjWHknlImrv2iAbCsL7qOxu6jMQQPRqZgi0WB/zBEonOEwOn4z8cov5OtI9I/UpJ
	ztMBiGSCTgTzYH/YwMvPAcC/G/Rbvc8speKgQQFT9Xk8+1uH+2Ayrs9z3jx4h7BcihiuyP
	dpw3OJ7b1/oAD5+D1S7RKunJAJjSXdNIE4N9TgxYH4d5t4AKiVyjVqolKEdpKBrVDGS+ef
	agMYN3pqnnOFhxpAomDp+wMO0quaRonCXcc/wWvFr2XT7DtcQN0QUuOmtX9cXw==
Date: Sun, 28 Jun 2026 15:51:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: do not require delete access for
 non-replacing links
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org
Cc: linux-cifs@vger.kernel.org, stable@vger.kernel.org
References: <20260628074243.629589-1-chenxiaosong@chenxiaosong.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260628074243.629589-1-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reported-by: Steve French <stfrench@microsoft.com>

在 2026/6/28 15:42, ChenXiaoSong 写道:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Reproducer:
> 
>    1. server: systemctl start ksmbd
>    2. client: mount -t cifs //${server_ip}/export /mnt
>    3. client: touch /mnt/file; ln /mnt/file /mnt/hardlink
>    4. client err log: ln: failed to create hard link 'hardlink' => 'file': Permission denied
>    5. server err log: ksmbd: no right to delete : 0x80
> 
> Fixes: 13f3942f2bf4 ("ksmbd: add per-handle permission check to FILE_LINK_INFORMATION")
> Cc: stable@vger.kernel.org
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

