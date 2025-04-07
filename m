Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC0714AA9
	for <linux-cifs@vger.kernel.org>; Mon,  7 Apr 2025 02:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743992684; cv=none; b=TmN7yFUIqYawb6JKIac7j0Xnelf0+N5MSbBXQNzX0tCO4bNZGmrQn5vAYMw+vhZ6tbF9WpLmC6NCNpg/cmbir7xkgISpptmViE0yD8kHDIzs9eATrN2jXyY+e8yjujaZL0Dqsf0Qz/4rUr4XnVHRLsYZ0fAsupaQ7BzUbFwsUdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743992684; c=relaxed/simple;
	bh=JuhLpCphOnYDKPSmzb1CIJflNgpoJjg6GSTe65CxLhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fkd/0JPtLmwYK/Q+RQw5lsKmtsvAk2INcEp5zYz7mIPoj57tlVPYoqU8DYXrHibkNDFHX/NUewRd+304CC+YKr7tuNPrQgf4oKsKPdQHH8HmaBEyBx6rzTN4cgUsPLMSe+z6MiflozgL3K+PiAsFUAj9/ia9c3NCwVHcBGSNyN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nsm6Mzcw; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nsm6Mzcw"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6fda22908d9so25842867b3.1
        for <linux-cifs@vger.kernel.org>; Sun, 06 Apr 2025 19:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743992679; x=1744597479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7Q80WRgYq/7EWe+ODMiCABAVzLean1PP7haY2cT+qs=;
        b=Nsm6MzcwrUQ6OBtXx/wJJ4vFy5NGa8KgU7q9jFZ+ao4Diyj8z6WjxfBUzsfqM1viO/
         E5UOAXQBcDbAOSgEWAkOlRGzIkYl+7OQ70ACZzjps+9d2ec/SimTyfcXMECU+vdVSj7X
         i1nBivSQg7afVBR7cwrzyhk/AjYtYCPDMqQ4COPnEhciQrhLsdmQR2mDBj607JZSFEpO
         i0Hl4XYaF3XTQ5Q/kUkppiEAcB0ugQpu+YwrEz31LU77IvrUAC6xZcdwh3+x0nhQ5KGQ
         fLE3OzGPu5yaLTtBi0yt6inpxAYRYW2GS0aSkq5VkCYBzzzXWivbcahu83yl+DJiyfZ/
         2kLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743992679; x=1744597479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7Q80WRgYq/7EWe+ODMiCABAVzLean1PP7haY2cT+qs=;
        b=i2g/LBekNhY/Y0PKEMZWHl64ATIQt4KaWkPYTkXxOyUmOzWODGBeRNSkGYRMBiGO5l
         7Eze6swbOhRlv2BhXOAUF3pXnUYVJCAdo8Q/mbP2VX8NNCU+eUJP8tMSzLwlmmb1g56u
         xd+RFClWOM1GhmW0fBDm3J6mAR5YPsEGDLnfrnA/EaOH7MuHiNGDkm3Sptbo3IPfXdne
         ISy3evCE7ND4ZJamFJu/7FEj4UD0Xug7/g3Cy5xV7xrFBYijCl61cSvP20yOQ2Kpo4/0
         1tbUJyaj/tI9iZveyIutR9zlabO7wIFy0eFu/WgVsaB6/QFK35u7OGFFbm59qEGes8XI
         ZlUg==
X-Forwarded-Encrypted: i=1; AJvYcCUFpXhkyBGGy6iB2xdcGHR7Zb4gFFR48FFW6nwGatzVGav8TUlqyqdzGQ29qDAslIId1Xf1cVMXWXTj@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9kS3Stthgoh08UTbubc/F0/OHQtP9gTrC+qlCGSnsYVie/NLO
	nBOUvPsfR4V0n3CM/PEnjxtaRbgrFaqqULM8uk6FWUyuEUWYBO8JXtIpUWkpcQhOpzwOtFauM4z
	d/6BV+B3zHQ4ASrGeYYiRvhYEUpw=
