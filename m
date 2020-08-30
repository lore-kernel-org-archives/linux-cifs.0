Return-Path: <SRS0=79/A=CI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9098C433E2
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Aug 2020 19:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B35620757
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Aug 2020 19:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVSSIIFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgH3TwA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Aug 2020 15:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgH3Tvz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Aug 2020 15:51:55 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DB4C061573
        for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2020 12:51:54 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x10so2802480ybj.13
        for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2020 12:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKrvHff2L8n1OdedvE2l5H0mUdq82XWGV6ttMOS8gQ0=;
        b=RVSSIIFc8Fj+rBMDS9d/Ya2jTnHAaV8vnoUsUI8q2ybKqip4saXTeb/KxMgEuwIA5y
         up4SCYw/T8pY5lI81TVI6IoEO1mh0H0dEWSCOp4v5leboxuPhVX8je78BTYwFqpipdpU
         kF+4Hk8zwTGj0Xzpkbl7kHK4gikPmMW+3ofzRm4XO8ER4p2i8NO287dofM9d4bppLGWp
         7eah9Eo59kpV1LIe0YpnN34XPomToF7LFNRToZ0kDXJicCQm/HD5szGsjXEy0uDuBeXu
         gzmi1GCOh6eEhLXylVMyj144h0Z8N7ghPlwu4q1h9+W1/I8jvty833mJVRmqXLhD4wUD
         YIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKrvHff2L8n1OdedvE2l5H0mUdq82XWGV6ttMOS8gQ0=;
        b=Jc0LE7crQ4jxSImNE+A/FUrd+Xf1HpjEq0Ngxjy3lz6L+BGWvO8s0w/pPP2zOi7f2A
         p7kliZOxbfldp1YhxBON7rlz863cfzCjFYmpkcaCJNzvo+B0QV/k8aoj8gE4B3usrBrm
         nXVtZ35rZGuOO2/76f9RV3YqY2T8Dagf5HxQvwwo8uwfqgh5uPGuQ6ZzANWjFj94X7uS
         388QrTIuhMVfT11juYax/BU+g7Q2SM4u+GMO3jPui416O5PfAb8YbTI+zKNKJcxy43NX
         EKWE5RpsgLV7myrESbq7CPqTtLRgcrOEoCfOoVKAO9GJr4lTh07p+aL7wtYrKmzUSe71
         ymCw==
X-Gm-Message-State: AOAM5314vVGParIr44uzaFTgJDAnFPD/p0h2gasWXqWf2upN6vc2b9vd
        HvdpaSh/JFglRun7FBLndtRGf6m7eGFK8cGtEg6Qv+Huz+ZjbQ==
X-Google-Smtp-Source: ABdhPJygMA6Bz1KYISnX+gd+RommQTIfbjpknwO8pTBqdaYNH2BYDvL3Lcj5zQ4a1+qfwkA3pNXmswOKJNceU3I/esM=
X-Received: by 2002:a25:1943:: with SMTP id 64mr15431430ybz.14.1598817112417;
 Sun, 30 Aug 2020 12:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com>
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 30 Aug 2020 14:51:41 -0500
Message-ID: <CAH2r5mvU_E7HeLVkG7dCcjE-wF0X9bQa9245jAx0J0dJ9eJy+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
To:     Jonathan Adams <jwadams@google.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Could this be useful for network file systems (e.g. cifs.ko)? Here are
example stats kept for SMB3 mounts (there are additional stats that
can be enabled in the build for "slow" responses and average response
time on network requests).

$ cat /proc/fs/cifs/Stats
Resources in use
CIFS Session: 1
Share (unique mount targets): 2
SMB Request/Response Buffer: 1 Pool size: 5
SMB Small Req/Resp Buffer: 1 Pool size: 30
Operations (MIDs): 0

0 session 0 share reconnects
Total vfs operations: 54 maximum at one time: 2

Max requests in flight: 3
1) \\localhost\test
SMBs: 105
Bytes read: 165675008  Bytes written: 5
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 18 total 0 failed
Closes: 19 total 1 failed
Flushes: 1 total 0 failed
Reads: 42 total 0 failed
Writes: 1 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 1 total 1 failed
QueryDirectories: 4 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 16 total 0 failed
SetInfos: 2 total 0 failed
OplockBreaks: 0 sent 0 failed


