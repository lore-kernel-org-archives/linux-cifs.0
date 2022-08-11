Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4069C00140
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 02:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiHKCyM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Aug 2022 22:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiHKCyM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Aug 2022 22:54:12 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D3E883D7
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 19:54:08 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id o123so17087873vsc.3
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 19:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=urXPKjmfyGcrO3WLS7/jzBNYUcrmZGXI5mo7XoHZsi0=;
        b=Hb7uSU8bFKKXFoDlEbAXkyLbBH41E3/OKXRaSp0AZzcs6ijrQUYSGZxfyJwWHEh3dO
         5MnHBjejXGIfyElNALfHUXAW+wh0nNOPPN3bkGOgdNmO4P03kchLeWpIX6yLV57eT99B
         fYFmGFOGzJJxdqExU6YbtbfZg/1IcEV/714yHXT2BLkdnMs8gdGovXnRBNW0t7Ra4mVL
         P9v+6O0xP2pXxhXYOAw0OiMiRwK/7jhgvMcWT8qZCNwbRs/myZj+YuNSHzqr7Go2XZEQ
         qmi7xzkp+dZCQCLmwdQ9H0OEn0pba7yMwx2660OGa33+54qscTp15iudhdlbukk3OKiv
         lODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=urXPKjmfyGcrO3WLS7/jzBNYUcrmZGXI5mo7XoHZsi0=;
        b=krgXdjoYEyqWBEVA2jXpW8sNe857LzG1nTfHTY/VjJ+ZtoKEXM53yK0tRAn92OllAN
         OcovBt1NdBnonFIqof/5rtjLDIuiAwmz0jjAnZPF+8r0Uvzg7IHo3ISC9+U0wb044whq
         4P2kA4OwCZNzdnrF+O/OMdRE9JM9/IOR1Dt8yTtYHuwW72dz4JHvMyDcJNJ1P2uvLdad
         z9LsvwtBCr5Mo/oJsTqWSZO8ohTiTMKxeKH5Cw9l5khfVZlSTgzgYPJfY7jwnqYGZare
         bzRRef9tZ8dnycHK/DbtUgJMlkLRgzxGadCvFMNHOUuMURGc6LgaYO/0qRBXwt6yUttw
         kymQ==
X-Gm-Message-State: ACgBeo1gp42gfZqGazInQbUMLsceRO5jhO+h+dl3GHjgsSGWnDKAgtHg
        LmRuyaij/uFLr4A6YXsEwlch4QVTtukHd8Men2M=
X-Google-Smtp-Source: AA6agR58ZX85wlo5FMZuvMY9Im5WW6vaSdXuVsokd9VEXBNZBpNhHKOPaPqvS2G2hidXoIANq2M1mCQtbd3EYclsQHs=
X-Received: by 2002:a67:b401:0:b0:387:8734:a09 with SMTP id
 x1-20020a67b401000000b0038787340a09mr12064903vsl.61.1660186447436; Wed, 10
 Aug 2022 19:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-2-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Aug 2022 21:53:55 -0500
Message-ID: <CAH2r5msgAYaYL0oi2HpsuzAa08+ZR6wZHJQx=7c_Wc7wRW3k4A@mail.gmail.com>
Subject: Re: [PATCH 1/9] cifs: Move cached-dir functions into a separate file
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000075ffe505e5ee473b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000075ffe505e5ee473b
Content-Type: text/plain; charset="UTF-8"

Lightly updated (rebase to merge with current for-next) and also
combined with patch 8 of the series to avoid a lock warning.

Tentatively merged this restructuring into cifs-2.6.git for-next
pending testing.

