Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4985622A1D5
	for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760875028; cv=none; b=fqsLmH3O9rb1ZD9a19BSL2xydV1+oFSCmSvPTMta6LM/8//KGDa96fNyh+xNR1FVc084JGuzjvXgYlGGQwcpLiLMsurzzbWUmWZrq+n1Q8IzJBThgDjrxMYQbnAXUdvUwnr51kz/cYMf3h65z1tKHtGbocpvgq826Vsd90joIOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760875028; c=relaxed/simple;
	bh=51pn86PN3q/U9/Rn7p4SrVjJixfchw/ObHxdns75EEY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OvuAirsYE+YVOnFK4++QKqpg4Kz1vCCR6+pYAjxDjkOiF7pNEQxmt8UaPntQOQNFvmFLzjvzLR47cu7QYNNSxJuFjeoP7RuBM68SXNgI0bxZNZMEHT1bwTb6sQ92Qq5lIu6DNnroTd/YfsfXay9Swhb+a6bWhc0jb0S4Ro/RxNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cUmX1Kag; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cUmX1Kag"
Message-ID: <03707213-395c-4b3f-bf6d-3aca392a8ec1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760875012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1ZbyeSiI8Nsia35zQRYjhz4FRJX3O13AYqEy6MW+M0=;
	b=cUmX1KaggKs/AUb6dyCXG7StXh/eHZYBENcIoJRIF71DwYqy/s5KIOfcyDUPtoS0RSq9hi
	NTTToCWFFsVtpFzJRpsSoaKPjelJzPTttz1zaYIvhTIz2RgxHf9HT9eCD8lP+C1LkZZlJY
	x2Pa6Jd9BDX4/4ISuJ2vXSf2kpTXFvg=
Date: Sun, 19 Oct 2025 19:56:45 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [v2 1/6] smb/server: fix return value of smb2_read()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Namjae Jeon <linkinjeon@samba.org>, sfrench@samba.org,
 Markus Elfring <Markus.Elfring@web.de>
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251017104613.3094031-2-chenxiaosong.chenxiaosong@linux.dev>
 <d3950582-2e2b-43b9-a86f-8e1d1b48ac30@web.de>
 <CAH2r5mt4X4+k89t9CSqxuF55jooOt=X-BMB9AGR+e9WNEh6Y0g@mail.gmail.com>
 <cc22c66e-9ecb-4aa4-9b38-bd148820269c@web.de>
 <CAH2r5mtiAy7h__rFd9mP-jutx38C9JSpPOPhn9ngqsezeX4_4g@mail.gmail.com>
 <8d9ab96f-b7cf-4ebb-9a1b-4b0f2b94461f@web.de>
 <CAH2r5mvx5+zQwhFRz-_dMmxYDX4PDzY5X9WGEd0M1Xf73bRyLA@mail.gmail.com>
 <3d3fe6c0-b05e-4e36-8b02-0fc16438c781@linux.dev>
Content-Language: en-US
In-Reply-To: <3d3fe6c0-b05e-4e36-8b02-0fc16438c781@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve and Namjae,

The "Fixes:" tags of the first five patches in this patchset are the same:

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")

Thanks,
ChenXiaoSong.

On 10/19/25 7:13 PM, ChenXiaoSong wrote:
> Hi Steve and Markus,
> 
> Sorry for the late reply, I’ve been ill and sleeping a lot, so I only 
> just saw your emails.
> 
> Steve, thank you for your understanding of Chinese naming tradition.
> 
> Markus, thank you too for your other suggestions (such as the suggestion 
> of adding a "Fixes:" tag).
> 
> I am Chinese, and my Chinese name is "陈孝松", the pinyin is 
> "ChenXiaoSong". The first word is my family name, the second indicates 
> my generation(the second word of my siblings' names is the same), and 
> the third is my given name.
> 
> In China, no characters (such as spaces or punctuation) are used between 
> the word of a name.
> 
> Thanks again to Steve for your understanding of Chinese naming tradition.
> 
> Thanks!
> ChenXiaoSong.
> 
> On 10/19/25 5:47 PM, Steve French wrote:
>>  > My name pattern recognition would find a display like “… Chen Xiao 
>> Song”
>> clearer eventually.
>>
>> The convention of whether and where a space is used in approximating 
>> an Asian name in western ASCII characters apparently varies by 
>> country, but apparently natively in many Asian languages there would 
>> be no spaces so there does not appear to be a rule on this for 
>> Americanized (or westernized) Asian names. In addition the convention 
>> of whether given name precedes family name is reversed in some asian 
>> countries. In general a person has some freedom in how they wish to be 
>> "named" in git commits eg in western languages whether a nickname or 
>> strict legal name is used.
>>
>> Thanks,
>>
>> Steve
>>
>> On Sun, Oct 19, 2025, 3:50 AM Markus Elfring <Markus.Elfring@web.de 
>> <mailto:Markus.Elfring@web.de>> wrote:
>>
>>      >> Do you care for naming requirements which are indicated by
>>      >> the Developer's Certificate of Origin?
>>      >
>>      > Generally, these are good to follow for multiple reasons,
>>
>>     Thanks for another bit of positive indication.
>>
>>
>>      > but I still don't see your point.
>>
>>     I hope that remaining communication difficulties can be resolved 
>> better.
>>
>>     We are
>>
>>
>>      > If "Markus Elfring" chooses to use a (valid) email address
>>     "Markus.Elfring@web.de <mailto:Markus.Elfring@web.de> …" which is
>>     basically the same is his name how is that any different from
>>     "ChenXiaoSong" choosing to use a (valid) email address that is
>>     almost identical to the name ie "chenxiaosong@kylinos.cn
>>     <mailto:chenxiaosong@kylinos.cn> <mailto:chenxiaosong@kylinos.cn
>>     <mailto:chenxiaosong@kylinos.cn>>" obviously this is not using an
>>     Asian character set, but it appears accurate and I don't see
>>     anywhere that it violates. …
>>
>>     You stressed constraints for the email address selection.
>>
>>     I dared to point a concern out for the representation of a personal
>>     name.
>>     https://en.wikipedia.org/wiki/Personal_name <https://
>>     en.wikipedia.org/wiki/Personal_name>
>>
>>     We are occasionally struggling with the information
>>     “using a known identity (sorry, no anonymous contributions.)”,
>>     don't we?
>>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
>>     tree/Documentation/process/submitting-patches.rst?h=v6.18-rc1#n440
>>     <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
>>     tree/Documentation/process/submitting-patches.rst?h=v6.18-rc1#n440>
>>
>>     My name pattern recognition would find a display like “… Chen Xiao 
>> Song”
>>     clearer eventually.
>>     * https://en.wikipedia.org/wiki/Chen_(surname) <https://
>>     en.wikipedia.org/wiki/Chen_(surname)>
>>     * https://en.wikipedia.org/wiki/Xiao_(surname) <https://
>>     en.wikipedia.org/wiki/Xiao_(surname)>
>>     * https://en.wikipedia.org/wiki/
>>     Song_%28disambiguation%29#People_with_the_name <https://
>>     en.wikipedia.org/wiki/Song_%28disambiguation%29#People_with_the_name>
>>
>>
>>     Regards,
>>     Markus
>>
> 

