Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4B71EF368
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746212888; cv=none; b=rjce/6hIrELObHL4bzmB5y9vhnZ42k/YmXiPOoj0/n+rycPLHj+OR2GvDyPv4wrbOchOXmJF/UodcK9PuPdmne4UGsmR3JO1s33hyHgtNh12JU3QHGI8Vtj2zX+iqx8AXFmVaFdQIgHMHy02J+OR+wLgltqofpU27+FumkrsAqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746212888; c=relaxed/simple;
	bh=0F1ciZ3uGa6cO94XxKH7BD4hNG95nKmsiP84h+YZIiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KUxh5gcfQQnPImM3/k9bASbB1z5T45fFd3Tde3CzqZx3D1Rup3HCER1q/jgDAGSBIm9iGO/BysOWQggoQWTpXqH/S+uWohflgRo8XSMiaRQrOcUHuxlzjhVIpWUuOqcU1K+aEAxhMoOMbNSLSDOaxjYqYDX3mSRXd7/4pW6f/zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BZpW6kTq; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZpW6kTq"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-30db1bd3bebso21818811fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 12:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746212884; x=1746817684; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUAfwJW8oNDqFOHUuBRheYfE+Pn8JfAEbuCZMCO4exM=;
        b=BZpW6kTq/TOctHaHLfs2YuqyjGWb490XrrvNpJEPCvKtUnVm5tShtcGLSyfL/jXvMm
         Uz3fYDOtHuLqiuQsHfNbmlvA1O6VbFtQ8BP/7Tg5CUCBauW7Fsaf3bVmhwwGaulVWRTN
         5osJrLNlCEGSSw75o1E5QQRXtvSktilZJSI2ITJKcakscLC3M/ApZzPQEpsZVMjAoAQn
         ugVzKp3AmaAfG2REnAzKob9dadHULJ7o8Pysl9vgptRiIptU3cRXYylj9ibuU+4Pm7UD
         F/r0pcwbmS8zTbZVImPJiL7cmERgdDW9bj0NYNeC09jBeYmekgYiu/F6m0nU/Sd16xR6
         qy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746212884; x=1746817684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUAfwJW8oNDqFOHUuBRheYfE+Pn8JfAEbuCZMCO4exM=;
        b=A/u0dhmUId43NIpc6u3gT20JRj8Ab7qm4Wm/U4s0qT58YUDjofB3qMiBy+FGjZjGUP
         2RZ2t2QSG2Y31NUcchFTaCeBGutJ+2cV/gxUSR94wG/MumG4TvrW5xhqskno1HzHzD2B
         P9ADc1sVY6+3Yz/3GyMPzwG9CQpXdan1jifcFhkdadwRyoYX9h7lsr0BU2BAWQUPF2tR
         l67a5Clrq5DhxLbCTH3wV2TlK8CFIUGY0iaR2csQig7Mhrq6XNSCYoilPYEmCm6848p0
         eDxhx1tfM6tzhN+I+187rxgHNqRJLzCaIrEU+lgiKbZKH7zwzMI9Ln0ZUa41NVtSKN53
         1Cuw==
X-Forwarded-Encrypted: i=1; AJvYcCXrDJQezu/Zmj3QuXcrNO0lbZRmdN5/dHnz29mB78hnKjgwtH1vHdS/CDGT01CNzHiEbx+uA9pXU4I6@vger.kernel.org
X-Gm-Message-State: AOJu0YzWrrUGdJs3mlT6a4GQQKxqPJj2Ak/IORj8TAVgSg5455WdcTYQ
	H0TguIj7Tgwa2anzwWKAGPyP0xS+2Nut+fkprV3fnJ5Is2Wa6nZbfrTc8JYK59aG4gPqT2iW4q8
	m/pzf3i5zRxaplWAymchW8qmu7Jo=
X-Gm-Gg: ASbGnctUS6CgdheQKNEX4tu0OnvNoB4scaToMfC1dPx8h0IikMyA7vykOPuJa+vFboW
	wb3r7QE4OUv07COaOoH6DnOxnJ1Sa3JSWeWxc4IFnvDbk9t5GYkVVK0pazh2NzzVpXdHzdQ3KjY
	RDqrpT0zBw+LRxnEN+I66FLzo0ghATRMn1e1kmXV3i3fKMxlLYS8Wa+Ok4
