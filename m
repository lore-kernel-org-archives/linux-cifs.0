Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA46219B3CB
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749749349; cv=none; b=uMwZOsILndIWr8pPl1Wc8lIsI5wNm9HCo5KtN/XwcGNjQ0WowqV5V3fWDpNow8kXXgSsy2AkpTi37XGX4pkqMelysg8bfnk3YUjsxHGKxT8UzdDHVVaC9xUdO9SkRsyWoYZBXguQPyTLfX8Q8az9HMs2QxzNk18V8dstxz11kTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749749349; c=relaxed/simple;
	bh=2frSqlGgKeNLZYpYyGElRTryB1xrd6wLOR5pK5KlfYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WMpwId2KQmj5OeVdm5w/K4OXORA26GgC9vooJvWvBrwMckyy1PMq9BOl3dqebvPU253TjR40vIr/Iu6UTyn4JgArcXeEqs0qPKC/Jwf2BrLDw69i2YPbK300f32IlDoMeE3bQX6pz5WQAgUL/E3bIezIFc3zjDhUrN6u0H17O8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ba0pelTU; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ba0pelTU"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-607c5715ef2so2132361a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 10:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749749345; x=1750354145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dI1SbB8e38knDmJ+zxjruGIp/w/QqIYx1kxMBUPFR3I=;
        b=Ba0pelTUYH038V/j9n4XmIXKquQf8R5i1yOdKZFn/eNQMB1B3n9yCHSD2o5DFMzPRS
         SZHuQF2vysNGXDpZcuG4/BvPfsPZCHFOnm4maHXeK4T4uz45Io62u5YnZ40A+sHmnQG0
         TMtiAFNMw2BoFpmRbyAl/CiC/IXO6gIZM9dyQCAsKG6S8M3g5Wd4Itg0jVE2uSHGEJBH
         7vcKaW9UepFjCoMczYxHTRU18gLAETk0pgbYccAlU6qtNyHxIuj5p31XLLxvgGbhWjl2
         XGX8LAHe0IfUAv2XXkIHDGE013vTu4mL6p9T0hwtUqGQUs+rkACuR63HSnEFGLaNRmiH
         txDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749749345; x=1750354145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dI1SbB8e38knDmJ+zxjruGIp/w/QqIYx1kxMBUPFR3I=;
        b=f+XJaSnF223cp/N5tLD7gkMd2lGZUN4SOAXxV/JIECPC/34Uw1SYNjn9XAgoeqFr0p
         rlegEVX+Yd6pE/F1JidT+1gqsFvZnzJvUznfXNHAmFV7TQtqckfl01dFRtzZeSmmZAnY
         EpUrMonCPVXLHaLvAtdVfcnyX7LuJjnYpDrb2yFpdAtw8VDi/yAIISihhrGQYIVm3oZS
         ZTqCz8WXx9X8qiU1QYa6KmYA48MY2kxadAbqcdhkZTMqlbm/zR1owfjnw4Bt00Fc8ra1
         5a5YMKD1SvY0/DLf6krWmtxKZZFQV2p/kvr/5hAoQasB7xLpr6fSxvkwYML/NWN6OCSc
         tH3w==
X-Forwarded-Encrypted: i=1; AJvYcCWuysGqxoEzKHdbJjfoJm9ubOMsev1Ijl+WlfJ1E8FMsvmRBE8aelhvoL9WviMn22QaAWFs2rA/K/1o@vger.kernel.org
X-Gm-Message-State: AOJu0YzCs9e5XNbAS+sr5ACQ/g4YXg8BQhmH38Sz/ksFXAsaoiQ4EF7l
	WaJi6ByG3ILno4Lf7AxAxzSClU36jjeOs12lTswfwrEhzHhxRgWzpWlBrQBwjDUZZ7pqV/7/IDs
	R0wXx338dn1af8Zbe3gFiwgmNTbXAkOknuTl3
X-Gm-Gg: ASbGncu9+uLf8OsPyWDMYgRHh9Qe+/4VbM7VqffHk3EeBlvtFiKlXR1Z74cKys1feSa
	dzSFu4+JrkelQHvgdKK8SGGMVUA9d7mtKCvcUpIacqTx1pw1qbQVuAqigc4cr8DW29m6e5vWNAB
	gIeO83abCx/IbzgCsu3Yb+U4e89QdloQyRPhp0llV0uQ==
