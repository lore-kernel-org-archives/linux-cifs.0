Return-Path: <SRS0=1BtU=ID=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC68C433E6
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 16:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B7464F4C
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 16:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhCEQIa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Mar 2021 11:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhCEQIW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Mar 2021 11:08:22 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CCEC061574
        for <linux-cifs@vger.kernel.org>; Fri,  5 Mar 2021 08:08:22 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id b1so4492109lfb.7
        for <linux-cifs@vger.kernel.org>; Fri, 05 Mar 2021 08:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VEZFbkqhVR6IQ4iJbS3/eIoNfdkbvHwlvFSaEGnGL5Q=;
        b=j4Gd/SzEEuOFTNQiKeDmA0kMq4xtTlUFBrlROfX7iK6CEDhUITUhVu8+RoZLCoQo6z
         o9huhsQlreNE4RvO4HFL+///yzmArMhgsHygsd9UKfeejXVs72VlzbEH7Qh/UH6+M3EY
         iMYwouavcZ4CI6e85yVTpcw3IV1nCyO2lOpN81EKLrU9zkDLgIGoYWfHw3nOUmxEuNPL
         XJV0g8JxBl257lVEZDDY/RHqzyhCuiRHaNCCewB3Wwk2rLDoEr4tDNoukCK+Te0GWtZ+
         EHomvRyRxah7uCPiY2/cl128ViGnIobtcXj30sU6jQCkJ643+YkAGNyazVgL44dTfSqj
         r2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VEZFbkqhVR6IQ4iJbS3/eIoNfdkbvHwlvFSaEGnGL5Q=;
        b=rSgt5uG70ZeApe8OJI0KfQwcR6tivcqGuAGmZn2skIGXhUCGPjt1fGesfx8aXhSaS+
         exmKuc3Pu5mE3njIN/C/q4yEQM7C7E5+PP95S5k2fYTKGyWbPX05q25N6v0pCYn+iQXD
         Klxgno4b6XYLJYWzTjWz7NcAqYi5HtjyRqpJMUbU5UMpmpBJl7uPKMdCHz3HPW8/lPJ3
         bHOge5Ic2JDrlcchSx7x/oaXfFGDveV9X0ELA6ZQlbSRHh5uUxfUZec7GnilLuRKL0Hy
         QuxBZVQT2igSqkrxNV8PW78aZleLMb1Y6+lw3BzYG/PEDCiUl1vXTOtHEmUXwtoOkDuT
         /7FA==
X-Gm-Message-State: AOAM5316kkKR4S9/5ecqJNDWSA06+EbQq0sW41vLiBr1Bc3CVmVh1kZd
        NTIeAceeeaNRFuypt8DiNBJZ/0f7Y4raJDITOXMOwg5DUUnFVg==
X-Google-Smtp-Source: ABdhPJwFOdd0d0o+q3FNRYc3Ivn8Mz1726LSiDPKX/cgOuffBaNxKE5APGEzhhve4zQEuPCIDy5rbiFzFW7ZetD2Bsg=
X-Received: by 2002:a19:7515:: with SMTP id y21mr6196669lfe.282.1614960500741;
 Fri, 05 Mar 2021 08:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20210305142407.23652-1-aaptel@suse.com>
In-Reply-To: <20210305142407.23652-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Mar 2021 10:08:09 -0600
Message-ID: <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
Subject: Re: [PATCH] cifs: try to pick channel with a minimum of credits
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The comment caught my attention - is that accurate?  When a channel
has fewer than 3 credits (assuming we had two reserved for oplock and
echo), that doesn't mean that there are fewer than 3 credits in flight
- just that current credits available is lower right?  So the channel
could still recover as long as current credits + credits in flight is
at least 3.

+/*
+ * Min number of credits for a channel to be picked.
+ *
+ * Note that once a channel reaches this threshold it will never be
+ * picked again as no credits can be requested from it.
+ */
+#define CIFS_CHANNEL_MIN_CREDITS 3

On Fri, Mar 5, 2021 at 8:24 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Check channel credits to prevent the client from using a starved
> channel that cannot send anything.
>
> Special care must be taken in selecting the minimum value: when
> channels are created they start off with a small amount that slowly
> ramps up as the channel gets used. Thus a new channel might never be
> picked if the min value is too small.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/transport.c | 57 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 49 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e90a1d1380b0..7bb1584b3724 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -44,6 +44,14 @@
>  /* Max number of iovectors we can use off the stack when sending request=
s. */
>  #define CIFS_MAX_IOV_SIZE 8
>
> +/*
> + * Min number of credits for a channel to be picked.
> + *
> + * Note that once a channel reaches this threshold it will never be
> + * picked again as no credits can be requested from it.
> + */
> +#define CIFS_CHANNEL_MIN_CREDITS 3
> +
>  void
>  cifs_wake_up_task(struct mid_q_entry *mid)
>  {
> @@ -1051,20 +1059,53 @@ cifs_cancelled_callback(struct mid_q_entry *mid)
>  struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
>  {
>         uint index =3D 0;
> +       struct TCP_Server_Info *s;
>
>         if (!ses)
>                 return NULL;
>
> -       if (!ses->binding) {
> -               /* round robin */
> -               if (ses->chan_count > 1) {
> -                       index =3D (uint)atomic_inc_return(&ses->chan_seq)=
;
> -                       index %=3D ses->chan_count;
> -               }
> -               return ses->chans[index].server;
> -       } else {
> +       if (ses->binding)
>                 return cifs_ses_server(ses);
> +
> +       /*
> +        * Channels are created right after the session is made. The
> +        * count cannot change after that so it is not racy to check.
> +        */
> +       if (ses->chan_count =3D=3D 1)
> +               return ses->chans[index].server;
> +
> +       /* round robin */
> +       index =3D (uint)atomic_inc_return(&ses->chan_seq);
> +       index %=3D ses->chan_count;
> +       s =3D ses->chans[index].server;
> +
> +       /*
> +        * Checking server credits is racy, but getting a slightly
> +        * stale value should not be an issue here
> +        */
> +       if (s->credits <=3D CIFS_CHANNEL_MIN_CREDITS) {
> +               uint i;
> +
> +               cifs_dbg(VFS, "cannot pick conn_id=3D0x%llx not enough cr=
edits (%u)",
> +                        s->conn_id,
> +                        s->credits);
> +
> +               /*
> +                * Look at all other channels starting from the next
> +                * one and pick first possible channel.
> +                */
> +               for (i =3D 1; i < ses->chan_count; i++) {
> +                       s =3D ses->chans[(index+i) % ses->chan_count].ser=
ver;
> +                       if (s->credits > CIFS_CHANNEL_MIN_CREDITS)
> +                               return s;
> +               }
>         }
> +
> +       /*
> +        * If none are possible, keep the initially picked one, but
> +        * later on it will block to wait for credits or fail.
> +        */
> +       return ses->chans[index].server;
>  }
>
>  int
> --
> 2.30.0
>


--=20
Thanks,

Steve
