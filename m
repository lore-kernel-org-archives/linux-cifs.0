Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEBBC6FA83
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiIWVym (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVyk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962BFFD2B
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSVtDYPGnA7LsHxC74MKd3JGEXGxU9sUjW9I4+T04bZNeGh9O9xli88IxxKjDNcuHg10E7mEkz+uyaHyGMX1KKf6xYWRUMg7kvquN4IGyQHYDTLPXxterKBDjA5OdimVQ5cjMcBY9CGsgY57DcDXDsj5eXRHGEpKAvfq5v/TttdrKNyuiLtk1L+4JOEKSw+41DxQZPM4K2vvx8mMBWJ1/15RC4GNtG17VCxSPMM67d7q00nseC2Sv7AD44XjZooX2pV5NW4MQz1yFz3iVr6aLc9utZmNa0O8pvGV3w47PQS2rTPryTpRCvNt9maVQERcAoNPX0zYg2IDDX8S66uwKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfZdJeW/hOyqzyBMa7dqBWBQC0UrIykEQL/VXl4PhC4=;
 b=WfENheIm0gc9vmTsRIrTfrnb8aYL8E/X00mDzIupo5v9auCLqkM51zfmViM7iD4KKUY1lZdBzRftwpZmxdpEJjtovw9xJx+hZcTZ6WofO0zigBmGmhk0W+lOAzRrSSDcvC91ZTPAgfbOMAc4VvUrx5HRJZU4bAn385IuVRr0GARWn2bw2QQgxa7LhDLe5ZJS2Nn2dOfG1d+ahi3Yur5z77oN5GeHd34lBoGR0tEJZwVY3bQrm5Kkbz+ZsaN4c5YOda1edYCdlCVnyDCFsCnYnPxmSI5cJtlHXTt6oqPAnPsFwqAuRPGNGOclG6tYZa/D96CAnI+x+hEvDkxVVfCsCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:31 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:31 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 2/6] Decrease the number of SMB3 smbdirect server SGEs
