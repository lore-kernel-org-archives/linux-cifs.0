Return-Path: <SRS0=KB7a=AZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0303DC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 17:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D14A322596
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 17:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLRNOned"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgGNRuE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jul 2020 13:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgGNRuE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jul 2020 13:50:04 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00852C061755
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2020 10:50:03 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id l19so8586494ybl.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2020 10:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OWaY5MHTaXN/3D8Hi4RZnIPs7SGYnk7DXecW7O28T8w=;
        b=kLRNOnedZAL7Kr/kyobw3OYCJQVH6pVHRqGc8LYEiVqf17H87CsMuOs78SMKXPmtPL
         b/Ph9x0sVZvkmg2MmQl7s5XcQVDP0xgKZCiaOkf8ZePx8El/G0pGJJHQBKEdb0AP8vz3
         bt8iApOWLx7CJakzoebEUWzr36xGRCXKKldi8zmnjuBZrcE+I446xgjzsvVp3H4y9Xot
         PC0wFwDRieocmSDibea5E29+E7r0l89WHHCqj++aHkaGXVf8E4heDjU+jFN5/HjYEfy9
         Mb+Ued5GC+Wt/zpJBfeYa93A9d5qcHLLtX5IFb5LoEL9w43BTjdLFkU/JKEp2sEvDqsM
         Uq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OWaY5MHTaXN/3D8Hi4RZnIPs7SGYnk7DXecW7O28T8w=;
        b=CGIcxtEcN175vNOqQUU/Ghfrc3w9BySVpjIW9KQSYTficIc/3BM0l6VuLPRRFS5Rt+
         iMDfsjNMhLsxo44miBsNDl4CQuw5TYrMXI9M+H0GzGmJLgWO1yeaS4hsWqeZ7QG7bTsN
         c1pdkqPLwH4Y+AFzBZ0kAj6j7Otq6kJ9unzyrU7Tj/s1wvuG/9jUVmv3qkGiulgCvtEy
         vKue6Tje3J1lt09jB5LIrv2WBdY3/n+rE35OdlYw9BiZNdvqIYHF6jlX5GeCNRXndkD1
         tkemm+j9y26QpWJtnu6pGSbxzm9SCUeIVxoNHcSZfY8/mJKxzCdzPfoLdBquWWyJmf+u
         vhMA==
X-Gm-Message-State: AOAM533rLrsmbqBVYlUXR9OsKbirR6pfpq3PrhoPoZvWUDUS8T9lZlP2
        nkBsvmS0k1Ue95Bx5V3Pn5u9cLZgRPnIEGY/wbU=
X-Google-Smtp-Source: ABdhPJyfjadp0wgSb6GHD395YOBJT2Y1LUPl/z4v1Eaua7i6lM65RaRkYUO6E9e5wa5fsQUWtB1riURnFIoLfs11l78=
X-Received: by 2002:a25:56c3:: with SMTP id k186mr9894525ybb.183.1594749003124;
 Tue, 14 Jul 2020 10:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <MW3PR16MB37063A82C9A57CC67EB5BE1F87920@MW3PR16MB3706.namprd16.prod.outlook.com>
 <BYAPR16MB26152FB66647DB8FCAED346CE26D0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAA_-hQJuAnELV+DKhst9iwyC_x7-CDkRKjneTFHgUcM3DSb2gQ@mail.gmail.com>
In-Reply-To: <CAA_-hQJuAnELV+DKhst9iwyC_x7-CDkRKjneTFHgUcM3DSb2gQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Jul 2020 12:49:52 -0500
Message-ID: <CAH2r5ms3567LG2rNiTDJgykuu3F8916VH2tjJOXnk+FMRC3giQ@mail.gmail.com>
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.x86_64
To:     Kenneth Dsouza <kdsouza@redhat.com>
Cc:     Vidhesh Ramesh <vidhesh.ramesh@komprise.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If you have a particular stable kernel used for your distro you can
email stable@vger.kernel.org with the commit id and version you want
it backported for.

