Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CDFC433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 21:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86AFD2065E
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 21:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=komprise.com header.i=@komprise.com header.b="3nLZlDCW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGQVXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:23:30 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:45889
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgGQVX3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 17 Jul 2020 17:23:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDp/iulo/CeiEfT71EV9vs7/vhiswVfTnZKAClcMNbqqz/ifdZ0pIIOXqGW7EO3YBG6jLgyLLKZnzHI3GUGqTp+/QAHkRk4XZXRWjL7Fe5CjtIMn/D+zsGr3kFmVQCCpfLFwpu+FlekIRW8CTo0T5iFRjg0TmwO1T/5m2Lcd/jTMZl5C+9f8r2W3KLUw0+TqbdCpddrG+F8ItRZMYqhQOSDj/g+NsAgswi7CDcbL2JVNqUNILlgrG5QCAqbo7cHWDZixjd2SMRSPS272dwHLrOmhMr8pxXqm5OQrPwAIf86SXrjxn86z61ahJLbQHOfYUjDrGh29gRpEPTBVfEqANg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xM4Rf+CZQvwuKZd6GJ/lqZgqGspGn0vwYRVc6sQCr68=;
 b=F/8ivX9IqSADIahIAvJxbyKSP1BqVyYoUy8RBqxbyYADPDub2Mk+sf1AqlAtI6MuL6byG+DvsU6Q6Veutr8nr5hc/kBCrHwBXgQ6mscvLZ176WdsnZL+1bI81u5zE8XJqiFKBl8T+Y68fYffoOYWo/6cyb4XtMCuqxDcTdtdabNXYYLGYpqhK/fdE32MdtA7LckCaFAWDbHtFZ8Hz2x4uuMHmu/sCaysdfFRk5oQbcAT8o931Yw8zTrlvpA/Xn0BgF/OPuPAiNTt8qa/TDHZDyMkmx774bxSH1YHMP691zDP64PORnRmJPzmIAqD9AZErjYryJDZvTML93Ls+ISi/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xM4Rf+CZQvwuKZd6GJ/lqZgqGspGn0vwYRVc6sQCr68=;
 b=3nLZlDCWfdYYBTTCVy3+e5LxeAflwjR67YCu3ygS/3T/XK3Mk4+rtDh2x0IkJcUDs1nRiDYTbvXvEfCv4hn+aYl0q0GAO2sFVYNuosS2SHTeEH7fWjcCL7uVzIeiEWFGGvL5RdOp/WA5qnkDJ56QUxU8yLF3N2QXK+3Emp4Hal0=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BYAPR16MB3959.namprd16.prod.outlook.com (2603:10b6:a02:c9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 17 Jul
 2020 21:23:24 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::99d9:a6f:4f4a:4993]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::99d9:a6f:4f4a:4993%3]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 21:23:24 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     Steve French <smfrench@gmail.com>
CC:     Kenneth Dsouza <kdsouza@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Oops in cifs_match_super() - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Topic: Oops in cifs_match_super() - linux kernel
 4.16.2-1.el7.elrepo.x86_64
Thread-Index: AQHWSq9edtCo81aaX06K8scfXoPZ86jz61slgBOCXOSAAAa8h4AAAm8AgAACGQCABCW3fYAAUneAgAB5rTg=
Date:   Fri, 17 Jul 2020 21:23:23 +0000
Message-ID: <BYAPR16MB261559669B8ECAB936C7E4C5E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <MW3PR16MB37063A82C9A57CC67EB5BE1F87920@MW3PR16MB3706.namprd16.prod.outlook.com>
 <BYAPR16MB26152FB66647DB8FCAED346CE26D0@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB261513751DCF34B035660665E2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <BYAPR16MB26150AE65092A458650DECFDE2610@BYAPR16MB2615.namprd16.prod.outlook.com>
 <CAA_-hQJuAnELV+DKhst9iwyC_x7-CDkRKjneTFHgUcM3DSb2gQ@mail.gmail.com>
 <CAH2r5ms3567LG2rNiTDJgykuu3F8916VH2tjJOXnk+FMRC3giQ@mail.gmail.com>
 <BYAPR16MB26156E99DAEAC5AB16C644A0E27C0@BYAPR16MB2615.namprd16.prod.outlook.com>,<CAH2r5ms2jsH2ka-9SAaN8v61YL16jN401uEDZJ7Uo0H0pLtH7g@mail.gmail.com>
