Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F15D3DDDD8
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773243447; cv=pass; b=BOboKptrDlNVAENWPi2CAk2Xosui2esRAToiL0SreCmvC7OaxUk0i8Dqt7rT3YAD8oK/kMayLiZgk3R1t6AJllO9KfYLKt0gbDR3IAb/r8ehraosxjkdlO4RfDw5C8QyEqL06L4DWd3JRMAwhj+zJAllmHgWeZ9Ncft5Ud/S2qA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773243447; c=relaxed/simple;
	bh=G3HOmb4DmvMdqvd1UH422B2yaKFVnTJ7/jhFlPHn8c4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=exzGf8Z4ew9LlPOEYkRpcasmKYqmgDFOyJapefm5GCXERrH3i4PW2BGVwQAmpBfkWKB6WkHe0b6MPuvzYnSiaC636DymL+Yf/Ij9vCyrBgXi7RICfHF61c0EZDg7sAlbsDPVH986/xAdcpyKiOKx08M8XG29ThyFOsMblvKCwEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTxcZZM/; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTxcZZM/"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89a0ece9f14so127109016d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 08:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773243445; cv=none;
        d=google.com; s=arc-20240605;
        b=LdK/mlIc0V0YphWF8vWTyV1i4uDLJWZJH++pUIMQgeU1dD7nW3/qQp2T1CLjcJYnJk
         zpo4DY1n8T3qJ4AKQlI4JyecrZZwRZN9hmreJ90+fqRadVOG3Y83n61IOmcfMnPHcjXR
         w5A6CgItzwtS7C2dt374HFId0Ju6OhpR7pYS4cssJCmwDa9XasDRaZHK/bEIC+CCQpxh
         2y+f53IkXXa0HSQnygBDIfUl/UcIPZPe44ybbxRDP3cwP7JxAGma9/VAhW5ToGxdovIZ
         Kti1PzBrH7gtTKD4ujx4zlMBNOHCh/7uZIpVl/iOF0BOc542NlJQjnVbBNtWs5ioejoT
         Ebiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lUyYZKolfE9+N2KbmVz/UBsGglNu3DLw340RfWfsVvA=;
        fh=Ej4LprDmAI80wkL6+/AJM5KF8rrOR5zegeLzTbDTDao=;
        b=RwhPkGSfnzr1YjIGdKlAZJ9G2ND4ZeTrHSvlPcZTGsKqth5Bwj4TAPeloMf/LYawkz
         5h4uWqLhyeQR+xG74KHIyXVvXjORvTTsVKviKZZMhN/uxDH4kup78HZDdE87QGRae9aR
         MZqQMGx4RjREBydpxsp4Kr6m6BreMGCDwU4v8DNa55hE3RnTrhdf+Q6WFtlaNdyRnpJS
         1wBdIiuVWl7fXsJ0gYyCx47xD3/tjB+2A5VxPEzb29kOQwHlmFHyo5oP5lU/eTOC0iOy
         6/urMqT0lFAiUvRtvOkqoE3L5WET863PqP2MH4e7dGlxoeXtzbULqMobtwh4kPIwzAqh
         KCnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773243445; x=1773848245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUyYZKolfE9+N2KbmVz/UBsGglNu3DLw340RfWfsVvA=;
        b=bTxcZZM/cDCBWudNv4oIaOFYniTE6I7EJVHJu1fyw9cHSgBLIMZIKNcp6aZNMeLQVo
         9aLvCKBlR8cYf0lmfFtke4Ch4D0upeGabruibl07/eeJpRvfT0nHEep0yBigCZeMn0GX
         K/q5MS2lAc2wSN2B26jQ2R+59jf5IaW7Qsxh5+s4ZVfklKubaD2/0zkjb1Y+z2Dsywxo
         CVhLIvE1CrMfFTI7vGVxirdS5ySM9IxkFmxdyNViILvArtRke+Qi9l+1lH9xQ1iMZJM7
         33U2bpeTT40JO3c2A1SJwXse6Rohl9++IiHqlj4ANqKyrWe6wb/Dhh6QiZKt7CY48s8c
         xFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773243445; x=1773848245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lUyYZKolfE9+N2KbmVz/UBsGglNu3DLw340RfWfsVvA=;
        b=rjnxED3zz9yxpEN3aXsY46PqSmiHJHEJmKAeADY9Va0DftFEoUOMMZQkSWf5iQK3R5
         y5nf7u4qarXhjEgRTWCUDyrd6WIzPMLy61nAYoRUPIjldBKmWNDP1ubkPIGkbz0O4TMw
         +7tjUbPASzPNaf6CPaPaSVddvFHMf3jQXi3eVUryq6PDZyXw4/iYjVlVgrVf7uKfR7AR
         quoBEUMIcCfafvytDAJXm5tccRS6VJhj4vb5mVvDm3BUPHCwMizx6O8eQDEAQHiKBhf/
         ZfkKeO1l1hO9izuhhpCIa48EVR2KyEnDKrMMSwaJLHVu+vAjD2BjzoSXxIdV9CMVdMRw
         DmPA==
