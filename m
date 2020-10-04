Return-Path: <SRS0=6i8E=DL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8743C47095
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Oct 2020 23:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7320D20757
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Oct 2020 23:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRWwkwRo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgJDXUI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Oct 2020 19:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgJDXUH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Oct 2020 19:20:07 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C07FC0613CE
        for <linux-cifs@vger.kernel.org>; Sun,  4 Oct 2020 16:20:07 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u9so6208009ilj.7
        for <linux-cifs@vger.kernel.org>; Sun, 04 Oct 2020 16:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hSVYyTYm3wuI0Qmct5eWOTHAt8AaCxbIeZNntYrQNN4=;
        b=GRWwkwRo6VVN7Qy49exl5NVq5166N4nRo2/RRFBc6xTvh3oqiV15XTQXaJMzcR0w//
         QMmKvWdo3bZ4z+SQdUczerzZrZwzWjBxaeed75zhXAJOECvGTw1x1YMz0DCCg9XZZnOW
         SBgew+Lrm1xSPpKX14CNLWmUxoeIdb5+5d86M8jRNSKb//q69fdPU8k4HXBgL3+C4HYB
         YI3g87FYaDK5JKze3V+l7sy0GbVQplC17eZywRhXC63t+LF1CVnAnlHCGaBOSkoD/H+O
         42y3sIyhj7J1CLDx23wqhgmeocV0NpzbT70XzbV+p45I21FeYYLaQS2tkrVOZY2IWjre
         wg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hSVYyTYm3wuI0Qmct5eWOTHAt8AaCxbIeZNntYrQNN4=;
        b=uf9/s3uMwQWL4VW1cxnMtd0ud6jIWZEtbHub1H+gCk9dFNjTEnQz2DKqe+HxlWHyF4
         X6te3lrap193J3+N4QQoLow/lYYvwD7coqhOsrjO2v62kVIwmoCyF80L/ZIv2UawX1gP
         SwdLQ/wAtYHuLX3CEXtMh0QA5Rz13UUqNPxSCKhRIUlU53o9kamho4JPMjKkUZWu75nn
         oNDjx55ZVNIhCGslzRU09wC61m/KpsvSgs0ei44cDDhYvn2iPJ+YG6V9HOy9O41j3reM
         5QGj6n9WCnM4fpP09hZDpmN5NjC2j+db5VBYhQjpATYgIEhP+snrJ8xXK+5J61SzdGv5
         9sKQ==
X-Gm-Message-State: AOAM5302YaHpzQf8RqH+NNKGaPiwFTrdDEq2ErSwStmrkDdcEBp/sEci
        eHkp4e8gZkF0MWlXWY5/G7rS70LSkaJDpkjIsYs=
X-Google-Smtp-Source: ABdhPJwGq2USHn/bOnSSiI4AH/RFtlDOM5qx3Z7xqgf1ulW0584Yse7fg0DUNySh6AoQ+Qow41YNTQuOWdftYZKuT+g=
X-Received: by 2002:a92:b50b:: with SMTP id f11mr9385105ile.109.1601853606622;
 Sun, 04 Oct 2020 16:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201001205026.8808-1-lsahlber@redhat.com> <20201001205026.8808-4-lsahlber@redhat.com>
 <87sgawir2x.fsf@suse.com>
In-Reply-To: <87sgawir2x.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 5 Oct 2020 09:19:55 +1000
Message-ID: <CAN05THR4J0JPkmK5ib9PnZu1n2Gd7uhycbedJecjimPq-BkfUw@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: cache the directory content for shroot
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Aurelien,

On Sat, Oct 3, 2020 at 1:30 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi Ronnie,
>
> The more we isolate code with clear opaque interfaces, the less we have
> to understand about their low-level implementation.
>
> I was thinking we could move all dir cache related code to a new dcache.c
> file or something like that.

Lets do that as a follow up.
I would also like to expand the caching from not just "" but, say, the
n latest directories we have used.

>
> One question: when does the cache gets cleared? We dont want to have the
> same stale content every time we query the root. Should it be time based?

Right now it still depends on the lease break.
We can add a timeout value to it as well.
Let's do that as a separate patch. I will do that once this is done.

