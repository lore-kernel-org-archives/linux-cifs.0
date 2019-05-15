Return-Path: <SRS0=u+N2=TP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E459C04AA7
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 04:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1B020862
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 04:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgZC3RTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfEOEQS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 00:16:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45994 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEOEQS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 00:16:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id s11so635328pfm.12;
        Tue, 14 May 2019 21:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BfF/cEY+63NPFeE0nnGTP5s2FRqzna+7ou7Ez1fHZIc=;
        b=HgZC3RTNLZvlm/5XzxJnHy0w0DoRXtA9hOhW/m7ICcJe6KpAsPYLSDbM/AfdyQIZCJ
         Zzp7n0ixLTO2jYKlR4aTa/tVxSc+DA9jyjnrJmqzY/6JhcAzthGuy50iS47h1yJmAIWc
         zJtCMEt1W7jhsXC+Vr41ryqdE9u17c6BDht6vir9NmO7wyneSyri/fo+vVl6VdhyaPSF
         CCbwAuzkWwcaQUCJf8a8j8vXj2YXGNWaKRbAJhTDIBxB8euBV30+K9y+mHurO2hwJlUH
         OlmmIIT5rHNLo3Z/k7KecfL3CQnY+czWLYCb/ZB6FZkDryiPUfLEGt7BEsj0tnAdy1N4
         Bd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BfF/cEY+63NPFeE0nnGTP5s2FRqzna+7ou7Ez1fHZIc=;
        b=J6rGB5V8cWfVC/IeDAFDQSyk4vkyLnIOu8xYqNgHyaOPsuK6ru48yIuTEnEFiQXqEZ
         nxPMfQo/A3oNFQkLn+oOfEcKhoRSV/x1JB3rl8fqTkYLEYxEJ19eek5Y6EWwABKL8ItF
         pMkG2Jx6nST8N2QdwFMOBUUM77/rMaX7GkYuoK818jM2PIs0fFqX15mNv8WFpDBrFLz7
         2ZwVoPfyo6KXfWoUh+pjZAgtp9v622Vyhdu8kNbQOLxxKusl/MOyeSKjWl9pLc7WYvyf
         dGroUmDPzCm+Rm4RafY/JTYalN+ei1iAZJbwtREw13vLVxsKqgHvEdRxdqFnNlqq8mNL
         k9FQ==
X-Gm-Message-State: APjAAAV8i7xXtYrKXLknrBOyyRpfUJDVZ5RDvZW17sbYBUBXXX28aSP1
        E4iGQJ3fRFDDDwWwnskutqRmqApsjreg9aKRh28l3w==
X-Google-Smtp-Source: APXvYqy8nPnvB25D5BAaYVI6FfefnZ4fR45Aui9wsDJbBswv7PdAsPryss5lbt8sGLj3Q8NuYCkRq4fPmmMq9yOdyQE=
X-Received: by 2002:a63:570d:: with SMTP id l13mr42080517pgb.55.1557893777809;
 Tue, 14 May 2019 21:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <1557806489-11272-1-git-send-email-longli@linuxonhyperv.com> <1557806489-11272-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1557806489-11272-2-git-send-email-longli@linuxonhyperv.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 May 2019 23:16:06 -0500
Message-ID: <CAH2r5ms4vU9PXceAemvzw2mQ1feTaKB_DbUHc72VZ8-Gb+X46A@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs:smbd Use the correct DMA direction when sending data
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged both patches into cifs-2.6.git for-next

On Mon, May 13, 2019 at 11:02 PM <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> When sending data, use the DMA_TO_DEVICE to map buffers. Also log the number
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
> @@ -903,7 +903,7 @@ static int smbd_create_header(struct smbd_connection *info,
>         request->sge[0].addr = ib_dma_map_single(info->id->device,
>                                                  (void *)packet,
>                                                  header_length,
> -                                                DMA_BIDIRECTIONAL);
> +                                                DMA_TO_DEVICE);
>         if (ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
>                 mempool_free(request, info->request_mempool);
>                 rc = -EIO;
> @@ -1005,7 +1005,7 @@ static int smbd_post_send_sgl(struct smbd_connection *info,
>         for_each_sg(sgl, sg, num_sgs, i) {
>                 request->sge[i+1].addr =
>                         ib_dma_map_page(info->id->device, sg_page(sg),
> -                              sg->offset, sg->length, DMA_BIDIRECTIONAL);
> +                              sg->offset, sg->length, DMA_TO_DEVICE);
>                 if (ib_dma_mapping_error(
>                                 info->id->device, request->sge[i+1].addr)) {
>                         rc = -EIO;
> @@ -2110,8 +2110,10 @@ int smbd_send(struct TCP_Server_Info *server,
>                 goto done;
>         }
>
> -       rqst_idx = 0;
> +       log_write(INFO, "num_rqst=%d total length=%u\n",
> +                       num_rqst, remaining_data_length);
>
> +       rqst_idx = 0;
>  next_rqst:
>         rqst = &rqst_array[rqst_idx];
>         iov = rqst->rq_iov;
> --
> 2.17.1
>


-- 
Thanks,

Steve
