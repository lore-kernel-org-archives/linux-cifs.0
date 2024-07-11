Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D17EEE7;
	Thu, 11 Jul 2024 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720691359; cv=none; b=ijjWvT6Lrotu3tSHxSUUaZj8E3i2h7ZyRHgFE4gVWqeLxctp9HX7v8BUovbthZBcIOGFj1R3o/XGJ5CcJHW2DwoiiicsAk24bjwJZCf8seXgPcmeFA5uqeD+D5MogGTKrlSRgyV8nqS+HFb3cMKzg2jbCbMCM2XjrOS2x5zPTxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720691359; c=relaxed/simple;
	bh=sYG5usZsNSnkOdgvDMVaBnhwUqfaAUQMHiYYhFQMdxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HukFDanVN7IdN6DyBD7G3wTpOAyP0eW0NemqbHUSwyPHfTC5tgczcO2oFvFfY8ZW+QF96Mw0c1DdjHv2ItDQ8tUpa6lVkBDC/RvbFT/j8breEB2bv+2jgm3xkWc9KYuNL7bPTMD4Xdvhp+E3dtd+K5M9cpkP6/CBjJxKEoGcYG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=wJ8YO72S; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="wJ8YO72S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=fbpbQLUloPKBX1PeXfC9DHyVOS0hmylV5zJFAZRG1jE=;
	t=1720691356; x=1721123356; b=wJ8YO72Syd/bn5JYrOJi+DWp4l52Kzw8jgrjHEzha4XDEWR
	rAO2p/LWl5QfxbeOj5BBbChC4AT73/QHZqbazQiQllmzpk/Jrm0tfz3xG8zx+CeMaMVrOR51YRi11
	NJXQWRojmb0nsH+/g2jKjqvgb7q7yhphNXYvVaTrmIMSzpjEv5U/uJOoBI4WxwTRKi55DYxofkeqr
	7jfKseGFSjCcoLsYND8ZedHNgD+Ou0zkxVhbzH6udlXA9nhn9bvyo/35gVhXC3Fit+xfPNpn2Q/rz
	A04sGBFX4wMnQ+tGbzozMhsU9NPt2bbGnHcjm99+FIgXt+DczEviJt6dAsUMPqbg==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sRqQL-0000jZ-13; Thu, 11 Jul 2024 11:49:13 +0200
Message-ID: <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
Date: Thu, 11 Jul 2024 11:49:10 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
To: Christian Heusel <christian@heusel.eu>,
 Andrew Paniakin <apanyaki@amazon.com>
Cc: pc@cjr.nz, stfrench@microsoft.com, sashal@kernel.org, pc@manguebit.com,
 regressions@lists.linux.dev, stable@vger.kernel.org,
 linux-cifs@vger.kernel.org, abuehaze@amazon.com, simbarb@amazon.com,
 benh@amazon.com, gregkh@linuxfoundation.org
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1720691356;ee6cc0fc;
X-HE-SMSGID: 1sRqQL-0000jZ-13

On 27.06.24 22:16, Christian Heusel wrote:
> On 24/06/26 03:09PM, Andrew Paniakin wrote:
>> On 25/06/2024, Christian Heusel wrote:
>>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
>>>> On 19/06/2024, Andrew Paniakin wrote:
>>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
>>>>> released in v6.1.54 and broke the failover when one of the servers
>>>>> inside DFS becomes unavailable.
>>>> Friendly reminder, did anyone had a chance to look into this report?
>>>
>>> If I understand the report correctly the regression is specific for the
>>> current 6.1.y stable series, so also not much the CIFS devs themselves
>>> can do. Maybe the stable team missed the report with the plethora of
>>> mail that they get.. I'll change the subject to make this more prominent
>>> for them.
>>>
>>> I think a good next step would be to bisect to the commit that fixed the
>>> relevant issue somewhere between v6.1.54..v6.2-rc1 so the stable team
>>> knows what needs backporting .. You can do that somewhat like so[0]:
>>
>> Bisection showed that 7ad54b98fc1f ("cifs: use origin fullpath for
>> automounts") is a first good commit. Applying it on top of 6.1.94 fixed
>> the reported problem. It also passed Amazon Linux kernel regression
>> tests when applied on top of our latest kernel 6.1. Since the code in
>> 6.1.92 is a bit different I updated the original patch:
> 
> I think it might make sense to send the backported version of the patch
> for inclusion to the stable tree directly (see "Option 3" [here][0]).
> 
> [0]: https://www.kernel.org/doc/html/next/process/stable-kernel-rules.html#option-3

Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
you take care of that to get this properly fixed to prevent others from
running into the same problem?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke
