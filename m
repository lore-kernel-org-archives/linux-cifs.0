Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199411E519;
	Mon,  7 Oct 2024 04:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728275325; cv=none; b=UIRf8QkCYmPfVcm5jY3HP3LpuoqnZj5HPXEebroVsw/9nIhHtgd95LLY/k2YeX7Rp0VPMvPm5KHJ95eOKR69UJBD7h8I+5wMSd4uNAUMG+8pnQ5DoizfeNObQEmOUORmOarOg10Ehtw0Ml0MZK1EmX09a4D4HNRE4iRULa02kJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728275325; c=relaxed/simple;
	bh=gKiiInaPozhGEl1m4SZsye59JMDbT6v/Zizb1HQ2NpM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RDGI5XN1w52be7iYKoXysI6lw/gL9vXA0mSmyDTUWW/QoW31kFhRD6UW04Fd2xGLcJRQH65Z1h5lfYwzOFq0xmkQtcL611tBdJnFwgDegW8l7crObIKKwlgJnyLfWKAeTkMcCoq9BWhItPhJOCRyE8KUkVW5aFAV3edKNehD/eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LpCPm/F5; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpCPm/F5"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fabc9bc5dfso43629711fa.0;
        Sun, 06 Oct 2024 21:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728275321; x=1728880121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mv7YoacoCBiM9nVT/cJZXxWRLJzrPv+EAn1e7OdZvKE=;
        b=LpCPm/F5Sh4QplzQ1LxwEuudB2JI9MW4GzIleXZmSH1tSuPpXKuxWBh5uUv4du0lJA
         0JRQLCUe2wgd7huF1faseu5KL39j9aBfVflUuWaA2LcMC12y0WkW4giqj0VBfuP8UxcA
         dFw92+A0Xdjq3SmfMfXDOLONPzep/1kuqEUSVtoFh5LBwMLAIa79FX85WKsHuTAUOVVq
         uu1WYSyWAUxSC+u5tQZ3adaTR/GLek1QJrDv19G9A3TMBHwnNPTpm4jw47UOsbY8/RTy
         QLQ//V5M/lXimW73LxLVL26OgERD7aXg8h3+E1/uutInQpvoW3UjHvCHy8UOwgOE+YUt
         HzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728275321; x=1728880121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mv7YoacoCBiM9nVT/cJZXxWRLJzrPv+EAn1e7OdZvKE=;
        b=vwcjSEsD1ckuO15ZwpTngd11CGtWJmR2m20dVvNMz0qNbQ3ZlWfhYtS7IauzxMCYFH
         a8hMz/fIOBj9FPYRJkNWZVjfGGvNxGA6NhgN3VczfE3+uWQ1ipLNLpFv1fhLXZ0KVcB6
         vFJBvJoy36aXkGMksqry7tnaZeI4R5aiVSJQ1VCQUh/8EXjar/9MKiRSI3w05uyvIRxa
         B0d+brLQXpBStK2WiPcYs9NQmzL39RtgoFHsKxcARoa/M5v/gakwhAJ/xk6qUB92/7MC
         UYUjmspOs9yL2NlIYqE9NwGK/5jx5KOnduUdnaRXg7sEs8bGxfp2WlFah3n4dOm96vXN
         HLMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx/3kB37LmoMOJwrw4NUIF71TakAvCtcZ662ZzdHgJY4pGQi4k5ysmpn91VANv+b/jD7zJJ2h7a86uL4+h@vger.kernel.org, AJvYcCXWRPX8i4zSKnKDBQHvL+lpjdFbimzWDbc2wXXQMv5BH5NfGtzGTKJUyQjLIMD7jZ82W1egevgUGdFK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5H9LcWRH9+cg1CrbW3FkFv4mE28QKwgdO4bXVGnsgg+G/u6WF
	RZMtxPoHZy87b8AW6xmvP1N3aMdiziNEAQNKwh6ZVIfb/AGhyHisVREhYpbtXKqfbp1txsqJMam
	zpSFezi5kxposFEsK7JsXt4pDmQWpkFrf
X-Google-Smtp-Source: AGHT+IHRLKfxS0xPT/7AJUK+uF1+CKJyyV5wcMOuQG5AhM+2HKG6TVrsfS2+w/j146wWJamATzpO2aFdzP7UEaopzNY=
X-Received: by 2002:a05:6512:23a0:b0:530:ae22:a6f0 with SMTP id
 2adb3069b0e04-539ab84e575mr4616504e87.5.1728275320924; Sun, 06 Oct 2024
 21:28:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006100046.30772-1-pali@kernel.org> <20241006100046.30772-2-pali@kernel.org>