On Fri, Aug 7, 2020 at 4:32 PM Jonathan Adams <jwadams@google.com> wrote:
>
> [resending to widen the CC lists per rdunlap@infradead.org's suggestion
> original posting to lkml here: https://lkml.org/lkml/2020/8/5/1009]
>
> To try to restart the discussion of kernel statistics started by the
> statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
> to share the following set of patches which are Google's 'metricfs'
> implementation and some example uses.  Google has been using metricfs
> internally since 2012 as a way to export various statistics to our
> telemetry systems (similar to OpenTelemetry), and we have over 200
> statistics exported on a typical machine.
>
> These patches have been cleaned up and modernized v.s. the versions
> in production; I've included notes under the fold in the patches.
> They're based on v5.8-rc6.
>
> The statistics live under debugfs, in a tree rooted at:
>
>         /sys/kernel/debug/metricfs
>
> Each metric is a directory, with four files in it.  For example, the '
> core/metricfs: Create metricfs, standardized files under debugfs.' patch
> includes a simple 'metricfs_presence' metric, whose files look like:
> /sys/kernel/debug/metricfs:
>  metricfs_presence/annotations
>   DESCRIPTION A\ basic\ presence\ metric.
>  metricfs_presence/fields
>   value
>   int
>  metricfs_presence/values
>   1
>  metricfs_presence/version
>   1
>
> (The "version" field always says '1', and is kind of vestigial)
>
> An example of a more complicated stat is the networking stats.
> For example, the tx_bytes stat looks like:
>
> net/dev/stats/tx_bytes/annotations
>   DESCRIPTION net\ device\ transmited\ bytes\ count
>   CUMULATIVE
> net/dev/stats/tx_bytes/fields
>   interface value
>   str int
> net/dev/stats/tx_bytes/values
>   lo 4394430608
>   eth0 33353183843
>   eth1 16228847091
> net/dev/stats/tx_bytes/version
>   1
>
> The per-cpu statistics show up in the schedulat stat info and x86
> IRQ counts.  For example:
>
> stat/user/annotations
>   DESCRIPTION time\ in\ user\ mode\ (nsec)
>   CUMULATIVE
> stat/user/fields
>   cpu value
>   int int
> stat/user/values
>   0 1183486517734
>   1 1038284237228
>   ...
> stat/user/version
>   1
>
> The full set of example metrics I've included are:
>
> core/metricfs: Create metricfs, standardized files under debugfs.
>   metricfs_presence
> core/metricfs: metric for kernel warnings
>   warnings/values
> core/metricfs: expose scheduler stat information through metricfs
>   stat/*
> net-metricfs: Export /proc/net/dev via metricfs.
>   net/dev/stats/[tr]x_*
> core/metricfs: expose x86-specific irq information through metricfs
>   irq_x86/*
>
> The general approach is called out in kernel/metricfs.c:
>
> The kernel provides:
>   - A description of the metric
>   - The subsystem for the metric (NULL is ok)
>   - Type information about the metric, and
>   - A callback function which supplies metric values.
>
> Limitations:
>   - "values" files are at MOST 64K. We truncate the file at that point.
>   - The list of fields and types is at most 1K.
>   - Metrics may have at most 2 fields.
>
> Best Practices:
>   - Emit the most important data first! Once the 64K per-metric buffer
>     is full, the emit* functions won't do anything.
>   - In userspace, open(), read(), and close() the file quickly! The kernel
>     allocation for the metric is alive as long as the file is open. This
>     permits users to seek around the contents of the file, while
>     permitting an atomic view of the data.
>
> Note that since the callbacks are called and the data is generated at
> file open() time, the relative consistency is only between members of
> a given metric; the rx_bytes stat for every network interface will
> be read at almost the same time, but if you want to get rx_bytes
> and rx_packets, there could be a bunch of slew between the two file
> opens.  (So this doesn't entirely address Andrew Lunn's comments in
> https://lkml.org/lkml/2020/5/26/490)
>
> This also doesn't address one of the basic parts of the statsfs work:
> moving the statistics out of debugfs to avoid lockdown interactions.
>
> Google has found a lot of value in having a generic interface for adding
> these kinds of statistics with reasonably low overhead (reading them
> is O(number of statistics), not number of objects in each statistic).
> There are definitely warts in the interface, but does the basic approach
> make sense to folks?
>
> Thanks,
> - Jonathan
>
> Jonathan Adams (5):
>   core/metricfs: add support for percpu metricfs files
>   core/metricfs: metric for kernel warnings
>   core/metricfs: expose softirq information through metricfs
>   core/metricfs: expose scheduler stat information through metricfs
>   core/metricfs: expose x86-specific irq information through metricfs
>
> Justin TerAvest (1):
>   core/metricfs: Create metricfs, standardized files under debugfs.
>
> Laurent Chavey (1):
>   net-metricfs: Export /proc/net/dev via metricfs.
>
>  arch/x86/kernel/irq.c      |  80 ++++
>  fs/proc/stat.c             |  57 +++
>  include/linux/metricfs.h   | 131 +++++++
>  kernel/Makefile            |   2 +
>  kernel/metricfs.c          | 775 +++++++++++++++++++++++++++++++++++++
>  kernel/metricfs_examples.c | 151 ++++++++
>  kernel/panic.c             | 131 +++++++
>  kernel/softirq.c           |  45 +++
>  lib/Kconfig.debug          |  18 +
>  net/core/Makefile          |   1 +
>  net/core/net_metricfs.c    | 194 ++++++++++
>  11 files changed, 1585 insertions(+)
>  create mode 100644 include/linux/metricfs.h
>  create mode 100644 kernel/metricfs.c
>  create mode 100644 kernel/metricfs_examples.c
>  create mode 100644 net/core/net_metricfs.c
>
> --
> 2.28.0.236.gb10cc79966-goog
>


-- 
Thanks,

Steve
