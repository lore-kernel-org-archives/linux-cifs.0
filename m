Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815B9C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 16:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647D660F92
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 16:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhIMQVJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhIMQVI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Sep 2021 12:21:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAA1C061574
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 09:19:52 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id s10so22239620lfr.11
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 09:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZ5AIiQ6aFrd/M/UAQhSkKHu8hMS5SYIv0LOvT6rpa4=;
        b=Pcc3q95o5Y2eGdWSO0IuSJp0M9AEBhP7zlEBG4UOPSO0a5v9LOSzqjmUS4SRaT9Amr
         6+mequYy3Y1AyUla2RP97M/bRDpJDNNuxOMbzYDL29LTbVkl7cmvTQHRNauMZu6Xbe2/
         IUdTuDys+w7JUtOaglW+mc9UdLdPqMjdgEwNBrELFx24gL5NJNAEFukrqGf7PcUKmbq3
         +JPV5WSyV7nx1/Q6siL2ac409XhZlwyaaSFiMvEELmilGWOI0lnozKPGlNXKj3t8HC9v
         XjStqWk0Yb4ebNmxzf+itreQObaLSwGke9R28qo0GE51a9ey4ObrSswbF1pl2lnah7AY
         EaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZ5AIiQ6aFrd/M/UAQhSkKHu8hMS5SYIv0LOvT6rpa4=;
        b=XQKNou6Z2dWLjpiuWWD1LGLL4A6j8NXY6Bn0SCbkEFYLiKvoqTTQSF1p81cH8kq+RH
         qpTzKJ8jn1p9aHHH5mD4VXBdq3NzZSdXaONVN0OY6HUayry6LrxkH/CUeBi0a1xZXP3i
         26x4Lc1f7Lh1Q6atx7LK2qYmE35QxQAtluiP8y5jgtFmBi4YDjciFBF2carJ2j68gPql
         0J2vDVuikEYPr2ULnVZY3CCeR5R1JYcsO+CkCNdi9DBNME0i3QU+og6wqpKtWKVs1N06
         fJrI90z81HpYDzDhG3lyFcyUlHgY9b9OBwSwYkFpf98qLVRnt4Eq3QgJjsZ7Dfo48PCR
         ykkg==
X-Gm-Message-State: AOAM530dbO1j9uHvpmLZEInqMkMO3ppBs9Vft7Hrnv8shhgdoKO48eLy
        7aEhIdVM9JI5/XjZRzVZ3e9XhJCFqKrwcWuF+mIcvAQQ
X-Google-Smtp-Source: ABdhPJwm+sF6aAFauqOQ44M5grG5q5oDwe0R+jN9le/T8hLBEjeZNB/ccFLMLs3H7A5suqvPPCHfgpcRf6idBasTHHY=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr4498421lfv.545.1631549990800;
 Mon, 13 Sep 2021 09:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
 <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
 <CAH2r5mtTLUQa2U=MGHOVk_FsPZg6owMsw+RoTudWxGuoQej41g@mail.gmail.com> <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 Sep 2021 11:19:40 -0500
Message-ID: <CAH2r5mvz0s75cfhOvk92KN42WqqZPHj6uM5sJnPG0XYiEeBteQ@mail.gmail.com>
Subject: Fwd: [GIT PULL] cifs/smb3 client fixes
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any thoughts on rename of fs/cifs directory (so it is less confusing
in this post-cifs, smb3 world) ... I created a patch to rename it to
fs/smbfs but that could cause confusion because the directory would
then have the same names as the really old implementation of an smb
client on Linux (removed more than 10 years ago, created 20+ years
ago) which was in "fs/smbfs."     I don't see a precedent for fs
directory names like smb-fs or smb_fs or smb-client or smb_client ...
but that might be clearer.

e.g. with the "git mv fs/cifs fs/smbfs" if you then do a "git log
fs/smbfs" you see commits from a long time ago that have nothing to do
with cifs.ko

My slight preference would be a directory name like "fs/smb_client"
(or "fs/smbclient")

Thoughts?
---------- Forwarded message ---------
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, Aug 31, 2021 at 12:43 PM
Subject: Re: [GIT PULL] cifs/smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>


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


-- 
Thanks,

Steve
