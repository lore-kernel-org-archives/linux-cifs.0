Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08395A3D;
	Thu, 22 Aug 2024 00:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724285566; cv=none; b=LljCxhC+Uqi/j6lfXs89rWofDdNiWrfW+1RKTCxi2mWz3SnlLsk/AQxqEaJDrqJS3Iuh4pkCYZTuy80tXT1rDdlqKCG45ESN7eYZDMBgxU31ZU2B5tTb5M5zw0mzcNMsCDPniCdvd/ct6CBZFmE+MyKVwXS+QKlrRz7jFH6XWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724285566; c=relaxed/simple;
	bh=Ud4moU3QYM2bHeBXVBUdNcNDYZW8LF+EK7m2J6EUFF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IDV+mqDjViLXlJtuFGy5ad6otWNii3RMs31Ch0OGYxe3YknrbDLND08yLIili9QAzeAAjHE1vdrW7Cu4kKJ7IfFnZyjG79z5HYexkp0EiFdCFh7p5cPj5GmHUd5XXm8smzpX+9rYlDbgUAQjEgjz9zfPlqZB7A/uweulmLlLAOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp85t1724285439t7bcq2yp
X-QQ-Originating-IP: 9bGwgY72Esq4vV0rTdYXEbCPnDYoyaMQUcxwONISsNc=
Received: from [192.168.3.223] ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 08:10:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3488548595379999423
Message-ID: <E4D68FE9C7D5C471+9fd2d656-df0c-4cdf-8ed3-d5096420ed09@chenxiaosong.com>
Date: Thu, 22 Aug 2024 08:10:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] smb/client: fix typo: STATUS_MCA_OCCURED ->
 STATUS_MCA_OCCURRED
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn,
 liuyun01@kylinos.cn
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
 <20240820143319.274033-8-chenxiaosong@chenxiaosong.com>
 <CAKYAXd_XWf33rCHMh8AjhXKZEdvcRS-xXew9FDeitExNaezW2g@mail.gmail.com>
Content-Language: en-US
From: chenxiaosong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_XWf33rCHMh8AjhXKZEdvcRS-xXew9FDeitExNaezW2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

Thanks, yes, it is not typo, I will send v2 patchset soon.

On 2024/8/22 07:57, Namjae Jeon wrote:
> On Tue, Aug 20, 2024 at 11:35 PM <chenxiaosong@chenxiaosong.com> wrote:
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Preparation for moving the SMB2 Status code definitions to a common
>> header file.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> STATUS_MCA_OCCURED is not a typo.
> Please check microsoft's header definition :
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-erref/596a1078-e883-4972-9bbc-49e60bebca55
>
> Thanks.
>

