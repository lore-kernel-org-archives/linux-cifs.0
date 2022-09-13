Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCCEECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiIMWUF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIMWUA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:20:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B27D57226
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceoGTV3bU1NVzpAZ22Ej0ZcGCIposKbOt8rJN5DsqHRtYAWqvkjatSZxnOzx73zmeOz0yd/FulOfCKUPgkm2MYBamBcTwpQ2i+flQ4O+cgYPGhBi+HiFFCvqSKOdcU+EjTR4E02w7sQg8KKjCUuhQ6yp/ioPd1uBZvCjvlEOf1ST6gOYMmOiURMzTwe6hvA0c6aajqdeQTF0EnGrDL53ij9fP+ZxYpxscMHtRQYA6nE2E2oJl1JhnpXXvpYeoUi0bhSyr+qq3LFlbpG1BBgxnBz2pJLGyCeT+SrAgYJuoE6ODMjlqTJxScIobt1VPJ0cCULQSpHFNZdzn9SraI8VSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ta9jH0CPNAcarRyFejg98tnimrtEnVbOqrhWWQc34SM=;
 b=RwqfD8GMrjs51TfCcY48/tyE5lYwpyXasJbsj3nczC8Mx4jUxGDQGmIFHAyhGAOUo8Hy4WVvOMFflNrOxh3TinSXMI1g3TSjEt7IB532dhbDneO2wZwS5eX/D8KIEVgm+s/jWO3JbxryqsaA+PfFwdSGWTSnWCo44mQOVQ0L8foykrmh8j9WZnVJhWWRZQTuKIyCoL6Zu4PXlzxWq3mYrPOQ9KxxTzjrn69GYuwDz4kJfFoOWZp1g1XDNXt0jjdv5mMChChSDf4TEJouOMkpeMieZhXGSAo3o1XIjHdxrGNFwwpfNYw7u0MlfSvbsU2xA2MCdlhPI+nkDEW/3Uf2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 LV2PR01MB7885.prod.exchangelabs.com (2603:10b6:408:17f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 13 Sep 2022 22:19:56 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:19:56 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [PATCH 1/6] Decrease the number of SMB3 smbdirect client SGEs
Date:   Tue, 13 Sep 2022 22:19:32 +0000
Message-Id: <4a517cc3d0002983a146aad632d5dff48d8db141.1663103255.git.tom@talpey.com>
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
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|LV2PR01MB7885:EE_
X-MS-Office365-Filtering-Correlation-Id: 961938ec-ad61-4859-6792-08da95d616fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W90BKTN1NdV64P1o95Pg4CRyaNIlj5tKZmSNEMtEIX4KyJ0azTGIbCJajYIkoMAU/al7+BbNdQTHwePdwtBc1laBm/pZsO3MnTF/yaOjPrXhAvGwZde4qIi8//uTy2lT/n/qbqL280Mqlo7w9yRl9AprLD0FJZVSNwT2aBZRNbKAiUxBR+N2GsMHw1qoSVKS25PppMndqyyndMF36felstgpJcikmJ6HUHdNsS6yzDbxtn0JeQzMJIa7q4/PUyMRT+Rbx46YqhVemp2XnC+ThFuLO4czJc1ewmOtrepfE5PxJR9cH5xj7GI6ZpBhoZvepf5yE6q8EWq+lDNbaepMP0pJdaDKWX86Uw2YNGJZqVVoRI1+tol/C0pVUOiiOrGPPhrxGWu6cSkFBC6pZT1kpJn6N4jsmIeHe/WYjNmJvg6McWRhozAhLtjUaBEGPTomdHVt7Ho0Nb9FGABkYjaMlEPMzgVkxbCqfNcqpGCQkdJb+ntGzQ1N/AtXqExDR2jD284OupmKCzZGT54nlPesxOzwCIlt+FMNQlwaHB5yCphSNTSYB8A0pnMwTKNaJLnm6faRxKB/Y/zUbEMRKYTTFsjm4i1sIKRCLh4Y+LY+9ht3K/Hw+kRYpwHCejhwsiSh+0joj197YqYGLPhBtL4ahp0SkGoCpixGL/ECmSGJPNHghCSuxAiUb7Q9kFcrWpgA9wp7UBtmhSdvislzCFBE58yozm0axlG5nuNqPJn0JC2Kqjy3WQrIjED3/QO2OxQ5cnb8xyMzYUi3iTWZgBN7eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39830400003)(396003)(346002)(136003)(366004)(451199015)(83380400001)(2616005)(186003)(52116002)(38100700002)(38350700002)(5660300002)(8936002)(66556008)(4326008)(8676002)(66476007)(66946007)(2906002)(6486002)(6512007)(41300700001)(316002)(6666004)(26005)(6506007)(478600001)(107886003)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AhRpMhCzE1VRw2HQJYB3UJwpvyBh6SmQSpf+BTywyiO5o7xJ2GJ7FPoqVxmO?=
 =?us-ascii?Q?HrRZhyNnzebXVNSE/+YnRpaZnO4/hDbxK49rtm0vmggULX5GZp/G4ckE3IUu?=
 =?us-ascii?Q?+r69ljHXjtpchthjB+NoO/3y7qp/lXFO618K6uo40IJl2adktJBUKfBok1jr?=
 =?us-ascii?Q?tOPJzMgkNlfXfzJB7G347YKdMhmpFwPkWtzeMtofqzRng+8WySMJGI9D+CVT?=
 =?us-ascii?Q?A9KUsQwrD7BYyBiduFcGdPYAVk9gbzzBjAqxg278Qq2pOUCghYNoSSMPJFUr?=
 =?us-ascii?Q?+dNe2LPm1BHLsLLlPaKB6jrl0ZTVNyr/VDeDUObWYgehjUgJdQ1H+DG88czk?=
 =?us-ascii?Q?o5ePNb562OhX2YoJT/QTzuO/lb1wOaa2W0to9IBFHJvi8tvT4pDeIsqEkl9v?=
 =?us-ascii?Q?mGbs0WmN3bAN5BurI6nirrdFgN8878T6/IryjLVbGnt+zDiR2gbk5tGrJvxi?=
 =?us-ascii?Q?34O25RWTeOif1FdywHjc/E6yM/fYCkRcgs0r4UJaQoKJQZ20YhLTvXz6/7d9?=
 =?us-ascii?Q?XOacqDNDbabWkfKNd/9WaswqADcTffonGsam4uA2fBVXkM3EmgVpihK5mP5w?=
 =?us-ascii?Q?2sCUCxbXkKTBfdFXxEwPfx67xpJ1oDuVOxzI4PzrxVI7w7XxLxFYb03ZeZmf?=
 =?us-ascii?Q?WKEf6tJAGn+p2KWY5bgMhI09WEWyyWYrBKy328JDxTmmAKG1dbN7NO3lltdN?=
 =?us-ascii?Q?/pZfRUbNmuQz3uKk7JG874nW0Jx9eaGImDv0wGkPOhSi2SzW9j/1Ox74sITt?=
 =?us-ascii?Q?MuBPduYyhOkm4gxBrzDSHSqkkIudGORXoUlfoSKz2D58RCyzGg4G2LjHW7KB?=
 =?us-ascii?Q?hBoZRVi4mI8Pr83GTZjNCShoG1uxUGM0cJwXnwVTbhRwK9m5mV07c1/BysBx?=
 =?us-ascii?Q?9dTKqXtIc7U4Fs53oXBsIoJeo8K79FA2RKyLWQYcR8iP1ESR2Ku8E8YDruJr?=
 =?us-ascii?Q?EYJH+3GvNk6KD9AvXW9gkRsQZeq2gVfr4iXkFiph+5N6iuSbGLm18ntSDHBe?=
 =?us-ascii?Q?LECzZse3iUoj1O68IYREty8UHvSDsUlFGIhJpHNaYFA4rCDwwNcUgCZXvet+?=
 =?us-ascii?Q?GwSMuNVXxvDI0lYT4lr7AqtnH7emTR0F4oQPIWDDdWs0mEHoC5GlEuQ/e8od?=
 =?us-ascii?Q?KIynJvKyYlLtpMsiF8mrXYROho4LsLp3L1n8ULC0dnAlrCwRHqIh4gaTPdhV?=
 =?us-ascii?Q?66jZnSKXqdwqIPZSRaMI/Z1fKf/N45HkI/7tv3Ez+df+fugq8KjecxfB0iLb?=
 =?us-ascii?Q?tBgKOEri7RLLrkA1mqVmsh+ogrvQP7szfRLXbwxznitMEps5qjTG1fmoIKMI?=
 =?us-ascii?Q?Twr+AZNLgSqi6QycNegukVTtvOuVSoFrF886tRzFrmB73F41Ors0gvTpRdS5?=
 =?us-ascii?Q?qKaVCFRJFQc5h3/d7GrchvcnuIv2wvM0Aq/eKMbHbEk8Ptfus0YTlozBcxC4?=
 =?us-ascii?Q?S0Yh3jlrOr8ojmez0kb0GbJgacjWNx6D+FLCNzhAIxpVIreTLhDPnpE1sg6G?=
 =?us-ascii?Q?lj+HKMMB/LeuLqm3t0WsLxawWmniryn873LjseqG+kIkyknoBUuDCDfVXKcu?=
 =?us-ascii?Q?2tB8gd/LTHH7HdyleunPKn0u45vIoiVkL+7x9yT/?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961938ec-ad61-4859-6792-08da95d616fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:19:56.8464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riCx8YlGIzquONLFV/qUDLT51HteTDeoOSCIvEHAHqrGb0NOMcYHTYJsO4ZujApH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7885
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The client-side SMBDirect layer requires no more than 6 send SGEs
and 1 receive SGE. The previous default of 8 send and 8 receive
causes smbdirect to fail on the SoftiWARP (siw) provider, and
possibly others. Additionally, large numbers of SGEs reduces
performance significantly on adapter implementations.

Also correct the frmr page count comment (not an SGE count).

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/cifs/smbdirect.c | 26 ++++++++++++--------------
 fs/cifs/smbdirect.h | 14 +++++++++-----
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fbbec22bcc8..f81229721b76 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -99,7 +99,7 @@ int smbd_keep_alive_interval = 120;
  * User configurable initial values for RDMA transport
  * The actual values used may be lower and are limited to hardware capabilities
  */
-/* Default maximum number of SGEs in a RDMA write/read */
+/* Default maximum number of pages in a single RDMA write/read */
 int smbd_max_frmr_depth = 2048;
 
 /* If payload is less than this byte, use RDMA send/recv not read/write */
@@ -1017,9 +1017,9 @@ static int smbd_post_send_data(
 {
 	int i;
 	u32 data_length = 0;
-	struct scatterlist sgl[SMBDIRECT_MAX_SGE];
+	struct scatterlist sgl[SMBDIRECT_MAX_SEND_SGE - 1];
 
-	if (n_vec > SMBDIRECT_MAX_SGE) {
+	if (n_vec > SMBDIRECT_MAX_SEND_SGE - 1) {
 		cifs_dbg(VFS, "Can't fit data to SGL, n_vec=%d\n", n_vec);
 		return -EINVAL;
 	}
@@ -1562,17 +1562,15 @@ static struct smbd_connection *_smbd_get_connection(
 	info->max_receive_size = smbd_max_receive_size;
 	info->keep_alive_interval = smbd_keep_alive_interval;
 
-	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
+	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SEND_SGE ||
+	    info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_RECV_SGE) {
 		log_rdma_event(ERR,
-			"warning: device max_send_sge = %d too small\n",
-			info->id->device->attrs.max_send_sge);
-		log_rdma_event(ERR, "Queue Pair creation may fail\n");
-	}
-	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
-		log_rdma_event(ERR,
-			"warning: device max_recv_sge = %d too small\n",
+			"device %.*s max_send_sge/max_recv_sge = %d/%d too small\n",
+			IB_DEVICE_NAME_MAX,
+			info->id->device->name,
+			info->id->device->attrs.max_send_sge,
 			info->id->device->attrs.max_recv_sge);
-		log_rdma_event(ERR, "Queue Pair creation may fail\n");
+		goto config_failed;
 	}
 
 	info->send_cq = NULL;
@@ -1598,8 +1596,8 @@ static struct smbd_connection *_smbd_get_connection(
 	qp_attr.qp_context = info;
 	qp_attr.cap.max_send_wr = info->send_credit_target;
 	qp_attr.cap.max_recv_wr = info->receive_credit_max;
-	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
-	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
+	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SEND_SGE;
+	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_RECV_SGE;
 	qp_attr.cap.max_inline_data = 0;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a87fca82a796..207ef979cd51 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -91,7 +91,7 @@ struct smbd_connection {
 	/* Memory registrations */
 	/* Maximum number of RDMA read/write outstanding on this connection */
 	int responder_resources;
-	/* Maximum number of SGEs in a RDMA write/read */
+	/* Maximum number of pages in a single RDMA write/read on this connection */
 	int max_frmr_depth;
 	/*
 	 * If payload is less than or equal to the threshold,
@@ -225,21 +225,25 @@ struct smbd_buffer_descriptor_v1 {
 	__le32 length;
 } __packed;
 
-/* Default maximum number of SGEs in a RDMA send/recv */
-#define SMBDIRECT_MAX_SGE	16
+/* Maximum number of SGEs used by smbdirect.c in any send work request */
+#define SMBDIRECT_MAX_SEND_SGE	6
+
 /* The context for a SMBD request */
 struct smbd_request {
 	struct smbd_connection *info;
 	struct ib_cqe cqe;
 
-	/* the SGE entries for this packet */
-	struct ib_sge sge[SMBDIRECT_MAX_SGE];
+	/* the SGE entries for this work request */
+	struct ib_sge sge[SMBDIRECT_MAX_SEND_SGE];
 	int num_sge;
 
 	/* SMBD packet header follows this structure */
 	u8 packet[];
 };
 
+/* Maximum number of SGEs used by smbdirect.c in any receive work request */
+#define SMBDIRECT_MAX_RECV_SGE	1
+
 /* The context for a SMBD response */
 struct smbd_response {
 	struct smbd_connection *info;
-- 
2.34.1

