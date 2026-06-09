Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94352690F9
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 01:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968415; cv=none; b=O+ZW1pZrpqZ1x+fJ/+MY0hjfMcFeB8VlDzvSB84PlWMogpSfT8MzD3eMSscXhDsr0xlLuXrjkXBx3ClkQ4VLtSIrcD7DTznDzqAE8Rp9ZCitMvVOvg+FIHeUNh4K6nEcmam6Z0mmFiJL8Tgfq0DaY4iYeWGLraLjpJCd5+1yCVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968415; c=relaxed/simple;
	bh=vY7AY5eBrZnqWIFxapw5tbAtPAvCHTkCPx2K2CKSnLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bh1TmoTDLIPZ4qpmXYVX8itHMYj63hqaBtolwGZ5eg2Kr7KnuoOMOVBlJqam19zWgp7xRtgSDc3pqc/WDp2BkKip5zkrTyJ+8us5zgMAeYnfABwYbGXEKCrkRA/P9BQoFR/38l0qXEr5ycKUAdrYccOky3kzOwlaka/N98e6ICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=CpL7gFcB; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="CpL7gFcB"
Message-ID: <ad83865a-6890-4a6e-8805-48bd356cabf6@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780968409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ykVQ99pF4znnSkMnfSNW9ZXq2SLesGNMbiALFdFh3I=;
	b=CpL7gFcBXJkucCLZ/4cgcpIrIiQlQYm6cJXdl8IgmE5NxS+fWztKFmyxlvJpR7QI++mqP+
	5ZQEgyuYKjw+XyeZZ9QFboG4kEQ9euykNhdS36wG0MPwECE6sefzsAQItJWVvJlEcmyQOp
	0VB5KjxaR3mB788x6xhtSyHIlgAEAiSiTlSiRn5yCZrcjdaued+qZLBTPU4hiQO71kOWAt
	pe5a6jArqpuH9U/00BfgrxBzPQ+n3Lb1hymip1URpNykkIfuXxD5uHzu15YK+YUxnAF85X
	Wdz/5jceZuIXO0BHBMrS8H7dhzxq82O3HWtIkSbBM7jFE+UmwSzr5DGua+siaw==
Date: Tue, 9 Jun 2026 09:25:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 7/7] smb/server: fix incorrect file size in
 get_file_compression_info()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
 <20260608140128.387844-8-chenxiaosong@chenxiaosong.com>
 <CAKYAXd9JGDYJvtO3fZcjLh_qY3bs198BYW4ijYaHsgZDFF9eCA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9JGDYJvtO3fZcjLh_qY3bs198BYW4ijYaHsgZDFF9eCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

It seems that the actual compressed size is filesystem-specific. I 
haven't found any generic kernel interface that can get the actual 
compressed size. Namjae, do you have any better ideas or suggestions?

However, `stat.blocks << 9` is definitely not the actual compressed size.

On 6/9/26 08:31, Namjae Jeon wrote:
>> -       file_info->CompressedFileSize = cpu_to_le64(stat.blocks << 9);
>> +       file_info->CompressedFileSize = cpu_to_le64(stat.size);
> We should return the number of bytes allocated to the actual disk
> after compression. Is stat.size the actual compressed size?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

