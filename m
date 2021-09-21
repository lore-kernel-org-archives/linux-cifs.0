Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7B0C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 03:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5616D60F91
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 03:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhIUD0g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 23:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351606AbhIUCkG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 22:40:06 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54663C08E9AC;
        Mon, 20 Sep 2021 19:16:29 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u8so23935592lff.9;
        Mon, 20 Sep 2021 19:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bklc5LnpHbXXRZG1hQdUHVP8Fhs6SyMfJaYgRp3O//E=;
        b=dsm+JAsusa9xNL32okfaioo2aQiS0BiadMNz2FsHDp4+QLFvhoqOtZD2YVdfKQa7JJ
         7STYnQPwVTnDXCgGt+S/ckrydR/yId4oG8qMJ2JiRP2H1GTMMmYI0bxP0LtiW8zTzA63
         6OIks84cyz5jmCMphJy9tqgSq2ooXxjs1GVEs+hSauO5dLdjFXJ71uvdXqZoeMdAtQSu
         C/ciiqyA1BFQmJnpmSnm9vmzYHldMU+aAG98k1K3rDVb14bnkQVkB9dSff2yw5Lk1Dj8
         F1HyMHHa8w09chMVw9dReBuFUR+NsQtgYPV4mMMCsLI1bhJuZOOXfOfCIm2RprYtD5xu
         lmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bklc5LnpHbXXRZG1hQdUHVP8Fhs6SyMfJaYgRp3O//E=;
        b=IE999Vk1PVQtgayOLHgkKAljAbzRQqYQ/5O9gZYVJU5GWlszfkEm+pPeBYgJQzrqux
         hE0RybDy2/wLJ3E+4QjxmP/oKcx9aBG27borDBWminWbVl4LEIYC3Ch0Dl9ko1Je1qor
         lnCzMioBBwquLZw5ZrV4OLitMUURVZFL3h/6bKpl9YfyCPqYC1RKI6YPfA3VuBBXS5l+
         cos0R9TODmmxIx9CoasYgBtxWKqMdvnCnC2j9v0HhMnErT1UQ60fOBDllO5oSTvsdW1c
         irvzhP785ktolgfXCsIpMeuEtb7jxa5C7RhBqM6ezk7ObI6+6rrCgEmg7yyKQtzKTCXy
         Tofg==
X-Gm-Message-State: AOAM531knN+ZZIUTQtWNwfXu4T/RHLwDtUZQp/hK20hvJULCnKcA5Kzb
        azbNMbZmrdmP1+BrtcWMp2vv/oEl58meZsJASM323RTr
X-Google-Smtp-Source: ABdhPJyzjfrt4j2H+fAlrXP+MgZcR4mnt936HzL/meXUT4p6FFtd+99NoogxeE2WrucliHMlrGKm83XD00j7mCVYiqQ=
X-Received: by 2002:ac2:44b6:: with SMTP id c22mr7348048lfm.601.1632190587579;
 Mon, 20 Sep 2021 19:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
 <CAHk-=wi6_m_d88kx7wWYQS+waEk6hv5szwFYvy2PjP1naj87Hw@mail.gmail.com>
In-Reply-To: <CAHk-=wi6_m_d88kx7wWYQS+waEk6hv5szwFYvy2PjP1naj87Hw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Sep 2021 21:16:16 -0500
Message-ID: <CAH2r5ms0P9r6N_Tqw02TtpmHXaiJejdQgL2Rur1GMP=tyr0CMg@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server security fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 20, 2021 at 5:46 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Sep 19, 2021 at 7:22 AM Steve French <smfrench@gmail.com> wrote:
> >
> > 3 ksmbd fixes: including an important security fix for path
> > processing, and a missing buffer overflow check, and a trivial fix for
> > incorrect header inclusion
> >
> > There are three additional patches (and also a patch to improve
> > symlink checks) for other buffer overflow cases that are being
> > reviewed and tested.
>
> Note that if you are working on a path basis, you should really take a
> look at our vfs lookup_flags, and LOOKUP_BENEATH in particular.

This was also something that Ralph brought up, and Namjae is looking
at now.

> The way to deal with '..' and symlinks is not to try to figure it out
> yourself. You'll get it wrong, partly because the races with rename
> are quite interesting. The VFS layer knows how to limit pathname
> lookup to the particular directory you started in these days.
>
> Of course, that is only true for the actual path lookup functions.
> Once you start doing things manually one component at a time yourself,
> you're on your own.

Agreed.  Also FYI I removed the "ksmbd: Use LOOKUP_NO_SYMLINKS"
changeset from for-next (I left the first two buffer validation changesets
in, since those have been reviewed), since Namjae is working on
an updated version following your suggestion (and others' review feedback).

-- 
Thanks,

Steve
