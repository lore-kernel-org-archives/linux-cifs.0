Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C302BC43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 18:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CAFE218D0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 18:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4HLseLS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfCPSBS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:01:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36647 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfCPSBR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Mar 2019 14:01:17 -0400
Received: by mail-lj1-f195.google.com with SMTP id v10so10623563lji.3;
        Sat, 16 Mar 2019 11:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FMDAOxM9QQ0EYxd6HiahnzIt/N/S3BFKKNfFRRGyRIM=;
        b=b4HLseLSJ0dkhHUdpobqJx4ntmT1SIAPBI/e+VOI7ySRS0qL4ui0R3oOSqYEEB6kbE
         tFfEbsAWcmmVN2g266DrfktFka1hKYQsWyr95PTTAKEwZqgXZn75H8VOkuXl6N0jwwgI
         j5K3fiklqnp8cjRSJ5gHfdV0ZEYLLTQqlZhNujVeCNq9GTmAwzLdYKmLn4Kj8ujr2nL9
         LiCMZZnW6PWyNN8N/ZA16iR4JoJdn3y7KeI3R4Vt9AqLpjvlAwtngzkLAnN+YxIrRDQ3
         2019RT0He35PrvHTlQ5ftRWnTdX7OVb+jej0/AnbKHQDBy+fTyOR7Y/yxWP2yP9zRgzR
         Zwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FMDAOxM9QQ0EYxd6HiahnzIt/N/S3BFKKNfFRRGyRIM=;
        b=QXipj4yEGRGmwiDDjLNw2UcaRn/b9JEqHzpU5eLn8t5FbOw0X3B/a4vRXxZyB+BVpi
         c85KErTcMTdyyOMjd/w0b3MM4Zrb8vBJDZWsV902W8EvtSvzFQIfGon2a1seUYQ04EQG
         IH6qV0taeohPbP5VHlsJpKeXdiLMIwXmbnazmDMUbKxRgU4wSn3C3XQz+EHE0IQO8ytK
         PU0q/3ukc9sImjn7DKJLs0JgPbAxhczveerfxSjJnv/MszD0KmLJ3tHTUZhOEuHyQ02o
         XqVtocfqV+60iGb0+/urfeECnMLFfQR0HIwXaH4W7OVUy0UwMK9IpNdelotyB29U3O4c
         tDUw==
X-Gm-Message-State: APjAAAXWTMzUZpTSzmOojE+sPvpL6pKHmIoDFRuQTEEKxzV/3U3snR9f
        4SEr+lE8VHteqiLal/J/UHxIONFjTtPRNwKfdQ==
X-Google-Smtp-Source: APXvYqzjJ9GqWklX4Q6zQ53uQlg0GlA+Fd8rlnD4exw6c7YBQokQEFJhfGG6gZVtsofIeAsmxLAePL9/ptjCGKrae8g=
X-Received: by 2002:a2e:9b15:: with SMTP id u21mr5750895lji.82.1552759274778;
 Sat, 16 Mar 2019 11:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190315075500.27747-1-longli@linuxonhyperv.com>
In-Reply-To: <20190315075500.27747-1-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 16 Mar 2019 11:01:03 -0700
Message-ID: <CAKywueREsB2gfrOoAiExUQg98MDcUtdjQD2-jd5ET3NqsdmE2A@mail.gmail.com>
Subject: Re: [Patch v2 1/2] CIFS: Fix an issue with re-sending wdata when
 transport returning -EAGAIN
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 15 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 00:56, Long Li <lo=
ngli@linuxonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> When sending a wdata, transport may return -EAGAIN. In this case
> we should re-obtain credits because the session may have been
> reconnected.
>
> Change in v2: adjust_credits before re-sending
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/file.c | 77 ++++++++++++++++++++++++++++++++++------------------=
------
>  1 file changed, 45 insertions(+), 32 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9b53f33137b3..321df1d27422 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2620,43 +2620,56 @@ cifs_resend_wdata(struct cifs_writedata *wdata, s=
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
> +               if (wdata->cfile->invalidHandle) {
> +                       rc =3D cifs_reopen_file(wdata->cfile, false);
> +                       if (rc =3D=3D -EAGAIN)
> +                               continue;
> +                       else if (rc)
> +                               break;
> +               }
>
> -               if (rc)
> -                       goto out;
>
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
> +                       if (rc)
> +                               goto fail;
> +
> +                       if (wsize < wdata->bytes) {
> +                               add_credits_and_wake_if(server, &credits,=
 0);
> +                               msleep(1000);
> +                       }
> +               } while (wsize < wdata->bytes);
> +               wdata->credits =3D credits;
>
> -       wdata->credits =3D credits;
> -       rc =3D -EAGAIN;
> -       while (rc =3D=3D -EAGAIN) {
> -               rc =3D 0;
> -               if (wdata->cfile->invalidHandle)
> -                       rc =3D cifs_reopen_file(wdata->cfile, false);
> -               if (!rc)
> -                       rc =3D server->ops->async_writev(wdata,
> +               rc =3D adjust_credits(server, &wdata->credits, wdata->byt=
es);
> +
> +               if (!rc) {
> +                       if (wdata->cfile->invalidHandle)
> +                               rc =3D -EAGAIN;
> +                       else
> +                               rc =3D server->ops->async_writev(wdata,
>                                         cifs_uncached_writedata_release);
> -       }
> +               }
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
>
> +fail:
> +       kref_put(&wdata->refcount, cifs_uncached_writedata_release);
>         return rc;
>  }
>
> @@ -2884,12 +2897,12 @@ static void collect_uncached_write_data(struct ci=
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
> 2.14.1
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
