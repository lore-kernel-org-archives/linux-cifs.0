Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730155228
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 02:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743646785; cv=none; b=TGogOqizr5in3qoApKRUotcmJCCGjQlmwTcVi+3kC1Th8lugYa39CY/UvhugtNY6zgATE+jRNhf6Hrm3Xbf+wrnodAOL6GL4eSHuGP/+RReMPNYweXWwUoJZcaaDGtpJ9zbh6Nv0LrHr2xCdzM+a4ZZrnvX1LG08AXxGRxmunW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743646785; c=relaxed/simple;
	bh=BeInf5QIimQRsWRmPtsbQErSXOQN2oOab0qiJxN/vc8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TtWbNPY+Cl9hVQCS0eRH8rVQpGYaznnk3+u58fC+AWkwbWngYQzWfd93RIYFaco13KvqiHZ9weVM9E9ENnnI1VoPxilu6fAVtHLMEjCNqMf/i/QIoyGas/9hOKDqbVLGRA6URo4Qmv2ASSGOG4T32CEBAUMZXsUko7ar5/1dK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=YJu1rebB; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="YJu1rebB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743646783; x=1775182783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QyFZHim0Rma4YlPlKPOCTgkgeDf60x+gIKo7k7pREX4=;
  b=YJu1rebBFkahz8b1kFTBPh7j3YsAySGq0EEQgIhEe2R4FET7umO5jZ6P
   DL+RI84aIYE/yhgzyjBN9iBI2IQuW2khK4eZfpBtP8c1Uamy54gDUZHVY
   8iNtwxzMrNtMUngZyNeyE6Gq50wy+koyofzrk0M7WJouXL8KKyea+D3g8
   g=;
X-IronPort-AV: E=Sophos;i="6.15,183,1739836800"; 
   d="scan'208";a="80324439"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 02:19:40 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:46601]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.224:2525] with esmtp (Farcaster)
 id 72bd2be2-e1ea-49e5-9574-f9c448598221; Thu, 3 Apr 2025 02:19:39 +0000 (UTC)
X-Farcaster-Flow-ID: 72bd2be2-e1ea-49e5-9574-f9c448598221
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 3 Apr 2025 02:19:39 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.8) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 3 Apr 2025 02:19:35 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <smfrench@gmail.com>
CC: <bharathsm@microsoft.com>, <ematsumiya@suse.de>, <kuni1840@gmail.com>,
	<kuniyu@amazon.com>, <linux-cifs@vger.kernel.org>, <pc@manguebit.com>,
	<samba-technical@lists.samba.org>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<wangzhaolong1@huawei.com>
Subject: Re: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its followup commit.
Date: Wed, 2 Apr 2025 19:18:35 -0700
Message-ID: <20250403021927.53033-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <CAH2r5mt68AFyJGdBcPB+eqzdAdbx=0QXC_U8MY-te26Wb0ye5w@mail.gmail.com>
References: <CAH2r5mt68AFyJGdBcPB+eqzdAdbx=0QXC_U8MY-te26Wb0ye5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Steve French <smfrench@gmail.com>
Date: Wed, 2 Apr 2025 20:14:03 -0500
> might be helpful if there were eBPF tracepoints for some of this that
> would be able to log warnings optionally if refcount issue on
> sock_release and/or rmmod

I just posted a fix and there explained that the socket and module
refcnt discrepancy is totally fine without LOCKDEP.

https://lore.kernel.org/netdev/20250403020837.51664-1-kuniyu@amazon.com/

So, in this case, the helpful warning is one logged by hlock_class().

As it returns NULL and triggers null-ptr-derf, it means something went
wrong, and I guess it was acceptable because LOCKDEP is not enabled in
production.

Btw, I posted v2 with Cc: stable tags as requested by Greg, so please
drop this v1.

https://lore.kernel.org/linux-cifs/20250402202714.6799-1-kuniyu@amazon.com/

Thanks!

> 
> 
> On Wed, Apr 2, 2025 at 3:03 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
> > rmmod") was not only a bogus fix for the LOCKDEP issue but also
> > introduced a real TCP socket leak.
> >
> > I'm working on the LOCKDEP fix on the networking side, so let's
> > revert the commit and its followup fix.
> >
> > For details, please see each commit.
> >
> >
> > Kuniyuki Iwashima (2):
> >   Revert "smb: client: Fix netns refcount imbalance causing leaks and
> >     use-after-free"
> >   Revert "smb: client: fix TCP timers deadlock after rmmod"
> >
> >  fs/smb/client/connect.c | 34 +++++++++-------------------------
> >  1 file changed, 9 insertions(+), 25 deletions(-)
> >
> > --
> > 2.48.1
