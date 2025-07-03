Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB45423C4E5
	for <linux-cifs@vger.kernel.org>; Thu,  3 Jul 2025 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751579018; cv=none; b=r2+3/MrODG9nhJbkla9yxPlIR5b3O646XPYvkxuTHak+O46wUbKvuMo4nF0x/QHMI7sgJ6XehCtO63m692I45PaybqqO7JtKQ18Ob64pL7mKG5AX0hx75XmXi2sQyxQzXkUam/Tt9euWpsrnn/LMRPoKWbdMJpqfIqbXpgyBSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751579018; c=relaxed/simple;
	bh=AIAYOYAKQNC4Ol129O9tfncpTOTmw9nICXs1vWnfATk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VdJ8S4Vk3krzBoSK2iGK/1GI3IWh4nRFooXz3MJZhZq7TE9BT1nKO64TZmAZiCy9FKI0LPBrBJ6B8cXkMwzu5MKGvNspL8Qo9mbKTu2GexGRWvYUATb7RKZSxPJAlo0LJ3wmS6np+VXPeEksRflkQOHGRH8vIwHBHR6XXpHk7ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OQ8zYeQP; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OQ8zYeQP"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6fb0eb0f0fbso4762416d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 03 Jul 2025 14:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751579016; x=1752183816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDuAvpg5WGob2rjEFLaLPNm56HXj6LcM1FWhJ0q5Kns=;
        b=OQ8zYeQPVvyZKoHB+1uZ3LuGaLf9cFva205J0ZrQV4uyAUiUUrV47mtzW3KrX/y8gb
         fSW4Occ3X56OfzGYXHB4vaBagH3SHlWR5XUc1aBT0udc4YuG8n1ySj1HrlJUYbusk17Q
         t3hTfkZLBj2DrDzPoj6XvjuUMgce+hT7cM3CBt0i/PF0SHEUSjHHMXgFF9zzR04wBJXI
         7rG1fvbT/VZDLgSpShCzRhz/4eI5lv/la69BH50BCy2uFNcd54ppMSvrC2BnWhPjYgEF
         upf5RpzJ/F/oSBsnNEI6I8iS00isaSYNfBdqdm9PTEjA5ii1QXb5eTExW/OdiQeXQd5V
         I6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751579016; x=1752183816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gDuAvpg5WGob2rjEFLaLPNm56HXj6LcM1FWhJ0q5Kns=;
        b=Yp69zSFlQDP31Ke8xvmlxazeG9OLpCZRpW4uLPew4/11QVbjhFfdW4UTWR4TBnTAEq
         uSLd09FPay5KdagOpQ2yRdTIjAF+YbsQB+sbPT8lSDyJYDk+HdBnWGnokccBPZzZnN0z
         OfpEGaP9n57kvNREXeG2/VVVdCMY/zyhnAs3hgU4iei+KFznA1T+JrAuW7m44lU5elp7
         LlDRZt2ahbKDufj/vHCDI3H8vMDT7rpjyp4aHF397ZQoyD4Hk2emRZHe/c6cOvHcFkuO
         sM5v2q1R2Q3aLFVQqQ8RBx2oty+drMyBuQIfMew3u2ZVKDg9aQAGsOXvzFSyuBlw9ago
         ttMA==
X-Gm-Message-State: AOJu0YzVwsdnYGxJrH+XKolW38+lqydDW2ooCXumIJm6lFSMatwuSzTg
	f10z0zQQ8DTyRpv8hU5iwaXmrc0kmUzTdp+n929w/lZ6uufO+PtrKfz9KGx/gRrXVAPY4RrbhIc
	pLxCfEr11yexhnSrKhsZrBE4F5Vvzfws=
X-Gm-Gg: ASbGnctnz+68mFrudtdZyRXD8oHZCzTklpUzG89sucq+uVRB1ESO8wCQyucYaNI5dEC
	dSwn/gGPAOu8guZjLR/lZjyS+U8WOqB/Nk+8p9kQM34WhxYs+/EG/3wYyvmHuJZBymmc95SWHY4
	2/Cj7KMviyVMjkBEUYL7YCmjW1uZ8//6slUaDPNFIRM7Mf+byoP7V+I2tfwdeIUlKygpNyACxVC
	xxO+/FUtkrxyss=
