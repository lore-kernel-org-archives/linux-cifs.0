Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1A6C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 10:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AEB52222D
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 10:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qFgec9TV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392079AbgJTK3K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 06:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388927AbgJTK3K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Oct 2020 06:29:10 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72726C061755
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 03:29:10 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 67so1476082ybt.6
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 03:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5APfQl2JtluuMdX2G4SS+4BVZw9fSYUwMsZsbihnqE=;
        b=qFgec9TVo9RlM+DqS1y3cE52M8a0nl0q8T3bOkh1hnVrD/VAOzwdimuEXPuFoZ2JeS
         BFeahJP1tTaqPZn6Y5ifkq5i9gNa9IEUg5eepbdJaVCe/0jX0dmjhisDkKxlRglr3dLe
         GayB9Cm5R9NGadGpgXwIZq1mhvnmzi8bog/TpozMNJzfYB0TvlDbl/tWq/qj+SEj5zoy
         OP5FGCt2/6fO2BmIN/693LqZh+MLPOPfRkkKe6bvxNAghxj5UUS/z6tbCxq/cQv8tdni
         I55jXLb1C+sjwAsL4LZKeEDwtVy7x6jo4i/LBnfXeLW2F1ircAw5NBvuztC7/KOfDwph
         JIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5APfQl2JtluuMdX2G4SS+4BVZw9fSYUwMsZsbihnqE=;
        b=pE2pI42aazV9MNsRzU8t9zkSZ3npU9hSvxN4mVX249YK+zfdXoFffC+5hr+TRFfoRJ
         I3CJPNLqXAWXY4EbLQgidw/nwUci3PbGoyKq3VO4eQa1G8rQKPBp4UAP5XnjByxvakKP
         NuQG43Sl/+kRG2cqWJx57UbGzjPylsDLuevlBv/5WAp8EQOjyIqVM0NULS5xHZHtlCdn
         AI4JixYEjGBjaiDcrFG869muydEYTgTbtQ6rhrHK2hDtA07zyxLriCmJggvR/XKt+TIl
         dO7flowbBNVEr+16uM6d6C/O3RpDBQU2XCN/9jBh5xS9GnyRRjHMZ/JE9sBdJi/4g7TU
         BX7Q==
X-Gm-Message-State: AOAM530xhBDm9Rg7zaXpc+P8LoBnqvPrm+Yu1uktjooU8UpwajqkC1p/
        L6nbFq/1Oc2TtSpnxB8hvmdBt2/50JqbnB9FeHI=
X-Google-Smtp-Source: ABdhPJygSfsy2opi968U34KH6N+XuJ8XpXXCZvzTKM8jJOOtQFfltQB4+Oi2x1zjNNnTBPxAqk9QFGJFqXjcEuUwTm0=
X-Received: by 2002:a25:bd0c:: with SMTP id f12mr2884373ybk.3.1603189749447;
 Tue, 20 Oct 2020 03:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201001205026.8808-1-lsahlber@redhat.com> <20201001205026.8808-4-lsahlber@redhat.com>
In-Reply-To: <20201001205026.8808-4-lsahlber@redhat.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 20 Oct 2020 15:58:58 +0530
Message-ID: <CANT5p=ra4cibPt+bHG5w74vZHpMK=ZUR270H=wEUvPCAEwmpfA@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: cache the directory content for shroot
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please read my comments inline...

