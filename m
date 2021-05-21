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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A32C47076
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 361CE613E4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhEUPVP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 11:21:15 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:41830 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237383AbhEUPVO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 May 2021 11:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621610390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saGODfxTGlwpESfyI+7NBm9F5gPWyeVCDnFemV8xYKk=;
        b=cnDGkLGvh5+hsvq7Qq4IeXjeZISSnhoEQWfcW/QuaeN0Q/LYdNiPXMDleMVRcw6S6rsJdu
        JNrqoqdyBDjKObwtB8+3xZmCVP+K3CFRm5KBwYSI73vsCWORxQ7qecelS46xnUZY/xB2Ak
        vRNfGJL6KAFwDXc0mg/CHtJpYiP+7NI=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-KVz7p6eTN1e-PspBxIRJBQ-1; Fri, 21 May 2021 17:19:48 +0200
X-MC-Unique: KVz7p6eTN1e-PspBxIRJBQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOjbjDAJyrbB3xhOMTF+NsIKyGfv4S8ZoxdpSKfcfjX1oyXVHNLpA8lGeN10A374kW/+gCZDIlDd4vWGYNIajDBDeTn2/FZNXICTaquBeXWC8eKszTjd/KapGPZOfDlif5vMcIHpLbF38LxvWKetDmBJ6HBsDK1Nty+N95gasM50f4jCloV90jLen0B4R82xDhHI3jyMZNDl4GAB+EJsflfTff19ZYaMixJEfAvZTqLbtYEinBeF2KPKppjDBDe/D9fX9UNIB5BHWZNQQ6st722qIyOtFpbikvb8WbXJ+Y//UCP5Iq8Sp47f3tAWAj0tSp1dmpvfVRj/4iMb4pDdoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zNPPkVwmXZN+k7e/ui3bspD5sdQ2A/z8/Msr2NZE0k=;
 b=X0vomdeS2nBrsYD0IlhKVl+HBGaL3i7oXSpnG5dnLYuJPz0XcK4SkJfu5UbYaTvnyYSphvzHtXukEmiwk1mBLAiU/lgKGds0nX/FtJD7V8U9eTqrBVlDc7kw9kd6M7yNd7lAoO7MXmwahwRlJ3ZrEw8qAyXY40DQhBegw3498kTC7UnmTg8u9wQ9zFNlg3umLFXKmxrcrt90PumLok5oD1D3UGKVpgk7lrwt40/CpACpWNcre2NJXdkzat1P04/llaWFgxzLzCev+G1+SqNXZNk3+hPChAn+STVhXisFijdD0vy3j8b2IN3+hcbxt1J8cSd9Z3BF9dE2FAAcjR/MkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7453.eurprd04.prod.outlook.com (2603:10a6:800:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 15:19:47 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 15:19:47 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, metze@samba.org,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1 1/2] cifs: set server->cipher_type to AES-128-CCM for SMB3.0
