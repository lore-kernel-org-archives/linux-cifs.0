Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2394C43334
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jul 2022 03:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiGUDGJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Jul 2022 23:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiGUDGG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Jul 2022 23:06:06 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E82E098
        for <linux-cifs@vger.kernel.org>; Wed, 20 Jul 2022 20:06:01 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id e19so250519uaa.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Jul 2022 20:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OnOItDFNUN9nv1loevdXS70ygCe9ByNVyVTJBt89gWo=;
        b=Fq+ByYwNlc3NvxDrmyVn9m3va6C3bWBw+2cXHEGUYubMv6NN6RXEzO2+Anrn8Ovf1j
         pGocxU5YGHvGAs05GR2x8MzFzhQjxc1tG1i/5gdgVb37VPsxa4FCz1EaITijxikemi5I
         9YTfxedpeFHqlFSiUtFIO1XEOY35Pkzm1kYdSgxaQIRFlUGILdyK7kqNEDPez+T9TC5y
         wm5mAXW7XT2FgEjFboSoNcHuteDFFv5fPZkoeC/r4qKL0Md683YUTrCF6ACnD2pJYge9
         ey0KHcF71A2EIs7/Hrv/PSU69mYj1Gkdg1bolQnFRuDbLqg5yrtthpLMPVoEvD76xNMq
         sfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OnOItDFNUN9nv1loevdXS70ygCe9ByNVyVTJBt89gWo=;
        b=Rkl1E/SkTXf+3VsYfsl7bw+etQTisqP4jpB6RMEY7idjzkA4RxCt95ZDeP6ZilxJew
         4YGS9UYqXei6eQUQcmCKqcThKmKV11vf4jS8BZcIhmXtk39orXkpcrA9xZvX4oyvwzaE
         VI897Tk0iX3dEpymkFx928o1qp/d+dVyWfSfC6JuqDe5vWB+1cQiTRziQ9QVyLdndx/z
         Tz4ZQiaeGKaBAxsSNdKSexvzdC0KfBPIDnWB2Jv5Ky0XquxBIQaWa6LPb8o7Svk918nv
         GqpkqIRAJnJodMito2pj0jMu4WnW3UK4h30p5s/5Ln75Lk3MpaUJ9wQghIp7FcykCS4K
         FoJw==
X-Gm-Message-State: AJIora8Yu4pExxatJwSbfAhGtokwojLQnDCpOitrw2PCrikGAzqDEoN6
        oWqE1Ylea6SEc+P/+dXfifuvgdYlN2xP8XGdPhM=
X-Google-Smtp-Source: AGRyM1s5TZuYyMjMX4IqA7AvDCIxEv7wQceNOUfatrLiKWtJ0ONLHhllQfUEzSzGUXlE2Iu6RemPPxJxOWEsCAAj+Xs=
X-Received: by 2002:ab0:3bc6:0:b0:381:c4db:ef5 with SMTP id
 q6-20020ab03bc6000000b00381c4db0ef5mr16181857uaw.81.1658372760249; Wed, 20
 Jul 2022 20:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220719173151.12068-1-ematsumiya@suse.de> <20220719173151.12068-2-ematsumiya@suse.de>
In-Reply-To: <20220719173151.12068-2-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Jul 2022 22:05:49 -0500
Message-ID: <CAH2r5msRkJLLL2my8PstV=MatuY-6dWmqmEZFEuJq-mfRDz7qQ@mail.gmail.com>
Subject: Re: [PATCH] smb2: small refactor in smb2_check_message()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't have any objections to this but wondering what prompted the
patch? Did you see an error logged with ioctls? You mention:

"SMB2_IOCTL, OutputLength and OutputContext are optional and can be zero"

And did you want to change the pr_warn_once to a pr_warn on the
mismatch since you had a case where server was frequently returning
frame with bad length and you want to debug it?
I am a little worried that it could cause log spam if some server has
a bug in smb3 response length.

