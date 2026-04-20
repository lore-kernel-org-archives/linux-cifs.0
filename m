Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365A399341
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776680969; cv=pass; b=GM2QUxNIZD7/wjLFCZuIkguRB9yx+lBnheuSFd6BrwW7doTFOgtTxMkBpSZMgHSewmLRq21aVQKZwfSZN6uxWS8AllcRDlke4EfBFf4DGHhLkGwDaNSH9SwYfCyvCLeRu40ZcATrgv077fQR6xMC/KV7CHeate543eCQN7eS0zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776680969; c=relaxed/simple;
	bh=b1r7vji9w89PWRc9XU2AkOZofoPvtW87U/mgamZN7Z8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtAzkHWEnag0HKukgo3DsOq1zDE6ypH9Yd6pS+/AE4JGS2PJ5ufr8lC3VLW0lSnfVQDEy4ASV2zdVlmKQj1Htxg4WR7p6hxgKpcZJQRatTWwv8jVgeN4YHqR6ZHbvcqdF5IBjd9eQcuA1WvtgHOU6woKHEaj/0XgqBotJXAsNUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dW1b51ak; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dW1b51ak"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9c6680aaf8so467753766b.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 03:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776680965; cv=none;
        d=google.com; s=arc-20240605;
        b=ZKzodRbABFRksUBjROLyhpJZ7ZwEW4k3tU9EKtaVdtJ22ZlO+na5XOF5+q7dqPcVJq
         BHkIDE5X5hD8zr/JQojxOyvVR/iffvBdDOXQRyxDegAFZj3doU6hpfQRJFOJJ/Epngvj
         AghrnRg8FTyS4CYWmkNo0XtjU8athpDJLAIp+fhpWbBpAxgXQ4QGhmT5tw2UD2btGtOe
         2Ez23nuZyGgC81Yw5ow3gSlbv02sW8IcmNTXjpio7K8HsYu65MY2zslFURjJjaXG58p+
         +SA4koyHjwGKUqFsLpulNiw6pdP5Xjny9sWLadQr4Zu31r7oedffW2D1N+Z5VFYsOtHs
         390Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w63l8zrtQNZhZJyil++3JdFvDsRqKJ7vTTWckv8Wa/g=;
        fh=AKYtjnjvY5j80g1PqWub9kHsdVGG6sxRw7IBMQXWac8=;
        b=FfehCC9DaxFnmAqP1RNPRveIbGY1Y4msw8B4kf1J9MhPfBaJ/tvl7uSwMrEwZwGrza
         swzZIVNgJUsJf1F21tibWeAXRTyYHjBqeoOJO0fMSJJglSfSD4wKYDtBoP90u/rsu61W
         IIJ5XoP9qGNnCKnokuytU/kUvsaRRKpu3qGbyD/fBi6l6dr9WnHjhKdgtrC5CImiaR0B
         1lbNPsnS92QjLatbvcsmAGqiqU9uLzI0NO24428xnnHlf9Znq3ROPukxd9Gxc//4Wyua
         bL9y5A78p4u1B6n69gVL0ToUMTaLi9x2osPYfWB2GucTWSgRCwgGq203hri+mFutfXc/
         FEQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776680965; x=1777285765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w63l8zrtQNZhZJyil++3JdFvDsRqKJ7vTTWckv8Wa/g=;
        b=dW1b51akAJ8lGCQr06LM3d7UsI1+mRdo5pQulQyadmKSAA6O3vhxDT+xrSCOUjvr7c
         XCrdDB0U1gArrQkts6yjXG5D7Yz3VizSYQ6bzfGhzB1PofmblbThC/H50KvwxwmWaKE3
         /kyrJc05izHiPsg93ak8oNuf9Wwnk33Jtkvwq/aqCtLX5hQqE8dZGIHOeO9lKlHh2XL6
         EcYT4PTrJclQjZ1ojxtbNXHSWNPmx5gyJsyGValdFG0cpV+YE7sMJ99kUpFyFnTLzIUU
         ncx3Xti8DAoRawd9FgM+vKyQEptPWYnJL5IWOZDgm9Iozu4rrbKIV1Ya7wqX280/tO6K
         Cqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776680965; x=1777285765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w63l8zrtQNZhZJyil++3JdFvDsRqKJ7vTTWckv8Wa/g=;
        b=kxDxlQe4lsCCcr6LeSm7j2hlY/Ifb6t1aALprPLml6kc/W13OBJ+uOivwa0otz0k2j
         jLCCejGDMYbJm9BU/C5NEDnx/ad0RfWF2SHkl55NW0rEZ7y/+m0VZ+aTRgTRFGj3v9qx
         gOJDJBwDuRTK+eSk4E8dmJ39ynzxI4Y38qjEpE3BgHSJyO+opvzfyvSb5DwxmuCvj7ca
         NSkYj9MydZm/vRJFazR5L8EcdNbejfu3A42nqx2o8nM3aVUKwpb+rw7mRMkgrVNpqX0r
         gq1zZykDlJ7GWbnCqUvnVYAvnAMrjo++eigCngIi0Vxjb4Kw29DISoMgZHu5DYF4itif
         jhrA==
