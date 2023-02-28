Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BAAC64EC7
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 23:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjB1Xfe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 18:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjB1Xfb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 18:35:31 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF862F783
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 15:35:29 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id r27so15384829lfe.10
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 15:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SdXKXPb2Liqc7XAfoGlbtFCZ+YYj4T3xE9514QOkYts=;
        b=nJlp4B6ZKwj1e+s/D3Zt0MXfB03xVZTLqkre3t0pf2GZBTMvwSqBcC434wCqbmNj2v
         G/T16sGdL4L2eC6b02c2me7to3irRfY+qnuTw+jbvAt2mHyqB3xQqId/Vx/2bzuTWmga
         XeweU1WrL4FyxMcQp6Z6/dzyLJElnLrKPAvcx3LEZ5Pg2Sz959ptWC4J0yP89BnmTn2B
         s4+1QFNu6n72yXJjhLa/TMkSF/ER2rZz92YGbYlB+WEMtxl+D8APztdU+9cXPCK7qw6u
         BTanGZ6+rf/MeyFVG4nFOJa7IGhC5KilKl4QeRjDBkY7vTa39ELTM32Kx1zIcISOAmAg
         d9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdXKXPb2Liqc7XAfoGlbtFCZ+YYj4T3xE9514QOkYts=;
        b=IMijl8+qfjNQmouz1QrKldvA5KTwVxGISsR4o+WAvqyYIWbWxOeo7TKWZcRUUYp8YZ
         CCoLhpNmms6Rqzj/+GRI3qYPsCjEMsiObPi/PzduDoBIANfRLjfTDFX/KS6OY9ZpYnbZ
         ZMf95usVhxK/8Iqeyei3QuWJurRySN7wDgSIj27T2EJaW8mycvX4LKJjCCpuslKf1Wja
         VXphRG122Ux8IbNoHjVIQbN7fQi4GFVOQfZ4sKoa03ZLAgbQvupnCNdoK+Z1lWK5TkOq
         xjvgKZNTIvqEIwK15OE2I+8mj3lfJ7c7aH+OiUbWYnUE3Zl2bHiQJvinsiYWn+8CNcGx
         BYVg==
X-Gm-Message-State: AO0yUKU7boC8bU+56pFMqtcQ5z1wrfd3GPO28Ih3J1zlSNI2vTR50kUL
        d4FxBmHHslhW7vvxNMcmuwao8DonbUhaOpAuyAX3QseWalI=
X-Google-Smtp-Source: AK7set/qyhRrEl7kskpJAvMaDPW8yDSMWTuoZeUsjqlS/CBqMGu1vuhR7r2uAiLfIlQiZVUwuf5IUAZcIWy63tHb7qI=
X-Received: by 2002:a05:6512:118d:b0:4dd:9eb6:444d with SMTP id
 g13-20020a056512118d00b004dd9eb6444dmr6622422lfr.4.1677627326993; Tue, 28 Feb
 2023 15:35:26 -0800 (PST)
MIME-Version: 1.0
References: <20230227135323.26712-1-pc@manguebit.com> <20230228220155.23394-1-pc@manguebit.com>
 <CAN05THSaVcbsqaR=euCr2Me88HkgMO7fHhX7nc21=cRLKdPwyw@mail.gmail.com>
In-Reply-To: <CAN05THSaVcbsqaR=euCr2Me88HkgMO7fHhX7nc21=cRLKdPwyw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 28 Feb 2023 17:35:15 -0600
Message-ID: <CAH2r5mtd_h7EFQir053YOy7d_kr-WdfOoCDJc3SgsLL7MDCTzg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cifs: improve checking of DFS links over STATUS_OBJECT_NAME_INVALID
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated to add RB tag and added:

CC: stable@vger.kernel.org # 6.2

