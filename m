Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE951A6810
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777363503; cv=pass; b=TakkEjn7WI5MFNwpccSJIE9ZHdi6NxIL0UhJegNO/PeAKhHAmBapWmEz7+7k/xYf8ABhqoC7cMWFBpcwmN/VOEzm2vQRUy0+9kyOMfKAfvyXu5KCBq0eqKg95g+2Llw/FVKANJozBRqkDONmVxoiDvKaCQWdXwn3DVtsqXkkZqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777363503; c=relaxed/simple;
	bh=kwa6s3JDmHiTLz0D4zpUr1j3ZrWQNGMSGgpLUP1LMCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nsJHx0JMRfL8O9oEcCvL73vcph5x6V2pHsUqJKqIEIx7ZRxNcFl+JRlrcCDjzS4kegCyPTC8G/Lvd3ffSS5UxRGd6xJQxnyW5TtNh5DLBFZIDcp2P3qRVMB0dxOHpcSFo9ijd1EtXpFsXq9y/JQEMYvRK4DN2/wY39xmWfMoinY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b=SQ8uiayk; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b="SQ8uiayk"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67179ed133dso12406972a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 01:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777363498; cv=none;
        d=google.com; s=arc-20240605;
        b=X/g3dfmDJGJoSBv/MZGtdCCSWPr4KCx6rvVXqNl+A6b3vP/dOLnhaCsJZ9uZigvwZP
         ilpSC3dCVswZQAEQpxocNvAsrWpYBHUg4F62iRuoEgT2jH4VH79BoEMLRx2Ck5Y6Tqfs
         WoYgNMx/Tqs24DByJGNRhYSna79dfqW3o6Uv1qnCBYvjbZRLZ31t5dM15kRuIQdW5goI
         pocVcc6ldTIWNKdYVfFZ/RJUcBO5MMxRPNbJjMOCKOGxFL7Y6H8YLKqrZtmHDTC83JUN
         7qz6L4CYWE6tryC4jzewqq1JGqWBTeaa6/qjtTOJdJPAe0HuCZ4YveDzTfhyq0f0KO35
         +kag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xyIKbgPQW7MYQpY08/aWtgtkkBlyRsuw1c4aOkuRo94=;
        fh=jgynuBj/ovdTveTAZ03Npsfas79cIcS9fW0rUSH5YgY=;
        b=SrKvcBjyfjpGKEtsKaKU5N1ybcT7cOW9SEn0KxPm3+A2crF4HDCePuG91ZWx+CM6z0
         XKm1Q0nHDKdKbIQzGpLrmKV0k/bKAUGbPlSbJ/SzG53cgD0cdNQ6cEud01x6nTZtvOdg
         rihxBbqo1kBfD6xb2xuNNtPc2HdMqTUlxz/Fg/JynpthuKYyHnWl5oezi10atpBLyO3Y
         J1PgzCSWP22oCB0/nSlBDJpWSvv6ccPfdJbgNb/7TYkc8f8evLdwZblkLw5Vlc3Fkbns
         h+Z5B0FFeBH/JfZYE2sOX1FGEMZA/WMF9X5wrMhEotE8i45U0Cx8NQYtYFheLRI0mA04
         hMbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20251104.gappssmtp.com; s=20251104; t=1777363498; x=1777968298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyIKbgPQW7MYQpY08/aWtgtkkBlyRsuw1c4aOkuRo94=;
        b=SQ8uiaykaTv6soQx2oXO47htjowYVoa7a2KtRB25dczD6In1DdLL7ykviHUumAKGoF
         VdmudKeSwb0Bz8QfuaIpU18NVNELB6gO2b0J9i6pP+27DBbxp4kZOs8fsuK4EMsOMN0I
         pFWNjqVlhrMPb5ar6tWQ0A3CJl5C0HfAPHl/O7s+Zut01XJZ7nC2YYomyU2x5fL9dR1o
         PWFuyQDyup3Dz3VQziLeDxfj03AInr5/noDzkLo/9gx6j81hCnawXGIiLSJq+2w1bq95
         YewlMVTsHQzTOzipDKrb9Ftw8fbaxanu5ka1H5T6oBqOHat0bbod9N9rrL6+zo6fzX++
         WXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777363498; x=1777968298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xyIKbgPQW7MYQpY08/aWtgtkkBlyRsuw1c4aOkuRo94=;
        b=rWfM7KkoDruIYsYXK52a11W79QwVOiUGdTemofJy9ABev3Y3lWkOqIgEUE44l5LP+7
         xVKF8gWw3vch3gnB/y97YGhZ6vxB8h8ia9RawCNW/oDqMRJevY/1ESeBixcBGDYvxuk9
         TBYpf8UXccprgB5WTIU4cL0I+IWNU80//gwU1SMV0yzL2bEql2/YjcKb6adeoB77TUvj
         TeEJj1JHw5HUaM9DFpEdCVkvCrCJSUBGOx/VeNB/D/j80/DppH3OU3hHU+m1+Kzd9eOB
         +qzXKLEpPXrHUQKxSVQLRH+7rlalQR1xvuI4JXmWAJctCf86nOi8iWUdtCOGDLcmRt0u
         kWjg==
