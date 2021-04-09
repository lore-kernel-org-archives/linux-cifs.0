Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7EBC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 15:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F7EF610D1
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 15:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhDIP6f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:58:35 -0400
Received: from mail-eopbgr1320090.outbound.protection.outlook.com ([40.107.132.90]:61920
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233884AbhDIP6e (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 9 Apr 2021 11:58:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKOTRe9uKqkw47XGJ2D7cKXKqe42wr7rcOevsb6JGgK1ygFEXRkh99jsNjOQ9CPL7j2UirlJUT5d32z44DUkazoZbxVc4mW/ufuxR7glf3FI8COqEKpcT97WJ43X3alrorBbZ9ShOH4VDx36J+ei4vcegwrF/LjznLRkeyYgRYE0KMADyv7RfDZxWHUo+1XHfkyfMNM94IxggUeR+fvreWxplkv3mMJgYLRnchw8lO53aFxQF0YLxo5PI54ddidqpYT5GVB4zTUQ8FXTqi1+kp3Lz3/xzYAzbPj2xGQuviBWV0/wM1Y2C+y+Y69V8QtXioS/Npe+l+hngPyUHbe+HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1auWXKX4qRuUBUjSLtmbkTcMnNFkvsH+bfWgI6YoNBQ=;
 b=oNkyZJ0+T4Q7JxrNjXr7IYyXobkCZ2630hLTYg6S+mor6Ovs+PVsKlNX0TxToo5XM8hGng95kgEy362+HgyxbQTCDjaSq3cyxFsrOaixxPqCr5PyXFKuPWxw0XYm7x5OS6i8n4Xi31TfCbwjhZaEZRCdPOuXRusNtcR6bCSZUsPC2P8uNZwG1ud9E4wZE9SA9LoP3VTwOuVvCTEJw2aZn+vI6PZt4H1lTkB9z9XXAB3Fbvy8Cb1XOapi5w/0fXVPduXeu/QzTD1YsBEOhyWJW2266WMwnX5grtML5YnCZIhueyx4wUd4r6HyWXNjhbxEAqs1DP40AwOEY40Ng6wRxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1auWXKX4qRuUBUjSLtmbkTcMnNFkvsH+bfWgI6YoNBQ=;
 b=iSBQoZgz9UxZszLfGqrn+PTTVu0kPzxz9HQhHrnyTjvYvKHn4RyhIWPWcMV0HKga33/mc3k2GpfHDCrLNwtKKso9el347VPGETMJ1Lz8nISIeSaOxeWevhEhtRjk6IEIaAyRNsRVIF+FMTVIhkc5S3I7NHp3oikUxCZ8o3TOmJM=
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM (20.182.94.12) by
 PSAP153MB0421.APCP153.PROD.OUTLOOK.COM (20.182.94.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.4; Fri, 9 Apr 2021 15:58:18 +0000
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::24d9:ce8b:8c06:2299]) by PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::24d9:ce8b:8c06:2299%8]) with mapi id 15.20.4042.010; Fri, 9 Apr 2021
 15:58:18 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "yukuai3@huawei.com" <yukuai3@huawei.com>
Subject: RE: [EXTERNAL] [PATCH] cifs: Fix build error when no
 CONFIG_DNS_RESOLVER
Thread-Topic: [EXTERNAL] [PATCH] cifs: Fix build error when no
 CONFIG_DNS_RESOLVER
