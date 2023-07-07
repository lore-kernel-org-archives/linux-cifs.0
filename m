Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33D2EB64D9
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jul 2023 06:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjGGGmY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jul 2023 02:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjGGGmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jul 2023 02:42:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5297D2103
        for <linux-cifs@vger.kernel.org>; Thu,  6 Jul 2023 23:42:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-992b2249d82so189649366b.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jul 2023 23:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688712132; x=1691304132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NeSI05cCJtV05wUYDJGYtlTuK8HdlpGUBX/a5VtTafk=;
        b=IJQ5LBQERF1/XE4J9U7K/XDpbkvL0VUsCtmujp8/TIKHi0lR8sstFYt8kJq5fE1otZ
         TK6GG94Os8wNAHqW/SYohkL6Frm6mrFKu240OlFZuJxHtm2r98bxIOZVGXxyIB0C9scJ
         041568Z854ggsrrbqeUZzZPVkmZgM8dWbaCD5L5uof+6lpDL2OMTukkxy2gkGbqB8FGg
         NN/HuqJU2ByBdkrrjK57LE7fH0M01LCeavffStdtHonKoJR0SQnxMI/r9qm0DfLhl+4x
         c3H35lzEvbBqQ/DprGtQcxsTPyTxXqFm2+yOt2CabQ0htXGjJxYbAS8UfdDoc1il06AG
         nULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688712132; x=1691304132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NeSI05cCJtV05wUYDJGYtlTuK8HdlpGUBX/a5VtTafk=;
        b=DgqAUmDHZbCKixVogDHMWPGGfnFwxQLOdu9tVY2CiXTtxlcW8Q/1vpGw+j3hHBz/xd
         vkBNkJw9mARpZQIoNgtAyp/agt1MD8t9vcA/McvuNGUzK4dsLBnMrnh3U9BbQdPoHQPD
         V/LShZbRiqp6hl+DkbTdJsNklAfiPx8JZc2LxC6Wu6+j/daU4+8cqTsTNQ9qb8v5lEaW
         b/BbqH54Hn2Ea91QBFgluoDWjhLbFqedtcj0ZtALMy7cy1L6S7fN+3sUrvBUW16M5KWE
         y908XXEiWsGFNFf1DFaDrdacXINk+UKx6MJWWJcTeMWkMPMGe7f64lOTFp32quXQMAs9
         RqCQ==
X-Gm-Message-State: ABy/qLZuXSEONI/QXeAB8WtaURgn+BuO2CZSz7wlQAF6fAOHkMSTsnsd
        opInYCvzUzfU03liD7HT2413D3klib9ISsmF2m8=
X-Google-Smtp-Source: APBJJlHWOQ0ZbY2F4W9HkRo4fJIW5PjeBOXTX2K6cr+sBfWQ589wsp6gBKKAwrjscGtOpWBikyVZygHLBum9Pvt/p5g=
X-Received: by 2002:a17:906:3f5c:b0:992:1bb2:61d9 with SMTP id
 f28-20020a1709063f5c00b009921bb261d9mr3018867ejj.54.1688712131683; Thu, 06
 Jul 2023 23:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230706023224.609324-1-lsahlber@redhat.com> <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
 <CANT5p=oMg3wx4qPCV9EEtmP7FCLG43iqO47iFwimCNS6E=QnFA@mail.gmail.com>
 <CAN05THSjxZ=_L-Ho8tffz9xRfc8R8kCWf-_GtYUe=yFNEC2bhw@mail.gmail.com> <CANT5p=qxZjxpqx49BO7G-8=se2_5gEPyLOi_W-sUDm0p7VhbEQ@mail.gmail.com>
In-Reply-To: <CANT5p=qxZjxpqx49BO7G-8=se2_5gEPyLOi_W-sUDm0p7VhbEQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 7 Jul 2023 16:41:59 +1000
Message-ID: <CAN05THTazZByLPSgrcMg8LuMhAT2=0r+znOnUkGuSdtWPVUtGw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add a laundromat thread for cached directories
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 7 Jul 2023 at 16:37, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Fri, Jul 7, 2023 at 11:20=E2=80=AFAM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > We can only cache a limited amount of entries.
> > We need to force entries to be dropped from the cache at regular
> > intervals to make room for potential new entries/different
> > directories.
> >
> > Access patterns change over time and what is the "hot" directory will
> > also change over time so we need to drop entries to make sure that
> > when some directory becomes hot there will be decent chance that it
> > will be able to become cached.
> >
> > If a directory becomes "cold" we no longer want it to take up entries
> > in our cache.
> >
>
> Makes sense.
>
> However, the value of MAX_CACHED_FIDS to 16 seems very restrictive.
> And as Steve suggested, 30s expiry seems very aggressive.
> I think we can increase both.

We can and should increase it at some stage but lets keep it small and
short for now until we feel confident it is all stable.
Once we are confident it is good we can increase these quite a bit.
