Return-Path: <SRS0=vo2T=CD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05879C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Aug 2020 21:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6272074A
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Aug 2020 21:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="smq/8CzC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgHYVQW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Aug 2020 17:16:22 -0400
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:47239
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgHYVQT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 25 Aug 2020 17:16:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kul6Oh9v74jRoDCK8d3yvZ6oE7sPfdGHw+eoijOw12WGlwpGTkT3ewvXNkWTKimOxWFY45oqe1AG/a/czsiezOQ8z1cERf8sAPBD/wq9FqTvm7AfomVbIIaPrhZNhGlK7jTjQ1R45xPXljLH9kAGbw+fOULdDUibAGnEQ8+hQyjqsfUoIH2hR/e8drgXL8fcLDW82T4+384mKvlNFDxGV6E3dnJPkBZJhMzUNIuL1hydBrFWna049EQLEAvB9zzS8VwdOG6E2mOFO38k6l1RKR26JDWfruaYV+U2gX23ePT+TkftZP5QWhn7K6IfaGVEz8wDnevPufxHazfJtkgK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0PRuwZgsvbMvfQXNO2P9yQmlA1RO7gu5qde3Uzkihk=;
 b=A+fbfbESE+nXYp9v5yuknCkRiiaGAiM68mS3AKpmRMkcd+YIby38uOohTkhW4QiBkfkhOswRH8UB+xEb1tdsHFLrNDwFVm3ZP0kynnrBEwyL727XbQWr9dMYjboSVvD68/QkLscPywPRlqQJEJPjGKCDtbSttDE9fEUDZ1ODjiNtjMcDDPbdoyvfZaPUUuSfZzbrRSw9ZvvyRgESCE7CkxiJ4HsW5dD5erYVBvcfrfw0oEk0KzoYX7kKh9VAtGdc0+yZ6OiRxQb2sMT8LodtYE3j/3tXfKzShwFctQhOLyonlH7y+XEQ0kiYupsQr3VGRGf1bTJn0EJad33Kq9JnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0PRuwZgsvbMvfQXNO2P9yQmlA1RO7gu5qde3Uzkihk=;
 b=smq/8CzCtNH40w78WunNQ4nn3Ifc9EHMWPPJSMAWDTu41y8VxBTxwzzQssU+YfleEiAlzaNoq++oc/1d8D6fo6sFPoroPuowhoa+IxlEP6atx67dYvQKOykSVvzvAwImlRenqIyv263SJyKS/G1t+Vviv2M6veYPkgUeEQWnz5w=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BYAPR16MB2536.namprd16.prod.outlook.com (2603:10b6:a03:86::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Tue, 25 Aug
 2020 21:16:15 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::b108:7150:bd4d:5cc4]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::b108:7150:bd4d:5cc4%6]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 21:16:14 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Oops in cifs_negotiate_protocol - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in cifs_negotiate_protocol - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWdPUttde7I4ogoE2xW8+tLiwFcKlJX4pv
Date:   Tue, 25 Aug 2020 21:16:14 +0000
Message-ID: <BYAPR16MB2615101D857F6A55AF5A39BFE2570@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <BYAPR16MB2615BE259AC55E3F8D26EBF4E25C0@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB2615BE259AC55E3F8D26EBF4E25C0@BYAPR16MB2615.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=komprise.com;
x-originating-ip: [24.5.193.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69d9824d-a4bd-406d-238e-08d8493c199d
x-ms-traffictypediagnostic: BYAPR16MB2536:
x-microsoft-antispam-prvs: <BYAPR16MB2536AB5B2FEA6850BAE3CF3FE2570@BYAPR16MB2536.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: euTbs9yQxFmqhxexjWLTxT/Ey5hI81rPEgvTVb+vq6VP1/pihTjZLLAIroUPE6X3irMYV4OwIkKQcP714dVZFhz0OyWqiT5yGTpasc3V2HhVIihDhnJHe6nNWyhQaYOIuC0BcH9L1pttzBXRf4cucF0DftQNaUDqQqwCyUCvxQZSt+NqL+8cG2UFNSQkFOM6vRxvRsKp6tHb70tSeKYpexNuFXviB4u2PegK/RUP1DqRR6gkq8W5HR6ZbhEtyImj7Wzz6H8DGBrvAZbOav2atIjURbeEKnbO+b0gBjnabrpRE/flJ3SNqQtehj68eg1I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(346002)(136003)(39830400003)(64756008)(66556008)(91956017)(66476007)(2906002)(186003)(316002)(76116006)(478600001)(26005)(66946007)(33656002)(52536014)(66446008)(8936002)(71200400001)(7696005)(6506007)(44832011)(6916009)(8676002)(86362001)(9686003)(55016002)(53546011)(83380400001)(5660300002)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QIdkl85R5gQJd+UYKCs7E/CFrxKRwDTaqMToBwNrCOz6Y/OZ7rGRZ1lxqt0t11U3U9b7TW2LmQ+q1qu90KB/8KdZZJPlg/EsIw+zcrboPXdDpv9qpNYS5IYKbB98/H06ar55/UO/DvvrDYYHkJrNqM3kCVj7qWw2395d0fytm4gh3srGfwLwC11vHpEC1IrGE/uydWqOCagwvOWa9o5TdAANqmBeZVU9fOcIVBkg2Ipvt4HwE8wTJQbI+2z0ME0HDazyD3L+NVc5K6s1PNQyYCrAlRXiG8vmNLhFRtKRjWrqclJNtZ5i0xiW4Vedco7VMGSlO0o214ehOv+OJpOcc5MoUfTpymgRrQewGbD4GKQZZMxegvlAETXHYAmGeenASRDTfLAWY0RDN7A3gXPcPMAmvXE7s7yE7lQgCoq0uJDhyKFbF0C63vLVnQeTQ8htorrOwyK6BPepVoGZp0uQEHtMfiU5yOMqozBrdnmDj9XFEJ4QwBhJmHiuAtc7OYt+fwCpAAX9PBnXP6AbZEZCwe17LTEq7VnVtD58F4EP0yhi/AO1qqBfsJprhPm6ooRbkt4c4QWKmHh9krV7iVze7BR5W6AqJILZmoV4k4antoBYRpJ/CVEMRmbsGhjvHfmKFKMTFc2M/CfAucNJUBCG2Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d9824d-a4bd-406d-238e-08d8493c199d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 21:16:14.5451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x442o3NoGkddGqwerPew9bAKAj2lVhzHHllMBu558UUxUpucdyulQi23KAuazCJqDtiULMWiCPQReBdpqhCamvY2Mi/UqggQBXv2kqEjHn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR16MB2536
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
=0A=