X-Google-Smtp-Source: AGHT+IE01VyG/r4ztHCMbfZbcP4Zx1hdy7s2/j98R3aBn83AnEw7gEzw+XPgoM3qCwxtlhFFqEaDYzL7kVVRG1jEPeg=
X-Received: by 2002:a05:6402:4408:b0:607:2417:6d04 with SMTP id
 4fb4d7f45d1cf-608af55d1c7mr688968a12.14.1749749345009; Thu, 12 Jun 2025
 10:29:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611112902.60071-1-bharathsm@microsoft.com> <CAH2r5munktDK1VstQRZ6VcRWyYMasHnR53VM+3i=cz1JYpcpaA@mail.gmail.com>
In-Reply-To: <CAH2r5munktDK1VstQRZ6VcRWyYMasHnR53VM+3i=cz1JYpcpaA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Jun 2025 22:58:53 +0530
X-Gm-Features: AX0GCFt_Ub0YNDlpxqAexc0F6OnHyGsxQv8Q3adoiYKFYuoD6ZwoTWSX-NTi9DU
Message-ID: <CANT5p=rC2gd6aD4On4HkojHFz4-547v12Cu1oUBOOzNCMuANFQ@mail.gmail.com>
Subject: Re: [PATCH] smb: improve directory cache reuse for readdir operations
To: Steve French <smfrench@gmail.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, pc@manguebit.com, ronniesahlberg@gmail.com, 
	paul@darkrain42.org, Bharath SM <bharathsm@microsoft.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 8:45=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> merged this updated patch into cifs-2.6.git for-next, running xfstests
