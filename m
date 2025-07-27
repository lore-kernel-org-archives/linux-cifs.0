Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887711FF603
	for <linux-cifs@vger.kernel.org>; Sun, 27 Jul 2025 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753640618; cv=none; b=o+vp2/HUmDM9bgug7gLPiB2Eo2GiSHQRqklWsa5ntDJAFcF+WqVXlLV92cv9OwX2d008ZY4Lzmoz8xKJMjRTZiimYD1Pji3ipAbkePgkxAy6vImwy3w8KZcXV8IGJAVykIZhji+r0g9JqpCsrocPIvaL2lbnZDuu8G4yQTz6PM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753640618; c=relaxed/simple;
	bh=jJAJ/oLlW3VhHtx7lxswQ6+1kTLpQ6EFMadVBalnerY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f4Pwv/DTAjTJ3LLWkjciX7t7ytE9m/ONdOsNytgdsFdE7npHIaDi3euvwCL7OjUQmBaZLzaUV177uW8lceNkeAGx9YaPfe3wTVb9GzmPP4sMlYizPB+o25Ke7QEDFWBQL3g9SFoiBPWQttdKQpcNhDz1wt1+2LWNxJJO8Bv53so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L7iCdj6X; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L7iCdj6X"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso34400306d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 27 Jul 2025 11:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753640615; x=1754245415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zKTNeUJEqSL440AOY+0PCgsp0MrqpEf6oTNYz2XFqw=;
        b=L7iCdj6XWDlijPSrjfAdN51OBrx99zHKch9qQ7I4m+zgubsDSjpTSsizKrWLIx1IfF
         0+a93F1zN6MqKEbo3tUK4FcaKJ7vb7SqOW0KEdJVNmwsaZG2kBKGDumrBIJvtQbJFX+/
         ViVVgof+mXWdIX1VWnxV/t6YoixZza4Mvtu9zFQNqLnnFDs1JOna1n+p72U0GMfiz2yp
         r2kprCjROUqL2XdggGhUp/0djKTQpm1TyufwwwoaqKWQO3WfbPM8E3og+11KWbJb9PbB
         o3CB2ZjNx1xcVRub8wqJuncZ0McdiUYkN7ciUn9KUMpS4hy8kkDPE7cENE65Dvnhyyua
         uibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753640615; x=1754245415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zKTNeUJEqSL440AOY+0PCgsp0MrqpEf6oTNYz2XFqw=;
        b=RcLQYOsODnEUdcqOle1heElpfegyKr4wZFDMWbt47Qf25S1uVrdd4qzT6tR7IIc+v9
         I/j175BbHG2ebxbQ9jiGf4cn7sQrQhBs78uWLIr+VkIt+BQo/MCAVJk5tiFDd5B1Xgs5
         vd4axksgdAKP8KdKNJ7Vkvv+xvomyTC/wqvSBr587w/cQ4M5LcYg8JnZOtXtUuR66NjH
         lI9+7x1Lr7k6g5Lznsfpsd2iajitfI3CH0b1A+w4zuPpGdeyFn8OW/TmkAwJGMpcqZWg
         UAGljCxXJmli2Pt+Tiw9/58Lw4Vx+imu+YddLbi5SWeEj5C2O6LXbpvw4yKJ7sMv25rJ
         ucDA==
X-Gm-Message-State: AOJu0Yx3D68EfOjYQrNnh23l1AEEatWUDMoQPQWhffniLCfA2icJSSWX
	nymmZ+/UO7XXvAAOqa8EoNGyIaioY+UL974AQqBS4QEIZpGM6WSn39JlBhXEJ6/p0pdmfXdtHSM
	EgvXgN6oIRk419IDesh4vG1v7O/xmI54=
X-Gm-Gg: ASbGncuJXLnoMlijLjVYHgZSMjWWBBuzo7dnyVwD0t0Zj6r7i4c84mK1L49FbusywwA
	F6g/WIO/IkE2gQNLPoBJbO3LVZkRaZXtfpFEcCW0cZpEz4dXTNs9pVqkISMPyV3eJ81x7TX3Ysa
	l1qdTUgLKXZ8pf2M+p9Pp8YemTRpmg/2ZUS6PHuvZSZXKUqXnbYDKtcll8SYb/k15WubpCLTVqp
	KiauPAaxDajLoV5Ipz6sS0OAV8QHRmHOJWg+PabTQIVjtQG8BhN
X-Google-Smtp-Source: AGHT+IF6gifLg1EZi3AR7ZOHQ5I4on/Pi8NsIjnjBpFAvfznftBUNk+lz706PxvGZuaafxBumndldO+bKbTWvp6QOUo=
X-Received: by 2002:ad4:5de6:0:b0:704:f7d8:edfe with SMTP id
 6a1803df08f44-7072060de4emr115948286d6.51.1753640615160; Sun, 27 Jul 2025
 11:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-7-sprasad@microsoft.com> <CAH2r5mvHV8Y2tO156TmQ7ymrgaiFPZSsZdzSNWvEreDq2p-G=A@mail.gmail.com>
 <CAH2r5muix9VFHpoVmDvUbZnwEeT94zXw7SrGKRf+Crgj8vgS5Q@mail.gmail.com>
