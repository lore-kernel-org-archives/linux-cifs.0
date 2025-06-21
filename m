Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB540153BF0;
	Sat, 21 Jun 2025 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750521619; cv=none; b=C4tBFdUfWJHLxhhEbCo09IEWkQzSlpKYJuZ86t4yIiyVhSUhMmsG6ItcBm9iQPkYeaf2nSoLpkkGMjFmWnoW+qiSivgSIVefQ7MoF3TNqGTKwjoKMzlhy6wvJ6lbk7MM2QyQ/7p1nC/b8TwoLXMEqSlU59WKlT3X4aFKcxkAxr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750521619; c=relaxed/simple;
	bh=EhkOvmhqnFGnEjgqkQ1sCv9zZQPb+cPkfAv6fIKA1nI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pLKsz88NPUlKm5hs/gktzWlKh+JB3R57WbSvZ+cfzwaGdBbWSN+iBAAyo6CUPRQSsgzdoIr58bCSjUKHzawcX7p6HNW433yeTYpp3iSocgmA5ZtywG4Rn3lf9d+z/lPpdUsjxEilsecdxgyxjBsqRtCvI1rOXMe7TSqOS96Oq34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MTQ5yY7Y; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTQ5yY7Y"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6fd0a7d3949so31439176d6.0;
        Sat, 21 Jun 2025 09:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750521613; x=1751126413; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSeTxg4WenHjcKKBSwYxJ1qE+4xyi1cTJ4g8NSuOIF0=;
        b=MTQ5yY7Y6/fQAWaJBPbr8noQcwu1nZnxOLSis0uL4rEdVfHURoFUcghuQTK7+Txewb
         cotaA1HV4DQZzSfpltfcnrbr4AnfTeJQrNU3XsIrHx2wRXCyWptk78dAwm4k4+Ho5kSq
         aSzf7PWcUISl15tS13EF78eOItYWUGchJquD1lxdCkxoWnYGPW/32N3y/LWcaDRpr5KL
         ryTALhXzI6sLVC+YTm7qU9o9ibPD3sFGYfFRLcWIfHgGZy/DJVGFCCf/+pnMrqDY3515
         zybX6HdQhMeRi8zhH4p/Uz0VzlWkiQOD1Gau0Dtmc6JWTyyZfAbbapXlwFKoqhfYipK6
         ZDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750521613; x=1751126413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSeTxg4WenHjcKKBSwYxJ1qE+4xyi1cTJ4g8NSuOIF0=;
        b=H3NAe5GVZboppcmqGQipfVq8JRVwVA32BdfySUmbnjbY/r1xMeUtdMcZlDEJBSEB49
         MHLL+pAJypGO7B1iPOLAdmbBN3uPlGAhfq7Q1e23KnOjwMjx+ySxCQEwazMJ3rn1RgIz
         yG3Y27uMpgbb9cF1HfQPXKmqGysKW0glNsrJiIAA0xRKxyxr9XangUiqUiUcQ47zO8mC
         vdDUDLVTT0ZsBiVRdnL84zRTS+TcJowQzFskRgGYOSqt683yOtm9XxVtY7ADlLxM19rs
         hpmBCXBps62LaUDgmN1FOGNUYph63jLel4nr3/hwcV2aqX07XrenyuvrPKWzUqv4RA/R
         Q57g==
X-Forwarded-Encrypted: i=1; AJvYcCUoYi4vyGI6lRqzwDxi24yRYVw9fix5grYc0ULEDGvtTiUQK2NUQTEZ2Hktbznptc/GsBu6BKVuHB0l@vger.kernel.org
X-Gm-Message-State: AOJu0YzfsyVteAuQP9bX/3uMz1CDI6cbIFtt0thD0oWMbEfSjsxqqfiX
	Lpd4hCFlwcLA4kt06B42gd6otnRG+9OYBMb6UU+TwG8ARtdxg0uzvJ3QqIkJkvzhWkI3O12rM5d
	kK94TuwVc2blDHK8nlx+d4+Ri0CN48eY=
X-Gm-Gg: ASbGncvFzYZ900vrkgwGrxjK/2AzpfvZ7WowWTQqol0lwfZkAAkQsLIkXPO18ysno36
	prCmWU1LvFFnb1hUOTFNRGWSmdfrU4itg0jZgFYpB/Mpz6+sBzqls1cnV7KdPzk3Q/ZLseIEAQJ
	fuaXnvXsWmIjDabOMToL+4nI6vDyU/igRlnwANlAQPlcmGxKDOMZFZTzdhWxqz6iL2+6M9USo4V
	Hgw0g==
X-Google-Smtp-Source: AGHT+IGOIeD1T3odEL8jSPpeX9pl/jxSDXz1xhhPjyI3HkWq5ORaqUx8fBeN7S1XDFfEDCPxNLyYxHxkHNxwA9QZYiA=
X-Received: by 2002:a05:6214:1d24:b0:6fa:c44f:2ae6 with SMTP id
 6a1803df08f44-6fd0a596d61mr134862016d6.38.1750521613177; Sat, 21 Jun 2025
 09:00:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtz1-JLM8PEZngKOd4bwESBLU+bw8T=ap5aMmJ6LOaNiA@mail.gmail.com>
 <CAHk-=wjZXRvTnAwO-EcheuHkjOmq2YMua9YC3sbaXYBQ+FC8og@mail.gmail.com>
In-Reply-To: <CAHk-=wjZXRvTnAwO-EcheuHkjOmq2YMua9YC3sbaXYBQ+FC8og@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 21 Jun 2025 11:00:02 -0500
X-Gm-Features: Ac12FXzUhM1qux_S0H1CL1XoySLKiQ9kDxhKvC5cw9SHtZUNjl-flJ61oEpeAzI
Message-ID: <CAH2r5msQwv4LuaF=kmmy_n=z5paCyat2vTZowOB46WeJxpwhiQ@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I can remove that and resend, handling special files properly can be
important (and there is a much more important patch being reviewed for
fixing some symlink corner cases) but SMB1 is much lower priority.

On Sat, Jun 21, 2025 at 10:55=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 20 Jun 2025 at 15:57, Steve French <smfrench@gmail.com> wrote:
> >
> > - Fix reparse points (special file handling) for SMB1
>
> I'm not seeing this being a fix at all. This seems to be entirely new
> functionality, with not even a whiff of "this fixes Xyz".
>
> I pulled and then unpulled again. Because WTF?
>
> If it's a real fix for a real problem, it needs to be explained as such.
>
> And if it is what it looks like and the explanation says it is, then
> it damn well shouldn't be hidden in a "fixes" pull and tried to be
> sneaked in with the pull request dressing it up as anything else.
>
>                  Linus



--=20
Thanks,

Steve