X-Gm-Gg: ASbGncsbW6pcFgqLDJPMGeGwN3dmVkmTRNA76GGvGYm08Lkr8VL/DeIbZFWAQbCgaZY
	nWT5Gq2gy/3+2rf+Q0oOXTX6qBXvnCrlaZV+G2zbKUtirjl7Zb+ELyzkC6+evoLKpc/DI1LEl79
	kGrnj7W0y9vckMCxRxapNyYrY=
X-Google-Smtp-Source: AGHT+IE4CwcU+3JewbIruBrnK/r53iftu/pwVpzBLacNF09Dj0QDz1+6PCGL4exfE+in0g9d8UEGs5Hlk+0EjV7D/PI=
X-Received: by 2002:a05:690c:38d:b0:703:ad10:a71b with SMTP id
 00721157ae682-703e331a46bmr191020677b3.29.1743992679254; Sun, 06 Apr 2025
 19:24:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
 <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
 <20250405172030.4ptuwa73nnqhkzdy@pali> <CAH2r5mtFPSe7ccQjVdaoL+OCBP8Dya9s8wjSyd1aQtstQnX7dA@mail.gmail.com>
 <20250405195923.aieo7ad2g3kynudr@pali> <CAH2r5msWXanWt7VvpiagZ-ekOdX=xRo=3O0kkOnunXN4rGzyJA@mail.gmail.com>
In-Reply-To: <CAH2r5msWXanWt7VvpiagZ-ekOdX=xRo=3O0kkOnunXN4rGzyJA@mail.gmail.com>
From: Junwen Sun <sunjw8888@gmail.com>
Date: Mon, 7 Apr 2025 10:24:28 +0800
X-Gm-Features: ATxdqUGNmZIgOCMvCezPvqP8cZ5UuZharqNDG0H_rcrEb_x8d15Uku_U8sMGIlo
Message-ID: <CAJXSQBkzMWQ8LiyD78Ai5EE8MMksJpppEW0O0-O0XLoHSZUkbA@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Steve French <smfrench@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 1marc1@gmail.com, 
	linux-cifs@vger.kernel.org, pc@manguebit.com, profnandaa@gmail.com, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steve
I've done some quick tests in my very limited environment, and I don't
see problems with the patch.
For the code, Pali's explanation is very clear and I think the patch
is better than just reverting the 'cad3fc0a4c8c'.

=E5=AD=99=E5=B3=BB=E6=96=87
Sun Junwen

