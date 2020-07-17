Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F31DC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 21:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136F4207EA
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 21:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFCJv7KY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgGQVe0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQVe0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jul 2020 17:34:26 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1E5C0619D2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 14:34:25 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a11so8569132ilk.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 14:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Eax2T9tAMeMcwlGP/X2Ab29yPQMk6xra7oDReUFEqEI=;
        b=nFCJv7KY5uvNM/6CQmc5ofE0Fg/hTLVfbuWxM3fcNa5Et13dJKvq+WM1C/X9bs9Nvy
         Wh393F6KWaxF37R3AbwMh5Zrl92Ks/F50/zAsPYlofREYl463njU+/dKF+l0pO3n5BWI
         Gqlv6DD/pEGO/0Qb2IV68jTtrixVnF0qlc855y9zB9o86jzBQTEtJvseh3v3knWpLT1f
         DfWpZBkUcJjRfKWoDVkQL+tQkTkSeshGCuMcmw/R+yTklkyVWh/kQgCj9b7OtAPwO+rM
         5IOuPYML8WqXRSIkumNg8JitBL2971sqpWj5flkOkBkNPnxQNH2LWn+02JbIfuWByqgI
         57Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Eax2T9tAMeMcwlGP/X2Ab29yPQMk6xra7oDReUFEqEI=;
        b=ZsSl14EnCqR1s70R0C3F21B+wU3WOgKS6jbwai1h+30HWcTSn86ceAFaud7s8mJvO4
         FMP4CrFcQt5DGrCWnYBeROh0ExAwuY24MRNwyDlxSrnG/unbgpfmVjI+Lz0/zMTxx7K2
         O91z0wFgQ9nGp9A+c9GhtUXnoQxMGBoMP3KLwdiZz7lr/KYa1OVhCRNtusauOmWSU9Mx
         HZbgWnyH90WtxP6JZifWSc6dJ8hRPxjQOu2QqGlcdwnEabA+1MvxQ5d531WtJJY64br5
         s0Yu+daQAXfqyvXeiBrF6p5vr+lNaZVpPtTAN6jR0MwnzC6EZXEKDoU7gAovlRudpzfH
         wMuQ==
X-Gm-Message-State: AOAM533yg2TNMWskeCwxsbeEi+vc+H08BW9/qWa205SlLQRRd1x7h42C
        zLJPCCNDejkhU3uKWZjkpOmmxHtRl1ZMbWL7xYbiRDlhwAE=
X-Google-Smtp-Source: ABdhPJxoXcTq/+ob7of5YIuZuCJtyHQkzfji8P4gUJr/zm7wdbWmap7DpJ3g+DIb3uaL+dLNHIZAxd/Z1AiFDi6FxRo=
X-Received: by 2002:a05:6e02:50:: with SMTP id i16mr11950406ilr.173.1595021664932;
 Fri, 17 Jul 2020 14:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <MW3PR16MB37063A82C9A57CC67EB5BE1F87920@MW3PR16MB3706.namprd16.prod.outlook.com>
 <BYAPR16MB26152FB66647DB8FCAED346CE26D0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAA_-hQJuAnELV+DKhst9iwyC_x7-CDkRKjneTFHgUcM3DSb2gQ@mail.gmail.com>
 <CAH2r5ms3567LG2rNiTDJgykuu3F8916VH2tjJOXnk+FMRC3giQ@mail.gmail.com>
 <BYAPR16MB26156E99DAEAC5AB16C644A0E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAH2r5ms2jsH2ka-9SAaN8v61YL16jN401uEDZJ7Uo0H0pLtH7g@mail.gmail.com> <BYAPR16MB261559669B8ECAB936C7E4C5E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB261559669B8ECAB936C7E4C5E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Jul 2020 16:34:13 -0500
Message-ID: <CAH2r5mvga0dYpsuUv+geTBeoT+pro1yo8b-1K936KN9W3j=D5Q@mail.gmail.com>
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.x86_64
To:     Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
Cc:     Kenneth Dsouza <kdsouza@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

At least it is very easy to build cifs.ko out of tree for old distros
that don't keep up to date with stable patches (e.g. something similar
to: cd into fs/cifs directory then "make C=3D1 -C
/usr/src/linux-headers-`uname -r` M=3D`pwd` modules") ... assuming you
can get src rpms for your distro version for the kernel.

On Fri, Jul 17, 2020 at 4:23 PM Vidhesh Ramesh
<vidhesh.ramesh@komprise.com> wrote:
>
> Thanks Steve.
> We have few more bug fixes that we need in 4.19 LT kernel. However I am u=
nable to get a built kernel RPM of latest build 133 of kernel 4.19.
> The latest I could get is build 113 of kernel 4.19 at https://buildlogs.c=
entos.org/c7-kernels.x86_64/kernel/20200330213326/4.19.113-300.el8.x86_64/k=
ernel-4.19.113-300.el7.x86_64.rpm
>
> Vidhesh Ramesh
>
> From: Steve French <smfrench@gmail.com>
> Sent: Friday, July 17, 2020 7:05 AM
> To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> Cc: Kenneth Dsouza <kdsouza@redhat.com>; CIFS <linux-cifs@vger.kernel.org=
>
> Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64
>
> I am not familiar with your distro but a Google search matched on this as=
 a more recent kernel rpm download with similar sounding name http://lists.=
