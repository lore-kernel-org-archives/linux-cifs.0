Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C96C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 23:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC7B610C9
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 23:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhIIXXE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 19:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349223AbhIIXXA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Sep 2021 19:23:00 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9E7C06175F
        for <linux-cifs@vger.kernel.org>; Thu,  9 Sep 2021 16:21:50 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y6so152934lje.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Sep 2021 16:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Ip6KeFGcMX6jk9gP4cDHs2yNmjHzz+Km9aVu9mX3ZE=;
        b=PDH0k14suDx2erif+Etm2SZyyScxLmkUEtTlX1eWR0TBNG0r8lWhLn6ZvxqwKoY3ci
         i7s1ryMlCEII7y6dkPcEQ0oJMtO64o88WtQ7jZ/3SDF7nuKYvJLfXlpqAaE8hG4vx3aL
         TRMu3W7UGfv9Jt2Ic4dz98+v1tX0C2JahfpvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Ip6KeFGcMX6jk9gP4cDHs2yNmjHzz+Km9aVu9mX3ZE=;
        b=gKHhWIIwhtJZRMv2z4yjRJ9dI5lTJ6o1ph3zDbfjRUTE2yBBCs/Kz7H7UwMO+cirqy
         u/0Q8J/UsAk2A64n+XaPdSUBRPPDBgIPxqwclX5mzPr/e4chER7oxXLM+zPmRMaeOD1d
         8/twB3q+VuSq/62dmElBBukXzO5tfDhTkUd7rioh5KYmuylNVlmwLowsSX3hOdPn8ZMY
         E7zdUg/5oc6qMuaOpMTBFC72hGk1zJYAgZsfKaecOqBAsiiv5eeByV2IfospyFrTrN4q
         R96U6fUw7R+RC2R+g+KPQgco2OxcrauWPrmMptrzMFDpIP4PawRxLxKgmihtyEtfEfWl
         CPGQ==
X-Gm-Message-State: AOAM531wlt4ONSpZAFL6j4r1rBQotKZde/ksWX8lFeEHB+sYo/MrHdKO
        qdI1aUSObZoPdo6k+BJ4eStwgB7zRaJQsomExew=
X-Google-Smtp-Source: ABdhPJzi1se6REfVJ25nR+HlSo9zLvpO/lfiT+SAix9Ipq5UO0Eo6qZebRgFjtHLirM+qItFjwpr7g==
X-Received: by 2002:a2e:a712:: with SMTP id s18mr1766435lje.325.1631229708720;
        Thu, 09 Sep 2021 16:21:48 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id k31sm339724lfv.37.2021.09.09.16.21.47
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 16:21:48 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id m28so179884lfj.6
        for <linux-cifs@vger.kernel.org>; Thu, 09 Sep 2021 16:21:47 -0700 (PDT)
X-Received: by 2002:a05:6512:3da5:: with SMTP id k37mr1641237lfv.655.1631229707726;
 Thu, 09 Sep 2021 16:21:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
In-Reply-To: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Sep 2021 16:21:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiE8+=FvKk8nEdh62S_khLgoaasOo4kkwERaMK0u3GZqg@mail.gmail.com>
Message-ID: <CAHk-=wiE8+=FvKk8nEdh62S_khLgoaasOo4kkwERaMK0u3GZqg@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 9, 2021 at 2:59 PM Steve French <smfrench@gmail.com> wrote:
>
> 18 ksmbd fixes including:

Sigh.. The text in the tag says 19.

But 18 was indeed correct.

For next time, if you're not quite certain, git can help you with these things:

   git rev-list --count --no-merges linus..

or similar.

But the important part is just the overview of what's actually going
on, not the number of patches. I tend to mostly edit that out anyway.

                Linus
