Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109DEC04A95
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiIWVyi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVyh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D086327
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QymDbH+nOCpkv26kex2GZh5NaTHIovaqdbf9b6yhGeQiylOEQ+rk7/onV0ocSgbKJACUhsAjwTtBfb7+ArF7noxU8B7TXgv4ZtDGmC3BAbF8OIWieMzPX4Rvohfi4L/mwMVxYh5TLwEVhlTrO74BXDVlF8N0A51Yk4zLOIQIHLh0fZBWR5Iq+1BJyHsmkTeBeGdATk53xjCgj+Tmb3kEOXCtkYhR71S0SmvbfMsRgY1T2BOLTN01BxxGi+glPO0ip+ILeHShtqwuRjTxUEYyqW2BpugmyRlFJGHhXthOQF47yHTvhTHAjaX9IRu1TZUexC9WzL65nVbttzd27m53Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ta9jH0CPNAcarRyFejg98tnimrtEnVbOqrhWWQc34SM=;
 b=n7tsQJhkk0WxoA2/sFC6JaV3VXKCzh3Gp8lJBbvY2CPNU/sLgUWBiwg0ECeNX2+00EY7mJCGHz7ekcabOSwVzEhd6H4kp10mnfoan6ioYPl03JIiZv81joU5GDEGl2Ryp8xwXJfB3412v2Lzl26ZjkJzQmfIQ81GQ7x90QW7D+9DfUtPME2lvK5eGT42fURxkw9HqJ2ErQtmoFK1B0tskzva/3mZzfA/ZrklmSREU7d1TL05db62EgGdJuFxNHggtIXV1PH5QmohaBb/FkJ2FiKfBCKL6tqdFiz08BlcOPh/W4tfHVFatu5VGtRO67RhjeNU3G8z5yTRpFtA2OTV1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:28 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:28 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 1/6] Decrease the number of SMB3 smbdirect client SGEs