X-Forwarded-Encrypted: i=1; AJvYcCVoc9dGi5o2L8rXmluaOt186fF5enoX06n6ovLegh2pgQUC71yfZaRFsF35qpNzZ8+rjC/zTWAN4z83@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7T8rualE8GMZ7OCXHBIwusoxZsk1269fEZb2SPgG01dMK2/Nq
	s02szIutkyhNd3+s/CMP/hh32rHjuu1uSVxjFLGhxxhGnQsSTzIvK/mFXC1BpvuKgWk53fQlwnV
	wkY4YCoXkYyVnwSDdxsI45uGx8dL6/Kc=
X-Gm-Gg: ATEYQzzBn6w8XTYJ0AfDbijwLpyTLB6g+iqfjSf9GWjmYJ8gGnVeYipEHf9YnpXDAwD
	gkexHlyCCtuWiiLzX6YMsPEcVAC5AmXk9BWsZ5wWZbmFk5Mjf1U0bi45nB3GRPiY0A8R627spXU
	LHFuUWY0z6WhhOirNNiZcx9HuRxyKTmM3OvYAzdMLuNpiiT+ys9fcwJrDzFS8eNf2xB6XNN5EsD
	1qGp81nPtl+MTdhtbfYhqtPWGQtrChqQyVilLDjcwoIz6QwpJKPec8OqoLxtkxqHxLgAxeUeiOv
	eZeF3CPo9vghcBPHgXTXu9jhBHKXagG3geFAf/2qKtlBXzEWqA+xpnszK190FtMopJtOvutnRkM
	memAeeczuP7eIM2dzzBRYOyEqHM9mQBR3elC174EzwXnXvtLVkinUqUBxEfEI1g==
X-Received: by 2002:a05:6214:cc3:b0:89a:5e9:fde2 with SMTP id
 6a1803df08f44-89a669f83bemr38716736d6.24.1773243445068; Wed, 11 Mar 2026
 08:37:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311144055.523527-1-pc@manguebit.org>
In-Reply-To: <20260311144055.523527-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Mar 2026 10:37:13 -0500
X-Gm-Features: AaiRm52Zi0CZIdXiSgcfnqKn4NPphaIh0eYJkwxEwagi67gSp30TCxLLv4NAWhQ
Message-ID: <CAH2r5mvmpnx7jQ_xuzJc3XKOrd=NxZP=nmjPa2SEiLUkXj9ZOQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix open handle lookup in cifs_open()
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixed a minor typo, added a RB and merged into cifs-2.6.git for-next

