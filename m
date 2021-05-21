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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5A1C4707A
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 18:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B28C61163
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 18:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhEUSkk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 14:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhEUSkk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 May 2021 14:40:40 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B658DC061574
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 11:39:15 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id c10so10085688lfm.0
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 11:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4jKWNREoK56Ih4ObRRyE3L5pIONhAPLoMTVeudZIfOg=;
        b=qPt4d+jPlbdqRTGtNcrxFVWLgRPgpbJoUEvCo+et+gCvEojKsY8ANKqY0RUO5NXyXW
         7UDAGDHTOnBlOgLvhRgHrOk0NMGDtfmbJtekikzn9ltqJLqNaTfYBOrNg7rPV/xoKU5L
         gake5CqbkUZHABIBOMmVOyJ9B0AgyIQgKh7ccoqGrVuYTtEoyqfr2sHXPUKSytffQOA8
         UrHRHk+wYSuIYlMhcP8a2A3Z90gTr8xW+3JoBCPxOGQMmpgSuo5DcHjS5UQ5VUOF9Ic/
         /hdKAztOvhdIwaY/AxT12HMU0mavcUboIQ953NXx6CblNBvCQ57wXX6EdUomYVhWzFQW
         trrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4jKWNREoK56Ih4ObRRyE3L5pIONhAPLoMTVeudZIfOg=;
        b=rZgmfplCDiRGvIoOgmpe2e//l1/Wn63nltlBwI46ScJaFdo7fz4W3V7YJXJLe95G93
         sCF3pakEP1cEN7u0fomzsSrFRU/SdevO/jVsttvIX87uA5GPbHYtO4B600kwRu0yHrpx
         vTJzgwNnnfsgYeCtNRnZElTtbcn+wG6A1q+4NN20J66tadYv+66wBzVb5cVG9kJhL0ZL
         XBrWDvKZYFJ8MDI8+wmd1PtiIGQF7/O4Euh2hD1fRmDRIba6D91BG+dqj+Vt0yX49lEs
         CZY2OMADhuNThdK4rLYFxn5x7WoU35tAAyrz0WU1eoJ5OlBbpkJ3x++/YtwEv40hEIYv
         thgA==
X-Gm-Message-State: AOAM531fqNWGblCemtGwBtl0ceKpfy/iotwZ1c8dMz4CpbRmCbdrcvU8
        PXfjQcIdiptVc7Bly6dUgYBCRo4s+Iqnzw3ucmY=
X-Google-Smtp-Source: ABdhPJwlvJUYo7nD+Tgmj0F0L2JdUegs9L0ZzkiK6eA7mxHFyXK1VmO8WJoYkehibtkSxWAWFJWHeAZAbtHBTFRuqjc=
X-Received: by 2002:a19:c397:: with SMTP id t145mr3131491lff.307.1621622353978;
 Fri, 21 May 2021 11:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210521151928.17730-1-aaptel@suse.com> <20210521151928.17730-2-aaptel@suse.com>
In-Reply-To: <20210521151928.17730-2-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 May 2021 13:39:03 -0500
Message-ID: <CAH2r5mvQCKFZSvMf0FuF6uTzv-OBx7E=eF41V2G1JwgPWUxXuA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] cifs: set server->cipher_type to AES-128-CCM for SMB3.0
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

stable? How useful is it to know for debugging?

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
