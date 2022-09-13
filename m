Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FDEC6FA8B
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiIMWUK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIMWUH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:20:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5FB6555F
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVPuXD6HdQj1/z+jBNcYln4KqVo5WIalC7mP1z+rITYxZ/V1FZbjCQKBgTZhWChWym+2Me4oMX8/Xg7L6/8UDngR/XBfrZMCJOBHRWtJoPHv1zP8xGRyz/wCUZr8zyd4msJgUA3aLu4nu+mtIrfGltObBESkOHAsCGv0kni7hjjUGS1EkPO1Q2O7qdvpH7GBfbYLtWEK5olIP5EtzEEMxBm7ME0H5yftxHONgrsDplLZZLx5OfZsT/qExaVFiKtMo6+SHnwNf7h3NKqLm/NnJWiB9cOb3hXv45TIFeRAOBkSmaR3koSmsyueqWYtr/QSPkVuRujZBGs1q7AjESkR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JszQGaIXBL/RB/UWJeLBk7jYn48snALr94pz+lwGG/8=;
 b=GbyP7g17irVILvIbCmaIK9PbVJpY658lyj9FK8M55UHXJIfOY1AuYyePlDi+BRxGBBEiw+aCO4JNv+CTHGPHEgnez15zVidXoXpRyLS23AZyiiev5g1n4TnB+Ctd4IxY9qkklOVihM69dkFnhzgAcAcIukK8ev/+385fx2tEWBACuOp8QhJ6zF4M/tj9FNNSU0kpgaRUc+l4E6PMrUrT84dvk3eO7//gWKCzrIWWsEkV0ss+5liBdm59mnbyOlheRbN9Nbl0Xc1LNhkSIpzZqvUc7SsEXOnZdIoUkPMeAAvXc0Q4rVHckjZUJ3/l/6MoOJl68JnJTJzmF/f74KJesA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR0102MB3378.prod.exchangelabs.com (2603:10b6:207:19::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 13 Sep 2022 22:20:05 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:20:05 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [PATCH 6/6] Fix formatting of client smbdirect RDMA logging
