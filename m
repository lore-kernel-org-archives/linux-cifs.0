Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C09FC432BE
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 17:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB60610E6
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 17:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbhHaRJ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhHaRJ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 13:09:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B43C061575;
        Tue, 31 Aug 2021 10:09:01 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z2so307698lft.1;
        Tue, 31 Aug 2021 10:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdVhQl1AA3NYR5Y28IbfQxZ7Txmq2EPWrQl9yB9/fZM=;
        b=uE4LCEGokfsQFSnQiDm+z+xI+rr8OUzBYDsGz09P2ekdwyek+LNClH/4/tL1Kh067w
         uMLC/6FSRcgLljPnxvzeb5sYTRZQXBLLSK2WFGEP5xm+hV8EquCps3ydk4muJjKrzLJi
         kQ8NP1HWl/qKwb+O0/nSCAeOPcUk36Ixh2DjgRQiF8U0TQYjFfFB6mrefqCuVhu63sc3
         2ZHR5kzfQTKvMygBW5npxWAUZcTkZJ51qHGvEuSlWnHshX7UoD7rNM4dVaWAsOM9Dbsq
         R9A+BUo8jpp796QRADct8pVjPG+xWGz+oFCbEvw0boKH7qVD49VbzDxV7XCgXjjbmCGU
         WDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdVhQl1AA3NYR5Y28IbfQxZ7Txmq2EPWrQl9yB9/fZM=;
        b=OG0tYqqF4EOCLxsFGKJOik7zCp/nD08lUXhtsVvBnFOOw+UZPW2CxqnXqIvfEzeG9J
         wgdHRJ+o3QRdTJ/uZAdWNtQTRXgo3lv46/jB74wpoWIkQobZeNYeS/X7MsQz+uDJ7Iks
         /q1cdaKSj/bsYaSprv2VxNBKwsQNNzLnmnNGBmLua3WcrD0jwPrpV4QZ+RsszUL9oUi8
         u1iJuYHQ0N+0OVcJ9/JRxPdNxK8wcgAQ+0cdtI/9f5R9FFREzG5VT2WWRg7kai/b8snP
         la6rDV2Te8zzEq+1iFiYXI3Ndb2wHs7JJB9Td3w+/A66GbPpJs4GVj4DXxdg1KoRNxY5
         CG9w==
X-Gm-Message-State: AOAM531yN7bHJBHRZjSujP95Ffv/ZkCp6GD2hTOZ8DV/bdhG1NUCkgIy
        TE9ulES1BqjQcs7fukytTrof6FXDKzaoff4R+yyowna6
X-Google-Smtp-Source: ABdhPJwqSEbsDf2RgvQHuasmksVMqpQ/BuuPPMMzavKg3Rc2DnPFO/sPDECXCSmWZatGLM+HWWbTemuWQNHaGKHEhGU=
X-Received: by 2002:ac2:54a4:: with SMTP id w4mr10746063lfk.133.1630429739587;
 Tue, 31 Aug 2021 10:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
 <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
In-Reply-To: <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Aug 2021 12:08:48 -0500
Message-ID: <CAH2r5mtTLUQa2U=MGHOVk_FsPZg6owMsw+RoTudWxGuoQej41g@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 31, 2021 at 11:40 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Aug 29, 2021 at 10:48 PM Steve French <smfrench@gmail.com> wrote:
> >
> > - mostly restructuring to allow disabling less secure algorithms (this
> > will allow eventual removing rc4 and md4 from general use in the
> > kernel)
>
> Well, you should probably have mentioned that you already started on
> this by removing LANMAN support.
>
> I'm sincerely hoping nobody used or depended on that old garbage in
> this day and age any more.
>
> Anyway, entirely unrelated question: you pretty much interchangeably
> use "cifs" or "smb3" for the filesystem, as shown once more by the
> commit messages here (but also the subject line).
>
> The filesystem directory is called "cifs", and I've taken to use that
> in my "Pull cifs updates" thing from you to just avoiding the
> confusion.
>
> And now we have ksmbd (yup, I just merged that pull request too), so
> we have a "cifs client" and a "smb server". Aaarrgh.
>
> I understand that some people may care about the name, may care about
> "smb2 vs smb3", or whatever. But I have to admit finding it a bit
> annoying how the code and the directory layout uses these different
> terms pretty much randomly with no real apparent logic.
>
> Somehow the NFS people had no problem completely changing everything
> about their protocols and then still calling the end result "nfs
> client" vs "nfs server".
>
> Oh well. I'm assuming it's not going to change, and it's not really a
> problem, I just wanted to mention my frustration about how clear as
> mud the naming is.
>              Linus


I (and many at Microsoft and in Samba team etc.) also have a strong
desire to stop
using the word "CIFS" as it has been associated with some very high profile
attacks, and with the introduction of SMB2.1 support (which was far more
secure) in 2009 no one should be using the very old CIFS dialect
(aka "SMB1" dialect).  So if you are ok with renaming the client dir and module
name - we can gradually stop using the word/name "cifs" except for the
parts of code which really are needed to access the (unfortunately
hundreds of millions of) very old devices which require SMB1 ("CIFS").
We could even build two versions of the module "smb3.ko" which does not
include support for the less secure legacy dialects and "cifs.ko" which does
include it.   Is there a precedent for something similar.

Note that with the introduction of various security features
in SMB3 (then even more security features in SMB3.1.1) it seems like it seemed
confusing to users to tell them "mount -t cifs ..." which was why I
added support
for "mount -t smb3 (to cifs.ko)  in the 4.18 kernel/   but I also
would strongly like to
stop using the word "cifs" in module name going forward, even if it does cause
a little bit of extra work for distros (most of which could be handled
in the mount
helper in any case)

If no objections,  we can start moving most things on
the client to "smb.ko" rather than "cifs.ko" ...

Do you have any objections to me renaming the client's source
directory to "fs/smb3"
(or fs/smb) and fs/smb3_common ...?



-- 
Thanks,

Steve
