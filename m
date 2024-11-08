Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3E01A9B5C
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 22:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105224; cv=none; b=mMP3MsA8Toyhxz+uuDBNKZWu+o3a8oI+ffuiKnowJUnSdwLt+PzQLRqYjMawjFWAdABBYLUEa2/v+0/wJkf0QM0czfg6q72gPEK3+BrqbC/vQa2r5HALdfysj/9N4mcVuQcxDwYqmYmo8oFWbfrTLkP6UpbGbPQGbFI2yloBHX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105224; c=relaxed/simple;
	bh=uFSTc6SxT2Vo+1CHNP4iUCsYg8Ujz80chMYqrgo0694=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WuDWLF1A6rL4oBtw0yfPNoSDUpWmSgD2E8eIexf9eycEAwQw9Khjtko4IvVUhsxUjObnknyZWDVSZEhkq7Wawp+r+cUf5HBY0Qu2fQAjABQP7+3okrF3XojPUyl9HmhkhOKgGoFvIfxeGg41gqi46Yk/bQs21ECS/RP/cmsvpHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8DVtmeX; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8DVtmeX"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f2b95775so3712237e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 08 Nov 2024 14:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731105221; x=1731710021; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pB2Whn/pgSg1DR8MyTstwu36l7nhUeSXY8ZZHDepHzA=;
        b=e8DVtmeXXxZ7cddX42upE8FFlk7F58xr6WjKDG4iaZFLvQj3ukYNMUz46oM9MRS9ll
         7hUnXegCuA16vZcnKKoZD/pJiAae+3KoUccx7VTj7t3RAx1KVbAKh+bIO5iT5g/UXkEB
         3Ik/yid09Zo0QGN3qrxlei2LKMvd4aXjg7Lqbf8HsqjwWtGRGxtMpt/rHZNJweo0zFN3
         uInYBv/kgFoCJeMeyGS6bl7pGAZtDckwlD2F6AmJjQAqN8d8TWgTjEJPbSIxigXpm9bU
         Tj+0oy4LFOrFCdB4mPs8rlm9fkUWPTadNKkVsTIlqKKEvDUKiUIOSKgsQ9t/cjwy6osX
         /1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731105221; x=1731710021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pB2Whn/pgSg1DR8MyTstwu36l7nhUeSXY8ZZHDepHzA=;
        b=Va0dkUEfBuhndnvRyRTgjp6UI6fjJJ4606Bd1SLpWiPbIpZmsKytTWkhZ006A8O27J
         QsPhnlE3O4A/YTVF+csJ9sWZcne3GMjopQ8xjqcIDxAw6uewFXqFrCrgvw90C+znCh76
         YCyX+sD8yzXql0S6P1D0qrzsNzeVkzok2d1rQcvx4P5Ui/0Vse8O/zzzn3wDOWLHh9PC
         iOmNqhJ0FM6N/GCoOTv8QezssxUbiR9VD7DIutvBZ9BLo32U148wCEguMFGSTCJusXVN
         +iOVaS/PUU4W0lhMGjoBrKTzWj8iSA0+7BWy6DudCZUCAufy27FpwEHwr5PhFRGAlhpZ
         T8WA==
X-Gm-Message-State: AOJu0YxecSrKZ2EcZtfc6nkdTXDq/3sAYbfmXG/od/gXx3RAlPVqjSjo
	7s+IicrtmwlXgQsJ/qSaZUo6AiVg5+i9sahABRVZVYzbz/ktMN8vvNvXKBBO2S1jqaSK4CdeqN0
	5xJy+dXea541K7GthENdtCHE2ODTHug==
X-Google-Smtp-Source: AGHT+IEw+EfBgYV0aRyetLM0OKdom/5Scl/QxZ6C8POgMadRtmg34MzNR1G3Pypj/Uwmd/jh7/nGoXh2z6b6jdcTyYY=
X-Received: by 2002:a05:6512:6d6:b0:536:54ff:51c8 with SMTP id
 2adb3069b0e04-53d862c6fa8mr3661130e87.17.1731105220496; Fri, 08 Nov 2024
 14:33:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108222906.3257172-1-paul@darkrain42.org> <20241108222906.3257172-6-paul@darkrain42.org>
In-Reply-To: <20241108222906.3257172-6-paul@darkrain42.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Nov 2024 16:33:29 -0600
Message-ID: <CAH2r5muH2W6GZPd-eE6q4vrOoituZsMyM17dKyppqcoCkVosbw@mail.gmail.com>
Subject: Re: [PATCH 5/5] smb: During umount, flush any pending lease breaks
 for cached dirs
To: Paul Aurich <paul@darkrain42.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Aah - thanks for this, I will try to test it out as well, and could be
very important if it also addresses a problem with the laundromat
cleanup race (with directory lease freeing) that I have also seen on
umount to Windows server.

Are there other patches in the series you want us to look at and/or
test (your email said patch 5/5)?


On Fri, Nov 8, 2024 at 4:29=E2=80=AFPM Paul Aurich <paul@darkrain42.org> wr=
ote:
>
> *** WORK IN PROGRESS ***
>
> If a lease break is received right as a filesystem is being unmounted,
> it's possible for cifs_kill_sb() to race with a queued
> smb2_cached_lease_break(). Since the cfid is no longer on the
> cfids->entries list, close_all_cached_dirs() cannot drop the dentry,
> leading to the unmount to report these BUGs:
>
> BUG: Dentry ffff88814f37e358{i=3D1000000000080,n=3D/}  still in use (2) [=
unmount of cifs cifs]
> VFS: Busy inodes after unmount of cifs (cifs)
> ------------[ cut here ]------------
> kernel BUG at fs/super.c:661!
>
> Flush anything in the cifsiod_wq workqueue in close_all_cached_dirs.
>
> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lea=
se is held")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Aurich <paul@darkrain42.org>
> ---
>  fs/smb/client/cached_dir.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index de1e41abdaf2..931108b3bb4a 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -482,10 +482,13 @@ void close_all_cached_dirs(struct cifs_sb_info *cif=
s_sb)
>                 list_for_each_entry(cfid, &cfids->entries, entry) {
>                         dput(cfid->dentry);
>                         cfid->dentry =3D NULL;
>                 }
>         }
> +
> +       /* Flush any pending lease breaks */
> +       flush_workqueue(cifsiod_wq);
>  }
>
>  /*
>   * Invalidate all cached dirs when a TCON has been reset
>   * due to a session loss.
> --
> 2.45.2
>
>


--
Thanks,

Steve
