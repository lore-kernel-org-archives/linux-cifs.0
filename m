Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7F128839
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 07:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707205143; cv=none; b=W/33akw2gXZPSSQuwnMDcGGhhevl8HP+MmDw1w2YGmH4Z9YsX4/iyrPCDFCJ95JVPqEVtmAaEukWlFKGmhCondZ+ZMiz9SI703WVO72Wx6GhARdmZiy2TCgdCJH+gjaFL8HWrxpddzxoYnJzHOIsIYxqheikUzyuE1cV9ZAam50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707205143; c=relaxed/simple;
	bh=UA3+Uj4FD3O8sHT81A04emCcj/0MYiz65OVcSGD/waQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6gnrSvccT9gQHtRhZsJM9/B97V0uStUQaFMGhQTdSH+TstV4ECRyoE6B7QlDPFsUivk4xi6QuaIYQcArPys6o6Lh6/VP72rU15JR8X2B4GIysJGn5VpX2DVEKJt8L4R2l+WnuKn07IDlKfR0PbAwCNifC9sL3CQasWVx2pOMOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=HNeMx7pJ; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="HNeMx7pJ"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4TTZr26N0hz7y4s;
	Tue,  6 Feb 2024 08:38:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707205138; bh=UA3+Uj4FD3O8sHT81A04emCcj/0MYiz65OVcSGD/waQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HNeMx7pJQ41ucA7ar8GQDzziY94Nnx1peqfokx9efk01vHhPIZO/Mkb09y49Faq+X
	 ehoz6ALbjuRTkAAi5MgIY4obX8FsaqI9k1dNqaFaEUXWEoDJ/7z9tsN5IRkOC08EmP
	 OyVDV7Ol2N3aRBk6J4qJ9jIXnA0rhQjmx6ulr0tGkXX1RT/4E6b8qI5Bv3NweZ3aVb
	 HJBvJexQr4YqhbmyKxqD1Qm2MOdGO9Z1UYrO0rDt/jseLdA1plldK/Utww719tlUyG
	 SjRG76IFaDvKs7/pvfeD0RGPegjGit7GRXTnzvMP2x3zDyS0CTAe5ZyMA4hSsDOQ4q
	 8eDxFQQLFLBYA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4TTZr260Dzz4xLq;
	Tue,  6 Feb 2024 08:38:58 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TTZr246CQz8sb7;
	Tue,  6 Feb 2024 08:38:58 +0100 (CET)
Received: from [IPV6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab] (p200300cfcf117f00329e6cc2267643ab.dip0.t-ipconnect.de [IPv6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 1572D100851;
	Tue,  6 Feb 2024 08:38:54 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 2003:cf:cf11:7f00:329e:6cc2:2676:43ab) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[IPV6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <a384b6e0-b32f-43b4-be09-99a919d78f91@rd10.de>
Date: Tue, 6 Feb 2024 08:38:53 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Content-Language: en-GB, es
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
References: <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
 <3003956.1707125148@warthog.procyon.org.uk>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
 <3004197.1707125484@warthog.procyon.org.uk>
 <3113886.1707204762@warthog.procyon.org.uk>
From: "R. Diez" <rdiez-2006@rd10.de>
In-Reply-To: <3113886.1707204762@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170720513438.31564.478875919904852517@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 1572D100851
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: bX5wLrjAObg1aFORpjTubYOXjYd61LuGMtgHSBNR


> Out of interest, are you able to try an arbitrary kernel?

I'm afraid that is beyond my Linux Kernel abilities. I am just a user able to poke in some configuration files, and maybe fight a little with Synaptic / APT.

But maybe the Ubuntu guys can. You can reach the guy doing some extra testing here:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634

Regards,
   rdiez

