Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C608AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Mar 2022 00:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiCCAv4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiCCAvx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 19:51:53 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809745AC9
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 16:51:09 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id u7so4621799ljk.13
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 16:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKFSF7MRn4RD8kJD0JeqBVCVJ3EJ3QGDTxIuE+JKKlc=;
        b=N4W/mHdUxMLhKDYm4EXBOpGR1LzgGEbDRtFg8Uw+7ULGn1zMR1qVw8F12LuDfSX7WM
         +UZpXxAH2RlpXEr1DSYOoRjl973nvFkn6xR3p4/F28kuztWFRkyXsWogbSguSXKA8Llw
         Gzv+NYJiwhY9x1qWLL/y5bct3E9P9S+LJO7/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKFSF7MRn4RD8kJD0JeqBVCVJ3EJ3QGDTxIuE+JKKlc=;
        b=6Sh8H7kPL+d8aDK+0m4/K6iG9DEYcgaO3EBr8e/AbcO7EGrGLKZhCT/6SIbseIEtDV
         LsVfEuZjnYFb5IoZ7aLNOX/8Y+LWhsndExX68EkzTohOEuSPPReQdkJ3SoGiWpr9NxKe
         uIiW8c8c6WTRa/cnIJ6pyll05Jy7WH/Ag+zIAA8Uw5F5WuHwGejG1HT/P2BtatYTHxRY
         0MPCsOdNQ9LbDAG/obhtruvyWgBx+R6GQFO8Du8QA2W/IRLUYhk87ylSRqXq51yaDgxP
         pb9h9hr3E5xYeGOUm8FNeuJQLelwAaLgLz9o3J9k3BqN+gLBAJP8/u3k5noND3hS08BL
         LahA==
X-Gm-Message-State: AOAM530iRkV0ENNdsy14TUM7X8UFdNy9LE4l6f+oxb7rgcL0fFEaSXDo
        Ib0IVkmw6v+kGhB5NFngkAUENzfD0ny8xwgAPfs=
X-Google-Smtp-Source: ABdhPJyZxq9MqjpY7Xw0pshPqZOH2/JcOQHCCl3mBdjxDbpnEz6rG2pnNwXruAlqS/BYqD30B3Olug==
X-Received: by 2002:a2e:3911:0:b0:246:3fec:bb3e with SMTP id g17-20020a2e3911000000b002463fecbb3emr21609432lja.337.1646268667487;
        Wed, 02 Mar 2022 16:51:07 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id o2-20020a2ebd82000000b00245f5c6437asm109416ljq.4.2022.03.02.16.51.04
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:51:04 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id j15so5687024lfe.11
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 16:51:04 -0800 (PST)
X-Received: by 2002:ac2:5313:0:b0:443:99c1:7e89 with SMTP id
 c19-20020ac25313000000b0044399c17e89mr19366064lfh.531.1646268663457; Wed, 02
 Mar 2022 16:51:03 -0800 (PST)
MIME-Version: 1.0
References: <CAJjP=Bt52AW_w2sKnM=MbckPkH1hevPMJVWm_Wf+wThmR72YTg@mail.gmail.com>
 <CAH2r5mt_2f==5reyc0HmMLvYJVmP4Enykwauo+LQoFGFbVFeRQ@mail.gmail.com>
 <CAJjP=BvNVOj3KRnhFgk6xiwnxVhxE-sN98-pr6e1Kzc5Xg5EvQ@mail.gmail.com>
 <CAH2r5mvsetx5G+c=8ePh+X8ng7FvMrnuM9+FJ4Sid4b3E+T41Q@mail.gmail.com>
 <CAJjP=BvqZUnJPq=C0OUKbXr=mbJd7a6YDSJC-sNY1j_33_e-uw@mail.gmail.com>
 <CAN05THSGwCKckQoeB6D91iBv0Sed+ethK7tde7GSc1UzS-0OYg@mail.gmail.com>
 <CAJjP=BvcWrF-k_sFxak1mgHAHVVS7_JZow+h_47XB1VzG2+Drw@mail.gmail.com>
 <ebf8c487-0377-834e-fbb7-725cceae1fbb@leemhuis.info> <CAN05THRJJj48ueb34t18Yj=JYuhiwZ8hTvOssX4D6XhNpjx-bg@mail.gmail.com>
 <f7eb4a3e-9799-3fe4-d464-d84dd9e64510@leemhuis.info> <CAJjP=Bus1_ce4vbHXpiou1WrSe8a61U1NzGm4XvN5fYCPGNikA@mail.gmail.com>
 <fe156bb6-c6d2-57da-7f62-57d2972bf1ae@leemhuis.info>
In-Reply-To: <fe156bb6-c6d2-57da-7f62-57d2972bf1ae@leemhuis.info>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 2 Mar 2022 16:50:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjSBvRk-ksUBOiQzJd=e19UZKvOSZs1UHahK5U0QVh6RQ@mail.gmail.com>
Message-ID: <CAHk-=wjSBvRk-ksUBOiQzJd=e19UZKvOSZs1UHahK5U0QVh6RQ@mail.gmail.com>
Subject: Re: Possible regression: unable to mount CIFS 1.0 shares from older
 machines since 76a3c92ec9e0668e4cd0e9ff1782eb68f61a179c
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Davyd McColl <davydm@gmail.com>, Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 1, 2022 at 10:58 PM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> Thx for the update. I pointed Linus towards this thread two times now,
> but he didn't comment on it afaics. CCing him now, maybe that will to
> the trick.

So I have to admit that I think it's a 20+ year old legacy and
insecure protocol that nobody should be using.

When the maintainer can't really even test it, and it really has been
deprecated that long, I get the feeling that somebody who wants it to
be maintained will need to do that job himself.

This seems to be a _very_ niche thing, possibly legacy museum style
equipment, and maybe using an older kernel ends up being the answer if
nobody steps up and maintains it as an external patch.

             Linus