On Mon, Aug 8, 2022 at 9:12 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Also rename crfid to cfid to have consistent naming for this variable.
>
> This commit does not change any logic.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/Makefile     |   2 +-
>  fs/cifs/cached_dir.c | 363 +++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cached_dir.h |  26 ++++
>  fs/cifs/cifsfs.c     |  20 +--
>  fs/cifs/cifsglob.h   |   2 +-
>  fs/cifs/cifsproto.h  |   1 -
>  fs/cifs/cifssmb.c    |   8 +-
>  fs/cifs/inode.c      |   1 +
>  fs/cifs/misc.c       |  12 +-
>  fs/cifs/readdir.c    |   1 +
>  fs/cifs/smb2inode.c  |   5 +-
>  fs/cifs/smb2misc.c   |  13 +-
>  fs/cifs/smb2ops.c    | 297 +----------------------------------
>  fs/cifs/smb2pdu.c    |   3 +-
>  fs/cifs/smb2proto.h  |  10 --
>  15 files changed, 412 insertions(+), 352 deletions(-)
>  create mode 100644 fs/cifs/cached_dir.c
>  create mode 100644 fs/cifs/cached_dir.h
>
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index 8c9f2c00be72..343a59e0d64d 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -7,7 +7,7 @@ obj-$(CONFIG_CIFS) += cifs.o
>
>  cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
>           inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
> -         cifs_unicode.o nterr.o cifsencrypt.o \
> +         cached_dir.o cifs_unicode.o nterr.o cifsencrypt.o \
>           readdir.o ioctl.o sess.o export.o unc.o winucase.o \
>           smb2ops.o smb2maperror.o smb2transport.o \
>           smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> new file mode 100644
> index 000000000000..f2e17c1d5196
> --- /dev/null
> +++ b/fs/cifs/cached_dir.c
> @@ -0,0 +1,363 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *  Functions to handle the cached directory entries
> + *
> + *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
> + */
> +
> +#include "cifsglob.h"
> +#include "cifsproto.h"
> +#include "cifs_debug.h"
> +#include "smb2proto.h"
> +#include "cached_dir.h"
> +
> +/*
> + * Open the and cache a directory handle.
> + * If error then *cfid is not initialized.
> + */
> +int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> +               const char *path,
> +               struct cifs_sb_info *cifs_sb,
> +               struct cached_fid **cfid)
> +{
> +       struct cifs_ses *ses;
> +       struct TCP_Server_Info *server;
> +       struct cifs_open_parms oparms;
> +       struct smb2_create_rsp *o_rsp = NULL;
> +       struct smb2_query_info_rsp *qi_rsp = NULL;
> +       int resp_buftype[2];
> +       struct smb_rqst rqst[2];
> +       struct kvec rsp_iov[2];
> +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> +       struct kvec qi_iov[1];
> +       int rc, flags = 0;
> +       __le16 utf16_path = 0; /* Null - since an open of top of share */
> +       u8 oplock = SMB2_OPLOCK_LEVEL_II;
> +       struct cifs_fid *pfid;
> +       struct dentry *dentry;
> +
> +       if (tcon == NULL || tcon->nohandlecache ||
> +           is_smb1_server(tcon->ses->server))
> +               return -ENOTSUPP;
> +
> +       ses = tcon->ses;
> +       server = ses->server;
> +
> +       if (cifs_sb->root == NULL)
> +               return -ENOENT;
> +
> +       if (strlen(path))
> +               return -ENOENT;
> +
> +       dentry = cifs_sb->root;
> +
> +       mutex_lock(&tcon->cfid.fid_mutex);
> +       if (tcon->cfid.is_valid) {
> +               cifs_dbg(FYI, "found a cached root file handle\n");
> +               *cfid = &tcon->cfid;
> +               kref_get(&tcon->cfid.refcount);
> +               mutex_unlock(&tcon->cfid.fid_mutex);
> +               return 0;
> +       }
> +
> +       /*
> +        * We do not hold the lock for the open because in case
> +        * SMB2_open needs to reconnect, it will end up calling
> +        * cifs_mark_open_files_invalid() which takes the lock again
> +        * thus causing a deadlock
> +        */
> +
> +       mutex_unlock(&tcon->cfid.fid_mutex);
> +
> +       if (smb3_encryption_required(tcon))
> +               flags |= CIFS_TRANSFORM_REQ;
> +
> +       if (!server->ops->new_lease_key)
> +               return -EIO;
> +
> +       pfid = tcon->cfid.fid;
> +       server->ops->new_lease_key(pfid);
> +
> +       memset(rqst, 0, sizeof(rqst));
> +       resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
> +       memset(rsp_iov, 0, sizeof(rsp_iov));
> +
> +       /* Open */
> +       memset(&open_iov, 0, sizeof(open_iov));
> +       rqst[0].rq_iov = open_iov;
> +       rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
> +
> +       oparms.tcon = tcon;
> +       oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
> +       oparms.desired_access = FILE_READ_ATTRIBUTES;
> +       oparms.disposition = FILE_OPEN;
> +       oparms.fid = pfid;
> +       oparms.reconnect = false;
> +
> +       rc = SMB2_open_init(tcon, server,
> +                           &rqst[0], &oplock, &oparms, &utf16_path);
> +       if (rc)
> +               goto oshr_free;
> +       smb2_set_next_command(tcon, &rqst[0]);
> +
> +       memset(&qi_iov, 0, sizeof(qi_iov));
> +       rqst[1].rq_iov = qi_iov;
> +       rqst[1].rq_nvec = 1;
> +
> +       rc = SMB2_query_info_init(tcon, server,
> +                                 &rqst[1], COMPOUND_FID,
> +                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> +                                 SMB2_O_INFO_FILE, 0,
> +                                 sizeof(struct smb2_file_all_info) +
> +                                 PATH_MAX * 2, 0, NULL);
> +       if (rc)
> +               goto oshr_free;
> +
> +       smb2_set_related(&rqst[1]);
> +
> +       rc = compound_send_recv(xid, ses, server,
> +                               flags, 2, rqst,
> +                               resp_buftype, rsp_iov);
> +       mutex_lock(&tcon->cfid.fid_mutex);
> +
> +       /*
> +        * Now we need to check again as the cached root might have
> +        * been successfully re-opened from a concurrent process
> +        */
> +
> +       if (tcon->cfid.is_valid) {
> +               /* work was already done */
> +
> +               /* stash fids for close() later */
> +               struct cifs_fid fid = {
> +                       .persistent_fid = pfid->persistent_fid,
> +                       .volatile_fid = pfid->volatile_fid,
> +               };
> +
> +               /*
> +                * caller expects this func to set the fid in cfid to valid
> +                * cached root, so increment the refcount.
> +                */
> +               kref_get(&tcon->cfid.refcount);
> +
> +               mutex_unlock(&tcon->cfid.fid_mutex);
> +
> +               if (rc == 0) {
> +                       /* close extra handle outside of crit sec */
> +                       SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +               }
> +               rc = 0;
> +               goto oshr_free;
> +       }
> +
> +       /* Cached root is still invalid, continue normaly */
> +
> +       if (rc) {
> +               if (rc == -EREMCHG) {
> +                       tcon->need_reconnect = true;
> +                       pr_warn_once("server share %s deleted\n",
> +                                    tcon->treeName);
> +               }
> +               goto oshr_exit;
> +       }
> +
> +       atomic_inc(&tcon->num_remote_opens);
> +
> +       o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> +       oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> +       oparms.fid->volatile_fid = o_rsp->VolatileFileId;
> +#ifdef CONFIG_CIFS_DEBUG2
> +       oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
> +#endif /* CIFS_DEBUG2 */
> +
> +       tcon->cfid.tcon = tcon;
> +       tcon->cfid.is_valid = true;
> +       tcon->cfid.dentry = dentry;
> +       dget(dentry);
> +       kref_init(&tcon->cfid.refcount);
> +
> +       /* BB TBD check to see if oplock level check can be removed below */
> +       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> +               /*
> +                * See commit 2f94a3125b87. Increment the refcount when we
> +                * get a lease for root, release it if lease break occurs
> +                */
> +               kref_get(&tcon->cfid.refcount);
> +               tcon->cfid.has_lease = true;
> +               smb2_parse_contexts(server, o_rsp,
> +                               &oparms.fid->epoch,
> +                                   oparms.fid->lease_key, &oplock,
> +                                   NULL, NULL);
> +       } else
> +               goto oshr_exit;
> +
> +       qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> +       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> +               goto oshr_exit;
> +       if (!smb2_validate_and_copy_iov(
> +                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> +                               sizeof(struct smb2_file_all_info),
> +                               &rsp_iov[1], sizeof(struct smb2_file_all_info),
> +                               (char *)&tcon->cfid.file_all_info))
> +               tcon->cfid.file_all_info_is_valid = true;
> +       tcon->cfid.time = jiffies;
> +
> +
> +oshr_exit:
> +       mutex_unlock(&tcon->cfid.fid_mutex);
> +oshr_free:
> +       SMB2_open_free(&rqst[0]);
> +       SMB2_query_info_free(&rqst[1]);
> +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> +       if (rc == 0) {
> +               *cfid = &tcon->cfid;
> +}
> +       return rc;
> +}
> +
> +int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> +                             struct dentry *dentry,
> +                             struct cached_fid **cfid)
> +{
> +       mutex_lock(&tcon->cfid.fid_mutex);
> +       if (tcon->cfid.dentry == dentry) {
> +               cifs_dbg(FYI, "found a cached root file handle by dentry\n");
> +               *cfid = &tcon->cfid;
> +               kref_get(&tcon->cfid.refcount);
> +               mutex_unlock(&tcon->cfid.fid_mutex);
> +               return 0;
> +       }
> +       mutex_unlock(&tcon->cfid.fid_mutex);
> +       return -ENOENT;
> +}
> +
> +static void
> +smb2_close_cached_fid(struct kref *ref)
> +{
> +       struct cached_fid *cfid = container_of(ref, struct cached_fid,
> +                                              refcount);
> +       struct cached_dirent *dirent, *q;
> +
> +       if (cfid->is_valid) {
> +               cifs_dbg(FYI, "clear cached root file handle\n");
> +               SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
> +                          cfid->fid->volatile_fid);
> +       }
> +
> +       /*
> +        * We only check validity above to send SMB2_close,
> +        * but we still need to invalidate these entries
> +        * when this function is called
> +        */
> +       cfid->is_valid = false;
> +       cfid->file_all_info_is_valid = false;
> +       cfid->has_lease = false;
> +       if (cfid->dentry) {
> +               dput(cfid->dentry);
> +               cfid->dentry = NULL;
> +       }
> +       /*
> +        * Delete all cached dirent names
> +        */
> +       mutex_lock(&cfid->dirents.de_mutex);
> +       list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
> +               list_del(&dirent->entry);
> +               kfree(dirent->name);
> +               kfree(dirent);
> +       }
> +       cfid->dirents.is_valid = 0;
> +       cfid->dirents.is_failed = 0;
> +       cfid->dirents.ctx = NULL;
> +       cfid->dirents.pos = 0;
> +       mutex_unlock(&cfid->dirents.de_mutex);
> +
> +}
> +
> +void close_cached_dir(struct cached_fid *cfid)
> +{
> +       mutex_lock(&cfid->fid_mutex);
> +       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       mutex_unlock(&cfid->fid_mutex);
> +}
> +
> +void close_cached_dir_lease_locked(struct cached_fid *cfid)
> +{
> +       if (cfid->has_lease) {
> +               cfid->has_lease = false;
> +               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       }
> +}
> +
> +void close_cached_dir_lease(struct cached_fid *cfid)
> +{
> +       mutex_lock(&cfid->fid_mutex);
> +       close_cached_dir_lease_locked(cfid);
> +       mutex_unlock(&cfid->fid_mutex);
> +}
> +
> +/*
> + * Called from cifs_kill_sb when we unmount a share
> + */
> +void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
> +{
> +       struct rb_root *root = &cifs_sb->tlink_tree;
> +       struct rb_node *node;
> +       struct cached_fid *cfid;
> +       struct cifs_tcon *tcon;
> +       struct tcon_link *tlink;
> +
> +       for (node = rb_first(root); node; node = rb_next(node)) {
> +               tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> +               tcon = tlink_tcon(tlink);
> +               if (IS_ERR(tcon))
> +                       continue;
> +               cfid = &tcon->cfid;
> +               mutex_lock(&cfid->fid_mutex);
> +               if (cfid->dentry) {
> +                       dput(cfid->dentry);
> +                       cfid->dentry = NULL;
> +               }
> +               mutex_unlock(&cfid->fid_mutex);
> +       }
> +}
> +
> +/*
> + * Invalidate and close all cached dirs when a TCON has been reset
> + * due to a session loss.
> + */
> +void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> +{
> +       mutex_lock(&tcon->cfid.fid_mutex);
> +       tcon->cfid.is_valid = false;
> +       /* cached handle is not valid, so SMB2_CLOSE won't be sent below */
> +       close_cached_dir_lease_locked(&tcon->cfid);
> +       memset(tcon->cfid.fid, 0, sizeof(struct cifs_fid));
> +       mutex_unlock(&tcon->cfid.fid_mutex);
> +}
> +
> +static void
> +smb2_cached_lease_break(struct work_struct *work)
> +{
> +       struct cached_fid *cfid = container_of(work,
> +                               struct cached_fid, lease_break);
> +
> +       close_cached_dir_lease(cfid);
> +}
> +
> +int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> +{
> +       if (tcon->cfid.is_valid &&
> +           !memcmp(lease_key,
> +                   tcon->cfid.fid->lease_key,
> +                   SMB2_LEASE_KEY_SIZE)) {
> +               tcon->cfid.time = 0;
> +               INIT_WORK(&tcon->cfid.lease_break,
> +                         smb2_cached_lease_break);
> +               queue_work(cifsiod_wq,
> +                          &tcon->cfid.lease_break);
> +               spin_unlock(&cifs_tcp_ses_lock);
> +               return true;
> +       }
> +       return false;
> +}
> diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> new file mode 100644
> index 000000000000..3731c755eea5
> --- /dev/null
> +++ b/fs/cifs/cached_dir.h
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *  Functions to handle the cached directory entries
> + *
> + *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
> + */
> +
> +#ifndef _CACHED_DIR_H
> +#define _CACHED_DIR_H
> +
> +
> +extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> +                          const char *path,
> +                          struct cifs_sb_info *cifs_sb,
> +                          struct cached_fid **cfid);
> +extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> +                                    struct dentry *dentry,
> +                                    struct cached_fid **cfid);
> +extern void close_cached_dir(struct cached_fid *cfid);
> +extern void close_cached_dir_lease(struct cached_fid *cfid);
> +extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
> +extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
> +extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
> +extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
> +
> +#endif                 /* _CACHED_DIR_H */
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f909d9e9faaa..615fbe2bff3c 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -46,6 +46,7 @@
>  #include "netlink.h"
>  #endif
>  #include "fs_context.h"
> +#include "cached_dir.h"
>
>  /*
>   * DOS dates from 1980/1/1 through 2107/12/31
> @@ -264,30 +265,13 @@ cifs_read_super(struct super_block *sb)
>  static void cifs_kill_sb(struct super_block *sb)
>  {
>         struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> -       struct cifs_tcon *tcon;
> -       struct cached_fid *cfid;
> -       struct rb_root *root = &cifs_sb->tlink_tree;
> -       struct rb_node *node;
> -       struct tcon_link *tlink;
>
>         /*
>          * We ned to release all dentries for the cached directories
>          * before we kill the sb.
>          */
>         if (cifs_sb->root) {
> -               for (node = rb_first(root); node; node = rb_next(node)) {
> -                       tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> -                       tcon = tlink_tcon(tlink);
> -                       if (IS_ERR(tcon))
> -                               continue;
> -                       cfid = &tcon->crfid;
> -                       mutex_lock(&cfid->fid_mutex);
> -                       if (cfid->dentry) {
> -                               dput(cfid->dentry);
> -                               cfid->dentry = NULL;
> -                       }
> -                       mutex_unlock(&cfid->fid_mutex);
> -               }
> +               close_all_cached_dirs(cifs_sb);
>
>                 /* finally release root dentry */
>                 dput(cifs_sb->root);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 9b7f409bfc8c..657fabb9067b 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1253,7 +1253,7 @@ struct cifs_tcon {
>         struct fscache_volume *fscache; /* cookie for share */
>  #endif
>         struct list_head pending_opens; /* list of incomplete opens */
> -       struct cached_fid crfid; /* Cached root fid */
> +       struct cached_fid cfid; /* Cached root fid */
>         /* BB add field for back pointer to sb struct(s)? */
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         struct list_head ulist; /* cache update list */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index d59aebefa71c..881bf112d6ae 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -599,7 +599,6 @@ enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
>  struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
>  void cifs_aio_ctx_release(struct kref *refcount);
>  int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
> -void smb2_cached_lease_break(struct work_struct *work);
>
>  int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
>                     struct sdesc **sdesc);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 9ed21752f2df..78dfadd729fe 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -35,6 +35,7 @@
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dfs_cache.h"
>  #endif
> +#include "cached_dir.h"
>
>  #ifdef CONFIG_CIFS_POSIX
>  static struct {
> @@ -91,12 +92,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
>         }
>         spin_unlock(&tcon->open_file_lock);
>
> -       mutex_lock(&tcon->crfid.fid_mutex);
> -       tcon->crfid.is_valid = false;
> -       /* cached handle is not valid, so SMB2_CLOSE won't be sent below */
> -       close_cached_dir_lease_locked(&tcon->crfid);
> -       memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
> -       mutex_unlock(&tcon->crfid.fid_mutex);
> +       invalidate_all_cached_dirs(tcon);
>
>         spin_lock(&cifs_tcp_ses_lock);
>         if (tcon->status == TID_IN_FILES_INVALIDATE)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3ad303dd5e5a..7714f47d199b 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -25,6 +25,7 @@
>  #include "fscache.h"
>  #include "fs_context.h"
>  #include "cifs_ioctl.h"
> +#include "cached_dir.h"
>
>  static void cifs_set_ops(struct inode *inode)
>  {
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 16168ebd1a62..fa1a03ddbbe2 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -115,13 +115,13 @@ tconInfoAlloc(void)
>         ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
>         if (!ret_buf)
>                 return NULL;
> -       ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid), GFP_KERNEL);
> -       if (!ret_buf->crfid.fid) {
> +       ret_buf->cfid.fid = kzalloc(sizeof(*ret_buf->cfid.fid), GFP_KERNEL);
> +       if (!ret_buf->cfid.fid) {
>                 kfree(ret_buf);
>                 return NULL;
>         }
> -       INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
> -       mutex_init(&ret_buf->crfid.dirents.de_mutex);
> +       INIT_LIST_HEAD(&ret_buf->cfid.dirents.entries);
> +       mutex_init(&ret_buf->cfid.dirents.de_mutex);
>
>         atomic_inc(&tconInfoAllocCount);
>         ret_buf->status = TID_NEW;
> @@ -129,7 +129,7 @@ tconInfoAlloc(void)
>         INIT_LIST_HEAD(&ret_buf->openFileList);
>         INIT_LIST_HEAD(&ret_buf->tcon_list);
>         spin_lock_init(&ret_buf->open_file_lock);
> -       mutex_init(&ret_buf->crfid.fid_mutex);
> +       mutex_init(&ret_buf->cfid.fid_mutex);
>         spin_lock_init(&ret_buf->stat_lock);
>         atomic_set(&ret_buf->num_local_opens, 0);
>         atomic_set(&ret_buf->num_remote_opens, 0);
> @@ -147,7 +147,7 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
>         atomic_dec(&tconInfoAllocCount);
>         kfree(buf_to_free->nativeFileSystem);
>         kfree_sensitive(buf_to_free->password);
> -       kfree(buf_to_free->crfid.fid);
> +       kfree(buf_to_free->cfid.fid);
>         kfree(buf_to_free);
>  }
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 384cabdf47ca..a06072ae6c7e 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -21,6 +21,7 @@
>  #include "cifsfs.h"
>  #include "smb2proto.h"
>  #include "fs_context.h"
> +#include "cached_dir.h"
>
>  /*
>   * To be safe - for UCS to UTF-8 with strings loaded with the rare long
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 8571a459c710..f6f9fc3f2e2d 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -23,6 +23,7 @@
>  #include "smb2glob.h"
>  #include "smb2pdu.h"
>  #include "smb2proto.h"
> +#include "cached_dir.h"
>
>  static void
>  free_set_inf_compound(struct smb_rqst *rqst)
> @@ -518,9 +519,9 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
>         /* If it is a root and its handle is cached then use it */
>         if (!rc) {
> -               if (tcon->crfid.file_all_info_is_valid) {
> +               if (tcon->cfid.file_all_info_is_valid) {
>                         move_smb2_info_to_cifs(data,
> -                                              &tcon->crfid.file_all_info);
> +                                              &tcon->cfid.file_all_info);
>                 } else {
>                         rc = SMB2_query_info(xid, tcon,
>                                              cfid->fid->persistent_fid,
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index db0f27fd373b..d3d9174ddd7c 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -16,6 +16,7 @@
>  #include "smb2status.h"
>  #include "smb2glob.h"
>  #include "nterr.h"
> +#include "cached_dir.h"
>
>  static int
>  check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
> @@ -639,18 +640,8 @@ smb2_is_valid_lease_break(char *buffer)
>                                 }
>                                 spin_unlock(&tcon->open_file_lock);
>
> -                               if (tcon->crfid.is_valid &&
> -                                   !memcmp(rsp->LeaseKey,
> -                                           tcon->crfid.fid->lease_key,
> -                                           SMB2_LEASE_KEY_SIZE)) {
> -                                       tcon->crfid.time = 0;
> -                                       INIT_WORK(&tcon->crfid.lease_break,
> -                                                 smb2_cached_lease_break);
> -                                       queue_work(cifsiod_wq,
> -                                                  &tcon->crfid.lease_break);
> -                                       spin_unlock(&cifs_tcp_ses_lock);
> +                               if (cached_dir_lease_break(tcon, rsp->LeaseKey))
>                                         return true;
> -                               }
>                         }
>                 }
>         }
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index aa4c1d403708..01aafedc477e 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -27,6 +27,7 @@
>  #include "smbdirect.h"
>  #include "fscache.h"
>  #include "fs_context.h"
> +#include "cached_dir.h"
>
>  /* Change credits for different ops and return the total number of credits */
>  static int
> @@ -701,300 +702,6 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
>         return rc;
>  }
>
> -static void
> -smb2_close_cached_fid(struct kref *ref)
> -{
> -       struct cached_fid *cfid = container_of(ref, struct cached_fid,
> -                                              refcount);
> -       struct cached_dirent *dirent, *q;
> -
> -       if (cfid->is_valid) {
> -               cifs_dbg(FYI, "clear cached root file handle\n");
> -               SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
> -                          cfid->fid->volatile_fid);
> -       }
> -
> -       /*
> -        * We only check validity above to send SMB2_close,
> -        * but we still need to invalidate these entries
> -        * when this function is called
> -        */
> -       cfid->is_valid = false;
> -       cfid->file_all_info_is_valid = false;
> -       cfid->has_lease = false;
> -       if (cfid->dentry) {
> -               dput(cfid->dentry);
> -               cfid->dentry = NULL;
> -       }
> -       /*
> -        * Delete all cached dirent names
> -        */
> -       mutex_lock(&cfid->dirents.de_mutex);
> -       list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
> -               list_del(&dirent->entry);
> -               kfree(dirent->name);
> -               kfree(dirent);
> -       }
> -       cfid->dirents.is_valid = 0;
> -       cfid->dirents.is_failed = 0;
> -       cfid->dirents.ctx = NULL;
> -       cfid->dirents.pos = 0;
> -       mutex_unlock(&cfid->dirents.de_mutex);
> -
> -}
> -
> -void close_cached_dir(struct cached_fid *cfid)
> -{
> -       mutex_lock(&cfid->fid_mutex);
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> -       mutex_unlock(&cfid->fid_mutex);
> -}
> -
> -void close_cached_dir_lease_locked(struct cached_fid *cfid)
> -{
> -       if (cfid->has_lease) {
> -               cfid->has_lease = false;
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> -       }
> -}
> -
> -void close_cached_dir_lease(struct cached_fid *cfid)
> -{
> -       mutex_lock(&cfid->fid_mutex);
> -       close_cached_dir_lease_locked(cfid);
> -       mutex_unlock(&cfid->fid_mutex);
> -}
> -
> -void
> -smb2_cached_lease_break(struct work_struct *work)
> -{
> -       struct cached_fid *cfid = container_of(work,
> -                               struct cached_fid, lease_break);
> -
> -       close_cached_dir_lease(cfid);
> -}
> -
> -/*
> - * Open the and cache a directory handle.
> - * Only supported for the root handle.
> - * If error then *cfid is not initialized.
> - */
> -int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> -               const char *path,
> -               struct cifs_sb_info *cifs_sb,
> -               struct cached_fid **cfid)
> -{
> -       struct cifs_ses *ses;
> -       struct TCP_Server_Info *server;
> -       struct cifs_open_parms oparms;
> -       struct smb2_create_rsp *o_rsp = NULL;
> -       struct smb2_query_info_rsp *qi_rsp = NULL;
> -       int resp_buftype[2];
> -       struct smb_rqst rqst[2];
> -       struct kvec rsp_iov[2];
> -       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> -       struct kvec qi_iov[1];
> -       int rc, flags = 0;
> -       __le16 utf16_path = 0; /* Null - since an open of top of share */
> -       u8 oplock = SMB2_OPLOCK_LEVEL_II;
> -       struct cifs_fid *pfid;
> -       struct dentry *dentry;
> -
> -       if (tcon == NULL || tcon->nohandlecache ||
> -           is_smb1_server(tcon->ses->server))
> -               return -ENOTSUPP;
> -
> -       ses = tcon->ses;
> -       server = ses->server;
> -
> -       if (cifs_sb->root == NULL)
> -               return -ENOENT;
> -
> -       if (strlen(path))
> -               return -ENOENT;
> -
> -       dentry = cifs_sb->root;
> -
> -       mutex_lock(&tcon->crfid.fid_mutex);
> -       if (tcon->crfid.is_valid) {
> -               cifs_dbg(FYI, "found a cached root file handle\n");
> -               *cfid = &tcon->crfid;
> -               kref_get(&tcon->crfid.refcount);
> -               mutex_unlock(&tcon->crfid.fid_mutex);
> -               return 0;
> -       }
> -
> -       /*
> -        * We do not hold the lock for the open because in case
> -        * SMB2_open needs to reconnect, it will end up calling
> -        * cifs_mark_open_files_invalid() which takes the lock again
> -        * thus causing a deadlock
> -        */
> -
> -       mutex_unlock(&tcon->crfid.fid_mutex);
> -
> -       if (smb3_encryption_required(tcon))
> -               flags |= CIFS_TRANSFORM_REQ;
> -
> -       if (!server->ops->new_lease_key)
> -               return -EIO;
> -
> -       pfid = tcon->crfid.fid;
> -       server->ops->new_lease_key(pfid);
> -
> -       memset(rqst, 0, sizeof(rqst));
> -       resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
> -       memset(rsp_iov, 0, sizeof(rsp_iov));
> -
> -       /* Open */
> -       memset(&open_iov, 0, sizeof(open_iov));
> -       rqst[0].rq_iov = open_iov;
> -       rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
> -
> -       oparms.tcon = tcon;
> -       oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
> -       oparms.desired_access = FILE_READ_ATTRIBUTES;
> -       oparms.disposition = FILE_OPEN;
> -       oparms.fid = pfid;
> -       oparms.reconnect = false;
> -
> -       rc = SMB2_open_init(tcon, server,
> -                           &rqst[0], &oplock, &oparms, &utf16_path);
> -       if (rc)
> -               goto oshr_free;
> -       smb2_set_next_command(tcon, &rqst[0]);
> -
> -       memset(&qi_iov, 0, sizeof(qi_iov));
> -       rqst[1].rq_iov = qi_iov;
> -       rqst[1].rq_nvec = 1;
> -
> -       rc = SMB2_query_info_init(tcon, server,
> -                                 &rqst[1], COMPOUND_FID,
> -                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> -                                 SMB2_O_INFO_FILE, 0,
> -                                 sizeof(struct smb2_file_all_info) +
> -                                 PATH_MAX * 2, 0, NULL);
> -       if (rc)
> -               goto oshr_free;
> -
> -       smb2_set_related(&rqst[1]);
> -
> -       rc = compound_send_recv(xid, ses, server,
> -                               flags, 2, rqst,
> -                               resp_buftype, rsp_iov);
> -       mutex_lock(&tcon->crfid.fid_mutex);
> -
> -       /*
> -        * Now we need to check again as the cached root might have
> -        * been successfully re-opened from a concurrent process
> -        */
> -
> -       if (tcon->crfid.is_valid) {
> -               /* work was already done */
> -
> -               /* stash fids for close() later */
> -               struct cifs_fid fid = {
> -                       .persistent_fid = pfid->persistent_fid,
> -                       .volatile_fid = pfid->volatile_fid,
> -               };
> -
> -               /*
> -                * caller expects this func to set the fid in crfid to valid
> -                * cached root, so increment the refcount.
> -                */
> -               kref_get(&tcon->crfid.refcount);
> -
> -               mutex_unlock(&tcon->crfid.fid_mutex);
> -
> -               if (rc == 0) {
> -                       /* close extra handle outside of crit sec */
> -                       SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> -               }
> -               rc = 0;
> -               goto oshr_free;
> -       }
> -
> -       /* Cached root is still invalid, continue normaly */
> -
> -       if (rc) {
> -               if (rc == -EREMCHG) {
> -                       tcon->need_reconnect = true;
> -                       pr_warn_once("server share %s deleted\n",
> -                                    tcon->treeName);
> -               }
> -               goto oshr_exit;
> -       }
> -
> -       atomic_inc(&tcon->num_remote_opens);
> -
> -       o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> -       oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> -       oparms.fid->volatile_fid = o_rsp->VolatileFileId;
> -#ifdef CONFIG_CIFS_DEBUG2
> -       oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
> -#endif /* CIFS_DEBUG2 */
> -
> -       tcon->crfid.tcon = tcon;
> -       tcon->crfid.is_valid = true;
> -       tcon->crfid.dentry = dentry;
> -       dget(dentry);
> -       kref_init(&tcon->crfid.refcount);
> -
> -       /* BB TBD check to see if oplock level check can be removed below */
> -       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> -               /*
> -                * See commit 2f94a3125b87. Increment the refcount when we
> -                * get a lease for root, release it if lease break occurs
> -                */
> -               kref_get(&tcon->crfid.refcount);
> -               tcon->crfid.has_lease = true;
> -               smb2_parse_contexts(server, o_rsp,
> -                               &oparms.fid->epoch,
> -                                   oparms.fid->lease_key, &oplock,
> -                                   NULL, NULL);
> -       } else
> -               goto oshr_exit;
> -
> -       qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> -       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> -               goto oshr_exit;
> -       if (!smb2_validate_and_copy_iov(
> -                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> -                               sizeof(struct smb2_file_all_info),
> -                               &rsp_iov[1], sizeof(struct smb2_file_all_info),
> -                               (char *)&tcon->crfid.file_all_info))
> -               tcon->crfid.file_all_info_is_valid = true;
> -       tcon->crfid.time = jiffies;
> -
> -
> -oshr_exit:
> -       mutex_unlock(&tcon->crfid.fid_mutex);
> -oshr_free:
> -       SMB2_open_free(&rqst[0]);
> -       SMB2_query_info_free(&rqst[1]);
> -       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> -       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> -       if (rc == 0)
> -               *cfid = &tcon->crfid;
> -       return rc;
> -}
> -
> -int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> -                             struct dentry *dentry,
> -                             struct cached_fid **cfid)
> -{
> -       mutex_lock(&tcon->crfid.fid_mutex);
> -       if (tcon->crfid.dentry == dentry) {
> -               cifs_dbg(FYI, "found a cached root file handle by dentry\n");
> -               *cfid = &tcon->crfid;
> -               kref_get(&tcon->crfid.refcount);
> -               mutex_unlock(&tcon->crfid.fid_mutex);
> -               return 0;
> -       }
> -       mutex_unlock(&tcon->crfid.fid_mutex);
> -       return -ENOENT;
> -}
> -
>  static void
>  smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>               struct cifs_sb_info *cifs_sb)
> @@ -1077,7 +784,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>         struct cifs_open_parms oparms;
>         struct cifs_fid fid;
>
> -       if ((*full_path == 0) && tcon->crfid.is_valid)
> +       if ((*full_path == 0) && tcon->cfid.is_valid)
>                 return 0;
>
>         utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 295ee8b88055..9ee1b6225619 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -39,6 +39,7 @@
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dfs_cache.h"
>  #endif
> +#include "cached_dir.h"
>
>  /*
>   *  The following table defines the expected "StructureSize" of SMB2 requests
> @@ -1978,7 +1979,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
>         }
>         spin_unlock(&ses->chan_lock);
>
> -       close_cached_dir_lease(&tcon->crfid);
> +       close_cached_dir_lease(&tcon->cfid);
>
>         rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
>                                  (void **) &req,
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index a69f1eed1cfe..51c5bf4a338a 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -54,16 +54,6 @@ extern bool smb2_is_valid_oplock_break(char *buffer,
>  extern int smb3_handle_read_data(struct TCP_Server_Info *server,
>                                  struct mid_q_entry *mid);
>
> -extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> -                          const char *path,
> -                          struct cifs_sb_info *cifs_sb,
> -                          struct cached_fid **cfid);
> -extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> -                                    struct dentry *dentry,
> -                                    struct cached_fid **cfid);
> -extern void close_cached_dir(struct cached_fid *cfid);
> -extern void close_cached_dir_lease(struct cached_fid *cfid);
> -extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
>  extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
>                                    struct smb2_file_all_info *src);
>  extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
> --
> 2.35.3
>


-- 
Thanks,

Steve

--00000000000075ffe505e5ee473b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Move-cached-dir-functions-into-a-separate-file.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Move-cached-dir-functions-into-a-separate-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6og48ym0>
X-Attachment-Id: f_l6og48ym0

RnJvbSAyNzRjNDQxOTZjMDkzNWY2NjljODgyN2UxNjY1ZWFjZTdkN2Y0NjcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgQXVnIDIwMjIgMjE6NTA6MTEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBNb3ZlIGNhY2hlZC1kaXIgZnVuY3Rpb25zIGludG8gYSBzZXBhcmF0ZSBmaWxlCgpBbHNv
IHJlbmFtZSBjcmZpZCB0byBjZmlkIHRvIGhhdmUgY29uc2lzdGVudCBuYW1pbmcgZm9yIHRoaXMg
dmFyaWFibGUuCgpUaGlzIGNvbW1pdCBkb2VzIG5vdCBjaGFuZ2UgYW55IGxvZ2ljLgoKU2lnbmVk
LW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9N
YWtlZmlsZSAgICB8ICAgMiArLQogZnMvY2lmcy9jaWZzZnMuYyAgICB8ICAyMCArLS0KIGZzL2Np
ZnMvY2lmc2dsb2IuaCAgfCAgIDIgKy0KIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAgIDEgLQogZnMv
Y2lmcy9maWxlLmMgICAgICB8ICAgOSArLQogZnMvY2lmcy9pbm9kZS5jICAgICB8ICAgMSArCiBm
cy9jaWZzL21pc2MuYyAgICAgIHwgIDEyICstCiBmcy9jaWZzL3JlYWRkaXIuYyAgIHwgICAxICsK
IGZzL2NpZnMvc21iMmlub2RlLmMgfCAgIDUgKy0KIGZzL2NpZnMvc21iMm1pc2MuYyAgfCAgMTEg
Ky0KIGZzL2NpZnMvc21iMm9wcy5jICAgfCAyOTcgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KIGZzL2NpZnMvc21iMnBkdS5jICAgfCAgIDMgKy0KIGZzL2NpZnMv
c21iMnByb3RvLmggfCAgMTAgLS0KIDEzIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyks
IDM1MSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL01ha2VmaWxlIGIvZnMvY2lm
cy9NYWtlZmlsZQppbmRleCBlODgyZTkxMmE1MTcuLjdjOTc4NTk3M2Y0OSAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9NYWtlZmlsZQorKysgYi9mcy9jaWZzL01ha2VmaWxlCkBAIC03LDcgKzcsNyBAQCBv
YmotJChDT05GSUdfQ0lGUykgKz0gY2lmcy5vCiAKIGNpZnMteSA6PSB0cmFjZS5vIGNpZnNmcy5v
IGNpZnNfZGVidWcubyBjb25uZWN0Lm8gZGlyLm8gZmlsZS5vIFwKIAkgIGlub2RlLm8gbGluay5v
IG1pc2MubyBuZXRtaXNjLm8gc21iZW5jcnlwdC5vIHRyYW5zcG9ydC5vIFwKLQkgIGNpZnNfdW5p
Y29kZS5vIG50ZXJyLm8gY2lmc2VuY3J5cHQubyBcCisJICBjYWNoZWRfZGlyLm8gY2lmc191bmlj
b2RlLm8gbnRlcnIubyBjaWZzZW5jcnlwdC5vIFwKIAkgIHJlYWRkaXIubyBpb2N0bC5vIHNlc3Mu
byBleHBvcnQubyB1bmMubyB3aW51Y2FzZS5vIFwKIAkgIHNtYjJvcHMubyBzbWIybWFwZXJyb3Iu
byBzbWIydHJhbnNwb3J0Lm8gXAogCSAgc21iMm1pc2MubyBzbWIycGR1Lm8gc21iMmlub2RlLm8g
c21iMmZpbGUubyBjaWZzYWNsLm8gZnNfY29udGV4dC5vIFwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
Y2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IDg4NDlmMDg1MjExMC4uOTQ1ZmIwODNj
ZWE3IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMK
QEAgLTQ2LDYgKzQ2LDcgQEAKICNpbmNsdWRlICJuZXRsaW5rLmgiCiAjZW5kaWYKICNpbmNsdWRl
ICJmc19jb250ZXh0LmgiCisjaW5jbHVkZSAiY2FjaGVkX2Rpci5oIgogCiAvKgogICogRE9TIGRh
dGVzIGZyb20gMTk4MC8xLzEgdGhyb3VnaCAyMTA3LzEyLzMxCkBAIC0yODMsMzAgKzI4NCwxMyBA
QCBjaWZzX3JlYWRfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIHN0YXRpYyB2b2lkIGNp
ZnNfa2lsbF9zYihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogewogCXN0cnVjdCBjaWZzX3NiX2lu
Zm8gKmNpZnNfc2IgPSBDSUZTX1NCKHNiKTsKLQlzdHJ1Y3QgY2lmc190Y29uICp0Y29uOwotCXN0
cnVjdCBjYWNoZWRfZmlkICpjZmlkOwotCXN0cnVjdCByYl9yb290ICpyb290ID0gJmNpZnNfc2It
PnRsaW5rX3RyZWU7Ci0Jc3RydWN0IHJiX25vZGUgKm5vZGU7Ci0Jc3RydWN0IHRjb25fbGluayAq
dGxpbms7CiAKIAkvKgogCSAqIFdlIG5lZCB0byByZWxlYXNlIGFsbCBkZW50cmllcyBmb3IgdGhl
IGNhY2hlZCBkaXJlY3RvcmllcwogCSAqIGJlZm9yZSB3ZSBraWxsIHRoZSBzYi4KIAkgKi8KIAlp
ZiAoY2lmc19zYi0+cm9vdCkgewotCQlmb3IgKG5vZGUgPSByYl9maXJzdChyb290KTsgbm9kZTsg
bm9kZSA9IHJiX25leHQobm9kZSkpIHsKLQkJCXRsaW5rID0gcmJfZW50cnkobm9kZSwgc3RydWN0
IHRjb25fbGluaywgdGxfcmJub2RlKTsKLQkJCXRjb24gPSB0bGlua190Y29uKHRsaW5rKTsKLQkJ
CWlmIChJU19FUlIodGNvbikpCi0JCQkJY29udGludWU7Ci0JCQljZmlkID0gJnRjb24tPmNyZmlk
OwotCQkJbXV0ZXhfbG9jaygmY2ZpZC0+ZmlkX211dGV4KTsKLQkJCWlmIChjZmlkLT5kZW50cnkp
IHsKLQkJCQlkcHV0KGNmaWQtPmRlbnRyeSk7Ci0JCQkJY2ZpZC0+ZGVudHJ5ID0gTlVMTDsKLQkJ
CX0KLQkJCW11dGV4X3VubG9jaygmY2ZpZC0+ZmlkX211dGV4KTsKLQkJfQorCQljbG9zZV9hbGxf
Y2FjaGVkX2RpcnMoY2lmc19zYik7CiAKIAkJLyogZmluYWxseSByZWxlYXNlIHJvb3QgZGVudHJ5
ICovCiAJCWRwdXQoY2lmc19zYi0+cm9vdCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9i
LmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggYTkzMDI0ZWFmMjUxLi44YjgyZjEzZDExZTAg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgK
QEAgLTEyNTcsNyArMTI1Nyw3IEBAIHN0cnVjdCBjaWZzX3Rjb24gewogCXN0cnVjdCBmc2NhY2hl
X3ZvbHVtZSAqZnNjYWNoZTsJLyogY29va2llIGZvciBzaGFyZSAqLwogI2VuZGlmCiAJc3RydWN0
IGxpc3RfaGVhZCBwZW5kaW5nX29wZW5zOwkvKiBsaXN0IG9mIGluY29tcGxldGUgb3BlbnMgKi8K
LQlzdHJ1Y3QgY2FjaGVkX2ZpZCBjcmZpZDsgLyogQ2FjaGVkIHJvb3QgZmlkICovCisJc3RydWN0
IGNhY2hlZF9maWQgY2ZpZDsgLyogQ2FjaGVkIHJvb3QgZmlkICovCiAJLyogQkIgYWRkIGZpZWxk
IGZvciBiYWNrIHBvaW50ZXIgdG8gc2Igc3RydWN0KHMpPyAqLwogI2lmZGVmIENPTkZJR19DSUZT
X0RGU19VUENBTEwKIAlzdHJ1Y3QgbGlzdF9oZWFkIHVsaXN0OyAvKiBjYWNoZSB1cGRhdGUgbGlz
dCAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMvY2lmc3Byb3Rv
LmgKaW5kZXggZGFhYWRmZmEyYjg4Li44N2E3N2E2ODQzMzkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
Y2lmc3Byb3RvLmgKKysrIGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtNTk3LDcgKzU5Nyw2IEBA
IGVudW0gc2VjdXJpdHlFbnVtIGNpZnNfc2VsZWN0X3NlY3R5cGUoc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqLAogc3RydWN0IGNpZnNfYWlvX2N0eCAqY2lmc19haW9fY3R4X2FsbG9jKHZvaWQpOwog
dm9pZCBjaWZzX2Fpb19jdHhfcmVsZWFzZShzdHJ1Y3Qga3JlZiAqcmVmY291bnQpOwogaW50IHNl
dHVwX2Fpb19jdHhfaXRlcihzdHJ1Y3QgY2lmc19haW9fY3R4ICpjdHgsIHN0cnVjdCBpb3ZfaXRl
ciAqaXRlciwgaW50IHJ3KTsKLXZvaWQgc21iMl9jYWNoZWRfbGVhc2VfYnJlYWsoc3RydWN0IHdv
cmtfc3RydWN0ICp3b3JrKTsKIAogaW50IGNpZnNfYWxsb2NfaGFzaChjb25zdCBjaGFyICpuYW1l
LCBzdHJ1Y3QgY3J5cHRvX3NoYXNoICoqc2hhc2gsCiAJCSAgICBzdHJ1Y3Qgc2Rlc2MgKipzZGVz
Yyk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IDA5
OTc1YmQ3ZDg2MC4uNDJmMjYzOWExYTY2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysg
Yi9mcy9jaWZzL2ZpbGUuYwpAQCAtMzQsNiArMzQsNyBAQAogI2luY2x1ZGUgInNtYmRpcmVjdC5o
IgogI2luY2x1ZGUgImZzX2NvbnRleHQuaCIKICNpbmNsdWRlICJjaWZzX2lvY3RsLmgiCisjaW5j
bHVkZSAiY2FjaGVkX2Rpci5oIgogCiAvKgogICogTWFyayBhcyBpbnZhbGlkLCBhbGwgb3BlbiBm
aWxlcyBvbiB0cmVlIGNvbm5lY3Rpb25zIHNpbmNlIHRoZXkKQEAgLTY0LDEzICs2NSw3IEBAIGNp
ZnNfbWFya19vcGVuX2ZpbGVzX2ludmFsaWQoc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKIAl9CiAJ
c3Bpbl91bmxvY2soJnRjb24tPm9wZW5fZmlsZV9sb2NrKTsKIAotCW11dGV4X2xvY2soJnRjb24t
PmNyZmlkLmZpZF9tdXRleCk7Ci0JdGNvbi0+Y3JmaWQuaXNfdmFsaWQgPSBmYWxzZTsKLQkvKiBj
YWNoZWQgaGFuZGxlIGlzIG5vdCB2YWxpZCwgc28gU01CMl9DTE9TRSB3b24ndCBiZSBzZW50IGJl
bG93ICovCi0JY2xvc2VfY2FjaGVkX2Rpcl9sZWFzZV9sb2NrZWQoJnRjb24tPmNyZmlkKTsKLQlt
ZW1zZXQodGNvbi0+Y3JmaWQuZmlkLCAwLCBzaXplb2Yoc3RydWN0IGNpZnNfZmlkKSk7Ci0JbXV0
ZXhfdW5sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwotCisJaW52YWxpZGF0ZV9hbGxfY2Fj
aGVkX2RpcnModGNvbik7CiAJc3Bpbl9sb2NrKCZ0Y29uLT50Y19sb2NrKTsKIAlpZiAodGNvbi0+
c3RhdHVzID09IFRJRF9JTl9GSUxFU19JTlZBTElEQVRFKQogCQl0Y29uLT5zdGF0dXMgPSBUSURf
TkVFRF9UQ09OOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5j
CmluZGV4IGVlZWFiYTNkZWMwNS4uYmFjMDhjMjBmNTU5IDEwMDY0NAotLS0gYS9mcy9jaWZzL2lu
b2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5jCkBAIC0yNSw2ICsyNSw3IEBACiAjaW5jbHVkZSAi
ZnNjYWNoZS5oIgogI2luY2x1ZGUgImZzX2NvbnRleHQuaCIKICNpbmNsdWRlICJjaWZzX2lvY3Rs
LmgiCisjaW5jbHVkZSAiY2FjaGVkX2Rpci5oIgogCiBzdGF0aWMgdm9pZCBjaWZzX3NldF9vcHMo
c3RydWN0IGlub2RlICppbm9kZSkKIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvbWlzYy5jIGIvZnMv
Y2lmcy9taXNjLmMKaW5kZXggN2E5MDYwNjdkYjA0Li5lYTA0MDVjZmFlZTMgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvbWlzYy5jCisrKyBiL2ZzL2NpZnMvbWlzYy5jCkBAIC0xMTYsMTMgKzExNiwxMyBA
QCB0Y29uSW5mb0FsbG9jKHZvaWQpCiAJcmV0X2J1ZiA9IGt6YWxsb2Moc2l6ZW9mKCpyZXRfYnVm
KSwgR0ZQX0tFUk5FTCk7CiAJaWYgKCFyZXRfYnVmKQogCQlyZXR1cm4gTlVMTDsKLQlyZXRfYnVm
LT5jcmZpZC5maWQgPSBremFsbG9jKHNpemVvZigqcmV0X2J1Zi0+Y3JmaWQuZmlkKSwgR0ZQX0tF
Uk5FTCk7Ci0JaWYgKCFyZXRfYnVmLT5jcmZpZC5maWQpIHsKKwlyZXRfYnVmLT5jZmlkLmZpZCA9
IGt6YWxsb2Moc2l6ZW9mKCpyZXRfYnVmLT5jZmlkLmZpZCksIEdGUF9LRVJORUwpOworCWlmICgh
cmV0X2J1Zi0+Y2ZpZC5maWQpIHsKIAkJa2ZyZWUocmV0X2J1Zik7CiAJCXJldHVybiBOVUxMOwog
CX0KLQlJTklUX0xJU1RfSEVBRCgmcmV0X2J1Zi0+Y3JmaWQuZGlyZW50cy5lbnRyaWVzKTsKLQlt
dXRleF9pbml0KCZyZXRfYnVmLT5jcmZpZC5kaXJlbnRzLmRlX211dGV4KTsKKwlJTklUX0xJU1Rf
SEVBRCgmcmV0X2J1Zi0+Y2ZpZC5kaXJlbnRzLmVudHJpZXMpOworCW11dGV4X2luaXQoJnJldF9i
dWYtPmNmaWQuZGlyZW50cy5kZV9tdXRleCk7CiAKIAlhdG9taWNfaW5jKCZ0Y29uSW5mb0FsbG9j
Q291bnQpOwogCXJldF9idWYtPnN0YXR1cyA9IFRJRF9ORVc7CkBAIC0xMzEsNyArMTMxLDcgQEAg
dGNvbkluZm9BbGxvYyh2b2lkKQogCUlOSVRfTElTVF9IRUFEKCZyZXRfYnVmLT5vcGVuRmlsZUxp
c3QpOwogCUlOSVRfTElTVF9IRUFEKCZyZXRfYnVmLT50Y29uX2xpc3QpOwogCXNwaW5fbG9ja19p
bml0KCZyZXRfYnVmLT5vcGVuX2ZpbGVfbG9jayk7Ci0JbXV0ZXhfaW5pdCgmcmV0X2J1Zi0+Y3Jm
aWQuZmlkX211dGV4KTsKKwltdXRleF9pbml0KCZyZXRfYnVmLT5jZmlkLmZpZF9tdXRleCk7CiAJ
c3Bpbl9sb2NrX2luaXQoJnJldF9idWYtPnN0YXRfbG9jayk7CiAJYXRvbWljX3NldCgmcmV0X2J1
Zi0+bnVtX2xvY2FsX29wZW5zLCAwKTsKIAlhdG9taWNfc2V0KCZyZXRfYnVmLT5udW1fcmVtb3Rl
X29wZW5zLCAwKTsKQEAgLTE0OSw3ICsxNDksNyBAQCB0Y29uSW5mb0ZyZWUoc3RydWN0IGNpZnNf
dGNvbiAqYnVmX3RvX2ZyZWUpCiAJYXRvbWljX2RlYygmdGNvbkluZm9BbGxvY0NvdW50KTsKIAlr
ZnJlZShidWZfdG9fZnJlZS0+bmF0aXZlRmlsZVN5c3RlbSk7CiAJa2ZyZWVfc2Vuc2l0aXZlKGJ1
Zl90b19mcmVlLT5wYXNzd29yZCk7Ci0Ja2ZyZWUoYnVmX3RvX2ZyZWUtPmNyZmlkLmZpZCk7CisJ
a2ZyZWUoYnVmX3RvX2ZyZWUtPmNmaWQuZmlkKTsKIAlrZnJlZShidWZfdG9fZnJlZSk7CiB9CiAK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvcmVhZGRpci5jIGIvZnMvY2lmcy9yZWFkZGlyLmMKaW5kZXgg
Mzg0Y2FiZGY0N2NhLi5hMDYwNzJhZTZjN2UgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvcmVhZGRpci5j
CisrKyBiL2ZzL2NpZnMvcmVhZGRpci5jCkBAIC0yMSw2ICsyMSw3IEBACiAjaW5jbHVkZSAiY2lm
c2ZzLmgiCiAjaW5jbHVkZSAic21iMnByb3RvLmgiCiAjaW5jbHVkZSAiZnNfY29udGV4dC5oIgor
I2luY2x1ZGUgImNhY2hlZF9kaXIuaCIKIAogLyoKICAqIFRvIGJlIHNhZmUgLSBmb3IgVUNTIHRv
IFVURi04IHdpdGggc3RyaW5ncyBsb2FkZWQgd2l0aCB0aGUgcmFyZSBsb25nCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJpbm9kZS5jIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwppbmRleCA4NTcxYTQ1
OWM3MTAuLmY2ZjlmYzNmMmUyZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyaW5vZGUuYworKysg
Yi9mcy9jaWZzL3NtYjJpbm9kZS5jCkBAIC0yMyw2ICsyMyw3IEBACiAjaW5jbHVkZSAic21iMmds
b2IuaCIKICNpbmNsdWRlICJzbWIycGR1LmgiCiAjaW5jbHVkZSAic21iMnByb3RvLmgiCisjaW5j
bHVkZSAiY2FjaGVkX2Rpci5oIgogCiBzdGF0aWMgdm9pZAogZnJlZV9zZXRfaW5mX2NvbXBvdW5k
KHN0cnVjdCBzbWJfcnFzdCAqcnFzdCkKQEAgLTUxOCw5ICs1MTksOSBAQCBzbWIyX3F1ZXJ5X3Bh
dGhfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CQlyYyA9IG9wZW5fY2FjaGVkX2Rpcih4aWQsIHRjb24sIGZ1bGxfcGF0aCwgY2lmc19zYiwgJmNm
aWQpOwogCS8qIElmIGl0IGlzIGEgcm9vdCBhbmQgaXRzIGhhbmRsZSBpcyBjYWNoZWQgdGhlbiB1
c2UgaXQgKi8KIAlpZiAoIXJjKSB7Ci0JCWlmICh0Y29uLT5jcmZpZC5maWxlX2FsbF9pbmZvX2lz
X3ZhbGlkKSB7CisJCWlmICh0Y29uLT5jZmlkLmZpbGVfYWxsX2luZm9faXNfdmFsaWQpIHsKIAkJ
CW1vdmVfc21iMl9pbmZvX3RvX2NpZnMoZGF0YSwKLQkJCQkJICAgICAgICZ0Y29uLT5jcmZpZC5m
aWxlX2FsbF9pbmZvKTsKKwkJCQkJICAgICAgICZ0Y29uLT5jZmlkLmZpbGVfYWxsX2luZm8pOwog
CQl9IGVsc2UgewogCQkJcmMgPSBTTUIyX3F1ZXJ5X2luZm8oeGlkLCB0Y29uLAogCQkJCQkgICAg
IGNmaWQtPmZpZC0+cGVyc2lzdGVudF9maWQsCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtaXNj
LmMgYi9mcy9jaWZzL3NtYjJtaXNjLmMKaW5kZXggODE4Y2M0ZGVlMGUyLi42YTZlYzZlZmI0NWEg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm1pc2MuYworKysgYi9mcy9jaWZzL3NtYjJtaXNjLmMK
QEAgLTE2LDYgKzE2LDcgQEAKICNpbmNsdWRlICJzbWIyc3RhdHVzLmgiCiAjaW5jbHVkZSAic21i
Mmdsb2IuaCIKICNpbmNsdWRlICJudGVyci5oIgorI2luY2x1ZGUgImNhY2hlZF9kaXIuaCIKIAog
c3RhdGljIGludAogY2hlY2tfc21iMl9oZHIoc3RydWN0IHNtYjJfaGRyICpzaGRyLCBfX3U2NCBt
aWQpCkBAIC02NDgsMTUgKzY0OSw3IEBAIHNtYjJfaXNfdmFsaWRfbGVhc2VfYnJlYWsoY2hhciAq
YnVmZmVyKQogCQkJCX0KIAkJCQlzcGluX3VubG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2spOwog
Ci0JCQkJaWYgKHRjb24tPmNyZmlkLmlzX3ZhbGlkICYmCi0JCQkJICAgICFtZW1jbXAocnNwLT5M
ZWFzZUtleSwKLQkJCQkJICAgIHRjb24tPmNyZmlkLmZpZC0+bGVhc2Vfa2V5LAotCQkJCQkgICAg
U01CMl9MRUFTRV9LRVlfU0laRSkpIHsKLQkJCQkJdGNvbi0+Y3JmaWQudGltZSA9IDA7Ci0JCQkJ
CUlOSVRfV09SSygmdGNvbi0+Y3JmaWQubGVhc2VfYnJlYWssCi0JCQkJCQkgIHNtYjJfY2FjaGVk
X2xlYXNlX2JyZWFrKTsKLQkJCQkJcXVldWVfd29yayhjaWZzaW9kX3dxLAotCQkJCQkJICAgJnRj
b24tPmNyZmlkLmxlYXNlX2JyZWFrKTsKKwkJCQlpZiAoY2FjaGVkX2Rpcl9sZWFzZV9icmVhayh0
Y29uLCByc3AtPkxlYXNlS2V5KSkgewogCQkJCQlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xv
Y2spOwogCQkJCQlyZXR1cm4gdHJ1ZTsKIAkJCQl9CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJv
cHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IGMwMDM5ZGMwNzE1YS4uOGNiMWVlZDFkZDYz
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpA
QCAtMjcsNiArMjcsNyBAQAogI2luY2x1ZGUgInNtYmRpcmVjdC5oIgogI2luY2x1ZGUgImZzY2Fj
aGUuaCIKICNpbmNsdWRlICJmc19jb250ZXh0LmgiCisjaW5jbHVkZSAiY2FjaGVkX2Rpci5oIgog
CiAvKiBDaGFuZ2UgY3JlZGl0cyBmb3IgZGlmZmVyZW50IG9wcyBhbmQgcmV0dXJuIHRoZSB0b3Rh
bCBudW1iZXIgb2YgY3JlZGl0cyAqLwogc3RhdGljIGludApAQCAtNzAxLDMwMCArNzAyLDYgQEAg
U01CM19yZXF1ZXN0X2ludGVyZmFjZXMoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbikKIAlyZXR1cm4gcmM7CiB9CiAKLXN0YXRpYyB2b2lkCi1zbWIyX2Nsb3Nl
X2NhY2hlZF9maWQoc3RydWN0IGtyZWYgKnJlZikKLXsKLQlzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2Zp
ZCA9IGNvbnRhaW5lcl9vZihyZWYsIHN0cnVjdCBjYWNoZWRfZmlkLAotCQkJCQkgICAgICAgcmVm
Y291bnQpOwotCXN0cnVjdCBjYWNoZWRfZGlyZW50ICpkaXJlbnQsICpxOwotCi0JaWYgKGNmaWQt
PmlzX3ZhbGlkKSB7Ci0JCWNpZnNfZGJnKEZZSSwgImNsZWFyIGNhY2hlZCByb290IGZpbGUgaGFu
ZGxlXG4iKTsKLQkJU01CMl9jbG9zZSgwLCBjZmlkLT50Y29uLCBjZmlkLT5maWQtPnBlcnNpc3Rl
bnRfZmlkLAotCQkJICAgY2ZpZC0+ZmlkLT52b2xhdGlsZV9maWQpOwotCX0KLQotCS8qCi0JICog
V2Ugb25seSBjaGVjayB2YWxpZGl0eSBhYm92ZSB0byBzZW5kIFNNQjJfY2xvc2UsCi0JICogYnV0
IHdlIHN0aWxsIG5lZWQgdG8gaW52YWxpZGF0ZSB0aGVzZSBlbnRyaWVzCi0JICogd2hlbiB0aGlz
IGZ1bmN0aW9uIGlzIGNhbGxlZAotCSAqLwotCWNmaWQtPmlzX3ZhbGlkID0gZmFsc2U7Ci0JY2Zp
ZC0+ZmlsZV9hbGxfaW5mb19pc192YWxpZCA9IGZhbHNlOwotCWNmaWQtPmhhc19sZWFzZSA9IGZh
bHNlOwotCWlmIChjZmlkLT5kZW50cnkpIHsKLQkJZHB1dChjZmlkLT5kZW50cnkpOwotCQljZmlk
LT5kZW50cnkgPSBOVUxMOwotCX0KLQkvKgotCSAqIERlbGV0ZSBhbGwgY2FjaGVkIGRpcmVudCBu
YW1lcwotCSAqLwotCW11dGV4X2xvY2soJmNmaWQtPmRpcmVudHMuZGVfbXV0ZXgpOwotCWxpc3Rf
Zm9yX2VhY2hfZW50cnlfc2FmZShkaXJlbnQsIHEsICZjZmlkLT5kaXJlbnRzLmVudHJpZXMsIGVu
dHJ5KSB7Ci0JCWxpc3RfZGVsKCZkaXJlbnQtPmVudHJ5KTsKLQkJa2ZyZWUoZGlyZW50LT5uYW1l
KTsKLQkJa2ZyZWUoZGlyZW50KTsKLQl9Ci0JY2ZpZC0+ZGlyZW50cy5pc192YWxpZCA9IDA7Ci0J
Y2ZpZC0+ZGlyZW50cy5pc19mYWlsZWQgPSAwOwotCWNmaWQtPmRpcmVudHMuY3R4ID0gTlVMTDsK
LQljZmlkLT5kaXJlbnRzLnBvcyA9IDA7Ci0JbXV0ZXhfdW5sb2NrKCZjZmlkLT5kaXJlbnRzLmRl
X211dGV4KTsKLQotfQotCi12b2lkIGNsb3NlX2NhY2hlZF9kaXIoc3RydWN0IGNhY2hlZF9maWQg
KmNmaWQpCi17Ci0JbXV0ZXhfbG9jaygmY2ZpZC0+ZmlkX211dGV4KTsKLQlrcmVmX3B1dCgmY2Zp
ZC0+cmVmY291bnQsIHNtYjJfY2xvc2VfY2FjaGVkX2ZpZCk7Ci0JbXV0ZXhfdW5sb2NrKCZjZmlk
LT5maWRfbXV0ZXgpOwotfQotCi12b2lkIGNsb3NlX2NhY2hlZF9kaXJfbGVhc2VfbG9ja2VkKHN0
cnVjdCBjYWNoZWRfZmlkICpjZmlkKQotewotCWlmIChjZmlkLT5oYXNfbGVhc2UpIHsKLQkJY2Zp
ZC0+aGFzX2xlYXNlID0gZmFsc2U7Ci0JCWtyZWZfcHV0KCZjZmlkLT5yZWZjb3VudCwgc21iMl9j
bG9zZV9jYWNoZWRfZmlkKTsKLQl9Ci19Ci0KLXZvaWQgY2xvc2VfY2FjaGVkX2Rpcl9sZWFzZShz
dHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCkKLXsKLQltdXRleF9sb2NrKCZjZmlkLT5maWRfbXV0ZXgp
OwotCWNsb3NlX2NhY2hlZF9kaXJfbGVhc2VfbG9ja2VkKGNmaWQpOwotCW11dGV4X3VubG9jaygm
Y2ZpZC0+ZmlkX211dGV4KTsKLX0KLQotdm9pZAotc21iMl9jYWNoZWRfbGVhc2VfYnJlYWsoc3Ry
dWN0IHdvcmtfc3RydWN0ICp3b3JrKQotewotCXN0cnVjdCBjYWNoZWRfZmlkICpjZmlkID0gY29u
dGFpbmVyX29mKHdvcmssCi0JCQkJc3RydWN0IGNhY2hlZF9maWQsIGxlYXNlX2JyZWFrKTsKLQot
CWNsb3NlX2NhY2hlZF9kaXJfbGVhc2UoY2ZpZCk7Ci19Ci0KLS8qCi0gKiBPcGVuIHRoZSBhbmQg
Y2FjaGUgYSBkaXJlY3RvcnkgaGFuZGxlLgotICogT25seSBzdXBwb3J0ZWQgZm9yIHRoZSByb290
IGhhbmRsZS4KLSAqIElmIGVycm9yIHRoZW4gKmNmaWQgaXMgbm90IGluaXRpYWxpemVkLgotICov
Ci1pbnQgb3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24sCi0JCWNvbnN0IGNoYXIgKnBhdGgsCi0JCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNf
c2IsCi0JCXN0cnVjdCBjYWNoZWRfZmlkICoqY2ZpZCkKLXsKLQlzdHJ1Y3QgY2lmc19zZXMgKnNl
czsKLQlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7Ci0Jc3RydWN0IGNpZnNfb3Blbl9w
YXJtcyBvcGFybXM7Ci0Jc3RydWN0IHNtYjJfY3JlYXRlX3JzcCAqb19yc3AgPSBOVUxMOwotCXN0
cnVjdCBzbWIyX3F1ZXJ5X2luZm9fcnNwICpxaV9yc3AgPSBOVUxMOwotCWludCByZXNwX2J1ZnR5
cGVbMl07Ci0Jc3RydWN0IHNtYl9ycXN0IHJxc3RbMl07Ci0Jc3RydWN0IGt2ZWMgcnNwX2lvdlsy
XTsKLQlzdHJ1Y3Qga3ZlYyBvcGVuX2lvdltTTUIyX0NSRUFURV9JT1ZfU0laRV07Ci0Jc3RydWN0
IGt2ZWMgcWlfaW92WzFdOwotCWludCByYywgZmxhZ3MgPSAwOwotCV9fbGUxNiB1dGYxNl9wYXRo
ID0gMDsgLyogTnVsbCAtIHNpbmNlIGFuIG9wZW4gb2YgdG9wIG9mIHNoYXJlICovCi0JdTggb3Bs
b2NrID0gU01CMl9PUExPQ0tfTEVWRUxfSUk7Ci0Jc3RydWN0IGNpZnNfZmlkICpwZmlkOwotCXN0
cnVjdCBkZW50cnkgKmRlbnRyeTsKLQotCWlmICh0Y29uID09IE5VTEwgfHwgdGNvbi0+bm9oYW5k
bGVjYWNoZSB8fAotCSAgICBpc19zbWIxX3NlcnZlcih0Y29uLT5zZXMtPnNlcnZlcikpCi0JCXJl
dHVybiAtRU5PVFNVUFA7Ci0KLQlzZXMgPSB0Y29uLT5zZXM7Ci0Jc2VydmVyID0gc2VzLT5zZXJ2
ZXI7Ci0KLQlpZiAoY2lmc19zYi0+cm9vdCA9PSBOVUxMKQotCQlyZXR1cm4gLUVOT0VOVDsKLQot
CWlmIChzdHJsZW4ocGF0aCkpCi0JCXJldHVybiAtRU5PRU5UOwotCi0JZGVudHJ5ID0gY2lmc19z
Yi0+cm9vdDsKLQotCW11dGV4X2xvY2soJnRjb24tPmNyZmlkLmZpZF9tdXRleCk7Ci0JaWYgKHRj
b24tPmNyZmlkLmlzX3ZhbGlkKSB7Ci0JCWNpZnNfZGJnKEZZSSwgImZvdW5kIGEgY2FjaGVkIHJv
b3QgZmlsZSBoYW5kbGVcbiIpOwotCQkqY2ZpZCA9ICZ0Y29uLT5jcmZpZDsKLQkJa3JlZl9nZXQo
JnRjb24tPmNyZmlkLnJlZmNvdW50KTsKLQkJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jcmZpZC5maWRf
bXV0ZXgpOwotCQlyZXR1cm4gMDsKLQl9Ci0KLQkvKgotCSAqIFdlIGRvIG5vdCBob2xkIHRoZSBs
b2NrIGZvciB0aGUgb3BlbiBiZWNhdXNlIGluIGNhc2UKLQkgKiBTTUIyX29wZW4gbmVlZHMgdG8g
cmVjb25uZWN0LCBpdCB3aWxsIGVuZCB1cCBjYWxsaW5nCi0JICogY2lmc19tYXJrX29wZW5fZmls
ZXNfaW52YWxpZCgpIHdoaWNoIHRha2VzIHRoZSBsb2NrIGFnYWluCi0JICogdGh1cyBjYXVzaW5n
IGEgZGVhZGxvY2sKLQkgKi8KLQotCW11dGV4X3VubG9jaygmdGNvbi0+Y3JmaWQuZmlkX211dGV4
KTsKLQotCWlmIChzbWIzX2VuY3J5cHRpb25fcmVxdWlyZWQodGNvbikpCi0JCWZsYWdzIHw9IENJ
RlNfVFJBTlNGT1JNX1JFUTsKLQotCWlmICghc2VydmVyLT5vcHMtPm5ld19sZWFzZV9rZXkpCi0J
CXJldHVybiAtRUlPOwotCi0JcGZpZCA9IHRjb24tPmNyZmlkLmZpZDsKLQlzZXJ2ZXItPm9wcy0+
bmV3X2xlYXNlX2tleShwZmlkKTsKLQotCW1lbXNldChycXN0LCAwLCBzaXplb2YocnFzdCkpOwot
CXJlc3BfYnVmdHlwZVswXSA9IHJlc3BfYnVmdHlwZVsxXSA9IENJRlNfTk9fQlVGRkVSOwotCW1l
bXNldChyc3BfaW92LCAwLCBzaXplb2YocnNwX2lvdikpOwotCi0JLyogT3BlbiAqLwotCW1lbXNl
dCgmb3Blbl9pb3YsIDAsIHNpemVvZihvcGVuX2lvdikpOwotCXJxc3RbMF0ucnFfaW92ID0gb3Bl
bl9pb3Y7Ci0JcnFzdFswXS5ycV9udmVjID0gU01CMl9DUkVBVEVfSU9WX1NJWkU7Ci0KLQlvcGFy
bXMudGNvbiA9IHRjb247Ci0Jb3Bhcm1zLmNyZWF0ZV9vcHRpb25zID0gY2lmc19jcmVhdGVfb3B0
aW9ucyhjaWZzX3NiLCBDUkVBVEVfTk9UX0ZJTEUpOwotCW9wYXJtcy5kZXNpcmVkX2FjY2VzcyA9
IEZJTEVfUkVBRF9BVFRSSUJVVEVTOwotCW9wYXJtcy5kaXNwb3NpdGlvbiA9IEZJTEVfT1BFTjsK
LQlvcGFybXMuZmlkID0gcGZpZDsKLQlvcGFybXMucmVjb25uZWN0ID0gZmFsc2U7Ci0KLQlyYyA9
IFNNQjJfb3Blbl9pbml0KHRjb24sIHNlcnZlciwKLQkJCSAgICAmcnFzdFswXSwgJm9wbG9jaywg
Jm9wYXJtcywgJnV0ZjE2X3BhdGgpOwotCWlmIChyYykKLQkJZ290byBvc2hyX2ZyZWU7Ci0Jc21i
Ml9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0WzBdKTsKLQotCW1lbXNldCgmcWlfaW92LCAw
LCBzaXplb2YocWlfaW92KSk7Ci0JcnFzdFsxXS5ycV9pb3YgPSBxaV9pb3Y7Ci0JcnFzdFsxXS5y
cV9udmVjID0gMTsKLQotCXJjID0gU01CMl9xdWVyeV9pbmZvX2luaXQodGNvbiwgc2VydmVyLAot
CQkJCSAgJnJxc3RbMV0sIENPTVBPVU5EX0ZJRCwKLQkJCQkgIENPTVBPVU5EX0ZJRCwgRklMRV9B
TExfSU5GT1JNQVRJT04sCi0JCQkJICBTTUIyX09fSU5GT19GSUxFLCAwLAotCQkJCSAgc2l6ZW9m
KHN0cnVjdCBzbWIyX2ZpbGVfYWxsX2luZm8pICsKLQkJCQkgIFBBVEhfTUFYICogMiwgMCwgTlVM
TCk7Ci0JaWYgKHJjKQotCQlnb3RvIG9zaHJfZnJlZTsKLQotCXNtYjJfc2V0X3JlbGF0ZWQoJnJx
c3RbMV0pOwotCi0JcmMgPSBjb21wb3VuZF9zZW5kX3JlY3YoeGlkLCBzZXMsIHNlcnZlciwKLQkJ
CQlmbGFncywgMiwgcnFzdCwKLQkJCQlyZXNwX2J1ZnR5cGUsIHJzcF9pb3YpOwotCW11dGV4X2xv
Y2soJnRjb24tPmNyZmlkLmZpZF9tdXRleCk7Ci0KLQkvKgotCSAqIE5vdyB3ZSBuZWVkIHRvIGNo
ZWNrIGFnYWluIGFzIHRoZSBjYWNoZWQgcm9vdCBtaWdodCBoYXZlCi0JICogYmVlbiBzdWNjZXNz
ZnVsbHkgcmUtb3BlbmVkIGZyb20gYSBjb25jdXJyZW50IHByb2Nlc3MKLQkgKi8KLQotCWlmICh0
Y29uLT5jcmZpZC5pc192YWxpZCkgewotCQkvKiB3b3JrIHdhcyBhbHJlYWR5IGRvbmUgKi8KLQot
CQkvKiBzdGFzaCBmaWRzIGZvciBjbG9zZSgpIGxhdGVyICovCi0JCXN0cnVjdCBjaWZzX2ZpZCBm
aWQgPSB7Ci0JCQkucGVyc2lzdGVudF9maWQgPSBwZmlkLT5wZXJzaXN0ZW50X2ZpZCwKLQkJCS52
b2xhdGlsZV9maWQgPSBwZmlkLT52b2xhdGlsZV9maWQsCi0JCX07Ci0KLQkJLyoKLQkJICogY2Fs
bGVyIGV4cGVjdHMgdGhpcyBmdW5jIHRvIHNldCB0aGUgZmlkIGluIGNyZmlkIHRvIHZhbGlkCi0J
CSAqIGNhY2hlZCByb290LCBzbyBpbmNyZW1lbnQgdGhlIHJlZmNvdW50LgotCQkgKi8KLQkJa3Jl
Zl9nZXQoJnRjb24tPmNyZmlkLnJlZmNvdW50KTsKLQotCQltdXRleF91bmxvY2soJnRjb24tPmNy
ZmlkLmZpZF9tdXRleCk7Ci0KLQkJaWYgKHJjID09IDApIHsKLQkJCS8qIGNsb3NlIGV4dHJhIGhh
bmRsZSBvdXRzaWRlIG9mIGNyaXQgc2VjICovCi0JCQlTTUIyX2Nsb3NlKHhpZCwgdGNvbiwgZmlk
LnBlcnNpc3RlbnRfZmlkLCBmaWQudm9sYXRpbGVfZmlkKTsKLQkJfQotCQlyYyA9IDA7Ci0JCWdv
dG8gb3Nocl9mcmVlOwotCX0KLQotCS8qIENhY2hlZCByb290IGlzIHN0aWxsIGludmFsaWQsIGNv
bnRpbnVlIG5vcm1hbHkgKi8KLQotCWlmIChyYykgewotCQlpZiAocmMgPT0gLUVSRU1DSEcpIHsK
LQkJCXRjb24tPm5lZWRfcmVjb25uZWN0ID0gdHJ1ZTsKLQkJCXByX3dhcm5fb25jZSgic2VydmVy
IHNoYXJlICVzIGRlbGV0ZWRcbiIsCi0JCQkJICAgICB0Y29uLT50cmVlTmFtZSk7Ci0JCX0KLQkJ
Z290byBvc2hyX2V4aXQ7Ci0JfQotCi0JYXRvbWljX2luYygmdGNvbi0+bnVtX3JlbW90ZV9vcGVu
cyk7Ci0KLQlvX3JzcCA9IChzdHJ1Y3Qgc21iMl9jcmVhdGVfcnNwICopcnNwX2lvdlswXS5pb3Zf
YmFzZTsKLQlvcGFybXMuZmlkLT5wZXJzaXN0ZW50X2ZpZCA9IG9fcnNwLT5QZXJzaXN0ZW50Rmls
ZUlkOwotCW9wYXJtcy5maWQtPnZvbGF0aWxlX2ZpZCA9IG9fcnNwLT5Wb2xhdGlsZUZpbGVJZDsK
LSNpZmRlZiBDT05GSUdfQ0lGU19ERUJVRzIKLQlvcGFybXMuZmlkLT5taWQgPSBsZTY0X3RvX2Nw
dShvX3JzcC0+aGRyLk1lc3NhZ2VJZCk7Ci0jZW5kaWYgLyogQ0lGU19ERUJVRzIgKi8KLQotCXRj
b24tPmNyZmlkLnRjb24gPSB0Y29uOwotCXRjb24tPmNyZmlkLmlzX3ZhbGlkID0gdHJ1ZTsKLQl0
Y29uLT5jcmZpZC5kZW50cnkgPSBkZW50cnk7Ci0JZGdldChkZW50cnkpOwotCWtyZWZfaW5pdCgm
dGNvbi0+Y3JmaWQucmVmY291bnQpOwotCi0JLyogQkIgVEJEIGNoZWNrIHRvIHNlZSBpZiBvcGxv
Y2sgbGV2ZWwgY2hlY2sgY2FuIGJlIHJlbW92ZWQgYmVsb3cgKi8KLQlpZiAob19yc3AtPk9wbG9j
a0xldmVsID09IFNNQjJfT1BMT0NLX0xFVkVMX0xFQVNFKSB7Ci0JCS8qCi0JCSAqIFNlZSBjb21t
aXQgMmY5NGEzMTI1Yjg3LiBJbmNyZW1lbnQgdGhlIHJlZmNvdW50IHdoZW4gd2UKLQkJICogZ2V0
IGEgbGVhc2UgZm9yIHJvb3QsIHJlbGVhc2UgaXQgaWYgbGVhc2UgYnJlYWsgb2NjdXJzCi0JCSAq
LwotCQlrcmVmX2dldCgmdGNvbi0+Y3JmaWQucmVmY291bnQpOwotCQl0Y29uLT5jcmZpZC5oYXNf
bGVhc2UgPSB0cnVlOwotCQlzbWIyX3BhcnNlX2NvbnRleHRzKHNlcnZlciwgb19yc3AsCi0JCQkJ
Jm9wYXJtcy5maWQtPmVwb2NoLAotCQkJCSAgICBvcGFybXMuZmlkLT5sZWFzZV9rZXksICZvcGxv
Y2ssCi0JCQkJICAgIE5VTEwsIE5VTEwpOwotCX0gZWxzZQotCQlnb3RvIG9zaHJfZXhpdDsKLQot
CXFpX3JzcCA9IChzdHJ1Y3Qgc21iMl9xdWVyeV9pbmZvX3JzcCAqKXJzcF9pb3ZbMV0uaW92X2Jh
c2U7Ci0JaWYgKGxlMzJfdG9fY3B1KHFpX3JzcC0+T3V0cHV0QnVmZmVyTGVuZ3RoKSA8IHNpemVv
ZihzdHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvKSkKLQkJZ290byBvc2hyX2V4aXQ7Ci0JaWYgKCFz
bWIyX3ZhbGlkYXRlX2FuZF9jb3B5X2lvdigKLQkJCQlsZTE2X3RvX2NwdShxaV9yc3AtPk91dHB1
dEJ1ZmZlck9mZnNldCksCi0JCQkJc2l6ZW9mKHN0cnVjdCBzbWIyX2ZpbGVfYWxsX2luZm8pLAot
CQkJCSZyc3BfaW92WzFdLCBzaXplb2Yoc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbyksCi0JCQkJ
KGNoYXIgKikmdGNvbi0+Y3JmaWQuZmlsZV9hbGxfaW5mbykpCi0JCXRjb24tPmNyZmlkLmZpbGVf
YWxsX2luZm9faXNfdmFsaWQgPSB0cnVlOwotCXRjb24tPmNyZmlkLnRpbWUgPSBqaWZmaWVzOwot
Ci0KLW9zaHJfZXhpdDoKLQltdXRleF91bmxvY2soJnRjb24tPmNyZmlkLmZpZF9tdXRleCk7Ci1v
c2hyX2ZyZWU6Ci0JU01CMl9vcGVuX2ZyZWUoJnJxc3RbMF0pOwotCVNNQjJfcXVlcnlfaW5mb19m
cmVlKCZycXN0WzFdKTsKLQlmcmVlX3JzcF9idWYocmVzcF9idWZ0eXBlWzBdLCByc3BfaW92WzBd
Lmlvdl9iYXNlKTsKLQlmcmVlX3JzcF9idWYocmVzcF9idWZ0eXBlWzFdLCByc3BfaW92WzFdLmlv
dl9iYXNlKTsKLQlpZiAocmMgPT0gMCkKLQkJKmNmaWQgPSAmdGNvbi0+Y3JmaWQ7Ci0JcmV0dXJu
IHJjOwotfQotCi1pbnQgb3Blbl9jYWNoZWRfZGlyX2J5X2RlbnRyeShzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAotCQkJICAgICAgc3RydWN0IGRlbnRyeSAqZGVudHJ5LAotCQkJICAgICAgc3RydWN0
IGNhY2hlZF9maWQgKipjZmlkKQotewotCW11dGV4X2xvY2soJnRjb24tPmNyZmlkLmZpZF9tdXRl
eCk7Ci0JaWYgKHRjb24tPmNyZmlkLmRlbnRyeSA9PSBkZW50cnkpIHsKLQkJY2lmc19kYmcoRllJ
LCAiZm91bmQgYSBjYWNoZWQgcm9vdCBmaWxlIGhhbmRsZSBieSBkZW50cnlcbiIpOwotCQkqY2Zp
ZCA9ICZ0Y29uLT5jcmZpZDsKLQkJa3JlZl9nZXQoJnRjb24tPmNyZmlkLnJlZmNvdW50KTsKLQkJ
bXV0ZXhfdW5sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwotCQlyZXR1cm4gMDsKLQl9Ci0J
bXV0ZXhfdW5sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwotCXJldHVybiAtRU5PRU5UOwot
fQotCiBzdGF0aWMgdm9pZAogc21iM19xZnNfdGNvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCSAgICAgIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNf
c2IpCkBAIC0xMDc3LDcgKzc4NCw3IEBAIHNtYjJfaXNfcGF0aF9hY2Nlc3NpYmxlKGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJc3RydWN0IGNpZnNfb3Bl
bl9wYXJtcyBvcGFybXM7CiAJc3RydWN0IGNpZnNfZmlkIGZpZDsKIAotCWlmICgoKmZ1bGxfcGF0
aCA9PSAwKSAmJiB0Y29uLT5jcmZpZC5pc192YWxpZCkKKwlpZiAoKCpmdWxsX3BhdGggPT0gMCkg
JiYgdGNvbi0+Y2ZpZC5pc192YWxpZCkKIAkJcmV0dXJuIDA7CiAKIAl1dGYxNl9wYXRoID0gY2lm
c19jb252ZXJ0X3BhdGhfdG9fdXRmMTYoZnVsbF9wYXRoLCBjaWZzX3NiKTsKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggNTkwYTFkNGFjMTQw
Li43YzIwMGI5MzgyNjcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2Np
ZnMvc21iMnBkdS5jCkBAIC0zOSw2ICszOSw3IEBACiAjaWZkZWYgQ09ORklHX0NJRlNfREZTX1VQ
Q0FMTAogI2luY2x1ZGUgImRmc19jYWNoZS5oIgogI2VuZGlmCisjaW5jbHVkZSAiY2FjaGVkX2Rp
ci5oIgogCiAvKgogICogIFRoZSBmb2xsb3dpbmcgdGFibGUgZGVmaW5lcyB0aGUgZXhwZWN0ZWQg
IlN0cnVjdHVyZVNpemUiIG9mIFNNQjIgcmVxdWVzdHMKQEAgLTE5NzgsNyArMTk3OSw3IEBAIFNN
QjJfdGRpcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQog
CX0KIAlzcGluX3VubG9jaygmc2VzLT5jaGFuX2xvY2spOwogCi0JY2xvc2VfY2FjaGVkX2Rpcl9s
ZWFzZSgmdGNvbi0+Y3JmaWQpOworCWNsb3NlX2NhY2hlZF9kaXJfbGVhc2UoJnRjb24tPmNmaWQp
OwogCiAJcmMgPSBzbWIyX3BsYWluX3JlcV9pbml0KFNNQjJfVFJFRV9ESVNDT05ORUNULCB0Y29u
LCBzZXMtPnNlcnZlciwKIAkJCQkgKHZvaWQgKiopICZyZXEsCmRpZmYgLS1naXQgYS9mcy9jaWZz
L3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIycHJvdG8uaAppbmRleCBhNjlmMWVlZDFjZmUuLjUx
YzViZjRhMzM4YSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycHJvdG8uaAorKysgYi9mcy9jaWZz
L3NtYjJwcm90by5oCkBAIC01NCwxNiArNTQsNiBAQCBleHRlcm4gYm9vbCBzbWIyX2lzX3ZhbGlk
X29wbG9ja19icmVhayhjaGFyICpidWZmZXIsCiBleHRlcm4gaW50IHNtYjNfaGFuZGxlX3JlYWRf
ZGF0YShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJIHN0cnVjdCBtaWRfcV9l
bnRyeSAqbWlkKTsKIAotZXh0ZXJuIGludCBvcGVuX2NhY2hlZF9kaXIodW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLQkJCSAgIGNvbnN0IGNoYXIgKnBhdGgsCi0JCQkg
ICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAotCQkJICAgc3RydWN0IGNhY2hlZF9maWQg
KipjZmlkKTsKLWV4dGVybiBpbnQgb3Blbl9jYWNoZWRfZGlyX2J5X2RlbnRyeShzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAotCQkJCSAgICAgc3RydWN0IGRlbnRyeSAqZGVudHJ5LAotCQkJCSAgICAg
c3RydWN0IGNhY2hlZF9maWQgKipjZmlkKTsKLWV4dGVybiB2b2lkIGNsb3NlX2NhY2hlZF9kaXIo
c3RydWN0IGNhY2hlZF9maWQgKmNmaWQpOwotZXh0ZXJuIHZvaWQgY2xvc2VfY2FjaGVkX2Rpcl9s
ZWFzZShzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCk7Ci1leHRlcm4gdm9pZCBjbG9zZV9jYWNoZWRf
ZGlyX2xlYXNlX2xvY2tlZChzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCk7CiBleHRlcm4gdm9pZCBt
b3ZlX3NtYjJfaW5mb190b19jaWZzKEZJTEVfQUxMX0lORk8gKmRzdCwKIAkJCQkgICBzdHJ1Y3Qg
c21iMl9maWxlX2FsbF9pbmZvICpzcmMpOwogZXh0ZXJuIGludCBzbWIyX3F1ZXJ5X3JlcGFyc2Vf
dGFnKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCi0tIAoy
LjM0LjEKCg==
--00000000000075ffe505e5ee473b--
