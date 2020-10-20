Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596AFC4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 22:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B13942225C
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 22:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="3BwKkdHU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439049AbgJTW2h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 18:28:37 -0400
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:36384
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392454AbgJTW2h (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Oct 2020 18:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwGmCOMUMSeA61/yn5Z94pckvrrEo8uanQvRe9AAW0Hx1hN03PEafMxQuEf7IIMpaXoazGM12NC1T1abjRVT686LI6B9MjgC415xmV7N7xdVYnuNC6EOZWo2fyvSplDwa0nzySSdX812B8kmAuzS4F70IFflHK+T3sTpbMh2d/JnqtTkwlqxlBZ+aQrVVaCN9QkXMV+Z+D3GcxE1c/zj+COM1L0Ozd7Lo4CLS05NAc33sfLM9bq6oxwiW+/JO0L2EUTa+o/JATIjWAv0jltj/3LV/YksOta2B7x8ZZSXmdBhjOu5qV4UKHDXbbZRGZ52rzJSXMzsY4Th6sb05FE73g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgjWjHRLu2hTHyehDSLI+dfyr8eQ89PsxmmuJA4ib58=;
 b=A1Iy4l4xE9kVkrhlanOgBVfELhTbY2hlPjHtUP0h/oU7wmt3mxTXNDgW0mw0cCHcOsn1dpdq00RAbCPwMX6+7XD6HaT0oJ5NZdJhd9OHJHe3Am93AiaqOw481ve5Go8+ar5q91savkBaJzQnD1FMFAiq4v5SYlzVf0yYfM2cymJOySuS9e/+1WdKwenq/SAeVJid+J/BlEXg7xlmGF37bShToUhjw43bAqHN/OmxmXuZMSeKos6LIEXveqMjNrNtVaoVi1EN2M+tQ+FDJLeqDRRLI1Ydgf1Ti9Mz88MPz4MFkr8cqMgF6FOEMJfUIJRBOTBxn78r/nPaBaOzR0rJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgjWjHRLu2hTHyehDSLI+dfyr8eQ89PsxmmuJA4ib58=;
 b=3BwKkdHULIJPeU+kz3j/GYGUD6g3UAds9Ekg40FjBjTJxjmqK8E93VnndZoQb75xpBFHYE2dj4BDksVYZnBuvUJFDC/RUHFREP8b+gf/gWtHur+i2XVPzkzgrid9NIPcH4T//3orREtS3H8BXNoxcSyH+kaBpURt5TOrse8e+eo=
Received: from BL0PR16MB2611.namprd16.prod.outlook.com (2603:10b6:208:72::15)
 by MN2PR16MB3424.namprd16.prod.outlook.com (2603:10b6:208:16e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 20 Oct
 2020 22:28:33 +0000
Received: from BL0PR16MB2611.namprd16.prod.outlook.com
 ([fe80::a872:ca6:2fa7:54db]) by BL0PR16MB2611.namprd16.prod.outlook.com
 ([fe80::a872:ca6:2fa7:54db%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 22:28:33 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     Steve French <smfrench@gmail.com>
CC:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Re: Oops in _raw_spin_lock_irqsave - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in _raw_spin_lock_irqsave - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWpqQWBoGDFiQvIEihBkAX+8fKfKmg0xcAgAAjznGAABlZAIAAAUWU
Date:   Tue, 20 Oct 2020 22:28:33 +0000
Message-ID: <BL0PR16MB2611A883EC51E4658156E233E21F0@BL0PR16MB2611.namprd16.prod.outlook.com>
References: <BYAPR16MB26151755ED24DE9F506736B8E21F0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAH2r5msFVeJMHR7RbRYKweo7FFdXW6Lk=4oQe57hfzrFu6KQGg@mail.gmail.com>
 <BYAPR16MB2615EF719B1D7BA80B3AF3E7E21F0@BYAPR16MB2615.namprd16.prod.outlook.com>,<CAH2r5muxToKcoe5-5sP_1_YQ2kZePAirFGX=EUjHxMCibPV9pA@mail.gmail.com>
In-Reply-To: <CAH2r5muxToKcoe5-5sP_1_YQ2kZePAirFGX=EUjHxMCibPV9pA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=komprise.com;
x-originating-ip: [24.5.2.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b97d0939-fe66-4739-4a4c-08d875477adc
x-ms-traffictypediagnostic: MN2PR16MB3424:
x-microsoft-antispam-prvs: <MN2PR16MB3424EB93932DD543EDF28F47E21F0@MN2PR16MB3424.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sET1dwH7TfKq9RUyAva9bO9K9ORUL8E6ZyM8WrxK0A6lzdeeeosisbF9VnndIPoXZVNcYwXsPeumjzS2pq2WoFZ4KDtmSeyx9zuX8pmayEdKxdhTuBlLNnK2VDDF2lAYSbTr+cvMjQCsL9BK5jGUiMNXT5xQ9uZUlGJlHGrCuOV/aD30W+nlHqnWjXZkMNRHdMcflcqz8TRnFeO+x+ZT8PvWuUVQUS44E6Zj4fk8p7O4wMMZPAPjs1hzq2QRl6S6GxzwK9UajkXba+B+TOa43rkKssj3bQl2Ehxu0zsvk/ZcdSHK71+hnPZCCJCcUJjJoiE35jgVtSTf96jBWclV6UZq7KrEx6hthA8cSdwPQhVlYO6tIiRLx15p+j39JEuzxQjgXD38Hso8FhOKocjhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR16MB2611.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39850400004)(366004)(396003)(44832011)(2906002)(53546011)(966005)(7696005)(45080400002)(54906003)(52536014)(8676002)(5660300002)(316002)(33656002)(6506007)(71200400001)(9686003)(4326008)(186003)(66476007)(66556008)(76116006)(83380400001)(8936002)(66946007)(66446008)(478600001)(55016002)(86362001)(6916009)(26005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fd1kYB8MqvQ3FPkEvnPWTN13gCdgAZ2P9C4EpjINZjASM+QkFo+M7UAnYmMHc57//fIF7Dzv0EiJoZXqjA6eT8jFAapBcNf4TXel2o4JhkVo554MngQtSYRqaNbI6M0I2V/k3NxoxL+y9fWxETYneGWltbWTMGlUD53rAQCUx4jazSQ3VwWZ84Mn6CDsWVoPBV7NZrLikrU1xaApDk0POnnCC4AaBjPzE80dH+C/xhy87gBi2ORYY6Y5F4+M0ER40L+Nc5v+OK6aai5wc3Wq62rKyEdpeel3DtHp481k/c20gKN+BByWvIRHFwnQyI55K0UwGbePU0tUBjHUL2Sm12kMDUYrwYdRy302iDr+eZSWCfzjhmwBWQ+azTaxAtaf/bERMw80K8EAArSiL8sShwWpxxHXdT84t2QR4QsYgVA6xonZvEZArXji1gfX0YyXwxrRORN7S9OTsQiD2A9OkeO6QbiFuYmitLI2E8JqfOXXDw9/dhk0MDciKgFmNml8mtq7IoDP+JtBRWMRgsHQZeb5NbYvFlKGKih5MPUUOhn79UrDK3PtX8qHVL2ov9TnPR1lzI+BazfhQ7dY3unfisjiGzK4gShf6tDPQYNiUQvXYj4pYvIpHqzYbj76Uxx58BRz8qE70l6aK11nyYmiVA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR16MB2611.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b97d0939-fe66-4739-4a4c-08d875477adc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 22:28:33.5241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBwLI2/AdMXJ7eJFi2K0wjZRYYhfSdCC33kdNyASIt4Vg+eSETtgt4uGlENaNArcEfnyB9Igk271DKQxdlgJwS5KPizzsNNjkqaFNwpPtyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR16MB3424
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve.=0A=
=0A=
Where would I be able to see the 900 changesets so that i could see if ther=
e is anything that matches this. We are using centos distro and have seen s=
ome of the fixes backported to 4.19 as it's Long term release kernel.=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
From: Steve French <smfrench@gmail.com>=0A=
Sent: Tuesday, October 20, 2020 3:17 PM=0A=
To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-cif=
s@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@lists.=
samba.org>=0A=
Subject: Re: Oops in _raw_spin_lock_irqsave - linux kernel 4.16.2-1.el7.elr=
epo.x86_64 =0A=
=A0=0A=
4.19 kernel is from 2018 so already a couple years old, and 4.16 is even ol=
der.=A0 There are > 900 changesets in the kernel cifs.ko driver since 4.16 =
kernel so could be hard to identify - but if you distro is backporting fixe=
s well, you may be fine.=A0 =A0My general rule of thumb would be to encoura=
ge use of 5.0 kernel or later given the large number of cifs.ko improvement=
s.=0A=
=0A=
On Tue, Oct 20, 2020 at 3:50 PM Vidhesh Ramesh <vidhesh.ramesh@komprise.com=
> wrote:=0A=
Hi Steve,=0A=
=0A=
Thanks for the quick response.=0A=
=0A=
I haven't tried redhat 8.1 or 8.2, I have tried 4.19 kernel build 134 and I=
 am not seeing the same panic but not sure if it is fixed in kernel 4.19.=
=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: Steve French <smfrench@gmail.com>=0A=
Sent: Tuesday, October 20, 2020 11:38 AM=0A=
To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-cif=
s@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@lists.=
samba.org>=0A=
Subject: Re: Oops in _raw_spin_lock_irqsave - linux kernel 4.16.2-1.el7.elr=
epo.x86_64 =0A=
=A0=0A=
I don't have a kernel that old and I can't access the Redhat page -=0A=
but I would expect that given the date it was posted the fix would be=0A=
in the last two Redhat releases 8.1 and 8.2.=A0 Have you tried those?=0A=
=0A=
On Tue, Oct 20, 2020 at 12:49 AM Vidhesh Ramesh=0A=
<vidhesh.ramesh@komprise.com> wrote:=0A=
>=0A=
> [1.] One line summary of the problem:=0A=
> oops kernel panic=0A=
> [2.] Full description of the problem/report:=0A=
> ESX VM hangs with a kernel panic when cifs shares are mounted and accesse=
d. Unable to ssh to the VM and the console of the VM is also not responding=
. With kdump service running and core collected the VM restarts successfull=
y.=0A=
> [3.] Keywords (i.e., modules, networking, kernel):=0A=
> cifs, kernel, panic, mount=0A=
> [4.] Kernel information=0A=
> [4.1.] Kernel version (from /proc/version):=0A=
> Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc versi=
on 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 EDT =
2018=0A=
> [4.2.] Kernel .config file:=0A=
> Please check the file uploaded=0A=
> [5.] Most recent kernel version which did not have the bug:=0A=
> [6.] Output of Oops.. message (if applicable) with symbolic information=
=0A=
>=A0=A0=A0=A0=A0 resolved (see Documentation/admin-guide/oops-tracing.rst)=
=0A=
> [1866796.225242] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000000=0A=
> [1866796.225758] IP: _raw_spin_lock_irqsave+0x22/0x40=0A=
> [1866796.226236] PGD 8000000428341067 P4D 8000000428341067 PUD 0=0A=
> [1866796.226736] Oops: 0002 [#1] SMP PTI=0A=
> [1866796.227202] Modules linked in: nfsv3 nfs fscache arc4 md4 nls_utf8 c=
ifs ccm dns_resolver nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT i=
p6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntr=
ack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_i=
pv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_r=
aw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_connt=
rack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip=
6table_filter ip6_tables iptable_filter vmw_vsock_vmci_transport vsock ppde=
v sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc vmw_balloo=
n aesni_intel crypto_simd glue_helper cryptd intel_rapl_perf joydev input_l=
eds pcspkr sg shpchp i2c_piix4 vmw_vmci parport_pc parport nfsd=0A=
> [1866796.232074]=A0 auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs =
libcrc32c sr_mod cdrom ata_generic pata_acpi sd_mod crc32c_intel serio_raw =
vmwgfx drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ata=
_piix mptspi scsi_transport_spi vmxnet3 mptscsih drm mptbase libata floppy =
dm_mirror dm_region_hash dm_log dm_mod dax=0A=
> [1866796.234432] CPU: 3 PID: 11126 Comm: cifsd Tainted: G=A0=A0=A0=A0=A0=
=A0=A0 W=A0=A0=A0=A0=A0=A0=A0 4.16.2-1.el7.elrepo.x86_64 #1=0A=
> [1866796.235687] Hardware name: VMware, Inc. VMware Virtual Platform/440B=
X Desktop Reference Platform, BIOS 6.00 12/12/2018=0A=
> [1866796.237004] RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40=0A=
> [1866796.237683] RSP: 0018:ffffc90007a2bc00 EFLAGS: 00010046=0A=
> [1866796.238361] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000=
000000002=0A=
> [1866796.239049] RDX: 0000000000000001 RSI: ffffc90007a2bc40 RDI: 0000000=
000000000=0A=
> [1866796.239757] RBP: ffffc90007a2bc08 R08: 0000000000000242 R09: 0000000=
000000000=0A=
> [1866796.240494] R10: 0000000000000000 R11: 00000000000003c9 R12: 0000000=
000000000=0A=
> [1866796.241194] R13: ffff88041b26f8c8 R14: ffffc90007a2bcf8 R15: 0000000=
000000000=0A=
> [1866796.241915] FS:=A0 0000000000000000(0000) GS:ffff88043fcc0000(0000) =
knlGS:0000000000000000=0A=
> [1866796.242670] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
> [1866796.243438] CR2: 0000000000000000 CR3: 000000042ab22000 CR4: 0000000=
0000406e0=0A=
> [1866796.244293] Call Trace:=0A=
> [1866796.245069]=A0 remove_wait_queue+0x19/0x60=0A=
> [1866796.245877]=A0 sk_wait_data+0xf6/0x140=0A=
> [1866796.246691]=A0 ? prepare_to_wait+0xb0/0xb0=0A=
> [1866796.247504]=A0 tcp_recvmsg+0x5f5/0xb40=0A=
> [1866796.248560]=A0 ? select_task_rq_fair+0x4d5/0xba0=0A=
> [1866796.249420]=A0 inet_recvmsg+0x56/0xd0=0A=
> [1866796.250222]=A0 sock_recvmsg+0x43/0x50=0A=
> [1866796.251115]=A0 cifs_readv_from_socket+0x76/0x200 [cifs]=0A=
> [1866796.251953]=A0 cifs_read_from_socket+0x52/0x70 [cifs]=0A=
> [1866796.252969]=A0 cifs_demultiplex_thread+0x11b/0xa90 [cifs]=0A=
> [1866796.253740]=A0 kthread+0x105/0x140=0A=
> [1866796.254486]=A0 ? cifs_handle_standard+0x190/0x190 [cifs]=0A=
> [1866796.255198]=A0 ? kthread_bind+0x20/0x20=0A=
> [1866796.255907]=A0 ? do_syscall_64+0x79/0x1b0=0A=
> [1866796.256601]=A0 ret_from_fork+0x35/0x40=0A=
> [1866796.257251] Code: c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89=
 e5 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01 00 00=
 00 <f0> 0f b1 17 85 c0 75 06 48 89 d8 5b 5d c3 89 c6 e8 36 91 8b ff=0A=
> [1866796.259312] RIP: _raw_spin_lock_irqsave+0x22/0x40 RSP: ffffc90007a2b=
c00=0A=
>=0A=
> I see the solution posted in https://access.redhat.com/solutions/4354471 =
but I am unable to access the solution.=0A=
>=0A=
> Vidhesh Ramesh=0A=
> [1866796.260111] CR2: 0000000000000000=0A=
> [7.] A small shell script or example program which triggers the=0A=
>=A0=A0=A0=A0=A0 problem (if possible)=0A=
>=0A=
> Vidhesh Ramesh=0A=
=0A=
=0A=
=0A=
-- =0A=
Thanks,=0A=
=0A=
Steve=0A=
=0A=
=0A=
-- =0A=
Thanks,=0A=
=0A=
Steve=