Steve French <smfrench@gmail.com> =E4=BA=8E2025=E5=B9=B44=E6=9C=886=E6=97=
=A5=E5=91=A8=E6=97=A5 05:42=E5=86=99=E9=81=93=EF=BC=9A
>
> Lightly updated version of Pali's patch description, merged into
> cifs-2.6.git pending more review and testing.
>
> Junwen,
> Let me know if you see any problems.  I have tested it but the more
> testing the better
>
>
> On Sat, Apr 5, 2025 at 2:59=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
> >
> > Steve, thank you for testing. I will do some other my own tests too.
> >
> > For explanation, the function parse_reparse_point() is called by
> > reparse_info_to_fattr() and then return value from
> > reparse_info_to_fattr() is checked against -EOPNOTSUPP for handling nam=
e
> > surrogate reparse points. This logic was added in the commit
> > b587fd128660 ("cifs: Treat unhandled directory name surrogate reparse
> > points as mount directory nodes").
> >
> > So this code in reparse_info_to_fattr() requires to know if the reparse
> > point was handled by the parse_reparse_point() function or not. Hence
> > reverting commit cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on
> > unsupported reparse point type from parse_reparse_point()") would cause
> > that the above logic stop working.
> >
> > To fix both problems, the one reported by Junwen about unsupported
> > OneDrive reparse point, and the name surrogate reparse points, I'm
> > proposing in my change to "mask" the -EOPNOTSUPP not in the called
> > parse_reparse_point() function but instead in the caller
> > reparse_info_to_fattr().
> >
> > During writing b587fd128660 and cad3fc0a4c8c I somehow forgot about the
> > case which cause this issue.
> >
> > Linux SMB client should not filter out unknown/unhandled reparse points=
.
> > Reparse points are processed by the SMB server (with few exceptions for
> > UNIX special files).
> >
> > In the attachment I'm sending the patch, now with the commit message an=
d
> > Fixes lines.
> >
> > On Saturday 05 April 2025 14:30:22 Steve French wrote:
> > > This was easy to reproduce on mainline for me as well (and presumably
> > > the same on 6.12 and 6.13 since it has been picked up by stable, and
> > > even looks it has been picked up in 6.6. stable) by simply mounting a
> > > Windows share that was exporting a onedrive directory.
> > >
> > > Pali,
> > > I did verify that your suggested fix worked for my experiment
> > > (exporting onedrive dir as share).   Could you give more specific
> > > examples of
> > >
> > >       'Reverting "cifs: Throw -EOPNOTSUPP error on unsupported repars=
e
> > > point type from parse_reparse_point()" would
> > >       break processing of the name-surrogate reparse points.
> > >
> > > ie some repro examples that Junwen etc. could try
> > >
> > > Welcome any other Tested-by/Reviewed-by/Acked-by for the two
> > > alternatives - reverting the patch, vs. Pali's workaround
> > >
> > >
> > > On Sat, Apr 5, 2025 at 12:20=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.=
org> wrote:
> > > >
> > > > Hello Junwen,
> > > >
> > > > Could you please provide me more details about your issue? What exa=
ct
> > > > kernel version is affected and what error message you see? Because =
in
> > > > email subject is version 6.8 and in description is 6.12, so I quite
> > > > confused.
> > > >
> > > > I will look at this issue, just I need all detailed information.
> > > > It looks like that the error handling is missing some case there.
> > > >
> > > > Thanks
> > > >
> > > > Pali
> > > >
> > > > On Saturday 05 April 2025 12:16:27 Steve French wrote:
> > > > > Good catch - it does look like a regression introduced by:
> > > > >
> > > > >         cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupport=
ed
> > > > > reparse point type from parse_reparse_point()")
> > > > >
> > > > > The "unhandled reparse tag: 0x9000701a" looks like (based on MS-F=
SCC
> > > > > document) refers to
> > > > >
> > > > >     "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
> > > > > filter, for files managed by a sync engine such as OneDrive"
> > > > >
> > > > > Will need to revert that as it looks like there are multiple repa=
rse
> > > > > tags that it will break not just the onedrive one above
> > > > >
> > > > >
> > > > > On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Junwen Sun <sunjw8888@gma=
il.com> wrote:
> > > > > >
> > > > > > Dear all,
> > > > > >
> > > > > > This is my first time submit an issue about kernel, if I am doi=
ng this
> > > > > > wrong, please correct me.
> > > > > >
> > > > > > I'm using Debian testing amd64 as a home server. Recently, it u=
pdated
> > > > > > to linux-image-6.12.20-amd64 and I found that it couldn't mount
> > > > > > OneDrive shared folder using cifs. If I boot the system with 6.=
12.19,
> > > > > > then there is no such problem.
> > > > > >
> > > > > > It just likes the issue Marc encountered in this thread. And th=
e issue
> > > > > > was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'.=
 So,
> > > > > > I've done some research and found that in 6.12.20, there is a n=
ew
> > > > > > commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which=
 almost
> > > > > > revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I=
 guess
> > > > > > it brings the same issue back to 6.12.20.
> > > > > >
> > > > > > Thanks very much in advance if someone can have a look into thi=
s issue again.
> > > > > >
> > > > > > =E5=AD=99=E5=B3=BB=E6=96=87
> > > > > > Sun Junwen
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
