Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7C24B2B
	for <linux-cifs@vger.kernel.org>; Sun,  4 Feb 2024 19:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707074129; cv=none; b=uzM5iB9YHZoqf6T6uoeC+DJIbjJjoJKukN5F8iPLPOmjsNxiFFSnjSw4GsDdh5CA6+6OMTiV8X3PtFe/ZzoIVmMeMtTZpeHwKh5j5hf94clXzom3bwTR8XzNmaWlBBeaD+IfSAovXCR0uJqce/6UawmtFyRxmBj6v7QeOiUuw4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707074129; c=relaxed/simple;
	bh=BSQFI1jOLgbBn5T9cdQtRPSN9aFRYcL13Q48TeyZW/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwwQ8s1gYl999tgNuuFLt6rw6G8Z8rF8HyryBGRRN9SSUcYz6QxEJy5SfRCDju1YjcHhbQ3F+xGMNqBcGnLKr1Pw2bobwNC4CAfkre+TSFOFytj+EV8IUTycNWC5/jF6ae5yy4jlCpuhQdFE7u7I62wRHdKIcZMYaHYXswQTHXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=ly0xl6nP; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="ly0xl6nP"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4TSfNN16Tjz3trv;
	Sun,  4 Feb 2024 20:15:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707074116; bh=BSQFI1jOLgbBn5T9cdQtRPSN9aFRYcL13Q48TeyZW/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ly0xl6nPlP0NoTpItXcQYEPcPkV/6NQotQ7YAResoM5sNCS1PK9XEB8mJVZ4yd5rN
	 +1ecRQcyKtPdKAD4h+2FZovfK7yhyDaLZwCzw1A0w+FosfmvDBuKaIXRzqe7ynnvjo
	 UBqaY1OeHY8FZRm0xfW3g79DB3zLTHH88sUQgsw2HxgzIo8owXL+2OyhTeWvCIbkqL
	 kCIXOcEPNvQkSDI8CFnFFx+3GFj5DFsgjNBwR99A1g5bABxdUH3vF9PsJ4gH/1wzFC
	 RKKj76hmE8ah0QqFWAamOUrFHRUUYcoekjJbY+uGtm4g5Jri/SuUszxQutgr16hwBY
	 BbyxLBV/bq5HQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4TSfNN0QKdz3trm;
	Sun,  4 Feb 2024 20:15:16 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TSfNM511Tz8sbF;
	Sun,  4 Feb 2024 20:15:15 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.251.92])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 322D5100721;
	Sun,  4 Feb 2024 20:15:11 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.251.92) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <6a65b2d1-7596-438a-8ade-2f7526b15596@rd10.de>
Date: Sun, 4 Feb 2024 20:15:10 +0100
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
X-PPP-Message-ID: <170707411146.32644.8143352906168118458@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 322D5100721
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: /SZHVKucXEsJmmb0+/tmNdpvLY+dUANJTMcPzfnx


> Do you know if this is also broken in current mainline e.g. 6.7 or
> [...]

I just tested on an older laptop with the same Ubuntu MATE 22.04.3. I tried with the latest Linux Kernel build I found:

Linux rdiez-L2017 6.8.0-060800rc3-generic #202402041232 SMP PREEMPT_DYNAMIC Sun Feb  4 12:41:05 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux

The test text file was corrupted in the same way. In fact, the resulting corrupted file compares (with 'cmp') with the other laptop running 6.5.0-15-generic #15~22.04.1-Ubuntu.

Regards,
   rdiez

