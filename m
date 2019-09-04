Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC33C3A5A7
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 06:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2F5A22CF5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 06:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=monash.edu header.i=@monash.edu header.b="Bk8H35Jv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfIDGqk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:46:40 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:33250 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfIDGqk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Sep 2019 02:46:40 -0400
Received: by mail-qk1-f177.google.com with SMTP id x134so8487528qkb.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 23:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monash.edu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=03FSZOEe9x/aW/OI6MTiDNY4FZxt/npYmapm0sDQhrM=;
        b=Bk8H35JvjklpnZ8ccDHceRiJivM/C67MVnJlqTRrhXGVKQ0+p7OM0hCC/Jg+GB7E8M
         d65U+4M4dHSq1TuZLmITzCy2hrumhyMgJ0uF5SJPgRHcuANkPSTdMc3jZmIOlB+m6QzH
         V6ROGIweYxTntmPXq0Acgvjr/DxD9osBDectJ/9l9insLNtmkFaNYz+xznMHot/T70v9
         cVECfZTfsxc+1Aa/0MDZdxsill+sBIi/GHgnp57UbmEvJQrve+wVvQJn+CtcmRPw4VOm
         Cx3xN1aXEcKteekVwhVJ6Cg7qooXlDz5bhzR2/HZ4NiBG8DPJYzAvCjze257rHptTdQB
         e+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=03FSZOEe9x/aW/OI6MTiDNY4FZxt/npYmapm0sDQhrM=;
        b=LRB1CRXcFSa92T6Br1kjhfR7xD7K4IbUC5X/LJR4uNKH3g+r+invusyeMi2i7gBNHe
         TliNQHIFfc50eCDYNn50gwu63q6JK4AOF0TI5MKi+6mrvCR/5GiiUTjl0jTCO7psy+Qp
         cIVdFiynQ9jMJUfek4NIC/SMi8anQT1PMFEijjYxYh/0qHSOyAAx3tuwuRFoP1yh02CI
         A7OtXDwxiC4B3NZ1AUkfh8nKb2MZwPxRRnZ/phfF4KulfQ3H9RTqIv9r4PQ+mEOYUamU
         2FLaVp03COoe6jxWg+Ksh3KQA7IwhIqYRysKIH9B/oYOQGupO1DvuEk9XfxVzWf4kMXR
         2b+Q==
X-Gm-Message-State: APjAAAVIMW9QSuZmWXBMn5rsFNqkfbeIBo1b+z0jprh1IXtRpTS2jUBu
        Ph04USf1efpvYr5KSJaDWJKPHwdXgTeqF9rgD3HOGQ==
X-Google-Smtp-Source: APXvYqxynNRP9YUBMzxd7alkHLp38uQywL3Dxq6UKWlxqljAWqLRa381H1dVlQYuygu38cNQO4YtiSrqGLrh0dhdI5c=
X-Received: by 2002:a37:a550:: with SMTP id o77mr15072102qke.205.1567579598695;
 Tue, 03 Sep 2019 23:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
 <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
 <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com> <87pnkh7jh2.fsf@suse.com>
In-Reply-To: <87pnkh7jh2.fsf@suse.com>
From:   James Wettenhall <james.wettenhall@monash.edu>
Date:   Wed, 4 Sep 2019 16:46:27 +1000
Message-ID: <CAE78Er_ea5mtp-6VxyNPzCSDuPym7cXcD3=Udcpv=jGo80XhZg@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aur=C3=A9lien,

The VMs become completely unresponsive, so we can't run commands in a
separate shell.

I've included a stack trace below.

I'm considering trying the cache=3Dloose mount option.

Cheers,
James

Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.616360] INFO: task
dockerd:786 blocked for more than 120 seconds.
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.621073]       Not
tainted 5.0.0-25-generic #26~18.04.1-Ubuntu
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.625436] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629464] dockerd
D    0   786      1 0x00000000
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629467] Call Trace:
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629477]  __schedule+0x2bd/0x8=
50
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629482]  ?
__switch_to_asm+0x35/0x70
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629484]  schedule+0x2c/0x70
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629485]
schedule_preempt_disabled+0xe/0x10
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629487]
__mutex_lock.isra.9+0x183/0x4e0
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629488]  ?
schedule_timeout+0x171/0x360
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629490]
__mutex_lock_slowpath+0x13/0x20
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629491]  ?
__mutex_lock_slowpath+0x13/0x20
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629492]  mutex_lock+0x2f/0x40
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629528]
smb2_reconnect+0x106/0x7f0 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629531]  ? __switch_to+0x123/=
0x4e0
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629533]  ?
__switch_to_asm+0x35/0x70
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629537]  ?
__switch_to_asm+0x41/0x70
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629540]  ? wait_woken+0x80/0x=
80
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629556]
smb2_plain_req_init+0x34/0x270 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629577]
SMB2_open_init+0x6d/0x730 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629595]
SMB2_open+0x148/0x4f0 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629609]  ?
SMB2_open+0x148/0x4f0 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629624]
open_shroot+0x16c/0x210 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629637]  ?
open_shroot+0x16c/0x210 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629654]
smb2_query_path_info+0x11c/0x1b0 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629656]  ? _cond_resched+0x19=
/0x40
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629660]  ?
kmem_cache_alloc_trace+0x151/0x1c0
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629673]
cifs_get_inode_info+0x3e3/0xb70 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629685]  ?
build_path_from_dentry_optional_prefix+0x103/0x430 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629699]
cifs_revalidate_dentry_attr+0xe9/0x3d0 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629712]
cifs_getattr+0x5d/0x1a0 [cifs]
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629715]  ?
common_perm_cond+0x4c/0x70
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629719]
vfs_getattr_nosec+0x73/0x90
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629720]  vfs_getattr+0x36/0x4=
0
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629721]  vfs_statx+0x8d/0xe0
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629723]
__do_sys_newlstat+0x3d/0x70
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629725]
__x64_sys_newlstat+0x16/0x20
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629729]  do_syscall_64+0x5a/0=
x120
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629731]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629734] RIP: 0033:0x55fd5a4b1=
e40
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629739] Code: Bad RIP value.
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629741] RSP:
002b:000000c421af6948 EFLAGS: 00000212 ORIG_RAX: 0000000000000006
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629742] RAX:
ffffffffffffffda RBX: 0000000000000000 RCX: 000055fd5a4b1e40
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629743] RDX:
0000000000000000 RSI: 000000c421491488 RDI: 000000c4227a4060
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629743] RBP:
000000c421af69b0 R08: 0000000000000000 R09: 0000000000000000
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629744] R10:
0000000000000000 R11: 0000000000000212 R12: ffffffffffffffff
Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629745] R13:
0000000000000002 R14: 0000000000000001 R15: 0000000000000055
