Return-Path: <SRS0=OaSP=63=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60937C433DF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 May 2020 19:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5972065C
	for <linux-cifs@archiver.kernel.org>; Wed, 13 May 2020 19:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SqNqMTYs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbgEMTOz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 May 2020 15:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387469AbgEMTOy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 May 2020 15:14:54 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5F0C061A0C
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 12:14:53 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x15so312823ybr.10
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 12:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BPZyzx2D6+WsQweiS3jDVQK58QvT198EDhUhZzZ4ZI=;
        b=SqNqMTYsuAOh+vwx5r5X65Ct34veGPlPQW8q5jtTKFqtc4IUBgjwXmMVLz7l5nL4BK
         U9QGEwjj47fbTdAXDfXjTbXaoO72iFf1qIfvWyXxmK5QRh/nHiC2309Y/ZUI8MfYXVp1
         yU5goOOTISNqFUyl+ESKD2PQ0hdvDe0bwANeuZ3rJ7SSSNO1j2UmO+dhblkpRzxNn4vS
         XA9Ast+iSzF2ZlvzXxMQpCmksiOeS0SnWhDFjM+ilfV80n7bmd3j2gaqT99LO8wUy0wx
         OkLcj48a4mvKYtMto9CaslSkxRTRwiGGaiDBKrL5E3iGYga7fiVpQ3QcmIkWV1xdu6n1
         KKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BPZyzx2D6+WsQweiS3jDVQK58QvT198EDhUhZzZ4ZI=;
        b=kgji6iGMz3Uy5fDAs7Li+l+/gqb2tiOFvIf+gOF5gRvebIeUw9tiANMuuB9xlhPu3C
         yxs65z1JXXiEo7wVDXPVL3mA1Pw4LfuRCPimnM8dSeOgrxz0zt2A2glTrrpurnRU2sIf
         YdFWMSxUpH6rukrLaAPon2M86eQI7FoYHowV2Ky2Jyx9qzUWZbj9PbHNiDt4gt7VgxZn
         ZnKBYbDL0Uq8rgqDgJrYsO9PiY5ECn1MbHuOD1LeRvwWdaaW6bsipkCPaxBfjgJdqWtc
         ysUsUcxG80fKSDegB2tk/qUK9yY4l763QjweedxVdzz1AzAjzoBS1kj0ScgzSrrn32DW
         mdxg==
X-Gm-Message-State: AOAM5333etXoMzPe/qrz/OCIMyz/qCF8VQXCcoqtG9V4OcfOwIDPJAvx
        R8TWlqqKyemH+3BThb7QIR3dBvkO8V++THvLAuZuLdcw
X-Google-Smtp-Source: ABdhPJwKzxcPos66h9ErYJowNZShgncfeMSRuiKKEoZFwvKjpYJYeaHdLSHZV8mjxKwl1UKXFYCtm/eAaZaQzbD4rUQ=
X-Received: by 2002:a25:b94:: with SMTP id 142mr1049749ybl.14.1589397292355;
 Wed, 13 May 2020 12:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200513115330.5187-1-adam@forsedomani.com>
In-Reply-To: <20200513115330.5187-1-adam@forsedomani.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 May 2020 14:14:41 -0500
Message-ID: <CAH2r5ms14KKspfjv7rc_vkWGMantAxoTE7p0bi66NmMzcex+tg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix leaked reference on requeued write
To:     Adam McCoy <adam@forsedomani.com>, Jeff Layton <jlayton@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam and Pavel noticed things which didn't make sense

e.g. in cifs_writepages weare putting the reference unconditionally
but in cifs_write_from_iter we are doing the same thing.   So how was
this working before - should have resulted in a reference leak and
direct i/o shouldn't have had a chance to complete??

and wouldn't there be an underrun if a retryable error with your patch
with it getting called twice?

Jeff,
Any thoughts on this?



On Wed, May 13, 2020 at 6:55 AM Adam McCoy <adam@forsedomani.com> wrote:
>
> Failed async writes that are requeued may not clean up a refcount
> on the file, which can result in a leaked open. This scenario arises
> very reliably when using persistent handles and a reconnect occurs
> while writing.
>
> cifs_writev_requeue only releases the reference if the write fails
> (rc != 0). The server->ops->async_writev operation will take its own
> reference, so the initial reference can always be released.
>
> Signed-off-by: Adam McCoy <adam@forsedomani.com>
> ---
>  fs/cifs/cifssmb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 182b864b3075..5014a82391ff 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2152,8 +2152,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
>                         }
>                 }
>
> +               kref_put(&wdata2->refcount, cifs_writedata_release);
>                 if (rc) {
> -                       kref_put(&wdata2->refcount, cifs_writedata_release);
>                         if (is_retryable_error(rc))
>                                 continue;
>                         i += nr_pages;
> --
> 2.17.1
>


--
Thanks,

Steve