In-Reply-To: <CAH2r5ms2jsH2ka-9SAaN8v61YL16jN401uEDZJ7Uo0H0pLtH7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=komprise.com;
x-originating-ip: [24.5.193.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 800a02e5-a873-4dc3-571d-08d82a97a354
x-ms-traffictypediagnostic: BYAPR16MB3959:
x-microsoft-antispam-prvs: <BYAPR16MB3959B4E19B86B4B2445C1DA0E27C0@BYAPR16MB3959.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KZxv//aWwKLrkES/LbwcfCqlpMbB/TCzl9HHbpXBPO/7gs7ID9UMwBU3vFN4ngUtlXJ75DfEYAtzlmCyoRB0XmNZv2rQ3mlvaFb1AJkT3Mr4BnOESIOWjn+Z0ZgvtQaDTTa4NBhY5oQX0xWvAXHtzvYs2yYrHEfQdZDHlsAOfMB1z0opKpCX6bWtO7DloxYfoNnMv5nbmI7iwZkBFy2i3wuohMYIVxUrWsWaQe+cYRSJMJ64eAObByaOvfuETAKldd8VRBbsKHsumqDR26ZnyXzawDAtNhQXg2AnxBhZ1/Otss9EdIh6AAs0Fe2iKPPbtlaZjv03B814nZJW18z9QYV19w638vlpsHrcq3iHRNtObzNPhUqz9B2bcYrdf5pWiKshjY1zY7ZKM6hR7PidgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39850400004)(396003)(366004)(136003)(55016002)(91956017)(4326008)(76116006)(316002)(8676002)(45080400002)(966005)(8936002)(478600001)(54906003)(9686003)(66946007)(64756008)(66556008)(66476007)(66446008)(6916009)(71200400001)(2906002)(6506007)(26005)(186003)(52536014)(44832011)(5660300002)(86362001)(33656002)(53546011)(7696005)(83380400001)(15974865002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P3bcNHqqnlq41Ma5CLCBy0dh1lJhLVH1h4K7kAZldcgs42oxt9YNtsG7AK4SuZykykxvpFN4tqepqRENGmFVsfcTHmwOdO0QydmLC8Ef0Z8fesGe5tjXkMK5IgpZ4yxjSnj7AVRLX+og4vJSl9pbSIgtLi1AnmWSLTKuKNWYNsc2gQ+u0v/BdwrsjYRvXOMP/7HWrZTiFKrkqkaN4VePuGpFIHvujjlGSZT4R1J2HOS0ZwI+D8XDQPY9J1WpuuMcu6aFz4ygZLf5TxnN65iE7xzb8O7o7+4fhfZteHVnfoFDSdjfyrdWZf+/3dVemoJSC1qCR2+qBBreBQ1i1R8goHkWbXlD6iIoM0vGptGov3O+Lxoc6kDAt2ZdCOqA6vpoGN7LnoatswTdEoIu84QZbiE/uI707O/ra8/WdY6jfCUElIVoNt4z/FSQwP+hPgJd/CRjA9CyQmaCe9LNMQA/zug81La6i2LplwTzRgrMQzA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 800a02e5-a873-4dc3-571d-08d82a97a354
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 21:23:23.8118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ZEC2k4TWvMv+eQZ7gEFMqrKYFu+RsEe67ptWvh9ny/JL9EaErPpGpHCl4oJ/9Hk+SmozIJzWUnx8SI4LtUx65RDKN+ziFaXCJH+EAQSdpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR16MB3959
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve. =0A=
We have few more bug fixes that we need in 4.19 LT kernel. However I am una=
ble to get a built kernel RPM of latest build 133 of kernel 4.19.=0A=
The latest I could get is build 113 of kernel 4.19 at=A0https://buildlogs.c=
entos.org/c7-kernels.x86_64/kernel/20200330213326/4.19.113-300.el8.x86_64/k=
ernel-4.19.113-300.el7.x86_64.rpm=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
From: Steve French <smfrench@gmail.com>=0A=
Sent: Friday, July 17, 2020 7:05 AM=0A=
To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Cc: Kenneth Dsouza <kdsouza@redhat.com>; CIFS <linux-cifs@vger.kernel.org>=
=0A=
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64 =0A=
=A0=0A=
I am not familiar with your distro but a Google search matched on this as a=
 more recent kernel rpm download with similar sounding name http://lists.el=
repo.org/pipermail/elrepo/2018-May/004282.html =0A=
=0A=
But there should be more recent kernels than that are eg based on newer 4.6=
.18 stable branch https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux.git/log/?h=3Dlinux-4.16.y=0A=
=0A=
On Fri, Jul 17, 2020, 04:12 Vidhesh Ramesh <vidhesh.ramesh@komprise.com> wr=
ote:=0A=
Thanks Steve and Kenneth for your responses.=0A=
=0A=
I did look at the commits and found that this has been fixed in a patch of =
4.19. Is there an archive where I can download latest 4.19 kernel rpm so th=
at I can verify the fix ?=A0=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: Steve French <smfrench@gmail.com>=0A=
Sent: Tuesday, July 14, 2020 10:49 AM=0A=
To: Kenneth Dsouza <kdsouza@redhat.com>=0A=
Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>; linux-cifs@vger.kernel.or=
g <linux-cifs@vger.kernel.org>=0A=
Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64 =0A=
=A0=0A=
If you have a particular stable kernel used for your distro you can=0A=
email stable@vger.kernel.org with the commit id and version you want=0A=
it backported for.=0A=
=0A=
On Tue, Jul 14, 2020 at 12:43 PM Kenneth Dsouza <kdsouza@redhat.com> wrote:=
=0A=
>=0A=
> You are hitting a known bug which has been fixed by below patch and is=0A=
> part of v5.6 and above.=0A=
>=0A=
> commit fe1292686333d1dadaf84091f585ee903b9ddb84=0A=
> Author: Ronnie Sahlberg <lsahlber@redhat.com>=0A=
> Date:=A0=A0 Wed Jan 22 11:07:56 2020 +1000=0A=
>=0A=
>=A0=A0=A0=A0 cifs: fix NULL dereference in match_prepath=0A=
>=0A=
>=A0=A0=A0=A0 RHBZ: 1760879=0A=
>=0A=
>=A0=A0=A0=A0 Fix an oops in match_prepath() by making sure that the prepat=
h string is not=0A=
>=A0=A0=A0=A0 NULL before we pass it into strcmp().=0A=
>=0A=
>=A0=A0=A0=A0 This is similar to other checks we make for example in cifs_r=
oot_iget()=0A=
>=0A=
>=A0=A0=A0=A0 Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>=0A=
>=A0=A0=A0=A0 Signed-off-by: Steve French <stfrench@microsoft.com>=0A=
>=0A=
> On Tue, Jul 14, 2020 at 11:05 PM Vidhesh Ramesh=0A=
> <vidhesh.ramesh@komprise.com> wrote:=0A=
> >=0A=
> > Adding linux-cifs mailing list.=0A=
> >=0A=
> > Vidhesh Ramesh=0A=
> >=0A=
> >=0A=
> > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> > Sent: Tuesday, July 14, 2020 10:18 AM=0A=
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux=
-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@li=
sts.samba.org>=0A=
> > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
> > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elr=
epo.x86_64=0A=
> >=0A=
> > Hi Steve et all,=0A=
> >=0A=
> > Resending this as a gentle reminder if anyone got a chance to look at t=
he below mentioned oops kernel panic.=0A=
> >=0A=
> >=0A=
> > Vidhesh Ramesh=0A=
> >=0A=
> >=0A=
> > From: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> > Sent: Thursday, July 2, 2020 12:21 AM=0A=
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux=
-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@li=
sts.samba.org>=0A=
> > Cc: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
> > Subject: Re: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elr=
epo.x86_64=0A=
> >=0A=
> > Hi Steve et all,=0A=
> >=0A=
> > Resending this as a gentle reminder if anyone got a chance to look at t=
he below mentioned oops kernel panic.=0A=
> >=0A=
> > Vidhesh Ramesh=0A=
> >=0A=
> >=0A=
> >=0A=
> >=0A=
> >=0A=
> >=0A=
> >=0A=
> > From: Ameya Usgaonkar <ameya.usgaonkar@komprise.com>=0A=
> > Sent: Wednesday, June 24, 2020 10:26 PM=0A=
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux=
-cifs@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@li=
sts.samba.org>=0A=
> > Cc: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
> > Subject: Oops in cifs_match_super() - linux kernel 4.16.2-1.el7.elrepo.=
x86_64=0A=
> >=0A=
> > Hi Steve et al,=0A=
> >=A0=A0=A0 My name is Ameya and I work for www.komprise.com.=A0 The linux=
 kernel with above mentioned version has been panicing, though randomly, bu=
t the stack trace appears is consistent.=A0 You can find more details in th=
e attachments.=A0 Below is the brief description of the problem -=0A=
> >=0A=
> > [1.] One line summary of the problem:=0A=
> > oops kernel panic=0A=
> > [2.] Full description of the problem/report:=0A=
> > ESX VM hangs with a kernel panic when cifs shares are mounted. Unable t=
o ssh to the VM and the console of the VM is also not responding. With kdum=
p service running and core collected the VM restarts successfully.=0A=
> > [3.] Keywords (i.e., modules, networking, kernel):=0A=
> > cifs, kernel, panic, strcmp, mount=0A=
> > [4.] Kernel information=0A=
> > [4.1.] Kernel version (from /proc/version):=0A=
> > Linux version 4.16.2-1.el7.elrepo.x86_64 (mockbuild@Build64R7) (gcc ver=
sion 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #1 SMP Thu Apr 12 09:08:05 ED=
T 2018=0A=
> > [4.2.] Kernel .config file:=0A=
> > Please check the file uploaded=0A=
> > [5.] Most recent kernel version which did not have the bug:=0A=
> > [6.] Output of Oops.. message (if applicable) with symbolic information=
=0A=
> >=A0=A0=A0=A0=A0 resolved (see Documentation/admin-guide/oops-tracing.rst=
)=0A=
> > [442282.069937] BUG: unable to handle kernel NULL pointer dereference a=
t 0000000000000000=0A=
> > [442282.071474] IP: strcmp+0xe/0x30=0A=
> > [442282.072892] PGD 0 P4D 0=0A=
> > [442282.074196] Oops: 0000 [#1] SMP PTI=0A=
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
_helper cryptd sg intel_rapl_perf input_leds pcspkr joydev shpchp=0A=
> > [442282.090386]=A0 parport_pc parport i2c_piix4 vmw_vmci nfsd nfs_acl l=
ockd auth_rpcgss grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom ata_gene=
ric sd_mod pata_acpi crc32c_intel serio_raw vmwgfx drm_kms_helper syscopyar=
ea sysfillrect sysimgblt fb_sys_fops ttm mptspi scsi_transport_spi ata_piix=
 mptscsih vmxnet3 drm mptbase libata floppy dm_mirror dm_region_hash dm_log=
 dm_mod dax=0A=
> > [442282.095332] CPU: 4 PID: 9273 Comm: mount.cifs Tainted: G=A0=A0=A0=
=A0=A0=A0=A0 W=A0=A0=A0=A0=A0=A0=A0 4.16.2-1.el7.elrepo.x86_64 #1=0A=
> > [442282.097802] Hardware name: VMware, Inc. VMware Virtual Platform/440=
BX Desktop Reference Platform, BIOS 6.00 04/05/2016=0A=
> > [442282.100363] RIP: 0010:strcmp+0xe/0x30=0A=
> > [442282.101645] RSP: 0018:ffffc9001bff7c88 EFLAGS: 00010202=0A=
> > [442282.102919] RAX: 0000000000000001 RBX: ffff8802ad7c2400 RCX: 000000=
0001240404=0A=
> > [442282.104207] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000000=
0000000001=0A=
> > [442282.105497] RBP: ffffc9001bff7c88 R08: 0000000001240404 R09: 000000=
0000000001=0A=
> > [442282.106765] R10: ffff88017d2c2b40 R11: ffff8801744c0e50 R12: ffff88=
011f793000=0A=
> > [442282.108038] R13: ffff88042b105800 R14: ffffc9001bff7d98 R15: ffff88=
01b63c0f00=0A=
> > [442282.109318] FS:=A0 00007f3e90ee6780(0000) GS:ffff88043fd00000(0000)=
 knlGS:0000000000000000=0A=
> > [442282.110630] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
> > [442282.111970] CR2: 0000000000000000 CR3: 000000011b2ea000 CR4: 000000=
00000406e0=0A=
> > [442282.113405] Call Trace:=0A=
> > [442282.114849]=A0 cifs_match_super+0x123/0x210 [cifs]=0A=
> > [442282.116211]=A0 ? cifs_prune_tlinks+0xe0/0xe0 [cifs]=0A=
> > [442282.117541]=A0 sget_userns+0x88/0x4a0=0A=
> > [442282.118877]=A0 ? cifs_kill_sb+0x30/0x30 [cifs]=0A=
> > [442282.120203]=A0 ? cifs_prune_tlinks+0xe0/0xe0 [cifs]=0A=
> > [442282.121502]=A0 sget+0x7d/0xa0=0A=
> > [442282.122781]=A0 ? cifs_kill_sb+0x30/0x30 [cifs]=0A=
> > [442282.124072]=A0 cifs_do_mount+0x168/0x5a0 [cifs]=0A=
> > [442282.125364]=A0 mount_fs+0x3e/0x150=0A=
> > [442282.126627]=A0 vfs_kern_mount+0x67/0x130=0A=
> > [442282.127850]=A0 do_mount+0x1f5/0xca0=0A=
> > [442282.129047]=A0 SyS_mount+0x83/0xd0=0A=
> > [442282.130257]=A0 do_syscall_64+0x79/0x1b0=0A=
> > [442282.131583]=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=0A=
> > [442282.132687] RIP: 0033:0x7f3e907fdfea=0A=
> > [442282.133754] RSP: 002b:00007ffee9139868 EFLAGS: 00000202 ORIG_RAX: 0=
0000000000000a5=0A=
> > [442282.134842] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f=
3e907fdfea=0A=
> > [442282.135909] RDX: 000055d13f5953b2 RSI: 000055d13f5953f9 RDI: 00007f=
fee913bb51=0A=
> > [442282.136944] RBP: 00007ffee913bb46 R08: 000055d1415e80d0 R09: 000000=
0000001000=0A=
> > [442282.137962] R10: 0000000000000000 R11: 0000000000000202 R12: 00007f=
3e90ef0000=0A=
> > [442282.138957] R13: 000055d1415e80d0 R14: 00007f3e90ef290f R15: 000000=
0000000000=0A=
> > [442282.139918] Code: 80 3a 00 75 f7 48 83 c6 01 0f b6 4e ff 48 83 c2 0=
1 84 c9 88 4a ff 75 ed 5d c3 0f 1f 00 55 48 89 e5 eb 04 84 c0 74 18 48 83 c=
7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 31=0A=
> > [442282.142829] RIP: strcmp+0xe/0x30 RSP: ffffc9001bff7c88=0A=
> > [442282.143759] CR2: 0000000000000000=0A=
> > [7.] A small shell script or example program which triggers the=0A=
> >=A0=A0=A0=A0=A0 problem (if possible)=0A=
> >=0A=
> > My colleague Vidhesh (CC'ed) will be glad to share further details on t=
he test scenario and/or in-house reproduction.=A0 Please let us know of wor=
karounds, if any.=0A=
> >=0A=
> > Thanks and Regards,=0A=
> > =3D Ameya=0A=
> >=0A=
> >=0A=
> >=0A=
>=0A=
=0A=
=0A=
-- =0A=
Thanks,=0A=
=0A=
Steve=
