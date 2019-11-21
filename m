Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0E0C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 23:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EB4206D8
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 23:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9bU/MlE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKUXop (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 18:44:45 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42872 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfKUXop (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 18:44:45 -0500
Received: by mail-io1-f68.google.com with SMTP id k13so5681324ioa.9
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 15:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcHOJA7182xf8ESXiFWpKki3uwKUNY2dQoQC0QwJmbc=;
        b=i9bU/MlENAQIqO7idJFbWjm6n1T/tpd8rxuL/sNLUUwwtfnaNCmjDPlf0cWkXI0axr
         o06WBSLC37YAoA8tVlmlbB2war7X0bS4I/ocpYIsErP1NRws71DQoNrqv2QMGJsCJF7m
         rL+rM3kvQFTsrobmEj3yUE3fQc3JRIujxvpl+r/zC3V0wwBvzWszzHI/4RH1lVtLVkwY
         gI8eCSP0czJ29vHNTIVpcIkYqvKR5VAM3GusKzISQp/G0kF8fkffhUuSsyILJpco9Wv/
         aBQVNUZGdUak8PXb60SD+G0HIwVGqr7jjwlOZB5fzxwwcBPzkZUJJzEh2VUZWfZP1qnL
         myNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcHOJA7182xf8ESXiFWpKki3uwKUNY2dQoQC0QwJmbc=;
        b=tNBu+rieICdNMfZPMI+SYsbjPbPpaQGyFUrAijhsBaQuPP2R+VQlO5U51oBw9G6jki
         th7KfC/G8GC2OXCz9UCw8071dalX0kUHhzb/DNT5TSKWmfrnhsIVbsyZpBYw8UZziZT7
         HnHWUYg/v9m+mG2PQAeLuEgjO8O7OGT3+1PjeKXI2V4GGgxA3qshCrAnZ0ahmtUx5Z4Y
         7zC0zPr/SXXONKVhkNOOee4Io4mDcRj95QUboshzcu1Gd1U1EO3z1h7yjbtpVmmGG6GY
         kjNDK19Y0MkEje1H9Gn93mX10hncWSanhq+RvlPB4AHKHepOQTSJxJSdgaGMDj00ECOD
         szAQ==
X-Gm-Message-State: APjAAAUeqTg3tOw/l+Hidi4vsVx2NXQ6Xa6XFX70Vwx0SWWecr2NZTFs
        r7yyim+zBsOxx14xYzDjVwHikrVppnFHNFg7DrM=
X-Google-Smtp-Source: APXvYqzwZYNObnBz6ZeW4WjMD54kuzVaEfz1l6+aQSohdYsKtgowt1ZITbta48WoEJOGHA0AcA6v0DYrQ9sBD0xJsXI=
X-Received: by 2002:a5d:8a19:: with SMTP id w25mr2708952iod.137.1574379884522;
 Thu, 21 Nov 2019 15:44:44 -0800 (PST)
MIME-Version: 1.0
References: <20191120161559.30295-1-aaptel@suse.com>
In-Reply-To: <20191120161559.30295-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Nov 2019 17:44:33 -0600
Message-ID: <CAH2r5mtzJLQw9X-rqYMipppXN99iWqPwjiGdPoqJMx+vukXMQw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: dump channel info in DebugData
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This wouldn't build due to CONFIG_CIFS_STATS2 but I merged it and
fixed the build break by adding a followon patch which enables in_send
and num_waiters by default (not requiring CONFIG_CIFS_STATS2 for those
two counters)

On Wed, Nov 20, 2019 at 10:16 AM Aurelien Aptel <aaptel@suse.com> wrote:
>
> * show server&TCP states for extra channels
> * mention if an interface has a channel connected to it
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifs_debug.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index efb2928ff6c8..c2dd07903d56 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -121,6 +121,27 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
>         seq_putc(m, '\n');
>  }
>
> +static void
> +cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
> +{
> +       struct TCP_Server_Info *server = chan->server;
> +
> +       seq_printf(m, "\t\tChannel %d Number of credits: %d Dialect 0x%x "
> +                  "TCP status: %d Instance: %d Local Users To Server: %d "
> +                  "SecMode: 0x%x Req On Wire: %d In Send: %d "
> +                  "In MaxReq Wait: %d\n",
> +                  i+1,
> +                  server->credits,
> +                  server->dialect,
> +                  server->tcpStatus,
> +                  server->reconnect_instance,
> +                  server->srv_count,
> +                  server->sec_mode,
> +                  in_flight(server),
> +                  atomic_read(&server->in_send),
> +                  atomic_read(&server->num_waiters));
> +}
> +
>  static void
>  cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
>  {
> @@ -377,6 +398,13 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>                         if (ses->sign)
>                                 seq_puts(m, " signed");
>
> +                       if (ses->chan_count > 1) {
> +                               seq_printf(m, "\n\n\tExtra Channels: %lu\n",
> +                                          ses->chan_count-1);
> +                               for (j = 1; j < ses->chan_count; j++)
> +                                       cifs_dump_channel(m, j, &ses->chans[j]);
> +                       }
> +
>                         seq_puts(m, "\n\tShares:");
>                         j = 0;
>
> @@ -415,8 +443,13 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>                                 seq_printf(m, "\n\tServer interfaces: %zu\n",
>                                            ses->iface_count);
>                         for (j = 0; j < ses->iface_count; j++) {
> +                               struct cifs_server_iface *iface;
> +
> +                               iface = &ses->iface_list[j];
>                                 seq_printf(m, "\t%d)", j);
> -                               cifs_dump_iface(m, &ses->iface_list[j]);
> +                               cifs_dump_iface(m, iface);
> +                               if (is_ses_using_iface(ses, iface))
> +                                       seq_puts(m, "\t\t[CONNECTED]\n");
>                         }
>                         spin_unlock(&ses->iface_lock);
>                 }
> --
> 2.16.4
>


-- 
Thanks,

Steve
