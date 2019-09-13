Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C2EC49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 23:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309212089F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 23:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MayBhqoV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390600AbfIMXrq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 19:47:46 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:45336 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390597AbfIMXrq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 19:47:46 -0400
Received: by mail-lj1-f170.google.com with SMTP id q64so18117254ljb.12
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2019 16:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ziesQ2JCtK1aH82OTLINI++lxExaH9Fu6JnbD2RfCHk=;
        b=MayBhqoVv1PI9mgRcjE7m9lO3tBDrzHUfvopkTez10JN1ZFySU9s1S+xZ/WxSRLWnc
         CojxxSyG9vBjrxTpTOvSJY/lKpo4cUxCMB3Ra7mqQ58Qs9JSB9D+YSRnYCk+UCkpVfat
         urUC1VHUfFo6DiEN7eDGaOOKUkq/sYLG+zg5VsXd7VPgHuIgTPGYm/nz+HjfZMZn66SZ
         4VngDlM1tr3BTosH4Nwi5gNMMgrCK16DonHBJChjwE3Q0E86IxqL5DdqriD3ejo1L48j
         QHu8OCNDkOl+Uve+8LBw3g66duwo+3QXBAq/BLIIhscw2XuOaJKrndkfDLeIndeK7vf4
         mHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ziesQ2JCtK1aH82OTLINI++lxExaH9Fu6JnbD2RfCHk=;
        b=ptJNq+PIUtEBt4WShkSy50+xz06P9W/VQrTNAxXt8AbdeMX7Lof+Eq+LwZui8jhm3F
         +ewnsbkUUyDx9Abcst0NCBhZkKphfbXWE/6j+vLj6ntPZjWhfA2uyj6agaqQq7oQrofU
         O/+x9IV/P05KjJ3BPmvnfzyA+su9YMYYWihB9L4mnwjr5LoRj9zwhKVIKu5kAPE0+fC+
         /8D4OvTkyzxJoqY0IJLddsxUAN/HlThVSWbMqpwMgNEpyUXg8kMfeRw/yEUkXoQA6XMp
         9mmsvmFhzOJaZtsDh2Lm8TQ0RPzxs0Fh04eKs8Hrmq5UX7tPv8ZL5AiyYERS7rg3nG8k
         5+Sg==
X-Gm-Message-State: APjAAAVPK6UZHu2XocCjanZoI4SZFs/UhKIjCI6t9TalNk/k7JBfTNqF
        jNetQp/5tSIKJvAXD+RGBFPHQOKSBvfZtgQ34w==
X-Google-Smtp-Source: APXvYqyJivdHrP/qMgCUI3UdlrCUNgVgP4K/QPOzUh+KRUcwjy9e7UCWAM1ijRzjJcxPHgKrh6MN7/XOUhSzS7b/KY4=
X-Received: by 2002:a2e:9012:: with SMTP id h18mr299326ljg.45.1568418463649;
 Fri, 13 Sep 2019 16:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
 <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
 <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com>
 <87pnkh7jh2.fsf@suse.com> <CAE78Er_ea5mtp-6VxyNPzCSDuPym7cXcD3=Udcpv=jGo80XhZg@mail.gmail.com>
In-Reply-To: <CAE78Er_ea5mtp-6VxyNPzCSDuPym7cXcD3=Udcpv=jGo80XhZg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 13 Sep 2019 16:47:32 -0700
Message-ID: <CAKywueT2mr1i3Y6iNQOzXEc1CePMozfvoJUz=TJAmbnskdofhw@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     James Wettenhall <james.wettenhall@monash.edu>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi James,

Thanks for providing this information.

The 5.0 kernel has the known bug when handling cached root handle
which may cause kernel to stuck like in your case.

In order to work around the problem for you, please mount with
"nohandlecache" mount option. This will turn off caching of the root
handle in the CIFS module and the problematic code path won't be
executed.

Please let us know if this solves the problem for you.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 3 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 23:47, James =
Wettenhall <james.wettenhall@monash.edu>:
>
> Hi Aur=C3=A9lien,
>
> The VMs become completely unresponsive, so we can't run commands in a
> separate shell.
>
> I've included a stack trace below.
>
> I'm considering trying the cache=3Dloose mount option.
>
> Cheers,
> James
>
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.616360] INFO: task
> dockerd:786 blocked for more than 120 seconds.
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.621073]       Not
> tainted 5.0.0-25-generic #26~18.04.1-Ubuntu
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.625436] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629464] dockerd
> D    0   786      1 0x00000000
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629467] Call Trace:
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629477]  __schedule+0x2bd/0=
x850
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629482]  ?
> __switch_to_asm+0x35/0x70
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629484]  schedule+0x2c/0x70
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629485]
> schedule_preempt_disabled+0xe/0x10
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629487]
> __mutex_lock.isra.9+0x183/0x4e0
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629488]  ?
> schedule_timeout+0x171/0x360
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629490]
> __mutex_lock_slowpath+0x13/0x20
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629491]  ?
> __mutex_lock_slowpath+0x13/0x20
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629492]  mutex_lock+0x2f/0x=
40
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629528]
> smb2_reconnect+0x106/0x7f0 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629531]  ? __switch_to+0x12=
3/0x4e0
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629533]  ?
> __switch_to_asm+0x35/0x70
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629537]  ?
> __switch_to_asm+0x41/0x70
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629540]  ? wait_woken+0x80/=
0x80
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629556]
> smb2_plain_req_init+0x34/0x270 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629577]
> SMB2_open_init+0x6d/0x730 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629595]
> SMB2_open+0x148/0x4f0 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629609]  ?
> SMB2_open+0x148/0x4f0 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629624]
> open_shroot+0x16c/0x210 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629637]  ?
> open_shroot+0x16c/0x210 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629654]
> smb2_query_path_info+0x11c/0x1b0 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629656]  ? _cond_resched+0x=
19/0x40
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629660]  ?
> kmem_cache_alloc_trace+0x151/0x1c0
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629673]
> cifs_get_inode_info+0x3e3/0xb70 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629685]  ?
> build_path_from_dentry_optional_prefix+0x103/0x430 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629699]
> cifs_revalidate_dentry_attr+0xe9/0x3d0 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629712]
> cifs_getattr+0x5d/0x1a0 [cifs]
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629715]  ?
> common_perm_cond+0x4c/0x70
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629719]
> vfs_getattr_nosec+0x73/0x90
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629720]  vfs_getattr+0x36/0=
x40
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629721]  vfs_statx+0x8d/0xe=
0
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629723]
> __do_sys_newlstat+0x3d/0x70
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629725]
> __x64_sys_newlstat+0x16/0x20
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629729]  do_syscall_64+0x5a=
/0x120
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629731]
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629734] RIP: 0033:0x55fd5a4=
b1e40
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629739] Code: Bad RIP value=
.
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629741] RSP:
> 002b:000000c421af6948 EFLAGS: 00000212 ORIG_RAX: 0000000000000006
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629742] RAX:
> ffffffffffffffda RBX: 0000000000000000 RCX: 000055fd5a4b1e40
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629743] RDX:
> 0000000000000000 RSI: 000000c421491488 RDI: 000000c4227a4060
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629743] RBP:
> 000000c421af69b0 R08: 0000000000000000 R09: 0000000000000000
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629744] R10:
> 0000000000000000 R11: 0000000000000212 R12: ffffffffffffffff
> Sep  4 13:36:36 prod-worker-1a kernel: [ 3384.629745] R13:
> 0000000000000002 R14: 0000000000000001 R15: 0000000000000055
