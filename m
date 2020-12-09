Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDB2C4361B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 20:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D1DD23A22
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 20:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgLIUTe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 15:19:34 -0500
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:51777
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727297AbgLIUT1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 9 Dec 2020 15:19:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gY17KOasL1vvT+7dBvLwZ3HFUDGPMtxjGIQUN/RCG1QvZK5Zbt8gjo46zanMR1T/pOakEUAKeTwYCyxx6xToLqswZI9n64VCWkwjVfFysL+oiAhUTpOBbQijfN+1PIOI4+yx31fHbS4BqGnt4/sCWwAaxDx0G7zRZcZpVM6Sr0B361d6rUskLcEkD1oGYJ1JpmFqR8jF91WjeijRIAJwYPx3/Tft3qVRjKsmRbj8pyKqo21oEt7UMV/83lwdRYSs6jwNvhHFSliEbxg/bPT/auW/SzN7ZMAopaQsukDNLAF3/X35SdqNEDqEFX6qMPbixGivwR/goOywvN77cHtMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6N0S1fFFTMmQhKycVudJFRx+H+CAbmUEc9s875Dgc4=;
 b=k1ozhhwvKMElTrH2Uiz2HIksgxC/+HnJ+ufeqlA8RogKThUrMVnr0uteBKb78jwTtw9/MsYCh7Tu2fsTJcL9q33j5NYo0lHOb4+4kqREHhvmBSd6pMzHt4wb5rSO7HrvpIZhCp3RDVHNpQhIiQ27kN5hlfwo2P+v20SNriW996h1tAe/NLAoCn0ZBWiMkzz82/W1rsNKaPjkQFpN+QdtauP10KZVVDs+Tx/zQwZZcJzg7RrE9sfR4Fwu3L/FJK4/oV4vIYlB6pgWoz2nviKamybukmKoAn3iTXbL+D8Linw3YJLUCUZX54fI1wP9i5WfaFq1kTDbrXnHzM1qPy1NNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=komprise.com; dmarc=pass action=none header.from=komprise.com;
 dkim=pass header.d=komprise.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=komprise.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6N0S1fFFTMmQhKycVudJFRx+H+CAbmUEc9s875Dgc4=;
 b=MaEuVWwXEwfafk8FyfmIb61psVnJGyE665TXV7RxB5vHZ8asml0h5ag0K5j8uX8qnN6U4Are6Rayui2m3HwYfav3fgCMPDOYArKYKrSAVRBk3jlJXSoxwS+5HHb+6TydVQrd4hk676euveod6H22VGyXA9op8vW8NnSgt4cr3bQ=
Received: from BYAPR16MB2615.namprd16.prod.outlook.com (2603:10b6:a03:8f::17)
 by BY5PR16MB3459.namprd16.prod.outlook.com (2603:10b6:a03:1a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 20:18:34 +0000
Received: from BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::116d:161c:4a50:e9bc]) by BYAPR16MB2615.namprd16.prod.outlook.com
 ([fe80::116d:161c:4a50:e9bc%6]) with mapi id 15.20.3632.021; Wed, 9 Dec 2020
 20:18:33 +0000
From:   Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
To:     Steve French <smfrench@gmail.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
CC:     Nahush Bhanage <nahush.bhanage@komprise.com>,
        Chris Dearden <chris.dearden@komprise.com>
Subject: Merge commits to v4.19 from 4.20 & 5.6 for cifs Backup intent flag
 fixes
Thread-Topic: Merge commits to v4.19 from 4.20 & 5.6 for cifs Backup intent
 flag fixes
