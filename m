Return-Path: <SRS0=Ubs5=BG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D3DC433E3
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 01:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F415C20719
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 01:30:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rqxjvg1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgG0BaM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Jul 2020 21:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgG0BaM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Jul 2020 21:30:12 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EC2C0619D2;
        Sun, 26 Jul 2020 18:30:11 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l17so1511450ilq.13;
        Sun, 26 Jul 2020 18:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=At1n3bfLBmzVh8svaQUG7cNrFCFewk1UeCPKO8UbSNA=;
        b=Rqxjvg1MjVMrZekSgd6Ma5pm0x3vOYks0eZwXakY57aRxoSt4xfYI1sNpBl1AoTkIx
         mCF5Ii61O+5DgO9RN+hNQT/drTdN5hOf1odT4b9uLZoQ/dWpFjrJvSTCn42oPrGFPVvB
         bEmSfat9IMCZqfKcDIIRC2NnbuywiKzVpMU8FCcowsZ//LwHkm45dT0dWjAEYIvD084y
         5A10aAvpQ2vyDJMIeR4Dwp6Ij8599td1OZQPc8ngSl2SH+1lq8ix2lxm0sCqujhNgLMB
         gAiUo3U6yN8eIqoH/4J9Ce0VioL5iEn1NNRYslUjGjBSC4Un/+1e1yNBK0h3oJGMlNM+
         ef/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=At1n3bfLBmzVh8svaQUG7cNrFCFewk1UeCPKO8UbSNA=;
        b=pwI+H76IqC1JY64U5plK07SK6rqRFNf8PUldJ74q4Wjd8wAHJVj+f+7AsDx/2PAhyd
         tYcBjdfk4fY7UEnUo6Ou2h3/DJmt0P8RoTd3C3K4Qd4I11NDXEFsGh6hkZkzqYzRX0uS
         7HPWSuICnGSOno95JTHfhpGU8A/grTzaPxFohXODZP0rD8k8GhN8/yaaK/Rr5LUaf+A3
         BLMIuYxLKpNy61d8KrJYxTShIQ8EpoJZM/OmJplweoFyRHBiEspuYYc40enV4itYYeZx
         CJdJ93DFwKhSjzsA+JSUsrgyOHWbp7lgd+MItSp0u4VqfQM9sqdUFAcQJjdZYBSYyS0L
         zdTA==
X-Gm-Message-State: AOAM531X7zinSr52GCFG+USuFo4QbOhl2km7rMWd4ZOiAyliMDRPB/eh
        hodsqqp74qZadG/Ef6fYil6VlPJ8lY70JWo5dwkeWQTY
X-Google-Smtp-Source: ABdhPJzLcl4LeBR3LD0Z44ay9UICBYF6WTtLTanTfzs+O1DHog2XbM6Zp/aQZLyPPREeNlt6AZF8nOLop7BXsmyjXhQ=
X-Received: by 2002:a92:6e05:: with SMTP id j5mr143549ilc.169.1595813409750;
 Sun, 26 Jul 2020 18:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200725085601.98074-1-miaoqinglang@huawei.com>
In-Reply-To: <20200725085601.98074-1-miaoqinglang@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 26 Jul 2020 20:29:58 -0500
Message-ID: <CAH2r5mvk9BJVPGLZzRnaf2uZs1YEFDzYNg++F3WVpM0Dvhartw@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: convert to use be32_add_cpu()
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

and for-next also updated with 5.8-rc7

On Sat, Jul 25, 2020 at 3:53 AM Qinglang Miao <miaoqinglang@huawei.com> wrote:
>
> Convert cpu_to_be32(be32_to_cpu(E1) + E2) to use be32_add_cpu().
>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  fs/cifs/connect.c | 3 +--
>  fs/cifs/sess.c    | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 889fee586..552975420 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -5114,8 +5114,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>         bcc_ptr += strlen("?????");
>         bcc_ptr += 1;
>         count = bcc_ptr - &pSMB->Password[0];
> -       pSMB->hdr.smb_buf_length = cpu_to_be32(be32_to_cpu(
> -                                       pSMB->hdr.smb_buf_length) + count);
> +       be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
>         pSMB->ByteCount = cpu_to_le16(count);
>
>         rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 6708ab0aa..69cd58566 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -938,8 +938,7 @@ sess_sendreceive(struct sess_data *sess_data)
>         struct kvec rsp_iov = { NULL, 0 };
>
>         count = sess_data->iov[1].iov_len + sess_data->iov[2].iov_len;
> -       smb_buf->smb_buf_length =
> -               cpu_to_be32(be32_to_cpu(smb_buf->smb_buf_length) + count);
> +       be32_add_cpu(&smb_buf->smb_buf_length, count);
>         put_bcc(count, smb_buf);
>
>         rc = SendReceive2(sess_data->xid, sess_data->ses,
> --
> 2.25.1
>


-- 
Thanks,

Steve
