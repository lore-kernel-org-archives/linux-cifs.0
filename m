Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A7EC2B9F7
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 14:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D027613B4
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 14:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhE1Oec (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 May 2021 10:34:32 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:49265 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhE1Oeb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 28 May 2021 10:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622212375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=o5ggAcCTpVE/76jz+FJtOQB1d8zx141rMnIw9wtnaSs=;
        b=fXMDxM+RKzE+KTETzKeHveUxA7YVI1t2p1GbeYhyBNa+uNU1NHRSxkFAcrb3rJrj7Uvq7k
        GhoHwFuyNzcDA6Ns+uSBjtTZeBwcauXxxnKWPbP0xYLGMpOIUJLA892g/S/a1qQlx8VKRH
        UTRo84puzKnlAzcA6PwWUZIazaL4LrE=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2052.outbound.protection.outlook.com [104.47.4.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-4BE785AIOGWdxNZXAsal7Q-1;
 Fri, 28 May 2021 16:32:54 +0200
X-MC-Unique: 4BE785AIOGWdxNZXAsal7Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afDafJ7fhH5sY34968FijOJNwITHXVkOdO66o+bBAMWPCgt9VywpWY++va1RVSkRglfTn8LlwMriYrPea6TpMF5HAQvgCsIbnGf8JnVrRqT+Dn0MxWhhmzdZeV6GNE/E6yKWqMfuR/aYWIwJifKd7AR1Cm539ZzIyqXPZzq1rAk87A0Jpmk6957VTdM5zLLqD81rGUjX06W7qnnuBlWfu5YYYR4lVRIWLuXwdiIxQnAqDAcVYMXMDaiguVRrV/F74P42VJEQeiQ+HMXCmc+qBIE2Kft0SBe1OTgMgNArodu/U/pgXEJY6eSyqkA1T2A0bBm34p7UGuLkYlwLlsjUZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVsANEP0mYMpEWWjpsEHjiRywcrR8kxOS95kyecgwpI=;
 b=mr+KYIvXShpLSa6usbYvTob6jJbVXusGv+COH7apncHw367L57ubUXKJQRf4/lWpMMgU+bHVKCcqZOoagcP28CceV6WL9+gutWprjPaVMbEd/EP/ESknJj3F894Skr591nV5YWuaNUibwy8lqjnRphYXIWdk6//7yTpWRIoIgJ69iUwXSxbcUpyMoxzRAB+pgJw0alDQabtiSmsfW3T4OWrnIboV0TPnSFW71JAsZaGRji+RPkXkoLwuNG6xNvikFqdTDuvtUqFBA1Rje8qLOACzX6MxsLUrM5mAWCHHCiqGU7REcsWLh9Z9/0ZuZznXQdByz/rIT4JUKQh/FmbeeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6911.eurprd04.prod.outlook.com (2603:10a6:803:12e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 14:32:52 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.030; Fri, 28 May 2021
 14:32:51 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] cifs: fix ipv6 formating in cifs_ses_add_channel
Date:   Fri, 28 May 2021 16:32:48 +0200
Message-ID: <20210528143248.7521-1-aaptel@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:713:d360:c494:e448:539d:457d]
X-ClientProxiedBy: ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::23) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d360:c494:e448:539d:457d) by ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:32:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fc2a40f-204e-4bf6-9f79-08d921e5792f
X-MS-TrafficTypeDiagnostic: VI1PR04MB6911:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6911369F009AE09906097A79A8229@VI1PR04MB6911.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:214;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8JGKhlCSOgQ5peoLEBIl3Ep0LgCx6rsTUOGIenNCOT4xPU51+lVKisJjWDAdA3xGWg/UsbS3DIJRg4NUxpyazPxyH5stxE8Zxihufk+ToZGBYYrr8LY5wSJV+XHZOtgUtZ2WP12TicEw6nCQj1niD3XwLsTcAgKGWAqRrjAeMbjIXjF2a+1Y8NF7Jy/9iuc+OguUAM/yVIng6nOOs2yuxSwPmyHNZsk3DDJ6wHYVygjTJqTgSWVPcfYu0gCBDT5vxcFBI4iFpzS0W51akxj8n//zKpjLrK7aTwV7MEerDinzNYTZTjr5nW03bwoT578re1sKOnX+sfo8hC1j+1MvhywreDN6MUxYboY5ClxCnwLC/ScFQe7Y81Ja8eV9mzAS7HtnAijGGuvdLnnA+CdsV6vRGdhzjx3jel6zD67Us+u2lbmd8jZf2vkx8B3IVZC0ACGxwIgBhZR68jAbzCxvM/YT25YyN38UwEolL7X5Y40WadYES8GOqaFu0la0MTqJ5jIX7RQVkkw5XWFXctjuDx0TrSHo1GaovDyF867wqrHG9GyYleHJ+Q/xJpR84z5liaYdaOG9q58q6pg2/iEGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(6916009)(2906002)(8676002)(38100700002)(86362001)(83380400001)(6486002)(2616005)(5660300002)(6496006)(6666004)(66946007)(66556008)(66476007)(1076003)(107886003)(16526019)(498600001)(186003)(4744005)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JW5sIGnZzprwxttaLlera8XltpomsIEMyPRayg+4ZTno+3hGA6pC3pFSXlnW?=
 =?us-ascii?Q?/u9EkCG7yT98ngWBM9SKeCXfbtF+pGPQrzu7q1xHS/ylEXOeu2NpfWkBaNHx?=
 =?us-ascii?Q?zup1DFnBb08B7ppKY1YIyX3BlFyF+iWHRqouTem8NTTq/iC3KULpTun+JWDy?=
 =?us-ascii?Q?1ey1BY/Ay+ODmEfG3IsfTCvBo+u1HukVvSOjEHCwVesFpptedO+wNR6VnFD1?=
 =?us-ascii?Q?EhutF16ctCgguofX4Ku5Fh1cqodoRYAQHXPfX7UeSXhsBx3fYP2a3BVmrix0?=
 =?us-ascii?Q?dlTE9WBR07oM6GGHlGoqzHbTrSvfBs8KxuyfkaQB9YzCDqt+ceOTrXd3IUbx?=
 =?us-ascii?Q?wqJWHugYOIs0VDcXkOUgAhLeeHi1wGit3fjSFATeRzg39pHcQKoAqsXmR5eo?=
 =?us-ascii?Q?p/+zfNeHmil3DoQsxl1TFPdtGq5Cy4PCxDkSmnOvG5rbnDoeXqyMdJuvUblx?=
 =?us-ascii?Q?+RSElFPiqFcwFh4sNZ3sJQlFehbbWGo2hGrnep6pWpK3h9dHfvvpaSs7JFg7?=
 =?us-ascii?Q?a8F4XEu5cmB0rNtWo12TH1Blp3eVE78qThPK7xSEVPG6T/3dYswIOv/t192L?=
 =?us-ascii?Q?bISi0y2O9ZtcP/COfZ2olRo6Pj57xbVfL/wrg3By9B/em6JZWOwqSbR7fdHY?=
 =?us-ascii?Q?ydb+yyQ2DQnCLmirZ13aGTQbkQfOFv1CpAJAxIy+QlxzXbFrJf5zcc+pc3Rx?=
 =?us-ascii?Q?1SnhZVf07IwIWEqIDhhGaMiyZQmcJF+PdNzheh7MBdJy1rWaEPom4yDrWyWZ?=
 =?us-ascii?Q?W2RA05g9tMrdFhOu3b4cclFrfixn82W6eKdehXV3L6/zr7z/L5cyp2MCJc/J?=
 =?us-ascii?Q?RNnxz3eNqVKNkYzRqADk6Y/fDRE/MbHncZ74siUq6PRzGjIdK+0QJvITrba9?=
 =?us-ascii?Q?87Gfj8Rr49mccfJfLSISOgM5BkSUTxvIPDUmibhTIAJ1Nc8IRjwrk+Fgr9iE?=
 =?us-ascii?Q?uWRmyN1v7Ibh5QClt/ouOCXqVlnGz1mXoPaYjAMnKY0lZuw2Zenya0vMC+d6?=
 =?us-ascii?Q?MZNP+bdKaawWPQqU6RcfwA4CvCe97vuCaQUipWsyCnJYzV5rNaIDNLqLV2KH?=
 =?us-ascii?Q?GjLA53YEG8Aoi10nkZnuUIkDKimCZ227UZdfWLVgFmYywjVDAWc3OIh5ADcp?=
 =?us-ascii?Q?vNOrHF/P6zs7s2Jqi8zXPdJbkoj1ccABDsu5h0pjHE8LsLdG9SFAEs5c+5Ae?=
 =?us-ascii?Q?YZhodd2S6t6iDrHHGBHNj1zNoItzd1WVPoDh1hPV9clPNifuAc4+nDiWglI2?=
 =?us-ascii?Q?E0AZ1oa/QrOdOvgb1m0ub7zaxUspVHxwQCV6XI7psoy+R5P4SJi7awDuZeIV?=
 =?us-ascii?Q?5W5cFmLsXqrH+F8rCEXXWGmFTWdXg8/g4Dql1ihXPVvojcuWOibG+4tKoVmS?=
 =?us-ascii?Q?tjSO3b8JMMYDK+VbH9DxyncBhMPR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc2a40f-204e-4bf6-9f79-08d921e5792f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:32:51.7555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzhe2bHOkW8XlohYwPt42A72n56b8pdjEAA36/BeZOt9a1t60mbXFrdGaZpNBWr4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6911
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Use %pI6 for IPv6 addresses

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index a92a1fb7cb52..cd19aa11f27e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -195,7 +195,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, stru=
ct cifs_ses *ses,
 			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
 			 &ipv4->sin_addr);
 	else
-		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI4)\=
n",
+		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI6)\=
n",
 			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
 			 &ipv6->sin6_addr);
=20
--=20
2.31.1

