Return-Path: <SRS0=KB7a=AZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F04C433E1
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 17:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC3F022518
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 17:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DoPwXQRO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGNRmp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jul 2020 13:42:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbgGNRmp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Jul 2020 13:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594748562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eHH90yzsAJ4M7oDyw0rL/h4ZASg7aGTxH0D5pq4QExY=;
        b=DoPwXQROKSsp+cO15L2udeXN4k/0YXM+siaBQyMFnBpYJZbtWOzqnPu+7+yU5T8+sKXOSv
        K/KhHYm4QnZtddcemHEFMwnkr2uWt8Og8YBDDeyabTPuPbYmrsGMgR023v8hk2CO6pir9+
        j8M5T9ykW2x8zvoYdnIHifqqctyfopE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-6mZ7KHxYNVO2sR356aeTyQ-1; Tue, 14 Jul 2020 13:42:35 -0400
X-MC-Unique: 6mZ7KHxYNVO2sR356aeTyQ-1
Received: by mail-qk1-f198.google.com with SMTP id k1so13609627qko.14
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2020 10:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eHH90yzsAJ4M7oDyw0rL/h4ZASg7aGTxH0D5pq4QExY=;
        b=Z+TtLY6lWOnmTfGd7zO+7UpLb/9NN6wBwj4ZyZFqaerWxjkLDShx2j2Zxyw9vIc4xj
         OErdlEMVj6fG0rGdQaT6AQrGm8O2t+4GVlNaGUzeezXQ1Kf/lJcQwfqgjTBlN6jF6iHq
         xDoFZiI9cmP1tmXIRVKj245hdpqSHd89LCoCC9DZilnxBs9nOFRo3k8BueTgnpbDT5Wg
         kUF/hzLU31dTf9Pkp8B+HdoRFIojvdagwfwbAWwizhhsAMwgo3ACrA7zWfeZzzJgaESM
         5LMxw6Aj/08i6HY0u80CASIjiau2gaQZoGMvN6OudUd7j45b72YkwG35XOrLI3VhPbLP
         2pWg==
X-Gm-Message-State: AOAM532qPX+MeMYS+FHR3OzJcb0j/jDJgzfKh+M3uwbpoPEnpO2pHxcm
        3NOkTdFnT5d0e3Fy5N/tVopSCSX4RXoYZe/dG3ckN0aXmuK1guFiJO5ifzLNceO++H+mPMHgj0b
        mmv1J6kpykj10vLm5mqbOKd4t3FaHM3PelKNHHw==
X-Received: by 2002:ac8:430b:: with SMTP id z11mr5860430qtm.73.1594748554467;
        Tue, 14 Jul 2020 10:42:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyV6iwUaUQhb19fkfEVQhREsvAMZKuSPW4LFNGXb59J3nVPsg2+WVewwS9jXZN+PKUyAjbEROIU3SwQjWn6cuY=
X-Received: by 2002:ac8:430b:: with SMTP id z11mr5860399qtm.73.1594748554106;
 Tue, 14 Jul 2020 10:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <MW3PR16MB37063A82C9A57CC67EB5BE1F87920@MW3PR16MB3706.namprd16.prod.outlook.com>
 <BYAPR16MB26152FB66647DB8FCAED346CE26D0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Tue, 14 Jul 2020 23:12:22 +0530
Message-ID: <CAA_-hQJuAnELV+DKhst9iwyC_x7-CDkRKjneTFHgUcM3DSb2gQ@mail.gmail.com>
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.x86_64
To:     Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

You are hitting a known bug which has been fixed by below patch and is
part of v5.6 and above.

commit fe1292686333d1dadaf84091f585ee903b9ddb84
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Wed Jan 22 11:07:56 2020 +1000

    cifs: fix NULL dereference in match_prepath

    RHBZ: 1760879

    Fix an oops in match_prepath() by making sure that the prepath string i=
s not
    NULL before we pass it into strcmp().

    This is similar to other checks we make for example in cifs_root_iget()

    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

On Tue, Jul 14, 2020 at 11:05 PM Vidhesh Ramesh
<vidhesh.ramesh@komprise.com> wrote:
>
> Adding linux-cifs mailing list.
>
> Vidhesh Ramesh
>
>
> From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> Sent: Tuesday, July 14, 2020 10:18 AM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-c=
ifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@list=
s.samba.org>
> Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64
>
> Hi Steve et all,
>
> Resending this as a gentle reminder if anyone got a chance to look at the=
 below mentioned oops kernel panic.
>
>
> Vidhesh Ramesh
>
>
> From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> Sent: Thursday, July 2, 2020 12:21 AM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-c=
ifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@list=
s.samba.org>
> Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64
>
> Hi Steve et all,
>
> Resending this as a gentle reminder if anyone got a chance to look at the=
 below mentioned oops kernel panic.
