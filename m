Return-Path: <SRS0=3VLN=AW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFED0C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jul 2020 16:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3BE20786
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jul 2020 16:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JD0sVUbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgGKQlj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Jul 2020 12:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKQlj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 11 Jul 2020 12:41:39 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7A1C08C5DD
        for <linux-cifs@vger.kernel.org>; Sat, 11 Jul 2020 09:41:38 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x9so4261817ybd.4
        for <linux-cifs@vger.kernel.org>; Sat, 11 Jul 2020 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QVEZwSimitIoKKBU/1PkUd547wwMMzOk2W/jcJeBTzc=;
        b=JD0sVUbPmPJtdUHzF0f98iNWZbS+OCUy3Sa5f8B5NGRQX9RMd2BXtPBy+gKXVw5pHP
         dXDVdl63LPHSu6JSUiuD2ccsWzrqY+pADjV0Zyds0Z6SBioPB4Ml1pH+dPpyZiR3k0Jz
         V9AkEjQZeXlsy1dRLa4zl9+88VfFwiw6WbkQgl44xmBjDcrsoZ83HB7J5Hn2ELrTAYkP
         TiM2+UBABiq9GbvXUi5gARCMFhHefFiR+xOEQnvABGv/nKnKhYju/0fIxfTLKNeOlYp6
         6bYawRjVO/AaIbzfzer0PP9xDfA6jC0wfXXZCvGVdJSCn67996sGlJ4f41X9eMwyi5z8
         hLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QVEZwSimitIoKKBU/1PkUd547wwMMzOk2W/jcJeBTzc=;
        b=mwyQ+/AIpW8NJ6+0OmnmhX0otHEwmjF8h3tnXN8n7K5Ret0vGU1r82ztXw4evhlHsz
         mlOOjerwmxWE7qi1CtlB/zY8W4uLGJpUp/8b/y0Dq5TN1nCCgYA9YR+XUsLyNsUJtUPt
         R/bNrTpfxElK3oMHXE3RYx1XJBAZWVnSYRjUraJb4lsq8xnSeGM/iqP5+UCs7EbkdH+4
         nPrgyvQx8nAELN6aAfVVzynArJ5uScm+eS9BA3Ok8cczj2lqHaT/4Ov7aQDoFM8Y4QwL
         2ZlllJoUfEwaFA4JuzHflx4Jemxww5GP8FjmECYmLKltyGsIG4Czf/yBkNkOIQNtE4IB
         GaoQ==
X-Gm-Message-State: AOAM532h2uZGa/dRqFLtcycaQdlrG2kIxSNCvRzq3r8ZeP0uys3FXrQQ
        yEdEzzwA3sBHtFevodD/zM6/mDus9OXB2i7DCQ8=
X-Google-Smtp-Source: ABdhPJzrw9tjUSSRj5mA4SVFNdIyoO5KxjuEPQnvyASdV8tzTmWxsWpt12bCqKWlW++sysX+ddqYXS7XdASiW5ZCDIY=
X-Received: by 2002:a25:23c7:: with SMTP id j190mr54490271ybj.167.1594485697608;
 Sat, 11 Jul 2020 09:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200710050116.623540-1-paul@darkrain42.org>
In-Reply-To: <20200710050116.623540-1-paul@darkrain42.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 11 Jul 2020 11:41:26 -0500
Message-ID: <CAH2r5muo=Z63jP0045u0O=pnE9mc2uwMy13_g4fsKx3Stw0-6g@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: Fix leak when handling lease break for cached
 root fid
To:     Paul Aurich <paul@darkrain42.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending review and testing

