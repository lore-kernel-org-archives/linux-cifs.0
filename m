Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B79C6FA83
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiIWVyq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiIWVyn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20761EAFC
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPnzhKyMCQ0tYZIk7Mlr1PXVe2KQ+OsVUzGlgbDh7v2qKTYeQ3CMJiB+okF+nj/Nz9QRKSwtYnIqxQDLy+OAM3PF6XmQ9YOnH36y55L9Qukq+hTrNf5cgheD/qeR2T0tQLQ9nMw4Jq9IRUoHLsxO70J5lqW5hzTEjqSh80yogceJfA89wPZwfNuWSJnwLxtjod9nta4Ef5+eF1VTHlDRcOkGXt0Hmwu2kiSUBUXPcrR7Y2GVwhwJ/vcG3dHjU4h9peRkYPIixcJJDjt2J4hlbGb7HW2l17Gc01BK2AeitwnRG2wGOYz7bN24aKK7mOUf145T66YKU8egNDQLwqaL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPu9BzhPJxokeo+9xsRSZpejNWGQMbOBgOVg6lQl7UE=;
 b=lxCSs2pKehGVOzypQHmDDACwPciOCxebb+Khu2VWHwuAuGDUwPpxaPcyJrpRHUY+ikmA2cGDM2z9CH6hPsn+o3Ho4eWLu4XbBkvTTcxDcXvtlBp59kk+aTJZ0Gvs3hggiK00+OzwKCj1ITQLGCK3nk5tg28sARaWuoxmwEJW86r+LsKlDbEaYmpABjsJOMeabuzcPVARIDJWFhu0UJkq/8e3g3hzuWAl11dmAnvZLJUhjZkJ/33dJPQOUPzkjUe+WDwCIBzWcYKrm7COojXPQSbke38g3j5wkyGOrVRlCC/12jssKjnoGLQz+/iHwMiXqQZ0Qb1WULouKVTcK8gUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:36 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 6/6] Fix formatting of client smbdirect RDMA logging
