Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CFAC433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 18:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1391E207B6
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 18:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgLCSrY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:47:24 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:30341 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728203AbgLCSrX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 13:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607021174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0HgQ18s22sY9/dUPx54mEU5BwgE4EnvoX53jzxVTD4Q=;
        b=V27LrKeX1C+zcg4/Z5olcZl9DnrMQhkII5V4aRwzU7l7bRgUl3ef1jO3DxBSjQsAH5kj+Y
        +DCR1VDeGvKxDoC7hjLyuGdt5lCeYMWIWBlanZb72SiWugaAnhTxLU4BxJWm/dn4BpBaBT
        NKN/hxZ3I/i5sQ3S3R7836ccjdxsFrU=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-tv7d_uPTNtaozu6YDSBbIw-1; Thu, 03 Dec 2020 19:46:13 +0100
X-MC-Unique: tv7d_uPTNtaozu6YDSBbIw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8HQ/Hgo+DZSW2j88CuJPK66pKxwI6mqPz4O5mchGMfiFCv5i8iOZltA34MqJ1MVurN0ER72ZA82e9rjmLlaH7/HV97pMFPmkCsXrgYlaiLSHHGSMb/QprWDNT4aaaw8TrZe2Xr97RMNtwrunPj+Cd6T743tGFyekGB6y7Us14FyADmaz+pYItp2LCyjSUVxzzsJmpWQrpql0YSJaREnPNt0i+ZQcjH4NLAEua/+hJsDbzAisN+/JstuS/Ned8j358BNMAYlpGuYLllILYWtjlp+NitSaihsagi7IZcirJq+ZHY1EbrDHfagDs3J6IyOJw2sIzf321Q5xwtSe2sFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAxRxtDFxqo1MBg31xRk6FbupwN16pKGUHH9eLycfYg=;
 b=l58Jico4z0qJQB7X6EtCYR1vB07Lx5d5ANFjnCtjNgtoaDQXx3i0avoZ5ZlZkSi509GOz8FOwaun/UngHOMDIUhcUHRla1w/QNHJFMZN7dFWjHu0xXHkEi8lnMRpzbX5QQgpbGEjAnyRVx1h8BTMVoJLbBGQik8sndDXXJqAjUg81SlXn5WRagGl21UjLxingf3biUPnJwLOTEjxOy75W8501+rPoZjeloQAq5PEax2CbsXuokdfiwYKJqjZzErAGwRdooRoR2g6T9EOFzH22IPbzhKuElcC9JxMM+xh2yDLJmZONF/FdV0lj8a5vsuoP9rQJWGn73X6rLcyvoKBgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB7165.eurprd04.prod.outlook.com (2603:10a6:800:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 18:46:12 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3611.032; Thu, 3 Dec 2020
 18:46:12 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] cifs: add NULL check for ses->tcon_ipc
