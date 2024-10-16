Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B304409;
	Wed, 16 Oct 2024 20:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729111793; cv=none; b=MCuQcnyCa3lywKXoZsfobMJObCt3FdYJZkrDd7fZQsVPsBY6VQoDgARaGI9EWz+wVawvtINhXXsVx0huvNiZp9eVOhxq9YwtHQBo9+n5sF/q3ilbDCRJ+mTklhqVJorUGVIOddny8XUWlgpmNvpzyuhTdnFOlBw1RYvUr1WLcV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729111793; c=relaxed/simple;
	bh=wyviNS/O87hNqvd7UTSnAIcEJ6WvYGkBX9tYawnrCik=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHib+lMJrYpRslec0UaNOsOqfoGOgW1u5tsoDcpQMvN/4P3j9Z5NaNfuAHI/mPgkNyQZKw6vdHC8HT95hhHgA2n84pl5Y2T2UZwaGjCe1os+KW0Jf6h/8GBYUeFnmKOKIQl9Q+2yVb59eIqrR6FE4bzyhBtsBQcutDaLVrmJaPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=d0KZ5eIP; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="d0KZ5eIP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729111792; x=1760647792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ICjUl4q8K/hAIxqwCsJkPss/Rcd78MNXDfdL8em+YUo=;
  b=d0KZ5eIPcUhrxbF7drELaM4c4EIJXLaSOn1WGG45NC4cMLRTJSRUWq9n
   QB9MP/4aeKbyOks5fSCfPBhgBMdrvlw7rv1uwHfdahBq9tKONeocklxcW
   vd/hJYYtzhE0mCB1f6tL+kAKTwha94Ksj3YG+DnDe49aFSRXHEi4ebaJq
   s=;
X-IronPort-AV: E=Sophos;i="6.11,209,1725321600"; 
   d="scan'208";a="432058913"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 20:49:47 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:44050]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.150:2525] with esmtp (Farcaster)
 id 91a88051-116e-4f95-a9e3-50e85f98db01; Wed, 16 Oct 2024 20:49:46 +0000 (UTC)
X-Farcaster-Flow-ID: 91a88051-116e-4f95-a9e3-50e85f98db01
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 16 Oct 2024 20:49:46 +0000
Received: from 3c06303d853a.ant.amazon.com (10.187.171.15) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 16 Oct 2024 20:49:43 +0000
Date: Wed, 16 Oct 2024 13:49:38 -0700
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
Message-ID: <ZxAm4rvmWp2MMt4b@3c06303d853a.ant.amazon.com>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
 <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
 <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
 <fb4c481d-91ba-46b8-b11a-534597a2b467@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fb4c481d-91ba-46b8-b11a-534597a2b467@leemhuis.info>
X-ClientProxiedBy: EX19D044UWB003.ant.amazon.com (10.13.139.168) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 27/09/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 23.07.24 02:51, Andrew Paniakin wrote:
> > On 12/07/2024, Andrew Paniakin wrote:
> >> On 11/07/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> >>> On 27.06.24 22:16, Christian Heusel wrote:
> >>>> On 24/06/26 03:09PM, Andrew Paniakin wrote:
> >>>>> On 25/06/2024, Christian Heusel wrote:
> >>>>>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
> >>>>>>> On 19/06/2024, Andrew Paniakin wrote:
> >>>>>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> >>
> >>> Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
> >>> you take care of that to get this properly fixed to prevent others from
> >>> running into the same problem?
> >>
> >> We got the confirmation from requesters that the kernel with this patch
> >> works properly, our regression tests also passed, so I submitted
> >> backport request:
> >> https://lore.kernel.org/stable/20240713031147.20332-1-apanyaki@amazon.com/
> >
> > There was an issue with backporting the follow-up fix for this patch:
> > https://lore.kernel.org/all/20240716152749.667492414@linuxfoundation.org/
> > I'll work on fixing this issue and send new patches again for the next cycle.
> 
> Andrew, was there any progress? From here it looks like this fell
> through the cracks, but I might be missing something.
> 
> Ciao, Thorsten

Hi Thorsten, sorry for delay in reply.
I had to do one step back and update my development setup, in order to
prevent rebase process breaking: created script to use crosstool [1] to
test my future backports on all platforms and make sure to search
follow-up fixes for the patch I'm porting, found kernel.dance [2] for
it. Now I'm trying to reproduce issue mentioned in follow-up fix [3] to
have clear red/green test results. I think I should be able to send
tested fixes in next 2 weeks.

[1] https://cdn.kernel.org/pub/tools/crosstool/
[2] https://kernel.dance/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5a863a153e90996ab2aef6b9e08d509f4d5662b
