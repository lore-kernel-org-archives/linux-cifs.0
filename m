Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87D117F7
	for <linux-cifs@vger.kernel.org>; Sat,  3 May 2025 02:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746240868; cv=none; b=H695CWReTOc5T0b/xLJ+c4eEDq9ii/QValrhmjGKa6bOS8gZgledug2G2Aog3fZzoF5tBvpU9pshNgf6KarrOa7eBJJtsr23Ob3Z4QdQTBHHqcZXKugiDunf5S1PPP6O6RI4/G60NMHOJwy+5PFR4ZxfSDd6TqGYzl1dQLzO2e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746240868; c=relaxed/simple;
	bh=ZbXOe/pxAA1xRCtJ+RQlJBFGix2Gek7ClZfv5a8QTOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HO8K1qtVRAEPmRegi+tkMr/dnPqeguYlIR2j6FSoQuCua+Dl2qxZTGuMj5uG83PhYNfOVi8iuV7K+lLlBIWAdNCwZ8SPy4kIFoW83x8WE2WiTVGbxnxAAnDtmQbp6ZLTX0HkqfSPr7HNr0UseVmu9ANAvLJJSs5+xEMDQYX5J5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0h+nn7c; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0h+nn7c"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-acec5b99052so458093066b.1
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 19:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746240865; x=1746845665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oo/fIzpTceE+UK1yf41TIT24FWpaZmMfWwq//AEtmu4=;
        b=k0h+nn7ct3CnwKu1CSNCWPBXJLlalaRyCRw/jXBR2GkZTI9JnJQVh8k5pL65dXPKtu
         Qx5gEiVZHtFd4ArLPDJtFoxAg14QrmgQAlCIFtrtuIcdCnkLhLjdHPdLjQ7WWrF1JLGn
         HxfuXeqL+JnJi2OhXacbXef0y7d5VfK1AtP+qkDQpdFed7xTdjgO8clFUNtGVAXKregE
         0Yrx3XPBRav1upERVwPsXMlkx2QSXxaJgYKjstBO78FrohdrZ+ua9VUCJ0sjUsR5xYt9
         n5fMSuyQMICEAkkmsPMQ2dCKFcazh/FbVr94/hnzmv1G1VRwL9caDlVBmHpb1FpEo5o2
         zjUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746240865; x=1746845665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oo/fIzpTceE+UK1yf41TIT24FWpaZmMfWwq//AEtmu4=;
        b=aUjtZcSUy3sXut+sidc6g9AqMk9oQshtZlPmeSknj6WHpDbJeB8sbu5z3gps8pP5Md
         5AQ6fjnM/7lcMUj8BKTT5sGLiELFiWvcg7kteo6gvF/IPPzp4Ugmewgxg+EVjTra9RLi
         F/iE2GmVyJJDnA7qye2OVCl/qWOUp7xtfcYirPva6qgWyYfMhNDKCbtuLWstlQ23bUzY
         Wsx7Mu2q5DJvBVt5SxxcLsS9W3Ma0BbIseEGYNKh6lYS4DL/E+NoPl/eAZVjn8JORXL1
         lB/SJSrCyBaX3ucDAgGmUw5H3eZCW9XjRJpUKsA+3k/hU9pa4uX70KDUOsifCAhv0ciH
         W0hQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNc9q52kG5OJcQIAumYckFih8JxQS9fiESvxuhjy+khqaeIi4VQ7QfQmSF5tQm9jkAi+EgK1KzO7Sq@vger.kernel.org
X-Gm-Message-State: AOJu0YzfP917CiWI8fzqa7dJzIF7lbi7E5xRPeIXsUrn3TVhEXGvcI2W
	UVdVEtTkhvsgLKQZFxtE4siqwIIbhRGUd/lfTAb4vVvPF1dIRMK88Jaiy6N/+PtwkGoa12j5+iu
	3n6ArT/wDZMcWsOSr860wubL7cbw=
