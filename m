Return-Path: <SRS0=o4Eu=CJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36283C433E6
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Aug 2020 00:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120812074B
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Aug 2020 00:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgHaAcn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Aug 2020 20:32:43 -0400
Received: from p3plsmtpa08-01.prod.phx3.secureserver.net ([173.201.193.102]:48686
        "EHLO p3plsmtpa08-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgHaAcm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 30 Aug 2020 20:32:42 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2020 20:32:42 EDT
Received: from [192.168.0.78] ([98.118.115.125])
        by :SMTPAUTH: with ESMTPSA
        id CXdTktNrVTuqWCXdTk4WcY; Sun, 30 Aug 2020 17:25:24 -0700
X-CMAE-Analysis: v=2.3 cv=cdSsUULM c=1 sm=1 tr=0
 a=gUzUqk5j/8HUPp45KC7Luw==:117 a=gUzUqk5j/8HUPp45KC7Luw==:17
 a=IkcTkHD0fZMA:10 a=1XWaLZrsAAAA:8 a=JfrnYn6hAAAA:8 a=D19gQVrFAAAA:8
 a=tY64fZGVlKu3wDFqGpMA:9 a=BPIBa7cgWuqYiAVi:21 a=V7w-8Uc7ws0wHuf9:21
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=W4TVW4IDbPiebHqcZpNg:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
To:     Steve French <smfrench@gmail.com>,
        Jonathan Adams <jwadams@google.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <20200807212916.2883031-1-jwadams@google.com>
 <CAH2r5mvU_E7HeLVkG7dCcjE-wF0X9bQa9245jAx0J0dJ9eJy+g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <7c316665-63c7-4dab-1ec0-49be379d97a1@talpey.com>
Date:   Sun, 30 Aug 2020 20:25:23 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvU_E7HeLVkG7dCcjE-wF0X9bQa9245jAx0J0dJ9eJy+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAnY0Llt5234OJaZTDUE0X8iOKe4xG2KenVlhunPh5WLop3Tlcg3ofDlRC4DH16j61yQyU2Fmjl98W1zlapwb5qOvzLezw4LWLetV0l/uj3/KZCzzeWX
 vLIxvw2o4O3cgqsT2mUf3Y31MdfTXodlzbmy0zhIO91z+E00tTmv8J6FB95rQjauI/QsInkdSr+4JBTE8L8Gm93T3SZ8pu1zwWnOioI/yeCkA3VcaL2xi7qf
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/30/2020 3:51 PM, Steve French wrote:
> Could this be useful for network file systems (e.g. cifs.ko)? Here are
> example stats kept for SMB3 mounts (there are additional stats that
> can be enabled in the build for "slow" responses and average response
> time on network requests).
> 
> $ cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 2
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Operations (MIDs): 0
> 
> 0 session 0 share reconnects
> Total vfs operations: 54 maximum at one time: 2
> 
> Max requests in flight: 3
> 1) \\localhost\test
> SMBs: 105
> Bytes read: 165675008  Bytes written: 5
> Open files: 0 total (local), 0 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 18 total 0 failed
> Closes: 19 total 1 failed
> Flushes: 1 total 0 failed
> Reads: 42 total 0 failed
> Writes: 1 total 0 failed
> Locks: 0 total 0 failed
> IOCTLs: 1 total 1 failed
> QueryDirectories: 4 total 0 failed
> ChangeNotifies: 0 total 0 failed
> QueryInfos: 16 total 0 failed
> SetInfos: 2 total 0 failed
> OplockBreaks: 0 sent 0 failed

Err, the client never sends oplock breaks, that's the server's domain.

These seem to be raw protocol operation counts, and I'm guessing they
are system-wide. A more workload-oriented sample might seem more useful,
with per-session operations, traffic patterns (including latencies),
etc. Possible?

Tom.

