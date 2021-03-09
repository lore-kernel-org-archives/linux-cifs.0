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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B9DC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E32464F7C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhCIAjj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhCIAj2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 19:39:28 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB5EC06174A
        for <linux-cifs@vger.kernel.org>; Mon,  8 Mar 2021 16:39:28 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id u20so12043333iot.9
        for <linux-cifs@vger.kernel.org>; Mon, 08 Mar 2021 16:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EWIC9IY/Jo12De6B8+UZGdzhcQIwFVUNJQXNbVPlZvc=;
        b=emF5fDyS6rMozAd6hg5NhY/hbJcKQUTm/iQo3J0hBKVEs/Z69feC1bKQA5khrssGHP
         0JxfmhIMtou4XiVXnHLCjcoH6X7ujSGpV1C4+sfFu4KbOcwxkSHDAoOOpgeMfl6OjP6s
         0XiMNCIPxAh155RtdFNGVv5LT06wbcOpWI2CaMjeUbvBkrFQPRIhITaSLcdT2FSjMwjP
         ruKgYyDHRio9fDteOvkSnlYLBrW+1KasFJDGj5gOwHqw4lZxUSFaWvAZPyKzZD29qlrR
         BgfjQDGOVVugEwApdV4faXsMS/RIKoCrV6oNa5rbGTxMv+a1t0Fy8eDsswav5ZjtgFtp
         aHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EWIC9IY/Jo12De6B8+UZGdzhcQIwFVUNJQXNbVPlZvc=;
        b=azCd4VWqGcUk74jZvtGaeah9InIPDAtdIJbVtJUEbAUw92LZS0I95pR3TyRgRXIZY5
         DhLZzzyH3dqmNWt5HzdGbrnQ4pJH7SHDs1EEGSRQvuCTM+Ol8dyq2mHf8ToUn9xp1mAi
         o8JtPCQvmu+j7zDNym0j6Nq6CHSqFyvkgeC7JSPntxg3aKJ5gVFhycly3ahpFKV5rITE
         0qEWK5Mwf66kDIDQ9Qca/oxVmFNfRxAmY1u1dPwsp8MB040veleheHJwnwp9ySN4Kr87
         U9ZEbLexlA1pJlVybqK1KGZ8VUtv0CFcaW7kBCmwyKQphTSdgXOTdFd2JMReTRYXLgeZ
         RMrw==
X-Gm-Message-State: AOAM530dVb/qbeIuwmibjXVbnM3BpJM2XJcfu80nolUjkUtbM3yj2F5n
        tnmfw7nRkJw2kUbSZkZZOIuGzIIaffwG6RcXy6vX/Dnj
X-Google-Smtp-Source: ABdhPJy779HQw6hNJ/kdrcL0n3/d5tyGHser+TBYAb+4AjeuMSBiAMdT2Gyw7TsfrXgUiRieyW8+L8sC3KDXUfKN8L8=
X-Received: by 2002:a02:7410:: with SMTP id o16mr26338992jac.37.1615250368089;
 Mon, 08 Mar 2021 16:39:28 -0800 (PST)
MIME-Version: 1.0
References: <20210308150050.19902-1-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-1-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 9 Mar 2021 10:39:17 +1000
Message-ID: <CAN05THQSDRuORY1PT4=iJpRFNBXO8SpnPku00oJ1iY_rhF_XYg@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: print MIDs in decimal notation
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Tue, Mar 9, 2021 at 1:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> The MIDs are mostly printed as decimal, so let's make it consistent.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifs_debug.c | 2 +-
>  fs/cifs/connect.c    | 4 ++--
>  fs/cifs/smb2misc.c   | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 3aedc484e440..88a7958170ee 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -207,7 +207,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
>                                                 from_kuid(&init_user_ns, cfile->uid),
>                                                 cfile->dentry);
>  #ifdef CONFIG_CIFS_DEBUG2
> -                                       seq_printf(m, " 0x%llx\n", cfile->fid.mid);
> +                                       seq_printf(m, " %llu\n", cfile->fid.mid);
>  #else
>                                         seq_printf(m, "\n");
>  #endif /* CIFS_DEBUG2 */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 68642e3d4270..eec8a2052da2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -741,7 +741,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                 spin_lock(&GlobalMid_Lock);
>                 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                         mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> -                       cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
> +                       cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
>                         kref_get(&mid_entry->refcount);
>                         mid_entry->mid_state = MID_SHUTDOWN;
>                         list_move(&mid_entry->qhead, &dispose_list);
> @@ -752,7 +752,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                 /* now walk dispose list and issue callbacks */
>                 list_for_each_safe(tmp, tmp2, &dispose_list) {
>                         mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> -                       cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
> +                       cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
>                         list_del_init(&mid_entry->qhead);
>                         mid_entry->callback(mid_entry);
>                         cifs_mid_q_entry_release(mid_entry);
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 3ea3bda64083..0a55a77d94de 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -767,7 +767,7 @@ smb2_cancelled_close_fid(struct work_struct *work)
>         int rc;
>
>         if (cancelled->mid)
> -               cifs_tcon_dbg(VFS, "Close unmatched open for MID:%llx\n",
> +               cifs_tcon_dbg(VFS, "Close unmatched open for MID:%llu\n",
>                               cancelled->mid);
>         else
>                 cifs_tcon_dbg(VFS, "Close interrupted close\n");
> --
> 2.30.1
>