elrepo.org/pipermail/elrepo/2018-May/004282.html
>
> But there should be more recent kernels than that are eg based on newer 4=
.6.18 stable branch https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git/log/?h=3Dlinux-4.16.y
>
> On Fri, Jul 17, 2020, 04:12 Vidhesh Ramesh <vidhesh.ramesh@komprise.com> =
wrote:
> Thanks Steve and Kenneth for your responses.
>
> I did look at the commits and found that this has been fixed in a patch o=
f 4.19. Is there an archive where I can download latest 4.19 kernel rpm so =
that I can verify the fix ?
>
> Vidhesh Ramesh
>
>
>
>
>
>
> From: Steve French <smfrench@gmail.com>
> Sent: Tuesday, July 14, 2020 10:49 AM
> To: Kenneth Dsouza <kdsouza@redhat.com>
> Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>; linux-cifs@vger.kernel.=
org <linux-cifs@vger.kernel.org>
> Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64
>
> If you have a particular stable kernel used for your distro you can
> email stable@vger.kernel.org with the commit id and version you want
> it backported for.
>
> On Tue, Jul 14, 2020 at 12:43 PM Kenneth Dsouza <kdsouza@redhat.com> wrot=
e:
> >
> > You are hitting a known bug which has been fixed by below patch and is
> > part of v5.6 and above.
> >
> > commit fe1292686333d1dadaf84091f585ee903b9ddb84
> > Author: Ronnie Sahlberg <lsahlber@redhat.com>
> > Date:   Wed Jan 22 11:07:56 2020 +1000
> >
> >     cifs: fix NULL dereference in match_prepath
> >
> >     RHBZ: 1760879
> >
> >     Fix an oops in match_prepath() by making sure that the prepath stri=
ng is not
> >     NULL before we pass it into strcmp().
> >
> >     This is similar to other checks we make for example in cifs_root_ig=
et()
> >
> >     Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >     Signed-off-by: Steve French <stfrench@microsoft.com>
> >
> > On Tue, Jul 14, 2020 at 11:05 PM Vidhesh Ramesh
> > <vidhesh.ramesh@komprise.com> wrote:
> > >
> > > Adding linux-cifs mailing list.
> > >
> > > Vidhesh Ramesh
> > >
> > >
> > > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> > > Sent: Tuesday, July 14, 2020 10:18 AM
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <lin=
ux-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@=
lists.samba.org>
> > > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> > > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.e=
lrepo.x86_64
> > >
> > > Hi Steve et all,
> > >
> > > Resending this as a gentle reminder if anyone got a chance to look at=
 the below mentioned oops kernel panic.
> > >
> > >
> > > Vidhesh Ramesh
> > >
> > >
> > > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> > > Sent: Thursday, July 2, 2020 12:21 AM
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <lin=
ux-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@=
lists.samba.org>
> > > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> > > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.e=
lrepo.x86_64
> > >
> > > Hi Steve et all,
> > >
> > > Resending this as a gentle reminder if anyone got a chance to look at=
 the below mentioned oops kernel panic.
> > >
> > > Vidhesh Ramesh
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > From: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>
> > > Sent: Wednesday, June 24, 2020 10:26 PM
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <lin=
ux-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@=
lists.samba.org>
> > > Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
> > > Subject: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64
> > >
> > > Hi Steve et al,
> > >    My name is Ameya and I work for www.komprise.com.  The linux kerne=
l with above mentioned version has been panicing, though randomly, but the =
stack trace appears is consistent.  You can find more details in the attach=
ments.  Below is the brief description of the problem -
> > >
> > > [1.] One line summary of the problem:
> > > oops kernel panic
> > > [2.] Full description of the problem/report:
> > > ESX VM hangs with a kernel panic when cifs shares are mounted. Unable=
 to ssh to the VM and the console of the VM is also not responding. With kd=
ump service running and core collected the VM restarts successfully.
> > > [3.] Keywords (i.e., modules, networking, kernel):
> > > cifs, kernel, panic, strcmp, mount
> > > [4.] Kernel information
> > > [4.1.] Kernel version (from /proc/version):
> > > Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc v=
ersion 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 =
EDT 2018
> > > [4.2.] Kernel .config file:
> > > Please check the file uploaded
> > > [5.] Most recent kernel version which did not have the bug:
> > > [6.] Output of Oops.. message (if applicable) with symbolic informati=
on
> > >      resolved (see Documentation/admin-guide/oops-tracing.rst)
> > > [442282.069937] BUG: unable to handle kernel NULL pointer dereference=
 at 0000000000000000
