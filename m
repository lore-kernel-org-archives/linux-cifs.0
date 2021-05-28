Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40451C2B9F7
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 14:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F0D5613B6
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 14:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbhE1OgN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 May 2021 10:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbhE1OgM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 May 2021 10:36:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E58C061574
        for <linux-cifs@vger.kernel.org>; Fri, 28 May 2021 07:34:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v12so3514643wrq.6
        for <linux-cifs@vger.kernel.org>; Fri, 28 May 2021 07:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qRDzkcOwTq21ALKO6Ebgz5xG8QP2D/4o2Z136j1fnzA=;
        b=UMuiiMrq6JSwdnTa4IPEKXj9Nq4yU+HFbRxEnd2lrFvpCjjCLXFqiR0mPaaTOLYIc2
         VWuHsTUY/ga6rOaK3OE6JLIZW/MytVQxWXUHQjkVNRdgUp9sKkhwWFFZhbZS8rIbh8Z4
         hyAqSxTEh7JxxGAGKtVTGdtNgtoRC3OfWq9d9smk32uEhfSA5FytqAqyGMZOzXi08bmp
         e+E2XquGe6XH68OoQkJoMuafGcr1s2ync/XVup8kl3QpDtjbUitXYEc/Iw3XJNEp5Chg
         yM0P6a6EZvAgV+uHuu0P0HagBancxHO2SaFvxmXdsliBeE8cfUJusfWNGnxHMhavzln7
         vd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qRDzkcOwTq21ALKO6Ebgz5xG8QP2D/4o2Z136j1fnzA=;
        b=LdOlPjs4tmslvFIIZVo3BLBEkX85Ya+gon6HON/JlzgSK4zxZNRMVTyVQFtnvdWW2C
         JUPJtGCF5UeO16cMVLpgybCHzZ7M14NAVRoAxA2rSIuzvnTRAb8ugunMFnefkc7h9xqW
         DAF4ndvOSF+lSYWPESlb+7ZeLopxFtJDILxxjtU37J59VhPmj9FwCebE0e76+MfyMn8a
         p15YrcejZnCUzp5XIU9quwZ2fnb26vv0jMtyb20ridDSnH60+T3VEHTn3YPbvYOz+1Jz
         mftwpBwHsF1on+XYEY3j4VZxLaaCRTCh7poF/1pblYmd1xnUnMMfwK2UObnvjt3ph1fl
         gfUQ==
X-Gm-Message-State: AOAM5331qoWpJDurkqdW8r6rqf87RVrYA1U02HjGtRYwb3vX6kTgy3WN
        OBXnPYlcH9T/wxa2ASd0E17AXqXrax/oPLrN97g=
X-Google-Smtp-Source: ABdhPJwq5tq4ljPcZRfnMHEHR807S4zeWhfJsK6nd6HqJyTcjGke8FQcI44WNIO8DPzlaGOuL4gzh6e61kYEn8CPnVQ=
X-Received: by 2002:a5d:4e85:: with SMTP id e5mr9122682wru.68.1622212475357;
 Fri, 28 May 2021 07:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210528143248.7521-1-aaptel@suse.com>
In-Reply-To: <20210528143248.7521-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 May 2021 09:34:24 -0500
Message-ID: <CAH2r5msNcxbZ4h+U2bg-kFiie=gjSDk_jUoZDcNsGMkcoD7VVg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix ipv6 formating in cifs_ses_add_channel
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

good catch

On Fri, May 28, 2021 at 9:32 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Use %pI6 for IPv6 addresses
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/sess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index a92a1fb7cb52..cd19aa11f27e 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -195,7 +195,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, st=
ruct cifs_ses *ses,
>                          ses, iface->speed, iface->rdma_capable ? "yes" :=
 "no",
>                          &ipv4->sin_addr);
>         else
> -               cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rd=
ma:%s ip:%pI4)\n",
> +               cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rd=
ma:%s ip:%pI6)\n",
>                          ses, iface->speed, iface->rdma_capable ? "yes" :=
 "no",
>                          &ipv6->sin6_addr);
>
> --
> 2.31.1
>


--=20
Thanks,

Steve
