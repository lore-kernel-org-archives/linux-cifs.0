Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1BAC433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 18:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EA723D57
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 18:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403946AbgLJS2e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Dec 2020 13:28:34 -0500
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:50976
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403854AbgLJS22 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 10 Dec 2020 13:28:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvnaJBt1/SkNkxECOZPQ8IxXwIpjW3jDrTABLoOOm3OutLoezF+W2sPw4zSSXOIH2xeuV8Z6ul8WSDXgaGAUJIuPercERRS1IZ6NfqiSPIC8LS1OBb9JRd2DIXgAKYHjo4n1V3ocQ6mfgB+4bapkBqT/oXWM159u2Ns69qgZIYbrA93o6cDvwcciIKbRIBghLo8LR0krzLCFfRkvFG+owjuQExRDvo2BaC8rvFCM9qE6g1Z+oxWvV5O5Z2yXq3L/l049zZXTfmoPqqzWtbuD5Hc7FlZ3Kk7GWI69g3FkBnliSTYi7QjMPCrXnswuYP/myZTNWLo//pf5ixaBtv7qfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUX125J9FzXoOtTvf1F09AY4YEzNPYjhYWxSFQXnSys=;
 b=EGkhxtzraJAJBAzgY0K7kIaYKl8laf/2yJM8rv+L9/bRkIfm6wmK99UnLUWlZc3h/E+4+RmQ8uXjWUaZz3rf77lxa9ZS+BXDtmiNOQJSLOf7MuuWuOXskymEwm3HWbgzo335Bs/s2t6rABKyn6Mz/osNOMCIeYpQJd4QrVTeNi9CEV/V/pu5ZpotTqJaQoruI6/SWhYmXD8HS0YZfybMMm8U5m/SiVU44MORqZ/DFIqJkNqYd0kY6ysx8Sjks22A6cZO53hj8tF3ZYypHhvChY2FQ+bqrqMtXi00ofHueXEh0AtiXzqBOnDvhUTkyNAmmnWaGIZI/xrEPgMoUU3E0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUX125J9FzXoOtTvf1F09AY4YEzNPYjhYWxSFQXnSys=;
 b=o1CDsheNE52h2A0VgQ/u+X7ybKnqqScdgVq4fYK9j06vCRyIrmYN9LGBQGplesQqcL3lzAVG+H0TAutjN7q1TobaVOaKuiHqFz2QSFqRrxzQIUpx5pC8lBceje7fn+w41WgWij4n54RVnf6SQ53wqOyfFXLqrdUkM3+Ts0MOnvA=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BY5PR16MB3047.namprd16.prod.outlook.com (2603:10b6:a03:183::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 18:27:33 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::116d:161c:4a50:e9bc]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::116d:161c:4a50:e9bc%6]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 18:27:33 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     Steve French <smfrench@gmail.com>
CC:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Nahush Bhanage <nahush.bhanage@komprise.com>,
        Chris Dearden <chris.dearden@komprise.com>
Subject: Re: Merge commits to v4.19 from 4.20 & 5.6 for cifs Backup intent
 flag fixes
Thread-Topic: Merge commits to v4.19 from 4.20 & 5.6 for cifs Backup intent
 flag fixes