X-Forwarded-Encrypted: i=1; AFNElJ/b2AAuxbW3dbKSJ/FQiZYZ/QoD6h155HXm783hjfCKPzBeNMcvGwOhM7w8XsBuOlV8m4hSwf/leosh@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh96hEEod8ElmJojdU5B40ejU/TzLQV9JEPY8N2zMoSnx9sbfx
	Gwgpm/twcjSfXKSR+mlzJcZTgXBtz6CLeHZXq6EZm40yzghU8k1wUn5joGNYVvU/yh1Hyx14sPF
	xV57Qt0ZDcUyUgTnxa2kY0X88lrxWUVU=
X-Gm-Gg: AeBDieuHHRoIcw+8oR/3OVw27SV82G4awycttiG4HNalXvcCUHQvoYTwUwBlW1sz3P0
	HoovWfljdk4RHHEcHr97l/CzrxplTLrV2fmKRZksqbBM1h4um52TCiE56OfRfNn1nzL6C08yb+C
	CvqcqdB6olP74Rb+K66qeGdnut6KUpHzVY7t7pgHmw8QiDFiIKPRjhG85cU9f56Hf9ofScsyLo8
	fUnMuF3KxeOv0BYuCd7e0MRhMjy3Bt73XHBwYXDdAdJ3Xfi63DMtbggb1s//R+1JAgkGgZK4OJb
	9KkVkDDd1g2fKVtT/ahwPlsCSQTyWyC1pkiCBRDq+E8iBtx+jGyk
X-Received: by 2002:a17:907:e84b:b0:ba3:8a04:7688 with SMTP id
 a640c23a62f3a-ba41b5d28acmr626277266b.36.1776680965266; Mon, 20 Apr 2026
 03:29:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260419161620.564854-1-jkoolstra@xs4all.nl>
In-Reply-To: <20260419161620.564854-1-jkoolstra@xs4all.nl>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 20 Apr 2026 12:29:12 +0200
X-Gm-Features: AQROBzC40fUp9j6jgAwRhk99puzFCqWY_c5zsC-v2pmMmssjl54h3VngfWz6pUk
Message-ID: <CAOQ4uxhh1kGnuY7sKTqti12tjFD4t1vCJ0qQrGngU2+0idXtpQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: replace ints with enum component_type for LAST_XXX
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>, 
	Jeff Layton <jlayton@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 6:16=E2=80=AFPM Jori Koolstra <jkoolstra@xs4all.nl>=
 wrote:
