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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE55BC433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 20:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966D3610A8
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 20:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhDIUaw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhDIUau (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 16:30:50 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF040C061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 13:30:36 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g8so11621675lfv.12
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 13:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXivI3UJWet7O6rlbjYauqHwUOpAxmgV84hqw4J/6CE=;
        b=s3lFh1GkI4mYZ9PtdntLaB+ln3fs8w1oEy315YmquS349v1pw0H++DI+0GRuA+na/l
         Rxl4+lweuWpP3JzAGU4TqN/eQKqsyBHWnRl1aaT9nD4gJVV3RoYTaaq2JAaE2/CBMEbY
         iIbCZ7g8yyMZ0ZVVMybRGBQKWsB7j8EUVHZUfwmo9YJmxToeUxQ9wGQI2PKHfpbtWTcV
         Bs30s1tjnocaS22o8EI9gEekpQQcGGaOmAzta7bwFnldileQXtu2nEM+nW9wAi1rCR4S
         d9UABp9JKYbQ7NgfnuQJ8dADjMqAvLW+sgD4DGkAQoOHKDOR4JY38wV/2GSm6kJ0twqf
         wKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXivI3UJWet7O6rlbjYauqHwUOpAxmgV84hqw4J/6CE=;
        b=sA+gFI0L0fffDRpicAQXWNZesokV5Y69d6kz5nJN20vES0HSL1akIhqcJz7Cdolsr2
         Eb54ZmeZkQUgArm8KVkJKxdvzYaCOHzAXLhYf12JgduH+1CN/mcsTozht9P+7ChuAOIo
         ZMAlnZwHq5NrKk+8w5JW929bXuM2FStQNKTCgyYqgfO3c+BiuY/NQ0in3nvFSV2BDz2a
         791fisxB4dhBEitKxvx8oaHgvAJJMHzA2/PTkrF2VzujpmmNcnTPWmsE7v0LJJqusP2R
         DuVSf4Mi0WkED1fwGwj9FKHwrkgfrBlTsDz6ZLEgWjhBvfChJz0/8UhxQ2ua/eA3tEBu
         tYyg==
X-Gm-Message-State: AOAM530mHNYg3rHV79gtkn7456Ii4mpm3zS8YujJQKPZwvZIjsf9c9bG
        1Fbeaj2IGN24Pa1ojXTVzQKIKT1q2Y5nJ/F1yGLU7XzTBGvZxA==
X-Google-Smtp-Source: ABdhPJyHe/7ymcH27TSwg0OUcVQhhYzuI09Wch3zp0JtVrpcvxVUWsftsY+N6Q+u3OkNZiz0CTvKAlfAGqfjWvvccEY=
X-Received: by 2002:ac2:4148:: with SMTP id c8mr10599759lfi.307.1618000235296;
 Fri, 09 Apr 2021 13:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
In-Reply-To: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 15:30:24 -0500
Message-ID: <CAH2r5mvEF6RyQ2dCB7y9m_knDxFWw6q2+kBBT_+seA3Tcox4EA@mail.gmail.com>
Subject: Re: [CFT] vfs.git #work.cifs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

So far so good (has 5.12-rc6 + Al's patches + 2 from Ronnie for
finsert/fcollapse )
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/552

I did get one failure last night that caused hang in subsequent tests
but looked unrelated (some reconnect issue) but rerunning looked ok

Testing to Azure should be fairly easy (apparently there are some free
accounts for testing Azure, I used to do it from MSDN) for developers
- but these are run to a mix of targets (including Azure) some of
which are higher end (e.g. multichannel) targets.

On Thu, Apr 8, 2021 at 8:47 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         Could somebody throw the current variant of that branch
> (HEAD at 224a69014604) into CIFS testsuite and/or point to
> instructions for setting such up?
>
>         Branch lives at
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.cifs
>
> Al, really wishing he could reproduce the test setup locally ;-/



-- 
Thanks,

Steve