>
> Vidhesh Ramesh
>
>
>
>
>
>
>
> From: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> Sent: Wednesday, June 24, 2020 10:26 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-c=
ifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@list=
s.samba.org>
> Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> Subject: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.x8=
6_64
>
> Hi Steve et al,
>    My name is Ameya and I work for www.komprise.com.  The linux kernel wi=
th above mentioned version has been panicing, though randomly, but the stac=
k trace appears is consistent.  You can find more details in the attachment=
s.  Below is the brief description of the problem -
>
> [1.] One line summary of the problem:
> oops kernel panic
> [2.] Full description of the problem/report:
> ESX VM hangs with a kernel panic when cifs shares are mounted. Unable to =
ssh to the VM and the console of the VM is also not responding. With kdump =
service running and core collected the VM restarts successfully.
> [3.] Keywords (i.e., modules, networking, kernel):
> cifs, kernel, panic, strcmp, mount
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version):
> Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc versi=
on 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 EDT =
2018
> [4.2.] Kernel .config file:
> Please check the file uploaded
> [5.] Most recent kernel version which did not have the bug:
> [6.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/admin-guide/oops-tracing.rst)
> [442282.069937] BUG: unable to handle kernel NULL pointer dereference at =
0000000000000000
> [442282.071474] IP: strcmp+0xe/0x30
> [442282.072892] PGD 0 P4D 0
> [442282.074196] Oops: 0000 [#1] SMP PTI
> [442282.075561] Modules linked in: binfmt_misc fuse cmac rpcsec_gss_krb5 =
nfsv4 arc4 md4 nls_utf8 cifs ccm dns_resolver nfsv3 nfs fscache nf_conntrac=
k_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ipt_REJECT nf_rejec=
t_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat=
 ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 i=
p6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4=
 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_secu=
rity iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable=
_filter vmw_vsock_vmci_transport vsock sb_edac crct10dif_pclmul crc32_pclmu=
l ghash_clmulni_intel pcbc ppdev aesni_intel vmw_balloon crypto_simd glue_h=
elper cryptd sg intel_rapl_perf input_leds pcspkr joydev shpchp
> [442282.090386]  parport_pc parport i2c_piix4 vmw_vmci nfsd nfs_acl lockd=
 auth_rpcgss grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom ata_generic =
sd_mod pata_acpi crc32c_intel serio_raw vmwgfx drm_kms_helper syscopyarea s=
ysfillrect sysimgblt fb_sys_fops ttm mptspi scsi_transport_spi ata_piix mpt=
scsih vmxnet3 drm mptbase libata floppy dm_mirror dm_region_hash dm_log dm_=
mod dax
> [442282.095332] CPU: 4 PID: 9273 Comm: mount.cifs Tainted: G        W    =
    4.16.2-1.el7.elrepo.x86_64 #1
> [442282.097802] Hardware name: VMware, Inc. VMware Virtual Platform/440BX=
 Desktop Reference Platform, BIOS 6.00 04/05/2016
> [442282.100363] RIP: 0010:strcmp+0xe/0x30
> [442282.101645] RSP: 0018:ffffc9001bff7c88 EFLAGS: 00010202
> [442282.102919] RAX: 0000000000000001 RBX: ffff8802ad7c2400 RCX: 00000000=
01240404
> [442282.104207] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000=
00000001
> [442282.105497] RBP: ffffc9001bff7c88 R08: 0000000001240404 R09: 00000000=
00000001
> [442282.106765] R10: ffff88017d2c2b40 R11: ffff8801744c0e50 R12: ffff8801=
1f793000
> [442282.108038] R13: ffff88042b105800 R14: ffffc9001bff7d98 R15: ffff8801=
b63c0f00
> [442282.109318] FS:  00007f3e90ee6780(0000) GS:ffff88043fd00000(0000) knl=
GS:0000000000000000
> [442282.110630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [442282.111970] CR2: 0000000000000000 CR3: 000000011b2ea000 CR4: 00000000=
000406e0
> [442282.113405] Call Trace:
> [442282.114849]  cifs_match_super+0x123/0x210 [cifs]
> [442282.116211]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]
> [442282.117541]  sget_userns+0x88/0x4a0
> [442282.118877]  ? cifs_kill_sb+0x30/0x30 [cifs]
> [442282.120203]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]
> [442282.121502]  sget+0x7d/0xa0
> [442282.122781]  ? cifs_kill_sb+0x30/0x30 [cifs]
> [442282.124072]  cifs_do_mount+0x168/0x5a0 [cifs]
> [442282.125364]  mount_fs+0x3e/0x150
> [442282.126627]  vfs_kern_mount+0x67/0x130
> [442282.127850]  do_mount+0x1f5/0xca0
> [442282.129047]  SyS_mount+0x83/0xd0
> [442282.130257]  do_syscall_64+0x79/0x1b0
> [442282.131583]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [442282.132687] RIP: 0033:0x7f3e907fdfea
> [442282.133754] RSP: 002b:00007ffee9139868 EFLAGS: 00000202 ORIG_RAX: 000=
00000000000a5
> [442282.134842] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3e=
907fdfea
> [442282.135909] RDX: 000055d13f5953b2 RSI: 000055d13f5953f9 RDI: 00007ffe=
e913bb51
> [442282.136944] RBP: 00007ffee913bb46 R08: 000055d1415e80d0 R09: 00000000=
00001000
> [442282.137962] R10: 0000000000000000 R11: 0000000000000202 R12: 00007f3e=
90ef0000
> [442282.138957] R13: 000055d1415e80d0 R14: 00007f3e90ef290f R15: 00000000=
00000000
> [442282.139918] Code: 80 3a 00 75 f7 48 83 c6 01 0f b6 4e ff 48 83 c2 01 =
84 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 84 c0 74 18 48 83 c7 =
01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 31
> [442282.142829] RIP: strcmp+0xe/0x30 RSP: ffffc9001bff7c88
> [442282.143759] CR2: 0000000000000000
> [7.] A small shell script or example program which triggers the
>      problem (if possible)
>
> My colleague Vidhesh (CC'ed) will be glad to share further details on the=
 test scenario and/or in-house reproduction.  Please let us know of workaro=
unds, if any.
>
> Thanks and Regards,
> =3D Ameya
>
>
>

