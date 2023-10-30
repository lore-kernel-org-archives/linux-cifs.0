Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DAAC4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 12:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjJ3Mvp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjJ3Mvo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 08:51:44 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B54D3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:51:42 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-507a3b8b113so6356349e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698670300; x=1699275100; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMgCo6a/aqYJkcdpD1HJrAsw5ftXhvegVtE8ZQqMwLg=;
        b=DA0x7R/ethUyri8K0/HbweAECWnfdGrG3FCrs5b3J3ARuxjlv5fUicNA1GXIWBWAd9
         FLAO7DIxtrT0l8hNJ61eaJsUMFltnAr8rl+K0VHexuU5HQrH3ZSHVThLg1cbw2/hzUmh
         KQ1vYcZ3K1XpXEGOiENCXUU6ClMF/z1LkG6TJoEatZthHRH2JAQstgQRuqt7rCKOIH5A
         Aw1aeS9VpX8X/eif3iTXy1TR6sj+ImYBdGQK0ov1ufOMTbRAv3x7UJNO5B0jNzFlF9Tx
         sqFj3kMcBBpPGbZl5HwDhuQJig8HvrahQaFITPEnO1ofu9RoeM0HmCu5WV0tMejpO0G1
         KaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698670300; x=1699275100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zMgCo6a/aqYJkcdpD1HJrAsw5ftXhvegVtE8ZQqMwLg=;
        b=I+KS2fjLoRPMasZnVWJEUz4T3gEYo0SrzpGt7zjb8VOFoYh9ZFAPo7ScXLCwgvvNqQ
         fU9OGfsZ6zKoHmOTguUAgOQy44ssyyrnWQcMwYcBYIfmRF9CS4dGsuviaAqH9rQi894V
         zSf5hosVOvCgANeHL4w74ovNT3T/drp5V28LjSnBIIz3JvSBVZ+sFLeTL2g+8f1gxm3K
         fiCNPwu/nxNjWSKEWM0SK1kT1Qtw5CPU9+J55QeFOx8fkt7227Hw3HyllfHP0UCqj3Bp
         L2NNIdeR9RnDfduI5FNn2BgCBcKxzUr4cGRZcz0UoYKQtKvy/Okr5uJrtuZ8zblgWMum
         QeyQ==
X-Gm-Message-State: AOJu0YxV0HnJcXhVN6mvw67gBsKR0uKGexBajdgXAoJk6DQcN9pqkm0w
        knqk6EW3l0V7NK03iJ7E6vBqsITmS+JnZpz25C4=
X-Google-Smtp-Source: AGHT+IHEuzKJuDsj/9Oq6oq9bdYcsAR4LSsKlZkHScxxBaTkXkUDltTZvlD7MqLRZKw81H555teD7VKasOuYpEMdvK8=
X-Received: by 2002:ac2:4c94:0:b0:507:96cd:e641 with SMTP id
 d20-20020ac24c94000000b0050796cde641mr5957693lfl.51.1698670299945; Mon, 30
 Oct 2023 05:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <CAGypqWz2sq7w3SkjD-9hTFA7_uY69DrdYGpKek9iH2x5SHfz7g@mail.gmail.com>
 <CANT5p=qJyHAECHANqAc+qas8Aadq0Or5FXo1JBy-6qQFrLd_yQ@mail.gmail.com>
In-Reply-To: <CANT5p=qJyHAECHANqAc+qas8Aadq0Or5FXo1JBy-6qQFrLd_yQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 30 Oct 2023 18:21:28 +0530
Message-ID: <CANT5p=qpPqK0KM2XANyTh8dHYSKNoN-VHbtN_0Jk5uLzwmNxvg@mail.gmail.com>
Subject: Re: [PATCH 01/14] cifs: print server capabilities in DebugData
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     smfrench@gmail.com, pc@manguebit.com, linux-cifs@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 30, 2023 at 6:10=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Mon, Oct 30, 2023 at 6:04=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > On Mon, Oct 30, 2023 at 4:30=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> > >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > In the output of /proc/fs/cifs/DebugData, we do not
> > > print the server->capabilities field today.
> > > With this change, we will do that.
> >
> > We already print session capabilities in DebugData. How is it
> > different from that.?
>
> These are capabilities at the server level. That one is at session level.
> Actually, there's tcon capabilities as well, which I think we should
> also dump in DebugData.
> I'll submit a revised version for that as well.

Actually, it looks like that's already done in smb2_dump_share_caps.
It would be even better to print server capabilities in the symbolic
form similar to how it's done there.
But this works too. I think we can do a follow up patch for that if needed.

>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam
