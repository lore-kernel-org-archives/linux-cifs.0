Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D459C4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 16:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E7520704
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 16:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aG17Up5a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394993AbgJTQzx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 12:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389033AbgJTQzv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Oct 2020 12:55:51 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668DFC0613CE;
        Tue, 20 Oct 2020 09:55:50 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y16so2812222ljk.1;
        Tue, 20 Oct 2020 09:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qz4MjVNVxrecIcW8x1TcdGzeDcTlGL+33knVz17BQFk=;
        b=aG17Up5akVMalus/NeTKE6aGHRm8gjB8jK8Dg9CnkPsI4ut9T47Fv5EQIZGF9BPJ86
         ExjfCyIUMdOYnaAEz2khGxxEHm4XoyPVL6F9uaAZRqNQjJD4f5JQeQNQ0tYclIclsJJC
         WLiz5CWas+RPe8snAwhmVHuToZg47AYHMIaj8Hm2xfHgugHgd3ZyV3jKiin0ICJ++eQi
         Bwj0fxcN6+SUO90+CID7elktrVTAcoVf0b7CHvIcV+41h+gn+TNlrvZwQ42LKVbhHQfX
         Pv+eUoraYIt4K9nwfAXcVQhyLBYK7BDxxi99rqoMcJiusaFZFSORaeny07vbrz4g/yA2
         piqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qz4MjVNVxrecIcW8x1TcdGzeDcTlGL+33knVz17BQFk=;
        b=fPuQi40fMuY7yDkW+0FjqRzZtYdQYi62IyAjw57lKEMvuHRysJUadprvSlr17DLigr
         eEu4uAS76CyXL40cNIC11ZF1xvmtuVOEA0gXOcsyRK0zt1K2Q3POCEgodlwiqhDb0K22
         aJH5XAmnIGQgDHSuYL7WtgIema6x7cwIvI3ZGriHs24izkWZ3niWW4yhPk7rIeZMgofx
         q1ufSkwWiXLghuLbj9hyIefEMPnOoNEoGD8k1ken3ww8USRXIwhndMZiCzYB4XQEhvDW
         ae61/NXHmf/VmWe18BCBDPdaxjvUFkGhxu5b4HF+bi/pLNdezgOUrNnFfqFt/a9RxaxI
         JngQ==
X-Gm-Message-State: AOAM532SB03DXhEsJYWXAoQtyFbz3P2m5Y2XbntMijz+hOUgiMF7sVqZ
        OvuHsLcQxdbhi7aaIa2kZHOGhqDq0zkC9WqvpiQ=
X-Google-Smtp-Source: ABdhPJxmKwy1feIl6inzCUzl6utHPj8AV6tlP+rB48lrZaEGH3kifdhldf95yOCS+tz/ydf7Xnce7H5lree+fPvT0cY=
X-Received: by 2002:a2e:b0e4:: with SMTP id h4mr1454870ljl.119.1603212948806;
 Tue, 20 Oct 2020 09:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201020141936.52272-1-colin.king@canonical.com>
In-Reply-To: <20201020141936.52272-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Oct 2020 11:55:38 -0500
Message-ID: <CAH2r5muM5K802hub3WYJYcC5Mqi8K2S2HJa1hgW_mo+oW0toMA@mail.gmail.com>
Subject: Re: [PATCH] cifs: make const array static, makes object smaller
To:     Colin King <colin.king@canonical.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added Aurelien's Reviewed-by and merged into cifs-2.6.git for-next

On Tue, Oct 20, 2020 at 9:22 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Don't populate const array smb3_create_tag_posix on the stack but
> instead make it static. Makes the object code smaller by 50 bytes.
>
> Before:
>    text    data     bss     dec     hex filename
>  150184   47167       0  197351   302e7 fs/cifs/smb2pdu.o
>
> After:
>     text           data     bss     dec     hex filename
>  150070   47231       0  197301   302b5 fs/cifs/smb2pdu.o
>
> (gcc version 10.2.0)
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/smb2pdu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index d504bc296349..be8696abd871 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1971,9 +1971,11 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
>         unsigned int next;
>         unsigned int remaining;
>         char *name;
> -       const char smb3_create_tag_posix[] = {0x93, 0xAD, 0x25, 0x50, 0x9C,
> -                                       0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
> -                                       0xDE, 0x96, 0x8B, 0xCD, 0x7C};
> +       static const char smb3_create_tag_posix[] = {
> +               0x93, 0xAD, 0x25, 0x50, 0x9C,
> +               0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
> +               0xDE, 0x96, 0x8B, 0xCD, 0x7C
> +       };
>
>         *oplock = 0;
>         data_offset = (char *)rsp + le32_to_cpu(rsp->CreateContextsOffset);
> --
> 2.27.0
>


-- 
Thanks,

Steve
