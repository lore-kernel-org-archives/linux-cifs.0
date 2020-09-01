Return-Path: <SRS0=bFr5=CK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA18C433E2
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Sep 2020 14:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27CCB206FA
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Sep 2020 14:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hYffevxH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIAOhK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:37:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgIAOTd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Sep 2020 10:19:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081EA6ef176523;
        Tue, 1 Sep 2020 14:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=6eQYXN0OOy0HH/VaaQCVqQh9m4FJAb8NFh/V+sib/f4=;
 b=hYffevxH5U3AJX9J/mstwU/HFSseSMv8FNGnzcemw8UbGi8im0C6QbcyobplUEXV/QRa
 vuVTQGslxWa52qyGik/ACBcnAsveDtQNC08ZjGgQfNbWzJCR+Qyl30EUx4N4o/cbxW8k
 jOCL/ccd4be82iXtq/5nDw63z7Xfnw7WeBqU1T7EnW954326y1vTZy2A97SFIpJxhfCl
 e8dNnzpBZ4kj30CCwNcG54EQxjigHJcE+dQI3W+ncvrc/L4/QgcuANtIrbJ9FCXvYuRo
 jFtpjEskGq0lHiaHOVNKKjAVTMpt0Xr9WRoIIf3ynN3k3xvgqr04fDHmwBpokxIao2s2 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eym4jq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 14:19:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081EB1UD121439;
        Tue, 1 Sep 2020 14:17:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380srsred-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 14:17:23 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 081EHMPF018255;
        Tue, 1 Sep 2020 14:17:22 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 07:17:21 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <83e1b9e9-28e8-daf1-67ad-57cbffe19f6d@talpey.com>
Date:   Tue, 1 Sep 2020 10:17:21 -0400
Cc:     Steve French <smfrench@gmail.com>,
        Jonathan Adams <jwadams@google.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB6BE807-E94D-4384-BBFE-AD72741616C7@oracle.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <CAH2r5mvU_E7HeLVkG7dCcjE-wF0X9bQa9245jAx0J0dJ9eJy+g@mail.gmail.com>
 <7c316665-63c7-4dab-1ec0-49be379d97a1@talpey.com>
 <CAH2r5mvzuBAQy=HeBnwg5TeJTKjVuXxw1HLktmRYiUr=wN+EvQ@mail.gmail.com>
 <83e1b9e9-28e8-daf1-67ad-57cbffe19f6d@talpey.com>
To:     Tom Talpey <tom@talpey.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010119
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



> On Sep 1, 2020, at 9:04 AM, Tom Talpey <tom@talpey.com> wrote:
>=20
> On 8/31/2020 5:25 PM, Steve French wrote:
>>> the client never sends oplock breaks, that's the server's domain.
>> The oplock break counters are valid. Oplock breaks are responded to =
by
>> the client and the server responds to the client ... so the counters
>> for oplock breaks are updated by 1 for every oplock break. I just did
>> an experiment to prove that - the counters match what I see in
>> wireshark (see below example from /proc/fs/cifs/Stats after opening =
an
>> oplocked file from a different client)
>=20
> Ah, ok I guess I should have looked deeper. But, the Oplock Break from
> the client is a response, not a request like all the others. And I'm
> confused what a "fail" would mean, oplock break cannot fail.
>=20
> Either way, it seems out of place here, somehow. And I still don't see
> how a request count is particularly meaningful to anything. What is
> the goal of these metrics? What reads them?
>=20
>> 2) \\localhost\test
>> SMBs: 33
>> Bytes read: 0  Bytes written: 0
>> Open files: 1 total (local), 1 open on server
>> TreeConnects: 2 total 0 failed
>> TreeDisconnects: 0 total 0 failed
>> Creates: 9 total 0 failed
>> Closes: 8 total 0 failed
>> Flushes: 1 total 0 failed
>> Reads: 0 total 0 failed
>> Writes: 0 total 0 failed
>> Locks: 0 total 0 failed
>> IOCTLs: 1 total 1 failed
>> QueryDirectories: 0 total 0 failed
>> ChangeNotifies: 0 total 0 failed
>> QueryInfos: 10 total 0 failed
>> SetInfos: 2 total 0 failed
>> OplockBreaks: 1 sent 0 failed
>>> These seem to be raw protocol operation counts, and I'm guessing =
they
>> are system-wide. A more workload-oriented sample might seem more =
useful,
>> with per-session operations,
>> They are per session/per-share, and can be reset just before running =
a
>> workload ("echo 0 > /proc/fs/cifs/Stats")
>>> traffic patterns (including latencies)
>> If CONFIG_PROC_FS_CIFS_STATS2 is enabled then we track the total time
>> by SMB3 protocol operation (and the slowest and fastest of each
>> operation as well) and the number of "slow" operations (defaults to 1
>> seconds as meaning "slow" but it can be increased via a module
>> parameter).  I have been a little hesitant to enable that though in
>> case it affects performance (tracking the response times) but it may
>> be minimal enough that we should enable that by default.   Any
>> thoughts?

