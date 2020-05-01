Return-Path: <SRS0=2f0v=6P=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D453C47256
	for <linux-cifs@archiver.kernel.org>; Fri,  1 May 2020 04:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56381208D6
	for <linux-cifs@archiver.kernel.org>; Fri,  1 May 2020 04:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgEAEro convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 May 2020 00:47:44 -0400
Received: from mout.perfora.net ([74.208.4.196]:42111 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgEAEro (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 1 May 2020 00:47:44 -0400
Received: from mbox0.exch.wynstonegroup.com ([173.174.199.113]) by
 mrelay.perfora.net (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0MXriD-1jhuUT3eSd-00WmBA for <linux-cifs@vger.kernel.org>; Fri, 01 May 2020
 06:47:43 +0200
Received: from mbox0.exch.wynstonegroup.com (10.0.200.50) by
 mbox0.exch.wynstonegroup.com (10.0.200.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.595.3;
 Thu, 30 Apr 2020 23:46:24 -0500
Received: from mbox0.exch.wynstonegroup.com ([fe80::cc87:845e:e093:fc4a]) by
 mbox0.exch.wynstonegroup.com ([fe80::cc87:845e:e093:fc4a%4]) with mapi id
 15.02.0595.003; Thu, 30 Apr 2020 23:46:24 -0500
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: issues with CIFS on Ubuntu 20 mounting Windows 2019
Thread-Topic: issues with CIFS on Ubuntu 20 mounting Windows 2019
Thread-Index: AdYfcd+fKz9EbKocTJmKaZWJpcHBlQ==
Date:   Fri, 1 May 2020 04:46:24 +0000
Message-ID: <52e802d7dde642c29662e9e05019c323@wynstonegroup.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.210.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   "Scott M. Lewandowski" <vgerkernel@scottl.com>
X-Provags-ID: V03:K1:MBUeZ/pV6xCQ5c+qTHEQp3ubZa/Mx6EUzD98uzpY7LzSlrjwWep
 WXKSYWp7OJyhuZ8NKDd/mSy/0eynyYLmwMz5cAUbjylTSycxYmohZs4lm2O3cl6STNQY6GL
 EMMGoyOGjbz9mlTvjl4x9kpTlVrf19ZI6cud32nM0Eh2TNvAtPnPjKN+SPJCC/6C4jcmSms
 Qqt4e5TGdEsukT7V8I7aw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:958LFZNFD3Y=:3TWyHQwjOy30DjWwx2BF0b
 3ix/27bzjo6GartLN05UPoNTIVQevbLwEiX/LxEIfDVHKxJN546GAIVyR4eUPO8DTv2rkZQRu
 EGpi2cCo/TwFSCWCjVu22fCT/zogR7JqV9FkbPiftmPzxdW3V7F1eiI8BZOyTI15OjJikPOPX
 8av8Q4QFFf6aFdo1SamS3A+aUWWSxvPRO+EHMz3MRtiIJto2U3crxxV0WQRyaPMcoIbkCaeIr
 o9EoBP0hl+gJhNUNUvTfTg9GUm0w6inA2DQjgNfHnmToNwIZaRzNsXwaFI7a5GikKpC9T6DEu
 eTWrG7U1KXddDEXaDV0H+QLyPOCQTyN4Y9DAd5yFkd76kz2F3UPwXXN1mFJVbg61iHUAi5NXy
 V0Lq7pJp0VeJ4yt+DndX3XK1NJtcEfqW4Mhe5D7EOBx3FmIqu47n28n86aCWPAo2hHYaJxE80
 4k2kIZ0Cj4azmRGGXkRhvnXGL4GIrbVML2VGn/hDUi+zchFxVM6rTqVDzC8AgK09SNo2zc5UQ
 7ArUCzq3/eN4rEuyu8uPOgn0ub3ZX9d+TbPaveN2FiynmiR5PYZ37bwDCNdBifMtGMvxVFrGb
 +Er2ZIa2Y2tZ3WbA+SEjP+qfN/FbLhsxKK3I0QQ2NwEYdXnPNiYGI6dGcaSmDwxP5QOT/C8bC
 BprgBFf4+H89O57Cktmld83M8O6lS0SGCpIS8Uo0m99v4kp9jewtjtsPN9kGhqYI7SQnovmV5
 TqWNJBzZVOAsQVEzyBI5UUDx+lWUy0E/kRbGoYL74n6bR+vg3vY/RDIprN2iDY6AKV+E+zYFQ
 br9qHl4u4M9sWuc/HE3Z2zmWOhrSEF85BAotj6MLA+mCCMOVWRAss1Tab2AjT25FaqCnTZ7
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have an Ubuntu 20.04 box mounting shares from a Windows 2019 server. Both boxes are fully patched. They are resident on the same hypervisor and communicating directly via a vSwitch. I have 4 shares mounted; here is an example from my fstab (yes, I know I should move the credential file):

//file1/usenet /mnt/usenet cifs vers=3.0,uid=scott,credentials=/home/scott/.smbcredentials,noserverino,nounix,iocharset=utf8 0 0

My kernel is 5.4.0-28-generic and mount.cifs version is 6.9. The contents of DebugData are included below.

Right after the mount, I see a duplicate cookie reported. It is unclear if this is a problem or not. Following that, I periodically see messages similar to the following repeated in dmesg:

[  179.625296] SMB2_read: 9 callbacks suppressed
[  179.625298] CIFS VFS: Send error in read = -4
[  179.704191] CIFS VFS: Send error in read = -4
[  179.847514] CIFS VFS: Send error in read = -4
[  180.031516] CIFS VFS: Send error in read = -4
[  180.214848] CIFS VFS: Send error in read = -4
[  180.282909] CIFS VFS: Send error in read = -4
[  180.474829] CIFS VFS: Send error in read = -4
[  180.621349] CIFS VFS: Send error in read = -4
[  180.780465] CIFS VFS: Send error in read = -4
[  180.823249] CIFS VFS: Send error in read = -4
[  182.339351] CIFS VFS: Close unmatched open
[  182.726829] CIFS VFS: Close unmatched open
[  184.292663] CIFS VFS: Close unmatched open
[  184.501185] CIFS VFS: Close unmatched open
[  191.784922] SMB2_read: 4 callbacks suppressed
[  191.784925] CIFS VFS: Send error in read = -4
[  191.884186] CIFS VFS: Send error in read = -4
[  192.270851] CIFS VFS: Send error in read = -4
[  192.323467] CIFS VFS: Send error in read = -4
[  192.381336] CIFS VFS: Send error in read = -4
[  192.446711] CIFS VFS: Send error in read = -4
[  192.507605] CIFS VFS: Send error in read = -4
[  193.244397] CIFS VFS: Send error in read = -4
[  193.307588] CIFS VFS: Send error in read = -4
[  193.403410] CIFS VFS: Send error in read = -4
[  193.797038] CIFS VFS: Close unmatched open
[  196.784082] CIFS VFS: Close unmatched open
[  198.247594] CIFS VFS: Close unmatched open

Here is the duplicate cookie info:

[   21.713307] FS-Cache: Duplicate cookie detected
[   21.713840] FS-Cache: O-cookie c=00000000e8276279 [p=0000000079ef0365 fl=222 nc=0 na=1]
[   21.714330] FS-Cache: O-cookie d=00000000173ea0ee n=00000000243f210c
[   21.714779] FS-Cache: O-key=[8] '020001bdc0a801af'
[   21.715219] FS-Cache: N-cookie c=00000000afb49d9c [p=0000000079ef0365 fl=2 nc=0 na=1]
[   21.715672] FS-Cache: N-cookie d=00000000173ea0ee n=00000000dd1465c5
[   21.716141] FS-Cache: N-key=[8] '020001bdc0a801af'
[   21.716591] FS-Cache: Duplicate cookie detected
[   21.717217] FS-Cache: O-cookie c=00000000e8276279 [p=0000000079ef0365 fl=222 nc=0 na=1]
[   21.717679] FS-Cache: O-cookie d=00000000173ea0ee n=00000000243f210c
[   21.718220] FS-Cache: O-key=[8] '020001bdc0a801af'
[   21.718681] FS-Cache: N-cookie c=0000000063665cf7 [p=0000000079ef0365 fl=2 nc=0 na=1]
[   21.719166] FS-Cache: N-cookie d=00000000173ea0ee n=00000000e757f917
[   21.719621] FS-Cache: N-key=[8] '020001bdc0a801af'
[   21.720097] FS-Cache: Duplicate cookie detected
[   21.720565] FS-Cache: O-cookie c=00000000e8276279 [p=0000000079ef0365 fl=222 nc=0 na=1]
[   21.721053] FS-Cache: O-cookie d=00000000173ea0ee n=00000000243f210c
[   21.721518] FS-Cache: O-key=[8] '020001bdc0a801af'
[   21.721994] FS-Cache: N-cookie c=00000000d479c294 [p=0000000079ef0365 fl=2 nc=0 na=1]
[   21.722476] FS-Cache: N-cookie d=00000000173ea0ee n=00000000ca1891fa
[   21.722941] FS-Cache: N-key=[8] '020001bdc0a801af'

Any ideas what could be going on? 

Thanks for any help!






DebugData:
CIFS Version 2.23
Features: DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0
Servers:
Number of credits: 8190 Dialect 0x300
1) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1 TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 0x100080000021
        Shares:
        0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x30
        tid: 0x1        Maximal Access: 0x11f01ff

        1) \\file1\XXX Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c339a0
        Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
        tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0x1f01ff

        MIDs:

        Server interfaces: 2
        0)      Speed: 10000000000 bps
                Capabilities:
                IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
        1)      Speed: 10000000000 bps
                Capabilities:
                IPv4: 192.168.1.175