In-Reply-To: <20241006100046.30772-2-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 6 Oct 2024 23:28:29 -0500
Message-ID: <CAH2r5muLa_0L5LL4ipQkzEHOUdtYtJVAD29AAjQOaun9dWmK0g@mail.gmail.com>
Subject: Re: [PATCH 1/7] cifs: Add mount option -o reparse=native
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is a good point about how to override the "native" symlink format
when using reparse=3Dnfs  (a similar question could come up, if for
security reasons you use "mfsymlinks" for symlinks - ie "client side
symlinks" (which are safer) - but use reparse=3Dnfs for everything else.
  But ... there is probably a better way to handle the mount option
for default symlink creation format more clearly (perhaps use of
"nativesymlinks" (default) or "mfsymlinks" if specified, overrides
"reparse=3Dwsl" or "reparse=3Dnfs" for symlink format only.   User can
specify "nativesymlinks=3Dno" if they want to use the "reparse=3D" format
for symlinks.   For the sfu case it might be trickier but could fall
back to sfu symlinks if "nativesymlinks=3Dno" or if they fail?!
Thoughts?

On Sun, Oct 6, 2024 at 5:01=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> Currently the default option is -o reparse=3Ddefault which is same as
> -o reparse=3Dnfs. Currently mount option -o reparse=3Dnfs does not create
> symlink in NFS reparse point style, which is misleading.
>
> Add new -o reparse=3D options "native", "native+nfs" and "native+wsl" to =
make
> it more clear and allow to choose the expected reparse point types.
>
> "native" would mean to create new special files only with reparse point
> tags which are natively supported by SMB or Windows. Types which are not
> natively supported cannot be created.
>
> "native+nfs" would mean same as native, but fallback to "nfs" for
> unsupported types.
>
> "native+wsl" would mean to fallback to "wsl".
>
> Change also meaning of "nfs" and "wsl" to always create special types wit=
h
> nfs / wsl style.
>
> And change also the default option to "native+nfs", so the default behavi=
or
> stay same as without this change. Without this change were all symlinks
> created in native Windows/SMB form and this stay same with this change to=
o.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifsglob.h   | 15 ++++++++--
>  fs/smb/client/fs_context.c | 12 ++++++++
>  fs/smb/client/fs_context.h |  3 ++
>  fs/smb/client/reparse.c    | 58 +++++++++++++++++++++++++++++++-------
>  fs/smb/client/reparse.h    |  2 ++
>  5 files changed, 77 insertions(+), 13 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 260b553283ef..367f0ac6400d 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -154,14 +154,23 @@ enum securityEnum {
>  };
>
>  enum cifs_reparse_type {
> -       CIFS_REPARSE_TYPE_NFS,
> -       CIFS_REPARSE_TYPE_WSL,
> -       CIFS_REPARSE_TYPE_DEFAULT =3D CIFS_REPARSE_TYPE_NFS,
> +       CIFS_REPARSE_TYPE_NATIVE, /* native symlinks only */
> +       CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks, nfs for oth=
ers */
> +       CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks, wsl for oth=
ers */
> +       CIFS_REPARSE_TYPE_NFS, /* nfs for everything */
> +       CIFS_REPARSE_TYPE_WSL, /* wsl for everything */
> +       CIFS_REPARSE_TYPE_DEFAULT =3D CIFS_REPARSE_TYPE_NATIVE_NFS,
>  };
>
>  static inline const char *cifs_reparse_type_str(enum cifs_reparse_type t=
ype)
>  {
>         switch (type) {
> +       case CIFS_REPARSE_TYPE_NATIVE:
> +               return "native";
> +       case CIFS_REPARSE_TYPE_NATIVE_NFS:
> +               return "native+nfs";
> +       case CIFS_REPARSE_TYPE_NATIVE_WSL:
> +               return "native+wsl";
>         case CIFS_REPARSE_TYPE_NFS:
>                 return "nfs";
>         case CIFS_REPARSE_TYPE_WSL:
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 22b550860cc8..e5de84912e3d 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -303,6 +303,9 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *=
value, struct smb3_fs_conte
>
>  static const match_table_t reparse_flavor_tokens =3D {
>         { Opt_reparse_default,  "default" },
> +       { Opt_reparse_native,   "native" },
> +       { Opt_reparse_native_nfs, "native+nfs" },
> +       { Opt_reparse_native_wsl, "native+wsl" },
>         { Opt_reparse_nfs,      "nfs" },
>         { Opt_reparse_wsl,      "wsl" },
>         { Opt_reparse_err,      NULL },
> @@ -317,6 +320,15 @@ static int parse_reparse_flavor(struct fs_context *f=
c, char *value,
>         case Opt_reparse_default:
>                 ctx->reparse_type =3D CIFS_REPARSE_TYPE_DEFAULT;
>                 break;
> +       case Opt_reparse_native:
> +               ctx->reparse_type =3D CIFS_REPARSE_TYPE_NATIVE;
> +               break;
> +       case Opt_reparse_native_nfs:
> +               ctx->reparse_type =3D CIFS_REPARSE_TYPE_NATIVE_NFS;
> +               break;
> +       case Opt_reparse_native_wsl:
> +               ctx->reparse_type =3D CIFS_REPARSE_TYPE_NATIVE_WSL;
> +               break;
>         case Opt_reparse_nfs:
>                 ctx->reparse_type =3D CIFS_REPARSE_TYPE_NFS;
>                 break;
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 8dd12498ffd8..1011176ba3b7 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -43,6 +43,9 @@ enum {
>
>  enum cifs_reparse_parm {
>         Opt_reparse_default,
> +       Opt_reparse_native,
> +       Opt_reparse_native_nfs,
> +       Opt_reparse_native_wsl,
>         Opt_reparse_nfs,
>         Opt_reparse_wsl,
>         Opt_reparse_err
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 6e9d914bac41..38fe0a710c65 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -14,6 +14,20 @@
>  #include "fs_context.h"
>  #include "reparse.h"
>
> +static int mknod_nfs(unsigned int xid, struct inode *inode,
> +                    struct dentry *dentry, struct cifs_tcon *tcon,
> +                    const char *full_path, umode_t mode, dev_t dev,
> +                    const char *symname);
> +
> +static int mknod_wsl(unsigned int xid, struct inode *inode,
> +                    struct dentry *dentry, struct cifs_tcon *tcon,
> +                    const char *full_path, umode_t mode, dev_t dev,
> +                    const char *symname);
> +
> +static int create_native_symlink(const unsigned int xid, struct inode *i=
node,
> +                                struct dentry *dentry, struct cifs_tcon =
*tcon,
> +                                const char *full_path, const char *symna=
me);
> +
>  static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
>                                            const unsigned int xid,
>                                            const char *full_path,
> @@ -23,6 +37,26 @@ static int detect_directory_symlink_target(struct cifs=
_sb_info *cifs_sb,
>  int smb2_create_reparse_symlink(const unsigned int xid, struct inode *in=
ode,
>                                 struct dentry *dentry, struct cifs_tcon *=
tcon,
>                                 const char *full_path, const char *symnam=
e)
> +{
> +       struct smb3_fs_context *ctx =3D CIFS_SB(inode->i_sb)->ctx;
> +
> +       switch (ctx->reparse_type) {
> +       case CIFS_REPARSE_TYPE_NATIVE:
> +       case CIFS_REPARSE_TYPE_NATIVE_NFS:
> +       case CIFS_REPARSE_TYPE_NATIVE_WSL:
> +               return create_native_symlink(xid, inode, dentry, tcon, fu=
ll_path, symname);
> +       case CIFS_REPARSE_TYPE_NFS:
> +               return mknod_nfs(xid, inode, dentry, tcon, full_path, S_I=
FLNK, 0, symname);
> +       case CIFS_REPARSE_TYPE_WSL:
> +               return mknod_wsl(xid, inode, dentry, tcon, full_path, S_I=
FLNK, 0, symname);
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +static int create_native_symlink(const unsigned int xid, struct inode *i=
node,
> +                                struct dentry *dentry, struct cifs_tcon =
*tcon,
> +                                const char *full_path, const char *symna=
me)
>  {
>         struct reparse_symlink_data_buffer *buf =3D NULL;
>         struct cifs_open_info_data data =3D {};
> @@ -363,6 +397,7 @@ static int nfs_set_reparse_buf(struct reparse_posix_d=
ata *buf,
>         case NFS_SPECFILE_SOCK:
>                 dlen =3D 0;
>                 break;
> +       case NFS_SPECFILE_LNK: /* TODO: add support for NFS symlinks */
>         default:
>                 return -EOPNOTSUPP;
>         }
> @@ -381,7 +416,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_d=
ata *buf,
>
>  static int mknod_nfs(unsigned int xid, struct inode *inode,
>                      struct dentry *dentry, struct cifs_tcon *tcon,
> -                    const char *full_path, umode_t mode, dev_t dev)
> +                    const char *full_path, umode_t mode, dev_t dev,
> +                    const char *symname)
>  {
>         struct cifs_open_info_data data;
>         struct reparse_posix_data *p;
> @@ -421,6 +457,7 @@ static int wsl_set_reparse_buf(struct reparse_data_bu=
ffer *buf,
>         case IO_REPARSE_TAG_LX_FIFO:
>         case IO_REPARSE_TAG_AF_UNIX:
>                 break;
> +       case IO_REPARSE_TAG_LX_SYMLINK: /* TODO: add support for WSL syml=
inks */
>         default:
>                 return -EOPNOTSUPP;
>         }
> @@ -518,7 +555,8 @@ static int wsl_set_xattrs(struct inode *inode, umode_=
t _mode,
>
>  static int mknod_wsl(unsigned int xid, struct inode *inode,
>                      struct dentry *dentry, struct cifs_tcon *tcon,
> -                    const char *full_path, umode_t mode, dev_t dev)
> +                    const char *full_path, umode_t mode, dev_t dev,
> +                    const char *symname)
>  {
>         struct cifs_open_info_data data;
>         struct reparse_data_buffer buf;
> @@ -563,17 +601,17 @@ int smb2_mknod_reparse(unsigned int xid, struct ino=
de *inode,
>                        const char *full_path, umode_t mode, dev_t dev)
>  {
>         struct smb3_fs_context *ctx =3D CIFS_SB(inode->i_sb)->ctx;
> -       int rc =3D -EOPNOTSUPP;
>
>         switch (ctx->reparse_type) {
> +       case CIFS_REPARSE_TYPE_NATIVE_NFS:
>         case CIFS_REPARSE_TYPE_NFS:
> -               rc =3D mknod_nfs(xid, inode, dentry, tcon, full_path, mod=
e, dev);
> -               break;
> +               return mknod_nfs(xid, inode, dentry, tcon, full_path, mod=
e, dev, NULL);
> +       case CIFS_REPARSE_TYPE_NATIVE_WSL:
>         case CIFS_REPARSE_TYPE_WSL:
> -               rc =3D mknod_wsl(xid, inode, dentry, tcon, full_path, mod=
e, dev);
> -               break;
> +               return mknod_wsl(xid, inode, dentry, tcon, full_path, mod=
e, dev, NULL);
> +       default:
> +               return -EOPNOTSUPP;
>         }
> -       return rc;
>  }
>
>  /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
> @@ -848,7 +886,7 @@ int smb2_parse_native_symlink(char **target, const ch=
ar *buf, unsigned int len,
>         return rc;
>  }
>
> -static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym=
,
> +static int parse_reparse_native_symlink(struct reparse_symlink_data_buff=
er *sym,
>                                  u32 plen, bool unicode,
>                                  struct cifs_sb_info *cifs_sb,
>                                  const char *full_path,
> @@ -936,7 +974,7 @@ int parse_reparse_point(struct reparse_data_buffer *b=
uf,
>                 return parse_reparse_posix((struct reparse_posix_data *)b=
uf,
>                                            cifs_sb, data);
>         case IO_REPARSE_TAG_SYMLINK:
> -               return parse_reparse_symlink(
> +               return parse_reparse_native_symlink(
>                         (struct reparse_symlink_data_buffer *)buf,
>                         plen, unicode, cifs_sb, full_path, data);
>         case IO_REPARSE_TAG_LX_SYMLINK:
> diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
> index eb6854e65e08..a6bdf20ce1b0 100644
> --- a/fs/smb/client/reparse.h
> +++ b/fs/smb/client/reparse.h
> @@ -61,6 +61,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info =
*cifs_sb,
>  static inline u64 reparse_mode_nfs_type(mode_t mode)
>  {
>         switch (mode & S_IFMT) {
> +       case S_IFLNK: return NFS_SPECFILE_LNK;
>         case S_IFBLK: return NFS_SPECFILE_BLK;
>         case S_IFCHR: return NFS_SPECFILE_CHR;
>         case S_IFIFO: return NFS_SPECFILE_FIFO;
> @@ -72,6 +73,7 @@ static inline u64 reparse_mode_nfs_type(mode_t mode)
>  static inline u32 reparse_mode_wsl_tag(mode_t mode)
>  {
>         switch (mode & S_IFMT) {
> +       case S_IFLNK: return IO_REPARSE_TAG_LX_SYMLINK;
>         case S_IFBLK: return IO_REPARSE_TAG_LX_BLK;
>         case S_IFCHR: return IO_REPARSE_TAG_LX_CHR;
>         case S_IFIFO: return IO_REPARSE_TAG_LX_FIFO;
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
