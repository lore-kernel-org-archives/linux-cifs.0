Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913BEC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 05:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C8F20838
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 05:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTaOF6u2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfCBFne (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Mar 2019 00:43:34 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32850 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfCBFne (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Mar 2019 00:43:34 -0500
Received: by mail-pg1-f193.google.com with SMTP id h11so13188pgl.0;
        Fri, 01 Mar 2019 21:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GCTgMyX7xA0jb9EP4T0pAaoNtn52q/x5LabQSatc9UA=;
        b=fTaOF6u2hZYLqFfX6j1aSNPXhkf5LdfvHnjfXb1ns3aKyEyQQKMU1SFEDc8yrTc2Pi
         BuVwImbd2aSq49NPMzsknTemOy672ZGTecGIN0Kaxm9XHR4T3xlGraFx2Rlrq/bKKUgx
         ko32qd1wL/f+gtca0LzVE7zAfhJTZBLbJ3D45g8r1AEfPTnSil4BmhrJD76ZeL8nVzIM
         ZMHJu+sUsmQAvL+/vuOAXMDwROF/T+weD77A+667uiORodds84IDaiFHedl3BixXOE68
         HPQQOzAUFD7hFShkNF9hU7ZHRHXGlPxgJ+8NNsUgRWnXfs7ZYsLQVz5k+5tfpBE6JAUl
         PLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GCTgMyX7xA0jb9EP4T0pAaoNtn52q/x5LabQSatc9UA=;
        b=cIr6DrHCu9NOGKu7CakPgQFXoVf29lZivbcER8iM4Wtze1GLAp3J4zKiwYECpCiqlT
         0eGMkCS+bZxcl2//C5SFMZAE6VDkmXNHLViOPOf/Vm8mxVUTuI0s1NwU0taPAzFbFwnv
         vuXYoegnCeI9L11uxlzh4zPPahpeDJww0mg4kBGwyEJ8gmCy+aPt9whGqG3XjfwYg4rQ
         xPpEHTg+TDsD7nSEg+N5apAK6WXf/LOrsYAqUuwwiXAnyQszVRLof60e93YmYqyex2kd
         avCXr73jPh4kCfzwAIINth4RTOZD0YrmT2eKKLVjL/jRxVjSF5Om0qqCVTDQvbX+pHuW
         DlWw==
X-Gm-Message-State: APjAAAWePNo7J8xIe+Nimfqv1PJ1XCKtIiYA6/Xa7tB/+GKcDVoBoUOw
        cN/XkDjm4jQvMro94namXSzDBOusSwqEqLh9uUw=
X-Google-Smtp-Source: APXvYqw+Omzfn0yE1dyr/miJeYucQJETQxtSJ1xa/JIZmTXcSLwVptZBk2Q6UwTCneomoFGlxjsGUakTGBuvTvgr28c=
X-Received: by 2002:a65:508b:: with SMTP id r11mr8577132pgp.242.1551505413070;
 Fri, 01 Mar 2019 21:43:33 -0800 (PST)
MIME-Version: 1.0
References: <20190302025146.2935-1-longli@linuxonhyperv.com>
In-Reply-To: <20190302025146.2935-1-longli@linuxonhyperv.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Mar 2019 23:43:22 -0600
Message-ID: <CAH2r5mt0=W54eWaH6JBEm9sfD8BWCqecV7SakC5U14QbYhChzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] CIFS: Fix a bug with re-sending wdata when transport
 returning -EAGAIN
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I tested this vs. Samba a few minutes ago with test 208 - looks like
it works.   Thank you!

Now just need some additional reviews as this can be a complex area of code.

On Fri, Mar 1, 2019 at 9:04 PM Long Li <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> When sending a wdata, transport may return -EAGAIN. In this case
> we should re-obtain credits because the session may have been
> reconnected.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/file.c | 61 +++++++++++++++++++++++++-------------------------
>  1 file changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9b53f33137b3..08e73759d6ec 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2620,43 +2620,44 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
>         struct TCP_Server_Info *server =
>                 tlink_tcon(wdata->cfile->tlink)->ses->server;
>
> -       /*
> -        * Wait for credits to resend this wdata.
> -        * Note: we are attempting to resend the whole wdata not in segments
> -        */
>         do {
> -               rc = server->ops->wait_mtu_credits(server, wdata->bytes, &wsize,
> -                                                  &credits);
> -
> -               if (rc)
> -                       goto out;
> -
> -               if (wsize < wdata->bytes) {
> -                       add_credits_and_wake_if(server, &credits, 0);
> -                       msleep(1000);
> -               }
> -       } while (wsize < wdata->bytes);
> +               /*
> +                * Wait for credits to resend this wdata.
> +                * Note: we are attempting to resend the whole wdata not in
> +                * segments
> +                */
> +               do {
> +                       rc = server->ops->wait_mtu_credits(server, wdata->bytes,
> +                                               &wsize, &credits);
> +                       if (rc)
> +                               goto fail;
> +
> +                       if (wsize < wdata->bytes) {
> +                               add_credits_and_wake_if(server, &credits, 0);
> +                               msleep(1000);
> +                       }
> +               } while (wsize < wdata->bytes);
>
> -       wdata->credits = credits;
> -       rc = -EAGAIN;
> -       while (rc == -EAGAIN) {
> +               wdata->credits = credits;
>                 rc = 0;
>                 if (wdata->cfile->invalidHandle)
>                         rc = cifs_reopen_file(wdata->cfile, false);
>                 if (!rc)
>                         rc = server->ops->async_writev(wdata,
> -                                       cifs_uncached_writedata_release);
> -       }
> +                               cifs_uncached_writedata_release);
>
> -       if (!rc) {
> -               list_add_tail(&wdata->list, wdata_list);
> -               return 0;
> -       }
> +               /* If the write was successfully sent, we are done */
> +               if (!rc) {
> +                       list_add_tail(&wdata->list, wdata_list);
> +                       return 0;
> +               }
>
> -       add_credits_and_wake_if(server, &wdata->credits, 0);
> -out:
> -       kref_put(&wdata->refcount, cifs_uncached_writedata_release);
> +               /* Roll back credits and retry if needed */
> +               add_credits_and_wake_if(server, &wdata->credits, 0);
> +       } while (rc == -EAGAIN);
>
> +fail:
> +       kref_put(&wdata->refcount, cifs_uncached_writedata_release);
>         return rc;
>  }
>
> @@ -2884,12 +2885,12 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
>                                                 wdata->bytes, &tmp_from,
>                                                 ctx->cfile, cifs_sb, &tmp_list,
>                                                 ctx);
> +
> +                                       kref_put(&wdata->refcount,
> +                                               cifs_uncached_writedata_release);
>                                 }
>
>                                 list_splice(&tmp_list, &ctx->list);
> -
> -                               kref_put(&wdata->refcount,
> -                                        cifs_uncached_writedata_release);
>                                 goto restart_loop;
>                         }
>                 }
> --
> 2.17.1
>


-- 
Thanks,

Steve