On Wed, Mar 11, 2026 at 9:40=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> When looking up open handles to be re-used in cifs_open(), calling
> cifs_get_{writable,readable}_path() is wrong as it will look up for
> the first matching open handle, and if @file->f_flags doesn't match,
> it will ignore the remaining open handles in
> cifsInodeInfo::openFileList that might potentially match
> @file->f_flags.
>
> For writable handles, fix this by calling __cifs_get_writable_file()
> directly with FIND_WR_OPEN_FLAGS, and for readable handles, call
> find_readable_file().
>
> With the patch, the following program ends up with two opens instead
> of three sent over the wire.
>
> ```
>   #define _GNU_SOURCE
>   #include <unistd.h>
>   #include <string.h>
>   #include <fcntl.h>
>
>   int main(int argc, char *argv[])
>   {
>           int fd;
>
>           fd =3D open("/mnt/1/foo", O_CREAT | O_WRONLY | O_TRUNC, 0664);
>           close(fd);
>           fd =3D open("/mnt/1/foo", O_DIRECT | O_WRONLY);
>           close(fd);
>           fd =3D open("/mnt/1/foo", O_WRONLY);
>           close(fd);
>           fd =3D open("/mnt/1/foo", O_DIRECT | O_WRONLY);
>           close(fd);
>           return 0;
>   }
> ```
>
> ```
> $ mount.cifs //srv/share /mnt/1 -o ...
> $ gcc test.c && ./a.out
> ```
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/cifsglob.h  |  1 +
>  fs/smb/client/cifsproto.h | 13 +++++--
>  fs/smb/client/file.c      | 75 ++++++++++++++++++++++++---------------
>  3 files changed, 59 insertions(+), 30 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index bb0fe4b60240..d56eeeb8f2b8 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1891,6 +1891,7 @@ enum cifs_writable_file_flags {
>         FIND_WR_FSUID_ONLY              =3D (1U << 0),
>         FIND_WR_WITH_DELETE             =3D (1U << 1),
>         FIND_WR_NO_PENDING_DELETE       =3D (1U << 2),
> +       FIND_WR_OPEN_FLAGS              =3D (1U << 3),
>  };
>
>  #define   MID_FREE 0
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 800a7e418c32..683ba00297a3 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -138,8 +138,9 @@ void cifs_write_subrequest_terminated(struct cifs_io_=
subrequest *wdata,
>                                       ssize_t result);
>  struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode=
,
>                                         int flags);
> -int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
> -                          struct cifsFileInfo **ret_file);
> +int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
> +                            int find_flags, unsigned int open_flags,
> +                            struct cifsFileInfo **ret_file);
>  int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name, int=
 flags,
