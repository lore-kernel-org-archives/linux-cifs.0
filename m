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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3258C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 05:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549F764E2E
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 05:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhBHFuI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Feb 2021 00:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBHFuB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Feb 2021 00:50:01 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FC0C06174A
        for <linux-cifs@vger.kernel.org>; Sun,  7 Feb 2021 21:49:21 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id d24so1258240lfs.8
        for <linux-cifs@vger.kernel.org>; Sun, 07 Feb 2021 21:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MEuxTlGGfwSG5I1P/p/i0rmdXnHyF57xxbgMJypphoc=;
        b=fKl5gnPHMmqUjeShZSy9R9Aodw0JVaA4YPCg4pvlGXuAzx6KP0a5IfOiQz69svWS8S
         R+lfdY0cwg4GpzwGs0qWiBDMvPmHjwx/lVlygoEpYhQmbsTuk62bhCNa35J+iI22noJw
         TPffpQ0TvLId3UFgLcPPlq2NLUGB4xYzb3N4g4SFKflqE+uZfQoH3TwaXfELfpboV4ng
         Rkkf7vZLMUN9Kx0FFidC+2fPKA5nrcZhD2pScP/gQCn3tio+2Q2XMzFumUcdRd01HvhD
         /kbEo89/iu5Pn/bWE0QlIdlch4Hsx2YeHU58UvGbYQEgSHbsHC8hzSV5+M1i1Ikz3Z5s
         kUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEuxTlGGfwSG5I1P/p/i0rmdXnHyF57xxbgMJypphoc=;
        b=S8vJaHzNUFo/HZHkl9sPNbbyu3xNehhZu9ajLvZ4Wt7VKamZe5WKZ+T2eRfwXv/TeY
         AuWG8HjLmvHXzzAmj5bHCISsM8kp9a32tTqF6uKJX0cxeC3MCtNgEiD1MXm42udO4Jep
         Uny9zbHRLc8LYxlmGfSgKqPWKSM44mj6ZqiOMnDLgKhJ52+Dca3BQGquSl2ANGEq+3XE
         OBK7yVhSdBVeojXjYiGKwfCk4Qf8GqbUT7cvldCZfQtRxMJe0m85xOERll2Bb8T/mw4S
         1bCg2bhoKmuay6FVsQj/2TB168ujYjL/ixIR8K+D/lFBljkHWNjhVGwdQAMTH0NdG0W2
         gNUw==
X-Gm-Message-State: AOAM531+RCy2DNnW5XHwRZDwaBivvJtx5WVx4Fc1Yegpn7cbsAaB5+O4
        POHM5M8nYjpIkliQo/eDHlP/FI3zBLp7U0wjFr8=
X-Google-Smtp-Source: ABdhPJwbukRXgSK6X+G29DKQq80c+lQZ2TtCiYF6wDVPqAp6mzSnJQdfAkjonPOo3TbzazZYLrkh/hAwHDVLIvfU+uc=
X-Received: by 2002:ac2:592c:: with SMTP id v12mr9164512lfi.133.1612763359685;
 Sun, 07 Feb 2021 21:49:19 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210126023109epcas1p257c4128a9d8673cb44f81dca636da39a@epcas1p2.samsung.com>
 <20210126022335.27311-1-namjae.jeon@samsung.com> <09887b1a-3303-9ac6-1d29-c53951be5324@samba.org>
 <CAKYAXd-rfk26A4SOeqvhMkBV2FcvpE0goj415HX7T4fBim1zQA@mail.gmail.com>
 <CAH2r5mutwPP570YbwxDWikwM6e+gdD7m2iwMJ5xNEcvqpkVrNg@mail.gmail.com> <000101d6f833$d9c38ba0$8d4aa2e0$@samsung.com>
In-Reply-To: <000101d6f833$d9c38ba0$8d4aa2e0$@samsung.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 7 Feb 2021 23:49:08 -0600
Message-ID: <CAH2r5mtmmei0q9kemkjL-QyDfeiNNYCidAuqX=WN0PncoqiokA@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: make xattr format of ksmbd
 compatible with samba's one
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have rebased cifsd-for-next on 5.11-rc7

Will kick off some buildbot tests with it this week - it is looking
good so far, but let me know of other PRs coming soon

On Sun, Jan 31, 2021 at 6:47 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
>
> > FYI - I have rebased the cifsd-for-next branch onto 5.11-rc6
> Let me check it!
>
> Thanks!
> >
> > https://protect2.fireeye.com/v1/url?k=776f3edf-28f407c5-776eb590-0cc47a6cba04-
> > 039abc8d8963817e&q=1&e=3337a309-5806-4005-8f00-
> > b7312c0621f1&u=https%3A%2F%2Fgithub.com%2Fsmfrench%2Fsmb3-kernel.git
> >
> > On Tue, Jan 26, 2021 at 4:46 PM Namjae Jeon via samba-technical <samba-technical@lists.samba.org>
> > wrote:
> > >
> > > 2021-01-26 23:36 GMT+09:00, Stefan Metzmacher via samba-technical
> > > <samba-technical@lists.samba.org>:
> > > > Hi Namjae,
> > > Hi Metze,
> > > >
> > > >> Samba team request that ksmbd should make xattr format of ksmbd
> > > >> compatible with samba's one. When user replace samba with ksmbd or
> > > >> replace ksmbd with samba, The written attribute and ACLs of xattr
> > > >> in file should be used on both server. This patch work the
> > > >> following ones.
> > > >>  1. make xattr prefix compaible.
> > > >>     - rename creation.time and file.attribute to DOSATTRIB.
> > > >>     - rename stream. to DosStream.
> > > >>     - rename sd. to NTACL.
> > > >>  2. use same dos attribute and ntacl structure compaible with samba.
> > > >>  3. create read/write encoding of ndr functions in ndr.c to store ndr
> > > >>     encoded metadata to xattr.
> > > >
> > > > Thanks a lot!
> > > >
> > > > Do you also have this a git commit in some repository?
> > > Yes, You can check github.com/cifsd-team/cifsd
> > > tree(https://protect2.fireeye.com/v1/url?k=abb45e79-f42f6763-abb5d536-0cc47a6cba04-
> > 4d12d0be7dd14e1f&q=1&e=3337a309-5806-4005-8f00-b7312c0621f1&u=https%3A%2F%2Fgithub.com%2Fcifsd-
> > team%2Fcifsd%2Fcommit%2F0dc106786d40457e276f50412ecc67f11422dd1e).
> > > And there is a cifsd-for-next branch in
> > > github.com/smfrench/smb3-kernel for upstream.
> > > I have made a patch for that git tree, but I haven't fully tested it yet...
> > > I'm planning to send a pull request to Steve this week after doing it.
> > > >
> > > > I played with ksmbd a bit in the last days.
> > > Cool.
> > > >
> > > > I can also test this commit and check if the resulting data is
> > > > compatible with samba.
> > > Great!  Let me know your opinion if there is something wrong:) Thank
> > > you so much for your help!
> > > >
> > > > metze
> > > >
> > > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>


-- 
Thanks,

Steve
