Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0105612881B
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 07:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707203831; cv=none; b=DDFZ7bk9WTrFnmF2UyLug3hbwD5v/DP+NuYa4dE5rIjrMM1G3VKy5d8W8euM37TB/NP8Oj1w6caBmLpXxFSS+kLzJEGWUXxPfFs3DUGcD1amVu1qphBn4MZMrcCt44ccD3KsfPs2xoJfVPTiNs9ut6+HarvuepST394NACyBNIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707203831; c=relaxed/simple;
	bh=/Dl3kv9KYRdJSV6m8dfnB+yhBX/ONihz4EvRxVCZxO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3IgZTGc3IIktDEbomBmNkTX98lFqInXDKOaTYQr0AJFaHfv2ks2sGFXoKbQbhh7BcfJLPjsEMGSTKM9SglifegBg0q8EAmkVI4aGl50eCPqmG8BQjvJQciRYiOmWmZ9fYym5Pm03X0wZOHZr1Tm4OBLlVcUs1cM1MPnRDfim/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=gJtNm6pM; arc=none smtp.client-ip=188.68.63.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="gJtNm6pM"
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4TTZLf3pRMz60Hb;
	Tue,  6 Feb 2024 08:16:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707203818; bh=/Dl3kv9KYRdJSV6m8dfnB+yhBX/ONihz4EvRxVCZxO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gJtNm6pMtYRCYIm5BdDQlNKTeCh7PUw8lHc2dZIutc//38MmLjd459MyoFdwMV55r
	 wKoYcxTrB3f3G3QXjGmWGw/TF7pdPM3sK9PI2QHqoKxB1xMHHRkDjiOQMDbfXGZSys
	 AJQYA7wTfsOsOjIJywy/RrL+Qs5qnwv/oU9QMz4A/UyzXEc9RIJJGx6Io7kF4rMFCv
	 XfeA/3f0aNN7bD5xRwQmJv85KKpCC+uSgjpXZBuL5alQYaUViQyQrbjHrDLfnSPM3B
	 G/ZnJyoChmWIdxnvufJGIZ6yPoNvqXFTuJaR+89SgHnpDim4ECYtvlmtVCKttLRCCG
	 aQDq87Hc5ZqqA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4TTZLf35hlz4xLH;
	Tue,  6 Feb 2024 08:16:58 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TTZLf0jGcz8sbF;
	Tue,  6 Feb 2024 08:16:58 +0100 (CET)
Received: from [IPV6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab] (p200300cfcf117f00329e6cc2267643ab.dip0.t-ipconnect.de [IPv6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 8EFA31007ED;
	Tue,  6 Feb 2024 08:16:53 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 2003:cf:cf11:7f00:329e:6cc2:2676:43ab) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[IPV6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <41e8ffc2-f425-4630-9895-e3c29a93e4d5@rd10.de>
Date: Tue, 6 Feb 2024 08:16:53 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
References: <3003956.1707125148@warthog.procyon.org.uk>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
 <3004197.1707125484@warthog.procyon.org.uk>
 <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
 <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
Content-Language: es, en-GB
From: "R. Diez" <rdiez-2006@rd10.de>
In-Reply-To: 
 <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170720381388.13137.1474549361359379686@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 8EFA31007ED
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: +bQ6NUJmAsc35TvKWE/Rz5x8L33tIBPPUTBjb7g3


> I can reproduce this now with a simple smb1 cp - but only with the small wsize
> ie mount option: wsize=16850.  As mentioned earlier the problem is
> that we see a 16K write, then the next write is at the wrong offset
> (leaving a hole)
> 
> (it worked for SMB1 with default wsize)

As stated twice in the original bug report on Launchpad, I didn't set a wsize, so the wsize=16580 must be a default value coming from somewhere.

This is not the first time we have a little communication issue in this thread. Would you guys please read the bug report once again carefully, and even better, subscribe to it?

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634

Regards,
   rdiez

