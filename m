Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2A13D2B2;
	Wed, 13 Nov 2024 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517559; cv=none; b=oHrtmk5MlRbc07pAI5HUgrldA/EcVnTaEbBXGC+y81vPv9C2z1MLVlt+3wjCIweWEtMO8KulMct2xqnZwiw6yCKn3PttOlJIh7qBAzycl7Cz1+zMebl7xhX70dbczd7oMWOgeK0t0t5kssKmmbWCxW8bVDvvdy/W7S4zRll7yc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517559; c=relaxed/simple;
	bh=vBDKgjR6V/zTWckWegrqEoc7IBGfIW4eBSJb7A4Bosw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QYTk8jYZFPI0Vqoclv3sfpcNYXiFm4s9pedxNMy4ZnFwPhycFIushH3rvgduiqJCWphHYz16jvp8A3P5ij/GS5P26+IBIHT0e6OV9jm2AIlYEYXx8gYUuU02poF7M8TsC5uRAxuKZvkaTsvdwOcwR4WeBDxMoeHHqVl3NfG+9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FaRJneDI; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FaRJneDI"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53d8c08cfc4so4565916e87.3;
        Wed, 13 Nov 2024 09:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731517556; x=1732122356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEep/OMfJyldzNvkNFDVhhiUsnQA3+XUm5BPLdUV5Uo=;
        b=FaRJneDI11zoQZcjBCvrAIMww6gUFRe6SDbEjs1y8Q21P/Jq0hy8dZcpOLpBTJeNGF
         XW/sgJ6YwitYOCQxFMrioCOIu2lcKrfHTWjV5cronRAOed9zn47HKPvMxnRx2ien54JS
         ZLYcnW6JByw2UalcYRWgHRSyDLGFyIzg+aEtGfWD+Fy2oyrcFFKEq2pjIc7L85FWmyE9
         HF6U8O9P8eimPAlTKFsSnb/w85iM2g5hPxJFHfxGt3LynSkCNUuMAOLoknNrLEuKzIhi
         3W7e6NtFbGrPeHBFuI/VWTA6Iscpaoh5hZBqMubq/Rqbc5ud7jtGRLcK86r1lUOa7q9r
         KKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731517556; x=1732122356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEep/OMfJyldzNvkNFDVhhiUsnQA3+XUm5BPLdUV5Uo=;
        b=VJ8yrVUf3eyu9gl2Wdv/9A0NLwM0D7o9dSqoEU1Rj8gYuWdG8PIdbOxjdcGc3wVO7N
         8VUkAAIGynPuFNflSOnBQgyzvB1fEs61mF8Zb607pz8WfxNq+YQZGX3epq/7h+L8SQ7+
         6852Oq29rgpBMqwn56m7TFgIqXrEGQ4U4rTUOAdq7pOBOxAodzJmou1QLhlEEiFx7qnM
         MpQL/7jk4FCK3R9EFR1X5aYc2g6HowDmxCC2QykJy6LfQXiX7HTsYnozc9HIDLz10r1I
         Ym99dAc2VVvEAzMxtcVWteqiJ+/DeFu+G1joTu6z8Swq//Io3aMMR1kb/jgFktP4zsry
         m6Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUEbxcw8Awg5Kg+SwkzbNKj947k5OX8O1EqExHSIYFP3iLa3GURnmsohmQ+H7Gx9J8L37RAZnuGRR88@vger.kernel.org, AJvYcCVADrGg0ISDhidEcr6sFQmNCzO3dW780h17Rja3vp4r7/5WJbu4kRlmQxCXUVLG8o4c1bl4NozFr5RE4DLT@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9suTTKMgsVSzvHgmlWuQ6WFecBnNdWeIewRpK5EHwPsDPb0zu
	cJkGmyz4MWrKA9ToIDciBtfz5VHwEsuMRiPY1t4RkdUgOvmRVRa+/UpHKLSZNhknzWOeQlsdz+m
	jBmkIEzf1PEg0/izz+iMZz9gmITA=
X-Google-Smtp-Source: AGHT+IHklTE9+daZ5V6N7lYW+6/IbHQcQEhMqhqVGJ7scdARVw98D3T0fBcxFBULN/mfvPbKatFu8XWI1hgeC9KqiEw=
X-Received: by 2002:ac2:4e13:0:b0:535:82eb:21d1 with SMTP id
 2adb3069b0e04-53d8630341bmr9311605e87.57.1731517555466; Wed, 13 Nov 2024
 09:05:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112105837.166575-2-thorsten.blum@linux.dev>
In-Reply-To: <20241112105837.166575-2-thorsten.blum@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Nov 2024 11:05:44 -0600
Message-ID: <CAH2r5mvUNiXVAVVmvt=W_RAVMCm5Fgs_=Etcme3uBZ8gKFK30w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Use str_yes_no() helper function
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and
additional review

On Tue, Nov 12, 2024 at 5:33=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Remove hard-coded strings by using the str_yes_no() helper function.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/smb/client/dfs_cache.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
> index 110f03df012a..00820f57b434 100644
> --- a/fs/smb/client/dfs_cache.c
> +++ b/fs/smb/client/dfs_cache.c
> @@ -173,8 +173,8 @@ static int dfscache_proc_show(struct seq_file *m, voi=
d *v)
>                                    "cache entry: path=3D%s,type=3D%s,ttl=
=3D%d,etime=3D%ld,hdr_flags=3D0x%x,ref_flags=3D0x%x,interlink=3D%s,path_con=
sumed=3D%d,expired=3D%s\n",
>                                    ce->path, ce->srvtype =3D=3D DFS_TYPE_=
ROOT ? "root" : "link",
>                                    ce->ttl, ce->etime.tv_nsec, ce->hdr_fl=
ags, ce->ref_flags,
> -                                  DFS_INTERLINK(ce->hdr_flags) ? "yes" :=
 "no",
> -                                  ce->path_consumed, cache_entry_expired=
(ce) ? "yes" : "no");
> +                                  str_yes_no(DFS_INTERLINK(ce->hdr_flags=
)),
> +                                  ce->path_consumed, str_yes_no(cache_en=
try_expired(ce)));
>
>                         list_for_each_entry(t, &ce->tlist, list) {
>                                 seq_printf(m, "  %s%s\n",
> @@ -242,9 +242,9 @@ static inline void dump_ce(const struct cache_entry *=
ce)
>                  ce->srvtype =3D=3D DFS_TYPE_ROOT ? "root" : "link", ce->=
ttl,
>                  ce->etime.tv_nsec,
>                  ce->hdr_flags, ce->ref_flags,
> -                DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
> +                str_yes_no(DFS_INTERLINK(ce->hdr_flags)),
>                  ce->path_consumed,
> -                cache_entry_expired(ce) ? "yes" : "no");
> +                str_yes_no(cache_entry_expired(ce)));
>         dump_tgts(ce);
>  }
>
> --
> 2.47.0
>
>


--=20
Thanks,

Steve
