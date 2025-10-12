Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC1F4C85;
	Sun, 12 Oct 2025 22:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760309951; cv=none; b=TeEbK5UckIgqYDnOPfUgoJT4M5umTl2lBD1vsgRc1iJEJAkKI0Rp39p2JpFqHsE5ug0YgFh33wpiKpQZVquWi9xCdKxwc9HXD78C+nY8p77qKjs0JTSknmGEf6Cf2Kf9jYS4yizSi/xYCHo2pXa/ndzyhEmi9OLg18basT0fV4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760309951; c=relaxed/simple;
	bh=O9/xMq/WsWwt6BhdaZP+0IQk2PmNkJ/e+71vzrgkOOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vq26vVTZ+pWb87vqkdiBCtU+aFlbiCL8nDfGhpxlVlOtNVbY1pwJgSN39rkrb+jgYEqVsmWj7WVvZr7JwTg0R6FpGVdOcXao6tLIJANfthCCDfr4tjGtBW2XtET4TKQ/a4PRdwUZiVoamPerXCw42qLqDeyxBKSWMCqrD9mvKYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760309901tf1369bb2
X-QQ-Originating-IP: MvtMcZy8FSuveoXRjmYKGRWu3Gd3/PHMHPUpYLPI0AU=
Received: from [192.168.3.223] ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 06:58:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15561149925438105871
Message-ID: <56E522C05F8E6468+9e555719-8b1e-47a6-8d60-b6a7e89fd91b@chenxiaosong.com>
Date: Mon, 13 Oct 2025 06:58:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 linkinjeon@kernel.org, smfrench@gmail.com, sfrench@samba.org,
 senozhatsky@chromium.org, tom@talpey.com, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
 <66942D4891D3E571+20251012161749.2994033-7-chenxiaosong@chenxiaosong.com>
 <bd7b1078-4e58-4403-97e3-ac3a4765c51a@wanadoo.fr>
Content-Language: en-US
From: chenxiaosong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <bd7b1078-4e58-4403-97e3-ac3a4765c51a@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M6HsUa4FHJpkREuH6gKmoKadHC2GeyeFVXQD1ZZH1o0+wu4TWXSYuyeu
	ShYRK44jqH5ITPzFw+F1jfvbMLgCf4HV8eE9IOEO8YC5BbdodOqn/pugq2C6zBujiWoEZ1R
	Me5eXtGs/SYwceMKT1GHenumWgq4W0LxRnOEPNyoXEfK4ZNptRjvmvejtrkayM6Ad5mQDEy
	FyNHNFS2u88okb6w1lJ4VAKtfQJKp4vdQv/1itBh/ZwuCuRbuJP1RexlSGNa7xrKU4wvdFi
	WDJYNw3GsCr7S3fT1ejoVohnz33MQFpWq3lHggFjXAye1kraDBSC+T7WUBjcntyet7NgYm8
	fSFkN5+HLgap79ahWQ2s6w2aQtIH3tXXdgPQ4ADZmmtU4B6AYOChV+8byErfPsE8I+UBigI
	4QuBk1WdH9+Mmdo2NqYgK1z/dubhgLtc4hZEe3cSpoPlEmxtPUMWcWB1o+7XjROvzqqM/lT
	4rnlAc8NVkpRaeI/wmJaEuW8hegQ/01InAZsWzpF4Z6GwVM8F313H5QEyxQ/tNtjIaQcgiC
	AEOhQHLIfv/in+Q828wE0W65IVdhobR3AarRvrkgAy3z1CYFe/69mFF5pj6qQcMjg1fF1Tt
	UyxOV0L/1TeN+rABwz+Yb7l11NZ7riAUxWscAXvKjjJa7xduRV3WV3YQPNeJJVZTOIxuJcD
	U4NapQa9K7mF++tj6XKQZZnraBp6lF1sDyyj6SLxPylHVlMVn+FfqZZNCqRaGBFNfPsfL3k
	LfE+ARi7nMmDKVcJFzd7DS2vE+R76y6nsLlezcY+/8qOGJaYXTrKVdsxc2FIYtQDitChdhP
	VuR01US3fzHtYmzZ0xj0ucbMYOWBaFnykbn/e4PdzIUDBznwBJgDDG7X0NevXv2z0vlmIRl
	RVgYmQhDVFGxZQN5nT5NatRmun/UpNN4gaEMT9GT3B1nuLmHp4asTbcXGZw7MuSRcSS3/+1
	i7qthzjUszR31kEF/jOEp9rWJXIs0UIB8ThlZ5tu+KNGd8RRTua7By3GebhoWDRP51zZFq0
	zR7jU5dIh5mX7z9en4fnDEhYxL54SqObWlViYcSLZMwjPQLJaAPpWTNojhkCbazHrO7TUAD
	g==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

Hi Christophe,

Thank you for taking the time to review and comment. Apologies — it was 
my oversight not to list you in the "To:" of v2, and I should have used 
"Suggested-by:" rather than "Reviewed-by:".

On 2025/10/13 04:36, Christophe JAILLET wrote:
> 
> Hi,
> 
> even if I reviewed and commented on this patch, I never gave an explicit 
> R-b.
> 
> And as I'm cited in this v2, being in To: or Cc: of this updated version 
> would have been appreciated.
> 
> No hard-feeling.
> 
> CJ
> 

