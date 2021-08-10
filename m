Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5ACC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 14:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF0C600CD
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 14:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhHJOEB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 10:04:01 -0400
Received: from mx01.geo.uzh.ch ([130.60.176.135]:52572 "EHLO mx01.geo.uzh.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241072AbhHJOEA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 10 Aug 2021 10:04:00 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 10:03:59 EDT
X-Virus-Scanned: Debian amavisd-new at geo.uzh.ch
Received: from brisen.service.geo.uzh.ch (unknown [130.60.176.40])
        by mx01.geo.uzh.ch (Postfix) with ESMTP id 6EF052614EC
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 15:56:49 +0200 (CEST)
Received: from smtpclient.apple (unknown [192.168.246.10])
        by brisen.service.geo.uzh.ch (Postfix) with ESMTPSA id 5F58BBD06D
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 15:56:49 +0200 (CEST)
From:   Thomas Werschlein <thomas.werschlein@geo.uzh.ch>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Kernel lockup upon dfs_cache_update
Message-Id: <C36709C4-A89B-40A8-819B-F54828F8788D@geo.uzh.ch>
Date:   Tue, 10 Aug 2021 15:56:49 +0200
To:     linux-cifs@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi

We are mounting SMB shares from Windows and FreeBSD servers to AD-joined (Ubuntu) Linux clients, using DFS and Kerberos.

A sample /etc/fstab entry looks like this:
//files.d.example.com/shared /files/shared cifs defaults,sec=krb5i,vers=3,seal,multiuser,noserverino,username=LINUXCLIENT$ 0 0

The machine account LINUXCLIENT$ is able to browse the DFS tree and mount the shares.
The credentials for the principal LINUXCLIENT$@D.EXAMPLE.COM are stored in the default keytab (/etc/krb5.keytab).
In order to access a share a user needs a personal KRB ticket (either through kinit or GSSAPI delegated credentials upon ssh login).

This works fine on Ubuntu 18.04 (4.15.0-153-generic Kernel, 2.10 cifs.ko), but doesn't on Ubuntu 20.04 (5.4.0-80-generic, 2.23).
To be precise: it works for the first 10 hours (the ticket lifetime) even on Ubuntu 20.04.

Consider this freshly booted linux host:

root@linuxclient:~# uptime -s
2021-08-09 18:11:29

Approximately 10 hours later, the kernel locks itself up with these messages in kern.log (server names and IPs redacted):

Aug 10 04:15:59 linuxclient kernel: [36115.522194] fs/cifs/connect.c: Existing tcp session with server found
Aug 10 04:15:59 linuxclient kernel: [36115.522197] fs/cifs/dfs_cache.c: CIFS VFS: in do_refresh_tcon as Xid: 398 with uid: 0
Aug 10 04:15:59 linuxclient kernel: [36115.522201] fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \files.d.example.com\shared
Aug 10 04:15:59 linuxclient kernel: [36115.522206] fs/cifs/smb2pdu.c: SMB2 IOCTL
Aug 10 04:15:59 linuxclient kernel: [36115.522234] fs/cifs/smb2ops.c: Encrypt message returned 0
Aug 10 04:15:59 linuxclient kernel: [36115.522246] fs/cifs/transport.c: Sending smb: smb_len=248
Aug 10 04:15:59 linuxclient kernel: [36115.522816] fs/cifs/connect.c: RFC1002 header 0x7d
Aug 10 04:15:59 linuxclient kernel: [36115.522826] fs/cifs/smb2ops.c: Decrypt message returned 0
Aug 10 04:15:59 linuxclient kernel: [36115.522828] fs/cifs/smb2ops.c: mid found
Aug 10 04:15:59 linuxclient kernel: [36115.522830] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
Aug 10 04:15:59 linuxclient kernel: [36115.522831] fs/cifs/smb2misc.c: SMB2 len 73
Aug 10 04:15:59 linuxclient kernel: [36115.522832] fs/cifs/smb2ops.c: Session expired or deleted
Aug 10 04:15:59 linuxclient kernel: [36115.522836] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \files.d.example.com\shared
Aug 10 04:15:59 linuxclient kernel: [36115.522840] fs/cifs/connect.c: cifs_reconnect: will retry 3 target(s)
Aug 10 04:15:59 linuxclient kernel: [36115.522841] fs/cifs/connect.c: Mark tcp session as need reconnect
Aug 10 04:15:59 linuxclient kernel: [36115.522841] fs/cifs/connect.c: cifs_reconnect: marking sessions and tcons for reconnect
Aug 10 04:15:59 linuxclient kernel: [36115.522842] fs/cifs/connect.c: cifs_reconnect: tearing down socket
Aug 10 04:15:59 linuxclient kernel: [36115.522844] fs/cifs/connect.c: State: 0x3 Flags: 0x0
Aug 10 04:15:59 linuxclient kernel: [36115.522850] fs/cifs/connect.c: Post shutdown state: 0x3 Flags: 0x0
Aug 10 04:15:59 linuxclient kernel: [36115.522857] fs/cifs/connect.c: cifs_reconnect: moving mids to private list
Aug 10 04:15:59 linuxclient kernel: [36115.522858] fs/cifs/connect.c: cifs_reconnect: issuing mid callbacks
Aug 10 04:15:59 linuxclient kernel: [36115.522862] fs/cifs/connect.c: reconn_inval_dfs_target: UNC: \\files.d.example.com\shared
Aug 10 04:15:59 linuxclient kernel: [36115.522865] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: probably server name is whole unc: \\files.d.example.com
Aug 10 04:15:59 linuxclient kernel: [36115.522873] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: files.d.example.com to 10.10.10.10
Aug 10 04:15:59 linuxclient kernel: [36115.522881] fs/cifs/connect.c: Socket created
Aug 10 04:15:59 linuxclient kernel: [36115.522882] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
Aug 10 04:15:59 linuxclient kernel: [36115.522905] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=698 state=8
Aug 10 04:15:59 linuxclient kernel: [36115.522907] fs/cifs/smb2pdu.c: SMB2 IOCTL
Aug 10 04:15:59 linuxclient kernel: [36115.523407] fs/cifs/smb2ops.c: set credits to 1 due to smb2 reconnect
Aug 10 04:15:59 linuxclient kernel: [36115.523409] fs/cifs/dfs_cache.c: dfs_cache_noreq_update_tgthint: path: \files.d.example.com\shared
Aug 10 04:15:59 linuxclient kernel: [36115.523410] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \files.d.example.com\shared
Aug 10 04:15:59 linuxclient kernel: [36115.523412] fs/cifs/dfs_cache.c: dfs_cache_update_vol: fullpath: \\files.d.example.com\shared
Aug 10 04:16:09 linuxclient kernel: [36125.762187] fs/cifs/smb2pdu.c: Negotiate protocol
Aug 10 04:16:09 linuxclient kernel: [36125.762201] fs/cifs/transport.c: Sending smb: smb_len=108
Aug 10 04:16:15 linuxclient kernel: [36131.906173] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:16:15 linuxclient kernel: [36131.906196] fs/cifs/transport.c: Sending smb: smb_len=72
Aug 10 04:16:15 linuxclient kernel: [36131.906213] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:16:15 linuxclient kernel: [36131.906214] fs/cifs/smb2pdu.c: Need negotiate, reconnecting tcons
Aug 10 04:16:15 linuxclient kernel: [36131.907034] fs/cifs/connect.c: RFC1002 header 0x44
Aug 10 04:16:15 linuxclient kernel: [36131.907041] fs/cifs/smb2misc.c: SMB2 len 68
Aug 10 04:16:15 linuxclient kernel: [36131.907044] fs/cifs/smb2ops.c: add 1 credits total=2353
Aug 10 04:17:16 linuxclient kernel: [36193.346172] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:17:16 linuxclient kernel: [36193.346174] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:17:16 linuxclient kernel: [36193.346199] fs/cifs/transport.c: Sending smb: smb_len=72
Aug 10 04:17:16 linuxclient kernel: [36193.347134] fs/cifs/connect.c: RFC1002 header 0x44
Aug 10 04:17:16 linuxclient kernel: [36193.347140] fs/cifs/smb2misc.c: SMB2 len 68
Aug 10 04:17:16 linuxclient kernel: [36193.347143] fs/cifs/smb2ops.c: add 1 credits total=2353
Aug 10 04:18:14 linuxclient kernel: [36250.690180] INFO: task cifsd:644 blocked for more than 120 seconds.
Aug 10 04:18:14 linuxclient kernel: [36250.690208]       Not tainted 5.4.0-80-generic #90-Ubuntu
Aug 10 04:18:14 linuxclient kernel: [36250.690227] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 10 04:18:14 linuxclient kernel: [36250.690253] cifsd           D    0   644      2 0x80004002
Aug 10 04:18:14 linuxclient kernel: [36250.690255] Call Trace:
Aug 10 04:18:14 linuxclient kernel: [36250.690263]  __schedule+0x2e3/0x740
Aug 10 04:18:14 linuxclient kernel: [36250.690267]  ? vprintk_default+0x29/0x50
Aug 10 04:18:14 linuxclient kernel: [36250.690270]  schedule+0x42/0xb0
Aug 10 04:18:14 linuxclient kernel: [36250.690272]  schedule_preempt_disabled+0xe/0x10
Aug 10 04:18:14 linuxclient kernel: [36250.690274]  __mutex_lock.isra.0+0x178/0x4d0
Aug 10 04:18:14 linuxclient kernel: [36250.690276]  ? _raw_spin_lock_bh+0x30/0x30
Aug 10 04:18:14 linuxclient kernel: [36250.690278]  __mutex_lock_slowpath+0x13/0x20
Aug 10 04:18:14 linuxclient kernel: [36250.690279]  mutex_lock+0x2e/0x40
Aug 10 04:18:14 linuxclient kernel: [36250.690308]  dfs_cache_update_vol+0x41/0x2b0 [cifs]
Aug 10 04:18:14 linuxclient kernel: [36250.690320]  cifs_reconnect+0x623/0xdb0 [cifs]
Aug 10 04:18:14 linuxclient kernel: [36250.690332]  cifs_handle_standard+0x18e/0x1b0 [cifs]
Aug 10 04:18:14 linuxclient kernel: [36250.690347]  smb3_receive_transform+0x2b5/0x400 [cifs]
Aug 10 04:18:14 linuxclient kernel: [36250.690359]  cifs_demultiplex_thread+0x778/0xcd0 [cifs]
Aug 10 04:18:14 linuxclient kernel: [36250.690360]  ? __schedule+0x2eb/0x740
Aug 10 04:18:14 linuxclient kernel: [36250.690363]  kthread+0x104/0x140
Aug 10 04:18:14 linuxclient kernel: [36250.690375]  ? cifs_handle_standard+0x1b0/0x1b0 [cifs]
Aug 10 04:18:14 linuxclient kernel: [36250.690376]  ? kthread_park+0x90/0x90
Aug 10 04:18:14 linuxclient kernel: [36250.690377]  ret_from_fork+0x35/0x40
Aug 10 04:18:18 linuxclient kernel: [36254.786170] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:18:18 linuxclient kernel: [36254.786197] fs/cifs/transport.c: Sending smb: smb_len=72
Aug 10 04:18:18 linuxclient kernel: [36254.786218] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:18:18 linuxclient kernel: [36254.786961] fs/cifs/connect.c: RFC1002 header 0x44
Aug 10 04:18:18 linuxclient kernel: [36254.786967] fs/cifs/smb2misc.c: SMB2 len 68
Aug 10 04:18:18 linuxclient kernel: [36254.786970] fs/cifs/smb2ops.c: add 1 credits total=2353
Aug 10 04:19:19 linuxclient kernel: [36316.226158] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:19:19 linuxclient kernel: [36316.226162] fs/cifs/smb2pdu.c: In echo request
Aug 10 04:19:19 linuxclient kernel: [36316.226186] fs/cifs/transport.c: Sending smb: smb_len=72
Aug 10 04:19:19 linuxclient kernel: [36316.227037] fs/cifs/connect.c: RFC1002 header 0x44
Aug 10 04:19:19 linuxclient kernel: [36316.227045] fs/cifs/smb2misc.c: SMB2 len 68
Aug 10 04:19:19 linuxclient kernel: [36316.227049] fs/cifs/smb2ops.c: add 1 credits total=2353

My findings so far:
- this lockup (after 10h) *only* occurs when DFS is involved. Mounting a target share directly "survives" the ticket expiry
- this problem does *not* manifest with the newest kernel/cifs.ko combo (5.14.0-051400rc5-generic/2.33)

Therefore:
Could it be, that the DFS patches contributed by Paulo Alcantara on June 4 2021 (https://www.spinics.net/lists/linux-cifs/msg21999.html)
fixed this problem?

Two of his comments point into that direction: 
  [...]
  - keep SMB sessions alive as long as dfs mounts are actives in order
    to refresh cached entries by using IPC tcons.
  [...]
  - skip unnecessary tree disconnect of IPCs when shutting down SMB
    sessions (it didn't even work before).

Am I on the right track here? And if so: are there any plans to backport Paulo's patches to current kernels?

Thanks a lot & best regards
Thomas

