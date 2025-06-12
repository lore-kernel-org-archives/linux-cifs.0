Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F391F583D
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749721088; cv=none; b=WXDqcTjk2fe00z6UYnp0MVhszBbGUQrAF6oBCuen5d5VRBnapwBN7jFXDhPr4Oq8ZMpRsRoqcxn6/5UKruLqRWegCgISzYGU60xRTLyazNgBUU63ZqZHweHEU7e8KbS6+0D4h2A8h+TIXzVD9hpeF+88Q96ycgxFonPaktO1mX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749721088; c=relaxed/simple;
	bh=AuX91TYGwv+um60FVn+wNqv9Zv7ULp29g5E8xK4cbks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=EtxXGzvyV0+IxQiFgnV+7aguzkCAJfsFl4EZZNZ+qw2wrcgMuDYDBSePzd+NDZvhqeZ/xNzrJbB1BdExGveOKE6mXYKmeHkQ7P/knNxuwu/RO4AbRalwSQJHOCBaAhXVIJSH8LT43zAb0LhOxxX/yZ/OLjm1nRXtPg+E3UEuCrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRtgNQ6p; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRtgNQ6p"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-606ddbda275so1703521a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 02:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749721084; x=1750325884; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Dj6qh6bYjBZJV4kkpPbYalCbqrhHATtVSiJkcdZFfo=;
        b=nRtgNQ6p5h94whJDcTPL/Z5WvdHAESGHPnW1uvBwrHZ08AEVBUo7dFw7KTNxBT7yRf
         p1o5lCwlMDZv8KTsOooRu7Jur/gClFMk4p/W0BOvQtM0g5sK9XLUM+oc7jBZyffEFhKl
         FH659J/dfjaa1DG4KO9Lwy4oD8wiS++ms0N5gTvsLwIPRsQ5+y6VIPTodqv8YgC0XsP1
         S/WnQGiu5uJn1DuFl3kOoXhXMVcH2Daea/yB9wwZ7PiDkUFcPl7s6nT7uJ2QCyJVAdRS
         P9CVMHg1Px+Yv45vSrtL72x/KXPjayBqitcg5U9ZsCo50lVH14HZW11sfgcYoBMFWg84
         DUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749721084; x=1750325884;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Dj6qh6bYjBZJV4kkpPbYalCbqrhHATtVSiJkcdZFfo=;
        b=Czc6SQHtjjD1rMN/7kbdBoerb5UFZqMKgry98Am0sYxuqdgVzWCZUaSHfBA6BAZM+m
         iaH8/qQeioOA/traaZi+rt0nqPdtQIKBcJrgXjPq32ireb0RYiNL2R/J4LQQraR++sxc
         Efu59wHIEeja1m7hJ/iNV4Dhss+n55KlzH6ESpOas2bqsysdjmgekJP3jJj0rXQUGcn5
         K+A2qQ/fdFMUJGAhEiFG68p9MKlE+rXc++c2cWW+w0SoiocGOLZY+YB016QNPPaBJ4w9
         DliishGyoQ6wf72/pRrySmBik8ZL/bJqE6DPDABxTw1PkOhhgdiKDlakoEQ5BuCJqmH0
         /qiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHjExIJil9KKfsgdZah4q7WGc8yHTWnu7VvjI1U1XVAXw7QmEXLwb8GCWlVQv2lJzh3Y6KENQ2Asey@vger.kernel.org
X-Gm-Message-State: AOJu0YzPkyP0aJZHxe0BLZqfXzxhTuwh4AaLvqfpzhq13CWXUOoXp4DC
	hkxE0evus3/vyabK1aWG1A4LFWhascVmsXe2rpn+mjE44zWhW2gXy8DXNUVy4+RagyUwyXZUr9a
	zlTJOgsR57yyRWetqoKaMcwdPGpGaWtg=
X-Gm-Gg: ASbGnctc4P2qWdSr8T+wKQ7lNjb30zNTo5jafaTOgnysXzIBSHp0vzAxjDn/UluKYsx
	GjU0QoqD5HfGgNGYZ2kB1FtS8k3cjQ0pYaNjBvHhTMaOxyGvYZrFJUG+dKupy+JfHrPwmvKdeCC
	2UaAiC1BsgNQILxDpCCjssW9BI50rXP33LtoOY7BAaR4egibuCXndP
X-Google-Smtp-Source: AGHT+IFHlVB8csoPy7yWgkO2wKYNnrO9zm7GGflfOk5wAn60g036YKQYsUTmoBLXA2JOgw/9ZhK/d31iLdadowydqdg=
X-Received: by 2002:a05:6402:26d1:b0:607:1b7a:b989 with SMTP id
 4fb4d7f45d1cf-6086a6de636mr1992790a12.12.1749721084127; Thu, 12 Jun 2025
 02:38:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-4-sprasad@microsoft.com> <aEpIpa3gbbz-nk86@vaarsuvius.home.arpa>