Number of credits: 8190 Dialect 0x300

2) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1 TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 0x10006c000019
        Shares:
        0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x30
        tid: 0x1        Maximal Access: 0x11f01ff

        1) \\file1\usenet Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c339a0
        Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
        tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0x1f01ff

        MIDs:

        Server interfaces: 2
        0)      Speed: 10000000000 bps
                Capabilities:
                IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
        1)      Speed: 10000000000 bps
                Capabilities:
                IPv4: 192.168.1.175


3) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1 TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x1 Req On Wire: 2 SessionId: 0x10007c000061
        Shares:
        0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x30
        tid: 0x1        Maximal Access: 0x11f01ff

        1) \\file1\YYY Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c339a0
        Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
        tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0x1f01ff

        MIDs:
        State: 2 com: 8 pid: 1218 cbdata: 00000000e45c59d2 mid 1211489
        State: 2 com: 8 pid: 1218 cbdata: 0000000018476195 mid 1211553

        Server interfaces: 2
        0)      Speed: 10000000000 bps
                Capabilities:
                IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
        1)      Speed: 10000000000 bps
                Capabilities:
                IPv4: 192.168.1.175

Number of credits: 8190 Dialect 0x300
4) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1 TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 0x10006c000055
        Shares:
        0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x30
        tid: 0x1        Maximal Access: 0x11f01ff

        1) \\file1\ZZZ Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c339a0
        Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
        tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0x1f01ff

        MIDs:

        Server interfaces: 2
        0)      Speed: 10000000000 bps
                Capabilities:
                IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
        1)      Speed: 10000000000 bps
                Capabilities:
                IPv4: 192.168.1.175