>
> Comments on code below:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> >  fs/cifs/cifsglob.h |  21 +++++++
> >  fs/cifs/misc.c     |   2 +
> >  fs/cifs/readdir.c  | 173 +++++++++++++++++++++++++++++++++++++++++++++=
+++++---
> >  fs/cifs/smb2ops.c  |  14 +++++
> >  4 files changed, 203 insertions(+), 7 deletions(-)
>
>
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index b565d83ba89e..e8f2b4a642d4 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1073,6 +1073,26 @@ cap_unix(struct cifs_ses *ses)
> >       return ses->server->vals->cap_unix & ses->capabilities;
> >  }
> >
> > +struct cached_dirent {
> > +     struct list_head entry;
> > +     char *name;
> > +     int namelen;
> > +     loff_t pos;
> > +     u64 ino;
> > +     unsigned type;
> > +};
> > +
> > +struct cached_dirents {
> > +     bool is_valid:1;
> > +     bool is_failed:1;
> > +     struct dir_context *ctx; /* Only used to make sure we only take e=
ntries
> > +                               * from a single context. Never derefere=
nced.
> > +                               */
>
> This type of comments are not in the kernel coding style. First comment
> line with "/*" shouldnt have text.

Will fix and resubmit.

>
> > +     struct mutex de_mutex;
> > +     int pos;                 /* Expected ctx->pos */
> > +     struct list_head entries;
> > +};
> > +
> >  struct cached_fid {
> >       bool is_valid:1;        /* Do we have a useable root fid */
> >       bool file_all_info_is_valid:1;
> > @@ -1083,6 +1103,7 @@ struct cached_fid {
> >       struct cifs_tcon *tcon;
> >       struct work_struct lease_break;
> >       struct smb2_file_all_info file_all_info;
> > +     struct cached_dirents dirents;
> >  };
>
> >       }
> > +     INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
> > +     mutex_init(&ret_buf->crfid.dirents.de_mutex);
> >
> >       atomic_inc(&tconInfoAllocCount);
> >       ret_buf->tidStatus =3D CifsNew;
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index 31a18aae5e64..17861c3d2e08 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -811,9 +811,119 @@ find_cifs_entry(const unsigned int xid, struct ci=
fs_tcon *tcon, loff_t pos,
> >       return rc;
> >  }
> >
> > +static void init_cached_dirents(struct cached_dirents *cde,
> > +                             struct dir_context *ctx)
> > +{
> > +     if (ctx->pos =3D=3D 2 && cde->ctx =3D=3D NULL) {
> > +             cde->ctx =3D ctx;
> > +             cde->pos =3D 2;
> > +     }
> > +}
>
> 2 is for "." and ".."? Can you add more comments to document this?
>
> Can you document which functions are expecting to be called with a lock
> held?

Yes, I will clarify that pos=3D=3D2 is due to dir_emit_dots() and it means
we have just started a
fresh scan.

