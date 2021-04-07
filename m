Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69157C433ED
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 00:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A89613C0
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 00:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhDGASI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 20:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbhDGASH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 20:18:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957E5C061760;
        Tue,  6 Apr 2021 17:17:58 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mh7so14735306ejb.12;
        Tue, 06 Apr 2021 17:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKVtgqn3FTurcOSdNrQJXSMQKGxJcG+Owhfj5N0hU7Y=;
        b=A5ZP5eKrx8vDWZkqIePXqyNHJutxfC/J15bpfUtlPvMzj72A4ChpSBj0Rv1CRgvAdy
         z5BCCfEomP6BXF7oQb999RbCivKrexuSzaJzWZfXQXgJyJuYs4f8gEQr/L9tyNxEcGmi
         I52PhKt9nVhEQZMFQV20+75COflG0PIaCe7dGeRjBJDgrfKbDIrH16WKtrtbA4KBK80l
         2aU2MZo43Quu7g4OMTMRQJeZbNZ9SXD3S3BgCFSLqcLszlu+UWyDm6qL0arE3+17DVYw
         Ho9eNDsXb3a8FryWJQfz2YakPoTs6BqjZtbdxXBCaErN8pOhQ0CRkYvyI+ZOwKwgj8ar
         rSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKVtgqn3FTurcOSdNrQJXSMQKGxJcG+Owhfj5N0hU7Y=;
        b=BS+1z5fR6mOqOjT1rSAHr+hPww84UsAD/yh3Shor9HsxIX4iJ/+ppennXHt7ci3PAz
         m9dPREcXJR2DBLGVJmApSjlTi7RURTWFGpeagw5kMveSEiyb8MV7OFSGgTI4uFh7mJ2f
         XY2IhVyD1pOYrB2advLdJC1xo/nj1+w4yQ2sJIJ4EGmgU6x5k7WIeV3PYLgBSgXNaI3N
         atOZoyP3Fsm3otlrgQvjh2KVqixlXuv4NbsPW802rC8ZpFGMRUzSiDmaTXTmrF8ckHek
         aFOzt4eB9pc/pfrg7GyFOpWKkncDJ3VHBGAWcrsuRsSeNoqUpoeLKUN92eDTUZm6J7Kf
         cTmA==
X-Gm-Message-State: AOAM5307+4e3DD5774vMtnbLypiCCEHs984twj+xNmqBNNKXivEDzce2
        YH302QJBdTHNkhm0idIA6zAOYcwBZT0MSWKYpwTBljK2
X-Google-Smtp-Source: ABdhPJzIbt4VJettkwnUDneguXkbVSiuGthZKnHiDt45sD/JgPNzlHiNZuzRQl4JDub5/UBOPKgP0jPA/dtGz/sJaFk=
X-Received: by 2002:a17:907:3ea0:: with SMTP id hs32mr652096ejc.411.1617754677376;
 Tue, 06 Apr 2021 17:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
 <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org> <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
 <2b758812-f00b-9465-c24e-763912748809@samba.org> <CAKYAXd_p1MrB2G25_p52OfppfSUcEWQEVxgJbBikAe3GZrJFhw@mail.gmail.com>
 <46e67316-58f3-435d-458c-11968499d4ee@talpey.com>
In-Reply-To: <46e67316-58f3-435d-458c-11968499d4ee@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 7 Apr 2021 10:17:45 +1000
Message-ID: <CAN05THQuMFiPpLVZ_j1UZVohitUPj59EOKT0qyscfV6dh4fBUw@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Colin King <colin.king@canonical.com>,
        Muhammad Usama Anjum <musamaanjum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 2, 2021 at 7:04 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 4/1/2021 9:36 AM, Namjae Jeon wrote:
> > 2021-04-01 22:14 GMT+09:00, Ralph Boehme <slow@samba.org>:
> >> Am 4/1/21 um 2:59 PM schrieb Namjae Jeon:
> >>> 2021-04-01 21:50 GMT+09:00, Ralph Boehme <slow@samba.org>:
> >>>> fwiw, while at it what about renaming everything that still references
> >>>> "cifs" to "smb" ? This is not the 90's... :)
> >>> It is also used with the name "ksmbd". So function and variable prefix
> >>> are used with ksmbd.
> >>
> >> well, I was thinking of this:
> >>
> >>   > +++ b/fs/cifsd/...
> >>
> >> We should really stop using the name cifs for modern implementation of
> >> SMB{23} and the code should not be added as fs/cifsd/ to the kernel.
> > As I know, currently "cifs" is being used for the subdirectory name
> > for historical reasons and to avoid confusions, even though the CIFS
> > (SMB1) dialect is no longer recommended.
>
> I'm with Ralph. CIFS is history that we need to relegate to the past.

Tom, and Ralph.
Some background on the cifsd directory name:

We discussed in length but we decided with cifsd to align with the
current directory name cifs for the client.
Just to align with current praxis defined by other filesystems, i.e.
nfs. which has nfs for client, nfsd for server
and nfs_common for shared cod and definitions.

Once cifsd lands in the kernel I expect we will start building
cifs_common for this purpose.

An alternative would have been to rename the current fs/cifs tree to
fs/ksmb but renaming an entire directory tree
felt it might get pushback.
In the end we thought that the module name, that is user visible and
there it is important we call it smb3 something
but the source tree is not end-user visible so it was less important
what the name was.

(the alternative ending up with   fs/cifs  fs/ksmbd and fs/cifs_common
would have been terrible)

regards
ronnie sahlberg

>
> I also agree that wrappers around core memory allocators are to
> be avoided.
>
> Tom.
