Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83903EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 03:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjFUD5k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jun 2023 23:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFUD5k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Jun 2023 23:57:40 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359F3F1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 20:57:38 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b474dac685so47770081fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 20:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687319856; x=1689911856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cd06NuhkrnbxD020qmHw4LA7cHDV5wYImdGA9i8TCSk=;
        b=klolcA7hoYPA2HOhLEhEfQzSVcAYOTeGqkYKHFENxQ/UhjxSzF/Q4Xe6VOh+fzDIKj
         UQzqTPapMpzHHr+6eOYFnRjMmY98bOSlxZRTD6cY+l0D4aH1MyXrcfMUQ5aCKi3OC3r/
         RgUr16wh0xUzw+9v/9DodKkzLJqGKHChI68WVg6svB+SjF/N99eatXHP3eivtzFltQ/x
         jLZWpcwT0+Cihq9QZ1qCAE4/cIJaSiax4RN28Yt6MZmywk1DMvM/sTD7lztmLaScsuiQ
         UAnk90QEXHCuPYbgX63oUjnV+1XA7vghPMvuuSrYpT+4Jz76Qchcnf78I0C8W0GiyYzk
         Ypgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687319856; x=1689911856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cd06NuhkrnbxD020qmHw4LA7cHDV5wYImdGA9i8TCSk=;
        b=M1QNK8pnwoWO5K1pLcYiJwkvWvzWT3KWYuCTWOzMCY53aeR3V1C0a+Qb4y4nKPLo/K
         dvUQX3V9UgehnRNHFDbe/E/l5ROmA0XLdfzGJ0NQQq5DrRrrGBuLAMIxL377uo4uvxuD
         4YO6PWBx/PRZG6BTn+jerq0Xh/ChOWOgidKqGl490tLFUlyLgqY4pB1NF6FDAyIX4iEJ
         iAWaTb5rTFpnlyQanwmEm0KowWrnNdwc+r2tf4vGk9OZILGsUtAm4PyjrHeEEpcTBFYh
         raHDs8xA/Iy5Q1jDqkxoa9iFsLhiGbHONZNJScbgzrEVdCGIQFcO9+0aT8yw1Xf/9pk7
         4A8w==
X-Gm-Message-State: AC+VfDz+U2EmV8C/0aTLWTtW1pbgpQk9Q8r1VIkXcqjXhnsyUyToP2oP
        XF2vr6aUdYHpzJNxz/NAULA6Td/TFuxY46ks+I8qh+sUtUc=
X-Google-Smtp-Source: ACHHUZ6dJNzotfYHXxe/2tPcPMNthaS2WB9GIiYn4dh7YK4Kku+Cev5h/wgp/58WYYVeFLeMxL/BJ0u3ar0wbdonXuU=
X-Received: by 2002:a2e:8296:0:b0:2b4:76f6:63a8 with SMTP id
 y22-20020a2e8296000000b002b476f663a8mr5371488ljg.12.1687319856123; Tue, 20
 Jun 2023 20:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
 <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
In-Reply-To: <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Jun 2023 22:57:24 -0500
Message-ID: <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Why this value of 10? I would go with 1, since we already reserve 1
credit for oplocks. If the reasoning is to have enough credits to send mult=
iple
lease/oplock acks, we should change the reserved count altogether.

I think there could be some value in sending multiple lease break
responses (ie allow oplock credits to be a few more than 1), but my
main reasoning for this was to pick some number that was "safe"
(allowing 10 oplock/lease-break credits while in flight count is
non-zero is unlikely to be a problem) and would be unlikely to change
existing behavior.

My thinking was that today's code allows oplock credits to be above 1
(and keep growing in the server scenario you noticed) while multiple
requests continue to be in flight - so there could potentially be a
performance benefit during this period of high activity in having a
few lease breaks in flight at one time and unlikely to hurt anything -
but more importantly if we change the code to never allow oplock/lease
credits to be above one we could (unlikely but possible) have subtle
behavior changes that trigger a bug (since we would then have cases to
at least some servers where we never have two lease breaks in flight).
It seemed harmless to set the threshold to something slightly more
than one (so multiple lease breaks in flight would still be possible
and thus behavior would not change - but risk of credit starvation is
gone).    If you prefer - I could pick a number like 2 or 3 credits
instead of 10.  My intent was just to make it extremely unlikely that
any behavior would change (but would still fix the possible credit
starvation scenario) - so 2 or 3 would also probably be fine.

On Tue, Jun 20, 2023 at 2:48=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Jun 20, 2023 at 9:12=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > There were cases reported where servers will sometimes return more
> > credits than requested on oplock break responses, which can lead to
> > most of the credits being allocated for oplock breaks (instead of
> > for normal operations like read and write) if number of SMB3 requests
> > in flight always stays above 0 (the oplock and echo credits are
> > rebalanced when in flight requests goes down to zero).
> >
> > If oplock credits gets unexpectedly large (e.g. ten is more than it
> > would ever be expected to be) and in flight requests are greater than
> > zero, then rebalance the oplock credits and regular credits (go
> > back to reserving just one oplock credit.
> >
> > See attached
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi Steve,
>
> > If oplock credits gets unexpectedly large (e.g. ten is more than it
> > would ever be expected to be) and in flight requests are greater than
> > zero, then rebalance the oplock credits and regular credits (go
> > back to reserving just one oplock crdit).
>
> Why this value of 10? I would go with 1, since we already reserve 1
> credit for oplocks.
> If the reasoning is to have enough credits to send multiple
> lease/oplock acks, we should
> change the reserved count altogether.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
