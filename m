Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFFAC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 01:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbiC3Buz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Mar 2022 21:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiC3Buy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Mar 2022 21:50:54 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C12E1C931
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 18:49:11 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b43so21259670ljr.10
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFVXxEGcs3o9xt6nWAO4LCKdQ4d6aOglruUR5okbORk=;
        b=QKQL51Cux42VdIwClcLsfLc3Abp3pgwkGuv5SNcD9ongKKWnH7VYBcvBS7iQjyyGvt
         jbco+bRlh9Qsx/DdrXYP+5hklqXa4Qpa47Hx0lDNQqG14L0DxdaM154wVSPteYFbtgg8
         9vyzViuRjEQZ6tEtz7kbss3ISrRXoyk9x35ns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFVXxEGcs3o9xt6nWAO4LCKdQ4d6aOglruUR5okbORk=;
        b=DRprHzceGHj6fOSNAOvgYBy9EjOD0ikS+7pvlGS9/TZEj4zDtYEzfato7ZiOQzwtuT
         bzCb3+7Ur9BbqclTBGSrTegcTVo4y6k3IdRuD1H7Kbh5DbDFuPfzSqb6LqP6e3KDVHIZ
         O3gltm+k/s21v3eVE3R8D+69nV2kNJQKHWo/6UqNu7gz/nPsmCEWdmLJamG0zEVuauFy
         yew6uXm+3p7OAkO9b5B6MSA+mAApwJJ2rEFQlV3ICnDqlRk1dcBiUaP+um15NnO62iKO
         wEFA5ZjtfXuR3w4CynDfdy3MntfH01eApR9XZCWvwGtpEmcuse1kJiyAGXGPZwb8m3Sa
         aUQg==
X-Gm-Message-State: AOAM5332kP55jNJGOCdB4d2Y1OudkxSyAsD2fJUJRixoSlusMdbHPHQB
        SRO4tDqVE0iS6Gl+2zSXOVXMmUi+MS96+OX7
X-Google-Smtp-Source: ABdhPJyr0G7VIMS+1QYtWItA28c6rjc7O9U+UAO4cJOMOWH+m7pB23mdVk1z7ruRJ1k/rr5lDEQJjA==
X-Received: by 2002:a2e:90ca:0:b0:246:48ce:ba0e with SMTP id o10-20020a2e90ca000000b0024648ceba0emr5117465ljg.401.1648604948889;
        Tue, 29 Mar 2022 18:49:08 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056512168900b004489c47d241sm2168699lfb.32.2022.03.29.18.49.07
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 18:49:08 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id p15so33309173lfk.8
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 18:49:07 -0700 (PDT)
X-Received: by 2002:a05:6512:3ca1:b0:44a:93f1:45cf with SMTP id
 h33-20020a0565123ca100b0044a93f145cfmr5041233lfv.542.1648604947566; Tue, 29
 Mar 2022 18:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
In-Reply-To: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Mar 2022 18:48:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
Message-ID: <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Mar 28, 2022 at 6:39 PM Steve French <smfrench@gmail.com> wrote:
>
> - four patches relating to dentry race

I took a look at this, and I absolutely hate it.

You are basically exporting vfs-internal functions (__lookup_hash() in
particular) that really shouldn't be exported.

And the _reason_ you are exporting them seems to be that you have
copied most of do_renameat2() as ksmbd_vfs_rename() but then made
various small changes.

This all makes me _very_ uncomfortable.

I really get the feeling that we'd be much better off exporting
something that is just a bigger part of that rename logic, not that
really low-level __lookup_hash() thing.

From what I can tell, almost everything between that __lookup_hash()
and the final vfs_rename() call is shared, even to the point of error
label names (ok, you call it "out5", the vfs layer calls it "exit5".

The main exception is that odd

        parent_fp = ksmbd_lookup_fd_inode(old_parent->d_inode);
        if (parent_fp) {
              ...

sequence, but that looks like it could have been done before the
__lookup_hash() too.

I'd be even happier if we could actually hjave some common helper
starting at that

        trap = lock_rename(...);

because that whole locking and 'trap' logic is kind of a big deal, and
the locking is the only thing that makes __lookup_hash() work.

Adding Al to the cc in case he has any ideas. Maybe he's ok with this
whole thing, and with his blessing I'll take this pull as-is, but as
it is I'm not comfortable with it.

     Linus
