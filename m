Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933913ADD
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 09:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.59.206.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707124397; cv=none; b=j8FEs0Uj9rYFmz3mYg0G3QSTxri3goxORYiM21OWvjUFpTH1DHCu5ikl/6WDephR4+sIFhLgXj6PvbWINqgHb3lpnRJEse5E4RkocADtUYJEK5tOxx1/nIu1KuIVn1OgC4TXiN+Dw7QIw4KHQ7Mrb8fXXZQQW3p3fn14Map2K9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707124397; c=relaxed/simple;
	bh=0mULUSENfdJreEXktXDQZ/g/mgQBjBd1TqTi5XWD1Vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=OHXxkYIbzRGb/AoYtjrSVpqTnRxe8y6T6hu1WJGeERigWbYaVprpQtcrWJIJsakgjW/kWxR08LE6zDjR3IuhNQO1J+SnTJBEBqx36+/88aZTWKDDQW1xrDY+TVCTbEOWspMiAbXj2qxv7w3pGOlzL2X76kWgk1DwT+6SDTn2dVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=jy+Cl3pL; arc=none smtp.client-ip=194.59.206.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="jy+Cl3pL"
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4TT0rH2lp8z41xy;
	Mon,  5 Feb 2024 10:07:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707124031; bh=0mULUSENfdJreEXktXDQZ/g/mgQBjBd1TqTi5XWD1Vc=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=jy+Cl3pLW3eW8HnZHEgbx0zRyXs1ecCfO7HbJSkBdmxtI37m3/ih+REmBLIdre2f3
	 fBOqAZ1QuAwAge/qg3gmszOj6kIA5jDcYHV4HTfE6ijK7TiuEYwruJkq15/p5vWFOB
	 C78cB3dQ3RkB+Ivt/1uMoUmvTs8CBgBCyaP7x36mwfOSRxDdYondFuJERVoded9Zh5
	 1REaJ3TdRU+0vbYYx0UOwB4N4w8Cq08p6R3xECBg+cb5BJAr8QZ1+IiMXIvNTkKpFm
	 /L7idaF7B2fBmVw+zP6s7kf+ied/0WjttkJQdWIQMS/MEq2RxOMttLEFaJXRdnogty
	 AkXtFVQl4tVdA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4TT0rH2N9Bz7wPh;
	Mon,  5 Feb 2024 10:07:11 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TT0rH0qgNz8sbH;
	Mon,  5 Feb 2024 10:07:11 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.251.92])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 69B951005CA;
	Mon,  5 Feb 2024 10:07:06 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.251.92) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <ec340836-831e-462e-8a4d-3aece977e19e@rd10.de>
Date: Mon, 5 Feb 2024 10:07:06 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to automatically drop unresponsive CIFS /SMB connections
Content-Language: en-GB, es-CO
To: Lucy Kueny <lucy@kueny.fr>
References: <428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de>
 <b5a481ec-7c97-4b28-a807-606bea3617ff@kueny.fr>
From: "R. Diez" <rdiez-2006@rd10.de>
Cc: linux-cifs@vger.kernel.org
In-Reply-To: <b5a481ec-7c97-4b28-a807-606bea3617ff@kueny.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170712402669.20480.8089113010699496196@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 69B951005CA
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: u/fQSj0cGytiR/b3i2hYBCVX6R5Cv0+eLhuRIcbF

Hallo Lucy:
> I have written a patch that does this.

Many thanks for confirming that this problem exists and bugs other people too.

Unfortunately, I lack the time and the skills to apply Kernel patches to my Linux PCs.


> It adds a mount flag to return as unavailable immediately after N reconnect attempts.
> [...]

I wonder whether the approach you followed is ideal. I do not know much about this area, so I might be wrong.

The first issue is that there appears to be no documentation about the Linux Kernel CIFS client's behaviour on connection timeout. I find this frustrating. I have done some research in the past, search for 'echo_interval' here:

https://github.com/rdiez/Tools/blob/master/MountWindowsShares/mount-windows-shares-sudo.sh

Based on my empirical research, there is a fixed 10-second timeout when reconnecting. Therefore, I would rather have an error returned as soon as the connection has been marked as lost by means of 'echo_interval', instead of after attempting to reconnect.

This may be hard to achieve if the reconnection only happens single threaded and on demand (when a process is trying to access a file under the mount point), instead of automatically on the background.

I would also welcome a configurable connection timeout. I normally set echo_interval to 4 seconds, as 8 seconds is long enough to declare a connection unresponsive. In fact, even 8 seconds is rather high with today's networks and servers. If the connection timeout is 10 seconds, that means an application may take up to 18 seconds the first time to "unfreeze", and 10 seconds every time afterwards, which I still find too long.

Let's hope that the CIFS guys take this problem seriously. The Linux desktop freezing for many seconds in a row is probably putting off many users.

Best regards,
   rdiez

