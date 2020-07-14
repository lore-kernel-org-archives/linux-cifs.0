Return-Path: <SRS0=KB7a=AZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBDDC433E3
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 17:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092822074A
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 17:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="00WulHEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNRer (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jul 2020 13:34:47 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:62785
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726169AbgGNRer (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Jul 2020 13:34:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nfbk31XX+QFT+i+qLYk//1KkjZi1f8Io19vQaYXfKz8I64h6aheeocGuryHPdPmf2dE7MVQjS0UPABhdtM2jokl2iUGx+yUgiZ1uOJEVwf8z3rvFrK4EzSsBByELvIfDFTN7BWYIOKwN8ETpL93vdWxQ2Waqz+bS1LlJPh6yuAMugeSa80wonjx4YgMOwTfyN+mqnjfIEXyMr/9SH6odS5UMNz6sns9bBpkSVmyhnwM9YpOZN1snc4VkYlmhrF1R92UdCoQM5QWSSH+PAJXMqSsi6Drq40BBk5rX4J4JlfVRwZaH9QCV4koLBIpn3UZlv/5IvYe5Ah14UxJt1q6nTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AqtPYaQvi502sgUZpbN+UzlVQYUh06Z64neTHBDZQc=;
 b=j1hmKvD43ZH1f1LMQIjBfA8JT541yheGXT9rVNb+i0A7hJHeEKuESpn2JaQI6m3YZcbB/91HX0a8Di59/VdoIfcl4s/TGliqlPorzIPduSLDZN6Yufyalonzv+kI5SSCXlcoalhOLriBuHfovSIIw2DPn5Y4jE7oxoHWbNjMEfsBHZFWeH4T1cEhyRRXo5oC34NoeUMpqVQ/zw6yTa4vBsttOFPD4M0mzjicj/CTd9qAvpBkWYNM6CUFj62tAot9BERvEqjiaf151LgucuiL9IK8EHk0ZdjpuvxlBEawn4re3GvX+W3JWSFyiOdKxrlZf4PuDnlD1kJkKUsrbYGuuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AqtPYaQvi502sgUZpbN+UzlVQYUh06Z64neTHBDZQc=;
 b=00WulHEd5qLXQajQiM1LOJlYn0qMA5hmBhABwnpfwuAdwXrsxOB4tOO+GQFkVBLn97zUMSPN5hM2Tst/A1y3tU5Sz26EDibZ/U/6ARPxqZEVBeyedzbykmpwMTs3j+s7pZ+kyjRc5N/bTjSUCkApKR8kaCWKjPuYtmcvJp89dyk=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BY5PR16MB3301.namprd16.prod.outlook.com (2603:10b6:a03:190::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Tue, 14 Jul
 2020 17:34:41 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::99d9:a6f:4f4a:4993]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::99d9:a6f:4f4a:4993%3]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 17:34:41 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Oops in cifs_match_super() - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in cifs_match_super() - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWSq9edtCo81aaX06K8scfXoPZ86jz61slgBOCXOSAAAa8hw==
