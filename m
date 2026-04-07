Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D01379973
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 20:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775595519; cv=pass; b=ZdyZd+DwluiZVnDfPumSlv7cg5phF9xN3Y81SoXd2pBfAI3hMdaubRfXl2A6NBvMApgV0x33fJ95qzAlcQfCyC9KZR5YLsFEUUeDmT7jfg+J0t0EhXCU7zoY9Vo/00BZVkTlEEJ2YyunztOy3OjLBnXh9Q2Kx6W2y+2HKG0q7DA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775595519; c=relaxed/simple;
	bh=1h94AgfJWc3+s3Eaic276faU69WBrrgzWO/FfycbIyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XK6tXArbQNrtMYfUN6j0ONdBUlhGj/tH9Lumg3+uuTLVbqGnqK1HQTNFbk33RQFf8TwS+NGwNY1kQGLF6mo2OLR1Mkgkt8/w75ht7Zu0gGh9RBQEkLxsXGrGC31Z6EftQAen+zT4YNyf6H07FPkKexG+5qRAuBGxPfYSCpMcids=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jKDpDFOc; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jKDpDFOc"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89f68634786so68981326d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Apr 2026 13:58:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775595516; cv=none;
        d=google.com; s=arc-20240605;
        b=lwxBl4iSTRVkC9MsljdvSpwXn78Ez50fjJzK03zfZRVvB7GqZVqTCwOHMnOuAz/qY9
         N9ScNcU3mwGyfJlgJVmxcrSqvtxucQFiz6wfRXgDU/J/TV+sa1MZqc4vpyFyknxcy39Q
         PrqufNALUA9eFRRmmIJyh2mny3/6oL+CRstQSRk78eq8g8fKQB6Fw9DmRDjDz/9I4RrD
         LHAQEptsswNC78k1sbeHzoIsxH4/SOMNU005Q1BsYIdZZPPQICU3WL6ojMBJtX/VtX7I
         yM0QpgcFVtb5zgCwEYHMuq/Ro6Fs6XPJO+pBs4CU4keTGGxtKovoatSyVECXc4lCE1C0
         h5EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BcPD8wLE7ADF41hdDHeXkGM6SnYL84k9Fh3jr+xNJ4c=;
        fh=ePcwQ/JLSqy2fFj7Li1LKTXXEn6syFP9Igl4p46rW/Y=;
        b=XXK2BZq46e3Ei95B5vJzFJcmVfjCFCv72MggEggcdfCkigPlCTbDv2CLNJHRDcWLM+
         l89o7ISNbHRMqE6ejWdnJ8oLG/O4Kc+bvRvikf77qbtljFi2FBuFaTRnEQ8NwPqe2IuG
         EFyW1mi05lc0aX533hruqZJTumPf6OO33eN0adNZcKu3lD2fY9mJkZzfwIGYjct6zK5r
         ESyKw6GnYLVkm+m4LDdaNnjbhxBghhC3Jr9xVLQOp3ODdCbSeaZASg3jzCBNW/2IjOlD
         tP8H0QdVC9K1JWgHOyXCqW//eaDJhg/uYYwO+TRNjz6CRvoGY0zWPYV00dVIxsT8GqPF
         H9mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775595516; x=1776200316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcPD8wLE7ADF41hdDHeXkGM6SnYL84k9Fh3jr+xNJ4c=;
        b=jKDpDFOcY0MKGc1xFrAs5hp7mLFQ5nliNcbSwyT5IOtYMcqeMAI3w5CLJzcGOatdj1
         LGpi1CuZsZqKIp8ECsCWpbiFW5lhrNGz4vE0iiC/kwJxkIgKCGsE5t6z2NKvMR/zFo+q
         hiikt+Y/7X7yC8sCsKbU1+p9F0HVuX3GfOb+jMpTz9W35TUKtRXlX4+E7o8VXsytIt4M
         REwSs9a+deSldb4dFdja1OwEbIQWwD2UnBGZABA+heCzbe/8mKUSP45yh7qGXdgj1P1a
         cFjw98Dseq4bsDxIiN7EqEVsAIdikkxZrtt3kw1Na+geDnFDWRrqbiAN45jgLNgLR7j7
         l2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775595516; x=1776200316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BcPD8wLE7ADF41hdDHeXkGM6SnYL84k9Fh3jr+xNJ4c=;
        b=b0gM/NrAYs2wLQZJFp2DXX1mNr5WPEorJUSaoVIFhtOEzP9kvEJo8C4pWdsvSLowDI
         KizAdvmOfS1r6uBp2H570F47jqETHPB12byoBe0RhiTQx+we2NVAFN4H9n8e1A3xj6yg
         vXt/p9NiSDH/TVd19BCcjh59Fre/JWVLRvADzMlYpMe8TYh7TFWsjmcn0U0B0EfNpvMV
         uZccPt4HWGC8dOmAJeg/Ls/pC84Fy7nVC6BuhWcF1NCZfQYlpxR5rf5k+MWYKMH+LYs3
         lTirnPvC+yeDWIpth/J1self40J/+PS0T7HHKuiGV3mPLisvwN/hFejghNL69JMkCA3Z
         hNBg==
X-Forwarded-Encrypted: i=1; AJvYcCWbx9HI4eZ1nq74PxtQ3o9HTZ+58XHVYQWAuof6KBIlYQU5K1U9toNm0IxtG5XnpdwLC46Obv32pmvT@vger.kernel.org
X-Gm-Message-State: AOJu0YzfHhxpNP6kKq62wiOQYC/Ib57+y2YvYpQXNWGjWjtO/wn71u+q
	eiX7yDBq1jo+k+wJ+5mlVLgm8ZTD44xHovyczn6kTJ6wxG9LHVBSS1kgH71nark55P3oBcBaiVF
	U5/Yt7V9UqHDFE+K6Q0zFmznaD1PW3jBTlg==
X-Gm-Gg: AeBDievQOXNOwx4MgQq/kGX5opfEAKkVWnIOwB3fXalJP/VZn7qLpDqOSiBh9jYWZgW
	CX32YE5ax/jR3lLv0Wk5lpioo59GLNzRT/VFMPqj29ntW96CncQW6k+x7Glz38VWDsjOrg+STCy
	/O6f1RNqVr9yKcxbZOxVGJ55eWHHiDNQ8SE0fcqPKhfJRGvKvrIGPYi3bvEgz0bdet37va4KReL
	xe7RcJkLEfG6L18B5MkAnD1u6v5+TH6CrUBAm507H3H49dqnP4rwOdEBSc4rUH1DClHOaNiwuC0
	KpwRk79FQ+MT7keF8xz0O7plKS0qYLEnGtgXmmqmRzuh610hoEdHWiiSQJ9sN5om0k1bSUjWP2S
	kuYNVEZxDvpAXXoJqm0uyNLsQZes8rDLVn8mh8EGNPnnACtI8Nd8hgsRCdMZfbPI=
X-Received: by 2002:a05:6214:e82:b0:89c:5e9c:4159 with SMTP id
 6a1803df08f44-8a6ff0bd833mr287826856d6.0.1775595515387; Tue, 07 Apr 2026
 13:58:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407195810.993862-1-pc@manguebit.org> <20260407195810.993862-2-pc@manguebit.org>
In-Reply-To: <20260407195810.993862-2-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 7 Apr 2026 15:58:24 -0500
X-Gm-Features: AQROBzCUvdp4wjP4B_G0xcddz3ngaNti1QUqGZti4PkgAd5APPwpTR7t03cDeHg
Message-ID: <CAH2r5muoNncWMAQ49thrQyy_c14Bn7rD5RLj88qGZ=ax=-FhkA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] smb: client: add support for O_TMPFILE
To: Paulo Alcantara <pc@manguebit.org>
Cc: viro@zeniv.linux.org.uk, David Howells <dhowells@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch in cifs-2.6.git for-next


