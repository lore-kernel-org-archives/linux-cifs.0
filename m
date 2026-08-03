Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE043ACEFE
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785747959; cv=none; b=Rj8NisYEI7x7SMsD4HpUoR0mL5WBpkqjX6g8vRIxoVqHUS1veK/SF/YS/yAHCu/yJMRLON8Nv/cK9tpuqCNpoRX06bj5dr4ve46ZnEJPJTxWroG2capRFGOeN7DIXpOKQmGkJ6fodQ0STu3BX3GotFEdBaBq0pTNs9SfzuxfTek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785747959; c=relaxed/simple;
	bh=mxET1xrYS2V1tsV5C07D2rtWgXJVsz7uu9yO6hKIP7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ab9+oGqBsn3563RfglReBXZNXSgzSvBCPKZk9UoazIePurkSk8HLkGB17JBxUvW4pc4u+m062PsZrpaOINfnIt3DQCs4zT+RpsY3OceniFm1VBINkQQLgBOnIcQPux/6ON+hY7sEkxOfgUxExCcbLwOWmBXcB97vaqpb+yNoTGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=MhKRhtvp; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="MhKRhtvp"
Message-ID: <84836592-a0c0-4073-8f66-f101b65b21c0@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785747952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lkRQesTcBW2G0Ke6PE+JVVmq5U8Zz0J2A1s2YDUMF0M=;
	b=MhKRhtvpJ1C+/AzVWHdrnQRAKm9VIsei8TZrb1HRb/+/natHYxigxnyaMOLrIZOQqLy8iC
	OOJxpuSuzNpzXJTb1i1WU9hz/r/dAP2SUCixm6rleTOc9D1/qq2eHL8qlRxPeGMxYL79Ex
	ZnT9ZTHKORW9PXz6NnEeQ4owbk3ZYjC5THIYtFaYwSLMHnkz+Klj5rvoUEp/8yzsN4CSqq
	ufgS4dZzLup7i8HGHQTuB+Le8UPy6bVVZljRz3FMw/kkoAzfEIsgmmem7on88NYCwHLLzm
	aNayt7jkDxwyYZUWYZyy68ipoWGUBPPUiGgCaTsyec2cQmkLIOIR4pbCpeC8iA==
Date: Mon, 3 Aug 2026 17:05:00 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] smb/server: fix posix state check for directory
 rename
To: Namjae Jeon <linkinjeon@kernel.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 slow@samba.org, linux-cifs@vger.kernel.org
References: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-aWSnucKnhX=AkGu=4VJVNQuwy0xjXAFCb_SriAtOz8w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-aWSnucKnhX=AkGu=4VJVNQuwy0xjXAFCb_SriAtOz8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Agreed. Squashing them into a single patch is fine.

On 8/3/26 16:48, Namjae Jeon wrote:
> The argument-only change in 0002 patch has no standalone functional
> purpose, so there is no reason to keep it as a separate patch.
> Additionally, 0002 patch must be applied first, and applying only 0001
> patch can result in a build failure. This is another source of error
> caused by unnecessarily splitting the change. Therefore, I squashed
> the two patches into a single patch and applied it to
> #ksmbd-for-next-next.
> Thanks!

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

