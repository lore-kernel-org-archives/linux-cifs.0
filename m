Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE56377EC2
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 09:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777626025; cv=pass; b=MLDKYc1yscs4/ilO6GJQ3A+/+HYeBSq5hjEHr29ZQ44ffaTlmfyqSEgT1O6as+IUC4FJSEkn/e17GPStyEktBEggq/yYktDdvpLNT50B0cKWXjaQpeT8cGb6Cupfr+XOE40HpQF+8OSSwj121GX9hDADNJbO3nsM5EwJQOS0QYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777626025; c=relaxed/simple;
	bh=rMNKaelWNJ8TacIzkrZFc0W8S9f8+e3TIJL1mwoKk7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cnd4im1KkxthHaydbgXaHcEkIXUqKjQaIOjQM2zhR+yDXsLvqXTXf+XzZjStrPS9F7Uf6hMAE2DR6Zrnn3BGgZy3Mtpr9JN0aCcKeDX9RsbXWAc2GQm4s1LY7TGnp7Qc8MXYk27kRySCRLBqxXrAjYpGpsMWOZ9npQkQwQnRiPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IGgDNO1A; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IGgDNO1A"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b9c3a9fe80fso256082866b.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 02:00:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777626021; cv=none;
        d=google.com; s=arc-20240605;
        b=cAHDL1YCImHKAwfsBaN7Gkkyb8evtkDoY72S5D7BD0Nj+Ky8YwWwBfP95d0bJtg9Qv
         yHMXYA1k3V/YLkhzNR1YtgnKN/hjRAuilNUSsHIk6317Sri2l0nmx9pITsPxOcs42PJ9
         T1JIJpZfe+Icmftlry7us5vzhG0qfarNLxX2/Y47Fm/g3ukzcsp/c7zWVhrNAswKyfOQ
         4OtFYEhuyMy+h18Zi9CZc2xTHARZhC5HCj485GjNFDE/WjqEFe9nMVq2wfHYKny38/u9
         adNEprtq0WHc+r5cWbBe5OHNRcfM7agHd31QRXKHm8wYvWm1ZhjWHf07wR5zFwKWpSaT
         7obw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2DNZL79JSBv3IL0MAKYq+jXCJbajoFW7/zvPIXUOZm4=;
        fh=ho/xw+X5kW/RwmS4pn7eFEzvztqHjolLg2Vc4Mhddfs=;
        b=ktOsSTLSfylxtPMNxQej+RUzbhCKUIUvLGLg7LRy7vYXIJ27Dasjpzr/feDxitVI/S
         jQF6ZpnRK7KOeNfzgEnA65qdV1DvTzVR2nfjwx+7fXbW5CDOE6WJMd73Eo0jxst31h55
         W9GBgWVdhNKERuMNzfuMNv7i9/PGCjf6fVSTl3z38vjz5t2QQiBAQu5kSxTm/5IPfrsZ
         GKhjA/yoq+P++Jluh3e7kDeOhHp4oAEstWVVwDmkxy6+cssNDztusjZB3HeDrKY4MJji
         s9wiuAhqrZL1PaF3hiK1Qx8PzdAhRqV8PUAWdC4pBW1fSy2cFKabMnSETb0ahjtm79lU
         SNSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777626021; x=1778230821; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DNZL79JSBv3IL0MAKYq+jXCJbajoFW7/zvPIXUOZm4=;
        b=IGgDNO1A8ftgxfowpPJ69+8kjNh3Aa5/vBE3lE+2JlQ2o60L2ocJLBkq1gdXp1LbnY
         ent5fqGWcyY0sq02OXiumWPb5Fg+syJF5ndKXBokqUAbnmu+15/mocbTtGnItIVq1j41
         SGRzx2t/S2YIKldX6BWtxIsXXCO2KaLPWFn8xJAl/qjR9vX3fuGXjf+beXo7BIH6FOOZ
         kcvWmMivpPOqipUkgqDBoLcOCsAnLCN12mZAlS7lrXhrOpQ22ID9A4uGivMImE6SZYB/
         Nsrti1RFU19Wz3of+iHYiO0TnXzKjX1D/Fj6S7CCt1yEcPxi9ygzw7zQa1SHUKw7DKJu
         XOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777626021; x=1778230821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2DNZL79JSBv3IL0MAKYq+jXCJbajoFW7/zvPIXUOZm4=;
        b=qOrrDxDQV+DHNDZ1Y+dQul2ne+bOnWxj0P9FHgTxUCiHnZqOmVu7YgXta8A3YWlGAr
         3DROK3mRPkPFX++bul9RG0ooD1myah8cmvKs6oO11HBsE+ldXbCsjwicfvkMalAlvm9E
         Sa2MSsm2FVR9wWZmXEL9wgZQxnFmg9J90QJfmB1wKOblh04YapK65I4DccFB6n4AxAOF
         4wfhvtGy72LiTukEofzx21k+zfQvtTIsUirHH5RzEX/j47YG0n0qbZC7flgsqsS6gk8v
         UUN57ImdQF+yn4zjOaWfJSXeBKfdxdiwaE7ndEOaIjgRr8M239jUAZE7p4zTU7qHs8pp
         jr8A==