On Tue, Apr 7, 2026 at 2:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Implement O_TMPFILE support for SMB2+ in the CIFS client.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-cifs@vger.kernel.org
> ---
> v1 -> v2:
>   * handling of CIFS_INO_TMPFILE bit can be done locklessly, so no
>     spinlock required.
>   * added a very simple documentation on expected dentry states to
>     cifs_atomic_open(), cifs_create and cifs_tmpfile().
>
>  fs/smb/client/cifsfs.c    |   4 +
>  fs/smb/client/cifsfs.h    |  19 ++
>  fs/smb/client/cifsglob.h  |  23 ++-
>  fs/smb/client/cifsproto.h |   3 +-
>  fs/smb/client/dir.c       | 313 ++++++++++++++++++++++++-----
>  fs/smb/client/file.c      |  53 +++--
>  fs/smb/client/inode.c     |   3 +-
>  fs/smb/client/link.c      |   1 +
>  fs/smb/client/smb2inode.c | 400 ++++++++++++++------------------------
>  9 files changed, 492 insertions(+), 327 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 32d0305a1239..f4bed8d4a072 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -124,6 +124,9 @@ MODULE_PARM_DESC(dir_cache_timeout, "Number of second=
s to cache directory conten
>  /* Module-wide total cached dirents (in bytes) across all tcons */
>  atomic64_t cifs_dircache_bytes_used =3D ATOMIC64_INIT(0);
>
> +atomic_t cifs_sillycounter;
> +atomic_t cifs_tmpcounter;
> +
>  /*
>   * Write-only module parameter to drop all cached directory entries acro=
ss
>   * all CIFS mounts. Echo a non-zero value to trigger.
> @@ -1199,6 +1202,7 @@ MODULE_ALIAS("smb3");
>  const struct inode_operations cifs_dir_inode_ops =3D {
>         .create =3D cifs_create,
>         .atomic_open =3D cifs_atomic_open,
> +       .tmpfile =3D cifs_tmpfile,
>         .lookup =3D cifs_lookup,
>         .getattr =3D cifs_getattr,
>         .unlink =3D cifs_unlink,
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index e320d39b01f5..64c7a4c6ac83 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -13,6 +13,9 @@
>
>  #define ROOT_I 2
>
> +extern atomic_t cifs_sillycounter;
> +extern atomic_t cifs_tmpcounter;
> +
>  /*
>   * ino_t is 32-bits on 32-bit arch. We have to squash the 64-bit value d=
own
>   * so that it will fit. We use hash_64 to convert the value to 31 bits, =
and
> @@ -53,6 +56,8 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *=
inode,
>                 struct dentry *direntry, umode_t mode, bool excl);
>  int cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>                      struct file *file, unsigned int oflags, umode_t mode=
);
> +int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +                struct file *file, umode_t mode);
>  struct dentry *cifs_lookup(struct inode *parent_dir_inode,
>                            struct dentry *direntry, unsigned int flags);
>  int cifs_unlink(struct inode *dir, struct dentry *dentry);
> @@ -142,6 +147,20 @@ struct smb3_fs_context;
>  struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type, int =
flags,
>                                   struct smb3_fs_context *old_ctx);
>
> +char *cifs_silly_fullpath(struct dentry *dentry);
> +
> +#define CIFS_TMPNAME_PREFIX        ".__smbfile_tmp"
> +#define CIFS_TMPNAME_PREFIX_LEN    ((int)sizeof(CIFS_TMPNAME_PREFIX) - 1=
)
> +#define CIFS_TMPNAME_COUNTER_LEN   ((int)sizeof(cifs_tmpcounter) * 2)
> +#define CIFS_TMPNAME_LEN \
> +       (CIFS_TMPNAME_PREFIX_LEN + CIFS_TMPNAME_COUNTER_LEN)
> +
> +#define CIFS_SILLYNAME_PREFIX      ".__smbfile_silly"
> +#define CIFS_SILLYNAME_PREFIX_LEN  ((int)sizeof(CIFS_SILLYNAME_PREFIX) -=
 1)
> +#define CIFS_SILLYNAME_COUNTER_LEN ((int)sizeof(cifs_sillycounter) * 2)
> +#define CIFS_SILLYNAME_LEN \
> +       (CIFS_SILLYNAME_PREFIX_LEN + CIFS_SILLYNAME_COUNTER_LEN)
> +
>  #ifdef CONFIG_CIFS_NFSD_EXPORT
>  extern const struct export_operations cifs_export_ops;
>  #endif /* CONFIG_CIFS_NFSD_EXPORT */
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 709e96e07791..ccfde157d3be 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1534,9 +1534,16 @@ int cifs_file_set_size(const unsigned int xid, str=
uct dentry *dentry,
>  #define CIFS_CACHE_RW_FLG      (CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_F=
LG)
>  #define CIFS_CACHE_RHW_FLG     (CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FL=
G)
>
> -/*
> - * One of these for each file inode
> - */
> +enum cifs_inode_flags {
> +       CIFS_INODE_PENDING_OPLOCK_BREAK,        /* oplock break in progre=
ss */
> +       CIFS_INODE_PENDING_WRITERS,             /* Writes in progress */
> +       CIFS_INODE_FLAG_UNUSED,                 /* Unused flag */
> +       CIFS_INO_DELETE_PENDING,                /* delete pending on serv=
er */
> +       CIFS_INO_INVALID_MAPPING,               /* pagecache is invalid *=
/
> +       CIFS_INO_LOCK,                          /* lock bit for synchroni=
zation */
> +       CIFS_INO_TMPFILE,                       /* for O_TMPFILE inodes *=
/
> +       CIFS_INO_CLOSE_ON_LOCK,                 /* Not to defer the close=
 when lock is set */
> +};
>
>  struct cifsInodeInfo {
>         struct netfs_inode netfs; /* Netfslib context and vfs inode */
> @@ -1554,13 +1561,6 @@ struct cifsInodeInfo {
>         __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, sys=
tem */
>         unsigned int oplock;            /* oplock/lease level we have */
>         __u16 epoch;            /* used to track lease state changes */
> -#define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progres=
s */
> -#define CIFS_INODE_PENDING_WRITERS       (1) /* Writes in progress */
> -#define CIFS_INODE_FLAG_UNUSED           (2) /* Unused flag */
> -#define CIFS_INO_DELETE_PENDING                  (3) /* delete pending o=
n server */
> -#define CIFS_INO_INVALID_MAPPING         (4) /* pagecache is invalid */
> -#define CIFS_INO_LOCK                    (5) /* lock bit for synchroniza=
tion */
> -#define CIFS_INO_CLOSE_ON_LOCK            (7) /* Not to defer the close =
when lock is set */
>         unsigned long flags;
>         spinlock_t writers_lock;
>         unsigned int writers;           /* Number of writers on this inod=
e */
> @@ -2259,6 +2259,7 @@ struct smb2_compound_vars {
>         struct kvec qi_iov;
>         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
>         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> +       struct kvec hl_iov[SMB2_SET_INFO_IOV_SIZE];
>         struct kvec unlink_iov[SMB2_SET_INFO_IOV_SIZE];
>         struct kvec rename_iov[SMB2_SET_INFO_IOV_SIZE];
>         struct kvec close_iov;
> @@ -2383,6 +2384,8 @@ static inline int cifs_open_create_options(unsigned=
 int oflags, int opts)
>                 opts |=3D CREATE_WRITE_THROUGH;
>         if (oflags & O_DIRECT)
>                 opts |=3D CREATE_NO_BUFFER;
> +       if (oflags & O_TMPFILE)
> +               opts |=3D CREATE_DELETE_ON_CLOSE;
>         return opts;
>  }
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 884bfa1cf0b4..c24c50d732e6 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -141,7 +141,8 @@ struct cifsFileInfo *find_writable_file(struct cifsIn=
odeInfo *cifs_inode,
>  int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
>                              unsigned int find_flags, unsigned int open_f=
lags,
>                              struct cifsFileInfo **ret_file);
> -int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name, int=
 flags,
> +int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
> +                          struct inode *inode, int flags,
>                            struct cifsFileInfo **ret_file);
>  struct cifsFileInfo *__find_readable_file(struct cifsInodeInfo *cifs_ino=
de,
>                                           unsigned int find_flags,
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 6d2378eeb7f6..67f9f956c211 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -172,20 +172,44 @@ check_name(struct dentry *direntry, struct cifs_tco=
n *tcon)
>         return 0;
>  }
>
> +static char *alloc_parent_path(struct dentry *dentry, size_t namelen)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry);
> +       void *page =3D alloc_dentry_path();
> +       const char *path;
> +       size_t size;
> +       char *npath;
> +
> +       path =3D build_path_from_dentry(dentry->d_parent, page);
> +       if (IS_ERR(path)) {
> +               npath =3D ERR_CAST(path);
> +               goto out;
> +       }
> +
> +       size =3D strlen(path) + namelen + 2;
> +       npath =3D kmalloc(size, GFP_KERNEL);
> +       if (!npath)
> +               npath =3D ERR_PTR(-ENOMEM);
> +       else
> +               scnprintf(npath, size, "%s%c", path, CIFS_DIR_SEP(cifs_sb=
));
> +out:
> +       free_dentry_path(page);
> +       return npath;
> +}
>
>  /* Inode operations in similar order to how they appear in Linux file fs=
.h */
> -
> -static int cifs_do_create(struct inode *inode, struct dentry *direntry, =
unsigned int xid,
> -                         struct tcon_link *tlink, unsigned int oflags, u=
mode_t mode, __u32 *oplock,
> -                         struct cifs_fid *fid, struct cifs_open_info_dat=
a *buf)
> +static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
> +                           const char *full_path, unsigned int xid,
> +                           struct tcon_link *tlink, unsigned int oflags,
> +                           umode_t mode, __u32 *oplock, struct cifs_fid =
*fid,
> +                           struct cifs_open_info_data *buf,
> +                           struct inode **inode)
>  {
>         int rc =3D -ENOENT;
>         int create_options =3D CREATE_NOT_DIR;
>         int desired_access;
> -       struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode);
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dir);
>         struct cifs_tcon *tcon =3D tlink_tcon(tlink);
> -       const char *full_path;
> -       void *page =3D alloc_dentry_path();
>         struct inode *newinode =3D NULL;
>         unsigned int sbflags =3D cifs_sb_flags(cifs_sb);
>         int disposition;
> @@ -199,21 +223,15 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
>         if (tcon->ses->server->oplocks)
>                 *oplock =3D REQ_OPLOCK;
>
> -       full_path =3D build_path_from_dentry(direntry, page);
> -       if (IS_ERR(full_path)) {
> -               rc =3D PTR_ERR(full_path);
> -               goto out;
> -       }
> -
>         /* If we're caching, we need to be able to fill in around partial=
 writes. */
