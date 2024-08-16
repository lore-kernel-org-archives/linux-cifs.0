Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A46482CD
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 03:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723779133; cv=none; b=fkMwFCx69FknCRZB50OBmzLfs0HavW9J7U+ICNmI2uCJzhsifQCFdU81NdtfqaeR3fCY0CEAMY7gcpzSNMMiwuGGDpFf4IlmGDBE0bwb9Sn/lM6XxybOT6lioSLjoC4gjEsozDHAketaBvS+W5Rd/jXDGwBtB4Xj7mNgitnMV4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723779133; c=relaxed/simple;
	bh=82PwQKH6C7N6hEHLEAR1vsWD0pC3nbHbwUZtuxUWVrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJsx1Ut3eQo/+sRpOyPZ5C++k45oZA4qsCjZvg8K+pIi4kTL/a6aKRHjYAEtCEkWT8x4dnUF4c5Ak5aAjaJYy26Y3stCW70JI8qLupdlJ+Gcc9ZRmNf7ejIWg0U0PfMleTSjYCmrRDWlEQbDE4YSUrQp4QhhH8RS2JOne0q4iis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YbzKO4rk; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YbzKO4rk"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f189a2a841so15109571fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 20:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723779130; x=1724383930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKW8u1B6IhAVqsMjrZ2viZJR8U3JnqX4D+nOGDxrsX8=;
        b=YbzKO4rkEvxzYa0ghAGRF/6Y9n/5CNavL3xXc5/JQacpAcTKi2E65md4cclKxiw8u6
         u5Pa2titn7lolk1WJL5LPyUVyfh7IeA24mLZFNPTlQO5mJHmSvcR4W7PDpOFuP6jy6ZY
         vQeFxKt/u0Y5PZbPQXP8YOQ8cAfZIEiAV9E8jNTU0MMrj8eLMIsxifMM5pPrQMq4BtpS
         xofI1xSAPMH0Iys3F+ahNVAr5pZU8q0NxzIvBgJFN8FC3DY7nrm83BUO3vUiHngeVYJa
         xXt9PH8J7IsoJ5+Up9PJSWOVpWYGGxRkTlZmL7pID6JRO/qFhOv55NL6fgmegegd1ydy
         EK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723779130; x=1724383930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CKW8u1B6IhAVqsMjrZ2viZJR8U3JnqX4D+nOGDxrsX8=;
        b=m50GYwFchWsqHKFy46LkNWEYXLZTXWt2FzPmraHmABGlFcsIWoA96PqPPKpu/txkg/
         DdTGUMEro9u+lWLCFRwiM1E5d0GSEdtT9M3wlVbL0dccfQsgoF/lrfbU6rf4eAIxgi/u
         oTdmx7rf2UpxeumEejYctUGiiS863ZTqFgZ9I0uSQ0YYHRNCMG57UMOXNFxqubtItWGu
         F5MewDxGwZBa1AuTSLsGb0PsFr/fjTCoULMzUhlKZUAJF5pyOm5wr2Mru8gMusTGW1vD
         ld1IYWf0a6P1cfMdjBdqY+nyzcYda+GDKNwWP9gU/ni5v2FdVU9Jld8EPnViVPvuSQac
         Oi0Q==
X-Gm-Message-State: AOJu0YzxFUvrou75mIGvfsxdQ/8KId/yVTaN0wpTWfgiBlsnJn6IAAvW
	tKW/g8TxUXZ2oW4pmiv9qTHAw9IDwDVPksdLqwh0EPBz5g6hSvE/5a64jFWrDlzb2dPIp4UiRwW
	1DrYsZGXoPvSySAr26O1ZX6Rc+BdesA==
X-Google-Smtp-Source: AGHT+IF/vpiRNP/Ilat2W88O3PmPKxLORkFSPopIG52CDNBCZGXHtmtmuuupo75SDmUVnzQ3S1czxND6wV6PqbaXWcM=
X-Received: by 2002:a2e:515a:0:b0:2ef:25ab:9881 with SMTP id
 38308e7fff4ca-2f3be608124mr9379441fa.46.1723779129744; Thu, 15 Aug 2024
 20:32:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk> <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
In-Reply-To: <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
From: Steve French <smfrench@gmail.com>
Date: Thu, 15 Aug 2024 22:31:58 -0500
Message-ID: <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
Subject: Re: CIFS lockup regression on SMB1 in 6.10
To: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What is the simplest repro you have seen - e.g. is there a git tree
with very small source that fails with configure that you could share?

On Thu, Aug 15, 2024 at 4:22=E2=80=AFPM matoro
<matoro_mailinglist_kernel@matoro.tk> wrote:
>
> On 2024-08-15 15:37, Steve French wrote:
> > Do you have any data on whether this still fails with current Linux
> > kernel (6.11-rc3 e.g.)?
> >
> >
> > On Thu, Aug 15, 2024 at 1:08=E2=80=AFPM matoro
> > <matoro_mailinglist_kernel@matoro.tk> wrote:
> >>
> >> Hi all, I run a service where user home directories are mounted over S=
MB1
> >> with unix extensions.  After upgrading to kernel 6.10 it was reported =
to me
> >> that users were observing lockups when performing compilations in thei=
r
> >> home
> >> directories.  I investigated and confirmed this to be the case.  It wo=
uld
> >> cause the build processes to get stuck in I/O.  After the lockup trigg=
ered
> >> then all further reads/writes to the CIFS-mounted directory would get
> >> stuck.
> >> Even the df(1) command would block indefinitely.  Shutdown was also
> >> prevented
> >> as the directory could no longer be unmounted.
> >>
> >> Triggering the issue is a little bit tricky.  I used compiling cpython=
 as a
> >> test case.  Parallel compilation does not seem to be required to trigg=
er
> >> it,
> >> because in some tests the hang would occur during ./configure phase, b=
ut it
> >> does seem to provoke it more easily, as the most common point where th=
e
> >> lockup was observed was immediately after "make -j4".  However, someti=
mes
> >> it
> >> would take 10+ minutes of ongoing compilation before the lockup would
> >> trigger.  I never observed a complete successful compilation on kernel
> >> 6.10.
> >>
> >> The furthest back I was able to confirm that the lockup is observed wa=
s
> >> v6.10-rc3.  The furthest forward I was able to confirm is good was v6.=
9.9
> >> in
> >> the stable tree.  Unfortunately, between those two tags there seems to=
 be a
> >> wide range of commits where the CIFS functionality is completely broke=
n,
> >> and
> >> reads/writes return total nonsense results.  For example, any git comm=
ands
> >> return "git error: bad signature 0x00000000".  So I cannot execute a
> >> compilation on commits in this range in order to test whether they obs=
erve
> >> the lockup issue.  Therefore I wasn't able to test most of the range, =
and
> >> wasn't able to complete a traditional bisect.  I tried adjusting the
> >> read/write buffers down to 8192 from the defaults, but this did not he=
lp.
> >> I
> >> also tried toggling several options that might be related, namely
> >> CONFIG_FSCACHE, to no effect.  There are no logs emitted to dmesg when=
 the
> >> lockup occurs.
> >>
> >> Thanks - please let me know if there is any further information I can
> >> provide.  For now I am rolling all hosts back to kernel 6.9.
> >>
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi Steve, just tested.  Not only is it still there in 6.11-rc3, but it's =
much
> worse - I got an immediate lockup just from ./configure
>
> Thank you for looking at this.



--=20
Thanks,

Steve