In-Reply-To: <CAH2r5muix9VFHpoVmDvUbZnwEeT94zXw7SrGKRf+Crgj8vgS5Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 27 Jul 2025 13:23:22 -0500
X-Gm-Features: Ac12FXz6qRsHZGa0m_IDJRX0kQl-hy0RejwoBei5axCVW7_BwpXIYRehjvyJCrY
Message-ID: <CAH2r5mszxU9KSWkTBc58Zz_vZGCw50Td-MfeNoJKFFaH2KoMJw@mail.gmail.com>
Subject: Re: [PATCH 7/7] cifs: add new field to track the last access time of cfid
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, paul@darkrain42.org, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One minor improvement we could do - I noticed that this helps workloads lik=
e:

"ls /mnt/somedir ; do stuff ; ls /mnt/somedir (uses cached data from
first) ; ... "ls /mnt/somedir"

but it doesn't help

"ls /mnt/somedir ; do stuff ; stat /mnt/somedir ; do stuff ; stat
/mnt/somedir ; etc."

When "ls" is repeated then we bump up the timeout for that directory
lease, but if ls is instead only followed by "stat" or "revalidate"
(not ls/query_dir) of the directory (stat/revalidate is much more
common than ls) then it doesn't bump up the timeout for the directory
lease.

Maybe followon patch can determine when to bump up the timeout when
revalidate/stat is frequently accessing the cached directory metadata

On Thu, Jul 24, 2025 at 10:26=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Updated patch with description
>
>
> On Thu, Jul 24, 2025 at 6:05=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > Rebased version of patch attached. See attached. Let me know if any
> > objections.  It solves an obvious important issue (we shouldn't be
> > timing out directory leases if they are the most recently used ones)
> >
> >
> > On Wed, Jun 4, 2025 at 5:18=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> > >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > The handlecache code today tracks the time at which dir lease was
> > > acquired and the laundromat thread uses that to check for old
> > > entries to cleanup.
> > >
> > > However, if a directory is actively accessed, it should not
> > > be chosen to expire first.
> > >
> > > This change adds a new last_access_time field to cfid and
> > > uses that to decide expiry of the cfid.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/smb/client/cached_dir.c | 6 ++++--
> > >  fs/smb/client/cached_dir.h | 1 +
> > >  2 files changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > > index 4abf5bbd8baf..d432a40f902e 100644
> > > --- a/fs/smb/client/cached_dir.c
> > > +++ b/fs/smb/client/cached_dir.c
> > > @@ -213,6 +213,7 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> > >          */
> > >         spin_lock(&cfid->fid_lock);
> > >         if (cfid->has_lease && cfid->time) {
> > > +               cfid->last_access_time =3D jiffies;
> > >                 spin_unlock(&cfid->fid_lock);
> > >                 mutex_unlock(&cfid->cfid_mutex);
> > >                 *ret_cfid =3D cfid;
> > > @@ -365,6 +366,7 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> > >         cfid->tcon =3D tcon;
> > >         cfid->is_open =3D true;
> > >         cfid->time =3D jiffies;
> > > +       cfid->last_access_time =3D jiffies;
> > >         spin_unlock(&cfid->fid_lock);
> > >
> > >  oshr_free:
> > > @@ -741,8 +743,8 @@ static void cfids_laundromat_worker(struct work_s=
truct *work)
> > >         spin_lock(&cfids->cfid_list_lock);
> > >         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> > >                 spin_lock(&cfid->fid_lock);
> > > -               if (cfid->time &&
> > > -                   time_after(jiffies, cfid->time + HZ * dir_cache_t=
imeout)) {
> > > +               if (cfid->last_access_time &&
> > > +                   time_after(jiffies, cfid->last_access_time + HZ *=
 dir_cache_timeout)) {
> > >                         cfid->on_list =3D false;
> > >                         list_move(&cfid->entry, &entry);
> > >                         cfids->num_entries--;
> > > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > > index 93c936af2253..6d4b9413aa67 100644
> > > --- a/fs/smb/client/cached_dir.h
> > > +++ b/fs/smb/client/cached_dir.h
> > > @@ -39,6 +39,7 @@ struct cached_fid {
> > >         bool on_list:1;
> > >         bool file_all_info_is_valid:1;
> > >         unsigned long time; /* jiffies of when lease was taken */
> > > +       unsigned long last_access_time; /* jiffies of when last acces=
sed */
> > >         struct kref refcount;
> > >         struct cifs_fid fid;
> > >         spinlock_t fid_lock;
> > > --
> > > 2.43.0
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
