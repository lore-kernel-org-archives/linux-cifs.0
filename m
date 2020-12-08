Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF43FC4361B
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 20:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B02CA22582
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 20:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgLHUne (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgLHUne (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Dec 2020 15:43:34 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F5C061793;
        Tue,  8 Dec 2020 12:42:53 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id m12so81030lfo.7;
        Tue, 08 Dec 2020 12:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPEezVzK5/kLNT18lfW/dfChG0nQyJZzaqQoMAH4Ojw=;
        b=QQB6xX7ZMHg5p+Sz6Bt9MksNDS64p3I6yufe4wI9yXPB/gVrO3fXujcKeeSB9vuEWp
         3a23umzaJgQ7JDO9BB/hOohKVSl1sHLJFD7X2ep22r/iO4cjIag+ZzLnqcKcoJLlYM7P
         PWQmJZRCIv4T4OkshRETA/Bfm6Wn9tRDmPwuSGgKVgxWzTb3G6hXpIkqKxAq/7LInnqj
         8FrUOY274w9bytUgQZYAXOIMIS8YfUivRINu6yrbLQ+czfZb83CQZsgLu6RP/C3o7fg4
         0Tp8z19OXY/ABUelr4Nx50muS+9ok8KuARMWdmXDpe5/TzKYoF7jsgS7p8XPBEGIfidC
         b2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPEezVzK5/kLNT18lfW/dfChG0nQyJZzaqQoMAH4Ojw=;
        b=ewSN5i4Mv5AJY+uJpSiaqcFSxZIquKEsZw+l00Vtt8DJxNGnMW7B7Q1TbgnF2oLi1N
         zfT8NVHxQ23ZgcvsUB/M32h1FreG6GZPGc1HdKoiqpgYUAgxUt4vL2qa1DzSe1nOwW8Z
         fHkF58kfsQ4qXANyiOXMlNK3nQo5lEqXUlpfuuHPjTNJz3MQ/43a8KU0iVQRp6IOk9gQ
         qkOQIgTbx500TGy9k556xFShe6ZX0cftBlgWkw24ag1uNaJRWMGUBBODpcSMySX9szYM
         gb7Dc7j4BKczNKXmX8EDadWfajcmb+39Gfr9I2A8x/f7hERe+J1VXjkCrRxhfNcc91Zy
         y0Aw==
X-Gm-Message-State: AOAM533C56g5R/wNzy3r0qfzctA46qCNqJSmNG8QMvoYWyUTt2FDY4Ai
        TeNxjKtDRk8l4ewIGVWOS8ougiwsfVcliEJG+STij9s6TkU=
X-Google-Smtp-Source: ABdhPJxV3qjQHB6wUEKu9rWrbuLtX9hIHxwZYN45a2xlKjN3Iv09O/zEhJ+iIFYHbTAk33M7azJfMCbvOBT9Bh7Cz4k=
X-Received: by 2002:a19:950:: with SMTP id 77mr6586265lfj.133.1607460172142;
 Tue, 08 Dec 2020 12:42:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605896059.git.gustavoars@kernel.org> <8a35ff7132f95e24f6d9501e1bec644854fc5078.1605896059.git.gustavoars@kernel.org>
In-Reply-To: <8a35ff7132f95e24f6d9501e1bec644854fc5078.1605896059.git.gustavoars@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 8 Dec 2020 14:42:40 -0600
Message-ID: <CAH2r5mtS-A+0N1byiXT3GYHEAkvyZByBdr-G_+ZDGhcfs40qrQ@mail.gmail.com>
Subject: Re: [PATCH 003/141] cifs: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

Let me know if you see any other cleanup/misc cifs.ko patches that may
have gotten missed ...

On Fri, Nov 20, 2020 at 12:25 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding multiple break/goto statements instead of
> just letting the code fall through to the next case.
>
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/cifs/inode.c     | 1 +
>  fs/cifs/sess.c      | 1 +
>  fs/cifs/smbdirect.c | 1 +
>  3 files changed, 3 insertions(+)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 9ee5f304592f..ac01f9684b39 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -771,6 +771,7 @@ cifs_get_file_info(struct file *filp)
>                  */
>                 rc = 0;
>                 CIFS_I(inode)->time = 0;
> +               goto cgfi_exit;
>         default:
>                 goto cgfi_exit;
>         }
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index de564368a887..6c2c42f8d893 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -812,6 +812,7 @@ cifs_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
>                                 return NTLMv2;
>                         if (global_secflags & CIFSSEC_MAY_NTLM)
>                                 return NTLM;
> +                       break;
>                 default:
>                         break;
>                 }
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index b029ed31ef91..10dfe5006792 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -246,6 +246,7 @@ smbd_qp_async_error_upcall(struct ib_event *event, void *context)
>         case IB_EVENT_CQ_ERR:
>         case IB_EVENT_QP_FATAL:
>                 smbd_disconnect_rdma_connection(info);
> +               break;
>
>         default:
>                 break;
> --
> 2.27.0
>


-- 
Thanks,

Steve