Thread-Index: AQHXLRO7xSy/YwnOJ02w+rqUNvvfkKqsV7Wg
Date:   Fri, 9 Apr 2021 15:58:18 +0000
Message-ID: <PSAP153MB04220A98B9A57BF059DF611894739@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
References: <20210409074634.1809521-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20210409074634.1809521-1-zhangxiaoxu5@huawei.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7020c6c7-de99-4633-9334-b4da3dc5675e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T15:56:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:1:60f6:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9e7f452-4837-474b-27ff-08d8fb704acf
x-ms-traffictypediagnostic: PSAP153MB0421:
x-microsoft-antispam-prvs: <PSAP153MB04218381973A2D91B09F2CC894739@PSAP153MB0421.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YAzCZp2/UFRSHarAueMV3JopG2Da5/D7Ghnl1k0x2eYnOGDI9DqVo5tFsDxcM4h28BJfDkMupHe1qzwfgMZfqGw2qBKywe/C8lrfQC25uJWpsE8bewO1XBv+kW2KpoBaMnKKsPVoxo+47jylMie0xR4uJkviAxSqkYVP3nNm0qC+m0lh0oA/YZGqxQW1MxSCU3waEoxv9cGzwapmP4uc08fJxHSN5YpgadTH8uf0+DAMBYNsKShbOIP13glnqEauEdDRsCQuRczBxvmxAv9QeSoZzL4BRLc9iJEMcwfTQ/uWJEjsmxOaAPd2XpbcekcXUUGUeX3K4SY0vYvpB0fDLR9veABuIbs9/wFFmv4wgB4Zqm+tVKO5jHFzfpUaRGtqV1LfxZe0ctXq4eNDrE74yOInz+eHEoY64s2SiiEw4Bn3vg5IYd+g7xIURDAz1LI+Bl7nuOqOXf6xjVv1QsmLC1zaSVF/BvynzzC41WR7qA3U/C4q3r8/2IfMrFOHISyUo7edAeMW52Thad6TQbU2tCrKMIeardEaoppEvm7jtCTKU6dVTs1fKQzpI39u6V38sKH3KSdlFanELtFqHPKdjDtsymrvzFqM+L2q05IPj2kzFcSYJteP6xZ6QrdXqdcOwryrwtdJcDo5zFlO0dN6Z1rVgIgXxOXAcoYmjcJxvIQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAP153MB0422.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(76116006)(53546011)(86362001)(8990500004)(8936002)(66476007)(66446008)(2906002)(66556008)(64756008)(66946007)(316002)(110136005)(186003)(83380400001)(6506007)(55016002)(5660300002)(38100700001)(33656002)(478600001)(7696005)(8676002)(71200400001)(52536014)(82950400001)(82960400001)(10290500003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9rgux3m41BgoMUT2P8ER48Bt1dSgVZvbmhYdhzkXC3NuZPH63qGWblajHDnY?=
 =?us-ascii?Q?NoHA4wDAmgI+UpJ10/AgrpNu5OjZFN2nVYydGu50ymJHFr4v1UeHwMyAXOrA?=
 =?us-ascii?Q?5eMD6u8V6yao0at1uxXxuwtJbugKltTbCB2wuuWu8m1l4OIaU2oYjDvIDNhp?=
 =?us-ascii?Q?FcHp2JyOJW8cZqsFnRRPaJeKlqMD/OP30Lft91NzujB5vvidnY14l02huNp0?=
 =?us-ascii?Q?A42on75BmnOA2SZ6Jvk0owwrVMkWjuWOAZ1JNd0U+u3cKISSVFeD22Zv2P3M?=
 =?us-ascii?Q?GDKdxyxVcEmlvLbNxrmkNcyg43779c1I3RVStttDASfaL1VuMkAjt+L219GG?=
 =?us-ascii?Q?nJOfnRTvX97ZCowEEpPYF3zWc2ttyC1QQOiYbBltBLT0gWNguEMSrwE/CSqR?=
 =?us-ascii?Q?Dp5BRfJfW8XDa1d0WwdHhHP9jcvaWO9AQ5ooJHzOnDDY6aPWIBNOeU0NgKcg?=
 =?us-ascii?Q?2Wm9enrg2RUEptfKQ3TMgQLS2lxaGgfXr3JA4bEoi7uf/TU3YQdAfz0ho/9c?=
 =?us-ascii?Q?nS0TO6KNKUMrAjGwZOQCiytxW10F/YhVMDvZgUoaHJWIsjJhbBxRBNJLhCaj?=
 =?us-ascii?Q?Pb1teiJaiAwwTNkU21+8ayDJEAw+l6Kfu7pU98vdvljVTGLWSEp1N4BMpJhp?=
 =?us-ascii?Q?8x8umvoO8UK4twh1uEDEGS4b+HUThb5jF8hRIXJMrW0kV2XtOanorWXwrUcm?=
 =?us-ascii?Q?TfBwQOwvUI9+qthtH8T+IXm4SwCwLhhF+g7rcGPQPUEWlvPaorBhMJ+GGOOu?=
 =?us-ascii?Q?rh2wGcSE9snM9pveEaJOC0yHOeSYV0Os4XUm/T9FT6JwlbCAc3SDCe05ZvjF?=
 =?us-ascii?Q?ZNL+JgAtfUQwXMsg8mnCj2OswZuTVl4H185XXMWxnV2SBwNW5W3QVj+MwV7Q?=
 =?us-ascii?Q?b9Md6IEjxnb+7elBzb+eR1p7hviBLhxX3oFktzvWhAlKsrI7o0P3VRikOLdW?=
 =?us-ascii?Q?g4q+Y6/uss5r3l6n2CoBOWZGR6MTt/gh9skqZ1akh6lygMfCmaxitG/UizuA?=
 =?us-ascii?Q?GkushDvgIGoW2lXXOAosBc4oTRkmAruhNG+5uYin45QfQUu92h0H4gk42AKy?=
 =?us-ascii?Q?bWQUjBaBfnfWIUc1U/xVSsTQ5TfdFrrNWlKt0+RlUH8fMU+uHw6wYVwF65Zc?=
 =?us-ascii?Q?K9ZsQLjf++/O+z7bPxWwJFA7GdepndOeW4KTDCpSufdxHG6BMAWyyl6WM+2D?=
 =?us-ascii?Q?FTmezVfwJ4fLxfyvmrZuYISnQloD/z2yttfs9at4kmlP83p/VBlLx3FzAckI?=
 =?us-ascii?Q?5agSVS+xYMr41n3tp8kJ+ATwSZaR5EocHTVzZjX50EimtTTfRAmULPagyJUL?=
 =?us-ascii?Q?/Ayt2srrNDmrh4+PLlL4Kr6jxtMiMM5eIIeUqODH9GxoonccpH63g0tCASb4?=
 =?us-ascii?Q?nFLBvj0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e7f452-4837-474b-27ff-08d8fb704acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 15:58:18.0823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkfQ7LVhnRIRlz9L/wl0QV/MALvKDQpW0hlJtbOOKjnwOuY/+DoPXrdiqBI77EVEFCOXQMKcieXXF39CLYAwbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAP153MB0421
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Zhang,

Thanks for the catch.=20
But it looks like Steve had already made this change yesterday. Can you ple=
ase pull and check now?

Regards,
Shyam

-----Original Message-----
From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>=20
Sent: Friday, April 9, 2021 1:17 PM
To: zhangxiaoxu5@huawei.com; sfrench@samba.org; linux-cifs@vger.kernel.org;=
 samba-technical@lists.samba.org; yukuai3@huawei.com; Shyam Prasad <Shyam.P=
rasad@microsoft.com>
Subject: [EXTERNAL] [PATCH] cifs: Fix build error when no CONFIG_DNS_RESOLV=
ER

hulk robot following build error:
  ld: fs/cifs/dns_resolve.o: in function `dns_resolve_server_name_to_ip':
  dns_resolve.c:(.text+0x154): undefined reference to `dns_query'
  make: *** [Makefile:1251: vmlinux] Error 1

Fixes: e488292a31fa ("cifs: On cifs_reconnect, resolve the hostname again."=
)
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig index fe03cbdae959..0d819976=
5045 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -18,6 +18,7 @@ config CIFS
 	select CRYPTO_AES
 	select CRYPTO_LIB_DES
 	select KEYS
+	select DNS_RESOLVER
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
 	  (including support for the most recent, most secure dialect SMB3.1.1) @=
@ -179,7 +180,6 @@ config CIFS_DEBUG_DUMP_KEYS  config CIFS_DFS_UPCALL
 	bool "DFS feature support"
 	depends on CIFS
-	select DNS_RESOLVER
 	help
 	  Distributed File System (DFS) support is used to access shares
 	  transparently in an enterprise name space, even if the share
--
2.25.4