>
> > +
> > +static bool emit_cached_dirents(struct cached_dirents *cde,
> > +                             struct dir_context *ctx)
> > +{
> > +     struct list_head *tmp;
> > +     struct cached_dirent *dirent;
> > +     int rc;
> > +
> > +     list_for_each(tmp, &cde->entries) {
> > +             dirent =3D list_entry(tmp, struct cached_dirent, entry);
> > +             if (ctx->pos >=3D dirent->pos)
> > +                     continue;
> > +             ctx->pos =3D dirent->pos;
> > +             rc =3D dir_emit(ctx, dirent->name, dirent->namelen,
> > +                           dirent->ino, dirent->type);
> > +             if (!rc)
> > +                     return rc;
> > +     }
> > +     return true;
> > +}
> > +
> > +static void update_cached_dirents_count(struct cached_dirents *cde,
> > +                                     struct dir_context *ctx)
> > +{
> > +     if (cde->ctx !=3D ctx)
> > +             return;
> > +     if (cde->is_valid || cde->is_failed)
> > +             return;
> > +
> > +     cde->pos++;
> > +}
> > +
> > +static void finished_cached_dirents_count(struct cached_dirents *cde,
> > +                                     struct dir_context *ctx)
> > +{
> > +     if (cde->ctx !=3D ctx)
> > +             return;
> > +     if (cde->is_valid || cde->is_failed)
> > +             return;
> > +     if (ctx->pos !=3D cde->pos)
> > +             return;
> > +
> > +     cde->is_valid =3D 1;
> > +}
> > +
> > +static void add_cached_dirent(struct cached_dirents *cde,
> > +                           struct dir_context *ctx,
> > +                           const char *name, int namelen,
> > +                           u64 ino, unsigned type)
> > +{
> > +     struct cached_dirent *de;
> > +
> > +     if (cde->ctx !=3D ctx)
> > +             return;
> > +     if (cde->is_valid || cde->is_failed)
> > +             return;
> > +     if (ctx->pos !=3D cde->pos) {
> > +             cde->is_failed =3D 1;
> > +             return;
> > +     }
> > +     de =3D kzalloc(sizeof(*de), GFP_ATOMIC);
> > +     if (de =3D=3D NULL) {
> > +             cde->is_failed =3D 1;
> > +             return;
> > +     }
> > +     de->name =3D kzalloc(namelen, GFP_ATOMIC);
> > +     if (de->name =3D=3D NULL) {
> > +             kfree(de);
> > +             cde->is_failed =3D 1;
> > +             return;
> > +     }
> > +     memcpy(de->name, name, namelen);
> > +     de->namelen =3D namelen;
> > +     de->pos =3D ctx->pos;
> > +     de->ino =3D ino;
> > +     de->type =3D type;
> > +
> > +     list_add_tail(&de->entry, &cde->entries);
> > +}
> > +
> > +static bool cifs_dir_emit(struct dir_context *ctx,
> > +                       const char *name, int namelen,
> > +                       u64 ino, unsigned type,
> > +                       struct cached_fid *cfid)
> > +{
> > +     bool rc;
> > +
> > +     rc =3D dir_emit(ctx, name, namelen, ino, type);
> > +     if (!rc)
> > +             return rc;
> > +
> > +     if (cfid) {
> > +             mutex_lock(&cfid->dirents.de_mutex);
> > +             add_cached_dirent(&cfid->dirents, ctx, name, namelen, ino=
,
> > +                               type);
> > +             mutex_unlock(&cfid->dirents.de_mutex);
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> >  static int cifs_filldir(char *find_entry, struct file *file,
> > -             struct dir_context *ctx,
> > -             char *scratch_buf, unsigned int max_len)
> > +                     struct dir_context *ctx,
> > +                     char *scratch_buf, unsigned int max_len,
> > +                     struct cached_fid *cfid)
> >  {
> >       struct cifsFileInfo *file_info =3D file->private_data;
> >       struct super_block *sb =3D file_inode(file)->i_sb;
> > @@ -903,10 +1013,10 @@ static int cifs_filldir(char *find_entry, struct=
 file *file,
> >       cifs_prime_dcache(file_dentry(file), &name, &fattr);
> >
> >       ino =3D cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
> > -     return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
> > +     return !cifs_dir_emit(ctx, name.name, name.len, ino, fattr.cf_dty=
pe,
> > +                           cfid);
> >  }
> >
> > -
> >  int cifs_readdir(struct file *file, struct dir_context *ctx)
> >  {
> >       int rc =3D 0;
> > @@ -920,6 +1030,8 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
> >       char *end_of_smb;
> >       unsigned int max_len;
> >       char *full_path =3D NULL;
> > +     struct cached_fid *cfid =3D NULL;
> > +     struct cifs_sb_info *cifs_sb =3D CIFS_FILE_SB(file);
> >
> >       xid =3D get_xid();
> >
> > @@ -928,7 +1040,6 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
> >               rc =3D -ENOMEM;
> >               goto rddir2_exit;
> >       }
> > -
> >       /*
> >        * Ensure FindFirst doesn't fail before doing filldir() for '.' a=
nd
> >        * '..'. Otherwise we won't be able to notify VFS in case of fail=
ure.
> > @@ -949,6 +1060,31 @@ int cifs_readdir(struct file *file, struct dir_co=
ntext *ctx)
> >               if after then keep searching till find it */
> >
> >       cifsFile =3D file->private_data;
> > +     tcon =3D tlink_tcon(cifsFile->tlink);
> > +     if (tcon->ses->server->vals->header_preamble_size =3D=3D 0 &&
>
> header_preamble_size =3D=3D 0 is a test for smb1? we have is_smb1_server(=
)
>
> > +             !strcmp(full_path, "")) {
> > +             rc =3D open_shroot(xid, tcon, cifs_sb, &cfid);
> > +             if (rc)
> > +                     goto cache_not_found;
> > +
> > +             mutex_lock(&cfid->dirents.de_mutex);
> > +             /* if this was reading from the start of the directory
> > +              * we might need to initialize scanning and storing the
> > +              * directory content.
> > +              */
> > +             init_cached_dirents(&cfid->dirents, ctx);
> > +             /* If we already have the entire directory cached then
> > +              * we cna just serve the cache.
> > +              */
>
> comment style
>
> > +             if (cfid->dirents.is_valid) {
> > +                     emit_cached_dirents(&cfid->dirents, ctx);
> > +                     mutex_unlock(&cfid->dirents.de_mutex);
> > +                     goto rddir2_exit;
> > +             }
> > +             mutex_unlock(&cfid->dirents.de_mutex);
> > +     }
> > + cache_not_found:
> > +
> >       if (cifsFile->srch_inf.endOfSearch) {
> >               if (cifsFile->srch_inf.emptyDir) {
> >                       cifs_dbg(FYI, "End of search, empty dir\n");
> > @@ -960,15 +1096,30 @@ int cifs_readdir(struct file *file, struct dir_c=
ontext *ctx)
> >               tcon->ses->server->close(xid, tcon, &cifsFile->fid);
> >       } */
> >
> > -     tcon =3D tlink_tcon(cifsFile->tlink);
> > +     /* Drop the cache while calling find_cifs_entry in case there wil=
l
> > +      * be reconnects during query_directory.
> > +      */
>
> comment style
>
> > +     if (cfid) {
> > +             close_shroot(cfid);
> > +             cfid =3D NULL;
> > +     }
> >       rc =3D find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
> >                            &current_entry, &num_to_fill);
> > +     if (tcon->ses->server->vals->header_preamble_size =3D=3D 0 &&
> > +             !strcmp(full_path, "")) {
> > +             open_shroot(xid, tcon, cifs_sb, &cfid);
> > +     }
> >       if (rc) {
> >               cifs_dbg(FYI, "fce error %d\n", rc);
> >               goto rddir2_exit;
> >       } else if (current_entry !=3D NULL) {
> >               cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
> >       } else {
> > +             if (cfid) {
> > +                     mutex_lock(&cfid->dirents.de_mutex);
> > +                     finished_cached_dirents_count(&cfid->dirents, ctx=
);
> > +                     mutex_unlock(&cfid->dirents.de_mutex);
> > +             }
> >               cifs_dbg(FYI, "Could not find entry\n");
> >               goto rddir2_exit;
> >       }
> > @@ -998,7 +1149,7 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
> >                */
> >               *tmp_buf =3D 0;
> >               rc =3D cifs_filldir(current_entry, file, ctx,
> > -                               tmp_buf, max_len);
> > +                               tmp_buf, max_len, cfid);
> >               if (rc) {
> >                       if (rc > 0)
> >                               rc =3D 0;
> > @@ -1006,6 +1157,12 @@ int cifs_readdir(struct file *file, struct dir_c=
ontext *ctx)
> >               }
> >
> >               ctx->pos++;
> > +             if (cfid) {
> > +                     mutex_lock(&cfid->dirents.de_mutex);
> > +                     update_cached_dirents_count(&cfid->dirents, ctx);
> > +                     mutex_unlock(&cfid->dirents.de_mutex);
> > +             }
> > +
> >               if (ctx->pos =3D=3D
> >                       cifsFile->srch_inf.index_of_last_entry) {
> >                       cifs_dbg(FYI, "last entry in buf at pos %lld %s\n=
",
> > @@ -1020,6 +1177,8 @@ int cifs_readdir(struct file *file, struct dir_co=
ntext *ctx)
> >       kfree(tmp_buf);
> >
> >  rddir2_exit:
> > +     if (cfid)
> > +             close_shroot(cfid);
> >       kfree(full_path);
> >       free_xid(xid);
> >       return rc;
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index fd6c136066df..280464e21a5f 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -605,6 +605,8 @@ smb2_close_cached_fid(struct kref *ref)
> >  {
> >       struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
> >                                              refcount);
> > +     struct list_head *pos, *q;
> > +     struct cached_dirent *dirent;
> >
> >       if (cfid->is_valid) {
> >               cifs_dbg(FYI, "clear cached root file handle\n");
> > @@ -613,6 +615,18 @@ smb2_close_cached_fid(struct kref *ref)
> >               cfid->is_valid =3D false;
> >               cfid->file_all_info_is_valid =3D false;
> >               cfid->has_lease =3D false;
> > +             mutex_lock(&cfid->dirents.de_mutex);
> > +             list_for_each_safe(pos, q, &cfid->dirents.entries) {
> > +                     dirent =3D list_entry(pos, struct cached_dirent, =
entry);
> > +                     list_del(pos);
> > +                     kfree(dirent->name);
> > +                     kfree(dirent);
> > +             }
> > +             cfid->dirents.is_valid =3D 0;
> > +             cfid->dirents.is_failed =3D 0;
> > +             cfid->dirents.ctx =3D NULL;
> > +             cfid->dirents.pos =3D 0;
> > +             mutex_unlock(&cfid->dirents.de_mutex);
> >       }
> >  }
>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
