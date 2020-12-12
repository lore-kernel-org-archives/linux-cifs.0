Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC98C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 19:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6619822257
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 19:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgLLTnp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 14:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgLLTnp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 14:43:45 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED14C0613CF
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 11:43:04 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id m25so20119282lfc.11
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 11:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUSdNIxD/7OQJK1eZmQhkSeeoDYp2WSnBvdnDwCP+P8=;
        b=fMrSq6mcKEmIdwuEA829+GhnDO8mClDzZ+EDloAzBKeOZq2WV5E8ewT7m6WYz5l6Nl
         rDb2oAoP+aAR5NR08P2iThbNcf+RE9A0MBtIpzKxVZ8bjzOvTrW47G90A8ub6a9JBS7+
         zpUgIDTsVNldm2BjkSWBvc+depki68V5ecDs90JHsCL5L+Tfa/Oj11m42Zd8Z6qTgzZQ
         KMK4hVMIXAbQ7wquQ115OuJgEMjH3P2H3MJcqzN4ti1bNECb8VFkwfPTBAjkhE70PBcS
         iTNIJABhnPtea0u/5RvONLOeXAmVT1B070CWZ3s6iACJd+wr0EJM4NJfpSqnLU8gVWrh
         iWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUSdNIxD/7OQJK1eZmQhkSeeoDYp2WSnBvdnDwCP+P8=;
        b=VWo0dLeWheLU6aTyW9L0T3kOMGimH1FrevlWcr7RKYWgVskm6P3sbHfZLBfxbJejo1
         HcdHO0KVcEinOsFfW5jtdBxxa0IFtZrxTv/TLO1i/jx4vrKI46Yg8dGbK14CAdXlD2a7
         YUgNplQ4A6dB4/6kUlFPrCxbS3z/GLcrmTdCnqYTxOTvyw+9zWlbr3ONbBSZhlPX7CyM
         AN4/hY9GPwFZVLqtQcHyr/JpDsswvKJFrploxypvdcjUTKi6Hs3ty3n2FQVhFtynnBOY
         Xui61BtZOEFVAeXifWxrKNFgGEgzYo3cztvKU0O/FUtn8MLiSGEAtn1yn7p2uw5C/z/x
         /CIQ==
X-Gm-Message-State: AOAM531CkONu+ATczZ59LCc1/KwxJ1q0khZPfm5UqCDvEghFjViMll/J
        Px1NTD0VyIJgVsJ/QMlCw0XYBMw48oRpC0+4fhZMnPFM/eY=
X-Google-Smtp-Source: ABdhPJzlyBCB1P5Dnq6dkcT2pCy0Jjj45tBHWwiDE6n4NGUukGyCrTHixQzC2OYJl/HfGvDSHz0WIky5Hz1+HsJ1i8g=
X-Received: by 2002:a2e:8eda:: with SMTP id e26mr7466055ljl.272.1607802182734;
 Sat, 12 Dec 2020 11:43:02 -0800 (PST)
MIME-Version: 1.0
References: <20201207233646.29823-1-lsahlber@redhat.com> <20201207233646.29823-9-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-9-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Dec 2020 13:42:51 -0600
Message-ID: <CAH2r5muE+_F5jM3uWDTX2G7yRZUya-nZj791OoZpEgf9JRrs-w@mail.gmail.com>
Subject: Re: [PATCH 09/21] cifs: remove [gu]id/backup[gu]id/file_mode/dir_mode
 from cifs_sb
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f8afa705b6499d79"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f8afa705b6499d79
Content-Type: text/plain; charset="UTF-8"

rebased patch on current for-next and tentatively merged into for-next