That sounds like you are hunting for outliers. The only issue is how
you select the threshold between "normal" and "outlier" -- there is
no good default setting for that, given the range of network fabrics
and backend storage technologies; and when the latency distribution
is more complicated than a normal bell curve, it's even more difficult.

Using a tracepoint that fires for outliers might be nicer than watching
a metrics file. NFS has a couple of tracepoints that report the latency
of each RPC, and these can be filtered based on the value of the latency
fields reported. They can also be used to build latency histograms and
for second-order analysis (waterfall, etc).

A module parameter is way too coarse. You at least want that setting
to be per-server, but better would be per-share, or even per-operation-
class. We expect WRITE and SETATTR to be slower than ACCESS or LOOKUP.


> You know me Steve, I am all about latency. :-) I would want to see
> those included. I'd also like to see when operations went async
> (STATUS_PENDING), and be able to build some sort of histogram to
> characterize the workload from the overall results.
>=20
> NFS has a facility (nfsiostat) very much like this, and it's quite =
good.
> Does this framework attempt to replace that?
>=20
> Adding Chuck Lever in case he has any input...

I'd add some deeper metrics (or tracepoints) for identifying issues with
connecting to servers. You could perhaps count the number of times the
server dropped the client's connection, for example. How long it took
to establish a connection, and so on.