Date:   Thu,  3 Dec 2020 19:46:08 +0100
Message-ID: <20201203184608.8384-1-aaptel@suse.com>
X-Mailer: git-send-email 2.29.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:705:9f91:cecf:b9c0:26b9:4a2f]
X-ClientProxiedBy: GVAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::23) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f91:cecf:b9c0:26b9:4a2f) by GVAP278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 18:46:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dad7148-6ebe-4f0a-3d41-08d897bbb4bf
X-MS-TrafficTypeDiagnostic: VI1PR04MB7165:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB71650E276AB5184E9D052A77A8F20@VI1PR04MB7165.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmnL2mYEmVkIsLHgs2I7F+La1VB0XkIOUj1GtE/ZZ/81nZygrsO3iN4NEGpo6dSmM6d/7JY+mdzZ4n7box6ECCddzf3eU6feE+NaPBrwZfA3NM1yZwu+bBd+J59G3uSfkvUd06DyCK7ticiK+uhm0+mW+r5al6OGatYbB41McSdhznvG6AKJPrtLB0FY4bBZMl5+1o7iiJleFB49shjnU9MIr35+J2QNXm8LinD0KRgKQMhBx4SIIWuFlvsTiKz8tMcVbP518zaqvUWmp+7izrIvfVXqjag0sr+GtXXL+c0OiDUyx3HjWVYsHhpOoM/t7x9QngqVu04TtH+xc+DZiHGhL1P/jnP9ciC5nUBS/ndZ/7alVsxC/HgxLcgcN4CmAz2lbxX75IWAqR4/ioyfTPq0d3vNQdZqVbX3D1NJSojzNbg+ithragmm5+b6bbZ3KFI1WrVewxh4uZpqj5Wvr7vdoxcCskiNt7oTa4ZGGrWQHNoPy41Z/HtfNH3rYBIAQuhNjxVc4m57talDQrP6JPpv2gofSZASs66yvo0iHbGzEBF0Q+e7kp9W+CuMQYoHA3Eb0SG1yDNcRqaKT/ILQKA8H5F2egKc+U9dlSq/SMy+lqtsGXVlKnXlQrdPL2SEhtg4uVO/285k45dOhNaHUMyPtGy5cUDZjiGLLmwEgkzIFhHuGbMHwXh0N3scN6aJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(346002)(376002)(396003)(39860400002)(136003)(316002)(6496006)(52116002)(8676002)(478600001)(6486002)(8936002)(6916009)(2616005)(83380400001)(107886003)(6666004)(2906002)(66476007)(4744005)(1076003)(66556008)(36756003)(66946007)(16526019)(86362001)(5660300002)(186003)(4326008)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lnVwOWzC8m3oz2wKyStqd9HJ9P+Rb+znZRyrwYV7tPYyt8QPvbjNjtmY5ZsM?=
 =?us-ascii?Q?1jsbroEEZa007CHHAzC+bTo76oTRz/L58Cw0a38FNbMl6QSXAvwhB9trZ7hP?=
 =?us-ascii?Q?uqrs/yE0VSkcgFTxDTE5CAxs5LTmnCqnHnhdh8bgVNOmRxZMgHF2ijHns9TY?=
 =?us-ascii?Q?s0ccEFsaM5pUuH0Ts2l/GfqVymgGBHhKVaEFJ8C8VLluB6fhmfbJpwaRhtTX?=
 =?us-ascii?Q?hiYSGOs9wKzUOrLxEkixgjv3QO84G5fkCCWtE8GgZ5YigodaDqLeLvtH545l?=
 =?us-ascii?Q?cmtKNuSRK8HFESylKCKRuynxGmRqICQlEv9/02PM3gCVXxyI6cKG1dVXcmdl?=
 =?us-ascii?Q?+M8K4acUE81Qb5SRfQ/MC6bH20ZsWfsSzNOwPOkXgh0zUu0nQDk2kPs9zdZR?=
 =?us-ascii?Q?KG5ol4aabKNKC3rvSeCnm/i9b/7jeVk6rYR1gUDU3q94z3hvyyM0elYMRQ6a?=
 =?us-ascii?Q?gU6pgBWP7nLq2i6WZZiBnE0+k7Ejju2DRNcDGz3RvoKLKjQDG6wcGeso/XJe?=
 =?us-ascii?Q?MJUTKa6H1jrTG3EvjvdyTjE381ioWenmc+ql0AZyjJrb58dKKwH8yp935332?=
 =?us-ascii?Q?H+lPMjqNSQ9Sknts6KB2/favOOvAueN9Lu9nfC2k0MYiDy2YEcwZsCUkEKkN?=
 =?us-ascii?Q?Y9PLv6SLR/u7pGZWM8PMOvzcV15SEyBiZ/0AenaRwysrTSJWHRp9d1fIjgbw?=
 =?us-ascii?Q?C4rwY8/Fd0f1z9sQczHvv9tMCPQhp4Gjsg2h8i4BjJmtL9pB2cbtI+qwfE66?=
 =?us-ascii?Q?E9uRjHhdH8XHh3894QJIjymMWhuAKLwBWuXq0Y3QFiZKyCfiDeInkIojFjlw?=
 =?us-ascii?Q?2NbhojEfsPO8ximXoppX3ZXVSvfpClhqKOFlnKs0lzqSur0enW6KyjJERs53?=
 =?us-ascii?Q?psxL6w37KuKxnFNPxFb4eyaUQWYrsN7svm/q4SbEwCO2Y/arDVGs9gHulZYI?=
 =?us-ascii?Q?PmSNOt42g7ikh16KLcq4aJPWF3rokOS5+neXgQ7NoIA9uLLRhUtReWKRPWE5?=
 =?us-ascii?Q?lsOhFyk19g/GUunHbtvLaE9VquKdbUkAIRsfVSlbqIxsXW8=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dad7148-6ebe-4f0a-3d41-08d897bbb4bf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 18:46:12.0995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwCkJfNILg2OPWYdCuoseLmP74/+EOSzdhBMGGgUWtUyYodq305jZLgpd/YzEs/1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7165
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

In some scenarios (DFS and BAD_NETWORK_NAME) set_root_set() can be
called with a NULL ses->tcon_ipc.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/connect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 28c1459fb0fc0..44f9cce570995 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4546,7 +4546,8 @@ static void set_root_ses(struct cifs_sb_info *cifs_sb=
, struct cifs_ses *ses,
 	if (ses) {
 		spin_lock(&cifs_tcp_ses_lock);
 		ses->ses_count++;
-		ses->tcon_ipc->remap =3D cifs_remap(cifs_sb);
+		if (ses->tcon_ipc)
+			ses->tcon_ipc->remap =3D cifs_remap(cifs_sb);
 		spin_unlock(&cifs_tcp_ses_lock);
 	}
 	*root_ses =3D ses;
--=20
2.29.2