In-Reply-To: <aEpIpa3gbbz-nk86@vaarsuvius.home.arpa>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Jun 2025 15:07:53 +0530
X-Gm-Features: AX0GCFuznEDEc-ge2gvk-FwnfaFwbnOzNOJ08_yHgLZKlQpD3F6B9kuGuc6Mg4Q
Message-ID: <CANT5p=qp_+s4Q42J8TyuAwQmPEpY4g+SYAGsgcBmQkipsLiXrg@mail.gmail.com>
Subject: Re: [PATCH 4/7] cifs: serialize initialization and cleanup of cfid
To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	bharathsm.hsk@gmail.com, meetakshisetiyaoss@gmail.com, pc@manguebit.com, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 8:55=E2=80=AFAM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> On 2025-06-04 15:48:13 +0530, nspmangalore@gmail.com wrote:
> >From: Shyam Prasad N <sprasad@microsoft.com>
> >
> >Today we can have multiple processes calling open_cached_dir
> >and other workers freeing the cached dir all in parallel.
> >Although small sections of this code is locked to protect
> >individual fields, there can be races between these threads
> >which can be hard to debug.
> >
> >This patch serializes all initialization and cleanup of
> >the cfid struct and the associated resources: dentry and
> >the server handle.
> >
> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >---
> > fs/smb/client/cached_dir.c | 16 ++++++++++++++++
> > fs/smb/client/cached_dir.h |  1 +
> > 2 files changed, 17 insertions(+)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index 94538f52dfc8..2746d693d80a 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -198,6 +198,12 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >               return -ENOENT;
> >       }
> >
> >+      /*
> >+       * the following is a critical section. We need to make sure that=
 the
> >+       * callers are serialized per-cfid
> >+       */
> >+      mutex_lock(&cfid->cfid_mutex);
> >+
> >       /*
> >        * check again that the cfid is valid (with mutex held this time)=
.
> >        * Return cached fid if it is valid (has a lease and has a time).
> >@@ -208,11 +214,13 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >       spin_lock(&cfid->fid_lock);
> >       if (cfid->has_lease && cfid->time) {
> >               spin_unlock(&cfid->fid_lock);
> >+              mutex_unlock(&cfid->cfid_mutex);
> >               *ret_cfid =3D cfid;
> >               kfree(utf16_path);
> >               return 0;
> >       } else if (!cfid->has_lease) {
> >               spin_unlock(&cfid->fid_lock);
> >+              mutex_unlock(&cfid->cfid_mutex);
> >               /* drop the ref that we have */
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> >               kfree(utf16_path);
> >@@ -229,6 +237,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >        */
> >       npath =3D path_no_prefix(cifs_sb, path);
> >       if (IS_ERR(npath)) {
> >+              mutex_unlock(&cfid->cfid_mutex);
>
> Double mutex_unlock?  (It's also unlocked unconditionally in the 'out' pa=
th)

Good catch!
Steve: Do you want me to submit a v2? Or submit another patch to fix this?

>
> >               rc =3D PTR_ERR(npath);
> >               goto out;
> >       }
> >@@ -389,6 +398,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >               *ret_cfid =3D cfid;
> >               atomic_inc(&tcon->num_remote_opens);
> >       }
> >+      mutex_unlock(&cfid->cfid_mutex);
> >+
> >       kfree(utf16_path);
> >
> >       if (is_replayable_error(rc) &&
> >@@ -432,6 +443,9 @@ smb2_close_cached_fid(struct kref *ref)
> >                                              refcount);
> >       int rc;
> >
> >+      /* make sure not to race with server open */
> >+      mutex_lock(&cfid->cfid_mutex);
> >+
> >       spin_lock(&cfid->cfids->cfid_list_lock);
> >       if (cfid->on_list) {
> >               list_del(&cfid->entry);
> >@@ -452,6 +466,7 @@ smb2_close_cached_fid(struct kref *ref)
> >               if (rc) /* should we retry on -EBUSY or -EAGAIN? */
> >                       cifs_dbg(VFS, "close cached dir rc %d\n", rc);
> >       }
> >+      mutex_unlock(&cfid->cfid_mutex);
> >
> >       free_cached_dir(cfid);
> > }
> >@@ -666,6 +681,7 @@ static struct cached_fid *init_cached_dir(const char=
 *path)
> >       INIT_LIST_HEAD(&cfid->entry);
> >       INIT_LIST_HEAD(&cfid->dirents.entries);
> >       mutex_init(&cfid->dirents.de_mutex);
> >+      mutex_init(&cfid->cfid_mutex);
> >       spin_lock_init(&cfid->fid_lock);
> >       kref_init(&cfid->refcount);
> >       return cfid;
> >diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> >index 1dfe79d947a6..93c936af2253 100644
> >--- a/fs/smb/client/cached_dir.h
> >+++ b/fs/smb/client/cached_dir.h
> >@@ -42,6 +42,7 @@ struct cached_fid {
> >       struct kref refcount;
> >       struct cifs_fid fid;
> >       spinlock_t fid_lock;
> >+      struct mutex cfid_mutex;
> >       struct cifs_tcon *tcon;
> >       struct dentry *dentry;
> >       struct work_struct put_work;
> >--
> >2.43.0
> >
>
> ~Paul
>


--=20
Regards,
Shyam
