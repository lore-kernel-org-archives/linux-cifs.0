Return-Path: <SRS0=UnI2=ZY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A0BC432C0
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Dec 2019 22:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EC132071E
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Dec 2019 22:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F22W3Agf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfLBW51 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:57:27 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46179 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfLBW51 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Dec 2019 17:57:27 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so1320942iol.13;
        Mon, 02 Dec 2019 14:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7OqmQQJODK9vo7ge/B5mit6aPLYvUZlqzcHChoc1YCQ=;
        b=F22W3AgfuOPDFHPUrzCdhSGKZJ5xlcnM9mGSYTNvFr6FpKl9wy/vJ0TDsYGmK/Lmi0
         k+7DaOUXEByM/pAYnnZjwVG+jAJXMkaoQZW/FIKAXTyKHrWNdo9PCeWqsHdtLS9jzZMl
         FFcznrw13nyZ1FTCsnAQMpH9kEdemBNM5JSJkOoiQZRD1NRhZVke2mdAzRMYJG8ERrQn
         vN/gyPBpQaUzOCbziR/WY250xSzZn5sBeIBRpSnc7bFX74UJzO4DZQPqdXbEe4YAcWiC
         /vhIyZzZct+N8pgTpmOg1DLcva9ycL6G0BfkqnSMUwqYs+zSA+udV+WorBeQwdxSYcJZ
         uNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OqmQQJODK9vo7ge/B5mit6aPLYvUZlqzcHChoc1YCQ=;
        b=CrgiLTQWmv6KIYyeAiVbwtk4w91kQr+HYgech/hNclqvPKDI7XZmCiM6Fga+cEBRjv
         DqpWAP58SVhuotQP19MIAblLkXnAy0tUcyP4geX2IkhuRjGf/WkKJXsfN+onXk9tU0aU
         H4I3Yl0yMSCx2NLRZ+edSu13ycj3BWr3ZEew04a5dcEwysrNfU8Df3sYN/6tp0TA+ilN
         vbw/whpDG61TxSda32zJTCkLYlKJgDjeUZWDGBWrFWrr/yrK/GHBRVeN67PhBYYPu3mi
         Ux//PFkN1aMgyuRjoJKqhSr3UbQXZh5yswZvBoaw1Lg+AIrdJIwgytHhh6eDKoGjG9u/
         tONA==
X-Gm-Message-State: APjAAAWO6CBEaY9TR0+YPWa3ajRKdczWS+GZ4Lhy4VfNScZGgIhTmMhh
        qLNugOYtsKl5uEi7Iier5v5VNq3Y4feOn7K+epY7eA==
X-Google-Smtp-Source: APXvYqzqgWdV8UxJScltcaQcOuDlIwZa5df7npulO3GcZdYl61HsqySvcNsIK04eAK1TVZwGNGoelGvqxFtQSH+5kGk=
X-Received: by 2002:a6b:8d11:: with SMTP id p17mr1252191iod.3.1575327446607;
 Mon, 02 Dec 2019 14:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20191202185942.81854-1-colin.king@canonical.com>
In-Reply-To: <20191202185942.81854-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 2 Dec 2019 16:57:15 -0600
Message-ID: <CAH2r5ms+DVGP+Wgx+cTe65sBCFskrXBNxNe1gMDr+sEQ1DbqAA@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove redundant assignment to pointer pneg_ctxt
To:     Colin King <colin.king@canonical.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Dec 2, 2019 at 1:00 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The pointer pneg_ctxt is being initialized with a value that is never
> read and it is being updated later with a new value.  The assignment
> is redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ed77f94dbf1d..be0de8a63e57 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -554,7 +554,7 @@ static void
>  assemble_neg_contexts(struct smb2_negotiate_req *req,
>                       struct TCP_Server_Info *server, unsigned int *total_len)
>  {
> -       char *pneg_ctxt = (char *)req;
> +       char *pneg_ctxt;
>         unsigned int ctxt_len;
>
>         if (*total_len > 200) {
> --
> 2.24.0
>


-- 
Thanks,

Steve