Thread-Index: AQHWzmgYMv71PfRbMkOvwLnCUG85Qg==
Date:   Wed, 9 Dec 2020 20:18:33 +0000
Message-ID: <BYAPR16MB26159527465394F378EB16FDE2CC0@BYAPR16MB2615.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=komprise.com;
x-originating-ip: [24.5.2.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e27fd2e1-0c4e-443c-35ca-08d89c7f9a7a
x-ms-traffictypediagnostic: BY5PR16MB3459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR16MB34599979AB95041EEA1B7A48E2CC0@BY5PR16MB3459.namprd16.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2UJqX3yp8TB98N9fqBM8/5b/4IqUc3UFSte60uumSyJzNRFFWJDS4cCxECnbmPtr1tmNThPPSO9fdt+fdkZ7jdE4FLu/xuszWrvCZTpKiB/aV/aJv0FJQMkAi9Oj4XQ5dUVCrZ4dPLp4qhc5fEgfrJTfmELndDn2z9aPuCgsEYqHf0PNw/i4q1kdUmYyeS5x89rJ/Ne/zz58VPuTufl7pumYgOg2r3bgyM3p8oFaKW6CObji81/HnuZDOSKxibHdxBroNSbn0nQ5x9yQ4QNwxlG/X2fJCxMQRbge8dvAKf4QIWal2wPOQs+sPcRj79gYCngsWPHGmAXJYNlWWOWLFua+JK/XJn+nVtrusEbWcprJOXjH9jMnvKC2Wv3lnrkm/TXhANEnLePE0ysayGijg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR16MB2615.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(44832011)(107886003)(33656002)(52536014)(2906002)(5660300002)(8936002)(8676002)(71200400001)(4744005)(966005)(508600001)(91956017)(4326008)(7696005)(66476007)(26005)(186003)(9686003)(6506007)(110136005)(76116006)(86362001)(55016002)(66946007)(66556008)(66446008)(64756008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?mvQYUMmeUAcVh+Bxwh0eKDT7nVfW8+C4XdJ11Dn9TlNqIYR6yT62OWPLe3?=
 =?iso-8859-1?Q?7bdu0bZCsW2dIDLDYF6CQPYhcQT79MMMn0gJFwiEDw+V63PRAtBG9dgx1o?=
 =?iso-8859-1?Q?UVl+XKFhx0qUTCU+peQQ/xk0i26uLFjIvKHLcByMsaANnIH7yamKc0cijm?=
 =?iso-8859-1?Q?SWRDzujPsttizPeYm+sxdPm7AtmbLI+6Aa1E70zKKbHK0I7cJXAZgaNC9N?=
 =?iso-8859-1?Q?vkA1kHh2q+9vsbUEypxUFEMCdi3IYqKdq4UW9q5Iqg9jvKcbRw7cYcaOUI?=
 =?iso-8859-1?Q?LGQRE2oMTQZ2WwHXy762AIXeqjlB/9FIpRIpWFtgjZ7SVqg3X8XGd7THBr?=
 =?iso-8859-1?Q?yNqPpwheUOX7rLAunWITpzT9C58uj52UjZ1hc9Rjs9j737guuQUCUwRxHA?=
 =?iso-8859-1?Q?fsiSBVf1nB/p9Esf5G/pe6JmGPi9z/KWwKPkVOviSr6gms+jIcjVAFfHMK?=
 =?iso-8859-1?Q?wDGelcX8evuS2UwZInWXe8pva65CXt2vbC5spDd+8XvECZ3E4F4zbDK+X2?=
 =?iso-8859-1?Q?qIdpqAJDSv6wMe1QLhobiU8S35R4AuvfWTt7D9kigwN82psSE4hTQrPKMH?=
 =?iso-8859-1?Q?cPZt3VyW4DILxtVhzoH8D+UxMaiVqWQj0p8nvA7vqfpF34VG+s+hBeZ/zU?=
 =?iso-8859-1?Q?zVT9fJMHLQa5UPPFcoMPQam++d5a5KVJmWY9m/LVVW6q6uiBI7li0e6Dho?=
 =?iso-8859-1?Q?9wG/wIA/6YUlQ97Lf0vYVKESQkqTgrK0qUm0Y7XLCKfNws1+FKZibtjqiC?=
 =?iso-8859-1?Q?PGX9PlUlpoA3r9OBjkBPm1+yJ81q5WIWkfDG8SKe/dMoMseW7JyZg3PXRu?=
 =?iso-8859-1?Q?0+mdo9bwcVA2W8MiwrybmHXAwz6yh1IKxsDppWWHRNhY+uO3vvvd0Ajj7R?=
 =?iso-8859-1?Q?ufTFtxJzWoJr8U3ev6QLBvPBEcpKsPfwmamdreeikj84qmKzli48fAJ/mH?=
 =?iso-8859-1?Q?rX+ghaTWnoTTstFCG9uX35pkEfhv0WlL/J8K9gpmeIerBWovKznLSXUko/?=
 =?iso-8859-1?Q?vvWgpelWwPPyXYl3Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: komprise.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR16MB2615.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27fd2e1-0c4e-443c-35ca-08d89c7f9a7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 20:18:33.7656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7a5a9d78-0afb-4c20-b729-756d332680db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yYYngZ+wnREsLc4K7zMrKtNiUD6W675y2jtw32TebqGvlhkHXPj45WXJ1QSz7WG+CpG4dx1Rh0mjE4SQRlue5I8kDDHmjPiq0vYUmS7Lm/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR16MB3459
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,=0A=
=0A=
We mount cifs shares on our centos machines running kernel v4.19 using back=
upoperator privileges using backupid, however we do not see that the backup=
 intent is used for all calls. We did find fixes for them in 4.20 & 5.6 but=
 not in 4.19. Would it be able to merge these commits to 4.19 as well ?=0A=
=0A=
Here are the commits of interest.=0A=
1.=A0https://github.com/torvalds/linux/commit/5e19697b56a64004e2d0ff1bb952e=
a05493c088f=A0- v4.19.rc1=0A=
2.=A0https://github.com/torvalds/linux/commit/61351d6d54e651ec4098445afa5dd=
c2092c4741a=A0- v4.20.rc1=0A=
3.=A0https://github.com/torvalds/linux/commit/4d5bdf28690a304e089ce750efc8b=
7dd718945c7=A0- v4.20.rc1=0A=
4.=A0https://github.com/torvalds/linux/commit/0f060936e490c6279dfe773d75d52=
6d3d3d77111=A0- v5.6-rc1=0A=
=0A=
Vidhesh Ramesh=
