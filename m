Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FB8C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIMWUH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIMWUC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:20:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8046746D
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXondhj2h+wNayxK8IjgyDCDdnQDqvNKsHMrYOzrUVN4bm+0EJB1FJLzpDx/0FgVoM3NfHJuONlXOFh/ACcY9BDV3GyfAPuM+mJ3CNc5VQTtoN0Xi53Y9xihlM0S/U28S33A5bksnQhY2jRgWlxnQ/jLqgPYfast9B9twQidtxp6I2s6n8yeV38pg7xJ1KxtCfcdWQ7HnxAw65kBdTR1mfhml/pHnrqlar8Xl2wUgrnWFjqTFU/FUX9Ly4iEbuHrl9Fe7y29oXM+biTZv3WSv/IoLaIg9fijfmfxP6Hz7IERV8SgW9OPWAcayH64IkM/6lE5J+MzwhRtJL2iYFyboQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfZdJeW/hOyqzyBMa7dqBWBQC0UrIykEQL/VXl4PhC4=;
 b=RmlvRxiPpup8FHGHrf7xLENFWMSO+Q1ySquMOxNEX4IT3Q9AtaG2xaZdkwRTTM+ISixn72POD0U+qALUacmOijQyKICKwtjStoeepAB75MxaPWcSchosgkW6jvOEPc/mn43Cbngf41pgfwh/efBh3V+78UC83m+82pDHPTO4o+MefO9D/Nw8FIvPidiwa6n0+R0pd8PmO5YxmFST4jm/wA9Cjpf4LVwh1FVmQUpVyo5+QuHndpmrMAjfdfej19QOOtpNcsWnLhn8E5ufd3yGdPN1qDVO2ZKMQ9sayAjkvM4PE/HP1LxBcVpTlmYqwRcGB3j02B4IT6cvaQc8LddAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4573.prod.exchangelabs.com (2603:10b6:805:eb::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.16; Tue, 13 Sep 2022 22:19:58 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:19:58 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [PATCH 2/6] Decrease the number of SMB3 smbdirect server SGEs
Date:   Tue, 13 Sep 2022 22:19:33 +0000
Message-Id: <241c910b1313cac9ad15f7fb7b5d87a6c40c0c0b.1663103255.git.tom@talpey.com>
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
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b12b9dd-0bca-40f0-a9ec-08da95d617c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrDyNbftXn07CdelTXvq+aORwY8Vclm8dJgOF8NDzijHVCaWwxWeztwz3cTBGzgV7m+cPMhDt8+KNA4YH3ZTiBXrZ8q4lmO8GIjIo8xA9jUg6eKCFS0fCUYdyyRFEur+3rlfsy7Ko7KSjG8HTHEKn+ilS8SBB/DTLoN6vKaeEkdl5IqHP4ABIinHPSoYqaNIGSHnEjuTWeG3Tpsx/QD6mA8t4Am5i/018Od6kC1krr4JrEItR4sEYJMf9MChrQGdZ1Gr9BHoyEgy36oiRPiudW4a0y9railuDVuuuY5XjphPgPffugSuYoGd8ue1rmzdqKVatOK+GrRMBN9fnLXGd52C6HL9oc5Pyhyp+Ch/Lccusa0loN4yI1W60hCERIKU2VuQZ+CSiCVoW7LEI8K0ZBe24sKOcPAZ4J5h2k8dHkb60+UcqBBehm+j3HqEUTsdNakSX4qcqZIL8E8toDBw1I+kKzdRPQw6A7vPjj2+LyIfHCfLIahEu1wyqYjMHSwX+eaWzuf4sckDUKB0817XAv9IDQTDW7MdqLIm96U6uysNMx4JuwcG444NQ7Ht+7O+mrLFgIXkGO93WYeE9kg9R2HnM9ttWnjQFeYpF/e7Gvlu7ndjxYx358A7gkEgHwCjvWwnFdY+rYAMn93Br3Q5HIwd9kmbMHywDkTGBegW2+VwDpmMOJN4j7YUC0e4qpf48Lx73QRqpbKWrF3uAxT5t1Ew7pKCIPvZFdpsH1J1EGvdDt2OGEMdy6yKVS9hNHRDhAGJ87IsmU87gXH4CfPb5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(396003)(39830400003)(451199015)(38350700002)(107886003)(6486002)(8676002)(8936002)(6666004)(4744005)(41300700001)(66556008)(6512007)(66476007)(2616005)(186003)(2906002)(52116002)(478600001)(86362001)(6506007)(5660300002)(36756003)(26005)(4326008)(38100700002)(66946007)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9gPcMDOnA50jUptzIjIZ+w+lFro7b5/GXDNi4iVjA/gjoVy9ftDf+o8YJiBy?=
 =?us-ascii?Q?iYtcptEZPXahkOUfo12fG5N9thXyhOEMdpXShDCfGdKRP/c3yW2GDAqG3u2X?=
 =?us-ascii?Q?/HqZ6K0VhWOw0eeIsdBVkfBvU+thp0BqLY8MB5IQ+huofKZOdVh0lbSEedbj?=
 =?us-ascii?Q?Kl0H3unUeqLuesjT+/7h3HD+xZSZE1CZPDQtskk/4DPETNlRBPDUElFypB6H?=
 =?us-ascii?Q?9jQ3km46rWopYT255UOXi7Fqnm14EDAn8S/QcCCBti2fJoKiHqZ8V2pEEkUl?=
 =?us-ascii?Q?jltC/AYhxXQzYn1QqJl6pAzwxw7CtDnTewGE8lGeXDDr4zdVGxdL0FPbvBsU?=
 =?us-ascii?Q?i3g7nef45XupzXf2lmvJfE/0lN+7oz3oC+lxrRlK+ZN5kXD/QoRz3d4PZeCx?=
 =?us-ascii?Q?kKCjZZQfRlRDyIMe66duhbOso2eXiLlHL+2OcnBmOMPJSM9ELbgkoXW7mKYq?=
 =?us-ascii?Q?1BIMpY21nCUbOWa1YTZLIRbcqy2WnZ0otOWH72RdiYIuok9zQqqYE0s+tBAd?=
 =?us-ascii?Q?1qXYgr3Cm3I285XvCAkVbctnotf0RACMvjSBvThf4+hh+x8fTcWys+LR4IvA?=
 =?us-ascii?Q?nW1/lTso6QuXlclgyuAa43zwln4Ph5i4VAHHTdCY8CjWkCShKcaVpE3TRk+G?=
 =?us-ascii?Q?l4K7D4Dlkb1KFTkLzNkhRBMS4Veve85WhViRNB65i0foXQ2f+k1F+anLNEvs?=
 =?us-ascii?Q?l+GsCNvT+n9G4FFyuYkK5AsISLq38nmRcOpN09RIeNgDsDByD0eZAvn33tBW?=
 =?us-ascii?Q?Lr8B82b9U6YdijE/e2vJdpUauH0y3e/XtpK5JTEIJvnq8YWAxHybA9cQ5U1A?=
 =?us-ascii?Q?DruFXl3GmVZQncmUiD7hO3cQcHfsQ/sBB9AX9QJYtKyhPrXurct8HehnG91t?=
 =?us-ascii?Q?aGvSXEMjz71T3gpxrgtpW2j2xLrko4+5xlsnVOwB9iVZVrwUTWJJlpe0+sn4?=
 =?us-ascii?Q?OgwUHY6eby8320nAfKzmIl08DsAYwJ7kg4eoIve/wpsG8VzGbZydlzi3t29j?=
 =?us-ascii?Q?Q515NAer27J5W7TFTzey2/Ndij+vKTs6frecosdkiMjRQtGosefckHswAGmL?=
 =?us-ascii?Q?dOnkxwSWK0mq5/hOB9FOjzxwDzp7HfqzxHsvCrTG+eC4y4+U8mIqK0UD1bHD?=
 =?us-ascii?Q?XvhiFsbw2oxfnj3GJpN43VVVm5Amv5CDFfjEINdF7C3i6vZ94FLjeD8Ig5+t?=
 =?us-ascii?Q?PKkWJOg152n0MKBMBIs9txC8419QVNpbXM5YwTK2LXsxfbSZbqz3PnIfS4S6?=
 =?us-ascii?Q?A9GcOTYwNa4741wBokblSIzEew5hJMJKRvU8m0IZBOWzrQS3bQiyQPF0MA6w?=
 =?us-ascii?Q?lQ2cVLyCB5poTHOKeC4BOK4yRv+48PbFIXodTjlsYxlDNpLtxFuyqWR2MwfS?=
 =?us-ascii?Q?A3dr5UdQoy7AN0slzeeDLJWjlqxb2ferhF0Kar0G4cTO8TvBm4CUFNDryDCo?=
 =?us-ascii?Q?2hfdlSJCtn6ouhe0D3Qx7+Twl6lIcSvm1nzvB2Jxip4io9uhl1BnedEPHtdm?=
 =?us-ascii?Q?ovBFUDtT9HpO3X09e751be7g5J6jQeXer6UTGVqMDYKOaPiVNimAS0trGOrl?=
 =?us-ascii?Q?d8lM9fOWH6qT2AImoPI9DjcnHIrHaeI4TrFJRboP?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b12b9dd-0bca-40f0-a9ec-08da95d617c4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:19:58.2682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZI9JAx7tj99ccOgPvD/lbcD5JpWb8XnBGXi+AuauLmwV0JajfJ+XtFsOo0wAZ5Yx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4573
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