Date:   Fri, 23 Sep 2022 21:54:00 +0000
Message-Id: <01a4ede1bf68bcbc2ee99cdd00ea229bbc618bb9.1663961449.git.tom@talpey.com>
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
X-MS-Office365-Filtering-Correlation-Id: 14949948-5d61-424e-e143-08da9dae30bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5tYGKblo8zHeRy/vknzGjMG2Mgykuy6jGe8Y+8P2KhugQzw59+dYa/Oa9h1/iOA+tjbRseAoa3r6IeSYISeVFAgQ8J/spJxTQgo5+Uswy402NiLdk2vINkk0OIH2mwTKoLHvmVzwUTrHiAuO+ftchXhInBUVTpzVYWphveu88+3kYxOTCFQiB9i26PqCIZphIrMz2xStD1N377Gk2s/Y4Eu/UjOg7kiBNgSLHNeeLdQS5LTQLpbXHqZA3mPFOpkVvwjcjluoB2c0HBDulaK8CUKua2EwPHTgBF9enPXdNxWxpNxY9tUlO4HldKLQYTHRN47LKfPsujK+1xIvsqzXiUemSSxfpPo2hczEMYowf1aERaZIOqHPOBGoshGRa5bu8I6BeT9F3DhK79yceA6yagJnv77cPvWxR70iDtOPZ0Km1K4V5PazRUM7yjT5nvIx2vYeuTs3/dRr3xn+MvljZszuTNHPrhcHurhRoeofTSaLnRkFQlrm0QCzzluvlnFCY82Cczja3vEubXFRJsfFIdETAH5mfngJ5kXnpupx0zzkAzZpHxhEY+Y4AgvZxxZ13IFQx5M44TYP29N874ywzB32R/zS+v1oJ+dJxzFDyvqZxd51ICcz+2Uam+3/mBZLRO/n4uroCoYceRaXcCjXsNMwvL6WRN6mYhvTCV6QJuvHVXFGlOVoNR38eg2//WFYy1eXbgHUEJ9VKPSAkJ7ituy3ftXF2c4Y/c1YgGsDp4017dD0cbmnLaAd4Y/HAD+aXtS5XNlpYNzJmCHVcQn2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uCKjRiHQJiMYdw4RGO176tVtPOo1XLS5UXKPUG95aYQJhkk9M/N2aBeeI3vl?=
 =?us-ascii?Q?yxVko49qyo7HDC+r7JiEwMPLeqSo5aHT0STm2Zhglyrjmh5kmNx88vz42hRb?=
 =?us-ascii?Q?nkZyFFPylGB16gpTanOrViS+8cxRV7MHOBP2s14brBoumfHR1dcbc1LSN57W?=
 =?us-ascii?Q?v7grL45aBlEW0wTfJAlGx8QQlAx/3ckPpSEsKGLzk6Wrl/3pvtqYq69soa7s?=
 =?us-ascii?Q?jTggZt0tyCeuLxHcsiw/XXhz3b71ykj5srlyZCPGBODfuB4rGs3M2ba234zf?=
 =?us-ascii?Q?e8qaTVj+DBxuwZ79FQ12ibAfZaJTG6qTre0GJEyJ8kqlAcV8wYcXr+wWxfCx?=
 =?us-ascii?Q?imGYbBaU7JIEd0xS6C/m6ZblEXREIEdTDth8msIiJT8iSArkOE6zlj2Sz2Bv?=
 =?us-ascii?Q?XHSYJt4Ke+r9dvQxALr4XMB0z/8X/aU5T3KsVD1uA+Lmw02Hbl0EvSId8oqD?=
 =?us-ascii?Q?K6skR8Pu/v3gE24QNXj7u29aMH8lUrBGeuzTuz2+2XjgxQkJd+UYXiUaootJ?=
 =?us-ascii?Q?O5uEUoeziISQtxf0Zgwxn+E6Ykz0N7XeuufzJoXeGF0r4QPJfy7S1DS5Oq6O?=
 =?us-ascii?Q?6F+LVryWxvx1uPH98BSmTOg8BWgk/POObP9Ldc3DaooM82TWDcWdrIZh/wUb?=
 =?us-ascii?Q?EDZq+z5T6Tqjrcifww7M2tFUk6EK4c2/tIQ1gMLi+SwqXlwMaR5rQeSuNQxH?=
 =?us-ascii?Q?/QLDSBhUjGS9n4NcitEp7PI98guDC4LrzBGefKGybqiiOOeMnM/Jc4DKcgKc?=
 =?us-ascii?Q?gvUr2NL4McSQ/Fh6itEv/efcuOcJYgKbUHWR8ALvW9IVaRTRZvA7SS+UgFAB?=
 =?us-ascii?Q?nUOP69b20SC3KR/gqQ48xRloZhsAKV78u5BRYxtQXdrj3bu7kiJAa5ian1CN?=
 =?us-ascii?Q?Q8+B1ioJevq465rAqSZY5eluibIreudpqFWi1uQ1GfKF5qfuOhNzO5AQ8JN0?=
 =?us-ascii?Q?pL9wrMzIR0whZG1dt/3kK9wD81hKU9j6FZKm8ZM1GGenAmUk24d3EpA8WXQW?=
 =?us-ascii?Q?mcVskkpX8JQdVUtFrGfUxMp5EYmJFqe83X0oZ3aJrHgwhTzKvBefr9MfBAic?=
 =?us-ascii?Q?oDL/IrW6Bt12FGkU1L7Ypl1X9KejLeplashie4K4TW/BGRVV5ZUMVTlhq75V?=
 =?us-ascii?Q?7VtwKCjSS0EswwI850hF8ZR3OReSWNdU8KOML4rg2PvjtSeAfVvhxaPyjjpd?=
 =?us-ascii?Q?QM25vXF2pqiPVCzhgf3JfbeGEE0w9ToNDsvIaeFhaPAATyFRR9MW45RkHS57?=
 =?us-ascii?Q?M1d1tus2e+WVNhIHPlRWSA7+eoAY6t70ubIRM2CVXOPKxzHSzYGpOHdgVVz+?=
 =?us-ascii?Q?HaGgJLO79nj4EFcCTlsJw+hDyaBSdRuE+YKzofvuxX3OgQHR6Wx2sdRcULog?=
 =?us-ascii?Q?gLhDD1bgfpQQ/wiLiLeD2Rrd4Y7pWpspW2TvLDeItjosRGxHT5KdC6aU4bPA?=
 =?us-ascii?Q?qr46ikHO+jfzA+qMMrGiETl/SyM1M7g9ZJ9EaLIG3yHWgpsKpfRrB+GUR1WN?=
 =?us-ascii?Q?QAdM1pc3nfcGYcJLE+g37q2WdhZxqJMp/Eg1NRs2YQ9N0A6pjH8tUPhBfK7T?=
 =?us-ascii?Q?5KTZ8i5bTmvUk+NPfOoDgYOhOS15jHIYXGol9BlN?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14949948-5d61-424e-e143-08da9dae30bd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:29.5060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XG5k8wYTmLIfdZ8NXqYL1Fot3Waz1moI9KVr+QBOXA7EhDIE8Pu6g5C8tXXqVfZj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
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
index 6ac424d26fe6..90789aaa6567 100644
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

