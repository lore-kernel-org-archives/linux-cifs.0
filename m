Return-Path: <SRS0=fN8F=CE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PI_IMPORTANCE_HIGH,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F46C433E1
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Aug 2020 07:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6AF20707
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Aug 2020 07:57:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="t2/t+acm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHZH5T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Aug 2020 03:57:19 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:13741
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgHZH5R (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 26 Aug 2020 03:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7hmk1gD5RGrSIvBayCK335miUJXNauY/XTvZZkmSh5iqTVED1c6nmbskYnO2zKcjOx1YuTvI9rgM4jhOri/eNff8kvGTIyTzF3Zl59iQsDU0loG038sllx1SFRJCuf7Gu+7DgjHho0I4ALrZV2gE2r0uOJ+Ubl8eYH4qxk4GjnG+99NbenRs23aMSuZMBdbL6WYtmi0FInnsCAoMzHwufuIynxDdgb8NCg6wpszH+uzrsx9i4rrMgvSdjloEDaaWWoEEpePEY1nUGdAtFk9t2yB4KJDLFUwczRA9rKbEjDKET25+NekqkMT9AEDgeLSpUr1s52QAeqaM9dKf89yug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQYvt5py6ujsJcTe5/7dK3/78yI8l4Xu0XQTJZVJx/k=;
 b=FwV18fBRRAyPKjqHY2FKBCmBOJ8Ou3c4zlimrPEKeDJLOa+EdX3E4Pm66t0pItEx6JFusS7oD9md/i8O9EwB3eZMLXt25jTgU8P0FSP4aC2I8d1bE9bEwbfmnTvkb7Ed4edpHzUO7iQs2k7cYc9chvVePuyWTWBnpd1+e9wHLUE6GuZiabLSLU56ATF2f/RnedtiVTgHDXcVvdiN89U4JuhgeftpP+f1lOkyXmYF/VoB3sZ+NmGH8LOCZz5xcDP4sq8IAJjhdyvyDn7pF52nHuFUPxO+lznUqsODZDBsCnaLV1+Yx+CuUprITlJkKVrPLTTyDsUKbNR3ENz62GgdyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQYvt5py6ujsJcTe5/7dK3/78yI8l4Xu0XQTJZVJx/k=;
 b=t2/t+acmUwt8FitsRk4IrL2iD8j/yZVNTwHpvc+yRUy8HsWKep+Vpjsus56bIP9uikb0gX4C6pShSJTxgpKW0ixRXW8uSZfcyMaOctwulsXa7erGaid+amRElMURA2AQ/rg68FmdXxop/Lkn2E1vaUsLDeOvZ42HV8Jpzi6lVTc=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BY5PR16MB3222.namprd16.prod.outlook.com (2603:10b6:a03:18d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Wed, 26 Aug
 2020 07:57:14 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::b108:7150:bd4d:5cc4]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::b108:7150:bd4d:5cc4%6]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 07:57:14 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Re: Oops in cifs_negotiate_protocol - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in cifs_negotiate_protocol - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWdPUttde7I4ogoE2xW8+tLiwFcKlJX4pvgACzFq4=