> -       if (cifs_fscache_enabled(inode) && (oflags & O_ACCMODE) =3D=3D O_=
WRONLY)
> +       if (cifs_fscache_enabled(dir) && (oflags & O_ACCMODE) =3D=3D O_WR=
ONLY)
>                 rdwr_for_fscache =3D 1;
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>         if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_=
open &&
>             (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>                         le64_to_cpu(tcon->fsUnixInfo.Capability))) {
> -               rc =3D cifs_posix_open(full_path, &newinode, inode->i_sb,=
 mode,
> +               rc =3D cifs_posix_open(full_path, &newinode, dir->i_sb, m=
ode,
>                                      oflags, oplock, &fid->netfid, xid);
>                 switch (rc) {
>                 case 0:
> @@ -225,8 +243,7 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
>                         if (S_ISDIR(newinode->i_mode)) {
>                                 CIFSSMBClose(xid, tcon, fid->netfid);
>                                 iput(newinode);
> -                               rc =3D -EISDIR;
> -                               goto out;
> +                               return -EISDIR;
>                         }
>
>                         if (!S_ISREG(newinode->i_mode)) {
> @@ -269,7 +286,7 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
>                         break;
>
>                 default:
> -                       goto out;
> +                       return rc;
>                 }
>                 /*
>                  * fallthrough to retry, using older open call, this is c=
ase
> @@ -287,26 +304,30 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
>                 desired_access |=3D GENERIC_WRITE;
>         if (rdwr_for_fscache =3D=3D 1)
>                 desired_access |=3D GENERIC_READ;
> +       if (oflags & O_TMPFILE)
> +               desired_access |=3D DELETE;
>
>         disposition =3D FILE_OVERWRITE_IF;
> -       if ((oflags & (O_CREAT | O_EXCL)) =3D=3D (O_CREAT | O_EXCL))
> +       if (oflags & O_CREAT) {
> +               if (oflags & O_EXCL)
> +                       disposition =3D FILE_CREATE;
> +               else if (oflags & O_TRUNC)
> +                       disposition =3D FILE_OVERWRITE_IF;
> +               else
> +                       disposition =3D FILE_OPEN_IF;
> +       } else if (oflags & O_TMPFILE) {
>                 disposition =3D FILE_CREATE;
> -       else if ((oflags & (O_CREAT | O_TRUNC)) =3D=3D (O_CREAT | O_TRUNC=
))
> -               disposition =3D FILE_OVERWRITE_IF;
> -       else if ((oflags & O_CREAT) =3D=3D O_CREAT)
> -               disposition =3D FILE_OPEN_IF;
> -       else
> +       } else {
>                 cifs_dbg(FYI, "Create flag not set in create function\n")=
;
> +       }
>
>         /*
>          * BB add processing to set equivalent of mode - e.g. via CreateX=
 with
>          * ACLs
>          */
>
> -       if (!server->ops->open) {
> -               rc =3D -ENOSYS;
> -               goto out;
> -       }
> +       if (!server->ops->open)
> +               return -EOPNOTSUPP;
>
>         create_options |=3D cifs_open_create_options(oflags, create_optio=
ns);
>         /*
> @@ -358,10 +379,10 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
>                         rdwr_for_fscache =3D 2;
>                         goto retry_open;
>                 }
> -               goto out;
> +               return rc;
>         }
>         if (rdwr_for_fscache =3D=3D 2)
> -               cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
> +               cifs_invalidate_cache(dir, FSCACHE_INVAL_DIO_WRITE);
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>         /*
> @@ -379,8 +400,8 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
>
>                 if (sbflags & CIFS_MOUNT_SET_UID) {
>                         args.uid =3D current_fsuid();
> -                       if (inode->i_mode & S_ISGID)
> -                               args.gid =3D inode->i_gid;
> +                       if (dir->i_mode & S_ISGID)
> +                               args.gid =3D dir->i_gid;
>                         else
>                                 args.gid =3D current_fsgid();
>                 } else {
> @@ -402,14 +423,14 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
>  cifs_create_get_file_info:
>         /* server might mask mode so we have to query for it */
>         if (tcon->unix_ext)
> -               rc =3D cifs_get_inode_info_unix(&newinode, full_path, ino=
de->i_sb,
> +               rc =3D cifs_get_inode_info_unix(&newinode, full_path, dir=
->i_sb,
>                                               xid);
>         else {
>  #else
>         {
>  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>                 /* TODO: Add support for calling POSIX query info here, b=
ut passing in fid */
> -               rc =3D cifs_get_inode_info(&newinode, full_path, buf, ino=
de->i_sb, xid, fid);
> +               rc =3D cifs_get_inode_info(&newinode, full_path, buf, dir=
->i_sb, xid, fid);
>                 if (newinode) {
>                         if (server->ops->set_lease_key)
>                                 server->ops->set_lease_key(newinode, fid)=
;
> @@ -418,8 +439,8 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
>                                         newinode->i_mode =3D mode;
>                                 if (sbflags & CIFS_MOUNT_SET_UID) {
>                                         newinode->i_uid =3D current_fsuid=
();
> -                                       if (inode->i_mode & S_ISGID)
> -                                               newinode->i_gid =3D inode=
->i_gid;
> +                                       if (dir->i_mode & S_ISGID)
> +                                               newinode->i_gid =3D dir->=
i_gid;
>                                         else
>                                                 newinode->i_gid =3D curre=
nt_fsgid();
>                                 }
> @@ -436,17 +457,13 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
>                 goto out_err;
>         }
>
> -       if (newinode)
> -               if (S_ISDIR(newinode->i_mode)) {
> -                       rc =3D -EISDIR;
> -                       goto out_err;
> -               }
> +       if (newinode && S_ISDIR(newinode->i_mode)) {
> +               rc =3D -EISDIR;
> +               goto out_err;
> +       }
>
>         d_drop(direntry);
> -       d_add(direntry, newinode);
> -
> -out:
> -       free_dentry_path(page);
> +       *inode =3D newinode;
>         return rc;
>
>  out_err:
> @@ -454,9 +471,41 @@ static int cifs_do_create(struct inode *inode, struc=
t dentry *direntry, unsigned
>                 server->ops->close(xid, tcon, fid);
>         if (newinode)
>                 iput(newinode);
> -       goto out;
> +       return rc;
>  }
>
> +static int cifs_do_create(struct inode *dir, struct dentry *direntry,
> +                         unsigned int xid, struct tcon_link *tlink,
> +                         unsigned int oflags, umode_t mode,
> +                         __u32 *oplock, struct cifs_fid *fid,
> +                         struct cifs_open_info_data *buf)
> +{
> +       void *page =3D alloc_dentry_path();
> +       const char *full_path;
> +       struct inode *inode;
> +       int rc;
> +
> +       full_path =3D build_path_from_dentry(direntry, page);
> +       if (IS_ERR(full_path)) {
> +               rc =3D PTR_ERR(full_path);
> +       } else {
> +               rc =3D __cifs_do_create(dir, direntry, full_path, xid,
> +                                     tlink, oflags, mode, oplock,
> +                                     fid, buf, &inode);
> +               if (!rc)
> +                       d_add(direntry, inode);
> +       }
> +       free_dentry_path(page);
> +       return rc;
> +}
> +
> +
> +/*
> + * Look up, create and open a CIFS file.
> + *
> + * The initial dentry state is in-lookup or hashed-negative.  On success=
, dentry
> + * will become hashed-positive by calling d_drop() & d_add(), respective=
ly.
> + */
>  int
>  cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>                  struct file *file, unsigned int oflags, umode_t mode)
> @@ -569,6 +618,12 @@ cifs_atomic_open(struct inode *inode, struct dentry =
*direntry,
>         return rc;
>  }
>
> +/*
> + * Create a CIFS file.
> + *
> + * The initial dentry state is hashed-negative.  On success, dentry will=
 become
> + * hashed-positive by calling d_drop() & d_add(), respectively.
> + */
>  int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
>                 struct dentry *direntry, umode_t mode, bool excl)
>  {
> @@ -959,6 +1014,172 @@ static int cifs_ci_compare(const struct dentry *de=
ntry,
>         return 0;
>  }
>
> +static int set_hidden_attr(const unsigned int xid,
> +                          struct TCP_Server_Info *server,
> +                          struct file *file)
> +{
> +       struct dentry *dentry =3D file->f_path.dentry;
> +       struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(dentry));
> +       FILE_BASIC_INFO fi =3D {
> +               .Attributes =3D cpu_to_le32(cinode->cifsAttrs |
> +                                         ATTR_HIDDEN),
> +       };
> +       void *page =3D alloc_dentry_path();
> +       const char *full_path;
> +       int rc;
> +
> +       full_path =3D build_path_from_dentry(dentry, page);
> +       if (IS_ERR(full_path))
> +               rc =3D PTR_ERR(full_path);
> +       else
> +               rc =3D  server->ops->set_file_info(d_inode(dentry),
> +                                                full_path, &fi, xid);
> +       free_dentry_path(page);
> +       return rc;
> +}
> +
> +/*
> + * Create a hidden temporary CIFS file with delete-on-close bit set.
> + *
> + * The initial dentry state is unhashed-negative.  On success, dentry wi=
ll
> + * become unhashed-positive by calling d_drop() & d_instantiate(), respe=
ctively.
> + */
> +int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +                struct file *file, umode_t mode)
> +{
> +       struct dentry *dentry =3D file->f_path.dentry;
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dir);
> +       size_t size =3D CIFS_TMPNAME_LEN + 1;
> +       int retries =3D 0, max_retries =3D 16;
> +       struct TCP_Server_Info *server;
> +       struct cifs_pending_open open;
> +       struct cifsFileInfo *cfile;
> +       struct cifs_fid fid =3D {};
> +       struct tcon_link *tlink;
> +       struct cifs_tcon *tcon;
> +       unsigned int sbflags;
> +       struct inode *inode;
> +       char *path, *name;
> +       unsigned int xid;
> +       __u32 oplock;
> +       int rc;
> +
> +       if (unlikely(cifs_forced_shutdown(cifs_sb)))
> +               return smb_EIO(smb_eio_trace_forced_shutdown);
> +
> +       tlink =3D cifs_sb_tlink(cifs_sb);
> +       if (IS_ERR(tlink))
> +               return PTR_ERR(tlink);
> +       tcon =3D tlink_tcon(tlink);
> +       server =3D tcon->ses->server;
> +
> +       xid =3D get_xid();
> +
> +       if (server->vals->protocol_id < SMB20_PROT_ID) {
> +               cifs_dbg(VFS | ONCE, "O_TMPFILE is supported only in SMB2=
+\n");
> +               rc =3D -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       if (server->ops->new_lease_key)
> +               server->ops->new_lease_key(&fid);
> +       cifs_add_pending_open(&fid, tlink, &open);
> +
> +       path =3D alloc_parent_path(dentry, size - 1);
> +       if (IS_ERR(path)) {
> +               cifs_del_pending_open(&open);
> +               rc =3D PTR_ERR(path);
> +               goto out;
> +       }
> +
> +       name =3D path + strlen(path);
> +       do {
> +               scnprintf(name, size,
> +                         CIFS_TMPNAME_PREFIX "%0*x",
> +                         CIFS_TMPNAME_COUNTER_LEN,
> +                         atomic_inc_return(&cifs_tmpcounter));
> +               rc =3D __cifs_do_create(dir, dentry, path, xid, tlink,
> +                                     file->f_flags, mode, &oplock,
> +                                     &fid, NULL, &inode);
> +               if (!rc) {
> +                       set_nlink(inode, 0);
> +                       mark_inode_dirty(inode);
> +                       d_mark_tmpfile_name(file, &QSTR_LEN(name, size - =
1));
> +                       d_instantiate(dentry, inode);
> +                       break;
> +               }
> +       } while (unlikely(rc =3D=3D -EEXIST) && ++retries < max_retries);
> +
> +       kfree(path);
> +       if (rc) {
> +               cifs_del_pending_open(&open);
> +               goto out;
> +       }
> +
> +       rc =3D finish_open(file, dentry, generic_file_open);
> +       if (rc)
> +               goto err_open;
> +
> +       sbflags =3D cifs_sb_flags(cifs_sb);
> +       if ((file->f_flags & O_DIRECT) && (sbflags & CIFS_MOUNT_STRICT_IO=
)) {
> +               if (sbflags & CIFS_MOUNT_NO_BRL)
> +                       file->f_op =3D &cifs_file_direct_nobrl_ops;
> +               else
> +                       file->f_op =3D &cifs_file_direct_ops;
> +       }
> +
> +       cfile =3D cifs_new_fileinfo(&fid, file, tlink, oplock, NULL);
> +       if (!cfile) {
> +               rc =3D -ENOMEM;
> +               goto err_open;
> +       }
> +
> +       rc =3D set_hidden_attr(xid, server, file);
> +       if (rc)
> +               goto out;
> +
> +       fscache_use_cookie(cifs_inode_cookie(file_inode(file)),
> +                          file->f_mode & FMODE_WRITE);
> +out:
> +       cifs_put_tlink(tlink);
> +       free_xid(xid);
> +       return rc;
> +err_open:
> +       cifs_del_pending_open(&open);
> +       if (server->ops->close)
> +               server->ops->close(xid, tcon, &fid);
> +       goto out;
> +}
> +
> +char *cifs_silly_fullpath(struct dentry *dentry)
> +{
> +       unsigned char name[CIFS_SILLYNAME_LEN + 1];
> +       int retries =3D 0, max_retries =3D 16;
> +       size_t namesize =3D sizeof(name);
> +       struct dentry *sdentry =3D NULL;
> +       char *path;
> +
> +       do {
> +               dput(sdentry);
> +               scnprintf(name, namesize,
> +                         CIFS_SILLYNAME_PREFIX "%0*x",
> +                         CIFS_SILLYNAME_COUNTER_LEN,
> +                         atomic_inc_return(&cifs_sillycounter));
> +               sdentry =3D lookup_noperm(&QSTR(name), dentry->d_parent);
> +               if (IS_ERR(sdentry))
> +                       return ERR_CAST(sdentry);
> +               if (d_is_negative(sdentry)) {
> +                       dput(sdentry);
> +                       path =3D alloc_parent_path(dentry, CIFS_SILLYNAME=
_LEN);
> +                       if (!IS_ERR(path))
> +                               strcat(path, name);
> +                       return path;
> +               }
> +       } while (++retries < max_retries);
> +       dput(sdentry);
> +       return ERR_PTR(-EBUSY);
> +}
> +
>  const struct dentry_operations cifs_ci_dentry_ops =3D {
>         .d_revalidate =3D cifs_d_revalidate,
>         .d_hash =3D cifs_ci_hash,
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index a69e05f86d7e..5d5b49468aff 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -406,22 +406,29 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon=
)
>          */
>  }
>
> -static inline int cifs_convert_flags(unsigned int flags, int rdwr_for_fs=
cache)
> +static inline int cifs_convert_flags(unsigned int oflags, int rdwr_for_f=
scache)
>  {
> -       if ((flags & O_ACCMODE) =3D=3D O_RDONLY)
> -               return GENERIC_READ;
> -       else if ((flags & O_ACCMODE) =3D=3D O_WRONLY)
> -               return rdwr_for_fscache =3D=3D 1 ? (GENERIC_READ | GENERI=
C_WRITE) : GENERIC_WRITE;
> -       else if ((flags & O_ACCMODE) =3D=3D O_RDWR) {
> +       int flags =3D 0;
> +
> +       if (oflags & O_TMPFILE)
> +               flags |=3D DELETE;
> +
> +       if ((oflags & O_ACCMODE) =3D=3D O_RDONLY)
> +               return flags | GENERIC_READ;
> +       if ((oflags & O_ACCMODE) =3D=3D O_WRONLY) {
> +               return flags | (rdwr_for_fscache =3D=3D 1 ?
> +                               (GENERIC_READ | GENERIC_WRITE) : GENERIC_=
WRITE);
> +       }
> +       if ((oflags & O_ACCMODE) =3D=3D O_RDWR) {
>                 /* GENERIC_ALL is too much permission to request
>                    can cause unnecessary access denied on create */
>                 /* return GENERIC_ALL; */
> -               return (GENERIC_READ | GENERIC_WRITE);
> +               return flags | GENERIC_READ | GENERIC_WRITE;
>         }
>
> -       return (READ_CONTROL | FILE_WRITE_ATTRIBUTES | FILE_READ_ATTRIBUT=
ES |
> -               FILE_WRITE_EA | FILE_APPEND_DATA | FILE_WRITE_DATA |
> -               FILE_READ_DATA);
> +       return flags | READ_CONTROL | FILE_WRITE_ATTRIBUTES |
> +               FILE_READ_ATTRIBUTES | FILE_WRITE_EA | FILE_APPEND_DATA |
> +               FILE_WRITE_DATA | FILE_READ_DATA;
>  }
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> @@ -696,6 +703,7 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fi=
d *fid, struct file *file,
>         cfile->f_flags =3D file->f_flags;
>         cfile->invalidHandle =3D false;
>         cfile->deferred_close_scheduled =3D false;
> +       cfile->status_file_deleted =3D file->f_flags & O_TMPFILE;
>         cfile->tlink =3D cifs_get_tlink(tlink);
>         INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
>         INIT_WORK(&cfile->put, cifsFileInfo_put_work);
> @@ -727,6 +735,8 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fi=
d *fid, struct file *file,
>
>         /* if readable file instance put first in list*/
>         spin_lock(&cinode->open_file_lock);
> +       if (file->f_flags & O_TMPFILE)
> +               set_bit(CIFS_INO_TMPFILE, &cinode->flags);
>         fid->purge_cache =3D false;
>         server->ops->set_fid(cfile, fid, oplock);
>
> @@ -2578,13 +2588,12 @@ int __cifs_get_writable_file(struct cifsInodeInfo=
 *cifs_inode,
>                              struct cifsFileInfo **ret_file)
>  {
>         struct cifsFileInfo *open_file, *inv_file =3D NULL;
> +       bool fsuid_only, with_delete;
>         struct cifs_sb_info *cifs_sb;
>         bool any_available =3D false;
> -       int rc =3D -EBADF;
>         unsigned int refind =3D 0;
> -       bool fsuid_only =3D find_flags & FIND_FSUID_ONLY;
> -       bool with_delete =3D find_flags & FIND_WITH_DELETE;
>         *ret_file =3D NULL;
> +       int rc =3D -EBADF;
>
>         /*
>          * Having a null inode here (because mapping->host was set to zer=
o by
> @@ -2598,8 +2607,13 @@ int __cifs_get_writable_file(struct cifsInodeInfo =
*cifs_inode,
>                 return rc;
>         }
>
> +       if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
> +               find_flags =3D FIND_ANY;
> +
>         cifs_sb =3D CIFS_SB(cifs_inode);
>
> +       with_delete =3D find_flags & FIND_WITH_DELETE;
> +       fsuid_only =3D find_flags & FIND_FSUID_ONLY;
>         /* only filter by fsuid on multiuser mounts */
>         if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
>                 fsuid_only =3D false;
> @@ -2683,16 +2697,19 @@ find_writable_file(struct cifsInodeInfo *cifs_ino=
de, int flags)
>         return cfile;
>  }
>
> -int
> -cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
> -                      int flags,
> -                      struct cifsFileInfo **ret_file)
> +int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
> +                          struct inode *inode, int flags,
> +                          struct cifsFileInfo **ret_file)
>  {
>         struct cifsFileInfo *cfile;
> -       void *page =3D alloc_dentry_path();
> +       void *page;
>
>         *ret_file =3D NULL;
>
> +       if (inode)
> +               return cifs_get_writable_file(CIFS_I(inode), flags, ret_f=
ile);
> +
> +       page =3D alloc_dentry_path();
>         spin_lock(&tcon->open_file_lock);
>         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>                 struct cifsInodeInfo *cinode;
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 888f9e35f14b..24040909d184 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2690,7 +2690,8 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>         struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>         struct cached_fid *cfid =3D NULL;
>
> -       if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags))
> +       if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags) ||
> +           test_bit(CIFS_INO_TMPFILE, &cifs_i->flags))
>                 return false;
>         if (cifs_i->time =3D=3D 0)
>                 return true;
> diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
> index 434e8fe74080..dd127917a340 100644
> --- a/fs/smb/client/link.c
> +++ b/fs/smb/client/link.c
> @@ -503,6 +503,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *=
inode,
>         if (d_really_is_positive(old_file)) {
>                 cifsInode =3D CIFS_I(d_inode(old_file));
>                 if (rc =3D=3D 0) {
> +                       clear_bit(CIFS_INO_TMPFILE, &cifsInode->flags);
>                         spin_lock(&d_inode(old_file)->i_lock);
>                         inc_nlink(d_inode(old_file));
>                         spin_unlock(&d_inode(old_file)->i_lock);
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 364bdcff9c9d..5b056d67fcef 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -164,6 +164,27 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>         return 0;
>  }
>
> +/*
> + * If @cfile is NULL, then need to account for trailing CLOSE request in=
 the
> + * compound chain.
> + */
> +static void set_next_compound(struct cifs_tcon *tcon,
> +                             struct cifsFileInfo *cfile,
> +                             int i, int num_cmds,
> +                             struct smb_rqst *rqst, int *num_rqst)
> +{
> +       int k =3D !cfile ? 1 : 0;
> +
> +       if (i + 1 < num_cmds + k)
> +               smb2_set_next_command(tcon, &rqst[*num_rqst]);
> +       if (i + k > 0)
> +               smb2_set_related(&rqst[*num_rqst]);
> +       (*num_rqst)++;
> +}
> +
> +#define COMP_PID(cfile) ((cfile) ? (cfile)->fid.persistent_fid : COMPOUN=
D_FID)
> +#define COMP_VID(cfile) ((cfile) ? (cfile)->fid.volatile_fid : COMPOUND_=
FID)
> +
>  /*
>   * note: If cfile is passed, the reference to it is dropped here.
>   * So make sure that you do not reuse cfile after return from this func.
> @@ -284,32 +305,16 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         rqst[num_rqst].rq_iov =3D &vars->qi_iov;
>                         rqst[num_rqst].rq_nvec =3D 1;
>
> -                       if (cfile) {
> -                               rc =3D SMB2_query_info_init(tcon, server,
> -                                                         &rqst[num_rqst]=
,
> -                                                         cfile->fid.pers=
istent_fid,
> -                                                         cfile->fid.vola=
tile_fid,
> -                                                         FILE_ALL_INFORM=
ATION,
> -                                                         SMB2_O_INFO_FIL=
E, 0,
> -                                                         sizeof(struct s=
mb2_file_all_info) +
> -                                                         PATH_MAX * 2, 0=
, NULL);
> -                       } else {
> -                               rc =3D SMB2_query_info_init(tcon, server,
> -                                                         &rqst[num_rqst]=
,
> -                                                         COMPOUND_FID,
> -                                                         COMPOUND_FID,
> -                                                         FILE_ALL_INFORM=
ATION,
> -                                                         SMB2_O_INFO_FIL=
E, 0,
> -                                                         sizeof(struct s=
mb2_file_all_info) +
> -                                                         PATH_MAX * 2, 0=
, NULL);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_query_info_init(tcon, server,
> +                                                 &rqst[num_rqst],
> +                                                 COMP_PID(cfile), COMP_V=
ID(cfile),
> +                                                 FILE_ALL_INFORMATION,
> +                                                 SMB2_O_INFO_FILE, 0,
> +                                                 sizeof(struct smb2_file=
_all_info) +
> +                                                 PATH_MAX * 2, 0, NULL);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_query_info_compound_enter(xid, tcon->t=
id,
>                                                              ses->Suid, f=
ull_path);
>                         break;
> @@ -317,35 +322,18 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         rqst[num_rqst].rq_iov =3D &vars->qi_iov;
>                         rqst[num_rqst].rq_nvec =3D 1;
>
> -                       if (cfile) {
> -                               /* TBD: fix following to allow for longer=
 SIDs */
