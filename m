Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96218C25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 01:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiHLBUs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHLBUr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 21:20:47 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326842AF4
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:20:46 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id w129so9794727vkg.10
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 18:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=gYw50UwQMoE5499vpOjy276gNcdOnwNir7q6PCZzlNI=;
        b=PQL93Fr71W7ae63QPJxBxCm/gDK7B5ZyeTZxGVBo2yHtSKdVdL+vzv896VOrpC8ZUw
         FX2/Yrg1OX0kVG2rTufvV7ZTLTOc9p2R2PK9tVbE4YHWPx0Y+6wlTqOSWiOHanQD6bKB
         oaNO8zKKwQNFXvLOWZdgAp/urusSDFZIYLXOtF52UDHnGWODIb57uSUngf0s7oLVyeGI
         /SygqtCridUZP0rxdZGrafc7ocGzFboOO3okaDTBpP3Ya0Q840s3wKkM/coFdCWKDKWD
         0YDBzlaeKgIuvfdeuRdDFDgCHCik1WB+VEb8B0AlxFF0vGcmwODw0BJRuq3eDghJHEik
         jMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=gYw50UwQMoE5499vpOjy276gNcdOnwNir7q6PCZzlNI=;
        b=z37vhvoNnhDCbPf9EFn6PsnWRX8M90cfXOqxwZGdSJ7x/5rgtUveO1WabM/diElUPu
         CDhW142WcA3yJr64KUxli3IdHc2NggaTLzFaIkz2wW3E3z3AvsxT3jruZ6h31TKhhpn2
         7d07CIgGdYio1erLfaSgK/ceIPCp/nJ095nh9mWkR2e8vhlQhdHBiiiZg0KHLmqrk/Or
         bkOGCF9yqVu16TD04EW1iuQYJB5/z7jXzTv5IC6sa+tIKvI0ChEZPqS0SJycCK6LmvpB
         nmjc8HubQB771rmcn40N1AxAos7wpP6XtRl/LYiYFIwkoS0y+PMW+sZNhhQWMzpQTnC9
         j0iQ==
X-Gm-Message-State: ACgBeo3qQ6G7yEnHbiNqdr791Rbupz/5odi3yM6V9eeLkJ7fS/8Cph4J
        yfLOEe8PYsYcvEqdkC24sYnbP0U8PfL9d3B7ces=
X-Google-Smtp-Source: AA6agR6caEJsbpJX28PRahsCXV1t0LbFj5mxWKOZStpTWjU/qLLTPG6VoJrRCJgAXXMuYluY5FzzicLNpqzUSfUwdxw=
X-Received: by 2002:ac5:cdd4:0:b0:377:2e13:3512 with SMTP id
 u20-20020ac5cdd4000000b003772e133512mr858879vkn.3.1660267245112; Thu, 11 Aug
 2022 18:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
 <87zggasr6o.fsf@cjr.nz> <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
 <87wnbesql0.fsf@cjr.nz> <CAH2r5muf+h+tdR6k3wgyhY52hz9BUSBCs1hzC1V434ddt0ovxw@mail.gmail.com>
 <CAN05THSv+7C2J9yv2Ph0_KApS5wucE-GwPLzihQ+zU_68ceq2g@mail.gmail.com>
In-Reply-To: <CAN05THSv+7C2J9yv2Ph0_KApS5wucE-GwPLzihQ+zU_68ceq2g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 20:20:34 -0500
Message-ID: <CAH2r5mvppBm7Of8M5YjLkxQQXnxEizGttLne-n2TQdvuhr-ULw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] allow deferred close timeout to be configurable
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Bharath S M <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am planning to document this (one reason I made the mount option
name a bit shorter, and tried to make the defaults a bit more
intuitive)

We have workloads where we need this (e.g. cases where they want to
read cache files more aggressively, but safely - but the app closes
the file)

My main short term issue is how to separate it from actimeo which is
unrelated (and somewhat unsafe).

I do plan to update the man page for mount.cifs, but we definitely
need to be able to configure this.  Remember we recently had a bug
where it would have helped investigate it.

The main example I can think of is apps that do:

open/read/close, open/read/close, repeatedly with other clients
occasionally reading or writing the file.   Currently we only cache
the file for 1 second after close. Windows for longer.  Our goal is to
allow this as a performance tuning recommendation for advanced users
until we can pick an optimum value (probably pretty long).

I am fine with documenting this.   My intent was to document it
similar to the following:
- indicate it is an advanced tuning parameter, and its default is fine for many
- indicate that if your apps open many, many files, you may want to
consider setting it smaller if your server is resource constrained, to
put less load on your server (especially if your apps do not
repeatedly reopen the same files over and over)
- indicate that if you have a workload where you want to cache files
for long periods safely, and these files are only occasionally
accessed by other clients, then consider setting it longer.  We have
some example workloads that we were asked about this e.g.


On Thu, Aug 11, 2022 at 8:10 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, 12 Aug 2022 at 03:17, Steve French <smfrench@gmail.com> wrote:
> >
> > The "jiffies vs. seconds" in comment was the only suggestion I didn't include.
> > See updated patch v2 (attached), I made minor updates.  Added the
> > Suggested-by from Bharath. Moved the defines for default/max to
> > different name with SMB3 (and in fs_context.h) since it is an smb3
> > feature (so not confused with cifs).  I increased the default to 5
> > seconds (although that is still lower than some other clients - it
> > should help perf.  As you suggested, unconditionally print the value
> > used on the mount.
> > for some workloads).
>
> nack.
> The problem with this is that it is a mount option that is impossible
> for a sys admin to set correctly.
>
> If we need this as a mount option we need documentation on it too.
>
> 1, How does a sys admin determine that there is an issue and that
> changing this value will  fix it?
> 2, How does a sys admin determine what to set it to?
>
> To me it seems this is an option that can only be used by developers
> and thus it should not be
> a mount option. We have too many ad-hoc mount options that end users
> can not use correctly as it is.
>
>
> >
> > On Thu, Aug 11, 2022 at 11:16 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > Steve French <smfrench@gmail.com> writes:
> > >
> > > > Will fix the typos thanks.
> > >
> > > Thanks.
> > >
> > > > There are a couple of minor differences from Bharath's earlier patch e.g.
> > > >
> > > > "closetimeo" rather than "dclosetimeo" (I am ok if you prefer the longer name),
> > > > and also this mount option is printed in list of mount options if set.
> > >
> > > Both look good to me.  I personally don't care much about naming,
> > > though.
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
