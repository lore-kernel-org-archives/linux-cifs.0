Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5AC1E9B1A
	for <linux-cifs@vger.kernel.org>; Mon,  4 May 2026 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777897733; cv=pass; b=NRMS82MRfXD1VeeGTVLkxAmqmzFLnEDeAjuBZKsHGM1BuWvPtqFWZl1Ggf6cKlHTnV9FOO7PPnKrdW5pq3e/bGTP4AE2RbTHK45oMG1lpfQB5DikXPNK2Qz8tPu/Z0k/6ydCkHG46kLmNlshaz7an4W/ufNWY4lPByhGlU3TPfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777897733; c=relaxed/simple;
	bh=z+0l/lYlHdpkW/KC9Zx2b+UGD70+cw6cJYj7Y53Oy1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EgpQ5swxXq5pRUbTk9Fxv0Rj9VELjMOSX7q8Ev1yGbkt0WCwAtxBc8ZCJLTxOuexYU7xnKVhFajc9kdleHzCa3KcrV3+szMSBFlJIa0R3jSYvg1Kx6o0x1ky8Z/G9tNxhPGU4WYZ85MUKXovFOckbvLWhJgI9k5FM5thIVjwVNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=paY1c2V0; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="paY1c2V0"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b936331786dso468494066b.3
        for <linux-cifs@vger.kernel.org>; Mon, 04 May 2026 05:28:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777897730; cv=none;
        d=google.com; s=arc-20240605;
        b=FXZE9skDjsL47NFo0n4RfE2CXbGtkd/mSVVekQEiLvsVDgRly7eoPHx1RcZRxNsR1Z
         tiD3Hgr7ooJVs08R48NGUgrZdYQ8ff59s1zMUuobCFGcB34U/A0PJDQz4n1auGOjoKGm
         PUPCGVl9Exs1hX5wvR68cT0t53XwAqHLH2klRiSvQfaj0hOYqemMyWLSUWlouiMIWjP2
         Gzwz4JQszGVWTLINmdEc4YHULfJhH6PngIhsyOaOIM9jt6tjR0ajXZzonpfI7KVQskqc
         hYFvM176pDqyH8KaZkmdqHuhnPmddmbyUwv2n5RAbxWrEvobpOYzTCrsCU/jsKnMXc+Q
         MvIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xsciO/FOEfXFSwFoQmZSXC6tR6mBWUFfXAsioD8AMgs=;
        fh=yrJGIw2QUJQBLjr3GfFSuw1vhjROVUNMBcgKBWqt7PQ=;
        b=dKAFrCnFfhzGg5ROWve6V7t581LgXwc6BpnQCDYF3VTJ6wIu17Nk59kUYeA8fflhV6
         iyuklsn9WXZ9Aq1/kY3wkgRxv3BYoJpuVIKVda1j7G2H4EBBfBzN6J7m/txVx/4ltt/G
         XFm9d66O8URjsIu4NRv6fn+eE7fulihYkZ7bKawqUt/MrSzIoD+P5d+MnMwbIR9O6iuW
         uy/EGhoOvNoLKjYIKPzALklkWYmVNNiO+tRbi/P14UJ2F+XlR3GesKBnQCbw9h1qgq5o
         w8sIlvttIFrza3fvuO2hlOWT1kOU3r3+TLcENYLpvBrlep0kIER73ozz7bOdlE0+mNXN
         TLAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777897730; x=1778502530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsciO/FOEfXFSwFoQmZSXC6tR6mBWUFfXAsioD8AMgs=;
        b=paY1c2V0zScWilE2NTFLlTHXVC8TzrtLW0J7+cXmIo8VjxgItNrtYA+pmPSvZ6zOR/
         qVsYtyOHsBdzJ5nAcOtXegj8DxSWLHVv1iekIvR9QMS5IY8rSF3tv6oD/zc6fHs0kq7+
         BABYjUWcYkyX3Az6QK85aZcUugiGz298elFLQrbQtnijJrOc4g2jhwIs67kYcTYWnw87
         PV15U9MHQ8QCh0TxY9pL/SgfpFOq7tiiJSp/tjXsP09479cMUO88K9EnZFHdfWYHri+w
         8xikPEDfBuKOyP4TivH2IjGifevKynQBWmRAYWn248mR1OZRVB52kYQSD2cfWl+c/GKD
         OdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777897730; x=1778502530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xsciO/FOEfXFSwFoQmZSXC6tR6mBWUFfXAsioD8AMgs=;
        b=sD804k+jd/ehdfDCgKRoRMVkrfEYZbcpsR6szU7plogvGEC4kG0Dvx0moOEP1KfEOt
         qWV2GOEY6ZNbTuKVwp/TDdCLfo8VjAKIiG+UoSa8wZvfFI1nawZ7y3xNH31G65aN06ce
         9jcPUPJaw+JVSK60r45nNCFDcEFMJ6LxA7+/yHvtmbJBANwq98GHrAgx37nDSwNsT4Ki
         Q5R95YY3SQCYva2kMlejeICC+UIt7QLfgsr23NikxwZQvejkJIBSfHcFqW767Tk30Zzc
         q+tw0sTCNhfqPnvhI4+a9/Ibfwjtt4QSuQUwMFHA6FRB1gJ4KdTu/vn5z+vqho3v+T8o
         Y1WQ==