> -                               rc =3D SMB2_query_info_init(tcon, server,
> -                                                         &rqst[num_rqst]=
,
> -                                                         cfile->fid.pers=
istent_fid,
> -                                                         cfile->fid.vola=
tile_fid,
> -                                                         SMB_FIND_FILE_P=
OSIX_INFO,
> -                                                         SMB2_O_INFO_FIL=
E, 0,
> -                                                         sizeof(struct s=
mb311_posix_qinfo) +
> -                                                         (PATH_MAX * 2) =
+
> -                                                         (sizeof(struct =
smb_sid) * 2), 0, NULL);
> -                       } else {
> -                               rc =3D SMB2_query_info_init(tcon, server,
> -                                                         &rqst[num_rqst]=
,
> -                                                         COMPOUND_FID,
> -                                                         COMPOUND_FID,
> -                                                         SMB_FIND_FILE_P=
OSIX_INFO,
> -                                                         SMB2_O_INFO_FIL=
E, 0,
> -                                                         sizeof(struct s=
mb311_posix_qinfo) +
> -                                                         (PATH_MAX * 2) =
+
> -                                                         (sizeof(struct =
smb_sid) * 2), 0, NULL);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       /* TBD: fix following to allow for longer SIDs */
> +                       rc =3D SMB2_query_info_init(tcon, server,
> +                                                 &rqst[num_rqst],
> +                                                 COMP_PID(cfile), COMP_V=
ID(cfile),
> +                                                 SMB_FIND_FILE_POSIX_INF=
O,
> +                                                 SMB2_O_INFO_FILE, 0,
> +                                                 sizeof(struct smb311_po=
six_qinfo) +
> +                                                 (PATH_MAX * 2) +
> +                                                 (sizeof(struct smb_sid)=
 * 2), 0, NULL);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_posix_query_info_compound_enter(xid, t=
con->tid,
>                                                                    ses->S=
uid, full_path);
>                         break;
> @@ -363,32 +351,15 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         size[0] =3D 1; /* sizeof __u8 See MS-FSCC section=
 2.4.11 */
>                         data[0] =3D &delete_pending[0];
>
> -                       if (cfile) {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       cfile->fid.persis=
tent_fid,
> -                                                       cfile->fid.volati=
le_fid,
> -                                                       current->tgid,
> -                                                       FILE_DISPOSITION_=
INFORMATION,
> -                                                       SMB2_O_INFO_FILE,=
 0,
> -                                                       data, size);
> -                       } else {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       COMPOUND_FID,
> -                                                       COMPOUND_FID,
> -                                                       current->tgid,
> -                                                       FILE_DISPOSITION_=
INFORMATION,
> -                                                       SMB2_O_INFO_FILE,=
 0,
> -                                                       data, size);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_set_info_init(tcon, server,
> +                                               &rqst[num_rqst],
> +                                               COMP_PID(cfile), COMP_VID=
(cfile),
> +                                               current->tgid, FILE_DISPO=
SITION_INFORMATION,
> +                                               SMB2_O_INFO_FILE, 0,
> +                                               data, size);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_unlink_enter(xid, tcon->tid, ses->Suid=
, full_path);
>                         break;
>                 case SMB2_OP_SET_EOF:
> @@ -398,32 +369,15 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         size[0] =3D in_iov[i].iov_len;
>                         data[0] =3D in_iov[i].iov_base;
>
> -                       if (cfile) {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       cfile->fid.persis=
tent_fid,
> -                                                       cfile->fid.volati=
le_fid,
> -                                                       current->tgid,
> -                                                       FILE_END_OF_FILE_=
INFORMATION,
> -                                                       SMB2_O_INFO_FILE,=
 0,
> -                                                       data, size);
> -                       } else {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       COMPOUND_FID,
> -                                                       COMPOUND_FID,
> -                                                       current->tgid,
> -                                                       FILE_END_OF_FILE_=
INFORMATION,
> -                                                       SMB2_O_INFO_FILE,=
 0,
> -                                                       data, size);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_set_info_init(tcon, server,
> +                                               &rqst[num_rqst],
> +                                               COMP_PID(cfile), COMP_VID=
(cfile),
> +                                               current->tgid, FILE_END_O=
F_FILE_INFORMATION,
> +                                               SMB2_O_INFO_FILE, 0,
> +                                               data, size);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_set_eof_enter(xid, tcon->tid, ses->Sui=
d, full_path);
>                         break;
>                 case SMB2_OP_SET_INFO:
> @@ -433,28 +387,14 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         size[0] =3D in_iov[i].iov_len;
>                         data[0] =3D in_iov[i].iov_base;
>
> -                       if (cfile) {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       cfile->fid.persis=
tent_fid,
> -                                                       cfile->fid.volati=
le_fid, current->tgid,
> -                                                       FILE_BASIC_INFORM=
ATION,
> -                                                       SMB2_O_INFO_FILE,=
 0, data, size);
