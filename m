Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51C2C433E3
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 21:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24132064B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 21:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jKM1BuP/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgGQVos (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgGQVor (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jul 2020 17:44:47 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93DBC0619D2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 14:44:47 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t18so8563556ilh.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 14:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RhZHV0w6wGSP7uZRAVQkucL5SjUtYTlVrGMXhpZmnKU=;
        b=jKM1BuP/XBnFCRp/Bm4LBsgrG7vr+ZcTx1oFOD3jhg/pQ5ZnSyRyqX5wP4Wv1paQaV
         ZHec5e2Ql3njQ3Lvgbt3ec6x33jx/jBLI9+lvnmTm6q6I+KTeKXFT9xyMiWMMkUl3jFK
         jStRI9Nt7r+l7BlITx2d58ZbRWTxs8QVTZSqVoLo9Oazq8dBESq/nj9Wz2qt1Ahsvr6p
         CyhlNO27R+DXZSJehwHeIwvZyUjWimX08TvjRnxrQ3YxrUQ1u7868idrAUShG6S1kxSD
         2iAdoUY/r/6q6d1cAee/pd8H23bc1uJr3Bz9T4jJtUhDBwIUL4Pbylts2nkKGUUrd2R5
         PINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RhZHV0w6wGSP7uZRAVQkucL5SjUtYTlVrGMXhpZmnKU=;
        b=Msiszu6/RT5/xdMe+J+370lrIUgg2hXy3YeuAeNq0Au6YwBEqKQtHmafVu1g2rWw93
         ypOnDJAdPwe2RXTJpXx/8eW4SfRD9893hM6xSWGdryi8zQAnuD1v+oW5Ylw8dAAcPEVC
         ummGlzaboMAfkNvbXTPqF95pGRaAKwcw6/IH7ynkcfRxHp3vw4lfD1LmCGDh3LxYbFnF
         9amObjc/y8llKAbTXHnfUdnrL0kpg0OVho61XjWfL1L+C+Mw8206t2Ha99CQ2v72PgJ7
         Cs+nGEeFkejv+OnCw8TpF/ZzbvH6DvrjeqE8YXaWLBDnjG8tWSYis4Ey3Vyw3caz0uY7
         pyIA==
X-Gm-Message-State: AOAM533OUq5rTxZ/addl1fN/GcHhv+XkJxFEVTOeGbUWtQ3ssrD31Weh
        rsnhLs5pFQ9NNUlMpp1SMYqXWz84uJ6WgM9kYZ4=
X-Google-Smtp-Source: ABdhPJzta+fZ21tswuRH5sIJxdfw6mq4ROka1s9fmtFGmR8csbJajpBziPbGX8SnPcdiQYiMWEB+bCEXhemKi1oTFiA=
X-Received: by 2002:a92:d6d2:: with SMTP id z18mr11475977ilp.272.1595022286909;
 Fri, 17 Jul 2020 14:44:46 -0700 (PDT)
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
Date:   Fri, 17 Jul 2020 16:44:35 -0500
Message-ID: <CAH2r5mt19W_Ceb+SB5e22+Gm2=UBbNiGbQ07EsX-oaCzPTtDrQ@mail.gmail.com>
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.x86_64
To:     Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
Cc:     Kenneth Dsouza <kdsouza@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d298bd05aaaa1024"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d298bd05aaaa1024
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see only 13 'cc:stable' patches missing from 4.19.113 for cifs.ko. See be=
low:

smfrench@smfrench-ThinkPad-P52:~/linux-stable-rc$ git log --oneline
v4.19.113.. fs/cifs
38bcc785c2eb cifs: update ctime and mtime during truncate
e1afc2c1baa5 cifs: Fix the target file was deleted when rename failed.
6f9e471d62ae SMB3: Honor lease disabling for multiuser mounts
da6845a443dc SMB3: Honor persistent/resilient handle flags for multiuser mo=
unts
c0651cd829ee SMB3: Honor 'seal' flag for multiuser mounts
1fa012710599 SMB3: Honor 'posix' flag for multiuser mounts
39dad7304057 cifs/smb3: Fix data inconsistent when zero file range
f4c710c4a39b cifs/smb3: Fix data inconsistent when punch hole
4d9248f989ec cifs: Fix null pointer check in cifs_read
ad149b6e08f1 cifs: fix leaked reference on requeued write
6c662c519277 cifs: protect updating server->dstaddr with a spinlock
731a3bc2be26 cifs: Allocate encryption header through kmalloc
9bc022589575 CIFS: Fix bug which the return value by asynchronous read is e=
rror

There are 113 cifs (cc:stable) patches in the 4.19.133 tree (out of
the 628 total patches to cifs.ko between 4.19 and now, 5.8-rc). See
attached

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

--000000000000d298bd05aaaa1024
Content-Type: application/octet-stream; name="4.19-stable-patches"
Content-Disposition: attachment; filename="4.19-stable-patches"
Content-Transfer-Encoding: base64
Content-ID: <f_kcqr08mm0>
X-Attachment-Id: f_kcqr08mm0

MzhiY2M3ODVjMmViIGNpZnM6IHVwZGF0ZSBjdGltZSBhbmQgbXRpbWUgZHVyaW5nIHRydW5jYXRl
CmUxYWZjMmMxYmFhNSBjaWZzOiBGaXggdGhlIHRhcmdldCBmaWxlIHdhcyBkZWxldGVkIHdoZW4g
cmVuYW1lIGZhaWxlZC4KNmY5ZTQ3MWQ2MmFlIFNNQjM6IEhvbm9yIGxlYXNlIGRpc2FibGluZyBm
b3IgbXVsdGl1c2VyIG1vdW50cwpkYTY4NDVhNDQzZGMgU01CMzogSG9ub3IgcGVyc2lzdGVudC9y
ZXNpbGllbnQgaGFuZGxlIGZsYWdzIGZvciBtdWx0aXVzZXIgbW91bnRzCmMwNjUxY2Q4MjllZSBT
TUIzOiBIb25vciAnc2VhbCcgZmxhZyBmb3IgbXVsdGl1c2VyIG1vdW50cwoxZmEwMTI3MTA1OTkg
U01CMzogSG9ub3IgJ3Bvc2l4JyBmbGFnIGZvciBtdWx0aXVzZXIgbW91bnRzCjM5ZGFkNzMwNDA1
NyBjaWZzL3NtYjM6IEZpeCBkYXRhIGluY29uc2lzdGVudCB3aGVuIHplcm8gZmlsZSByYW5nZQpm
NGM3MTBjNGEzOWIgY2lmcy9zbWIzOiBGaXggZGF0YSBpbmNvbnNpc3RlbnQgd2hlbiBwdW5jaCBo
b2xlCjRkOTI0OGY5ODllYyBjaWZzOiBGaXggbnVsbCBwb2ludGVyIGNoZWNrIGluIGNpZnNfcmVh
ZAphZDE0OWI2ZTA4ZjEgY2lmczogZml4IGxlYWtlZCByZWZlcmVuY2Ugb24gcmVxdWV1ZWQgd3Jp
dGUKNmM2NjJjNTE5Mjc3IGNpZnM6IHByb3RlY3QgdXBkYXRpbmcgc2VydmVyLT5kc3RhZGRyIHdp
dGggYSBzcGlubG9jawo3MzFhM2JjMmJlMjYgY2lmczogQWxsb2NhdGUgZW5jcnlwdGlvbiBoZWFk
ZXIgdGhyb3VnaCBrbWFsbG9jCjliYzAyMjU4OTU3NSBDSUZTOiBGaXggYnVnIHdoaWNoIHRoZSBy
ZXR1cm4gdmFsdWUgYnkgYXN5bmNocm9ub3VzIHJlYWQgaXMgZXJyb3IKYThhYjBiNzA5NzkwIGNp
ZnNfYXRvbWljX29wZW4oKTogZml4IGRvdWJsZS1wdXQgb24gbGF0ZSBhbGxvY2F0aW9uIGZhaWx1
cmUKM2UzMTlmMjQyYWYzIGNpZnM6IGRvbid0IGxlYWsgLUVBR0FJTiBmb3Igc3RhdCgpIGR1cmlu
ZyByZWNvbm5lY3QKYjZiNzdiNWVkMzVjIGNpZnM6IEZpeCBtb2RlIG91dHB1dCBpbiBkZWJ1Z2dp
bmcgc3RhdGVtZW50cwozZWRmODU1OTFmYjUgY2lmczogbG9nIHdhcm5pbmcgbWVzc2FnZSAob25j
ZSkgaWYgb3V0IG9mIGRpc2sgc3BhY2UKMzVjOWJjYjY3MmUzIGNpZnM6IGZpeCBOVUxMIGRlcmVm
ZXJlbmNlIGluIG1hdGNoX3ByZXBhdGgKNzFhNDdlZDY1MWMwIGNpZnM6IGZhaWwgaS9vIG9uIHNv
ZnQgbW91bnRzIGlmIHNlc3Npb25zZXR1cCBlcnJvcnMgb3V0CjMzZGExY2YwODIwZCBzbWIzOiBm
aXggc2lnbmluZyB2ZXJpZmljYXRpb24gb2YgbGFyZ2UgcmVhZHMKZjkzNzQzYTMzM2VhIGNpZnM6
IEZpeCBtZW1vcnkgYWxsb2NhdGlvbiBpbiBfX3NtYjJfaGFuZGxlX2NhbmNlbGxlZF9jbWQoKQo2
ZGIwZTI4Yjg5M2Egc2lnbmFsOiBBbGxvdyBjaWZzIGFuZCBkcmJkIHRvIHJlY2VpdmUgdGhlaXIg
dGVybWluYXRpbmcgc2lnbmFscwo3ZjZhOTZkZDgyMjMgY2lmczogZml4IHJtbW9kIHJlZ3Jlc3Np
b24gaW4gY2lmcy5rbyBjYXVzZWQgYnkgZm9yY2Vfc2lnIGNoYW5nZXMKZTZhMTNjNzUzZjkxIHNp
Z25hbC9jaWZzOiBGaXggY2lmc19wdXRfdGNwX3Nlc3Npb24gdG8gY2FsbCBzZW5kX3NpZyBpbnN0
ZWFkIG9mIGZvcmNlX3NpZwpiNTI0MjQ3ZWZiOTkgY2lmczogQWRqdXN0IGluZGVudGF0aW9uIGlu
IHNtYjJfb3Blbl9maWxlCmU4YjI2ODc3YzQyOSBDSUZTOiBDbG9zZSBvcGVuIGhhbmRsZSBhZnRl
ciBpbnRlcnJ1cHRlZCBjbG9zZQozZGRjMDljODIzM2UgQ0lGUzogUmVzcGVjdCBPX1NZTkMgYW5k
IE9fRElSRUNUIGZsYWdzIGR1cmluZyByZWNvbm5lY3QKNTk0OGU3ZWMwNzA4IGNpZnM6IERvbid0
IGRpc3BsYXkgUkRNQSB0cmFuc3BvcnQgb24gcmVjb25uZWN0CjMzODUyYTk1MDExYiBjaWZzOiBz
bWJkOiBSZXR1cm4gLUVJTlZBTCB3aGVuIHRoZSBudW1iZXIgb2YgaW92cyBleGNlZWRzIFNNQkRJ
UkVDVF9NQVhfU0dFCjY3NGI3YjZjOWYxOCBjaWZzOiBzbWJkOiBBZGQgbWVzc2FnZXMgb24gUkRN
QSBzZXNzaW9uIGRlc3Ryb3kgYW5kIHJlY29ubmVjdGlvbgo1Y2NlZWFkNzE0YzUgY2lmczogc21i
ZDogUmV0dXJuIC1FQUdBSU4gd2hlbiB0cmFuc3BvcnQgaXMgcmVjb25uZWN0aW5nCjE0Y2IyMGFk
NmJmYyBjaWZzOiBGaXggcG90ZW50aWFsIHNvZnRsb2NrdXBzIHdoaWxlIHJlZnJlc2hpbmcgREZT
IGNhY2hlCmQ0Nzg1ZDg4NDU5ZSBDSUZTOiBGaXggU01CMiBvcGxvY2sgYnJlYWsgcHJvY2Vzc2lu
ZwpkZjg3MWU1NTFkMGEgQ0lGUzogRml4IE5VTEwtcG9pbnRlciBkZXJlZmVyZW5jZSBpbiBzbWIy
X3B1c2hfbWFuZGF0b3J5X2xvY2tzCjZjMjA3NWY3OTJjNiBmcy9jaWZzOiBmaXggdW5pbml0aWFs
aXNlZCB2YXJpYWJsZSB3YXJuaW5ncwpkOGE3NmUzMDBlMzcgU01CMzogRml4IHBlcnNpc3RlbnQg
aGFuZGxlcyByZWNvbm5lY3QKODBiNDJmNDM4MWMyIGNpZnM6IEZpeCBjaWZzSW5vZGVJbmZvIGxv
Y2tfc2VtIGRlYWRsb2NrIHdoZW4gcmVjb25uZWN0IG9jY3Vycwo0OTdmZDk4YTUwYjIgZnM6IGNp
ZnM6IG11dGUgLVd1bnVzZWQtY29uc3QtdmFyaWFibGUgbWVzc2FnZQpiNzMxMzJiNzRkMjUgY2lm
czogYWRkIGNyZWRpdHMgZnJvbSB1bm1hdGNoZWQgcmVzcG9uc2VzL21lc3NhZ2VzCmVlNGQyOGE3
MTZlOCBDSUZTOiBSZXNwZWN0IFNNQjIgaGRyIHByZWFtYmxlIHNpemUgaW4gcmVhZCByZXNwb25z
ZXMKMDEzMzJiMDM3MDY2IENJRlM6IEZpeCB1c2UgYWZ0ZXIgZnJlZSBvZiBmaWxlIGluZm8gc3Ry
dWN0dXJlcwo3MWNmODgxNjVmZjAgQ0lGUzogYXZvaWQgdXNpbmcgTUlEIDB4RkZGRgphOGRlNzA5
MDgwNWQgY2lmczogdXNlIGNpZnNJbm9kZUluZm8tPm9wZW5fZmlsZV9sb2NrIHdoaWxlIGl0ZXJh
dGluZyB0byBhdm9pZCBhIHBhbmljCjIzMGIzMzlhN2M3NSBDSUZTOiBGb3JjZSByZXZhbCBkZW50
cnkgaWYgTE9PS1VQX1JFVkFMIGZsYWcgaXMgc2V0CjBiYzc4ZGU0NjFiNCBDSUZTOiBGb3JjZSBy
ZXZhbGlkYXRlIGlub2RlIHdoZW4gZGVudHJ5IGlzIHN0YWxlCmQ3MmMyMTE1MTA4ZiBDSUZTOiBH
cmFjZWZ1bGx5IGhhbmRsZSBRdWVyeUluZm8gZXJyb3JzIGR1cmluZyBvcGVuCjQyOTBhOWU1OTMy
MyBDSUZTOiBGaXggb3Bsb2NrIGhhbmRsaW5nIGZvciBTTUIgMi4xKyBwcm90b2NvbHMKYTNhMTUw
ODk1YjZmIENJRlM6IGZpeCBtYXggZWEgdmFsdWUgc2l6ZQoyZTk2YzkzMzI1OTUgc21iMzogYWxs
b3cgZGlzYWJsaW5nIHJlcXVlc3RpbmcgbGVhc2VzCmU4NjdlZjExMzAwNCBDSUZTOiBmaXggZGVh
ZGxvY2sgaW4gY2FjaGVkIHJvb3QgaGFuZGxpbmcKYjYyOTQ2ODUyYWZhIGNpZnM6IFVzZSBremZy
ZWUoKSB0byB6ZXJvIG91dCB0aGUgcGFzc3dvcmQKMzI1ZmEyYTY3MjliIGNpZnM6IHNldCBkb21h
aW5OYW1lIHdoZW4gYSBkb21haW4ta2V5IGlzIHVzZWQgaW4gbXVsdGl1c2VyCjk4NzU2NGMyOGU4
YSBjaWZzOiBQcm9wZXJseSBoYW5kbGUgYXV0byBkaXNhYmxpbmcgb2Ygc2VydmVyaW5vIG9wdGlv
bgphY2MwNzk0MWUyMjQgY2lmczogYWRkIHNwaW5sb2NrIGZvciB0aGUgb3BlbkZpbGVMaXN0IHRv
IGNpZnNJbm9kZUluZm8KOTZiNDRjMjBlNmYwIGNpZnM6IHNtYmQ6IHRha2UgYW4gYXJyYXkgb2Yg
cmVxZXVzdHMgd2hlbiBzZW5kaW5nIHVwcGVyIGxheWVyIGRhdGEKNDA2MWU2NjJjOGU5IGNpZnM6
IEZpeCBsZWFzZSBidWZmZXIgbGVuZ3RoIGVycm9yCjc3OGQ2MjZjNmFmMyBDSUZTOiBGaXggbGVh
a2luZyBsb2NrZWQgVkZTIGNhY2hlIHBhZ2VzIGluIHdyaXRlYmFjayByZXRyeQpmYjJkYWJlYWJi
MTcgQ0lGUzogRml4IGVycm9yIHBhdGhzIGluIHdyaXRlYmFjayBjb2RlCjMzYmRlYTE3NWRmMCBT
TUIzOiBLZXJuZWwgb29wcyBtb3VudGluZyBhIGVuY3J5cHREYXRhIHNoYXJlIHdpdGggQ09ORklH
X0RFQlVHX1ZJUlRVQUwKZmFiNWExZmQxN2E2IFNNQjM6IEZpeCBwb3RlbnRpYWwgbWVtb3J5IGxl
YWsgd2hlbiBwcm9jZXNzaW5nIGNvbXBvdW5kIGNoYWluCjg5OGMxOWYxYjRjOCBzbWIzOiBzZW5k
IENBUF9ERlMgY2FwYWJpbGl0eSBkdXJpbmcgc2Vzc2lvbiBzZXR1cAo1MDgzMWYxYTJmNTcgU01C
MzogRml4IGRlYWRsb2NrIGluIHZhbGlkYXRlIG5lZ290aWF0ZSBoaXRzIHJlY29ubmVjdApkMjlm
YmY2Nzc5NjMgY2lmczogRml4IGEgcmFjZSBjb25kaXRpb24gd2l0aCBjaWZzX2VjaG9fcmVxdWVz
dAo1MjkzYzc5YzZmNjAgU01CMzogcmV0cnkgb24gU1RBVFVTX0lOU1VGRklDSUVOVF9SRVNPVVJD
RVMgaW5zdGVhZCBvZiBmYWlsaW5nIHdyaXRlCjI5N2EyNTEwNjJjMCBDSUZTOiBjaWZzX3JlYWRf
YWxsb2NhdGVfcGFnZXM6IGRvbid0IGl0ZXJhdGUgdGhyb3VnaCB3aG9sZSBwYWdlIGFycmF5IG9u
IEVOT01FTQozMmQ1N2MwYzA2M2MgY2lmczogZml4IG1lbW9yeSBsZWFrIG9mIHBuZWdfaW5idWYg
b24gLUVPUE5PVFNVUFAgaW9jdGwgY2FzZQo5MzlkYjZmZGJlYTYgY2lmczogZml4IHN0cmNhdCBi
dWZmZXIgb3ZlcmZsb3cgYW5kIHJlZHVjZSByYWNpbmVzcyBpbiBzbWIyMV9zZXRfb3Bsb2NrX2xl
dmVsKCkKZWUyMzEwNjNmZjk1IGNpZnM6IGRvIG5vdCBhdHRlbXB0IGNpZnMgb3BlcmF0aW9uIG9u
IHNtYjIrIHJlbmFtZSBlcnJvcgpkNWJmNzgzYTA5YTAgY2lmczogZml4IG1lbW9yeSBsZWFrIGlu
IFNNQjJfcmVhZAoyZmNlZTVlYWFlNmUgY2lmczogZml4IGhhbmRsZSBsZWFrIGluIHNtYjJfcXVl
cnlfc3ltbGluaygpCmM2OTMzMGE4NTVhYiBjaWZzOiBGaXggdXNlLWFmdGVyLWZyZWUgaW4gU01C
Ml9yZWFkCjhmYjg5YjQzYjY1ZiBjaWZzOiBGaXggdXNlLWFmdGVyLWZyZWUgaW4gU01CMl93cml0
ZQo4MDkyZWNjMzA2ZDggQ0lGUzoga2VlcCBGaWxlSW5mbyBoYW5kbGUgbGl2ZSBkdXJpbmcgb3Bs
b2NrIGJyZWFrCmU5NjAzY2ZmYjFjYSBjaWZzOiBmYWxsYmFjayB0byBvbGRlciBpbmZvbGV2ZWxz
IG9uIGZpbmRmaXJzdCBxdWVyeWluZm8gcmV0cnkKNDAyNzZlNGUyZmQwIGZpeCBpbmNvcnJlY3Qg
ZXJyb3IgY29kZSBtYXBwaW5nIGZvciBPQkpFQ1RJRF9OT1RfRk9VTkQKMzZhMzIxOWU2MTdhIGNp
ZnM6IEZpeCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ugb2YgZGV2bmFtZQpkNTc5YjRlYWU4MzYg
Y2lmczogQWNjZXB0IHZhbGlkYXRlIG5lZ290aWF0ZSBpZiBzZXJ2ZXIgcmV0dXJuIE5UX1NUQVRV
U19OT1RfU1VQUE9SVEVECjYyNmQ5OGJiZGIzMCBjaWZzOiB1c2UgY29ycmVjdCBmb3JtYXQgY2hh
cmFjdGVycwoyOTM4NjUxZDM2Y2EgQ0lGUzogZml4IFBPU0lYIGxvY2sgbGVhayBhbmQgaW52YWxp
ZCBwdHIgZGVyZWYKMzhiZDU3NWI5YWVmIFNNQjM6IEZpeCBTTUIzLjEuMSBndWVzdCBtb3VudHMg
dG8gU2FtYmEKMTRjNTJhY2FhYzg2IGNpZnM6IGFsbG93IGd1ZXN0IG1vdW50cyB0byB3b3JrIGZv
ciBzbWIzLjExCjQzZWFhNmNjMTc3NSBDSUZTOiBGaXggcmVhZCBhZnRlciB3cml0ZSBmb3IgZmls
ZXMgd2l0aCByZWFkIGNhY2hpbmcKZGM4ZThhZDk2MmE4IENJRlM6IERvIG5vdCBza2lwIFNNQjIg
bWVzc2FnZSBJRHMgb24gc2VuZCBmYWlsdXJlcwozZWQ5ZjIyZTI4ZGQgQ0lGUzogRG8gbm90IHJl
c2V0IGxlYXNlIHN0YXRlIHRvIE5PTkUgb24gbGVhc2UgYnJlYWsKYjRkOTY1YTM3ZDg5IGNpZnM6
IGFsbG93IGNhbGxpbmcgU01CMl94eHhfZnJlZShOVUxMKQo2ZWZkNjlkNjMzMzkgY2lmczogZml4
IGNvbXB1dGF0aW9uIGZvciBNQVhfU01CMl9IRFJfU0laRQpiMTc2NWViZDlkMTIgQ0lGUzogRG8g
bm90IGFzc3VtZSBvbmUgY3JlZGl0IGZvciBhc3luYyByZXNwb25zZXMKNjM3MTVjMWYwYTY3IGNp
ZnM6IExpbWl0IG1lbW9yeSB1c2VkIGJ5IGxvY2sgcmVxdWVzdCBjYWxscyB0byBhIHBhZ2UKNWQz
YjRjZDg3MzRiIGNpZnM6IGNoZWNrIG50d3JrX2J1Zl9zdGFydCBmb3IgTlVMTCBiZWZvcmUgZGVy
ZWZlcmVuY2luZyBpdApjMGJlNjI0Nzc3YmEgY2lmczogQWx3YXlzIHJlc29sdmUgaG9zdG5hbWUg
YmVmb3JlIHJlY29ubmVjdGluZwplOWQ1NmY5MjBiYjIgQ0lGUzogRG8gbm90IGNvbnNpZGVyIC1F
Tk9EQVRBIGFzIHN0YXQgZmFpbHVyZSBmb3IgcmVhZHMKNmU3MDQ1ZWMzMzZiIENJRlM6IEZpeCB0
cmFjZSBjb21tYW5kIGxvZ2dpbmcgZm9yIFNNQjIgcmVhZHMgYW5kIHdyaXRlcwpjNjk2MTI4OGE1
ZjQgQ0lGUzogRG8gbm90IGNvdW50IC1FTk9EQVRBIGFzIGZhaWx1cmUgZm9yIHF1ZXJ5IGRpcmVj
dG9yeQowNmQ5Zjk4NzIwMWYgc21iMzogYWRkIGNyZWRpdHMgd2UgcmVjZWl2ZSBmcm9tIG9wbG9j
ay9icmVhayBQRFVzCjc3OWM2NWJiNzczOSBDSUZTOiBEbyBub3QgcmVjb25uZWN0IFRDUCBzZXNz
aW9uIGluIGFkZF9jcmVkaXRzKCkKMmFlNmZlZGJkNWNiIENJRlM6IEZpeCBjcmVkaXQgY2FsY3Vs
YXRpb24gZm9yIGVuY3J5cHRlZCByZWFkcyB3aXRoIGVycm9ycwowMzgwZWQ5YjFjZDMgQ0lGUzog
Rml4IGNyZWRpdHMgY2FsY3VsYXRpb25zIGZvciByZWFkcyB3aXRoIGVycm9ycwowN2I5ZTVlMzVl
OGYgQ0lGUzogRml4IHBvc3NpYmxlIGhhbmcgZHVyaW5nIGFzeW5jIE1UVSByZWFkcyBhbmQgd3Jp
dGVzCjJhNzFhNDdlMDNmZiBjaWZzOiBGaXggcG90ZW50aWFsIE9PQiBhY2Nlc3Mgb2YgbG9jayBl
bGVtZW50IGFycmF5CjdkY2M1YjM2ZWE3ZiBDSUZTOiBGaXggY3JlZGl0IGNvbXB1dGF0aW9uIGZv
ciBjb21wb3VuZGVkIHJlcXVlc3RzCmQyZjc2ZjZmOWZhOSBDSUZTOiBEbyBub3QgaGlkZSBFSU5U
UiBhZnRlciBzZW5kaW5nIG5ldHdvcmsgcGFja2V0cwpjMzYwNmM2NDY3ODMgQ0lGUzogRG8gbm90
IHNldCBjcmVkaXRzIHRvIDEgaWYgdGhlIHNlcnZlciBkaWRuJ3QgZ3JhbnQgYW55dGhpbmcKZDEx
MzA2ODJkMTI3IENJRlM6IEZpeCBhZGp1c3RtZW50IG9mIGNyZWRpdHMgZm9yIE1UVSByZXF1ZXN0
cwpiYTc3ZThjN2Y3MDQgc21iMzogZml4IGxhcmdlIHJlYWRzIG9uIGVuY3J5cHRlZCBjb25uZWN0
aW9ucwoxODI3ZDFjNDM5YmMgQ0lGUzogRml4IGVycm9yIG1hcHBpbmcgZm9yIFNNQjJfTE9DSyBj
b21tYW5kIHdoaWNoIGNhdXNlZCBPRkQgbG9jayBwcm9ibGVtCmI1YTgwMjhjMjVmMyBjaWZzOiBJ
biBLY29uZmlnIENPTkZJR19DSUZTX1BPU0lYIG5lZWRzIGRlcGVuZHMgb24gbGVnYWN5IChpbnNl
Y3VyZSBjaWZzKQo5OWM2OTQwODFiYTIgY2lmczogRml4IHNlcGFyYXRvciB3aGVuIGJ1aWxkaW5n
IHBhdGggZnJvbSBkZW50cnkKZTRlZDRlNjhjNmQ4IGNpZnM6IGZpeCByZXR1cm4gdmFsdWUgZm9y
IGNpZnNfbGlzdHhhdHRyCmFkMTgzNGZkOGE0NyBjaWZzOiBkb24ndCBkZXJlZmVyZW5jZSBzbWJf
ZmlsZV90YXJnZXQgYmVmb3JlIG51bGwgY2hlY2sKOTNlMmU4Njc0NTQ4IHNtYjM6IG9uIGtlcmJl
cm9zIG1vdW50IGlmIHNlcnZlciBkb2Vzbid0IHNwZWNpZnkgYXV0aCB0eXBlIHVzZSBrcmI1CjEw
OGI5ODFkNDhmMSBzbWIzOiBkbyBub3QgYXR0ZW1wdCBjaWZzIG9wZXJhdGlvbiBpbiBzbWIzIHF1
ZXJ5IGluZm8gZXJyb3IgcGF0aAplYjc4MTRjMzZmNDkgc21iMzogYWxsb3cgc3RhdHMgd2hpY2gg
dHJhY2sgc2Vzc2lvbiBhbmQgc2hhcmUgcmVjb25uZWN0cyB0byBiZSByZXNldApjMjRmNTdjNjEy
NzcgY2lmczogZml4IGEgY3JlZGl0cyBsZWFrIGZvciBjb21wdW5kIGNvbW1hbmRzCg==
--000000000000d298bd05aaaa1024--
