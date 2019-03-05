Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993BEC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 19:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55840205F4
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 19:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="utZcjm22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfCETrr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:47:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40594 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfCETrq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 14:47:46 -0500
Received: by mail-lf1-f66.google.com with SMTP id a8so7091898lfi.7;
        Tue, 05 Mar 2019 11:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y4q+SwP7kq/NYVMAc3APu14t6XSfAfthk0RviBN41Sw=;
        b=utZcjm22QN8UdOLE5Iu20Ny1EMwVeEXmjCZQUWx2X21mWdNU2lfezFjntwWGVpN+ua
         EE4obMm6yAMKB4mEoNGXS7rIhLAAnXdm1TGDLbOxQs4Kf/XQVescDTBl+q0bvvz4ZJ8a
         1U0nZC+6bRR1lvfPY2VvD4ll4/JfM634xCegRSZUpsMJm44GBXAgppb53N2m1ZcLjKCw
         q8BhuPMSvvxWYjMO/IcoqAfCD+nQ9bquDZRVSkZwWf7nOyCTo9iFE/F5nwNI2hPGrjTg
         tzgvJ9k7yzr056t5QzvLJgiHLJ5fpKLWh1fWiU4wgViMCkP7akcwsMIw2ndU/1QKGBT7
         U4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y4q+SwP7kq/NYVMAc3APu14t6XSfAfthk0RviBN41Sw=;
        b=ECrpoCGBEZE6MZn1Y6Oj2ModMYivukp9BGGcH/vwNbPgxqIWlQnEZhOW+gQmCNc+3K
         iB3kTN8Q2gI1P6lNWEtoNpvmIpARlDvHPxuJWivEVQSlO5VS5TX2qM0usA+r0YEK8nba
         tFqCJZYRoY5exIO1nVkbJli3HUmWjY0l6ccSgVR8Nn+Muu7CXrpAVvPljce4BFZcXQiA
         kdn8ZVS77x7fpCqJtXFfvdvquysso99ZUkesNp0Cf3JF7IL8zwlFR4kpBukUxWAIqJ0Y
         BdLRoysebZ0Khv0ceXiOgH6cul/mEJaSysDbiyPHktRRVkm6GA0ZxHCVtAQie20al1En
         2rGQ==
X-Gm-Message-State: APjAAAX8OBrQz4g6LUDjOvfpyAdnGjzKJ2N+se6uf728IbjZbEbCPGGd
        dI5LJJztH1NscBfEZvv41O8ojnKAm52KRXbej9Hh/Ko=
X-Google-Smtp-Source: APXvYqwmukTZ8D/v1jk6TDVnS+a/3mCa8DrbWWDzU2E8XMwuVmeNn7rEw6265K6LqWrXmqCQhtFY4cP8Js+LI6rRSKs=
X-Received: by 2002:a19:520e:: with SMTP id m14mr1731604lfb.64.1551815263538;
 Tue, 05 Mar 2019 11:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20190302025146.2935-1-longli@linuxonhyperv.com>
In-Reply-To: <20190302025146.2935-1-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 5 Mar 2019 11:47:32 -0800
Message-ID: <CAKywueRMhjoN3HiuF-WW=4Yt8kn-XA5t7uXWGveD8DT+vY=qGg@mail.gmail.com>
Subject: Re: [PATCH 1/2] CIFS: Fix a bug with re-sending wdata when transport
 returning -EAGAIN
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 1 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 19:04, Long Li <lon=
gli@linuxonhyperv.com>:
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
> @@ -2620,43 +2620,44 @@ cifs_resend_wdata(struct cifs_writedata *wdata, s=
truct list_head *wdata_list,
>         struct TCP_Server_Info *server =3D
>                 tlink_tcon(wdata->cfile->tlink)->ses->server;
>
> -       /*
> -        * Wait for credits to resend this wdata.
> -        * Note: we are attempting to resend the whole wdata not in segme=
nts
> -        */
>         do {
> -               rc =3D server->ops->wait_mtu_credits(server, wdata->bytes=
, &wsize,
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
> +                * Note: we are attempting to resend the whole wdata not =
in
> +                * segments
> +                */
> +               do {
> +                       rc =3D server->ops->wait_mtu_credits(server, wdat=
a->bytes,
> +                                               &wsize, &credits);

The steps in write/read codepaths have been recently re-ordered: now
we need to first check the open handle, re-open it if needed and then
attempt to get credits. This approach avoid a possibility to be stuck
waiting for credits because generally cifs_reopen_file() may need a
lot of credits to complete (up to 2 SMB2_CREATE commands and arbitrary
number of SMB2_LOCK commands).

Please look at this loop as an example:
https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dblob;f=3Dfs/cifs/file.c=
;h=3Dbf864123093162c7ef5cd49ee08d8b40ad7938c8;hb=3D778d81b65e4d596251943002=
522d94a7c6fbcf69#l2690

> +                       if (rc)
> +                               goto fail;
> +
> +                       if (wsize < wdata->bytes) {
> +                               add_credits_and_wake_if(server, &credits,=
 0);
> +                               msleep(1000);
> +                       }
> +               } while (wsize < wdata->bytes);
>
> -       wdata->credits =3D credits;
> -       rc =3D -EAGAIN;
> -       while (rc =3D=3D -EAGAIN) {
> +               wdata->credits =3D credits;

let's call adjust_credits before calling async_writev() as in the example a=
bove.

>                 rc =3D 0;
>                 if (wdata->cfile->invalidHandle)
>                         rc =3D cifs_reopen_file(wdata->cfile, false);
>                 if (!rc)
>                         rc =3D server->ops->async_writev(wdata,
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
> +       } while (rc =3D=3D -EAGAIN);

I don't think there is a need for the nested loop here. How about just do:

do {
    if (wdata->cfile->invalidHandle) {
         rc =3D cifs_reopen_file(...);
         if (rc) break;
    }

    // get_credits
    // if not enough credits - wait and continue the loop.

    rc =3D adjust_credits(...);
    if (!rc) {
         if (wdata->cfile->invalidHandle)
             // set rc, put credits and continue the loop.
        else
            // send async write
    }
    // handle write errors
} while(rc =3D=3D -EAGAIN);


>
> +fail:
> +       kref_put(&wdata->refcount, cifs_uncached_writedata_release);
>         return rc;
>  }
>
> @@ -2884,12 +2885,12 @@ static void collect_uncached_write_data(struct ci=
fs_aio_ctx *ctx)
>                                                 wdata->bytes, &tmp_from,
>                                                 ctx->cfile, cifs_sb, &tmp=
_list,
>                                                 ctx);
> +
> +                                       kref_put(&wdata->refcount,
> +                                               cifs_uncached_writedata_r=
elease);
>                                 }
>
>                                 list_splice(&tmp_list, &ctx->list);
> -
> -                               kref_put(&wdata->refcount,
> -                                        cifs_uncached_writedata_release)=
;
>                                 goto restart_loop;
>                         }
>                 }
> --
> 2.17.1
>

The similar concepts applies for async reads as well.

--
Best regards,
Pavel Shilovsky
