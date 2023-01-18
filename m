Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4C1C00A5A
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 01:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjARBd5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjARBd4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 20:33:56 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520BA4ED18
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 17:33:55 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b3so49649410lfv.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 17:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1K9QCv2UtVsrI07DuqisWinbGf0dbiRb90wADACm0S8=;
        b=BtG1IMIOM/L8U7vhQ8lfy/JC8g9UFziqUmSFqnDjvZ/SUqkUcZV7igJ1lhX4qrDnPc
         +bdWxNdMBAaKpuBgL9+mVWUuma3uTxrv/SxVBF4hyBWs4U/gukgl4xYpEzgVP2VNor6J
         axDFbIFE30ClXRKnUL3uv0V9/xdBtMBFY+5U6JjgEZ4yKFbY7+lp74MlV184XL8lyQ/D
         xhr3tmCPmDcwKCpKRxVnHtuJt2PlJw+WQVBqWLdSwvr7mRbrhd0KM7ZG4//OoMAtfbRP
         K5/+40AnUKlxcUfK5GFRM3LnF/U+epbW021oLNR0UX9OeLCIC8ijESe+TUdoHSVkSqW/
         BXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1K9QCv2UtVsrI07DuqisWinbGf0dbiRb90wADACm0S8=;
        b=8FG35vgfY3wAKOfLqn+/GQ2wVFlQ3wTmql+hKPh8klxj+WQRDBEihWn9WYMw5VzwD9
         P30X1PHbsu1PwCEca8Ca198cupQgofUy5qL/jG8GFZp+JXQRy4hWuW0FKVhz+GhBT1bb
         jKCZjvkIyK5G1bGaiRSjJ61GtblyUmVZngCn1iFib0fL/hgUdO2SkzuYYZogV47qQKjp
         nnjxqh9gZtM8e2S7hMzST5xW5XRfef2MmPeml016NIK1FKvH3RxJDGUCYsWOl+UKsCjX
         6cHjXKpbBEyv+lxIb41SLDMmAmHvl+GOd4h1fqRM0Y9+L/ARb3HE7dXfCrck0ACbBAGP
         GwsA==
X-Gm-Message-State: AFqh2kp0q4AXHvEg/6v/aFGaF0yY+0oaL1H/bhC5PLY+7K/+g8Jd6IB4
        YfBJ94kf8xrSVyXc6iB4usDHl201w5i1keVXE3M=
X-Google-Smtp-Source: AMrXdXt/OdH4TOhEiOcpiYfe8iF3MtqJ3KuP8RQtztmJvaiYfq9jgHADDezFVZk/qtkzXUQeBuf18immvBffiACbHc8=
X-Received: by 2002:a05:6512:39cb:b0:4b5:9125:1432 with SMTP id
 k11-20020a05651239cb00b004b591251432mr272413lfu.204.1674005633603; Tue, 17
 Jan 2023 17:33:53 -0800 (PST)
MIME-Version: 1.0
References: <20230117000952.9965-1-pc@cjr.nz> <20230117220041.15905-1-pc@cjr.nz>
In-Reply-To: <20230117220041.15905-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 17 Jan 2023 19:33:42 -0600
Message-ID: <CAH2r5muK1FUHq=06McOD+=fC8ttu_UH=9fjFg4bGkK6d2w42MQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] dfs fixes
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, aurelien.aptel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more review/testing

On Tue, Jan 17, 2023 at 4:00 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Steve,
>
> The most important fix is 1/5 that should fix those random hangs that
> we've observed while running dfs tests on buildbot.
>
> I have run twice 50 dfs tests against Windows 2022 and samba 4.16 with
> these mount options
>
>         vers=3.1.1,echo_interval=10,{,hard}
>         vers=3.0,echo_interval=10,{,hard}
>         vers=3.0,echo_interval=10,{,sign}
>         vers=3.0,echo_interval=10,{,seal}
>         vers=2.1,echo_interval=10,{,hard}
>         vers=1.0,echo_interval=10,{,hard}
>
> The only tests which failed (2%) were with SMB1 UNIX extensions
> against samba.  readdir(2) was getting STATUS_INVALID_LEVEL from
> QUERY_PATH_INFO after failover for some reason -- I'll look into that
> when time allows.  Those failures aren't related to this series,
> though.
>
> I also did some quick tests with kerberos.
>
> ---
> v1 -> v2: add comments in patch 1/5 as suggested by Aurelien
>
> Paulo Alcantara (5):
>   cifs: fix potential deadlock in cache_refresh_path()
>   cifs: avoid re-lookups in dfs_cache_find()
>   cifs: don't take exclusive lock for updating target hints
>   cifs: remove duplicate code in __refresh_tcon()
>   cifs: handle cache lookup errors different than -ENOENT
>
>  fs/cifs/dfs_cache.c | 191 +++++++++++++++++++++++---------------------
>  1 file changed, 100 insertions(+), 91 deletions(-)
>
> --
> 2.39.0
>


-- 
Thanks,

Steve
