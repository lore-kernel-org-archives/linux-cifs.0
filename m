Return-Path: <SRS0=o4Eu=CJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178B6C433E6
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Aug 2020 21:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D47E120639
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Aug 2020 21:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQUXLHNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgHaVZa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 Aug 2020 17:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbgHaVZ3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 Aug 2020 17:25:29 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB9AC061573
        for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2020 14:25:29 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h126so2718088ybg.4
        for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2020 14:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKLiq8pwdfzYFYzAZOp+0zGJQ7y1h3xV6pw66AyeN0c=;
        b=VQUXLHNeIQbZ4Itt/ePFTDYR5t+C/V7GfBnsqFyH5UYYKJYrNFQKeJs4VIYz/NVyHO
         nK/RHoBiThy8G9fWpI5K1hV8pHMTKrW7UYi9q2Hryo3PKUDAqvebFs10Re9U6Excybkw
         X4kDUC7/xohczhZaYyQqrvhAMH+j3OwRRBT+itm84FR2gBMK+GHDTNlO/u5F/ehCaQuj
         jdO7ICNw4dSl0W0FF9WGBc2barVfXu4NY+PoUbcvjbKD3uRFgM7/WUpoIqWTYL8JyfLy
         nda5D/+g6v+9A4lpjt9RyCndTK+OoALIZz5S6Sy24Aoh7Hd2FKeiyZkZTKCpFKh00UMh
         GWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKLiq8pwdfzYFYzAZOp+0zGJQ7y1h3xV6pw66AyeN0c=;
        b=Qyk5BcyDwvbIbclnPISh8ZeS1o75TEP//rDhJ50ey5Izs+Dn31ljvYNpzRzd8QXH/V
         W4JNG7FSWVs7raLirIwXe+K1bwHEQRSxG8LzJxwfQgR4HSVTpfYim1AQzmhjqVZuDsaV
         vYgYpNuJ+c1pZ3tvYdJo66nSJLyJtJ3AGm5cNfYQixFC7To7xoaaQMsw+Pwr1+ioFfOz
         Sg/1okl/EhSTjWJvzzVgLpJNj+ZsHi/mgxZDuAUHU+IqSaSHOhWS3h+23Jb/VIhGsFjE
         X+TzYGAtdoKC4RE6l97r4pNMaYp69jQiMtbT/8sUTkaxoMJjOCEyWjmbs6HVyZuIwKCr
         Ljcg==
X-Gm-Message-State: AOAM531d2Xyj7WnC8Gqk/gMeOPAA5ko2ryhXzlUBnqLJbEv/qW1hyYfn
        +XbtxycLpcM+Ayl+agpYzNxvtSKhAReluQVrTtw=
X-Google-Smtp-Source: ABdhPJxabzKtS7BBeevruLVUVs7L8IDA58eedOMA8gvDbdx5QRbjN8cjJ0KXcb4yt9NNEeQs3ct3S7sNhkimjL/55NM=
X-Received: by 2002:a25:c606:: with SMTP id k6mr5135059ybf.183.1598909128009;
 Mon, 31 Aug 2020 14:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com> <CAH2r5mvU_E7HeLVkG7dCcjE-wF0X9bQa9245jAx0J0dJ9eJy+g@mail.gmail.com>
 <7c316665-63c7-4dab-1ec0-49be379d97a1@talpey.com>
In-Reply-To: <7c316665-63c7-4dab-1ec0-49be379d97a1@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 31 Aug 2020 16:25:16 -0500
Message-ID: <CAH2r5mvzuBAQy=HeBnwg5TeJTKjVuXxw1HLktmRYiUr=wN+EvQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
To:     Tom Talpey <tom@talpey.com>
Cc:     Jonathan Adams <jwadams@google.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> the client never sends oplock breaks, that's the server's domain.

The oplock break counters are valid. Oplock breaks are responded to by
the client and the server responds to the client ... so the counters
for oplock breaks are updated by 1 for every oplock break. I just did
an experiment to prove that - the counters match what I see in
wireshark (see below example from /proc/fs/cifs/Stats after opening an
oplocked file from a different client)

2) \\localhost\test
SMBs: 33
Bytes read: 0  Bytes written: 0
Open files: 1 total (local), 1 open on server
TreeConnects: 2 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 9 total 0 failed
Closes: 8 total 0 failed
Flushes: 1 total 0 failed
Reads: 0 total 0 failed
Writes: 0 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 1 total 1 failed
QueryDirectories: 0 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 10 total 0 failed
SetInfos: 2 total 0 failed
OplockBreaks: 1 sent 0 failed

