Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3B729C344
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742143; cv=none; b=Kown1SLh+6FcHAOPTt57Tky79+dZT9KSvLkmnbokLYnUfOA2TYdxo1NXh6bubXGtMGRYQAtCIEh+dAiHZz9jO1E4PzFprHzln0pbp6Kbqv5a/36IHS23vGGXlfsB9puUGWB43d8DTTMerldN6TuOd9GdnVP8a2dLgyrAlM6z7Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742143; c=relaxed/simple;
	bh=9Wcz0EgAvBuq7skMcbu3TqJWuN9aavtWwlkmVbJJabc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdBWZ/h2XIaWiYwAnEVFlRYWL1ukOruXgenvsUMcYSnLUgorMect4SZYMk04l3PasVHRuTSI31tFAID3k+jLG7gHxWNVeJjNV+5HMHUYxznkXoM/pP4gc/sI8forpJ7355QCWPC2f4sH46UylCEHlDbnpkioSJHalYF6HwB4i6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9LNxISg; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9LNxISg"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55350d0eedeso1023585e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749742139; x=1750346939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g80HoXcjmH9pJp+7YdyycmiK/uaTtj0/EEMvAUdEQlA=;
        b=Z9LNxISgQ2O5heagS25icC04iRt6pXhpPCrfX5fsZIeXE+Kn2WgSZKG8cDJ00/ajqZ
         d1vqKtKQMuLN6MWDpoHw7NO5hI5ahhZb1Yi9XqfPqhv6lRBX35GYDOirGJr82SOYIqAs
         PYmLUX9Nu775WrRJPLimsCVx5aTkOPPhvwvq8jGIHN4/V8SJF23f+HqsLEqtBkSyuFDJ
         h+mHcHfxls5MLc6xyh6p8yh1Qjr5JVRNZFpgsd8bu7kQ5CBAnrOJxZpFaXbZlFV+PNRT
         XpWFouZZv1yao5pY8ccEIz2UNXqTiFhI52IvKtEpKSBIKtC1UY7Pe3S3exfxuVt5wvq6
         pHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749742139; x=1750346939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g80HoXcjmH9pJp+7YdyycmiK/uaTtj0/EEMvAUdEQlA=;
        b=TYJ5jMePh9FFzS1Bw/Z8N5E1p6o6r0sP6wpw7Spo/QL9gsiiH1GqwnZ2/zyjWHZlvd
         0Bw2R/gw7gCx2D1snrHyH8h85j/KMUzJqySjdxyVwJrYk/R3Cxs+qKHbtjOktaEgg3yE
         9Gs0mPC82dK4gctBfJ1iuCkntEiKFJQaoaxHwENQMhnWVRTm+JXikhOVM9REJw35gIkX
         xZosH4vEM81oXpq3hfTRm5R21/r1cFAH6b0EQUagARSW4SUVz+cTV4ht5T4PNiRm9Y2Y
         cDwPFegTN37kf1+J4NMKY7xECDdFH7vxShbbh3v4HL/HSRV/ZB8ffJGgtGDdwL2nt6yR
         OBmw==
X-Gm-Message-State: AOJu0YzWftpLzf9Aq+j6uxECs1ojBqbh6GPh2roqX/22HL8is5DyPJa5
	gJaT8ClWjLN2t+i6xe3xRRsLZ6B4acZzgYd1wi8pQco5hjL8Cq9wiW97AJ9PJyTZljZ3jXmoZGo
	p5Sk2zDn2strxP/51zOCvqJfREg0Pa7E=
X-Gm-Gg: ASbGncuZQbkmfWxOc/VHhkTE424fbfxuteXIF5YkYR3wzv6LARqtAjTj4MTOsAHZBLh
	q33NPlxgOrShTFGGGxyeGO/5YZyU9yeggobTAS+l/UWJxsu5VWIYAhfazxRjRhOuL85IaenJOD/
	4a+m7fbzTAr5KnzNbgC37DiROIXZ4otbeEAOoAa/cO9A==
X-Google-Smtp-Source: AGHT+IHzBbSFJEZTEfwVdm88ETLkif4NbkyXC1BZ94UH1IOg/bre90wb1+hgWTSdryvAqYAsvH5VydRvkXXkr0MKgI4=
X-Received: by 2002:a05:6512:3b23:b0:553:2f25:3b46 with SMTP id
 2adb3069b0e04-553a5647a6bmr1079519e87.57.1749742139067; Thu, 12 Jun 2025
 08:28:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-4-sprasad@microsoft.com> <aEpIpa3gbbz-nk86@vaarsuvius.home.arpa>
 <CANT5p=qp_+s4Q42J8TyuAwQmPEpY4g+SYAGsgcBmQkipsLiXrg@mail.gmail.com>
In-Reply-To: <CANT5p=qp_+s4Q42J8TyuAwQmPEpY4g+SYAGsgcBmQkipsLiXrg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Jun 2025 10:28:48 -0500
X-Gm-Features: AX0GCFsG8xohAmovYAHI9BQp2eRuq0SFpti8NVw3SvJKAoxv41mCy_sY7K5qhbU
Message-ID: <CAH2r5msJYghVKpHsDiNzSGSVq_GzLM5zzPco7gqC4FWmHP29gA@mail.gmail.com>
Subject: Re: [PATCH 4/7] cifs: serialize initialization and cleanup of cfid
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Steve: Do you want me to submit a v2? Or submit another patch to fix this=
?