> on it now.
>
> Looks very promising, and we have a couple more dir lease
> optimizations to try out that should also help a lot with perf, and
> reducing load on servers by sending fewer metadata ops over the wire
>
> On Wed, Jun 11, 2025 at 6:29=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > Currently, cached directory contents were not reused across subsequent
> > 'ls' operations because the cache validity check relied on comparing
> > the ctx pointer, which changes with each readdir invocation. As a
> > result, the cached dir entries was not marked as valid and the cache wa=
s
> > not utilized for subsequent 'ls' operations.
> >
> > This change uses the file pointer, which remains consistent across all
> > readdir calls for a given directory instance, to associate and validate
> > the cache. As a result, cached directory contents can now be
> > correctly reused, improving performance for repeated directory listings=
.
> >
> > Performance gains with local windows SMB server:
> >
> > Without the patch and default actimeo=3D1:
> >  1000 directory enumeration operations on dir with 10k files took 135.0=
s
> >
> > With this patch and actimeo=3D0:
> >  1000 directory enumeration operations on dir with 10k files took just =
5.1s
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.h |  8 ++++----
> >  fs/smb/client/readdir.c    | 28 +++++++++++++++-------------
> >  2 files changed, 19 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > index 1dfe79d947a6..bc8a812ff95f 100644
> > --- a/fs/smb/client/cached_dir.h
> > +++ b/fs/smb/client/cached_dir.h
> > @@ -21,10 +21,10 @@ struct cached_dirent {
> >  struct cached_dirents {
> >         bool is_valid:1;
> >         bool is_failed:1;
> > -       struct dir_context *ctx; /*
> > -                                 * Only used to make sure we only take=
 entries
> > -                                 * from a single context. Never derefe=
renced.
> > -                                 */
> > +       struct file *file; /*
> > +                           * Used to associate the cache with a single
> > +                           * open file instance.
> > +                           */
> >         struct mutex de_mutex;
> >         int pos;                 /* Expected ctx->pos */
> >         struct list_head entries;
> > diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> > index f9f11cbf89be..ba0193cf9033 100644
> > --- a/fs/smb/client/readdir.c
> > +++ b/fs/smb/client/readdir.c
> > @@ -851,9 +851,9 @@ static bool emit_cached_dirents(struct cached_diren=
ts *cde,
> >  }
> >
> >  static void update_cached_dirents_count(struct cached_dirents *cde,
> > -                                       struct dir_context *ctx)
> > +                                       struct file *file)
> >  {
> > -       if (cde->ctx !=3D ctx)
> > +       if (cde->file !=3D file)
> >                 return;
> >         if (cde->is_valid || cde->is_failed)
> >                 return;
> > @@ -862,9 +862,9 @@ static void update_cached_dirents_count(struct cach=
ed_dirents *cde,
> >  }
> >
> >  static void finished_cached_dirents_count(struct cached_dirents *cde,
> > -                                       struct dir_context *ctx)
> > +                                       struct dir_context *ctx, struct=
 file *file)
> >  {
> > -       if (cde->ctx !=3D ctx)
> > +       if (cde->file !=3D file)
> >                 return;
> >         if (cde->is_valid || cde->is_failed)
> >                 return;
> > @@ -877,11 +877,12 @@ static void finished_cached_dirents_count(struct =
cached_dirents *cde,
> >  static void add_cached_dirent(struct cached_dirents *cde,
> >                               struct dir_context *ctx,
> >                               const char *name, int namelen,
> > -                             struct cifs_fattr *fattr)
> > +                             struct cifs_fattr *fattr,
> > +                                 struct file *file)
> >  {
> >         struct cached_dirent *de;
> >
> > -       if (cde->ctx !=3D ctx)
> > +       if (cde->file !=3D file)
> >                 return;
> >         if (cde->is_valid || cde->is_failed)
> >                 return;
> > @@ -911,7 +912,8 @@ static void add_cached_dirent(struct cached_dirents=
 *cde,
> >  static bool cifs_dir_emit(struct dir_context *ctx,
> >                           const char *name, int namelen,
> >                           struct cifs_fattr *fattr,
> > -                         struct cached_fid *cfid)
> > +                         struct cached_fid *cfid,
> > +                         struct file *file)
> >  {
> >         bool rc;
> >         ino_t ino =3D cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
> > @@ -923,7 +925,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
> >         if (cfid) {
> >                 mutex_lock(&cfid->dirents.de_mutex);
> >                 add_cached_dirent(&cfid->dirents, ctx, name, namelen,
> > -                                 fattr);
> > +                                 fattr, file);
> >                 mutex_unlock(&cfid->dirents.de_mutex);
> >         }
> >
> > @@ -1023,7 +1025,7 @@ static int cifs_filldir(char *find_entry, struct =
file *file,
> >         cifs_prime_dcache(file_dentry(file), &name, &fattr);
> >
> >         return !cifs_dir_emit(ctx, name.name, name.len,
> > -                             &fattr, cfid);
> > +                             &fattr, cfid, file);
> >  }
> >
> >
> > @@ -1074,8 +1076,8 @@ int cifs_readdir(struct file *file, struct dir_co=
ntext *ctx)
> >          * we need to initialize scanning and storing the
> >          * directory content.
> >          */
> > -       if (ctx->pos =3D=3D 0 && cfid->dirents.ctx =3D=3D NULL) {
> > -               cfid->dirents.ctx =3D ctx;
> > +       if (ctx->pos =3D=3D 0 && cfid->dirents.file =3D=3D NULL) {
> > +               cfid->dirents.file =3D file;
> >                 cfid->dirents.pos =3D 2;
> >         }
> >         /*
> > @@ -1143,7 +1145,7 @@ int cifs_readdir(struct file *file, struct dir_co=
ntext *ctx)
> >         } else {
> >                 if (cfid) {
> >                         mutex_lock(&cfid->dirents.de_mutex);
> > -                       finished_cached_dirents_count(&cfid->dirents, c=
tx);
> > +                       finished_cached_dirents_count(&cfid->dirents, c=
tx, file);
> >                         mutex_unlock(&cfid->dirents.de_mutex);
> >                 }
> >                 cifs_dbg(FYI, "Could not find entry\n");
> > @@ -1184,7 +1186,7 @@ int cifs_readdir(struct file *file, struct dir_co=
ntext *ctx)
> >                 ctx->pos++;
> >                 if (cfid) {
> >                         mutex_lock(&cfid->dirents.de_mutex);
> > -                       update_cached_dirents_count(&cfid->dirents, ctx=
);
> > +                       update_cached_dirents_count(&cfid->dirents, fil=
e);
> >                         mutex_unlock(&cfid->dirents.de_mutex);
> >                 }
> >
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve
>
Looks good to me. You can add my RB.

--=20
Regards,
Shyam
