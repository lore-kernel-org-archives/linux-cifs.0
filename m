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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ABEC47082
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 04:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8131B61008
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 04:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhEaEcx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 May 2021 00:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhEaEcu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 May 2021 00:32:50 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE35C061574
        for <linux-cifs@vger.kernel.org>; Sun, 30 May 2021 21:31:10 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a5so14927993lfm.0
        for <linux-cifs@vger.kernel.org>; Sun, 30 May 2021 21:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bIkcDtH56sinAfWg8xsMCLuNZcRfeogON1KPDAO3M1g=;
        b=T0XzbhqD0f3e6OqnTELqbw5Nj/5TwY89b77HXbzp6pret2pzY6hLK9fp4OCoaW996X
         hpH0Rja51bFqtPY3XHbAeAkTuh18S+BpqwfmH8FBk2Qiavf2RkrN/QGSWMwp8AsGGL4L
         7ksza75moHm/xMuRyvlRUKLC3ENdNlDnMVpdNdGZfG7MHcFx3yJzYM0GhYWUYZlVb2fF
         00y6hS1tkhLiJTOJ6WIfns3mx+nBm+R2bHSLRWu91ilLfP0vt7892QKIS1t8Bw4PNCSn
         bG5oX98I2Yo7yhbm/l8QoPK/CfBBNOyloWjF+hn+9GoOfUXHXYMgv4CJuhM5nN7HhMPp
         b28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bIkcDtH56sinAfWg8xsMCLuNZcRfeogON1KPDAO3M1g=;
        b=Bn0jK36XCpN4FZfD88RV2Uw99/bVED3bUyVY/Oz9krBvRH1hiw7t5pjqLg1lfRiASl
         EhvOhtBIhUqNdhzMPgAemEaQxY4zTLIhFySiBIPxEw3iXXj6+zg6IKOcRDPUzRN8abRK
         7pA+561dtRFjLvfBny3cmNJWeYHa9i04YbyzuFCZGCb9ZVyGrAE5yTpEX1NEp/ttlwEc
         AYSWvRt6kvsSjsx4CXT8G3jxHP74fjaNtXPu7QlXNCxOAonKJrSmF8kqxLMTOnPDBPxO
         EwEctRW39O2nnveCHRKOuino1Dqg+7Yf9SIZe86vTr5cbVAsmDR6RcD0j+w+5FFW5Uit
         BNIw==
X-Gm-Message-State: AOAM5319GXV21Mz9A6PmUg46HOpkRCrJdBSWZ2OX44CPTo1TA/Eezppt
        Q+NTBZlpPoT3ZYmGKJtNHZeXYnLE+Ms8BElMluE=
X-Google-Smtp-Source: ABdhPJwt1Aaz4t8SqA+93MeUulKZkDc6OESetODtSyt0GkqG9TsmkFVXr+4m1khk98rsyr1K/vdnxVbEVtsOQmcmddY=
X-Received: by 2002:a05:6512:344f:: with SMTP id j15mr6295668lfr.175.1622435468922;
 Sun, 30 May 2021 21:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210528143248.7521-1-aaptel@suse.com>
In-Reply-To: <20210528143248.7521-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 30 May 2021 23:30:57 -0500
Message-ID: <CAH2r5muTVLS9J7QCpQvKozUz4txVvBeY0hbDYKRfjEpMJvscBw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix ipv6 formating in cifs_ses_add_channel
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

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
