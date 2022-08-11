Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B66C00140
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 03:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiHKDIV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Aug 2022 23:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiHKDIU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Aug 2022 23:08:20 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFADA7D1C1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 20:08:14 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id 66so17107774vse.4
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 20:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xYpqj9xhX/9Av7zPgQKZw4iJ4ZEOPkktczEGoNGndNc=;
        b=L2ZKtDbWgQUqMJOQglKGo54FTACnKcIkYsJ2cWyYdCDBvKjNWB39yy7SQKWLYP7d4I
         uTsd5LclbBjnCVBCoosDTMqYIhmXZrvFgWXJeCQ0jyrG163tbH0pU8dKbCePA0YeCBuD
         izcaz/X8X8+l5gDLi3aTeVfgOM5N1pL4sSznkeq9QPGQCmCGOgIjkJX9mmbX5KDnQSoL
         lzNeUUGBt1rZldCy+JK1Sbe5CIiuiC0HastgQJsVGKtq75DQp3oZHorLxendd7sWzwn0
         Jf+AOL2MIFQPgT/K1L5PoiwkAsuQxI8ana8SF6U6oHAkqULI73MuNDVG2bD/kjACa1p9
         XKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xYpqj9xhX/9Av7zPgQKZw4iJ4ZEOPkktczEGoNGndNc=;
        b=AyFQAu9Jn3eI38gvls9msJPTU3aE2FqQEXHvIUOzlcP+v+vcdk7Gx2wqDZrds6naT1
         0dP1qobvfIM/+rlpaV6PsZ/FXWaIuIEDZE+poPCHG5wMjMgcv+Fdra7yDDoB7mtuazu7
         SvnekfQFmD8G4Z8j7xPDWZZmc6wgvLtV1PtJk8PA2DaDJoul4Z0+d6y388m6vRJJCTI0
         wstg4OELy6nDF93rYsJrRhu0E9w/DrwF641LPDfhhJ21gQIluqXQtjqhuanmJHXpLhpb
         ErWiZZ+81p/yVsjGLsicZwTtwCG/Bwivwx/Li4xcE/DvVLM2xvfD/O2rRTx96Rhe5mXD
         WTbg==
X-Gm-Message-State: ACgBeo3KK4lMH4GqXNsWqfNVGvvfFLRAvUWiaCjBYBmBqpBtjAhhq4z0
        ZbhPXoAzNq4d3xvax0bR0ZHuCtyD/1JeGZVXzDuo0pVhx5I=
X-Google-Smtp-Source: AA6agR5irSnmK1/47dQWUygJ4Id6EU97t58MtUEwn0DDUmZ9SJ15Vu8kcbQo0iay8NLP6ZHhZd1wfZhE3aMDCcaw9vc=
X-Received: by 2002:a67:b24b:0:b0:357:31a6:1767 with SMTP id
 s11-20020a67b24b000000b0035731a61767mr12652089vsh.29.1660187293455; Wed, 10
 Aug 2022 20:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-2-lsahlber@redhat.com>
 <CAH2r5msgAYaYL0oi2HpsuzAa08+ZR6wZHJQx=7c_Wc7wRW3k4A@mail.gmail.com>
In-Reply-To: <CAH2r5msgAYaYL0oi2HpsuzAa08+ZR6wZHJQx=7c_Wc7wRW3k4A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Aug 2022 22:08:02 -0500
Message-ID: <CAH2r5mupHa4sxD-tu8m9vVaPPoNut6CYrXtbOURxnXrYkioSyw@mail.gmail.com>
Subject: Re: [PATCH 1/9] cifs: Move cached-dir functions into a separate file
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e3334f05e5ee7981"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e3334f05e5ee7981
Content-Type: text/plain; charset="UTF-8"

Updated to fix various checkpatch warnings, and to include new file
accidentally left out in rebased patch.