X-Google-Smtp-Source: AGHT+IERoNuLoBdUkFEX07vH/pr8tuCyKoxkKJryiMOKPO4uU5EEyh8cqcv6gHutrPnZV9eXmuu+6obd1FUv3nf5OKQ=
X-Received: by 2002:a05:6214:268b:b0:6fd:3886:e31d with SMTP id
 6a1803df08f44-702c57487f6mr7733776d6.11.1751579015623; Thu, 03 Jul 2025
 14:43:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703205719.134380-1-pc@manguebit.org>
In-Reply-To: <20250703205719.134380-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Jul 2025 16:43:24 -0500
X-Gm-Features: Ac12FXwbQRPbBSAguXwPlh4ZxciYZ-YbM1BmRI67ykn_tMgwIrTLFvf2ahYlboE
Message-ID: <CAH2r5mvT0B3L4eSvVtAxV4bQPPirU53S5+buAW_GO9XTFrqR0w@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix native SMB symlink traversal
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Pierguido Lambri <plambri@redhat.com>, 
	David Howells <dhowells@redhat.com>, Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next (pending review and testing) and
added Reported-by

On Thu, Jul 3, 2025 at 3:57=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> We've seen customers having shares mounted in paths like /??/C:/ or
> /??/UNC/foo.example.com/share in order to get their native SMB
> symlinks successfully followed from different mounts.
>
> After commit 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-=
style symlinks"),
> the client would then convert absolute paths from "/??/C:/" to "/mnt/c/"
> by default.  The absolute paths would vary depending on the value of
> symlinkroot=3D mount option.
>
> Fix this by restoring old behavior of not trying to convert absolute
> paths by default.  Only do this if symlinkroot=3D was _explicitly_ set.
>
> Before patch:
>
>   $ mount.cifs //w22-fs0/test2 /mnt/1 -o vers=3D3.1.1,username=3Dxxx,pass=
word=3Dyyy
>   $ ls -l /mnt/1/symlink2
>   lrwxr-xr-x 1 root root 15 Jun 20 14:22 /mnt/1/symlink2 -> /mnt/c/testfi=
le
>   $ mkdir -p /??/C:; echo foo > //??/C:/testfile
>   $ cat /mnt/1/symlink2
>   cat: /mnt/1/symlink2: No such file or directory
>
> After patch:
>
>   $ mount.cifs //w22-fs0/test2 /mnt/1 -o vers=3D3.1.1,username=3Dxxx,pass=
word=3Dyyy
>   $ ls -l /mnt/1/symlink2
>   lrwxr-xr-x 1 root root 15 Jun 20 14:22 /mnt/1/symlink2 -> '/??/C:/testf=
ile'
>   $ mkdir -p /??/C:; echo foo > //??/C:/testfile
>   $ cat /mnt/1/symlink2
>   foo
>
> Cc: linux-cifs@vger.kernel.org
> Cc: Pierguido Lambri <plambri@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Stefan Metzmacher <metze@samba.org>
> Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style =
symlinks")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>  fs/smb/client/fs_context.c | 17 +++++++----------
>  fs/smb/client/reparse.c    | 22 +++++++++++++---------
>  2 files changed, 20 insertions(+), 19 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index a634a34d4086..59ccc2229ab3 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1824,10 +1824,14 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
>                         cifs_errorf(fc, "symlinkroot mount options must b=
e absolute path\n");
>                         goto cifs_parse_mount_err;
>                 }
> +               if (strnlen(param->string, PATH_MAX) =3D=3D PATH_MAX) {
> +                       cifs_errorf(fc, "symlinkroot path too long (max p=
ath length: %u)\n",
> +                                   PATH_MAX - 1);
> +                       goto cifs_parse_mount_err;
> +               }
>                 kfree(ctx->symlinkroot);
> -               ctx->symlinkroot =3D kstrdup(param->string, GFP_KERNEL);
> -               if (!ctx->symlinkroot)
> -                       goto cifs_parse_mount_err;
> +               ctx->symlinkroot =3D param->string;
> +               param->string =3D NULL;
>                 break;
>         }
>         /* case Opt_ignore: - is ignored as expected ... */
> @@ -1837,13 +1841,6 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>                 goto cifs_parse_mount_err;
>         }
>
> -       /*
> -        * By default resolve all native absolute symlinks relative to "/=
mnt/".
> -        * Same default has drvfs driver running in WSL for resolving SMB=
 shares.
> -        */
> -       if (!ctx->symlinkroot)
> -               ctx->symlinkroot =3D kstrdup("/mnt/", GFP_KERNEL);
> -
>         return 0;
>
>   cifs_parse_mount_err:
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 1c40e42e4d89..5fa29a97ac15 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -57,6 +57,7 @@ static int create_native_symlink(const unsigned int xid=
, struct inode *inode,
>         struct reparse_symlink_data_buffer *buf =3D NULL;
>         struct cifs_open_info_data data =3D {};
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> +       const char *symroot =3D cifs_sb->ctx->symlinkroot;
>         struct inode *new;
>         struct kvec iov;
>         __le16 *path =3D NULL;
> @@ -82,7 +83,8 @@ static int create_native_symlink(const unsigned int xid=
, struct inode *inode,
>                 .symlink_target =3D symlink_target,
>         };
>
> -       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symnam=
e[0] =3D=3D '/') {
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) &&
> +           symroot && symname[0] =3D=3D '/') {
>                 /*
>                  * This is a request to create an absolute symlink on the=
 server
>                  * which does not support POSIX paths, and expects symlin=
k in
> @@ -92,7 +94,7 @@ static int create_native_symlink(const unsigned int xid=
, struct inode *inode,
>                  * ensure compatibility of this symlink stored in absolut=
e form
>                  * on the SMB server.
>                  */
> -               if (!strstarts(symname, cifs_sb->ctx->symlinkroot)) {
> +               if (!strstarts(symname, symroot)) {
>                         /*
>                          * If the absolute Linux symlink target path is n=
ot
>                          * inside "symlinkroot" location then there is no=
 way
> @@ -101,12 +103,12 @@ static int create_native_symlink(const unsigned int=
 xid, struct inode *inode,
>                         cifs_dbg(VFS,
>                                  "absolute symlink '%s' cannot be convert=
ed to NT format "
>                                  "because it is outside of symlinkroot=3D=
'%s'\n",
> -                                symname, cifs_sb->ctx->symlinkroot);
> +                                symname, symroot);
>                         rc =3D -EINVAL;
>                         goto out;
>                 }
> -               len =3D strlen(cifs_sb->ctx->symlinkroot);
> -               if (cifs_sb->ctx->symlinkroot[len-1] !=3D '/')
> +               len =3D strlen(symroot);
> +               if (symroot[len - 1] !=3D '/')
>                         len++;
>                 if (symname[len] >=3D 'a' && symname[len] <=3D 'z' &&
>                     (symname[len+1] =3D=3D '/' || symname[len+1] =3D=3D '=
\0')) {
> @@ -782,6 +784,7 @@ int smb2_parse_native_symlink(char **target, const ch=
ar *buf, unsigned int len,
>                               const char *full_path,
>                               struct cifs_sb_info *cifs_sb)
>  {
> +       const char *symroot =3D cifs_sb->ctx->symlinkroot;
>         char sep =3D CIFS_DIR_SEP(cifs_sb);
>         char *linux_target =3D NULL;
>         char *smb_target =3D NULL;
> @@ -815,7 +818,8 @@ int smb2_parse_native_symlink(char **target, const ch=
ar *buf, unsigned int len,
>                 goto out;
>         }
>
> -       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && !relat=
ive) {
> +       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) &&
> +           symroot && !relative) {
>                 /*
>                  * This is an absolute symlink from the server which does=
 not
>                  * support POSIX paths, so the symlink is in NT-style pat=
h.
> @@ -907,15 +911,15 @@ int smb2_parse_native_symlink(char **target, const =
char *buf, unsigned int len,
>                 }
>
>                 abs_path_len =3D strlen(abs_path)+1;
> -               symlinkroot_len =3D strlen(cifs_sb->ctx->symlinkroot);
> -               if (cifs_sb->ctx->symlinkroot[symlinkroot_len-1] =3D=3D '=
/')
> +               symlinkroot_len =3D strlen(symroot);
> +               if (symroot[symlinkroot_len - 1] =3D=3D '/')
>                         symlinkroot_len--;
>                 linux_target =3D kmalloc(symlinkroot_len + 1 + abs_path_l=
en, GFP_KERNEL);
>                 if (!linux_target) {
>                         rc =3D -ENOMEM;
>                         goto out;
>                 }
> -               memcpy(linux_target, cifs_sb->ctx->symlinkroot, symlinkro=
ot_len);
> +               memcpy(linux_target, symroot, symlinkroot_len);
>                 linux_target[symlinkroot_len] =3D '/';
>                 memcpy(linux_target + symlinkroot_len + 1, abs_path, abs_=
path_len);
>         } else if (smb_target[0] =3D=3D sep && relative) {
> --
> 2.50.0
>


--=20
Thanks,

Steve
