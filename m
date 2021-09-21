Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACFDC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 04:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A711260EDF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 04:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhIUEvB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 00:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhIUEvB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 00:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632199773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLRgRbNZ8nW7hWqlYAmDzH9cpD3uN8f9E0mMMpatDnY=;
        b=ChJZbBhgPDI8eTxb6ailpk4LDmxIrdMDiSUdeBYYg/Wn3vwCnets0/ZJiVJKGJ0Dk01lAV
        R9o/Wh3tRqwImJWhMyb/fJpt5jiL7V9GTB0wb7hEaDp4u4QK8qRPQu9uwa4TUw/EQ7mJhV
        mxNpMkil9d/jo5Y1iNCX1/awFTwDvXQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-HUw_oscgM1GeSGrMkEuyZg-1; Tue, 21 Sep 2021 00:49:31 -0400
X-MC-Unique: HUw_oscgM1GeSGrMkEuyZg-1
Received: by mail-ed1-f70.google.com with SMTP id e7-20020a50d4c7000000b003d871ecccd8so3864308edj.18
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 21:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MLRgRbNZ8nW7hWqlYAmDzH9cpD3uN8f9E0mMMpatDnY=;
        b=AnJXsMS9jXhdBjNAMTslkEWtaRTZ6MWigB0f4raFNNFn003YEBhhewPfi5nYwTATlX
         UedIFR6ysV+nYidvnYbEhXAx+9mKc000Gz2t5gXQq01WxHgez9QkNughVFTY9wjOKOQ8
         54zRFR+XPK+8JS9BUT17LwrSeOIttaQ0iWev7p4qxa9ZU8LRbSTIqq6w46cqrJ+AqygI
         wC5nehy5WDsWyB1N9Fvm/ALW6dv2qM//KQ5yknfOozEvI4CHUlW2LEUlbjOmebRslsTs
         w/9C9m2ubaTjyexLXsS627NSCQ46h31FyMApsylrAitOJ6xUAq47qDQw0ca8wN/PZk+D
         vvsQ==
X-Gm-Message-State: AOAM5336349d8U+X7IJ+qge5yZMhRNbQ1zfqcN1S2JmzBVsqLfBdKnCC
        9m4rrdRxjZkRoLupXc78ZcGYuzttETftQWRUetDTNNm/pSygvsNGvItgkn86rC9bPab5RHUdCnK
        O5rLOo+t+KKA/3YdafbHTo80BpqqBIeNpCDI6JA==
X-Received: by 2002:aa7:dcc4:: with SMTP id w4mr34052493edu.286.1632199769843;
        Mon, 20 Sep 2021 21:49:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAsOSKIpKNZ2vyZA7mVKNthjC21ZrJAeZ7pdlGm5wQhMsyX5fnQxm43Vu24H0kivrOGx/xRR8RcinsoD9yRss=
X-Received: by 2002:aa7:dcc4:: with SMTP id w4mr34052482edu.286.1632199769633;
 Mon, 20 Sep 2021 21:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210921044040.624769-1-linkinjeon@kernel.org>
In-Reply-To: <20210921044040.624769-1-linkinjeon@kernel.org>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Tue, 21 Sep 2021 14:49:18 +1000
Message-ID: <CAGvGhF4o=FVLbRAVa08sV0b6mxrZsiJ6F5A45ThpsBqRueQr2w@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: remove follow symlinks support
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 21, 2021 at 2:41 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> This patch remove symlink support that can be vulnerable and access out
> of share, and we re-implement it as reparse point later.


Very good.
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>

