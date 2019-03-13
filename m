Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0A1C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 22:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17A4921019
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 22:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fi3Ge+JO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfCMWOd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 18:14:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35169 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfCMWOd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 18:14:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id h39so3898479qte.2;
        Wed, 13 Mar 2019 15:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSeST17t3RS04gASTvmKouC23Uer3g+QIxo7NXIdLL4=;
        b=fi3Ge+JOEd2F3d/WCT0EiRoSeZYUByR8Fs/+BJkaCeMW5Mz/qve4JY0MrlCXno4ByQ
         P09jrMF8uT6NhoOwC7qMbHd7vQD9kQsF/0NOf0Q7Q4vp0ZP+FdgbGSCtEqwJX1+uUrMp
         06deZRTsGtQTuI0B+VRwSgnwYswTPmdM/Noev5fFL8Y5nHMYxCqpCjguSrtoHTFr8VxO
         Mb7cvdhzk0p7YbnEruy7r//KjVjr4MIAFiMws/B0g8+klFoE5zPI5d8MJvlw06OfxtRl
         1pSSLBbPQBLiNhRuq+Dd2kFEZkUPSIiHm80grF/LyK55pgC76t3BS9qxhiZukO1/SvJI
         IPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSeST17t3RS04gASTvmKouC23Uer3g+QIxo7NXIdLL4=;
        b=m/baMePMM+x7Th4lFrbRBDiudSbo9jn/ulIkQUAd5fOQ00PMcZcgpesiEgntgCVqbR
         TJVv2rxwRd1WJkBScHavTjbSdBsILkNBF5R4oxxDKtNTg2mIYCDjsYLYKUkgZ6nVbTNI
         qpe3NeAZcQn7iy3bTH6lAt/8uYrbS8l/k6ZAssHxtusllUw2yqU3QglcyPCQHtG5nxus
         Usf33UFI8E1nVzYO6DH2xdPbMSDl/Qr9TiqHzB/D54ZiR7sVr87ChF8sW/DI0wE9M3WW
         kERG21xpHxce4CzvD1Wl7ovHXRjvOJDZMA70c2KZgIMVbl0J08kJbuaTgN+dt7pW+lQJ
         LXQg==
X-Gm-Message-State: APjAAAUavA7813EsbDwRDaShn9egw02pHP652ld2Cq/Ko9TEUr/ihGYX
        BPmqs3XNvc8HHEb4jRJVqh6hPD6UZobzDj6GE7CY/A==
X-Google-Smtp-Source: APXvYqwaC1I3oqg2djOxajVrmIT8HH8hEmLhvc9wslX4sglFbwc2pd7hwx6JJs2cjIPXeFeTLJANEIpsWJAk3Sm8ZsU=
X-Received: by 2002:ac8:3957:: with SMTP id t23mr13499678qtb.331.1552515272616;
 Wed, 13 Mar 2019 15:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muaceyqkrbXB7Bt-qv_vtVqZEmpafJa6B2+8kyRsK7ftQ@mail.gmail.com>
In-Reply-To: <CAH2r5muaceyqkrbXB7Bt-qv_vtVqZEmpafJa6B2+8kyRsK7ftQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 14 Mar 2019 08:14:21 +1000
Message-ID: <CAN05THR2MpsVC9LwDfFDPA4nD9VWjKeF25Nsi2vJ=gC6=mNqVQ@mail.gmail.com>
Subject: Re: [PATCH] [CIFS] Remove unneeded statements pointed out by Coverity
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed by me

On Thu, Mar 14, 2019 at 7:53 AM Steve French <smfrench@gmail.com> wrote:
>
> cifs: remove unused value pointed out by Coverity
>
> Detected by CoverityScan CID#1438719 ("Unused Value")
>
> buf is reset again before being used so these two lines of code
> are useless.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/connect.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b95db2b593cb..a8e9738db691 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1191,10 +1191,6 @@ cifs_demultiplex_thread(void *p)
>              continue;
>          }
>
> -        if (server->large_buf)
> -            buf = server->bigbuf;
> -
> -
>          server->lstrp = jiffies;
>
>          for (i = 0; i < num_mids; i++) {
>
> --
> Thanks,
>
> Steve
