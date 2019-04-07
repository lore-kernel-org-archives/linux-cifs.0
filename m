Return-Path: <SRS0=1DbD=SJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1B5C10F0E
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Apr 2019 03:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4168820880
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Apr 2019 03:28:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9l2CDKS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfDGD2Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Apr 2019 23:28:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40134 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfDGD2Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Apr 2019 23:28:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id d31so749642pgl.7
        for <linux-cifs@vger.kernel.org>; Sat, 06 Apr 2019 20:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZiJoZy2vrXoItvRAuotJxrKAhRSc1Mjx4GdmiBTDpLo=;
        b=Y9l2CDKSA94o2m+marFjVhFIUtDfcWCmkr26De8pPDkuSDdVmLSSxl/jygI/mvdc03
         sTsdT2pERZGWxzsFTzVY+Zqq/QDCYAdUfA/WkR8J3dbNt2Mbt5M4iLh5uP7PHffYAZK1
         qnYL7QfpWjVT7o9+BfG5qABpz9X5KgwZyrd7BrkyDwhGsDYbu91IzojXmgctIATpHfcL
         SY4SGWirX5jnMHvzpu/wKo802KSaSiAennus5UfrYomA+3e4lmRIkIi8z56SY4MMYVEl
         1bJ8c8UUMGVv4cuccMNjxDfQlt04dramGsXFkGsfeYn/7E7ypl2cAubHlqx8muorcQki
         vUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiJoZy2vrXoItvRAuotJxrKAhRSc1Mjx4GdmiBTDpLo=;
        b=LfpnUo0OBcyMNA1pQY4Gaduzwm26WX7kTl7V6AVG9EZmNwgjEpMbVbx9vMmxAN5LSW
         gr48R2qF0VDEs1fv9oliqWZMtsc0EZ368h3uQsp1pzTLSTGxxkDNNlV9Bd13V1DhO9MD
         2yRzSmLQade5qxUf7oZp7d11fO3LAwrvoWOHnLslU4qAXkoIWJ8QPQjG0EyZgM7MiPWu
         FpC5LFSgQP5QRFjG6Q6v1dkB/O98SsvCPLLWP6KebG9l1e70EfGi2mMzlZ+KnBF6SM+8
         v9RcU+5Ma0cTlRnFfT1GbUroxsIge2430RnNV6TiNMDQ/cwhLq0Mx3t/VNiME/oRMtJ3
         Rqqg==
X-Gm-Message-State: APjAAAVLgqptg8HnVg48Hwu372n1E92VsU+qSy2wGO1FbMU8zjs4m7fJ
        WRbjlmscSxxTL8AX/9dGKelPhMR0EK+q/a+4tq0=
X-Google-Smtp-Source: APXvYqyUxiMnvS6889l7Gvi+mBvY94Kldz6fFOm8MrO2s50WVrjxdRpLSoNpRIc4NUAEiNxT+yxXO+NTD1ax4cFPWtM=
X-Received: by 2002:a63:525f:: with SMTP id s31mr20855950pgl.172.1554607704595;
 Sat, 06 Apr 2019 20:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <1554536859-139778-1-git-send-email-zhangxiaoxu5@huawei.com> <1554536859-139778-2-git-send-email-zhangxiaoxu5@huawei.com>
In-Reply-To: <1554536859-139778-2-git-send-email-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 6 Apr 2019 22:28:12 -0500
Message-ID: <CAH2r5msQJ1KjAf5P0WiRWX+Kcj-UU=UK1yjkWT-ZZ6_KXsykBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cifs: Fix use-after-free in SMB2_write
To:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Presumably cc: stable v4.18+

On Sat, Apr 6, 2019 at 2:45 AM ZhangXiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> There is a KASAN use-after-free:
> BUG: KASAN: use-after-free in SMB2_write+0x1342/0x1580
> Read of size 8 at addr ffff8880b6a8e450 by task ln/4196
>
> Should not release the 'req' because it will use in the trace.
>
> Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugging)
>
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 21ac19f..6cf4e88 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3752,7 +3752,6 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>
>         rc = cifs_send_recv(xid, io_parms->tcon->ses, &rqst,
>                             &resp_buftype, flags, &rsp_iov);
> -       cifs_small_buf_release(req);
>         rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
>
>         if (rc) {
> @@ -3770,6 +3769,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>                                      io_parms->offset, *nbytes);
>         }
>
> +       cifs_small_buf_release(req);
>         free_rsp_buf(resp_buftype, rsp);
>         return rc;
>  }
> --
> 2.7.4
>


-- 
Thanks,

Steve
