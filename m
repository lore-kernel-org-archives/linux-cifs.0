Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1E33594F
	for <linux-cifs@vger.kernel.org>; Sat,  1 Nov 2025 00:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761955560; cv=none; b=ryJId16Wjh2davV9FpXLNvLBYG3uCdKc0r08irs/F7KF5lY331rmeJ+KiWXal+nixt5DH7imeqmhf9xn0ulALY/uEbtNlimAAoJgMb7bMR0tQymzXJMIZjCuwrUmiIstLiFmykp62In8klFuCWjCZBb9r4AiQeV2CtZ+jQBxBPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761955560; c=relaxed/simple;
	bh=f5/8LpE4wqq613f6QTFx58QsWVFSfr6ZnH19GC1Nz5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NziPZdpDV4mDS1QIn6dQ5+K/icnTeikrYANUkOJ5rwrg4HH7IyfviC8BIw/5wwhCOFn2rim+Ll/hQHSGR8wnHiYZU0mUxq9/l8ljYYJdhZ+Qmpo+MHKHDbK8maFlvDNysTnQe/eqIg36Q73DF6jrGR7m7q1bqDYVq98ZalAjcuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HeHmZJGP; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HeHmZJGP"
Message-ID: <63eb1d4e-b606-4776-a0cd-d41c6bdc60be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761955545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hFJOcK6O2D2uXFqMv8li+0aym3JFnVeRftKtiihgkcg=;
	b=HeHmZJGP0mzqI7SEFrX0We401IVA5sL8MApekQAGtWE9U85jFbqPaND1ZZqTNYpD2chxd0
	rMOH0+MqSE3xoU/yDE4HusgomrrkyIWkp5ee5tdsqT3H8c2yq1I39uvP+/zGhUz18ApTtQ
	YS/nBjMl1ShJC45HJknDNgzNJpsRemY=
Date: Sat, 1 Nov 2025 08:05:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/6] smb/server: fix return value of smb2_notify()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251017084610.3085644-3-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-DxRTEu65-YKwXw8jA478jmgQAtOUNR66Tjb+czxp=xw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-DxRTEu65-YKwXw8jA478jmgQAtOUNR66Tjb+czxp=xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

I’m referring to the userspace samba code and trying to implement this 
feature.

Thanks,
ChenXiaoSong.

On 11/1/25 7:56 AM, Namjae Jeon wrote:
> On Fri, Oct 17, 2025 at 5:47 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> smb2_notify() should return error code when an error occurs,
>> __process_request() will print the error messages.
>>
>> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
>> in the future.
> Do you have any plans to implement SMB2 CHANGE_NOTIFY?
> Thanks.