X-Gm-Gg: ASbGncsMqX4xcQEA9cVDx2limPkKQfJkU7c3o1+0MdZYn+N4LE8I1ihca10H6cbFZaL
	dnEIrsiba1bsdT3oGLazorDScII4UFpKMOfqBXY15t/gdNTW5VhHCHbx8Afy0XmGUj9+l6LF0/R
	y+XaBwdEDfcD8kUWMtEzw4ELQYl0/DN9vUU1NgSlMMYciTyzwQXcso
X-Google-Smtp-Source: AGHT+IGGvFV+GpLxQJz/XSYwxDrEVFHkinXfaTXoRUh1tGaHsKIocdGewdu9DKP5jFJwnk9pv9ywc+zANzo5wtoNXR4=
X-Received: by 2002:a17:907:2d0e:b0:ace:9d31:d4b5 with SMTP id
 a640c23a62f3a-ad17ad397f8mr528607966b.12.1746240864792; Fri, 02 May 2025
 19:54:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502051517.10449-1-sprasad@microsoft.com> <aBS8jg4bcmh6EdwT@precision>
In-Reply-To: <aBS8jg4bcmh6EdwT@precision>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 3 May 2025 08:24:13 +0530
X-Gm-Features: ATxdqUExDk44AJc4wEYCXuO-biyXazACrBVSLRmFjxfSW-uwjafQjD7ugyTj0iU
Message-ID: <CANT5p=qGspYwczDEnp6oy6F1UQJZKJ9vYw_3pKdipcByqjjuTQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de, 
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 6:09=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Hi Shyam,
>
> On Fri, May 02, 2025 at 05:13:40AM +0000, nspmangalore@gmail.com wrote:
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > There are several accesses to cfid structure today without
> > locking fid_lock. This can lead to race conditions that are
> > hard to debug.
> >
> > With this change, I'm trying to make sure that accesses to cfid
> > struct members happen with fid_lock held.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c | 87 ++++++++++++++++++++++----------------
> >  1 file changed, 50 insertions(+), 37 deletions(-)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index fe738623cf1b..f074675fa6be 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -31,6 +31,7 @@ static struct cached_fid *find_or_create_cached_dir(s=
truct cached_fids *cfids,
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> > +             spin_lock(&cfid->fid_lock);
> >               if (!strcmp(cfid->path, path)) {
> >                       /*
> >                        * If it doesn't have a lease it is either not ye=
t
> > @@ -38,13 +39,16 @@ static struct cached_fid *find_or_create_cached_dir=
(struct cached_fids *cfids,
> >                        * being deleted due to a lease break.
> >                        */
> >                       if (!cfid->time || !cfid->has_lease) {
> > +                             spin_unlock(&cfid->fid_lock);
> >                               spin_unlock(&cfids->cfid_list_lock);
> >                               return NULL;
> >                       }
> >                       kref_get(&cfid->refcount);
> > +                     spin_unlock(&cfid->fid_lock);
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return cfid;
> >               }
> > +             spin_unlock(&cfid->fid_lock);
> >       }
> >       if (lookup_only) {
> >               spin_unlock(&cfids->cfid_list_lock);
> > @@ -192,19 +196,20 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> >               kfree(utf16_path);
> >               return -ENOENT;
> >       }
> > +
> >       /*
> >        * Return cached fid if it is valid (has a lease and has a time).
> >        * Otherwise, it is either a new entry or laundromat worker remov=
ed it
> >        * from @cfids->entries.  Caller will put last reference if the l=
atter.
> >        */
> > -     spin_lock(&cfids->cfid_list_lock);
> > +     spin_lock(&cfid->fid_lock);
> >       if (cfid->has_lease && cfid->time) {
> > -             spin_unlock(&cfids->cfid_list_lock);
> > +             spin_unlock(&cfid->fid_lock);
> >               *ret_cfid =3D cfid;
> >               kfree(utf16_path);
> >               return 0;
> >       }
> > -     spin_unlock(&cfids->cfid_list_lock);
> > +     spin_unlock(&cfid->fid_lock);
> >
> >       /*
> >        * Skip any prefix paths in @path as lookup_positive_unlocked() e=
nds up
> > @@ -219,17 +224,6 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               goto out;
> >       }
> >
> > -     if (!npath[0]) {
> > -             dentry =3D dget(cifs_sb->root);
> > -     } else {
> > -             dentry =3D path_to_dentry(cifs_sb, npath);
> > -             if (IS_ERR(dentry)) {
> > -                     rc =3D -ENOENT;
> > -                     goto out;
> > -             }
> > -     }
> > -     cfid->dentry =3D dentry;
> > -     cfid->tcon =3D tcon;
> >
> >       /*
> >        * We do not hold the lock for the open because in case
> > @@ -301,9 +295,6 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >               }
> >               goto oshr_free;
> >       }
> > -     cfid->is_open =3D true;
> > -
> > -     spin_lock(&cfids->cfid_list_lock);
> >
> >       o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> >       oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
> > @@ -314,7 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >
> >
> >       if (o_rsp->OplockLevel !=3D SMB2_OPLOCK_LEVEL_LEASE) {
> > -             spin_unlock(&cfids->cfid_list_lock);
> >               rc =3D -EINVAL;
> >               goto oshr_free;
> >       }
> > @@ -323,21 +313,15 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> >                                &oparms.fid->epoch,
> >                                oparms.fid->lease_key,
> >                                &oplock, NULL, NULL);
> > -     if (rc) {
> > -             spin_unlock(&cfids->cfid_list_lock);
> > +     if (rc)
> >               goto oshr_free;
> > -     }
> >
> >       rc =3D -EINVAL;
> > -     if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
> > -             spin_unlock(&cfids->cfid_list_lock);
> > +     if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
> >               goto oshr_free;
> > -     }
> >       qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> > -     if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info)) {
> > -             spin_unlock(&cfids->cfid_list_lock);
> > +     if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info))
> >               goto oshr_free;
> > -     }
> >       if (!smb2_validate_and_copy_iov(
> >                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> >                               sizeof(struct smb2_file_all_info),
> > @@ -345,10 +329,26 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> >                               (char *)&cfid->file_all_info))
> >               cfid->file_all_info_is_valid =3D true;
> >
> > -     cfid->time =3D jiffies;
> > -     spin_unlock(&cfids->cfid_list_lock);
> >       /* At this point the directory handle is fully cached */
> >       rc =3D 0;
> > +     spin_lock(&cfid->fid_lock);
> > +     if (!cfid->dentry) {
> > +             if (!npath[0]) {
> > +                     dentry =3D dget(cifs_sb->root);
> > +             } else {
> > +                     dentry =3D path_to_dentry(cifs_sb, npath);
> > +                     if (IS_ERR(dentry)) {
> > +                             spin_unlock(&cfid->fid_lock);
> > +                             rc =3D -ENOENT;
> > +                             goto out;
> > +                     }
> > +             }
> > +             cfid->dentry =3D dentry;
> > +     }
> > +     cfid->tcon =3D tcon;
> > +     cfid->is_open =3D true;
> > +     cfid->time =3D jiffies;
> > +     spin_unlock(&cfid->fid_lock);
> >
> >  oshr_free:
> >       SMB2_open_free(&rqst[0]);
> > @@ -363,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >                       cfid->on_list =3D false;
> >                       cfids->num_entries--;
> >               }
> > +             spin_lock(&cfid->fid_lock);
> >               if (cfid->has_lease) {
> >                       /*
> >                        * We are guaranteed to have two references at th=
is
> > @@ -372,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >                       cfid->has_lease =3D false;
> >                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> >               }
> > +             spin_unlock(&cfid->fid_lock);
> >               spin_unlock(&cfids->cfid_list_lock);
> >
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> > @@ -400,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *t=
con,
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> > +             spin_lock(&cfid->fid_lock);
> >               if (dentry && cfid->dentry =3D=3D dentry) {
> >                       cifs_dbg(FYI, "found a cached file handle by dent=
ry\n");
> >                       kref_get(&cfid->refcount);
> > +                     spin_unlock(&cfid->fid_lock);
> >                       *ret_cfid =3D cfid;
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return 0;
> >               }
> > +             spin_unlock(&cfid->fid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >       return -ENOENT;
> > @@ -427,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
> >       }
> >       spin_unlock(&cfid->cfids->cfid_list_lock);
> >
> > -     dput(cfid->dentry);
> > -     cfid->dentry =3D NULL;
> > +     /* no locking necessary as we're the last user of this cfid */
> > +     if (cfid->dentry) {
> > +             dput(cfid->dentry);
> > +             cfid->dentry =3D NULL;
> > +     }
> >
> >       if (cfid->is_open) {
> >               rc =3D SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid=
,
> > @@ -451,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int x=
id, struct cifs_tcon *tcon,
> >               cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name=
);
> >               return;
> >       }
> > -     spin_lock(&cfid->cfids->cfid_list_lock);
> > +     spin_lock(&cfid->fid_lock);
> >       if (cfid->has_lease) {
> > +             /* mark as invalid */
> >               cfid->has_lease =3D false;
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> >       }
> > -     spin_unlock(&cfid->cfids->cfid_list_lock);
> > +     spin_unlock(&cfid->fid_lock);
> >       close_cached_dir(cfid);
> >  }
> >
> > @@ -538,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *t=
con)
> >               cfids->num_entries--;
> >               cfid->is_open =3D false;
> >               cfid->on_list =3D false;
> > +             spin_lock(&cfid->fid_lock);
> >               if (cfid->has_lease) {
> >                       /*
> >                        * The lease was never cancelled from the server,
> > @@ -546,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *t=
con)
> >                       cfid->has_lease =3D false;
> >               } else
> >                       kref_get(&cfid->refcount);
> > +             spin_unlock(&cfid->fid_lock);
> >       }
> >       /*
> >        * Queue dropping of the dentries once locks have been dropped
> > @@ -600,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, =
__u8 lease_key[16])
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> > +             spin_lock(&cfid->fid_lock);
> >               if (cfid->has_lease &&
> >                   !memcmp(lease_key,
> >                           cfid->fid.lease_key,
> > @@ -612,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, =
__u8 lease_key[16])
> >                        */
> >                       list_del(&cfid->entry);
> >                       cfid->on_list =3D false;
> > +                     spin_unlock(&cfid->fid_lock);
> >                       cfids->num_entries--;
> >
> >                       ++tcon->tc_count;
> > @@ -621,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, =
__u8 lease_key[16])
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return true;
> >               }
> > +             spin_unlock(&cfid->fid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >       return false;
> > @@ -656,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid=
)
> >       WARN_ON(work_pending(&cfid->close_work));
> >       WARN_ON(work_pending(&cfid->put_work));
> >
> > -     dput(cfid->dentry);
> > -     cfid->dentry =3D NULL;
> > -
> >       /*
> >        * Delete all cached dirent names
> >        */
> > @@ -703,6 +714,7 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> > +             spin_lock(&cfid->fid_lock);
> >               if (cfid->time &&
> >                   time_after(jiffies, cfid->time + HZ * dir_cache_timeo=
ut)) {
> >                       cfid->on_list =3D false;
> > @@ -717,6 +729,7 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
> >                       } else
> >                               kref_get(&cfid->refcount);
> >               }
> > +             spin_unlock(&cfid->fid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >
> > @@ -726,7 +739,6 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
> >               spin_lock(&cfid->fid_lock);
> >               dentry =3D cfid->dentry;
> >               cfid->dentry =3D NULL;
> > -             spin_unlock(&cfid->fid_lock);
> >
> >               dput(dentry);
> >               if (cfid->is_open) {
> > @@ -742,6 +754,7 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
> >                        * was one) or the extra one acquired.
> >                        */
> >                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> > +             spin_unlock(&cfid->fid_lock);
> >       }
> >       queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
> >                          dir_cache_timeout * HZ);
>
> You are calling dput() here with a lock held, both in path_to_dentry and
> in smb2_close_cached_fid. Is this correct?

Hi Henrique,
Thanks for reviewing the patches.

Do you see any obvious problem with it?
dput would call into VFS layer and might end up calling
cifs_free_inode. But that does not take any of the competing locks.

>
> Also, the lock ordering here is lock(fid_lock) -> lock(cifs_tcp_ses_lock)=
 ->
> unlock(cifs_tcp_ses_lock) -> unlock(fid_lock), won't this blow up in
> another path?

Can you please elaborate which code path will result in this lock ordering?

>
> Thanks,
> Henrique



--=20
Regards,
Shyam