On Mon, Dec 7, 2020 at 5:38 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We can already access these from cifs_sb->ctx so we no longer need
> a local copy in cifs_sb.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_fs_sb.h |  6 ------
>  fs/cifs/cifsacl.c    |  7 ++++---
>  fs/cifs/cifsfs.c     | 12 ++++++------
>  fs/cifs/connect.c    | 15 +++++----------
>  fs/cifs/file.c       |  5 +++--
>  fs/cifs/inode.c      | 29 +++++++++++++++--------------
>  fs/cifs/misc.c       |  5 +++--
>  fs/cifs/readdir.c    |  9 +++++----
>  8 files changed, 41 insertions(+), 47 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 8ee37c80880a..3f4f1487f714 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -67,12 +67,6 @@ struct cifs_sb_info {
>         unsigned int wsize;
>         unsigned long actimeo; /* attribute cache timeout (jiffies) */
>         atomic_t active;
> -       kuid_t  mnt_uid;
> -       kgid_t  mnt_gid;
> -       kuid_t  mnt_backupuid;
> -       kgid_t  mnt_backupgid;
> -       umode_t mnt_file_mode;
> -       umode_t mnt_dir_mode;
>         unsigned int mnt_cifs_flags;
>         struct delayed_work prune_tlinks;
>         struct rcu_head rcu;
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 23b21e943652..d4e33bba4713 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -32,6 +32,7 @@
>  #include "cifsacl.h"
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
> +#include "fs_context.h"
>
>  /* security id for everyone/world system group */
>  static const struct cifs_sid sid_everyone = {
> @@ -346,8 +347,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>         struct key *sidkey;
>         char *sidstr;
>         const struct cred *saved_cred;
> -       kuid_t fuid = cifs_sb->mnt_uid;
> -       kgid_t fgid = cifs_sb->mnt_gid;
> +       kuid_t fuid = cifs_sb->ctx->linux_uid;
> +       kgid_t fgid = cifs_sb->ctx->linux_gid;
>
>         /*
>          * If we have too many subauthorities, then something is really wrong.
> @@ -448,7 +449,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>
>         /*
>          * Note that we return 0 here unconditionally. If the mapping
> -        * fails then we just fall back to using the mnt_uid/mnt_gid.
> +        * fails then we just fall back to using the ctx->linux_uid/linux_gid.
>          */
>  got_valid_id:
>         rc = 0;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 4f27f77d3053..4ea8c3c3bce1 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -515,14 +515,14 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>         }
>
>         seq_printf(s, ",uid=%u",
> -                  from_kuid_munged(&init_user_ns, cifs_sb->mnt_uid));
> +                  from_kuid_munged(&init_user_ns, cifs_sb->ctx->linux_uid));
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
>                 seq_puts(s, ",forceuid");
>         else
>                 seq_puts(s, ",noforceuid");
>
>         seq_printf(s, ",gid=%u",
> -                  from_kgid_munged(&init_user_ns, cifs_sb->mnt_gid));
> +                  from_kgid_munged(&init_user_ns, cifs_sb->ctx->linux_gid));
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
>                 seq_puts(s, ",forcegid");
>         else
> @@ -532,8 +532,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>
>         if (!tcon->unix_ext)
>                 seq_printf(s, ",file_mode=0%ho,dir_mode=0%ho",
> -                                          cifs_sb->mnt_file_mode,
> -                                          cifs_sb->mnt_dir_mode);
> +                                          cifs_sb->ctx->file_mode,
> +                                          cifs_sb->ctx->dir_mode);
>
>         cifs_show_nls(s, cifs_sb->local_nls);
>
> @@ -606,11 +606,11 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
>                 seq_printf(s, ",backupuid=%u",
>                            from_kuid_munged(&init_user_ns,
> -                                           cifs_sb->mnt_backupuid));
> +                                           cifs_sb->ctx->backupuid));
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
>                 seq_printf(s, ",backupgid=%u",
>                            from_kgid_munged(&init_user_ns,
> -                                           cifs_sb->mnt_backupgid));
> +                                           cifs_sb->ctx->backupgid));
>
>         seq_printf(s, ",rsize=%u", cifs_sb->rsize);
>         seq_printf(s, ",wsize=%u", cifs_sb->wsize);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7fc27fb49789..96c5b66d4b44 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2225,11 +2225,12 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
>         if (new->rsize && new->rsize < old->rsize)
>                 return 0;
>
> -       if (!uid_eq(old->mnt_uid, new->mnt_uid) || !gid_eq(old->mnt_gid, new->mnt_gid))
> +       if (!uid_eq(old->ctx->linux_uid, new->ctx->linux_uid) ||
> +           !gid_eq(old->ctx->linux_gid, new->ctx->linux_gid))
>                 return 0;
>
> -       if (old->mnt_file_mode != new->mnt_file_mode ||
> -           old->mnt_dir_mode != new->mnt_dir_mode)
> +       if (old->ctx->file_mode != new->ctx->file_mode ||
> +           old->ctx->dir_mode != new->ctx->dir_mode)
>                 return 0;
>
>         if (strcmp(old->local_nls->charset, new->local_nls->charset))
> @@ -2678,12 +2679,8 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
>         cifs_sb->rsize = ctx->rsize;
>         cifs_sb->wsize = ctx->wsize;
>
> -       cifs_sb->mnt_uid = ctx->linux_uid;
> -       cifs_sb->mnt_gid = ctx->linux_gid;
> -       cifs_sb->mnt_file_mode = ctx->file_mode;
> -       cifs_sb->mnt_dir_mode = ctx->dir_mode;
>         cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
> -                cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
> +                cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
>
>         cifs_sb->actimeo = ctx->actimeo;
>         cifs_sb->local_nls = ctx->local_nls;
> @@ -2722,11 +2719,9 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
>         if (ctx->backupuid_specified) {
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
> -               cifs_sb->mnt_backupuid = ctx->backupuid;
>         }
>         if (ctx->backupgid_specified) {
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
> -               cifs_sb->mnt_backupgid = ctx->backupgid;
>         }
>         if (ctx->override_uid)
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index be46fab4c96d..3ee510d3dab8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -44,6 +44,7 @@
>  #include "cifs_fs_sb.h"
>  #include "fscache.h"
>  #include "smbdirect.h"
> +#include "fs_context.h"
>
>  static inline int cifs_convert_flags(unsigned int flags)
>  {
> @@ -566,7 +567,7 @@ int cifs_open(struct inode *inode, struct file *file)
>                                 le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>                 /* can not refresh inode info since size could be stale */
>                 rc = cifs_posix_open(full_path, &inode, inode->i_sb,
> -                               cifs_sb->mnt_file_mode /* ignored */,
> +                               cifs_sb->ctx->file_mode /* ignored */,
>                                 file->f_flags, &oplock, &fid.netfid, xid);
>                 if (rc == 0) {
>                         cifs_dbg(FYI, "posix open succeeded\n");
> @@ -735,7 +736,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>                                                 ~(O_CREAT | O_EXCL | O_TRUNC);
>
>                 rc = cifs_posix_open(full_path, NULL, inode->i_sb,
> -                                    cifs_sb->mnt_file_mode /* ignored */,
> +                                    cifs_sb->ctx->file_mode /* ignored */,
>                                      oflags, &oplock, &cfile->fid.netfid, xid);
>                 if (rc == 0) {
>                         cifs_dbg(FYI, "posix reopen succeeded\n");
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index daec31be8571..e8a7110db2a6 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -37,6 +37,7 @@
>  #include "cifs_fs_sb.h"
>  #include "cifs_unicode.h"
>  #include "fscache.h"
> +#include "fs_context.h"
>
>
>  static void cifs_set_ops(struct inode *inode)
> @@ -294,7 +295,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
>                 break;
>         }
>
> -       fattr->cf_uid = cifs_sb->mnt_uid;
> +       fattr->cf_uid = cifs_sb->ctx->linux_uid;
>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
>                 u64 id = le64_to_cpu(info->Uid);
>                 if (id < ((uid_t)-1)) {
> @@ -304,7 +305,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
>                 }
>         }
>
> -       fattr->cf_gid = cifs_sb->mnt_gid;
> +       fattr->cf_gid = cifs_sb->ctx->linux_gid;
>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
>                 u64 id = le64_to_cpu(info->Gid);
>                 if (id < ((gid_t)-1)) {
> @@ -333,8 +334,8 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
>
>         memset(fattr, 0, sizeof(*fattr));
>         fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
> -       fattr->cf_uid = cifs_sb->mnt_uid;
> -       fattr->cf_gid = cifs_sb->mnt_gid;
> +       fattr->cf_uid = cifs_sb->ctx->linux_uid;
> +       fattr->cf_gid = cifs_sb->ctx->linux_gid;
>         ktime_get_coarse_real_ts64(&fattr->cf_mtime);
>         fattr->cf_atime = fattr->cf_ctime = fattr->cf_mtime;
>         fattr->cf_nlink = 2;
> @@ -644,8 +645,8 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
>         }
>         /* else if reparse point ... TODO: add support for FIFO and blk dev; special file types */
>
> -       fattr->cf_uid = cifs_sb->mnt_uid; /* TODO: map uid and gid from SID */
> -       fattr->cf_gid = cifs_sb->mnt_gid;
> +       fattr->cf_uid = cifs_sb->ctx->linux_uid; /* TODO: map uid and gid from SID */
> +       fattr->cf_gid = cifs_sb->ctx->linux_gid;
>
>         cifs_dbg(FYI, "POSIX query info: mode 0x%x uniqueid 0x%llx nlink %d\n",
>                 fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
> @@ -689,7 +690,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>                 fattr->cf_mode = S_IFLNK;
>                 fattr->cf_dtype = DT_LNK;
>         } else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
> -               fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
> +               fattr->cf_mode = S_IFDIR | cifs_sb->ctx->dir_mode;
>                 fattr->cf_dtype = DT_DIR;
>                 /*
>                  * Server can return wrong NumberOfLinks value for directories
> @@ -698,7 +699,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>                 if (!tcon->unix_ext)
>                         fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
>         } else {
> -               fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
> +               fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
>                 fattr->cf_dtype = DT_REG;
>
>                 /* clear write bits if ATTR_READONLY is set */
> @@ -717,8 +718,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>                 }
>         }
>
> -       fattr->cf_uid = cifs_sb->mnt_uid;
> -       fattr->cf_gid = cifs_sb->mnt_gid;
> +       fattr->cf_uid = cifs_sb->ctx->linux_uid;
> +       fattr->cf_gid = cifs_sb->ctx->linux_gid;
>  }
>
>  static int
> @@ -1358,8 +1359,8 @@ struct inode *cifs_root_iget(struct super_block *sb)
>                 set_nlink(inode, 2);
>                 inode->i_op = &cifs_ipc_inode_ops;
>                 inode->i_fop = &simple_dir_operations;
> -               inode->i_uid = cifs_sb->mnt_uid;
> -               inode->i_gid = cifs_sb->mnt_gid;
> +               inode->i_uid = cifs_sb->ctx->linux_uid;
> +               inode->i_gid = cifs_sb->ctx->linux_gid;
>                 spin_unlock(&inode->i_lock);
>         } else if (rc) {
>                 iget_failed(inode);
> @@ -2834,10 +2835,10 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>                                 attrs->ia_mode &= ~(S_IALLUGO);
>                                 if (S_ISDIR(inode->i_mode))
>                                         attrs->ia_mode |=
> -                                               cifs_sb->mnt_dir_mode;
> +                                               cifs_sb->ctx->dir_mode;
>                                 else
>                                         attrs->ia_mode |=
> -                                               cifs_sb->mnt_file_mode;
> +                                               cifs_sb->ctx->file_mode;
>                         }
>                 } else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
>                         /* ignore mode change - ATTR_READONLY hasn't changed */
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 1c14cf01dbef..82e176720ca6 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -35,6 +35,7 @@
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dns_resolve.h"
>  #endif
> +#include "fs_context.h"
>
>  extern mempool_t *cifs_sm_req_poolp;
>  extern mempool_t *cifs_req_poolp;
> @@ -632,11 +633,11 @@ bool
>  backup_cred(struct cifs_sb_info *cifs_sb)
>  {
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID) {
> -               if (uid_eq(cifs_sb->mnt_backupuid, current_fsuid()))
> +               if (uid_eq(cifs_sb->ctx->backupuid, current_fsuid()))
>                         return true;
>         }
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID) {
> -               if (in_group_p(cifs_sb->mnt_backupgid))
> +               if (in_group_p(cifs_sb->ctx->backupgid))
>                         return true;
>         }
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 5abf1ea21abe..70676843e169 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -33,6 +33,7 @@
>  #include "cifs_fs_sb.h"
>  #include "cifsfs.h"
>  #include "smb2proto.h"
> +#include "fs_context.h"
>
>  /*
>   * To be safe - for UCS to UTF-8 with strings loaded with the rare long
> @@ -165,14 +166,14 @@ static bool reparse_file_needs_reval(const struct cifs_fattr *fattr)
>  static void
>  cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
>  {
> -       fattr->cf_uid = cifs_sb->mnt_uid;
> -       fattr->cf_gid = cifs_sb->mnt_gid;
> +       fattr->cf_uid = cifs_sb->ctx->linux_uid;
> +       fattr->cf_gid = cifs_sb->ctx->linux_gid;
>
>         if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
> -               fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
> +               fattr->cf_mode = S_IFDIR | cifs_sb->ctx->dir_mode;
>                 fattr->cf_dtype = DT_DIR;
>         } else {
> -               fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
> +               fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
>                 fattr->cf_dtype = DT_REG;
>         }
>
> --
> 2.13.6
>


-- 
Thanks,

Steve

--000000000000f8afa705b6499d79
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-remove-gu-id-backup-gu-id-file_mode-dir_mode-fr.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-gu-id-backup-gu-id-file_mode-dir_mode-fr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kim3w8e10>
X-Attachment-Id: f_kim3w8e10

RnJvbSA0YWZkZTZjNzQwMjNiYTM4ZDE4Yzk5ODI0MjEzMDZlN2YyZDQ5MjFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFNhdCwgMTIgRGVjIDIwMjAgMTM6NDA6NTAgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiByZW1vdmUgW2d1XWlkL2JhY2t1cFtndV1pZC9maWxlX21vZGUvZGlyX21vZGUgZnJvbQog
Y2lmc19zYgoKV2UgY2FuIGFscmVhZHkgYWNjZXNzIHRoZXNlIGZyb20gY2lmc19zYi0+Y3R4IHNv
IHdlIG5vIGxvbmdlciBuZWVkCmEgbG9jYWwgY29weSBpbiBjaWZzX3NiLgoKU2lnbmVkLW9mZi1i
eTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBT
dGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzX2Zz
X3NiLmggfCAgNiAtLS0tLS0KIGZzL2NpZnMvY2lmc2FjbC5jICAgIHwgIDcgKysrKy0tLQogZnMv
Y2lmcy9jaWZzZnMuYyAgICAgfCAxMiArKysrKystLS0tLS0KIGZzL2NpZnMvY29ubmVjdC5jICAg
IHwgMTUgKysrKystLS0tLS0tLS0tCiBmcy9jaWZzL2ZpbGUuYyAgICAgICB8ICA1ICsrKy0tCiBm
cy9jaWZzL2lub2RlLmMgICAgICB8IDM5ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLQogZnMvY2lmcy9taXNjLmMgICAgICAgfCAgNSArKystLQogZnMvY2lmcy9yZWFkZGly
LmMgICAgfCAxOSArKysrKysrKysrLS0tLS0tLS0tCiA4IGZpbGVzIGNoYW5nZWQsIDUxIGluc2Vy
dGlvbnMoKyksIDU3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19mc19z
Yi5oIGIvZnMvY2lmcy9jaWZzX2ZzX3NiLmgKaW5kZXggOGVlMzdjODA4ODBhLi4zZjRmMTQ4N2Y3
MTQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19mc19zYi5oCisrKyBiL2ZzL2NpZnMvY2lmc19m
c19zYi5oCkBAIC02NywxMiArNjcsNiBAQCBzdHJ1Y3QgY2lmc19zYl9pbmZvIHsKIAl1bnNpZ25l
ZCBpbnQgd3NpemU7CiAJdW5zaWduZWQgbG9uZyBhY3RpbWVvOyAvKiBhdHRyaWJ1dGUgY2FjaGUg
dGltZW91dCAoamlmZmllcykgKi8KIAlhdG9taWNfdCBhY3RpdmU7Ci0Ja3VpZF90CW1udF91aWQ7
Ci0Ja2dpZF90CW1udF9naWQ7Ci0Ja3VpZF90CW1udF9iYWNrdXB1aWQ7Ci0Ja2dpZF90CW1udF9i
YWNrdXBnaWQ7Ci0JdW1vZGVfdAltbnRfZmlsZV9tb2RlOwotCXVtb2RlX3QJbW50X2Rpcl9tb2Rl
OwogCXVuc2lnbmVkIGludCBtbnRfY2lmc19mbGFnczsKIAlzdHJ1Y3QgZGVsYXllZF93b3JrIHBy
dW5lX3RsaW5rczsKIAlzdHJ1Y3QgcmN1X2hlYWQgcmN1OwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9j
aWZzYWNsLmMgYi9mcy9jaWZzL2NpZnNhY2wuYwppbmRleCBjMzk1NGJmY2I2NjYuLjJmMjFmODk4
NzFjYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzYWNsLmMKKysrIGIvZnMvY2lmcy9jaWZzYWNs
LmMKQEAgLTMyLDYgKzMyLDcgQEAKICNpbmNsdWRlICJjaWZzYWNsLmgiCiAjaW5jbHVkZSAiY2lm
c3Byb3RvLmgiCiAjaW5jbHVkZSAiY2lmc19kZWJ1Zy5oIgorI2luY2x1ZGUgImZzX2NvbnRleHQu
aCIKIAogLyogc2VjdXJpdHkgaWQgZm9yIGV2ZXJ5b25lL3dvcmxkIHN5c3RlbSBncm91cCAqLwog
c3RhdGljIGNvbnN0IHN0cnVjdCBjaWZzX3NpZCBzaWRfZXZlcnlvbmUgPSB7CkBAIC0zNDYsOCAr
MzQ3LDggQEAgc2lkX3RvX2lkKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBj
aWZzX3NpZCAqcHNpZCwKIAlzdHJ1Y3Qga2V5ICpzaWRrZXk7CiAJY2hhciAqc2lkc3RyOwogCWNv
bnN0IHN0cnVjdCBjcmVkICpzYXZlZF9jcmVkOwotCWt1aWRfdCBmdWlkID0gY2lmc19zYi0+bW50
X3VpZDsKLQlrZ2lkX3QgZmdpZCA9IGNpZnNfc2ItPm1udF9naWQ7CisJa3VpZF90IGZ1aWQgPSBj
aWZzX3NiLT5jdHgtPmxpbnV4X3VpZDsKKwlrZ2lkX3QgZmdpZCA9IGNpZnNfc2ItPmN0eC0+bGlu
dXhfZ2lkOwogCiAJLyoKIAkgKiBJZiB3ZSBoYXZlIHRvbyBtYW55IHN1YmF1dGhvcml0aWVzLCB0
aGVuIHNvbWV0aGluZyBpcyByZWFsbHkgd3JvbmcuCkBAIC00NDgsNyArNDQ5LDcgQEAgc2lkX3Rv
X2lkKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBjaWZzX3NpZCAqcHNpZCwK
IAogCS8qCiAJICogTm90ZSB0aGF0IHdlIHJldHVybiAwIGhlcmUgdW5jb25kaXRpb25hbGx5LiBJ
ZiB0aGUgbWFwcGluZwotCSAqIGZhaWxzIHRoZW4gd2UganVzdCBmYWxsIGJhY2sgdG8gdXNpbmcg
dGhlIG1udF91aWQvbW50X2dpZC4KKwkgKiBmYWlscyB0aGVuIHdlIGp1c3QgZmFsbCBiYWNrIHRv
IHVzaW5nIHRoZSBjdHgtPmxpbnV4X3VpZC9saW51eF9naWQuCiAJICovCiBnb3RfdmFsaWRfaWQ6
CiAJcmMgPSAwOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2Zz
LmMKaW5kZXggZjgxMGIyNWRmZWI4Li4zYWYyMmMwOWQ4ZGUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
Y2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtNTE4LDE0ICs1MTgsMTQgQEAgY2lm
c19zaG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQog
CX0KIAogCXNlcV9wcmludGYocywgIix1aWQ9JXUiLAotCQkgICBmcm9tX2t1aWRfbXVuZ2VkKCZp
bml0X3VzZXJfbnMsIGNpZnNfc2ItPm1udF91aWQpKTsKKwkJICAgZnJvbV9rdWlkX211bmdlZCgm
aW5pdF91c2VyX25zLCBjaWZzX3NiLT5jdHgtPmxpbnV4X3VpZCkpOwogCWlmIChjaWZzX3NiLT5t
bnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfT1ZFUlJfVUlEKQogCQlzZXFfcHV0cyhzLCAiLGZv
cmNldWlkIik7CiAJZWxzZQogCQlzZXFfcHV0cyhzLCAiLG5vZm9yY2V1aWQiKTsKIAogCXNlcV9w
cmludGYocywgIixnaWQ9JXUiLAotCQkgICBmcm9tX2tnaWRfbXVuZ2VkKCZpbml0X3VzZXJfbnMs
IGNpZnNfc2ItPm1udF9naWQpKTsKKwkJICAgZnJvbV9rZ2lkX211bmdlZCgmaW5pdF91c2VyX25z
LCBjaWZzX3NiLT5jdHgtPmxpbnV4X2dpZCkpOwogCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFn
cyAmIENJRlNfTU9VTlRfT1ZFUlJfR0lEKQogCQlzZXFfcHV0cyhzLCAiLGZvcmNlZ2lkIik7CiAJ
ZWxzZQpAQCAtNTM1LDggKzUzNSw4IEBAIGNpZnNfc2hvd19vcHRpb25zKHN0cnVjdCBzZXFfZmls
ZSAqcywgc3RydWN0IGRlbnRyeSAqcm9vdCkKIAogCWlmICghdGNvbi0+dW5peF9leHQpCiAJCXNl
cV9wcmludGYocywgIixmaWxlX21vZGU9MCVobyxkaXJfbW9kZT0wJWhvIiwKLQkJCQkJICAgY2lm
c19zYi0+bW50X2ZpbGVfbW9kZSwKLQkJCQkJICAgY2lmc19zYi0+bW50X2Rpcl9tb2RlKTsKKwkJ
CQkJICAgY2lmc19zYi0+Y3R4LT5maWxlX21vZGUsCisJCQkJCSAgIGNpZnNfc2ItPmN0eC0+ZGly
X21vZGUpOwogCiAJY2lmc19zaG93X25scyhzLCBjaWZzX3NiLT5sb2NhbF9ubHMpOwogCkBAIC02
MDksMTEgKzYwOSwxMSBAQCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIHN0
cnVjdCBkZW50cnkgKnJvb3QpCiAJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19N
T1VOVF9DSUZTX0JBQ0tVUFVJRCkKIAkJc2VxX3ByaW50ZihzLCAiLGJhY2t1cHVpZD0ldSIsCiAJ
CQkgICBmcm9tX2t1aWRfbXVuZ2VkKCZpbml0X3VzZXJfbnMsCi0JCQkJCSAgICBjaWZzX3NiLT5t
bnRfYmFja3VwdWlkKSk7CisJCQkJCSAgICBjaWZzX3NiLT5jdHgtPmJhY2t1cHVpZCkpOwogCWlm
IChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfQ0lGU19CQUNLVVBHSUQpCiAJ
CXNlcV9wcmludGYocywgIixiYWNrdXBnaWQ9JXUiLAogCQkJICAgZnJvbV9rZ2lkX211bmdlZCgm
aW5pdF91c2VyX25zLAotCQkJCQkgICAgY2lmc19zYi0+bW50X2JhY2t1cGdpZCkpOworCQkJCQkg
ICAgY2lmc19zYi0+Y3R4LT5iYWNrdXBnaWQpKTsKIAogCXNlcV9wcmludGYocywgIixyc2l6ZT0l
dSIsIGNpZnNfc2ItPnJzaXplKTsKIAlzZXFfcHJpbnRmKHMsICIsd3NpemU9JXUiLCBjaWZzX3Ni
LT53c2l6ZSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVj
dC5jCmluZGV4IDE1NmMxOGJmNDBkMi4uZjZhYTM3YWEzYmYwIDEwMDY0NAotLS0gYS9mcy9jaWZz
L2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjI0MCwxMSArMjI0MCwxMiBA
QCBjb21wYXJlX21vdW50X29wdGlvbnMoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0IGNp
ZnNfbW50X2RhdGEgKm1udF9kYXRhKQogCWlmIChuZXctPnJzaXplICYmIG5ldy0+cnNpemUgPCBv
bGQtPnJzaXplKQogCQlyZXR1cm4gMDsKIAotCWlmICghdWlkX2VxKG9sZC0+bW50X3VpZCwgbmV3
LT5tbnRfdWlkKSB8fCAhZ2lkX2VxKG9sZC0+bW50X2dpZCwgbmV3LT5tbnRfZ2lkKSkKKwlpZiAo
IXVpZF9lcShvbGQtPmN0eC0+bGludXhfdWlkLCBuZXctPmN0eC0+bGludXhfdWlkKSB8fAorCSAg
ICAhZ2lkX2VxKG9sZC0+Y3R4LT5saW51eF9naWQsIG5ldy0+Y3R4LT5saW51eF9naWQpKQogCQly
ZXR1cm4gMDsKIAotCWlmIChvbGQtPm1udF9maWxlX21vZGUgIT0gbmV3LT5tbnRfZmlsZV9tb2Rl
IHx8Ci0JICAgIG9sZC0+bW50X2Rpcl9tb2RlICE9IG5ldy0+bW50X2Rpcl9tb2RlKQorCWlmIChv
bGQtPmN0eC0+ZmlsZV9tb2RlICE9IG5ldy0+Y3R4LT5maWxlX21vZGUgfHwKKwkgICAgb2xkLT5j
dHgtPmRpcl9tb2RlICE9IG5ldy0+Y3R4LT5kaXJfbW9kZSkKIAkJcmV0dXJuIDA7CiAKIAlpZiAo
c3RyY21wKG9sZC0+bG9jYWxfbmxzLT5jaGFyc2V0LCBuZXctPmxvY2FsX25scy0+Y2hhcnNldCkp
CkBAIC0yNzA3LDEyICsyNzA4LDggQEAgaW50IGNpZnNfc2V0dXBfY2lmc19zYihzdHJ1Y3Qgc21i
M19mc19jb250ZXh0ICpjdHgsCiAJY2lmc19zYi0+cnNpemUgPSBjdHgtPnJzaXplOwogCWNpZnNf
c2ItPndzaXplID0gY3R4LT53c2l6ZTsKIAotCWNpZnNfc2ItPm1udF91aWQgPSBjdHgtPmxpbnV4
X3VpZDsKLQljaWZzX3NiLT5tbnRfZ2lkID0gY3R4LT5saW51eF9naWQ7Ci0JY2lmc19zYi0+bW50
X2ZpbGVfbW9kZSA9IGN0eC0+ZmlsZV9tb2RlOwotCWNpZnNfc2ItPm1udF9kaXJfbW9kZSA9IGN0
eC0+ZGlyX21vZGU7CiAJY2lmc19kYmcoRllJLCAiZmlsZSBtb2RlOiAlMDRobyAgZGlyIG1vZGU6
ICUwNGhvXG4iLAotCQkgY2lmc19zYi0+bW50X2ZpbGVfbW9kZSwgY2lmc19zYi0+bW50X2Rpcl9t
b2RlKTsKKwkJIGNpZnNfc2ItPmN0eC0+ZmlsZV9tb2RlLCBjaWZzX3NiLT5jdHgtPmRpcl9tb2Rl
KTsKIAogCWNpZnNfc2ItPmFjdGltZW8gPSBjdHgtPmFjdGltZW87CiAJY2lmc19zYi0+bG9jYWxf
bmxzID0gY3R4LT5sb2NhbF9ubHM7CkBAIC0yNzUxLDExICsyNzQ4LDkgQEAgaW50IGNpZnNfc2V0
dXBfY2lmc19zYihzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgsCiAJCWNpZnNfc2ItPm1udF9j
aWZzX2ZsYWdzIHw9IENJRlNfTU9VTlRfQ0lGU19BQ0w7CiAJaWYgKGN0eC0+YmFja3VwdWlkX3Nw
ZWNpZmllZCkgewogCQljaWZzX3NiLT5tbnRfY2lmc19mbGFncyB8PSBDSUZTX01PVU5UX0NJRlNf
QkFDS1VQVUlEOwotCQljaWZzX3NiLT5tbnRfYmFja3VwdWlkID0gY3R4LT5iYWNrdXB1aWQ7CiAJ
fQogCWlmIChjdHgtPmJhY2t1cGdpZF9zcGVjaWZpZWQpIHsKIAkJY2lmc19zYi0+bW50X2NpZnNf
ZmxhZ3MgfD0gQ0lGU19NT1VOVF9DSUZTX0JBQ0tVUEdJRDsKLQkJY2lmc19zYi0+bW50X2JhY2t1
cGdpZCA9IGN0eC0+YmFja3VwZ2lkOwogCX0KIAlpZiAoY3R4LT5vdmVycmlkZV91aWQpCiAJCWNp
ZnNfc2ItPm1udF9jaWZzX2ZsYWdzIHw9IENJRlNfTU9VTlRfT1ZFUlJfVUlEOwpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCAyOTE3NmE1NjIyOWYuLjU4
MzA3NDU0NmU2ZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxl
LmMKQEAgLTQ0LDYgKzQ0LDcgQEAKICNpbmNsdWRlICJjaWZzX2ZzX3NiLmgiCiAjaW5jbHVkZSAi
ZnNjYWNoZS5oIgogI2luY2x1ZGUgInNtYmRpcmVjdC5oIgorI2luY2x1ZGUgImZzX2NvbnRleHQu
aCIKIAogc3RhdGljIGlubGluZSBpbnQgY2lmc19jb252ZXJ0X2ZsYWdzKHVuc2lnbmVkIGludCBm
bGFncykKIHsKQEAgLTU3MSw3ICs1NzIsNyBAQCBpbnQgY2lmc19vcGVuKHN0cnVjdCBpbm9kZSAq
aW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCQkJCWxlNjRfdG9fY3B1KHRjb24tPmZzVW5peElu
Zm8uQ2FwYWJpbGl0eSkpKSB7CiAJCS8qIGNhbiBub3QgcmVmcmVzaCBpbm9kZSBpbmZvIHNpbmNl
IHNpemUgY291bGQgYmUgc3RhbGUgKi8KIAkJcmMgPSBjaWZzX3Bvc2l4X29wZW4oZnVsbF9wYXRo
LCAmaW5vZGUsIGlub2RlLT5pX3NiLAotCQkJCWNpZnNfc2ItPm1udF9maWxlX21vZGUgLyogaWdu
b3JlZCAqLywKKwkJCQljaWZzX3NiLT5jdHgtPmZpbGVfbW9kZSAvKiBpZ25vcmVkICovLAogCQkJ
CWZpbGUtPmZfZmxhZ3MsICZvcGxvY2ssICZmaWQubmV0ZmlkLCB4aWQpOwogCQlpZiAocmMgPT0g
MCkgewogCQkJY2lmc19kYmcoRllJLCAicG9zaXggb3BlbiBzdWNjZWVkZWRcbiIpOwpAQCAtNzQw
LDcgKzc0MSw3IEBAIGNpZnNfcmVvcGVuX2ZpbGUoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUs
IGJvb2wgY2FuX2ZsdXNoKQogCQkJCQkJfihPX0NSRUFUIHwgT19FWENMIHwgT19UUlVOQyk7CiAK
IAkJcmMgPSBjaWZzX3Bvc2l4X29wZW4oZnVsbF9wYXRoLCBOVUxMLCBpbm9kZS0+aV9zYiwKLQkJ
CQkgICAgIGNpZnNfc2ItPm1udF9maWxlX21vZGUgLyogaWdub3JlZCAqLywKKwkJCQkgICAgIGNp
ZnNfc2ItPmN0eC0+ZmlsZV9tb2RlIC8qIGlnbm9yZWQgKi8sCiAJCQkJICAgICBvZmxhZ3MsICZv
cGxvY2ssICZjZmlsZS0+ZmlkLm5ldGZpZCwgeGlkKTsKIAkJaWYgKHJjID09IDApIHsKIAkJCWNp
ZnNfZGJnKEZZSSwgInBvc2l4IHJlb3BlbiBzdWNjZWVkZWRcbiIpOwpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5jCmluZGV4IGViM2M4ODY3MTUwOC4uYmJkY2Uz
MmU5NzhmIDEwMDY0NAotLS0gYS9mcy9jaWZzL2lub2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5j
CkBAIC0zNyw2ICszNyw3IEBACiAjaW5jbHVkZSAiY2lmc19mc19zYi5oIgogI2luY2x1ZGUgImNp
ZnNfdW5pY29kZS5oIgogI2luY2x1ZGUgImZzY2FjaGUuaCIKKyNpbmNsdWRlICJmc19jb250ZXh0
LmgiCiAKIAogc3RhdGljIHZvaWQgY2lmc19zZXRfb3BzKHN0cnVjdCBpbm9kZSAqaW5vZGUpCkBA
IC0yOTQsNyArMjk1LDcgQEAgY2lmc191bml4X2Jhc2ljX3RvX2ZhdHRyKHN0cnVjdCBjaWZzX2Zh
dHRyICpmYXR0ciwgRklMRV9VTklYX0JBU0lDX0lORk8gKmluZm8sCiAJCWJyZWFrOwogCX0KIAot
CWZhdHRyLT5jZl91aWQgPSBjaWZzX3NiLT5tbnRfdWlkOworCWZhdHRyLT5jZl91aWQgPSBjaWZz
X3NiLT5jdHgtPmxpbnV4X3VpZDsKIAlpZiAoIShjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJ
RlNfTU9VTlRfT1ZFUlJfVUlEKSkgewogCQl1NjQgaWQgPSBsZTY0X3RvX2NwdShpbmZvLT5VaWQp
OwogCQlpZiAoaWQgPCAoKHVpZF90KS0xKSkgewpAQCAtMzA0LDcgKzMwNSw3IEBAIGNpZnNfdW5p
eF9iYXNpY190b19mYXR0cihzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsIEZJTEVfVU5JWF9CQVNJ
Q19JTkZPICppbmZvLAogCQl9CiAJfQogCQotCWZhdHRyLT5jZl9naWQgPSBjaWZzX3NiLT5tbnRf
Z2lkOworCWZhdHRyLT5jZl9naWQgPSBjaWZzX3NiLT5jdHgtPmxpbnV4X2dpZDsKIAlpZiAoIShj
aWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfT1ZFUlJfR0lEKSkgewogCQl1NjQg
aWQgPSBsZTY0X3RvX2NwdShpbmZvLT5HaWQpOwogCQlpZiAoaWQgPCAoKGdpZF90KS0xKSkgewpA
QCAtMzMzLDggKzMzNCw4IEBAIGNpZnNfY3JlYXRlX2Rmc19mYXR0cihzdHJ1Y3QgY2lmc19mYXR0
ciAqZmF0dHIsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAKIAltZW1zZXQoZmF0dHIsIDAsIHNp
emVvZigqZmF0dHIpKTsKIAlmYXR0ci0+Y2ZfbW9kZSA9IFNfSUZESVIgfCBTX0lYVUdPIHwgU19J
UldYVTsKLQlmYXR0ci0+Y2ZfdWlkID0gY2lmc19zYi0+bW50X3VpZDsKLQlmYXR0ci0+Y2ZfZ2lk
ID0gY2lmc19zYi0+bW50X2dpZDsKKwlmYXR0ci0+Y2ZfdWlkID0gY2lmc19zYi0+Y3R4LT5saW51
eF91aWQ7CisJZmF0dHItPmNmX2dpZCA9IGNpZnNfc2ItPmN0eC0+bGludXhfZ2lkOwogCWt0aW1l
X2dldF9jb2Fyc2VfcmVhbF90czY0KCZmYXR0ci0+Y2ZfbXRpbWUpOwogCWZhdHRyLT5jZl9hdGlt
ZSA9IGZhdHRyLT5jZl9jdGltZSA9IGZhdHRyLT5jZl9tdGltZTsKIAlmYXR0ci0+Y2Zfbmxpbmsg
PSAyOwpAQCAtNjQ0LDggKzY0NSw4IEBAIHNtYjMxMV9wb3NpeF9pbmZvX3RvX2ZhdHRyKHN0cnVj
dCBjaWZzX2ZhdHRyICpmYXR0ciwgc3RydWN0IHNtYjMxMV9wb3NpeF9xaW5mbyAqCiAJfQogCS8q
IGVsc2UgaWYgcmVwYXJzZSBwb2ludCAuLi4gVE9ETzogYWRkIHN1cHBvcnQgZm9yIEZJRk8gYW5k
IGJsayBkZXY7IHNwZWNpYWwgZmlsZSB0eXBlcyAqLwogCi0JZmF0dHItPmNmX3VpZCA9IGNpZnNf
c2ItPm1udF91aWQ7IC8qIFRPRE86IG1hcCB1aWQgYW5kIGdpZCBmcm9tIFNJRCAqLwotCWZhdHRy
LT5jZl9naWQgPSBjaWZzX3NiLT5tbnRfZ2lkOworCWZhdHRyLT5jZl91aWQgPSBjaWZzX3NiLT5j
dHgtPmxpbnV4X3VpZDsgLyogVE9ETzogbWFwIHVpZCBhbmQgZ2lkIGZyb20gU0lEICovCisJZmF0
dHItPmNmX2dpZCA9IGNpZnNfc2ItPmN0eC0+bGludXhfZ2lkOwogCiAJY2lmc19kYmcoRllJLCAi
UE9TSVggcXVlcnkgaW5mbzogbW9kZSAweCV4IHVuaXF1ZWlkIDB4JWxseCBubGluayAlZFxuIiwK
IAkJZmF0dHItPmNmX21vZGUsIGZhdHRyLT5jZl91bmlxdWVpZCwgZmF0dHItPmNmX25saW5rKTsK
QEAgLTY4NSwyNSArNjg2LDI1IEBAIGNpZnNfYWxsX2luZm9fdG9fZmF0dHIoc3RydWN0IGNpZnNf
ZmF0dHIgKmZhdHRyLCBGSUxFX0FMTF9JTkZPICppbmZvLAogCiAJZmF0dHItPmNmX25saW5rID0g
bGUzMl90b19jcHUoaW5mby0+TnVtYmVyT2ZMaW5rcyk7CiAJaWYgKHJlcGFyc2VfdGFnID09IElP
X1JFUEFSU0VfVEFHX0xYX1NZTUxJTkspIHsKLQkJZmF0dHItPmNmX21vZGUgfD0gU19JRkxOSyB8
IGNpZnNfc2ItPm1udF9maWxlX21vZGU7CisJCWZhdHRyLT5jZl9tb2RlIHw9IFNfSUZMTksgfCBj
aWZzX3NiLT5jdHgtPmZpbGVfbW9kZTsKIAkJZmF0dHItPmNmX2R0eXBlID0gRFRfTE5LOwogCX0g
ZWxzZSBpZiAocmVwYXJzZV90YWcgPT0gSU9fUkVQQVJTRV9UQUdfTFhfRklGTykgewotCQlmYXR0
ci0+Y2ZfbW9kZSB8PSBTX0lGSUZPIHwgY2lmc19zYi0+bW50X2ZpbGVfbW9kZTsKKwkJZmF0dHIt
PmNmX21vZGUgfD0gU19JRklGTyB8IGNpZnNfc2ItPmN0eC0+ZmlsZV9tb2RlOwogCQlmYXR0ci0+
Y2ZfZHR5cGUgPSBEVF9GSUZPOwogCX0gZWxzZSBpZiAocmVwYXJzZV90YWcgPT0gSU9fUkVQQVJT
RV9UQUdfQUZfVU5JWCkgewotCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGU09DSyB8IGNpZnNfc2It
Pm1udF9maWxlX21vZGU7CisJCWZhdHRyLT5jZl9tb2RlIHw9IFNfSUZTT0NLIHwgY2lmc19zYi0+
Y3R4LT5maWxlX21vZGU7CiAJCWZhdHRyLT5jZl9kdHlwZSA9IERUX1NPQ0s7CiAJfSBlbHNlIGlm
IChyZXBhcnNlX3RhZyA9PSBJT19SRVBBUlNFX1RBR19MWF9DSFIpIHsKLQkJZmF0dHItPmNmX21v
ZGUgfD0gU19JRkNIUiB8IGNpZnNfc2ItPm1udF9maWxlX21vZGU7CisJCWZhdHRyLT5jZl9tb2Rl
IHw9IFNfSUZDSFIgfCBjaWZzX3NiLT5jdHgtPmZpbGVfbW9kZTsKIAkJZmF0dHItPmNmX2R0eXBl
ID0gRFRfQ0hSOwogCX0gZWxzZSBpZiAocmVwYXJzZV90YWcgPT0gSU9fUkVQQVJTRV9UQUdfTFhf
QkxLKSB7Ci0JCWZhdHRyLT5jZl9tb2RlIHw9IFNfSUZCTEsgfCBjaWZzX3NiLT5tbnRfZmlsZV9t
b2RlOworCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGQkxLIHwgY2lmc19zYi0+Y3R4LT5maWxlX21v
ZGU7CiAJCWZhdHRyLT5jZl9kdHlwZSA9IERUX0JMSzsKIAl9IGVsc2UgaWYgKHN5bWxpbmspIHsg
LyogVE9ETyBhZGQgbW9yZSByZXBhcnNlIHRhZyBjaGVja3MgKi8KIAkJZmF0dHItPmNmX21vZGUg
PSBTX0lGTE5LOwogCQlmYXR0ci0+Y2ZfZHR5cGUgPSBEVF9MTks7CiAJfSBlbHNlIGlmIChmYXR0
ci0+Y2ZfY2lmc2F0dHJzICYgQVRUUl9ESVJFQ1RPUlkpIHsKLQkJZmF0dHItPmNmX21vZGUgPSBT
X0lGRElSIHwgY2lmc19zYi0+bW50X2Rpcl9tb2RlOworCQlmYXR0ci0+Y2ZfbW9kZSA9IFNfSUZE
SVIgfCBjaWZzX3NiLT5jdHgtPmRpcl9tb2RlOwogCQlmYXR0ci0+Y2ZfZHR5cGUgPSBEVF9ESVI7
CiAJCS8qCiAJCSAqIFNlcnZlciBjYW4gcmV0dXJuIHdyb25nIE51bWJlck9mTGlua3MgdmFsdWUg
Zm9yIGRpcmVjdG9yaWVzCkBAIC03MTIsNyArNzEzLDcgQEAgY2lmc19hbGxfaW5mb190b19mYXR0
cihzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsIEZJTEVfQUxMX0lORk8gKmluZm8sCiAJCWlmICgh
dGNvbi0+dW5peF9leHQpCiAJCQlmYXR0ci0+Y2ZfZmxhZ3MgfD0gQ0lGU19GQVRUUl9VTktOT1dO
X05MSU5LOwogCX0gZWxzZSB7Ci0JCWZhdHRyLT5jZl9tb2RlID0gU19JRlJFRyB8IGNpZnNfc2It
Pm1udF9maWxlX21vZGU7CisJCWZhdHRyLT5jZl9tb2RlID0gU19JRlJFRyB8IGNpZnNfc2ItPmN0
eC0+ZmlsZV9tb2RlOwogCQlmYXR0ci0+Y2ZfZHR5cGUgPSBEVF9SRUc7CiAKIAkJLyogY2xlYXIg
d3JpdGUgYml0cyBpZiBBVFRSX1JFQURPTkxZIGlzIHNldCAqLwpAQCAtNzMxLDggKzczMiw4IEBA
IGNpZnNfYWxsX2luZm9fdG9fZmF0dHIoc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyLCBGSUxFX0FM
TF9JTkZPICppbmZvLAogCQl9CiAJfQogCi0JZmF0dHItPmNmX3VpZCA9IGNpZnNfc2ItPm1udF91
aWQ7Ci0JZmF0dHItPmNmX2dpZCA9IGNpZnNfc2ItPm1udF9naWQ7CisJZmF0dHItPmNmX3VpZCA9
IGNpZnNfc2ItPmN0eC0+bGludXhfdWlkOworCWZhdHRyLT5jZl9naWQgPSBjaWZzX3NiLT5jdHgt
PmxpbnV4X2dpZDsKIH0KIAogc3RhdGljIGludApAQCAtMTM5MSw4ICsxMzkyLDggQEAgc3RydWN0
IGlub2RlICpjaWZzX3Jvb3RfaWdldChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCQlzZXRfbmxp
bmsoaW5vZGUsIDIpOwogCQlpbm9kZS0+aV9vcCA9ICZjaWZzX2lwY19pbm9kZV9vcHM7CiAJCWlu
b2RlLT5pX2ZvcCA9ICZzaW1wbGVfZGlyX29wZXJhdGlvbnM7Ci0JCWlub2RlLT5pX3VpZCA9IGNp
ZnNfc2ItPm1udF91aWQ7Ci0JCWlub2RlLT5pX2dpZCA9IGNpZnNfc2ItPm1udF9naWQ7CisJCWlu
b2RlLT5pX3VpZCA9IGNpZnNfc2ItPmN0eC0+bGludXhfdWlkOworCQlpbm9kZS0+aV9naWQgPSBj
aWZzX3NiLT5jdHgtPmxpbnV4X2dpZDsKIAkJc3Bpbl91bmxvY2soJmlub2RlLT5pX2xvY2spOwog
CX0gZWxzZSBpZiAocmMpIHsKIAkJaWdldF9mYWlsZWQoaW5vZGUpOwpAQCAtMjg3NywxMCArMjg3
OCwxMCBAQCBjaWZzX3NldGF0dHJfbm91bml4KHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LCBzdHJ1
Y3QgaWF0dHIgKmF0dHJzKQogCQkJCWF0dHJzLT5pYV9tb2RlICY9IH4oU19JQUxMVUdPKTsKIAkJ
CQlpZiAoU19JU0RJUihpbm9kZS0+aV9tb2RlKSkKIAkJCQkJYXR0cnMtPmlhX21vZGUgfD0KLQkJ
CQkJCWNpZnNfc2ItPm1udF9kaXJfbW9kZTsKKwkJCQkJCWNpZnNfc2ItPmN0eC0+ZGlyX21vZGU7
CiAJCQkJZWxzZQogCQkJCQlhdHRycy0+aWFfbW9kZSB8PQotCQkJCQkJY2lmc19zYi0+bW50X2Zp
bGVfbW9kZTsKKwkJCQkJCWNpZnNfc2ItPmN0eC0+ZmlsZV9tb2RlOwogCQkJfQogCQl9IGVsc2Ug
aWYgKCEoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX0RZTlBFUk0pKSB7CiAJ
CQkvKiBpZ25vcmUgbW9kZSBjaGFuZ2UgLSBBVFRSX1JFQURPTkxZIGhhc24ndCBjaGFuZ2VkICov
CmRpZmYgLS1naXQgYS9mcy9jaWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IDFjMTRj
ZjAxZGJlZi4uODJlMTc2NzIwY2E2IDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9m
cy9jaWZzL21pc2MuYwpAQCAtMzUsNiArMzUsNyBAQAogI2lmZGVmIENPTkZJR19DSUZTX0RGU19V
UENBTEwKICNpbmNsdWRlICJkbnNfcmVzb2x2ZS5oIgogI2VuZGlmCisjaW5jbHVkZSAiZnNfY29u
dGV4dC5oIgogCiBleHRlcm4gbWVtcG9vbF90ICpjaWZzX3NtX3JlcV9wb29scDsKIGV4dGVybiBt
ZW1wb29sX3QgKmNpZnNfcmVxX3Bvb2xwOwpAQCAtNjMyLDExICs2MzMsMTEgQEAgYm9vbAogYmFj
a3VwX2NyZWQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYikKIHsKIAlpZiAoY2lmc19zYi0+
bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX0NJRlNfQkFDS1VQVUlEKSB7Ci0JCWlmICh1aWRf
ZXEoY2lmc19zYi0+bW50X2JhY2t1cHVpZCwgY3VycmVudF9mc3VpZCgpKSkKKwkJaWYgKHVpZF9l
cShjaWZzX3NiLT5jdHgtPmJhY2t1cHVpZCwgY3VycmVudF9mc3VpZCgpKSkKIAkJCXJldHVybiB0
cnVlOwogCX0KIAlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX0NJRlNf
QkFDS1VQR0lEKSB7Ci0JCWlmIChpbl9ncm91cF9wKGNpZnNfc2ItPm1udF9iYWNrdXBnaWQpKQor
CQlpZiAoaW5fZ3JvdXBfcChjaWZzX3NiLT5jdHgtPmJhY2t1cGdpZCkpCiAJCQlyZXR1cm4gdHJ1
ZTsKIAl9CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvcmVhZGRpci5jIGIvZnMvY2lmcy9yZWFkZGly
LmMKaW5kZXggNzk5YmUzYTVkMjVlLi44MGJmNGM2ZjRjN2IgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
cmVhZGRpci5jCisrKyBiL2ZzL2NpZnMvcmVhZGRpci5jCkBAIC0zMyw2ICszMyw3IEBACiAjaW5j
bHVkZSAiY2lmc19mc19zYi5oIgogI2luY2x1ZGUgImNpZnNmcy5oIgogI2luY2x1ZGUgInNtYjJw
cm90by5oIgorI2luY2x1ZGUgImZzX2NvbnRleHQuaCIKIAogLyoKICAqIFRvIGJlIHNhZmUgLSBm
b3IgVUNTIHRvIFVURi04IHdpdGggc3RyaW5ncyBsb2FkZWQgd2l0aCB0aGUgcmFyZSBsb25nCkBA
IC0xNjUsOCArMTY2LDggQEAgc3RhdGljIGJvb2wgcmVwYXJzZV9maWxlX25lZWRzX3JldmFsKGNv
bnN0IHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikKIHN0YXRpYyB2b2lkCiBjaWZzX2ZpbGxfY29t
bW9uX2luZm8oc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyLCBzdHJ1Y3QgY2lmc19zYl9pbmZvICpj
aWZzX3NiKQogewotCWZhdHRyLT5jZl91aWQgPSBjaWZzX3NiLT5tbnRfdWlkOwotCWZhdHRyLT5j
Zl9naWQgPSBjaWZzX3NiLT5tbnRfZ2lkOworCWZhdHRyLT5jZl91aWQgPSBjaWZzX3NiLT5jdHgt
PmxpbnV4X3VpZDsKKwlmYXR0ci0+Y2ZfZ2lkID0gY2lmc19zYi0+Y3R4LT5saW51eF9naWQ7CiAK
IAkvKgogCSAqIFRoZSBJT19SRVBBUlNFX1RBR19MWF8gdGFncyBvcmlnaW5hbGx5IHdlcmUgdXNl
ZCBieSBXU0wgYnV0IHRoZXkKQEAgLTE3NywyNSArMTc4LDI1IEBAIGNpZnNfZmlsbF9jb21tb25f
aW5mbyhzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNf
c2IpCiAJICogcmVhc29uYWJseSBtYXAgc29tZSBvZiB0aGVtIHRvIGRpcmVjdG9yaWVzIHZzLiBm
aWxlcyB2cy4gc3ltbGlua3MKIAkgKi8KIAlpZiAoZmF0dHItPmNmX2NpZnNhdHRycyAmIEFUVFJf
RElSRUNUT1JZKSB7Ci0JCWZhdHRyLT5jZl9tb2RlID0gU19JRkRJUiB8IGNpZnNfc2ItPm1udF9k
aXJfbW9kZTsKKwkJZmF0dHItPmNmX21vZGUgPSBTX0lGRElSIHwgY2lmc19zYi0+Y3R4LT5kaXJf
bW9kZTsKIAkJZmF0dHItPmNmX2R0eXBlID0gRFRfRElSOwogCX0gZWxzZSBpZiAoZmF0dHItPmNm
X2NpZnN0YWcgPT0gSU9fUkVQQVJTRV9UQUdfTFhfU1lNTElOSykgewotCQlmYXR0ci0+Y2ZfbW9k
ZSB8PSBTX0lGTE5LIHwgY2lmc19zYi0+bW50X2ZpbGVfbW9kZTsKKwkJZmF0dHItPmNmX21vZGUg
fD0gU19JRkxOSyB8IGNpZnNfc2ItPmN0eC0+ZmlsZV9tb2RlOwogCQlmYXR0ci0+Y2ZfZHR5cGUg
PSBEVF9MTks7CiAJfSBlbHNlIGlmIChmYXR0ci0+Y2ZfY2lmc3RhZyA9PSBJT19SRVBBUlNFX1RB
R19MWF9GSUZPKSB7Ci0JCWZhdHRyLT5jZl9tb2RlIHw9IFNfSUZJRk8gfCBjaWZzX3NiLT5tbnRf
ZmlsZV9tb2RlOworCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGSUZPIHwgY2lmc19zYi0+Y3R4LT5m
aWxlX21vZGU7CiAJCWZhdHRyLT5jZl9kdHlwZSA9IERUX0ZJRk87CiAJfSBlbHNlIGlmIChmYXR0
ci0+Y2ZfY2lmc3RhZyA9PSBJT19SRVBBUlNFX1RBR19BRl9VTklYKSB7Ci0JCWZhdHRyLT5jZl9t
b2RlIHw9IFNfSUZTT0NLIHwgY2lmc19zYi0+bW50X2ZpbGVfbW9kZTsKKwkJZmF0dHItPmNmX21v
ZGUgfD0gU19JRlNPQ0sgfCBjaWZzX3NiLT5jdHgtPmZpbGVfbW9kZTsKIAkJZmF0dHItPmNmX2R0
eXBlID0gRFRfU09DSzsKIAl9IGVsc2UgaWYgKGZhdHRyLT5jZl9jaWZzdGFnID09IElPX1JFUEFS
U0VfVEFHX0xYX0NIUikgewotCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGQ0hSIHwgY2lmc19zYi0+
bW50X2ZpbGVfbW9kZTsKKwkJZmF0dHItPmNmX21vZGUgfD0gU19JRkNIUiB8IGNpZnNfc2ItPmN0
eC0+ZmlsZV9tb2RlOwogCQlmYXR0ci0+Y2ZfZHR5cGUgPSBEVF9DSFI7CiAJfSBlbHNlIGlmIChm
YXR0ci0+Y2ZfY2lmc3RhZyA9PSBJT19SRVBBUlNFX1RBR19MWF9CTEspIHsKLQkJZmF0dHItPmNm
X21vZGUgfD0gU19JRkJMSyB8IGNpZnNfc2ItPm1udF9maWxlX21vZGU7CisJCWZhdHRyLT5jZl9t
b2RlIHw9IFNfSUZCTEsgfCBjaWZzX3NiLT5jdHgtPmZpbGVfbW9kZTsKIAkJZmF0dHItPmNmX2R0
eXBlID0gRFRfQkxLOwogCX0gZWxzZSB7IC8qIFRPRE86IHNob3VsZCB3ZSBtYXJrIHNvbWUgb3Ro
ZXIgcmVwYXJzZSBwb2ludHMgKGxpa2UgREZTUikgYXMgZGlyZWN0b3JpZXM/ICovCi0JCWZhdHRy
LT5jZl9tb2RlID0gU19JRlJFRyB8IGNpZnNfc2ItPm1udF9maWxlX21vZGU7CisJCWZhdHRyLT5j
Zl9tb2RlID0gU19JRlJFRyB8IGNpZnNfc2ItPmN0eC0+ZmlsZV9tb2RlOwogCQlmYXR0ci0+Y2Zf
ZHR5cGUgPSBEVF9SRUc7CiAJfQogCi0tIAoyLjI3LjAKCg==
--000000000000f8afa705b6499d79--