X-Gm-Message-State: AOJu0YwjFjLtRclyts0FtuKNHmebHRSUkX8KV6+tLA4csE3ftNcPVDvv
	S+Tv0eiRyEl19MK7Xbw4CWwUHohSg6d2yy2/2Rg9WfnCPA3DmPeC7Ozh4BlOCWapPiZRmBmnBXo
	UPXwZW2oXdzzFrq1t2uVSTQt3AUyo9UI=
X-Gm-Gg: AeBDievvdrMGhE9JbQ9oUgC4OCnvJCq9gcz/2hwmN5re9c62WX4WVi1siHBy1H0Mtc0
	s4edm0uNADQIyFg5WLOvoDTWxSh8pTJIAQPhN8yrrtIr7fQM99gMiY7wzDY1bPAu5ef6wyYcgyk
	JaYYyUQuHfDDCBJlyIn7r5r/so4dpYqak326zrmRb+EmO1zQEVoMi78iBJbDFSvLEWKzZLVbpp+
	woiQgk09urujg2ZxhtGSLLYmmLNKEnFMZyqBlHS1EjgBbUgf+TlnosOMXCjcJZ0gJRoJKOjPpgx
	gnhD8jVVdnRvvmJb
X-Received: by 2002:a17:907:26c9:b0:bae:d29c:4e28 with SMTP id
 a640c23a62f3a-bbac4cd2331mr403876166b.12.1777626020162; Fri, 01 May 2026
 02:00:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428160804.281745-1-sprasad@microsoft.com>
 <20260428160804.281745-3-sprasad@microsoft.com> <d43b1d1023d13746819a780f65da9341@manguebit.org>