> These seem to be raw protocol operation counts, and I'm guessing they
are system-wide. A more workload-oriented sample might seem more useful,
with per-session operations,

They are per session/per-share, and can be reset just before running a
workload ("echo 0 > /proc/fs/cifs/Stats")

> traffic patterns (including latencies)
If CONFIG_PROC_FS_CIFS_STATS2 is enabled then we track the total time
by SMB3 protocol operation (and the slowest and fastest of each
operation as well) and the number of "slow" operations (defaults to 1
seconds as meaning "slow" but it can be increased via a module
parameter).  I have been a little hesitant to enable that though in
case it affects performance (tracking the response times) but it may
be minimal enough that we should enable that by default.   Any
thoughts?


On Sun, Aug 30, 2020 at 7:25 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 8/30/2020 3:51 PM, Steve French wrote:
> > Could this be useful for network file systems (e.g. cifs.ko)? Here are
> > example stats kept for SMB3 mounts (there are additional stats that
> > can be enabled in the build for "slow" responses and average response
> > time on network requests).
> >
> > $ cat /proc/fs/cifs/Stats
> > Resources in use
> > CIFS Session: 1
> > Share (unique mount targets): 2
> > SMB Request/Response Buffer: 1 Pool size: 5
> > SMB Small Req/Resp Buffer: 1 Pool size: 30
> > Operations (MIDs): 0
> >
> > 0 session 0 share reconnects
> > Total vfs operations: 54 maximum at one time: 2
> >
> > Max requests in flight: 3
> > 1) \\localhost\test
> > SMBs: 105
> > Bytes read: 165675008  Bytes written: 5
> > Open files: 0 total (local), 0 open on server
> > TreeConnects: 1 total 0 failed
> > TreeDisconnects: 0 total 0 failed
> > Creates: 18 total 0 failed
> > Closes: 19 total 1 failed
> > Flushes: 1 total 0 failed
> > Reads: 42 total 0 failed
> > Writes: 1 total 0 failed
> > Locks: 0 total 0 failed
> > IOCTLs: 1 total 1 failed
> > QueryDirectories: 4 total 0 failed
> > ChangeNotifies: 0 total 0 failed
> > QueryInfos: 16 total 0 failed
> > SetInfos: 2 total 0 failed
> > OplockBreaks: 0 sent 0 failed
>
> Err, the client never sends oplock breaks, that's the server's domain.
>
> These seem to be raw protocol operation counts, and I'm guessing they
> are system-wide. A more workload-oriented sample might seem more useful,
> with per-session operations, traffic patterns (including latencies),
> etc. Possible?
>
> Tom.
>
> > On Fri, Aug 7, 2020 at 4:32 PM Jonathan Adams <jwadams@google.com> wrote:
> >>
> >> [resending to widen the CC lists per rdunlap@infradead.org's suggestion
> >> original posting to lkml here: https://lkml.org/lkml/2020/8/5/1009]
> >>
> >> To try to restart the discussion of kernel statistics started by the
> >> statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
> >> to share the following set of patches which are Google's 'metricfs'
> >> implementation and some example uses.  Google has been using metricfs
> >> internally since 2012 as a way to export various statistics to our
> >> telemetry systems (similar to OpenTelemetry), and we have over 200
> >> statistics exported on a typical machine.
> >>
> >> These patches have been cleaned up and modernized v.s. the versions
> >> in production; I've included notes under the fold in the patches.
> >> They're based on v5.8-rc6.
> >>
> >> The statistics live under debugfs, in a tree rooted at:
> >>
> >>          /sys/kernel/debug/metricfs
> >>
> >> Each metric is a directory, with four files in it.  For example, the '
> >> core/metricfs: Create metricfs, standardized files under debugfs.' patch
> >> includes a simple 'metricfs_presence' metric, whose files look like:
> >> /sys/kernel/debug/metricfs:
> >>   metricfs_presence/annotations
> >>    DESCRIPTION A\ basic\ presence\ metric.
> >>   metricfs_presence/fields
> >>    value
> >>    int
> >>   metricfs_presence/values
> >>    1
> >>   metricfs_presence/version
> >>    1
> >>
> >> (The "version" field always says '1', and is kind of vestigial)
> >>
> >> An example of a more complicated stat is the networking stats.
> >> For example, the tx_bytes stat looks like:
> >>
> >> net/dev/stats/tx_bytes/annotations
> >>    DESCRIPTION net\ device\ transmited\ bytes\ count
> >>    CUMULATIVE
> >> net/dev/stats/tx_bytes/fields
> >>    interface value
> >>    str int
> >> net/dev/stats/tx_bytes/values
> >>    lo 4394430608
> >>    eth0 33353183843
> >>    eth1 16228847091
> >> net/dev/stats/tx_bytes/version
> >>    1
> >>
> >> The per-cpu statistics show up in the schedulat stat info and x86
> >> IRQ counts.  For example:
> >>
> >> stat/user/annotations
> >>    DESCRIPTION time\ in\ user\ mode\ (nsec)
> >>    CUMULATIVE
> >> stat/user/fields
> >>    cpu value
> >>    int int
> >> stat/user/values
> >>    0 1183486517734
> >>    1 1038284237228
> >>    ...
> >> stat/user/version
> >>    1
> >>
> >> The full set of example metrics I've included are:
> >>
> >> core/metricfs: Create metricfs, standardized files under debugfs.
> >>    metricfs_presence
> >> core/metricfs: metric for kernel warnings
> >>    warnings/values
> >> core/metricfs: expose scheduler stat information through metricfs
> >>    stat/*
> >> net-metricfs: Export /proc/net/dev via metricfs.
> >>    net/dev/stats/[tr]x_*
> >> core/metricfs: expose x86-specific irq information through metricfs
> >>    irq_x86/*
> >>
> >> The general approach is called out in kernel/metricfs.c:
> >>
> >> The kernel provides:
> >>    - A description of the metric
> >>    - The subsystem for the metric (NULL is ok)
> >>    - Type information about the metric, and
> >>    - A callback function which supplies metric values.
> >>
> >> Limitations:
> >>    - "values" files are at MOST 64K. We truncate the file at that point.
> >>    - The list of fields and types is at most 1K.
> >>    - Metrics may have at most 2 fields.
> >>
> >> Best Practices:
> >>    - Emit the most important data first! Once the 64K per-metric buffer
> >>      is full, the emit* functions won't do anything.
> >>    - In userspace, open(), read(), and close() the file quickly! The kernel
> >>      allocation for the metric is alive as long as the file is open. This
> >>      permits users to seek around the contents of the file, while
> >>      permitting an atomic view of the data.
> >>
> >> Note that since the callbacks are called and the data is generated at
> >> file open() time, the relative consistency is only between members of
> >> a given metric; the rx_bytes stat for every network interface will
> >> be read at almost the same time, but if you want to get rx_bytes
> >> and rx_packets, there could be a bunch of slew between the two file
> >> opens.  (So this doesn't entirely address Andrew Lunn's comments in
> >> https://lkml.org/lkml/2020/5/26/490)
> >>
> >> This also doesn't address one of the basic parts of the statsfs work:
> >> moving the statistics out of debugfs to avoid lockdown interactions.
> >>
> >> Google has found a lot of value in having a generic interface for adding
> >> these kinds of statistics with reasonably low overhead (reading them
> >> is O(number of statistics), not number of objects in each statistic).
> >> There are definitely warts in the interface, but does the basic approach
> >> make sense to folks?
> >>
> >> Thanks,
> >> - Jonathan
> >>
> >> Jonathan Adams (5):
> >>    core/metricfs: add support for percpu metricfs files
> >>    core/metricfs: metric for kernel warnings
> >>    core/metricfs: expose softirq information through metricfs
> >>    core/metricfs: expose scheduler stat information through metricfs
> >>    core/metricfs: expose x86-specific irq information through metricfs
> >>
> >> Justin TerAvest (1):
> >>    core/metricfs: Create metricfs, standardized files under debugfs.
> >>
> >> Laurent Chavey (1):
> >>    net-metricfs: Export /proc/net/dev via metricfs.
> >>
> >>   arch/x86/kernel/irq.c      |  80 ++++
> >>   fs/proc/stat.c             |  57 +++
> >>   include/linux/metricfs.h   | 131 +++++++
> >>   kernel/Makefile            |   2 +
> >>   kernel/metricfs.c          | 775 +++++++++++++++++++++++++++++++++++++
> >>   kernel/metricfs_examples.c | 151 ++++++++
> >>   kernel/panic.c             | 131 +++++++
> >>   kernel/softirq.c           |  45 +++
> >>   lib/Kconfig.debug          |  18 +
> >>   net/core/Makefile          |   1 +
> >>   net/core/net_metricfs.c    | 194 ++++++++++
> >>   11 files changed, 1585 insertions(+)
> >>   create mode 100644 include/linux/metricfs.h
> >>   create mode 100644 kernel/metricfs.c
> >>   create mode 100644 kernel/metricfs_examples.c
> >>   create mode 100644 net/core/net_metricfs.c
> >>
> >> --
> >> 2.28.0.236.gb10cc79966-goog
> >>
> >
> >



--
Thanks,

Steve
