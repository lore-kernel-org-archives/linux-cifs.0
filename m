Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E380C433B4
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 01:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A41610FB
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 01:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhDJBgv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 21:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDJBgu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 21:36:50 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203DEC061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 18:36:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x13so2356054lfr.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 18:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+UDj9XpsFRndTdoS7BpTYErFCbe3gk9WERQlwXf+fw=;
        b=Wje9cfrDcN8TfgVV7HVoVWi6N4gH8KOHxHcw4JG7Wdb24YuYmV9ycQ0XPRlNbm0jsC
         mGGc1guQOa1ckJDB48vF/YmrzcsyaVYyDqjlKQZm9Xs3iasAaz1V8cWbnL80NgRV10xw
         ufHLkwJ2+tTWjhChnBO+8Wm6J/FApYoJu4iD+HMJxrs7GB/57LXWKihYgfRJBVGRtM8t
         4F/RLhC0EgSkgJtM7dwInOR3ZPVZ9DhEi2JxvdWAqoTAPZAWiysZlTMNC9NF50Opq2S0
         H8Ae33NGcLlgsWSCXbPYxDEcVYh3NxeLyDbdbfBuYuTh3o1S6h7bi8pJLWrDYuRob+An
         uSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+UDj9XpsFRndTdoS7BpTYErFCbe3gk9WERQlwXf+fw=;
        b=H+oTHPxO15O0oilR1eW0/CIXZP3YFqCO69KbG5BjyjgsHFFmxk6NuZelrL2OD8j3Ac
         VsaTt2R1qYfzl4+54RKYDdRvD8LcbTpWBpmXkewPfCA/TDcLuRxSjPUotdLBhpJp8+d6
         CR3reumZoHvOnXG2hheSEl/t/7JqxkayAUBWnelj00ayjNHuqzuavzjAmAwR/lF1iWeG
         /ZB7+m97aJBfRwJUcYfOYwN2ZzfEbwvQLchrqaIJE07AX3bo2sM8wOXiO62Q/SIPEzUh
         Bv8Z1Eh8DPCXkNBCOUkoemHdgPCeW8Dk2Lno1sn5fE9scwZuY9JmKqAX5BwGZyYSO0aO
         A7Vg==
X-Gm-Message-State: AOAM530XjRPk3tcKeLGpWPJn/CYY0R9IXT2dq2zjU6ykmWoE/J5650iL
        sjWKDpbQxWAH/Dfr86ZNmHo/ZhfsmIvtHLh/V99Y3LgmtYo5IA==
X-Google-Smtp-Source: ABdhPJwyDSRwIdltoS6uS/qtt6eZ05xzbEvG1edOcqKPqNP/4CjLpBiSUkbKFa3LIuF1uLiQ+PgaRbguBsJzGYxLouw=
X-Received: by 2002:a05:6512:6c4:: with SMTP id u4mr11465728lff.395.1618018595592;
 Fri, 09 Apr 2021 18:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk> <CAH2r5mvEF6RyQ2dCB7y9m_knDxFWw6q2+kBBT_+seA3Tcox4EA@mail.gmail.com>
In-Reply-To: <CAH2r5mvEF6RyQ2dCB7y9m_knDxFWw6q2+kBBT_+seA3Tcox4EA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 20:36:24 -0500
Message-ID: <CAH2r5muY4wQjqw9MhP0-NchXMSNQ+JfwNiDtmNcJMC3i0vPGxg@mail.gmail.com>
Subject: Re: [CFT] vfs.git #work.cifs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Your series passed an all Azure test group
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/20
(with additional patches) and the main test group (with your 7 and
Ronnie's finsert/fcollapse)
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/20
which tests to the wider variety of server and target server fs types.


On Fri, Apr 9, 2021 at 3:30 PM Steve French <smfrench@gmail.com> wrote:
>
> So far so good (has 5.12-rc6 + Al's patches + 2 from Ronnie for
> finsert/fcollapse )
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/552
>
> I did get one failure last night that caused hang in subsequent tests
> but looked unrelated (some reconnect issue) but rerunning looked ok
>
> Testing to Azure should be fairly easy (apparently there are some free
> accounts for testing Azure, I used to do it from MSDN) for developers
> - but these are run to a mix of targets (including Azure) some of
> which are higher end (e.g. multichannel) targets.
>
> On Thu, Apr 8, 2021 at 8:47 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >         Could somebody throw the current variant of that branch
> > (HEAD at 224a69014604) into CIFS testsuite and/or point to
> > instructions for setting such up?
> >
> >         Branch lives at
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.cifs
> >
> > Al, really wishing he could reproduce the test setup locally ;-/
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
