Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2CB1292D9;
	Mon, 26 Feb 2024 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708957734; cv=none; b=PPJCcTeHQs9XDCJLysqyPMs8aRXVovAAXJqcNog8+F4hDp2rJAOVAIDHH679DQANsxqoZwn9AdasZcGYYAF+avErZyKWG6CeXmQkYMCrLZohM6r4+N1JVVwMBIrHkCpSW/o1TtXAChWqD1gi50q51US3lYuy0d2MimWNCVglfag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708957734; c=relaxed/simple;
	bh=0BRotfMPalXo5hqdz05sY70qLfIXoUMYoqgjhMDvYlY=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PUdogk3H1GiVUc6BPv1sbgY8JhYzAIC67fBn+jbl8XTfryJjCon/l84R6kWVTCWzT94KCICRxQnAYXAvq+z+U/ut7ziL2gF1zjcNNAe89QgZiX/+I1eJG+wLCfaMU+SQ0GZxchBNp6BsWvu8WYEKLIqyMNZOfkwEVffK4c8M1Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=pb0l6H3N; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="pb0l6H3N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1708957734; x=1740493734;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=RMTQzJS8lecM3Zt817XwKvIJXzxu0vlxx0W01zNW6N4=;
  b=pb0l6H3NZLnVv8K8Y6tyNY84sy75BHDCQ0avgNSqCuAbXKU8i601hJws
   6mHWVSxgKIIWZ50t47hWfYjsyQIPhWgCxAlREoV+wNjf3nj+X3+4ZcYWu
   Etlder+IdxJb0TD2db/6H8Nh7NrbVYWs2BQZ2nZilOlZsZvgsTZeLkycG
   s=;
X-IronPort-AV: E=Sophos;i="6.06,185,1705363200"; 
   d="scan'208";a="636818919"
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with "Resource
 temporarily unavailable"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 14:28:50 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:32633]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.37.70:2525] with esmtp (Farcaster)
 id 91a80cc8-7a22-4c01-9163-242ce4817eeb; Mon, 26 Feb 2024 14:28:47 +0000 (UTC)
X-Farcaster-Flow-ID: 91a80cc8-7a22-4c01-9163-242ce4817eeb
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 26 Feb 2024 14:28:43 +0000
Received: from [192.168.17.69] (10.106.82.23) by EX19D018EUA004.ant.amazon.com
 (10.252.50.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 26 Feb
 2024 14:28:43 +0000
Message-ID: <fd0174a5-8319-436d-bf05-0f6a3794f6f9@amazon.com>
Date: Mon, 26 Feb 2024 14:28:41 +0000
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Linux regressions mailing list <regressions@lists.linux.dev>, "SeongJae
 Park" <sj@kernel.org>
CC: "pc@manguebit.com" <pc@manguebit.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "leonardo@schenkel.net"
	<leonardo@schenkel.net>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "m.weissbach@info-gate.de"
	<m.weissbach@info-gate.de>, "sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20240126191351.56183-1-sj@kernel.org>
 <2ab43584-8b6f-4c39-ae49-401530570c7a@leemhuis.info>
Content-Language: en-US
From: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
In-Reply-To: <2ab43584-8b6f-4c39-ae49-401530570c7a@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D015EUA004.ant.amazon.com (10.252.50.202) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)

On 23/02/2024 06:14, Linux regression tracking #update (Thorsten 
Leemhuis) wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 

> Thx. Took a while (among others because the stable team worked a bit
> slower that usual), but from what Paulo Alcantara and Salvatore
> Bonaccorso recently said everything is afaics now fixed or on track to
> be fixed in all affected stable/longterm branches:
> https://lore.kernel.org/all/ZdgyEfNsev8WGIl5@eldamar.lan/
> 
> If I got this wrong and that's not the case, please holler.
> 
> #regzbot resolve: apparently fixed in all affected stable/longterm
> branches with various commits
> #regzbot ignore-activity
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> That page also explains what to do if mails like this annoy you.
> 
> 

We are seeing CIFS mount failures after upgrading from v5.15.148 to 
v5.15.149, I have reverted eb3e28c1e8 ("smb3: Replace smb2pdu 1-element 
arrays with flex-arrays") and I no longer see the regression. It looks 
like the issue is also impacting v5.10.y as the mentioned reverted patch 
has also been merged to v5.10.210. I am currently running the CIFS mount 
test manually and will update the thread with the exact mount failure 
error. I think we should revert eb3e28c1e8 ("smb3: Replace smb2pdu 
1-element arrays with flex-arrays") from both v5.15.y & v5.10.y until we 
come up with a proper fix on this versions, please note that if we will 
take this path then we will need to re-introduce. b3632baa5045 ("cifs: 
fix off-by-one in SMB2_query_info_init()") which has been removed from 
latest v5.10.y and v5.15.y releases.

