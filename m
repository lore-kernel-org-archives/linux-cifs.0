Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D87313559
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296169; cv=none; b=FvWsPzF9zN0caQYDHQnAqwv1c8q1+BEFOYUQy1HEzbmY/6cnD3kmHKnmbahfnL5WgbjxrebKEJQW6+xUnC8YZaRU/8wPUZS0Hr54BQoD3HQsucnjm3EGvUzHz9/iQk5iLg4VXdzBKjR3P7t9/9jop+VAubEXn7pV0aKR5xGXLCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296169; c=relaxed/simple;
	bh=9dQsC0JShGXwYim8Hfxkbjs0R7W6HpyZooan10EWO7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i9xaFpNStJdVPuknqx84Rswqk845CM1/rip3XcT4iC24/jH7Hq9dfjMO1Qbh/minWQ6buHHyneSfH9F1jmOVzTvTrZkpn5+bRhX/Ush1N6/CwPHutffxVRwFUZfxjddm9QFeS/WtJkH528aBmYVf2qpLVDvthx7+rE/xNuG8S3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NP7bXSFr; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NP7bXSFr"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4e89c433c00so69696021cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 14:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762296166; x=1762900966; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KL33Ke9tFP2I1LCAUEYtJ25zdws1kwg0zjw6YyOey6Q=;
        b=NP7bXSFrHYu0j2OV7OwDfddM6hFAkGCNgmlpO9TZF4TrFWv7u1UucBGrL0PEj3iXw6
         MyngVfc8TGKJ+7RGh0drikb2MQAx1DQEreqTQNRe26D43bINWrXbINL2pSTqJ1prCl5n
         t3UmOPf1FPazwLb3GfCjenkwhfFedMR0qBfqXDFgq3028iiBHObGxS39jgYMcY7zunlr
         uy1fGzhjJGOgkGBF6ViuaHNUCLYx4lQ1CW7lAhAMd6+cEFskhA0MPg5hLa1GLNMasUhl
         GenLwMIz2VWaONIQULvlhHeFlpwlOxGQ/RU28NfzvAbvFKOPSzWnRnvKGLw2+2lu38Vc
         GAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296166; x=1762900966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KL33Ke9tFP2I1LCAUEYtJ25zdws1kwg0zjw6YyOey6Q=;
        b=c5NnUI5LO+UBkKL2HzuIS6FvKDsJEyULNkrbGhVs2VhhyUIFb6N4815Ixkx1Gxgd6c
         Hzf2WnHu9Mr2rsamhvs/abn84nNlHXCUykykvi9H5jxTZ3IEEGZGK5k2GlAlE7Wa1aym
         bH3Irp802Fr/gZKsz0emFcSXYdLqDovAS4HWMIT82B3ITsq7DVTBHXhz7gFZyFoxv3c/
         vxumdoW43x5iAjmID1/S7UB+60FU0pmoa3yWfFnbudqCLj1no5nn1kmI6c8dIUM1gcnI
         PZIxZTKRSFtMLY+5xy+KRlB8+IRbjM2E3KEbckPYRCw5iwDMeeoAsnC7ryzM3m6KUrf+
         fYog==
X-Forwarded-Encrypted: i=1; AJvYcCXOYd6MsSP9bRtUdDofRwbQn9UyDV+4gm30CtezTEHJh4gg8GrVX0JjegIj4usjXQuRPXCc1ftDX5QB@vger.kernel.org
X-Gm-Message-State: AOJu0YxM52za8aIrHJ5YLiHZKe2y+n/201CR1N+BdGnldKs/30VE6ihF
	8YDFzrUZnh3m8LtN5cVt9NmAxy5e0tGTMu0lwVmWbop818gZuIFkkGDOhZ3dOwQ6ZfHkKIfLXPI
	mlSC8Fpt7XF6pEgs//U3QvsVOsVSAdDw=
X-Gm-Gg: ASbGncu2Af5oOoVG2bh2kpVBfYuuV9lUdTlrgNif40guckhsiXsB5+/XToTqH26/4XL
	HXwHtty7h1IAG7t7hBoJqzmefjI+3OWZRu24ZYJiBb7KF7eSohgjY5eZTffXz5xyIOZKlL9WHpW
	1JmwBQ2xwBu97433qaSFJtdHGfIt+4Fez8Kd1AC1Q3vpX7NSKeDI0VDxfYsENcfrByXwlKwr5fv
	9Yes3ljtwd9BPXDg6R276xcylGP/OfVrupcebMhML+rwovXvG2wBFQYmo3kQjWZ0Mra7Ld5nQnk
	aJlnpC82eB/yOBAB5YXY5VMe89/5QHecWUzxxgx2p29oTKUZKB/tSOY0FioEIYoCUI+MpjUuyUP
	3Uha+8skfsvM/8s0AiCkC5wiblOs+UZiPdPEPH9MOh/S53ZJmmbmd3x9Iw5ZYPxCxdMwlralfMQ
	==
