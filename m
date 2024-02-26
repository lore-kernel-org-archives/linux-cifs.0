Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11F17FBAA;
	Mon, 26 Feb 2024 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959303; cv=none; b=YkSL68had9z6M2/aaX0s0qjE8TuX5ILcDjR9lXSD/QNVm7rojM/0amq7xg4MdAvBpeV9tMMtJEQXvYvB0Ca4ZnQ2DMbqoFLympzLe2SkT/giinKwOrf/mixDFKnndEv8H5PeeeEzZQcDwp2r3beP7MHbH+MWE74O6BCanffVCpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959303; c=relaxed/simple;
	bh=BxYZ9LdSRKDiHLKUEgpXGQTsOcHVROg0YnCSVaDW/9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYqx6X2LHiSoODk2a8YkjrVWwBPpTjHQd72dcgashsG3/LwVcf/zsNeFDxwvFYrRosczF8ex4sFHTufECuNS4eZvcbyiliaVvxLROFtqdaVvxpj/GZDbQDLa/YwtUDfQRegWb7PUvXxNx/ytjaqIGQ2A/xPdFFrB0K/FEyVq82U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=X5BvDma6; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="X5BvDma6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=qU6uGJ5gCCJaB1zEIQmziYSPL2tGMFcFQnLaHWsOaP4=;
	t=1708959301; x=1709391301; b=X5BvDma6YbpRSfya0spaKW8+xuQZb6G5fCWBsJr0Yqg0WsR
	xvS5dCcZ1PgRldexbD4lyN9AP8+eLoPHwb4Yx4+3HXUOpFQDCzPSZr78MnPzn6IlC0WzlakXN7nig
	K9zki7TFG92ktdmD9ycNPHUN9ImyXui74WyQuRoUPfpImsQn0wYELGwmb5XbOxZByOZu1D8Ibpxzf
	wQqhMIUsEx16+NqpAOzFYkwHcnRoZrYF4t4IW7cv4SiTHLHdvcQpE+x2NbBqWHEQvJir1D2Ua45j4
	qK/LhyHIoCRLaTXlsvZEoSlRgp4gk56HxV7nvn/00uniSMEEf1Js8ys1as6eWIQw==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1recNe-0002Cw-Lp; Mon, 26 Feb 2024 15:54:58 +0100
Message-ID: <abf80818-3c8c-47e1-b1d2-5fd65d65b247@leemhuis.info>
Date: Mon, 26 Feb 2024 15:54:57 +0100
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
To: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
 Linux regressions mailing list <regressions@lists.linux.dev>,
 SeongJae Park <sj@kernel.org>
Cc: "pc@manguebit.com" <pc@manguebit.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "leonardo@schenkel.net" <leonardo@schenkel.net>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
 "sairon@sairon.cz" <sairon@sairon.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Vasiliy Kovalev <kovalev@altlinux.org>,
 Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>,
 ajay.kaher@broadcom.com, tapas.kundu@broadcom.com
References: <20240126191351.56183-1-sj@kernel.org>
 <2ab43584-8b6f-4c39-ae49-401530570c7a@leemhuis.info>
 <fd0174a5-8319-436d-bf05-0f6a3794f6f9@amazon.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <fd0174a5-8319-436d-bf05-0f6a3794f6f9@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1708959301;3c6287ca;
X-HE-SMSGID: 1recNe-0002Cw-Lp

[CCing a few people that afaics were involved in trying to fix the CIFS
problems on 5.15/5.10 (to be honest I lost a bit track of that
situation; sorry if I added too many people; at the same time I hope I
did not forget anyone...)]

Anyway: it seems 5.15.149 created a new CIFS problem, see the quoted
mail below for details. Ciao, Thorsten

On 26.02.24 15:28, Mohamed Abuelfotoh, Hazem wrote:
> On 23/02/2024 06:14, Linux regression tracking #update (Thorsten
> Leemhuis) wrote:
>
>> Thx. Took a while (among others because the stable team worked a bit
>> slower that usual), but from what Paulo Alcantara and Salvatore
>> Bonaccorso recently said everything is afaics now fixed or on track to
>> be fixed in all affected stable/longterm branches:
>> https://lore.kernel.org/all/ZdgyEfNsev8WGIl5@eldamar.lan/
>>
>> If I got this wrong and that's not the case, please holler.
> 
> We are seeing CIFS mount failures after upgrading from v5.15.148 to
> v5.15.149, I have reverted eb3e28c1e8 ("smb3: Replace smb2pdu 1-element
> arrays with flex-arrays") and I no longer see the regression. It looks
> like the issue is also impacting v5.10.y as the mentioned reverted patch
> has also been merged to v5.10.210. I am currently running the CIFS mount
> test manually and will update the thread with the exact mount failure
> error. I think we should revert eb3e28c1e8 ("smb3: Replace smb2pdu
> 1-element arrays with flex-arrays") from both v5.15.y & v5.10.y until we
> come up with a proper fix on this versions, please note that if we will
> take this path then we will need to re-introduce. b3632baa5045 ("cifs:
> fix off-by-one in SMB2_query_info_init()") which has been removed from
> latest v5.10.y and v5.15.y releases.