On Wed, Aug 10, 2022 at 9:53 PM Steve French <smfrench@gmail.com> wrote:
>
> Lightly updated (rebase to merge with current for-next) and also
> combined with patch 8 of the series to avoid a lock warning.
>
> Tentatively merged this restructuring into cifs-2.6.git for-next
> pending testing.
>
> On Mon, Aug 8, 2022 at 9:12 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Also rename crfid to cfid to have consistent naming for this variable.
> >
> > This commit does not change any logic.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/Makefile     |   2 +-
> >  fs/cifs/cached_dir.c | 363 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/cifs/cached_dir.h |  26 ++++
> >  fs/cifs/cifsfs.c     |  20 +--
> >  fs/cifs/cifsglob.h   |   2 +-
> >  fs/cifs/cifsproto.h  |   1 -
> >  fs/cifs/cifssmb.c    |   8 +-
> >  fs/cifs/inode.c      |   1 +
> >  fs/cifs/misc.c       |  12 +-
> >  fs/cifs/readdir.c    |   1 +
> >  fs/cifs/smb2inode.c  |   5 +-
> >  fs/cifs/smb2misc.c   |  13 +-
> >  fs/cifs/smb2ops.c    | 297 +----------------------------------
> >  fs/cifs/smb2pdu.c    |   3 +-
> >  fs/cifs/smb2proto.h  |  10 --
> >  15 files changed, 412 insertions(+), 352 deletions(-)
> >  create mode 100644 fs/cifs/cached_dir.c
> >  create mode 100644 fs/cifs/cached_dir.h
> >
> > diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> > index 8c9f2c00be72..343a59e0d64d 100644
> > --- a/fs/cifs/Makefile
> > +++ b/fs/cifs/Makefile
> > @@ -7,7 +7,7 @@ obj-$(CONFIG_CIFS) += cifs.o
> >
> >  cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
> >           inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
> > -         cifs_unicode.o nterr.o cifsencrypt.o \
> > +         cached_dir.o cifs_unicode.o nterr.o cifsencrypt.o \
> >           readdir.o ioctl.o sess.o export.o unc.o winucase.o \
> >           smb2ops.o smb2maperror.o smb2transport.o \
> >           smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
> > diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> > new file mode 100644
> > index 000000000000..f2e17c1d5196
> > --- /dev/null
> > +++ b/fs/cifs/cached_dir.c
> > @@ -0,0 +1,363 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + *  Functions to handle the cached directory entries
> > + *
> > + *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
> > + */
> > +
> > +#include "cifsglob.h"
> > +#include "cifsproto.h"
> > +#include "cifs_debug.h"
> > +#include "smb2proto.h"
> > +#include "cached_dir.h"
> > +
> > +/*
> > + * Open the and cache a directory handle.
> > + * If error then *cfid is not initialized.
> > + */
> > +int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> > +               const char *path,
> > +               struct cifs_sb_info *cifs_sb,
> > +               struct cached_fid **cfid)
> > +{
> > +       struct cifs_ses *ses;
> > +       struct TCP_Server_Info *server;
> > +       struct cifs_open_parms oparms;
> > +       struct smb2_create_rsp *o_rsp = NULL;
> > +       struct smb2_query_info_rsp *qi_rsp = NULL;
> > +       int resp_buftype[2];
> > +       struct smb_rqst rqst[2];
> > +       struct kvec rsp_iov[2];
> > +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > +       struct kvec qi_iov[1];
> > +       int rc, flags = 0;
> > +       __le16 utf16_path = 0; /* Null - since an open of top of share */
> > +       u8 oplock = SMB2_OPLOCK_LEVEL_II;
> > +       struct cifs_fid *pfid;
> > +       struct dentry *dentry;
> > +
> > +       if (tcon == NULL || tcon->nohandlecache ||
> > +           is_smb1_server(tcon->ses->server))
> > +               return -ENOTSUPP;
> > +
> > +       ses = tcon->ses;
> > +       server = ses->server;
> > +
> > +       if (cifs_sb->root == NULL)
> > +               return -ENOENT;
> > +
> > +       if (strlen(path))
> > +               return -ENOENT;
> > +
> > +       dentry = cifs_sb->root;
> > +
> > +       mutex_lock(&tcon->cfid.fid_mutex);
> > +       if (tcon->cfid.is_valid) {
> > +               cifs_dbg(FYI, "found a cached root file handle\n");
> > +               *cfid = &tcon->cfid;
> > +               kref_get(&tcon->cfid.refcount);
> > +               mutex_unlock(&tcon->cfid.fid_mutex);
> > +               return 0;
> > +       }
> > +
> > +       /*
> > +        * We do not hold the lock for the open because in case
> > +        * SMB2_open needs to reconnect, it will end up calling
> > +        * cifs_mark_open_files_invalid() which takes the lock again
> > +        * thus causing a deadlock
> > +        */
> > +
> > +       mutex_unlock(&tcon->cfid.fid_mutex);
> > +
> > +       if (smb3_encryption_required(tcon))
> > +               flags |= CIFS_TRANSFORM_REQ;
> > +
> > +       if (!server->ops->new_lease_key)
> > +               return -EIO;
> > +
> > +       pfid = tcon->cfid.fid;
> > +       server->ops->new_lease_key(pfid);
> > +
> > +       memset(rqst, 0, sizeof(rqst));
> > +       resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
> > +       memset(rsp_iov, 0, sizeof(rsp_iov));
> > +
> > +       /* Open */
> > +       memset(&open_iov, 0, sizeof(open_iov));
> > +       rqst[0].rq_iov = open_iov;
> > +       rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
> > +
> > +       oparms.tcon = tcon;
> > +       oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
> > +       oparms.desired_access = FILE_READ_ATTRIBUTES;
> > +       oparms.disposition = FILE_OPEN;
> > +       oparms.fid = pfid;
> > +       oparms.reconnect = false;
> > +
> > +       rc = SMB2_open_init(tcon, server,
> > +                           &rqst[0], &oplock, &oparms, &utf16_path);
> > +       if (rc)
> > +               goto oshr_free;
> > +       smb2_set_next_command(tcon, &rqst[0]);
> > +
> > +       memset(&qi_iov, 0, sizeof(qi_iov));
> > +       rqst[1].rq_iov = qi_iov;
> > +       rqst[1].rq_nvec = 1;
> > +
> > +       rc = SMB2_query_info_init(tcon, server,
> > +                                 &rqst[1], COMPOUND_FID,
> > +                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> > +                                 SMB2_O_INFO_FILE, 0,
> > +                                 sizeof(struct smb2_file_all_info) +
> > +                                 PATH_MAX * 2, 0, NULL);
> > +       if (rc)
> > +               goto oshr_free;
> > +
> > +       smb2_set_related(&rqst[1]);
> > +
> > +       rc = compound_send_recv(xid, ses, server,
> > +                               flags, 2, rqst,
> > +                               resp_buftype, rsp_iov);
> > +       mutex_lock(&tcon->cfid.fid_mutex);
> > +
> > +       /*
> > +        * Now we need to check again as the cached root might have
> > +        * been successfully re-opened from a concurrent process
> > +        */
> > +
> > +       if (tcon->cfid.is_valid) {
> > +               /* work was already done */
> > +
> > +               /* stash fids for close() later */
> > +               struct cifs_fid fid = {
> > +                       .persistent_fid = pfid->persistent_fid,
> > +                       .volatile_fid = pfid->volatile_fid,
> > +               };
> > +
> > +               /*
> > +                * caller expects this func to set the fid in cfid to valid
> > +                * cached root, so increment the refcount.
> > +                */
> > +               kref_get(&tcon->cfid.refcount);
> > +
> > +               mutex_unlock(&tcon->cfid.fid_mutex);
> > +
> > +               if (rc == 0) {
> > +                       /* close extra handle outside of crit sec */
> > +                       SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> > +               }
> > +               rc = 0;
> > +               goto oshr_free;
> > +       }
> > +
> > +       /* Cached root is still invalid, continue normaly */
> > +
> > +       if (rc) {
> > +               if (rc == -EREMCHG) {
> > +                       tcon->need_reconnect = true;
> > +                       pr_warn_once("server share %s deleted\n",
> > +                                    tcon->treeName);
> > +               }
> > +               goto oshr_exit;
> > +       }
> > +
> > +       atomic_inc(&tcon->num_remote_opens);
> > +
> > +       o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> > +       oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> > +       oparms.fid->volatile_fid = o_rsp->VolatileFileId;
> > +#ifdef CONFIG_CIFS_DEBUG2
> > +       oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
> > +#endif /* CIFS_DEBUG2 */
> > +
> > +       tcon->cfid.tcon = tcon;
> > +       tcon->cfid.is_valid = true;
> > +       tcon->cfid.dentry = dentry;
> > +       dget(dentry);
> > +       kref_init(&tcon->cfid.refcount);
> > +
> > +       /* BB TBD check to see if oplock level check can be removed below */
> > +       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> > +               /*
> > +                * See commit 2f94a3125b87. Increment the refcount when we
> > +                * get a lease for root, release it if lease break occurs
> > +                */
> > +               kref_get(&tcon->cfid.refcount);
> > +               tcon->cfid.has_lease = true;
> > +               smb2_parse_contexts(server, o_rsp,
> > +                               &oparms.fid->epoch,
> > +                                   oparms.fid->lease_key, &oplock,
> > +                                   NULL, NULL);
> > +       } else
> > +               goto oshr_exit;
> > +
> > +       qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> > +       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> > +               goto oshr_exit;
> > +       if (!smb2_validate_and_copy_iov(
> > +                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> > +                               sizeof(struct smb2_file_all_info),
> > +                               &rsp_iov[1], sizeof(struct smb2_file_all_info),
> > +                               (char *)&tcon->cfid.file_all_info))
> > +               tcon->cfid.file_all_info_is_valid = true;
> > +       tcon->cfid.time = jiffies;
> > +
> > +
> > +oshr_exit:
> > +       mutex_unlock(&tcon->cfid.fid_mutex);
> > +oshr_free:
> > +       SMB2_open_free(&rqst[0]);
> > +       SMB2_query_info_free(&rqst[1]);
> > +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> > +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> > +       if (rc == 0) {
> > +               *cfid = &tcon->cfid;
> > +}
> > +       return rc;
> > +}
> > +
> > +int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> > +                             struct dentry *dentry,
> > +                             struct cached_fid **cfid)
> > +{
> > +       mutex_lock(&tcon->cfid.fid_mutex);
> > +       if (tcon->cfid.dentry == dentry) {
> > +               cifs_dbg(FYI, "found a cached root file handle by dentry\n");
> > +               *cfid = &tcon->cfid;
> > +               kref_get(&tcon->cfid.refcount);
> > +               mutex_unlock(&tcon->cfid.fid_mutex);
> > +               return 0;
> > +       }
> > +       mutex_unlock(&tcon->cfid.fid_mutex);
> > +       return -ENOENT;
> > +}
> > +
> > +static void
> > +smb2_close_cached_fid(struct kref *ref)
> > +{
> > +       struct cached_fid *cfid = container_of(ref, struct cached_fid,
> > +                                              refcount);
> > +       struct cached_dirent *dirent, *q;
> > +
> > +       if (cfid->is_valid) {
> > +               cifs_dbg(FYI, "clear cached root file handle\n");
> > +               SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
> > +                          cfid->fid->volatile_fid);
> > +       }
> > +
> > +       /*
> > +        * We only check validity above to send SMB2_close,
> > +        * but we still need to invalidate these entries
> > +        * when this function is called
> > +        */
> > +       cfid->is_valid = false;
> > +       cfid->file_all_info_is_valid = false;
> > +       cfid->has_lease = false;
> > +       if (cfid->dentry) {
> > +               dput(cfid->dentry);
> > +               cfid->dentry = NULL;
> > +       }
> > +       /*
> > +        * Delete all cached dirent names
> > +        */
> > +       mutex_lock(&cfid->dirents.de_mutex);
> > +       list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
> > +               list_del(&dirent->entry);
> > +               kfree(dirent->name);
> > +               kfree(dirent);
> > +       }
> > +       cfid->dirents.is_valid = 0;
> > +       cfid->dirents.is_failed = 0;
> > +       cfid->dirents.ctx = NULL;
> > +       cfid->dirents.pos = 0;
> > +       mutex_unlock(&cfid->dirents.de_mutex);
> > +
> > +}
> > +
> > +void close_cached_dir(struct cached_fid *cfid)
> > +{
> > +       mutex_lock(&cfid->fid_mutex);
> > +       kref_put(&cfid->refcount, smb2_close_cached_fid);
> > +       mutex_unlock(&cfid->fid_mutex);
> > +}
> > +
> > +void close_cached_dir_lease_locked(struct cached_fid *cfid)
> > +{
> > +       if (cfid->has_lease) {
> > +               cfid->has_lease = false;
> > +               kref_put(&cfid->refcount, smb2_close_cached_fid);
> > +       }
> > +}
> > +
> > +void close_cached_dir_lease(struct cached_fid *cfid)
> > +{
> > +       mutex_lock(&cfid->fid_mutex);
> > +       close_cached_dir_lease_locked(cfid);
> > +       mutex_unlock(&cfid->fid_mutex);
> > +}
> > +
> > +/*
> > + * Called from cifs_kill_sb when we unmount a share
> > + */
> > +void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
> > +{
> > +       struct rb_root *root = &cifs_sb->tlink_tree;
> > +       struct rb_node *node;
> > +       struct cached_fid *cfid;
> > +       struct cifs_tcon *tcon;
> > +       struct tcon_link *tlink;
> > +
> > +       for (node = rb_first(root); node; node = rb_next(node)) {
> > +               tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> > +               tcon = tlink_tcon(tlink);
> > +               if (IS_ERR(tcon))
> > +                       continue;
> > +               cfid = &tcon->cfid;
> > +               mutex_lock(&cfid->fid_mutex);
> > +               if (cfid->dentry) {
> > +                       dput(cfid->dentry);
> > +                       cfid->dentry = NULL;
> > +               }
> > +               mutex_unlock(&cfid->fid_mutex);
> > +       }
> > +}
> > +
> > +/*
> > + * Invalidate and close all cached dirs when a TCON has been reset
> > + * due to a session loss.
> > + */
> > +void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> > +{
> > +       mutex_lock(&tcon->cfid.fid_mutex);
> > +       tcon->cfid.is_valid = false;
> > +       /* cached handle is not valid, so SMB2_CLOSE won't be sent below */
> > +       close_cached_dir_lease_locked(&tcon->cfid);
> > +       memset(tcon->cfid.fid, 0, sizeof(struct cifs_fid));
> > +       mutex_unlock(&tcon->cfid.fid_mutex);
> > +}
> > +
> > +static void
> > +smb2_cached_lease_break(struct work_struct *work)
> > +{
> > +       struct cached_fid *cfid = container_of(work,
> > +                               struct cached_fid, lease_break);
> > +
> > +       close_cached_dir_lease(cfid);
> > +}
> > +
> > +int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> > +{
> > +       if (tcon->cfid.is_valid &&
> > +           !memcmp(lease_key,
> > +                   tcon->cfid.fid->lease_key,
> > +                   SMB2_LEASE_KEY_SIZE)) {
> > +               tcon->cfid.time = 0;
> > +               INIT_WORK(&tcon->cfid.lease_break,
> > +                         smb2_cached_lease_break);
> > +               queue_work(cifsiod_wq,
> > +                          &tcon->cfid.lease_break);
> > +               spin_unlock(&cifs_tcp_ses_lock);
> > +               return true;
> > +       }
> > +       return false;
> > +}
> > diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> > new file mode 100644
> > index 000000000000..3731c755eea5
> > --- /dev/null
> > +++ b/fs/cifs/cached_dir.h
> > @@ -0,0 +1,26 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + *  Functions to handle the cached directory entries
> > + *
> > + *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
> > + */
> > +
> > +#ifndef _CACHED_DIR_H
> > +#define _CACHED_DIR_H
> > +
> > +
> > +extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> > +                          const char *path,
> > +                          struct cifs_sb_info *cifs_sb,
> > +                          struct cached_fid **cfid);
> > +extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> > +                                    struct dentry *dentry,
> > +                                    struct cached_fid **cfid);
> > +extern void close_cached_dir(struct cached_fid *cfid);
> > +extern void close_cached_dir_lease(struct cached_fid *cfid);
> > +extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
> > +extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
> > +extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
> > +extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
> > +
> > +#endif                 /* _CACHED_DIR_H */
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index f909d9e9faaa..615fbe2bff3c 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -46,6 +46,7 @@
> >  #include "netlink.h"
> >  #endif
> >  #include "fs_context.h"
> > +#include "cached_dir.h"
> >
> >  /*
> >   * DOS dates from 1980/1/1 through 2107/12/31
> > @@ -264,30 +265,13 @@ cifs_read_super(struct super_block *sb)
> >  static void cifs_kill_sb(struct super_block *sb)
> >  {
> >         struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> > -       struct cifs_tcon *tcon;
> > -       struct cached_fid *cfid;
> > -       struct rb_root *root = &cifs_sb->tlink_tree;
> > -       struct rb_node *node;
> > -       struct tcon_link *tlink;
> >
> >         /*
> >          * We ned to release all dentries for the cached directories
> >          * before we kill the sb.
> >          */
> >         if (cifs_sb->root) {
> > -               for (node = rb_first(root); node; node = rb_next(node)) {
> > -                       tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> > -                       tcon = tlink_tcon(tlink);
> > -                       if (IS_ERR(tcon))
> > -                               continue;
> > -                       cfid = &tcon->crfid;
> > -                       mutex_lock(&cfid->fid_mutex);
> > -                       if (cfid->dentry) {
> > -                               dput(cfid->dentry);
> > -                               cfid->dentry = NULL;
> > -                       }
> > -                       mutex_unlock(&cfid->fid_mutex);
> > -               }
> > +               close_all_cached_dirs(cifs_sb);
> >
> >                 /* finally release root dentry */
> >                 dput(cifs_sb->root);
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 9b7f409bfc8c..657fabb9067b 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1253,7 +1253,7 @@ struct cifs_tcon {
> >         struct fscache_volume *fscache; /* cookie for share */
> >  #endif
> >         struct list_head pending_opens; /* list of incomplete opens */
> > -       struct cached_fid crfid; /* Cached root fid */
> > +       struct cached_fid cfid; /* Cached root fid */
> >         /* BB add field for back pointer to sb struct(s)? */
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >         struct list_head ulist; /* cache update list */
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index d59aebefa71c..881bf112d6ae 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -599,7 +599,6 @@ enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
> >  struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
> >  void cifs_aio_ctx_release(struct kref *refcount);
> >  int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
> > -void smb2_cached_lease_break(struct work_struct *work);
> >
> >  int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
> >                     struct sdesc **sdesc);
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 9ed21752f2df..78dfadd729fe 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -35,6 +35,7 @@
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >  #include "dfs_cache.h"
> >  #endif
> > +#include "cached_dir.h"
> >
> >  #ifdef CONFIG_CIFS_POSIX
> >  static struct {
> > @@ -91,12 +92,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
> >         }
> >         spin_unlock(&tcon->open_file_lock);
> >
> > -       mutex_lock(&tcon->crfid.fid_mutex);
> > -       tcon->crfid.is_valid = false;
> > -       /* cached handle is not valid, so SMB2_CLOSE won't be sent below */
> > -       close_cached_dir_lease_locked(&tcon->crfid);
> > -       memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
> > -       mutex_unlock(&tcon->crfid.fid_mutex);
> > +       invalidate_all_cached_dirs(tcon);
> >
> >         spin_lock(&cifs_tcp_ses_lock);
> >         if (tcon->status == TID_IN_FILES_INVALIDATE)
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 3ad303dd5e5a..7714f47d199b 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -25,6 +25,7 @@
> >  #include "fscache.h"
> >  #include "fs_context.h"
> >  #include "cifs_ioctl.h"
> > +#include "cached_dir.h"
> >
> >  static void cifs_set_ops(struct inode *inode)
> >  {
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index 16168ebd1a62..fa1a03ddbbe2 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -115,13 +115,13 @@ tconInfoAlloc(void)
> >         ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
> >         if (!ret_buf)
> >                 return NULL;
> > -       ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid), GFP_KERNEL);
> > -       if (!ret_buf->crfid.fid) {
> > +       ret_buf->cfid.fid = kzalloc(sizeof(*ret_buf->cfid.fid), GFP_KERNEL);
> > +       if (!ret_buf->cfid.fid) {
> >                 kfree(ret_buf);
> >                 return NULL;
> >         }
> > -       INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
> > -       mutex_init(&ret_buf->crfid.dirents.de_mutex);
> > +       INIT_LIST_HEAD(&ret_buf->cfid.dirents.entries);
> > +       mutex_init(&ret_buf->cfid.dirents.de_mutex);
> >
> >         atomic_inc(&tconInfoAllocCount);
> >         ret_buf->status = TID_NEW;
> > @@ -129,7 +129,7 @@ tconInfoAlloc(void)
> >         INIT_LIST_HEAD(&ret_buf->openFileList);
> >         INIT_LIST_HEAD(&ret_buf->tcon_list);
> >         spin_lock_init(&ret_buf->open_file_lock);
> > -       mutex_init(&ret_buf->crfid.fid_mutex);
> > +       mutex_init(&ret_buf->cfid.fid_mutex);
> >         spin_lock_init(&ret_buf->stat_lock);
> >         atomic_set(&ret_buf->num_local_opens, 0);
> >         atomic_set(&ret_buf->num_remote_opens, 0);
> > @@ -147,7 +147,7 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
> >         atomic_dec(&tconInfoAllocCount);
> >         kfree(buf_to_free->nativeFileSystem);
> >         kfree_sensitive(buf_to_free->password);
> > -       kfree(buf_to_free->crfid.fid);
> > +       kfree(buf_to_free->cfid.fid);
> >         kfree(buf_to_free);
> >  }
> >
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index 384cabdf47ca..a06072ae6c7e 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -21,6 +21,7 @@
> >  #include "cifsfs.h"
> >  #include "smb2proto.h"
> >  #include "fs_context.h"
> > +#include "cached_dir.h"
> >
> >  /*
> >   * To be safe - for UCS to UTF-8 with strings loaded with the rare long
> > diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> > index 8571a459c710..f6f9fc3f2e2d 100644
> > --- a/fs/cifs/smb2inode.c
> > +++ b/fs/cifs/smb2inode.c
> > @@ -23,6 +23,7 @@
> >  #include "smb2glob.h"
> >  #include "smb2pdu.h"
> >  #include "smb2proto.h"
> > +#include "cached_dir.h"
> >
> >  static void
> >  free_set_inf_compound(struct smb_rqst *rqst)
> > @@ -518,9 +519,9 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
> >                 rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
> >         /* If it is a root and its handle is cached then use it */
> >         if (!rc) {
> > -               if (tcon->crfid.file_all_info_is_valid) {
> > +               if (tcon->cfid.file_all_info_is_valid) {
> >                         move_smb2_info_to_cifs(data,
> > -                                              &tcon->crfid.file_all_info);
> > +                                              &tcon->cfid.file_all_info);
> >                 } else {
> >                         rc = SMB2_query_info(xid, tcon,
> >                                              cfid->fid->persistent_fid,
> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > index db0f27fd373b..d3d9174ddd7c 100644
> > --- a/fs/cifs/smb2misc.c
> > +++ b/fs/cifs/smb2misc.c
> > @@ -16,6 +16,7 @@
> >  #include "smb2status.h"
> >  #include "smb2glob.h"
> >  #include "nterr.h"
> > +#include "cached_dir.h"
> >
> >  static int
> >  check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
> > @@ -639,18 +640,8 @@ smb2_is_valid_lease_break(char *buffer)
> >                                 }
> >                                 spin_unlock(&tcon->open_file_lock);
> >
> > -                               if (tcon->crfid.is_valid &&
> > -                                   !memcmp(rsp->LeaseKey,
> > -                                           tcon->crfid.fid->lease_key,
> > -                                           SMB2_LEASE_KEY_SIZE)) {
> > -                                       tcon->crfid.time = 0;
> > -                                       INIT_WORK(&tcon->crfid.lease_break,
> > -                                                 smb2_cached_lease_break);
> > -                                       queue_work(cifsiod_wq,
> > -                                                  &tcon->crfid.lease_break);
> > -                                       spin_unlock(&cifs_tcp_ses_lock);
> > +                               if (cached_dir_lease_break(tcon, rsp->LeaseKey))
> >                                         return true;
> > -                               }
> >                         }
> >                 }
> >         }
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index aa4c1d403708..01aafedc477e 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -27,6 +27,7 @@
> >  #include "smbdirect.h"
> >  #include "fscache.h"
> >  #include "fs_context.h"
> > +#include "cached_dir.h"
> >
> >  /* Change credits for different ops and return the total number of credits */
> >  static int
> > @@ -701,300 +702,6 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
> >         return rc;
> >  }
> >
> > -static void
> > -smb2_close_cached_fid(struct kref *ref)
> > -{
> > -       struct cached_fid *cfid = container_of(ref, struct cached_fid,
> > -                                              refcount);
> > -       struct cached_dirent *dirent, *q;
> > -
> > -       if (cfid->is_valid) {
> > -               cifs_dbg(FYI, "clear cached root file handle\n");
> > -               SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
> > -                          cfid->fid->volatile_fid);
> > -       }
> > -
> > -       /*
> > -        * We only check validity above to send SMB2_close,
> > -        * but we still need to invalidate these entries
> > -        * when this function is called
> > -        */
> > -       cfid->is_valid = false;
> > -       cfid->file_all_info_is_valid = false;
> > -       cfid->has_lease = false;
> > -       if (cfid->dentry) {
> > -               dput(cfid->dentry);
> > -               cfid->dentry = NULL;
> > -       }
> > -       /*
> > -        * Delete all cached dirent names
> > -        */
> > -       mutex_lock(&cfid->dirents.de_mutex);
> > -       list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
> > -               list_del(&dirent->entry);
> > -               kfree(dirent->name);
> > -               kfree(dirent);
> > -       }
> > -       cfid->dirents.is_valid = 0;
> > -       cfid->dirents.is_failed = 0;
> > -       cfid->dirents.ctx = NULL;
> > -       cfid->dirents.pos = 0;
> > -       mutex_unlock(&cfid->dirents.de_mutex);
> > -
> > -}
> > -
> > -void close_cached_dir(struct cached_fid *cfid)
> > -{
> > -       mutex_lock(&cfid->fid_mutex);
> > -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> > -       mutex_unlock(&cfid->fid_mutex);
> > -}
> > -
> > -void close_cached_dir_lease_locked(struct cached_fid *cfid)
> > -{
> > -       if (cfid->has_lease) {
> > -               cfid->has_lease = false;
> > -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> > -       }
> > -}
> > -
> > -void close_cached_dir_lease(struct cached_fid *cfid)
> > -{
> > -       mutex_lock(&cfid->fid_mutex);
> > -       close_cached_dir_lease_locked(cfid);
> > -       mutex_unlock(&cfid->fid_mutex);
> > -}
> > -
> > -void
> > -smb2_cached_lease_break(struct work_struct *work)
> > -{
> > -       struct cached_fid *cfid = container_of(work,
> > -                               struct cached_fid, lease_break);
> > -
> > -       close_cached_dir_lease(cfid);
> > -}
> > -
> > -/*
> > - * Open the and cache a directory handle.
> > - * Only supported for the root handle.
> > - * If error then *cfid is not initialized.
> > - */
> > -int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> > -               const char *path,
> > -               struct cifs_sb_info *cifs_sb,
> > -               struct cached_fid **cfid)
> > -{
> > -       struct cifs_ses *ses;
> > -       struct TCP_Server_Info *server;
> > -       struct cifs_open_parms oparms;
> > -       struct smb2_create_rsp *o_rsp = NULL;
> > -       struct smb2_query_info_rsp *qi_rsp = NULL;
> > -       int resp_buftype[2];
> > -       struct smb_rqst rqst[2];
> > -       struct kvec rsp_iov[2];
> > -       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > -       struct kvec qi_iov[1];
> > -       int rc, flags = 0;
> > -       __le16 utf16_path = 0; /* Null - since an open of top of share */
> > -       u8 oplock = SMB2_OPLOCK_LEVEL_II;
> > -       struct cifs_fid *pfid;
> > -       struct dentry *dentry;
> > -
> > -       if (tcon == NULL || tcon->nohandlecache ||
> > -           is_smb1_server(tcon->ses->server))
> > -               return -ENOTSUPP;
> > -
> > -       ses = tcon->ses;
> > -       server = ses->server;
> > -
> > -       if (cifs_sb->root == NULL)
> > -               return -ENOENT;
> > -
> > -       if (strlen(path))
> > -               return -ENOENT;
> > -
> > -       dentry = cifs_sb->root;
> > -
> > -       mutex_lock(&tcon->crfid.fid_mutex);
> > -       if (tcon->crfid.is_valid) {
> > -               cifs_dbg(FYI, "found a cached root file handle\n");
> > -               *cfid = &tcon->crfid;
> > -               kref_get(&tcon->crfid.refcount);
> > -               mutex_unlock(&tcon->crfid.fid_mutex);
> > -               return 0;
> > -       }
> > -
> > -       /*
> > -        * We do not hold the lock for the open because in case
> > -        * SMB2_open needs to reconnect, it will end up calling
> > -        * cifs_mark_open_files_invalid() which takes the lock again
> > -        * thus causing a deadlock
> > -        */
> > -
> > -       mutex_unlock(&tcon->crfid.fid_mutex);
> > -
> > -       if (smb3_encryption_required(tcon))
> > -               flags |= CIFS_TRANSFORM_REQ;
> > -
> > -       if (!server->ops->new_lease_key)
> > -               return -EIO;
> > -
> > -       pfid = tcon->crfid.fid;
> > -       server->ops->new_lease_key(pfid);
> > -
> > -       memset(rqst, 0, sizeof(rqst));
> > -       resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
> > -       memset(rsp_iov, 0, sizeof(rsp_iov));
> > -
> > -       /* Open */
> > -       memset(&open_iov, 0, sizeof(open_iov));
> > -       rqst[0].rq_iov = open_iov;
> > -       rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
> > -
> > -       oparms.tcon = tcon;
> > -       oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
> > -       oparms.desired_access = FILE_READ_ATTRIBUTES;
> > -       oparms.disposition = FILE_OPEN;
> > -       oparms.fid = pfid;
> > -       oparms.reconnect = false;
> > -
> > -       rc = SMB2_open_init(tcon, server,
> > -                           &rqst[0], &oplock, &oparms, &utf16_path);
> > -       if (rc)
> > -               goto oshr_free;
> > -       smb2_set_next_command(tcon, &rqst[0]);
> > -
> > -       memset(&qi_iov, 0, sizeof(qi_iov));
> > -       rqst[1].rq_iov = qi_iov;
> > -       rqst[1].rq_nvec = 1;
> > -
> > -       rc = SMB2_query_info_init(tcon, server,
> > -                                 &rqst[1], COMPOUND_FID,
> > -                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> > -                                 SMB2_O_INFO_FILE, 0,
> > -                                 sizeof(struct smb2_file_all_info) +
> > -                                 PATH_MAX * 2, 0, NULL);
> > -       if (rc)
> > -               goto oshr_free;
> > -
> > -       smb2_set_related(&rqst[1]);
> > -
> > -       rc = compound_send_recv(xid, ses, server,
> > -                               flags, 2, rqst,
> > -                               resp_buftype, rsp_iov);
> > -       mutex_lock(&tcon->crfid.fid_mutex);
> > -
> > -       /*
> > -        * Now we need to check again as the cached root might have
> > -        * been successfully re-opened from a concurrent process
> > -        */
> > -
> > -       if (tcon->crfid.is_valid) {
> > -               /* work was already done */
> > -
> > -               /* stash fids for close() later */
> > -               struct cifs_fid fid = {
> > -                       .persistent_fid = pfid->persistent_fid,
> > -                       .volatile_fid = pfid->volatile_fid,
> > -               };
> > -
> > -               /*
> > -                * caller expects this func to set the fid in crfid to valid
> > -                * cached root, so increment the refcount.
> > -                */
> > -               kref_get(&tcon->crfid.refcount);
> > -
> > -               mutex_unlock(&tcon->crfid.fid_mutex);
> > -
> > -               if (rc == 0) {
> > -                       /* close extra handle outside of crit sec */
> > -                       SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> > -               }
> > -               rc = 0;
> > -               goto oshr_free;
> > -       }
> > -
> > -       /* Cached root is still invalid, continue normaly */
> > -
> > -       if (rc) {
> > -               if (rc == -EREMCHG) {
> > -                       tcon->need_reconnect = true;
> > -                       pr_warn_once("server share %s deleted\n",
> > -                                    tcon->treeName);
> > -               }
> > -               goto oshr_exit;
> > -       }
> > -
> > -       atomic_inc(&tcon->num_remote_opens);
> > -
> > -       o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> > -       oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> > -       oparms.fid->volatile_fid = o_rsp->VolatileFileId;
> > -#ifdef CONFIG_CIFS_DEBUG2
> > -       oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
> > -#endif /* CIFS_DEBUG2 */
> > -
> > -       tcon->crfid.tcon = tcon;
> > -       tcon->crfid.is_valid = true;
> > -       tcon->crfid.dentry = dentry;
> > -       dget(dentry);
> > -       kref_init(&tcon->crfid.refcount);
> > -
> > -       /* BB TBD check to see if oplock level check can be removed below */
> > -       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> > -               /*
> > -                * See commit 2f94a3125b87. Increment the refcount when we
> > -                * get a lease for root, release it if lease break occurs
> > -                */
> > -               kref_get(&tcon->crfid.refcount);
> > -               tcon->crfid.has_lease = true;
> > -               smb2_parse_contexts(server, o_rsp,
> > -                               &oparms.fid->epoch,
> > -                                   oparms.fid->lease_key, &oplock,
> > -                                   NULL, NULL);
> > -       } else
> > -               goto oshr_exit;
> > -
> > -       qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> > -       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> > -               goto oshr_exit;
> > -       if (!smb2_validate_and_copy_iov(
> > -                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> > -                               sizeof(struct smb2_file_all_info),
> > -                               &rsp_iov[1], sizeof(struct smb2_file_all_info),
> > -                               (char *)&tcon->crfid.file_all_info))
> > -               tcon->crfid.file_all_info_is_valid = true;
> > -       tcon->crfid.time = jiffies;
> > -
> > -
> > -oshr_exit:
> > -       mutex_unlock(&tcon->crfid.fid_mutex);
> > -oshr_free:
> > -       SMB2_open_free(&rqst[0]);
> > -       SMB2_query_info_free(&rqst[1]);
> > -       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> > -       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> > -       if (rc == 0)
> > -               *cfid = &tcon->crfid;
> > -       return rc;
> > -}
> > -
> > -int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> > -                             struct dentry *dentry,
> > -                             struct cached_fid **cfid)
> > -{
> > -       mutex_lock(&tcon->crfid.fid_mutex);
> > -       if (tcon->crfid.dentry == dentry) {
> > -               cifs_dbg(FYI, "found a cached root file handle by dentry\n");
> > -               *cfid = &tcon->crfid;
> > -               kref_get(&tcon->crfid.refcount);
> > -               mutex_unlock(&tcon->crfid.fid_mutex);
> > -               return 0;
> > -       }
> > -       mutex_unlock(&tcon->crfid.fid_mutex);
> > -       return -ENOENT;
> > -}
> > -
> >  static void
> >  smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
> >               struct cifs_sb_info *cifs_sb)
> > @@ -1077,7 +784,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
> >         struct cifs_open_parms oparms;
> >         struct cifs_fid fid;
> >
> > -       if ((*full_path == 0) && tcon->crfid.is_valid)
> > +       if ((*full_path == 0) && tcon->cfid.is_valid)
> >                 return 0;
> >
> >         utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 295ee8b88055..9ee1b6225619 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -39,6 +39,7 @@
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >  #include "dfs_cache.h"
> >  #endif
> > +#include "cached_dir.h"
> >
> >  /*
> >   *  The following table defines the expected "StructureSize" of SMB2 requests
> > @@ -1978,7 +1979,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
> >         }
> >         spin_unlock(&ses->chan_lock);
> >
> > -       close_cached_dir_lease(&tcon->crfid);
> > +       close_cached_dir_lease(&tcon->cfid);
> >
> >         rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
> >                                  (void **) &req,
> > diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> > index a69f1eed1cfe..51c5bf4a338a 100644
> > --- a/fs/cifs/smb2proto.h
> > +++ b/fs/cifs/smb2proto.h
> > @@ -54,16 +54,6 @@ extern bool smb2_is_valid_oplock_break(char *buffer,
> >  extern int smb3_handle_read_data(struct TCP_Server_Info *server,
> >                                  struct mid_q_entry *mid);
> >
> > -extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> > -                          const char *path,
> > -                          struct cifs_sb_info *cifs_sb,
> > -                          struct cached_fid **cfid);
> > -extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> > -                                    struct dentry *dentry,
> > -                                    struct cached_fid **cfid);
> > -extern void close_cached_dir(struct cached_fid *cfid);
> > -extern void close_cached_dir_lease(struct cached_fid *cfid);
> > -extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
> >  extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
> >                                    struct smb2_file_all_info *src);
> >  extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
> > --
> > 2.35.3
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000e3334f05e5ee7981
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Move-cached-dir-functions-into-a-separate-file.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Move-cached-dir-functions-into-a-separate-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6ogn2i00>
X-Attachment-Id: f_l6ogn2i00

RnJvbSA1MjBkMTYwOTc2MmUwMzgzYTI1Yjc3ZTQxNGFiYzkwYWRiNWU1NTIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFdlZCwgMTAgQXVnIDIwMjIgMjI6MDA6MDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBNb3ZlIGNhY2hlZC1kaXIgZnVuY3Rpb25zIGludG8gYSBzZXBhcmF0ZSBmaWxlCgpBbHNv
IHJlbmFtZSBjcmZpZCB0byBjZmlkIHRvIGhhdmUgY29uc2lzdGVudCBuYW1pbmcgZm9yIHRoaXMg
dmFyaWFibGUuCgpUaGlzIGNvbW1pdCBkb2VzIG5vdCBjaGFuZ2UgYW55IGxvZ2ljLgoKU2lnbmVk
LW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9N
YWtlZmlsZSAgICAgfCAgIDIgKy0KIGZzL2NpZnMvY2FjaGVkX2Rpci5jIHwgMzYyICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvY2FjaGVkX2Rpci5o
IHwgIDI2ICsrKysKIGZzL2NpZnMvY2lmc2ZzLmMgICAgIHwgIDIwICstLQogZnMvY2lmcy9jaWZz
Z2xvYi5oICAgfCAgIDIgKy0KIGZzL2NpZnMvY2lmc3Byb3RvLmggIHwgICAxIC0KIGZzL2NpZnMv
ZmlsZS5jICAgICAgIHwgICA5ICstCiBmcy9jaWZzL2lub2RlLmMgICAgICB8ICAgMSArCiBmcy9j
aWZzL21pc2MuYyAgICAgICB8ICAxMiArLQogZnMvY2lmcy9yZWFkZGlyLmMgICAgfCAgIDEgKwog
ZnMvY2lmcy9zbWIyaW5vZGUuYyAgfCAgIDUgKy0KIGZzL2NpZnMvc21iMm1pc2MuYyAgIHwgIDEx
ICstCiBmcy9jaWZzL3NtYjJvcHMuYyAgICB8IDI5NyArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogZnMvY2lmcy9zbWIycGR1LmMgICAgfCAgIDMgKy0KIGZzL2NpZnMvc21iMnBy
b3RvLmggIHwgIDEwIC0tCiAxNSBmaWxlcyBjaGFuZ2VkLCA0MTEgaW5zZXJ0aW9ucygrKSwgMzUx
IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGZzL2NpZnMvY2FjaGVkX2Rpci5jCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZnMvY2lmcy9jYWNoZWRfZGlyLmgKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL01ha2VmaWxlIGIvZnMvY2lmcy9NYWtlZmlsZQppbmRleCBlODgyZTkxMmE1MTcuLjdjOTc4
NTk3M2Y0OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9NYWtlZmlsZQorKysgYi9mcy9jaWZzL01ha2Vm
aWxlCkBAIC03LDcgKzcsNyBAQCBvYmotJChDT05GSUdfQ0lGUykgKz0gY2lmcy5vCiAKIGNpZnMt
eSA6PSB0cmFjZS5vIGNpZnNmcy5vIGNpZnNfZGVidWcubyBjb25uZWN0Lm8gZGlyLm8gZmlsZS5v
IFwKIAkgIGlub2RlLm8gbGluay5vIG1pc2MubyBuZXRtaXNjLm8gc21iZW5jcnlwdC5vIHRyYW5z
cG9ydC5vIFwKLQkgIGNpZnNfdW5pY29kZS5vIG50ZXJyLm8gY2lmc2VuY3J5cHQubyBcCisJICBj
YWNoZWRfZGlyLm8gY2lmc191bmljb2RlLm8gbnRlcnIubyBjaWZzZW5jcnlwdC5vIFwKIAkgIHJl
YWRkaXIubyBpb2N0bC5vIHNlc3MubyBleHBvcnQubyB1bmMubyB3aW51Y2FzZS5vIFwKIAkgIHNt
YjJvcHMubyBzbWIybWFwZXJyb3IubyBzbWIydHJhbnNwb3J0Lm8gXAogCSAgc21iMm1pc2MubyBz
bWIycGR1Lm8gc21iMmlub2RlLm8gc21iMmZpbGUubyBjaWZzYWNsLm8gZnNfY29udGV4dC5vIFwK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2FjaGVkX2Rpci5jIGIvZnMvY2lmcy9jYWNoZWRfZGlyLmMK
bmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi43NTNiODUwYjZmODcKLS0t
IC9kZXYvbnVsbAorKysgYi9mcy9jaWZzL2NhY2hlZF9kaXIuYwpAQCAtMCwwICsxLDM2MiBAQAor
Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKKy8qCisgKiAgRnVuY3Rpb25zIHRv
IGhhbmRsZSB0aGUgY2FjaGVkIGRpcmVjdG9yeSBlbnRyaWVzCisgKgorICogIENvcHlyaWdodCAo
YykgMjAyMiwgUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgorICovCisKKyNp
bmNsdWRlICJjaWZzZ2xvYi5oIgorI2luY2x1ZGUgImNpZnNwcm90by5oIgorI2luY2x1ZGUgImNp
ZnNfZGVidWcuaCIKKyNpbmNsdWRlICJzbWIycHJvdG8uaCIKKyNpbmNsdWRlICJjYWNoZWRfZGly
LmgiCisKKy8qCisgKiBPcGVuIHRoZSBhbmQgY2FjaGUgYSBkaXJlY3RvcnkgaGFuZGxlLgorICog
SWYgZXJyb3IgdGhlbiAqY2ZpZCBpcyBub3QgaW5pdGlhbGl6ZWQuCisgKi8KK2ludCBvcGVuX2Nh
Y2hlZF9kaXIodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKKwkJY29u
c3QgY2hhciAqcGF0aCwKKwkJc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKKwkJc3RydWN0
IGNhY2hlZF9maWQgKipjZmlkKQoreworCXN0cnVjdCBjaWZzX3NlcyAqc2VzOworCXN0cnVjdCBU
Q1BfU2VydmVyX0luZm8gKnNlcnZlcjsKKwlzdHJ1Y3QgY2lmc19vcGVuX3Bhcm1zIG9wYXJtczsK
KwlzdHJ1Y3Qgc21iMl9jcmVhdGVfcnNwICpvX3JzcCA9IE5VTEw7CisJc3RydWN0IHNtYjJfcXVl
cnlfaW5mb19yc3AgKnFpX3JzcCA9IE5VTEw7CisJaW50IHJlc3BfYnVmdHlwZVsyXTsKKwlzdHJ1
Y3Qgc21iX3Jxc3QgcnFzdFsyXTsKKwlzdHJ1Y3Qga3ZlYyByc3BfaW92WzJdOworCXN0cnVjdCBr
dmVjIG9wZW5faW92W1NNQjJfQ1JFQVRFX0lPVl9TSVpFXTsKKwlzdHJ1Y3Qga3ZlYyBxaV9pb3Zb
MV07CisJaW50IHJjLCBmbGFncyA9IDA7CisJX19sZTE2IHV0ZjE2X3BhdGggPSAwOyAvKiBOdWxs
IC0gc2luY2UgYW4gb3BlbiBvZiB0b3Agb2Ygc2hhcmUgKi8KKwl1OCBvcGxvY2sgPSBTTUIyX09Q
TE9DS19MRVZFTF9JSTsKKwlzdHJ1Y3QgY2lmc19maWQgKnBmaWQ7CisJc3RydWN0IGRlbnRyeSAq
ZGVudHJ5OworCisJaWYgKHRjb24gPT0gTlVMTCB8fCB0Y29uLT5ub2hhbmRsZWNhY2hlIHx8CisJ
ICAgIGlzX3NtYjFfc2VydmVyKHRjb24tPnNlcy0+c2VydmVyKSkKKwkJcmV0dXJuIC1FT1BOT1RT
VVBQOworCisJc2VzID0gdGNvbi0+c2VzOworCXNlcnZlciA9IHNlcy0+c2VydmVyOworCisJaWYg
KGNpZnNfc2ItPnJvb3QgPT0gTlVMTCkKKwkJcmV0dXJuIC1FTk9FTlQ7CisKKwlpZiAoc3RybGVu
KHBhdGgpKQorCQlyZXR1cm4gLUVOT0VOVDsKKworCWRlbnRyeSA9IGNpZnNfc2ItPnJvb3Q7CisK
KwltdXRleF9sb2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRleCk7CisJaWYgKHRjb24tPmNmaWQuaXNf
dmFsaWQpIHsKKwkJY2lmc19kYmcoRllJLCAiZm91bmQgYSBjYWNoZWQgcm9vdCBmaWxlIGhhbmRs
ZVxuIik7CisJCSpjZmlkID0gJnRjb24tPmNmaWQ7CisJCWtyZWZfZ2V0KCZ0Y29uLT5jZmlkLnJl
ZmNvdW50KTsKKwkJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRleCk7CisJCXJldHVy
biAwOworCX0KKworCS8qCisJICogV2UgZG8gbm90IGhvbGQgdGhlIGxvY2sgZm9yIHRoZSBvcGVu
IGJlY2F1c2UgaW4gY2FzZQorCSAqIFNNQjJfb3BlbiBuZWVkcyB0byByZWNvbm5lY3QsIGl0IHdp
bGwgZW5kIHVwIGNhbGxpbmcKKwkgKiBjaWZzX21hcmtfb3Blbl9maWxlc19pbnZhbGlkKCkgd2hp
Y2ggdGFrZXMgdGhlIGxvY2sgYWdhaW4KKwkgKiB0aHVzIGNhdXNpbmcgYSBkZWFkbG9jaworCSAq
LworCisJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRleCk7CisKKwlpZiAoc21iM19l
bmNyeXB0aW9uX3JlcXVpcmVkKHRjb24pKQorCQlmbGFncyB8PSBDSUZTX1RSQU5TRk9STV9SRVE7
CisKKwlpZiAoIXNlcnZlci0+b3BzLT5uZXdfbGVhc2Vfa2V5KQorCQlyZXR1cm4gLUVJTzsKKwor
CXBmaWQgPSB0Y29uLT5jZmlkLmZpZDsKKwlzZXJ2ZXItPm9wcy0+bmV3X2xlYXNlX2tleShwZmlk
KTsKKworCW1lbXNldChycXN0LCAwLCBzaXplb2YocnFzdCkpOworCXJlc3BfYnVmdHlwZVswXSA9
IHJlc3BfYnVmdHlwZVsxXSA9IENJRlNfTk9fQlVGRkVSOworCW1lbXNldChyc3BfaW92LCAwLCBz
aXplb2YocnNwX2lvdikpOworCisJLyogT3BlbiAqLworCW1lbXNldCgmb3Blbl9pb3YsIDAsIHNp
emVvZihvcGVuX2lvdikpOworCXJxc3RbMF0ucnFfaW92ID0gb3Blbl9pb3Y7CisJcnFzdFswXS5y
cV9udmVjID0gU01CMl9DUkVBVEVfSU9WX1NJWkU7CisKKwlvcGFybXMudGNvbiA9IHRjb247CisJ
b3Bhcm1zLmNyZWF0ZV9vcHRpb25zID0gY2lmc19jcmVhdGVfb3B0aW9ucyhjaWZzX3NiLCBDUkVB
VEVfTk9UX0ZJTEUpOworCW9wYXJtcy5kZXNpcmVkX2FjY2VzcyA9IEZJTEVfUkVBRF9BVFRSSUJV
VEVTOworCW9wYXJtcy5kaXNwb3NpdGlvbiA9IEZJTEVfT1BFTjsKKwlvcGFybXMuZmlkID0gcGZp
ZDsKKwlvcGFybXMucmVjb25uZWN0ID0gZmFsc2U7CisKKwlyYyA9IFNNQjJfb3Blbl9pbml0KHRj
b24sIHNlcnZlciwKKwkJCSAgICAmcnFzdFswXSwgJm9wbG9jaywgJm9wYXJtcywgJnV0ZjE2X3Bh
dGgpOworCWlmIChyYykKKwkJZ290byBvc2hyX2ZyZWU7CisJc21iMl9zZXRfbmV4dF9jb21tYW5k
KHRjb24sICZycXN0WzBdKTsKKworCW1lbXNldCgmcWlfaW92LCAwLCBzaXplb2YocWlfaW92KSk7
CisJcnFzdFsxXS5ycV9pb3YgPSBxaV9pb3Y7CisJcnFzdFsxXS5ycV9udmVjID0gMTsKKworCXJj
ID0gU01CMl9xdWVyeV9pbmZvX2luaXQodGNvbiwgc2VydmVyLAorCQkJCSAgJnJxc3RbMV0sIENP
TVBPVU5EX0ZJRCwKKwkJCQkgIENPTVBPVU5EX0ZJRCwgRklMRV9BTExfSU5GT1JNQVRJT04sCisJ
CQkJICBTTUIyX09fSU5GT19GSUxFLCAwLAorCQkJCSAgc2l6ZW9mKHN0cnVjdCBzbWIyX2ZpbGVf
YWxsX2luZm8pICsKKwkJCQkgIFBBVEhfTUFYICogMiwgMCwgTlVMTCk7CisJaWYgKHJjKQorCQln
b3RvIG9zaHJfZnJlZTsKKworCXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbMV0pOworCisJcmMgPSBj
b21wb3VuZF9zZW5kX3JlY3YoeGlkLCBzZXMsIHNlcnZlciwKKwkJCQlmbGFncywgMiwgcnFzdCwK
KwkJCQlyZXNwX2J1ZnR5cGUsIHJzcF9pb3YpOworCW11dGV4X2xvY2soJnRjb24tPmNmaWQuZmlk
X211dGV4KTsKKworCS8qCisJICogTm93IHdlIG5lZWQgdG8gY2hlY2sgYWdhaW4gYXMgdGhlIGNh
Y2hlZCByb290IG1pZ2h0IGhhdmUKKwkgKiBiZWVuIHN1Y2Nlc3NmdWxseSByZS1vcGVuZWQgZnJv
bSBhIGNvbmN1cnJlbnQgcHJvY2VzcworCSAqLworCisJaWYgKHRjb24tPmNmaWQuaXNfdmFsaWQp
IHsKKwkJLyogd29yayB3YXMgYWxyZWFkeSBkb25lICovCisKKwkJLyogc3Rhc2ggZmlkcyBmb3Ig
Y2xvc2UoKSBsYXRlciAqLworCQlzdHJ1Y3QgY2lmc19maWQgZmlkID0geworCQkJLnBlcnNpc3Rl
bnRfZmlkID0gcGZpZC0+cGVyc2lzdGVudF9maWQsCisJCQkudm9sYXRpbGVfZmlkID0gcGZpZC0+
dm9sYXRpbGVfZmlkLAorCQl9OworCisJCS8qCisJCSAqIGNhbGxlciBleHBlY3RzIHRoaXMgZnVu
YyB0byBzZXQgdGhlIGZpZCBpbiBjZmlkIHRvIHZhbGlkCisJCSAqIGNhY2hlZCByb290LCBzbyBp
bmNyZW1lbnQgdGhlIHJlZmNvdW50LgorCQkgKi8KKwkJa3JlZl9nZXQoJnRjb24tPmNmaWQucmVm
Y291bnQpOworCisJCW11dGV4X3VubG9jaygmdGNvbi0+Y2ZpZC5maWRfbXV0ZXgpOworCisJCWlm
IChyYyA9PSAwKSB7CisJCQkvKiBjbG9zZSBleHRyYSBoYW5kbGUgb3V0c2lkZSBvZiBjcml0IHNl
YyAqLworCQkJU01CMl9jbG9zZSh4aWQsIHRjb24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZv
bGF0aWxlX2ZpZCk7CisJCX0KKwkJcmMgPSAwOworCQlnb3RvIG9zaHJfZnJlZTsKKwl9CisKKwkv
KiBDYWNoZWQgcm9vdCBpcyBzdGlsbCBpbnZhbGlkLCBjb250aW51ZSBub3JtYWx5ICovCisKKwlp
ZiAocmMpIHsKKwkJaWYgKHJjID09IC1FUkVNQ0hHKSB7CisJCQl0Y29uLT5uZWVkX3JlY29ubmVj
dCA9IHRydWU7CisJCQlwcl93YXJuX29uY2UoInNlcnZlciBzaGFyZSAlcyBkZWxldGVkXG4iLAor
CQkJCSAgICAgdGNvbi0+dHJlZU5hbWUpOworCQl9CisJCWdvdG8gb3Nocl9leGl0OworCX0KKwor
CWF0b21pY19pbmMoJnRjb24tPm51bV9yZW1vdGVfb3BlbnMpOworCisJb19yc3AgPSAoc3RydWN0
IHNtYjJfY3JlYXRlX3JzcCAqKXJzcF9pb3ZbMF0uaW92X2Jhc2U7CisJb3Bhcm1zLmZpZC0+cGVy
c2lzdGVudF9maWQgPSBvX3JzcC0+UGVyc2lzdGVudEZpbGVJZDsKKwlvcGFybXMuZmlkLT52b2xh
dGlsZV9maWQgPSBvX3JzcC0+Vm9sYXRpbGVGaWxlSWQ7CisjaWZkZWYgQ09ORklHX0NJRlNfREVC
VUcyCisJb3Bhcm1zLmZpZC0+bWlkID0gbGU2NF90b19jcHUob19yc3AtPmhkci5NZXNzYWdlSWQp
OworI2VuZGlmIC8qIENJRlNfREVCVUcyICovCisKKwl0Y29uLT5jZmlkLnRjb24gPSB0Y29uOwor
CXRjb24tPmNmaWQuaXNfdmFsaWQgPSB0cnVlOworCXRjb24tPmNmaWQuZGVudHJ5ID0gZGVudHJ5
OworCWRnZXQoZGVudHJ5KTsKKwlrcmVmX2luaXQoJnRjb24tPmNmaWQucmVmY291bnQpOworCisJ
LyogQkIgVEJEIGNoZWNrIHRvIHNlZSBpZiBvcGxvY2sgbGV2ZWwgY2hlY2sgY2FuIGJlIHJlbW92
ZWQgYmVsb3cgKi8KKwlpZiAob19yc3AtPk9wbG9ja0xldmVsID09IFNNQjJfT1BMT0NLX0xFVkVM
X0xFQVNFKSB7CisJCS8qCisJCSAqIFNlZSBjb21taXQgMmY5NGEzMTI1Yjg3LiBJbmNyZW1lbnQg
dGhlIHJlZmNvdW50IHdoZW4gd2UKKwkJICogZ2V0IGEgbGVhc2UgZm9yIHJvb3QsIHJlbGVhc2Ug
aXQgaWYgbGVhc2UgYnJlYWsgb2NjdXJzCisJCSAqLworCQlrcmVmX2dldCgmdGNvbi0+Y2ZpZC5y
ZWZjb3VudCk7CisJCXRjb24tPmNmaWQuaGFzX2xlYXNlID0gdHJ1ZTsKKwkJc21iMl9wYXJzZV9j
b250ZXh0cyhzZXJ2ZXIsIG9fcnNwLAorCQkJCSZvcGFybXMuZmlkLT5lcG9jaCwKKwkJCQkgICAg
b3Bhcm1zLmZpZC0+bGVhc2Vfa2V5LCAmb3Bsb2NrLAorCQkJCSAgICBOVUxMLCBOVUxMKTsKKwl9
IGVsc2UKKwkJZ290byBvc2hyX2V4aXQ7CisKKwlxaV9yc3AgPSAoc3RydWN0IHNtYjJfcXVlcnlf
aW5mb19yc3AgKilyc3BfaW92WzFdLmlvdl9iYXNlOworCWlmIChsZTMyX3RvX2NwdShxaV9yc3At
Pk91dHB1dEJ1ZmZlckxlbmd0aCkgPCBzaXplb2Yoc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbykp
CisJCWdvdG8gb3Nocl9leGl0OworCWlmICghc21iMl92YWxpZGF0ZV9hbmRfY29weV9pb3YoCisJ
CQkJbGUxNl90b19jcHUocWlfcnNwLT5PdXRwdXRCdWZmZXJPZmZzZXQpLAorCQkJCXNpemVvZihz
dHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvKSwKKwkJCQkmcnNwX2lvdlsxXSwgc2l6ZW9mKHN0cnVj
dCBzbWIyX2ZpbGVfYWxsX2luZm8pLAorCQkJCShjaGFyICopJnRjb24tPmNmaWQuZmlsZV9hbGxf
aW5mbykpCisJCXRjb24tPmNmaWQuZmlsZV9hbGxfaW5mb19pc192YWxpZCA9IHRydWU7CisJdGNv
bi0+Y2ZpZC50aW1lID0gamlmZmllczsKKworCitvc2hyX2V4aXQ6CisJbXV0ZXhfdW5sb2NrKCZ0
Y29uLT5jZmlkLmZpZF9tdXRleCk7Citvc2hyX2ZyZWU6CisJU01CMl9vcGVuX2ZyZWUoJnJxc3Rb
MF0pOworCVNNQjJfcXVlcnlfaW5mb19mcmVlKCZycXN0WzFdKTsKKwlmcmVlX3JzcF9idWYocmVz
cF9idWZ0eXBlWzBdLCByc3BfaW92WzBdLmlvdl9iYXNlKTsKKwlmcmVlX3JzcF9idWYocmVzcF9i
dWZ0eXBlWzFdLCByc3BfaW92WzFdLmlvdl9iYXNlKTsKKwlpZiAocmMgPT0gMCkKKwkJKmNmaWQg
PSAmdGNvbi0+Y2ZpZDsKKworCXJldHVybiByYzsKK30KKworaW50IG9wZW5fY2FjaGVkX2Rpcl9i
eV9kZW50cnkoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKKwkJCSAgICAgIHN0cnVjdCBkZW50cnkg
KmRlbnRyeSwKKwkJCSAgICAgIHN0cnVjdCBjYWNoZWRfZmlkICoqY2ZpZCkKK3sKKwltdXRleF9s
b2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRleCk7CisJaWYgKHRjb24tPmNmaWQuZGVudHJ5ID09IGRl
bnRyeSkgeworCQljaWZzX2RiZyhGWUksICJmb3VuZCBhIGNhY2hlZCByb290IGZpbGUgaGFuZGxl
IGJ5IGRlbnRyeVxuIik7CisJCSpjZmlkID0gJnRjb24tPmNmaWQ7CisJCWtyZWZfZ2V0KCZ0Y29u
LT5jZmlkLnJlZmNvdW50KTsKKwkJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRleCk7
CisJCXJldHVybiAwOworCX0KKwltdXRleF91bmxvY2soJnRjb24tPmNmaWQuZmlkX211dGV4KTsK
KwlyZXR1cm4gLUVOT0VOVDsKK30KKworc3RhdGljIHZvaWQKK3NtYjJfY2xvc2VfY2FjaGVkX2Zp
ZChzdHJ1Y3Qga3JlZiAqcmVmKQoreworCXN0cnVjdCBjYWNoZWRfZmlkICpjZmlkID0gY29udGFp
bmVyX29mKHJlZiwgc3RydWN0IGNhY2hlZF9maWQsCisJCQkJCSAgICAgICByZWZjb3VudCk7CisJ
c3RydWN0IGNhY2hlZF9kaXJlbnQgKmRpcmVudCwgKnE7CisKKwlpZiAoY2ZpZC0+aXNfdmFsaWQp
IHsKKwkJY2lmc19kYmcoRllJLCAiY2xlYXIgY2FjaGVkIHJvb3QgZmlsZSBoYW5kbGVcbiIpOwor
CQlTTUIyX2Nsb3NlKDAsIGNmaWQtPnRjb24sIGNmaWQtPmZpZC0+cGVyc2lzdGVudF9maWQsCisJ
CQkgICBjZmlkLT5maWQtPnZvbGF0aWxlX2ZpZCk7CisJfQorCisJLyoKKwkgKiBXZSBvbmx5IGNo
ZWNrIHZhbGlkaXR5IGFib3ZlIHRvIHNlbmQgU01CMl9jbG9zZSwKKwkgKiBidXQgd2Ugc3RpbGwg
bmVlZCB0byBpbnZhbGlkYXRlIHRoZXNlIGVudHJpZXMKKwkgKiB3aGVuIHRoaXMgZnVuY3Rpb24g
aXMgY2FsbGVkCisJICovCisJY2ZpZC0+aXNfdmFsaWQgPSBmYWxzZTsKKwljZmlkLT5maWxlX2Fs
bF9pbmZvX2lzX3ZhbGlkID0gZmFsc2U7CisJY2ZpZC0+aGFzX2xlYXNlID0gZmFsc2U7CisJaWYg
KGNmaWQtPmRlbnRyeSkgeworCQlkcHV0KGNmaWQtPmRlbnRyeSk7CisJCWNmaWQtPmRlbnRyeSA9
IE5VTEw7CisJfQorCS8qCisJICogRGVsZXRlIGFsbCBjYWNoZWQgZGlyZW50IG5hbWVzCisJICov
CisJbXV0ZXhfbG9jaygmY2ZpZC0+ZGlyZW50cy5kZV9tdXRleCk7CisJbGlzdF9mb3JfZWFjaF9l
bnRyeV9zYWZlKGRpcmVudCwgcSwgJmNmaWQtPmRpcmVudHMuZW50cmllcywgZW50cnkpIHsKKwkJ
bGlzdF9kZWwoJmRpcmVudC0+ZW50cnkpOworCQlrZnJlZShkaXJlbnQtPm5hbWUpOworCQlrZnJl
ZShkaXJlbnQpOworCX0KKwljZmlkLT5kaXJlbnRzLmlzX3ZhbGlkID0gMDsKKwljZmlkLT5kaXJl
bnRzLmlzX2ZhaWxlZCA9IDA7CisJY2ZpZC0+ZGlyZW50cy5jdHggPSBOVUxMOworCWNmaWQtPmRp
cmVudHMucG9zID0gMDsKKwltdXRleF91bmxvY2soJmNmaWQtPmRpcmVudHMuZGVfbXV0ZXgpOwor
Cit9CisKK3ZvaWQgY2xvc2VfY2FjaGVkX2RpcihzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCkKK3sK
KwltdXRleF9sb2NrKCZjZmlkLT5maWRfbXV0ZXgpOworCWtyZWZfcHV0KCZjZmlkLT5yZWZjb3Vu
dCwgc21iMl9jbG9zZV9jYWNoZWRfZmlkKTsKKwltdXRleF91bmxvY2soJmNmaWQtPmZpZF9tdXRl
eCk7Cit9CisKK3ZvaWQgY2xvc2VfY2FjaGVkX2Rpcl9sZWFzZV9sb2NrZWQoc3RydWN0IGNhY2hl
ZF9maWQgKmNmaWQpCit7CisJaWYgKGNmaWQtPmhhc19sZWFzZSkgeworCQljZmlkLT5oYXNfbGVh
c2UgPSBmYWxzZTsKKwkJa3JlZl9wdXQoJmNmaWQtPnJlZmNvdW50LCBzbWIyX2Nsb3NlX2NhY2hl
ZF9maWQpOworCX0KK30KKwordm9pZCBjbG9zZV9jYWNoZWRfZGlyX2xlYXNlKHN0cnVjdCBjYWNo
ZWRfZmlkICpjZmlkKQoreworCW11dGV4X2xvY2soJmNmaWQtPmZpZF9tdXRleCk7CisJY2xvc2Vf
Y2FjaGVkX2Rpcl9sZWFzZV9sb2NrZWQoY2ZpZCk7CisJbXV0ZXhfdW5sb2NrKCZjZmlkLT5maWRf
bXV0ZXgpOworfQorCisvKgorICogQ2FsbGVkIGZyb20gY2lmc19raWxsX3NiIHdoZW4gd2UgdW5t
b3VudCBhIHNoYXJlCisgKi8KK3ZvaWQgY2xvc2VfYWxsX2NhY2hlZF9kaXJzKHN0cnVjdCBjaWZz
X3NiX2luZm8gKmNpZnNfc2IpCit7CisJc3RydWN0IHJiX3Jvb3QgKnJvb3QgPSAmY2lmc19zYi0+
dGxpbmtfdHJlZTsKKwlzdHJ1Y3QgcmJfbm9kZSAqbm9kZTsKKwlzdHJ1Y3QgY2FjaGVkX2ZpZCAq
Y2ZpZDsKKwlzdHJ1Y3QgY2lmc190Y29uICp0Y29uOworCXN0cnVjdCB0Y29uX2xpbmsgKnRsaW5r
OworCisJZm9yIChub2RlID0gcmJfZmlyc3Qocm9vdCk7IG5vZGU7IG5vZGUgPSByYl9uZXh0KG5v
ZGUpKSB7CisJCXRsaW5rID0gcmJfZW50cnkobm9kZSwgc3RydWN0IHRjb25fbGluaywgdGxfcmJu
b2RlKTsKKwkJdGNvbiA9IHRsaW5rX3Rjb24odGxpbmspOworCQlpZiAoSVNfRVJSKHRjb24pKQor
CQkJY29udGludWU7CisJCWNmaWQgPSAmdGNvbi0+Y2ZpZDsKKwkJbXV0ZXhfbG9jaygmY2ZpZC0+
ZmlkX211dGV4KTsKKwkJaWYgKGNmaWQtPmRlbnRyeSkgeworCQkJZHB1dChjZmlkLT5kZW50cnkp
OworCQkJY2ZpZC0+ZGVudHJ5ID0gTlVMTDsKKwkJfQorCQltdXRleF91bmxvY2soJmNmaWQtPmZp
ZF9tdXRleCk7CisJfQorfQorCisvKgorICogSW52YWxpZGF0ZSBhbmQgY2xvc2UgYWxsIGNhY2hl
ZCBkaXJzIHdoZW4gYSBUQ09OIGhhcyBiZWVuIHJlc2V0CisgKiBkdWUgdG8gYSBzZXNzaW9uIGxv
c3MuCisgKi8KK3ZvaWQgaW52YWxpZGF0ZV9hbGxfY2FjaGVkX2RpcnMoc3RydWN0IGNpZnNfdGNv
biAqdGNvbikKK3sKKwltdXRleF9sb2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRleCk7CisJdGNvbi0+
Y2ZpZC5pc192YWxpZCA9IGZhbHNlOworCS8qIGNhY2hlZCBoYW5kbGUgaXMgbm90IHZhbGlkLCBz
byBTTUIyX0NMT1NFIHdvbid0IGJlIHNlbnQgYmVsb3cgKi8KKwljbG9zZV9jYWNoZWRfZGlyX2xl
YXNlX2xvY2tlZCgmdGNvbi0+Y2ZpZCk7CisJbWVtc2V0KHRjb24tPmNmaWQuZmlkLCAwLCBzaXpl
b2Yoc3RydWN0IGNpZnNfZmlkKSk7CisJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jZmlkLmZpZF9tdXRl
eCk7Cit9CisKK3N0YXRpYyB2b2lkCitzbWIyX2NhY2hlZF9sZWFzZV9icmVhayhzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IGNhY2hlZF9maWQgKmNmaWQgPSBjb250YWluZXJf
b2Yod29yaywKKwkJCQlzdHJ1Y3QgY2FjaGVkX2ZpZCwgbGVhc2VfYnJlYWspOworCisJY2xvc2Vf
Y2FjaGVkX2Rpcl9sZWFzZShjZmlkKTsKK30KKworaW50IGNhY2hlZF9kaXJfbGVhc2VfYnJlYWso
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgX191OCBsZWFzZV9rZXlbMTZdKQoreworCWlmICh0Y29u
LT5jZmlkLmlzX3ZhbGlkICYmCisJICAgICFtZW1jbXAobGVhc2Vfa2V5LAorCQkgICAgdGNvbi0+
Y2ZpZC5maWQtPmxlYXNlX2tleSwKKwkJICAgIFNNQjJfTEVBU0VfS0VZX1NJWkUpKSB7CisJCXRj
b24tPmNmaWQudGltZSA9IDA7CisJCUlOSVRfV09SSygmdGNvbi0+Y2ZpZC5sZWFzZV9icmVhaywK
KwkJCSAgc21iMl9jYWNoZWRfbGVhc2VfYnJlYWspOworCQlxdWV1ZV93b3JrKGNpZnNpb2Rfd3Es
CisJCQkgICAmdGNvbi0+Y2ZpZC5sZWFzZV9icmVhayk7CisJCXJldHVybiB0cnVlOworCX0KKwly
ZXR1cm4gZmFsc2U7Cit9CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NhY2hlZF9kaXIuaCBiL2ZzL2Np
ZnMvY2FjaGVkX2Rpci5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4u
NTFjNmI5NjhmOGI2Ci0tLSAvZGV2L251bGwKKysrIGIvZnMvY2lmcy9jYWNoZWRfZGlyLmgKQEAg
LTAsMCArMSwyNiBAQAorLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8KKy8q
CisgKiAgRnVuY3Rpb25zIHRvIGhhbmRsZSB0aGUgY2FjaGVkIGRpcmVjdG9yeSBlbnRyaWVzCisg
KgorICogIENvcHlyaWdodCAoYykgMjAyMiwgUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRo
YXQuY29tPgorICovCisKKyNpZm5kZWYgX0NBQ0hFRF9ESVJfSAorI2RlZmluZSBfQ0FDSEVEX0RJ
Ul9ICisKKworZXh0ZXJuIGludCBvcGVuX2NhY2hlZF9kaXIodW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKKwkJCSAgIGNvbnN0IGNoYXIgKnBhdGgsCisJCQkgICBzdHJ1
Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAorCQkJICAgc3RydWN0IGNhY2hlZF9maWQgKipjZmlk
KTsKK2V4dGVybiBpbnQgb3Blbl9jYWNoZWRfZGlyX2J5X2RlbnRyeShzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAorCQkJCSAgICAgc3RydWN0IGRlbnRyeSAqZGVudHJ5LAorCQkJCSAgICAgc3RydWN0
IGNhY2hlZF9maWQgKipjZmlkKTsKK2V4dGVybiB2b2lkIGNsb3NlX2NhY2hlZF9kaXIoc3RydWN0
IGNhY2hlZF9maWQgKmNmaWQpOworZXh0ZXJuIHZvaWQgY2xvc2VfY2FjaGVkX2Rpcl9sZWFzZShz
dHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCk7CitleHRlcm4gdm9pZCBjbG9zZV9jYWNoZWRfZGlyX2xl
YXNlX2xvY2tlZChzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCk7CitleHRlcm4gdm9pZCBjbG9zZV9h
bGxfY2FjaGVkX2RpcnMoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYik7CitleHRlcm4gdm9p
ZCBpbnZhbGlkYXRlX2FsbF9jYWNoZWRfZGlycyhzdHJ1Y3QgY2lmc190Y29uICp0Y29uKTsKK2V4
dGVybiBpbnQgY2FjaGVkX2Rpcl9sZWFzZV9icmVhayhzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBf
X3U4IGxlYXNlX2tleVsxNl0pOworCisjZW5kaWYJCQkvKiBfQ0FDSEVEX0RJUl9IICovCmRpZmYg
LS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCA4ODQ5ZjA4
NTIxMTAuLjk0NWZiMDgzY2VhNyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9m
cy9jaWZzL2NpZnNmcy5jCkBAIC00Niw2ICs0Niw3IEBACiAjaW5jbHVkZSAibmV0bGluay5oIgog
I2VuZGlmCiAjaW5jbHVkZSAiZnNfY29udGV4dC5oIgorI2luY2x1ZGUgImNhY2hlZF9kaXIuaCIK
IAogLyoKICAqIERPUyBkYXRlcyBmcm9tIDE5ODAvMS8xIHRocm91Z2ggMjEwNy8xMi8zMQpAQCAt
MjgzLDMwICsyODQsMTMgQEAgY2lmc19yZWFkX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2Ip
CiBzdGF0aWMgdm9pZCBjaWZzX2tpbGxfc2Ioc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIHsKIAlz
dHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiID0gQ0lGU19TQihzYik7Ci0Jc3RydWN0IGNpZnNf
dGNvbiAqdGNvbjsKLQlzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZDsKLQlzdHJ1Y3QgcmJfcm9vdCAq
cm9vdCA9ICZjaWZzX3NiLT50bGlua190cmVlOwotCXN0cnVjdCByYl9ub2RlICpub2RlOwotCXN0
cnVjdCB0Y29uX2xpbmsgKnRsaW5rOwogCiAJLyoKIAkgKiBXZSBuZWQgdG8gcmVsZWFzZSBhbGwg
ZGVudHJpZXMgZm9yIHRoZSBjYWNoZWQgZGlyZWN0b3JpZXMKIAkgKiBiZWZvcmUgd2Uga2lsbCB0
aGUgc2IuCiAJICovCiAJaWYgKGNpZnNfc2ItPnJvb3QpIHsKLQkJZm9yIChub2RlID0gcmJfZmly
c3Qocm9vdCk7IG5vZGU7IG5vZGUgPSByYl9uZXh0KG5vZGUpKSB7Ci0JCQl0bGluayA9IHJiX2Vu
dHJ5KG5vZGUsIHN0cnVjdCB0Y29uX2xpbmssIHRsX3Jibm9kZSk7Ci0JCQl0Y29uID0gdGxpbmtf
dGNvbih0bGluayk7Ci0JCQlpZiAoSVNfRVJSKHRjb24pKQotCQkJCWNvbnRpbnVlOwotCQkJY2Zp
ZCA9ICZ0Y29uLT5jcmZpZDsKLQkJCW11dGV4X2xvY2soJmNmaWQtPmZpZF9tdXRleCk7Ci0JCQlp
ZiAoY2ZpZC0+ZGVudHJ5KSB7Ci0JCQkJZHB1dChjZmlkLT5kZW50cnkpOwotCQkJCWNmaWQtPmRl
bnRyeSA9IE5VTEw7Ci0JCQl9Ci0JCQltdXRleF91bmxvY2soJmNmaWQtPmZpZF9tdXRleCk7Ci0J
CX0KKwkJY2xvc2VfYWxsX2NhY2hlZF9kaXJzKGNpZnNfc2IpOwogCiAJCS8qIGZpbmFsbHkgcmVs
ZWFzZSByb290IGRlbnRyeSAqLwogCQlkcHV0KGNpZnNfc2ItPnJvb3QpOwpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IGE5MzAyNGVhZjI1
MS4uOGI4MmYxM2QxMWUwIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMv
Y2lmcy9jaWZzZ2xvYi5oCkBAIC0xMjU3LDcgKzEyNTcsNyBAQCBzdHJ1Y3QgY2lmc190Y29uIHsK
IAlzdHJ1Y3QgZnNjYWNoZV92b2x1bWUgKmZzY2FjaGU7CS8qIGNvb2tpZSBmb3Igc2hhcmUgKi8K
ICNlbmRpZgogCXN0cnVjdCBsaXN0X2hlYWQgcGVuZGluZ19vcGVuczsJLyogbGlzdCBvZiBpbmNv
bXBsZXRlIG9wZW5zICovCi0Jc3RydWN0IGNhY2hlZF9maWQgY3JmaWQ7IC8qIENhY2hlZCByb290
IGZpZCAqLworCXN0cnVjdCBjYWNoZWRfZmlkIGNmaWQ7IC8qIENhY2hlZCByb290IGZpZCAqLwog
CS8qIEJCIGFkZCBmaWVsZCBmb3IgYmFjayBwb2ludGVyIHRvIHNiIHN0cnVjdChzKT8gKi8KICNp
ZmRlZiBDT05GSUdfQ0lGU19ERlNfVVBDQUxMCiAJc3RydWN0IGxpc3RfaGVhZCB1bGlzdDsgLyog
Y2FjaGUgdXBkYXRlIGxpc3QgKi8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmggYi9m
cy9jaWZzL2NpZnNwcm90by5oCmluZGV4IGRhYWFkZmZhMmI4OC4uODdhNzdhNjg0MzM5IDEwMDY0
NAotLS0gYS9mcy9jaWZzL2NpZnNwcm90by5oCisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKQEAg
LTU5Nyw3ICs1OTcsNiBAQCBlbnVtIHNlY3VyaXR5RW51bSBjaWZzX3NlbGVjdF9zZWN0eXBlKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKiwKIHN0cnVjdCBjaWZzX2Fpb19jdHggKmNpZnNfYWlvX2N0
eF9hbGxvYyh2b2lkKTsKIHZvaWQgY2lmc19haW9fY3R4X3JlbGVhc2Uoc3RydWN0IGtyZWYgKnJl
ZmNvdW50KTsKIGludCBzZXR1cF9haW9fY3R4X2l0ZXIoc3RydWN0IGNpZnNfYWlvX2N0eCAqY3R4
LCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIsIGludCBydyk7Ci12b2lkIHNtYjJfY2FjaGVkX2xlYXNl
X2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CiAKIGludCBjaWZzX2FsbG9jX2hhc2go
Y29uc3QgY2hhciAqbmFtZSwgc3RydWN0IGNyeXB0b19zaGFzaCAqKnNoYXNoLAogCQkgICAgc3Ry
dWN0IHNkZXNjICoqc2Rlc2MpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZz
L2ZpbGUuYwppbmRleCAwOTk3NWJkN2Q4NjAuLjQyZjI2MzlhMWE2NiAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTM0LDYgKzM0LDcgQEAKICNpbmNs
dWRlICJzbWJkaXJlY3QuaCIKICNpbmNsdWRlICJmc19jb250ZXh0LmgiCiAjaW5jbHVkZSAiY2lm
c19pb2N0bC5oIgorI2luY2x1ZGUgImNhY2hlZF9kaXIuaCIKIAogLyoKICAqIE1hcmsgYXMgaW52
YWxpZCwgYWxsIG9wZW4gZmlsZXMgb24gdHJlZSBjb25uZWN0aW9ucyBzaW5jZSB0aGV5CkBAIC02
NCwxMyArNjUsNyBAQCBjaWZzX21hcmtfb3Blbl9maWxlc19pbnZhbGlkKHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24pCiAJfQogCXNwaW5fdW5sb2NrKCZ0Y29uLT5vcGVuX2ZpbGVfbG9jayk7CiAKLQlt
dXRleF9sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwotCXRjb24tPmNyZmlkLmlzX3ZhbGlk
ID0gZmFsc2U7Ci0JLyogY2FjaGVkIGhhbmRsZSBpcyBub3QgdmFsaWQsIHNvIFNNQjJfQ0xPU0Ug
d29uJ3QgYmUgc2VudCBiZWxvdyAqLwotCWNsb3NlX2NhY2hlZF9kaXJfbGVhc2VfbG9ja2VkKCZ0
Y29uLT5jcmZpZCk7Ci0JbWVtc2V0KHRjb24tPmNyZmlkLmZpZCwgMCwgc2l6ZW9mKHN0cnVjdCBj
aWZzX2ZpZCkpOwotCW11dGV4X3VubG9jaygmdGNvbi0+Y3JmaWQuZmlkX211dGV4KTsKLQorCWlu
dmFsaWRhdGVfYWxsX2NhY2hlZF9kaXJzKHRjb24pOwogCXNwaW5fbG9jaygmdGNvbi0+dGNfbG9j
ayk7CiAJaWYgKHRjb24tPnN0YXR1cyA9PSBUSURfSU5fRklMRVNfSU5WQUxJREFURSkKIAkJdGNv
bi0+c3RhdHVzID0gVElEX05FRURfVENPTjsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBi
L2ZzL2NpZnMvaW5vZGUuYwppbmRleCBlZWVhYmEzZGVjMDUuLmJhYzA4YzIwZjU1OSAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjUsNiArMjUs
NyBAQAogI2luY2x1ZGUgImZzY2FjaGUuaCIKICNpbmNsdWRlICJmc19jb250ZXh0LmgiCiAjaW5j
bHVkZSAiY2lmc19pb2N0bC5oIgorI2luY2x1ZGUgImNhY2hlZF9kaXIuaCIKIAogc3RhdGljIHZv
aWQgY2lmc19zZXRfb3BzKHN0cnVjdCBpbm9kZSAqaW5vZGUpCiB7CmRpZmYgLS1naXQgYS9mcy9j
aWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IDdhOTA2MDY3ZGIwNC4uZWEwNDA1Y2Zh
ZWUzIDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAt
MTE2LDEzICsxMTYsMTMgQEAgdGNvbkluZm9BbGxvYyh2b2lkKQogCXJldF9idWYgPSBremFsbG9j
KHNpemVvZigqcmV0X2J1ZiksIEdGUF9LRVJORUwpOwogCWlmICghcmV0X2J1ZikKIAkJcmV0dXJu
IE5VTEw7Ci0JcmV0X2J1Zi0+Y3JmaWQuZmlkID0ga3phbGxvYyhzaXplb2YoKnJldF9idWYtPmNy
ZmlkLmZpZCksIEdGUF9LRVJORUwpOwotCWlmICghcmV0X2J1Zi0+Y3JmaWQuZmlkKSB7CisJcmV0
X2J1Zi0+Y2ZpZC5maWQgPSBremFsbG9jKHNpemVvZigqcmV0X2J1Zi0+Y2ZpZC5maWQpLCBHRlBf
S0VSTkVMKTsKKwlpZiAoIXJldF9idWYtPmNmaWQuZmlkKSB7CiAJCWtmcmVlKHJldF9idWYpOwog
CQlyZXR1cm4gTlVMTDsKIAl9Ci0JSU5JVF9MSVNUX0hFQUQoJnJldF9idWYtPmNyZmlkLmRpcmVu
dHMuZW50cmllcyk7Ci0JbXV0ZXhfaW5pdCgmcmV0X2J1Zi0+Y3JmaWQuZGlyZW50cy5kZV9tdXRl
eCk7CisJSU5JVF9MSVNUX0hFQUQoJnJldF9idWYtPmNmaWQuZGlyZW50cy5lbnRyaWVzKTsKKwlt
dXRleF9pbml0KCZyZXRfYnVmLT5jZmlkLmRpcmVudHMuZGVfbXV0ZXgpOwogCiAJYXRvbWljX2lu
YygmdGNvbkluZm9BbGxvY0NvdW50KTsKIAlyZXRfYnVmLT5zdGF0dXMgPSBUSURfTkVXOwpAQCAt
MTMxLDcgKzEzMSw3IEBAIHRjb25JbmZvQWxsb2Modm9pZCkKIAlJTklUX0xJU1RfSEVBRCgmcmV0
X2J1Zi0+b3BlbkZpbGVMaXN0KTsKIAlJTklUX0xJU1RfSEVBRCgmcmV0X2J1Zi0+dGNvbl9saXN0
KTsKIAlzcGluX2xvY2tfaW5pdCgmcmV0X2J1Zi0+b3Blbl9maWxlX2xvY2spOwotCW11dGV4X2lu
aXQoJnJldF9idWYtPmNyZmlkLmZpZF9tdXRleCk7CisJbXV0ZXhfaW5pdCgmcmV0X2J1Zi0+Y2Zp
ZC5maWRfbXV0ZXgpOwogCXNwaW5fbG9ja19pbml0KCZyZXRfYnVmLT5zdGF0X2xvY2spOwogCWF0
b21pY19zZXQoJnJldF9idWYtPm51bV9sb2NhbF9vcGVucywgMCk7CiAJYXRvbWljX3NldCgmcmV0
X2J1Zi0+bnVtX3JlbW90ZV9vcGVucywgMCk7CkBAIC0xNDksNyArMTQ5LDcgQEAgdGNvbkluZm9G
cmVlKHN0cnVjdCBjaWZzX3Rjb24gKmJ1Zl90b19mcmVlKQogCWF0b21pY19kZWMoJnRjb25JbmZv
QWxsb2NDb3VudCk7CiAJa2ZyZWUoYnVmX3RvX2ZyZWUtPm5hdGl2ZUZpbGVTeXN0ZW0pOwogCWtm
cmVlX3NlbnNpdGl2ZShidWZfdG9fZnJlZS0+cGFzc3dvcmQpOwotCWtmcmVlKGJ1Zl90b19mcmVl
LT5jcmZpZC5maWQpOworCWtmcmVlKGJ1Zl90b19mcmVlLT5jZmlkLmZpZCk7CiAJa2ZyZWUoYnVm
X3RvX2ZyZWUpOwogfQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3JlYWRkaXIuYyBiL2ZzL2NpZnMv
cmVhZGRpci5jCmluZGV4IDM4NGNhYmRmNDdjYS4uYTA2MDcyYWU2YzdlIDEwMDY0NAotLS0gYS9m
cy9jaWZzL3JlYWRkaXIuYworKysgYi9mcy9jaWZzL3JlYWRkaXIuYwpAQCAtMjEsNiArMjEsNyBA
QAogI2luY2x1ZGUgImNpZnNmcy5oIgogI2luY2x1ZGUgInNtYjJwcm90by5oIgogI2luY2x1ZGUg
ImZzX2NvbnRleHQuaCIKKyNpbmNsdWRlICJjYWNoZWRfZGlyLmgiCiAKIC8qCiAgKiBUbyBiZSBz
YWZlIC0gZm9yIFVDUyB0byBVVEYtOCB3aXRoIHN0cmluZ3MgbG9hZGVkIHdpdGggdGhlIHJhcmUg
bG9uZwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyaW5vZGUuYyBiL2ZzL2NpZnMvc21iMmlub2Rl
LmMKaW5kZXggODU3MWE0NTljNzEwLi5mNmY5ZmMzZjJlMmQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMmlub2RlLmMKKysrIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwpAQCAtMjMsNiArMjMsNyBAQAog
I2luY2x1ZGUgInNtYjJnbG9iLmgiCiAjaW5jbHVkZSAic21iMnBkdS5oIgogI2luY2x1ZGUgInNt
YjJwcm90by5oIgorI2luY2x1ZGUgImNhY2hlZF9kaXIuaCIKIAogc3RhdGljIHZvaWQKIGZyZWVf
c2V0X2luZl9jb21wb3VuZChzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpCkBAIC01MTgsOSArNTE5LDkg
QEAgc21iMl9xdWVyeV9wYXRoX2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJcmMgPSBvcGVuX2NhY2hlZF9kaXIoeGlkLCB0Y29uLCBmdWxsX3Bh
dGgsIGNpZnNfc2IsICZjZmlkKTsKIAkvKiBJZiBpdCBpcyBhIHJvb3QgYW5kIGl0cyBoYW5kbGUg
aXMgY2FjaGVkIHRoZW4gdXNlIGl0ICovCiAJaWYgKCFyYykgewotCQlpZiAodGNvbi0+Y3JmaWQu
ZmlsZV9hbGxfaW5mb19pc192YWxpZCkgeworCQlpZiAodGNvbi0+Y2ZpZC5maWxlX2FsbF9pbmZv
X2lzX3ZhbGlkKSB7CiAJCQltb3ZlX3NtYjJfaW5mb190b19jaWZzKGRhdGEsCi0JCQkJCSAgICAg
ICAmdGNvbi0+Y3JmaWQuZmlsZV9hbGxfaW5mbyk7CisJCQkJCSAgICAgICAmdGNvbi0+Y2ZpZC5m
aWxlX2FsbF9pbmZvKTsKIAkJfSBlbHNlIHsKIAkJCXJjID0gU01CMl9xdWVyeV9pbmZvKHhpZCwg
dGNvbiwKIAkJCQkJICAgICBjZmlkLT5maWQtPnBlcnNpc3RlbnRfZmlkLApkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9zbWIybWlzYy5jIGIvZnMvY2lmcy9zbWIybWlzYy5jCmluZGV4IDgxOGNjNGRlZTBl
Mi4uNmE2ZWM2ZWZiNDVhIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJtaXNjLmMKKysrIGIvZnMv
Y2lmcy9zbWIybWlzYy5jCkBAIC0xNiw2ICsxNiw3IEBACiAjaW5jbHVkZSAic21iMnN0YXR1cy5o
IgogI2luY2x1ZGUgInNtYjJnbG9iLmgiCiAjaW5jbHVkZSAibnRlcnIuaCIKKyNpbmNsdWRlICJj
YWNoZWRfZGlyLmgiCiAKIHN0YXRpYyBpbnQKIGNoZWNrX3NtYjJfaGRyKHN0cnVjdCBzbWIyX2hk
ciAqc2hkciwgX191NjQgbWlkKQpAQCAtNjQ4LDE1ICs2NDksNyBAQCBzbWIyX2lzX3ZhbGlkX2xl
YXNlX2JyZWFrKGNoYXIgKmJ1ZmZlcikKIAkJCQl9CiAJCQkJc3Bpbl91bmxvY2soJnRjb24tPm9w
ZW5fZmlsZV9sb2NrKTsKIAotCQkJCWlmICh0Y29uLT5jcmZpZC5pc192YWxpZCAmJgotCQkJCSAg
ICAhbWVtY21wKHJzcC0+TGVhc2VLZXksCi0JCQkJCSAgICB0Y29uLT5jcmZpZC5maWQtPmxlYXNl
X2tleSwKLQkJCQkJICAgIFNNQjJfTEVBU0VfS0VZX1NJWkUpKSB7Ci0JCQkJCXRjb24tPmNyZmlk
LnRpbWUgPSAwOwotCQkJCQlJTklUX1dPUksoJnRjb24tPmNyZmlkLmxlYXNlX2JyZWFrLAotCQkJ
CQkJICBzbWIyX2NhY2hlZF9sZWFzZV9icmVhayk7Ci0JCQkJCXF1ZXVlX3dvcmsoY2lmc2lvZF93
cSwKLQkJCQkJCSAgICZ0Y29uLT5jcmZpZC5sZWFzZV9icmVhayk7CisJCQkJaWYgKGNhY2hlZF9k
aXJfbGVhc2VfYnJlYWsodGNvbiwgcnNwLT5MZWFzZUtleSkpIHsKIAkJCQkJc3Bpbl91bmxvY2so
JmNpZnNfdGNwX3Nlc19sb2NrKTsKIAkJCQkJcmV0dXJuIHRydWU7CiAJCQkJfQpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBjMDAzOWRjMDcx
NWEuLjhjYjFlZWQxZGQ2MyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMv
Y2lmcy9zbWIyb3BzLmMKQEAgLTI3LDYgKzI3LDcgQEAKICNpbmNsdWRlICJzbWJkaXJlY3QuaCIK
ICNpbmNsdWRlICJmc2NhY2hlLmgiCiAjaW5jbHVkZSAiZnNfY29udGV4dC5oIgorI2luY2x1ZGUg
ImNhY2hlZF9kaXIuaCIKIAogLyogQ2hhbmdlIGNyZWRpdHMgZm9yIGRpZmZlcmVudCBvcHMgYW5k
IHJldHVybiB0aGUgdG90YWwgbnVtYmVyIG9mIGNyZWRpdHMgKi8KIHN0YXRpYyBpbnQKQEAgLTcw
MSwzMDAgKzcwMiw2IEBAIFNNQjNfcmVxdWVzdF9pbnRlcmZhY2VzKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiAJcmV0dXJuIHJjOwogfQogCi1zdGF0aWMg
dm9pZAotc21iMl9jbG9zZV9jYWNoZWRfZmlkKHN0cnVjdCBrcmVmICpyZWYpCi17Ci0Jc3RydWN0
IGNhY2hlZF9maWQgKmNmaWQgPSBjb250YWluZXJfb2YocmVmLCBzdHJ1Y3QgY2FjaGVkX2ZpZCwK
LQkJCQkJICAgICAgIHJlZmNvdW50KTsKLQlzdHJ1Y3QgY2FjaGVkX2RpcmVudCAqZGlyZW50LCAq
cTsKLQotCWlmIChjZmlkLT5pc192YWxpZCkgewotCQljaWZzX2RiZyhGWUksICJjbGVhciBjYWNo
ZWQgcm9vdCBmaWxlIGhhbmRsZVxuIik7Ci0JCVNNQjJfY2xvc2UoMCwgY2ZpZC0+dGNvbiwgY2Zp
ZC0+ZmlkLT5wZXJzaXN0ZW50X2ZpZCwKLQkJCSAgIGNmaWQtPmZpZC0+dm9sYXRpbGVfZmlkKTsK
LQl9Ci0KLQkvKgotCSAqIFdlIG9ubHkgY2hlY2sgdmFsaWRpdHkgYWJvdmUgdG8gc2VuZCBTTUIy
X2Nsb3NlLAotCSAqIGJ1dCB3ZSBzdGlsbCBuZWVkIHRvIGludmFsaWRhdGUgdGhlc2UgZW50cmll
cwotCSAqIHdoZW4gdGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQKLQkgKi8KLQljZmlkLT5pc192YWxp
ZCA9IGZhbHNlOwotCWNmaWQtPmZpbGVfYWxsX2luZm9faXNfdmFsaWQgPSBmYWxzZTsKLQljZmlk
LT5oYXNfbGVhc2UgPSBmYWxzZTsKLQlpZiAoY2ZpZC0+ZGVudHJ5KSB7Ci0JCWRwdXQoY2ZpZC0+
ZGVudHJ5KTsKLQkJY2ZpZC0+ZGVudHJ5ID0gTlVMTDsKLQl9Ci0JLyoKLQkgKiBEZWxldGUgYWxs
IGNhY2hlZCBkaXJlbnQgbmFtZXMKLQkgKi8KLQltdXRleF9sb2NrKCZjZmlkLT5kaXJlbnRzLmRl
X211dGV4KTsKLQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoZGlyZW50LCBxLCAmY2ZpZC0+ZGly
ZW50cy5lbnRyaWVzLCBlbnRyeSkgewotCQlsaXN0X2RlbCgmZGlyZW50LT5lbnRyeSk7Ci0JCWtm
cmVlKGRpcmVudC0+bmFtZSk7Ci0JCWtmcmVlKGRpcmVudCk7Ci0JfQotCWNmaWQtPmRpcmVudHMu
aXNfdmFsaWQgPSAwOwotCWNmaWQtPmRpcmVudHMuaXNfZmFpbGVkID0gMDsKLQljZmlkLT5kaXJl
bnRzLmN0eCA9IE5VTEw7Ci0JY2ZpZC0+ZGlyZW50cy5wb3MgPSAwOwotCW11dGV4X3VubG9jaygm
Y2ZpZC0+ZGlyZW50cy5kZV9tdXRleCk7Ci0KLX0KLQotdm9pZCBjbG9zZV9jYWNoZWRfZGlyKHN0
cnVjdCBjYWNoZWRfZmlkICpjZmlkKQotewotCW11dGV4X2xvY2soJmNmaWQtPmZpZF9tdXRleCk7
Ci0Ja3JlZl9wdXQoJmNmaWQtPnJlZmNvdW50LCBzbWIyX2Nsb3NlX2NhY2hlZF9maWQpOwotCW11
dGV4X3VubG9jaygmY2ZpZC0+ZmlkX211dGV4KTsKLX0KLQotdm9pZCBjbG9zZV9jYWNoZWRfZGly
X2xlYXNlX2xvY2tlZChzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCkKLXsKLQlpZiAoY2ZpZC0+aGFz
X2xlYXNlKSB7Ci0JCWNmaWQtPmhhc19sZWFzZSA9IGZhbHNlOwotCQlrcmVmX3B1dCgmY2ZpZC0+
cmVmY291bnQsIHNtYjJfY2xvc2VfY2FjaGVkX2ZpZCk7Ci0JfQotfQotCi12b2lkIGNsb3NlX2Nh
Y2hlZF9kaXJfbGVhc2Uoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpCi17Ci0JbXV0ZXhfbG9jaygm
Y2ZpZC0+ZmlkX211dGV4KTsKLQljbG9zZV9jYWNoZWRfZGlyX2xlYXNlX2xvY2tlZChjZmlkKTsK
LQltdXRleF91bmxvY2soJmNmaWQtPmZpZF9tdXRleCk7Ci19Ci0KLXZvaWQKLXNtYjJfY2FjaGVk
X2xlYXNlX2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKLXsKLQlzdHJ1Y3QgY2FjaGVk
X2ZpZCAqY2ZpZCA9IGNvbnRhaW5lcl9vZih3b3JrLAotCQkJCXN0cnVjdCBjYWNoZWRfZmlkLCBs
ZWFzZV9icmVhayk7Ci0KLQljbG9zZV9jYWNoZWRfZGlyX2xlYXNlKGNmaWQpOwotfQotCi0vKgot
ICogT3BlbiB0aGUgYW5kIGNhY2hlIGEgZGlyZWN0b3J5IGhhbmRsZS4KLSAqIE9ubHkgc3VwcG9y
dGVkIGZvciB0aGUgcm9vdCBoYW5kbGUuCi0gKiBJZiBlcnJvciB0aGVuICpjZmlkIGlzIG5vdCBp
bml0aWFsaXplZC4KLSAqLwotaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAotCQljb25zdCBjaGFyICpwYXRoLAotCQlzdHJ1Y3QgY2lm
c19zYl9pbmZvICpjaWZzX3NiLAotCQlzdHJ1Y3QgY2FjaGVkX2ZpZCAqKmNmaWQpCi17Ci0Jc3Ry
dWN0IGNpZnNfc2VzICpzZXM7Ci0Jc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyOwotCXN0
cnVjdCBjaWZzX29wZW5fcGFybXMgb3Bhcm1zOwotCXN0cnVjdCBzbWIyX2NyZWF0ZV9yc3AgKm9f
cnNwID0gTlVMTDsKLQlzdHJ1Y3Qgc21iMl9xdWVyeV9pbmZvX3JzcCAqcWlfcnNwID0gTlVMTDsK
LQlpbnQgcmVzcF9idWZ0eXBlWzJdOwotCXN0cnVjdCBzbWJfcnFzdCBycXN0WzJdOwotCXN0cnVj
dCBrdmVjIHJzcF9pb3ZbMl07Ci0Jc3RydWN0IGt2ZWMgb3Blbl9pb3ZbU01CMl9DUkVBVEVfSU9W
X1NJWkVdOwotCXN0cnVjdCBrdmVjIHFpX2lvdlsxXTsKLQlpbnQgcmMsIGZsYWdzID0gMDsKLQlf
X2xlMTYgdXRmMTZfcGF0aCA9IDA7IC8qIE51bGwgLSBzaW5jZSBhbiBvcGVuIG9mIHRvcCBvZiBz
aGFyZSAqLwotCXU4IG9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX0lJOwotCXN0cnVjdCBjaWZz
X2ZpZCAqcGZpZDsKLQlzdHJ1Y3QgZGVudHJ5ICpkZW50cnk7Ci0KLQlpZiAodGNvbiA9PSBOVUxM
IHx8IHRjb24tPm5vaGFuZGxlY2FjaGUgfHwKLQkgICAgaXNfc21iMV9zZXJ2ZXIodGNvbi0+c2Vz
LT5zZXJ2ZXIpKQotCQlyZXR1cm4gLUVOT1RTVVBQOwotCi0Jc2VzID0gdGNvbi0+c2VzOwotCXNl
cnZlciA9IHNlcy0+c2VydmVyOwotCi0JaWYgKGNpZnNfc2ItPnJvb3QgPT0gTlVMTCkKLQkJcmV0
dXJuIC1FTk9FTlQ7Ci0KLQlpZiAoc3RybGVuKHBhdGgpKQotCQlyZXR1cm4gLUVOT0VOVDsKLQot
CWRlbnRyeSA9IGNpZnNfc2ItPnJvb3Q7Ci0KLQltdXRleF9sb2NrKCZ0Y29uLT5jcmZpZC5maWRf
bXV0ZXgpOwotCWlmICh0Y29uLT5jcmZpZC5pc192YWxpZCkgewotCQljaWZzX2RiZyhGWUksICJm
b3VuZCBhIGNhY2hlZCByb290IGZpbGUgaGFuZGxlXG4iKTsKLQkJKmNmaWQgPSAmdGNvbi0+Y3Jm
aWQ7Ci0JCWtyZWZfZ2V0KCZ0Y29uLT5jcmZpZC5yZWZjb3VudCk7Ci0JCW11dGV4X3VubG9jaygm
dGNvbi0+Y3JmaWQuZmlkX211dGV4KTsKLQkJcmV0dXJuIDA7Ci0JfQotCi0JLyoKLQkgKiBXZSBk
byBub3QgaG9sZCB0aGUgbG9jayBmb3IgdGhlIG9wZW4gYmVjYXVzZSBpbiBjYXNlCi0JICogU01C
Ml9vcGVuIG5lZWRzIHRvIHJlY29ubmVjdCwgaXQgd2lsbCBlbmQgdXAgY2FsbGluZwotCSAqIGNp
ZnNfbWFya19vcGVuX2ZpbGVzX2ludmFsaWQoKSB3aGljaCB0YWtlcyB0aGUgbG9jayBhZ2Fpbgot
CSAqIHRodXMgY2F1c2luZyBhIGRlYWRsb2NrCi0JICovCi0KLQltdXRleF91bmxvY2soJnRjb24t
PmNyZmlkLmZpZF9tdXRleCk7Ci0KLQlpZiAoc21iM19lbmNyeXB0aW9uX3JlcXVpcmVkKHRjb24p
KQotCQlmbGFncyB8PSBDSUZTX1RSQU5TRk9STV9SRVE7Ci0KLQlpZiAoIXNlcnZlci0+b3BzLT5u
ZXdfbGVhc2Vfa2V5KQotCQlyZXR1cm4gLUVJTzsKLQotCXBmaWQgPSB0Y29uLT5jcmZpZC5maWQ7
Ci0Jc2VydmVyLT5vcHMtPm5ld19sZWFzZV9rZXkocGZpZCk7Ci0KLQltZW1zZXQocnFzdCwgMCwg
c2l6ZW9mKHJxc3QpKTsKLQlyZXNwX2J1ZnR5cGVbMF0gPSByZXNwX2J1ZnR5cGVbMV0gPSBDSUZT
X05PX0JVRkZFUjsKLQltZW1zZXQocnNwX2lvdiwgMCwgc2l6ZW9mKHJzcF9pb3YpKTsKLQotCS8q
IE9wZW4gKi8KLQltZW1zZXQoJm9wZW5faW92LCAwLCBzaXplb2Yob3Blbl9pb3YpKTsKLQlycXN0
WzBdLnJxX2lvdiA9IG9wZW5faW92OwotCXJxc3RbMF0ucnFfbnZlYyA9IFNNQjJfQ1JFQVRFX0lP
Vl9TSVpFOwotCi0Jb3Bhcm1zLnRjb24gPSB0Y29uOwotCW9wYXJtcy5jcmVhdGVfb3B0aW9ucyA9
IGNpZnNfY3JlYXRlX29wdGlvbnMoY2lmc19zYiwgQ1JFQVRFX05PVF9GSUxFKTsKLQlvcGFybXMu
ZGVzaXJlZF9hY2Nlc3MgPSBGSUxFX1JFQURfQVRUUklCVVRFUzsKLQlvcGFybXMuZGlzcG9zaXRp
b24gPSBGSUxFX09QRU47Ci0Jb3Bhcm1zLmZpZCA9IHBmaWQ7Ci0Jb3Bhcm1zLnJlY29ubmVjdCA9
IGZhbHNlOwotCi0JcmMgPSBTTUIyX29wZW5faW5pdCh0Y29uLCBzZXJ2ZXIsCi0JCQkgICAgJnJx
c3RbMF0sICZvcGxvY2ssICZvcGFybXMsICZ1dGYxNl9wYXRoKTsKLQlpZiAocmMpCi0JCWdvdG8g
b3Nocl9mcmVlOwotCXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAmcnFzdFswXSk7Ci0KLQlt
ZW1zZXQoJnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lvdikpOwotCXJxc3RbMV0ucnFfaW92ID0gcWlf
aW92OwotCXJxc3RbMV0ucnFfbnZlYyA9IDE7Ci0KLQlyYyA9IFNNQjJfcXVlcnlfaW5mb19pbml0
KHRjb24sIHNlcnZlciwKLQkJCQkgICZycXN0WzFdLCBDT01QT1VORF9GSUQsCi0JCQkJICBDT01Q
T1VORF9GSUQsIEZJTEVfQUxMX0lORk9STUFUSU9OLAotCQkJCSAgU01CMl9PX0lORk9fRklMRSwg
MCwKLQkJCQkgIHNpemVvZihzdHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvKSArCi0JCQkJICBQQVRI
X01BWCAqIDIsIDAsIE5VTEwpOwotCWlmIChyYykKLQkJZ290byBvc2hyX2ZyZWU7Ci0KLQlzbWIy
X3NldF9yZWxhdGVkKCZycXN0WzFdKTsKLQotCXJjID0gY29tcG91bmRfc2VuZF9yZWN2KHhpZCwg
c2VzLCBzZXJ2ZXIsCi0JCQkJZmxhZ3MsIDIsIHJxc3QsCi0JCQkJcmVzcF9idWZ0eXBlLCByc3Bf
aW92KTsKLQltdXRleF9sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwotCi0JLyoKLQkgKiBO
b3cgd2UgbmVlZCB0byBjaGVjayBhZ2FpbiBhcyB0aGUgY2FjaGVkIHJvb3QgbWlnaHQgaGF2ZQot
CSAqIGJlZW4gc3VjY2Vzc2Z1bGx5IHJlLW9wZW5lZCBmcm9tIGEgY29uY3VycmVudCBwcm9jZXNz
Ci0JICovCi0KLQlpZiAodGNvbi0+Y3JmaWQuaXNfdmFsaWQpIHsKLQkJLyogd29yayB3YXMgYWxy
ZWFkeSBkb25lICovCi0KLQkJLyogc3Rhc2ggZmlkcyBmb3IgY2xvc2UoKSBsYXRlciAqLwotCQlz
dHJ1Y3QgY2lmc19maWQgZmlkID0gewotCQkJLnBlcnNpc3RlbnRfZmlkID0gcGZpZC0+cGVyc2lz
dGVudF9maWQsCi0JCQkudm9sYXRpbGVfZmlkID0gcGZpZC0+dm9sYXRpbGVfZmlkLAotCQl9Owot
Ci0JCS8qCi0JCSAqIGNhbGxlciBleHBlY3RzIHRoaXMgZnVuYyB0byBzZXQgdGhlIGZpZCBpbiBj
cmZpZCB0byB2YWxpZAotCQkgKiBjYWNoZWQgcm9vdCwgc28gaW5jcmVtZW50IHRoZSByZWZjb3Vu
dC4KLQkJICovCi0JCWtyZWZfZ2V0KCZ0Y29uLT5jcmZpZC5yZWZjb3VudCk7Ci0KLQkJbXV0ZXhf
dW5sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwotCi0JCWlmIChyYyA9PSAwKSB7Ci0JCQkv
KiBjbG9zZSBleHRyYSBoYW5kbGUgb3V0c2lkZSBvZiBjcml0IHNlYyAqLwotCQkJU01CMl9jbG9z
ZSh4aWQsIHRjb24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxlX2ZpZCk7Ci0JCX0K
LQkJcmMgPSAwOwotCQlnb3RvIG9zaHJfZnJlZTsKLQl9Ci0KLQkvKiBDYWNoZWQgcm9vdCBpcyBz
dGlsbCBpbnZhbGlkLCBjb250aW51ZSBub3JtYWx5ICovCi0KLQlpZiAocmMpIHsKLQkJaWYgKHJj
ID09IC1FUkVNQ0hHKSB7Ci0JCQl0Y29uLT5uZWVkX3JlY29ubmVjdCA9IHRydWU7Ci0JCQlwcl93
YXJuX29uY2UoInNlcnZlciBzaGFyZSAlcyBkZWxldGVkXG4iLAotCQkJCSAgICAgdGNvbi0+dHJl
ZU5hbWUpOwotCQl9Ci0JCWdvdG8gb3Nocl9leGl0OwotCX0KLQotCWF0b21pY19pbmMoJnRjb24t
Pm51bV9yZW1vdGVfb3BlbnMpOwotCi0Jb19yc3AgPSAoc3RydWN0IHNtYjJfY3JlYXRlX3JzcCAq
KXJzcF9pb3ZbMF0uaW92X2Jhc2U7Ci0Jb3Bhcm1zLmZpZC0+cGVyc2lzdGVudF9maWQgPSBvX3Jz
cC0+UGVyc2lzdGVudEZpbGVJZDsKLQlvcGFybXMuZmlkLT52b2xhdGlsZV9maWQgPSBvX3JzcC0+
Vm9sYXRpbGVGaWxlSWQ7Ci0jaWZkZWYgQ09ORklHX0NJRlNfREVCVUcyCi0Jb3Bhcm1zLmZpZC0+
bWlkID0gbGU2NF90b19jcHUob19yc3AtPmhkci5NZXNzYWdlSWQpOwotI2VuZGlmIC8qIENJRlNf
REVCVUcyICovCi0KLQl0Y29uLT5jcmZpZC50Y29uID0gdGNvbjsKLQl0Y29uLT5jcmZpZC5pc192
YWxpZCA9IHRydWU7Ci0JdGNvbi0+Y3JmaWQuZGVudHJ5ID0gZGVudHJ5OwotCWRnZXQoZGVudHJ5
KTsKLQlrcmVmX2luaXQoJnRjb24tPmNyZmlkLnJlZmNvdW50KTsKLQotCS8qIEJCIFRCRCBjaGVj
ayB0byBzZWUgaWYgb3Bsb2NrIGxldmVsIGNoZWNrIGNhbiBiZSByZW1vdmVkIGJlbG93ICovCi0J
aWYgKG9fcnNwLT5PcGxvY2tMZXZlbCA9PSBTTUIyX09QTE9DS19MRVZFTF9MRUFTRSkgewotCQkv
KgotCQkgKiBTZWUgY29tbWl0IDJmOTRhMzEyNWI4Ny4gSW5jcmVtZW50IHRoZSByZWZjb3VudCB3
aGVuIHdlCi0JCSAqIGdldCBhIGxlYXNlIGZvciByb290LCByZWxlYXNlIGl0IGlmIGxlYXNlIGJy
ZWFrIG9jY3VycwotCQkgKi8KLQkJa3JlZl9nZXQoJnRjb24tPmNyZmlkLnJlZmNvdW50KTsKLQkJ
dGNvbi0+Y3JmaWQuaGFzX2xlYXNlID0gdHJ1ZTsKLQkJc21iMl9wYXJzZV9jb250ZXh0cyhzZXJ2
ZXIsIG9fcnNwLAotCQkJCSZvcGFybXMuZmlkLT5lcG9jaCwKLQkJCQkgICAgb3Bhcm1zLmZpZC0+
bGVhc2Vfa2V5LCAmb3Bsb2NrLAotCQkJCSAgICBOVUxMLCBOVUxMKTsKLQl9IGVsc2UKLQkJZ290
byBvc2hyX2V4aXQ7Ci0KLQlxaV9yc3AgPSAoc3RydWN0IHNtYjJfcXVlcnlfaW5mb19yc3AgKily
c3BfaW92WzFdLmlvdl9iYXNlOwotCWlmIChsZTMyX3RvX2NwdShxaV9yc3AtPk91dHB1dEJ1ZmZl
ckxlbmd0aCkgPCBzaXplb2Yoc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbykpCi0JCWdvdG8gb3No
cl9leGl0OwotCWlmICghc21iMl92YWxpZGF0ZV9hbmRfY29weV9pb3YoCi0JCQkJbGUxNl90b19j
cHUocWlfcnNwLT5PdXRwdXRCdWZmZXJPZmZzZXQpLAotCQkJCXNpemVvZihzdHJ1Y3Qgc21iMl9m
aWxlX2FsbF9pbmZvKSwKLQkJCQkmcnNwX2lvdlsxXSwgc2l6ZW9mKHN0cnVjdCBzbWIyX2ZpbGVf
YWxsX2luZm8pLAotCQkJCShjaGFyICopJnRjb24tPmNyZmlkLmZpbGVfYWxsX2luZm8pKQotCQl0
Y29uLT5jcmZpZC5maWxlX2FsbF9pbmZvX2lzX3ZhbGlkID0gdHJ1ZTsKLQl0Y29uLT5jcmZpZC50
aW1lID0gamlmZmllczsKLQotCi1vc2hyX2V4aXQ6Ci0JbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jcmZp
ZC5maWRfbXV0ZXgpOwotb3Nocl9mcmVlOgotCVNNQjJfb3Blbl9mcmVlKCZycXN0WzBdKTsKLQlT
TUIyX3F1ZXJ5X2luZm9fZnJlZSgmcnFzdFsxXSk7Ci0JZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlw
ZVswXSwgcnNwX2lvdlswXS5pb3ZfYmFzZSk7Ci0JZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZVsx
XSwgcnNwX2lvdlsxXS5pb3ZfYmFzZSk7Ci0JaWYgKHJjID09IDApCi0JCSpjZmlkID0gJnRjb24t
PmNyZmlkOwotCXJldHVybiByYzsKLX0KLQotaW50IG9wZW5fY2FjaGVkX2Rpcl9ieV9kZW50cnko
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLQkJCSAgICAgIHN0cnVjdCBkZW50cnkgKmRlbnRyeSwK
LQkJCSAgICAgIHN0cnVjdCBjYWNoZWRfZmlkICoqY2ZpZCkKLXsKLQltdXRleF9sb2NrKCZ0Y29u
LT5jcmZpZC5maWRfbXV0ZXgpOwotCWlmICh0Y29uLT5jcmZpZC5kZW50cnkgPT0gZGVudHJ5KSB7
Ci0JCWNpZnNfZGJnKEZZSSwgImZvdW5kIGEgY2FjaGVkIHJvb3QgZmlsZSBoYW5kbGUgYnkgZGVu
dHJ5XG4iKTsKLQkJKmNmaWQgPSAmdGNvbi0+Y3JmaWQ7Ci0JCWtyZWZfZ2V0KCZ0Y29uLT5jcmZp
ZC5yZWZjb3VudCk7Ci0JCW11dGV4X3VubG9jaygmdGNvbi0+Y3JmaWQuZmlkX211dGV4KTsKLQkJ
cmV0dXJuIDA7Ci0JfQotCW11dGV4X3VubG9jaygmdGNvbi0+Y3JmaWQuZmlkX211dGV4KTsKLQly
ZXR1cm4gLUVOT0VOVDsKLX0KLQogc3RhdGljIHZvaWQKIHNtYjNfcWZzX3Rjb24oY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkgICAgICBzdHJ1Y3QgY2lm
c19zYl9pbmZvICpjaWZzX3NiKQpAQCAtMTA3Nyw3ICs3ODQsNyBAQCBzbWIyX2lzX3BhdGhfYWNj
ZXNzaWJsZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CXN0cnVjdCBjaWZzX29wZW5fcGFybXMgb3Bhcm1zOwogCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CiAK
LQlpZiAoKCpmdWxsX3BhdGggPT0gMCkgJiYgdGNvbi0+Y3JmaWQuaXNfdmFsaWQpCisJaWYgKCgq
ZnVsbF9wYXRoID09IDApICYmIHRjb24tPmNmaWQuaXNfdmFsaWQpCiAJCXJldHVybiAwOwogCiAJ
dXRmMTZfcGF0aCA9IGNpZnNfY29udmVydF9wYXRoX3RvX3V0ZjE2KGZ1bGxfcGF0aCwgY2lmc19z
Yik7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmlu
ZGV4IDU5MGExZDRhYzE0MC4uN2MyMDBiOTM4MjY3IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJw
ZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMzksNiArMzksNyBAQAogI2lmZGVmIENP
TkZJR19DSUZTX0RGU19VUENBTEwKICNpbmNsdWRlICJkZnNfY2FjaGUuaCIKICNlbmRpZgorI2lu
Y2x1ZGUgImNhY2hlZF9kaXIuaCIKIAogLyoKICAqICBUaGUgZm9sbG93aW5nIHRhYmxlIGRlZmlu
ZXMgdGhlIGV4cGVjdGVkICJTdHJ1Y3R1cmVTaXplIiBvZiBTTUIyIHJlcXVlc3RzCkBAIC0xOTc4
LDcgKzE5NzksNyBAQCBTTUIyX3RkaXMoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbikKIAl9CiAJc3Bpbl91bmxvY2soJnNlcy0+Y2hhbl9sb2NrKTsKIAotCWNs
b3NlX2NhY2hlZF9kaXJfbGVhc2UoJnRjb24tPmNyZmlkKTsKKwljbG9zZV9jYWNoZWRfZGlyX2xl
YXNlKCZ0Y29uLT5jZmlkKTsKIAogCXJjID0gc21iMl9wbGFpbl9yZXFfaW5pdChTTUIyX1RSRUVf
RElTQ09OTkVDVCwgdGNvbiwgc2VzLT5zZXJ2ZXIsCiAJCQkJICh2b2lkICoqKSAmcmVxLApkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgKaW5kZXgg
YTY5ZjFlZWQxY2ZlLi41MWM1YmY0YTMzOGEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnByb3Rv
LmgKKysrIGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAtNTQsMTYgKzU0LDYgQEAgZXh0ZXJuIGJv
b2wgc21iMl9pc192YWxpZF9vcGxvY2tfYnJlYWsoY2hhciAqYnVmZmVyLAogZXh0ZXJuIGludCBz
bWIzX2hhbmRsZV9yZWFkX2RhdGEoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJ
CSBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCk7CiAKLWV4dGVybiBpbnQgb3Blbl9jYWNoZWRfZGly
KHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCi0JCQkgICBjb25zdCBj
aGFyICpwYXRoLAotCQkJICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKLQkJCSAgIHN0
cnVjdCBjYWNoZWRfZmlkICoqY2ZpZCk7Ci1leHRlcm4gaW50IG9wZW5fY2FjaGVkX2Rpcl9ieV9k
ZW50cnkoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLQkJCQkgICAgIHN0cnVjdCBkZW50cnkgKmRl
bnRyeSwKLQkJCQkgICAgIHN0cnVjdCBjYWNoZWRfZmlkICoqY2ZpZCk7Ci1leHRlcm4gdm9pZCBj
bG9zZV9jYWNoZWRfZGlyKHN0cnVjdCBjYWNoZWRfZmlkICpjZmlkKTsKLWV4dGVybiB2b2lkIGNs
b3NlX2NhY2hlZF9kaXJfbGVhc2Uoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpOwotZXh0ZXJuIHZv
aWQgY2xvc2VfY2FjaGVkX2Rpcl9sZWFzZV9sb2NrZWQoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQp
OwogZXh0ZXJuIHZvaWQgbW92ZV9zbWIyX2luZm9fdG9fY2lmcyhGSUxFX0FMTF9JTkZPICpkc3Qs
CiAJCQkJICAgc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbyAqc3JjKTsKIGV4dGVybiBpbnQgc21i
Ml9xdWVyeV9yZXBhcnNlX3RhZyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAotLSAKMi4zNC4xCgo=
--000000000000e3334f05e5ee7981--
