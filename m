Return-Path: <SRS0=xLh5=AN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B3C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 00:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB6B62085B
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 00:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfUPJ/5w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgGBAxS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jul 2020 20:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgGBAxR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jul 2020 20:53:17 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2088C08C5C1
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2020 17:53:17 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s1so12890115ybo.7
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2020 17:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FnSnwXSG+KhHDJFrEPDCjVR//EMNezuwKnzwfS8+Yu4=;
        b=AfUPJ/5wj9L62gprRn7wtimyT8IJ+Bgd50RMgiEpQUssdr7g+4C7Tg9CCImEbMwTTx
         hvUnXY0RhP3yGtvuht6h5hYbmmvoaLZYu91Ws9zilJiYOjIKx6ITuIoGnJN+BO3vm2Kp
         O5UQp+dwqcaBOBMH+yNLC76PSKoeynIASpBfqcKvJExsmMY3At0uivkm2h+ohuwIWFoh
         sshH5Tpym11I1LCt265qf04fReMSYHE6hYxdo0f1rzPXlRSBG+QZqyhPIK6U9+4HRcf9
         //6F+xMg/NMtIA/icGHxsJoCPrwv5m77ig3Z5Ctf2agVAuP/6oJoEeEz6ekUiB2VjkUc
         bu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FnSnwXSG+KhHDJFrEPDCjVR//EMNezuwKnzwfS8+Yu4=;
        b=fgQf6Ra7GaJDFCxklhQz+b1tUqLdWii2kan1n/UhwnoZLxSzTDSq+NHXQc3DGtJeFj
         htrJ6Un5cqhQiT19PbyUl3liryQ4+nHrRVHMFI+P05vVOE9m5GeQ8Gp0Trl2mwgpLOHN
         v2Q9jrAMBDCyUD3o60OUcmIE2gMXqjmVn7ED72owDhjrzX/i7dYdErRIOqHn9WE/RRdI
         wEStakXq/17YfpW4jYHtNbNLrnA+1zRHqig99n9SmpJnGKJ+inFHr/ZKCN8n+Qc5sAuQ
         4dPApX3BObpRgxye0M9OJCli63ycHsvOgx6BciKN+rkYmHoD1fTwT1+2S/fEnF6Bpoi7
         GENg==
X-Gm-Message-State: AOAM530/8QgOqBjvm6+9AOk/YPMbXKLBfFlA6+xmlPnGTKcFiN6KylNr
        Aj0s3t3pV5EGOC/jMRkwmf84ymcbSd9mHoCDAAEC/8UwWV0=
X-Google-Smtp-Source: ABdhPJxliEORdx4EVK24Bxx1gSoiMI38mcH5VF/qB5xa/EThIvnQRTuVOet/CAQzg/30YLMThcOvBxdlFNNppf9IGpI=
X-Received: by 2002:a25:bc81:: with SMTP id e1mr44434480ybk.375.1593651196813;
 Wed, 01 Jul 2020 17:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200630023003.1858066-1-paul@darkrain42.org>
In-Reply-To: <20200630023003.1858066-1-paul@darkrain42.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 1 Jul 2020 19:53:05 -0500
Message-ID: <CAH2r5mtEaYtdNNzGCrXcyxKTi=w_KoDhruc2pV5Je253yOHEDQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Fix leak when handling lease break for cached
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

I get the following sparse warning compiling this patch (make C=1 -C
/usr/src/linux-headers-`uname -r` M=`pwd` modules
CF=-D__CHECK_ENDIAN__)

  CHECK   /home/smfrench/cifs-2.6/fs/cifs/smb2misc.c
/home/smfrench/cifs-2.6/fs/cifs/smb2misc.c:542:24: warning: context
imbalance in 'smb2_tcon_has_lease' - unexpected unlock
/home/smfrench/cifs-2.6/fs/cifs/smb2misc.c:594:1: warning: context
imbalance in 'smb2_is_valid_lease_break' - wrong count at exit
  CC [M]  /home/smfrench/cifs-2.6/fs/cifs/smb2misc.o