Date:   Fri, 21 May 2021 17:19:27 +0200
Message-ID: <20210521151928.17730-2-aaptel@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521151928.17730-1-aaptel@suse.com>
References: <20210521151928.17730-1-aaptel@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::19) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 15:19:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5399381-9d1d-4edf-506d-08d91c6bdec8
X-MS-TrafficTypeDiagnostic: VE1PR04MB7453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7453763A81D37B025DD8B8B1A8299@VE1PR04MB7453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ulkij5Zp7C93hU6+0xWqi1xpeXnxjHCFXfmohP5P4Zcb5ppttHUvEogPCMOHukjSm/rSJ9KQY7j3263ar+ukBZVpg/0EYmEDow+MQxmyoGDae4vTjQccS3KB3yzuAFuMD6rmHXpPF4adUoEboMJk3/b/H+CWJlcNXILsSzg2hXEcd0y+ukD/gIpTuU45oiIQN2spF3iTdu1aQMcG8hUHRYtaP1OH9VuS1+GGMPxNLo/FHFPOyax11vTuhAZCz3S9nge2tCp6LAG1RsIWpdDum8D9Ji30nVxNiVWS7fus54It8yj0thUjvG2WpeHB1mDKobc6rhDRW4+icN2OHTqEMa6kYnd0NIrZDraMFY7cuncaUFrcJRvpCpRDS+zI6k8ynSqt3PxvRveBHq/eLbFC1IMdayYL8a5aeJVs9/i5+qbs2E+48GIBI25ZPVscRmFTWzQ2eEr8wdF/yTUpLNrSf2Vehd/13mbmjvy0+E5zM4v+5TuBu9eb48m4CmZJ0AX3gcGY/9AthYKZ16twXobYvHReibI63BQ+R6vsSAOlIzacgoaXfRyAdJ2SIxIdR5AF+CdUdeFMHv3A2SJOV846msPKYLduNnU18RqFAHd/ljx6krI2de39yrQnwKZTng+SZ2nTU+OleD5fh7f7efRTjpCXKa3lB8V13vFn3N3Uh5/NHSXnpdZ5Jox7FxZp1jorW+ELCAv7puZQj0ZI1/NEpuoJbQmbdKQPOqlJW2y5thApQu5zQAHcsbLH1C5E+MXWoCCzbAtC3/wT23De62M08dY1lgnzkinOiDfxiVGjh1ixf4OHm/AZv8qhr1RNStW1rjUmQtb1690ZVFiiGMU8bxr6W7tYWQAW6ZXBqCSZu4vqedylbcUf96YRRBeQeTN8WiY06XwMZmokSKcTx1pQj+csAtHuX7a7s2XBxM8wfplaXlIKk+Z44rb0nQ1Kr9zCgf
 4qWtL05X8xEZd4JMGKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(316002)(1076003)(66476007)(66556008)(8936002)(52116002)(6486002)(6496006)(186003)(8676002)(16526019)(2616005)(86362001)(66946007)(5660300002)(83380400001)(6916009)(6666004)(2906002)(478600001)(38100700002)(36756003)(107886003)(4326008)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y168LK7nK1U7BXv/jgg8ZjfNBbiD65/RBihpDlg6Gid8Z0yRKqXdaHE8wrQK?=
 =?us-ascii?Q?pxec4f1Y/yGhS16Jae6qyqLHDqTRPVJVgRcdK8JJtcXLIZ1ABfhuyolpl2sP?=
 =?us-ascii?Q?VCXUtGP3Fe4OObRwT3cLbVEVz6SFt4ZmmNlXEeTikrTgqnPnaVWYTNlxmCly?=
 =?us-ascii?Q?wIAw30qjg7b1BLn5iP+OsD8G394+9ds+zl9bFvxW4FMzaCHzXvMri1r0oKij?=
 =?us-ascii?Q?8E4/+5fWwYB1kzgfLD3qeju9Hpo4Vm544/Owj4jbH7iAoA6DrnHaITcu1mo6?=
 =?us-ascii?Q?KPYC3AiQgapnlzapmYl535vpIcpkeIgd65IG34Cs43SCYdrpYRNOB5txR1gu?=
 =?us-ascii?Q?CyNO7k9aJgkedzvpOth5keTLusesoPO+NybsvsZ6Rpg3L3Q/hkTHrWcLudGU?=
 =?us-ascii?Q?R1HHkSHQHcxH9IBe74y3lxxWOSeKnD6Et9DSyYp4nWy14Ug6jqxH4jyFco8D?=
 =?us-ascii?Q?pYjxHp+mW4tV1a5VPfiaZlLK3oM2eB472halDIES3L2Xf2GIUe8l3ghlgNCA?=
 =?us-ascii?Q?eaBEu+FPxmciUsfGeeqdocpLxNwxDpv3QI5Mk7/GKhpEP2Oafkdp+qmuyhdg?=
 =?us-ascii?Q?zbO6vKaHEhr3o5pTypJCLc8jmt0gW5Xz5noVew1l1y4q/B/87jY8298iSFJw?=
 =?us-ascii?Q?QJEJ1Meelj+lUXygqKhIYDNNOrvsIdtP8h/G83VmD7JeOmt3Hwi7coqndz5e?=
 =?us-ascii?Q?Og9ZuhuveV8CKhdDKEIz0CAcyqEdWZDm3WA0mjD/+2C/0HWzcPgZP4nsKwYn?=
 =?us-ascii?Q?cqxfKvqY4uuCiFu0U04T1BhZqO8HEPnw5B7DF7WdPuGlfoIS9IbS2Nb9vVI/?=
 =?us-ascii?Q?vCtJl8E6sEBPWO3oCV25EnKrASgIka6JLnpnAvwYvOF0ywVB68YJj/vreJjp?=
 =?us-ascii?Q?l1fiTobW2hMTzjsQCCgVMG4eklC0VkalFSYCoa9X3X+ytRdr0/L3kxbJ8bVO?=
 =?us-ascii?Q?jQBh8FjSkYt6/HlW/KwAQIBVVyDiPRzZPwCqYfAAppLslzLMQeMipYXdLsRO?=
 =?us-ascii?Q?BY3u7PSJ/mKS54rpz0X1r0su564Fph+W5CdatnuajdKZuBUCrsh/Lp6nlv1M?=
 =?us-ascii?Q?nJlQh8orymqcgigKndaJfLj3ixlSbVy4h+lCrtwRISuBmvvJ/NsecL0fY+GU?=
 =?us-ascii?Q?iNUTZAmFO6/xd9OZH+pdZAWa87Av7t3vB1p4e1F3pyqRxp3l3BazJIGLrdfh?=
 =?us-ascii?Q?lPNSKOeqJ3u4YOQF/m1Ly8iS1CFOF5aX9tD3faCMtQ3btnVOS5zAv/Jok116?=
 =?us-ascii?Q?sMQ9eYgOcVV//oAuNUE6iBvv8uClzxz0I1EetBT8kOtt+oVsYy4c3zJ/EF+n?=
 =?us-ascii?Q?oDQPJz1Oh1rFug2Un/SZKMryhDtfFZJz48JmqlCIaR5kNTT+/M9h07JsdxaJ?=
 =?us-ascii?Q?3CXE4bE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5399381-9d1d-4edf-506d-08d91c6bdec8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 15:19:47.5413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/LCsnWCbblmU2lvcFHlqkg/MhKSKBvt/eE4c7275bzpqKsKhJClIjLY+799BfJS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7453
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