On Tue, Jul 14, 2020 at 12:43 PM Kenneth Dsouza <kdsouza@redhat.com> wrote:
>
> You are hitting a known bug which has been fixed by below patch and is
> part of v5.6 and above.
>
> commit fe1292686333d1dadaf84091f585ee903b9ddb84
> Author: Ronnie Sahlberg <lsahlber@redhat.com>
> Date:   Wed Jan 22 11:07:56 2020 +1000
>
>     cifs: fix NULL dereference in match_prepath
>
>     RHBZ: 1760879
>
>     Fix an oops in match_prepath() by making sure that the prepath string=
 is not
>     NULL before we pass it into strcmp().
>
>     This is similar to other checks we make for example in cifs_root_iget=
()
>
>     Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> On Tue, Jul 14, 2020 at 11:05 PM Vidhesh Ramesh
> <vidhesh.ramesh@komprise.com> wrote:
> >
> > Adding linux-cifs mailing list.
> >
> > Vidhesh Ramesh
> >
> >
> > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> > Sent: Tuesday, July 14, 2020 10:18 AM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux=
-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@li=
sts.samba.org>
> > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elr=
epo.x86_64
> >
> > Hi Steve et all,
> >
> > Resending this as a gentle reminder if anyone got a chance to look at t=
he below mentioned oops kernel panic.
> >
> >
> > Vidhesh Ramesh
> >
> >
> > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> > Sent: Thursday, July 2, 2020 12:21 AM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux=
-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@li=
sts.samba.org>
> > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elr=
epo.x86_64
> >
> > Hi Steve et all,
> >
> > Resending this as a gentle reminder if anyone got a chance to look at t=
he below mentioned oops kernel panic.
> >
> > Vidhesh Ramesh
> >
> >
> >
> >
> >
> >
> >
> > From: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> > Sent: Wednesday, June 24, 2020 10:26 PM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux=
-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@li=
sts.samba.org>
> > Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> > Subject: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64
> >
> > Hi Steve et al,
> >    My name is Ameya and I work for www.komprise.com.  The linux kernel =
with above mentioned version has been panicing, though randomly, but the st=
ack trace appears is consistent.  You can find more details in the attachme=
nts.  Below is the brief description of the problem -
> >
> > [1.] One line summary of the problem:
> > oops kernel panic
> > [2.] Full description of the problem/report:
> > ESX VM hangs with a kernel panic when cifs shares are mounted. Unable t=
o ssh to the VM and the console of the VM is also not responding. With kdum=
p service running and core collected the VM restarts successfully.
> > [3.] Keywords (i.e., modules, networking, kernel):
> > cifs, kernel, panic, strcmp, mount
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
> > [442282.069937] BUG: unable to handle kernel NULL pointer dereference a=
t 0000000000000000
> > [442282.071474] IP: strcmp+0xe/0x30
> > [442282.072892] PGD 0 P4D 0
> > [442282.074196] Oops: 0000 [#1] SMP PTI
> > [442282.075561] Modules linked in: binfmt_misc fuse cmac rpcsec_gss_krb=
5 nfsv4 arc4 md4 nls_utf8 cifs ccm dns_resolver nfsv3 nfs fscache nf_conntr=
ack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ipt_REJECT nf_rej=
ect_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_n=
at ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6=
 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ip=
v4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_se=
curity iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptab=
le_filter vmw_vsock_vmci_transport vsock sb_edac crct10dif_pclmul crc32_pcl=
mul ghash_clmulni_intel pcbc ppdev aesni_intel vmw_balloon crypto_simd glue=
_helper cryptd sg intel_rapl_perf input_leds pcspkr joydev shpchp
> > [442282.090386]  parport_pc parport i2c_piix4 vmw_vmci nfsd nfs_acl loc=
kd auth_rpcgss grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom ata_generi=
c sd_mod pata_acpi crc32c_intel serio_raw vmwgfx drm_kms_helper syscopyarea=
 sysfillrect sysimgblt fb_sys_fops ttm mptspi scsi_transport_spi ata_piix m=
ptscsih vmxnet3 drm mptbase libata floppy dm_mirror dm_region_hash dm_log d=
m_mod dax
> > [442282.095332] CPU: 4 PID: 9273 Comm: mount.cifs Tainted: G        W  =
      4.16.2-1.el7.elrepo.x86_64 #1
> > [442282.097802] Hardware name: VMware, Inc. VMware Virtual Platform/440=
BX Desktop Reference Platform, BIOS 6.00 04/05/2016
> > [442282.100363] RIP: 0010:strcmp+0xe/0x30
> > [442282.101645] RSP: 0018:ffffc9001bff7c88 EFLAGS: 00010202
> > [442282.102919] RAX: 0000000000000001 RBX: ffff8802ad7c2400 RCX: 000000=
0001240404
> > [442282.104207] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000000=
0000000001
> > [442282.105497] RBP: ffffc9001bff7c88 R08: 0000000001240404 R09: 000000=
0000000001
> > [442282.106765] R10: ffff88017d2c2b40 R11: ffff8801744c0e50 R12: ffff88=
011f793000
> > [442282.108038] R13: ffff88042b105800 R14: ffffc9001bff7d98 R15: ffff88=
01b63c0f00
> > [442282.109318] FS:  00007f3e90ee6780(0000) GS:ffff88043fd00000(0000) k=
nlGS:0000000000000000
> > [442282.110630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [442282.111970] CR2: 0000000000000000 CR3: 000000011b2ea000 CR4: 000000=
00000406e0
> > [442282.113405] Call Trace:
> > [442282.114849]  cifs_match_super+0x123/0x210 [cifs]
> > [442282.116211]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]
> > [442282.117541]  sget_userns+0x88/0x4a0
> > [442282.118877]  ? cifs_kill_sb+0x30/0x30 [cifs]
> > [442282.120203]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]
> > [442282.121502]  sget+0x7d/0xa0
> > [442282.122781]  ? cifs_kill_sb+0x30/0x30 [cifs]
> > [442282.124072]  cifs_do_mount+0x168/0x5a0 [cifs]
> > [442282.125364]  mount_fs+0x3e/0x150
> > [442282.126627]  vfs_kern_mount+0x67/0x130
> > [442282.127850]  do_mount+0x1f5/0xca0
> > [442282.129047]  SyS_mount+0x83/0xd0
> > [442282.130257]  do_syscall_64+0x79/0x1b0
> > [442282.131583]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > [442282.132687] RIP: 0033:0x7f3e907fdfea
> > [442282.133754] RSP: 002b:00007ffee9139868 EFLAGS: 00000202 ORIG_RAX: 0=
0000000000000a5
> > [442282.134842] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f=
3e907fdfea
> > [442282.135909] RDX: 000055d13f5953b2 RSI: 000055d13f5953f9 RDI: 00007f=
fee913bb51
> > [442282.136944] RBP: 00007ffee913bb46 R08: 000055d1415e80d0 R09: 000000=
0000001000
> > [442282.137962] R10: 0000000000000000 R11: 0000000000000202 R12: 00007f=
3e90ef0000
> > [442282.138957] R13: 000055d1415e80d0 R14: 00007f3e90ef290f R15: 000000=
0000000000
> > [442282.139918] Code: 80 3a 00 75 f7 48 83 c6 01 0f b6 4e ff 48 83 c2 0=
1 84 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 84 c0 74 18 48 83 c=
7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 31
> > [442282.142829] RIP: strcmp+0xe/0x30 RSP: ffffc9001bff7c88
> > [442282.143759] CR2: 0000000000000000
> > [7.] A small shell script or example program which triggers the
> >      problem (if possible)
> >
> > My colleague Vidhesh (CC'ed) will be glad to share further details on t=
he test scenario and/or in-house reproduction.  Please let us know of worka=
rounds, if any.
> >
> > Thanks and Regards,
> > =3D Ameya
> >
> >
> >
>


--=20
Thanks,

Steve
