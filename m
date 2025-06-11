Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D161C20CCD3
	for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749654742; cv=none; b=NXnLyse5QtG+d1uxF0EUet4oXK4aCX+hD2dk7gaLsRtCmNG8TtfjAGU3aKudM8btOJpyFtPvca4KUdXeY5QSOFNwzX5oYH+3rmdUe3oUXEkiIL4rVUrYabWiUGHdd/DADuVdTJB8+2nZ4t8WqTeAGaWstPauFOJBdxLwjshjwvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749654742; c=relaxed/simple;
	bh=yqnq/8THBSrKJCwxxuAgAa2TMGEjkrqUGTt7fvq0CtM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cLmFHDbYgefo3amDct+JqRXXxXHRacSMpglXiGsPpbwainVZw2xAfpVsd0nj55TcLsFzCf3KxKvblFywhJqjoQdQfpLo8gBNH01erFx/oRnJDU/IwBoq3cqXfqUvgwRktS9Si/oG88zsq+UqAQy9UCWqwco5LCkq6jDWc7gD4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lc05O14A; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lc05O14A"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-32a7a12955eso32312631fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 08:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749654739; x=1750259539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5d4rQ7j/tpr5QKroSCDl0E2qZSLxiAsShxNtEN6jKek=;
        b=Lc05O14AWmwfUZUbI604WzwQKLCghz5WRuJVqBf1H9T9q7J5MzxusOgB/Fu4f002nC
         F2Mgqnfz4O3JYROjPHJN2/xSW+ttLcfBOG7orppn0TFMoUDeI8ViiTQUCZj7TrAbzs/r
         DiEkyeQUXYaJEBJrZCnqwlhaycdmDYVdWgfecB05k52ib42XcYMm0cphxcdwuxzk12cp
         PlELLg7acvDaYwC9keFn9+fQ/wW454VSN3Brf5/jbL1QFN5WNdniMBgS7tx/pAqaDQJE
         WXw3EpBDWSEbkSgszR3fQJq6WlOMi4bM2Awb8svOXIDc60brNVdpwMrvtZQhWR+g1PCb
         ntuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749654739; x=1750259539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5d4rQ7j/tpr5QKroSCDl0E2qZSLxiAsShxNtEN6jKek=;
        b=gEcW2SG54CGSSbKPDHpozPHC4Z+4SrUV6e3G9jEMq3M0CimfOvJsdWPMHFfARNmn4U
         IqX/4MRRTIH80llzIL/jYUQ/9lrsyeLt1HeBfPpjG9StlgRCxqtcpPF8cv2yDBMlvyVS
         KHQ4mCNk8jl63rYuQNr0Kd+UaTNCmpCQQ8HV7JhyMxlcX52WuZ+IZXYiGFeZABAN7D/v
         z2hVfn8fiOUW7+pS3QsCIs5quT5v6XqHdWhxKpWlNYaXSK2xE1H9DfnfqiFggQz2Wh0t
         S5XO7YJwZl0ieJWiSJacTNrB19FI3d654ls9YlbmomDR72UtZ0mkiEekFgPR6cbACWZp
         LM7Q==
X-Gm-Message-State: AOJu0YwpMoqRyqu5yJ14rUSuHd+8wgUh/GXtySODrox2aOfxNd2RQg4z
	df+euEewPyp73bsXHyv95jYNbsrGWIhSb4QAOkumRjATmrjqGtJF6mNHdhdHMqW3GJI4NSOAGCM
	hoIcPI6bRCv4ES7i7N9J84vW3meXTlV5xnw==
X-Gm-Gg: ASbGnctkEG1YUxgS1tpso7XeXSKRlKI3XFy2N1J4AULzDTWhUsawTDDdYJbcw2mP+og
	QMCNwUiel97A4ug72dFAS89evD4Q6GNm0gqZJlxiIs/M2hzmlb+zJNbzgtuGmqiblvcVUdAa9uK
	NQe1R+wnYVz9IFoeNiETygC6udgTBgdDgo6Zg0j24WBjvb84WWkiA6v9cXVH904CbyEENwTpUB5
	oAibQ==
X-Google-Smtp-Source: AGHT+IFszMwNbQOCxLYs447Esu6qG70KcmNWlNBnyPZ1yAO4cpvg7wgpGE8lTuKNZIyYQGWkQcLuCCxfOrwW4HkGyK4=
X-Received: by 2002:a05:651c:1548:b0:32a:710f:5a0 with SMTP id
 38308e7fff4ca-32b222c7d03mr10075481fa.11.1749654738677; Wed, 11 Jun 2025
 08:12:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611112902.60071-1-bharathsm@microsoft.com>
In-Reply-To: <20250611112902.60071-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Jun 2025 10:12:07 -0500
X-Gm-Features: AX0GCFtw4ZL5H3ESFLIgEc4QBM2Y_lSXiLUunkjaEMIXSJz4XxyRURpq4BmwYyc
Message-ID: <CAH2r5munktDK1VstQRZ6VcRWyYMasHnR53VM+3i=cz1JYpcpaA@mail.gmail.com>
Subject: Re: [PATCH] smb: improve directory cache reuse for readdir operations
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, sprasad@microsoft.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, paul@darkrain42.org, 
	Bharath SM <bharathsm@microsoft.com>, samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged this updated patch into cifs-2.6.git for-next, running xfstests
on it now.

Looks very promising, and we have a couple more dir lease
optimizations to try out that should also help a lot with perf, and
reducing load on servers by sending fewer metadata ops over the wire