>
> Several functions in namei.c take an "int *type" parameter, such as
> filename_parentat(). To know what values this can take you have to find
> the anonymous struct that defines the LAST_XXX values. I would argue
> that the readability of the code is improved by making this an explicit
> type.
>
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> ---
>
> v2: move back to LAST_XXX and change int to component_type in
> fs/smb/server/vfs.c.
>
> ---
>  fs/namei.c            | 41 ++++++++++++++++++++++-------------------
>  fs/smb/server/vfs.c   |  5 +++--
>  include/linux/namei.h |  4 ++--
>  3 files changed, 27 insertions(+), 23 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 9e5500dad14f..a880454a6415 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -721,15 +721,15 @@ EXPORT_SYMBOL(path_put);
>
>  #define EMBEDDED_LEVELS 2
>  struct nameidata {
> -       struct path     path;
> -       struct qstr     last;
> -       struct path     root;
> -       struct inode    *inode; /* path.dentry.d_inode */
> -       unsigned int    flags, state;
> -       unsigned        seq, next_seq, m_seq, r_seq;
> -       int             last_type;

Please update documentation entry for last_type in
Documentation/filesystems/path-lookup.rst

> -       unsigned        depth;
> -       int             total_link_count;
> +       struct path             path;
> +       struct qstr             last;
> +       struct path             root;
> +       struct inode            *inode; /* path.dentry.d_inode */
> +       unsigned int            flags, state;
> +       unsigned                seq, next_seq, m_seq, r_seq;
> +       enum component_type     last_type;

I really dislike all this white space churn just because the enum name
is so long. If it was long for a good reason - increasing readability -
I may have conceded, but I don't think that is the case.

I do not think that 'component_type' is more clear than 'last_type'
for a developer passing by reading the code.
If anything, the opposite, because 'last_type' or 'type' variables always
appear in the same function with 'last' variable, so it is more clear WHICH
object the type is referring to and matches the LAST_ enum prefix.

> +       unsigned                depth;
> +       int                     total_link_count;
>         struct saved {
>                 struct path link;
>                 struct delayed_call done;
> @@ -2221,7 +2221,7 @@ static struct dentry *follow_dotdot(struct nameidat=
a *nd)
>         return dget(nd->path.dentry);
>  }
>
> -static const char *handle_dots(struct nameidata *nd, int type)
> +static const char *handle_dots(struct nameidata *nd, enum component_type=
 type)
>  {
>         if (type =3D=3D LAST_DOTDOT) {
>                 const char *error =3D NULL;
> @@ -2869,7 +2869,7 @@ static int path_parentat(struct nameidata *nd, unsi=
gned flags,
>  /* Note: this does not consume "name" */
>  static int __filename_parentat(int dfd, struct filename *name,
>                                unsigned int flags, struct path *parent,
> -                              struct qstr *last, int *type,
> +                              struct qstr *last, enum component_type *ty=
pe,
>                                const struct path *root)
>  {
>         int retval;
> @@ -2894,7 +2894,7 @@ static int __filename_parentat(int dfd, struct file=
name *name,
>
>  static int filename_parentat(int dfd, struct filename *name,
>                              unsigned int flags, struct path *parent,
> -                            struct qstr *last, int *type)
> +                            struct qstr *last, enum component_type *type=
)
>  {
>         return __filename_parentat(dfd, name, flags, parent, last, type, =
NULL);
>  }
> @@ -2963,7 +2963,8 @@ static struct dentry *__start_removing_path(int dfd=
, struct filename *name,
>         struct path parent_path __free(path_put) =3D {};
>         struct dentry *d;
>         struct qstr last;
> -       int type, error;
> +       enum component_type type;
> +       int error;
>
>         error =3D filename_parentat(dfd, name, 0, &parent_path, &last, &t=
ype);
>         if (error)
> @@ -3009,7 +3010,8 @@ struct dentry *kern_path_parent(const char *name, s=
truct path *path)
>         CLASS(filename_kernel, filename)(name);
>         struct dentry *d;
>         struct qstr last;
> -       int type, error;
> +       enum component_type type;
> +       int error;
>
>         error =3D filename_parentat(AT_FDCWD, filename, 0, &parent_path, =
&last, &type);
>         if (error)
> @@ -3057,7 +3059,7 @@ EXPORT_SYMBOL(kern_path);
>   * @root: pointer to struct path of the base directory
>   */
>  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags=
,
> -                          struct path *parent, struct qstr *last, int *t=
ype,
> +                          struct path *parent, struct qstr *last, enum c=
omponent_type *type,
>                            const struct path *root)
>  {
>         return  __filename_parentat(AT_FDCWD, filename, flags, parent, la=
st,
> @@ -4903,7 +4905,7 @@ static struct dentry *filename_create(int dfd, stru=
ct filename *name,
>         bool want_dir =3D lookup_flags & LOOKUP_DIRECTORY;
>         unsigned int reval_flag =3D lookup_flags & LOOKUP_REVAL;
>         unsigned int create_flags =3D LOOKUP_CREATE | LOOKUP_EXCL;
> -       int type;
> +       enum component_type type;
>         int error;
>
>         error =3D filename_parentat(dfd, name, reval_flag, path, &last, &=
type);
> @@ -5365,7 +5367,7 @@ int filename_rmdir(int dfd, struct filename *name)
>         struct dentry *dentry;
>         struct path path;
>         struct qstr last;
> -       int type;
> +       enum component_type type;
>         unsigned int lookup_flags =3D 0;
>         struct delegated_inode delegated_inode =3D { };
>  retry:
> @@ -5383,6 +5385,7 @@ int filename_rmdir(int dfd, struct filename *name)
>         case LAST_ROOT:
>                 error =3D -EBUSY;
>                 goto exit2;
> +       case LAST_NORM: ; // OK

I was not aware that the compiler warns about missing cases for enums -
cool feature.
but that needs to be a break; rather than fallthough the end
and as a matter of taste, I would put the valid case first - not critical.

>         }
>
>         error =3D mnt_want_write(path.mnt);
> @@ -5507,7 +5510,7 @@ int filename_unlinkat(int dfd, struct filename *nam=
e)
>         struct dentry *dentry;
>         struct path path;
>         struct qstr last;
> -       int type;
> +       enum component_type type;
>         struct inode *inode;
>         struct delegated_inode delegated_inode =3D { };
>         unsigned int lookup_flags =3D 0;
> @@ -6074,7 +6077,7 @@ int filename_renameat2(int olddfd, struct filename =
*from,
>         struct renamedata rd;
>         struct path old_path, new_path;
>         struct qstr old_last, new_last;
> -       int old_type, new_type;
> +       enum component_type old_type, new_type;
>         struct delegated_inode delegated_inode =3D { };
>         unsigned int lookup_flags =3D 0;
>         bool should_retry =3D false;
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index d08973b288e5..b12d481f5ba9 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -56,7 +56,8 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_con=
fig *share_conf,
>  {
>         struct qstr last;
>         const struct path *root_share_path =3D &share_conf->vfs_path;
> -       int err, type;
> +       int err;
> +       enum component_type type;
>         struct dentry *d;
>
>         if (pathname[0] =3D=3D '\0') {
> @@ -668,7 +669,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const s=
truct path *old_path,
>         struct renamedata rd;
>         struct ksmbd_share_config *share_conf =3D work->tcon->share_conf;
>         struct ksmbd_file *parent_fp;
> -       int new_type;
> +       enum component_type new_type;
>         int err, lookup_flags =3D LOOKUP_NO_SYMLINKS;
>
>         if (ksmbd_override_fsids(work))
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 58600cf234bc..fa3ae87762b7 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -16,7 +16,7 @@ enum { MAX_NESTED_LINKS =3D 8 };
>  /*
>   * Type of the last component on LOOKUP_PARENT
>   */
> -enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> +enum component_type {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};

Please use last_type to match the LAST_ prefix.

TBH, the thing that bothers me most is why is this enum exposed
outside of namei.c
in the first place?

>
>  /* pathwalk mode */
>  #define LOOKUP_FOLLOW          BIT(0)  /* follow links at the end */
> @@ -70,7 +70,7 @@ static inline void end_removing_path(const struct path =
*path , struct dentry *de
>         end_creating_path(path, dentry);
>  }
>  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags=
,
> -                          struct path *parent, struct qstr *last, int *t=
ype,
> +                          struct path *parent, struct qstr *last, enum c=
omponent_type *type,
>                            const struct path *root);

As your patch demonstrates, the only use of enum last_type outside of namei=
.c is
in ksmbd calls to vfs_path_parent_lookup().

This is an "internal" lookup helper that was exposed by commit
74d7970febf7e ("ksmbd: fix racy issue from using ->d_parent and ->d_name")

This commit appears to be using the helper inconsistently in
its two call sites, because ksmbd_vfs_rename(), is not checking the
unlikely(type !=3D LAST_NORM) case.

Perhaps it would be wiser not to expose enum last_type at all and move
the unlikely(type !=3D LAST_NORM) check into the helper itself in namei.c.

WDYT?

Thanks,
Amir.
