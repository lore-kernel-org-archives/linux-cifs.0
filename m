Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39911352FBA
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 07:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523156; cv=none; b=YTIXpwAek62H+U6lCvmNZP+R/66U1C1e0WoQRPC0loXH6qtNDSsyH39yR9taZ9R6/3rjnHFvBDa1yQksQhdpQGBvfvbrwIoFINhpt8cjK8F4+hsp24vf0VbSN7Yml6Ea/MZihMom56JJPJKFRr+tYFdY8zdn+4pQGCrr0xjr1nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523156; c=relaxed/simple;
	bh=QgDURLHMJq1X/7PHnFLEwgyQGcx4aHUQgDbnik7U/xI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lA7ck9B5335GrCeKGThS6zGGyK7Q9IQc1DUBhRxIN0B6UF7s+qQxD1INdWbly+BdTaFE6o9sEfcOAa8aKMypIB1+tsKAW25wYO0n9G0SfghEjDl90/iJDJ1aCC2FlMZiHKKyXZWdeJzfCDv9tdoZEajpGGhyJi9RB54cmwwpMUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=FeCmMhJR; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="FeCmMhJR"
Message-ID: <87181afa-553a-475c-8f08-3c292ba30ffb@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772523149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVPyLe/gw81ykSP1mGqm0Yu6IFSMQ37cIPuUS7wyQ3k=;
	b=FeCmMhJRlr+fGwB9WHktQWZA9Df236TPgbYWhsFp6lXnhnl/oCT+a8558WCu+pcLwDcpEI
	5057hp+Vd4A14vXIyyAHcBfFS72kfEgZCRQ2LglTGaLd/oigG+eDm5ye2OJH/S4a0XyLqi
	eQoWj9xP5xTEcas/3eJywOarpT/Mb1xX/wspOkSxGc1GBA7YG7bZp9b/DrY4fib2SgGZ5F
	Vi78fPyKxzXuAZIvLdot7miL1ggap8RW1XDXGV6qgVGV4pSprl0hkL4y+KfBsAt6r5pMkY
	1zoip+rm2Qaedr87rwDTDTiznQjrbhRg7SvnDGNhKhmcb7mWoWw4zSqGz0wUpA==
Date: Tue, 3 Mar 2026 15:31:36 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/5] smb: introduce struct file_posix_info
To: ZhangGuoDong <zhang.guodong@linux.dev>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260225041100.707468-1-zhang.guodong@linux.dev>
 <20260225041100.707468-6-zhang.guodong@linux.dev>
 <CAKYAXd8ieg2fvYOK0BwBG8bbT18d9Z2A43-XoC21a5DArwsJKw@mail.gmail.com>
 <b257491a-e821-4b2a-8465-1aa1102d35b9@linux.dev>
 <09cb6f53-e5e1-4b42-9b25-b28860fe2a9e@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <09cb6f53-e5e1-4b42-9b25-b28860fe2a9e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

How about merging the two flexible array members and naming it 
`sids_and_name[]`?

在 2026/3/3 11:00, ZhangGuoDong 写道:
> And we cannot use `SidBuffer[32]` because the size of `SidBuffer[]` on 
> the client side is not necessarily 32.
> 
> 在 2026/3/3 10:41, ZhangGuoDong 写道:
>> Hi Namjae,
>>
>> C structure cannot have two flexible array members.
>>
>> If we make `Sids[]` a flexible array member, then there cannot be any 
>> members after it. However, this structure still has `filenamelength` 
>> and `filename[]` after it. And `filename[]` is also a flexible array 
>> member.
>>
>> Do you have any suggestions for this?
>>
>> 在 2026/2/27 12:37, Namjae Jeon 写道:
>>> You need to add Sids[] flex array here.
>>>> +       // var sized owner SID
>>>> +       // var sized group SID
>>>> +       /* end of POSIX Create Context Response */
>>>> +       // le32 filenamelength
>>>> +       // u8 filename[]
>>>> +} __packed;
>>
> 

-- 
Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

