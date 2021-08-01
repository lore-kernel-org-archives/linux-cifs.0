Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C20C4338F
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Aug 2021 04:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39EDF60F00
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Aug 2021 04:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhHAENK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 1 Aug 2021 00:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhHAENI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 1 Aug 2021 00:13:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6464C06175F
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 21:13:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b13so6210236wrs.3
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 21:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kDfPu2jItJ4KeFgRl93CoV68EzB/9AO2isy9mSlXi5U=;
        b=Gggs87d+hH6E0Hb0S6yO6cqjYRWXca430UFbdPsX5GDYGdP7cI9FZKuDRiy4R7pIiE
         xKo46GmQapsl2OxMr8O5zpFgnxe1Z0ovbZMNqeY0B2Pp8QgTClvwry2mIAgkwLG/1til
         eyfthNEp5irU8xf9JnaRFAzDkl8UhckWtNGcYtFylSc4fYQlJF8Fa3b8tLMjwDTPWSCd
         slramqUNAZUQiJvsICga62ASXivin0eoK+bIkaFSY9Pg6qH/jQkRXSQQ7WgoIDDx6iq5
         ybSHxsErp58N/Mca4m+8+7hKfKHXfHs6oL8f1Y2R2NaaL1Dkc8cfRTvGkfStfqOonSX7
         i8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kDfPu2jItJ4KeFgRl93CoV68EzB/9AO2isy9mSlXi5U=;
        b=t5p0bqCUUtMgk/MhpIb5xCDD27gU0W4e6zYftwncaS2IER4xtmVAkMP+3NFdlDL7/v
         zzylc+NQtCBMlg2hFxXt+aX8BmYQP4Lb3pn99VZYBQ1563z25gcAmezgUB5bmmld1Osq
         P4mxEcmj72hjkVa90K8LwW0cMFv6Odb1ixDiO7rci0b/EZ27jihFsSiwMqucZObDxUbl
         PBhTFXUUlvIrZOvEqzs4t9wJVMJ3hGcYFt/LhuWxGruQFgr60aZEO+xZDqnLt+QHMGP2
         O+rOS5C4uVMUY9lK3zuBNb5hYzBFHUCwlSrzuF4fiaj0//2KcHTKYxHcItSnasRXMS1l
         a9Qw==
X-Gm-Message-State: AOAM531D0qj+BazV+UiUBT2BhZ2EZ6Hsc5bisi3rRyTHqpE89U2e9ujE
        VGhROOYt79yA1sNsKpCDsT65SH7mWSaBPKIhXA==
X-Google-Smtp-Source: ABdhPJymvLjMjO/tqYmkn5tGJYsu9N/oGQRaa7Ct0XF4MWBVC2HspkwHHq5ASldgUDafzF+Qss8BaBQidfkRam49heM=
X-Received: by 2002:a5d:4585:: with SMTP id p5mr10762826wrq.265.1627791179321;
 Sat, 31 Jul 2021 21:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <CANXojcy9sAY6Sd62Xs2nnjPNHWuUWQwcSpAAyAoT+VPDWizhOQ@mail.gmail.com>
 <CAN05THS_KtutZxOOap7xPU3d+XfEJJTe7XT9sZ1tVZFMcLAYEA@mail.gmail.com>
In-Reply-To: <CAN05THS_KtutZxOOap7xPU3d+XfEJJTe7XT9sZ1tVZFMcLAYEA@mail.gmail.com>
From:   Stef Bon <stefbon@gmail.com>
Date:   Sun, 1 Aug 2021 06:12:48 +0200
Message-ID: <CANXojczOzWWebVJNDmS-b=cYSFOJ=0dSNSeNJ6T5+-FZfq_pNQ@mail.gmail.com>
Subject: Re: Question about parsing acl to get linux attributes.
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Op za 31 jul. 2021 om 23:57 schreef ronnie sahlberg <ronniesahlberg@gmail.com>:
>
>
>
>
> Example:
> 1, S-1-2-ALICE                  ALLOW   READ
> 2, S-1-2-BOB                     ALLOW  READ/WRITE
> 3, S-1-2-EVERYBODY      ALLOW   READ/WRITE
> 4, S-1-2-BOB                     DENY     WRITE
>
> In this case, even though there are two ACEs that would grant BOB
> WRITE access (the ACE for BOB and EVERYBODY), BOB is still denied
> write access due to the presence of a DENY ACE for WRITE.
>
> In this case the ACEs are evaluated in the following order
> 4, 1, 2, 3

Wow this will take a lot of time to process when listing a directory.
After the readdir for every entry a lookup is done, for more details,
and then this processing of a list has to be done.

Is it really required to do this more than once? You mention looking
first for the denies, and then the allow entries. But what happens if
there no allow entries, then it will be denied I think. Is it
something like iptables: there is a default policy which counts when
no rule applies?
If this is the case you do not have to do it twice:
- if the policy is deny, you only have to look for allow rules
- and vica versa if the policy is allow, you will have to look for deny rules

Stef

PS it is sophisticated, but (I read somewhere) no system administrator
will use the fine grained rules, use defaults (which make them
predictable).