X-Gm-Message-State: AOJu0YzVU1136Uo6FV0fZB3tAgfmmm6AUyn9LOqsx7IdweoFuxOFIWFz
	0j4uuYnEfiyfAsWdMYL4+aC1WR/1RESaSK8otFmB/jIV2BND743Efw8PakGghxWWTJCWGOOGJtD
	LW57+afHHNe172Bdx+ThVtQ+gsxDWXC8=
X-Gm-Gg: AeBDievtI64xPaXynHp5KETtoHsR7GVFPQVJgcxGDlvPakTC4J93rwzz8dTMv7dSuMB
	HKG6CeVd+OQctkDO+FmOHRLZK5/fR+EzL0mW42Rps0nMLjxXT4y4vswc5+gl9cg4RPD/UkoNzUW
	Kxa8I64zrFNnUbYtWGo2F8y6jfdy+Y/1j6mr3opj6WKpFywdqkRpYCliluDyv1d2jW4y6MPgxzd
	5wBiRRM94vrC2HJoDWTmIz5P3Y1rYi2zioFmJiQPupxjkmIeGUxc9k//sHth8VkvZD2ABeik8UM
	9/ZOlh/9TjNtFXp8
X-Received: by 2002:a17:907:1c9a:b0:bb7:be3b:ba3e with SMTP id
 a640c23a62f3a-bbffc480964mr426620266b.45.1777897730070; Mon, 04 May 2026
 05:28:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501112023.338005-1-sprasad@microsoft.com>
 <20260501112023.338005-13-sprasad@microsoft.com> <CAH2r5mtgqehu+Qtutws_cHQRmULHZi_-0_WRyskmT=emcZEjzw@mail.gmail.com>
In-Reply-To: <CAH2r5mtgqehu+Qtutws_cHQRmULHZi_-0_WRyskmT=emcZEjzw@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 4 May 2026 17:58:38 +0530
X-Gm-Features: AVHnY4KMeobc6GniFrRCa-6R2-lcsDf7uEmwuU-FDNm8U1vWSQOLhFMBSEk1Ws4
Message-ID: <CANT5p=phGhjF3EmFb9cR1PXtfb_2Y=osE9qYRkm=5p875fvCXQ@mail.gmail.com>
Subject: Re: [PATCH v4 13/19] cifs: option to disable time-based eviction of cache
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 9:17=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> Seems like there is still value in temporarily free up the dir cache
> (setting dir_cache_timeout to 0), remount with nohandlecache may not
> be as helpful if you just want to temporarily reset the dir cache for
> debugging.  Is there another option that could set it to unlimited
> (e.g. setting to -1, if that is allowed)?
>
> On Fri, May 1, 2026 at 6:20=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today there is no way to disable time-based eviction of dir cache.
> > dir_cache_timeout =3D 0 meant immediate free up of dir cache on next
> > laundromat scan. We already have nohandlecache to disable dir cache.
> >
> > This changes the meaning of dir_cache_timeout =3D 0 to mean unlimited
> > timeout. Shrinker-based eviction is still possible.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsfs.c  | 2 +-
> >  fs/smb/client/connect.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index ee5de358e27f8..79a6a4c297ee3 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -121,7 +121,7 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous re=
quests to server for "
> >  unsigned int dir_cache_timeout =3D 30;
> >  module_param(dir_cache_timeout, uint, 0644);
> >  MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache direct=
ory contents for which we have a lease. Default: 30 "
> > -                                "Range: 1 to 65000 seconds, 0 to disab=
le caching dir contents");
> > +                                "Range: 0 to 65000 seconds. 0 disables=
 timeout-based cleanup (cached dirs persist until explicitly invalidated)."=
);
> >  /* Module-wide total cached dirents (in bytes) across all tcons */
> >  atomic64_t cifs_dircache_bytes_used =3D ATOMIC64_INIT(0);
> >  static struct shrinker *cifs_dircache_shrinker;
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 69b38f0ccf2b2..849c16c538353 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -2698,7 +2698,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_f=
s_context *ctx)
> >
> >         if (ses->server->dialect >=3D SMB20_PROT_ID &&
> >             (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEAS=
ING))
> > -               nohandlecache =3D ctx->nohandlecache || !dir_cache_time=
out;
> > +               nohandlecache =3D ctx->nohandlecache;
> >         else
> >                 nohandlecache =3D true;
> >         tcon =3D tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_n=
ew);
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve

You have an option to drop dir cache just for that.

--=20
Regards,
Shyam
