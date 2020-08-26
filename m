Return-Path: <SRS0=fN8F=CE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3953C433DF
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Aug 2020 07:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BF7920767
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Aug 2020 07:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="rM9OEhqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgHZH7B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Aug 2020 03:59:01 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:52832
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgHZH67 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 26 Aug 2020 03:58:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5s4gcsFqqUcrC8Ezg/BeWH4/ykH8hveB9b0eVt0t091Jbt2pCRSa4yv1OyNWVb0HiNtrwmzitngjbR7eqrH5lMSmgMfdNeZ0WM3j73g7mQp6pKXGpx8TrBPgFG00+RCS2hkQFCfeySV1+l+mG+MAkXIbPrxs45RRS+eNXOEIKmFfIwBi+arZPyzbLFwvG461CYt3eMttfIXZjjQvzWFI28AT70AbNU/MhfzNyhlQaRaXXL8BKCR13XesiA9PZHlFhqC1DpgaeSoX/awRR3TMUutMYTvqcpknsUtQHxIvihTwlKr2WRTd8VVIKGwSfHc/pV02UduK4qcvzMRwaByYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/ItiPPSdg2dSbC5/bTh+v7vfkSQgu535Jrq/NpXseU=;
 b=EPhNz3UxrpHJDh4Hsm42abD5rARKuLJPmHGNqHdqzerjwY4dmdiT64eqKcmyvUdCwkVEFR3zm9mMmO8GRSsOZz3zL3OyJA8Yob+KZxY9PLN8s9gnB8afsMemxQPONGUKnZ+PAld/lLFR/we7yAOxqG4iPO5OsmhomkjQdj2Zb9g5ADPtN3WjcQAfZZzqZXN1ZcMnQ95y+S1ijCYnw5aoCii1Bro4XP+rIfg9KjvwlkG1ktdhJBHFg6c3eNTj91iCiofsBGEhXin+o5ve9yAX5LbPtdZVrkGYucS8MhSt18dzlo9TLq3YP98eUC9MWIJOSXnuh+wSH6eBls44MijJdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/ItiPPSdg2dSbC5/bTh+v7vfkSQgu535Jrq/NpXseU=;
 b=rM9OEhqTZ8AdzcmfKCDp/S7PwtTeOx77FoOVnZstKr083wJ/XNmmkHrE8z1Ajyvicfz2NBSzQyrMDLQ8aEZifP5Dd38VZ9oBW3FGWddJ/ip2p2rSAWAURT/XYO9DlNpj1M6EO4Q9gEpuktGHjnfoJLNn0PBUjXcKi1u1TOA6fo4=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BY5PR16MB3222.namprd16.prod.outlook.com (2603:10b6:a03:18d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Wed, 26 Aug
 2020 07:58:57 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::b108:7150:bd4d:5cc4]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::b108:7150:bd4d:5cc4%6]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 07:58:57 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Re: Oops in cifs_reconnect - linux kernel 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in cifs_reconnect - linux kernel 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWdPXYF6AGBDNprEenJbDpWCgEcqlJYAf7gACzTNA=
