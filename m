Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BD07261D
	for <linux-cifs@vger.kernel.org>; Sat,  1 Nov 2025 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761956316; cv=none; b=Ih/+CP+TL+e+phBg/ooZhDDb88rKXAc3KcT/K6ANDDs7lJQxi2Ai3poievZ2gigujzWGASdvc9RP9+OROStygO7x4VK3FNElRRWW055a0CYOLJHdmPH6qfsoQ868GHPgN6aYo/i09NiwGtiMue3oX32Fz8+nkVs8h6J9t1zS6F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761956316; c=relaxed/simple;
	bh=E2B3UWzG/CygJ2gZuQpAK6iCi/mmEa2MKTJf6U/VWTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPE5C+QIKnVBGqvHZifwWeWGnxkP1ucP/B8Df3CqLFBej2YcAEA6wm5AgUrv5VPvLI+Txp9DFxj0t/kJCJNfFzgbEof9TQEzFR1BOmQNJT8+pyAsThHTPRhcD0IQU3Z0+KVv+Fmi5NVV43WsaOX+bev0SlP30WOSqpUTB0Ph2IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qZWnFxnY; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qZWnFxnY"
Message-ID: <e01f3ed4-929b-484c-8386-857ddde8c6a5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761956302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k22FrVOeT9IaUG0qE2tC6THdJ3EOujV09TCOS3UYwR4=;
	b=qZWnFxnYZHSW3qjVFfr6L7GSxE2+KUy0dttmdYv2x4GvR9DIEII5pmZUyzpANNA65hPoXM
	UsYrBHMPLN8Um/BPb0t9XQiEP5pbjG2PLkThuZQ5IIEbCBFEBJHbK4w5TAHGH4vyGyUQDK
	FHMPdPI2y0275DC09uVSvLxX1E5SqoU=
Date: Sat, 1 Nov 2025 08:18:14 +0800
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
 <63eb1d4e-b606-4776-a0cd-d41c6bdc60be@linux.dev>
 <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

After I finish the other patchset, I'll fully focus on developing this 
feature.

Thanks,
ChenXiaoSong.

On 11/1/25 8:10 AM, Namjae Jeon wrote:
> On Sat, Nov 1, 2025 at 9:05 AM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> Hi Namjae,
> Hi ChenXiaoSong,
>>
>> I’m referring to the userspace samba code and trying to implement this
>> feature.
> Sounds great!
> There are requests from users to implement it :
> https://github.com/namjaejeon/ksmbd/issues/495#issuecomment-3473472265
> Thanks!
>>
>> Thanks,
>> ChenXiaoSong.
>>
>> On 11/1/25 7:56 AM, Namjae Jeon wrote:
>>> On Fri, Oct 17, 2025 at 5:47 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>
>>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>
>>>> smb2_notify() should return error code when an error occurs,
>>>> __process_request() will print the error messages.
>>>>
>>>> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
>>>> in the future.
>>> Do you have any plans to implement SMB2 CHANGE_NOTIFY?
>>> Thanks.
>>

