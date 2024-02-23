Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ECE11CBF;
	Fri, 23 Feb 2024 06:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708668894; cv=none; b=Hj+iXZg8bZqjpcQah8FXpIO1GBlUMrgYftg2TI8Dj6CBBNHEEpn0nNJWAqT68MyjxLKdGTyx5vMvS5gsNRUkgHSAbzNVgN13sxfDFOgAclT8bw2p5q6OdGpvmITkjK/mPFBOSztlVUP5mzMHm7MZA9O+ck/Yr2E6KY7w6rtlmuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708668894; c=relaxed/simple;
	bh=I+DRK2qRibafYkFWKQJ26whI6Qgjy0e6h8mNAwKYnWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qwg4ROj41TYfXxp8ELQoXqPvkVcSBX/l/6uzlSSXYo7COSBH3egcDc/6rTmP89EAP/HtICdJK9W5GISNyNRAP2rOhqyvW44HYlptgs3z9gTb0KGPuF1/WEI6a8SA6ToSaomu7EKIhRTrZAfnadpBa9/ZvytyC7aU9LbPbARiwtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=f8mQ63ep; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="f8mQ63ep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=RUcyIzoLfd4/RfE2D7H2Fq5N2oC1WfbzIS4zayB28vU=;
	t=1708668891; x=1709100891; b=f8mQ63ep+SHADeFC2lTOEXdroo5O9qPWKwRrl4eqWIger7G
	lgRC1pOOQcwNexrUsPxQbw0S9S6prHKK0+HiD3qojSSBs8Nk84to6Ay5dNzPzCeX5p/LmwI3P/4a1
	2+fsDWo3SEsAhd3Xgszzxvp25rSCMMKE+ZHQXQf4TEmt38Z42d+LnZcng/frEjjWidVAHd+tCi3vg
	llYWw2LWf78KD2JJbP6cSf43yrZHR3Xj+jKL3jHderLGFFjY4oZtJnxO1lhc5mai3WEwozoDGyPHH
	01cmm5oLovijsx/2bx3Cqdv2Dm+WfBxCAuFxsHQl+h6gTcNOtiYuV06h1Ug4qHgg==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rdOpX-0007iv-CA; Fri, 23 Feb 2024 07:14:43 +0100
Message-ID: <2ab43584-8b6f-4c39-ae49-401530570c7a@leemhuis.info>
Date: Fri, 23 Feb 2024 07:14:38 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Content-Language: en-US, de-DE
To: SeongJae Park <sj@kernel.org>
Cc: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
 "pc@manguebit.com" <pc@manguebit.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "leonardo@schenkel.net" <leonardo@schenkel.net>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 "sairon@sairon.cz" <sairon@sairon.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20240126191351.56183-1-sj@kernel.org>
From: "Linux regression tracking #update (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20240126191351.56183-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1708668891;7bb25fdc;
X-HE-SMSGID: 1rdOpX-0007iv-CA

On 26.01.24 20:13, SeongJae Park wrote:
> On Mon, 15 Jan 2024 14:22:39 +0000 "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com> wrote:
> 
>> It looks like both 5.15.146 and 5.10.206 are impacted by this regression as
>> they both have the bad commit 33eae65c6f (smb: client: fix OOB in
>> SMB2_query_info_init()).
> 
> Let me try to tell this to the regression tracking bot, following the doc[1].
> This is my first time using #regzbot, so please feel free to correct me if I'm
> doing something wrong.
> 
> #regzbot introduced: 33eae65c6f

Thx. Took a while (among others because the stable team worked a bit
slower that usual), but from what Paulo Alcantara and Salvatore
Bonaccorso recently said everything is afaics now fixed or on track to
be fixed in all affected stable/longterm branches:
https://lore.kernel.org/all/ZdgyEfNsev8WGIl5@eldamar.lan/

If I got this wrong and that's not the case, please holler.

#regzbot resolve: apparently fixed in all affected stable/longterm
branches with various commits
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