Date:   Wed, 26 Aug 2020 07:58:57 +0000
Message-ID: <BYAPR16MB26153C402856F5D21AC4D7ACE2540@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <BYAPR16MB2615D74ECD5670CFD3CD7860E25C0@BYAPR16MB2615.namprd16.prod.outlook.com>,<BYAPR16MB2615945959907C39B0BB1BF1E2570@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB2615945959907C39B0BB1BF1E2570@BYAPR16MB2615.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=komprise.com;
x-originating-ip: [24.5.193.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a23ab545-262c-4f29-fb3a-08d84995e2c6
x-ms-traffictypediagnostic: BY5PR16MB3222:
x-microsoft-antispam-prvs: <BY5PR16MB3222455BC020D272F3F1DBF1E2540@BY5PR16MB3222.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P1sZNnNrDMeLWsR5saEDlbS8kz+sc2qcxX9z+FBvBIEpIh0bq0wUiQfzkHq+CRUxlWs3vrAQ9W7n7C9hTIInE94vxFVQ55VSCGGwXKjsnd+Qwm/1+tbDE4D8hO3+p02oGbGafDv9F17lvyOsOyHAYxqufki4gRq2hD6dMY6Oyq79qltSN8wAmrMFBVT87B8J74QKustw/ch3WSlFAZceSfdJ4MjbWibuX/2DXmpYO9BFJ8A5SfHaLMz3sla/XfEiTDHi2T7Omn587Qh4RoOzdXS/PyJ2eYRVq59qfPgWo64SbzEuBeFj6jroP31gtMHkf4jslA69oK/HvVHpSUjxMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39840400004)(86362001)(7696005)(71200400001)(5660300002)(66946007)(9686003)(52536014)(64756008)(186003)(478600001)(76116006)(83380400001)(66476007)(66556008)(66446008)(91956017)(8676002)(26005)(44832011)(33656002)(45080400002)(2906002)(8936002)(55016002)(110136005)(53546011)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1bxajUEibA1C1S2ymb5srqZl3pAiWMULyAhXy/5iHZmR060s/xeijCPzq+H6auvYB4+YnrIKzrORHZ0rGVYPqHGYwBwXvACaAwhUgqgezCYpq2Vv+XBjwoFtnwKeOOMyELXqjIk7IST6Jci9jXA7TDTvyD/M8yeDTnRE57b5Ar8MaSvmUPpQzwhOQSlIEs//ATpBDaz0jJMNHEN6GafKyaHTbain1E6XnlNboMEByZIBy8O2l4XVEMp/ijqOZBVJjvCxC53s9wK8E/TmBMzrSjE/3ApqGVyQ/Ygo8P9anwkVgnir4GrKxZtGTxCePsWHebBt3d0ZxiS3cDv+l7Fxs9QSxcItPvZsdHeRkS0HW2nTpyt3emWlQfGkNeR9k3/6PYPgppSN73kASu2cusZE+Ul1ULV9SkZ1xU4Qo1cRXz9j+62LeBE/xeKQF4l8EHf6e3mLvCThUgVnEM3gLOffzUETtvgNqCunCPDbDUByUmENjoe2+pCP+GktVa0CXeTPH1qHgLKdEP3zI4bgah8h1CCIG0uJIBxZlaQdb3aW+mPJhkKuIaPQ6sTs7/Fs9SgabTP/FCQSixgvdiuCIc/e9rJdQQS8dJBwiQsO8wLqQMKSmpsJtMAIayLsP3z1I/sE7APDZSgGldBqHeqYOxxU1A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23ab545-262c-4f29-fb3a-08d84995e2c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 07:58:57.5521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bqkSjZ9wvsKjeBONIdI5JSGtAlFHwoVgn8FuGROpJOm9VZGaTftjoBsY71+lhB1YHFMpmzMWz3/5F0l7HjZG96gKQMLdHIvEQRskF8DvW3A=
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
Subject: Re: Oops in cifs_reconnect - linux kernel 4.16.2-1.el7.elrepo.x86_=
64 =0A=
=A0=0A=
Resending again. This is OOPS seen on centos running kernel 4.16. I wanted =
to check and see if this has been fixed in kernel 4.19 ?=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
From: Vidhesh Ramesh=0A=
Sent: Monday, August 17, 2020 5:26 PM=0A=
To: linux-cifs@vger.kernel.org <linux-cifs@vger.kernel.org>=0A=
Subject: Oops in cifs_reconnect - linux kernel 4.16.2-1.el7.elrepo.x86_64 =
=0A=
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
[366603.058360] BUG: unable to handle kernel NULL pointer dereference at 00=
00000000000000=0A=
[366603.058730] IP: cifs_reconnect+0x286/0x620 [cifs]=0A=
[366603.059062] PGD 8000000426291067 P4D 8000000426291067 PUD 42af59067 PMD=
 0=0A=
