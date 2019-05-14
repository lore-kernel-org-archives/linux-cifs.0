Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D71C04AB4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 21:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16E3020879
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 21:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6TXiImM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENVlc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 May 2019 17:41:32 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46590 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfENVlc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 May 2019 17:41:32 -0400
Received: by mail-lj1-f193.google.com with SMTP id h21so578767ljk.13;
        Tue, 14 May 2019 14:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5m8suSOXj3rzby4LAxsQcSwGgLVkjYeR9u7Qjs8sKQk=;
        b=c6TXiImMg/nQjL/P6h7bIbTERKpUGdYxZxwBURtDusJzfsXpEpr4/6fZP7DoX90W7B
         3EbUs92KZc+z7ty0fyBfxdWZZu9h5dc0Nfjwr2nYfYX0Wx1f5uZYyDgQ2IEDxc7Xg5y6
         A/nz3dgWLg1ARdFYUh/0tgCraZNtf90bA+I+1yXAlaUW0EPfW+zhXpiwU91nul396Noa
         7qQXWJfFmRC5367OU7GjG2jUOkBhowtMBQI5d9/KXkFkaTaDhQtq1HJnykRHbOLS5/Tm
         e93bIIxlm3Tqht5AHvjI4qWrglSR69H3mxvAOB7MeQAFOAZJPs2joxZIT+xXjnSj+LQk
         XlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5m8suSOXj3rzby4LAxsQcSwGgLVkjYeR9u7Qjs8sKQk=;
        b=f1cLP5EWi24uLJZRNmtUsiDqDDIcbEpRN4IlG7LUV+fb6a8vynXiOiB/JLbrNqanSD
         f+SphXr3T3X7nULm9Xyd9ns0y6kDAV9B8aKuI7hgMzWqlSTfckfinuMG5sSlWGkkxeQF
         9W8JmTe/W9Usbe8NSUrYQe1mlnyU62FuXxus6E/DuOXcRhxA+5IS+W/7btQqAhuW6ND1
         fKNE74PCrlp+8uh0i+d8YJ0Sm9YFyeLXjzh4/rAdGEu84kZ9BMxy73pC28MOD5JT2kqz
         2dVYTdp1gbOlcHBg1RwjUUvsbfMjpgqQD5nq64/1cX4dMv3eKX/8kO4l6AorTlk9IGaK
         5mrw==
X-Gm-Message-State: APjAAAUBUEf8PArWpWF51w1tNoaT0ANoQxBhhzv8dFkAH/pcLNeP+59E
        aZApGgoV/HIxkKG4AvaI3mCsPQnX3AU+0TYKsQ==
X-Google-Smtp-Source: APXvYqzJfN5/jEVrICMKNKf1Gbk6t97scfit5Or0E0rGafJU60pSgkm96WWXDbFmc/eogZh3Ay8RlJQmxCehuE6fsIo=
X-Received: by 2002:a2e:994:: with SMTP id 142mr10090225ljj.192.1557870090361;
 Tue, 14 May 2019 14:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <1557806489-11272-1-git-send-email-longli@linuxonhyperv.com> <1557806489-11272-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1557806489-11272-2-git-send-email-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 14 May 2019 14:41:18 -0700
Message-ID: <CAKywueSKyttaG8h_OrFE-ZCvDy_QCRQkdKQmW7m2wtrJ+fsT6Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs:smbd Use the correct DMA direction when sending data
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

=D0=BF=D0=BD, 13 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 21:02, <longli@linu=
xonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> When sending data, use the DMA_TO_DEVICE to map buffers. Also log the num=
ber
> of requests in a compounding request from upper layer.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smbdirect.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 251ef1223206..caac37b1de8c 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -903,7 +903,7 @@ static int smbd_create_header(struct smbd_connection =
*info,
>         request->sge[0].addr =3D ib_dma_map_single(info->id->device,
>                                                  (void *)packet,
>                                                  header_length,
> -                                                DMA_BIDIRECTIONAL);
> +                                                DMA_TO_DEVICE);
>         if (ib_dma_mapping_error(info->id->device, request->sge[0].addr))=
 {
>                 mempool_free(request, info->request_mempool);
>                 rc =3D -EIO;
> @@ -1005,7 +1005,7 @@ static int smbd_post_send_sgl(struct smbd_connectio=
n *info,
>         for_each_sg(sgl, sg, num_sgs, i) {
>                 request->sge[i+1].addr =3D
>                         ib_dma_map_page(info->id->device, sg_page(sg),
> -                              sg->offset, sg->length, DMA_BIDIRECTIONAL)=
;
> +                              sg->offset, sg->length, DMA_TO_DEVICE);
>                 if (ib_dma_mapping_error(
>                                 info->id->device, request->sge[i+1].addr)=
) {
>                         rc =3D -EIO;
> @@ -2110,8 +2110,10 @@ int smbd_send(struct TCP_Server_Info *server,
>                 goto done;
>         }
>
> -       rqst_idx =3D 0;
> +       log_write(INFO, "num_rqst=3D%d total length=3D%u\n",
> +                       num_rqst, remaining_data_length);
>
> +       rqst_idx =3D 0;
>  next_rqst:
>         rqst =3D &rqst_array[rqst_idx];
>         iov =3D rqst->rq_iov;
> --
> 2.17.1
>

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
