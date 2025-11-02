Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976401397
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 03:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762052469; cv=none; b=OcY7zhjPjKtwnWBYjEfUc6dMp5wHB/v4KJTzTi0lI2BXnEfc0q8U82c+rcThuJnSvqSYjVTaqSbTAOXL3fn5l6ut4DNhpTTFMx0KppCIO+PrwK4kpK2ChaOev+kOnIUsZmIVsxiicIoiEvTV7hzkksrVAZ34KVlc7tuZJvOzmA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762052469; c=relaxed/simple;
	bh=IQPlxWK2SiCYHp3ozQZ0AHeaXF3prwFijLEBBh82vT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RfzggxIAyFN597gbEO8BI8kLiq/L+NSDpi0n/XC8wqLFnItPdnjzTsm3VYkY+i/Qy0eUsW383bJg4Au/+mZxxfMuZ2bs2hvGdLjvIwDHxd2syTdplAuWVBqyJj0FFMbhwgdIR/4bG6rlp+W5mty4jo9I2TO0Jl24hf/fJRkZ9fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 27988c6cb79811f0a38c85956e01ac42-20251102
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:14a2a488-7914-4b8b-a08d-53dd174efb49,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:11
X-CID-INFO: VERSION:1.3.6,REQID:14a2a488-7914-4b8b-a08d-53dd174efb49,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:re
	lease,TS:11
X-CID-META: VersionHash:a9d874c,CLOUDID:fe36ae48f8e0976b8a2f7cc453af3b6f,BulkI
	D:251101080553FTFBUHBO,BulkQuantity:3,Recheck:0,SF:19|38|64|66|72|78|80|81
	|82|83|102|841,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:1,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 27988c6cb79811f0a38c85956e01ac42-20251102
X-User: chenxiaosong@kylinos.cn
Received: from [192.168.0.101] [(220.202.230.216)] by mailgw.kylinos.cn
	(envelope-from <chenxiaosong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1064133614; Sun, 02 Nov 2025 11:00:57 +0800
Message-ID: <72b98be3-c8aa-46ec-aa08-7687b9ee0209@kylinos.cn>
Date: Sun, 2 Nov 2025 11:00:54 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] smb/server: fix return value of smb2_notify()
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251017084610.3085644-3-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-DxRTEu65-YKwXw8jA478jmgQAtOUNR66Tjb+czxp=xw@mail.gmail.com>
 <63eb1d4e-b606-4776-a0cd-d41c6bdc60be@linux.dev>
 <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
 <CAH2r5mttHJfMTEc7xS56va-WDohXQ3DfuYKq0OFWgFiGEQHoGQ@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@kylinos.cn>
In-Reply-To: <CAH2r5mttHJfMTEc7xS56va-WDohXQ3DfuYKq0OFWgFiGEQHoGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I will also try to work on improvements for the client. This will be 
very interesting and very useful.

Good news: next year I will be able to fully focus on SMB development.

Thanks,
ChenXiaoSong.

On 11/2/25 10:52 AM, Steve French wrote:
> I am also very interested in the work to improve the VFS to allow
> filesystems, especially cifs.ko (client) to support change notify
> (without having to use the ioctl or smb client specific tool, smbinfo
> etc).  It will be very useful
> 
> On Fri, Oct 31, 2025 at 7:10 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> On Sat, Nov 1, 2025 at 9:05 AM ChenXiaoSong
>> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>
>>> Hi Namjae,
>> Hi ChenXiaoSong,
>>>
>>> I’m referring to the userspace samba code and trying to implement this
>>> feature.
>> Sounds great!
>> There are requests from users to implement it :
>> https://github.com/namjaejeon/ksmbd/issues/495#issuecomment-3473472265
>> Thanks!
>>>
>>> Thanks,
>>> ChenXiaoSong.
>>>
>>> On 11/1/25 7:56 AM, Namjae Jeon wrote:
>>>> On Fri, Oct 17, 2025 at 5:47 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>>
>>>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>>
>>>>> smb2_notify() should return error code when an error occurs,
>>>>> __process_request() will print the error messages.
>>>>>
>>>>> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
>>>>> in the future.
>>>> Do you have any plans to implement SMB2 CHANGE_NOTIFY?
>>>> Thanks.
>>>
> 
> 
> 