>                            struct cifsFileInfo **ret_file);
>  struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode=
,
> @@ -596,4 +597,12 @@ static inline void cifs_sg_set_buf(struct sg_table *=
sgtable,
>         }
>  }
>
> +static inline int cifs_get_writable_file(struct cifsInodeInfo *cifs_inod=
e,
> +                                        int find_flags,
> +                                        struct cifsFileInfo **ret_file)
> +{
> +       find_flags &=3D ~FIND_WR_OPEN_FLAGS;
> +       return __cifs_get_writable_file(cifs_inode, find_flags, 0, ret_fi=
le);
> +}
> +
>  #endif                 /* _CIFSPROTO_H */
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 13dda87f7711..2e261c22c0f3 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1061,32 +1061,26 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
>
>         /* Get the cached handle as SMB2 close is deferred */
>         if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
> -               rc =3D cifs_get_writable_path(tcon, full_path,
> -                                           FIND_WR_FSUID_ONLY |
> -                                           FIND_WR_NO_PENDING_DELETE,
> -                                           &cfile);
> +               rc =3D __cifs_get_writable_file(CIFS_I(inode),
> +                                             FIND_WR_FSUID_ONLY |
> +                                             FIND_WR_NO_PENDING_DELETE |
> +                                             FIND_WR_OPEN_FLAGS,
> +                                             file->f_flags, &cfile);
>         } else {
> -               rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> +               cfile =3D find_readable_file(CIFS_I(inode), 0);
> +               rc =3D cfile ? 0 : -ENOENT;
>         }
>         if (rc =3D=3D 0) {
> -               unsigned int oflags =3D file->f_flags & ~(O_CREAT|O_EXCL|=
O_TRUNC);
> -               unsigned int cflags =3D cfile->f_flags & ~(O_CREAT|O_EXCL=
|O_TRUNC);
> -
> -               if (cifs_convert_flags(oflags, 0) =3D=3D cifs_convert_fla=
gs(cflags, 0) &&
> -                   (oflags & (O_SYNC|O_DIRECT)) =3D=3D (cflags & (O_SYNC=
|O_DIRECT))) {
> -                       file->private_data =3D cfile;
> -                       spin_lock(&CIFS_I(inode)->deferred_lock);
> -                       cifs_del_deferred_close(cfile);
> -                       spin_unlock(&CIFS_I(inode)->deferred_lock);
> -                       goto use_cache;
> -               }
> -               _cifsFileInfo_put(cfile, true, false);
> -       } else {
> -               /* hard link on the defeered close file */
> -               rc =3D cifs_get_hardlink_path(tcon, inode, file);
> -               if (rc)
> -                       cifs_close_deferred_file(CIFS_I(inode));
> +               file->private_data =3D cfile;
> +               spin_lock(&CIFS_I(inode)->deferred_lock);
> +               cifs_del_deferred_close(cfile);
> +               spin_unlock(&CIFS_I(inode)->deferred_lock);
> +               goto use_cache;
>         }
> +       /* hard link on the defeered close file */
> +       rc =3D cifs_get_hardlink_path(tcon, inode, file);
> +       if (rc)
> +               cifs_close_deferred_file(CIFS_I(inode));
>
>         if (server->oplocks)
>                 oplock =3D REQ_OPLOCK;
> @@ -2512,6 +2506,27 @@ void cifs_write_subrequest_terminated(struct cifs_=
io_subrequest *wdata, ssize_t
>         netfs_write_subrequest_terminated(&wdata->subreq, result);
>  }
>
> +static bool open_flags_match(struct cifsInodeInfo *cinode,
> +                            unsigned int oflags, unsigned int cflags)
> +{
> +       struct inode *inode =3D &cinode->netfs.inode;
> +       int crw =3D 0, orw =3D 0;
> +
> +       oflags &=3D ~(O_CREAT | O_EXCL | O_TRUNC);
> +       cflags &=3D ~(O_CREAT | O_EXCL | O_TRUNC);
> +
> +       if (cifs_fscache_enabled(inode)) {
> +               if (OPEN_FMODE(cflags) & FMODE_WRITE)
> +                       crw =3D 1;
> +               if (OPEN_FMODE(oflags) & FMODE_WRITE)
> +                       orw =3D 1;
> +       }
> +       if (cifs_convert_flags(oflags, orw) !=3D cifs_convert_flags(cflag=
s, crw))
> +               return false;
> +
> +       return (oflags & (O_SYNC | O_DIRECT)) =3D=3D (cflags & (O_SYNC | =
O_DIRECT));
> +}
> +
>  struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode=
,
>                                         bool fsuid_only)
>  {
> @@ -2547,17 +2562,17 @@ struct cifsFileInfo *find_readable_file(struct ci=
fsInodeInfo *cifs_inode,
>  }
>
>  /* Return -EBADF if no handle is found and general rc otherwise */
> -int
> -cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
> -                      struct cifsFileInfo **ret_file)
> +int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
> +                            int find_flags, unsigned int open_flags,
> +                            struct cifsFileInfo **ret_file)
>  {
>         struct cifsFileInfo *open_file, *inv_file =3D NULL;
>         struct cifs_sb_info *cifs_sb;
>         bool any_available =3D false;
>         int rc =3D -EBADF;
>         unsigned int refind =3D 0;
> -       bool fsuid_only =3D flags & FIND_WR_FSUID_ONLY;
> -       bool with_delete =3D flags & FIND_WR_WITH_DELETE;
> +       bool fsuid_only =3D find_flags & FIND_WR_FSUID_ONLY;
> +       bool with_delete =3D find_flags & FIND_WR_WITH_DELETE;
>         *ret_file =3D NULL;
>
>         /*
> @@ -2591,9 +2606,13 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_=
inode, int flags,
>                         continue;
>                 if (with_delete && !(open_file->fid.access & DELETE))
>                         continue;
> -               if ((flags & FIND_WR_NO_PENDING_DELETE) &&
> +               if ((find_flags & FIND_WR_NO_PENDING_DELETE) &&
>                     open_file->status_file_deleted)
>                         continue;
> +               if ((find_flags & FIND_WR_OPEN_FLAGS) &&
> +                   !open_flags_match(cifs_inode, open_flags,
> +                                     open_file->f_flags))
> +                       continue;
>                 if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
>                         if (!open_file->invalidHandle) {
>                                 /* found a good writable file */
> --
> 2.53.0
>


--=20
Thanks,

Steve