> -                       } else {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       COMPOUND_FID,
> -                                                       COMPOUND_FID, cur=
rent->tgid,
> -                                                       FILE_BASIC_INFORM=
ATION,
> -                                                       SMB2_O_INFO_FILE,=
 0, data, size);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_set_info_init(tcon, server,
> +                                               &rqst[num_rqst],
> +                                               COMP_PID(cfile), COMP_VID=
(cfile),
> +                                               current->tgid, FILE_BASIC=
_INFORMATION,
> +                                               SMB2_O_INFO_FILE, 0, data=
, size);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_set_info_compound_enter(xid, tcon->tid=
,
>                                                            ses->Suid, ful=
l_path);
>                         break;
> @@ -474,31 +414,19 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         size[1] =3D len + 2 /* null */;
>                         data[1] =3D in_iov[i].iov_base;
>
> -                       if (cfile) {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       cfile->fid.persis=
tent_fid,
> -                                                       cfile->fid.volati=
le_fid,
> -                                                       current->tgid, FI=
LE_RENAME_INFORMATION,
> -                                                       SMB2_O_INFO_FILE,=
 0, data, size);
> -                       } else {
> -                               rc =3D SMB2_set_info_init(tcon, server,
> -                                                       &rqst[num_rqst],
> -                                                       COMPOUND_FID, COM=
POUND_FID,
> -                                                       current->tgid, FI=
LE_RENAME_INFORMATION,
> -                                                       SMB2_O_INFO_FILE,=
 0, data, size);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_set_info_init(tcon, server,
> +                                               &rqst[num_rqst],
> +                                               COMP_PID(cfile), COMP_VID=
(cfile),
> +                                               current->tgid, FILE_RENAM=
E_INFORMATION,
> +                                               SMB2_O_INFO_FILE, 0, data=
, size);
> +
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_rename_enter(xid, tcon->tid, ses->Suid=
, full_path);
>                         break;
>                 case SMB2_OP_HARDLINK:
> -                       rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> +                       rqst[num_rqst].rq_iov =3D vars->hl_iov;
>                         rqst[num_rqst].rq_nvec =3D 2;
>
>                         len =3D in_iov[i].iov_len;
> @@ -514,41 +442,27 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         data[1] =3D in_iov[i].iov_base;
>
>                         rc =3D SMB2_set_info_init(tcon, server,
> -                                               &rqst[num_rqst], COMPOUND=
_FID,
> -                                               COMPOUND_FID, current->tg=
id,
> -                                               FILE_LINK_INFORMATION,
> +                                               &rqst[num_rqst],
> +                                               COMP_PID(cfile), COMP_VID=
(cfile),
> +                                               current->tgid, FILE_LINK_=
INFORMATION,
>                                                 SMB2_O_INFO_FILE, 0, data=
, size);
>                         if (rc)
>                                 goto finished;
> -                       smb2_set_next_command(tcon, &rqst[num_rqst]);
> -                       smb2_set_related(&rqst[num_rqst++]);
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_hardlink_enter(xid, tcon->tid, ses->Su=
id, full_path);
>                         break;
>                 case SMB2_OP_SET_REPARSE:
>                         rqst[num_rqst].rq_iov =3D vars->io_iov;
>                         rqst[num_rqst].rq_nvec =3D ARRAY_SIZE(vars->io_io=
v);
>
> -                       if (cfile) {
> -                               rc =3D SMB2_ioctl_init(tcon, server, &rqs=
t[num_rqst],
> -                                                    cfile->fid.persisten=
t_fid,
> -                                                    cfile->fid.volatile_=
fid,
> -                                                    FSCTL_SET_REPARSE_PO=
INT,
> -                                                    in_iov[i].iov_base,
> -                                                    in_iov[i].iov_len, 0=
);
> -                       } else {
> -                               rc =3D SMB2_ioctl_init(tcon, server, &rqs=
t[num_rqst],
> -                                                    COMPOUND_FID, COMPOU=
ND_FID,
> -                                                    FSCTL_SET_REPARSE_PO=
INT,
> -                                                    in_iov[i].iov_base,
> -                                                    in_iov[i].iov_len, 0=
);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_ioctl_init(tcon, server, &rqst[num_rq=
st],
> +                                            COMP_PID(cfile), COMP_VID(cf=
ile),
> +                                            FSCTL_SET_REPARSE_POINT,
> +                                            in_iov[i].iov_base,
> +                                            in_iov[i].iov_len, 0);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_set_reparse_compound_enter(xid, tcon->=
tid,
>                                                               ses->Suid, =
full_path);
>                         break;
> @@ -556,25 +470,13 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         rqst[num_rqst].rq_iov =3D vars->io_iov;
>                         rqst[num_rqst].rq_nvec =3D ARRAY_SIZE(vars->io_io=
v);
>
> -                       if (cfile) {
> -                               rc =3D SMB2_ioctl_init(tcon, server, &rqs=
t[num_rqst],
> -                                                    cfile->fid.persisten=
t_fid,
> -                                                    cfile->fid.volatile_=
fid,
> -                                                    FSCTL_GET_REPARSE_PO=
INT,
> -                                                    NULL, 0, CIFSMaxBufS=
ize);
> -                       } else {
> -                               rc =3D SMB2_ioctl_init(tcon, server, &rqs=
t[num_rqst],
> -                                                    COMPOUND_FID, COMPOU=
ND_FID,
> -                                                    FSCTL_GET_REPARSE_PO=
INT,
> -                                                    NULL, 0, CIFSMaxBufS=
ize);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_ioctl_init(tcon, server, &rqst[num_rq=
st],
> +                                            COMP_PID(cfile), COMP_VID(cf=
ile),
> +                                            FSCTL_GET_REPARSE_POINT,
> +                                            NULL, 0, CIFSMaxBufSize);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_get_reparse_compound_enter(xid, tcon->=
tid,
>                                                               ses->Suid, =
full_path);
>                         break;
> @@ -582,34 +484,17 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         rqst[num_rqst].rq_iov =3D &vars->ea_iov;
>                         rqst[num_rqst].rq_nvec =3D 1;
>
> -                       if (cfile) {
> -                               rc =3D SMB2_query_info_init(tcon, server,
> -                                                         &rqst[num_rqst]=
,
> -                                                         cfile->fid.pers=
istent_fid,
> -                                                         cfile->fid.vola=
tile_fid,
> -                                                         FILE_FULL_EA_IN=
FORMATION,
> -                                                         SMB2_O_INFO_FIL=
E, 0,
> -                                                         SMB2_WSL_MAX_QU=
ERY_EA_RESP_SIZE,
> -                                                         sizeof(wsl_quer=
y_eas),
> -                                                         (void *)wsl_que=
ry_eas);
> -                       } else {
> -                               rc =3D SMB2_query_info_init(tcon, server,
> -                                                         &rqst[num_rqst]=
,
> -                                                         COMPOUND_FID,
> -                                                         COMPOUND_FID,
> -                                                         FILE_FULL_EA_IN=
FORMATION,
> -                                                         SMB2_O_INFO_FIL=
E, 0,
> -                                                         SMB2_WSL_MAX_QU=
ERY_EA_RESP_SIZE,
> -                                                         sizeof(wsl_quer=
y_eas),
> -                                                         (void *)wsl_que=
ry_eas);
> -                       }
> -                       if (!rc && (!cfile || num_rqst > 1)) {
> -                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> -                               smb2_set_related(&rqst[num_rqst]);
> -                       } else if (rc) {
> +                       rc =3D SMB2_query_info_init(tcon, server,
> +                                                 &rqst[num_rqst],
> +                                                 COMP_PID(cfile), COMP_V=
ID(cfile),
> +                                                 FILE_FULL_EA_INFORMATIO=
N,
> +                                                 SMB2_O_INFO_FILE, 0,
> +                                                 SMB2_WSL_MAX_QUERY_EA_R=
ESP_SIZE,
> +                                                 sizeof(wsl_query_eas),
> +                                                 (void *)wsl_query_eas);
> +                       if (rc)
>                                 goto finished;
> -                       }
> -                       num_rqst++;
> +                       set_next_compound(tcon, cfile, i, num_cmds, rqst,=
 &num_rqst);
>                         trace_smb3_query_wsl_ea_compound_enter(xid, tcon-=
>tid,
>                                                                ses->Suid,=
 full_path);
>                         break;
> @@ -1156,7 +1041,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char =
*name,
>         cifs_i =3D CIFS_I(inode);
>         dosattrs =3D cifs_i->cifsAttrs | ATTR_READONLY;
>         data.Attributes =3D cpu_to_le32(dosattrs);
> -       cifs_get_writable_path(tcon, name, FIND_ANY, &cfile);
> +       cifs_get_writable_path(tcon, name, inode, FIND_ANY, &cfile);
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES=
,
>                              FILE_CREATE, CREATE_NOT_FILE, ACL_NO_MODE);
>         tmprc =3D smb2_compound_op(xid, tcon, cifs_sb, name,
> @@ -1332,17 +1217,20 @@ int smb2_rename_path(const unsigned int xid,
>                      const char *from_name, const char *to_name,
>                      struct cifs_sb_info *cifs_sb)
>  {
> +       struct inode *inode =3D source_dentry ? d_inode(source_dentry) : =
NULL;
>         struct cifsFileInfo *cfile;
>         __u32 co =3D file_create_options(source_dentry);
>
>         drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
> -       cifs_get_writable_path(tcon, from_name, FIND_WITH_DELETE, &cfile)=
;
> +       cifs_get_writable_path(tcon, from_name, inode,
> +                              FIND_WITH_DELETE, &cfile);
>
>         int rc =3D smb2_set_path_attr(xid, tcon, from_name, to_name, cifs=
_sb,
>                                   co, DELETE, SMB2_OP_RENAME, cfile, sour=
ce_dentry);
>         if (rc =3D=3D -EINVAL) {
>                 cifs_dbg(FYI, "invalid lease key, resending request witho=
ut lease");
> -               cifs_get_writable_path(tcon, from_name, FIND_WITH_DELETE,=
 &cfile);
> +               cifs_get_writable_path(tcon, from_name, inode,
> +                                      FIND_WITH_DELETE, &cfile);
>                 rc =3D smb2_set_path_attr(xid, tcon, from_name, to_name, =
cifs_sb,
>                                   co, DELETE, SMB2_OP_RENAME, cfile, NULL=
);
>         }
> @@ -1355,11 +1243,32 @@ int smb2_create_hardlink(const unsigned int xid,
>                          const char *from_name, const char *to_name,
>                          struct cifs_sb_info *cifs_sb)
>  {
> +       struct inode *inode =3D source_dentry ? d_inode(source_dentry) : =
NULL;
>         __u32 co =3D file_create_options(source_dentry);
> +       struct cifsFileInfo *cfile;
>
> +       if (inode) {
> +               struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> +               FILE_BASIC_INFO fi;
> +               __le32 attrs;
> +               int rc;
> +
> +               if (!test_bit(CIFS_INO_TMPFILE, &CIFS_I(inode)->flags))
> +                       goto out;
> +
> +               attrs =3D cpu_to_le32(cinode->cifsAttrs & ~ATTR_HIDDEN);
> +               fi =3D (FILE_BASIC_INFO){ .Attributes =3D attrs, };
> +               rc =3D smb2_set_file_info(inode, from_name, &fi, xid);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +out:
> +       cifs_get_writable_path(tcon, from_name, inode,
> +                              FIND_WITH_DELETE, &cfile);
>         return smb2_set_path_attr(xid, tcon, from_name, to_name,
>                                   cifs_sb, co, FILE_READ_ATTRIBUTES,
> -                                 SMB2_OP_HARDLINK, NULL, NULL);
> +                                 SMB2_OP_HARDLINK, cfile, NULL);
>  }
>
>  int
> @@ -1368,15 +1277,16 @@ smb2_set_path_size(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                    struct cifs_sb_info *cifs_sb, bool set_alloc,
>                    struct dentry *dentry)
>  {
> -       struct cifs_open_parms oparms;
> -       struct cifsFileInfo *cfile;
> -       struct kvec in_iov;
> +       struct inode *inode =3D dentry ? d_inode(dentry) : NULL;
>         __le64 eof =3D cpu_to_le64(size);
> +       struct cifs_open_parms oparms;
> +       struct cifsFileInfo *cfile;
> +       struct kvec in_iov;
>         int rc;
>
>         in_iov.iov_base =3D &eof;
>         in_iov.iov_len =3D sizeof(eof);
> -       cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile);
> +       cifs_get_writable_path(tcon, full_path, inode, FIND_ANY, &cfile);
>
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA,
>                              FILE_OPEN, 0, ACL_NO_MODE);
> @@ -1386,7 +1296,8 @@ smb2_set_path_size(const unsigned int xid, struct c=
ifs_tcon *tcon,
>                               cfile, NULL, NULL, dentry);
>         if (rc =3D=3D -EINVAL) {
>                 cifs_dbg(FYI, "invalid lease key, resending request witho=
ut lease");
> -               cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile)=
;
> +               cifs_get_writable_path(tcon, full_path,
> +                                      inode, FIND_ANY, &cfile);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb,
>                                       full_path, &oparms, &in_iov,
>                                       &(int){SMB2_OP_SET_EOF}, 1,
> @@ -1416,7 +1327,8 @@ smb2_set_file_info(struct inode *inode, const char =
*full_path,
>             (buf->LastWriteTime =3D=3D 0) && (buf->ChangeTime =3D=3D 0)) =
{
>                 if (buf->Attributes =3D=3D 0)
>                         goto out; /* would be a no op, no sense sending t=
his */
> -               cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile)=
;
> +               cifs_get_writable_path(tcon, full_path,
> +                                      inode, FIND_ANY, &cfile);
>         }
>
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRI=
BUTES,
> @@ -1475,7 +1387,7 @@ struct inode *smb2_create_reparse_inode(struct cifs=
_open_info_data *data,
>
>         if (tcon->posix_extensions) {
>                 cmds[1] =3D SMB2_OP_POSIX_QUERY_INFO;
> -               cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile)=
;
> +               cifs_get_writable_path(tcon, full_path, NULL, FIND_ANY, &=
cfile);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms,
>                                       in_iov, cmds, 2, cfile, out_iov, ou=
t_buftype, NULL);
>                 if (!rc) {
> @@ -1484,7 +1396,7 @@ struct inode *smb2_create_reparse_inode(struct cifs=
_open_info_data *data,
>                 }
>         } else {
>                 cmds[1] =3D SMB2_OP_QUERY_INFO;
> -               cifs_get_writable_path(tcon, full_path, FIND_ANY, &cfile)=
;
> +               cifs_get_writable_path(tcon, full_path, NULL, FIND_ANY, &=
cfile);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms,
>                                       in_iov, cmds, 2, cfile, out_iov, ou=
t_buftype, NULL);
>                 if (!rc) {
> @@ -1566,8 +1478,8 @@ int smb2_rename_pending_delete(const char *full_pat=
h,
>                                struct dentry *dentry,
>                                const unsigned int xid)
>  {
> -       struct cifs_sb_info *cifs_sb =3D CIFS_SB(d_inode(dentry)->i_sb);
>         struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(dentry));
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry);
>         __le16 *utf16_path __free(kfree) =3D NULL;
>         __u32 co =3D file_create_options(dentry);
>         int cmds[] =3D {
> @@ -1579,14 +1491,10 @@ int smb2_rename_pending_delete(const char *full_p=
ath,
>         char *to_name __free(kfree) =3D NULL;
>         __u32 attrs =3D cinode->cifsAttrs;
>         struct cifs_open_parms oparms;
> -       static atomic_t sillycounter;
>         struct cifsFileInfo *cfile;
>         struct tcon_link *tlink;
>         struct cifs_tcon *tcon;
>         struct kvec iov[2];
> -       const char *ppath;
> -       void *page;
> -       size_t len;
>         int rc;
>
>         tlink =3D cifs_sb_tlink(cifs_sb);
> @@ -1594,25 +1502,14 @@ int smb2_rename_pending_delete(const char *full_p=
ath,
>                 return PTR_ERR(tlink);
>         tcon =3D tlink_tcon(tlink);
>
> -       page =3D alloc_dentry_path();
> -
> -       ppath =3D build_path_from_dentry(dentry->d_parent, page);
> -       if (IS_ERR(ppath)) {
> -               rc =3D PTR_ERR(ppath);
> +       to_name =3D cifs_silly_fullpath(dentry);
> +       if (IS_ERR(to_name)) {
> +               rc =3D PTR_ERR(to_name);
> +               to_name =3D NULL;
>                 goto out;
>         }
>
> -       len =3D strlen(ppath) + strlen("/.__smb1234") + 1;
> -       to_name =3D kmalloc(len, GFP_KERNEL);
> -       if (!to_name) {
> -               rc =3D -ENOMEM;
> -               goto out;
> -       }
> -
> -       scnprintf(to_name, len, "%s%c.__smb%04X", ppath, CIFS_DIR_SEP(cif=
s_sb),
> -                 atomic_inc_return(&sillycounter) & 0xffff);
> -
> -       utf16_path =3D utf16_smb2_path(cifs_sb, to_name, len);
> +       utf16_path =3D utf16_smb2_path(cifs_sb, to_name, strlen(to_name))=
;
>         if (!utf16_path) {
>                 rc =3D -ENOMEM;
>                 goto out;
> @@ -1635,12 +1532,14 @@ int smb2_rename_pending_delete(const char *full_p=
ath,
>         iov[1].iov_base =3D utf16_path;
>         iov[1].iov_len =3D sizeof(*utf16_path) * UniStrlen((wchar_t *)utf=
16_path);
>
> -       cifs_get_writable_path(tcon, full_path, FIND_WITH_DELETE, &cfile)=
;
> +       cifs_get_writable_path(tcon, full_path, d_inode(dentry),
> +                              FIND_WITH_DELETE, &cfile);
>         rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, i=
ov,
>                               cmds, num_cmds, cfile, NULL, NULL, dentry);
>         if (rc =3D=3D -EINVAL) {
>                 cifs_dbg(FYI, "invalid lease key, resending request witho=
ut lease\n");
> -               cifs_get_writable_path(tcon, full_path, FIND_WITH_DELETE,=
 &cfile);
> +               cifs_get_writable_path(tcon, full_path, d_inode(dentry),
> +                                      FIND_WITH_DELETE, &cfile);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms, iov,
>                                       cmds, num_cmds, cfile, NULL, NULL, =
NULL);
>         }
> @@ -1653,6 +1552,5 @@ int smb2_rename_pending_delete(const char *full_pat=
h,
>         }
>  out:
>         cifs_put_tlink(tlink);
> -       free_dentry_path(page);
>         return rc;
>  }
> --
> 2.53.0
>


--=20
Thanks,

Steve
