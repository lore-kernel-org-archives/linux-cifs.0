Return-Path: <SRS0=tZQk=YK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDB1FA372A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 20:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D798D21835
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 20:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391182AbfJQUfh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Oct 2019 16:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437240AbfJQUfc (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Oct 2019 16:35:32 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D70FD6696C
        for <linux-cifs@vger.kernel.org>; Thu, 17 Oct 2019 20:35:31 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id n4so3510146qtp.19
        for <linux-cifs@vger.kernel.org>; Thu, 17 Oct 2019 13:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a/67vzwtL6iFdG2zU3Ezmi7fTFI654oboepll7QllqI=;
        b=rZNaCGGTurGF/tivskzLopeXX39qj0HZUtJEr8gxWPENK0hj+rEPJ/6KUYAkSlVazf
         B28IlcR3PMOlGCwpNYPQgkI8p22eqkgXVkzdQ4gbn7oAdITLRXw2Nxzoo5+Gu18mBhmL
         gtBQtxf8AYiXN+o+TXDyOTafaF7prWROhAmCRuG0HFN7zabVPsywyTPkZPZYgYfDjAvV
         xXHk5vdK7vNeZ+1M+ap8okJS0jK3FRCypMdD6fr8IfUOZ/4MKsXHuYdnlclAzWTZMTOq
         les26hVrZFMy+F9VF2IPFLezfOpmK1zMzLnO+/E8eMCvlJbMFUadJ5e4lfY0r3UVlpnP
         EtIA==
X-Gm-Message-State: APjAAAWlwSeWdZb56w81davgLpmokLfNUVdM4VpIxStS+LX7qbWDiK5F
        971IdDoOSxU9Pc0ZlkgqDvwV8OZsALYJ5Zh+j7PDf5uR17vO0w2VFly/PSc196eHfy0yvj7teTX
        uXEvwihbmKTd1MyZW85lmu28wH4SbMEr6LmDVCw==
X-Received: by 2002:a0c:da8b:: with SMTP id z11mr6113472qvj.126.1571344530419;
        Thu, 17 Oct 2019 13:35:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxxOX1HgTTy/7UWhX5g+9az4h6LtvngmffzAQmA2nbjgqO9fxVBziLOtJ8YF5PuVszI9mGmGtqu2sU6/q/viTk=
X-Received: by 2002:a0c:da8b:: with SMTP id z11mr6113436qvj.126.1571344530051;
 Thu, 17 Oct 2019 13:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <1206360169.6955748.1571271438699.JavaMail.zimbra@redhat.com>
 <1205168.6984242.1571303132895.JavaMail.zimbra@redhat.com>
 <CALF+zOkAEH5Zz9wBmTBM21wLcWU7mKnpFAktxdpNGyo4xET5zA@mail.gmail.com>
 <1383472639.7033868.1571321306723.JavaMail.zimbra@redhat.com>
 <CALF+zOnkhUYZpu_2xPVHaXx8CeX_kR+caVZj4YLmoYWR-aQaqg@mail.gmail.com>
 <DM5PR21MB018567FF1ED90591DC1D43D0B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com> <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Thu, 17 Oct 2019 16:34:53 -0400
Message-ID: <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
