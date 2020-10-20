Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE542C4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 23:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 871BF22247
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 23:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emNnq7+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392469AbgJTXIJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 19:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390906AbgJTXIJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Oct 2020 19:08:09 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB69C0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 16:08:08 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h20so161159lji.9
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 16:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vUkrjwNtnK6MFgh2wnTv+W9rBayBLKOy4ZmSMKHsm04=;
        b=emNnq7+dUvxinuXWtLbN3BGxr3TjKr/quP+Eh/pLhzETPdk+OqVlW1Ak8i4vAzGtYD
         xhOK38Ku+mvVuRyvDcOHuKTguhgW61FCUB/aaq3T55jN3faUv2XUKfI+HZEmym0LJyfs
         w56lh2AqpMH09Ws0sTlpUIapCPkzdTdVeu7V3gOChAGE1bXGB9a6TCj9eG8YJVGRUJNE
         OdR5R4ywQ0klTLbzOtkI7pZJgstZybLSCoAxsu4HWoI4JCLJp/7B2+oUZe+QFlLeRQiF
         en4Fa0YExWzh0BsfTZ0WFNLZAmJ5dPj/FAXi0sQBqSJcd2mMm5HCOdbrUgFYKx68o+6n
         WgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vUkrjwNtnK6MFgh2wnTv+W9rBayBLKOy4ZmSMKHsm04=;
        b=p0PRQUmyvUcsMJDMtDpjWE9xsxcjRfv7GVTnKeyCJNTvU+8g1/P6F8CL81X66iL2K+
         nKxOY0VuZAH5s1p7pCerKQ1NFaC7S2PTw4Iw9JI5X8TMkRUHSGUvPJJctZ8GcMM7Epv2
         kP3Klc9TKsOQC9Mrb6s4Lv5I4p9tzMUr+ApnhaKY9BF/kw7fM+OUSl+lpQdjmrburwYC
         Kg3WfNiewT/SFRXgb30I92THPoYFfeUtgmuYID6i0H+Mw3mMGCvAGbgbAPpReyAw/v9u
         pcyidR8py1HeHvk8XSCFtp4AL+Q0kx7/lrgeR0908hEoT0oY2QbspBzycF+RWK7JubI/
         sHqg==
X-Gm-Message-State: AOAM533qNDBxxADn/mUq+IOe07LDr8M7vcFMz3sDHTPtMsoNavjERSvp
        OfdyFZG/9E/lusRVbCPb96DORw185P/fDbCoqYU=
X-Google-Smtp-Source: ABdhPJxydhZ1t/0NLnzPLfWM84WkEjX3XOlQogwJUQtI1SsQDxbT3q14a1kHQOIv1BSc5B/n1QoE+O/nwfT6uBZwgFU=
X-Received: by 2002:a2e:b0e4:: with SMTP id h4mr158467ljl.119.1603235286688;
 Tue, 20 Oct 2020 16:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <BYAPR16MB26151755ED24DE9F506736B8E21F0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAH2r5msFVeJMHR7RbRYKweo7FFdXW6Lk=4oQe57hfzrFu6KQGg@mail.gmail.com>
 <BYAPR16MB2615EF719B1D7BA80B3AF3E7E21F0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAH2r5muxToKcoe5-5sP_1_YQ2kZePAirFGX=EUjHxMCibPV9pA@mail.gmail.com> <BL0PR16MB2611A883EC51E4658156E233E21F0@BL0PR16MB2611.namprd16.prod.outlook.com>
In-Reply-To: <BL0PR16MB2611A883EC51E4658156E233E21F0@BL0PR16MB2611.namprd16.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Oct 2020 18:07:55 -0500
Message-ID: <CAH2r5muZE_9yqdUP6xYmZobyRD997scq+BhT_ZHn4deqa2aSEA@mail.gmail.com>
Subject: Re: Oops in _raw_spin_lock_irqsave - linux kernel 4.16.2-1.el7.elrepo.x86_64
To:     Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
Cc:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I do something like "git log --oneline v.4.19.. fs/cifs" from the root
of a recent kernel git tree.  You can also see them in the web GUI at
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/fs/c=
ifs
but it is more time consuming

