Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9716C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  3 May 2022 07:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiECHYj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 May 2022 03:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiECHXx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 May 2022 03:23:53 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06E3393ED
        for <linux-cifs@vger.kernel.org>; Tue,  3 May 2022 00:19:51 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x33so28944301lfu.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 May 2022 00:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJCvY9m6BL67WJPHr48lQwoZkrxD92K4ILTFojoxU2A=;
        b=TfHSNMZtDoHzZsDf9HXUlcE7Tj0fzF1RYGTp/dxYFKb7sDo+/z1j3cA+NdbQZu23Qn
         5YE72kZ2rSNYbagir/ypgpeCgCflfg1zc1wgy/pWVQOP2hbFg+9KucyLB/2wqozFcPy0
         x8MANjOg5utgqePrhPJVFhJJHtqVEEZPIQn7VxjVP07ovvyES29/pFnxCbDBezWHMpSF
         cn0W6e/hs8EmhnqDMmqB9Zw2mleB60kmbl6G/XMIhhyA41mC1xVYegIWFJfDWW/jFK/B
         9olvYXGdVWGB/1MVxa8uoQGNMpBI4qFth4nPfWkoSvw3kZfyF0cJ8S3PDSEKgyH8FXg4
         yHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJCvY9m6BL67WJPHr48lQwoZkrxD92K4ILTFojoxU2A=;
        b=Vi6I2S/mjsviqNMYjduArgbu4lL7/9lLe2Eb0hbU97NEOElSHnVocilxhyouwYzt+m
         MJlBJmo0WkkivfF7PhYgDA8bUMUSKJ1zbtC7SQqbYzgveF0VWhrSX1Rj+LVf8ZbP96nR
         zJQJnLugb19bSPuDLBzLj2XbAR6xCurN23YY7IHbiqTErg7yvGkq4fPK9Unq6vjrChYG
         SRPocO67ijbUjgUB3n347vD9Z+FSYFR2uCrN9uOjBCFqDJeUH+w664IKv52K2zmhrajS
         tdkM/uAdqPlw2KKtlTccglPgDLOSHYB6MaYnBOxsPoJs2TY45cfUM0dDK+CUNhA0qVZv
         AI5Q==
X-Gm-Message-State: AOAM531lfS4hksHDQSR55Jd6FG6LvkaLYABAccDRCVgK/DRll9w/9PEB
        ak5RlEzLosXxIIyCq1EEAC7gQSsaPp7qOaTLv4w=
X-Google-Smtp-Source: ABdhPJx6A6lTCkLIdtQLEP7bHWo3FWxo5svPHSbtS5lDd9UzGCbeIr7iB8Iqco8sP6ROgjVNeUALvSlcntILen6TIK8=
X-Received: by 2002:ac2:484c:0:b0:472:357:f8fb with SMTP id
 12-20020ac2484c000000b004720357f8fbmr10736836lfy.601.1651562389629; Tue, 03
 May 2022 00:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220503070959.2276616-1-lsahlber@redhat.com> <20220503070959.2276616-2-lsahlber@redhat.com>
In-Reply-To: <20220503070959.2276616-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 May 2022 02:19:38 -0500
Message-ID: <CAH2r5mtcq5Qsgp0B-CWvPNYuoOPmi01pqvaapw5F+jvyEXvLAA@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively put in cifs-2.6.git for-next pending more review/testing
to allow it to be scanned

FYI - also cleaned up minor whitespace errors