> > > [442282.071474] IP: strcmp+0xe/0x30
> > > [442282.072892] PGD 0 P4D 0
> > > [442282.074196] Oops: 0000 [#1] SMP PTI
> > > [442282.075561] Modules linked in: binfmt_misc fuse cmac rpcsec_gss_k=
rb5 nfsv4 arc4 md4 nls_utf8 cifs ccm dns_resolver nfsv3 nfs fscache nf_conn=
track_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ipt_REJECT nf_r=
eject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable=
_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ip=
v6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_=
ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_=
security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables ipt=
able_filter vmw_vsock_vmci_transport vsock sb_edac crct10dif_pclmul crc32_p=
clmul ghash_clmulni_intel pcbc ppdev aesni_intel vmw_balloon crypto_simd gl=
ue_helper cryptd sg intel_rapl_perf input_leds pcspkr joydev shpchp
> > > [442282.090386]  parport_pc parport i2c_piix4 vmw_vmci nfsd nfs_acl l=
ockd auth_rpcgss grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom ata_gene=
ric sd_mod pata_acpi crc32c_intel serio_raw vmwgfx drm_kms_helper syscopyar=
ea sysfillrect sysimgblt fb_sys_fops ttm mptspi scsi_transport_spi ata_piix=
 mptscsih vmxnet3 drm mptbase libata floppy dm_mirror dm_region_hash dm_log=
 dm_mod dax
> > > [442282.095332] CPU: 4 PID: 9273 Comm: mount.cifs Tainted: G        W=
        4.16.2-1.el7.elrepo.x86_64 #1
> > > [442282.097802] Hardware name: VMware, Inc. VMware Virtual Platform/4=
40BX Desktop Reference Platform, BIOS 6.00 04/05/2016
> > > [442282.100363] RIP: 0010:strcmp+0xe/0x30
> > > [442282.101645] RSP: 0018:ffffc9001bff7c88 EFLAGS: 00010202
> > > [442282.102919] RAX: 0000000000000001 RBX: ffff8802ad7c2400 RCX: 0000=
000001240404
> > > [442282.104207] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000=
000000000001
> > > [442282.105497] RBP: ffffc9001bff7c88 R08: 0000000001240404 R09: 0000=
000000000001
> > > [442282.106765] R10: ffff88017d2c2b40 R11: ffff8801744c0e50 R12: ffff=
88011f793000
> > > [442282.108038] R13: ffff88042b105800 R14: ffffc9001bff7d98 R15: ffff=
8801b63c0f00
> > > [442282.109318] FS:  00007f3e90ee6780(0000) GS:ffff88043fd00000(0000)=
 knlGS:0000000000000000
> > > [442282.110630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [442282.111970] CR2: 0000000000000000 CR3: 000000011b2ea000 CR4: 0000=
0000000406e0
> > > [442282.113405] Call Trace:
> > > [442282.114849]  cifs_match_super+0x123/0x210 [cifs]
> > > [442282.116211]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]
> > > [442282.117541]  sget_userns+0x88/0x4a0
> > > [442282.118877]  ? cifs_kill_sb+0x30/0x30 [cifs]
> > > [442282.120203]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]
> > > [442282.121502]  sget+0x7d/0xa0
> > > [442282.122781]  ? cifs_kill_sb+0x30/0x30 [cifs]
> > > [442282.124072]  cifs_do_mount+0x168/0x5a0 [cifs]
> > > [442282.125364]  mount_fs+0x3e/0x150
> > > [442282.126627]  vfs_kern_mount+0x67/0x130
> > > [442282.127850]  do_mount+0x1f5/0xca0
> > > [442282.129047]  SyS_mount+0x83/0xd0
> > > [442282.130257]  do_syscall_64+0x79/0x1b0
> > > [442282.131583]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > > [442282.132687] RIP: 0033:0x7f3e907fdfea
> > > [442282.133754] RSP: 002b:00007ffee9139868 EFLAGS: 00000202 ORIG_RAX:=
 00000000000000a5
> > > [442282.134842] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000=
7f3e907fdfea
> > > [442282.135909] RDX: 000055d13f5953b2 RSI: 000055d13f5953f9 RDI: 0000=
7ffee913bb51
> > > [442282.136944] RBP: 00007ffee913bb46 R08: 000055d1415e80d0 R09: 0000=
000000001000
> > > [442282.137962] R10: 0000000000000000 R11: 0000000000000202 R12: 0000=
7f3e90ef0000
> > > [442282.138957] R13: 000055d1415e80d0 R14: 00007f3e90ef290f R15: 0000=
000000000000
> > > [442282.139918] Code: 80 3a 00 75 f7 48 83 c6 01 0f b6 4e ff 48 83 c2=
 01 84 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 84 c0 74 18 48 83=
 c7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 31
> > > [442282.142829] RIP: strcmp+0xe/0x30 RSP: ffffc9001bff7c88
> > > [442282.143759] CR2: 0000000000000000
> > > [7.] A small shell script or example program which triggers the
> > >      problem (if possible)
> > >
> > > My colleague Vidhesh (CC'ed) will be glad to share further details on=
 the test scenario and/or in-house reproduction.  Please let us know of wor=
karounds, if any.
> > >
> > > Thanks and Regards,
> > > =3D Ameya
> > >
> > >
> > >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