Date:   Tue, 13 Sep 2022 22:19:37 +0000
Message-Id: <663860530f19f4ac5c72ca0fdc2bc743751b531b.1663103255.git.tom@talpey.com>
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
X-MS-Office365-Filtering-Correlation-Id: 74e1e1ae-4d5d-4510-a001-08da95d61c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grfMC6LxdRGg/5D4l+eOaHMBqj7dkFPLJ8nwW95eIMHZClFPngWmC0iTRuC9T1Oou/b9AvbJe1UvKpe/J4Annqu/JxxcTDJBjcDJme7pUtZgac9yZRopnbhxpgBwR3aMF6XcjnZuomFVVwQxktP3rWPbTJJ7Al8dzERAeJcmhX2BFNfrltXdGo7F/QWZ9Bo7axEpIrSS5kdnqN0wXaiqzNjG8SS7zUBM72hEOFl33G+jug17mySBWyhG30cpiVedNu0hhlWhfAtHvUpqSezYY9cvECwP+IDVewmpEVABCDf7O27Wo33HDrY6kCcQ1c1JyUahB5072Xh3bCr0DgJB5OAf9YLmiXTStDAWOK+MG0kt8EXLPnTbnbsPpdC+kDWo6CD0KodR7QDFrYiEUhrhFJLwJkCcenRFfr1DJ8hFAxmDj9h/imHglkKEXq8Z4829OuAhmK9QfQBS1Quj2YMVktg4HSTVMMTxxtLB4Qu5FSEvwjM4gMS32G7r1sXKsIWcpkhhoqlCG7AYYgoGfQNiIa8+jzVUHA/cPhLVKGvbGx2FJW29xA5bGkHMBiwUOUezbRR9f3sHdT8zqynPUxYok1AvUinoQK+CNHY0KipiMdsQ0B4PZrGeZoKW0A1ZfrArjhnhWx6jcO9iV7T4j3A8ViSGIeo4tjD2m9eUiGroQo8Ou+9N6MfrqsdCP1vHbp07qdB/6ufOZ/OtVuvDiKImsbyJHiVsW6wNgAKH3iaAKIp30+CO7nPK110ww5gRr1G8uBFRuj/WHvwdC+b7UcCkqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(39830400003)(366004)(451199015)(5660300002)(8936002)(2906002)(36756003)(4326008)(66476007)(66556008)(66946007)(316002)(52116002)(478600001)(41300700001)(6506007)(6486002)(6666004)(107886003)(26005)(38100700002)(86362001)(2616005)(186003)(8676002)(83380400001)(6512007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rZJukJoyONyATG9j7rChLHhMCEKPYDTpw3nrGE2hvq/OWw578Qb/W+nk9TFP?=
 =?us-ascii?Q?SDEeJLeOY7JI/PEToL9ebKWA0y83Mt7LzFBcdrqQyQSCrTPMz5fBpHpfjOuO?=
 =?us-ascii?Q?0ag6DBMfiPsNxsFUaGUebWxFyo2qsJ2pBZ1/EYLsYV3fxleTnu8H2F+C3VMU?=
 =?us-ascii?Q?LCrvXUFT/IflJjZbZf1J9zN3kCcLXDgMg5CrEs4izki+gQccChHgNyakG1bP?=
 =?us-ascii?Q?ij6yDA4TU7/CteCwAAzBCrPNzT6cU8IeEAAR1r8LSpgD12G3z66OCbmI5Kew?=
 =?us-ascii?Q?GeNIRjQnveIIvolpQ4J5pc7320QkLKXgsbeuvzY79IG7LtnAa9Ac+PPG4KTy?=
 =?us-ascii?Q?v2cBkrOi4X4K+frPV7rP8rWWrZicNov9DyLKdZfOtmF7fU4ve/qlRBveIiGI?=
 =?us-ascii?Q?m5MiiXwEvUDKC30eUJcXS/FeJLHwJvSnumoku5fMhM9c2x3GkRfY2GAEd3XZ?=
 =?us-ascii?Q?cqBDtZEloYTJ5NAD706gCI+qRtwqbwIP8ez7yohhcwbRshV/iRSl+FaFEfRP?=
 =?us-ascii?Q?0gi/bZvzt6Xa5n/BZgDGBIvVxJlaAJUHrm9t4ej34YCuo+vPfL4uZAy8IQEJ?=
 =?us-ascii?Q?+isMJBwT7WBBHqWWMuKQfBPRKK8v18Z3CeG3OBZ/Ir/x64qn6b6gyLgk7BRx?=
 =?us-ascii?Q?D1I+wS9UN9D/kKsLXJ0HuEKK8hsZedtiAuYZzDqpCdNsJ4RG2lc0v0uJRqvW?=
 =?us-ascii?Q?LPEZRDXK1l/eJgS2OJhudc6sLhmDvka9eWmoO8cmhHAF8e/6oCH1CAGSrjIM?=
 =?us-ascii?Q?1rPOkZ2WCP176M3DrR8DpZzxET54+/DHoS8Z5+4Yvpu8MBv/h+qh154z4dsc?=
 =?us-ascii?Q?BzKKevEbttYYtRYQW3maEirHlQ5ZjLg3DhU220cbvovd7MLPwAqkHpJtz5B4?=
 =?us-ascii?Q?tRRbAacm7OILhhOhdPBL30/In7U3dXcbwLavV60iCn5G5Lf/h2uwCdNzAK/M?=
 =?us-ascii?Q?mWvGZZljNY6NwYmG91RXLzr+f1XEBh0CskU8oIKErpR/wGFMFa+0hQsWyzLP?=
 =?us-ascii?Q?LbknWpXvia15pmjdt7HeVDYwdlYU1DJwOKgU/TsrRGPZNRzdVXknE9qNM2q5?=
 =?us-ascii?Q?6LNoh4ZK3yAvlyJSAT9AxJnjW1lbI4LWdaeS7Qo+2FZ+VS0Dn+uE7L31qBtb?=
 =?us-ascii?Q?Y1Iwq64+XHKYGa+RPtL5TISvLLeASDz8Kadj06J1Hjd4xUufyYaNVZ0ZqdcE?=
 =?us-ascii?Q?ezx05UQjA9sV2cDbDKRnWgZbGOC9P6nsvxDJcNNre05DXEgMNE6qnIj9HaTy?=
 =?us-ascii?Q?bnoea/5xyqgUhB2m2bUMzgK6g3P4aH9yZxufjrowSL/w7SkRT+pWZvbNImSx?=
 =?us-ascii?Q?4B2tWdU001uIX+9zY9IHFY3HD4sMONuweOulDM0fyqpCOjq9KboU1jYr3qj1?=
 =?us-ascii?Q?GnurGoaHb0URebGwhmXEr/KliV7u6t+9DRZT8kHFOr6mo94+2Mbvsh7ru3tI?=
 =?us-ascii?Q?uLtv2XoFrtcGPR3bb0qDM9Wy/5OOi3klK+9tZbVf4B00+piZvlYcfXcVItfE?=
 =?us-ascii?Q?xJyZZk5PZj5ywNp6VDRRrfU4UsGTQ+nxpS551z0IMd8Kga69vJHGdNoNvPtw?=
 =?us-ascii?Q?nsQ6EphhJoVjom7PIp1vF5IHy2FTDl0rvg6ULKjC?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e1e1ae-4d5d-4510-a001-08da95d61c1b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:20:05.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrJztfBgW4toRIBK1Y4zhKx/QrWSS8kwMdnu+oH+pbw4hvPsb2rgyTdTUI7529Ng
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR0102MB3378
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make the debug logging more consistent in formatting of addresses,
lengths, and bitfields.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/cifs/smbdirect.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 494ac916158f..4491c4a10bfc 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -270,7 +270,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_request *request =
 		container_of(wc->wr_cqe, struct smbd_request, cqe);
 
-	log_rdma_send(INFO, "smbd_request %p completed wc->status=%d\n",
+	log_rdma_send(INFO, "smbd_request 0x%p completed wc->status=%d\n",
 		request, wc->status);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
@@ -448,7 +448,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_connection *info = response->info;
 	int data_length = 0;
 
-	log_rdma_recv(INFO, "response=%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%x\n",
+	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
 		      response, response->type, wc->status, wc->opcode,
 		      wc->byte_len, wc->pkey_index);
 
@@ -723,7 +723,7 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 	send_wr.opcode = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
-	log_rdma_send(INFO, "sge addr=%llx length=%x lkey=%x\n",
+	log_rdma_send(INFO, "sge addr=0x%llx length=%u lkey=0x%x\n",
 		request->sge[0].addr,
 		request->sge[0].length, request->sge[0].lkey);
 
@@ -792,7 +792,7 @@ static int smbd_post_send(struct smbd_connection *info,
 
 	for (i = 0; i < request->num_sge; i++) {
 		log_rdma_send(INFO,
-			"rdma_request sge[%d] addr=%llu length=%u\n",
+			"rdma_request sge[%d] addr=0x%llx length=%u\n",
 			i, request->sge[i].addr, request->sge[i].length);
 		ib_dma_sync_single_for_device(
 			info->id->device,
@@ -1079,7 +1079,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 
 	response->type = SMBD_NEGOTIATE_RESP;
 	rc = smbd_post_recv(info, response);
-	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=%llx iov.length=%x iov.lkey=%x\n",
+	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
 	if (rc)
@@ -1539,7 +1539,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	if (smbd_send_credit_target > info->id->device->attrs.max_cqe ||
 	    smbd_send_credit_target > info->id->device->attrs.max_qp_wr) {
-		log_rdma_event(ERR, "consider lowering send_credit_target = %d. Possible CQE overrun, device reporting max_cpe %d max_qp_wr %d\n",
+		log_rdma_event(ERR, "consider lowering send_credit_target = %d. Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
 			       smbd_send_credit_target,
 			       info->id->device->attrs.max_cqe,
 			       info->id->device->attrs.max_qp_wr);
@@ -1548,7 +1548,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	if (smbd_receive_credit_max > info->id->device->attrs.max_cqe ||
 	    smbd_receive_credit_max > info->id->device->attrs.max_qp_wr) {
-		log_rdma_event(ERR, "consider lowering receive_credit_max = %d. Possible CQE overrun, device reporting max_cpe %d max_qp_wr %d\n",
+		log_rdma_event(ERR, "consider lowering receive_credit_max = %d. Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
 			       smbd_receive_credit_max,
 			       info->id->device->attrs.max_cqe,
 			       info->id->device->attrs.max_qp_wr);
-- 
2.34.1

