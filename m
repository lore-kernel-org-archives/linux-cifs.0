Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A0AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Nov 2021 03:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhKVDyW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Nov 2021 22:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhKVDyV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Nov 2021 22:54:21 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB2BC061574
        for <linux-cifs@vger.kernel.org>; Sun, 21 Nov 2021 19:51:15 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z5so70842206edd.3
        for <linux-cifs@vger.kernel.org>; Sun, 21 Nov 2021 19:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=C/68/oGQLQ9zCrXtSOnerJe+nZWIYVdVUmHA2qPg/ss=;
        b=FhQQ4xT4P6l213au6GucP4rBYcLdZyUGaCwjSA1OgnXYRTBp893CbSkNBt11OgMFVZ
         6HHrXiDBDfypqoKCXHAjLPK4GtPJWSgW7A72Hi5GnjM5pJRH0OkznYjtrkSllup94uXK
         tkY1dEDnXtpoF8gm7gAviHJk524a3x4hYiwMXusOaquHUoVQKHFj1Q3aKgXEzHY5xVN5
         TM9M/HqnQ4Y2KJFlmwv+h+BksryyLUI7oQ+iGXGTRzBuIRfpP4UF1dbFMqr1yDsEP/nY
         5Vstl4dYH/gB2g1Y/7bg1SQ89Ps3vBSjLUvdrEF1Tro37dBOaVsW/0i7ODfa0kw9eOmh
         2paQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=C/68/oGQLQ9zCrXtSOnerJe+nZWIYVdVUmHA2qPg/ss=;
        b=iiAKGRXVMws+STy9EHUAqCzymMcGGbD8oOfqP4UkOCmabkEVVCoezR5oEFW426BMbt
         KlA28a/qwPqgYnCt5watzpNspLn5RaclQQ2CmIV+V2w8GbWYLcmvBO2r0OSuo/IPn4OL
         snvSCaOoljjOOjIB3AyojIEcfl9bywY3nj3o2ltg7hCmdP1sZRESYcVzBERXjtj9FmN6
         t1v9MFLLW5QWE4I18ozlEVjoZrLhIS/aBXimyfHfCWE156w3hDmKeK2+v2ORBeKLp3Vp
         uOBbCyA2XATgJvWMJQMfiWCaWElRqZM2LRcP5yKOGtcrGO+4P7D/Le0eocyc6b59OjW8
         /C1g==
X-Gm-Message-State: AOAM532AoDNDI87kB2XkxJzwsfYw4cB6R2G67aCwmrC27se7EdQWlpAT
        rl6Ebsz2Sx7Od6i7j0Q7nPl6CIMtYLeZHKvHwR/G+fVZcV9KGg==
X-Google-Smtp-Source: ABdhPJwemoLhxhKiCVNqPzx7RsqRBL/izWAMomYrdzIgrq5scSk3f33yWpnlEiPsmVXrQI/sBQAP8cXu5vg0ApzQvyA=
X-Received: by 2002:aa7:d4c3:: with SMTP id t3mr59689154edr.268.1637553074267;
 Sun, 21 Nov 2021 19:51:14 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rw6OqPgPcgRQRk-ujM43x7j_Rw7c97z6Lk4Tpb=vL1VQ@mail.gmail.com>
In-Reply-To: <CANT5p=rw6OqPgPcgRQRk-ujM43x7j_Rw7c97z6Lk4Tpb=vL1VQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 22 Nov 2021 09:21:03 +0530
Message-ID: <CANT5p=ojh1OjgJ-285Xh6PCG4EEmF1SJqPQ7J775PeDmkBQCaA@mail.gmail.com>
Subject: Re: [PATCH] cifs: nosharesock should not share socket with future sessions
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        rohiths msft <rohiths.msft@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Nov 6, 2021 at 5:25 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please consider this fix for CC stable. This will be important for
> Azure workloads.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/8f7a939555d6df2255b89d403ba5a30218852568.patch
>
> --
> Regards,
> Shyam

Hi Steve,

The above patch had a bug, which showed up for multichannel scenario.
Fixed with this patch:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/6be89071827998bfa6c714aea64f39966cc54b0b.patch

-- 
Regards,
Shyam
