Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC282E62D4
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743881437; cv=none; b=WH3zWtsYbs+658ohDUeG2CDMosDZZJp3e3XTHGiImpIr7EhotKAYw7maFXxFEEn5eeUjj2bzzlIpzFEDs7X0HSELolEO2+fgOv769T7pz3EclF8RYUwpgrfw/ww37nCc6ORVd4SV1UlEAJIM+LOFifXW5m/3ELr5yaeNYmQ+IDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743881437; c=relaxed/simple;
	bh=47gvytXGLL8jNwgyYImQuc5a30DTMbQk514dOpaTfAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMG5LKI4D1ziI3K/NRnDmt8rl2ZYQd/8pW0tqYw2nHfEphr/FM8LLkS/sWSHoELSIvCYPyrJQwnz5NsYeaw7lHf8hcyaq9gD9FauPlVFpMLurezvT+FgmTu2r6dXgDXy3YVARaEP683nzYOMklBy6NO9frd+uVyFCxmPaT4UUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/PNufW7; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/PNufW7"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30db1bd3bebso28196911fa.2
        for <linux-cifs@vger.kernel.org>; Sat, 05 Apr 2025 12:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743881433; x=1744486233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRpBIr+xXXz1/CtUOcT+2D0W3fA7zof4ndEWcpK/IEE=;
        b=A/PNufW76j63xy8Mx6K60R+umAiWdmEq/KcbsiJRcCbhLKK2y8k+i3wsEQzUshNhOu
         zAS0BKf+ejcwQOT3EqKtPhFFvbBSrED1AmA4bNiseOm9fhHIDN36HFI9FKMmEByyv0Of
         Y8TsiENsQA4rlVtR81Ois4lzG46wYOy+8+FdMK/d0nCm3veHfOFRUXH8CfNX9uKEKCMy
         moG1X2O7pCGjmvnhgaKF/MJd7C6VVZcrR9ss/LOIiR+XeA36Kk0+pE9JYz2vjCHsZSKU
         vLFvbyuqTKIB/NT8l5QrM3V7Le/L4kaaoYKjS7fS/mpmalarUYbAc7RZ7VQVUT9uwHDu
         fS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743881433; x=1744486233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRpBIr+xXXz1/CtUOcT+2D0W3fA7zof4ndEWcpK/IEE=;
        b=wY8MXZbyWwlLhv8gwi62ONAHEivP545Es4SRibnfvaq7+mMd7LaRtAfrGTKCcA9ndH
         OZ0yUPiJwtW4qjtwVpsmjaPpCGtbF9CrDdo/YCtw2ubS/XbJCnQKmvjp+9BBNurKa4Pw
         CNuFdIHM0tPM7SMO9HHd8oVoBJ0/BzQzi2TqVkGaINXH6G7dkCBxptw7wlyDywoVLpmG
         9rOx554DGqbNky96pObEwF8dmWEwRQVe8ZlghGtCUEUn1b5JhE/XuvZvdLGtYOznjF9M
         YpZ+MXIea8sAaU1XmKCxFxNYFo0b6aoxKfEUQcAyoNw/7Qx3F+MYPVLEFP/OZlxsTXdP
         9pLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUke6+xO8deBR3chrZHKp22o/wYCZ2DQx6nQUca21iCdrXDuNh/LiewQFZOCbtXCcvotsy0ZrDISjgb@vger.kernel.org
X-Gm-Message-State: AOJu0YxHarQbzKryUDcoUxyEoUJaUQOwwF94IUe+RxZ1GTF2wcIQNsKC
	HJQnlbuvZmoqDUj0xhYJ1zFLMs6fjdf8UwYS06y+6hjndBF7rFXLkm2K4Z66t4xgYfBHpj5gMky
	/JXrU3L3VQovqvGE+njYjdpB569FCmfED
X-Gm-Gg: ASbGncuFLyF8s1l1t34qsxvR37RX+M3wzzmRaVhcn1+AjnPDlIfG+BBPnqKBKJVHtII
	+iBrhPdc3BC8iz5gUUNqFO7woXvM2YvpSzNceAOGX/PxWo52dv/7BTZ9sSFfbmPiGJUtHXcw3Hl
	0V+aUYZbmH3t5gxtjk9ikwEitQdGg5zqbbBM1wF5mxY25fTWaC4/7yKAEhRLCN
