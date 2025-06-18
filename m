Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AA33085AA
	for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285487; cv=none; b=OSTK6m4im3z/OLjiljZwui7HR5pjYZO8tmAOlTmDMLnQDi929dEjC3f09Cs+tLJlyTlb0zrCxEHHU67FaSZuo32bOfBZaxGAm+VgoJxuCm49ow9TomkYWWO8L0H2x5TphnOWCzpchbf0kwXks/XzuWrD+RPRHKXbgX1mZgtTWdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285487; c=relaxed/simple;
	bh=xhHcGJI7ZJPnRvgzX13bM3JGdHjUkZekfWR6UFrJVnU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=SYhyZoFMd8Ns8UkrzvxWo7kYUd9rO9bQU/JhYbKy42IkUDBeyShRaC7xXNV0+0K+iFpTyTTcmJski03BqMP2fcPOLkEoN2qqNVe7kFclBw5/XQ9mCeO/4RQPieNALPSgf8PHQJRBR/1fywqZGIkWBPpTmBVhdt5mT6xI2fUSOrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYROa9p6; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYROa9p6"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-553bcba4ff8so93022e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 15:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750285484; x=1750890284; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KxQhDubABj6uaLJxZ4q28EQg9L/Fekhes499ywIf55U=;
        b=SYROa9p6dHbAxVZVZdqIfTBDqU+STyI/U5hTMkDkJfJm1n5UXwUgbyLsaQugXFl1+a
         Avdc7mbWzStcgudCujcNzxgAlJNb97GufnckMHS3tccfUlkqPrNT60ZOtK1PLG4i6h8y
         tRRBM2jvbUFZbqlqAC+rUI3xhK7Xlk0NDzckAfDew6RCmhxoolYbN31tkY0RYJZUTe/O
         bNe0FUocdZ+U2xrJHaw3eggEzNMdtvlnh8FkgIu+k5ZzUiLt5OZuuQ0kdC0do4B3u4mK
         pK6sN5kbele7KyTieVkumFxi5KNFrpHalGZ9kW4GGbKOewEjISiW4Mq2MF8UgB61aYL9
         QtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750285484; x=1750890284;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KxQhDubABj6uaLJxZ4q28EQg9L/Fekhes499ywIf55U=;
        b=XhqyCADVHJodUQheHLxXT657VSROWA1epGk7O//+AjsNODeqFknmZuJfLA9noa+Ria
         q+PYmytvlm2aaGuMzno8WC1YgZ0Gh2s/MmnuvN+uWsz5JrCC8yiaQFGlddNBwHKuOQ/z
         sxVOktCDJ9plhp7FH6GaL0X79MbuE+zYmUm11V0d9NRWooVQc4hRSrLouKaBd0triFJ6
         R6FinqM7b+Ov5gt2cigWJvuXLJmLAH1LXck4+l5w8rq/Pf/Q82onQxQumFBVb2ADZzgr
         W19Fb1/tcLYob+lxp9pSA1sVZV/W4q/meWg8tfJq32QgNxrqBg6BNVAxUlfkqE2dGO/i
         8xog==
X-Gm-Message-State: AOJu0YxLyDIjLp2RAw5cjBBLY157N3gQ8dRVZ6j3+zay0XbMO1ep4ST6
	ih4V8TzO3Isblhf10bUioUD/BC504z7AecXVUaACdKgE+7MikJPnKV+Tyfg0lSurCu4BIk9WW5H
	Kxk8lO2DfZSW4nZo2TqoU8L2bZBKOOaUa3g==
X-Gm-Gg: ASbGncv6HT6B9IIRP5eDG8rZ9y3vsaWgsiWDH7MFaVzPoDf7NPKum0kPDSplQZX0+ce
	645n7LhJd8E22f0nL1xEkMDp75F0nSIqI4yd4PO20rIo0tCTl6+hoNoYhurub8psWJhAciw0Ikc
	jLsdn3Wm3ox1ADFWVC3C5CWI4xElLRL1rZsFD0LoAie5pemxtYJT89rByQc1HdkH8salF98ZAlK
	6FHug==
X-Google-Smtp-Source: AGHT+IFKWkYleReGlaDeMZSGoeOcdHTZI6FuBSdm7IoLx/5YW/44/CL3YqGcIw2DYFpNrlozaeE4fxezGa538frgb8E=
X-Received: by 2002:a05:6512:3b13:b0:553:d573:cd6b with SMTP id
 2adb3069b0e04-553d573d055mr980556e87.10.1750285483500; Wed, 18 Jun 2025
 15:24:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Jun 2025 17:24:31 -0500
X-Gm-Features: AX0GCFsVWtBmDqxDregn5D43skKGu3Get2qHilpdUKL1gYfeC-e0WYlzVJdgdmI
Message-ID: <CAH2r5mtipm8KB+FwzYKAvNqH4ECAv+1+SUqyZ0ur6k6Sy8KoAA@mail.gmail.com>
Subject: smb 3.1.1 client dir lease performance
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Bharath,
I noticed that with your patch we are caching directories (when server
supports directory leases) well for successive readdirs which is a
great perf improvement but I also noticed that they time out at 30
seconds from when the first readdir was issued (when the dir lease was
first acquired) and not delayed if the directory is requeried every
few seconds.

Thoughts about bumping the timeout on a directory lease
experimentation to when it was last accessed instead of when it was
acquired?

I also noticed that when we hit the limit on max_cached_dirs (16 by
default) instead of evicting the oldest entries in the cache to use
the newest dir leases we give up adding cached_dir for that
when we hit the limit, even though some of the older dir leases in the
cache may be about to expire?  Maybe we should replace the oldest
entry in dir cache with one from newest dir lease

Thoughts?
-- 
Thanks,

Steve
