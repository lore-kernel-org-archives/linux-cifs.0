Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD9E253F01
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743702445; cv=none; b=HVWyX9UUliSWLUa2jVIjivjNj3hwVA+SZqaV1AIDKhFHmXBlZddWAjkYA8iEeiBJV+FlKPTKRPDwgJjhAj1KI8eCzUOykmt6Qh1o2KsJXcFbxvLeeTdkLOyl+127GKB//sQw8zjdFZnoCrbWuwZHOWoDCkXU/2C1K3tPUg5+8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743702445; c=relaxed/simple;
	bh=Iu3+YSJOmRcMjkgw5HwAAi2UidCNk0KpbkI+tnvg+GE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pnNCM2s+O0pbMzcxBtT5Xd8h1URRoY2EUahxoqjbp4Z0SXIF85YHbTvh6LkuAkRrCR6rrJxnxtDQysNyUl2oprIs4BX1igDguRh0ovRFEMgvaKd+jHtI0lm0axu02wj00DBG1HWzPVCNbei2T31tTqzoBRWNGGuoJn5y0wPy2cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ry6lZkk+; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ry6lZkk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743702444; x=1775238444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ItqibUDue/nvXJeFGIlrYkT9DaDOwFbB4zbDCJzYPS4=;
  b=ry6lZkk+dlLDZEPjyPFAZTuxgzSGITyeOsewj+53rql5oUgLIS5XWCHl
   0TKsVWO2I+Hs484oOSOx0srEWzHawmXsVn0tDyD/3BJkP+3tTfbEOsxMT
   stTo5XDEgFLogblXmy9NWnr0zRcdW152XaeJ7xhpfJE/Dl2Mvbn5zbnFc
   4=;
X-IronPort-AV: E=Sophos;i="6.15,186,1739836800"; 
   d="scan'208";a="80577388"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 17:46:56 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:35396]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.63:2525] with esmtp (Farcaster)
 id 3124faff-37ef-4d37-a782-1af507d1d671; Thu, 3 Apr 2025 17:46:55 +0000 (UTC)
X-Farcaster-Flow-ID: 3124faff-37ef-4d37-a782-1af507d1d671
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 3 Apr 2025 17:46:54 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 3 Apr 2025 17:46:50 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <smfrench@gmail.com>
CC: <bharathsm@microsoft.com>, <ematsumiya@suse.de>, <kuni1840@gmail.com>,
	<kuniyu@amazon.com>, <linux-cifs@vger.kernel.org>, <pc@manguebit.com>,
	<ronniesahlberg@gmail.com>, <samba-technical@lists.samba.org>,
	<sfrench@samba.org>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<wangzhaolong1@huawei.com>
Subject: Re: [PATCH 1/2] Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"
Date: Thu, 3 Apr 2025 10:46:38 -0700
Message-ID: <20250403174642.96094-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <CAH2r5mtvkAAEur6_jPMtvpKa8q9fWufwV7VG+fXkATXs_jZv0w@mail.gmail.com>
References: <CAH2r5mtvkAAEur6_jPMtvpKa8q9fWufwV7VG+fXkATXs_jZv0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Apr 2025 12:32:35 -0500
> > What branch should be used to send reverts for -rcX ?
> 
> cifs-2.6.git for-next
> 
> But probably won't be an issue in a few days (since mainline then will
> likely include the conflicting patch - which fortunately is unrelated
> to this discussion, just fixes an RFC1001 bug)

Thanks, then I'd leave v2 as is for now.