> Tom.
>=20
>> On Sun, Aug 30, 2020 at 7:25 PM Tom Talpey <tom@talpey.com> wrote:
>>>=20
>>> On 8/30/2020 3:51 PM, Steve French wrote:
>>>> Could this be useful for network file systems (e.g. cifs.ko)? Here =
are
>>>> example stats kept for SMB3 mounts (there are additional stats that
>>>> can be enabled in the build for "slow" responses and average =
response
>>>> time on network requests).
>>>>=20
>>>> $ cat /proc/fs/cifs/Stats
>>>> Resources in use
>>>> CIFS Session: 1
>>>> Share (unique mount targets): 2
>>>> SMB Request/Response Buffer: 1 Pool size: 5
>>>> SMB Small Req/Resp Buffer: 1 Pool size: 30
>>>> Operations (MIDs): 0
>>>>=20
>>>> 0 session 0 share reconnects
>>>> Total vfs operations: 54 maximum at one time: 2
>>>>=20
>>>> Max requests in flight: 3
>>>> 1) \\localhost\test
>>>> SMBs: 105
>>>> Bytes read: 165675008  Bytes written: 5
>>>> Open files: 0 total (local), 0 open on server
>>>> TreeConnects: 1 total 0 failed
>>>> TreeDisconnects: 0 total 0 failed
>>>> Creates: 18 total 0 failed
>>>> Closes: 19 total 1 failed
>>>> Flushes: 1 total 0 failed
>>>> Reads: 42 total 0 failed
>>>> Writes: 1 total 0 failed
>>>> Locks: 0 total 0 failed
>>>> IOCTLs: 1 total 1 failed
>>>> QueryDirectories: 4 total 0 failed
>>>> ChangeNotifies: 0 total 0 failed
>>>> QueryInfos: 16 total 0 failed
>>>> SetInfos: 2 total 0 failed
>>>> OplockBreaks: 0 sent 0 failed
>>>=20
>>> Err, the client never sends oplock breaks, that's the server's =
domain.
>>>=20
>>> These seem to be raw protocol operation counts, and I'm guessing =
they
>>> are system-wide. A more workload-oriented sample might seem more =
useful,
>>> with per-session operations, traffic patterns (including latencies),
>>> etc. Possible?
>>>=20
>>> Tom.
>>>=20
>>>> On Fri, Aug 7, 2020 at 4:32 PM Jonathan Adams <jwadams@google.com> =
wrote:
>>>>>=20
>>>>> [resending to widen the CC lists per rdunlap@infradead.org's =
suggestion
>>>>> original posting to lkml here: =
https://lkml.org/lkml/2020/8/5/1009]
>>>>>=20
>>>>> To try to restart the discussion of kernel statistics started by =
the
>>>>> statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
>>>>> to share the following set of patches which are Google's =
'metricfs'
>>>>> implementation and some example uses.  Google has been using =
metricfs
>>>>> internally since 2012 as a way to export various statistics to our
>>>>> telemetry systems (similar to OpenTelemetry), and we have over 200
>>>>> statistics exported on a typical machine.
>>>>>=20
>>>>> These patches have been cleaned up and modernized v.s. the =
versions
>>>>> in production; I've included notes under the fold in the patches.
>>>>> They're based on v5.8-rc6.
>>>>>=20
>>>>> The statistics live under debugfs, in a tree rooted at:
>>>>>=20
>>>>>          /sys/kernel/debug/metricfs
>>>>>=20
>>>>> Each metric is a directory, with four files in it.  For example, =
the '
>>>>> core/metricfs: Create metricfs, standardized files under debugfs.' =
patch
>>>>> includes a simple 'metricfs_presence' metric, whose files look =
like:
>>>>> /sys/kernel/debug/metricfs:
>>>>>   metricfs_presence/annotations
>>>>>    DESCRIPTION A\ basic\ presence\ metric.
>>>>>   metricfs_presence/fields
>>>>>    value
>>>>>    int
>>>>>   metricfs_presence/values
>>>>>    1
>>>>>   metricfs_presence/version
>>>>>    1
>>>>>=20
>>>>> (The "version" field always says '1', and is kind of vestigial)
>>>>>=20
>>>>> An example of a more complicated stat is the networking stats.
>>>>> For example, the tx_bytes stat looks like:
>>>>>=20
>>>>> net/dev/stats/tx_bytes/annotations
>>>>>    DESCRIPTION net\ device\ transmited\ bytes\ count
>>>>>    CUMULATIVE
>>>>> net/dev/stats/tx_bytes/fields
>>>>>    interface value
>>>>>    str int
>>>>> net/dev/stats/tx_bytes/values
>>>>>    lo 4394430608
>>>>>    eth0 33353183843
>>>>>    eth1 16228847091
>>>>> net/dev/stats/tx_bytes/version
>>>>>    1
>>>>>=20
>>>>> The per-cpu statistics show up in the schedulat stat info and x86
>>>>> IRQ counts.  For example:
>>>>>=20
>>>>> stat/user/annotations
>>>>>    DESCRIPTION time\ in\ user\ mode\ (nsec)
>>>>>    CUMULATIVE
>>>>> stat/user/fields
>>>>>    cpu value
>>>>>    int int
>>>>> stat/user/values
>>>>>    0 1183486517734
>>>>>    1 1038284237228
>>>>>    ...
>>>>> stat/user/version
>>>>>    1
>>>>>=20
>>>>> The full set of example metrics I've included are:
>>>>>=20
>>>>> core/metricfs: Create metricfs, standardized files under debugfs.
>>>>>    metricfs_presence
>>>>> core/metricfs: metric for kernel warnings
>>>>>    warnings/values
>>>>> core/metricfs: expose scheduler stat information through metricfs
>>>>>    stat/*
>>>>> net-metricfs: Export /proc/net/dev via metricfs.
>>>>>    net/dev/stats/[tr]x_*
>>>>> core/metricfs: expose x86-specific irq information through =
metricfs
>>>>>    irq_x86/*
>>>>>=20
>>>>> The general approach is called out in kernel/metricfs.c:
>>>>>=20
>>>>> The kernel provides:
>>>>>    - A description of the metric
>>>>>    - The subsystem for the metric (NULL is ok)
>>>>>    - Type information about the metric, and
>>>>>    - A callback function which supplies metric values.
>>>>>=20
>>>>> Limitations:
>>>>>    - "values" files are at MOST 64K. We truncate the file at that =
point.
>>>>>    - The list of fields and types is at most 1K.
>>>>>    - Metrics may have at most 2 fields.
>>>>>=20
>>>>> Best Practices:
>>>>>    - Emit the most important data first! Once the 64K per-metric =
buffer
>>>>>      is full, the emit* functions won't do anything.
>>>>>    - In userspace, open(), read(), and close() the file quickly! =
The kernel
>>>>>      allocation for the metric is alive as long as the file is =
open. This
>>>>>      permits users to seek around the contents of the file, while
>>>>>      permitting an atomic view of the data.
>>>>>=20
>>>>> Note that since the callbacks are called and the data is generated =
at
>>>>> file open() time, the relative consistency is only between members =
of
>>>>> a given metric; the rx_bytes stat for every network interface will
>>>>> be read at almost the same time, but if you want to get rx_bytes
>>>>> and rx_packets, there could be a bunch of slew between the two =
file
>>>>> opens.  (So this doesn't entirely address Andrew Lunn's comments =
in
>>>>> https://lkml.org/lkml/2020/5/26/490)
>>>>>=20
>>>>> This also doesn't address one of the basic parts of the statsfs =
work:
>>>>> moving the statistics out of debugfs to avoid lockdown =
interactions.
>>>>>=20
>>>>> Google has found a lot of value in having a generic interface for =
adding
>>>>> these kinds of statistics with reasonably low overhead (reading =
them
>>>>> is O(number of statistics), not number of objects in each =
statistic).
>>>>> There are definitely warts in the interface, but does the basic =
approach
>>>>> make sense to folks?
>>>>>=20
>>>>> Thanks,
>>>>> - Jonathan
>>>>>=20
>>>>> Jonathan Adams (5):
>>>>>    core/metricfs: add support for percpu metricfs files
>>>>>    core/metricfs: metric for kernel warnings
>>>>>    core/metricfs: expose softirq information through metricfs
>>>>>    core/metricfs: expose scheduler stat information through =
metricfs
>>>>>    core/metricfs: expose x86-specific irq information through =
metricfs
>>>>>=20
>>>>> Justin TerAvest (1):
>>>>>    core/metricfs: Create metricfs, standardized files under =
debugfs.
>>>>>=20
>>>>> Laurent Chavey (1):
>>>>>    net-metricfs: Export /proc/net/dev via metricfs.
>>>>>=20
>>>>>   arch/x86/kernel/irq.c      |  80 ++++
>>>>>   fs/proc/stat.c             |  57 +++
>>>>>   include/linux/metricfs.h   | 131 +++++++
>>>>>   kernel/Makefile            |   2 +
>>>>>   kernel/metricfs.c          | 775 =
+++++++++++++++++++++++++++++++++++++
>>>>>   kernel/metricfs_examples.c | 151 ++++++++
>>>>>   kernel/panic.c             | 131 +++++++
>>>>>   kernel/softirq.c           |  45 +++
>>>>>   lib/Kconfig.debug          |  18 +
>>>>>   net/core/Makefile          |   1 +
>>>>>   net/core/net_metricfs.c    | 194 ++++++++++
>>>>>   11 files changed, 1585 insertions(+)
>>>>>   create mode 100644 include/linux/metricfs.h
>>>>>   create mode 100644 kernel/metricfs.c
>>>>>   create mode 100644 kernel/metricfs_examples.c
>>>>>   create mode 100644 net/core/net_metricfs.c
>>>>>=20
>>>>> --
>>>>> 2.28.0.236.gb10cc79966-goog
>>>>>=20
>>>>=20
>>>>=20
>> --
>> Thanks,
>> Steve

--
Chuck Lever