Importance: high
X-Priority: 1
Date:   Wed, 26 Aug 2020 07:57:14 +0000
Message-ID: <BYAPR16MB26157E1CB90FE26A50E8DED6E2540@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <BYAPR16MB2615BE259AC55E3F8D26EBF4E25C0@BYAPR16MB2615.namprd16.prod.outlook.com>,<BYAPR16MB2615101D857F6A55AF5A39BFE2570@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB2615101D857F6A55AF5A39BFE2570@BYAPR16MB2615.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=komprise.com;
x-originating-ip: [24.5.193.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca823104-af35-4092-1150-08d84995a55f
x-ms-traffictypediagnostic: BY5PR16MB3222:
x-microsoft-antispam-prvs: <BY5PR16MB3222FB3D980938956134C0B6E2540@BY5PR16MB3222.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odC8WkvKBgatmFpCBg/ClONKy8ezoIFa5pTCwrnr25L6XSNQVK320L95+OiV0cCHsHFqOOitGSfFV8Smg3fu7Cn2vr/F1YU6NBn7+WtgIfijo2LnnbDkBonnl47d9isoyh5EC3fY/EqMmrLm2iJEIcbF2d1TWsk89QpzE4DpsgaF264+q1HUoG4rU54ujhjwLKULidX76DzrV6ztmMcEroZAYZieYnNI61bqceW1CQTVN8rNhZvYn+LMYB+9SRM0r3npYCluCJ/qURnQV1eN6RF/P2TvHWMCqPp32RqSDs6BFdCoNDFfL4Hp490cfRQ2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39840400004)(86362001)(7696005)(71200400001)(5660300002)(66946007)(9686003)(52536014)(64756008)(186003)(478600001)(76116006)(83380400001)(66476007)(66556008)(66446008)(91956017)(8676002)(26005)(44832011)(33656002)(45080400002)(2906002)(8936002)(55016002)(110136005)(53546011)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iSt/N1CDnUUpc3GT+h/vGJC1Ypal1jOuXl76iPNsWRyR9TgthAfVxLdJ83vbQ1OEdlRp3aFyRSqCVKzs1WK5kf9sUokixTYOTe9dk/9JIKUjkV0WJCtbthQ3xlMZCWwGD8pWYcKvj48//haUJ0DJ1CWMjspUR4iRbc7FG4bG6OJDsT6K7F1Py9mw6izRvQwz7pj7Hdzz5fmvbZZTWzjvxk2XBzrlVTPyEr3URzycYuZqxugON4kxwyVmBDnu2WiT7g8QIpSE45esNROOpxpG2FQaHsv4hjS8/vpzTQYWvVXiP8fZpdafvx3oeV6ZPz05NgY28eEUdaA01oY3L1Ea4bpa6RcxltlTc7AxBBSXiPrhAiw3uyFZfxOqpDdAzWlMlpGrezW0lJsPKQesyzDq+4t0wtnX7LW3jIFZ6d37uOxYW1ruyL1te+FNkfgqpgQcuEvAF/X/rN40A+GY6K09EQT7Qf99hJ8bsESMFX351yACBExeMP2BxqWLMguPiUbIjtbxRfiLTk79gEadjy82vq7M4qdQOqdAXzAwLAtLvKczerXA++cD0luW7KZ80RPnM+gfUWIua8VnEbo8scWNpFygBN+Z0AaHfiI114O9zA72ot/38M56KD8YVU8b8rs0OwXpUub/OFiRLTwTZY3GAQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca823104-af35-4092-1150-08d84995a55f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 07:57:14.4561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fxtRhQJ9chOVmmBmRNPsi6Jwt1SnrpY2dtJdx2BeM/gbAE1ljiznPknGiUrLBIUHJQuvaoio1NMcpJNaggz1rbxYmLfk1/WP/oNSaEiOdW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR16MB3222
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding Steve and samba-technical.=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Sent: Tuesday, August 25, 2020 2:16 PM=0A=
To: linux-cifs@vger.kernel.org <linux-cifs@vger.kernel.org>=0A=
Subject: Re: Oops in cifs_negotiate_protocol - linux kernel 4.16.2-1.el7.el=
repo.x86_64 =0A=
=A0=0A=
Resending again. This is OOPS seen on centos running kernel 4.16. I wanted =
to check and see if this has been fixed in kernel 4.19 ?=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
From: Vidhesh Ramesh=0A=
Sent: Monday, August 17, 2020 5:23 PM=0A=
To: linux-cifs@vger.kernel.org <linux-cifs@vger.kernel.org>=0A=
Subject: Oops in cifs_negotiate_protocol - linux kernel 4.16.2-1.el7.elrepo=
.x86_64 =0A=
=A0=0A=
[1.] One line summary of the problem:=0A=
oops kernel panic=0A=
[2.] Full description of the problem/report:=0A=
ESX VM hangs with a kernel panic when cifs shares are mounted and unmounted=
. Unable to ssh to the VM and the console of the VM is also not responding.=
 With kdump service running and core collected the VM restarts successfully=
.=0A=
[3.] Keywords (i.e., modules, networking, kernel):=0A=
cifs, kernel, panic, mount=0A=
[4.] Kernel information=0A=
[4.1.] Kernel version (from /proc/version):=0A=
Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc version=
 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 EDT 20=
18=0A=
[4.2.] Kernel .config file:=0A=
Please check the file uploaded=0A=
[5.] Most recent kernel version which did not have the bug:=0A=
[6.] Output of Oops.. message (if applicable) with symbolic information=0A=
=A0=A0=A0=A0 resolved (see Documentation/admin-guide/oops-tracing.rst)=0A=
[255120.498118] BUG: unable to handle kernel NULL pointer dereference at 00=
00000000000038=0A=
[255120.498520] IP: cifs_negotiate_protocol+0x15/0xd0 [cifs]=0A=
[255120.498805] PGD 800000042a54c067 P4D 800000042a54c067 PUD 4276f0067 PMD=
 0=0A=
