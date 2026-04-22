Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07323306D2A
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 08:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776847014; cv=pass; b=JIVb1YRKUog0n9EFsICEvkGxmx4nHxZbjRmnR6/CeGcWmXjIcanTUcG8dnlmF9jzHS3mwRW6Yw/Xagw/R/8E7/frUofOHfn8BiWGEZA8H752GRVcPOihkJeB8YANpA7ws99+M4lUHbrIt1g3UPz+eW8GtcyiR/dbklGIQVUhhjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776847014; c=relaxed/simple;
	bh=Ux0jHj6JhqB9OLstvAhPbVdy+wBTQatJ71oj1iH1Y6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J6gP4XYcW82BelJkBshEdejMG6oCsKFrmZpRQq87XFzXhGoO+pn6itOuNAWYJNFaEOJYO3QSwoBjQyPp9YEMBKm/8Z6I0zH5rUdONgbtAM/fjvwA1knC2DjyVxtvRRuTvQXL68fzM5ZhGtuBJSt24uVjpJ6OJaG7ZcORVT2n+9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jJbrxe7Y; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jJbrxe7Y"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-65005a8840dso4454208d50.0
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 01:36:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776847012; cv=none;
        d=google.com; s=arc-20240605;
        b=VUotWT+tHmnbK/detLGAzpsPqdVviUOpXQX+gREzhQgvp6DJmqAzRgNmnz6BGKfk1i
         wiRwp+Ex6T/WrIffTKa3/NluJKrBhaVvh7D+6FTBG2FRdPY9ckmLJ/JEThR7+SZfP7IR
         E72krG3aFXFZva8xtjVXYFLbrR7sOxEWW7d2+ZaGiQRIJme5rQrVVan9Vwod41841bWg
         xPV4c7wNPUqxeZ6bXKktBhtxiX0cR4vu9tgLlzwKzUCIyOXfJuprEPXUHhcNyx25pHQy
         xigKRb+YYmjZd/RDfq2NMtA5w9NNY59xawxGFNr/daCRXucuZw+cdITHwobnQ0TyrxoK
         tJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZVtvcXMMK8avyypVb8iKfolU2FhGMion8XNm98EJOwI=;
        fh=a5JLd7s8eVDu3CYXLm4Hv3VAHboxO6sYVNMcQn627Zc=;
        b=II4VSfeTrOFXQz/9sNzz1sYPIghL0j8s5ncmuRC2Zh1JkBVoEkAIT3mGZwAhsxlNYt
         WBXtteo0wtrVsCoatEyAnAiZ3MJhOpW+JZ7nJEZhrMxAAyc+moe3Td+LnvU/cGQuuijv
         tYCk2AIw+h2L7Oa6nXSgwYOURBBbMf3OvepBuCabHDbZ7TmY+DslYQ6P3eQCwrhlNNtg
         vMuwVgp8T7aY0XvqaU7EEG/Qs8VNrZrXFAtMIw8CmWxa+eYssRpAL/p4fXjYOo5YPSq0
         9kl8YQPip2ohREgIl/hLKzAu7RN1o27jLvqAXFyeZg1bfJrMzCvn55mdtcqJDAs25J0l
         wTng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776847012; x=1777451812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVtvcXMMK8avyypVb8iKfolU2FhGMion8XNm98EJOwI=;
        b=jJbrxe7YxI9MEb+KIWqWVshsGZaHBlMiFFqHPoBx4O3KQHI1ZpFs9mPpc4rYHGds73
         oI4pLA/deNYDvoz3CMtKI8ApXp0QOs39jaDSu0b3WpXcBClRA8KUXc+1w2UMR5MFxl+a
         SHtizFgW9aMZ8ERp9mESAnZegmx/moCqsJU9ltRVlegQw4jtg7WYIcnyHnfWRBo0YbNO
         n7HPgFN85quXSTfp40yqT9/HR6ryWskuUT1RcKUrgHiveYIfOgaXxYwaikaCqC6+zsD1
         d41qE4zWJpZEvVkLygAZhASxCxYXigMj0FAI4bqVuQA4ymGERlxaQ9J6jrW8I4xKGiqD
         Q8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776847012; x=1777451812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZVtvcXMMK8avyypVb8iKfolU2FhGMion8XNm98EJOwI=;
        b=TcKbaLHau6d+aq8kLk04rH14g/PJkvYAwEnTKY9b4UpNkNrITcK+2AZ6y3rTdgRQu4
         dcTGWKcXwotlP3fMEbJx4DHcPoDEZwGIEJBJutD0jEf6cbbpjmSqBid9+6l0dIAhX4Ih
         2bHJxO1X+m2DLe5tkFTp5ZWYlLcPX5NKk7dNNHtNsfbm5KSdVKbHFmYwoc16Srrfc8ro
         lVNH5cTZVNrrpPvXpFmQM4kB/zgUjE3xBoj2NwgzYaAe0VTAp0O8Obz9+jHiM+MJ5LGu
         lVvTLMyDJ47soHQw6Q4nVuifGrfH+HvP/h+4Y335DetIFWXMSQkrKYKgvBWn+P1qWXps
         sMxA==