On Mon, Jun 29, 2020 at 9:30 PM Paul Aurich <paul@darkrain42.org> wrote:
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
>  fs/cifs/smb2misc.c | 47 ++++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 6a39451973f8..570c0521fc3c 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -505,8 +505,7 @@ cifs_ses_oplock_break(struct work_struct *work)
>  }
>
>  static bool
> -smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
> -                   struct smb2_lease_break_work *lw)
> +smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
>  {
>         bool found;
>         __u8 lease_state;
> @@ -516,9 +515,13 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>         struct cifsInodeInfo *cinode;
>         int ack_req = le32_to_cpu(rsp->Flags &
>                                   SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
> +       struct smb2_lease_break_work *lw;
> +       struct tcon_link *tlink;
> +       __u8 lease_key[SMB2_LEASE_KEY_SIZE];
>
>         lease_state = le32_to_cpu(rsp->NewLeaseState);
>
> +       spin_lock(&tcon->open_file_lock);
>         list_for_each(tmp, &tcon->openFileList) {
>                 cfile = list_entry(tmp, struct cifsFileInfo, tlist);
>                 cinode = CIFS_I(d_inode(cfile->dentry));
> @@ -542,7 +545,8 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>                 cfile->oplock_level = lease_state;
>
>                 cifs_queue_oplock_break(cfile);
> -               kfree(lw);
> +               spin_unlock(&tcon->open_file_lock);
> +               spin_unlock(&cifs_tcp_ses_lock);
>                 return true;
>         }
>
> @@ -554,10 +558,9 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>
>                 if (!found && ack_req) {
>                         found = true;
> -                       memcpy(lw->lease_key, open->lease_key,
> +                       memcpy(lease_key, open->lease_key,
>                                SMB2_LEASE_KEY_SIZE);
> -                       lw->tlink = cifs_get_tlink(open->tlink);
> -                       queue_work(cifsiod_wq, &lw->lease_break);
> +                       tlink = cifs_get_tlink(open->tlink);
>                 }
>
>                 cifs_dbg(FYI, "found in the pending open list\n");
> @@ -567,6 +570,23 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>                 open->oplock = lease_state;
>         }
>
> +       spin_unlock(&tcon->open_file_lock);
> +       if (found) {
> +               spin_unlock(&cifs_tcp_ses_lock);
> +
> +               lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
> +               if (!lw) {
> +                       cifs_put_tlink(tlink);
> +                       return true;
> +               }
> +
> +               INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
> +               lw->tlink = tlink;
> +               lw->lease_state = rsp->NewLeaseState;
> +               memcpy(lw->lease_key, lease_key, SMB2_LEASE_KEY_SIZE);
> +               queue_work(cifsiod_wq, &lw->lease_break);
> +       }
> +
>         return found;
>  }
>
> @@ -578,14 +598,6 @@ smb2_is_valid_lease_break(char *buffer)
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
>
>         cifs_dbg(FYI, "Checking for lease break\n");
>
> @@ -600,15 +612,11 @@ smb2_is_valid_lease_break(char *buffer)
>                         list_for_each(tmp2, &ses->tcon_list) {
>                                 tcon = list_entry(tmp2, struct cifs_tcon,
>                                                   tcon_list);
> -                               spin_lock(&tcon->open_file_lock);
>                                 cifs_stats_inc(
>                                     &tcon->stats.cifs_stats.num_oplock_brks);
> -                               if (smb2_tcon_has_lease(tcon, rsp, lw)) {
> -                                       spin_unlock(&tcon->open_file_lock);
> -                                       spin_unlock(&cifs_tcp_ses_lock);
> +                               if (smb2_tcon_has_lease(tcon, rsp)) {
>                                         return true;
>                                 }
> -                               spin_unlock(&tcon->open_file_lock);
>
>                                 if (tcon->crfid.is_valid &&
>                                     !memcmp(rsp->LeaseKey,
> @@ -625,7 +633,6 @@ smb2_is_valid_lease_break(char *buffer)
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