Date:   Fri, 23 Sep 2022 21:53:56 +0000
Message-Id: <c16ac0947a26d94ff084512b305bd525c93f6bec.1663961449.git.tom@talpey.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BL1PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::19) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MW2PR0102MB3481:EE_
X-MS-Office365-Filtering-Correlation-Id: 9842eab6-dfd6-40fb-9fb9-08da9dae2eac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VEUsiNetdFKijnfbCuAYlyeGA0MXBcSlaOMJfa6eRgVy35jD/0DRTBBOcpThDbq52xAWWT+g5m0Icb0VfmwIDMUliHzq9LnPyHhwvmhq09NfRVxSlQjM/iYkluvojYWbOk4nrCcqgPgi64lTxQbscXCfn5If+g6FqJD94bEF4B08S/1oAKZzEFXXCUd8OqnKbgGSQ9huJA4Whv7t6Ekpqvt38Bm8n7+YrDDjcDtAu7/xk0eiRUpuLWtw6ag6G/a89nta+3VJG8O9HVXSVXR+o/z6M8MjPkzrPHf+DsTQSxDNamLb6U56BbqMhR5VcPVPplnDOQnl7WGgOPycQ7odAaDbfjTd3zpaoaw5YQPElzS2gmF77DkCNQPbgiHAhvjn9bcXJKMQRM1EKa3tQ+isIX4iICyRl2bQyX1ZfFt6ZxtsoVi7aqumqUWTwuCF62IX7JohA05DW73jpTF5K4Gp7KsgWt7PPSdIibmDYpC67u3OHGx5NuVChy9IiI9dM5cd3QXLHSkZvZHEt0xKgPl2ljD/RLbvwGbw7BqCB09JI6ytSxTuLzXFLRYADBk+V+XHXXXfA3T38OuYNVE0IEnh7EEL3xhWX0tXs29RShtNTg+JnA1sWDV/8tFrRMs5t/VWZsFQL21O+vgtOezLnBQksrJV5uBE7bZYr1IMjrGbHc+FSzdM1p1q0HogI65+OT56rOSCRfoTbfSAN++0SOREcL/5hjvDCGWQPB0NJS8OpuZVqEuInAzJVmc54pS+TZg9eD4sF7MmM6Bt8mgANaMIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(4744005)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nmKPwutFaNt+qT4maDdvAp8mtqg75YS3wsfyEqtg7XxzaTwXBQ1DhqTebN1P?=
 =?us-ascii?Q?m6VeGfcXlcs+mPzaIVRF3X5kjIk0h0V7bX9Y+8Pd9od3xIfe4syNmxuDMzmi?=
 =?us-ascii?Q?bjB0HGh0Vdhe+UdTzGRR+xBubk/sQ7SnhIu3U3IpWV8lVXhprg36xBlKBM3F?=
 =?us-ascii?Q?/8visWdlIIO56E7cEpQx9MIWUmY8VFev/FTul8crBWlyF/tA2kQ3ZHFbcmJE?=
 =?us-ascii?Q?W+SdUVHdRApMQnwQUo4Gr42yU33K70DgqLPzNleOl8l/skk8I21VPqZ4TIMO?=
 =?us-ascii?Q?93AmbDSVFLSMSGIJ2trkUjMvrp4793KVwVaJheWlh5aPA+/i5Vr/BA0hLhFL?=
 =?us-ascii?Q?DwgY2JkkQ4EBzp5B5VNXFdwIAPyGpGqExsX3+Re5WMg7PGn+KOcPV0pWdiJZ?=
 =?us-ascii?Q?ghiNFjTnoA8Xnty9gXquU6CjgWOEa7B/4FXnsgfHESOiUPCQvXuq0TyzyNZf?=
 =?us-ascii?Q?DbTVW53feYUctuuDajhdGf6YUCFBYajt3pv+REIHMBPVZ9IbKNnj3/VkgLm/?=
 =?us-ascii?Q?YmMSRI/OXBEouMqlboZYf8oj6mo1XqHXeyZe21paPGnmxJzRE2ZMB50VAr36?=
 =?us-ascii?Q?riViLWF8IpRML1gCO5LyaPjdI9j7MEmYQ+akcAPVWUEzNjIEAuS81Nm9flPN?=
 =?us-ascii?Q?l+5aFLPcnMn7f5Q/0igrNU96X0QaCQ0Zd8xv6i1hxNpoh/90xduYU4y5iVBk?=
 =?us-ascii?Q?VtULK1FKHzq0frDWZUXsYwOf3ZZy1rlxUxWgXalIMeMqmr4QR+IJEQldc47F?=
 =?us-ascii?Q?v3Vpj2ue1OCJaVMNYrfZkMWlY+W5s8Cdr2qB3HyBw1CtHIQzXvUQ9PTrkEWG?=
 =?us-ascii?Q?GUg4kDJIwM4AHMNLz6r7fGurMfH+KjxeFzClxExmyRdKCgZeU59gezMH0AY1?=
 =?us-ascii?Q?i8zQBvk+Pe70Q/qtUryrauhJ0Zbl1NLhhd0d/eMm9vhuHZfTrbeDqwSyeASR?=
 =?us-ascii?Q?Y+XCe0kRZO6ZleCTgiwKZRUmB6SD5coTgUMd6NddLbfqN9W7D6tA8OtLizPu?=
 =?us-ascii?Q?WHZM8xhjpKMbMUQnYGRWqJsLsvR/h3N6cRb6mhF3Fo4/kqN5nRa/jZbSVd42?=
 =?us-ascii?Q?hR2t6+ZMLsBa2qUcS/Xk4hOTA3Amo1IjhWkGvj8hPu/jHxE0p/5dNgh5a1ei?=
 =?us-ascii?Q?wMlUbWFka+PlWZv2jCk1oNrvGOE8JkxkSaisGY55BMr94jEUqvDOIe+F8eqZ?=
 =?us-ascii?Q?rDOsVNfi/p8bRdqLEq/aXm31MM5RnxBSCfWQnxERJIevYGJ5AN7y1Ks85BiC?=
 =?us-ascii?Q?+Rok1ZUFv3Mt8Ujxe3uWU1D9cGALbkuIPP/nIydjl8IxuO+oASH44lSQGII3?=
 =?us-ascii?Q?naijmSLMgc3iUR9bRV+oJfpXu5dwGHiLuWWWIYIs761qQ/IdCRok+zBV2wd+?=
 =?us-ascii?Q?s7ixMYGhefeEDHmfieApTzeYGR+QuUT6uK89gU3FFFJSqdERyMOgyhYDY+SE?=
 =?us-ascii?Q?paY4drV57PEtsyblC7qPITPiFTPJdMhyVbswaBYFvS1lrd4qFetnTpibjDRp?=
 =?us-ascii?Q?I4oRX/FrZ4mwvO+aAPpoCjmWgcTbm1gyWgQptb84x0Pb8azpon1ghVFnUWsb?=
 =?us-ascii?Q?u7JVHA0WNw1esudCInOaXfqrwezmzNHoSpn8YH2D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9842eab6-dfd6-40fb-9fb9-08da9dae2eac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:26.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLqRffA0ANS9ZayOboQIOnw4gtTIDpkzrPphmCUFtQIqA6ZpRWeJN5SWZwCu+7IO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The server-side SMBDirect layer requires no more than 6 send SGEs
The previous default of 8 causes ksmbd to fail on the SoftiWARP
(siw) provider, and possibly others. Additionally, large numbers
of SGEs reduces performance significantly on adapter implementations.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/ksmbd/transport_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 35b55ee94fe5..494b8e5af4b3 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -32,7 +32,7 @@
 /* SMB_DIRECT negotiation timeout in seconds */
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT		120
 
-#define SMB_DIRECT_MAX_SEND_SGES		8
+#define SMB_DIRECT_MAX_SEND_SGES		6
 #define SMB_DIRECT_MAX_RECV_SGES		1
 
 /*
-- 
2.34.1