On Tue, May 3, 2022 at 2:10 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Cache the names of entries for cached-directories while we have a lease held.
> This allows us to avoid expensive calls to the server when re-scanning
> a cached directory.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h |  84 ++++++++++++++--------
>  fs/cifs/misc.c     |   2 +
>  fs/cifs/readdir.c  | 176 ++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/smb2ops.c  |  20 +++++-
>  4 files changed, 241 insertions(+), 41 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 8de977c359b1..4ec6a3df17fa 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1009,6 +1009,58 @@ cap_unix(struct cifs_ses *ses)
>         return ses->server->vals->cap_unix & ses->capabilities;
>  }
>
> +/*
> + * common struct for holding inode info when searching for or updating an
> + * inode with new info
> + */
> +
> +#define CIFS_FATTR_DFS_REFERRAL                0x1
> +#define CIFS_FATTR_DELETE_PENDING      0x2
> +#define CIFS_FATTR_NEED_REVAL          0x4
> +#define CIFS_FATTR_INO_COLLISION       0x8
> +#define CIFS_FATTR_UNKNOWN_NLINK       0x10
> +#define CIFS_FATTR_FAKE_ROOT_INO       0x20
> +
> +struct cifs_fattr {
> +       u32             cf_flags;
> +       u32             cf_cifsattrs;
> +       u64             cf_uniqueid;
> +       u64             cf_eof;
> +       u64             cf_bytes;
> +       u64             cf_createtime;
> +       kuid_t          cf_uid;
> +       kgid_t          cf_gid;
> +       umode_t         cf_mode;
> +       dev_t           cf_rdev;
> +       unsigned int    cf_nlink;
> +       unsigned int    cf_dtype;
> +       struct timespec64 cf_atime;
> +       struct timespec64 cf_mtime;
> +       struct timespec64 cf_ctime;
> +       u32             cf_cifstag;
> +};
> +
> +struct cached_dirent {
> +       struct list_head entry;
> +       char *name;
> +       int namelen;
> +       loff_t pos;
> +
> +       struct cifs_fattr fattr;
> +};
> +
> +struct cached_dirents {
> +       bool is_valid:1;
> +       bool is_failed:1;
> +       struct dir_context *ctx; /*
> +                                 * Only used to make sure we only take entries
> +                                 * from a single context. Never dereferenced.
> +                                 */
> +       struct mutex de_mutex;
> +       int pos;                 /* Expected ctx->pos */
> +       struct list_head entries;
> +};
> +
>  struct cached_fid {
>         bool is_valid:1;        /* Do we have a useable root fid */
>         bool file_all_info_is_valid:1;
> @@ -1021,6 +1073,7 @@ struct cached_fid {
>         struct dentry *dentry;
>         struct work_struct lease_break;
>         struct smb2_file_all_info file_all_info;
> +       struct cached_dirents dirents;
>  };
>
>  /*
> @@ -1641,37 +1694,6 @@ struct file_list {
>         struct cifsFileInfo *cfile;
>  };
>
> -/*
> - * common struct for holding inode info when searching for or updating an
> - * inode with new info
> - */
> -
> -#define CIFS_FATTR_DFS_REFERRAL                0x1
> -#define CIFS_FATTR_DELETE_PENDING      0x2
> -#define CIFS_FATTR_NEED_REVAL          0x4
> -#define CIFS_FATTR_INO_COLLISION       0x8
> -#define CIFS_FATTR_UNKNOWN_NLINK       0x10
> -#define CIFS_FATTR_FAKE_ROOT_INO       0x20
> -
> -struct cifs_fattr {
> -       u32             cf_flags;
> -       u32             cf_cifsattrs;
> -       u64             cf_uniqueid;
> -       u64             cf_eof;
> -       u64             cf_bytes;
> -       u64             cf_createtime;
> -       kuid_t          cf_uid;
> -       kgid_t          cf_gid;
> -       umode_t         cf_mode;
> -       dev_t           cf_rdev;
> -       unsigned int    cf_nlink;
> -       unsigned int    cf_dtype;
> -       struct timespec64 cf_atime;
> -       struct timespec64 cf_mtime;
> -       struct timespec64 cf_ctime;
> -       u32             cf_cifstag;
> -};
> -
>  static inline void free_dfs_info_param(struct dfs_info3_param *param)
>  {
>         if (param) {
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index afaf59c22193..7fef08add3bc 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -114,6 +114,8 @@ tconInfoAlloc(void)
>                 kfree(ret_buf);
>                 return NULL;
>         }
> +       INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
> +       mutex_init(&ret_buf->crfid.dirents.de_mutex);
>
>         atomic_inc(&tconInfoAllocCount);
>         ret_buf->status = TID_NEW;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 1929e80c09ee..8b3fbe6b3580 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -840,9 +840,112 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
>         return rc;
>  }
>
> +static bool emit_cached_dirents(struct cached_dirents *cde,
> +                               struct dir_context *ctx)
> +{
> +       struct list_head *tmp;
> +       struct cached_dirent *dirent;
> +       int rc;
> +
> +       list_for_each(tmp, &cde->entries) {
> +               dirent = list_entry(tmp, struct cached_dirent, entry);
> +               if (ctx->pos >= dirent->pos)
> +                       continue;
> +               ctx->pos = dirent->pos;
> +               rc = dir_emit(ctx, dirent->name, dirent->namelen,
> +                             dirent->fattr.cf_uniqueid,
> +                             dirent->fattr.cf_dtype);
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
> +                             struct cifs_fattr *fattr)
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
> +       de->name = kzalloc(namelen + 1, GFP_ATOMIC);
> +       if (de->name == NULL) {
> +               kfree(de);
> +               cde->is_failed = 1;
> +               return;
> +       }
> +       memcpy(de->name, name, namelen);
> +       de->namelen = namelen;
> +       de->pos = ctx->pos;
> +
> +       memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
> +
> +       list_add_tail(&de->entry, &cde->entries);
> +}
> +
> +static bool cifs_dir_emit(struct dir_context *ctx,
> +                         const char *name, int namelen,
> +                         struct cifs_fattr *fattr,
> +                         struct cached_fid *cfid)
> +{
> +       bool rc;
> +       ino_t ino = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
> +
> +       rc = dir_emit(ctx, name, namelen, ino, fattr->cf_dtype);
> +       if (!rc)
> +               return rc;
> +
> +       if (cfid) {
> +               mutex_lock(&cfid->dirents.de_mutex);
> +               add_cached_dirent(&cfid->dirents, ctx, name, namelen,
> +                                 fattr);
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
> @@ -851,7 +954,6 @@ static int cifs_filldir(char *find_entry, struct file *file,
>         struct cifs_fattr fattr;
>         struct qstr name;
>         int rc = 0;
> -       ino_t ino;
>
>         rc = cifs_fill_dirent(&de, find_entry, file_info->srch_inf.info_level,
>                               file_info->srch_inf.unicode);
> @@ -931,8 +1033,8 @@ static int cifs_filldir(char *find_entry, struct file *file,
>
>         cifs_prime_dcache(file_dentry(file), &name, &fattr);
>
> -       ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
> -       return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
> +       return !cifs_dir_emit(ctx, name.name, name.len,
> +                             &fattr, cfid);
>  }
>
>
> @@ -942,7 +1044,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>         unsigned int xid;
>         int i;
>         struct cifs_tcon *tcon;
> -       struct cifsFileInfo *cifsFile = NULL;
> +       struct cifsFileInfo *cifsFile;
>         char *current_entry;
>         int num_to_fill = 0;
>         char *tmp_buf = NULL;
> @@ -950,6 +1052,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>         unsigned int max_len;
>         const char *full_path;
>         void *page = alloc_dentry_path();
> +       struct cached_fid *cfid = NULL;
> +       struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
>
>         xid = get_xid();
>
> @@ -969,6 +1073,48 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 if (rc)
>                         goto rddir2_exit;
>         }
> +       cifsFile = file->private_data;
> +       tcon = tlink_tcon(cifsFile->tlink);
> +
> +       rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
> +       if (rc)
> +               goto cache_not_found;
> +
> +       mutex_lock(&cfid->dirents.de_mutex);
> +       /*
> +        * If this was reading from the start of the directory
> +        * we need to initialize scanning and storing the
> +        * directory content.
> +        */
> +       if (ctx->pos == 0 && cfid->dirents.ctx == NULL) {
> +               cfid->dirents.ctx = ctx;
> +               cfid->dirents.pos = 2;
> +       }
> +       /*
> +        * If we already have the entire directory cached then
> +        * we can just serve the cache.
> +        */
> +       if (cfid->dirents.is_valid) {
> +               if (!dir_emit_dots(file, ctx)){
> +                       mutex_unlock(&cfid->dirents.de_mutex);
> +                       goto rddir2_exit;
> +               }
> +               emit_cached_dirents(&cfid->dirents, ctx);
> +               mutex_unlock(&cfid->dirents.de_mutex);
> +               goto rddir2_exit;
> +       }
> +       mutex_unlock(&cfid->dirents.de_mutex);
> + cache_not_found:
> +
> +       /* Drop the cache while calling initiate_cifs_search and
> +        * find_cifs_entry in case there will be reconnects during
> +        * query_directory.
> +        */
> +       if (cfid) {
> +               close_cached_dir(cfid);
> +               cfid = NULL;
> +       }
> +
>
>         if (!dir_emit_dots(file, ctx))
>                 goto rddir2_exit;
> @@ -978,7 +1124,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 if it before then restart search
>                 if after then keep searching till find it */
>
> -       cifsFile = file->private_data;
>         if (cifsFile->srch_inf.endOfSearch) {
>                 if (cifsFile->srch_inf.emptyDir) {
>                         cifs_dbg(FYI, "End of search, empty dir\n");
> @@ -990,15 +1135,20 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                 tcon->ses->server->close(xid, tcon, &cifsFile->fid);
>         } */
>
> -       tcon = tlink_tcon(cifsFile->tlink);
>         rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
>                              &current_entry, &num_to_fill);
> +       open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
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
> @@ -1028,7 +1178,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                  */
>                 *tmp_buf = 0;
>                 rc = cifs_filldir(current_entry, file, ctx,
> -                                 tmp_buf, max_len);
> +                                 tmp_buf, max_len, cfid);
>                 if (rc) {
>                         if (rc > 0)
>                                 rc = 0;
> @@ -1036,6 +1186,12 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
> @@ -1050,6 +1206,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>         kfree(tmp_buf);
>
>  rddir2_exit:
> +       if (cfid)
> +               close_cached_dir(cfid);
>         free_dentry_path(page);
>         free_xid(xid);
>         return rc;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d6aaeff4a30a..10170266f44b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -699,6 +699,8 @@ smb2_close_cached_fid(struct kref *ref)
>  {
>         struct cached_fid *cfid = container_of(ref, struct cached_fid,
>                                                refcount);
> +       struct list_head *pos, *q;
> +       struct cached_dirent *dirent;
>
>         if (cfid->is_valid) {
>                 cifs_dbg(FYI, "clear cached root file handle\n");
> @@ -718,6 +720,21 @@ smb2_close_cached_fid(struct kref *ref)
>                 dput(cfid->dentry);
>                 cfid->dentry = NULL;
>         }
> +       /*
> +        * Delete all cached dirent names
> +        */
> +       mutex_lock(&cfid->dirents.de_mutex);
> +       list_for_each_safe(pos, q, &cfid->dirents.entries) {
> +               dirent = list_entry(pos, struct cached_dirent, entry);
> +               list_del(pos);
> +               kfree(dirent->name);
> +               kfree(dirent);
> +       }
> +       cfid->dirents.is_valid = 0;
> +       cfid->dirents.is_failed = 0;
> +       cfid->dirents.ctx = NULL;
> +       cfid->dirents.pos = 0;
> +       mutex_unlock(&cfid->dirents.de_mutex);
>  }
>
>  void close_cached_dir(struct cached_fid *cfid)
> @@ -776,7 +793,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>         struct cifs_fid *pfid;
>         struct dentry *dentry;
>
> -       if (tcon->nohandlecache)
> +       if (tcon == NULL || tcon->nohandlecache ||
> +           is_smb1_server(tcon->ses->server))
>                 return -ENOTSUPP;
>
>         if (cifs_sb->root == NULL)
> --
> 2.30.2
>


-- 
Thanks,

Steve
