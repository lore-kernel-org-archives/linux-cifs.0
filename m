Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6832CECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiIMWUJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIMWUG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:20:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C8657226
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpYZHCGxoYex9teH6WWVOdWu808MUvAlo3ZurlQuHwj1ij8zAVRNJFWkGJUSpcK5dQMyWgjmvVLH7xy1fpVk3Q8XVd68ldi3qGx3rh3s7Huk9JVA+fU5gHHzoLtzxAKopTl21KOKZ5RPCL+zoaOQIRt0xkBGDSgwiH5Ngv4RCovtkkLNWUq653dhHmp9AmSXw/nruSmrTvVyaCynBgm9xSXRC7wo1iQ0t8GvYXgVDAzICkMf79mgZW7EW9tS60muXKiaxflsYvP6q4nN0jjr6EKp1gFevHAJp5Cups8fl1p+gLqjtdsLiRpczwWO51oJWRcKmPRjjv9jp+DGpJ7rrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWfD7j4oaagsHQyFIKvg/EfxuQXkKvKVNetOePjbQMc=;
 b=En/MoIKL5+BAO6y9Sm4ddsqURM7/4YM/UFTNshr3yxVtOpyo5JTmDCwvNIFAeYHQEwA3PLqAWCAaaqQP8LtsWRWmI2dBduJBYMWGsFAGM5nsTS8q8gwo8WvHF4Vja4OU8Lv+J8tMZ0aOWcd2k2VxxmpSp0Y8U8dYjbxisdeyCikXOJ+UvNO1T2P9BXWR8qhcfjwMQlFLUFq1YlSesclM3XUX5E3ffOafFt0u9olwu61rQGIoByzITVK5WiSISz9F6mMuqqSrM5wFAyY/0OtfhG0hajD/Mktk2IuhOdHvARfQqWJ3FnFjKL/K8MawtPm4qmYaX0Kq7+slNZBWP8TP2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM8PR01MB7159.prod.exchangelabs.com (2603:10b6:8:d::16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Tue, 13 Sep 2022 22:20:03 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:20:03 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [PATCH 5/6] Handle variable number of SGEs in client smbdirect send.
Date:   Tue, 13 Sep 2022 22:19:36 +0000
Message-Id: <95a265f5f5da14508359d692d50d45f82635d924.1663103255.git.tom@talpey.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2117e103-bcb6-4b7f-031f-08da95d61ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UWYq/Cb8+xjl5D2402rY3Mm4PrCaEf3dwHo+BhazV7hESVeQVrLrx+nWhR5twxApY8NaoHvZx04BYRkFmFXwladGIk5hgCQplbbfzUG4gdW7bxVN9gy/nayXJY8bCq+jBXUqvKrsNt3MUnugaD8MqfZZ8ctn1AcuzHbo8E8gpvABbZ6OhlanJowuHbZqHhU1IfX2nmHHUUMFJIHugEz9bzDdFSH77O3U3YahsH7u3OA8mpYsvxSMDhqTrM2IXYBUsndpui7k4R9o9N4krg/jujcEEJ5h9ip3tO5qR2F9R5AAilosS1TttkmcdNU94bxEEZp7icPvnLRWEXBpEVDdj7Zm2C3b4cZUhBT8TbBGgdssMrTVDFpI4FMJ3N+RlqAB31dUKiEpUZMLqBY6opvWZYPuJ6y4ZkyDX1klLt/VCijCQ3CPxp/iFrJa7noUrHwdnjl58Ka2YXmTW4bXgUkm4W8cIaecWuXfyQ284e+F4d6f0jDatwB5l8gjtaUTPEeKut6TDzT2u7iHyNaDtZDeLxGjjd8OIXGwMwGpM6V2WPYIVGPT79K/l7K/SkxWTMQ830fFnS8Jn7+JOV43LRHhGD17nrC/LC7myVAciFGszBY1ILzNUWxm39CTJoIiW+104nrg4vAdjuz4BKRI4b5liYz0FI18Nm3/XhbaqGBwwWKij+Qg7svRPMavE3uh908cHMixw5C4/+cDBiJNjIj4e5I8MQ9IIU0oENqyu4FJYx+g3LdHHOf6m0LSaheANSUBMJIup7si2FQycVmlyE9/1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(39830400003)(396003)(451199015)(38350700002)(6506007)(316002)(6666004)(6486002)(2906002)(5660300002)(41300700001)(107886003)(478600001)(2616005)(6512007)(66556008)(38100700002)(8676002)(26005)(52116002)(8936002)(66476007)(186003)(83380400001)(66946007)(36756003)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68vUZBDmWdv6IQ0tWF2uF6JA1CViELsTCwrgEpuV0606SQ4A1X+u3KpO2CmW?=
 =?us-ascii?Q?CfnKYf5rVvIhaMmoIWzKUfLb0cxD5Sep7VqMnYiVf3+QaVg8OFgm3cqy4xB4?=
 =?us-ascii?Q?cFVcMPKmuZ3n8YVUawvxfvP90/fSRAyiMGWX4ELiZJjpwWv6BqQtZcb712yo?=
 =?us-ascii?Q?D+9rl5UcRA59bEngsh5qUfm+VGM9znwYTrznXS1WVWPvwQjlY5IfzHB2fgmB?=
 =?us-ascii?Q?gAzlhuwOToRx68g8374kln1YLofqKmquphlakgk+i8ZWpwDGEAoT0hX8lA6x?=
 =?us-ascii?Q?tE09V+TOaRWyuu30JOx5qbljM+ND1XqVHmGOW14dRdnuDI1FPbeY6LojcPB3?=
 =?us-ascii?Q?dGJOXLwk9sfj3g0lHbFRjThCclJ0fexbjkDVba+M5nX+lcNjxmglMAs87XYd?=
 =?us-ascii?Q?FXc7bbLx1p5Arv8GRBOiump77vJ1xD+Hobsd1MerwZVeTWeXPYEZKffmMk92?=
 =?us-ascii?Q?QgcFfV7p/NAKbZo4fVdgBGJrlRAOkFx7BOn7qN/nPH4cMOoDNLpAvCgB55zT?=
 =?us-ascii?Q?INDiAj8vmLqQMJp85ovLOv9Xpx1jxLSspK4ebcAnaJYk/W1YfMHeP0HTRQtI?=
 =?us-ascii?Q?O8CNZQ1f6ZgQfIuB/gc/dFSiIKZqDM1kv69yI4Cc/SJ2mbXLLL8tGuwQNNU6?=
 =?us-ascii?Q?GIcTwCWssCMGZHWYdOXVrfDy817klCwvCAABl6cqTZK6xVbE4RnFSZUfFyaR?=
 =?us-ascii?Q?XFcARbXzZYM+t0nv0QxChkbBmtzn4VOWDyzJVKMcIGSU0KzE63Z/k2ZW+zDD?=
 =?us-ascii?Q?SSNOeEGk3qrwmlS64zoVjxNsGdbYUtOkpQcFrgz6k4mrf3y/d77QdJwb6An6?=
 =?us-ascii?Q?L9/mjnzBLSUB0qpmhbQRcRsP1JuEuZcTf7ZCogV9moXUXgmus5IbsPDL00tg?=
 =?us-ascii?Q?CE/RnYLIR7NNhEtMVcBRcg/NmN5cgTBXbg+h3z+tsh4jSipH85uabKH7Gwjl?=
 =?us-ascii?Q?zy9HR7PiMX3zw7V6Zc7e6n45OfQ4hdkU4fjuTUEmQb2bH29YZu4CSQiflyBA?=
 =?us-ascii?Q?nAPe6u7HuYF1Fk3z2kcq/Urg/d9/zhoVIVarub59wpnwOVMpHNB5WmiWmfvs?=
 =?us-ascii?Q?6I1irAJJd7ROJzaHCH+PRXCvmWw2/j5lvttzN249kvViiGPs6a9lrIFUtb1A?=
 =?us-ascii?Q?7hX6GrUFThKsHknE0Co0LKx67MLhXX2eoMqTHR1bEUODVe+8bDClVxpPaCTo?=
 =?us-ascii?Q?MH2RqdbGpRLT1IL3TpgTt2p3dKvvLrrvUlid+ggXmt1VvCeukwd7uaXC6XZd?=
 =?us-ascii?Q?Jl0Bz+HGvotQ3y1t9N+viVWjaQ/hj0YZXimUHb+iA1515nSER/ylXfy1oQtY?=
 =?us-ascii?Q?2Bn+3ls3+W0ol0pNKVPVkQY3I6tlsRA60wPm0FkFjBT3LZeBz+ZJJYUh9otE?=
 =?us-ascii?Q?oX0DrVunyFXu49YEdHqYoMjZiPwgvN3eQ0lKhPgAnuMkmjgAaG8rzaWgQdUi?=
 =?us-ascii?Q?8UrbxyJXEc/zP8V91PmYSS5/5XjE+WcFPX3/lsz6czwocJ2htTT9yGdBq0VO?=
 =?us-ascii?Q?aM55uuymnYIsWeyutG+SITOWUa5Gw6XvQ1Y5H4BHDzH/0TMssddUrmvZd+Gl?=
 =?us-ascii?Q?rVMl0SsU3aP6q0EbrN2K+Fe2zmQA5kaqCOZ9hAt0?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2117e103-bcb6-4b7f-031f-08da95d61ad5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:20:03.3147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CK4yREDBWP9N9PQE6BSuiko6OJgpx3mDTfQP53e+GbboV+bga1nInPM+pPZ0NTHs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7159
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
index 4908ca54610c..494ac916158f 100644
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
+						max_iov_size - vecs[j].iov_len;
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

