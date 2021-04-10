Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E908C433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4549761105
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhDJAFo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbhDJAFo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 20:05:44 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9242FC061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 17:05:30 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c6so8389303lji.8
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 17:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4RAmwZXDHoJW/9jRCXzKPrS5IQ4jNUK7S0geZewHQLs=;
        b=OmYpL37q7rclKXpyaca+bp05wp3FRyLwkzu38AP417eQf7WCG2pmlRkEUAFUboOYHT
         f8wiBIKP7v/QOk+FfjkS3ql2xcrFD56VuNn60YSkeKVusENMmQmpBMFlLxHqKay3taIU
         gp0Ej4qYCDiAUTI0+ZR9oAZ0QT1d9JZ5COFfcCxdNmBhPox7hOBBS0xCWai28DpBxWCC
         SvXomq578uaLDnwa4vRZeh/Zk0qJ1LKH1p1CoBRELkv/uFSLu2QBtvdi6/RsoYtTNPuY
         PjblK51KrWFPxURY1RXaQOfwnuW7BZFZ9Y/5qbiF9v3NZcuI+jjgskV8QWJJa1RojtUE
         cqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4RAmwZXDHoJW/9jRCXzKPrS5IQ4jNUK7S0geZewHQLs=;
        b=b7M0kIHDSfeMn3+oPC+deSPfuiAxjTWxbQhe2hzgA3b+7JklqugDQ6IHYgpw2UCIzL
         LDtdX7aO0rV/tWoBMqKHpRjC9WecQX09uB0sz20dhO4YMjs4Z54csitHEi4RvHfmjUOL
         F//fsvnA5fDnqi8HFY9pYIM44nj68+AAG39ikE10px1eOC7ynRHlFFwQrC3ehwMbCvb9
         TYmaQOL1t/fMj7p8fX3ucVyURW736gEMpDD9GYxTdO/S68O9Apm2F0qbJngIG5vBA2Ms
         NoQ+7GSa+1RPiHq3bi80DjBC6v7LwkTjTqqclC/j7gIoYFkwt93sYXGo1G3CQCEGAcaX
         Y4dw==
X-Gm-Message-State: AOAM530ywej/cAxm4YP/JClJeWr6wk9185DOIVWX+2Eq2bIyKtgJusyt
        pL77s1qBbtFeJan7rBHTEWj1eh6wQsJrcu76CB0=
X-Google-Smtp-Source: ABdhPJwUmKdNBDrV3KcucUybfD+T6BCHaNj+gEtcPKUISLoFGDzmfWDP5RHmIMNT/tbSV+zvuPVOnAklZTZMvgzGvDc=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr10643658ljp.406.1618013129001;
 Fri, 09 Apr 2021 17:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210308230735.337-1-lsahlber@redhat.com> <20210308230735.337-2-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 19:05:17 -0500
Message-ID: <CAH2r5mvPy3+5jrcSC=HVNnQwCU8JPGGiz2gQzq7ORxPr0Xeexw@mail.gmail.com>
Subject: Re: [PATCH 1/9] cifs: move the check for nohandlecache into open_shroot
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

checkpatch complains about

WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
#71: FILE: fs/cifs/smb2ops.c:750:

include/linux/errno.h indicates that these in range 512 through 530 should
never be returned to userspace:

/*
 * These should never be seen by user programs.  To return one of ERESTART*
 * codes, signal_pending() MUST be set.  Note that ptrace can observe these
 * at syscall exit tracing, but they will never be left for the debugged user
 * process to see.
 */


... but since this is not returned to userspace, perhaps it is
harmless.  Thoughts?

On Mon, Mar 8, 2021 at 5:08 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> instead of doing it in the callsites for open_shroot.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 24 +++++++++++-------------
>  fs/cifs/smb2ops.c   | 16 ++++++++--------
>  2 files changed, 19 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 1f900b81c34a..3d59614cbe8f 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -511,7 +511,6 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>         int rc;
>         struct smb2_file_all_info *smb2_data;
>         __u32 create_options = 0;
> -       bool no_cached_open = tcon->nohandlecache;
>         struct cifsFileInfo *cfile;
>         struct cached_fid *cfid = NULL;
>
> @@ -524,23 +523,22 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         /* If it is a root and its handle is cached then use it */
> -       if (!strlen(full_path) && !no_cached_open) {
> +       if (!strlen(full_path)) {
>                 rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> -               if (rc)
> -                       goto out;
> -
> -               if (tcon->crfid.file_all_info_is_valid) {
> -                       move_smb2_info_to_cifs(data,
> +               if (!rc) {
> +                       if (tcon->crfid.file_all_info_is_valid) {
> +                               move_smb2_info_to_cifs(data,
>                                                &tcon->crfid.file_all_info);
> -               } else {
> -                       rc = SMB2_query_info(xid, tcon,
> +                       } else {
> +                               rc = SMB2_query_info(xid, tcon,
>                                              cfid->fid->persistent_fid,
>                                              cfid->fid->volatile_fid, smb2_data);
> -                       if (!rc)
> -                               move_smb2_info_to_cifs(data, smb2_data);
> +                               if (!rc)
> +                                       move_smb2_info_to_cifs(data, smb2_data);
> +                       }
> +                       close_shroot(cfid);
> +                       goto out;
>                 }
> -               close_shroot(cfid);
> -               goto out;
>         }
>
>         cifs_get_readable_path(tcon, full_path, &cfile);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f5087295424c..7ee6926153b8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -746,6 +746,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
>         u8 oplock = SMB2_OPLOCK_LEVEL_II;
>         struct cifs_fid *pfid;
>
> +       if (tcon->nohandlecache)
> +               return -ENOTSUPP;
> +
>         mutex_lock(&tcon->crfid.fid_mutex);
>         if (tcon->crfid.is_valid) {
>                 cifs_dbg(FYI, "found a cached root file handle\n");
> @@ -914,7 +917,6 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
>         struct cifs_open_parms oparms;
>         struct cifs_fid fid;
> -       bool no_cached_open = tcon->nohandlecache;
>         struct cached_fid *cfid = NULL;
>
>         oparms.tcon = tcon;
> @@ -924,14 +926,12 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         oparms.fid = &fid;
>         oparms.reconnect = false;
>
> -       if (no_cached_open) {
> +       rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> +       if (rc == 0)
> +               memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
> +       else
>                 rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
>                                NULL, NULL);
> -       } else {
> -               rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> -               if (rc == 0)
> -                       memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
> -       }
>         if (rc)
>                 return;
>
> @@ -945,7 +945,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>                         FS_VOLUME_INFORMATION);
>         SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
>                         FS_SECTOR_SIZE_INFORMATION); /* SMB3 specific */
> -       if (no_cached_open)
> +       if (cfid == NULL)
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
>         else
>                 close_shroot(cfid);
> --
> 2.13.6
>


-- 
Thanks,

Steve
