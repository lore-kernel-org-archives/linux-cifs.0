Return-Path: <SRS0=wfZ6=BY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FDBC433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Aug 2020 19:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1178120838
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Aug 2020 19:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="bSJnaVV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHNTpF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Aug 2020 15:45:05 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:38465
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726213AbgHNTpF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Aug 2020 15:45:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYsqnkWt4r7b9AxCoN7vlFqYHzfk1bP3dLikbn8RST95u5UjIUldW1QDyC9tmOmRaOVreq213sj71/hWgcn0lutCtBZ4Z/bSA5+gvODHDQQusDhka7oP+8xODLq/JcyzmBw6yDeytiHPB9RPswfqNOOIn2oNm/xbuhjvDlmnwjVMQxF7ZWzkkdglfGhe85iOpcDZqP1S/2R6Ot4RPEwEW36U64S6Xbnd57kIF9jc5y8LTv8E/fMsyGB9dCw6wzdnsi/BNuLvE9lRNqh/FR4MpyIM8GNIEBCPEct0EgYYPJxBtjBd45XQ38GMMzzA27mjgO4EvABvLEp6JUXcn/wgqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh2GLUu+3jY7uUzOV3NQaSscjSFh26eaQ5PVWpHZCdg=;
 b=eZhrcRl12dXylbknvT8BdX9P7w3zwDWRUxnvVkz6Ff6GbZyp9U7iLu2ccfx6ThyvP1KtXEruBKkCK2o3cff0gnciSHuwbFbkxoMgjixrPsrwIsAkT7FvceIEqSuGhqeneeYUZsn6wV4jMN2M/iDDkN7R3P+dqSWRY60k0QZcZKP9G9PPste3NkHhop+j3HskDE9sfXpIRfiUEovRPkfJRiUVVnI+P+9wsGaI0jAPkQRJJwpNJCrzefhJWddtLnJjDvNqRMOAQp01B8HNLhQdowP8JgH9M07p24cn75t1mKe4r/pVUiw6gCawnrjECVZF0ma24j3N1Q1wHbVJt6py6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh2GLUu+3jY7uUzOV3NQaSscjSFh26eaQ5PVWpHZCdg=;
 b=bSJnaVV4mth9MK2TdwSIkF9+0p/JzWAMCsqF8cpriAjm7inA7Ga6KCX5yGhkX5Zs7FgxyYY7ooA7mAnxjI6JxKLlvE5vBHeqKr5KRoBhG/EokRdkjXp6yVPzVdM63HfmkomajRL7UTmc2kinAsqKICJFz927Zx7HfpJPqRywzoM=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BY5PR16MB3411.namprd16.prod.outlook.com (2603:10b6:a03:195::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Fri, 14 Aug
 2020 19:44:58 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::99d9:a6f:4f4a:4993]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::99d9:a6f:4f4a:4993%3]) with mapi id 15.20.3261.025; Fri, 14 Aug 2020
 19:44:58 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     Steve French <smfrench@gmail.com>
CC:     Kenneth Dsouza <kdsouza@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Oops in cifs_match_super() - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in cifs_match_super() - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWSq9edtCo81aaX06K8scfXoPZ86jz61slgBOCXOSAAAa8h4AAAm8AgAACGQCABCW3fYAAUneAgAB5rTiAAAa3gIAr3xe+
Date:   Fri, 14 Aug 2020 19:44:58 +0000
Message-ID: <BYAPR16MB2615525002793CBE10F9E0B8E2400@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <MW3PR16MB37063A82C9A57CC67EB5BE1F87920@MW3PR16MB3706.namprd16.prod.outlook.com>
 <BYAPR16MB26152FB66647DB8FCAED346CE26D0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAA_-hQJuAnELV+DKhst9iwyC_x7-CDkRKjneTFHgUcM3DSb2gQ@mail.gmail.com>
 <CAH2r5ms3567LG2rNiTDJgykuu3F8916VH2tjJOXnk+FMRC3giQ@mail.gmail.com>
 <BYAPR16MB26156E99DAEAC5AB16C644A0E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAH2r5ms2jsH2ka-9SAaN8v61YL16jN401uEDZJ7Uo0H0pLtH7g@mail.gmail.com>
 <BYAPR16MB261559669B8ECAB936C7E4C5E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>,<CAH2r5mt19W_Ceb+SB5e22+Gm2=UBbNiGbQ07EsX-oaCzPTtDrQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt19W_Ceb+SB5e22+Gm2=UBbNiGbQ07EsX-oaCzPTtDrQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=komprise.com;