>
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  v2:
>   - reorganize path lookup in smb2_open to call only one
>     ksmbd_vfs_kern_path().
>
>  fs/ksmbd/smb2pdu.c | 60 ++++++++++------------------------------------
>  fs/ksmbd/vfs.c     | 50 ++++++++------------------------------
>  2 files changed, 22 insertions(+), 88 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index e08c6b26b6f0..de044802fc5b 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2648,19 +2648,9 @@ int smb2_open(struct ksmbd_work *work)
>                 goto err_out1;
>         }
>
> -       if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
> -               if (test_share_config_flag(work->tcon->share_conf,
> -                                          KSMBD_SHARE_FLAG_FOLLOW_SYMLIN=
KS)) {
> -                       /*
> -                        * On delete request, instead of following up, ne=
ed to
> -                        * look the current entity
> -                        */
> -                       rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
> -               } else {
> -                       rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLIN=
KS, &path, 1);
> -               }
> -
> -               if (!rc) {
> +       rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
> +       if (!rc) {
> +               if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>                         /*
>                          * If file exists with under flags, return access
>                          * denied error.
> @@ -2679,26 +2669,10 @@ int smb2_open(struct ksmbd_work *work)
>                                 path_put(&path);
>                                 goto err_out;
>                         }
> -               }
> -       } else {
> -               if (test_share_config_flag(work->tcon->share_conf,
> -                                          KSMBD_SHARE_FLAG_FOLLOW_SYMLIN=
KS)) {
> -                       /*
> -                        * Use LOOKUP_FOLLOW to follow the path of
> -                        * symlink in path buildup
> -                        */
> -                       rc =3D ksmbd_vfs_kern_path(name, LOOKUP_FOLLOW, &=
path, 1);
> -                       if (rc) { /* Case for broken link ?*/
> -                               rc =3D ksmbd_vfs_kern_path(name, 0, &path=
, 1);
> -                       }
> -               } else {
> -                       rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLIN=
KS,
> -                                                &path, 1);
> -                       if (!rc && d_is_symlink(path.dentry)) {
> -                               rc =3D -EACCES;
> -                               path_put(&path);
> -                               goto err_out;
> -                       }
> +               } else if (d_is_symlink(path.dentry)) {
> +                       rc =3D -EACCES;
> +                       path_put(&path);
> +                       goto err_out;
>                 }
>         }
>
> @@ -4781,12 +4755,8 @@ static int smb2_get_info_filesystem(struct ksmbd_w=
ork *work,
>         struct path path;
>         int rc =3D 0, len;
>         int fs_infoclass_size =3D 0;
> -       int lookup_flags =3D LOOKUP_NO_SYMLINKS;
> -
> -       if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINK=
S))
> -               lookup_flags =3D LOOKUP_FOLLOW;
>
> -       rc =3D ksmbd_vfs_kern_path(share->path, lookup_flags, &path, 0);
> +       rc =3D ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path=
, 0);
>         if (rc) {
>                 pr_err("cannot create vfs path\n");
>                 return -EIO;
> @@ -5293,7 +5263,7 @@ static int smb2_rename(struct ksmbd_work *work,
>         char *pathname =3D NULL;
>         struct path path;
>         bool file_present =3D true;
> -       int rc, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> +       int rc;
>
>         ksmbd_debug(SMB, "setting FILE_RENAME_INFO\n");
>         pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
> @@ -5362,11 +5332,8 @@ static int smb2_rename(struct ksmbd_work *work,
>                 goto out;
>         }
>
> -       if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINK=
S))
> -               lookup_flags =3D LOOKUP_FOLLOW;
> -
>         ksmbd_debug(SMB, "new name %s\n", new_name);
> -       rc =3D ksmbd_vfs_kern_path(new_name, lookup_flags, &path, 1);
> +       rc =3D ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1=
);
>         if (rc)
>                 file_present =3D false;
>         else
> @@ -5416,7 +5383,7 @@ static int smb2_create_link(struct ksmbd_work *work=
,
>         char *link_name =3D NULL, *target_name =3D NULL, *pathname =3D NU=
LL;
>         struct path path;
>         bool file_present =3D true;
> -       int rc, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> +       int rc;
>
>         ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
>         pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
> @@ -5439,11 +5406,8 @@ static int smb2_create_link(struct ksmbd_work *wor=
k,
>                 goto out;
>         }
>
> -       if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINK=
S))
> -               lookup_flags =3D LOOKUP_FOLLOW;
> -
>         ksmbd_debug(SMB, "target name is %s\n", target_name);
> -       rc =3D ksmbd_vfs_kern_path(link_name, lookup_flags, &path, 0);
> +       rc =3D ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, =
0);
>         if (rc)
>                 file_present =3D false;
>         else
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 53047f013371..3733e4944c1d 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -164,13 +164,9 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const =
char *name, umode_t mode)
>  {
>         struct path path;
>         struct dentry *dentry;
> -       int err, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> -
> -       if (test_share_config_flag(work->tcon->share_conf,
> -                                  KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -               lookup_flags =3D LOOKUP_FOLLOW;
> +       int err;
>
> -       dentry =3D kern_path_create(AT_FDCWD, name, &path, lookup_flags);
> +       dentry =3D kern_path_create(AT_FDCWD, name, &path, LOOKUP_NO_SYML=
INKS);
>         if (IS_ERR(dentry)) {
>                 err =3D PTR_ERR(dentry);
>                 if (err !=3D -ENOENT)
> @@ -205,14 +201,10 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const =
char *name, umode_t mode)
>         struct user_namespace *user_ns;
>         struct path path;
>         struct dentry *dentry;
> -       int err, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> -
> -       if (test_share_config_flag(work->tcon->share_conf,
> -                                  KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -               lookup_flags =3D LOOKUP_FOLLOW;
> +       int err;
>
>         dentry =3D kern_path_create(AT_FDCWD, name, &path,
> -                                 lookup_flags | LOOKUP_DIRECTORY);
> +                                 LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY);
>         if (IS_ERR(dentry)) {
>                 err =3D PTR_ERR(dentry);
>                 if (err !=3D -EEXIST)
> @@ -597,16 +589,11 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, =
char *name)
>         struct path path;
>         struct dentry *parent;
>         int err;
> -       int flags =3D LOOKUP_NO_SYMLINKS;
>
>         if (ksmbd_override_fsids(work))
>                 return -ENOMEM;
>
> -       if (test_share_config_flag(work->tcon->share_conf,
> -                                  KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -               flags =3D LOOKUP_FOLLOW;
> -
> -       err =3D kern_path(name, flags, &path);
> +       err =3D kern_path(name, LOOKUP_NO_SYMLINKS, &path);
>         if (err) {
>                 ksmbd_debug(VFS, "can't get %s, err %d\n", name, err);
>                 ksmbd_revert_fsids(work);
> @@ -661,16 +648,11 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const c=
har *oldname,
>         struct path oldpath, newpath;
>         struct dentry *dentry;
>         int err;
> -       int flags =3D LOOKUP_NO_SYMLINKS;
>
>         if (ksmbd_override_fsids(work))
>                 return -ENOMEM;
>
> -       if (test_share_config_flag(work->tcon->share_conf,
> -                                  KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -               flags =3D LOOKUP_FOLLOW;
> -
> -       err =3D kern_path(oldname, flags, &oldpath);
> +       err =3D kern_path(oldname, LOOKUP_NO_SYMLINKS, &oldpath);
>         if (err) {
>                 pr_err("cannot get linux path for %s, err =3D %d\n",
>                        oldname, err);
> @@ -678,7 +660,7 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const cha=
r *oldname,
>         }
>
>         dentry =3D kern_path_create(AT_FDCWD, newname, &newpath,
> -                                 flags | LOOKUP_REVAL);
> +                                 LOOKUP_NO_SYMLINKS | LOOKUP_REVAL);
>         if (IS_ERR(dentry)) {
>                 err =3D PTR_ERR(dentry);
>                 pr_err("path create err for %s, err %d\n", newname, err);
> @@ -797,7 +779,6 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, stru=
ct ksmbd_file *fp,
>         struct dentry *src_dent, *trap_dent, *src_child;
>         char *dst_name;
>         int err;
> -       int flags =3D LOOKUP_NO_SYMLINKS;
>
>         dst_name =3D extract_last_component(newname);
>         if (!dst_name)
> @@ -806,13 +787,8 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, str=
uct ksmbd_file *fp,
>         src_dent_parent =3D dget_parent(fp->filp->f_path.dentry);
>         src_dent =3D fp->filp->f_path.dentry;
>
> -       flags =3D LOOKUP_DIRECTORY;
> -       if (test_share_config_flag(work->tcon->share_conf,
> -                                  KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -               flags =3D LOOKUP_FOLLOW;
> -       flags |=3D LOOKUP_DIRECTORY;
> -
> -       err =3D kern_path(newname, flags, &dst_path);
> +       err =3D kern_path(newname, LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY,
> +                       &dst_path);
>         if (err) {
>                 ksmbd_debug(VFS, "Cannot get path for %s [%d]\n", newname=
, err);
>                 goto out;
> @@ -871,13 +847,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work, cons=
t char *name,
>         int err =3D 0;
>
>         if (name) {
> -               int flags =3D LOOKUP_NO_SYMLINKS;
> -
> -               if (test_share_config_flag(work->tcon->share_conf,
> -                                          KSMBD_SHARE_FLAG_FOLLOW_SYMLIN=
KS))
> -                       flags =3D LOOKUP_FOLLOW;
> -
> -               err =3D kern_path(name, flags, &path);
> +               err =3D kern_path(name, LOOKUP_NO_SYMLINKS, &path);
>                 if (err) {
>                         pr_err("cannot get linux path for %s, err %d\n",
>                                name, err);
> --
> 2.25.1
>

