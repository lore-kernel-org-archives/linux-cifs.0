Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C0F21106
	for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711417432; cv=none; b=B/FUERRKY4x+z2EfU+aKeGEyzMpnuvboF/6C5B8HTpo6tCc0FcsIO50RRsyJGAmvdBKaUWGDUbzWhlHPXYS1jFDa9KYNR19A3leyRwV5P7GUY4QVYl0/iJ8sHZTPsLb5vKvn/tXaTHTfDhfKX43t/dYhIkid5dBc/9NovF3J0ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711417432; c=relaxed/simple;
	bh=4KVBO1crUFGsijK2YQBISuBhSI+OnF9RC3jdb5ggDz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOVPMdyo4ljtGPwF0O5WCMa7S2Z5QZ3Ip7TZ4sgL4WVdOhC4kDriEQ33bFgsH+kt4MEXnDaCR6Rs4nyJciH5lr3epPUkbXvx0bzQPu1I7uBLqBCMScETwt5eSi2jhYbqET25QyGGHdR4Okw6OhbUZnk2JEw4apGCaRrOgSGnPVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0meuYKb; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0meuYKb"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a472f8c6a55so441922866b.0
        for <linux-cifs@vger.kernel.org>; Mon, 25 Mar 2024 18:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711417429; x=1712022229; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBZZrT9enK3BUQPCDDlFqApOPRo8aGrsy8oT6NmAD34=;
        b=g0meuYKbY25wgsyoPsGqEwLs+qdkL9oc2kwEt275vVeQ8nHLSygqqwp9NYwUKrwzua
         HV+MvFcxkIk4TQ1jPTPzyWvJtWcufFUsIsldtjDupQg0B4Ia2cb0MeYCVbpH1VeNbQo6
         R04QiWJ7CTbQCrFPoir57LULl7Bmxh9a6OZFvp5B/HwCzInB+loubONtA2nHtysMKGug
         qQMhmofPcxKny78KuOGAjv8C6dgIlCEhx+70P0YGyaDzwCHsdir58wCKAAG2IcyENXko
         FcrtYSpfW11Ga3YLLnlLuwkpyWT3seXcF3SjUwHzB2Pl5mI6B41r+k2xbR+nG9mmP2Ba
         ayag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711417429; x=1712022229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JBZZrT9enK3BUQPCDDlFqApOPRo8aGrsy8oT6NmAD34=;
        b=n8DnfZBg1Fy3cD4t3gm/xX5hmWIvS8o16ULOu8T/XdFJMcYq0phE1YJwXx6Ad7lrb0
         zqkSW6echHHzmE2VQGbyyNuUIXZCOoRFIOztRZLsKLDCwYN6dTJALdjsHJnYTpdUZasJ
         nXFK2V1hb9IGBIUxEbdwpzUMQ4C2iJFk49aYP43G3x+wDnQOLnxaT0/b0yZyCzLwQBL7
         YhXaDdLBgYPFY1EpfAam7nkYQ7VAXoxwAs/+KqE094jactigWiNnF87Ojt8f1RYSqqQs
         rNBoZcZbDUeoOA/6S3ZcZy/wNutD8N0mR7Me0Zui710KrivNgAC5+3xrRqTTeVCgcEgU
         Aj1w==
X-Gm-Message-State: AOJu0Yy0ENgoZc7x8YoKVXVvggjwqeHrr+/MvdH8a70iDSDERExiXTX7
	dTxtlYm5Jx1VJV2i3t+d524RjByzpUplUd1W1aYFABnmgny7KsmObcHMFlIPNp8uuPs3P56g9pA
	nDaE8jCcNAOEZfmz/8MP7Ymibm12bwQs=
X-Google-Smtp-Source: AGHT+IEpS+oIae6G9dXSOT2C+HmpzeuWr8Gju3pT6XQ4MQyZAE9ohwu7R9OQCiARogcobO3K5/WT5/AqreUnQ/3IQ38=
X-Received: by 2002:a17:906:fa90:b0:a46:faa7:d014 with SMTP id
 lt16-20020a170906fa9000b00a46faa7d014mr5541243ejb.9.1711417429013; Mon, 25
 Mar 2024 18:43:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240308150615.339103-1-pc@manguebit.com>
In-Reply-To: <20240308150615.339103-1-pc@manguebit.com>
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Mon, 25 Mar 2024 18:43:36 -0700
Message-ID: <CAKywueTgWhQMz+_bi01dzCVNfWzceXe8LkqR=AySseFL8wOw-Q@mail.gmail.com>
Subject: Re: [PATCH] cifs.upcall: fix UAF in get_cachename_from_process_env()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged this and the other patch to the next branch. Thanks!
--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 8 =D0=BC=D0=B0=D1=80. 2024=E2=80=AF=D0=B3. =D0=B2 07:06, Paul=
o Alcantara <pc@manguebit.com>:
>
> Whether lseek(2) fails or @bufsize * 2 > ENV_BUF_MAX, then @buf would
> end up being freed twice.  For instance:
>
>   cifs-utils-7.0/cifs.upcall.c:501: freed_arg: "free" frees "buf".
>   cifs-utils-7.0/cifs.upcall.c:524: double_free: Calling "free" frees
>   pointer "buf" which has already been freed.
>     522|           }
>     523|   out_close:
>     524|->         free(buf);
>     525|           close(fd);
>     526|           return cachename;
>
> Fix this by setting @buf to NULL after freeing it to prevent UAF.
>
> Fixes: ed97e4ecab4e ("cifs.upcall: allow scraping of KRB5CCNAME out of in=
itiating task's /proc/<pid>/environ file")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  cifs.upcall.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 52c03280dbe0..ff6f2bd271bc 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -498,10 +498,11 @@ retry:
>                 /* We read to the end of the buffer. Double and try again=
 */
>                 syslog(LOG_DEBUG, "%s: read to end of buffer (%zu bytes)\=
n",
>                                         __func__, bufsize);
> -               free(buf);
> -               bufsize *=3D 2;
>                 if (lseek(fd, 0, SEEK_SET) < 0)
>                         goto out_close;
> +               free(buf);
> +               buf =3D NULL;
> +               bufsize *=3D 2;
>                 goto retry;
>         }
>
> --
> 2.44.0
>
