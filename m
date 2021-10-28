Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CA2C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 23:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0817E610A4
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 23:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJ1X5u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Oct 2021 19:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhJ1X5u (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Oct 2021 19:57:50 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965A8C061570
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 16:55:22 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id i6so652104uae.6
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 16:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mPhshzVYr1FfNMZTJ6+XagR9YX8mAmVtCDwpyuliOfg=;
        b=EEWTug60XmU97q9pTEP9d8jE0UV0/w4756hvuj7hrP8pd4aq6vYtBWhXY0R0SxsSJh
         7JugRB0MiswLahvoPPVaVMVlHePVWaANXk6X2NgmdVZbD/eJg46UCgr5B7f4530T3hbD
         OUkNsmML08Glwtumdkmjy7PESobrnIV4hLRFY9BeQOUkiczx5IBQhHd2WYTV5wLNEDRC
         WYu5AxW/V412L88tk7IlN3OUUANmshunUd92E/kVsRJxOPPZuvW8n151sPUUyDD2uE5w
         Jko7+q12hRGL5RBSBbeZ9td40Ts/KQ+oZd+1rspjvP/j5nSVLnVvVlUfYoJDIUNRmNQA
         kVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mPhshzVYr1FfNMZTJ6+XagR9YX8mAmVtCDwpyuliOfg=;
        b=a/zlSFkPGAwXI9Fmdlz7Axxiznfe26wjGAEINV2bb42sCRBaQad98ZRz8Dsjpqg1ri
         CHS8ssspDVNmkp/Z26QiXWfi9jBslU4CuEXCf0YOBRBHeS4niceMKywBpk4enlOkTK1C
         m0i9GWyG77tFcVx9p53bZMOS0lPtKZmBXuaGfg9OU3MQ9XWpM/IocKGcU1Ad+jHuWr/Q
         64Af3TC5baSrnwfbyj0ARBMQOQxl9/Ca5QWH7xyszcuI6WVnrBr+YgpujC1Bim916jI6
         djZHf5YfBBAK2JWjhkmguuLSvDS+WxehzXeTk2YOEY9EUlXsrPssqS1z0Ao5Y4g366t1
         6oBw==
X-Gm-Message-State: AOAM533ZBfoY9Pvp5EZfkwb1nkWt99H1PxFg6RjWpnyehyt5U3LtfTqt
        qw7rwDnJYR/fD92GRsjYYUHMTRy5XpoKxZr7nW3zR74yYdQ=
X-Google-Smtp-Source: ABdhPJxmOs+zjMxF992JeXuxA2BDGVZzbBPFm6VpYgHyi/BHPczt7DLWWVUY4Udkb7woeFVMXrqa/CkRo8vNLHMg/Bw=
X-Received: by 2002:ab0:1c4c:: with SMTP id o12mr5751664uaj.136.1635465321779;
 Thu, 28 Oct 2021 16:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211028231317.18522-1-linkinjeon@kernel.org>
In-Reply-To: <20211028231317.18522-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 29 Oct 2021 08:55:10 +0900
Message-ID: <CANFS6baEimPGUs=paOoc+MCPC2+A3EAqNGiSmVbUmNGMtdyAiw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: don't need 8byte alignment for request length in ksmbd_check_message
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 29=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 8:13, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When validating request length in ksmbd_check_message, 8byte alignment
> is not needed for compound request. It can cause wrong validation
> of request length.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2misc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 2385622cc3c8..0239fa96926c 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -353,12 +353,10 @@ int ksmbd_smb2_check_message(struct ksmbd_work *wor=
k)
>         __u32 clc_len;  /* calculated length */
>         __u32 len =3D get_rfc1002_len(pdu);
>
> -       if (le32_to_cpu(hdr->NextCommand) > 0) {
> +       if (le32_to_cpu(hdr->NextCommand) > 0)
>                 len =3D le32_to_cpu(hdr->NextCommand);
> -       } else if (work->next_smb2_rcv_hdr_off) {
> +       else if (work->next_smb2_rcv_hdr_off)
>                 len -=3D work->next_smb2_rcv_hdr_off;
> -               len =3D round_up(len, 8);
> -       }
>
>         if (check_smb2_hdr(hdr))
>                 return 1;
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
