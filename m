Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847CF2907;
	Sat, 12 Apr 2025 19:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744485086; cv=none; b=cn8il/jRvQM1df6RDv1SXGWjymicqxDKzHZ48CTHsbbLdoZDuemb/ENuI6tDbeAcK+GrdqKD4ljp4tYpZry2u0bQ/XaDnC5U5B+p/hCc59K7NfUED0jCL0YfrFuEhSWD4zaoDAkZf2lZD/dTYuzkzzUAujkLV6UWGS1v+rx7QYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744485086; c=relaxed/simple;
	bh=nMJQoTM1O4Fh7TpT9eRfIIK6vCKrB7f9exl3szLZnjc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGJEzTpDfaGoV/VVazsahr/AX2LbgRfE4qhIe2brxm7QDXR8HWzwKrxXG6Wp6KZkzAjx6gryadAnw0/IsIe0HF3vZwj2WC/lveqDFY5peqokntYwwnVMSX6y7hChd5tOwDYosH0jG1vU8HYAhyFfg2AgFpLbSeaBmYqwgOrtpiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=M7SBw35F; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="M7SBw35F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744485085; x=1776021085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GvDCmGotCUn8aBjIPBYmqzHfJ0S2PVl/zo27M4FAgUE=;
  b=M7SBw35FwwG79tmQa4tunWeMqne21opySBGJeTwvtHzCHWYSgJ1rA9BC
   Mm6di3iYUsbsnBVLiCMi3nrLrsYYYXO8A+XO2TonTtVGRAf8uxBF1vpPc
   AMAXF2zcmOSXqJAA5kidVk7VD8j/y1VIvTbnmXkcmr4otQLRI/za0edkY
   A=;
X-IronPort-AV: E=Sophos;i="6.15,208,1739836800"; 
   d="scan'208";a="482573478"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2025 19:11:21 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:4269]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.120:2525] with esmtp (Farcaster)
 id 113971dd-8f91-4e5b-aeb4-c1d0a0fac33f; Sat, 12 Apr 2025 19:11:20 +0000 (UTC)
X-Farcaster-Flow-ID: 113971dd-8f91-4e5b-aeb4-c1d0a0fac33f
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 12 Apr 2025 19:11:19 +0000
Received: from 6c7e67bfbae3.amazon.com (10.187.170.45) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 12 Apr 2025 19:11:16 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <smfrench@gmail.com>
CC: <bharathsm@microsoft.com>, <ematsumiya@suse.de>, <kuni1840@gmail.com>,
	<kuniyu@amazon.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-net@vger.kernel.org>,
	<pc@manguebit.com>, <samba-technical@lists.samba.org>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <wangzhaolong1@huawei.com>
Subject: Re: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its followup commit.
Date: Sat, 12 Apr 2025 12:10:35 -0700
Message-ID: <20250412191108.15393-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <CAH2r5msMZ9j2Uugjex8DzT+uQWsoj5Q0NECMgx3wJFpCEaeo8w@mail.gmail.com>
References: <CAH2r5msMZ9j2Uugjex8DzT+uQWsoj5Q0NECMgx3wJFpCEaeo8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWC003.ant.amazon.com (10.13.139.217) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)


From: Steve French <smfrench@gmail.com>
Date: Sat, 12 Apr 2025 12:28:46 -0500
> I have tentatively merged the two revert patches into cifs-2.6.git
> for-next but still hoping for any review comments for those more
> expert in the network lockdep code.
> 
> Let me know when the fix to core/sock.c is upstream

Thanks, Steve.

It was pulled by Linus.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0bb2f7a1ad1f11d861f58e5ee5051c8974ff9569
https://lore.kernel.org/netdev/174430107749.3733248.15022802028936610477.pr-tracker-bot@kernel.org/
