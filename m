Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86A21E890
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 07:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707204573; cv=none; b=pPVk1xm0GF4VoUrVeoTxLBGlVRu2C4SQwOrrmV8Vu+KFczVvMhyOyc1sdhGyBp9Y7K9IqzuOHyDRuJlxR1/b4Zazl+XW9JZ6I1aR/egG9uxkZpf3JQDVLjcOshfQSWQ3TzFnYBJSuMxJp/eyPvlHj5rfP7yZWGwILfR1Htc1ukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707204573; c=relaxed/simple;
	bh=Gj8BSNCL/E/HLt6dwE20NS3RNnnwmKLPt4OUj6gucq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nH+zijUBdopsbPTyYfjp5radbr2s/XNDyHFu7CUXCtPjf9TOjXNoC0b26UpIzxb1FHMZiJQ8BnWloNTX73Pz7MmuBSCD/RqGUmYWmMa4OY6UiAX3D5N96CW4W6LtQLfDWmOIHiA2BJ+n6sxLQgYNhl07e+2BC2KEWLMH6u9IYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=VdE1XgQF; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="VdE1XgQF"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4TTZcy2Nxhz3tfX;
	Tue,  6 Feb 2024 08:29:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707204562; bh=Gj8BSNCL/E/HLt6dwE20NS3RNnnwmKLPt4OUj6gucq0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VdE1XgQFnAABX+xJufOEQAwNQPoyTSAE4bP78dZkkO38/jNDI+iZ1rUUzytn+pI8+
	 Y5RLGkQJ6sFUbA01mGMEqAsJ7Xv5bsJHFq/5cg5p+qvNhbF3HQ0O3UXOGoRvfOyXOo
	 EcbZxYS18mhbtzUw9Do2RrZC5EMsCZiA2QXf5+84uoD5xSKDeuE9l8li8lfuC/4HAj
	 Eo9aAv7jArcvTKeSIkBKciJMyVe9GYTc5geyS+xefkqkhApJLS6o0fzRvzS00Ig53b
	 Z39e8RjJUB/AvkQo8lfYgzBAsNHEhpbDvg8ua3WP5LVNRtPDamG7BwlAfzqUVz6O4h
	 +0F9c2nM6SHUA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4TTZcy1h50z3tdn;
	Tue,  6 Feb 2024 08:29:22 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TTZcx6H8tz8sZV;
	Tue,  6 Feb 2024 08:29:21 +0100 (CET)
Received: from [IPV6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab] (p200300cfcf117f00329e6cc2267643ab.dip0.t-ipconnect.de [IPv6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 445E2100851;
	Tue,  6 Feb 2024 08:29:17 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 2003:cf:cf11:7f00:329e:6cc2:2676:43ab) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[IPV6:2003:cf:cf11:7f00:329e:6cc2:2676:43ab]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <c561e42e-0dfa-46b7-999c-947dc52e7778@rd10.de>
Date: Tue, 6 Feb 2024 08:29:16 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Content-Language: en-GB, es
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>
References: <3003956.1707125148@warthog.procyon.org.uk>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
 <3004197.1707125484@warthog.procyon.org.uk>
 <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
 <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
 <CAH2r5mv6mvtSD3VpHKUtA_3zNDMGhFFkeLus1h5HpNZEJ2Q1pw@mail.gmail.com>
 <CAH2r5muy0UEnG1KmSgz1P_y9hP+-nj8wvZK5aGTGp6WW3F4mSA@mail.gmail.com>
 <CAN05THS4HuTfCHEpKG8D3mzo7omoz9mZFVuZGVTH_C2gqhKSHQ@mail.gmail.com>
From: "R. Diez" <rdiez-2006@rd10.de>
In-Reply-To: 
 <CAN05THS4HuTfCHEpKG8D3mzo7omoz9mZFVuZGVTH_C2gqhKSHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170720455763.31780.11518734095887205442@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 445E2100851
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: wR/5FiNwhMYF/GXbtRle8uq+SAfZAWCTTQ96wWpW


> Probably the easiest/quickest fix is to enforce rsize/wsize MUST be a
> multiple of page-size ?
> Is there any reason to support other sizes?
> In the mount api you could just round these sizes up to the nearest
> page size multiple.

This feels like a quick shot which may land near your foot.

The documentation does not say why you may want to choose a non-default wsize, but I could think of a scenario where the packet size is chosen based on some network packet fragmentation size. If you suddenly increase the sizes, you may trigger a network performance problem.

Besides, the page size is not always fixed. I am assuming we are talking about PAGE_SIZE on the Linux kernel here, but I don't really know anything about this code. Most architectures have 4 KiB page size, but there is the odd one with 8 KiB, and there is a "kernel-64k" variant for ARM with a 64 KiB page size.

Before rounding any sizes up, I suggest finding out where the issue is, and whether it could be fixed respecting the user-chosen sizes.

Regards,
   rdiez

