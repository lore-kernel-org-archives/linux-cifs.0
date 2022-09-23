Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839BFC04A95
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 21:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiIWVyn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiIWVyl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 17:54:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7B6193D8
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 14:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crvXmFQsZJN5CLtabpxWEQGQJDKTf6W6ClVX8FH8W6LUW3Q3Vkw5sm2Ul9ZU1kyZoq0XR4kXGXKyA3FfCM+IgrGfs9OyV/3IrBEW6keoxM6UwItFANkU+TTBmy0Z1fOxp5HjPO5kBsD7Vdkqa8veVRobkemkhbWtCOSYbv1Q+CWG9zX5tsEF9ZYSskiEki85lXDsANqD645l2/868r1eq5MlwvnsMakEB8SpjFwU18Qyt57IY+ivllLkS3RV+Cu37Y1BNpDnDM8RIj7/M5fBnCYCrnFAtKht6Z+7g+VTktrSzKg9eyR/A/YA+H0q9AF1txFHRxiG19KVzddMRjpT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LST/EbNmmvrfpVR9pArI4f4fDznQBxgDBKokjk/LBuo=;
 b=Qi1uExkDIFX1FMkOaidct4ks7WB5KN8UvQ/ImaBqNMW80v/o06zNQCNEb2vqcoIReyngLTs7srwH40OG3WojSo/pRLtYVs3RaxcjBChYLl240z2YLGONnjyyUzoVEmWiFnik8EokUMesjcC928lgtORRiVWmD4Dkm2IVG1PnHL6vV+iZ2jdflwIrJ3cV4JY9fEZ/u9QX1UkbvgbCPHS3W6VjLszIZg7XEhhFVTqRN7YUb0eQB5Ds28lnmm69xXmGZKpcj4TR4t4IEe/uwx0jTCmsCNUx+PpulYAGBDzbIPRWScPymTRL+En+TV8NBH9aKoLzBWhnWCXe52942NXDqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3481.prod.exchangelabs.com (2603:10b6:302:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Fri, 23 Sep 2022 21:54:35 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 21:54:35 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 5/6] Handle variable number of SGEs in client smbdirect send.
