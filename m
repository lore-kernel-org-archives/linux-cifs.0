Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7B9C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 18:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83235218D0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 18:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Opk2gaHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfCPSDs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:03:48 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38588 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbfCPSDr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Mar 2019 14:03:47 -0400
Received: by mail-lf1-f65.google.com with SMTP id a6so6651238lfl.5;
        Sat, 16 Mar 2019 11:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+H4Asu78BOybMMYm/zG4goDHicRW/UR8XYf7jEe2GwI=;
        b=Opk2gaHCWYRlvARdU89Wj0/oLUfA8I1cYZtCUwaH+cXy4v3qmXfLqKKqurL2DovFd2
         Dn/886CDetzQGCmIfcFXE2P314Q91c92Ud+NaKqXrxY8efGUGHBInpfqbHufI083Fms/
         X510crI3UIB423QpzdpsnV3bnXhPdf0hr/d5dh0dZ9YBXygozI4Kb4yzianuZ/zh4xiX
         JfMGq5nryhUvxFvehut7Rq7tA4R9yqWmSmCVphI4YTnFO7AlhfoajWzHnxm8cMDepeWh
         j770IogqKQxH2gAZa7y/M8nz/pmYn7sPoeVmig8bEwl2HeFQHu1dT1XfAeqCoobk9bq+
         yHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+H4Asu78BOybMMYm/zG4goDHicRW/UR8XYf7jEe2GwI=;
        b=in1zFiQ+hMGH8brvjvanxQbvjKGJ78oY+ugIVlxZYpHf+Dr0OfmztCD0BoL6lyFCEq
         b+qDeBKksOHYmQ7wYNakkNS59UuCFgO+g8jn7ZQz9aYxInOGTfRba2qxDQfbFQl9Xo/c
         ex08kFISmx2qZiNyfVqSGb5ijtj+QojGEG2Onm4QF4SxJ6CLF322166h8thuaDZPBF+l
         A0xKRXuhPr7QA0W9KEUyks8k/G+gvN/Svb8WexsWghW59A2sWPQoj8Bt221Z87FzM4kO
         JCyWvM8siqKSP9ksLUEFBDdNt2b9vfd8DauQxNr3h7Yuo1rKUKPh+DjMnTSA9lxdIGHD
         TG8Q==
X-Gm-Message-State: APjAAAX9fHGeYhoK8jxAUB1DIEpUqowN1J4lUY6zVxJ5BK6yoKuOeN/E
        XWtm5txFiAVL3HDR7W//pUOoBZ7F4uC3PbKzQU6QnUs=
X-Google-Smtp-Source: APXvYqx7TLfYloecJM8oaJq4Vgcsn7yGD11gulLHNfKW6VPng2mS4CSY/67UCbqeIn+PqSDltckpEmApdJXTIQ9eG3E=
X-Received: by 2002:a19:5506:: with SMTP id n6mr5462486lfe.119.1552759424584;
 Sat, 16 Mar 2019 11:03:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190315075500.27747-1-longli@linuxonhyperv.com> <20190315075500.27747-2-longli@linuxonhyperv.com>
In-Reply-To: <20190315075500.27747-2-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 16 Mar 2019 11:03:33 -0700
Message-ID: <CAKywueTOHQq8iEiQRHer7yGstvKEF7SrSgNqmETYV73uEgqA+A@mail.gmail.com>
Subject: Re: [Patch v2 2/2] CIFS: Fix an issue with re-sending rdata when
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
> When sending a rdata, transport may return -EAGAIN. In this case
> we should re-obtain credits because the session may have been
> reconnected.
>
> Change in v2: adjust_credits before re-sending
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/file.c | 71 +++++++++++++++++++++++++++++++++-------------------=
------
>  1 file changed, 41 insertions(+), 30 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 321df1d27422..9d90cc07e38b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3347,44 +3347,55 @@ static int cifs_resend_rdata(struct cifs_readdata=
 *rdata,
>         struct TCP_Server_Info *server =3D
>                 tlink_tcon(rdata->cfile->tlink)->ses->server;
>
> -       /*
> -        * Wait for credits to resend this rdata.
> -        * Note: we are attempting to resend the whole rdata not in segme=
nts
> -        */
>         do {
> -               rc =3D server->ops->wait_mtu_credits(server, rdata->bytes=
,
> +               if (rdata->cfile->invalidHandle) {
> +                       rc =3D cifs_reopen_file(rdata->cfile, true);
> +                       if (rc =3D=3D -EAGAIN)
> +                               continue;
> +                       else if (rc)
> +                               break;
> +               }
> +
> +               /*
> +                * Wait for credits to resend this rdata.
> +                * Note: we are attempting to resend the whole rdata not =
in
> +                * segments
> +                */
> +               do {
> +                       rc =3D server->ops->wait_mtu_credits(server, rdat=
a->bytes,
>                                                 &rsize, &credits);
>
> -               if (rc)
> -                       goto out;
> +                       if (rc)
> +                               goto fail;
>
> -               if (rsize < rdata->bytes) {
> -                       add_credits_and_wake_if(server, &credits, 0);
> -                       msleep(1000);
> -               }
> -       } while (rsize < rdata->bytes);
> +                       if (rsize < rdata->bytes) {
> +                               add_credits_and_wake_if(server, &credits,=
 0);
> +                               msleep(1000);
> +                       }
> +               } while (rsize < rdata->bytes);
> +               rdata->credits =3D credits;
>
> -       rdata->credits =3D credits;
> -       rc =3D -EAGAIN;
> -       while (rc =3D=3D -EAGAIN) {
> -               rc =3D 0;
> -               if (rdata->cfile->invalidHandle)
> -                       rc =3D cifs_reopen_file(rdata->cfile, true);
> -               if (!rc)
> -                       rc =3D server->ops->async_readv(rdata);
> -       }
> +               rc =3D adjust_credits(server, &rdata->credits, rdata->byt=
es);
> +               if (!rc) {
> +                       if (rdata->cfile->invalidHandle)
> +                               rc =3D -EAGAIN;
> +                       else
> +                               rc =3D server->ops->async_readv(rdata);
> +               }
>
> -       if (!rc) {
> -               /* Add to aio pending list */
> -               list_add_tail(&rdata->list, rdata_list);
> -               return 0;
> -       }
> +               /* If the read was successfully sent, we are done */
> +               if (!rc) {
> +                       /* Add to aio pending list */
> +                       list_add_tail(&rdata->list, rdata_list);
> +                       return 0;
> +               }
>
> -       add_credits_and_wake_if(server, &rdata->credits, 0);
> -out:
> -       kref_put(&rdata->refcount,
> -               cifs_uncached_readdata_release);
> +               /* Roll back credits and retry if needed */
> +               add_credits_and_wake_if(server, &rdata->credits, 0);
> +       } while (rc =3D=3D -EAGAIN);
>
> +fail:
> +       kref_put(&rdata->refcount, cifs_uncached_readdata_release);
>         return rc;
>  }
>
> --
> 2.14.1
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
