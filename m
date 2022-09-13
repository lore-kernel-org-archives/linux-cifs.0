Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1569C6FA86
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIMWUI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiIMWUF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:20:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0016A489
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dtn8Hqnt03YzpGuA88a+FhOeS0seTf+oVjokDwr5XXe+o++e5k5cNFGexBLEC36aKcZ7+0Jjz8pWNw1rFhzsKtkewPbnMuqK05X82MRmpxCD0QtFsb57FBnrJtm1ILoxX251bC5j9TF/AIs/bgPXn9D5CGQKVM4uI4VbC1tOvDSJCdlKQxV1aah8kuLMKSKc+JR7oDmMVn+eWnuut4JViLXoI81X1NdNCG9U3vRHoWmJY9EfCSpRZaTRZYZf03+89+P4WNn5e0oY7XxQkbQQOX68vPWKpaNxecIoFhljaL+X+oGeQcKOQbOZrZBLMGJPzsOoHcmRVBinw33nYTQFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phnMl4ugC+e8OyWUA6WiuLa8GoD33pQPA9NWUYMuASQ=;
 b=bMSn/xn7vR4wPuK3aBPgCQZbAv15FXRZMBAlzLjjFVUP+cX0rh2nQ1u4C/cMGxir5DfmjxZb6kxbWnBmJj9fD6QezaPpfs74CEU0sp4/vgomyd1ytarj0hRhHf1C/DbpRIzzIZFQGD7gxwe/0wk3MxWyfYejFOGl+/QYWwBV/gntdUtDCQT2m/TWVbjSkmg2ior6zVwfM9vNGMIIIbjQPaH6YcC6dNyEMCD5yvdbE3oI3+g8FsOb06yFzW7NU84bdNGH8Tg6Pb2THTAqB39eNS1w98iltnbYe+n2hYDwEbvNq3YbF5P87o6yb+hs6EqqGBSoPqH8SdzCOKGEWFV9XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR0102MB3378.prod.exchangelabs.com (2603:10b6:207:19::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 13 Sep 2022 22:20:01 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:20:01 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [PATCH 4/6] Reduce server smbdirect max send/receive segment sizes
Date:   Tue, 13 Sep 2022 22:19:35 +0000
Message-Id: <27ad44f89fa239f69806241aa65869cd58a04d3d.1663103255.git.tom@talpey.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663103255.git.tom@talpey.com>
References: <cover.1663103255.git.tom@talpey.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL0PR0102MB3378:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c13c911-1a38-496f-b20f-08da95d619bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MOO5DX8X74QYjHtXhIJCGB8k0d7CcHYa3b+w/E4OcDm6FfqH78BlJ/TU7Wfu2JWXcpMPynz7C1Hujiv54n/OMQWrFI3poLt/Kyu3Cyz0e93rTOhypOwVS+RdHKKtdeOLVFz9FnwXb69tjVsAAj4AwOPhxCh8iv7PKk+hnlBL/Cwzx1Ik0YwB29z4EnXFcQrOPDAJDLzhxtTCaaAnxhg+/5zhxF+fbjPMy2Of3ToUPHsBVzIm/NMoXbFZDVFFa/7h5axhezDvKLHC061yzORB2o1ksG/gahAd0gN7A51X/Lj3MUBTqQXNtfzzlaI/GXq8DTwbvQVdeSBlfX2OPECp2V+ry69blEz/g9B5z+oTey25u8hARIJHzkH7QogNYc7CbP+Fu6/QJqOsDe794LdSmg2xcIBWGy/Wxx6SbVhMRhEwZi2keM4OV4gJGU47BECA6CeKhmi8i5PskvqZFk1UI5d9RlEcv9IkMKJwr8J8TMht7cqqUcP5WWWUIcMDII9OXLN0jwWZI+jVxjxeCAbMS35A/zv1NstuH8mg/07n7QCcdjOUpQjg5sgx/t2hhBlLJkXD6reaZSdeYwZzpXfPj0EAERDGD3tpIcHUL/fY2BQAA1toWNvo+p5dm9vnphj4fbys6usirr0C+MMFPFMBxOh2CCXUg9jTWJCDzCzkp4j38ZMBwvalBFwDW6oT9FZW2jRbOkyZyjsrNH648AOcueJMOQjeeVTtlV6/K2Qylx1scbTHXjBhfyG9MWYsPqYGWdb1QGVI4V5QLZC9ezcAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(39830400003)(366004)(451199015)(5660300002)(8936002)(2906002)(36756003)(4326008)(66476007)(66556008)(66946007)(316002)(52116002)(478600001)(41300700001)(6506007)(6486002)(6666004)(107886003)(26005)(38100700002)(86362001)(2616005)(186003)(8676002)(83380400001)(6512007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOFEBR4KO6QZPdu4IRIUJu086V7bjVdrC1utqAuAwCdqaSUnq7yv2+0aYZ9M?=
 =?us-ascii?Q?VYE74fwMkkadoQMLuLNLHlQwcfuMGONqKrEs+uK54+ijhlGdxUptjdY9841V?=
 =?us-ascii?Q?J0JpL0T5mlfNFq8BAl91WkshThyKiZp4eUpgF6/cSa2PiPUm89fdUl6k7uk0?=
 =?us-ascii?Q?AaZv3ZC+NvIUd3V0PVCKPgHo4qhxYz9hghkZ9DyZBzsBibCo6t9aS6Hy3UBT?=
 =?us-ascii?Q?XH15gWM4gSQfv4PkxK35SfIefBZtzxV9me3lTSr3xZSVlbmXoaAvEQ6tD/SJ?=
 =?us-ascii?Q?sitNWsJ49cTJKDjrTWfxMa1rhclvkoIeuXsK+GD7nFaZCQ+3mrzg2RfONa1/?=
 =?us-ascii?Q?TgjtsdkrVZLwYUWHypx36MOYx5sPzQvcoOeOz57hcpstlvmhOr3lTHQAfTN+?=
 =?us-ascii?Q?G8Ds2G2Y24kV51fuBBs3/HzFTnoAYTqhqq/XARib0qnUSMP4uDnIa2X6A+Yp?=
 =?us-ascii?Q?As4kDeqW6jr5jerz5r2BL2cBK+LGGLDtrw8NUDU+wkbRpvXo03wWj0NgcXxY?=
 =?us-ascii?Q?0fqp28iQbIen+lYDEiYvf0f6vrdNt0EMctRbKFTrY7/7/DJtKFxCUtb7PGvc?=
 =?us-ascii?Q?yLflsmzQba7rXB3e/C4oApWwbGEEKNyeRgay2i5HTsnEmUySdf9QxUM4fxze?=
 =?us-ascii?Q?ZaKrAKdWoYz34tX/uQkgtf4HwdWv4HHDkbS8pQ8KTmdjUAC8O6UksJPsM7Uy?=
 =?us-ascii?Q?6ghiQHiFUiodr4Maf+iI8I/fzMDfLn81YmZx6PK4mLhQjXbEYbiJbEyp3xxR?=
 =?us-ascii?Q?sSdxPN77h0RUuqUsyc1Vq5Fir76Th3In89oILPWYyx754QL8FGoUJDYhwGy4?=
 =?us-ascii?Q?SgroI6t3HtGRxxTyQgsUrK27ydAg4XJZYNDsFphPvK2uuMXt5g97IvuvW8Wo?=
 =?us-ascii?Q?cSsHkQeBAn0y1aVt1gHhPmHklsbjvQ3KN6kM+QEmPsDXmiKA+virF33hLg2x?=
 =?us-ascii?Q?asNNmX9nlVIhAGrljIfQnrdmOPl3CWX8hQVIE1fzWXphzKS9fQ4COCif6hOM?=
 =?us-ascii?Q?VTX3MbNrqRprHW8xxr6TvAzQQbBrEtKqOf3gIFmZ7nYyAR/1p/HY2ji0DAhV?=
 =?us-ascii?Q?qj21fKONIdP1gJII8HfdReFXFBAxeuXVa2jaxBKDLlD1xaBR77kKCY50AVpV?=
 =?us-ascii?Q?hwSDUNZ9J85zWPcaULu3qfSPULlqX3EmhUxOOKV+9aRK/pKL+t1yQWzEUPGO?=
 =?us-ascii?Q?sadLq0xRW3OOt4meh5s/Gk7CrIgn/JYICU00ahKk+DbxD59QwL7XjaB2tBtd?=
 =?us-ascii?Q?O8PG4ewuiX/HqgpJkNB1uxj8di8o7Dc5Cn12JxduKZMums83GjutvZBfXYDx?=
 =?us-ascii?Q?J5hoN9vaqxL0cNwfgRsKbzkQkzCiEpcBB6phLMN3oUddBJIthYMsAH44e4JF?=
 =?us-ascii?Q?/yVkBB5BzhTTan/Lu5LRYDZk3PeGWMESNQIfbRHtjZ+uqUY97+ROTgEmJ2Om?=
 =?us-ascii?Q?hPAtMDqfyYCZWnPi++kc75HyiqC/tmH3YaNuBrVxxNEjiMmAw8pc/eq/HqqW?=
 =?us-ascii?Q?UONalqN1hT1rIJs+fJpaWLQ0XMqL61ShjZalEml9VHV92Yb+VBOxMUK0PTu6?=
 =?us-ascii?Q?1OlzhwC+5SFGT7E++n8dnPpC1HN9uZVn9MregmnI?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c13c911-1a38-496f-b20f-08da95d619bb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:20:01.5180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHoO87RzM1OwNfsnmZ/hF5iWnOnKVtUFxXCxIFUEpMfrBR2B9jcMNhxHnuP+FELA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR0102MB3378
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce ksmbd smbdirect max segment send and receive size to 1364
to match protocol norms. Larger buffers are unnecessary and add
significant memory overhead.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/ksmbd/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 494b8e5af4b3..0315bca3d53b 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
 static int smb_direct_send_credit_target = 255;
 
 /* The maximum single message size can be sent to remote peer */
-static int smb_direct_max_send_size = 8192;
+static int smb_direct_max_send_size = 1364;
 
 /*  The maximum fragmented upper-layer payload receive size supported */
 static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 
 /*  The maximum single-message size which can be received */
-static int smb_direct_max_receive_size = 8192;
+static int smb_direct_max_receive_size = 1364;
 
 static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
-- 
2.34.1

