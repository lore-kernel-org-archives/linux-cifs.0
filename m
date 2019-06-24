Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3B8C4646B
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 21:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3783420663
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 21:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLUTVUkx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfFXVhH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 17:37:07 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40899 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFXVhH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 17:37:07 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so187286ioc.7
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 14:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5N+5qxMjFwWKHLcQ7T7a2+5aIzVq4QQH0lGNWKe1Pw=;
        b=BLUTVUkxhlIngUCqa8zag/pA9Twf7nG0FNLRugd+LMYcY0Z5Hg0080tPue6DKQQmXQ
         MTb6G5AylWwy4N7xunMscgzfGGjwYFvJvqZjJfYYrJphmx4zgGnG8x98kQZsCrbDb+hm
         ivKxkWgHqW974rZnCaQwHoZns0QgM7KBOofN/bQaW/g/44n+AVlo2ul5/OICdDTIChGh
         brfpvCELvBtL1xPO+Z+rPrYioBS+S6Lsw7apbbFNThvPBHWx/7fGy4yNfIg0S/pGJm/g
         3v+jdApko5+HsVfS4Vhafa+W9D/jHh5kXXX3Ln9pCtIUbBPx4Q8IQB6H2tVfewdLNY25
         77Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e5N+5qxMjFwWKHLcQ7T7a2+5aIzVq4QQH0lGNWKe1Pw=;
        b=HyYZTbar70ug1Y7ephnfqwfs8nn0MjNiVoaLQjaDHtD1/LuNZoUvugHDhyrD5ocGNf
         lST9MDC3uhEJu6F50x9n9wiSHO6Fu9Z/JnCzvTct7D/mH3y8MnKIMQlsSnKBb44lQ5eF
         t6HKDbJsavzUr7f8LOwUNX4YmLSmXoJDTcqqXRNT9MiM0qQT6Vu6y8NHeQHKYJ+7E4C8
         BZpiP/3aeycQpDBeGyqLrLuosnsUhCWrkoib/jG8mKO3qlrMdRIqnMyRHnKIqZtiBUGE
         jZTuvQzi9OMcYSAhHKylnEkFIM/gCTuq92YnrEe1PJSm8QQVYYiM2buVHlYS0mz1Fyo0
         vBcg==
X-Gm-Message-State: APjAAAXLRuplRPrTyi7whqG2nrSsOOlp5rvqVGO2KnA+QR3L4E1OmdeN
        8qTny6/bxN371/Q8q81zBSEnuBk7kINY3ZhcC/aD4A==
X-Google-Smtp-Source: APXvYqzKyHEmIIjCpz5zk/X1ISnn07afV+LK+ooYfayU8jXsndbxyG8xxXoFNiISMVt11/I31RfJZvb56vXC71Ri/WE=
X-Received: by 2002:a6b:641a:: with SMTP id t26mr13638944iog.3.1561412226918;
 Mon, 24 Jun 2019 14:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
 <CAH2r5muF+bppZPXFKq2qMc=muVEmg30455M_EXjDZhf6r_i0tQ@mail.gmail.com>
In-Reply-To: <CAH2r5muF+bppZPXFKq2qMc=muVEmg30455M_EXjDZhf6r_i0tQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 25 Jun 2019 07:36:55 +1000
Message-ID: <CAN05THR4Ocmhe6pfCeDaVa+tKRy4t+r3pMtkwLOy0X5VJCw1rg@mail.gmail.com>
Subject: Re: [SMB3][PATCH] add mount option to allow retrieving POSIX mode
 from special ACE
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Tue, Jun 25, 2019 at 7:22 AM Steve French <smfrench@gmail.com> wrote:
>
> I missed a couple lines in the earlier version of this patch that I
> sent last night - updated one attached.
>
>
> On Mon, Jun 24, 2019 at 2:11 AM Steve French <smfrench@gmail.com> wrote:
> >
> > See e.g. https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/hh509017(v=ws.10)
> >
> > where it describes use of an ACE with special SID S-1-5-88-3 to store the mode.
> >
> > Followon patches will add the support for chmod and query_info (stat)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