On Tue, Jul 19, 2022 at 12:32 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> If the command is SMB2_IOCTL, OutputLength and OutputContext are
> optional and can be zero, so return early and skip calculated length
> check.
>
> Move the mismatched length message to the end of the check, to avoid
> unnecessary logs when the check was not a real miscalculation.
>
> Also change the pr_warn_once() to a pr_warn() so we're sure to get a
> log for the real mismatches.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/connect.c  | 13 ++++++-------
>  fs/cifs/smb2misc.c | 47 +++++++++++++++++++++++++++-------------------
>  2 files changed, 34 insertions(+), 26 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 386bb523c69e..057237c9cb30 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1039,19 +1039,18 @@ int
>  cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  {
>         char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
> -       int length;
> +       int rc;
>
>         /*
>          * We know that we received enough to get to the MID as we
>          * checked the pdu_length earlier. Now check to see
> -        * if the rest of the header is OK. We borrow the length
> -        * var for the rest of the loop to avoid a new stack var.
> +        * if the rest of the header is OK.
>          *
>          * 48 bytes is enough to display the header and a little bit
>          * into the payload for debugging purposes.
>          */
> -       length = server->ops->check_message(buf, server->total_read, server);
> -       if (length != 0)
> +       rc = server->ops->check_message(buf, server->total_read, server);
> +       if (rc)
>                 cifs_dump_mem("Bad SMB: ", buf,
>                         min_t(unsigned int, server->total_read, 48));
>
> @@ -1066,9 +1065,9 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>                 return -1;
>
>         if (!mid)
> -               return length;
> +               return rc;
>
> -       handle_mid(mid, server, buf, length);
> +       handle_mid(mid, server, buf, rc);
>         return 0;
>  }
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 17813c3d0c6e..562064fe9668 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -132,15 +132,15 @@ static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
>  }
>
>  int
> -smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
> +smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
>  {
>         struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
>         struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
> -       __u64 mid;
> -       __u32 clc_len;  /* calculated length */
> -       int command;
> -       int pdu_size = sizeof(struct smb2_pdu);
>         int hdr_size = sizeof(struct smb2_hdr);
> +       int pdu_size = sizeof(struct smb2_pdu);
> +       int command;
> +       __u32 calc_len; /* calculated length */
> +       __u64 mid;
>
>         /*
>          * Add function to do table lookup of StructureSize by command
> @@ -154,7 +154,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
>
>                 /* decrypt frame now that it is completely read in */
>                 spin_lock(&cifs_tcp_ses_lock);
> -               list_for_each_entry(iter, &srvr->smb_ses_list, smb_ses_list) {
> +               list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
>                         if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
>                                 ses = iter;
>                                 break;
> @@ -221,30 +221,33 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
>                 }
>         }
>
> -       clc_len = smb2_calc_size(buf, srvr);
> +       calc_len = smb2_calc_size(buf, server);
> +
> +       /* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
> +        * be 0, and not a real miscalculation */
> +       if (command == SMB2_IOCTL_HE && calc_len == 0)
> +               return 0;
>
> -       if (shdr->Command == SMB2_NEGOTIATE)
> -               clc_len += get_neg_ctxt_len(shdr, len, clc_len);
> +       if (command == SMB2_NEGOTIATE_HE)
> +               calc_len += get_neg_ctxt_len(shdr, len, calc_len);
>
> -       if (len != clc_len) {
> -               cifs_dbg(FYI, "Calculated size %u length %u mismatch mid %llu\n",
> -                        clc_len, len, mid);
> +       if (len != calc_len) {
>                 /* create failed on symlink */
>                 if (command == SMB2_CREATE_HE &&
>                     shdr->Status == STATUS_STOPPED_ON_SYMLINK)
>                         return 0;
>                 /* Windows 7 server returns 24 bytes more */
> -               if (clc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
> +               if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
>                         return 0;
>                 /* server can return one byte more due to implied bcc[0] */
> -               if (clc_len == len + 1)
> +               if (calc_len == len + 1)
>                         return 0;
>
>                 /*
>                  * Some windows servers (win2016) will pad also the final
>                  * PDU in a compound to 8 bytes.
>                  */
> -               if (((clc_len + 7) & ~7) == len)
> +               if (((calc_len + 7) & ~7) == len)
>                         return 0;
>
>                 /*
> @@ -253,12 +256,18 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
>                  * SMB2/SMB3 frame length (header + smb2 response specific data)
>                  * Some windows servers also pad up to 8 bytes when compounding.
>                  */
> -               if (clc_len < len)
> +               if (calc_len < len)
>                         return 0;
>
> -               pr_warn_once(
> -                       "srv rsp too short, len %d not %d. cmd:%d mid:%llu\n",
> -                       len, clc_len, command, mid);
> +               /* Only log a message if len was really miscalculated */
> +               if (unlikely(cifsFYI))
> +                       cifs_dbg(FYI, "Server response too short: calculated "
> +                                "length %u doesn't match read length %u (cmd=%d, mid=%llu)\n",
> +                                calc_len, len, command, mid);
> +               else
> +                       pr_warn("Server response too short: calculated length "
> +                               "%u doesn't match read length %u (cmd=%d, mid=%llu)\n",
> +                               calc_len, len, command, mid);
>
>                 return 1;
>         }
> --
> 2.35.3
>


-- 
Thanks,

Steve
