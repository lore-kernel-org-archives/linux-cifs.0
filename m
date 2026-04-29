Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B694B3876A9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 03:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777432650; cv=pass; b=dfQYkQXA8yEjZI7n0zufV5N0XBMQMLyRw5Gmb/pvkaQ8dAU7loSutGg1T2xrOqSv5ptnZL3EkPb/5mAuINnUki/lKbrvj7xV75OzhOJhMDldOw4yLlRVf9tHaIgWzu3nqPK/JgBBzHtTiwXmYsu7Y46GszaIDrsX7NTEtYWtMyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777432650; c=relaxed/simple;
	bh=yJdPis36K/r/4ST05sZ4v02Z3IZMoEILTHabHEn9gFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=noOnIMytufxhuzR3H/JiOH2K8FkveP6UOEf/HqcHexK1AZitvocDj8SYeZwWJaq5jbd91Lav+s93i8/SjwhYavddikBMaHVLQwrjcR+tqsQLBLHEDAeeJMIfRQGWO31ZrYlX6aThD9AMJ7pD2DAC4Ex2oqZtEs/dRH6x+fQZ0bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYn1cqXB; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYn1cqXB"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so12031734a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 20:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777432646; cv=none;
        d=google.com; s=arc-20240605;
        b=eVFvXxUdDwm6JhgcKEMA+vqbwoDKnm/xBBbPKxOAweTji8L7hvOOcrfdbgHKr3F4NV
         1C/79UxYPrXUVtwLqF/q18QPVx6hn93g3GAsxgQatNFlnZNRFMPi+auZZqCnL7q2sBLH
         uk0womiqLG/7cphan9UD4aNazoUbg6QwMVx/lZMgIFcNr3KCshipwRW3gMR9G54L6Kky
         EUSjRSIQKbFTzO946g1BkQSrMFLVLGFW+daO5jMyDO8q8/l1Ep6lZQK7YPmt4OgiLGXY
         8y7t2r0HhoqBp/9jZvXZN8yAgBdc4mPcp6wSE14GYi7V9wqXzWQnMtB7AbVxeXMgZV8c
         tdEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YuD12r4Qlan/ix7+SIyh4cuZxCxRV0k9SHIGi6zVYL8=;
        fh=7RrK0OSAj6XIrxZxCK/2HeJuF3tOmFEkJG53UnFgqIU=;
        b=UgUPm84+zblR3xDnBcL8E69EexvMyGSYezpMs5PEWidFHg538WaKpw3oeiWB5etHtI
         xA2GWQ7ZJXLcLdSngzFyIZwtchVZ9sYEI/46DQAAx6lnImbnYpkLpmWjCgcNn1GmS97z
         6KpMA5ExfPnIIo9ypDdIvxbOLDrRwpa9bn/u4kT97UHJqHjAsHABqIr0QKjZGOHQ92I7
         hLqfwZWa6fPDjUSH3M6FZObz+374G9dVaJmI+BB46uJ3dhHopEWOxstG1JTLoJOY8Aln
         03crV6ZtlPCq9C4GP8WyqwCct8XA8VbIngRem3z3dBXJ/lnO0gxoj12wvHJwLsLorz1A
         UH1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777432646; x=1778037446; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YuD12r4Qlan/ix7+SIyh4cuZxCxRV0k9SHIGi6zVYL8=;
        b=aYn1cqXBdakCjgDrCZGvJxnGBcSUcEH/UNJTPdolx0yjQU4FYoTQdlkSIxf9Agvbsv
         9/hmj2P4KMQnw3AboxgZBJPjoyz9Oq7x6glsviCsgzwZuZmvjpF582j4JxXind1dkzf8
         bhymg/K/2vk5C0J/UdgUb60L4D1vKWa5QbkSrpDXokFUGFYdTlSw4CoA1cyafqAkBtT/
         2aM2wgKexUhd8nk+30mO4sMdwzsaN3TSoEjL8b+4DSjzm69KpzHIlGQ66t65+HNmycxq
         Q8GEnLNDL7OOwTKqqsBhRiEmRxB65HnxV8FWTYSGBUVZu2OovjXt9iyor7CafPvasp27
         w8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777432646; x=1778037446;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuD12r4Qlan/ix7+SIyh4cuZxCxRV0k9SHIGi6zVYL8=;
        b=ngNVSNmyoUVTngLRmTeUDR27T3Mbzw8U4bEF39znDq262WUs9Utmmnpwlut95qL35h
         2ZYYsx+1Szog0Su5BHKmAxTxDbcgdz0/dRSrtpbvJlxHk7/T85oC+IVHWKR9cq/RVMQC
         mwPf12iHk51CyaWstBsklaMdXktjPh0br0540ZMNHKM3tJVDs9Z/JN6QbxktKWI/HhFY
         2Q3Y6iF4pZICnTmIp0rD9FPeutt6taGLljCRn2ITbaOPZLMJH+VgAakjQ3DEis6XRK1Y
         NnidwAtsFiIRPz+ffdozrPNhCjZBa+dmuMZf99PsSq/xEcNgxpbjYVkRveZtqr/LoYwD
         Zpng==
