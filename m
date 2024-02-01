Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113A853362;
	Thu,  1 Feb 2024 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706792320; cv=none; b=QiiQ61zsdVscBO7bH7+9Q7z+Pl/LUCiT+wAZC+cJZ1xH4VxM3Fs6VjtBzFEmesjdK/0gEJmhar9VQNBMsVNaBxdP71voU3Izsq8lGOot95Xek17CmLSch+GRqvZtH7k8H2of7RwW6VYMpPmjKUq9lmIC4KiM1Ft7LU/ORxWgWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706792320; c=relaxed/simple;
	bh=MHDfNdMw12sIWRU7RfM/N1sTc3Fx1OjZKgjklgYHhcE=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ycg8M5W6BNRz6QYDnH+4nxl8wFmgieBN0o+vN7zM002/QNgJoX1q5n1hpwOIUwlRR7U1eQrwDNn3nI8mWPKzvKBtB6q9i/frcrBQ545QauEea5qjBHNAbvvHwoKo10ZhGC//DMKI3ScwCT0wv16wfQqUh7vCED5ATD8L+nlB0Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=q88rvNhv; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="q88rvNhv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1706792319; x=1738328319;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=waFRF+K7gEDtO0MzxpQ/w+uoFORktzAU96B8ZA3JvFs=;
  b=q88rvNhvS4MoTgje1wHxIokNCfIkfzgzb252WDU70XxgYuE/lQPiQxd6
   Fr4kV44tsWtJHrEuTJMWylaQG2qZuXW/CEkf883mZKTfX3KgJ34+TdeZ4
   36+0BBAdfBEemQ4jylUylHqOwjtqlx/62soVTdUMIP1RfybSctl98T6xw
   4=;
X-IronPort-AV: E=Sophos;i="6.05,234,1701129600"; 
   d="scan'208";a="631327036"
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with "Resource
 temporarily unavailable"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 12:58:37 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:53331]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.14.233:2525] with esmtp (Farcaster)
 id c4031593-8aa9-42fd-b6fc-de37a98e7084; Thu, 1 Feb 2024 12:58:35 +0000 (UTC)
X-Farcaster-Flow-ID: c4031593-8aa9-42fd-b6fc-de37a98e7084
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 1 Feb 2024 12:58:35 +0000
Received: from [192.168.7.223] (10.106.82.33) by EX19D018EUA004.ant.amazon.com
 (10.252.50.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Thu, 1 Feb
 2024 12:58:32 +0000
Message-ID: <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
Date: Thu, 1 Feb 2024 12:58:28 +0000
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Paulo Alcantara <pc@manguebit.com>, Salvatore Bonaccorso
	<carnil@debian.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "m.weissbach@info-gate.de"
	<m.weissbach@info-gate.de>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>, "sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
Content-Language: en-US
From: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
In-Reply-To: <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)


On 31/01/2024 17:19, Paulo Alcantara wrote:
> Greg, could you please drop
> 
>          b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")
> 
> from v5.10.y as suggested by Salvatore?
> 
> Thanks.

Are we dropping b3632baa5045 ("cifs: fix off-by-one in 
SMB2_query_info_init()") from v5.10.y while keeping it on v5.15.y? if we 
are dropping it from v5.15.y as well then we should backport 06aa6eff7b 
smb3: Replace smb2pdu 1-element arrays with flex-arrays to v5.15.y I 
remember trying to backport this patch on v5.15.y but there were some 
merge conflicts there.

06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays


Thank you.

Hazem