X-Gm-Message-State: AOJu0Yw6yQ2WehuYoVNxQrk074KixneQK+miTQZhpB4TCZDknlPSqiQW
	Iah/I4pc5MeNuYKC/AgvG1DVnMcdz5dmrjrFKNP/kqmo2+fSsC1MaJZ3RDMXufezyi1OQW93fy0
	nx1o4Pyb4Gs+v2H9caeveevOMbM136KArfgXAbjC5LA==
X-Gm-Gg: AeBDievWQR28IrQ4WptVbFXI9Wff0i3bcVCA35qovdbPnx2v/VLdLGHvIyPbZjmKPO6
	mSRuH98N6vLu62fQbpY+xVAoHdOaIC2x3Z6jbRqb1TD2va3T5FzauHfinr+qWjTXYYW8qdu0/jQ
	3yVNhNOgHcNyXLCrAFckSjLGMrGuC4hChkBOlqONJf7bOJEtQ5lvATa2WuQv/QjSgBJnyMgWL65
	Go4XNJZ3DxNNmWpO5mi3xvhXiNm2YU+CBQ3itwUY4WsFVefApf+KkTeSDhktGrjqDxryiW3OIMx
	Eyxhkj77daXmkVczj4Sq3p2YKWaFBxByE2uOXd/UMMHSf7NSxPNVtu2iWHjZH6+3dW3A8L5tsRO
	D
X-Received: by 2002:a05:6402:5107:b0:670:8add:2b8d with SMTP id
 4fb4d7f45d1cf-679bb09f095mr1013793a12.24.1777363498000; Tue, 28 Apr 2026
 01:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422105010.2600337-2-mmakassikis@freebox.fr> <CAKYAXd_FRpqjTcxbBsLcZATT9GmGmVF-g8JkF_9dwretGA0rpA@mail.gmail.com>
In-Reply-To: <CAKYAXd_FRpqjTcxbBsLcZATT9GmGmVF-g8JkF_9dwretGA0rpA@mail.gmail.com>
From: Marios Makassikis <mmakassikis@freebox.fr>
Date: Tue, 28 Apr 2026 10:04:46 +0200
X-Gm-Features: AVHnY4I3B2WmQYnme1ZgtgFOGQo9H6HnAOAw-z2Xio7La-V37C1iZbVMkAEsF4w
Message-ID: <CAF6XXKXD-dKoQV2AP+7WYc6CKJWqsC0MYYqJyncoD20YXdx0vA@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: zero buffer before filling file entry
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 2:29=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Wed, Apr 22, 2026 at 7:50=E2=80=AFPM Marios Makassikis
> <mmakassikis@freebox.fr> wrote:
> >
> > this ensures there is no stale data in padding area between entries
> > when processing SMB2_QUERY_DIRECTORY request.
> >
> > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > ---
> >  fs/smb/server/smb2pdu.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index 07782f7205dc..b55bef96d94b 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -3962,6 +3962,7 @@ static int smb2_populate_readdir_entry(struct ksm=
bd_conn *conn, int info_level,
> >                 rc =3D -ENOSPC;
> >                 goto free_conv_name;
> >         }
> > +       memset(d_info->wptr, 0, next_entry_offset);
> The response buffer is allocated with kvzalloc(). Could it be a
> duplicate initialization?
> Thanks!

Hello,

I sent this patch because I was seeing parts of filenames in the padding ar=
ea,
while investigating a different issue.

the call flow is:
  smb2_query_dir()
    iterate_dir()
      __query_dir()
        reserve_populate_dentry()
    process_query_dir_entries()
        smb2_populate_readdir_entry()

reserve_populate_dentry() uses rsp->Buffer as a scratchbuffer to store
the filename. Then, this information is picked up in process_query_dir_entr=
ies()
when calling dentry_name().

You can reproduce the issue by listing a directory with a few dozen files.
Wireshark does not include the padding in the decoded fields, so you
have to look
at the hex dump.

I have no idea if clients may error if the padding area contains garbage,
but I'd rather not find out the hard way.

--
Marios
