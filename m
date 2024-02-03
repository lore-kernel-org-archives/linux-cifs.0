Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485312E68
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707001376; cv=none; b=oCNuTLJxV0WgXV5ArEQsDuHUKDr3twMSGfKmV0OhXvNK9KwBrKwrD1jPK9e5u8TdlbmSwZmyFd/cgiiMwedsDYhwIhx17NIdRtuzoIil8Y/2GlyY4bUq5tcGz23u0DDkhbCEsyr03R957hqGG5jaSemXwBCfTJ2Gj9EqNEooaMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707001376; c=relaxed/simple;
	bh=fK01hh23ykgw3qutGPm7o9kaGeUktmDS8ZA3wcS1zUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0ifAajILkkRhCgxUWCzLcYIRMsjC3YIO5nOp75LV0SbHSCIhkEBH70Xk/fi2ZWErUvlz3/3nZFTebrzDCnkvi/mYdGlgDHp2rj5Mqgprs7og/TjLWZ6j3QTEly0SaITc344jVa4qWtQSPf3rBwEntEDvXMb1mcf2TxyOqCv/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=Z3psgwzd; arc=none smtp.client-ip=188.68.63.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="Z3psgwzd"
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4TS7TR1TFFz5yVG;
	Sun,  4 Feb 2024 00:02:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707001371; bh=fK01hh23ykgw3qutGPm7o9kaGeUktmDS8ZA3wcS1zUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z3psgwzducIHmP363Rg3ChFu0S+DEx49dxHIshj5vf4/Zhxd7zZOEXyvyQwOalcl+
	 0bR52tsbmhb5ifJFgKXasITpTUrAjeYadIlQRrppkYUpwZTphEF0nSOTkOxt2bQJlH
	 cB9ZijiwYdT29uqjJBdqkD9+YEmj0c/uQtyTr1yP5UWNBivpeaPlVq4/bphcjszWcY
	 9GqWLFecEd7t5x5QtFvbzAbqXl0S5BM8Qz4N5d8YTowxd15uiLc5kEvJOB4WrYJxma
	 sGJBLNXwjXG2qnGUlbPVUD4IBDD6zOHUFu7vtyqzrU+A4UKI49TqVMFyFAvIdmXyVj
	 NTws1Vt/49xjQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4TS7TR0mV8z4xYq;
	Sun,  4 Feb 2024 00:02:51 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TS7TQ5tZ6z8sZf;
	Sun,  4 Feb 2024 00:02:50 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.244.140])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 424B61007EB;
	Sun,  4 Feb 2024 00:02:46 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.244.140) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <fb4abd14-b002-4056-9dfc-1b7f5c83f84a@rd10.de>
Date: Sun, 4 Feb 2024 00:02:45 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Content-Language: en-GB
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
From: "R. Diez" <rdiez-2006@rd10.de>
In-Reply-To: 
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170700136654.29116.14943511454839720127@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 424B61007EB
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: F+tQCHWzTPT+xThRjrhpa8hLy1DsGWGUwRVNh6rW


> Do you know if this is also broken in current mainline e.g. 6.7 or
> 6.8-rc2 (for Ubuntu and some other distros it is fairly easy to
> download from their website current kernel packages to make testing
> easy).

I don't know, I didn't test so much. I am not familiar with this kind of Kernel work.

I found some newer Kernels for Ubuntu here:

https://kernel.ubuntu.com/mainline/?C=N;O=D

But it looks like many of the self-tests fail, which does not help build confidence. I fear breaking my Linux PCs, which I need daily.

I'll see if I can find some time and some spare computer to try this out, but it may take some time.

Regards,
   rdiez

