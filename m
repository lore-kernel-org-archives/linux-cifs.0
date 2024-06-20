Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.67.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A1014287
	for <linux-cifs@vger.kernel.org>; Thu, 20 Jun 2024 01:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.67.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718847879; cv=none; b=JpKN5yCOHFS4mLgrspEYO/8T0r1ere5iI0XycfgJd1vhsoDqebjaaaR2ET6BRe9G4lNo/bUMAFul3FfiA8qbMehjpL6rj3PUAZkYbyLV6q+cEd36ohTsrRZHylhLYBSC0ByDFNmZ8D1RGbsipVjehVA+YJpAT0Zkyw/lWP/1S3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718847879; c=relaxed/simple;
	bh=jSbBfnFEVkBHUkb9NCpVaXYf/HDwlV39lAtQS5Vewtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5RQ8uMMrTwjoavJm5vJAuVnJY7az4LeB/ObnG8f7bkgEbjcZ1wkZSmb2fuU8jxR7qZ9Gq5N0ZNrv1PQ7WEWkZENmxbpIF4JGsfecfCGAnBkE0Y39jqqdOviiNxR7zS3TbytTQ01pjTuJKObPMgjn2FCzq5qGMC7Birp90cM6gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=114.132.67.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp84t1718847689tomiice7
X-QQ-Originating-IP: IM73d26sDbCFwrMMCr7FHKDf1VjP0fTxeWun6rBOf4w=
Received: from [192.168.3.231] ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 20 Jun 2024 09:41:27 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8005467843438064961
Message-ID: <4CBA9B648A28A133+4e64e193-72b9-456b-a399-62abda2ba7fd@chenxiaosong.com>
Date: Thu, 20 Jun 2024 09:41:27 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: remove duplicate SMB2 Oplock levels definitions
To: Namjae Jeon <linkinjeon@kernel.org>, sfrench@samba.org
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com,
 samba-technical@lists.samba.org, chenxiaosong@kylinos.cn,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn
References: <20240619161753.385508-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-V80sdH2uXoDe+xqf9N-gFYTjqWtERrB+-vH0s0NUMvw@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-V80sdH2uXoDe+xqf9N-gFYTjqWtERrB+-vH0s0NUMvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

Hi Namjae and Steve:

By the way, is there any update on the KSMBD Feature Status [1]?

Thanks,
ChenXiaoSong.

[1] 
https://github.com/torvalds/linux/blob/master/Documentation/filesystems/smb/ksmbd.rst#ksmbd-feature-status

在 2024/6/20 07:32, Namjae Jeon 写道:
> 2024년 6월 20일 (목) 오전 1:18, <chenxiaosong@chenxiaosong.com>님이 작성:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> smb/common already have SMB2 Oplock levels definitions, remove duplicate
>> definitions in server.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Applied it to #ksmbd-for-next-next.
> Thanks for your patch!
> 

