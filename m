Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A217D8468;
	Mon, 11 Nov 2024 06:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731306701; cv=none; b=kz+/r/vy73OE/z9sCo7t/3KV/WfDQnf7NMUdegs9hHHIZXTnvQ+UhFXH9tIK8KzePqGp21LmfvsFv+sR28S0XHxPeGh580KC+R2iA1FsYiOF/lnQkru27M+wkFEs063gOEjuesUB17SrP3wNQa4ElxRzWPYsLkKm1tbFYfWRoJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731306701; c=relaxed/simple;
	bh=Z4c521/2axtqq3BARK8Mz9YTcm5ccQXhEiB28VSaRTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XlkWTzLHnKvWqc1Ha6zY2ywyTOOtizOg9LwhG9GrW/ImS6Zyedh1P3R4FsQPYZyj9Eu/OxThvtoSslqlMmN/2f8cw8mrZl0FllhIehNs24XhaOynyMUE/Hq73v/4SakpA7k8xia1jEZ76d3GTLOjrwV5apC7ytqd+v3MrcM922E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LvfCofz7; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvfCofz7"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7ee6edc47abso2773841a12.3;
        Sun, 10 Nov 2024 22:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731306698; x=1731911498; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WXpWvz0Qv6z1AewP6mYc3kyZfjZbPBjaNa56qfUEE8o=;
        b=LvfCofz7rGkTGF+eRvU8vMl1dcWth76falsansSoSZzGLGwJE3gcTBW1uKdy17bZD3
         VAWxXsS3ZNvkED0DCQqv4wR4M44DErWiRLaD9INFtiADwRkzmzQZs0NHtSpaM6AzekDC
         j7JbmfdhgxmfwDX1d068p3scYhTNEuUCo/tNx+AkcFTSyBoY2HTPl/a6FFWKVLM7UuwP
         LnHgyTE3GIMJnMFDuzqld6o1QceDrspoFQHsI13BU4tJ5qGFBxZOYkDlNNAucEH0CRqg
         OlQ8UERIkGn5ufGHPAW7YqICSLPwwPzOKOVzOytATSEpIvVEzbC7kleV5tCfz8+/WUyY
         epQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731306698; x=1731911498;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXpWvz0Qv6z1AewP6mYc3kyZfjZbPBjaNa56qfUEE8o=;
        b=pfQC3swHu64o6vRQtc3CTySObhE2hWQ8jccCNUPueLAWIlGtHrte44AZlh4wsAsddT
         pGN7b2e30EZYpuM0qGaBWdFxFHaCAP4m1DiWovaj3lQmswv4lZsD/bczs+IZ/eq21ggK
         AXUdRvbNMUnGqdLImxXsSM8J+o2WPw7CTvyqM4FQqN6/tHF33dLiZwndflKHEKHEH1aD
         qZoyvscKKzzKSl07UxXrEwRRwdm+w6kgIXETW0ketqWvGJt6AFsrKli7SfT68ANaXs5d
         FrzDS/o7pqoX4O5aI/uD3B8jR/alVvAXaDykV+P7z/sA8n+yQePS2uZp6qnpsSF/ZhsR
         +7Xg==
X-Forwarded-Encrypted: i=1; AJvYcCV7KAiGlKjXa34GRz+vDyrqSn9d7hs7jCcaKDs8DILu0Wne2EAwE/dIWlakKv83ySatVqgFqN968LU6@vger.kernel.org, AJvYcCWlTe9YtZ7Pl0Q/NiCz6Eauzw2Q394ZyXx1Q2Rz/iTU7nmXg12XfKkjWYyr5O514OWS3wWAj7/V7vCuof/a@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+YTEVFd+dYhzLdx6IEIPy+TAOlwzksw0055zfsx9khKPYdYJS
	fl45TTv3b+DbFLP5BxmvBb23PDYCnZ8a9QvqebaqKhyB3FEr7OPAWh03xABtKsaMUJJX1TTkTtd
	PGVJfcBJ0+jWYDZy2JroEfaJr/tgOa6CMytM=
X-Google-Smtp-Source: AGHT+IEzhxaGaGl/GBxq3P6afyCic6It5guwLyOkDVy40lR2gGXznKUwHu5IgUmo7o72wwokDXZ+A/AAEwnXGUdFwHY=
X-Received: by 2002:a17:90b:53c6:b0:2e2:cf5c:8edf with SMTP id
 98e67ed59e1d1-2e9b170eaf9mr15710113a91.9.1731306697869; Sun, 10 Nov 2024
 22:31:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007210214.102568-1-linux@treblig.org> <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
 <ZzEOuqDwagwoGCMf@jeremy-HP-Z840-Workstation> <CAN05THTgj+_78kG3LFnpU9zsjEEBAsyDZ0P20YL3-DP94r3KUA@mail.gmail.com>
 <ZzFaSf20nIbppt8w@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZzFaSf20nIbppt8w@jeremy-HP-Z840-Workstation>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Mon, 11 Nov 2024 16:31:26 +1000
Message-ID: <CAN05THQXYNgG=Rji7r7xU9UF6ZBH3SP405o=D_F3nbbs9XYChQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath S M <bharathsm@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Nov 2024 at 11:13, Jeremy Allison <jra@samba.org> wrote:
>
> On Mon, Nov 11, 2024 at 09:02:03AM +1000, ronnie sahlberg wrote:
> >All of SMB1 should be removed.  Not just disabled but deleted.
> >
> >What are the plans in samba? Any timeline to literally delete the smb1 code?
>
> It can already be compiled out of any build,
> so it's an option for any distro or user of
> Samba.
>
> I'm not sure deleting the code is needed at
> this point, as it still has legacy uses
> (there are still commercial uses of OS/2
> out there for example).

There are still costs to maintain it. Especially since weird protocol
quirks keep being exposed and affecting semantics much higher up in
the stack.

There are probably still someone that runs 3Mbit Ethernet with 16-bit
MAC addresses.  But we don't support that with modern ethernet
drivers.
