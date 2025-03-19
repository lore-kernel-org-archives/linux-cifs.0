Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFF61F4164;
	Wed, 19 Mar 2025 19:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742413057; cv=none; b=Ar8kgir24Qa+4zUkEwuDez95dBUKHuJSsHoBUp1BU4dtJiwHHz37Xp6Ppzqa+hnJ9BjdhMzBsZ+PrMTdV4glr4gnSm0nxIkMS1yljcdOvDPWR6GIUrWbtTIYGozT95cttiEt6w37Qlx1JXYHV2X4TozN9AoqQhtLcA5FMjmLMrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742413057; c=relaxed/simple;
	bh=8nGPnTW1eyGh3a0wLALqR7KIKnLgAktSfc2CBz5uc1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JaZw+8MNDUwc4AjudZiFTUtS9Sd4gtpkc0KqwpnBNyP2pchoLxAYRyJHwnKF1bxdR/2wnsv9OGrxpddQVN6Zytu8r9v4tK7FVjJN41YFaH/35304WXdRd0qRHQvetyLIcGopoPEFrqwEwpfAv/U9Guy77FEIcpPwdMMU828952c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e0UWZA1d; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e0UWZA1d"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5499659e669so64286e87.3;
        Wed, 19 Mar 2025 12:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742413051; x=1743017851; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WelDcJYWQaS3l09AcZuppDXU1WugmJGhAokrLxNPCgE=;
        b=e0UWZA1d8LNPWOLyT6YxiDakkPn5gPKmws+gNGaufI2R9ln/BFLk8yY52Lm1xIS1PB
         JcVt/8pr80xlY7Ey7qG0b1S/4FqUzcZs30pi+fP8Ns5379MbOTQFlTzVq/Tbt3sIJxby
         ixxsGHHZeT9EDnMSqIg7GVIH8ATHRGRgbQvpiJzFn8R3HZcJIMLLS8/3zgLxflzRfjh7
         Ya/Vl1fJSIaBulahFjEdwszRyC/aV13O2DME/Cq/72Wwx4HNEYp80vTGAJyUrFQUzMsH
         LJuIg+2JQE0+4W+PMJkJzOnlYbrep3fHcxY00Ucm/hmjn71SuNFm76kn/fd4RVAY0IGy
         IGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742413051; x=1743017851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WelDcJYWQaS3l09AcZuppDXU1WugmJGhAokrLxNPCgE=;
        b=blt7UMFl2qEB26HL3UUcA2+5Xsi3UYe2yuYilu7xS2lIFs6n4ZH0Rdjr/+Nt3R8JfB
         01Q83rjmo/L6bhFNzq/EYRG2gYdMGW+yyPXlWgB9RZ2vWphSXMPrOXs20QQuNyowUfRN
         B7u9R7GQ9J+jj3g2LACRzUNIYcZux63XPeu6Lc9VpiMsA3JKSBAawzuB0CoNOHJCjg0z
         7zG+w36IL0112R7mj9ME+Co7fnQQiPRRW0kw41W7JbNpru7SNlbzDz97NRgwZ9tzDv30
         aNUBe8dUhVGNlrQwat3TkRsm3UNp+XkgtucEo45RbJZ0Qb2pa4zs95RV4s71uJCSJVR9
         H1sQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9/sIHxO4EwhoKjvYqhwDpBCQZhcX7a4Clrm78QSoVKsspWN01uVRqXo+LW1A/rHypQIhgW6Hs03M2@vger.kernel.org, AJvYcCXXbknY0lgkq2OINP3BRmPMmvvqXuhxL0nTE4uVKQ8AK1C0NvnC5HbDXeG2lX6qaVvJIWIw/DTvHBc0I6p6@vger.kernel.org
X-Gm-Message-State: AOJu0YynarzBlz4H5ajBRrgEoeZ4DrfAcqkMZk6IpviIKGvDG9lUa7/1
	wieXc17U07osSb58gZgs7vFwk80R7gpJ544Exx+7+Mr4b9bfrhejZShFAraY+3K8+a6P1yn6ypW
	cnvUhW9jRmNHEPLSN04/6fRyQ6NY=
X-Gm-Gg: ASbGncufOxwUPhI1UtVLsShF/q1GhKmdc/i8kYqtoyT+xnbMPvVG5pCjNIafciwIWpU
	vTQC7Q8POzBDNDvV51neo6MQQWpzWiwYymipXY0BNoVMqCvtqlQDHnCbNiUYDz6GPQSmTd1o+6u
	b9RNLh6rgkwNlM7v8dHG474+j+UkxzKlPfwbaIBQfo1HDCichO57pOO28fe3ns
X-Google-Smtp-Source: AGHT+IHrvWI3UoKXZQQSRHhL+gWni4iREVrtOgZThxYJkYpKtEfFcO9VBstPjZnI4CM4VdBfLrcZazPcLCorx1NKX8A=
X-Received: by 2002:a05:6512:398e:b0:549:38eb:d694 with SMTP id
 2adb3069b0e04-54acb1d23fbmr1449998e87.26.1742413051160; Wed, 19 Mar 2025
 12:37:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319142858.2166-1-adiupina@astralinux.ru>
In-Reply-To: <20250319142858.2166-1-adiupina@astralinux.ru>
From: Steve French <smfrench@gmail.com>
Date: Wed, 19 Mar 2025 14:37:19 -0500
X-Gm-Features: AQ5f1JrgLUDmVpAP0c4ldz7sUhuXdXJkM2JqC2VPQQoZqLCK0Q3aELpbc3alokw
Message-ID: <CAH2r5mukVacAnksOjDE7k4UOSwzkkkA4PXEaKZAzZcFz78YBgQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: avoid NULL pointer dereference in dbg call
To: Alexandra Diupina <adiupina@astralinux.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Pavel Shilovsky <pshilov@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-2.6.git for-next

On Wed, Mar 19, 2025 at 10:00=E2=80=AFAM Alexandra Diupina
<adiupina@astralinux.ru> wrote:
>
> cifs_server_dbg() implies server to be non-NULL so
> move call under condition to avoid NULL pointer dereference.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: e79b0332ae06 ("cifs: ignore cached share root handle closing error=
s")
> Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
> ---
> v2: fix indentation
>  fs/smb/client/smb2misc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index f3c4b70b77b9..c02aab58aade 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -816,11 +816,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon,=
 __u64 persistent_fid,
>                 WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative"=
);
>                 spin_unlock(&cifs_tcp_ses_lock);
>
> -               if (tcon->ses)
> +               if (tcon->ses) {
>                         server =3D tcon->ses->server;
> -
> -               cifs_server_dbg(FYI, "tid=3D0x%x: tcon is closing, skippi=
ng async close retry of fid %llu %llu\n",
> -                               tcon->tid, persistent_fid, volatile_fid);
> +                       cifs_server_dbg(FYI,
> +                                       "tid=3D0x%x: tcon is closing, ski=
pping async close retry of fid %llu %llu\n",
> +                                       tcon->tid, persistent_fid, volati=
le_fid);
> +               }
>
>                 return 0;
>         }
> --
> 2.30.2
>
>


--=20
Thanks,

Steve
