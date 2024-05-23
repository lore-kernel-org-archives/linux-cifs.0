Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0835577116
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716440757; cv=none; b=UGDE7RonotpFBOvBkDFklp9PhA+xi0/TC/+56nSQXKydxSbQwFLfw9Ev3qZGpE/j5Sjx6CZdTsxanHSPuSXnotwJyTaAN7QF9y78y7Hkx8qd60jJoTr8BnhwFyc38pyS1uO2WjO3vOLo/wMuGLt2+Kz7vq07nDsO2T08IH9O8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716440757; c=relaxed/simple;
	bh=M6DDNGAR/jFSN85WY0loO8mgdGs0/EnGhPgWiXNbgm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bcCctzjGCD2R0Dtd4vGpnEZhOqcDeZnjgqAy8bhpXivPLMFZJfDsBLpl6Ju39wQA7xqgTt74laYuqyVg995eiymR333icXD7iM/iMeZB0/bJxw2yerF0aTDW8311TUiG4sKhv9Yhq5L/0HDAHvXMNXj4XFrtbgGFsWHmIEARKkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMtTIcRk; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMtTIcRk"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6f6765226d0so1964280b3a.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 22:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716440755; x=1717045555; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tF6Kx9pd5yezFjqe2ydRSdeLmrzD4h4wUjjTdpDm3b4=;
        b=YMtTIcRkzuxAr5chVrXlwrL0hFiFc8GEZrd2kdcWzLYRSDFGVI8IimXLwXdFe71j8K
         aPTtRI6dGdfm04lwFQv58bxQgtXlDbP/8eMFkIySTQctmqKB96G0yyLKt27nmZWu3Uyu
         6Ac3J0BkZy/75vyQ6X0De2YOx4ZvMiaI6SRELrqIhVtybD6WLpbJUxNEM4RHUHzoqGob
         +9Bl1JgmyUoYpYORDV8ccOPfTdsrUurn4ZCSdZQpW+r/EuLKNxhz7hmx/fYkdE+os+HS
         OPw4meQ5/4LYinFrsjuAHvHJJ85lHgcnfj77cCEGKVB7KUh4qzeJ5Ex612AXE5UuDOQa
         5ilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716440755; x=1717045555;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tF6Kx9pd5yezFjqe2ydRSdeLmrzD4h4wUjjTdpDm3b4=;
        b=suMFwzFnC7qdZODIqFDKaTapHlxxwQ/zQwr+Pgs2qWLPhmzNxVa/XTaOVQi0msfVtt
         1/juyVRhdMEVMkoWNvKl//ZgG+IYdvBFu6fsg0VC5It34leK9fE3biw27Y6pjWDMj4DI
         kHW2fsbjlptI3MPmeZB9GlT/sXnxgSd0+HluB4H0Vo8YYdJpQczUM3UqJFZFzYlyWFX3
         rwmUfzC5VsubtO6uIqU1im99XvUHR/A/Tpeo16qfczxKW21GYP2nAjNHdo07ESZhE4VI
         IFLV90S0/8qllbpSZ3o1WW6OKBrJQXuKZ3IZeDZOkUyhPwIrPLV2A1Z+RpVVXs6BhkUy
         nhUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUan5etN7f+5q/l0XmvGEoAdiaKERiEG+oYa0zSn9pAas/ZrYcNM3riUBYv5+8HxmYL8SX4YTgNHvMXlFwkDE1AlNa52JKIQ+vIuA==
X-Gm-Message-State: AOJu0YylQjuNqJjFtGwqXL3Zqyt+RkJFLhDbUz/26PgBjARFupLdyl9g
	K7dy0sgYkQiPzwMr/cpcjcDVGtiL/+ZGLeSOIB1ZfeI5PKpxDXGyeO5ZR4oODdGb256eXGPudC1
	OTpSA2LpEHK1P+BESW9u2h4fdEYI=
X-Google-Smtp-Source: AGHT+IFRe5OLvE2qEd1txQbhRpgZX6pnqKA88zpPw43LzAOs3XU+9mDNc3wdNiZD7DmD3CjfhiCWyjpx/V3Q+cooRXY=
X-Received: by 2002:a05:6a21:8183:b0:1a3:df1d:deba with SMTP id
 adf61e73a8af0-1b1f88df90dmr3629546637.31.1716440755231; Wed, 22 May 2024
 22:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk>
 <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna>
In-Reply-To: <20240523145420.5bf49110@echidna>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 23 May 2024 15:05:43 +1000
Message-ID: <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
To: David Disseldorp <ddiss@samba.org>
Cc: David Howells <dhowells@redhat.com>, 
	David Howells via samba-technical <samba-technical@lists.samba.org>, Steve French <sfrench@samba.org>, 
	Jeremy Allison <jra@samba.org>, linux-cifs@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 May 2024 at 14:54, David Disseldorp <ddiss@samba.org> wrote:
>
> On Wed, 22 May 2024 11:36:25 +0100, David Howells wrote:
>
> > David Disseldorp <ddiss@samba.org> wrote:
> > > ...
> > > I think the best way to proceed here would be to capture traffic for the
> > > same workload against a Windows SMB server. This could be don't by using
> > > your cifs.ko workload or extending test_ioctl_sparse_qar_malformed().
> >
> > I don't have a windows server I can try.  Steve may be able to try that.
>
> I'll put it on my todo list for the next time I have a Windows VM
> sitting around. I do recall testing Samba alongside Windows when doing
> the initial implementation, but QAR is very FS block / allocation size
> specific, so 1:1 behaviour isn't straightforward (nor is it required by
> the FSCTL_QUERY_ALLOCATED_RANGES / FSCTL_SET_ZERO_DATA specs).

I recall talks with microsoft folks on the list about these as well
and I think they were problematic because ntfs and other windows
filesystems do not really have the same semantics at tha tlinux has.
I think one issue is that "set-zero" nothing more than a hint
and depending on phase-of-moon and how the server feels might
sometimes punch a hole,
might sometimes fill in a hole  or do a combination.
The behaviour was hinted could even differ from one run to the next on
the same server, because reasons.

There were other issues as well making the behavior unpredictable
becase one could not assume the alignment of blocks, or if it would
even be constant throughout the file.


It might be best to just ignore tests that fail in this area. And just
accept that some things, at best, is a best-effort approximation.
(as long as dataloss does not happen, of course. That is never acceptable)
At the end of the day it is a lot of guesswork and trying to fit a
square peg (unpredictable ntfs behavior) into a round hole (linux vfs
api).



>
> Cheers, David
>
