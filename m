Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9BBC6FA89
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIMWUI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiIMWUE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:20:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72046745C
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPwbL4C1uha7qaXcsJgsaw1QQGNM3I8zkRi0a5OABTpMBW6Uv1+oA9COL8Prnf2hccYf/GYEiV4McuwZMDzPJBsVPrA1DgkivJ205ix256I3yuUz3726YAU+NZmy+XoxdE2KD/Ji8MJy2fg0cwhXqvtKwBUW4NCRw7cLlTaF8szBEVIWue1hPIoHDswxDm6pfY4NVXmlzr79jeFM1LmNqDHEkuyBml8GLr1Py6g2TW7OjGWNragHaqxqFjyZD+tQOR75ypTXIcGei/R+7PSJfo7fyUE1ijdUe4l5aOuvVPLY7MaqS74+QS545I5Ryf+cETOnvQle+IClcdlU+oJjPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zt3d8Oy1VfX+ugp+UOthZmnd/5vgHGAh5+SQqKRIXms=;
 b=ny/bq+XbA2nI5/m84KRiioyvhjqYiJb+nOnSFlr9h55v3IEvSqEDV4zTFOazCMW0g5E44/xR37IyA2u7mafUG1Z9LnSfOUst+6gM4jybwa/yfFTIPk7BWYZA9buk6zfx30SKLU/BqSQKOV29FG2WjQ0IhDKfiN9sWY0i2U0GUPA71TiNXZMSq992G9G1ADkFYnXbv9W1Eg0zvqAz+Vxjz1bvwe4BI9d0pbhqlbYCIYN6rznZD1NhdYzMXhgk0lHXBMJJFI+UK/LhKJa6BaZnUcKVOpT8/BVzp9bHy6/vpZ0IUOAKNpbp39BWmbfOS9g+ySbopbmls8ZcBNKCbJF64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM8PR01MB7159.prod.exchangelabs.com (2603:10b6:8:d::16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Tue, 13 Sep 2022 22:19:59 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:19:59 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [PATCH 3/6] Reduce client smbdirect max receive segment size
Date:   Tue, 13 Sep 2022 22:19:34 +0000
Message-Id: <51241595d597712e4f12cfba521b861b37cbf43b.1663103255.git.tom@talpey.com>
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
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM8PR01MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: f3053b5a-3fac-4eb7-6111-08da95d618a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NIhKad/UGBAndyn++cFV94++JmMEyooJ3tWYvj+BP5Rh69dbN+XY6rjJVYjYxHhq0JmVqodzHgwI+lH7wG4u9grrGtwC6BhF8C4X5a8P0TLBYIlR0RpxE0xhyBRY1FS7UheIG7eYY+MVoGRvejD4kB8JeCS7fZY0YWqXEsp/8asOqMuFu7Fv7UrrG/xZxu1lACsVl+3Ng7vy/DhrP9tKQCZMwxiRTNtdrbQV2m222q+5coaC1xclP6TBV5hxOlYeWs38f/RguzdsOTHqlv2gaq3pXhqM8wIB+6Zpc0nKiCr9W8zYAMx3J5neip/W9ErJPpfE9FicH4wBjHoGrHJs8qfoeA9Y+ObkjJpexsUdgd8xD8G+Kp87K5SvWk7WV7NwP1K0YhF7P75oT73Cm7sriCEu0q+jpb57va+9vbKv5N79GU+Lf6TSHFlC+46qqYwgT7fVKedk7R3O1Dl7JhsGtWo0SOmm4dN6U4CKZ5g/BPnh1mN/VrrCkmVtL6ZwVCoZLhkN1kbozF3CBVx9B3CQ4FZuKH4QGKxb6NUZMaPH5DEJUjXJXUDekML/kE65oR297gvDSIyuAzFn19eOYSWNTLMPBD+nlahHAomHbvrVy8onQXbb6WqFOei2EUgUIUXejezBtDacugyds35ph5yA+1wVmsNRNNen0fBoydK5EJ/1W31NzD0N+5H9eYA+Q+VbwPhW1jnsUHpYhS33joZ2YnamH60/l3ytfYfBpeJs9On8HQ7jb1IPxEgQN07DW0DooLHazZqkNTuQJ8wVLIjefQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(39830400003)(396003)(451199015)(38350700002)(6506007)(316002)(6666004)(6486002)(2906002)(5660300002)(41300700001)(107886003)(478600001)(2616005)(6512007)(66556008)(38100700002)(4744005)(8676002)(26005)(52116002)(8936002)(66476007)(186003)(83380400001)(66946007)(36756003)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?onkXsieBun3vH2+u8y00kWUQgP1fMIpXtku5cY4Pv3lR/vK5NDBNF+rRakU+?=
 =?us-ascii?Q?pU1iyqNrhOQPT0Htm9RfAF09UNbBdi3jU9gsa5vGM7Zac1uH0GqK+9OU1cLV?=
 =?us-ascii?Q?YTe9Pm+jtbxuVAThyiuEeO5Jp9f67wv0SSkG2A/mlfZ5tZn9aIINNYleEO3R?=
 =?us-ascii?Q?3p/aZzbIJjF5H9tjjD10WsqhQcDNlc0fwfolmX28C2BNVf+rIHgjZsWPGLfQ?=
 =?us-ascii?Q?7dHLCEEP3zzIYTbxoMY5X4pMHtSlPJl81ZkMViKinSbKG/Ifkmm+G9XoNo7c?=
 =?us-ascii?Q?E65KJWFKu55jJ1CUisG8LF0xdxgNg5+Af4RbKY4m/XZD8Y40ceIt2WQOdbZ2?=
 =?us-ascii?Q?1s8mL100pgwLdXiPkucmEleeNst3BHkbMDz/7GSk643vxZIvIB4MavwYuVcs?=
 =?us-ascii?Q?k5HyQmD6K0C+HfsVKfeeSi77AVOyuvhYjY+Q3DemyIHuCvA2wYrQiVsXO4ez?=
 =?us-ascii?Q?EFXBOg2BmxrPNorDn9HJasTgEtO2RBzuYX4t7kyB75PFRCIwon8aEJceKnyx?=
 =?us-ascii?Q?gy9LcHc3vei4hWvU94uy3ZEJ8jKxt2DXKfT4L6M+44fH10n3EWx8H+BqjHXH?=
 =?us-ascii?Q?LTUlcOXsc1S+DwMwUBC98R0pgw/H70WMlOu1vmSWJ3eYG+xAE+9JUTc110qN?=
 =?us-ascii?Q?Ht9lJktjDueHBUAH5O3hPLLLIf8x4PHZL49YiVipQqIStSn9iA8G0YMy/aRt?=
 =?us-ascii?Q?KYustpDV0qIH6b8341DO8YchG1BYh2OhkNW/CTG6BSv46XKkbKn1QbEVEWO6?=
 =?us-ascii?Q?LEto1/eTNSnvpeS9eyWQWwWIAa8djVRzur6wjokv4jwrafU6GDtYIJT8MwH7?=
 =?us-ascii?Q?TNlb2Sn499uIhuOBpDRdhpufmidLvbExSvdmuxTOrKV2xqG3d3DTuhiGuE5y?=
 =?us-ascii?Q?9uEAMhjzIcejtjzZT0+R3n/emxv4B9ytdP27i/SBVq66iRNuKKmT6l1QzZrG?=
 =?us-ascii?Q?FMtg2oEw3YQWfT0uVl1XOt8FYVoPou6L/rd+HAy3AJD5+whbrP9a1YN5uWaN?=
 =?us-ascii?Q?MnlgWF50sGKM5rKrx+lVmTY6f6Z/B6wcS8Q3dWHm+rLxY/vITiarrsJzM7Y2?=
 =?us-ascii?Q?mtoxo4MRXHDJs1qEc20Mqza4I8w26KBSYi4UpZKQazBVUbTBS23QaorR3LWu?=
 =?us-ascii?Q?XsgWxbq212zOvwAcSPfjTnwp2j3qhC9vOXXWLBHyt1M1exZD0um7pWsQScP0?=
 =?us-ascii?Q?IEDgT9jbZi/mEPp2up4MAMMUu2o1Lcbj8APP66Ajaxa1YhYc76q68CFEZ45Q?=
 =?us-ascii?Q?Tj8f8aFzRSUy7j9QEEugmweMxVYIeVEILYG0svllxZdz62gnQkBDT7C7oOT5?=
 =?us-ascii?Q?ldu12M+eVD6hhG9JmZLhWPxSrqi10/I49S0fYgjXrRFM7NIfDqIZTdIwy/or?=
 =?us-ascii?Q?3w4vdsZqgbA1xzCSCchd3cQpbG0TKYsQikr570U3sHBp3ocN24H059hYs9+5?=
 =?us-ascii?Q?Z4EtEskhZE+I8ansLJR1ZMDZGfbdAKIbFpNYSN4bH1ufNJ/IDa8eNemQXaD9?=
 =?us-ascii?Q?sG5UWxzHGRmKlCFuP04FsCjXp9Z/a6q2+h+wG8h4VFWEJgC724bJz5YK53k+?=
 =?us-ascii?Q?iYstdWtn0HCQp1I7PeIQEixFo+9BsPEtnlAi9qMM?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3053b5a-3fac-4eb7-6111-08da95d618a2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:19:59.6743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZ9V+VQWrxzmuF2HYSebxkxtLo3BtYhEtcWc3AiGKhwVOSMSTumjEKEVwAe/Dci3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7159
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce client smbdirect max segment receive size to 1364 to match
protocol norms. Larger buffers are unnecessary and add significant
memory overhead.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index f81229721b76..4908ca54610c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -90,7 +90,7 @@ int smbd_max_send_size = 1364;
 int smbd_max_fragmented_recv_size = 1024 * 1024;
 
 /*  The maximum single-message size which can be received */
-int smbd_max_receive_size = 8192;
+int smbd_max_receive_size = 1364;
 
 /* The timeout to initiate send of a keepalive message on idle */
 int smbd_keep_alive_interval = 120;
-- 
2.34.1

