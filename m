Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0EC77111;
	Sun, 10 Nov 2024 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731261567; cv=none; b=VlGPZCpyQhoAdtjf712thr0Q+gdGOhUp4kmbJHkhQyTBorodC41WWhQ3OJ8QjnFAGBKc8EIZeQ3ohZhO+IB0yUg6G8Erv6ALP3q/3O5DcqOGIRa4anB89NONeq0X2VhxKkSUi4B98JbAWe0NSuPNk790urBUIbfTAJOJyWvTWQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731261567; c=relaxed/simple;
	bh=gP0LyPTk1K9ldk25ShgNbUfkLy4CMQwovmYapa/+6nw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWtZxw5yYzpPOXl9fi3xARNpLnFWbCExqQTy39bLR5bcn+7c1KNQPz+KRowRSaqpghKo3htHwN09XpEhZk/NcFu+qZe+1Oj/F2SxKEooGJqlHkQaKBROI0Fa59HwVNGaUMi4EzfbriMZkTwKzpNCTOyRdAbqwDLjUMmr+nsl7+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=mMWLfBKj; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="mMWLfBKj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731261565; x=1762797565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qriQr7A7vdEU9JH1OJ7IVxAGZbKMJJpRoQgwNdcsaRQ=;
  b=mMWLfBKj0ZAuehlf0t52oCK/8qb7gVABtBcVtl66w4nBA9VCO3caQk0s
   n8OPsJl3jua2WUZ1bWBuu4ndthB1lmqFvfyV1XRGMSTZ0CLVWV4/zn6E9
   UHyCzc9Qh35FS1jflCK8Y+F5AHDs5JZNW7231HapuWkcF8DidcnrhhTvv
   k=;
X-IronPort-AV: E=Sophos;i="6.12,143,1728950400"; 
   d="scan'208";a="146039670"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2024 17:59:23 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:50883]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.102:2525] with esmtp (Farcaster)
 id c392b481-9aba-45bc-b262-f61f404f42f0; Sun, 10 Nov 2024 17:59:21 +0000 (UTC)
X-Farcaster-Flow-ID: c392b481-9aba-45bc-b262-f61f404f42f0
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sun, 10 Nov 2024 17:59:21 +0000
Received: from 3c06303d853a (10.187.171.33) by EX19D026EUB004.ant.amazon.com
 (10.252.61.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Sun, 10 Nov 2024
 17:59:18 +0000
Date: Sun, 10 Nov 2024 09:59:13 -0800
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
Message-ID: <ZzD0cW4gbQnbI9Gm@3c06303d853a>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
 <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
 <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
 <fb4c481d-91ba-46b8-b11a-534597a2b467@leemhuis.info>
 <ZxAm4rvmWp2MMt4b@3c06303d853a.ant.amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZxAm4rvmWp2MMt4b@3c06303d853a.ant.amazon.com>
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 16/10/2024, Andrew Paniakin wrote:
> On 27/09/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> > On 23.07.24 02:51, Andrew Paniakin wrote:
> > > On 12/07/2024, Andrew Paniakin wrote:
> > >> On 11/07/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> > >>> On 27.06.24 22:16, Christian Heusel wrote:
> > >>>> On 24/06/26 03:09PM, Andrew Paniakin wrote:
> > >>>>> On 25/06/2024, Christian Heusel wrote:
> > >>>>>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
> > >>>>>>> On 19/06/2024, Andrew Paniakin wrote:
> > >>>>>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> > >>
> > >>> Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
> > >>> you take care of that to get this properly fixed to prevent others from
> > >>> running into the same problem?
> > >>
> > >> We got the confirmation from requesters that the kernel with this patch
> > >> works properly, our regression tests also passed, so I submitted
> > >> backport request:
> > >> https://lore.kernel.org/stable/20240713031147.20332-1-apanyaki@amazon.com/
> > >
> > > There was an issue with backporting the follow-up fix for this patch:
> > > https://lore.kernel.org/all/20240716152749.667492414@linuxfoundation.org/
> > > I'll work on fixing this issue and send new patches again for the next cycle.
> > 
> > Andrew, was there any progress? From here it looks like this fell
> > through the cracks, but I might be missing something.
> > 
> > Ciao, Thorsten
> 
> Hi Thorsten, sorry for delay in reply.
> I had to do one step back and update my development setup, in order to
> prevent rebase process breaking: created script to use crosstool [1] to
> test my future backports on all platforms and make sure to search
> follow-up fixes for the patch I'm porting, found kernel.dance [2] for
> it. Now I'm trying to reproduce issue mentioned in follow-up fix [3] to
> have clear red/green test results. I think I should be able to send
> tested fixes in next 2 weeks.
> 
> [1] https://cdn.kernel.org/pub/tools/crosstool/
> [2] https://kernel.dance/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5a863a153e90996ab2aef6b9e08d509f4d5662b
Hi Thorsten,
Last weeks I had to work on few urgent internal issues, so this work got
delayed. I got confirmation from the manager to make this task my
priority until it's done. To progress faster I setup systemtap and was
able find the reason why my reproducer didn't work.
