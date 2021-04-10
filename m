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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E076EC433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B51B36008E
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhDJAIu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbhDJAIu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 20:08:50 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B126C061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 17:08:36 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 12so12204184lfq.13
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 17:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GzDk+luyRLHl3xZFm7QpNCudAsNmIQ+Am0n1E/HJhLo=;
        b=RlE4rz3KY5NXT0DOSx9LyJrJdN8UItx6Ap5FjN3Caeu1290nenawZmmbWphYAw7bmU
         ntxqvYW6fsajhbB9UPT/X7lOS6AmlfzguaP/zTAwDbqy7Djpp+XIHBEN54Q/ropAhQ5W
         Vecx4GT2UEtyvZ3CScC39ICIoNSO2KV/WNmeVek5nP/1bqlSdxwgm0px4/JEfxReZ1DK
         FgB19LwmIag/w6wDetQDtAXhs/aSRbg+PQMvdGAFepkfW6WhB/E7/8ARlh0yT+vmepVo
         jJsuvbq8DMhoYNXsddd17C1UD8CdXKE/phfs/uZIk65bsJjPH3l5x1e1MT7YpjQFCXAI
         djJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GzDk+luyRLHl3xZFm7QpNCudAsNmIQ+Am0n1E/HJhLo=;
        b=E/n/YvlBPXKCWeTkB8vb2dCy+Cp7A36tAllF0A7TS2yqjF2WiAydecs0YGTfCt2RlY
         d3PINHJ9zHylngxkN37wjNzHkXKhAfG+BTEQOy60rvWMfL0YOZ+ZkEEgRqc60qcOBX0h
         CB1shQqgo3LHhvDgfWcfPIrFIYyoTn581Q1gZRh2fSNYqYb5hpsIKJ6oyI/OQceZVisq
         Yu/JvNrB12bRWgsDoulazaRC1bFsJ2q04QHfcGtKMCnSgCstUpGuatMH15bGA2mktkvn
         p/YjOTO3lBP2Y8cX9838xvu/fcCeaSU83OZsQUW/zXKcHz0OBzOYVuNUl1fPyDAta9qj
         doWA==
X-Gm-Message-State: AOAM531H2TX6FuSqrgFMHdw/SIeHuoVT+acakrSraASDXmezOQhhcdF1
        Mr8pBOq69ZDjLRcv1esLFgll9nHdA9NL6fDvh70=
X-Google-Smtp-Source: ABdhPJz0yHw1mhwGUtJM0qFX5wVSQ1xVhW7gyDp2iRE23DpMRuM5BcjgW6dduNsWJP8n1KvazdDUB0nfl5y5pAJhLKI=
X-Received: by 2002:a19:5513:: with SMTP id n19mr6565237lfe.313.1618013314971;
 Fri, 09 Apr 2021 17:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210308230735.337-1-lsahlber@redhat.com> <20210308230735.337-3-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-3-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 19:08:24 -0500
Message-ID: <CAH2r5mv+QQOC41ro4J_BwNmn1kAZhntJOzhLQFLkPDrJTVpaSg@mail.gmail.com>
Subject: Re: [PATCH 2/9] cifs: pass a path to open_shroot and check if it is
 the root or not
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Similar checkpatch complaint about ENOTSUPP (instead of EOPNOTSUPP)

WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
#74: FILE: fs/cifs/smb2ops.c:754:
+ return -ENOTSUPP;

the header which defines ENOTSUPP notes:

/*
 * These should never be seen by user programs.  To return one of ERESTART*
 * codes, signal_pending() MUST be set.  Note that ptrace can observe these
 * at syscall exit tracing, but they will never be left for the debugged user
 * process to see.
 */

On Mon, Mar 8, 2021 at 5:07 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Move the check for the directory path into the open_shroot() function
> but still fail for any non-root directories.
> This is preparation for later when we will start using the cache also
> for other directories than the root.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 22 ++++++++++------------
>  fs/cifs/smb2ops.c   |  6 +++++-
>  fs/cifs/smb2proto.h |  1 +
>  3 files changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 3d59614cbe8f..67f80c9561fc 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -523,22 +523,20 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         /* If it is a root and its handle is cached then use it */
> -       if (!strlen(full_path)) {
> -               rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> -               if (!rc) {
> -                       if (tcon->crfid.file_all_info_is_valid) {
> -                               move_smb2_info_to_cifs(data,
> +       rc = open_shroot(xid, tcon, full_path, cifs_sb, &cfid);
> +       if (!rc) {
> +               if (tcon->crfid.file_all_info_is_valid) {
> +                       move_smb2_info_to_cifs(data,
>                                                &tcon->crfid.file_all_info);
> -                       } else {
> -                               rc = SMB2_query_info(xid, tcon,
> +               } else {
> +                       rc = SMB2_query_info(xid, tcon,
>                                              cfid->fid->persistent_fid,
>                                              cfid->fid->volatile_fid, smb2_data);
> -                               if (!rc)
> -                                       move_smb2_info_to_cifs(data, smb2_data);
> -                       }
> -                       close_shroot(cfid);
> -                       goto out;
> +                       if (!rc)
> +                               move_smb2_info_to_cifs(data, smb2_data);
>                 }
> +               close_shroot(cfid);
> +               goto out;
>         }
>
>         cifs_get_readable_path(tcon, full_path, &cfile);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 7ee6926153b8..96ff946674e6 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -728,6 +728,7 @@ smb2_cached_lease_break(struct work_struct *work)
>   * Open the directory at the root of a share
>   */
>  int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
> +               const char *path,
>                 struct cifs_sb_info *cifs_sb,
>                 struct cached_fid **cfid)
>  {
> @@ -749,6 +750,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
>         if (tcon->nohandlecache)
>                 return -ENOTSUPP;
>
> +       if (strlen(path))
> +               return -ENOTSUPP;
> +
>         mutex_lock(&tcon->crfid.fid_mutex);
>         if (tcon->crfid.is_valid) {
>                 cifs_dbg(FYI, "found a cached root file handle\n");
> @@ -926,7 +930,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         oparms.fid = &fid;
>         oparms.reconnect = false;
>
> -       rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> +       rc = open_shroot(xid, tcon, "", cifs_sb, &cfid);
>         if (rc == 0)
>                 memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
>         else
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 9565e27681a5..7e4fc69c8b01 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -70,6 +70,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
>                                  struct mid_q_entry *mid);
>
>  extern int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
> +                      const char *path,
>                        struct cifs_sb_info *cifs_sb,
>                        struct cached_fid **cfid);
>  extern void close_shroot(struct cached_fid *cfid);
> --
> 2.13.6
>


-- 
Thanks,

Steve
