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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E275CC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 18:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF1F64F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 18:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhCRSRt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 14:17:49 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:41750 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhCRSRV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Mar 2021 14:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616091439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WUgRuT32rZUfcJnD95eAD4iL66eQefj0LB88xKhNUic=;
        b=gqM8ZyrzETKQnLI7xfLaEBkw0ttPPyunYDdy834A4Hn7Vtyg4cOn5lbLtMVKGWIm9MhnDQ
        DaFUuRLPdyeV61eZVcYucFGJnlAtrEwhVOOv7XzTuN8SrIJv3jyKywkY5dZMCsxeOACcLJ
        xfmR8t4YTl9Ypm5D3T+K5nsaAZaTJ4E=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-L0sIcZqQM-WZNJYueCIR_A-1; Thu, 18 Mar 2021 19:17:18 +0100
X-MC-Unique: L0sIcZqQM-WZNJYueCIR_A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtqeufLcOXWx1awMO6BEyerrIBW280CJZFo4MgzCjYCgONZ1oMBa0fA1mHv57Ht/VhF8wx+k1tZj23GvycaI++lAo/LxFayJSb8CbUCShDkltq4h/70nICp+5SnCVzpGO8eCZdjBivXjDZtvF2xNLQ93bwKgHm82vR6e3nLEum9VCrU74VGXVFO/ANIEdiMZlIlw5X72tJp5DTFgnCnLewRRmBqBsJIRw5Y0Tgdp66KIdXDLUBGcfSkoEhFly2SUSl6s5q6zl3Rd+soNnjOjxMnmMkawhjXGHlKgPx5clodkaKQFbCL+5axzKEEWWpHx/uKhcc3EcUK6te/czlg+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbRJ6+PE9Mv7b5RKodcRlZYJ4dLXW3KEHGRZ4VZVIE8=;
 b=bzhxqhnm+gLJKMfU1tIOLLPISuJ/kff0odVXm4kTkooNCONmSMspWSxfzsdyHRyq+B87qaUKCYLHm0X8Xj6NxXilsY4VUDv/cwgOF1Ayi1Hvh6A3uT7mk+6ILGcXCgiPn0oVMlzlrnyNn2jUdTEWiQRHW+oNouILIBoRUr8bj6JVCcclrTlBppKpQ6zToJdDxJLNT/y2QbsAoEumcvDJwUDaRCZj3g8XORyuOybA+FDP1Gl/vastHiItk6DRli0SDBsKrGH2xmJA5vnCWxnRqE64pLT2+uNBX3M6MCC85jdvvnn8Q1x/SoQI5GcOf0D5NoJylr9lem12/aa+ABvjmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7456.eurprd04.prod.outlook.com (2603:10a6:800:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 18:17:17 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 18:17:17 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] cifs: warn and fail if trying to use rootfs without the config option