[366603.059418] Oops: 0000 [#1] SMP PTI=0A=
[366603.059803] Modules linked in: rpcsec_gss_krb5 nfsv4 nfs cmac fscache a=
rc4 md4 nls_utf8 cifs ccm dns_resolver nf_conntrack_netbios_ns nf_conntrack=
_broadcast xt_CT ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_rej=
ect_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_=
nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_s=
ecurity ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ip=
v4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_=
filter ebtables ip6table_filter ip6_tables iptable_filter vmw_vsock_vmci_tr=
ansport vsock sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcb=
c ppdev aesni_intel crypto_simd glue_helper cryptd vmw_balloon intel_rapl_p=
erf pcspkr joydev input_leds sg parport_pc parport i2c_piix4=0A=
[366603.064108]=A0 vmw_vmci shpchp nfsd nfs_acl lockd auth_rpcgss grace sun=
rpc ip_tables xfs libcrc32c sr_mod cdrom sd_mod ata_generic pata_acpi crc32=
c_intel serio_raw vmxnet3 mptspi mptscsih mptbase scsi_transport_spi vmwgfx=
 ata_piix drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm =
libata drm floppy dm_mirror dm_region_hash dm_log dm_mod dax=0A=
[366603.066558] CPU: 6 PID: 5920 Comm: cifsd Tainted: G=A0=A0=A0=A0=A0=A0=
=A0 W=A0=A0=A0=A0=A0=A0=A0 4.16.2-1.el7.elrepo.x86_64 #1=0A=
[366603.067888] Hardware name: VMware, Inc. VMware Virtual Platform/440BX D=
esktop Reference Platform, BIOS 6.00 04/05/2016=0A=
[366603.069252] RIP: 0010:cifs_reconnect+0x286/0x620 [cifs]=0A=
[366603.069947] RSP: 0018:ffffc90005a53d70 EFLAGS: 00010203=0A=
[366603.070641] RAX: 0000000000000001 RBX: ffff88042b599c00 RCX: 0000000000=
000000=0A=
[366603.071413] RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000=
000246=0A=
[366603.072144] RBP: ffffc90005a53dc0 R08: 0000000000000005 R09: ffff88042d=
6c8000=0A=
[366603.072934] R10: 00000000000002d4 R11: 000000000000b6bf R12: 0000000000=
000000=0A=
[366603.073669] R13: ffffc90005a53d80 R14: ffff88035d086680 R15: ffff88035d=
086f00=0A=
[366603.074406] FS:=A0 0000000000000000(0000) GS:ffff88043fd80000(0000) knl=
GS:0000000000000000=0A=
[366603.075162] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[366603.076031] CR2: 0000000000000000 CR3: 0000000427c88000 CR4: 0000000000=
0406e0=0A=
[366603.076896] Call Trace:=0A=
[366603.077706]=A0 cifs_readv_from_socket+0x1b4/0x200 [cifs]=0A=
[366603.078621]=A0 cifs_read_from_socket+0x52/0x70 [cifs]=0A=
[366603.079458]=A0 cifs_demultiplex_thread+0x11b/0xa90 [cifs]=0A=
[366603.080313]=A0 kthread+0x105/0x140=0A=
[366603.081182]=A0 ? cifs_handle_standard+0x190/0x190 [cifs]=0A=
[366603.082048]=A0 ? kthread_bind+0x20/0x20=0A=
[366603.082896]=A0 ? do_syscall_64+0x79/0x1b0=0A=
[366603.083716]=A0 ret_from_fork+0x35/0x40=0A=
[366603.084541] Code: e7 da e0 84 c0 74 0e 49 8b 17 49 8b 47 08 48 89 42 08=
 48 89 10 49 8b 47 38 4d 89 3f 4c 89 ff 4d 89 7f 08 e8 4d 3f 5e e1 4d 39 ec=
 <49> 8b 04 24 75 c4 65 4c 8b 2c 25 40 5c 01 00 eb 31 f6 05 66 0a=0A=
[366603.087050] RIP: cifs_reconnect+0x286/0x620 [cifs] RSP: ffffc90005a53d7=
0=0A=
[366603.087856] CR2: 0000000000000000=0A=
[7.] A small shell script or example program which triggers the=0A=
=A0=A0=A0=A0 problem (if possible)=0A=
=0A=
Vidhesh Ramesh=
