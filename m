Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E5846F;
	Sat, 10 May 2025 03:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746846327; cv=none; b=Tieh1PZYqo8Aq4QA4jZxiPvB8dJmaSQ/4smWjLi4M4KBvOVMzA5MUxiv0M3setrWa1Ypmc9dsIeji0h6a+teyqAomMyeIXWxbP6qeqHPX+dFnGqvHgxgF4igIpaClsOtXgb4FM+S+5BWoKMb1/2z7mE5PONuhH1BF5+wxSL8vjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746846327; c=relaxed/simple;
	bh=0Y5jtXbkzPHbi+33JLX/GRAnmyxVtbBj1SF8BU/aAA0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCDTf6N7AXQUFsC18by2UJobblvi3XEFH8HCPMTIkcBTM2ZAMmE5ZSubqgeku/UYTi4r/Is6GcU55jivlRIQviozmDN4npZYej+IMCg0bQXO04LdPN4VI0GBX91mpxn2/pSEIn0Q5ShIloCv7JYg5xijbY2R90CUKMQUpiWBibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=L9u12xnT; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="L9u12xnT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1746846326; x=1778382326;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0Y5jtXbkzPHbi+33JLX/GRAnmyxVtbBj1SF8BU/aAA0=;
  b=L9u12xnT25QYNASFTXh159xICCHvNBI/FWuuO+WaYffwIW8m8h7KtII2
   CwzjAQOsn5U7IGUYkIhS/57H4LKu67BT7C7U5dDR1ukgEMRmyWvuRYMOZ
   jE51ANbdTtZzWfkt1GRu02toEHwjRU83fp/ruJsaYZnlhn+rTlD+0g0SO
   NMiznEq5YjMLncPGQQXYVzArgf91EFBf//4UlbmlCimSLJFL2GLwQ0wT6
   vd4LFFVUNieqGHIKYCe3KQ9oIQNXYDDzr/dCY3V+9VlOAM17yqDWhPFeS
   fKSmSMHkXq4t4T9jtN+X8NgTxHIT6i4tbySsoBFBaVKfaCAQ7Ae01MAHJ
   w==;
X-IronPort-AV: E=Sophos;i="6.15,276,1739836800"; 
   d="scan'208";a="296299169"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2025 03:05:23 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:40195]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.229:2525] with esmtp (Farcaster)
 id bf756ada-ce60-45e5-bac3-f1e19ee65d09; Sat, 10 May 2025 03:05:21 +0000 (UTC)
X-Farcaster-Flow-ID: bf756ada-ce60-45e5-bac3-f1e19ee65d09
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 10 May 2025 03:05:20 +0000
Received: from 3c06303d853a.ant.amazon.com (10.135.223.133) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 10 May 2025 03:05:18 +0000
Date: Fri, 9 May 2025 20:05:13 -0700
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
Message-ID: <aB7CaTP-jwYhDROJ@3c06303d853a.ant.amazon.com>
References: <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
 <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
 <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
 <fb4c481d-91ba-46b8-b11a-534597a2b467@leemhuis.info>
 <ZxAm4rvmWp2MMt4b@3c06303d853a.ant.amazon.com>
 <ZzD0cW4gbQnbI9Gm@3c06303d853a>
 <Z9cZuBxOscqybcMy@3c06303d853a.ant.amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9cZuBxOscqybcMy@3c06303d853a.ant.amazon.com>
X-ClientProxiedBy: EX19D041UWA001.ant.amazon.com (10.13.139.124) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 16/03/2025, Andrew Paniakin wrote:
> My next step is to resend 7ad54b98fc1f1 ("cifs: use origin fullpath for
> automounts") with required comments and send an update to this thread once it
> merged.

Backport with a fix was released in v6.1.135.

#regzbot fix: 7d8bb979f627 ("cifs: use origin fullpath for automounts")