> On Fri, Aug 7, 2020 at 4:32 PM Jonathan Adams <jwadams@google.com> wrote:
>>
>> [resending to widen the CC lists per rdunlap@infradead.org's suggestion
>> original posting to lkml here: https://lkml.org/lkml/2020/8/5/1009]
>>
>> To try to restart the discussion of kernel statistics started by the
>> statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
>> to share the following set of patches which are Google's 'metricfs'
>> implementation and some example uses.  Google has been using metricfs
>> internally since 2012 as a way to export various statistics to our
>> telemetry systems (similar to OpenTelemetry), and we have over 200
>> statistics exported on a typical machine.
>>
>> These patches have been cleaned up and modernized v.s. the versions
>> in production; I've included notes under the fold in the patches.
>> They're based on v5.8-rc6.
>>
>> The statistics live under debugfs, in a tree rooted at:
>>
>>          /sys/kernel/debug/metricfs
>>
>> Each metric is a directory, with four files in it.  For example, the '
>> core/metricfs: Create metricfs, standardized files under debugfs.' patch
>> includes a simple 'metricfs_presence' metric, whose files look like:
>> /sys/kernel/debug/metricfs:
>>   metricfs_presence/annotations
>>    DESCRIPTION A\ basic\ presence\ metric.
>>   metricfs_presence/fields
>>    value
>>    int
>>   metricfs_presence/values
>>    1
>>   metricfs_presence/version
>>    1
>>
>> (The "version" field always says '1', and is kind of vestigial)
>>
>> An example of a more complicated stat is the networking stats.
>> For example, the tx_bytes stat looks like:
>>
>> net/dev/stats/tx_bytes/annotations
>>    DESCRIPTION net\ device\ transmited\ bytes\ count
>>    CUMULATIVE
>> net/dev/stats/tx_bytes/fields
>>    interface value
>>    str int
>> net/dev/stats/tx_bytes/values
>>    lo 4394430608
>>    eth0 33353183843
>>    eth1 16228847091
>> net/dev/stats/tx_bytes/version
>>    1
>>
>> The per-cpu statistics show up in the schedulat stat info and x86
>> IRQ counts.  For example:
>>
>> stat/user/annotations
>>    DESCRIPTION time\ in\ user\ mode\ (nsec)
>>    CUMULATIVE
>> stat/user/fields
>>    cpu value
>>    int int
>> stat/user/values
>>    0 1183486517734
>>    1 1038284237228
>>    ...
>> stat/user/version
>>    1
>>
>> The full set of example metrics I've included are:
>>
>> core/metricfs: Create metricfs, standardized files under debugfs.
>>    metricfs_presence
>> core/metricfs: metric for kernel warnings
>>    warnings/values
>> core/metricfs: expose scheduler stat information through metricfs
>>    stat/*
>> net-metricfs: Export /proc/net/dev via metricfs.
>>    net/dev/stats/[tr]x_*
>> core/metricfs: expose x86-specific irq information through metricfs
>>    irq_x86/*
>>
>> The general approach is called out in kernel/metricfs.c:
>>
>> The kernel provides:
>>    - A description of the metric
>>    - The subsystem for the metric (NULL is ok)
>>    - Type information about the metric, and
>>    - A callback function which supplies metric values.
>>
>> Limitations:
>>    - "values" files are at MOST 64K. We truncate the file at that point.
>>    - The list of fields and types is at most 1K.
>>    - Metrics may have at most 2 fields.
>>
>> Best Practices:
>>    - Emit the most important data first! Once the 64K per-metric buffer
>>      is full, the emit* functions won't do anything.
>>    - In userspace, open(), read(), and close() the file quickly! The kernel
>>      allocation for the metric is alive as long as the file is open. This
>>      permits users to seek around the contents of the file, while
>>      permitting an atomic view of the data.
>>
>> Note that since the callbacks are called and the data is generated at
>> file open() time, the relative consistency is only between members of
>> a given metric; the rx_bytes stat for every network interface will
>> be read at almost the same time, but if you want to get rx_bytes
>> and rx_packets, there could be a bunch of slew between the two file
>> opens.  (So this doesn't entirely address Andrew Lunn's comments in
>> https://lkml.org/lkml/2020/5/26/490)
>>
>> This also doesn't address one of the basic parts of the statsfs work:
>> moving the statistics out of debugfs to avoid lockdown interactions.
>>
>> Google has found a lot of value in having a generic interface for adding
>> these kinds of statistics with reasonably low overhead (reading them
>> is O(number of statistics), not number of objects in each statistic).
>> There are definitely warts in the interface, but does the basic approach
>> make sense to folks?
>>
>> Thanks,
>> - Jonathan
>>
>> Jonathan Adams (5):
>>    core/metricfs: add support for percpu metricfs files
>>    core/metricfs: metric for kernel warnings
>>    core/metricfs: expose softirq information through metricfs
>>    core/metricfs: expose scheduler stat information through metricfs
>>    core/metricfs: expose x86-specific irq information through metricfs
>>
>> Justin TerAvest (1):
>>    core/metricfs: Create metricfs, standardized files under debugfs.
>>
>> Laurent Chavey (1):
>>    net-metricfs: Export /proc/net/dev via metricfs.
>>
>>   arch/x86/kernel/irq.c      |  80 ++++
>>   fs/proc/stat.c             |  57 +++
>>   include/linux/metricfs.h   | 131 +++++++
>>   kernel/Makefile            |   2 +
>>   kernel/metricfs.c          | 775 +++++++++++++++++++++++++++++++++++++
>>   kernel/metricfs_examples.c | 151 ++++++++
>>   kernel/panic.c             | 131 +++++++
>>   kernel/softirq.c           |  45 +++
>>   lib/Kconfig.debug          |  18 +
>>   net/core/Makefile          |   1 +
>>   net/core/net_metricfs.c    | 194 ++++++++++
>>   11 files changed, 1585 insertions(+)
>>   create mode 100644 include/linux/metricfs.h
>>   create mode 100644 kernel/metricfs.c
>>   create mode 100644 kernel/metricfs_examples.c
>>   create mode 100644 net/core/net_metricfs.c
>>
>> --
>> 2.28.0.236.gb10cc79966-goog
>>
> 
> 