On Tue, Oct 20, 2020 at 5:28 PM Vidhesh Ramesh
<vidhesh.ramesh@komprise.com> wrote:
>
> Thanks Steve.
>
> Where would I be able to see the 900 changesets so that i could see if th=
ere is anything that matches this. We are using centos distro and have seen=
 some of the fixes backported to 4.19 as it's Long term release kernel.
>
> Vidhesh Ramesh
>
>
> From: Steve French <smfrench@gmail.com>
> Sent: Tuesday, October 20, 2020 3:17 PM
> To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-c=
ifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@list=
s.samba.org>
> Subject: Re: Oops in _raw_spin_lock_irqsave - linux kernel 4.16.2-1.el7.e=
lrepo.x86_64
>
> 4.19 kernel is from 2018 so already a couple years old, and 4.16 is even =
older.  There are > 900 changesets in the kernel cifs.ko driver since 4.16 =
kernel so could be hard to identify - but if you distro is backporting fixe=
s well, you may be fine.   My general rule of thumb would be to encourage u=
se of 5.0 kernel or later given the large number of cifs.ko improvements.
>
> On Tue, Oct 20, 2020 at 3:50 PM Vidhesh Ramesh <vidhesh.ramesh@komprise.c=
om> wrote:
> Hi Steve,
>
> Thanks for the quick response.
>
> I haven't tried redhat 8.1 or 8.2, I have tried 4.19 kernel build 134 and=
 I am not seeing the same panic but not sure if it is fixed in kernel 4.19.
