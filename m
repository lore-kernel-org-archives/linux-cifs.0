Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B97C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 02:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhLACVR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:21:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhLACVQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Nov 2021 21:21:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D646CB81DCE
        for <linux-cifs@vger.kernel.org>; Wed,  1 Dec 2021 02:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918D9C53FCD
        for <linux-cifs@vger.kernel.org>; Wed,  1 Dec 2021 02:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638325074;
        bh=CiQJxYRhRRBSDokRZpVtvZx9haLXdX399pCmP6sANq0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=IqEpQmVF5+LqEUHZOHd3vYvmlvrsEtrX7Ygv6lphLANAnGqgwsUsizWMpbh+UiriF
         HqfSS9RghADDl7ztNT7052qlaSyeL3mm/G04rIFpWXzaQCohabpLv5AMtz+s58wqjM
         l5w2HMuZ2OtPpJTs6nc3k0Zvn9piPlrQa57fPDlXzcJuxOh1sXIYTkT9ObriAM8/FI
         DgGqRGoaCeWL5UDaOS7By3pjeAK+5nJL7jXtQu+/AXliqP+d7uRy1hzc/KzfKy7KM/
         kGVNl1KkWu4vE8VhI0r+nyW6d2tmI8OTw/Bn1zph9rbgs6Mxuz47zyCV407Gz2hJjz
         iOYsS2VaVgusg==
Received: by mail-oi1-f172.google.com with SMTP id u74so45316460oie.8
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 18:17:54 -0800 (PST)
X-Gm-Message-State: AOAM530l149IQYJeZgdfRqVRla1qP6jEXf9+gS/l/8hb6kL2MtNxyCgi
        5XRnBK+GfHN+Ag3oFMTf2svI1CCNZJAWZsCZ7jo=
X-Google-Smtp-Source: ABdhPJwv45ywEnxGsjEoX7ZsNAkC8/3BdMLuzpH+HpzeHPJLaknh009RrDLmHob2lZyoE9ioYeB57tP49ib5wwkMPlg=
X-Received: by 2002:a05:6808:1202:: with SMTP id a2mr3263400oil.8.1638325073805;
 Tue, 30 Nov 2021 18:17:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Tue, 30 Nov 2021 18:17:53
 -0800 (PST)
In-Reply-To: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia>
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Dec 2021 11:17:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
Message-ID: <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-01 3:47 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Hi Namjae, list,
Hi Enzo,

First, Thanks for your work!
Cc: other maintainers.

>
> I've been working on the unification of all ksmbd-tools programs into a
> single 'ksmbdctl' binary, and I would like to invite everyone to test
> and/or provide me feedback on the implementation.
While checking this out, I'd love to hear from other maintainers.
>
> Since this a big-ish refactor, for now I'm sharing the code via my
> GitHub repo:
>
> https://github.com/ematsumiya/ksmbd-tools/tree/ksmbdctl
>
> I can split it into smaller commits later on, if approved for merge.
Great.
>
> Commit message below, for a better explanation.
I will check it and give feedback soon.
Thanks!
>
> Cheers,
>
> Enzo
>
> ==================================
> commit 1135e0f6b592fb48d6b20b919c44ddb961d0c51d
> Author: Enzo Matsumiya <ematsumiya@suse.de>
> Date:   Tue Nov 30 15:22:35 2021 -0300
>
>      Unify all programs into a single 'ksmbdctl' binary
>
>      This commit unifies all existing programs
>      (ksmbd.{adduser,addshare,control,mountd}) into a single ksmbdctl
> binary.
>
>      The intention is to make it more like other modern tools (e.g. git,
>      nvme, virsh, etc) which have more clear user interface, readable
>      commands, and also makes it easier to script.
>
>      Example commands:
>        # ksmbdctl share add myshare -o "guest ok=yes, writable=yes,
> path=/mnt/data"
>        # ksmbdctl user add myuser
>        # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
>        # ksmbdctl daemon start
>
>      Besides adding a new "share list" command, any previously working
>      functionality shouldn't be affected.
>
>      Basic testing was done manually. Updated README to reflect these
>      modifications.
>
>      TODO:
>      - run more complex tests in more complext environments
>      - implement tests (for each command and subcommand)
>      - create an abstract command interface, to make it easier to
> add/modify
>        the commands
>      - find and fix obvious bugs I missed
>
>      Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>
>
