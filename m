Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B398B39AF4;
	Mon,  7 Oct 2024 03:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728273576; cv=none; b=cTWclgzkjUeTIZl4kvG+eA0DGY4tX6mtKnNEl+wF5pa2DjOoupgkwbP91+K6uqtJKA8ITiVEFVa7saJfDkgOrK/2TOw0AavgdVUm/be3fcHzI4ba6FhkXdSnDFLvUYr2/Chj5+8dntN5Ek/pH9lLUZO1KBrd3UkuhBNvjEpZ84o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728273576; c=relaxed/simple;
	bh=nMhdB+C2xi2SknIpWnFRhhMCTv9coUiMVxwQWY/2dCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q7HP6HJtutOniDExgLoGtw8tLPTfNR/uKSmDPdf6uWQEoD4+EaW04+GOkdTD1QQGke8LZM4O/vVaXu0vdA0euT8kedwDanfSOpl9dpm0pRw4OEqCdnPjBBmC8nBhvWZ4MP/cafHb74bIcjYkbbdCq/rZnHGXIAqwfrI1p0k/tA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBlH9TRt; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBlH9TRt"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5398e3f43f3so4481592e87.2;
        Sun, 06 Oct 2024 20:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728273572; x=1728878372; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aa/FZhs19hsaSM6Vz7PSTMThGiOXhNDxdzf3yxlYC6w=;
        b=KBlH9TRtJ3vFrFuyqvQiFYpzOSXNFdaixH5gXsWyv8T2dzLpqmsTSmxVxJpkWJo2a2
         i7IFSvNuuWbJEO6EHjV4ZR0ix2RhlDxt4qSk2jGkE2olRutGYGBpmPqZRC7RDZF063QU
         WRo9V2yks12LffXFQH+erBYtNa7qtSC8AE8xI4sbqvL9Kp3z3G/TD5m/tteSlIGoT2sc
         BIRVqPposcqKk/KYbBRLDX87K1gp8r3f/hKP1mMtJ153W/Q8HW80Nob4N6GC5SLPCr/v
         vgCk1/ONITEj9IwDIxveb1UqgBlYPlsmQ7I8X2bK39qSG1m9aAilD8G7jMzd3j2tTwBy
         NfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728273572; x=1728878372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aa/FZhs19hsaSM6Vz7PSTMThGiOXhNDxdzf3yxlYC6w=;
        b=JNzZ/+jLLLZODAXP0rdtb5uN2Sh75VLyR9iFmsh2GnR8h9foDSqBCqAxxzxsy8vfQq
         ZyrndZ4T/wSra5rDdxVqPMCqboGNeeSXKK3kr9NCcLbafARHLz6ab7xtI8hgGPGH7KF6
         VPqBgFmuQMPT4WV6GWtGQGKNi4ptzxrIPIGMoD/OnPb+1gRAQ1H3xglV5cAX6rq5xhQj
         mb1GJhDTHQeZ3xtF0hlvdJUBCam2X/UNz2PUlVQHEMLdLPh8mvd3roJYHx79xsDtrGn1
         V3VnqjKvAF0qzl45B4AsYVIbhyy+yNTduvKdPvONPyUcpQOP2AqRIqylKh5UImNMxUU6
         AfSw==
X-Forwarded-Encrypted: i=1; AJvYcCWJHQ0b8VUhNrk72dNb+fkJZtX8NmBXY5dWi0tsQBG7n3/Hh6zNnaSMaxlgU5RzNkjg04useUhEpYQNz5tX@vger.kernel.org, AJvYcCWWMtf1nDDIWb+fM61f6kw2GTOTenq8EEp9FRgSbof36uobZYG/qe5J1chl6PL3pto6zjHa7x4jaT0X@vger.kernel.org
X-Gm-Message-State: AOJu0YyU02XFdXXHEXsUm9kMdm/Q2OJl0NNwtpupIaelQzFcrjsSOQlL
	mWzABspCFX2V8kJRbJNbQ7mH8Nc5vCS/aVSFgt6mBVoQmaEpGwmkwPRvXoUYxJZ2hRJJedeSY8j
	7fiC7th6PTCSaIwNcCEV059YUsFboyaSk