X-Google-Smtp-Source: AGHT+IGpaoIacJ9/3B+S3G2sMgnB9UZLbVXKdL18caBAy7Ti0DM+oQxnVPsi2j1FTXQ35UPCvk/M3engujCzhSMj6sg=
X-Received: by 2002:a05:651c:212a:b0:31f:8c3c:6034 with SMTP id
 38308e7fff4ca-320c57f62a6mr13799111fa.29.1746212883935; Fri, 02 May 2025
 12:08:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502180136.192407-1-henrique.carvalho@suse.com>
In-Reply-To: <20250502180136.192407-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 2 May 2025 14:07:52 -0500
X-Gm-Features: ATxdqUFpFcfA55n-kj2Y3ydOW6e9obQOoUX_nCx25KZg6A0olIH_8FEsOiGQ_IU
Message-ID: <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
Subject: Re: [PATCH] smb: cached_dir.c: fix race in cfid release
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, paul@darkrain42.org, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I fixed a minor checkpatch warning but also noticed this compile
warning - is there a missing lock call?

cached_dir.c:429:20: warning: context imbalance in 'cfid_release' -
unexpected unlock

On Fri, May 2, 2025 at 1:04=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> find_or_create_cached_dir() could grab a new reference after kref_put()
> had seen the refcount drop to zero but before cfid_list_lock is acquired
> in smb2_close_cached_fid(), leading to use-after-free.
>
> Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
> held, closing that gap.
>
> While we are at it:
> * rename the functions smb2_close_cached_fid() and close_cached_dir()
>   for clarity;
> * replace the calls to kref_put() for cfid_put().
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cached_dir.c | 28 ++++++++++++++++------------
>  fs/smb/client/cached_dir.h |  2 +-
>  fs/smb/client/inode.c      |  4 ++--
>  fs/smb/client/readdir.c    |  4 ++--
>  fs/smb/client/smb2inode.c  |  2 +-
>  fs/smb/client/smb2ops.c    |  8 ++++----
>  6 files changed, 26 insertions(+), 22 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index fe738623cf1b..ff4f9f8150cf 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -14,7 +14,7 @@
>
>  static struct cached_fid *init_cached_dir(const char *path);
>  static void free_cached_dir(struct cached_fid *cfid);
> -static void smb2_close_cached_fid(struct kref *ref);
> +static void cfid_release(struct kref *ref);
>  static void cfids_laundromat_worker(struct work_struct *work);
>
>  struct cached_dir_dentry {
> @@ -370,11 +370,13 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
>                          * lease. Release one here, and the second below.
>                          */
>                         cfid->has_lease =3D false;
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +
> +                       /* If this cfid_put calls back cfid_release the c=
ode is wrong anyway. */
> +                       cfid_put(cfid);
>                 }
>                 spin_unlock(&cfids->cfid_list_lock);
>
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               cfid_put(cfid);
>         } else {
>                 *ret_cfid =3D cfid;
>                 atomic_inc(&tcon->num_remote_opens);
> @@ -413,13 +415,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tco=
n,
>  }
>
>  static void
> -smb2_close_cached_fid(struct kref *ref)
> +cfid_release(struct kref *ref)
>  {
>         struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
>                                                refcount);
>         int rc;
>
> -       spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->on_list) {
>                 list_del(&cfid->entry);
>                 cfid->on_list =3D false;
> @@ -454,16 +455,19 @@ void drop_cached_dir_by_name(const unsigned int xid=
, struct cifs_tcon *tcon,
>         spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->has_lease) {
>                 cfid->has_lease =3D false;
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +
> +               /* If this cfid_put calls back cfid_release the code is w=
rong anyway. */
> +               cfid_put(cfid);
>         }
>         spin_unlock(&cfid->cfids->cfid_list_lock);
> -       close_cached_dir(cfid);
> +       cfid_put(cfid);
>  }
>
>
> -void close_cached_dir(struct cached_fid *cfid)
> +void cfid_put(struct cached_fid *cfid)
>  {
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       struct cached_fids *cfids =3D cfid->tcon->cfids;
> +       kref_put_lock(&cfid->refcount, cfid_release, &cfids->cfid_list_lo=
ck);
>  }
>
>  /*
> @@ -564,7 +568,7 @@ cached_dir_offload_close(struct work_struct *work)
>
>         WARN_ON(cfid->on_list);
>
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       cfid_put(cfid);
>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>  }
>
> @@ -688,7 +692,7 @@ static void cfids_invalidation_worker(struct work_str=
uct *work)
>         list_for_each_entry_safe(cfid, q, &entry, entry) {
>                 list_del(&cfid->entry);
>                 /* Drop the ref-count acquired in invalidate_all_cached_d=
irs */
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               cfid_put(cfid);
>         }
>  }
>
> @@ -741,7 +745,7 @@ static void cfids_laundromat_worker(struct work_struc=
t *work)
>                          * Drop the ref-count from above, either the leas=
e-ref (if there
>                          * was one) or the extra one acquired.
>                          */
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       cfid_put(cfid);
>         }
>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>                            dir_cache_timeout * HZ);
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 1dfe79d947a6..f4fc7818dda5 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -73,7 +73,7 @@ extern int open_cached_dir(unsigned int xid, struct cif=
s_tcon *tcon,
>  extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>                                      struct dentry *dentry,
>                                      struct cached_fid **cfid);
> -extern void close_cached_dir(struct cached_fid *cfid);
> +extern void cfid_put(struct cached_fid *cfid);
>  extern void drop_cached_dir_by_name(const unsigned int xid,
>                                     struct cifs_tcon *tcon,
>                                     const char *name,
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 75be4b46bc6f..c3ef1f93a80d 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2610,10 +2610,10 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>
>         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
>                 if (cfid->time && cifs_i->time > cfid->time) {
> -                       close_cached_dir(cfid);
> +                       cfid_put(cfid);
>                         return false;
>                 }
> -               close_cached_dir(cfid);
> +               cfid_put(cfid);
>         }
>         /*
>          * depending on inode type, check if attribute caching disabled f=
or
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index 50f96259d9ad..1e1768152803 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -1093,7 +1093,7 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>          * find_cifs_entry in case there will be reconnects during
>          * query_directory.
>          */
> -       close_cached_dir(cfid);
> +       cfid_put(cfid);
>         cfid =3D NULL;
>
>   cache_not_found:
> @@ -1199,7 +1199,7 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>
>  rddir2_exit:
>         if (cfid)
> -               close_cached_dir(cfid);
> +               cfid_put(cfid);
>         free_dentry_path(page);
>         free_xid(xid);
>         return rc;
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 57d9bfbadd97..f805d71a8d19 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -975,7 +975,7 @@ int smb2_query_path_info(const unsigned int xid,
>                                                      cfid->fid.volatile_f=
id,
>                                                      &data->fi);
>                         }
> -                       close_cached_dir(cfid);
> +                       cfid_put(cfid);
>                         return rc;
>                 }
>                 cmds[num_cmds++] =3D SMB2_OP_QUERY_INFO;
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 2fe8eeb98535..97c4d44c9a69 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -889,7 +889,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tco=
n *tcon,
>         if (cfid =3D=3D NULL)
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
>         else
> -               close_cached_dir(cfid);
> +               cfid_put(cfid);
>  }
>
>  static void
> @@ -940,10 +940,10 @@ smb2_is_path_accessible(const unsigned int xid, str=
uct cifs_tcon *tcon,
>         rc =3D open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid=
);
>         if (!rc) {
>                 if (cfid->has_lease) {
> -                       close_cached_dir(cfid);
> +                       cfid_put(cfid);
>                         return 0;
>                 }
> -               close_cached_dir(cfid);
> +               cfid_put(cfid);
>         }
>
>         utf16_path =3D cifs_convert_path_to_utf16(full_path, cifs_sb);
> @@ -2804,7 +2804,7 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>         free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
>         if (cfid)
> -               close_cached_dir(cfid);
> +               cfid_put(cfid);
>         kfree(vars);
>  out_free_path:
>         kfree(utf16_path);
> --
> 2.47.0
>
>


--=20
Thanks,

Steve