X-Google-Smtp-Source: AGHT+IHffcEY68xATYqqcUAOScISrN2sJNXPuakJ87Mv9zblNkUZ/iObay9Zn8bzLvusyy9PeH7srxP+Xfh1L0PHQRM=
X-Received: by 2002:a05:622a:2d5:b0:4ec:ee36:c04c with SMTP id
 d75a77b69052e-4ed7233250bmr16341231cf.4.1762296166216; Tue, 04 Nov 2025
 14:42:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103225255.908859-1-henrique.carvalho@suse.com>
In-Reply-To: <20251103225255.908859-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 4 Nov 2025 16:42:34 -0600
X-Gm-Features: AWmQ_bkKUalV4aGnczjiW1cQty-uYbzL6kWFm6i0yieL2_M7GE_7LOJ3tD3Inuc
Message-ID: <CAH2r5mtSmg-FwgPzEyPF2CFfP1zuc-Qh5CVuBjbEkA8eTA2Mtg@mail.gmail.com>
Subject: Re: [PATCH v4] smb: client: fix potential UAF in smb2_close_cached_fid()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	jaeshin@redhat.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One minor comment that AI had on this was on the change to
fs/smb/client/cached_dir.c (line 447). See below.

    -spin_lock(&cfid->cfids->cfid_list_lock);
    +lockdep_assert_held(&cfid->cfids->cfid_list_lock);


The lockdep_assert_held validates that the lock is held on entry, but
the function signature __releases(&cfid->cfids->cfid_list_lock)
indicates the lock is released inside. Consider adding a corresponding
__acquires annotation to the call sites that call this function via
kref_put_lock, or document why callers must hold the lock before
calling kref_put_lock.

On Mon, Nov 3, 2025 at 5:00=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> find_or_create_cached_dir() could grab a new reference after kref_put()
> had seen the refcount drop to zero but before cfid_list_lock is acquired
> in smb2_close_cached_fid(), leading to use-after-free.
>
> Switch to kref_put_lock() so cfid_release() is called with
> cfid_list_lock held, closing that gap.
>
> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lea=
se is held")
> Cc: stable@vger.kernel.org
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V3 -> V4: rebase, added Reviewed-by and Reported-by, add
> lockdep_assert_held in smb2_close_cached_fid, change commit subject (was
> "smb: client: fix race in smb2_close_cached_fid()") to clearly state the
> bug class (UAF)
> V2 -> V3: rebase, remove unneeded comments, modify commit subject
> V1 -> V2: kept the original function names and added __releases annotatio=
n
> to silence sparse warning
> ---
>  fs/smb/client/cached_dir.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index b8ac7b7faf61..018055fd2cdb 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -388,11 +388,11 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
>                          * lease. Release one here, and the second below.
>                          */
>                         cfid->has_lease =3D false;
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       close_cached_dir(cfid);
>                 }
>                 spin_unlock(&cfids->cfid_list_lock);
>
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               close_cached_dir(cfid);
>         } else {
>                 *ret_cfid =3D cfid;
>                 atomic_inc(&tcon->num_remote_opens);
> @@ -438,12 +438,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tco=
n,
>
>  static void
>  smb2_close_cached_fid(struct kref *ref)
> +__releases(&cfid->cfids->cfid_list_lock)
>  {
>         struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
>                                                refcount);
>         int rc;
>
> -       spin_lock(&cfid->cfids->cfid_list_lock);
> +       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> +
>         if (cfid->on_list) {
>                 list_del(&cfid->entry);
>                 cfid->on_list =3D false;
> @@ -478,7 +480,7 @@ void drop_cached_dir_by_name(const unsigned int xid, =
struct cifs_tcon *tcon,
>         spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->has_lease) {
>                 cfid->has_lease =3D false;
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               close_cached_dir(cfid);
>         }
>         spin_unlock(&cfid->cfids->cfid_list_lock);
>         close_cached_dir(cfid);
> @@ -487,7 +489,7 @@ void drop_cached_dir_by_name(const unsigned int xid, =
struct cifs_tcon *tcon,
>
>  void close_cached_dir(struct cached_fid *cfid)
>  {
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfid=
s->cfid_list_lock);
>  }
>
>  /*
> @@ -596,7 +598,7 @@ cached_dir_offload_close(struct work_struct *work)
>
>         WARN_ON(cfid->on_list);
>
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       close_cached_dir(cfid);
>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>  }
>
> @@ -762,7 +764,7 @@ static void cfids_laundromat_worker(struct work_struc=
t *work)
>                          * Drop the ref-count from above, either the leas=
e-ref (if there
>                          * was one) or the extra one acquired.
>                          */
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       close_cached_dir(cfid);
>         }
>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>                            dir_cache_timeout * HZ);
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