Date:   Fri, 23 Sep 2022 21:53:55 +0000
Message-Id: <f361d643cebbf031a4dd272608dedd6a89d12aaf.1663961449.git.tom@talpey.com>
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
X-MS-Office365-Filtering-Correlation-Id: 67e02447-0cb1-4759-4529-08da9dae2e2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hESARQ4bsoA1XwRu61OtFy2olMhq+T1zyIalPiptzA3LxDPFRdJlY4wQZ7aMn61EJQtuW0Qn5Qvj4aAX/ysR8E561BCQEO9T7IjvWjbbbGnnnJt6qJsCiWLvR/jDd05wgfp20+luBhAW87J3RzrZGnU9mlK72PCMPAaxzW9dt1OOXDHtqJUew3L/SgJdJ2hRyP5MaOFNGCoO/FJhvvnMumT4Fwvrj5h3GDQoDY06mT8ZV714joJ9BcHrn+q9m7voCFJcK1xjil9MxAvH5E/IirxFP5XJrroJNV7hJLbxsm3njMN5vLrTvl2B3j9IuAOhy6Omo2yTsuq3Dp7m+NmO1I1DsC3ytGlnLiCiPRBNkLLRqltEN0zm44aoaxjvijgRX76gMJNg3rMB3nTU9DYtiR9clGFGefPiIkmt82eqkujZiNW2VlE5CcjgQWUJO71sKkhJPVi3ujOUqBYDKrGSRzldQ1gQyuh8or43vZNeHyz5eBy6wKWYDIhrOdSYU4UUvMpWrTFljCfNSmnzS69GhkGxynww8yI6NRScn4ukDtA3Tmb+/uTwi/nd6dX6F0wvQ4lpRqaUEZdLVrN/tm0V/jLT6lXV0xcbYEWstK6OBH9j+Cv0LZH7Q8JK5NfXE+XJ8/thGy3C2b4ZFwdmsPLFBNwPEv4AAp9r3MgiTUqvLME+G7PpJRCJk6nBbat6OcPe1VXK9x8qOAourMTPMVPg/ii/XrHsdeI3M3NoYxAXlewZ338t13a2+Wr0p24DTKTywmkscCXb7C2ypCaaNGO5RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C1Ey87hKRTzhYF7c+xhxA2uPdr7jKdA/zap6cqHMxFIPFWoPIbtCulbSd5gC?=
 =?us-ascii?Q?9Z/jnrvLnHaDQZfJO8MvYgiM3hiqAklWk0Y6UltZj2Br7V3aROxfOwYXU36D?=
 =?us-ascii?Q?Zt4ckoCITy5q3s1js9WL724KZ6MQ9l+ojhrPQT49xv24AHzA/oGWY/FUQqIW?=
 =?us-ascii?Q?kyG09N5KYSDUQ1tgAII6DXtWT6uuX5AeP2lxkQFei0ap69o9mVEPcp9+u5Ej?=
 =?us-ascii?Q?Xzz/rRXjDq0yNWxLQuEg16A0saoU+WpPaVsy49xF5Rr7kw/2b7xATiBLWvSF?=
 =?us-ascii?Q?2SNPp93xfwVM7vVPEsG6PhcF8b/s73PSK79e3LXok9f2jMuO9kw2VlyZhihw?=
 =?us-ascii?Q?lPdApYQN8Sc5dzZDtRe98KI486DiN9TIrS/Dpiq+FxIjhb5IVs/xEZvEFZmw?=
 =?us-ascii?Q?u8vzm0DVeH+5o4PMd7IIpeBNtMvhE51lbzC61twIME6rzs7+gL+YZ4JRVP+D?=
 =?us-ascii?Q?DUBryxecyoKm83iorDAeHA2rftgSXYtbDPE6oFEmjrCzkV1Eohz9AE6eCyCe?=
 =?us-ascii?Q?t+Y7aZrEq6RsBGe8UqfjF7qM7ysPIvxVSlZxvmrNUMCjqCwK3Tkh/JoTdg7g?=
 =?us-ascii?Q?tNd4XTq4Q16ATvWHvsD0rzzTOU+QTFIQAD1dizdzicpDVLbx9RFFD0/TCh+J?=
 =?us-ascii?Q?z4l8FdD/Qbc1McwnLg7l6YyU0hZ+VUGElSQl1P8pKTD0K4DZSDYIb6thy64n?=
 =?us-ascii?Q?Wv3grCX6SGapcZmPkrNe40Ctr1QZGZR6DZcrcXtahu8B04SSmKLO+jKEBgh+?=
 =?us-ascii?Q?7Q4/QwgqfDjLC3pMt+Gt4FVYWTantjLVfZLtApqNnPVrxjNxrPr/kWNqYE4O?=
 =?us-ascii?Q?Hw97GnE/wdh8VB/QzN6ZMWOliXkIKM0Sxv7nXVGKkY1KZjk6YVVgwkIpw3h0?=
 =?us-ascii?Q?uEIa/vJ56ohvMHewcd3phc1Bl0JoZR0HyfW27W6kkyOKRMdBP6OV8mtyIEaw?=
 =?us-ascii?Q?rkrflW3ZIUdsjZyB7VaA0lxql+0FysGX2q1pB02xFbxHRKmeoLyB6ntyGs6Y?=
 =?us-ascii?Q?VpYYnZqZt7ooFQpSdz3JpuULtRfIdV7KgJkzhC/lLMXzMuq0cigzk61i4d5g?=
 =?us-ascii?Q?xdPtisr/iuMZhLqmaAftp0jqMsqSJMBVeThOjUDbqUvY0qyYTOWgI9S0BHyE?=
 =?us-ascii?Q?Uws2Hik7l44qK4ODclQb1rTFETpvSR0J1VJDuXDo6J7rEnr2BPQ4ac8tGdi1?=
 =?us-ascii?Q?EgTyKIDNVJFSEmJOQK8n8Bmxy+csZrRiCwoTBFhXs44k5yGt+tWUaOK4j2WL?=
 =?us-ascii?Q?5o1+zpGhGTPd/OXFcdgbG9Riucv6uzX/iCTTwtHKCI3BsoX+eFT3mH2mmj/d?=
 =?us-ascii?Q?5d0OfkkTNXbJbOqd5miCuy15PYdVlQhMRXHTH7SKwz+rImQ82Es4+hBRLzYg?=
 =?us-ascii?Q?wkklrbTLK6SnHxqExbq6pVJ8sRJ8iZU7mrbn3s5HHpCQbEU4SQyBVLJreEBE?=
 =?us-ascii?Q?CmVozigPUDzY8gmbMuSjYKJ5+MaQ5B+WsGo4WeC6lU6VWx4DhREeNz3PP+uJ?=
 =?us-ascii?Q?OJJTFR5nN94DsaND8zH6J2MGtLwWvVumjSi3y6Azj/u1Jmvu1PvdVEvc7AB6?=
 =?us-ascii?Q?iX2nl6V8lhB4whgSo5IKf6ru6C7BKJLyf+QlyszF?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e02447-0cb1-4759-4529-08da9dae2e2e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:25.2251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttmGzWPoC3gT4BtW077JUIpMpCqFIW9Mt7FsJXE1yHbZmnduSE1eehdTvnP2GtsJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
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

