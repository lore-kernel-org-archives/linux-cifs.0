Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F3AC43334
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jul 2022 05:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbiGAF4d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jul 2022 01:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiGAF4c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jul 2022 01:56:32 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327AD6B27D
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 22:56:31 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id g6so855232qvt.5
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 22:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSN6SYtmh/U9iN70U64VAd042aGbJnj1aoWfNUQAUBY=;
        b=fKxHjABLHk2Pne7eb7LyG59at4k79TEVyU50TZp0Wk8eErizY+cr44DylK4vybqsvq
         SFVFoIs5ag9PuEY1ijEFjvXIXeFAHA+A8tQZc8IUYgD8HxK7JLUm3M4+xJLjyx8CDXay
         /IVtZU10Jt15kTGbouS+V9CppMTtzmt1b772eat8jO/il9Ud5rXZF92MjlR7jTdcbuhZ
         dah+9ZIYbCKkP++D1OV0C6SJAJJOcvwNbsKPAp+Odqh281+tYntNgsPbqLnXiH26YUvW
         w4agoX8PvD/B4SWxAlck+lAgJ2s7OFPxJL4FcQ4sPLWhP+FpMlDBQGdRrSWlRjU6tO83
         6abg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSN6SYtmh/U9iN70U64VAd042aGbJnj1aoWfNUQAUBY=;
        b=4zwvv7HupBvY77yb0XOf1SXCwAjAYdBbD47FeCTDJF7XsgFrdJIunePcxN0CISazRs
         OAuMwQsP1/fUqHY6p317HCZEwu/8wF1KVP9Om5/p7LKEVS0FNpR3UQjSaeHRx9knc4cB
         3SdYAFkWvNopJCuiCT35wp45FRuGUwZXmtxPdP2j8LtRD0okDx75PZHS5tkckTs6MbFh
         ksYvjohPVq7QD8mzyyPlXZalY4xfs5nC248G5yfAbLwr8NlAL5Zyenl/25l5abJcdyTF
         0sun2WS1A20Zwj1C+WOpAXutLT8QFpxGlHkMuOeq++Fue1lpb0krYQLyxDnsj7CPPpmq
         TKZA==
X-Gm-Message-State: AJIora8iFvd/6OF3NIeQf1V34vYtjtsAydI7vrt9eXOAzkdAo0EGYH0r
        jdR38viIBAxKd9djX5CTP3HfUlKCf4rDjzigbYI=
X-Google-Smtp-Source: AGRyM1vQRMKx+mrQZXfCAnPWFtLji6glZ1WgHcuIKh47yU5jAXcmWtgi+975nJwX9EDlIqcDmIaU4A7414LiGG+D3Qg=
X-Received: by 2002:a05:622a:285:b0:31a:366e:c141 with SMTP id
 z5-20020a05622a028500b0031a366ec141mr11603952qtw.70.1656654990124; Thu, 30
 Jun 2022 22:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com>
In-Reply-To: <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 1 Jul 2022 11:26:19 +0530
Message-ID: <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     Tom Talpey <tom@talpey.com>
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
>
> Is there a justification for why this is necessary?
>
> When and how are admins expected to use it, and with what values?
>

Hi Tom,

This came up specifically when a customer reported an issue with lease break.
We wanted to rule out (or confirm) if deferred close is playing any
part in this by disabling it.
However, to disable it today, we will need to set acregmax to 0, which
will also disable attribute caching.

So Bharath now submitted a patch for this to be able to tune this
parameter separately.

> On 6/29/2022 4:26 AM, Bharath SM wrote:
> > Adding a new mount parameter to specifically control timeout for deferred close.



-- 
Regards,
Shyam