Thread-Index: AQHWzmgYMv71PfRbMkOvwLnCUG85Qqnwj0KAgAAXeQM=
Date:   Thu, 10 Dec 2020 18:27:33 +0000
Message-ID: <BYAPR16MB26152139C1FB73AEE9119B80E2CB0@BYAPR16MB2615.namprd16.prod.outlook.com>
References: <BYAPR16MB26159527465394F378EB16FDE2CC0@BYAPR16MB2615.namprd16.prod.outlook.com>,<CAH2r5mtZo68cjRFOXPxET2D2yr+J8xbAoNto0zx06b1uRwxX4g@mail.gmail.com>
In-Reply-To: <CAH2r5mtZo68cjRFOXPxET2D2yr+J8xbAoNto0zx06b1uRwxX4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=komprise.com;
x-originating-ip: [24.5.2.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9aa0e1a5-2a96-4933-e13b-08d89d394334
x-ms-traffictypediagnostic: BY5PR16MB3047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR16MB3047315D7494689B15734636E2CB0@BY5PR16MB3047.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KoJRWLggOT24IG28tHoCDf5QPrS1HoRjeTdpCA9kQNab1eyis3N4Nfkh1H+wzSn9h0i3lNaXzuU/Edlv3r929zjbngMIfZOb4ygpLeAM/LNCDcyVTG64z4gDEU6cOQI5AXJGhsXMbR3Vsqyngt6RmeO+u2W0dBvbmzkb7Bl5iokWRizPOt0JOj+QBFpxok3YnjLgMpoBxmVjUkIJpo2MNVeL2nZASWA+3KRKSo5Pwq7taWeihTLUQaGN2UnRAQ5D4P9kSkJFfTnqfX0K2Uzjpp8c2a2Z3bX2VpGG7mhNJgjXxscUhWGO349mcDRz56P3MDAh3YlXGog0epI+rCSmX3Ip07vRMOr5EKHd+q2hzaf2QjqE8cU8BisKUbvzXyy/Jsi4k4GbL8TC1WNPtmymWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(26005)(7696005)(55016002)(76116006)(91956017)(86362001)(8936002)(8676002)(44832011)(2906002)(508600001)(83380400001)(966005)(33656002)(66446008)(54906003)(64756008)(5660300002)(66476007)(66946007)(52536014)(4326008)(6506007)(6916009)(53546011)(9686003)(71200400001)(107886003)(186003)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?D6buGC91c9T2Gshk78zDJb7bE762AslGkDVvJP5e+VcCPX1ejKKOYZBKJq?=
 =?iso-8859-1?Q?iqk5IsiCyrjkCaR0OST6okQfGttoyOzjE8/hc9jAGBFnIquGAdbatiBkw6?=
 =?iso-8859-1?Q?3P8+5kqu/p3zvULAO1kpYybBPNmmugiSzJOa730Lj4ui96nReunwupuSXa?=
 =?iso-8859-1?Q?iSJIoJU1sANr4eCfX7ade2dPWEVjnLIDwWimE6PxU8BtweweP3mf0aUMOV?=
 =?iso-8859-1?Q?m52OTNpeG24tg5UC4YvJhbXG5B9ZNR7AB07ygtFwmt5ch3ivL/YTy0nZqa?=
 =?iso-8859-1?Q?ZNPUZtF4sqhDRWGUISAhq0auTAiWCHyQWfVaROO43fx2EzcxH0FVeM9GZt?=
 =?iso-8859-1?Q?668BEXKbpNtd+mIFHLC/8IJDBlJ5JK7M+60mIbocLpqz9kJaQfR8Y8MBOi?=
 =?iso-8859-1?Q?uUQ15KZwruDskAAC6q1wJu16bXDNY3UzJDqZ3+bC9EqqNafhhw77UV3XiE?=
 =?iso-8859-1?Q?4T+npjU61ic6SZhOwZJJ+2nHYlMBCbD73QOgT8syee7holntapFoIOekho?=
 =?iso-8859-1?Q?SdCEgVKUQLSaqkmNwL6O6dUtWv8jx1MjbfBSp53ZgkXv2dL3g52FzMEKFu?=
 =?iso-8859-1?Q?+3bCDycqPhjKuKiW8TBany6IjkdEZSuEq5ecwtVR4JxKNaP0/C2rUr08fD?=
 =?iso-8859-1?Q?mlI7Ny7nAxfipvygvnPkYmfirY3DBP5K8QA/1VggYsDQLvoAekE3ODWAaL?=
 =?iso-8859-1?Q?bI2MvUysnago3P/6WfE3m9FMlNRw19roRBd/NAydbRJrd1UKAX9SbyEf3e?=
 =?iso-8859-1?Q?RxdYWN1LOV3nPWDA6XaAUKDv4Xs/pWfM3+UrgKX+YHaCUFMWC0WqKpFzPX?=
 =?iso-8859-1?Q?sNSYHPkrXir2T/CL7OI0Mx8J6CxsoPuCWbnkhuUdJ1XTq3+Id86J/XzGzo?=
 =?iso-8859-1?Q?iUsFIzziBk6En4m/46hPcGQ8muSpBgtQLZdCdIjt9TMQjyQ5FaTrpny+2o?=
 =?iso-8859-1?Q?PwfV9Icx5n14sK/DBBP7ZMgeBxtVuSKEK5XodJ6TVtZkdMaINaPKRfk2ZC?=
 =?iso-8859-1?Q?sAlfQtfjmULWGmA/Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa0e1a5-2a96-4933-e13b-08d89d394334
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 18:27:33.8211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2qPVqtmFjjp8FIv+eLi3YsEllYkQzbSAX330MxAuT1SZrHHkafnli5MGaExDz5jp7O5e/g1Y/eHWg7/RsZzNhQpk3Jtu1lo3CuiJgMonbGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR16MB3047
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve.=0A=
=0A=
We are not using any distro and building our onprem VM ovas with Centos 7.8=
 and kernel 4.19 (4.19.134). We did try the latest kernel of LTS 4.19 kerne=
l build 160 and still see that the backup intent is not being sent for some=
 of the calls. However, on kernel 5.4 we see the same working as expected.=
=0A=
=0A=
We are currently planning to stay on kernel 4.19 as it is stable and LTS re=
lease & hence wanted to see if the fixes could be backported to kernel 4.19=
.=0A=
=0A=
We see #1 in 4.19 and #1,#2,#3 in 5.4. Since its working with 5.4 and not w=
ith 4.19 was wondering if #2 and #3 are not in 4.19 and hence if it could b=
e backported ?=0A=
=0A=
1.=A0https://github.com/torvalds/linux/commit/5e19697b56a64004e2d0ff1bb952e=
a05493c088f=A0- v4.19.rc1=0A=
2.=A0https://github.com/torvalds/linux/commit/61351d6d54e651ec4098445afa5dd=
c2092c4741a=A0- v4.20.rc1=0A=
3.=A0https://github.com/torvalds/linux/commit/4d5bdf28690a304e089ce750efc8b=
7dd718945c7=A0- v4.20.rc1=0A=
4.=A0https://github.com/torvalds/linux/commit/0f060936e490c6279dfe773d75d52=
6d3d3d77111=A0- v5.6-rc1=0A=
=0A=
Vidhesh Ramesh=0A=
=0A=
From: Steve French <smfrench@gmail.com>=0A=
Sent: Thursday, December 10, 2020 9:01 AM=0A=
To: Vidhesh Ramesh <vidhesh.ramesh@komprise.com>=0A=
Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org <linux-cif=
s@vger.kernel.org>; samba-technical@lists.samba.org <samba-technical@lists.=
samba.org>; Nahush Bhanage <nahush.bhanage@komprise.com>; Chris Dearden <ch=
ris.dearden@komprise.com>=0A=
Subject: Re: Merge commits to v4.19 from 4.20 & 5.6 for cifs Backup intent =
flag fixes =0A=
=A0=0A=
You may want to contact the guys that package your custom distro.=0A=
Since some of those patches are marked for stable they would be=0A=
automatically backported but I don't know who provides your custom=0A=
kernel.=A0=A0 AFAIK these are likely to be backported already by Redhat so=
=0A=
if you are using CentOS 8.2 or RHEL8.2 there is a good chance that=0A=
these are already in.=0A=
=0A=
On Wed, Dec 9, 2020 at 2:18 PM Vidhesh Ramesh=0A=
<vidhesh.ramesh@komprise.com> wrote:=0A=
>=0A=
> Hi Steve,=0A=
>=0A=
> We mount cifs shares on our centos machines running kernel v4.19 using ba=
ckupoperator privileges using backupid, however we do not see that the back=
up intent is used for all calls. We did find fixes for them in 4.20 & 5.6 b=
ut not in 4.19. Would it be able to merge these commits to 4.19 as well ?=
=0A=
>=0A=
> Here are the commits of interest.=0A=
> 1. https://github.com/torvalds/linux/commit/5e19697b56a64004e2d0ff1bb952e=
a05493c088f - v4.19.rc1=0A=
> 2. https://github.com/torvalds/linux/commit/61351d6d54e651ec4098445afa5dd=
c2092c4741a - v4.20.rc1=0A=
> 3. https://github.com/torvalds/linux/commit/4d5bdf28690a304e089ce750efc8b=
7dd718945c7 - v4.20.rc1=0A=
> 4. https://github.com/torvalds/linux/commit/0f060936e490c6279dfe773d75d52=
6d3d3d77111 - v5.6-rc1=0A=
>=0A=
> Vidhesh Ramesh=0A=
=0A=
=0A=
=0A=
-- =0A=
Thanks,=0A=
=0A=
Steve=
