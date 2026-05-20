Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF8F376A01
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 11:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779274983; cv=none; b=dM8GVlmFrTeO+ttBP4xGi0OBE/bRYVlgAgMLZr67i1wOWe0Mrc+PpcyaddDbkPq9e6UCn8PuwbxSjvfpcBMxC92EEeZyIidkk0LYfrvBzj4ACVMQx9zPGaVUKycMvxP1TY7TXVFJvWweOR9jqPovKQe9xK7p8d+jqmMpvrxMubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779274983; c=relaxed/simple;
	bh=VNMEDqqkhxu7ItirhI9fB7z4U2vSbis0hlfZQuhZymA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m2eeR5756/HA5MFuKP7ka0Xr2BLWtR4bYWcPmB7VjEiMzZupgLnTPLlYvU+mPv25e7yF9c+Wpazt8Qn3Y67OoiaePioPl3ofa0hyUJnlZwJ6i9lsNAMfhBV3OsfNXjPuI8COTylwSj9LfHQ91ZANv744lqlwb3MhHnuvhdEIeHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=fFDFixpr; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="fFDFixpr"
Message-ID: <a0992f9e-179d-469f-8f10-62d17c6f160d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779274977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4fHb5s0tcLitiad2ym+klpJuciTk78PpTqgOnb/aos=;
	b=fFDFixprjHt+G3jY7xb2cVJkoduqlxbQ/hvFg2sx6qWmEkZzB3t5acAKM2Qn1gqVzskUFn
	WGPmNUKde7iqCAiI7ZFKhfSV+MK8mg9p4Gzu5CUlrWsxD6NcBrOgA4lsYMkm7d7i80IpR8
	kHRh5x0HcQhBtRJWNRnWWActzSW03Lg/1bdZ6WbjB41N0yhmijo/hO2t8xgZ5oVRLTCLTd
	2Vi/nAy0bw/3jXp3CCNlYNU3qByuS7+u1Sx/L8o3kig46s6qYkCyJbsn4jzZnnRv0YNuQQ
	E0buLhd+4kmefgmriS0OX2zClt6VT+hSD+KLINDR3uX9I9LhxtZIpynpW1kNNg==
Date: Wed, 20 May 2026 19:02:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: Stefan Metzmacher <metze@samba.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <0cedd361-1774-442e-8196-a9fcd881531b@samba.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <0cedd361-1774-442e-8196-a9fcd881531b@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Thanks for your review. After cancel notify succeeds, 
`cli_notify_recv()` seems to return `NT_STATUS_OK`.

On 2026/5/20 18:25, Stefan Metzmacher wrote:
> I think here we should check for NT_STATUS_CANCELLED.
> 
> And sig_state.cancelled should be checked before the next cli_notify_send
