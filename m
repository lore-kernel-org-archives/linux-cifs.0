Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81845C432BE
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 17:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536376101B
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 17:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbhHaRop (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 13:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhHaRoo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 13:44:44 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E229C061760
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 10:43:48 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id f2so123317ljn.1
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 10:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lnd65774JO8YYmZVOhCC16tnqq32B7o8SgIDuZJ5NNY=;
        b=Xz7mg9NXLim+9Vg9JD5Jw6XT5OV9xbyVxCx9yHvWMsYpvK1sLGgOT6Vdn6dA5zxaf9
         xr+O6z59ZBDsfmnS+iVFCQt/C9bOlQyS/6C3phRAhM8PSgMDhbBjCrj9e9kZQx1Y5SHc
         ErjpSlzPY38B0e9mc65A7J3UWaM010BxzOQIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lnd65774JO8YYmZVOhCC16tnqq32B7o8SgIDuZJ5NNY=;
        b=ctyfu4yepvJxJmO2qpyGAUmsTwMb9ggPNzgWBqLs1LABjNkSBlz/mq1nXsrtsweXvX
         1II3kNi51mjteyxZmgj15vMdNWowyaLIfpkwnBQMOo/vnwmYjyFu4JTQj+ErzeSm89sN
         GfhfwTFh++GxL8MKPuKdY8KZ76O/pmST35hEiUF5cLh8xhhYOBC5Pw2ddJaowWegwc9d
         6/t0RkDPyeH+jPsleU3vfOkkpChX8UW1FVBboB2uLN5eS4blOzKsCW6gyiDnc34OD36i
         7rYCbGbLd9+k882KIypniP8T0zCLpBoy8xY+8hbWgCYzOJKvFAHImN1IOfb8BjhmPvYZ
         3FJg==
X-Gm-Message-State: AOAM531ddHKGrEgSbjlIO0IL2+WDQZ0z8sKcHi+4HgqEP+Y0fP6RBlNg
        jLuyEN+tAeq4kOshdwO1d4u6I2319QCGljIk4YE=
X-Google-Smtp-Source: ABdhPJyz/R9Mc+sk9kikn9j/+vaaFfyQAhJrhElRKScwmdM+nyuaS00FpfMxImnXvVJ1/B+Qd3p4yA==
X-Received: by 2002:a2e:83d0:: with SMTP id s16mr25974226ljh.328.1630431826270;
        Tue, 31 Aug 2021 10:43:46 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id r19sm2261639ljn.139.2021.08.31.10.43.45
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 10:43:45 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id c8so503557lfi.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 10:43:45 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr21985146lfp.41.1630431825288;
 Tue, 31 Aug 2021 10:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
 <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com> <CAH2r5mtTLUQa2U=MGHOVk_FsPZg6owMsw+RoTudWxGuoQej41g@mail.gmail.com>
In-Reply-To: <CAH2r5mtTLUQa2U=MGHOVk_FsPZg6owMsw+RoTudWxGuoQej41g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 31 Aug 2021 10:43:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com>
Message-ID: <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 client fixes
To:     Steve French <smfrench@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 31, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrote:
>
>   So if you are ok with renaming the client dir and module
> name - we can gradually stop using the word/name "cifs" except for the
> parts of code which really are needed to access the (unfortunately
> hundreds of millions of) very old devices which require SMB1 ("CIFS").

I'm ok with directory renames, git handles it all well enough that the
pain should be fairly minimal.

I'd ask for that to be done during a fairly calm cycle, though, when
there isn't a lot pending, so that any rename conflicts will be
minimized.

> We could even build two versions of the module "smb3.ko" which does not
> include support for the less secure legacy dialects and "cifs.ko" which does
> include it.   Is there a precedent for something similar.

I'm not sure there is precedent for that, but that's not a huge issue per se.

Whether it's actually worth it having two separate modules, I don't know.

That said, I'm not entirely enamoured with the name "smb" as a module
(or directory) name, to put it lightly.

Part of it is that it can mean "system management bus" too, although
in the kernel we happily universally (?) use "smbus" for that.

But a big part of it is exactly the history of random different names,
which means that I'd like any new name to be more explicit than a TLA
that has been mis-used for so long.

So yes, we have "fs/nfs/", but I'd rather _not_ have "fs/smb/".

They may superficially look entirely equivalent - but one of them has
had a consistent name that is unambiguous and has no horrible naming
history. The other has not.

> Do you have any objections to me renaming the client's source
> directory to "fs/smb3" (or fs/smb) and fs/smb3_common ...?

So no objections to the rename per se, but can we please use a more
specific name that is *not* tainted by history?

I'll throw out two suggestions, but they are just that: (a) "smbfs" or
(b) "smb-client".

I think "smbfs" has the nice property of making it clear that this is
just the filesystem part of the smb protocols - that otherwise cover a
lot of other things too (at least historically printers, although I
have no idea how true that is any more).

And "smb-client" as a name is in no way great, but at least it's not
just a TLA, and from a naming standpoint it would match the
"smb-common" thing (although I guess you used an underscore, not a
dash).

Again - those are just two random suggestions, and I'm not married to
either of them, I just really don't like just that "smb" because of
all the historical naming baggage.

So if we rename, we should rename it to something new and slightly
more specific than what we used to have.

I'd rather have a module called "smbfs.ko" (or "smb-fs.ko" or
"smb-client.ko" etc) than "smb.ko".

And no, I wouldn't want it to be called "smb3" either. Because it
clearly does cifs/smb1 and smb2 too (even if people would obviously
like to deprecate at least the older parts).

Hmm? Is there some unambiguous name that is in use by the smb
community and would work?

                 Linus
