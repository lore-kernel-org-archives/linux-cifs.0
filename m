Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBB6C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 02:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiC3CZZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Mar 2022 22:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiC3CZY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Mar 2022 22:25:24 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23CD3A195
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 19:23:39 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id r22so25851766ljd.4
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 19:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xmE2B0KqajgiiBd6cZk1SV9UJHZuFPaj2pvt9v+n5VA=;
        b=ZUaJlUBPKUh5Cu7A8Rcew5FOgBY6lQnMw4Cu0Lgru4a3y791MjVdZMYtpXAPN+oy5l
         9uOYPLTHkCommFKc4kdBn1lpTJlICoff8/tuBmfKDAb/rqGb3GCkXI/xn/E8JrklIRep
         evg2AiHR4/XbKIuXDooc2x6/uFmIxSDuOOxNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xmE2B0KqajgiiBd6cZk1SV9UJHZuFPaj2pvt9v+n5VA=;
        b=tIBzb2Owd6S8LVpRVpDYBcUbL8A8jM5IXSTlW/4A4lk7IePsSJvz2/0mmZp19utOkq
         SxVldOrVw04NitnQh3/AXePQTYRqybxqZyDPlKCCDSN0jMoGL1AxPeOGQHjZRIJHQGyw
         PtWcR9w6eKfMAgvz/a2XJ1UpyxWyVlX0v2xFf3wwk1VVHSL19zVXVb3pCIiiSXk2aDSV
         PDbnOeZl25WNGTT2fE2RZGQgIW8wtOQQxXkNcq+DcDaIkbW9zSHjTJSDVdL4gpS7KkPG
         fAmhdVtWWK8h6iY29AHssEock/8xoUaO0Njtuv2YNI7AWn4fZEddm+HBBn0i3WVIZu46
         fvIQ==
X-Gm-Message-State: AOAM530zfSBVz/A6gaiqMT7noCIkkpfnHev6TCRMSjzdW1Y9invtkmFJ
        BRXHPUiDTKqgiUEj9s6rtEaqUglVZ05u+Vl8
X-Google-Smtp-Source: ABdhPJzBYjfKmsnJYwqb0Jm5N+KpgtC3EON4paLC+xX0m5A7MXP6ORctmMMb4z3U9TMpR9ColCr6/g==
X-Received: by 2002:a2e:b746:0:b0:249:6f44:16c0 with SMTP id k6-20020a2eb746000000b002496f4416c0mr4948633ljo.133.1648607016908;
        Tue, 29 Mar 2022 19:23:36 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id g12-20020a05651222cc00b0044a1065ca5fsm2164998lfu.304.2022.03.29.19.23.35
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 19:23:35 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id bn33so25855404ljb.6
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 19:23:35 -0700 (PDT)
X-Received: by 2002:a2e:9b10:0:b0:247:f28c:ffd3 with SMTP id
 u16-20020a2e9b10000000b00247f28cffd3mr4963210lji.152.1648607015230; Tue, 29
 Mar 2022 19:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
 <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
In-Reply-To: <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Mar 2022 19:23:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8CFSfu8bSs1ggiX6gW0Qx_MdZAbxC6bWHi-GQRyErAw@mail.gmail.com>
Message-ID: <CAHk-=wg8CFSfu8bSs1ggiX6gW0Qx_MdZAbxC6bWHi-GQRyErAw@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 29, 2022 at 6:48 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'd be even happier if we could actually have some common helper
> starting at that
>
>         trap = lock_rename(...);
>
> because that whole locking and 'trap' logic is kind of a big deal, and
> the locking is the only thing that makes __lookup_hash() work.

Hmm. The cachefiles and ecryptfs code seems to have a fair amount of
this pattern.

None of it is exactly the same, and maybe it's hard to really have a
common helper, but it does look like that sequence from

        trap = lock_rename(...)

leading up to the eventual

        ret = vfs_rename(&renamedata);

would be really nice to capture some way.

But maybe there just isn't any actual code commonality outside of the
general pattern.

I was curious, and that "trap = lock_rename()" pattern including those
"exit5" labels is _ancient_, btw.

It goes back to a commit by Al back in 2002, best seen in Thomas' BK
history conversion:

    https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=1b3d7c93c6d1927540120bafb08fa60c0d96cbee

so it's not like this is a pattern that has seen a lot of changes.

Maybe it's ok to just have various copies of it, but let's see if Al
has any ideas.

             Linus
