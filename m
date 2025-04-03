Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2728251783
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743701269; cv=none; b=MocvG6o5demeUNHTlgZtok5hkd98V0Vx7KIf2dziogXeE4SUg+Bog0miwjxuWS25HosKQyPw/TdaTCE4+vLmaTpiLzzNmESRDZy2v3XIT5wyi3MwkhramYbqEvloDxdW/ipSriPQJt5sWzO6uYhgfylhmKzRbyaffWG18qYLfMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743701269; c=relaxed/simple;
	bh=pvJh44ZQxnKOZqN1gChSSa/J9gexfgkD8Tulm65i8aY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=juyYlPBjT/VcdY0D0JRFI9GGtcEKPeAzfb5w80jD1mGIW/G4Wt+0BeAzSrGB5TjWLsh4GMMc+guEI7s+P5eRF0Mo+VF7dGtTAfrJ7qBQbg/pqELZ6Nh7qxRqlyT42PDNOqmy2JF6pHKtzTjwXh2WwIbMna1nwEbH5Omve20lcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=PaYq9bP/; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="PaYq9bP/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743701267; x=1775237267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ua3pksczn5JrLI/TR0iVKuelZ15cEIgvLKtswP1k610=;
  b=PaYq9bP/S3P1au2PsIIp7FKw/DI7lkK2S0/hXd9cLpUspdKe54QtRDSj
   3AdQPGtxYxKqEP0z/NDj5LuvTeScoWho+0u44gcNtLoBdBijv5g7vVCD6
   a8jheBweF0a1+T/1f7vhVP6kt3Tr9QKfkwjZeX64XZC8t7754OCSQo1zE
   4=;
X-IronPort-AV: E=Sophos;i="6.15,184,1739836800"; 
   d="scan'208";a="392767783"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 17:27:21 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:64124]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.147:2525] with esmtp (Farcaster)
 id 3e4e472c-3ac4-4d18-8e4d-fae441999a30; Thu, 3 Apr 2025 17:27:21 +0000 (UTC)
X-Farcaster-Flow-ID: 3e4e472c-3ac4-4d18-8e4d-fae441999a30
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 3 Apr 2025 17:27:21 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 3 Apr 2025 17:27:17 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <wangzhaolong1@huawei.com>
CC: <bharathsm@microsoft.com>, <ematsumiya@suse.de>, <kuni1840@gmail.com>,
	<kuniyu@amazon.com>, <linux-cifs@vger.kernel.org>, <pc@manguebit.com>,
	<ronniesahlberg@gmail.com>, <samba-technical@lists.samba.org>,
	<sfrench@samba.org>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: Re: [PATCH 1/2] Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"
Date: Thu, 3 Apr 2025 10:26:47 -0700
Message-ID: <20250403172709.92329-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <1e95b93f-7632-441a-a4ba-aecd7e640383@huawei.com>
References: <1e95b93f-7632-441a-a4ba-aecd7e640383@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWC003.ant.amazon.com (10.13.139.240) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Wang Zhaolong <wangzhaolong1@huawei.com>
Date: Thu, 3 Apr 2025 17:59:20 +0800
> Hi Kuniyuki,
> 
> When testing this patch on the latest mainline, I found that the following
> snippet has a conflict:

I guess it's because I used for-next branch of the cifs.git.

Steve:

What branch should be used to send reverts for -rcX ?


> 
> 
> > @@ -3444,6 +3441,9 @@ generic_ip_connect(struct TCP_Server_Info *server)
> >   	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
> >   		rc = ip_rfc1001_connect(server);
> >   
> > +	if (rc < 0)
> > +		put_net(cifs_net_ns(server));
> > +
> >   	return rc;
> >   }
> >   
> 
> Specifically, it is this line:
> 
> >   	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
> 
> In my code, it corresponds to the following snippet:
> 
> ```
> @@ -3333,10 +3330,13 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	}
>   	trace_smb3_connect_done(server->hostname, server->conn_id, &server->dstaddr);
>   	if (sport == htons(RFC1001_PORT))
>   		rc = ip_rfc1001_connect(server);
>   
> +	if (rc < 0)
> +		put_net(cifs_net_ns(server));
> +
>   	return rc;
>   }
> ```
> 
> Looks like V3 needs to be sent?
> 
> Best regards,
> Wang Zhaolong
