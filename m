Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904C4C3F2D1
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 20:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E52A20CC7
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 20:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HSdwRA5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgCCUNw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:13:52 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42018 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730352AbgCCUNv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 15:13:51 -0500
Received: by mail-yw1-f65.google.com with SMTP id n127so4612264ywd.9;
        Tue, 03 Mar 2020 12:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCzvYSdF8vmgaLCTyZpeoxltcbWBACzfXPrjZZqp6qg=;
        b=HSdwRA5Bre9VwcSxMFaoCPSA0sPrtL1sp1XGm7Ny1rzf9Vq9rU/Dn+qUCnDuf2pCMt
         wftX96Y7fd7IIoOntNw7zGMgK57yrEarZLclj6RrcBI5A0f9rHFnPUIasBiiWEMYzwWR
         JzVPPXHJXW5mPHkhi7HCDIvfjhk1qrXsCnqtuEXCiXTVAdieSA7EprD6b3UQY4sTFoDg
         hD6k51IOCmpoxhG6mDgWl5cE3pHbMAxH2ujpxrNvitgm/jb94F+2/6HdxvTcwA5MhZDC
         gwdmUDZmV/s9K21zvY1zt3RLsn6fNQfyWyvFXBreOdQ+zy3RGoBzoLWMMX1OgWArQt+h
         W7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCzvYSdF8vmgaLCTyZpeoxltcbWBACzfXPrjZZqp6qg=;
        b=BIXr5vqsSfmh3vtNyoFZ235atj0qBySD/IJYLt3g+Q1gh+7HT36AHlZNFYA9JKOat9
         1WL7Jzq2AUNZpBIma0prakUfaCScSfdXC2VTXbkXYNPW3ODuXNGDW3zLE7kDL/dOaS2F
         VMUzS6i8R6ZmaCSV6tsoElwkL2s8j4ZL9R8qYPt/oRjANDcyOIVwaw3Fq/IZI0Va2nIZ
         2uOxdG7FER1HBaYefikoRkhi6OdwA/rs2HMqDUU99AK48YkxdZkB1vX01/OXsGbWT05D
         Pc2eaJ9J+/D+Gatj7mTZJaqufQwkuU1dfXF9bYLXTkAPPyp+rJc7Ja7urrMwwT0XgqMi
         s58w==
X-Gm-Message-State: ANhLgQ3arakZgpQPTOFbw6MjZdWnj0qmMhT4QQMSLD2wS08lQCBymKOB
        LjsTb9pUO0P5cAJnrOX5QR1rPly176gT9fBm8xBXGW4v
X-Google-Smtp-Source: ADFU+vse4AsegA7GlUrSvWXsI5JQFIAMJz76HINEijP2ceCWNl2LChFRI5gUzeg5y40xNet9+LnNSpv1FKu/Ff1YFSg=
X-Received: by 2002:a81:6c55:: with SMTP id h82mr6562001ywc.381.1583266430034;
 Tue, 03 Mar 2020 12:13:50 -0800 (PST)
MIME-Version: 1.0
References: <1583250197-10786-1-git-send-email-hqjagain@gmail.com>
In-Reply-To: <1583250197-10786-1-git-send-email-hqjagain@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Mar 2020 14:13:39 -0600
Message-ID: <CAH2r5mv2VrSBT_MvUNjd=h354v=29htRQdLSEZi+pDtdggNfoQ@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifsacl: fix sid_to_id
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Doesn't rc = 0 have to be set earlier (preferably in the declaration
on line 345)?

since line 392 does
            goto got_valid_id;
which appears to leave rc unitialized with your change

On Tue, Mar 3, 2020 at 9:56 AM Qiujun Huang <hqjagain@gmail.com> wrote:
>
> fix it to return the errcode.
>
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  fs/cifs/cifsacl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 716574a..a8d2aa8 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -400,6 +400,7 @@
>         if (!sidstr)
>                 return -ENOMEM;
>
> +       rc = 0;
>         saved_cred = override_creds(root_cred);
>         sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
>         if (IS_ERR(sidkey)) {
> @@ -454,7 +455,7 @@
>                 fattr->cf_uid = fuid;
>         else
>                 fattr->cf_gid = fgid;
> -       return 0;
> +       return rc;
>  }
>
>  int
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