On Wed, Jun 11, 2025 at 6:29=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Currently, cached directory contents were not reused across subsequent
> 'ls' operations because the cache validity check relied on comparing
> the ctx pointer, which changes with each readdir invocation. As a
> result, the cached dir entries was not marked as valid and the cache was
> not utilized for subsequent 'ls' operations.
>
> This change uses the file pointer, which remains consistent across all
> readdir calls for a given directory instance, to associate and validate
> the cache. As a result, cached directory contents can now be
> correctly reused, improving performance for repeated directory listings.
>
> Performance gains with local windows SMB server:
>
> Without the patch and default actimeo=3D1:
>  1000 directory enumeration operations on dir with 10k files took 135.0s
>
> With this patch and actimeo=3D0:
>  1000 directory enumeration operations on dir with 10k files took just 5.=
1s
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cached_dir.h |  8 ++++----
>  fs/smb/client/readdir.c    | 28 +++++++++++++++-------------
>  2 files changed, 19 insertions(+), 17 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 1dfe79d947a6..bc8a812ff95f 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -21,10 +21,10 @@ struct cached_dirent {
>  struct cached_dirents {
>         bool is_valid:1;
>         bool is_failed:1;
> -       struct dir_context *ctx; /*
> -                                 * Only used to make sure we only take e=
ntries
> -                                 * from a single context. Never derefere=
nced.
> -                                 */
> +       struct file *file; /*
> +                           * Used to associate the cache with a single
> +                           * open file instance.
> +                           */
>         struct mutex de_mutex;
>         int pos;                 /* Expected ctx->pos */
>         struct list_head entries;
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index f9f11cbf89be..ba0193cf9033 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -851,9 +851,9 @@ static bool emit_cached_dirents(struct cached_dirents=
 *cde,
>  }
>
>  static void update_cached_dirents_count(struct cached_dirents *cde,
> -                                       struct dir_context *ctx)
> +                                       struct file *file)
>  {
> -       if (cde->ctx !=3D ctx)
> +       if (cde->file !=3D file)
>                 return;
>         if (cde->is_valid || cde->is_failed)
>                 return;
> @@ -862,9 +862,9 @@ static void update_cached_dirents_count(struct cached=
_dirents *cde,
>  }
>
>  static void finished_cached_dirents_count(struct cached_dirents *cde,
> -                                       struct dir_context *ctx)
> +                                       struct dir_context *ctx, struct f=
ile *file)
>  {
> -       if (cde->ctx !=3D ctx)
> +       if (cde->file !=3D file)
>                 return;
>         if (cde->is_valid || cde->is_failed)
>                 return;
> @@ -877,11 +877,12 @@ static void finished_cached_dirents_count(struct ca=
ched_dirents *cde,
>  static void add_cached_dirent(struct cached_dirents *cde,
>                               struct dir_context *ctx,
>                               const char *name, int namelen,
> -                             struct cifs_fattr *fattr)
> +                             struct cifs_fattr *fattr,
> +                                 struct file *file)
>  {
>         struct cached_dirent *de;
>
> -       if (cde->ctx !=3D ctx)
> +       if (cde->file !=3D file)
>                 return;
>         if (cde->is_valid || cde->is_failed)
>                 return;
> @@ -911,7 +912,8 @@ static void add_cached_dirent(struct cached_dirents *=
cde,
>  static bool cifs_dir_emit(struct dir_context *ctx,
>                           const char *name, int namelen,
>                           struct cifs_fattr *fattr,
> -                         struct cached_fid *cfid)
> +                         struct cached_fid *cfid,
> +                         struct file *file)
>  {
>         bool rc;
>         ino_t ino =3D cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
> @@ -923,7 +925,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
>         if (cfid) {
>                 mutex_lock(&cfid->dirents.de_mutex);
>                 add_cached_dirent(&cfid->dirents, ctx, name, namelen,
> -                                 fattr);
> +                                 fattr, file);
>                 mutex_unlock(&cfid->dirents.de_mutex);
>         }
>
> @@ -1023,7 +1025,7 @@ static int cifs_filldir(char *find_entry, struct fi=
le *file,
>         cifs_prime_dcache(file_dentry(file), &name, &fattr);
>
>         return !cifs_dir_emit(ctx, name.name, name.len,
> -                             &fattr, cfid);
> +                             &fattr, cfid, file);
>  }
>
>
> @@ -1074,8 +1076,8 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>          * we need to initialize scanning and storing the
>          * directory content.
>          */
> -       if (ctx->pos =3D=3D 0 && cfid->dirents.ctx =3D=3D NULL) {
> -               cfid->dirents.ctx =3D ctx;
> +       if (ctx->pos =3D=3D 0 && cfid->dirents.file =3D=3D NULL) {
> +               cfid->dirents.file =3D file;
>                 cfid->dirents.pos =3D 2;
>         }
>         /*
> @@ -1143,7 +1145,7 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>         } else {
>                 if (cfid) {
>                         mutex_lock(&cfid->dirents.de_mutex);
> -                       finished_cached_dirents_count(&cfid->dirents, ctx=
);
> +                       finished_cached_dirents_count(&cfid->dirents, ctx=
, file);
>                         mutex_unlock(&cfid->dirents.de_mutex);
>                 }
>                 cifs_dbg(FYI, "Could not find entry\n");
> @@ -1184,7 +1186,7 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>                 ctx->pos++;
>                 if (cfid) {
>                         mutex_lock(&cfid->dirents.de_mutex);
> -                       update_cached_dirents_count(&cfid->dirents, ctx);
> +                       update_cached_dirents_count(&cfid->dirents, file)=
;
>                         mutex_unlock(&cfid->dirents.de_mutex);
>                 }
>
> --
> 2.43.0
>


--=20
Thanks,

Steve