>
> Vidhesh Ramesh
>
>
>
>
>
>
> From: Steve French <smfrench@gmail.com>
> Sent: Tuesday, October 20, 2020 11:38 AM
> To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-c=
ifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@list=
s.samba.org>
> Subject: Re: Oops in _raw_spin_lock_irqsave - linux kernel 4.16.2-1.el7.e=
lrepo.x86_64
>
> I don't have a kernel that old and I can't access the Redhat page -
> but I would expect that given the date it was posted the fix would be
> in the last two Redhat releases 8.1 and 8.2.  Have you tried those?
>
> On Tue, Oct 20, 2020 at 12:49 AM Vidhesh Ramesh
> <vidhesh.ramesh@komprise.com> wrote:
> >
> > [1.] One line summary of the problem:
> > oops kernel panic
> > [2.] Full description of the problem/report:
> > ESX VM hangs with a kernel panic when cifs shares are mounted and acces=
sed. Unable to ssh to the VM and the console of the VM is also not respondi=
ng. With kdump service running and core collected the VM restarts successfu=
lly.
> > [3.] Keywords (i.e., modules, networking, kernel):
> > cifs, kernel, panic, mount
> > [4.] Kernel information
> > [4.1.] Kernel version (from /proc/version):
> > Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc ver=
sion 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 ED=
T 2018
> > [4.2.] Kernel .config file:
> > Please check the file uploaded
> > [5.] Most recent kernel version which did not have the bug:
> > [6.] Output of Oops.. message (if applicable) with symbolic information
> >      resolved (see Documentation/admin-guide/oops-tracing.rst)
> > [1866796.225242] BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000000
> > [1866796.225758] IP: _raw_spin_lock_irqsave+0x22/0x40
> > [1866796.226236] PGD 8000000428341067 P4D 8000000428341067 PUD 0
> > [1866796.226736] Oops: 0002 [#1] SMP PTI
> > [1866796.227202] Modules linked in: nfsv3 nfs fscache arc4 md4 nls_utf8=
 cifs ccm dns_resolver nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT=
 ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conn=
track ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack=
_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table=
_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_con=
ntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables =
ip6table_filter ip6_tables iptable_filter vmw_vsock_vmci_transport vsock pp=
dev sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc vmw_ball=
oon aesni_intel crypto_simd glue_helper cryptd intel_rapl_perf joydev input=
_leds pcspkr sg shpchp i2c_piix4 vmw_vmci parport_pc parport nfsd
> > [1866796.232074]  auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs =
libcrc32c sr_mod cdrom ata_generic pata_acpi sd_mod crc32c_intel serio_raw =
vmwgfx drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ata=
_piix mptspi scsi_transport_spi vmxnet3 mptscsih drm mptbase libata floppy =
dm_mirror dm_region_hash dm_log dm_mod dax
> > [1866796.234432] CPU: 3 PID: 11126 Comm: cifsd Tainted: G        W     =
   4.16.2-1.el7.elrepo.x86_64 #1
> > [1866796.235687] Hardware name: VMware, Inc. VMware Virtual Platform/44=
0BX Desktop Reference Platform, BIOS 6.00 12/12/2018
> > [1866796.237004] RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40
> > [1866796.237683] RSP: 0018:ffffc90007a2bc00 EFLAGS: 00010046
> > [1866796.238361] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 00000=
00000000002
> > [1866796.239049] RDX: 0000000000000001 RSI: ffffc90007a2bc40 RDI: 00000=
00000000000
> > [1866796.239757] RBP: ffffc90007a2bc08 R08: 0000000000000242 R09: 00000=
00000000000
> > [1866796.240494] R10: 0000000000000000 R11: 00000000000003c9 R12: 00000=
00000000000
> > [1866796.241194] R13: ffff88041b26f8c8 R14: ffffc90007a2bcf8 R15: 00000=
00000000000
> > [1866796.241915] FS:  0000000000000000(0000) GS:ffff88043fcc0000(0000) =
knlGS:0000000000000000
> > [1866796.242670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [1866796.243438] CR2: 0000000000000000 CR3: 000000042ab22000 CR4: 00000=
000000406e0
> > [1866796.244293] Call Trace:
> > [1866796.245069]  remove_wait_queue+0x19/0x60
> > [1866796.245877]  sk_wait_data+0xf6/0x140
> > [1866796.246691]  ? prepare_to_wait+0xb0/0xb0
> > [1866796.247504]  tcp_recvmsg+0x5f5/0xb40
> > [1866796.248560]  ? select_task_rq_fair+0x4d5/0xba0
> > [1866796.249420]  inet_recvmsg+0x56/0xd0
> > [1866796.250222]  sock_recvmsg+0x43/0x50
> > [1866796.251115]  cifs_readv_from_socket+0x76/0x200 [cifs]
> > [1866796.251953]  cifs_read_from_socket+0x52/0x70 [cifs]
> > [1866796.252969]  cifs_demultiplex_thread+0x11b/0xa90 [cifs]
> > [1866796.253740]  kthread+0x105/0x140
> > [1866796.254486]  ? cifs_handle_standard+0x190/0x190 [cifs]
> > [1866796.255198]  ? kthread_bind+0x20/0x20
> > [1866796.255907]  ? do_syscall_64+0x79/0x1b0
> > [1866796.256601]  ret_from_fork+0x35/0x40
> > [1866796.257251] Code: c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 =
89 e5 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01 00 =
00 00 <f0> 0f b1 17 85 c0 75 06 48 89 d8 5b 5d c3 89 c6 e8 36 91 8b ff
> > [1866796.259312] RIP: _raw_spin_lock_irqsave+0x22/0x40 RSP: ffffc90007a=
2bc00
> >
> > I see the solution posted in https://access.redhat.com/solutions/435447=
1 but I am unable to access the solution.
> >
> > Vidhesh Ramesh
> > [1866796.260111] CR2: 0000000000000000
> > [7.] A small shell script or example program which triggers the
> >      problem (if possible)
> >
> > Vidhesh Ramesh
>
>
>
> --
> Thanks,
>
> Steve
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