In-Reply-To: <d43b1d1023d13746819a780f65da9341@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 1 May 2026 14:30:08 +0530
X-Gm-Features: AVHnY4IOoNnpCXPfdkS6WxhMvsIxS21lj0SdS3Rdi0XAOv0tNaGt6C4zzPChomg
Message-ID: <CANT5p=rMDk9nGPVeU8hKV6SUNWOo_kkL1uoRiOd845AEowgYyA@mail.gmail.com>
Subject: Re: [PATCH v3 03/19] cifs: invalidate cfid on unlink/rename/rmdir
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 10:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> nspmangalore@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today we do not invalidate the cached_dirent or the entire
> > parent cfid when a dentry in a dir has been removed/moved.
> >
> > This change invalidates the parent cfid so that we don't serve
> > directory contents from the cache.
> >
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/inode.c | 40 ++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 38 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index 888f9e35f14b8..e077df844c819 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -28,6 +28,23 @@
> >  #include "cached_dir.h"
> >  #include "reparse.h"
> >
> > +static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
> > +                                    struct dentry *parent)
> > +{
> > +     struct cached_fid *parent_cfid =3D NULL;
> > +
> > +     if (!tcon || !parent)
> > +             return;
>
> The NULL check for @tcon is unnecessary.  This seems to be called only
> with a valid @tcon.
>
Hi Paulo,
Thanks for the review.
I would let the null check be. For future callers who may miss the check.
> > +
> > +     if (!open_cached_dir_by_dentry(tcon, parent, &parent_cfid)) {
> > +             mutex_lock(&parent_cfid->dirents.de_mutex);
> > +             parent_cfid->dirents.is_valid =3D false;
> > +             parent_cfid->dirents.is_failed =3D true;
> > +             mutex_unlock(&parent_cfid->dirents.de_mutex);
> > +             close_cached_dir(parent_cfid);
> > +     }
> > +}
> > +
> >  /*
> >   * Set parameters for the netfs library
> >   */
> > @@ -322,7 +339,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, =
FILE_UNIX_BASIC_INFO *info,
> >                               fattr->cf_uid =3D uid;
> >               }
> >       }
> > -
> > +
>
> Why are you adding a blank newline?
Looks like an empty line with a tab was removed. Will add back the tab.
>
> >       fattr->cf_gid =3D cifs_sb->ctx->linux_gid;
> >       if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
> >               u64 id =3D le64_to_cpu(info->Gid);
> > @@ -2067,6 +2084,9 @@ static int __cifs_unlink(struct inode *dir, struc=
t dentry *dentry, bool sillyren
> >               cifs_set_file_info(inode, attrs, xid, full_path, origattr=
);
> >
> >  out_reval:
> > +     if (!rc && dentry->d_parent)
> > +             cifs_invalidate_cached_dir(tcon, dentry->d_parent);
>
> The non-NULL check of @dentry->d_parent is unnecessary.
> cifs_invalidate_cached_dir() already handles it.
Will do this change.
>
> > +
> >       if (inode) {
> >               cifs_inode =3D CIFS_I(inode);
> >               cifs_inode->time =3D 0;   /* will force revalidate to get=
 info
> > @@ -2378,7 +2398,6 @@ int cifs_rmdir(struct inode *inode, struct dentry=
 *direntry)
> >       }
> >
> >       rc =3D server->ops->rmdir(xid, tcon, full_path, cifs_sb);
> > -     cifs_put_tlink(tlink);
> >
> >       cifsInode =3D CIFS_I(d_inode(direntry));
> >
> > @@ -2388,6 +2407,8 @@ int cifs_rmdir(struct inode *inode, struct dentry=
 *direntry)
> >               i_size_write(d_inode(direntry), 0);
> >               clear_nlink(d_inode(direntry));
> >               spin_unlock(&d_inode(direntry)->i_lock);
> > +             if (direntry->d_parent)
> > +                     cifs_invalidate_cached_dir(tcon, direntry->d_pare=
nt);
>
> Ditto.
>
> >       }
> >
> >       /* force revalidate to go get info when needed */
> > @@ -2402,6 +2423,7 @@ int cifs_rmdir(struct inode *inode, struct dentry=
 *direntry)
> >
> >       inode_set_ctime_current(d_inode(direntry));
> >       inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> > +     cifs_put_tlink(tlink);
> >
> >  rmdir_exit:
> >       free_dentry_path(page);
> > @@ -2501,6 +2523,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inod=
e *source_dir,
> >       struct cifs_sb_info *cifs_sb;
> >       struct tcon_link *tlink;
> >       struct cifs_tcon *tcon;
> > +     struct dentry *source_parent;
> > +     struct dentry *target_parent;
> >       bool rehash =3D false;
> >       unsigned int xid;
> >       int rc, tmprc;
> > @@ -2532,6 +2556,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inod=
e *source_dir,
> >       if (IS_ERR(tlink))
> >               return PTR_ERR(tlink);
> >       tcon =3D tlink_tcon(tlink);
> > +     source_parent =3D source_dentry->d_parent ? dget(source_dentry->d=
_parent) : NULL;
> > +     target_parent =3D target_dentry->d_parent ? dget(target_dentry->d=
_parent) : NULL;
>
> Why do you need to dget() ->d_parent?
Good point. Considering this is a rename callback, I think this dget
on parent is redundant. Will fix it.
>
> >       server =3D tcon->ses->server;
> >
> >       page1 =3D alloc_dentry_path();
> > @@ -2668,11 +2694,21 @@ cifs_rename2(struct mnt_idmap *idmap, struct in=
ode *source_dir,
> >       }
> >
> >       /* force revalidate to go get info when needed */
> > +     if (!rc) {
> > +             cifs_invalidate_cached_dir(tcon, source_parent);
> > +             if (target_parent !=3D source_parent)
> > +                     cifs_invalidate_cached_dir(tcon, target_parent);
> > +     }
> > +
> >       CIFS_I(source_dir)->time =3D CIFS_I(target_dir)->time =3D 0;
> >
> >  cifs_rename_exit:
> >       if (rehash)
> >               d_rehash(target_dentry);
> > +     if (target_parent)
> > +             dput(target_parent);
> > +     if (source_parent)
> > +             dput(source_parent);
>
> The non-NULL checks are unnecessary.  dput() already handles NULL
> dentries.



--=20
Regards,
Shyam
