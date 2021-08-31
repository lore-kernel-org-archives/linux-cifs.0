Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B4AC4320A
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 16:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F89B6109D
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 16:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbhHaQk7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 12:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbhHaQk6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 12:40:58 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E547CC061760
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 09:40:02 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id l10so77074lfg.4
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PlDvXWCwq9oQrcS+ObUACbXbifYYVn7FARrjhr/5Hw8=;
        b=LaDPyL+bvAPyD4iPhWTnGEliAF5N5bk9qNdn6gNkd/k4E9TXbp/ff4JtgKOD8IS41y
         9mfNzGlYM+qCWBkM3Xu6bQ0IZ4fcrj9gBV7prm6Ry88aItm9Up1BB36d6W2KxRIOCtWI
         LxLJxns5SrPZu9HOj88MgI//jXoAE0XHqJ6BQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PlDvXWCwq9oQrcS+ObUACbXbifYYVn7FARrjhr/5Hw8=;
        b=XIAigv6arM1ptruClEPu0MA/JgF5uYWKBugjQYuGwRX0LioUe8QmUQrbzlmeArI/i/
         +GNGNHhA+VMqinZsaNlBtkUnCc/ddB+/raEj+aI0mIlJKPak5VtYUmmsA/Oio3BXQ3hD
         r9az3t+XOzxFyLYWmyH/42W8BwTJQa6ZuAJpsG7s5F+qkRT/Zr4CQn2t2Ja+wuBoYzdc
         tQdld++4Jkj4BZrIRKmuKCCvHf2Eba+LVSatBflrEGG2IeZhwWdyG0ei4NIKIfEy1sQP
         vMPVungDnmtmlGjuINnaV++i7Aqiy9Kod7O8DtBd9BndOnoYlPNwJ6iocEdEGZzLDEPT
         /sQw==
X-Gm-Message-State: AOAM530DlDUvZS8huiV0MLzYibCmW4rWEwZnAaOMr0MW01W5cSDe9XjY
        sjSuJ1iueHNcrF2MkIQ7Q8sdbq/9nwTC4dHWLz8=
X-Google-Smtp-Source: ABdhPJyESagfZwQIK21bW8cuMWWoEpa0oleRtBRQgCL75kjvhkS41k0Cten0O78xc5aqYwCLPFqlhw==
X-Received: by 2002:a05:6512:3091:: with SMTP id z17mr15544689lfd.418.1630428000826;
        Tue, 31 Aug 2021 09:40:00 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id 207sm1847007ljf.41.2021.08.31.09.39.59
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 09:39:59 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id j4so9100lfg.9
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 09:39:59 -0700 (PDT)
X-Received: by 2002:a05:6512:1053:: with SMTP id c19mr9701063lfb.201.1630427999490;
 Tue, 31 Aug 2021 09:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
In-Reply-To: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 31 Aug 2021 09:39:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
Message-ID: <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 client fixes
To:     Steve French <smfrench@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Aug 29, 2021 at 10:48 PM Steve French <smfrench@gmail.com> wrote:
>
> - mostly restructuring to allow disabling less secure algorithms (this
> will allow eventual removing rc4 and md4 from general use in the
> kernel)

Well, you should probably have mentioned that you already started on
this by removing LANMAN support.

I'm sincerely hoping nobody used or depended on that old garbage in
this day and age any more.

Anyway, entirely unrelated question: you pretty much interchangeably
use "cifs" or "smb3" for the filesystem, as shown once more by the
commit messages here (but also the subject line).

The filesystem directory is called "cifs", and I've taken to use that
in my "Pull cifs updates" thing from you to just avoiding the
confusion.

And now we have ksmbd (yup, I just merged that pull request too), so
we have a "cifs client" and a "smb server". Aaarrgh.

I understand that some people may care about the name, may care about
"smb2 vs smb3", or whatever. But I have to admit finding it a bit
annoying how the code and the directory layout uses these different
terms pretty much randomly with no real apparent logic.

Somehow the NFS people had no problem completely changing everything
about their protocols and then still calling the end result "nfs
client" vs "nfs server".

Oh well. I'm assuming it's not going to change, and it's not really a
problem, I just wanted to mention my frustration about how clear as
mud the naming is.

             Linus