For patches that are not in mainline yet, then better to send a v2, yes

On Thu, Jun 12, 2025 at 4:38=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Thu, Jun 12, 2025 at 8:55=E2=80=AFAM Paul Aurich <paul@darkrain42.org>=
 wrote:
> >
> > On 2025-06-04 15:48:13 +0530, nspmangalore@gmail.com wrote:
> > >From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > >Today we can have multiple processes calling open_cached_dir
> > >and other workers freeing the cached dir all in parallel.
> > >Although small sections of this code is locked to protect
> > >individual fields, there can be races between these threads
> > >which can be hard to debug.
> > >
> > >This patch serializes all initialization and cleanup of
> > >the cfid struct and the associated resources: dentry and
> > >the server handle.
> > >
> > >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > >---
> > > fs/smb/client/cached_dir.c | 16 ++++++++++++++++
> > > fs/smb/client/cached_dir.h |  1 +
> > > 2 files changed, 17 insertions(+)
> > >
> > >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > >index 94538f52dfc8..2746d693d80a 100644
> > >--- a/fs/smb/client/cached_dir.c
> > >+++ b/fs/smb/client/cached_dir.c
> > >@@ -198,6 +198,12 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> > >               return -ENOENT;
> > >       }
> > >
> > >+      /*
> > >+       * the following is a critical section. We need to make sure th=
at the
> > >+       * callers are serialized per-cfid
> > >+       */
> > >+      mutex_lock(&cfid->cfid_mutex);
> > >+
> > >       /*
> > >        * check again that the cfid is valid (with mutex held this tim=
e).
> > >        * Return cached fid if it is valid (has a lease and has a time=
).
> > >@@ -208,11 +214,13 @@ int open_cached_dir(unsigned int xid, struct cif=
s_tcon *tcon,
> > >       spin_lock(&cfid->fid_lock);
> > >       if (cfid->has_lease && cfid->time) {
> > >               spin_unlock(&cfid->fid_lock);
> > >+              mutex_unlock(&cfid->cfid_mutex);
> > >               *ret_cfid =3D cfid;
> > >               kfree(utf16_path);
> > >               return 0;
> > >       } else if (!cfid->has_lease) {
> > >               spin_unlock(&cfid->fid_lock);
> > >+              mutex_unlock(&cfid->cfid_mutex);
> > >               /* drop the ref that we have */
> > >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> > >               kfree(utf16_path);
> > >@@ -229,6 +237,7 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> > >        */
> > >       npath =3D path_no_prefix(cifs_sb, path);
> > >       if (IS_ERR(npath)) {
> > >+              mutex_unlock(&cfid->cfid_mutex);
> >
> > Double mutex_unlock?  (It's also unlocked unconditionally in the 'out' =
path)
>
> Good catch!
> Steve: Do you want me to submit a v2? Or submit another patch to fix this=
?
>
> >
> > >               rc =3D PTR_ERR(npath);
> > >               goto out;
> > >       }
> > >@@ -389,6 +398,8 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> > >               *ret_cfid =3D cfid;
> > >               atomic_inc(&tcon->num_remote_opens);
> > >       }
> > >+      mutex_unlock(&cfid->cfid_mutex);
> > >+
> > >       kfree(utf16_path);
> > >
> > >       if (is_replayable_error(rc) &&
> > >@@ -432,6 +443,9 @@ smb2_close_cached_fid(struct kref *ref)
> > >                                              refcount);
> > >       int rc;
> > >
> > >+      /* make sure not to race with server open */
> > >+      mutex_lock(&cfid->cfid_mutex);
> > >+
> > >       spin_lock(&cfid->cfids->cfid_list_lock);
> > >       if (cfid->on_list) {
> > >               list_del(&cfid->entry);
> > >@@ -452,6 +466,7 @@ smb2_close_cached_fid(struct kref *ref)
> > >               if (rc) /* should we retry on -EBUSY or -EAGAIN? */
> > >                       cifs_dbg(VFS, "close cached dir rc %d\n", rc);
> > >       }
> > >+      mutex_unlock(&cfid->cfid_mutex);
> > >
> > >       free_cached_dir(cfid);
> > > }
> > >@@ -666,6 +681,7 @@ static struct cached_fid *init_cached_dir(const ch=
ar *path)
> > >       INIT_LIST_HEAD(&cfid->entry);
> > >       INIT_LIST_HEAD(&cfid->dirents.entries);
> > >       mutex_init(&cfid->dirents.de_mutex);
> > >+      mutex_init(&cfid->cfid_mutex);
> > >       spin_lock_init(&cfid->fid_lock);
> > >       kref_init(&cfid->refcount);
> > >       return cfid;
> > >diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > >index 1dfe79d947a6..93c936af2253 100644
> > >--- a/fs/smb/client/cached_dir.h
> > >+++ b/fs/smb/client/cached_dir.h
> > >@@ -42,6 +42,7 @@ struct cached_fid {
> > >       struct kref refcount;
> > >       struct cifs_fid fid;
> > >       spinlock_t fid_lock;
> > >+      struct mutex cfid_mutex;
> > >       struct cifs_tcon *tcon;
> > >       struct dentry *dentry;
> > >       struct work_struct put_work;
> > >--
> > >2.43.0
> > >
> >
> > ~Paul
> >
>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
