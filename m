Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4FDC4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF554229EF
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgLNMHq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 07:07:46 -0500
Received: from mail-eopbgr1300091.outbound.protection.outlook.com ([40.107.130.91]:27360
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729840AbgLNMHq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 07:07:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZgyHjdXdMPErRQsYy6A60rM8RucGkjh6LJvxucXdwtBNvuFSghh0ZktFqMjGUZACjcS1mXqvOpwyiDiPW+7VEsl40Gi3LBKe08w7uJIdnNcWZSvCgzKTgIR5EaHL21KVpNR3hRqEKb1P4aBnC39L0taijg6d4LqxaP8KzKq0gJIa6NQ4VEfd+rnGbMPoYpKybO55zgOAvGnBUDIKdX9QkSXhmdvxoSXa4op/VZ7OxFR06c7/Ro+vEHBBawNyVSZiJVYieMYsGnWBucnRlx+PVtAJOef/YXQYSetTTzfgmZn4geW7gQ2NkRuRrgLOa2ba7Yhu9BQ8346lahxAKhQrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/peJIvEXfuTa0Puy4g0rlmkiQBuNOEa3PQfTTPa56I=;
 b=Vz2NQlwMsC734jl314/2Hzz7lx2AwflvW1YjhJT/206tT3YxHb2uno6Hd/Dfo41b0UzBnlzpwySKsNe0e+W8wO7qfM92UHRcclKLYmmq4/AXYiSQL1n9KndQpk2wmnQuY4HAIlR4HMF1XGAihP7SBq6TDBgGRicWjkTltkgc6TbgJxiS9M973oH93n254fbjb60jKK2rwaCDN2J0Sj6/mS64UGOyySQQG5p/IpReKiWYodP9M7fAxrFTzwdZodEwmDls0oa/Nw7XGbhI1O9loX21FlS4NetCmKFtvTwijHGkSrfNo8yjt7/8V7vIVNjg+XynPme6nc0Z/iJRCN7etw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/peJIvEXfuTa0Puy4g0rlmkiQBuNOEa3PQfTTPa56I=;
 b=EDcVE7PMuk/MRJG7o8brBwr85VQ4Hl/irEqNPaFV5WpWEfs6S7tJubhnr4dnknUSmjTz2PYiLzmcl18O+grIG93zJUr+I5HNHqzO7mMYSk0vvNNUmgXi6tM3RTX422jJn8IhvGMtScVKfWzMtaxmGpsjyfcqJ6Aj9mO/1c7FWpo=
Received: from (2603:1096:820:32::13) by
 KL1P15301MB0037.APCP153.PROD.OUTLOOK.COM (2603:1096:802:f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.3; Mon, 14 Dec 2020 12:06:16 +0000
Received: from KL1P15301MB0401.APCP153.PROD.OUTLOOK.COM
 ([fe80::d0ca:28e5:90f3:1c]) by KL1P15301MB0401.APCP153.PROD.OUTLOOK.COM
 ([fe80::d0ca:28e5:90f3:1c%5]) with mapi id 15.20.3700.010; Mon, 14 Dec 2020
 12:06:16 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH] cifs: Fix uninitialized variable in
 set_chmod_dacl()
Thread-Topic: [EXTERNAL] [PATCH] cifs: Fix uninitialized variable in
 set_chmod_dacl()
Thread-Index: AQHW0hByPH/YW2xm3UyZUS9aA/TeBan2fVDw
Date:   Mon, 14 Dec 2020 12:06:15 +0000
Message-ID: <KL1P15301MB0401F166D77AD883E07367F094C79@KL1P15301MB0401.APCP153.PROD.OUTLOOK.COM>
References: <X9dS1EllbQhuX7/C@mwanda>
In-Reply-To: <X9dS1EllbQhuX7/C@mwanda>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f86f02ae-7d8e-4c4b-bd7d-3970c6e6f4fb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-14T12:00:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [122.167.22.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b24cc026-4a55-40fb-8dc9-08d8a028a8bf
x-ms-traffictypediagnostic: KL1P15301MB0037:
x-microsoft-antispam-prvs: <KL1P15301MB003741B2495FCD1DCDD1884F94C79@KL1P15301MB0037.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uSBVLpGnz0qzwXYgMwNBYkXM0CDnSK6e8YTmP/L4RcQVyULm/Y9O71r2DqNH4rqOe7KSiRnwZU0SzarqnN4C9OjeHli8ECmQUr7cUPJIRx2+T2qW7t2eZ7/pMOGaONRD1XXvruvH38BRX4MFngB6wc+Zk4VmLeGO/Pyzg4jmeV2SdkgPespLmhkXwZLhuGOyUbAtoO6fLFHm4vxqJqCadT4UrfpAfOJ0IvsghisYDIP8MBrxLm+x+IFAkgCf4IAxB12Ph/bqpIGxB4PUOEhKIYhfitvH00NAtn74mgvhwW/OWpqMGUvJBiDW+rCo4jWaG5rwkzzo0Me9Dfnt7gge7wWu3jHmBpxpBGwGGa4TztB6bU5IIaroXCM5Onlj9qSHaKxXdcbKKz8/3UZVK9RnIU1xvXSjDJoEudrKbA8BOn4DCiP48C5Lh15KWm5IdLdiz9BNzXKGWglaVjSevTNXSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0401.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(478600001)(966005)(8990500004)(8676002)(186003)(52536014)(2906002)(5660300002)(10290500003)(54906003)(86362001)(66556008)(6506007)(8936002)(4326008)(316002)(110136005)(9686003)(83380400001)(55016002)(7696005)(33656002)(66476007)(82960400001)(82950400001)(66946007)(66446008)(64756008)(71200400001)(53546011)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fHlzTR16gsMffqCkqSEY59M8Tlt5TypQ9hx59UQkgk4YrbILMJk/Y9SD2+IL?=
 =?us-ascii?Q?tP8akBHTV0Lb9EurfmwpoxfDYAvH/79tlJbHytmIapBf+ZX53qHyjjuJwgL0?=
 =?us-ascii?Q?C3QBbdAX4wFkhPqANm4W7nvLNRm9NE7sX2VIvAi7OA7JtjcwPDtXRnPhtyLa?=
 =?us-ascii?Q?xLSAqTpsBAQNvKPDZ8UiXMF5Q9V+RS4B/tVTeGKMlVbz/VrKBAL/0a9CNAQp?=
 =?us-ascii?Q?BgvzjV8RMIIbyTn/sMhc6RiclPgXEzAOGAVAG5PStZmTRLDEkhbF2/k0kE1D?=
 =?us-ascii?Q?hs2a3JP5D5lKUrOAkK99+X+HZZrLlRPPaqYkURJjnvHjdHD8YqONkcSRGtSz?=
 =?us-ascii?Q?z1rCpo8gQx1KCYMIZHy+igbpJDv2BvZADuWs4c/xNs3PkUYmU/mg3UpxaUgL?=
 =?us-ascii?Q?SyflcXoFXO37KfHmBV1U4fTzB3LI7QumBmg/xnC/RBFj9xhB3DWb8lGv1fL2?=
 =?us-ascii?Q?lspRgoXa7El5Ldwrqv0BQE8hQgzFo7TayNiMDi5V9eFzEzHk1mW/2yL2dZmI?=
 =?us-ascii?Q?dUEQ5lXCE3qKRZYAa8gHp6PSDbRtyMPt7VHW8wL3ChwmAPBJh3ccJNSk36WA?=
 =?us-ascii?Q?na/oWmQnfyHeVWjpdoZ+UdcAlC4fHc1IXUJH/UJCjK3mobrv+Sy3ltZ1NPC0?=
 =?us-ascii?Q?YRu+EFvSV+hvxqPncV+Y91p9ki1/+mkhiw5JK172IU3jeG4khMGIvZSfyZ2T?=
 =?us-ascii?Q?LfYy4kJ5pnjWzRwGyD+FZBmCgFlZOz0ZkHROjIMfWJkS1ugpRTYd7SQLGrf0?=
 =?us-ascii?Q?5bmuqslZwNIOPJYRTjo808r268hzRsS8TCSwE9Fro7MZIKAHW2QOBACL0rAV?=
 =?us-ascii?Q?3O7Sp2ZEE3TU6FSXuAzLc1E/7wx9edKLPfljKIQnekgXJi4//iMDhOr+vJoq?=
 =?us-ascii?Q?bu2FJZW7z5OoeXBMfNHWcy14oGW1S8NxKy5ZX4yaUtHVo9UMs7vgKiY7JnoR?=
 =?us-ascii?Q?2Yv5kxRtpZsebrK7xsGfigDKlhEF57zotWcjOkdpE9U=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0401.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b24cc026-4a55-40fb-8dc9-08d8a028a8bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2020 12:06:15.8831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kt9Z8/jNLTDk3SqTyp2qfnBxEubXGxFBZvzxiSBd0ycr7SSYvjMcvNy73WhIsW63FN6l9Jczs/Le/dgkXjgqqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0037
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Dan,

Thanks for the catch. This patch is already in for-next branch here:
https://git.samba.org/sfrench/cifs-2.6.git

Can you please pull the latest and verify?

Regards,
Shyam

-----Original Message-----
From: Dan Carpenter <dan.carpenter@oracle.com>=20
Sent: Monday, December 14, 2020 5:26 PM
To: Steve French <sfrench@samba.org>; Shyam Prasad <Shyam.Prasad@microsoft.=
com>
Cc: linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; kernel-jan=
itors@vger.kernel.org
Subject: [EXTERNAL] [PATCH] cifs: Fix uninitialized variable in set_chmod_d=
acl()

Initialize the "nmode" variable earlier to prevent an uninitialized variabl=
e bug when we do "size +=3D setup_special_mode_ACE(pntace, nmode);"

Fixes: 253374f7557e ("cifs: Fix unix perm bits to cifsacl conversion for "o=
ther" bits.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/cifsacl.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c index d7a6d0f533bf..8410=
db328e5e 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -920,6 +920,13 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, str=
uct cifs_sid *pownersid,
 	__u64 deny_group_mode =3D 0;
 	bool sticky_set =3D false;
=20
+	/*
+	 * We'll try to keep the mode as requested by the user.
+	 * But in cases where we cannot meaningfully convert that
+	 * into ACL, return back the updated mode, so that it is
+	 * updated in the inode.
+	 */
+	nmode =3D *pnmode;
 	pnndacl =3D (struct cifs_acl *)((char *)pndacl + sizeof(struct cifs_acl))=
;
=20
 	if (modefromsid) {
@@ -931,14 +938,6 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, str=
uct cifs_sid *pownersid,
 		goto set_size;
 	}
=20
-	/*
-	 * We'll try to keep the mode as requested by the user.
-	 * But in cases where we cannot meaningfully convert that
-	 * into ACL, return back the updated mode, so that it is
-	 * updated in the inode.
-	 */
-	nmode =3D *pnmode;
-
 	if (!memcmp(pownersid, pgrpsid, sizeof(struct cifs_sid))) {
 		/*
 		 * Case when owner and group SIDs are the same.
--
2.29.2