On Fri, Jul 10, 2020 at 12:01 AM Paul Aurich <paul@darkrain42.org> wrote:
>
> Handling a lease break for the cached root didn't free the
> smb2_lease_break_work allocation, resulting in a leak:
>
>     unreferenced object 0xffff98383a5af480 (size 128):
>       comm "cifsd", pid 684, jiffies 4294936606 (age 534.868s)
>       hex dump (first 32 bytes):
>         c0 ff ff ff 1f 00 00 00 88 f4 5a 3a 38 98 ff ff  ..........Z:8...
>         88 f4 5a 3a 38 98 ff ff 80 88 d6 8a ff ff ff ff  ..Z:8...........
>       backtrace:
>         [<0000000068957336>] smb2_is_valid_oplock_break+0x1fa/0x8c0
>         [<0000000073b70b9e>] cifs_demultiplex_thread+0x73d/0xcc0
>         [<00000000905fa372>] kthread+0x11c/0x150
>         [<0000000079378e4e>] ret_from_fork+0x22/0x30
>
> Avoid this leak by only allocating when necessary.
>
> Fixes: a93864d93977 ("cifs: add lease tracking to the cached root fid")
> Signed-off-by: Paul Aurich <paul@darkrain42.org>
> CC: Stable <stable@vger.kernel.org> # v4.18+
> ---
> Changes from v3:
>   - refactor pending open lease handling into separate functions so that the
>     core spinlock handling can occur all in smb2_is_valid_lease_break
>
>  fs/cifs/smb2misc.c | 73 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 52 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 6a39451973f8..865cd248c605 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -504,15 +504,31 @@ cifs_ses_oplock_break(struct work_struct *work)
>         kfree(lw);
>  }
>
> +static void
> +smb2_queue_pending_open_break(struct tcon_link *tlink, __u8 *lease_key,
> +                             __le32 new_lease_state)
> +{
> +       struct smb2_lease_break_work *lw;
> +
> +       lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
> +       if (!lw) {
> +               cifs_put_tlink(tlink);
> +               return;
> +       }
> +
> +       INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
> +       lw->tlink = tlink;
> +       lw->lease_state = new_lease_state;
> +       memcpy(lw->lease_key, lease_key, SMB2_LEASE_KEY_SIZE);
> +       queue_work(cifsiod_wq, &lw->lease_break);
> +}
> +
>  static bool
> -smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
> -                   struct smb2_lease_break_work *lw)
> +smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
>  {
> -       bool found;
>         __u8 lease_state;
>         struct list_head *tmp;
>         struct cifsFileInfo *cfile;
> -       struct cifs_pending_open *open;
>         struct cifsInodeInfo *cinode;
>         int ack_req = le32_to_cpu(rsp->Flags &
>                                   SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
> @@ -542,22 +558,29 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>                 cfile->oplock_level = lease_state;
>
>                 cifs_queue_oplock_break(cfile);
> -               kfree(lw);
>                 return true;
>         }
>
> -       found = false;
> +       return false;
> +}
> +
> +static struct cifs_pending_open *
> +smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
> +                                 struct smb2_lease_break *rsp)
> +{
> +       __u8 lease_state = le32_to_cpu(rsp->NewLeaseState);
> +       int ack_req = le32_to_cpu(rsp->Flags &
> +                                 SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
> +       struct cifs_pending_open *open;
> +       struct cifs_pending_open *found = NULL;
> +
>         list_for_each_entry(open, &tcon->pending_opens, olist) {
>                 if (memcmp(open->lease_key, rsp->LeaseKey,
>                            SMB2_LEASE_KEY_SIZE))
>                         continue;
>
>                 if (!found && ack_req) {
> -                       found = true;
> -                       memcpy(lw->lease_key, open->lease_key,
> -                              SMB2_LEASE_KEY_SIZE);
> -                       lw->tlink = cifs_get_tlink(open->tlink);
> -                       queue_work(cifsiod_wq, &lw->lease_break);
> +                       found = open;
>                 }
>
>                 cifs_dbg(FYI, "found in the pending open list\n");
> @@ -578,14 +601,7 @@ smb2_is_valid_lease_break(char *buffer)
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
> -       struct smb2_lease_break_work *lw;
> -
> -       lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
> -       if (!lw)
> -               return false;
> -
> -       INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
> -       lw->lease_state = rsp->NewLeaseState;
> +       struct cifs_pending_open *open;
>
>         cifs_dbg(FYI, "Checking for lease break\n");
>
> @@ -603,11 +619,27 @@ smb2_is_valid_lease_break(char *buffer)
>                                 spin_lock(&tcon->open_file_lock);
>                                 cifs_stats_inc(
>                                     &tcon->stats.cifs_stats.num_oplock_brks);
> -                               if (smb2_tcon_has_lease(tcon, rsp, lw)) {
> +                               if (smb2_tcon_has_lease(tcon, rsp)) {
>                                         spin_unlock(&tcon->open_file_lock);
>                                         spin_unlock(&cifs_tcp_ses_lock);
>                                         return true;
>                                 }
> +                               open = smb2_tcon_find_pending_open_lease(tcon,
> +                                                                        rsp);
> +                               if (open) {
> +                                       __u8 lease_key[SMB2_LEASE_KEY_SIZE];
> +                                       struct tcon_link *tlink;
> +
> +                                       tlink = cifs_get_tlink(open->tlink);
> +                                       memcpy(lease_key, open->lease_key,
> +                                              SMB2_LEASE_KEY_SIZE);
> +                                       spin_unlock(&tcon->open_file_lock);
> +                                       spin_unlock(&cifs_tcp_ses_lock);
> +                                       smb2_queue_pending_open_break(tlink,
> +                                                                     lease_key,
> +                                                                     rsp->NewLeaseState);
> +                                       return true;
> +                               }
>                                 spin_unlock(&tcon->open_file_lock);
>
>                                 if (tcon->crfid.is_valid &&
> @@ -625,7 +657,6 @@ smb2_is_valid_lease_break(char *buffer)
>                 }
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
> -       kfree(lw);
>         cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
>         return false;
>  }
> --
> 2.27.0
>


-- 
Thanks,

Steve