[255120.499119] Oops: 0000 [#1] SMP PTI=0A=
[255120.499398] Modules linked in: rpcsec_gss_krb5 cmac nfsv4 nfs fscache a=
rc4 md4 nls_utf8 cifs ccm dns_resolver nf_conntrack_netbios_ns nf_conntrack=
_broadcast xt_CT ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_rej=
ect_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_=
nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_s=
ecurity ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ip=
v4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_=
filter ebtables ip6table_filter ip6_tables iptable_filter vmw_vsock_vmci_tr=
ansport vsock ppdev sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_int=
el pcbc vmw_balloon aesni_intel crypto_simd glue_helper cryptd intel_rapl_p=
erf joydev input_leds pcspkr sg parport_pc parport vmw_vmci shpchp=0A=
[255120.503180]=A0 i2c_piix4 nfsd nfs_acl lockd auth_rpcgss grace sunrpc ip=
_tables xfs libcrc32c sr_mod cdrom sd_mod ata_generic pata_acpi serio_raw c=
rc32c_intel floppy vmxnet3 vmwgfx drm_kms_helper syscopyarea sysfillrect sy=
simgblt fb_sys_fops ttm ata_piix drm libata mptspi mptscsih mptbase scsi_tr=
ansport_spi dm_mirror dm_region_hash dm_log dm_mod dax=0A=
[255120.505469] CPU: 0 PID: 6419 Comm: kworker/0:0 Not tainted 4.16.2-1.el7=
.elrepo.x86_64 #1=0A=
[255120.506098] Hardware name: VMware, Inc. VMware Virtual Platform/440BX D=
esktop Reference Platform, BIOS 6.00 04/05/2016=0A=
[255120.507412] Workqueue: cifsiod smb2_reconnect_server [cifs]=0A=
[255120.508111] RIP: 0010:cifs_negotiate_protocol+0x15/0xd0 [cifs]=0A=
[255120.508827] RSP: 0018:ffffc900113e7d40 EFLAGS: 00010246=0A=
[255120.509536] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa0=
61a340=0A=
[255120.510256] RDX: ffff88042d725d00 RSI: ffff88042bb9ae00 RDI: 0000000000=
000000=0A=
[255120.510987] RBP: ffffc900113e7d58 R08: 0000000000000271 R09: 0000000000=
000000=0A=
[255120.511724] R10: 0000000000000001 R11: 000000000000026b R12: ffff88042b=
b9ae00=0A=
[255120.512476] R13: ffff880399229568 R14: ffffffffa061a000 R15: 0000000000=
000001=0A=
[255120.513246] FS:=A0 0000000000000000(0000) GS:ffff88043fc00000(0000) knl=
GS:0000000000000000=0A=
[255120.514048] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[255120.514832] CR2: 0000000000000038 CR3: 000000042a5b2000 CR4: 0000000000=
0406f0=0A=
[255120.515696] Call Trace:=0A=
[255120.516545]=A0 smb2_reconnect+0x108/0x420 [cifs]=0A=
[255120.517410]=A0 ? remove_wait_queue+0x60/0x60=0A=
[255120.518249]=A0 smb2_reconnect_server+0x1d4/0x340 [cifs]=0A=
[255120.519102]=A0 process_one_work+0x15f/0x370=0A=
[255120.519962]=A0 worker_thread+0x4d/0x3e0=0A=
[255120.520808]=A0 kthread+0x105/0x140=0A=
[255120.521642]=A0 ? max_active_store+0x80/0x80=0A=
[255120.522456]=A0 ? kthread_bind+0x20/0x20=0A=
[255120.523254]=A0 ? do_syscall_64+0x79/0x1b0=0A=
[255120.524035]=A0 ret_from_fork+0x35/0x40=0A=
[255120.524791] Code: 64 a0 e8 ff 08 ab e0 5b 41 5c 41 5d 5d c3 0f 1f 84 00=
 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 f4 53 48 8b 5e 48=
 <48> 8b 43 38 48 8b 90 b8 00 00 00 48 85 d2 0f 84 97 00 00 00 48=0A=
[255120.527052] RIP: cifs_negotiate_protocol+0x15/0xd0 [cifs] RSP: ffffc900=
113e7d40=0A=
[255120.527807] CR2: 0000000000000038=0A=
[7.] A small shell script or example program which triggers the=0A=
=A0=A0=A0=A0 problem (if possible)=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
