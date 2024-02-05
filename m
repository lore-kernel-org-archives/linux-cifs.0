Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436F8134C6
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 09:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707125871; cv=none; b=DMxUreDFVzILpvx4riROOP1KM+LKEji31kvifVI8oxbSAEtgFkhfdrXbsnW0xioeNhQXFC4eUo/ru/gYQx23x+K7ZCGlOhBM2Jhhk3Ie6/+Zhx9tttghtJ9SU3mVn3LfNI9v2k3g9GeNNdGpqnQSGXWHzHLhrMvOxaER9AMfsOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707125871; c=relaxed/simple;
	bh=het7fmG+HcxET9yIZHVl3Gp9qbL6Tc04QaMnNlqaTt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I121YrASQecNfs5Q0mOjPK97pVSIzTbJekUVFCAWsVdutEbUHtOEgaGuE7YaA/+ZcE6aBEV+EWBj1+6khLonRYlE+gQxfu2kwgKjLOAfRp0hyyNRSlTV4m4ALOOen+BfLmGVN5Oa5h2VNj8obsShGjK1XPTfvNPjdxV8kuABOrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=IXUGfLjV; arc=none smtp.client-ip=188.68.61.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="IXUGfLjV"
Received: from mors-relay-8403.netcup.net (localhost [127.0.0.1])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4TT1WR07Fhz80pb;
	Mon,  5 Feb 2024 10:37:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707125859; bh=het7fmG+HcxET9yIZHVl3Gp9qbL6Tc04QaMnNlqaTt4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IXUGfLjVcB5YB4n8Gh/RwPcTGacrVRPUaSGep2auHpWYHP8Bt4j30A0PuthKOLaiA
	 QufgkmQKMSShL9xcnAzibLnPUItw6o1b1bG+NdkEsbIwW3e+QlenbvIAnUUig2yWXS
	 Y9fGBDChW0weWS5aGyVlDq/EcXDETseJ+90PpJj5eArxeNlUWiVDjgJ/+vZz9SXCZ4
	 sYKrzZ+SLvIB+1kNNoLG3Kvlm0bRUJGJkvw2+jdb8mesqRpx+NTQB/bdVeU0RdHb5l
	 zkqJD5DSL2xFUifp0xSeChwNCICH87IpaIig7TBwMLNv5Uh0MroA8Z5kE7DPtgG8xf
	 sZs6SDehkXrOQ==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4TT1WQ6rWsz80p7;
	Mon,  5 Feb 2024 10:37:38 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4TT1WG6Dnfz8sZl;
	Mon,  5 Feb 2024 10:37:30 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.251.92])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 5E7831004F8;
	Mon,  5 Feb 2024 10:37:26 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.251.92) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
Date: Mon, 5 Feb 2024 10:37:26 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Content-Language: en-GB
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
References: <3003956.1707125148@warthog.procyon.org.uk>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
 <3004197.1707125484@warthog.procyon.org.uk>
From: "R. Diez" <rdiez-2006@rd10.de>
In-Reply-To: <3004197.1707125484@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170712584664.25379.7279760947497558634@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 5E7831004F8
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: P6wNJ4Rq1iHbhx3njCUkGiN/C1TOedTtTjBTNhLa


>> Unlikely as you didn't take them for the last merge window, let alone 6.2.
> 
> That said, you did take my iteratorisation patches in 6.3 - but that shouldn't
> affect 6.2 unless someone backported them.

Please note that 6.2 is not affected, the breakage occurred afterwards. See the bug report here for more information:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634

Regards,
   rdiez