Date:   Tue, 14 Jul 2020 17:34:40 +0000
Message-ID: <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <MW3PR16MB37063A82C9A57CC67EB5BE1F87920@MW3PR16MB3706.namprd16.prod.outlook.com>,<BYAPR16MB26152FB66647DB8FCAED346CE26D0@BYAPR16MB2615.namprd16.prod.outlook.com>,<BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=komprise.com;
x-originating-ip: [24.5.193.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 354ef17b-09bd-477d-ac01-08d8281c3077
x-ms-traffictypediagnostic: BY5PR16MB3301:
x-microsoft-antispam-prvs: <BY5PR16MB3301E23D2BB31ADD64B354BDE2610@BY5PR16MB3301.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhXzLm3gChTM4J1F/SDJ4/uJt971Q7+V1z3VNFM3pFzPq6HD1ttoAnJk9YHcgQzMKIcbEDYjJDcBBh2R0IO0YnQYhDuDOSqUNLhHNjUHHvue/H04AdrkBtz2Qj2R81kyYVJgeg6+56Q6vizp6rX4xbC0cjoMcISFOkQvIazfdkkxZisHezhKbCnFqDTZw4WfDh/lxjxTMKirBRir2QJGLLuGZPPzmcEzV7Dvstjj1TeOaruRT7Nnk9Jqxn96TVnX4TpwReDFWnHzHagtPYj4i1gJoEZjQy8TLStj+TBM6+Uvi+CuCaW1wMn/1uzLIbVhXcJ8auJJeipU3ANbjpU21TRCdUNMECEBbrlw+ZQeRza1nmTH3gvWj2H1Hrp/sn6EGKy5sWHjDm5LnZQja2XdYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(346002)(366004)(39850400004)(2906002)(6916009)(2940100002)(91956017)(186003)(316002)(76116006)(45080400002)(26005)(44832011)(64756008)(478600001)(86362001)(9686003)(5660300002)(52536014)(15974865002)(55016002)(66556008)(66476007)(66946007)(66446008)(8676002)(83380400001)(7696005)(8936002)(33656002)(71200400001)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZO6fAJj1i4Z4/Orxt9qG5y+dY1dtFZ9iE8+UCvkk3Gn1KQXunCTjv9bKtwTpc6wFhCXGKHFJK3UvyhjduLSnyL0g8zftMXI+WxzRyNguFcDQ50hD7dxH0aF14VRwrMVG2vZrVjLmsfo1yW7MhTgwCWfuZMjFTF9JPN89vQ2GYELRjiLKmT+BN7p37XoBXDPABdZidSLCQmXbODez2ZbbJvVoVMPADIDScYT9lDlD7ud0A0UP2IsfGjQsECl94PBUAJxnei+WopsFKa/Hqofq+pRr1LrUHO00qbH6pUIl/yOdsyNrlq2/tCoq2f2O6OfW6fN1zTs1d3yPoAspFKQmhuRSspKEh4yXz+w8hCfMNzD+l08VA82J9MOInmq16EYphoGsb/X9Mhv99r0HxSHJnV5viYNb7C9tb93opkYlPf2a5Nedla06NPv0TnGG3A2bSxs/FWvvRI959Vh7cyMAtUHYIwxBR8aM0XVOd4faBiM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354ef17b-09bd-477d-ac01-08d8281c3077
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 17:34:40.8420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HffJLSj9rdI9oVy3sDGfD2QqV2jP+4i7V5S2AfEAEJLMCPcnmXMfl8CR7jZ8vOjSL8FIJYjPIBhewnLlJGB2Eex/tFW5xYgXuE5LGNYkmjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR16MB3301
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding linux-cifs mailing list.=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Sent: Tuesday, July 14, 2020 10:18 AM=0A=
To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-cif=
s@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@lists.=
samba.org>=0A=
Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64 =0A=
=A0=0A=
Hi Steve et all,=0A=
=0A=
Resending this as a gentle=A0reminder=A0if anyone got a chance to look at t=
he below mentioned oops kernel panic.=0A=
=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Sent: Thursday, July 2, 2020 12:21 AM=0A=
To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-cif=
s@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@lists.=
samba.org>=0A=
Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64 =0A=
=A0=0A=
Hi Steve et all,=0A=
=0A=
Resending this as a gentle reminder if anyone got a chance to look at the b=
elow mentioned oops kernel panic.=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
Sent: Wednesday, June 24, 2020 10:26 PM=0A=
To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-cif=
s@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@lists.=
samba.org>=0A=
Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Subject: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.x86_=
64 =0A=
=A0=0A=
Hi Steve et al,=0A=
=A0 =A0My name is Ameya and I work for www.komprise.com.=A0 The linux kerne=
l with above mentioned version has been panicing, though randomly, but the =
stack trace appears is consistent.=A0 You can find more details in the atta=
chments.=A0 Below is the brief description of the problem -=0A=
=0A=
[1.] One line summary of the problem:=0A=
oops kernel panic=0A=
[2.] Full description of the problem/report:=0A=
ESX VM hangs with a kernel panic when cifs shares are mounted. Unable to ss=
h to the VM and the console of the VM is also not responding. With kdump se=
rvice running and core collected the VM restarts successfully.=0A=
[3.] Keywords (i.e., modules, networking, kernel):=0A=
cifs, kernel, panic, strcmp, mount=0A=
[4.] Kernel information=0A=
[4.1.] Kernel version (from /proc/version):=0A=
Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc version=
 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 EDT 20=
18=0A=
[4.2.] Kernel .config file:=0A=
Please check the file uploaded=0A=
[5.] Most recent kernel version which did not have the bug:=0A=
[6.] Output of Oops.. message (if applicable) with symbolic information=0A=
     resolved (see Documentation/admin-guide/oops-tracing.rst)=0A=
[442282.069937] BUG: unable to handle kernel NULL pointer dereference at 00=
00000000000000=0A=
[442282.071474] IP: strcmp+0xe/0x30=0A=
[442282.072892] PGD 0 P4D 0=0A=
[442282.074196] Oops: 0000 [#1] SMP PTI=0A=
[442282.075561] Modules linked in: binfmt_misc fuse cmac rpcsec_gss_krb5 nf=
sv4 arc4 md4 nls_utf8 cifs ccm dns_resolver nfsv3 nfs fscache nf_conntrack_=
netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ipt_REJECT nf_reject_=
ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat e=
btable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6=
table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 n=
f_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_securi=
ty iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_f=
ilter vmw_vsock_vmci_transport vsock sb_edac crct10dif_pclmul crc32_pclmul =
ghash_clmulni_intel pcbc ppdev aesni_intel vmw_balloon crypto_simd glue_hel=
per cryptd sg intel_rapl_perf input_leds pcspkr joydev shpchp=0A=
[442282.090386]  parport_pc parport i2c_piix4 vmw_vmci nfsd nfs_acl lockd a=
uth_rpcgss grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom ata_generic sd=
_mod pata_acpi crc32c_intel serio_raw vmwgfx drm_kms_helper syscopyarea sys=
fillrect sysimgblt fb_sys_fops ttm mptspi scsi_transport_spi ata_piix mptsc=
sih vmxnet3 drm mptbase libata floppy dm_mirror dm_region_hash dm_log dm_mo=
d dax=0A=
[442282.095332] CPU: 4 PID: 9273 Comm: mount.cifs Tainted: G        W      =
  4.16.2-1.el7.elrepo.x86_64 #1=0A=
[442282.097802] Hardware name: VMware, Inc. VMware Virtual Platform/440BX D=
esktop Reference Platform, BIOS 6.00 04/05/2016=0A=
[442282.100363] RIP: 0010:strcmp+0xe/0x30=0A=
[442282.101645] RSP: 0018:ffffc9001bff7c88 EFLAGS: 00010202=0A=
[442282.102919] RAX: 0000000000000001 RBX: ffff8802ad7c2400 RCX: 0000000001=
240404=0A=
[442282.104207] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000=
000001=0A=
[442282.105497] RBP: ffffc9001bff7c88 R08: 0000000001240404 R09: 0000000000=
000001=0A=
[442282.106765] R10: ffff88017d2c2b40 R11: ffff8801744c0e50 R12: ffff88011f=
793000=0A=
[442282.108038] R13: ffff88042b105800 R14: ffffc9001bff7d98 R15: ffff8801b6=
3c0f00=0A=
[442282.109318] FS:  00007f3e90ee6780(0000) GS:ffff88043fd00000(0000) knlGS=
:0000000000000000=0A=
[442282.110630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[442282.111970] CR2: 0000000000000000 CR3: 000000011b2ea000 CR4: 0000000000=
0406e0=0A=
[442282.113405] Call Trace:=0A=
[442282.114849]  cifs_match_super+0x123/0x210 [cifs]=0A=
[442282.116211]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]=0A=
[442282.117541]  sget_userns+0x88/0x4a0=0A=
[442282.118877]  ? cifs_kill_sb+0x30/0x30 [cifs]=0A=
[442282.120203]  ? cifs_prune_tlinks+0xe0/0xe0 [cifs]=0A=
[442282.121502]  sget+0x7d/0xa0=0A=
[442282.122781]  ? cifs_kill_sb+0x30/0x30 [cifs]=0A=
[442282.124072]  cifs_do_mount+0x168/0x5a0 [cifs]=0A=
[442282.125364]  mount_fs+0x3e/0x150=0A=
[442282.126627]  vfs_kern_mount+0x67/0x130=0A=
[442282.127850]  do_mount+0x1f5/0xca0=0A=
[442282.129047]  SyS_mount+0x83/0xd0=0A=
[442282.130257]  do_syscall_64+0x79/0x1b0=0A=
[442282.131583]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2=0A=
[442282.132687] RIP: 0033:0x7f3e907fdfea=0A=
[442282.133754] RSP: 002b:00007ffee9139868 EFLAGS: 00000202 ORIG_RAX: 00000=
000000000a5=0A=
[442282.134842] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3e90=
7fdfea=0A=
[442282.135909] RDX: 000055d13f5953b2 RSI: 000055d13f5953f9 RDI: 00007ffee9=
13bb51=0A=
[442282.136944] RBP: 00007ffee913bb46 R08: 000055d1415e80d0 R09: 0000000000=
001000=0A=
[442282.137962] R10: 0000000000000000 R11: 0000000000000202 R12: 00007f3e90=
ef0000=0A=
[442282.138957] R13: 000055d1415e80d0 R14: 00007f3e90ef290f R15: 0000000000=
000000=0A=
[442282.139918] Code: 80 3a 00 75 f7 48 83 c6 01 0f b6 4e ff 48 83 c2 01 84=
 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 84 c0 74 18 48 83 c7 01=
 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 31=0A=
[442282.142829] RIP: strcmp+0xe/0x30 RSP: ffffc9001bff7c88=0A=
[442282.143759] CR2: 0000000000000000=0A=
[7.] A small shell script or example program which triggers the=0A=
     problem (if possible)=0A=
=0A=
My colleague Vidhesh (CC'ed) will be glad to share further details on the t=
est scenario and/or in-house reproduction.=A0 Please let us know of workaro=
unds, if any.=0A=
=0A=
Thanks and Regards,=0A=
=3D Ameya=0A=
=0A=
