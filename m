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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4165C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 01:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FAE4610A8
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 01:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDIBzA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 21:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIBzA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 21:55:00 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B93C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 18:54:48 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 12so7072485lfq.13
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 18:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNij33TshObf/RFrk9AhDj1oQJB9Cs2Y6oRXHztG/3Q=;
        b=fZJarEsUWW1SNc40UOSmTEd7Cgvc+mMLetz+2D1F3DVdizFB8BUOFE7o9828zVphMV
         2fs+PWiz+vFf41GlNC3MAo9oHVOhRy/Y0KSffiwrC6TiFDiT8lsYm0XmvDdEwYofBpY4
         q3tEsOVz0dPUUxPLkRNfja1O/QKVeUFNnq/OBkEPxWS8qOx5cnjMPSOmc3Yatk3Wxr6H
         d7v/uPA+acc/haOqEhjWMnasi2awwav8Im3uzlc1UzQKNRbkkPAawTKTIw3yJrQIDkc6
         SlyKr/ZP+ytK002V5Vmthwk+udadvheWRuMNRB0v99M+OVtJJ8n0dSncWdJcPXIj3DU7
         psgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNij33TshObf/RFrk9AhDj1oQJB9Cs2Y6oRXHztG/3Q=;
        b=K3Ie70BOas14lL5bq2HCPTokbH9fEXP0QnoZBXAX94j0SyDzOR0pPfDBDP3Jo7Vsi9
         417ildq3+YQRXDP0MJ0x0RP1IgcwGbzZpuC6TlDAk+C4HMymXl6XKLQGzv0jL4GxQJv9
         QCiW1r4OBBPqQ9mSSf+KE+TQUuemyrYGTNeQipk+J34f5PWGqwR99RBFQ3rilIQacbCN
         /RwiJ+SHndbKHZjfxDxHcJIWfbpHKWOlo6YYac1Sh7/DMD6Yg6nflycDkBCUdhAi2jIj
         vhTIBDkica2mrYATG8u3b81/1X6N0vNDgMduipb9OhrhLPYRQcOMwq+h4mBVb47jdQ2j
         vbfQ==
X-Gm-Message-State: AOAM5328NEn4MllXkxNRtp4LP0q9Dgb+a+Tm/rPffDRmRbwJJH2lOdbC
        9WHGCJz3I7v9YECwjIbl5y6gq7MX9abvgfWO7rn0PqOftXE=
X-Google-Smtp-Source: ABdhPJyohImwE44q62S4BpipuZBkdDBEKfggrNh5FMuwDKCD3BQvTxm6chq92dDlCQUQKWLkverB0amBvggsvqSuEUs=
X-Received: by 2002:a05:6512:6c4:: with SMTP id u4mr8432350lff.395.1617933286568;
 Thu, 08 Apr 2021 18:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
In-Reply-To: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 20:54:35 -0500
Message-ID: <CAH2r5msLHRQT5dT5KpT-41ScvhYt-23=KbYNQTfmp_DPX+R1EQ@mail.gmail.com>
Subject: Re: [CFT] vfs.git #work.cifs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I can put the patches back into the automated test bucket tomorrow.
There was a problem with the last patch of the series breaking, but
all the rest looked fine before.  I wanted to add onto those the
change (and earlier WIP patch of mine) to move the conversion of path
separators (depending on dialect) '/' to '\' to later (not in
build_path_from_dentry ... but rather later (where it is safer to do
the conversion) e.g. when the pathname is translated (usually from
UTF8 to UCS2 Unicode).

Setting up Samba server is pretty easy for testing - some of the
instructions are on the Samba xfstesting wiki page

Also interesting that it could even be a bit easier (setting up
automated testing on localhost) for some soon by testing to the kernel
server (ksmbd) but that is currently in linux-next not mainline (yet)
pending working through various code review comments, patches etc.

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