SMB3.0 doesn't have encryption negotiate context but simply uses
the SMB2_GLOBAL_CAP_ENCRYPTION flag.

When that flag is present in the neg response cifs.ko uses AES-128-CCM
which is the only cipher available in this context.

cipher_type was set to the server cipher only when parsing encryption
negotiate context (SMB3.1.1).

For SMB3.0 it was set to 0. This means cipher_type value can be 0 or 1
for AES-128-CCM.

Fix this by checking for SMB3.0 and encryption capability and setting
cipher_type appropriately.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9f24eb88297a..c205f93e0a10 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -958,6 +958,13 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses=
 *ses)
 	/* Internal types */
 	server->capabilities |=3D SMB2_NT_FIND | SMB2_LARGE_FILES;
=20
+	/*
+	 * SMB3.0 supports only 1 cipher and doesn't have a encryption neg contex=
t
+	 * Set the cipher type manually.
+	 */
+	if (server->dialect =3D=3D SMB30_PROT_ID && (server->capabilities & SMB2_=
GLOBAL_CAP_ENCRYPTION))
+		server->cipher_type =3D SMB2_ENCRYPTION_AES128_CCM;
+
 	security_blob =3D smb2_get_data_area_len(&blob_offset, &blob_length,
 					       (struct smb2_sync_hdr *)rsp);
 	/*
--=20
2.31.1

