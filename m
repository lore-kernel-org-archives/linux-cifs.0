Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B080C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 18:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219C3233ED
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 18:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbhAMS3t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 13:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbhAMS3t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jan 2021 13:29:49 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7FFC061786;
        Wed, 13 Jan 2021 10:29:08 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id t16so4427556ejf.13;
        Wed, 13 Jan 2021 10:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=trmHdIPzmXxvlf8cnFfbYuNN5Xx/8sKP9KLGzody5VU=;
        b=BTDZuJcxKftMz04Z/cPhM4ZL9+l/nqfnjdT/LnD5R/qav4nUqXSAQWhdQLhDC3XpAR
         lGnA+g2q7AUpzYWX8Sj0L4hZiF7bye6/WJ6tfAjB3tovvYGClF9pr47+IGsczOqXcJkQ
         a8Rlqw1Op9HAyIFY5jHDFXwKGfDTb8YJ69kiNa8JrTcunYDoH7+on7d2EgGBmLfvs+B4
         cz6468d0P9WlCtdQCdvYyTEafV2Rr/B3hSgKtxFpUoeIFPPjyAPqrl2SDQoFQzTuD/VU
         vUx/oqoVEj6MkZiWOl7xMrFH/n3AaconL/O3kevRyOKzex4GbU4xXK4ksan/EWcbbHdF
         Hg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=trmHdIPzmXxvlf8cnFfbYuNN5Xx/8sKP9KLGzody5VU=;
        b=VyKwrWHDa35sVW02f9I71sEnxe9S2bzIyj07dG8UzAsa9rfsK/5a8poIMEiicVpfuo
         W0DxhrQADYU1p5sI0V3L+Bz1hXEs/XiAWjkfHLcbqGEKJyiVRwSjH4zJBYTYfq3adCim
         bt638lTHLnATArmE/QaDFfSM39TILCMMJD+3hGsV9rhcMI/xPsRu8KNJPxudm4U1XAK9
         Q9lYGn4DUiwx48N1QQZDx/SQgZbEXvqW3AnYiUmWB40RzudCYjRSvXlnjhmu0bTZC/cv
         UKc2nxERG0oHGpMVJUzSeoRYMflW6IoCcv6ds6h3cPRKk4mBLDQxFYHSLHsStS39Xzgv
         8nzA==
X-Gm-Message-State: AOAM5332gqmPc1o+bl3ppZMvU1CgCLCJu0ksC923RLfa+qlbN7MCZQqj
        3C9BM0UX5i79g2iyiwZdVzIAvR3q3ERUPAo7aw==
X-Google-Smtp-Source: ABdhPJy1cjnIlFBhUtsw4W/f7OPfIo6L5IWfDAC4rxDzWHCEmtjDAtVqE7+/sXnMZVnvtl3lPR/sBZPfU3w8SQIcyhU=
X-Received: by 2002:a17:906:c7d9:: with SMTP id dc25mr2602506ejb.138.1610562547258;
 Wed, 13 Jan 2021 10:29:07 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
 <20210113171616.11730-1-pc@cjr.nz>
In-Reply-To: <20210113171616.11730-1-pc@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 13 Jan 2021 10:28:55 -0800
Message-ID: <CAKywueSoG8zCqmVgaOtvG5AM4fi47+bFJ3VdHPAa=sJa+v2duA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix interrupted close commands
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Duncan Findlay <duncf@duncf.ca>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 13 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:16, Paulo Alcan=
tara <pc@cjr.nz>:
>
> Retry close command if it gets interrupted to not leak open handles on
> the server.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reported-by: Duncan Findlay <duncf@duncf.ca>
> Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
> Fixes: 6988a619f5b7 ("cifs: allow syscalls to be restarted in __smb_send_=
rqst()")
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 067eb44c7baa..794fc3b68b4f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tc=
on *tcon,
>         free_rsp_buf(resp_buftype, rsp);
>
>         /* retry close in a worker thread if this one is interrupted */
> -       if (rc =3D=3D -EINTR) {
> +       if (is_interrupt_error(rc)) {
>                 int tmp_rc;
>
>                 tmp_rc =3D smb2_handle_cancelled_close(tcon, persistent_f=
id,
> --
> 2.29.2
>

Thanks for the fix!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