X-Google-Smtp-Source: AGHT+IEN8kBCnfrYNsTTgW0+hdCp46vxmB0bTVMBPKhM6l119tr8+MHOYU9uAT19Hor1blYcNAYMBuZhTqgsFVBqBCw=
X-Received: by 2002:a2e:9fc5:0:b0:308:f5f0:c415 with SMTP id
 38308e7fff4ca-30f0a0eefcamr21528821fa.6.1743881433200; Sat, 05 Apr 2025
 12:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
 <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com> <20250405172030.4ptuwa73nnqhkzdy@pali>
In-Reply-To: <20250405172030.4ptuwa73nnqhkzdy@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 5 Apr 2025 14:30:22 -0500
X-Gm-Features: ATxdqUFxw8DVa_mvmC_Hub9IXVD5jHQUw2WvJZBvRO8xajWDjnHuv9OtUo8gLkg
Message-ID: <CAH2r5mtFPSe7ccQjVdaoL+OCBP8Dya9s8wjSyd1aQtstQnX7dA@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Junwen Sun <sunjw8888@gmail.com>, 1marc1@gmail.com, linux-cifs@vger.kernel.org, 
	pc@manguebit.com, profnandaa@gmail.com, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was easy to reproduce on mainline for me as well (and presumably
the same on 6.12 and 6.13 since it has been picked up by stable, and
even looks it has been picked up in 6.6. stable) by simply mounting a
Windows share that was exporting a onedrive directory.

Pali,
I did verify that your suggested fix worked for my experiment
(exporting onedrive dir as share).   Could you give more specific
examples of

      'Reverting "cifs: Throw -EOPNOTSUPP error on unsupported reparse
point type from parse_reparse_point()" would
      break processing of the name-surrogate reparse points.

ie some repro examples that Junwen etc. could try

Welcome any other Tested-by/Reviewed-by/Acked-by for the two
alternatives - reverting the patch, vs. Pali's workaround


On Sat, Apr 5, 2025 at 12:20=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Hello Junwen,
>
> Could you please provide me more details about your issue? What exact
> kernel version is affected and what error message you see? Because in
> email subject is version 6.8 and in description is 6.12, so I quite
> confused.
>
> I will look at this issue, just I need all detailed information.
> It looks like that the error handling is missing some case there.
>
> Thanks
>
> Pali
>
> On Saturday 05 April 2025 12:16:27 Steve French wrote:
> > Good catch - it does look like a regression introduced by:
> >
> >         cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported
> > reparse point type from parse_reparse_point()")
> >
> > The "unhandled reparse tag: 0x9000701a" looks like (based on MS-FSCC
> > document) refers to
> >
> >     "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
> > filter, for files managed by a sync engine such as OneDrive"
> >
> > Will need to revert that as it looks like there are multiple reparse
> > tags that it will break not just the onedrive one above
> >
> >
> > On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Junwen Sun <sunjw8888@gmail.com=
> wrote:
> > >
> > > Dear all,
> > >
> > > This is my first time submit an issue about kernel, if I am doing thi=
s
> > > wrong, please correct me.
> > >
> > > I'm using Debian testing amd64 as a home server. Recently, it updated
> > > to linux-image-6.12.20-amd64 and I found that it couldn't mount
> > > OneDrive shared folder using cifs. If I boot the system with 6.12.19,
> > > then there is no such problem.
> > >
> > > It just likes the issue Marc encountered in this thread. And the issu=
e
> > > was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. So,
> > > I've done some research and found that in 6.12.20, there is a new
> > > commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which almos=
t
> > > revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I guess
> > > it brings the same issue back to 6.12.20.
> > >
> > > Thanks very much in advance if someone can have a look into this issu=
e again.
> > >
> > > =E5=AD=99=E5=B3=BB=E6=96=87
> > > Sun Junwen
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--
Thanks,

Steve
