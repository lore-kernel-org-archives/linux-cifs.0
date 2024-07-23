Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D853376;
	Tue, 23 Jul 2024 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695888; cv=none; b=ft9B7NG4g4bkybv/M1w6MICCMQejnxYSIwX58xqb3wzwIJmzxf601C7wNxTo3kZckPGRmUgFB+1NvANoafygnOZ4fqU+3xSDxMeWEl0ncC4GdSC16tOuhBrCHBcJj0AVQHtW/AONJer/zW0anYuZIWBJaYgWb8fNYcopy9h3CDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695888; c=relaxed/simple;
	bh=I80HJJ0uWLSCDX0+f3gDi4OoFh5QNskt1isnchAx8kU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJwxgSueZEsGz53C7/uyvS7P3NYiNBWDVTEuUJoDgUVJQBwzqV1owxx5xmKEDc2juDuChf6CUZy3kbrc1+cGPoENgGuUf97h36ZOBgmfo7LbtfOcM/qlhCyKHhrIhJ4Bl7OybRiVwk6oevVJMnk8e5zZXNJVfTzT9NvRcjbx3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=esModib6; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="esModib6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721695887; x=1753231887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8upgokxXsouhrUx6bkYmKhiOfAsG7NKO2JmhE0OOTtM=;
  b=esModib6kcAwu2UC+U7AkTjrqQmfASU+1KFsZg40pDSlYq7dZIsogFAn
   gM5lOdFz1zttMEF5QaBg8AZekolh7nGJQ8d5gzyzJMUjezxsf+O2Dk41f
   Xe+x9sjpVCoFCn8fx/h9P6USUH1S+DDZsDyLYz5praZ6kBcB67aW8vlSv
   0=;
X-IronPort-AV: E=Sophos;i="6.09,229,1716249600"; 
   d="scan'208";a="412592983"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 00:51:24 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:38811]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.42.47:2525] with esmtp (Farcaster)
 id 8632a391-44c4-41ee-9546-d1ec88e94edf; Tue, 23 Jul 2024 00:51:23 +0000 (UTC)
X-Farcaster-Flow-ID: 8632a391-44c4-41ee-9546-d1ec88e94edf
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 23 Jul 2024 00:51:23 +0000
Received: from 3c06303d853a.ant.amazon.com (10.187.170.41) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 23 Jul 2024 00:51:19 +0000
Date: Mon, 22 Jul 2024 17:51:14 -0700
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
Message-ID: <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
 <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
X-ClientProxiedBy: EX19D035UWB001.ant.amazon.com (10.13.138.33) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 12/07/2024, Andrew Paniakin wrote:
> On 11/07/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> > On 27.06.24 22:16, Christian Heusel wrote:
> > > On 24/06/26 03:09PM, Andrew Paniakin wrote:
> > >> On 25/06/2024, Christian Heusel wrote:
> > >>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
> > >>>> On 19/06/2024, Andrew Paniakin wrote:
> > >>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> 
> [snip]
> 
> > Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
> > you take care of that to get this properly fixed to prevent others from
> > running into the same problem?
> > 
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > --
> > Everything you wanna know about Linux kernel regression tracking:
> > https://linux-regtracking.leemhuis.info/about/#tldr
> > If I did something stupid, please tell me, as explained on that page.
> > 
> > #regzbot poke
> 
> We got the confirmation from requesters that the kernel with this patch
> works properly, our regression tests also passed, so I submitted
> backport request:
> https://lore.kernel.org/stable/20240713031147.20332-1-apanyaki@amazon.com/

There was an issue with backporting the follow-up fix for this patch:
https://lore.kernel.org/all/20240716152749.667492414@linuxfoundation.org/
I'll work on fixing this issue and send new patches again for the next cycle.
