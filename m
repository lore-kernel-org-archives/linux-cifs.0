Return-Path: <SRS0=tZQk=YK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78C2FA372A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 21:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9229A222BD
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 21:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437893AbfJQVox (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Oct 2019 17:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395390AbfJQVox (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Oct 2019 17:44:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 450BF10317F1;
        Thu, 17 Oct 2019 21:44:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A952600C4;
        Thu, 17 Oct 2019 21:44:52 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2BE8818089C8;
        Thu, 17 Oct 2019 21:44:52 +0000 (UTC)
Date:   Thu, 17 Oct 2019 17:44:51 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     Pavel Shilovskiy <pshilov@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Message-ID: <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
In-Reply-To: <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com> <CALF+zOkAEH5Zz9wBmTBM21wLcWU7mKnpFAktxdpNGyo4xET5zA@mail.gmail.com> <1383472639.7033868.1571321306723.JavaMail.zimbra@redhat.com> <CALF+zOnkhUYZpu_2xPVHaXx8CeX_kR+caVZj4YLmoYWR-aQaqg@mail.gmail.com> <DM5PR21MB018567FF1ED90591DC1D43D0B66D0@DM5PR21MB0185.namprd21.prod.outlook.com> <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com> <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com> <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in
 cifs_reconnect still seen on 5.4-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.54.116, 10.4.195.14]
Thread-Topic: list_del corruption while iterating retry_list in cifs_reconnect still seen on 5.4-rc3
Thread-Index: SH+C5q0n42cUKDDC4LZwyprWy6jIhg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 17 Oct 2019 21:44:52 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dave, Pavel

If it takes longer to trigger it might indicate we are on the right path but there are additional places to fix.

I still think you also need to protect the list mutate functions as well using the global mutex, so something like this :

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index bdea4b3e8005..16705a855818 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -564,6 +564,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
        spin_lock(&GlobalMid_Lock);
        list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
                mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+               kref_get(&mid_entry->refcount);
                if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
                        mid_entry->mid_state = MID_RETRY_NEEDED;
                list_move(&mid_entry->qhead, &retry_list);
@@ -572,11 +573,18 @@ cifs_reconnect(struct TCP_Server_Info *server)
        mutex_unlock(&server->srv_mutex);
 
        cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
+       spin_lock(&GlobalMid_Lock);
        list_for_each_safe(tmp, tmp2, &retry_list) {
                mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
                list_del_init(&mid_entry->qhead);
+               spin_unlock(&GlobalMid_Lock);
+
                mid_entry->callback(mid_entry);
+               cifs_mid_q_entry_release(mid_entry);
+
+               spin_lock(&GlobalMid_Lock);
        }
+       spin_unlock(&GlobalMid_Lock);
 
        if (cifs_rdma_enabled(server)) {
                mutex_lock(&server->srv_mutex);


----- Original Message -----
From: "David Wysochanski" <dwysocha@redhat.com>
To: "Pavel Shilovskiy" <pshilov@microsoft.com>
Cc: "Ronnie Sahlberg" <lsahlber@redhat.com>, "linux-cifs" <linux-cifs@vger.kernel.org>, "Frank Sorenson" <sorenson@redhat.com>
Sent: Friday, 18 October, 2019 6:34:53 AM
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect still seen on 5.4-rc3

Unfortunately that did not fix the list_del corruption.
It did seem to run longer but I'm not sure runtime is meaningful.

[ 1424.215537] list_del corruption. prev->next should be
ffff8d9b74c84d80, but was a6787a60550c54a9
[ 1424.232688] ------------[ cut here ]------------
[ 1424.234535] kernel BUG at lib/list_debug.c:51!
[ 1424.236502] invalid opcode: 0000 [#1] SMP PTI
[ 1424.238334] CPU: 5 PID: 10212 Comm: cifsd Kdump: loaded Not tainted
5.4.0-rc3-fix1+ #33
[ 1424.241489] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1424.243770] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
[ 1424.245972] Code: 5e 15 b5 e8 54 a3 c5 ff 0f 0b 48 c7 c7 70 5f 15
b5 e8 46 a3 c5 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 30 5f 15 b5 e8 32
a3 c5 ff <0f> 0b 48 89 fe 4c 89 c2 48 c7 c7 f8 5e 15 b5 e8 1e a3 c5 ff
0f 0b
[ 1424.253409] RSP: 0018:ffff9a12404b3d38 EFLAGS: 00010246
[ 1424.255576] RAX: 0000000000000054 RBX: ffff8d9b6ece1000 RCX: 0000000000000000
[ 1424.258504] RDX: 0000000000000000 RSI: ffff8d9b77b57908 RDI: ffff8d9b77b57908
[ 1424.261404] RBP: ffff8d9b74c84d80 R08: ffff8d9b77b57908 R09: 0000000000000280
[ 1424.264336] R10: ffff9a12404b3bf0 R11: ffff9a12404b3bf5 R12: ffff8d9b6ece11c0
[ 1424.267285] R13: ffff9a12404b3d48 R14: a6787a60550c54a9 R15: ffff8d9b6fcec300
[ 1424.270191] FS:  0000000000000000(0000) GS:ffff8d9b77b40000(0000)
knlGS:0000000000000000
[ 1424.273491] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1424.275831] CR2: 0000562cdf4a2000 CR3: 000000023340c000 CR4: 00000000000406e0
[ 1424.278733] Call Trace:
[ 1424.279844]  cifs_reconnect+0x268/0x620 [cifs]
[ 1424.281723]  cifs_readv_from_socket+0x220/0x250 [cifs]
[ 1424.283876]  cifs_read_from_socket+0x4a/0x70 [cifs]
[ 1424.285922]  ? try_to_wake_up+0x212/0x650
[ 1424.287595]  ? cifs_small_buf_get+0x16/0x30 [cifs]
[ 1424.289520]  ? allocate_buffers+0x66/0x120 [cifs]
[ 1424.291421]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
[ 1424.293506]  kthread+0xfb/0x130
[ 1424.294789]  ? cifs_handle_standard+0x190/0x190 [cifs]
[ 1424.296833]  ? kthread_park+0x90/0x90
[ 1424.298295]  ret_from_fork+0x35/0x40
[ 1424.299717] Modules linked in: cifs libdes libarc4 ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ip6table_nat
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
iptable_mangle iptable_raw iptable_security nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel virtio_balloon joydev i2c_piix4 nfsd nfs_acl lockd
auth_rpcgss grace sunrpc xfs libcrc32c crc32c_intel virtio_net
net_failover ata_generic serio_raw virtio_console virtio_blk failover
pata_acpi qemu_fw_cfg
[ 1424.322374] ---[ end trace 214af7e68b58e94b ]---
[ 1424.324305] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
[ 1424.326551] Code: 5e 15 b5 e8 54 a3 c5 ff 0f 0b 48 c7 c7 70 5f 15
b5 e8 46 a3 c5 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 30 5f 15 b5 e8 32
a3 c5 ff <0f> 0b 48 89 fe 4c 89 c2 48 c7 c7 f8 5e 15 b5 e8 1e a3 c5 ff
0f 0b
[ 1424.333874] RSP: 0018:ffff9a12404b3d38 EFLAGS: 00010246
[ 1424.335976] RAX: 0000000000000054 RBX: ffff8d9b6ece1000 RCX: 0000000000000000
[ 1424.338842] RDX: 0000000000000000 RSI: ffff8d9b77b57908 RDI: ffff8d9b77b57908
[ 1424.341668] RBP: ffff8d9b74c84d80 R08: ffff8d9b77b57908 R09: 0000000000000280
[ 1424.344511] R10: ffff9a12404b3bf0 R11: ffff9a12404b3bf5 R12: ffff8d9b6ece11c0
[ 1424.347343] R13: ffff9a12404b3d48 R14: a6787a60550c54a9 R15: ffff8d9b6fcec300
[ 1424.350184] FS:  0000000000000000(0000) GS:ffff8d9b77b40000(0000)
knlGS:0000000000000000
[ 1424.353394] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1424.355699] CR2: 0000562cdf4a2000 CR3: 000000023340c000 CR4: 00000000000406e0