x-originating-ip: [24.5.193.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0aae1d4-d153-4446-5def-08d8408a86ec
x-ms-traffictypediagnostic: BY5PR16MB3411:
x-microsoft-antispam-prvs: <BY5PR16MB3411136FEA8DDFA7AFE917D2E2400@BY5PR16MB3411.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j9ln3zH0LSydORt/XiUDtk0eTjl9hflBfrR0s71TSIvCieB9iWPJZr81617S1+QQsQWcnLpfRdTmwejT22eCSzi5HQAGrIycXAvcb0/XwROdffpAQVEeLTAfe4U2UAUAv/NydTTSNj9pivyrV3Z5eF8O0gWWlqigw/m3kIN/mrPRk4yW1T1Bze4YDkvKmIITv78Yasw9DdKlV/G0CkxoaVAXGZk2FOqoI53g2K1eCAklpbbYjUYd7eUlqiuhDW+UIZyJytJF1GYx8TU50vkcNMBhJohyUQASmJJtCaZLWNX5i+BiNqauYlYAd83rz4PPkCSJHnwzAH24Fh5XDgLzIZyR3jH3oe5ozm1MDH4FVwQeoZAsKWjFUvvX2MQq6Ux7+WG+CEZqr7OSt1wkuHYpPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(396003)(39850400004)(66446008)(91956017)(54906003)(30864003)(316002)(86362001)(64756008)(76116006)(66946007)(66476007)(66556008)(7696005)(52536014)(6916009)(2906002)(15974865002)(5660300002)(186003)(83380400001)(45080400002)(26005)(33656002)(53546011)(6506007)(8936002)(508600001)(55016002)(44832011)(71200400001)(966005)(4326008)(8676002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iDwVgaKVggMpvEw4qrKQ7n+Mjpkd3HBUaoePrETp82FrhxCLxdIw3fHmUEoKTF3NkVBjmxB+Mn+Ca7lZVSGi3trvD5VnhTC0oC2ZX6Sxyp6xXTZamqC+6rvPssqIblSdSYs5eGgNX/ayV8nrIRhmuC3Qpc/bp8yLN48I0R6ipIgNQ9ZYWn8Yr1CZ+qSJEpz8KW2GyM42+wDaFoLxLq5RcjDQ4WhwL4WvQ9LLOKDd+NNO6pwD5L2VQzljDnUVYsRQEKHnVuZclC7qYE3CKQx258m/ZhdPGJPnnX46BpXSud4+87E276Efx2Hk8SOYz3jqhpATrVgCEs01JAz1GIfXV6h20apRSmZiYLB8SygRt4W4AYlP+m6cLdf1E/cuXsjkNvoBquL+li65PbJDsoNKBjh/tn0qISlhG4wKd9UKT793TeKtptiqlRhZ/QCLPk55FrrwlpDUMh6lLAKEoduEQ2t9g2mgcmwBBLEJXK4z2B0BLtrJMxDSFiybn30fiS5j1x8JSVYiaVGwFLneQx/dipaI4m0kfmrxGb2kS/DQHa9lrn1QRJ+ce4aUW+F7Wi1I2Uc97wNoTbLkuCqdP9wTNZnwf6TMuzgI9tBmePp/XWoRZ1TUqy6qUsPhg6gUMC0AIcTJGIdknz1cByRxl1BnuA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0aae1d4-d153-4446-5def-08d8408a86ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 19:44:58.4418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8tVvtHCSzvtvOsipniEa4570/JMM2o9OlpfXqpi2OsSJETnAV+OnEtdd3k//S1/UXqKjpCJMwEfo83MrunwKrXZAjGjPSDWQd7AsoNCQudM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR16MB3411
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve,=0A=
=0A=
I was able to get hold of 4.19 build 134.=0A=
=0A=
I am also seeing the following 2 NPE in CIFS on kernel 4.16.2.1 and was hop=
ing to see if these 2 are also fixed in 4.19 kernel ?=0A=
=0A=
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
[255120.503180]  i2c_piix4 nfsd nfs_acl lockd auth_rpcgss grace sunrpc ip_t=
ables xfs libcrc32c sr_mod cdrom sd_mod ata_generic pata_acpi serio_raw crc=
32c_intel floppy vmxnet3 vmwgfx drm_kms_helper syscopyarea sysfillrect sysi=
mgblt fb_sys_fops ttm ata_piix drm libata mptspi mptscsih mptbase scsi_tran=
sport_spi dm_mirror dm_region_hash dm_log dm_mod dax=0A=
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
[255120.513246] FS:  0000000000000000(0000) GS:ffff88043fc00000(0000) knlGS=
:0000000000000000=0A=
[255120.514048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[255120.514832] CR2: 0000000000000038 CR3: 000000042a5b2000 CR4: 0000000000=
0406f0=0A=
[255120.515696] Call Trace:=0A=
[255120.516545]  smb2_reconnect+0x108/0x420 [cifs]=0A=
[255120.517410]  ? remove_wait_queue+0x60/0x60=0A=
[255120.518249]  smb2_reconnect_server+0x1d4/0x340 [cifs]=0A=
[255120.519102]  process_one_work+0x15f/0x370=0A=
[255120.519962]  worker_thread+0x4d/0x3e0=0A=
[255120.520808]  kthread+0x105/0x140=0A=
[255120.521642]  ? max_active_store+0x80/0x80=0A=
[255120.522456]  ? kthread_bind+0x20/0x20=0A=
[255120.523254]  ? do_syscall_64+0x79/0x1b0=0A=
[255120.524035]  ret_from_fork+0x35/0x40=0A=
[255120.524791] Code: 64 a0 e8 ff 08 ab e0 5b 41 5c 41 5d 5d c3 0f 1f 84 00=
 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 f4 53 48 8b 5e 48=
 <48> 8b 43 38 48 8b 90 b8 00 00 00 48 85 d2 0f 84 97 00 00 00 48=0A=
[255120.527052] RIP: cifs_negotiate_protocol+0x15/0xd0 [cifs] RSP: ffffc900=
113e7d40=0A=
[255120.527807] CR2: 0000000000000038=0A=
=0A=
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
[366603.064108]  vmw_vmci shpchp nfsd nfs_acl lockd auth_rpcgss grace sunrp=
c ip_tables xfs libcrc32c sr_mod cdrom sd_mod ata_generic pata_acpi crc32c_=
intel serio_raw vmxnet3 mptspi mptscsih mptbase scsi_transport_spi vmwgfx a=
ta_piix drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm li=
bata drm floppy dm_mirror dm_region_hash dm_log dm_mod dax=0A=
[366603.066558] CPU: 6 PID: 5920 Comm: cifsd Tainted: G        W        4.1=
6.2-1.el7.elrepo.x86_64 #1=0A=
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
[366603.074406] FS:  0000000000000000(0000) GS:ffff88043fd80000(0000) knlGS=
:0000000000000000=0A=
[366603.075162] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[366603.076031] CR2: 0000000000000000 CR3: 0000000427c88000 CR4: 0000000000=
0406e0=0A=
[366603.076896] Call Trace:=0A=
[366603.077706]  cifs_readv_from_socket+0x1b4/0x200 [cifs]=0A=
[366603.078621]  cifs_read_from_socket+0x52/0x70 [cifs]=0A=
[366603.079458]  cifs_demultiplex_thread+0x11b/0xa90 [cifs]=0A=
[366603.080313]  kthread+0x105/0x140=0A=
[366603.081182]  ? cifs_handle_standard+0x190/0x190 [cifs]=0A=
[366603.082048]  ? kthread_bind+0x20/0x20=0A=
[366603.082896]  ? do_syscall_64+0x79/0x1b0=0A=
[366603.083716]  ret_from_fork+0x35/0x40=0A=
[366603.084541] Code: e7 da e0 84 c0 74 0e 49 8b 17 49 8b 47 08 48 89 42 08=
 48 89 10 49 8b 47 38 4d 89 3f 4c 89 ff 4d 89 7f 08 e8 4d 3f 5e e1 4d 39 ec=
 <49> 8b 04 24 75 c4 65 4c 8b 2c 25 40 5c 01 00 eb 31 f6 05 66 0a=0A=
[366603.087050] RIP: cifs_reconnect+0x286/0x620 [cifs] RSP: ffffc90005a53d7=
0=0A=
[366603.087856] CR2: 0000000000000000=0A=
=0A=
=0A=
=0A=
=0A=
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
=0A=
=0A=
=0A=
=0A=
From: Steve French <smfrench@gmail.com>=0A=
Sent: Friday, July 17, 2020 2:44 PM=0A=
To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Cc: Kenneth Dsouza <kdsouza@redhat.com>; CIFS <linux-cifs@vger.kernel.org>=
=0A=
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64 =0A=
=A0=0A=
I see only 13 'cc:stable' patches missing from 4.19.113 for cifs.ko. See be=
low:=0A=
=0A=
smfrench@smfrench-ThinkPad-P52:~/linux-stable-rc$ git log --oneline=0A=
v4.19.113.. fs/cifs=0A=
38bcc785c2eb cifs: update ctime and mtime during truncate=0A=
e1afc2c1baa5 cifs: Fix the target file was deleted when rename failed.=0A=
6f9e471d62ae SMB3: Honor lease disabling for multiuser mounts=0A=
da6845a443dc SMB3: Honor persistent/resilient handle flags for multiuser mo=
unts=0A=
c0651cd829ee SMB3: Honor 'seal' flag for multiuser mounts=0A=
1fa012710599 SMB3: Honor 'posix' flag for multiuser mounts=0A=
39dad7304057 cifs/smb3: Fix data inconsistent when zero file range=0A=
f4c710c4a39b cifs/smb3: Fix data inconsistent when punch hole=0A=
4d9248f989ec cifs: Fix null pointer check in cifs_read=0A=
ad149b6e08f1 cifs: fix leaked reference on requeued write=0A=
6c662c519277 cifs: protect updating server->dstaddr with a spinlock=0A=
731a3bc2be26 cifs: Allocate encryption header through kmalloc=0A=
9bc022589575 CIFS: Fix bug which the return value by asynchronous read is e=
rror=0A=
=0A=
There are 113 cifs (cc:stable) patches in the 4.19.133 tree (out of=0A=
the 628 total patches to cifs.ko between 4.19 and now, 5.8-rc). See=0A=
attached=0A=
=0A=
On Fri, Jul 17, 2020 at 4:23 PM Vidhesh Ramesh=0A=
<vidhesh.ramesh@komprise.com> wrote:=0A=
>=0A=
> Thanks Steve.=0A=
> We have few more bug fixes that we need in 4.19 LT kernel. However I am u=
nable to get a built kernel RPM of latest build 133 of kernel 4.19.=0A=
> The latest I could get is build 113 of kernel 4.19 at https://buildlogs.c=
entos.org/c7-kernels.x86_64/kernel/20200330213326/4.19.113-300.el8.x86_64/k=
ernel-4.19.113-300.el7.x86_64.rpm=0A=
>=0A=
> Vidhesh Ramesh=0A=
>=0A=
> From: Steve French <smfrench@gmail.com>=0A=
> Sent: Friday, July 17, 2020 7:05 AM=0A=
> To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> Cc: Kenneth Dsouza <kdsouza@redhat.com>; CIFS <linux-cifs@vger.kernel.org=
>=0A=
> Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64=0A=
>=0A=
> I am not familiar with your distro but a Google search matched on this as=
 a more recent kernel rpm download with similar sounding name http://lists.=
elrepo.org/pipermail/elrepo/2018-May/004282.html=0A=
>=0A=
> But there should be more recent kernels than that are eg based on newer 4=
.6.18 stable branch https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git/log/?h=3Dlinux-4.16.y=0A=
>=0A=
> On Fri, Jul 17, 2020, 04:12 Vidhesh Ramesh <vidhesh.ramesh@komprise.com> =
wrote:=0A=
> Thanks Steve and Kenneth for your responses.=0A=
>=0A=
> I did look at the commits and found that this has been fixed in a patch o=
f 4.19. Is there an archive where I can download latest 4.19 kernel rpm so =
that I can verify the fix ?=0A=
>=0A=
> Vidhesh Ramesh=0A=
>=0A=
>=0A=
>=0A=
>=0A=
>=0A=
>=0A=
> From: Steve French <smfrench@gmail.com>=0A=
> Sent: Tuesday, July 14, 2020 10:49 AM=0A=
> To: Kenneth Dsouza <kdsouza@redhat.com>=0A=
> Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>; linux-cifs@vger.kernel.=
org <linux-cifs@vger.kernel.org>=0A=
> Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64=0A=
>=0A=
> If you have a particular stable kernel used for your distro you can=0A=
> email stable@vger.kernel.org with the commit id and version you want=0A=
> it backported for.=0A=
>=0A=
> On Tue, Jul 14, 2020 at 12:43 PM Kenneth Dsouza <kdsouza@redhat.com> wrot=
e:=0A=
> >=0A=
> > You are hitting a known bug which has been fixed by below patch and is=
=0A=
> > part of v5.6 and above.=0A=
> >=0A=
> > commit fe1292686333d1dadaf84091f585ee903b9ddb84=0A=
> > Author: Ronnie Sahlberg <lsahlber@redhat.com>=0A=
> > Date:=A0=A0 Wed Jan 22 11:07:56 2020 +1000=0A=
> >=0A=
> >=A0=A0=A0=A0 cifs: fix NULL dereference in match_prepath=0A=
> >=0A=
> >=A0=A0=A0=A0 RHBZ: 1760879=0A=
> >=0A=
> >=A0=A0=A0=A0 Fix an oops in match_prepath() by making sure that the prep=
ath string is not=0A=
> >=A0=A0=A0=A0 NULL before we pass it into strcmp().=0A=
> >=0A=
> >=A0=A0=A0=A0 This is similar to other checks we make for example in cifs=
_root_iget()=0A=
> >=0A=
> >=A0=A0=A0=A0 Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>=0A=
> >=A0=A0=A0=A0 Signed-off-by: Steve French <stfrench@microsoft.com>=0A=
> >=0A=
> > On Tue, Jul 14, 2020 at 11:05 PM Vidhesh Ramesh=0A=
> > <vidhesh.ramesh@komprise.com> wrote:=0A=
> > >=0A=
> > > Adding linux-cifs mailing list.=0A=
> > >=0A=
> > > Vidhesh Ramesh=0A=
> > >=0A=
> > >=0A=
> > > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> > > Sent: Tuesday, July 14, 2020 10:18 AM=0A=
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <lin=
ux-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@=
lists.samba.org>=0A=
> > > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
> > > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.e=
lrepo.x86_64=0A=
> > >=0A=
> > > Hi Steve et all,=0A=
> > >=0A=
> > > Resending this as a gentle reminder if anyone got a chance to look at=
 the below mentioned oops kernel panic.=0A=
> > >=0A=
> > >=0A=
> > > Vidhesh Ramesh=0A=
> > >=0A=
> > >=0A=
> > > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> > > Sent: Thursday, July 2, 2020 12:21 AM=0A=
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <lin=
ux-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@=
lists.samba.org>=0A=
> > > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
> > > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.e=
lrepo.x86_64=0A=
> > >=0A=
> > > Hi Steve et all,=0A=
> > >=0A=
> > > Resending this as a gentle reminder if anyone got a chance to look at=
 the below mentioned oops kernel panic.=0A=
> > >=0A=
> > > Vidhesh Ramesh=0A=
> > >=0A=
> > >=0A=
> > >=0A=
> > >=0A=
> > >=0A=
> > >=0A=
> > >=0A=
> > > From: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
> > > Sent: Wednesday, June 24, 2020 10:26 PM=0A=
> > > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <lin=
ux-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@=
lists.samba.org>=0A=
> > > Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> > > Subject: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrep=
o.x86_64=0A=
> > >=0A=
> > > Hi Steve et al,=0A=
> > >=A0=A0=A0 My name is Ameya and I work for www.komprise.com.=A0 The lin=
ux kernel with above mentioned version has been panicing, though randomly, =
but the stack trace appears is consistent.=A0 You can find more details in =
the attachments.=A0 Below is the brief description of the problem -=0A=
> > >=0A=
> > > [1.] One line summary of the problem:=0A=
> > > oops kernel panic=0A=
> > > [2.] Full description of the problem/report:=0A=
> > > ESX VM hangs with a kernel panic when cifs shares are mounted. Unable=
 to ssh to the VM and the console of the VM is also not responding. With kd=
ump service running and core collected the VM restarts successfully.=0A=
> > > [3.] Keywords (i.e., modules, networking, kernel):=0A=
> > > cifs, kernel, panic, strcmp, mount=0A=
> > > [4.] Kernel information=0A=
> > > [4.1.] Kernel version (from /proc/version):=0A=
> > > Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc v=
ersion 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 =
EDT 2018=0A=
> > > [4.2.] Kernel .config file:=0A=
> > > Please check the file uploaded=0A=
> > > [5.] Most recent kernel version which did not have the bug:=0A=
> > > [6.] Output of Oops.. message (if applicable) with symbolic informati=
on=0A=
> > >=A0=A0=A0=A0=A0 resolved (see Documentation/admin-guide/oops-tracing.r=
st)=0A=
> > > [442282.069937] BUG: unable to handle kernel NULL pointer dereference=
 at 0000000000000000=0A=
> > > [442282.071474] IP: strcmp+0xe/0x30=0A=
> > > [442282.072892] PGD 0 P4D 0=0A=
> > > [442282.074196] Oops: 0000 [#1] SMP PTI=0A=
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
ue_helper cryptd sg intel_rapl_perf input_leds pcspkr joydev shpchp=0A=
> > > [442282.090386]=A0 parport_pc parport i2c_piix4 vmw_vmci nfsd nfs_acl=
 lockd auth_rpcgss grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom ata_ge=
neric sd_mod pata_acpi crc32c_intel serio_raw vmwgfx drm_kms_helper syscopy=
area sysfillrect sysimgblt fb_sys_fops ttm mptspi scsi_transport_spi ata_pi=
ix mptscsih vmxnet3 drm mptbase libata floppy dm_mirror dm_region_hash dm_l=
og dm_mod dax=0A=
> > > [442282.095332] CPU: 4 PID: 9273 Comm: mount.cifs Tainted: G=A0=A0=A0=
=A0=A0=A0=A0 W=A0=A0=A0=A0=A0=A0=A0 4.16.2-1.el7.elrepo.x86_64 #1=0A=
> > > [442282.097802] Hardware name: VMware, Inc. VMware Virtual Platform/4=
40BX Desktop Reference Platform, BIOS 6.00 04/05/2016=0A=
> > > [442282.100363] RIP: 0010:strcmp+0xe/0x30=0A=
> > > [442282.101645] RSP: 0018:ffffc9001bff7c88 EFLAGS: 00010202=0A=
> > > [442282.102919] RAX: 0000000000000001 RBX: ffff8802ad7c2400 RCX: 0000=
000001240404=0A=
> > > [442282.104207] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000=
000000000001=0A=
> > > [442282.105497] RBP: ffffc9001bff7c88 R08: 0000000001240404 R09: 0000=
000000000001=0A=
> > > [442282.106765] R10: ffff88017d2c2b40 R11: ffff8801744c0e50 R12: ffff=
88011f793000=0A=
> > > [442282.108038] R13: ffff88042b105800 R14: ffffc9001bff7d98 R15: ffff=
8801b63c0f00=0A=
> > > [442282.109318] FS:=A0 00007f3e90ee6780(0000) GS:ffff88043fd00000(000=
0) knlGS:0000000000000000=0A=
> > > [442282.110630] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=
=0A=
> > > [442282.111970] CR2: 0000000000000000 CR3: 000000011b2ea000 CR4: 0000=
0000000406e0=0A=
> > > [442282.113405] Call Trace:=0A=
> > > [442282.114849]=A0 cifs_match_super+0x123/0x210 [cifs]=0A=
> > > [442282.116211]=A0 ? cifs_prune_tlinks+0xe0/0xe0 [cifs]=0A=
> > > [442282.117541]=A0 sget_userns+0x88/0x4a0=0A=
> > > [442282.118877]=A0 ? cifs_kill_sb+0x30/0x30 [cifs]=0A=
> > > [442282.120203]=A0 ? cifs_prune_tlinks+0xe0/0xe0 [cifs]=0A=
> > > [442282.121502]=A0 sget+0x7d/0xa0=0A=
> > > [442282.122781]=A0 ? cifs_kill_sb+0x30/0x30 [cifs]=0A=
> > > [442282.124072]=A0 cifs_do_mount+0x168/0x5a0 [cifs]=0A=
> > > [442282.125364]=A0 mount_fs+0x3e/0x150=0A=
> > > [442282.126627]=A0 vfs_kern_mount+0x67/0x130=0A=
> > > [442282.127850]=A0 do_mount+0x1f5/0xca0=0A=
> > > [442282.129047]=A0 SyS_mount+0x83/0xd0=0A=
> > > [442282.130257]=A0 do_syscall_64+0x79/0x1b0=0A=
> > > [442282.131583]=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=0A=
> > > [442282.132687] RIP: 0033:0x7f3e907fdfea=0A=
> > > [442282.133754] RSP: 002b:00007ffee9139868 EFLAGS: 00000202 ORIG_RAX:=
 00000000000000a5=0A=
> > > [442282.134842] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000=
7f3e907fdfea=0A=
> > > [442282.135909] RDX: 000055d13f5953b2 RSI: 000055d13f5953f9 RDI: 0000=
7ffee913bb51=0A=
> > > [442282.136944] RBP: 00007ffee913bb46 R08: 000055d1415e80d0 R09: 0000=
000000001000=0A=
> > > [442282.137962] R10: 0000000000000000 R11: 0000000000000202 R12: 0000=
7f3e90ef0000=0A=
> > > [442282.138957] R13: 000055d1415e80d0 R14: 00007f3e90ef290f R15: 0000=
000000000000=0A=
> > > [442282.139918] Code: 80 3a 00 75 f7 48 83 c6 01 0f b6 4e ff 48 83 c2=
 01 84 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 84 c0 74 18 48 83=
 c7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 31=0A=
> > > [442282.142829] RIP: strcmp+0xe/0x30 RSP: ffffc9001bff7c88=0A=
> > > [442282.143759] CR2: 0000000000000000=0A=
> > > [7.] A small shell script or example program which triggers the=0A=
> > >=A0=A0=A0=A0=A0 problem (if possible)=0A=
> > >=0A=
> > > My colleague Vidhesh (CC'ed) will be glad to share further details on=
 the test scenario and/or in-house reproduction.=A0 Please let us know of w=
orkarounds, if any.=0A=
> > >=0A=
> > > Thanks and Regards,=0A=
> > > =3D Ameya=0A=
> > >=0A=
> > >=0A=
> > >=0A=
> >=0A=
>=0A=
>=0A=
> --=0A=
> Thanks,=0A=
>=0A=
> Steve=0A=
=0A=
=0A=
=0A=
-- =0A=
Thanks,=0A=
=0A=
Steve=
