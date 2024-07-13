Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9301758B;
	Sat, 13 Jul 2024 03:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720840942; cv=none; b=r1TGKXG4ioA0kK4UwU3o4eud3vAsNNu1RtYOVkCLUsy9DxUgE0Fyv8aszADgeQNm7fEa5p18rKIOV5ewsNBFzXPr0ggd1ZXAldnIqHICdF3a2ofvuLF3AEBB98GozOqR8jUvW9b0Iic93d7b90lxF6adTtUJm4s23glFZeF+H64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720840942; c=relaxed/simple;
	bh=XQRK3olFcGYDhpyX/gjVvN4c01L8z83NPrVTYmMOqp8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQualyjYLuvsSanyOkM2Z12NrMhkjxeaKD8kaaSXyhYq2Voq4RZUgYlwKHcB99SritoQbDzbZFS+1GTKMXY9KJ9Hi374Czlo/7QBNWhcmLlfAob1bcTH3SwcioTp9nJk5BlvuyUY56iOJUxEKeRqQkqO8BZ2t9yQuVdm4OhOnXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=mFbEdoaC; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="mFbEdoaC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720840941; x=1752376941;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HFQVoU++qjoMPpjt/cUGGmwpKXJ4P+TR3Qf9WgP35GU=;
  b=mFbEdoaCTL2Dux5ka9yeOTApCp0oMWv4ITXfAgcQeWCgsEN7X/CVqd1g
   9OO3uZmrEQMX03gd5wCCO3vrI4/xvxphz8RSdANaLxP9Kn7AXiLu2wQCR
   swqLcK21fv2wplmv5hjytWRSrj35nN1iLe0TRb0osTkSo0QoQwWBeWOCn
   A=;
X-IronPort-AV: E=Sophos;i="6.09,204,1716249600"; 
   d="scan'208";a="419984667"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 03:22:19 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:49511]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.30:2525] with esmtp (Farcaster)
 id e4354d46-f591-41c7-a032-eb8684858776; Sat, 13 Jul 2024 03:22:17 +0000 (UTC)
X-Farcaster-Flow-ID: e4354d46-f591-41c7-a032-eb8684858776
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 13 Jul 2024 03:22:17 +0000
Received: from 3c06303d853a.ant.amazon.com (10.187.170.15) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 13 Jul 2024 03:22:14 +0000
Date: Fri, 12 Jul 2024 20:22:09 -0700
From: Andrew Paniakin <apanyaki@amazon.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
CC: Christian Heusel <christian@heusel.eu>, <pc@cjr.nz>,
	<stfrench@microsoft.com>, <sashal@kernel.org>, <pc@manguebit.com>,
	<stable@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
	<abuehaze@amazon.com>, <simbarb@amazon.com>, <benh@amazon.com>,
	<gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
Message-ID: <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
X-ClientProxiedBy: EX19D035UWA002.ant.amazon.com (10.13.139.60) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 11/07/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 27.06.24 22:16, Christian Heusel wrote:
> > On 24/06/26 03:09PM, Andrew Paniakin wrote:
> >> On 25/06/2024, Christian Heusel wrote:
> >>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
> >>>> On 19/06/2024, Andrew Paniakin wrote:
> >>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was

[snip]

> Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
> you take care of that to get this properly fixed to prevent others from
> running into the same problem?
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
> 
> #regzbot poke

We got the confirmation from requesters that the kernel with this patch
works properly, our regression tests also passed, so I submitted
backport request:
https://lore.kernel.org/stable/20240713031147.20332-1-apanyaki@amazon.com/