On Thu, Oct 17, 2019 at 3:58 PM Pavel Shilovskiy <pshilov@microsoft.com> wrote:
>
>
> The patch looks good. Let's see if it fixes the issue in your setup.
>
> --
> Best regards,
> Pavel Shilovsky
>
> -----Original Message-----
> From: David Wysochanski <dwysocha@redhat.com>
> Sent: Thursday, October 17, 2019 12:23 PM
> To: Pavel Shilovskiy <pshilov@microsoft.com>
> Cc: Ronnie Sahlberg <lsahlber@redhat.com>; linux-cifs <linux-cifs@vger.kernel.org>; Frank Sorenson <sorenson@redhat.com>
> Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect still seen on 5.4-rc3
> On Thu, Oct 17, 2019 at 2:29 PM Pavel Shilovskiy <pshilov@microsoft.com> wrote:
> >
> > The similar solution of taking an extra reference should apply to the case of reconnect as well. The reference should be taken during the process of moving mid entries to the private list. Once a callback completes, such a reference should be put back thus freeing the mid.
> >
>
> Ah ok very good.  The above seems consistent with the traces I'm seeing of the race.
> I am going to test this patch as it sounds like what you're describing and similar to what Ronnie suggested earlier:
>
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -564,6 +564,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         spin_lock(&GlobalMid_Lock);
>         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> +               kref_get(&mid_entry->refcount);
>                 if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
>                         mid_entry->mid_state = MID_RETRY_NEEDED;
>                 list_move(&mid_entry->qhead, &retry_list); @@ -576,6 +577,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
>                 list_del_init(&mid_entry->qhead);
>                 mid_entry->callback(mid_entry);
> +               cifs_mid_q_entry_release(mid_entry);
>         }
>
>         if (cifs_rdma_enabled(server)) {
>


-- 
Dave Wysochanski
Principal Software Maintenance Engineer
T: 919-754-4024