X-Google-Smtp-Source: AGHT+IEYz5fSHf0URDfLIIxinz54wmQ+EORvJqbpOKAMcGbRT091wxzbYW+kAcnthtOvsKsQlRCnD7ejYYVKjBeMSTk=
X-Received: by 2002:a05:6512:b09:b0:52c:ebd0:609 with SMTP id
 2adb3069b0e04-539ab84e067mr4418430e87.7.1728273571165; Sun, 06 Oct 2024
 20:59:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20241005140300.19416-1-pali@kernel.org>
 <20241005140300.19416-7-pali@kernel.org>
In-Reply-To: <20241005140300.19416-7-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 6 Oct 2024 22:59:18 -0500
Message-ID: <CAH2r5mtCCSY0eLARtzi4LZF3tCmPec7DSJ=h47h09fo--_D49g@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] cifs: Fix creating and resolving absolute NT-style symlinks
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch had a merge conflict in fs_context.h and wouldn't apply
cleanly.   Do you have a git branch with this series (or all three
recent patch series) applied on 6.12-rc2?

On Sat, Oct 5, 2024 at 9:04=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> If the SMB symlink is stored on NT server in absolute form then it points
> to the NT object hierarchy, which is different from POSIX one and needs
> some conversion / mapping.
>
> To make interoperability with Windows SMB server and WSL subsystem, reuse
> its logic of mapping between NT paths and POSIX paths into Linux SMB
> client.
>
> WSL subsystem on Windows uses for -t drvfs mount option -o symlinkroot=3D
> which specifies the POSIX path where are expected to be mounted lowercase
> Windows drive letters (without colon).
>
> Do same for Linux SMB client and add a new mount option -o symlinkroot=3D
> which mimics the drvfs mount option of the same name. It specifies where =
in
> the Linux VFS hierarchy is the root of the DOS / Windows drive letters, a=
nd
> translates between absolute NT-style symlinks and absolute Linux VFS
> symlinks. Default value of symlinkroot is "/mnt", same what is using WSL.
>
> Note that DOS / Windows drive letter symlinks are just subset of all
> possible NT-style symlinks. Drive letters live in NT subtree \??\ and
> important details about NT paths and object hierarchy are in the comments
> in this change.
>
> When symlink target location from non-POSIX SMB server is in absolute for=
m
> (indicated by absence of SYMLINK_FLAG_RELATIVE) then it is converted to
> Linux absolute symlink according to symlinkroot configuration.
>
> And when creating a new symlink on non-POSIX SMB server in absolute form
> then Linux absolute target is converted to NT-style according to
> symlinkroot configuration.
>
> When SMB server is POSIX, then this change does not affect neither readin=
g
> target location of symlink, nor creating a new symlink. It is expected th=
at
> POSIX SMB server works with POSIX paths where the absolute root is /.
>
> This change improves interoperability of absolute SMB symlinks with Windo=
ws
> SMB servers.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/fs_context.c |  22 +++
>  fs/smb/client/fs_context.h |   2 +
>  fs/smb/client/reparse.c    | 267 ++++++++++++++++++++++++++++++++++---
>  3 files changed, 273 insertions(+), 18 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 2f0c3894b0f7..22b550860cc8 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -178,6 +178,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] =
=3D {
>         fsparam_string("sec", Opt_sec),
>         fsparam_string("cache", Opt_cache),
>         fsparam_string("reparse", Opt_reparse),
> +       fsparam_string("symlinkroot", Opt_symlinkroot),
>
>         /* Arguments that should be ignored */
>         fsparam_flag("guest", Opt_ignore),
> @@ -355,6 +356,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, =
struct smb3_fs_context *ctx
>         new_ctx->source =3D NULL;
>         new_ctx->iocharset =3D NULL;
>         new_ctx->leaf_fullpath =3D NULL;
> +       new_ctx->symlinkroot =3D NULL;
>         /*
>          * Make sure to stay in sync with smb3_cleanup_fs_context_content=
s()
>          */
> @@ -369,6 +371,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, =
struct smb3_fs_context *ctx
>         DUP_CTX_STR(nodename);
>         DUP_CTX_STR(iocharset);
>         DUP_CTX_STR(leaf_fullpath);
> +       DUP_CTX_STR(symlinkroot);
>
>         return 0;
>  }
> @@ -1614,9 +1617,26 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>                 if (parse_reparse_flavor(fc, param->string, ctx))
>                         goto cifs_parse_mount_err;
>                 break;
> +       case Opt_symlinkroot:
> +               if (param->string[0] !=3D '/') {
> +                       cifs_errorf(fc, "symlinkroot mount options must b=
e absolute path\n");
> +                       goto cifs_parse_mount_err;
> +               }
> +               kfree(ctx->symlinkroot);
> +               ctx->symlinkroot =3D kstrdup(param->string, GFP_KERNEL);
> +               if (!ctx->symlinkroot)
> +                       goto cifs_parse_mount_err;
> +               break;
>         }
>         /* case Opt_ignore: - is ignored as expected ... */
>
> +       /*
> +        * By default resolve all native absolute symlinks relative to "/=
mnt/".
> +        * Same default has drvfs driver running in WSL for resolving SMB=
 shares.
> +        */
> +       if (!ctx->symlinkroot)
> +               ctx->symlinkroot =3D kstrdup("/mnt/", GFP_KERNEL);
> +
>         return 0;
>
>   cifs_parse_mount_err:
> @@ -1747,6 +1767,8 @@ smb3_cleanup_fs_context_contents(struct smb3_fs_con=
text *ctx)
>         ctx->prepath =3D NULL;
>         kfree(ctx->leaf_fullpath);
>         ctx->leaf_fullpath =3D NULL;
> +       kfree(ctx->symlinkroot);
> +       ctx->symlinkroot =3D NULL;
>  }
>
>  void
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index cf577ec0dd0a..8dd12498ffd8 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -157,6 +157,7 @@ enum cifs_param {
>         Opt_sec,
>         Opt_cache,
>         Opt_reparse,
> +       Opt_symlinkroot,
>
>         /* Mount options to be ignored */
>         Opt_ignore,
> @@ -284,6 +285,7 @@ struct smb3_fs_context {
>         struct cifs_ses *dfs_root_ses;
>         bool dfs_automount:1; /* set for dfs automount only */
>         enum cifs_reparse_type reparse_type;
> +       char *symlinkroot; /* top level directory for native SMB symlinks=
 in absolute format */
>  };
>
>  extern const struct fs_parameter_spec smb3_fs_parameters[];
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index fb1d16b17f38..a577b2d2a4fc 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -25,33 +25,128 @@ int smb2_create_reparse_symlink(const unsigned int x=
id, struct inode *inode,
>                                 const char *full_path, const char *symnam=
e)
>  {
>         struct reparse_symlink_data_buffer *buf =3D NULL;
> -       struct cifs_open_info_data data;
> +       struct cifs_open_info_data data =3D {};
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>         struct inode *new;
>         struct kvec iov;
> -       __le16 *path;
> +       __le16 *path =3D NULL;
>         bool directory;
> -       char *sym, sep =3D CIFS_DIR_SEP(cifs_sb);
> -       u16 len, plen;
> +       char *symlink_target =3D NULL;
> +       char *sym =3D NULL;
> +       char sep =3D CIFS_DIR_SEP(cifs_sb);
> +       u16 len, plen, poff, slen;
>         int rc =3D 0;
>
> -       sym =3D kstrdup(symname, GFP_KERNEL);
> -       if (!sym)
> -               return -ENOMEM;
> +       symlink_target =3D kstrdup(symname, GFP_KERNEL);
> +       if (!symlink_target) {
> +               rc =3D -ENOMEM;
> +               goto out;
> +       }
>
>         data =3D (struct cifs_open_info_data) {
>                 .reparse_point =3D true,
>                 .reparse =3D { .tag =3D IO_REPARSE_TAG_SYMLINK, },
> -               .symlink_target =3D sym,
> +               .symlink_target =3D symlink_target,
>         };
>
> -       convert_delimiter(sym, sep);
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symnam=
e[0] =3D=3D '/') {
> +               /*
> +                * This is a request to create an absolute symlink on the=
 server
> +                * which does not support POSIX paths, and expects symlin=
k in
> +                * NT-style path. So convert absolute Linux symlink targe=
t path
> +                * to the absolute NT-style path. Root of the NT-style pa=
th for
> +                * symlinks is specified in "symlinkroot" mount option. T=
his will
> +                * ensure compatibility of this symlink stored in absolut=
e form
> +                * on the SMB server.
> +                */
> +               if (!strstarts(symname, cifs_sb->ctx->symlinkroot)) {
> +                       /*
> +                        * If the absolute Linux symlink target path is n=
ot
> +                        * inside "symlinkroot" location then there is no=
 way
> +                        * to convert such Linux symlink to NT-style path=
.
> +                        */
> +                       cifs_dbg(VFS,
> +                                "absolute symlink '%s' cannot be convert=
ed to NT format "
> +                                "because it is outside of symlinkroot=3D=
'%s'\n",
> +                                symname, cifs_sb->ctx->symlinkroot);
> +                       rc =3D -EINVAL;
> +                       goto out;
> +               }
> +               len =3D strlen(cifs_sb->ctx->symlinkroot);
> +               if (cifs_sb->ctx->symlinkroot[len-1] !=3D '/')
> +                       len++;
> +               if (symname[len] >=3D 'a' && symname[len] <=3D 'z' &&
> +                   (symname[len+1] =3D=3D '/' || symname[len+1] =3D=3D '=
\0')) {
> +                       /*
> +                        * Symlink points to Linux target /symlinkroot/x/=
path/...
> +                        * where 'x' is the lowercase local Windows drive=
.
> +                        * NT-style path for 'x' has common form \??\X:\p=
ath\...
> +                        * with uppercase local Windows drive.
> +                        */
> +                       int common_path_len =3D strlen(symname+len+1)+1;
> +                       sym =3D kzalloc(6+common_path_len, GFP_KERNEL);
> +                       if (!sym) {
> +                               rc =3D -ENOMEM;
> +                               goto out;
> +                       }
> +                       memcpy(sym, "\\??\\", 4);
> +                       sym[4] =3D symname[len] - ('a'-'A');
> +                       sym[5] =3D ':';
> +                       memcpy(sym+6, symname+len+1, common_path_len);
> +               } else {
> +                       /* Unhandled absolute symlink. Report an error. *=
/
> +                       cifs_dbg(
> +                                VFS,
> +                                "absolute symlink '%s' cannot be convert=
ed to NT format "
> +                                "because it points to unknown target\n",
> +                                symname);
> +                       rc =3D -EINVAL;
> +                       goto out;
> +               }
> +       } else {
> +               /*
> +                * This is request to either create an absolute symlink o=
n
> +                * server which expects POSIX paths or it is an request t=
o
> +                * create a relative symlink from the current directory.
> +                * These paths have same format as relative SMB symlinks,
> +                * so no conversion is needed. So just take symname as-is=
.
> +                */
> +               sym =3D kstrdup(symname, GFP_KERNEL);
> +               if (!sym) {
> +                       rc =3D -ENOMEM;
> +                       goto out;
> +               }
> +       }
> +
> +       if (sep =3D=3D '\\')
> +               convert_delimiter(sym, sep);
> +
> +       /*
> +        * For absolute NT symlinks it is required to pass also leading
> +        * backslash and to not mangle NT object prefix "\\??\\" and not =
to
> +        * mangle colon in drive letter. But cifs_convert_path_to_utf16()
> +        * removes leading backslash and replaces '?' and ':'. So tempora=
ry
> +        * mask these characters in NT object prefix by '_' and then chan=
ge
> +        * them back.
> +        */
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symnam=
e[0] =3D=3D '/')
> +               sym[0] =3D sym[1] =3D sym[2] =3D sym[5] =3D '_';
> +
>         path =3D cifs_convert_path_to_utf16(sym, cifs_sb);
>         if (!path) {
>                 rc =3D -ENOMEM;
>                 goto out;
>         }
>
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symnam=
e[0] =3D=3D '/') {
> +               sym[0] =3D '\\';
> +               sym[1] =3D sym[2] =3D '?';
> +               sym[5] =3D ':';
> +               path[0] =3D '\\';
> +               path[1] =3D path[2] =3D '?';
> +               path[5] =3D ':';
> +       }
> +
>         /*
>          * SMB distinguish between symlink to directory and symlink to fi=
le.
>          * They cannot be exchanged (symlink of file type which points to
> @@ -64,8 +159,18 @@ int smb2_create_reparse_symlink(const unsigned int xi=
d, struct inode *inode,
>         if (rc < 0)
>                 goto out;
>
> -       plen =3D 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
> -       len =3D sizeof(*buf) + plen * 2;
> +       slen =3D 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
> +       poff =3D 0;
> +       plen =3D slen;
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symnam=
e[0] =3D=3D '/') {
> +               /*
> +                * For absolute NT symlinks skip leading "\\??\\" in Prin=
tName as
> +                * PrintName is user visible location in DOS/Win32 format=
 (not in NT format).
> +                */
> +               poff =3D 4;
> +               plen -=3D 2 * poff;
> +       }
> +       len =3D sizeof(*buf) + plen + slen;
>         buf =3D kzalloc(len, GFP_KERNEL);
>         if (!buf) {
>                 rc =3D -ENOMEM;
> @@ -74,17 +179,17 @@ int smb2_create_reparse_symlink(const unsigned int x=
id, struct inode *inode,
>
>         buf->ReparseTag =3D cpu_to_le32(IO_REPARSE_TAG_SYMLINK);
>         buf->ReparseDataLength =3D cpu_to_le16(len - sizeof(struct repars=
e_data_buffer));
> +
>         buf->SubstituteNameOffset =3D cpu_to_le16(plen);
> -       buf->SubstituteNameLength =3D cpu_to_le16(plen);
> -       memcpy(&buf->PathBuffer[plen], path, plen);
> +       buf->SubstituteNameLength =3D cpu_to_le16(slen);
> +       memcpy(&buf->PathBuffer[plen], path, slen);
> +
>         buf->PrintNameOffset =3D 0;
>         buf->PrintNameLength =3D cpu_to_le16(plen);
> -       memcpy(buf->PathBuffer, path, plen);
> +       memcpy(buf->PathBuffer, path+poff, plen);
> +
>         buf->Flags =3D cpu_to_le32(*symname !=3D '/' ? SYMLINK_FLAG_RELAT=
IVE : 0);
> -       if (*sym !=3D sep)
> -               buf->Flags =3D cpu_to_le32(SYMLINK_FLAG_RELATIVE);
>
> -       convert_delimiter(sym, '/');
>         iov.iov_base =3D buf;
>         iov.iov_len =3D len;
>         new =3D smb2_get_reparse_inode(&data, inode->i_sb, xid,
> @@ -95,6 +200,7 @@ int smb2_create_reparse_symlink(const unsigned int xid=
, struct inode *inode,
>         else
>                 rc =3D PTR_ERR(new);
>  out:
> +       kfree(sym);
>         kfree(path);
>         cifs_free_open_info(&data);
>         kfree(buf);
> @@ -540,6 +646,9 @@ int smb2_parse_native_symlink(char **target, const ch=
ar *buf, unsigned int len,
>         char sep =3D CIFS_DIR_SEP(cifs_sb);
>         char *linux_target =3D NULL;
>         char *smb_target =3D NULL;
> +       int symlinkroot_len;
> +       int abs_path_len;
> +       char *abs_path;
>         int levels;
>         int rc;
>         int i;
> @@ -569,7 +678,123 @@ int smb2_parse_native_symlink(char **target, const =
char *buf, unsigned int len,
>                 goto out;
>         }
>
> -       if (smb_target[0] =3D=3D sep && relative) {
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && !relat=
ive) {
> +               /*
> +                * This is an absolute symlink from the server which does=
 not
> +                * support POSIX paths, so the symlink is in NT-style pat=
h.
> +                * So convert it to absolute Linux symlink target path. R=
oot of
> +                * the NT-style path for symlinks is specified in "symlin=
kroot"
> +                * mount option.
> +                *
> +                * Root of the DOS and Win32 paths is at NT path \??\
> +                * It means that DOS/Win32 path C:\folder\file.txt is
> +                * NT path \??\C:\folder\file.txt
> +                *
> +                * NT systems have some well-known object symlinks in the=
ir NT
> +                * hierarchy, which is needed to take into account when r=
esolving
> +                * other symlinks. Most commonly used symlink paths are:
> +                * \?? -> \GLOBAL??
> +                * \DosDevices -> \??
> +                * \GLOBAL??\GLOBALROOT -> \
> +                * \GLOBAL??\Global -> \GLOBAL??
> +                * \GLOBAL??\NUL -> \Device\Null
> +                * \GLOBAL??\UNC -> \Device\Mup
> +                * \GLOBAL??\PhysicalDrive0 -> \Device\Harddisk0\DR0 (for=
 each harddisk)
> +                * \GLOBAL??\A: -> \Device\Floppy0 (if A: is the first fl=
oppy)
> +                * \GLOBAL??\C: -> \Device\HarddiskVolume1 (if C: is the =
first harddisk)
> +                * \GLOBAL??\D: -> \Device\CdRom0 (if D: is first cdrom)
> +                * \SystemRoot -> \Device\Harddisk0\Partition1\WINDOWS (o=
r where is NT system installed)
> +                * \Volume{...} -> \Device\HarddiskVolume1 (where ... is =
system generated guid)
> +                *
> +                * In most common cases, absolute NT symlinks points to p=
ath on
> +                * DOS/Win32 drive letter, system-specific Volume or on U=
NC share.
> +                * Here are few examples of commonly used absolute NT sym=
links
> +                * created by mklink.exe tool:
> +                * \??\C:\folder\file.txt
> +                * \??\\C:\folder\file.txt
> +                * \??\UNC\server\share\file.txt
> +                * \??\\UNC\server\share\file.txt
> +                * \??\Volume{b75e2c83-0000-0000-0000-602f00000000}\folde=
r\file.txt
> +                *
> +                * It means that the most common path prefix \??\ is also=
 NT path
> +                * symlink (to \GLOBAL??). It is less common that second =
path
> +                * separator is double backslash, but it is valid.
> +                *
> +                * Volume guid is randomly generated by the target system=
 and so
> +                * only the target system knows the mapping between guid =
and the
> +                * hardisk number. Over SMB it is not possible to resolve=
 this
> +                * mapping, therefore symlinks pointing to target locatio=
n of
> +                * volume guids are totally unusable over SMB.
> +                *
> +                * For now parse only symlink paths available for DOS and=
 Win32.
> +                * Those are paths with \??\ prefix or paths which points=
 to \??\
> +                * via other NT symlink (\DosDevices\, \GLOBAL??\, ...).
> +                */
> +               abs_path =3D smb_target;
> +globalroot:
> +               if (strstarts(abs_path, "\\??\\"))
> +                       abs_path +=3D sizeof("\\??\\")-1;
> +               else if (strstarts(abs_path, "\\DosDevices\\"))
> +                       abs_path +=3D sizeof("\\DosDevices\\")-1;
> +               else if (strstarts(abs_path, "\\GLOBAL??\\"))
> +                       abs_path +=3D sizeof("\\GLOBAL??\\")-1;
> +               else {
> +                       /* Unhandled absolute symlink, points outside of =
DOS/Win32 */
> +                       cifs_dbg(VFS,
> +                                "absolute symlink '%s' cannot be convert=
ed from NT format "
> +                                "because points to unknown target\n",
> +                                smb_target);
> +                       rc =3D -EIO;
> +                       goto out;
> +               }
> +
> +               /* Sometimes path separator after \?? is double backslash=
 */
> +               if (abs_path[0] =3D=3D '\\')
> +                       abs_path++;
> +
> +               while (strstarts(abs_path, "Global\\"))
> +                       abs_path +=3D sizeof("Global\\")-1;
> +
> +               if (strstarts(abs_path, "GLOBALROOT\\")) {
> +                       /* Label globalroot requires path with leading '\=
\', so do not trim '\\' */
> +                       abs_path +=3D sizeof("GLOBALROOT")-1;
> +                       goto globalroot;
> +               }
> +
> +               /* For now parse only paths to drive letters */
> +               if (((abs_path[0] >=3D 'A' && abs_path[0] <=3D 'Z') ||
> +                    (abs_path[0] >=3D 'a' && abs_path[0] <=3D 'z')) &&
> +                   abs_path[1] =3D=3D ':' &&
> +                   (abs_path[2] =3D=3D '\\' || abs_path[2] =3D=3D '\0'))=
 {
> +                       /* Convert drive letter to lowercase and drop col=
on */
> +                       char drive_letter =3D abs_path[0];
> +                       if (drive_letter >=3D 'A' && drive_letter <=3D 'Z=
')
> +                               drive_letter +=3D 'a'-'A';
> +                       abs_path++;
> +                       abs_path[0] =3D drive_letter;
> +               } else {
> +                       /* Unhandled absolute symlink. Report an error. *=
/
> +                       cifs_dbg(VFS,
> +                                "absolute symlink '%s' cannot be convert=
ed from NT format "
> +                                "because points to unknown target\n",
> +                                smb_target);
> +                       rc =3D -EIO;
> +                       goto out;
> +               }
> +
> +               abs_path_len =3D strlen(abs_path)+1;
> +               symlinkroot_len =3D strlen(cifs_sb->ctx->symlinkroot);
> +               if (cifs_sb->ctx->symlinkroot[symlinkroot_len-1] =3D=3D '=
/')
> +                       symlinkroot_len--;
> +               linux_target =3D kmalloc(symlinkroot_len + 1 + abs_path_l=
en, GFP_KERNEL);
> +               if (!linux_target) {
> +                       rc =3D -ENOMEM;
> +                       goto out;
> +               }
> +               memcpy(linux_target, cifs_sb->ctx->symlinkroot, symlinkro=
ot_len);
> +               linux_target[symlinkroot_len] =3D '/';
> +               memcpy(linux_target + symlinkroot_len + 1, abs_path, abs_=
path_len);
> +       } else if (smb_target[0] =3D=3D sep && relative) {
>                 /*
>                  * This is a relative SMB symlink from the top of the sha=
re,
>                  * which is the top level directory of the Linux mount po=
int.
> @@ -598,6 +823,12 @@ int smb2_parse_native_symlink(char **target, const c=
har *buf, unsigned int len,
>                 }
>                 memcpy(linux_target + levels*3, smb_target+1, smb_target_=
len); /* +1 to skip leading sep */
>         } else {
> +               /*
> +                * This is either an absolute symlink in POSIX-style form=
at
> +                * or relative SMB symlink from the current directory.
> +                * These paths have same format as Linux symlinks, so no
> +                * conversion is needed.
> +                */
>                 linux_target =3D smb_target;
>                 smb_target =3D NULL;
>         }
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