On Fri, Oct 2, 2020 at 2:21 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Add caching of the directory content for the shroot.
> Populate the cache during the initial scan in readdir()
> and then try to serve out of the cache for subsequent scans.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h |  21 +++++++
>  fs/cifs/misc.c     |   2 +
>  fs/cifs/readdir.c  | 173 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/smb2ops.c  |  14 +++++
>  4 files changed, 203 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b565d83ba89e..e8f2b4a642d4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1073,6 +1073,26 @@ cap_unix(struct cifs_ses *ses)
>         return ses->server->vals->cap_unix & ses->capabilities;
>  }
>
> +struct cached_dirent {
> +       struct list_head entry;
> +       char *name;
> +       int namelen;
> +       loff_t pos;
> +       u64 ino;
> +       unsigned type;
> +};
> +
> +struct cached_dirents {
> +       bool is_valid:1;
> +       bool is_failed:1;
> +       struct dir_context *ctx; /* Only used to make sure we only take entries
> +                                 * from a single context. Never dereferenced.
> +                                 */
Since this is an opaque value, can we save this as a non-pointer or
void * so that any references in the future will emit compiler errors?

> +       struct mutex de_mutex;
> +       int pos;                 /* Expected ctx->pos */
> +       struct list_head entries;
> +};
> +
>  struct cached_fid {
>         bool is_valid:1;        /* Do we have a useable root fid */
>         bool file_all_info_is_valid:1;
> @@ -1083,6 +1103,7 @@ struct cached_fid {
>         struct cifs_tcon *tcon;
>         struct work_struct lease_break;
>         struct smb2_file_all_info file_all_info;
> +       struct cached_dirents dirents;
>  };
>
>  /*
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 1c14cf01dbef..a106bd3cc20b 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -124,6 +124,8 @@ tconInfoAlloc(void)
>                 kfree(ret_buf);
>                 return NULL;
>         }
> +       INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
> +       mutex_init(&ret_buf->crfid.dirents.de_mutex);
>
>         atomic_inc(&tconInfoAllocCount);
>         ret_buf->tidStatus = CifsNew;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 31a18aae5e64..17861c3d2e08 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -811,9 +811,119 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
>         return rc;
>  }
>
> +static void init_cached_dirents(struct cached_dirents *cde,
> +                               struct dir_context *ctx)
> +{
> +       if (ctx->pos == 2 && cde->ctx == NULL) {
> +               cde->ctx = ctx;
> +               cde->pos = 2;
Is this needed? pos is already 2.

> +       }
> +}
> +
> +static bool emit_cached_dirents(struct cached_dirents *cde,
> +                               struct dir_context *ctx)
> +{
> +       struct list_head *tmp;
> +       struct cached_dirent *dirent;
> +       int rc;
> +
> +       list_for_each(tmp, &cde->entries) {
If the directory is large, can this loop take a long time?
Maybe okay for now. But maybe something to think?

> +               dirent = list_entry(tmp, struct cached_dirent, entry);
> +               if (ctx->pos >= dirent->pos)
> +                       continue;
> +               ctx->pos = dirent->pos;
> +               rc = dir_emit(ctx, dirent->name, dirent->namelen,
> +                             dirent->ino, dirent->type);
> +               if (!rc)
> +                       return rc;
> +       }
> +       return true;
> +}
> +
> +static void update_cached_dirents_count(struct cached_dirents *cde,
> +                                       struct dir_context *ctx)
> +{
> +       if (cde->ctx != ctx)
> +               return;
> +       if (cde->is_valid || cde->is_failed)
> +               return;
> +
> +       cde->pos++;
> +}
> +
> +static void finished_cached_dirents_count(struct cached_dirents *cde,
> +                                       struct dir_context *ctx)
> +{
> +       if (cde->ctx != ctx)
> +               return;
> +       if (cde->is_valid || cde->is_failed)
> +               return;
> +       if (ctx->pos != cde->pos)
> +               return;
> +
> +       cde->is_valid = 1;
> +}
> +
> +static void add_cached_dirent(struct cached_dirents *cde,
> +                             struct dir_context *ctx,
> +                             const char *name, int namelen,
> +                             u64 ino, unsigned type)
> +{
> +       struct cached_dirent *de;
> +
> +       if (cde->ctx != ctx)
> +               return;
> +       if (cde->is_valid || cde->is_failed)
> +               return;
> +       if (ctx->pos != cde->pos) {
> +               cde->is_failed = 1;
> +               return;
> +       }
> +       de = kzalloc(sizeof(*de), GFP_ATOMIC);
> +       if (de == NULL) {
> +               cde->is_failed = 1;
> +               return;
> +       }
> +       de->name = kzalloc(namelen, GFP_ATOMIC);
> +       if (de->name == NULL) {
> +               kfree(de);
> +               cde->is_failed = 1;
> +               return;
> +       }
> +       memcpy(de->name, name, namelen);
> +       de->namelen = namelen;
> +       de->pos = ctx->pos;
> +       de->ino = ino;
> +       de->type = type;
> +
> +       list_add_tail(&de->entry, &cde->entries);
> +}
> +
> +static bool cifs_dir_emit(struct dir_context *ctx,
> +                         const char *name, int namelen,
> +                         u64 ino, unsigned type,
> +                         struct cached_fid *cfid)
> +{
> +       bool rc;
> +
> +       rc = dir_emit(ctx, name, namelen, ino, type);
> +       if (!rc)
> +               return rc;
> +
> +       if (cfid) {
> +               mutex_lock(&cfid->dirents.de_mutex);
> +               add_cached_dirent(&cfid->dirents, ctx, name, namelen, ino,
> +                                 type);
> +               mutex_unlock(&cfid->dirents.de_mutex);
> +       }
> +
> +       return rc;
> +}
> +
>  static int cifs_filldir(char *find_entry, struct file *file,
> -               struct dir_context *ctx,
> -               char *scratch_buf, unsigned int max_len)
> +                       struct dir_context *ctx,
> +                       char *scratch_buf, unsigned int max_len,
> +                       struct cached_fid *cfid)
>  {
>         struct cifsFileInfo *file_info = file->private_data;
>         struct super_block *sb = file_inode(file)->i_sb;
> @@ -903,10 +1013,10 @@ static int cifs_filldir(char *find_entry, struct file *file,
>         cifs_prime_dcache(file_dentry(file), &name, &fattr);
>
>         ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
> -       return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
> +       return !cifs_dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype,
> +                             cfid);
>  }
>
> -
>  int cifs_readdir(struct file *file, struct dir_context *ctx)
>  {
>         int rc = 0;
> @@ -920,6 +1030,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>         char *end_of_smb;
>         unsigned int max_len;
>         char *full_path = NULL;
> +       struct cached_fid *cfid = NULL;
> +       struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
>
>         xid = get_xid();
>
> @@ -928,7 +1040,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 rc = -ENOMEM;
>                 goto rddir2_exit;
>         }
> -
>         /*
>          * Ensure FindFirst doesn't fail before doing filldir() for '.' and
>          * '..'. Otherwise we won't be able to notify VFS in case of failure.
> @@ -949,6 +1060,31 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 if after then keep searching till find it */
>
>         cifsFile = file->private_data;
> +       tcon = tlink_tcon(cifsFile->tlink);
> +       if (tcon->ses->server->vals->header_preamble_size == 0 &&
> +               !strcmp(full_path, "")) {
> +               rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> +               if (rc)
> +                       goto cache_not_found;
> +
> +               mutex_lock(&cfid->dirents.de_mutex);
> +               /* if this was reading from the start of the directory
> +                * we might need to initialize scanning and storing the
> +                * directory content.
> +                */
> +               init_cached_dirents(&cfid->dirents, ctx);
If ctx passed is different from the ctx in cfid->dirents, should we
skip serving from cache?
Do we need to invalidate the cached dentries in that case?
Also, do we need to check if cifsFile->invalidHandle?

> +               /* If we already have the entire directory cached then
> +                * we cna just serve the cache.
> +                */
Typo: cna -> can

> +               if (cfid->dirents.is_valid) {
Should we also check if is_dir_changed(file)? If the dir has changed,
we should not invalidate the cache.

> +                       emit_cached_dirents(&cfid->dirents, ctx);
> +                       mutex_unlock(&cfid->dirents.de_mutex);
> +                       goto rddir2_exit;
What if we can cache only a portion of the request from cache? Can
there still be entries which we have not served from cache?
I think we'd still be okay, since the user would call readdir again
with pos updated. But can we not go to rddir2_exit and proceed here?
Since ctx->pos would be updated anyway, I think we don't need to end here.

> +               }
> +               mutex_unlock(&cfid->dirents.de_mutex);
> +       }
> + cache_not_found:
> +
>         if (cifsFile->srch_inf.endOfSearch) {
>                 if (cifsFile->srch_inf.emptyDir) {
>                         cifs_dbg(FYI, "End of search, empty dir\n");
> @@ -960,15 +1096,30 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 tcon->ses->server->close(xid, tcon, &cifsFile->fid);
>         } */
>
> -       tcon = tlink_tcon(cifsFile->tlink);
> +       /* Drop the cache while calling find_cifs_entry in case there will
> +        * be reconnects during query_directory.
> +        */
> +       if (cfid) {
> +               close_shroot(cfid);
> +               cfid = NULL;
> +       }
>         rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
>                              &current_entry, &num_to_fill);
> +       if (tcon->ses->server->vals->header_preamble_size == 0 &&
> +               !strcmp(full_path, "")) {
> +               open_shroot(xid, tcon, cifs_sb, &cfid);
> +       }
>         if (rc) {
>                 cifs_dbg(FYI, "fce error %d\n", rc);
>                 goto rddir2_exit;
>         } else if (current_entry != NULL) {
>                 cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
>         } else {
> +               if (cfid) {
> +                       mutex_lock(&cfid->dirents.de_mutex);
> +                       finished_cached_dirents_count(&cfid->dirents, ctx);
> +                       mutex_unlock(&cfid->dirents.de_mutex);
> +               }
>                 cifs_dbg(FYI, "Could not find entry\n");
>                 goto rddir2_exit;
>         }
> @@ -998,7 +1149,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                  */
>                 *tmp_buf = 0;
>                 rc = cifs_filldir(current_entry, file, ctx,
> -                                 tmp_buf, max_len);
> +                                 tmp_buf, max_len, cfid);
>                 if (rc) {
>                         if (rc > 0)
>                                 rc = 0;
> @@ -1006,6 +1157,12 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 }
>
>                 ctx->pos++;
> +               if (cfid) {
> +                       mutex_lock(&cfid->dirents.de_mutex);
> +                       update_cached_dirents_count(&cfid->dirents, ctx);
> +                       mutex_unlock(&cfid->dirents.de_mutex);
> +               }
> +
>                 if (ctx->pos ==
>                         cifsFile->srch_inf.index_of_last_entry) {
>                         cifs_dbg(FYI, "last entry in buf at pos %lld %s\n",
> @@ -1020,6 +1177,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>         kfree(tmp_buf);
>
>  rddir2_exit:
> +       if (cfid)
> +               close_shroot(cfid);
>         kfree(full_path);
>         free_xid(xid);
>         return rc;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index fd6c136066df..280464e21a5f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -605,6 +605,8 @@ smb2_close_cached_fid(struct kref *ref)
>  {
>         struct cached_fid *cfid = container_of(ref, struct cached_fid,
>                                                refcount);
> +       struct list_head *pos, *q;
> +       struct cached_dirent *dirent;
>
>         if (cfid->is_valid) {
>                 cifs_dbg(FYI, "clear cached root file handle\n");
> @@ -613,6 +615,18 @@ smb2_close_cached_fid(struct kref *ref)
>                 cfid->is_valid = false;
>                 cfid->file_all_info_is_valid = false;
>                 cfid->has_lease = false;
> +               mutex_lock(&cfid->dirents.de_mutex);
> +               list_for_each_safe(pos, q, &cfid->dirents.entries) {
> +                       dirent = list_entry(pos, struct cached_dirent, entry);
> +                       list_del(pos);
> +                       kfree(dirent->name);
> +                       kfree(dirent);
> +               }
> +               cfid->dirents.is_valid = 0;
> +               cfid->dirents.is_failed = 0;
> +               cfid->dirents.ctx = NULL;
> +               cfid->dirents.pos = 0;
> +               mutex_unlock(&cfid->dirents.de_mutex);
>         }
>  }
>
> --
> 2.13.6
>

Also, does it make sense to keep a mount option to enable/disable
directory caching till this feature is stabilized?

-- 
-Shyam