X-Forwarded-Encrypted: i=1; AFNElJ8jUPVdqvg0W0j3nEy5wDVSkx9CKIfiBUBJ9sbmSt/ZEE0wYPaq86iGJMz6Z5K5HbkbjXvKALJB2wBd@vger.kernel.org
X-Gm-Message-State: AOJu0YxUR8aMyofecQr9gMj7TZ41+dVtR6/Y3B5E5MLS054/Gsuy1sUm
	3SpLW8yV3u3CV9sZaMLt1Pr3gHtnAkqgxOlFTJpRRQpi3iT3ckPnMuzU2ADUumaIr60XJkPIQdz
	vriqoFpVoToPqzE1eKweybOSojvyWuKQ=
X-Gm-Gg: AeBDieu6jRU6EjGNPfLnLXSP7x5aG74TrLQh7sTFli+yclhccEKt+yInz6N+RXiC8Ty
	oivuhzbjM+AEKRKjSsnInM2F9M+Rdmn9VEw2RUpN84ANzImJJsgZs41FlPxtJJE1CPwBjc+WAiX
	5wDvD9FAKiq56l8JvDEFCxWSLeGPlMZtNHrNYgt9i4aV8CN3XSu7+NPtae36xvngM8DrzYXDbGN
	mdLQKxKgngCXwEWdufKZ42aV1xaYxTlXfSSVjeZv1MiCy4lXX9cLMAHjf1G8hWuPzQpWapknaV/
	4fxXNFp3QtjwUArXy0yLDJz8R/sVYYMzEWcJObiOUxqya3t42btGg3Is1IaV
X-Received: by 2002:a05:690e:2584:b0:64a:d7e3:cf7c with SMTP id
 956f58d0204a3-653107fef43mr15634933d50.13.1776847011899; Wed, 22 Apr 2026
 01:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-6-rajasimandalos@gmail.com> <20260422050613.1136327-1-rajasimandalos@gmail.com>
In-Reply-To: <20260422050613.1136327-1-rajasimandalos@gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 22 Apr 2026 01:36:39 -0700
X-Gm-Features: AQROBzB1J1xlyQ4A2gmxrGoYaQW6x9KtQCcCA6aM3iPA77Fw2gthNAmaI-PmcHs
Message-ID: <CAGypqWz-rThJ3SaeJECy9mG3e+CCmozkns5k3UyatdVuXSonjw@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: allow nolease option to be reconfigured
 on remount
To: rajasimandalos@gmail.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 10:06=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> tcon->no_lease controls whether the client requests leases from the
> server.  Changing nolease via remount is silently accepted but has
> no effect because the value is never propagated to the live tcon.
>
> Add no_lease to smb3_sync_tcon_opts() so the flag is propagated to
> every tcon on remount.
>
> When switching to nolease, close all deferred file handles via
> cifs_close_all_deferred_files_sb() outside the tlink_tree_lock,
> since closing deferred handles can sleep.  Deferred handles retain
> active leases from before the switch; without closing them, those
> files continue using lease-based caching despite nolease being set.
>
> Both transitions are safe:
>  - lease -> nolease: deferred handles are closed, future opens
>    get OPLOCK_LEVEL_NONE.
>  - nolease -> lease: future opens request leases normally.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 45173f287f00..fb59b45c7f66 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1317,6 +1317,7 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info=
 *cifs_sb,
>
>                 spin_lock(&tcon->tc_lock);
>                 tcon->retry =3D ctx->retry;
> +               tcon->no_lease =3D ctx->no_lease;
>                 /*
>                  * Note: this updates the limit for new cached dir opens
>                  * but does not resize or evict existing cached dirents.
> @@ -1325,6 +1326,14 @@ static void smb3_sync_tcon_opts(struct cifs_sb_inf=
o *cifs_sb,
>                 spin_unlock(&tcon->tc_lock);
>         }
>         spin_unlock(&cifs_sb->tlink_tree_lock);
> +
> +       /*
> +        * When switching to nolease, close all deferred file handles.
> +        * cifs_close_all_deferred_files_sb() handles its own locking
> +        * and must be called outside tlink_tree_lock since it can sleep.
> +        */
> +       if (ctx->no_lease)
> +               cifs_close_all_deferred_files_sb(cifs_sb);
>  }
Similar to deferred files, I think we probably need to invalidate the
cached directory
entries when we remount with 'nolease' considering 'nolease' is a
superset mount option
and should affect all types of leases.

One additional case to consider: if an application already has a file
open with an RWH
lease acquired before the remount, that handle may continue to hold
its lease and benefit
from caching until the server sends a lease break or the application
closes the handle.
Is that correct.?
I think nolease remount only affects new opens; it cannot
retroactively revoke leases on
existing active file handles. It may be worth documenting and/or
comment this behavior,
so it's clear that lease->nolease takes effect gradually as old
handles are closed rather than
instantaneously across all files & handles.

Other than these comments, change looks good to me.
