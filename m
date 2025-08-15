Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E16307488
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272544; cv=none; b=KzeXWk7tXXD32VH0D7/5XQ6PFMio9ceYxlCxxuMD3svviybZZneCY6b2EAeKHOC4AvFBSpbQy2EjXLboc+s5T2ZpRRS80ONfZdXv62SO1QDfdF2BxmXHznb17d+JTPqChx25NZki9ufHrXLVnYh9QSSyPN4jMzjIf5NrQ+CIHfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272544; c=relaxed/simple;
	bh=TvC6a/FsSrK86kiM74bEek4j91JX57WtMeA32bCOxHI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=S4gbUQag5x4JqLRvil+4aM4IaP5cGTkQPNsULJvzNEMnnGcXXqLuBhzLOvUv/ehWRYjSWcT6P+u0/ymE7qdMoKquBYiwEZ9UdGaylBm4RMJJ2t1QtCPN/pHrz5IYAWou33r3CXqahEmcpxfDgFJVSpgYd2LkeUD8xg0lGpENbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JCMgDsvh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JCMgDsvh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=8ne5O4VxsjBRC6ta9KutfIbWX6rUe+sScX+06ze5Bpo=; b=JCMgDsvhji4+KkYcmeKNiJz7kQ
	v9DGcXkQGWFJCoVzxGGldU/EspgU/kMrtd0hm0Qz88Euj38OPzkcClOxanEzJfMT3PUANSbQ6tmRG
	2Lu7g2uVZOUF5r9tb7FUhf1O6Z/GR14S1TVFhml2PcbnSQrrmpFgfPWl+RDTZ/4Fzd10XxPloR2Qa
	gSaA5UVb57tbRNTQrAiIgJcQKwoAay7dW3f7L5QisoIA4XVRdDJ+NxnrpSxISiUaMbPjDg2cTbxP4
	qPLttjp9vUPHkjOUEa2CoshA+IwhBnTlx7qFx5rJH+0KJhYL0jYopL2bI5WZkHTllS2aNtbzjGhaP
	ISbpHf5YWB3/EWDNoM/vyEsstMNBnUlAD/AkX76Bis47KAW+4pJVfJtAC6ZvvTaPS4V4dvs1fkAVP
	fJxx/8JwF0IIEX/j+0Ix7nFcad5fHZCWJhai/Er9zJ8l+gjesBGyF6L1nex7ymIktdaC0F+3ytVSl
	3sktCDcjpM+rfJwo7Hk6x4pV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1umwZP-0031LW-23;
	Fri, 15 Aug 2025 15:42:19 +0000
Message-ID: <aa1772e6-690e-477f-adcb-400ccb17d219@samba.org>
Date: Fri, 15 Aug 2025 17:42:19 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
From: Stefan Metzmacher <metze@samba.org>
Subject: ksmbd: limit repeated connections from clients with the same IP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae,

this commit relies on IPv4 only, which is wrong!
Can you please have a look, thanks!

commit e6bb9193974059ddbb0ce7763fa3882bd60d4dc3
Author: Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue Aug 5 18:13:13 2025 +0900

     ksmbd: limit repeated connections from clients with the same IP

     Repeated connections from clients with the same IP address may exhaust
     the max connections and prevent other normal client connections.
     This patch limit repeated connections from clients with the same IP.

     Reported-by: tianshuo han <hantianshuo233@gmail.com>
     Cc: stable@vger.kernel.org
     Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
     Signed-off-by: Steve French <stfrench@microsoft.com>

I came to it because smatch reported this:

Warning: server/connection.c:53 function parameter 'inet_addr' not described in 'ksmbd_conn_alloc'

Thanks!
metze
