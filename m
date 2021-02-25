Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E717C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0506964E6C
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBYS0F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhBYSZ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 13:25:58 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B4C061574
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:25:17 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id h125so9990389lfd.7
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=331CMSLQlr3rNuClbnuDwXVU3AgzZBLbiXGtdAv/i3o=;
        b=Dq6K8xo0S0Iy+04Mxn/o8xfwP28KZEVQuhxbKBfWNkrMK4Agm3eWvfHBrZa0l6Hfit
         c1ltPQM41/LeBovFgwGzhenCwVYitOJx327TuJyKghtQyUSfBc/LQpoIOcWdMcq7HDIs
         /SN1pxvj/iULXeSH4dnh+1kWN/OMM6RNQzCK8Djlc4LMlBC8wxiI1qgeYON+koM1QaTj
         9B3hCLYOWkBj9RJ/a056M6kYoEwU0EumdkaZfNu5tV2PkFBtsWZdSavP+02MjxlCMoyp
         HUtbAzdjNJ+MfaOrFB30EB5/77vqngGgnvWG6L1xH006pmXeRkDgIx9b3KRGA77xY/la
         lFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=331CMSLQlr3rNuClbnuDwXVU3AgzZBLbiXGtdAv/i3o=;
        b=CwNQVTAKFge4K9dB8qn7zGHvkl1dGLuvBUsKYP3BB4HNhqg5VjLQOfAMBV3EEySPYK
         CXg5PkcL6PbzQ0i7AtDBBJLQJUXbbtQD/Mydw2Zargr91RIT5nqi6kyCdFCKUA6xg7pE
         6b3bOaM/qByGu5wuVUWnfTST4woaQ+zSnADuIKptdT0Wg9digaFUMqBxY5DxEclLsYE+
         IhWCfP2z7S0wWh3p5J9YTyqnwC1qV/2X2jH8xIj8LUILuyb2rqEa5jamcqNJUQInd7OM
         y0jAy172V2/Bas80He2HGRzrGhZgkVE3Hw+aDoqgjBxunGCm9ECDUKqyT3lxiEhkJ2bw
         j/dA==
X-Gm-Message-State: AOAM531/61y9V98Q5uw1djhV3fsm5xBqceWvxTN3kozfPIoynqp91j1o
        hRyppjY9sO3JF5bTHvbrF+sCKdj7AVX8q4MJDISL9L4AnAM=
X-Google-Smtp-Source: ABdhPJzhpuvzyz8pCeSMBycdqsIXG5dh5x+2jfnrzjNPMVJV8PaYi1ba33J9CJhF1O9JEHWGeagMO+cRoj1rolECU4s=
X-Received: by 2002:a19:910e:: with SMTP id t14mr2661811lfd.282.1614277515872;
 Thu, 25 Feb 2021 10:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20210224235924.29931-1-pc@cjr.nz> <CAH2r5muMt3gmmtLOBxaOqqh-KfccSDDuta6ob218_w9WQZdmbA@mail.gmail.com>
 <87y2fdszy3.fsf@cjr.nz> <CAH2r5mt3HTJYi=TP0YF+zPfYrN0Qj56rK0grMbodsN8Xkdny+w@mail.gmail.com>
In-Reply-To: <CAH2r5mt3HTJYi=TP0YF+zPfYrN0Qj56rK0grMbodsN8Xkdny+w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Feb 2021 12:25:04 -0600
Message-ID: <CAH2r5mvsGLERYD0AhwZcB5oAeRXRMSh+U=r=dOq88O3mpz+ZwA@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: fix DFS failover
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I pushed the 4 in your email attachment to cifs-2.6 for-next

They differed only in patch 3 from the one in dfs-fixes-v2

Let me know if the correct version is in for-next

On Wed, Feb 24, 2021 at 9:34 PM Steve French <smfrench@gmail.com> wrote:
>
> git diff dfs-fixes..dfs-fixes-v2      showed no differences between
> the two branches
>
> And should we cc: Stable #5.10
>
> On Wed, Feb 24, 2021 at 7:23 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Steve French <smfrench@gmail.com> writes:
> >
> > > is this series of 4 identical with
> > >    https://git.cjr.nz/linux.git/commit/?h=dfs-fixes-v2
> >
> > Nope.  Please pull from git://git.cjr.nz/linux.git dfs-fixes
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