On Tue, Feb 28, 2023 at 4:21=E2=80=AFPM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Wed, 1 Mar 2023 at 08:15, Paulo Alcantara <pc@manguebit.com> wrote:
> >
> > Do not map STATUS_OBJECT_NAME_INVALID to -EREMOTE under non-DFS
> > shares, or 'nodfs' mounts or CONFIG_CIFS_DFS_UPCALL=3Dn builds.
> > Otherwise, in the slow path, get a referral to figure out whether it
> > is an actual DFS link.
> >
> > This could be simply reproduced under a non-DFS share by running the
> > following
> >
> >   $ mount.cifs //srv/share /mnt -o ...
> >   $ cat /mnt/$(printf '\U110000')
> >   cat: '/mnt/'$'\364\220\200\200': Object is remote
> >
> > Fixes: c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests"=
)
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> > ---
> > v1 -> v2: fixed mem leak on PTR_ERR(ref_path) !=3D -EINVAL
> >
> >  fs/cifs/cifsproto.h | 20 ++++++++++----
> >  fs/cifs/misc.c      | 67 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/cifs/smb2inode.c | 21 +++++++-------
> >  fs/cifs/smb2ops.c   | 23 +++++++++-------
> >  4 files changed, 106 insertions(+), 25 deletions(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index b7a36ebd0f2f..20a2f0f3f682 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -667,11 +667,21 @@ static inline int get_dfs_path(const unsigned int=
 xid, struct cifs_ses *ses,
> >  int match_target_ip(struct TCP_Server_Info *server,
> >                     const char *share, size_t share_len,
> >                     bool *result);
> > -
> > -int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
> > -                                      struct cifs_tcon *tcon,
> > -                                      struct cifs_sb_info *cifs_sb,
> > -                                      const char *dfs_link_path);
> > +int cifs_inval_name_dfs_link_error(const unsigned int xid,
> > +                                  struct cifs_tcon *tcon,
> > +                                  struct cifs_sb_info *cifs_sb,
> > +                                  const char *full_path,
> > +                                  bool *islink);
> > +#else
> > +static inline int cifs_inval_name_dfs_link_error(const unsigned int xi=
d,
> > +                                  struct cifs_tcon *tcon,
> > +                                  struct cifs_sb_info *cifs_sb,
> > +                                  const char *full_path,
> > +                                  bool *islink)
> > +{
> > +       *islink =3D false;
> > +       return 0;
> > +}
> >  #endif
> >
> >  static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, in=
t options)
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index 2905734eb289..0c6c1fc8dae9 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -21,6 +21,7 @@
> >  #include "cifsfs.h"
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >  #include "dns_resolve.h"
> > +#include "dfs_cache.h"
> >  #endif
> >  #include "fs_context.h"
> >  #include "cached_dir.h"
> > @@ -1198,4 +1199,70 @@ int cifs_update_super_prepath(struct cifs_sb_inf=
o *cifs_sb, char *prefix)
> >         cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_USE_PREFIX_PATH;
> >         return 0;
> >  }
> > +
> > +/*
> > + * Handle weird Windows SMB server behaviour. It responds with
> > + * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request for
> > + * "\<server>\<dfsname>\<linkpath>" DFS reference, where <dfsname> con=
tains
> > + * non-ASCII unicode symbols.
> > + */
> > +int cifs_inval_name_dfs_link_error(const unsigned int xid,
> > +                                  struct cifs_tcon *tcon,
> > +                                  struct cifs_sb_info *cifs_sb,
> > +                                  const char *full_path,
> > +                                  bool *islink)
> > +{
> > +       struct cifs_ses *ses =3D tcon->ses;
> > +       size_t len;
> > +       char *path;
> > +       char *ref_path;
> > +
> > +       *islink =3D false;
> > +
> > +       /*
> > +        * Fast path - skip check when @full_path doesn't have a prefix=
 path to
> > +        * look up or tcon is not DFS.
> > +        */
> > +       if (strlen(full_path) < 2 || !cifs_sb ||
> > +           (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
> > +           !is_tcon_dfs(tcon) || !ses->server->origin_fullpath)
> > +               return 0;
> > +
> > +       /*
> > +        * Slow path - tcon is DFS and @full_path has prefix path, so a=
ttempt
> > +        * to get a referral to figure out whether it is an DFS link.
> > +        */
> > +       len =3D strnlen(tcon->tree_name, MAX_TREE_SIZE + 1) + strlen(fu=
ll_path) + 1;
> > +       path =3D kmalloc(len, GFP_KERNEL);
> > +       if (!path)
> > +               return -ENOMEM;
> > +
> > +       scnprintf(path, len, "%s%s", tcon->tree_name, full_path);
> > +       ref_path =3D dfs_cache_canonical_path(path + 1, cifs_sb->local_=
nls,
> > +                                           cifs_remap(cifs_sb));
> > +       kfree(path);
> > +
> > +       if (IS_ERR(ref_path)) {
> > +               if (PTR_ERR(ref_path) !=3D -EINVAL)
> > +                       return PTR_ERR(ref_path);
> > +       } else {
> > +               struct dfs_info3_param *refs =3D NULL;
> > +               int num_refs =3D 0;
> > +
> > +               /*
> > +                * XXX: we are not using dfs_cache_find() here because =
we might
> > +                * end filling all the DFS cache and thus potentially
> > +                * removing cached DFS targets that the client would ev=
entually
> > +                * need during failover.
> > +                */
> > +               if (ses->server->ops->get_dfs_refer &&
> > +                   !ses->server->ops->get_dfs_refer(xid, ses, ref_path=
, &refs,
> > +                                                    &num_refs, cifs_sb=
->local_nls,
> > +                                                    cifs_remap(cifs_sb=
)))
> > +                       *islink =3D refs[0].server_type =3D=3D DFS_TYPE=
_LINK;
> > +               free_dfs_info_array(refs, num_refs);
> > +               kfree(ref_path);
> > +       }
> > +       return 0;
> > +}
> >  #endif
> > diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> > index 37b4cd59245d..9b956294e864 100644
> > --- a/fs/cifs/smb2inode.c
> > +++ b/fs/cifs/smb2inode.c
> > @@ -527,12 +527,13 @@ int smb2_query_path_info(const unsigned int xid, =
struct cifs_tcon *tcon,
> >                          struct cifs_sb_info *cifs_sb, const char *full=
_path,
> >                          struct cifs_open_info_data *data, bool *adjust=
_tz, bool *reparse)
> >  {
> > -       int rc;
> >         __u32 create_options =3D 0;
> >         struct cifsFileInfo *cfile;
> >         struct cached_fid *cfid =3D NULL;
> >         struct kvec err_iov[3] =3D {};
> >         int err_buftype[3] =3D {};
> > +       bool islink;
> > +       int rc, rc2;
> >
> >         *adjust_tz =3D false;
> >         *reparse =3D false;
> > @@ -580,15 +581,15 @@ int smb2_query_path_info(const unsigned int xid, =
struct cifs_tcon *tcon,
> >                                               SMB2_OP_QUERY_INFO, cfile=
, NULL, NULL,
> >                                               NULL, NULL);
> >                         goto out;
> > -               } else if (rc !=3D -EREMOTE && IS_ENABLED(CONFIG_CIFS_D=
FS_UPCALL) &&
> > -                          hdr->Status =3D=3D STATUS_OBJECT_NAME_INVALI=
D) {
> > -                       /*
> > -                        * Handle weird Windows SMB server behaviour. I=
t responds with
> > -                        * STATUS_OBJECT_NAME_INVALID code to SMB2 QUER=
Y_INFO request
> > -                        * for "\<server>\<dfsname>\<linkpath>" DFS ref=
erence,
> > -                        * where <dfsname> contains non-ASCII unicode s=
ymbols.
> > -                        */
> > -                       rc =3D -EREMOTE;
> > +               } else if (rc !=3D -EREMOTE && hdr->Status =3D=3D STATU=
S_OBJECT_NAME_INVALID) {
> > +                       rc2 =3D cifs_inval_name_dfs_link_error(xid, tco=
n, cifs_sb,
> > +                                                            full_path,=
 &islink);
> > +                       if (rc2) {
> > +                               rc =3D rc2;
> > +                               goto out;
> > +                       }
> > +                       if (islink)
> > +                               rc =3D -EREMOTE;
> >                 }
> >                 if (rc =3D=3D -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UP=
CALL) && cifs_sb &&
> >                     (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index f79b075f2992..6dfb865ee9d7 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -796,7 +796,6 @@ static int
> >  smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon=
,
> >                         struct cifs_sb_info *cifs_sb, const char *full_=
path)
> >  {
> > -       int rc;
> >         __le16 *utf16_path;
> >         __u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >         int err_buftype =3D CIFS_NO_BUFFER;
> > @@ -804,6 +803,8 @@ smb2_is_path_accessible(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >         struct kvec err_iov =3D {};
> >         struct cifs_fid fid;
> >         struct cached_fid *cfid;
> > +       bool islink;
> > +       int rc, rc2;
> >
> >         rc =3D open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cf=
id);
> >         if (!rc) {
> > @@ -833,15 +834,17 @@ smb2_is_path_accessible(const unsigned int xid, s=
truct cifs_tcon *tcon,
> >
> >                 if (unlikely(!hdr || err_buftype =3D=3D CIFS_NO_BUFFER)=
)
> >                         goto out;
> > -               /*
> > -                * Handle weird Windows SMB server behaviour. It respon=
ds with
> > -                * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO r=
equest
> > -                * for "\<server>\<dfsname>\<linkpath>" DFS reference,
> > -                * where <dfsname> contains non-ASCII unicode symbols.
> > -                */
> > -               if (rc !=3D -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCA=
LL) &&
> > -                   hdr->Status =3D=3D STATUS_OBJECT_NAME_INVALID)
> > -                       rc =3D -EREMOTE;
> > +
> > +               if (rc !=3D -EREMOTE && hdr->Status =3D=3D STATUS_OBJEC=
T_NAME_INVALID) {
> > +                       rc2 =3D cifs_inval_name_dfs_link_error(xid, tco=
n, cifs_sb,
> > +                                                            full_path,=
 &islink);
> > +                       if (rc2) {
> > +                               rc =3D rc2;
> > +                               goto out;
> > +                       }
> > +                       if (islink)
> > +                               rc =3D -EREMOTE;
> > +               }
> >                 if (rc =3D=3D -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UP=
CALL) && cifs_sb &&
> >                     (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
> >                         rc =3D -EOPNOTSUPP;
> > --
> > 2.39.2
> >



--=20
Thanks,

Steve
