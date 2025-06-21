Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C932063D2
	for <linux-cifs@vger.kernel.org>; Sat, 21 Jun 2025 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750522201; cv=none; b=DilYKogAyU1hsmqvQ2YNYV++dv385ww6qQEL4+QHazIyF0+LSj1vgV4xCWbzlbcTeiLeOx3/8t4WyJCzf4uSc5zT0WmNFOloeaLHDxZSGwAQxJ9LvZo4GWHmrBlrTFC3nvLcQo2SYH+psDpbm1DVDkwmgEdi8c7uNYMO2Tq82/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750522201; c=relaxed/simple;
	bh=hZVmROOzt5gmR/oCOgZdaBilYrkNqyZT7daFih7mQeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b4e3tdA4ihEOqBh59XLi7OwYg6aekFNoXLxyef9G8L87x4HiQOjvmA+IBuOoIhk3k+W6ytt2GImryuODr0z2nee4jsY8YnWbxG8jBrD1tRzLvs7/LwOCtg5u5NU/os92RP42NvP1yvGunJc8kT0c1HzIDXUZTGJo+vqqxAmK/po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fIDCT9Qa; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fIDCT9Qa"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso4836925a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Jun 2025 09:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750522197; x=1751126997; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bR9CkFS1o49k2KhvLWDphFNGNkDZGgw2MDOOVeB8Wlk=;
        b=fIDCT9QaxOIFNEU7EpKQrFG1R+u//wjnook0ViX06hlDuFwKz8EXL/bAQQaWRle6Gw
         wRRUVJUe5tPZ2rmssPUKR3ShJdGvcFIJnw3tgSZApFUFRx2/p4ulzgcMvfQo6Xscf0Rg
         ULy1fA3A3ZokRE9WO27h1E7y7NLnqb+eNswNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750522197; x=1751126997;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bR9CkFS1o49k2KhvLWDphFNGNkDZGgw2MDOOVeB8Wlk=;
        b=JE2GLlp2qjGFGsbBCIBJb2b1GuNWtdwOA7AnUKuIbsG15lz1TucLZ1RujBNSSyFu5h
         I9vJCMjYXaiAp03y9borDYO+2J2xY+dZRdxmTYIPLnUiwpTvZKBYMzo58VjZHKhPUdFp
         6fGBl7X5LU8NwhprxzOXeBvwRVGIA5IAQKPcUJsGl2HQpLg7I7AsRmRUkSDHimn6Qo7Y
         FWQcjBpuho4ILN0zGRx7EzKcp4oI4zLMqjbdZrd0rGK8asoePklJ2HCc9PoXSZJd4mUZ
         z23gK2eSadLd0/pnpZLvjJzXC0yWPJkGinDcgIpvX6KHODXQgEDy0BwN5dfUrXUig7RY
         pvhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCAEzLJ6Zr0XA0uQZJJtcVAGL/GNvitH2XhRLBQqNhiA4uxTIOJNdCYg9MRimQv7jnMzBkgm8looPC@vger.kernel.org
X-Gm-Message-State: AOJu0YwukTFSGSl2hNPZZ7L+OoB1O5tUCVrcH0FPk9xbor3qqAjBINDT
	L6DureZ3koAvNRrrdnvLj7erE+xKct/gbLQcR51qoyMsQRVZjFmRWS0NWFL+Rj+9rgvoiJZiAH+
	yy5k8P1o=
X-Gm-Gg: ASbGncvJcJKLSmk7mdkYzyJdukaS+2r2ftmseLuW8E4Xmn18I4cU03nnWBpcopNYEFy
	x2U33EphnnfwLHa5gwA4zLY0gs7jr7nNTc5wz45lfbCNYIM+t5DIiBmuM0lpY9mUsOw4ZQmYpIl
	NAzPz5XPx7EodaVuqGAH0n+nFd+BMWLmNGBvam9fSN8ud+9xs3f1qPhKHj5/gnd4EdSIFsIEd9p
	5tOVyfTImOEBJ1J4wXncI5OvkgfQPkkQwkKRy5SnA8isY4Xqr96upvidHw4YEK5pzE7pftW8e19
	9UG5Rorov0dMkBdE7eDHizr6YSg4oXrrzhi7xhwyV/Cly7c5GnEzC2zCf0OU3rO0v2OVurnMNnA
	xTjcBCcm0VLI0mEO9x3ozhGUJg4fskPtvX6YE
X-Google-Smtp-Source: AGHT+IEqrHUQznueylLftKu876Naa+MAM+9nyIZr9W/NKlJJ9eFZK83B+J3icpPlfBSpgs+KjRdWcA==
X-Received: by 2002:a05:6402:51d1:b0:607:16b1:7489 with SMTP id 4fb4d7f45d1cf-60a1d16770dmr6061611a12.20.1750522197030;
        Sat, 21 Jun 2025 09:09:57 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60a185449e9sm3379912a12.25.2025.06.21.09.09.56
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jun 2025 09:09:56 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso4836890a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Jun 2025 09:09:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXAzCrYz/udipBuXiB0609H1tHNx57RT/gPhJQj0+ys7rwSCxx/V5Gs8pb/Aumago86Hnu4UusWs0T@vger.kernel.org
X-Received: by 2002:a05:6402:2550:b0:607:116e:108d with SMTP id
 4fb4d7f45d1cf-60a1d1676dfmr5557990a12.21.1750522195823; Sat, 21 Jun 2025
 09:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtz1-JLM8PEZngKOd4bwESBLU+bw8T=ap5aMmJ6LOaNiA@mail.gmail.com>
 <CAHk-=wjZXRvTnAwO-EcheuHkjOmq2YMua9YC3sbaXYBQ+FC8og@mail.gmail.com> <CAH2r5msQwv4LuaF=kmmy_n=z5paCyat2vTZowOB46WeJxpwhiQ@mail.gmail.com>
In-Reply-To: <CAH2r5msQwv4LuaF=kmmy_n=z5paCyat2vTZowOB46WeJxpwhiQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Jun 2025 09:09:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgReqMNHT8Y8W0jdbnhZBqsY3Omga8wYQJ-yVRumzSDwA@mail.gmail.com>
X-Gm-Features: AX0GCFshO2Qs5pTCKhyWhLvRvDT1-MxhzQG3NIDdJZYSnFdFeiznfZUuFLm6-W0
Message-ID: <CAHk-=wgReqMNHT8Y8W0jdbnhZBqsY3Omga8wYQJ-yVRumzSDwA@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Jun 2025 at 09:00, Steve French <smfrench@gmail.com> wrote:
>
> I can remove that and resend, handling special files properly can be
> important (and there is a much more important patch being reviewed for
> fixing some symlink corner cases) but SMB1 is much lower priority.

So honestly, if you had explained it as such, I would have taken a
look and gone "Ok, I don't care, this area hasn't been a problem".

But instead, it was sold as fixes, and I went "that looks odd". So I
had to go explore, and decided that it looked decidedly like new
development.

End result: now there is no way in hell that I'm pulling that thing.

Trying to sneak things in is not ok. Claiming things are "fixes" when
they aren't, and me having to figure that out just makes me unhappy.

Just be honest about these things.

Sure, I don't always check, because smb hasn't been a problem, and
maybe you've done this hundreds of times before.

But that's also exactly the problem: now I feel like I can't trust
your explanations because they seem to be whitewashing what is
actually going on.

So instead of a "let it go", it's now a "I guess I will have to waste
time on these things because I feel like I have to double-check what
Steve sends me".

Which is what neither of us wants, but here we are.

            Linus