Date:   Thu, 18 Mar 2021 19:17:10 +0100
Message-ID: <20210318181710.9003-1-aaptel@suse.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:700:2866:22c7:97d:4e03:1280]
X-ClientProxiedBy: ZR0P278CA0127.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2866:22c7:97d:4e03:1280) by ZR0P278CA0127.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 18:17:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e05af3-5878-4461-0780-08d8ea3a1011
X-MS-TrafficTypeDiagnostic: VE1PR04MB7456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7456907491E1B788D395E60BA8699@VE1PR04MB7456.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hni1S81CS/jDpQTlsW1ekMOTXs2RFTfZxB2rHCD3YBY8A3k6j9YkOXzSE9OeIPddaKfYJcnFRSbSztnsafbimRv0CAC4m6ZJX0uk4peLHVhSKwTqfLlsEk98sHIqCYg9oYNhPmneRZEtq7CE0nh/zU+AAjii283wNaARMvr4VjCkDtBFoZ8ryAKAvgUJTZNyA6WuG4APi3JvZSij6XJ5hA9J23ca8aOswYOFCfJZ0BaXQ0zRmXw6ZDYoV9xeiSNmfliYOjYo5ysjKZy9IWIxPgryTXv+Vqui/aVsFWs+CvrvHvcJ1z7c5PMoAc3S/a2Sl3IkRmimQ+WIQN23e8TpIvNJXKxmmhsj9gVY5CbAgnpE7JxvHRrvfNOonmWFiTKZtmS8p/M9EHxeYmmK6cROnoSa1YYrLhr+rDEoROXMgDhEN3Ooh+QTsZyYM2uctjZtpiRY367yN7ApH3j2RAGEVs+OJFBMCQZXnY9vNuiGwi8lUca/7sEEyYqg9HQ7hJYP7e04oONLb+wVj1KTN6xFkiz+Mgx9CA2e9k2Z4zmxD6chfTAXevf2qBE6yZJL2fTvtuk9e9QguTTuQPrXzR4dE+l1r8E3uqOxrPUgrrN/JQGYlXoaJ5i4RxAnQuAUJ9iNPNoqdLiSe7c2bX3UlDk8MeQRSqgtJP9HjmRmlv2K+zSgXFfv3e45lqP1pHpzQ9z9k5sf2QYiq5gnTXD1SZ2J2T5iyTTQ2PdSmogJuIrFp7BJc/9+yjwubY57yj1z0Kf+BXhm8jjP9nTxX/+uxLCcR01kUtSHV0ZEMBGKjTyeRmJh6qRSiBP8aHcvQKd31jrFunRp5QQ3LUE18EScESEAPSeTpgsf2uEEauqUHYuMhYpLnyFP53l4gcV3ZcV8iGHp5tHZ1AtnMc75GJRv/R3V4fV6Hj1OAq0zRyinn0zieeI8Qt82cauDN+JNxyrGsDtD6sv
 KYmiMPX+EjJSoW3ZE6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(396003)(39860400002)(366004)(346002)(376002)(136003)(1076003)(107886003)(83380400001)(38100700001)(16526019)(6486002)(66946007)(316002)(4744005)(2616005)(66476007)(6496006)(6666004)(186003)(4326008)(8936002)(5660300002)(52116002)(478600001)(2906002)(66556008)(6916009)(86362001)(8676002)(36756003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zxvX6HSxNaWVuAUFukO5QjF+WLPzfvDWuCI3x+9EincRu79ZorJqV5KCLBEj?=
 =?us-ascii?Q?dXZpgwVpmh1XISlblkyD6Ghrm5djBePmc1jge4LWMS9dy7CBVf+2SSmbPa1M?=
 =?us-ascii?Q?xOSxPjyiQt7N8VA6BJ9BNJEbCed2WcJyLi3Ruj4eY5P1o12v2RhkheLpK6Q9?=
 =?us-ascii?Q?ABOhkhQKcOw+QJanhaI+By+I254QXQRMkCxvg9vh+YxLmeIvJ4wGvxht/xzk?=
 =?us-ascii?Q?jgb3W/8/oPSOjlyZ4/FOqLeQrIiS/+uADL9iUFO/ksZJR003IxUsWMEACZHl?=
 =?us-ascii?Q?2+DNcIHJqfDHNIFGxtoSXeejXtkWcPbMkhhzIaJtAx2SlwnAtwtnlQiz5eep?=
 =?us-ascii?Q?pEWIYJ5EI8lVVBWOXMYlseMahcL5VmvTgDGFI1MuQI6nltsGrxczfKRpX+r+?=
 =?us-ascii?Q?XD+BlQhhgTms6i94/L/bTzJoOv4aq26l0EvNr9J7t4ebJrcihSGkVILexjh/?=
 =?us-ascii?Q?QvNjVsfC812aRfwS2QfkmFXu9V4eUQToat0ICqBccGbC5DP7ov9ICUdidvYE?=
 =?us-ascii?Q?HbZ+7dYQdqhF8L3Fl0z/47ByQPkTv5rEjtOeKBCW3VR/CS7YNaIuN/i7VudE?=
 =?us-ascii?Q?rgv74QAbJVzFiETwvYbANjqv/CcBFlhmH2AGBpXnyt5L7wFCGJeyW8sXR51v?=
 =?us-ascii?Q?lir0ECFPpOmX04OAPmYraF9SWUGpDculeuPRNX1gmuvApinWTftGqgPVXpmk?=
 =?us-ascii?Q?bK8oJRvm3Bxp7VNvLMzxMPGU71aVagFOX6kmRs7c0z/CnqOwmhW+7ePawJlr?=
 =?us-ascii?Q?UUOSglWyFY2tyI2plPEDUPBxrFugKR0Jt0VlCN4LTH9CArT048jP7wVTK0ZH?=
 =?us-ascii?Q?vj+x4ffDFlS4JYjCw6sGwEQuSlRkQ21NqJqUYw5EZaSjz/Ip/62lq49DEq1H?=
 =?us-ascii?Q?jcccV3PKGq56EAFNbfiWOM44zS4qhPkOpNZiC9ZHno0lmxaCggQRZnPj9SpX?=
 =?us-ascii?Q?1NdgQ22BuXazMte8xxN1b1io+tdDheand8oxgXaknuVnOxJEbizqh0ZQ9Ihw?=
 =?us-ascii?Q?Udfl43/KeAlt/xPu8FcUez4z7BbTf9YHZOffvSovHikSlkIWrqyVPE5dnO91?=
 =?us-ascii?Q?cMbcLitpopr6nvJue2GkD8p3nRaNt0Wt31L5oToquqTefXXQZraARsuLQznC?=
 =?us-ascii?Q?6/6glqVudRzU0ysAkaaWpMxgKthklw1X5G4pBYcPPExCFnPL9hXeQYWpr7Mu?=
 =?us-ascii?Q?ltiSYK2ImnlM4xjIJHOUSjO2PcxTEvnRX+tA3IuDS0iqovgCBzTZ2gCh+LJH?=
 =?us-ascii?Q?tB5lzTmM20TWNE5/AwoeVTgM1AxdyFKOWBv3w76uGqdQHg4ur17kwgROyieh?=
 =?us-ascii?Q?u8LGubwpCAR5Upf0I9MSx+qz45AlrKVtuUtrvkGyITzIxa+74vhx+t+6SWea?=
 =?us-ascii?Q?LOn5tU5yNSczSZ7ubbXmL9cK2qHE?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e05af3-5878-4461-0780-08d8ea3a1011
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 18:17:17.2199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KsChmywscFdhsxP+pwQrsbHlUfBUY8rZ669S/b6E3YWm67VeP+7JKpgv7qIelGIm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7456
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/fs_context.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 9b0e82bc584f..d0580e2d1f32 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1197,9 +1197,11 @@ static int smb3_fs_context_parse_param(struct fs_con=
text *fc,
 		pr_warn_once("Witness protocol support is experimental\n");
 		break;
 	case Opt_rootfs:
-#ifdef CONFIG_CIFS_ROOT
-		ctx->rootfs =3D true;
+#ifndef CONFIG_CIFS_ROOT
+		cifs_dbg(VFS, "rootfs support requires CONFIG_CIFS_ROOT config option\n"=
);
+		goto cifs_parse_mount_err;
 #endif
+		ctx->rootfs =3D true;
 		break;
 	case Opt_posixpaths:
 		if (result.negated)
--=20
2.30.0