Date:   Fri, 23 Sep 2022 21:53:59 +0000
Message-Id: <a9529566390d8c09c5ae0e0ca8e9746993ef51ab.1663961449.git.tom@talpey.com>
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
X-MS-Office365-Filtering-Correlation-Id: 588e5e39-6bf8-40e7-e906-08da9dae3041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AUP0N2gkrbEeT75wAuSjr0vgcjd72iVSQ5bniwolQqz2BE11sm9JNd+nYZyTHZIDmhm8fptfboQQEDeWKhMUIL1swQNYhUZrkG+gtvIRkRlKxWnxlWpl76y1MvbyeugnmVRpZza1HHN1Ws+A5I1EJpEatzCS5NNVgYtgsG9M3uYm6QyxKuo5DWH8rUFKkYlWg56Bme71EfL4h7rAWZpOzziK5rtFtOCZs4CSNfYd9OP2pBxcZCltoTmMXQb5eI0a5rYvKyTYpZ20K9jWLGS5XI2s3vhHf8M0lpuDKSoZZ/prGWybCAQNJ1MxduZlHOBZxQBqQyBiaQTaWNaqXLuMnGKJp1arTMxuLgniQ4KuRb3CjytW4+X/1HDAj0o3CN8LiR1GNKjmzoTY6Dsl68VSOteThh/8WldK9UIEP4pP8h0xTu4jKd3QiBqgJQUagEkO64oHbqRas1YLuTULEn2do/CyTlIWX9GzA0PLrF6SpyfwkIu9+3ZeggzQJB/I35uUMEZjvjYZVPpPu3W6o4DH6Q3brCSz4s95OjEBirYDfPvSjivUbyySBQntEPlOvgxU29ZRcNUP8OL3GDcwI7vipGM1JhXaduhhUViaLRT6AB5hTCk5oG2AJWq8e1KXUxjowrNzf9js/4dgHFtYFFS/E7i22QSdTZHlEnKeKWtRgTZ4RiysA6fCXsOCTD3F3A2lnYMO8Oauac7v+bEbm3RGcp13ryCE8dh4f08iC8vaUAb1tp0rt9h0xcpeeHYuTnuJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39830400003)(136003)(451199015)(8936002)(38100700002)(41300700001)(66556008)(8676002)(38350700002)(66946007)(66476007)(36756003)(5660300002)(2906002)(26005)(6512007)(6506007)(52116002)(4326008)(186003)(478600001)(6486002)(107886003)(6666004)(2616005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m+pR2W8AYyfsA1xopG3TfilNnYdkvqTtiW3fizDp0YLUAwLOEdRFf/8YQY3W?=
 =?us-ascii?Q?UZHfhjpLPSTP0tBxCBaSRjJG0ng3K0TihLLv/vLnhbmNs94ZX6slklZ5Nmsd?=
 =?us-ascii?Q?WdtE2afXBz54eIu7Hs/SKnGI9trE8NdZg6guxw27joy7+BzDfsYmhoEI/hi/?=
 =?us-ascii?Q?iypWVfWE/6QTRQuBuA96YKo0U13OBsONwr5NWsByCRTvaiTPDZ6eFAK68MVb?=
 =?us-ascii?Q?c+kpUXZEdnyacLa53+0I3H91N7cpSrJFEW244XQWOPhj7gdoUhPsUmlK7KbU?=
 =?us-ascii?Q?7PHwlAtlhhL8FL2p+a7NP9aY/0bL64rlx6EJ+ydYDYx6Gkr3bEhCPNKVAmJp?=
 =?us-ascii?Q?a70qXab6MC/UNE1qWslufnjAU7eVWffN2YWmEgUcLTVfVvF4k4Z+WTpORF0c?=
 =?us-ascii?Q?n2IjGi4/79Ao25UFXG6WRMqlf1r5ZfEo9zsphDIJYJmx2PRoFTwt9y0c6+aV?=
 =?us-ascii?Q?7urGRPQuArBnCpK+18HqVe/Bx/uegf4aD2p0SJOQ7fGOGmMnmAkNkCSK7s7F?=
 =?us-ascii?Q?2BYdYkskEsfzkDvSO/MEJytxGm+HTmMYzOIUpQ+KzT4yxKpjr1kYl8ULNHhD?=
 =?us-ascii?Q?aKSVvcbnkoLQXNHFzGgDejpVtTn8Fu509grdha2mPvyJ68sb7LTbArcx9GA5?=
 =?us-ascii?Q?rA9WrWRRF4pZuRGDbqPAgZvMzfetkNVICLZyB3LVxkdQbHmLmaJPKhi0Q5Hk?=
 =?us-ascii?Q?BDRxWZVSgo8rFWsv3oApIX1kV5vDxSPv8suVjGm0d3L9iEMQN0Ol0GNin6GW?=
 =?us-ascii?Q?nw2cx9vb7i2Gwe0Z/oGPblVKoyj5c0IjDHy9dckyikVPSoKPHT8iwk2XqFUF?=
 =?us-ascii?Q?4moNKD5PntYTcnw3LtCp+aThUeg/PpqIfJ9kWle2xBqzg6qTyMOM9NieA3Ae?=
 =?us-ascii?Q?FnYAdyEP4gaFadnmXbQ+rmp5zsmVp3D+rmZvNfDxRKrylJHyd5LNNMegyp8+?=
 =?us-ascii?Q?LAZD/L05vamYrPqcudus6wDfsv2sCblYWsg99unXKAQY0/RPj0tvLc+IpYct?=
 =?us-ascii?Q?z6kxL3iV0NTbsw4dVEaNPqmD9CLrmhzH0Q3l433sLzYfjvI6+vW/vKH5EDzP?=
 =?us-ascii?Q?GWoQKxcchzW8NhK2hlUBOiNS1WfcpenP7I0UkzypieS0guYP/I1HHcK/i7A8?=
 =?us-ascii?Q?ZreFNijcHBDf+4lt5iWE/HuhlSn0Y8B0zv/iEEhsEPANL+gU1MoMS4OfeWOV?=
 =?us-ascii?Q?26qNhKvR7c/MM3ucWBPP4Wh8/iYUCEBa/lDc3WuHbRPRI4Aw8z8k7r0wugau?=
 =?us-ascii?Q?TGXQXmvjw8gSJcKQAP6ycZ0Bn/cGIUzkfYCbckxxOOD3m7rX6bM7TiBx36C5?=
 =?us-ascii?Q?54jmVu4JtXKtDa/xVWaBxIRO/DsZzTjy3ncwSjJcgKisPYd88AIHZzzidWqS?=
 =?us-ascii?Q?SGmWz+X3g5+evsKHKYM+Nl794MH4mLFtbhFD/X42u1+13N+rIBB4FwLmaQqm?=
 =?us-ascii?Q?Dvp8SCCJSouoGIGvgdinxOe/U7acVXdSl8MTESGFf7TBYo6xumnzF9SA1EEU?=
 =?us-ascii?Q?/oXaKr3GIUu1Pl9CCbCV6WcDE4g/Y+t5RxMkUnOUs/UWemecWbm7XUzqaO+z?=
 =?us-ascii?Q?PDx+nF2oris5EaNgnZ1yw8wJnx/9ZJbwloqPoO3/?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588e5e39-6bf8-40e7-e906-08da9dae3041
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:54:28.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctMmgoEP4NFMDbzfp9ty+/7+vWBBWXH+zuHoCMmInEO8P6Mk5srAu+dMfQfquYZl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3481
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If/when an outgoing request contains more scatter/gather segments
than can be mapped in a single RDMA send work request, use smbdirect
fragments to send it in multiple packets.

Signed-off-by: Tom Talpey <tom@talpey.com>
---
 fs/cifs/smbdirect.c | 185 ++++++++++++++++++--------------------------
 1 file changed, 77 insertions(+), 108 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 4908ca54610c..6ac424d26fe6 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1984,10 +1984,11 @@ int smbd_send(struct TCP_Server_Info *server,
 	int num_rqst, struct smb_rqst *rqst_array)
 {
 	struct smbd_connection *info = server->smbd_conn;
-	struct kvec vec;
+	struct kvec vecs[SMBDIRECT_MAX_SEND_SGE - 1];
 	int nvecs;
 	int size;
 	unsigned int buflen, remaining_data_length;
+	unsigned int offset, remaining_vec_data_length;
 	int start, i, j;
 	int max_iov_size =
 		info->max_send_size - sizeof(struct smbd_data_transfer);
@@ -1996,10 +1997,8 @@ int smbd_send(struct TCP_Server_Info *server,
 	struct smb_rqst *rqst;
 	int rqst_idx;
 
-	if (info->transport_status != SMBD_CONNECTED) {
-		rc = -EAGAIN;
-		goto done;
-	}
+	if (info->transport_status != SMBD_CONNECTED)
+		return -EAGAIN;
 
 	/*
 	 * Add in the page array if there is one. The caller needs to set
@@ -2010,125 +2009,95 @@ int smbd_send(struct TCP_Server_Info *server,
 	for (i = 0; i < num_rqst; i++)
 		remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
 
-	if (remaining_data_length > info->max_fragmented_send_size) {
+	if (unlikely(remaining_data_length > info->max_fragmented_send_size)) {
+		/* assertion: payload never exceeds negotiated maximum */
 		log_write(ERR, "payload size %d > max size %d\n",
 			remaining_data_length, info->max_fragmented_send_size);
-		rc = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 
 	log_write(INFO, "num_rqst=%d total length=%u\n",
 			num_rqst, remaining_data_length);
 
 	rqst_idx = 0;
-next_rqst:
-	rqst = &rqst_array[rqst_idx];
-	iov = rqst->rq_iov;
-
-	cifs_dbg(FYI, "Sending smb (RDMA): idx=%d smb_len=%lu\n",
-		rqst_idx, smb_rqst_len(server, rqst));
-	for (i = 0; i < rqst->rq_nvec; i++)
-		dump_smb(iov[i].iov_base, iov[i].iov_len);
-
-
-	log_write(INFO, "rqst_idx=%d nvec=%d rqst->rq_npages=%d rq_pagesz=%d rq_tailsz=%d buflen=%lu\n",
-		  rqst_idx, rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
-		  rqst->rq_tailsz, smb_rqst_len(server, rqst));
-
-	start = i = 0;
-	buflen = 0;
-	while (true) {
-		buflen += iov[i].iov_len;
-		if (buflen > max_iov_size) {
-			if (i > start) {
-				remaining_data_length -=
-					(buflen-iov[i].iov_len);
-				log_write(INFO, "sending iov[] from start=%d i=%d nvecs=%d remaining_data_length=%d\n",
-					  start, i, i - start,
-					  remaining_data_length);
-				rc = smbd_post_send_data(
-					info, &iov[start], i-start,
-					remaining_data_length);
-				if (rc)
-					goto done;
-			} else {
-				/* iov[start] is too big, break it */
-				nvecs = (buflen+max_iov_size-1)/max_iov_size;
-				log_write(INFO, "iov[%d] iov_base=%p buflen=%d break to %d vectors\n",
-					  start, iov[start].iov_base,
-					  buflen, nvecs);
-				for (j = 0; j < nvecs; j++) {
-					vec.iov_base =
-						(char *)iov[start].iov_base +
-						j*max_iov_size;
-					vec.iov_len = max_iov_size;
-					if (j == nvecs-1)
-						vec.iov_len =
-							buflen -
-							max_iov_size*(nvecs-1);
-					remaining_data_length -= vec.iov_len;
-					log_write(INFO,
-						"sending vec j=%d iov_base=%p iov_len=%zu remaining_data_length=%d\n",
-						  j, vec.iov_base, vec.iov_len,
-						  remaining_data_length);
-					rc = smbd_post_send_data(
-						info, &vec, 1,
-						remaining_data_length);
-					if (rc)
-						goto done;
+	do {
+		rqst = &rqst_array[rqst_idx];
+		iov = rqst->rq_iov;
+
+		cifs_dbg(FYI, "Sending smb (RDMA): idx=%d smb_len=%lu\n",
+			rqst_idx, smb_rqst_len(server, rqst));
+		remaining_vec_data_length = 0;
+		for (i = 0; i < rqst->rq_nvec; i++) {
+			remaining_vec_data_length += iov[i].iov_len;
+			dump_smb(iov[i].iov_base, iov[i].iov_len);
+		}
+
+		log_write(INFO, "rqst_idx=%d nvec=%d rqst->rq_npages=%d rq_pagesz=%d rq_tailsz=%d buflen=%lu\n",
+			  rqst_idx, rqst->rq_nvec,
+			  rqst->rq_npages, rqst->rq_pagesz,
+			  rqst->rq_tailsz, smb_rqst_len(server, rqst));
+
+		start = 0;
+		offset = 0;
+		do {
+			buflen = 0;
+			i = start;
+			j = 0;
+			while (i < rqst->rq_nvec &&
+				j < SMBDIRECT_MAX_SEND_SGE - 1 &&
+				buflen < max_iov_size) {
+
+				vecs[j].iov_base = iov[i].iov_base + offset;
+				if (buflen + iov[i].iov_len > max_iov_size) {
+					vecs[j].iov_len =
+						max_iov_size - iov[i].iov_len;
+					buflen = max_iov_size;
+					offset = vecs[j].iov_len;
+				} else {
+					vecs[j].iov_len =
+						iov[i].iov_len - offset;
+					buflen += vecs[j].iov_len;
+					offset = 0;
+					++i;
 				}
-				i++;
-				if (i == rqst->rq_nvec)
-					break;
+				++j;
 			}
+
+			remaining_vec_data_length -= buflen;
+			remaining_data_length -= buflen;
+			log_write(INFO, "sending %s iov[%d] from start=%d nvecs=%d remaining_data_length=%d\n",
+					remaining_vec_data_length > 0 ?
+						"partial" : "complete",
+					rqst->rq_nvec, start, j,
+					remaining_data_length);
+
 			start = i;
-			buflen = 0;
-		} else {
-			i++;
-			if (i == rqst->rq_nvec) {
-				/* send out all remaining vecs */
-				remaining_data_length -= buflen;
-				log_write(INFO, "sending iov[] from start=%d i=%d nvecs=%d remaining_data_length=%d\n",
-					  start, i, i - start,
+			rc = smbd_post_send_data(info, vecs, j, remaining_data_length);
+			if (rc)
+				goto done;
+		} while (remaining_vec_data_length > 0);
+
+		/* now sending pages if there are any */
+		for (i = 0; i < rqst->rq_npages; i++) {
+			rqst_page_get_length(rqst, i, &buflen, &offset);
+			nvecs = (buflen + max_iov_size - 1) / max_iov_size;
+			log_write(INFO, "sending pages buflen=%d nvecs=%d\n",
+				buflen, nvecs);
+			for (j = 0; j < nvecs; j++) {
+				size = min_t(unsigned int, max_iov_size, remaining_data_length);
+				remaining_data_length -= size;
+				log_write(INFO, "sending pages i=%d offset=%d size=%d remaining_data_length=%d\n",
+					  i, j * max_iov_size + offset, size,
 					  remaining_data_length);
-				rc = smbd_post_send_data(info, &iov[start],
-					i-start, remaining_data_length);
+				rc = smbd_post_send_page(
+					info, rqst->rq_pages[i],
+					j*max_iov_size + offset,
+					size, remaining_data_length);
 				if (rc)
 					goto done;
-				break;
 			}
 		}
-		log_write(INFO, "looping i=%d buflen=%d\n", i, buflen);
-	}
-
-	/* now sending pages if there are any */
-	for (i = 0; i < rqst->rq_npages; i++) {
-		unsigned int offset;
-
-		rqst_page_get_length(rqst, i, &buflen, &offset);
-		nvecs = (buflen + max_iov_size - 1) / max_iov_size;
-		log_write(INFO, "sending pages buflen=%d nvecs=%d\n",
-			buflen, nvecs);
-		for (j = 0; j < nvecs; j++) {
-			size = max_iov_size;
-			if (j == nvecs-1)
-				size = buflen - j*max_iov_size;
-			remaining_data_length -= size;
-			log_write(INFO, "sending pages i=%d offset=%d size=%d remaining_data_length=%d\n",
-				  i, j * max_iov_size + offset, size,
-				  remaining_data_length);
-			rc = smbd_post_send_page(
-				info, rqst->rq_pages[i],
-				j*max_iov_size + offset,
-				size, remaining_data_length);
-			if (rc)
-				goto done;
-		}
-	}
-
-	rqst_idx++;
-	if (rqst_idx < num_rqst)
-		goto next_rqst;
+	} while (++rqst_idx < num_rqst);
 
 done:
 	/*
-- 
2.34.1

