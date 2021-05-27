Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADE8C47089
	for <linux-cifs@archiver.kernel.org>; Thu, 27 May 2021 20:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E465F613CC
	for <linux-cifs@archiver.kernel.org>; Thu, 27 May 2021 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbhE0U0Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 May 2021 16:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235524AbhE0UZl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 May 2021 16:25:41 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F91C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 27 May 2021 13:24:07 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m18so946874wmq.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 May 2021 13:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YWhEsxvNv4qY267geWNN/rHe3apoNcbIU88MrIw09IY=;
        b=gQaxUZDjg1UZ+9YcFcS96sdmtIdOKMike+on8kA9BuI99M4+eF2rU48RBQSKEuOF8D
         tlpZ3b27wdwFIhlj66IujKC874QrbpxRiGHYqJjS/snfJVf0zypYWZacZ3gXZKV5j80K
         WBQbwpENlBF4bHIVeU/6153aLF0yL00CcL5SPlqWlVlJ3VdpKBkwjXAnI3+dBQaDDXdP
         n4pGr6dbwDaDIA5dsMddBgV+5R39c4xBbPzGv1+po17NUEEWGa/9ynOb9gRSulKnrcKu
         +SEC46s0iTu/7Bc/BQw9//F0jejz9H/XiOQ3tvxPo0APU/OZ2ALOIg/QJofzV5dknknL
         TqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YWhEsxvNv4qY267geWNN/rHe3apoNcbIU88MrIw09IY=;
        b=cylibTbtj83PE0hSXAfVS3fE4jWhyiSx6ITzGViwadBee9F2QR3SGG+69F5xFGjkhi
         xVoz5sTYf/fbj4YrlhL5XKTinURIQ+6yc3SLVzGwY+RZSZfXyTKKrJFY0beovMPNi0xm
         Tn+hzLL9+OwgxBjEdq7ZCfIp1kswfQajU570qvWEoh33VrD0c6AOOm4MpaSjfyJ3fzns
         bbwWDYiU9zO8Gax7COlHoUHkb0Fy+8TbkUplaCLhD3wnHb1uVsURi4Quf3ZFhAKrb11C
         F9PUg536LEeTOvn5/auxGx7bPB8JEhvlZ2TaWZ915j4qQfhLO1qo4svVHBYj2i2jHX5B
         36/w==
X-Gm-Message-State: AOAM530aC96znAgm/vQ6T5NQTQN0MRDES5yZdPGBec/67rFOQyUTnFz9
        dAG1355FJY6qwYxHFw0yQK9Zu0e0QE5h4DkBQh6PcmulK8Q=
X-Google-Smtp-Source: ABdhPJz0zWo9wue/1lOdEvv8YCCT/Sc0xWI/N183E6xExKXIJTQLicXZ0EpJLD/Wn+zRG1o6lYjGpXRq+osK5TFTEXo=
X-Received: by 2002:a7b:ce8d:: with SMTP id q13mr4229434wmj.67.1622147045973;
 Thu, 27 May 2021 13:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210521151928.17730-1-aaptel@suse.com> <20210521151928.17730-2-aaptel@suse.com>
In-Reply-To: <20210521151928.17730-2-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 May 2021 15:23:55 -0500
Message-ID: <CAH2r5mv3CfzEdWFrGzA2JYuW4dgHcXU7CDuZ6X=sqcjx6fH3mA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] cifs: set server->cipher_type to AES-128-CCM for SMB3.0
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added cc:stable

On Fri, May 21, 2021 at 10:19 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> SMB3.0 doesn't have encryption negotiate context but simply uses
> the SMB2_GLOBAL_CAP_ENCRYPTION flag.
>
> When that flag is present in the neg response cifs.ko uses AES-128-CCM
> which is the only cipher available in this context.
>
> cipher_type was set to the server cipher only when parsing encryption
> negotiate context (SMB3.1.1).
>
> For SMB3.0 it was set to 0. This means cipher_type value can be 0 or 1
> for AES-128-CCM.
>
> Fix this by checking for SMB3.0 and encryption capability and setting
> cipher_type appropriately.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/smb2pdu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 9f24eb88297a..c205f93e0a10 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -958,6 +958,13 @@ SMB2_negotiate(const unsigned int xid, struct cifs_s=
es *ses)
>         /* Internal types */
>         server->capabilities |=3D SMB2_NT_FIND | SMB2_LARGE_FILES;
>
> +       /*
> +        * SMB3.0 supports only 1 cipher and doesn't have a encryption ne=
g context
> +        * Set the cipher type manually.
> +        */
> +       if (server->dialect =3D=3D SMB30_PROT_ID && (server->capabilities=
 & SMB2_GLOBAL_CAP_ENCRYPTION))
> +               server->cipher_type =3D SMB2_ENCRYPTION_AES128_CCM;
> +
>         security_blob =3D smb2_get_data_area_len(&blob_offset, &blob_leng=
th,
>                                                (struct smb2_sync_hdr *)rs=
p);
>         /*
> --
> 2.31.1
>


--=20
Thanks,

Steve
