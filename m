Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ECE262FC0
	for <linux-cifs@vger.kernel.org>; Sat,  7 Mar 2026 00:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772842929; cv=none; b=PNMJXciuIeKLnT6z1/U0TLuGDh3yzJNPnc+EiQS8UYenKu7uRjJxRLg15u2qF8FL+Ecs3K6c/lWUZbZVrl1S8SaYv0+KYxHFGrfKzZaGGmzB2slHdMoPHpQ8qe2wJZtLc0o+TtXFN8KkZj02MhpJZVcbF+SNQ0N/XYl/Q4P0PBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772842929; c=relaxed/simple;
	bh=3mFM2AbWMEYHxPCxyFWA+kZtk417krsotatj0UtSI/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UszX2gQ/uWA1GroqOK2Z8tTKA2XKHGCB9k/eKbM5wazpXH2vmRz0VNf9qEvgf/OxKGvl0QQVNJapa4cwqAJv9EDXWuX6iMdqKaETkX+kbySkS/VKWEW8PGBCLBW5cVU61RfoBL4BdessYutqUQ7v8CYKK1uOd3YOIoFPMzNM8e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IoKJZWHE; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IoKJZWHE"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-660b497acd1so5688607a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 16:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1772842926; x=1773447726; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FgXnr2cmhS5BhkvQnnC9Tz341LcLJyI6amhClJjD3Ms=;
        b=IoKJZWHEZ69dN4RflMsw4BxGu71MKmD9Z8cE8Gd6Od+C28gIEd+el1+4SowB/QD3WF
         oETV6NiJHWPCuVxPfoyRvNW8CpYd0aDo0r2hrq46vX7dljmx5E2jNoq3WwKAT6YRFDqN
         pgfsGXWvyx7/49y4Q20O6XvU3lHGzmkCTFYSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772842926; x=1773447726;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgXnr2cmhS5BhkvQnnC9Tz341LcLJyI6amhClJjD3Ms=;
        b=T96qOgHi+g73U8ko2E0Gf7hVhwjOwdjustPzrGIRcSDh8KLvjURugbRpQIG/TNqNDe
         2H0oIKH18K4afB1z8BaJakdAnSZRwTkhG8Xu4Cbzd6rO7o7Tk4rOrYAS2KFUxj7zBXh9
         1XGUR5rkC4D6plaq1SscH+EMUbFy3UD8dhEen9HsReIKFn78z5NgiXJNK306g2Bs3ksB
         01CLjiaTRz+y/MM2x/MtrnsITi3d0dZSI2XSGczkB2K/gaIxosJp4YIH9f3Yy3HhgdrR
         RuMEbfvP6IsQgeyNOL9O2+lLoJ16U2Is9PuFBH+p4qDXUvoa6lyJ9LhCUKE+N9+GfULS
         iX1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLcIwkJGRqkGHtSOu0pGxOPT76nPpDLy1DPaUOB/F/OlkEGRSjXBhbdABRXs9POc1b/5otmGeQH/n2@vger.kernel.org
X-Gm-Message-State: AOJu0YwCA+L5G6vT9b538w6agGsC/dfmokMje44y6aZZncq39oa1RwwZ
	KjauqDocGYBiXCYAahtaurNqUir13U8KvyTCMMX6BgmWCKsTwnHKR6Qfau0W3ByUxxuqopMFoo/
	tuJMIlHE=
X-Gm-Gg: ATEYQzy4J7CgYNv8ojqJF4071v+8jdHjzRNkYeN8aq9o8QcWDac10WdlTpU9KlCM7ll
	xH3i0hsgUi6vAeDyuJaQ4ecu+BgWCOwxpqdHRnzGlCsgVrLwn/G9feL3lbHzru772gg3NiMta71
	TD2SKL0FagwBTDtYUuk7fmi66HZvb7V9+YcB+9qD1lIOqAuHk4flYvM7WmoKeFE5JGp9UyekocH
	RtkHsCebYisEo/RYjoXaUl6e2U6dxIc4fKayTkCCopD1IoSFlOPzh5QiS+SKIaKJb0epBrRVUcJ
	NSTk+i3DHnv2iX2dz1rFNF1mFfo8w4L/WzaBvLGqyD2eB2DplHEgoR8LnMeqBnDjFS7CiO8Vfv1
	eQ0OXmp0uVciLb3hBuE+2MhPgbvRQ+3fLMSmDoOsZFdxvn/gdOmbaGoQ8bq1ia8wEu7IldVp8b6
	C3PNAMKiITbbCbi3bEApC+S7SFFtx6rBrw3dacOCpmu7FD9M+h9tZoDAO7NqJFCP06aXuJv84TV
	bWjW0Npcrg=
X-Received: by 2002:a05:6402:440b:b0:65c:354e:94f0 with SMTP id 4fb4d7f45d1cf-6619d467bf2mr2291566a12.8.1772842925831;
        Fri, 06 Mar 2026 16:22:05 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a4fd5e87sm891460a12.18.2026.03.06.16.22.05
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 16:22:05 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b941bb3e23cso328268966b.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 16:22:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXMicLDeFt+FQDIEG3AWGw64doYaxyhn8R6KUV51lKYHRVWHx12Jc2ApQCznZapJaWw/XOdX5ugczee@vger.kernel.org
X-Received: by 2002:a17:907:6ea6:b0:b8f:f08a:4b80 with SMTP id
 a640c23a62f3a-b942da495bdmr180549166b.3.1772842925193; Fri, 06 Mar 2026
 16:22:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
In-Reply-To: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Mar 2026 16:21:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjXKY7uS6OBPuNMc8xsiHwyVCfbaEgCZGffooxr=XzOaw@mail.gmail.com>
X-Gm-Features: AaiRm50rfrQcL36UpaTvN8C9SHh0jnK-H4V6doiwfOPHkDn27SRvFRj1uQ6if68
Message-ID: <CAHk-=wjXKY7uS6OBPuNMc8xsiHwyVCfbaEgCZGffooxr=XzOaw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Mar 2026 at 14:04, Steve French <smfrench@gmail.com> wrote:
>
> - Security fix

Bah. I had to look this up - I don't think it's an actual security
issue, just a (good) cleanup.

Yes, yes, the old code did "memcmp" instead of "crypto_memneq". And
yes, it's in theory timing-sensitive.

But the two compares were of size 8 and 16, and at least clang
generates a constant-time comparison for that anyway (I bet gcc does
too):

This is the 16-byte case:

        movq    (%rdi), %rax
        movq    8(%rdi), %rcx
        xorq    (%rsi), %rax
        xorq    8(%rsi), %rcx
        orq     %rax, %rcx
        je      ...

and the 8-byte case is even more trivially constant-time.

And I'm sure that you can get the compiler to generate garbage that is
timing-sensitive by enabling some debug options that make code quality
much worse, but my point is that as an explanation for the pull
request, that "security fix" was just not a great explanation
regardless.

I'd argue that half of the other fixes were *more* relevant for
security than this one. An oops is a bigger security issue than some
purely theoretical timing attack that is almost certainly not
practical even *if* that code had done the mindless byte-at-a-time
comparison.

              Linus