X-Forwarded-Encrypted: i=1; AFNElJ/UolkpqWOp5f8GYqwnWZe+04B5SRmRaKsYGFex7kuQ0lpaJVZL0aBem17uh0bOcwQlcpnROcBRjBEk@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnxm7/6xdeud77s30pZfK17Qz9fEGFtC6SbHuxfnUhY0+aMF1T
	4W8bEKkx97iNytJwR5W9UYlxc4tZysPfy2FC2Vrow43gC6H84neMWx4bBZUQcAlvo1IpLC+raFL
	AG83Ts3jebfs1yEMv+oY5gPlYSVdXArM=
X-Gm-Gg: AeBDiesMDXS6fkva5Pl3uMagL36CVzFsGdjVPlvNwZb06xYnXFG3bQhPwCUK3gEogf7
	JTGmxllbNo6rS+4rWr0EwJ5emdh62HrbzMqe1FPBrDKEFi739bQNompPGq8q36TZNV3FKN3yjF7
	ThtIrRpNJAG8Nt9VbNrYrpkeWgBQyYBbCURCSSftD95/tFesBwr9U5M/iLQ8U6eYhCVwEWsHLz0
	dJhT3gdx+3B2NnbI4f/ZEDPMSkUIeoa4hVaAQkunAEPbfplufyT/7fsni7wQRRizo6qgG9aFueG
	PNCBcRjdOfESauAX
X-Received: by 2002:a05:6402:2802:b0:66f:76d7:56a4 with SMTP id
 4fb4d7f45d1cf-679bb0a1317mr3010521a12.26.1777432645633; Tue, 28 Apr 2026
 20:17:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416151839.3315696-1-charsyam@gmail.com> <20260416204539.3536168-1-charsyam@gmail.com>
In-Reply-To: <20260416204539.3536168-1-charsyam@gmail.com>
From: RAJASI MANDAL <rajasimandalos@gmail.com>
Date: Tue, 28 Apr 2026 20:17:13 -0700
X-Gm-Features: AVHnY4I_e5uPWJlIuzBJwy9w-CMDuIk2Vh0-JFW-klB4ZigV87Hz3BzJHxIEkIg
Message-ID: <CAEY6_V1pbh05BWHtsudj3XAdsAEM1Mcj=KFH9We4mg7oD9fv1Q@mail.gmail.com>
Subject: Re: [PATCH v3] smb/client: fix state corruption in smb3_reconfigure
 multichannel path
To: DaeMyung Kang <charsyam@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	rajasimandal@microsoft.com, henrique.carvalho@suse.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi DaeMyung,

Thanks for the v3. One minor suggestion

> + old_chan_max = ses->chan_max;
> + /* Synchronize ses->chan_max with the new mount context */
> + smb3_sync_ses_chan_max(ses, ctx->max_channels);

This reads ses->chan_max without holding chan_lock.
smb3_sync_ses_chan_max() itself takes chan_lock for the write, and
cifs_try_adding_channels() / cifs_chan_skip_or_disable() also access
chan_max under chan_lock. So there is a potential data race between
this unlocked read and a concurrent reconnect path writing chan_max.

Other than that, this  patch looks good to me.

Thanks,
Rajasi
