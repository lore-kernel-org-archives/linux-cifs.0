Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9B9C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 15:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbiHWPFT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243285AbiHWPEx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 11:04:53 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B1931FC3D
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:29:37 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MBnbH51JyzlWQt;
        Tue, 23 Aug 2022 19:50:03 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 19:52:53 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
Subject: [PATCH -next 1/3] cifs: Use help macro to get the header preamble size
Date:   Tue, 23 Aug 2022 20:52:00 +0800
Message-ID: <20220823125202.1156172-2-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
References: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It's better to use HEADER_PREAMBLE_SIZE because the unfolded expression
too long. No actual functional changes, minor readability improvement.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/cifsencrypt.c |  2 +-
 fs/cifs/cifsglob.h    |  1 +
 fs/cifs/connect.c     | 20 ++++++++++----------
 fs/cifs/transport.c   | 21 ++++++++++-----------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 8f7835ccbca1..61a9fed56548 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -32,7 +32,7 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 	int rc;
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
-	int is_smb2 = server->vals->header_preamble_size == 0;
+	bool is_smb2 = HEADER_PREAMBLE_SIZE(server) == 0;
 
 	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
 	if (is_smb2) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 187b32158da8..0057228b47cc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -556,6 +556,7 @@ struct smb_version_values {
 
 #define HEADER_SIZE(server) (server->vals->header_size)
 #define MAX_HEADER_SIZE(server) (server->vals->max_header_size)
+#define HEADER_PREAMBLE_SIZE(server) (server->vals->header_preamble_size)
 
 /**
  * CIFS superblock mount flags (mnt_cifs_flags) to consider when
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9111c025bcb8..8a4ba1e93269 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -871,7 +871,7 @@ smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 	/*
 	 * SMB1 does not use credits.
 	 */
-	if (server->vals->header_preamble_size)
+	if (HEADER_PREAMBLE_SIZE(server))
 		return 0;
 
 	return le16_to_cpu(shdr->CreditRequest);
@@ -1050,7 +1050,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* make sure this will fit in a large buffer */
 	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) -
-		server->vals->header_preamble_size) {
+	    HEADER_PREAMBLE_SIZE(server)) {
 		cifs_server_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
 		cifs_reconnect(server, true);
 		return -ECONNABORTED;
@@ -1065,8 +1065,8 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* now read the rest */
 	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
-				       pdu_length - HEADER_SIZE(server) + 1
-				       + server->vals->header_preamble_size);
+				       pdu_length - HEADER_SIZE(server) + 1 +
+				       HEADER_PREAMBLE_SIZE(server));
 
 	if (length < 0)
 		return length;
@@ -1122,7 +1122,7 @@ smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 	/*
 	 * SMB1 does not use credits.
 	 */
-	if (server->vals->header_preamble_size)
+	if (HEADER_PREAMBLE_SIZE(server))
 		return;
 
 	if (shdr->CreditRequest) {
@@ -1180,7 +1180,7 @@ cifs_demultiplex_thread(void *p)
 		if (length < 0)
 			continue;
 
-		if (server->vals->header_preamble_size == 0)
+		if (HEADER_PREAMBLE_SIZE(server) == 0)
 			server->total_read = 0;
 		else
 			server->total_read = length;
@@ -1199,7 +1199,7 @@ cifs_demultiplex_thread(void *p)
 
 		/* make sure we have enough to get to the MID */
 		if (server->pdu_size < HEADER_SIZE(server) - 1 -
-		    server->vals->header_preamble_size) {
+		    HEADER_PREAMBLE_SIZE(server)) {
 			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
 				 server->pdu_size);
 			cifs_reconnect(server, true);
@@ -1208,9 +1208,9 @@ cifs_demultiplex_thread(void *p)
 
 		/* read down to the MID */
 		length = cifs_read_from_socket(server,
-			     buf + server->vals->header_preamble_size,
-			     HEADER_SIZE(server) - 1
-			     - server->vals->header_preamble_size);
+			     buf + HEADER_PREAMBLE_SIZE(server),
+			     HEADER_SIZE(server) - 1 -
+			     HEADER_PREAMBLE_SIZE(server));
 		if (length < 0)
 			continue;
 		server->total_read += length;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index de7aeced7e16..bb1052dbac5b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -261,8 +261,8 @@ smb_rqst_len(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	int nvec;
 	unsigned long buflen = 0;
 
-	if (server->vals->header_preamble_size == 0 &&
-	    rqst->rq_nvec >= 2 && rqst->rq_iov[0].iov_len == 4) {
+	if (HEADER_PREAMBLE_SIZE(server) == 0 && rqst->rq_nvec >= 2 &&
+	    rqst->rq_iov[0].iov_len == 4) {
 		iov = &rqst->rq_iov[1];
 		nvec = rqst->rq_nvec - 1;
 	} else {
@@ -346,7 +346,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
 
 	/* Generate a rfc1002 marker for SMB2+ */
-	if (server->vals->header_preamble_size == 0) {
+	if (HEADER_PREAMBLE_SIZE(server) == 0) {
 		struct kvec hiov = {
 			.iov_base = &rfc1002_marker,
 			.iov_len  = 4
@@ -1238,7 +1238,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		buf = (char *)midQ[i]->resp_buf;
 		resp_iov[i].iov_base = buf;
 		resp_iov[i].iov_len = midQ[i]->resp_buf_size +
-			server->vals->header_preamble_size;
+			HEADER_PREAMBLE_SIZE(server);
 
 		if (midQ[i]->large_buf)
 			resp_buf_type[i] = CIFS_LARGE_BUFFER;
@@ -1643,7 +1643,7 @@ int
 cifs_discard_remaining_data(struct TCP_Server_Info *server)
 {
 	unsigned int rfclen = server->pdu_size;
-	int remaining = rfclen + server->vals->header_preamble_size -
+	int remaining = rfclen + HEADER_PREAMBLE_SIZE(server) -
 		server->total_read;
 
 	while (remaining > 0) {
@@ -1689,8 +1689,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	unsigned int data_offset, data_len;
 	struct cifs_readdata *rdata = mid->callback_data;
 	char *buf = server->smallbuf;
-	unsigned int buflen = server->pdu_size +
-		server->vals->header_preamble_size;
+	unsigned int buflen = server->pdu_size + HEADER_PREAMBLE_SIZE(server);
 	bool use_rdma_mr = false;
 
 	cifs_dbg(FYI, "%s: mid=%llu offset=%llu bytes=%u\n",
@@ -1724,10 +1723,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* set up first two iov for signature check and to get credits */
 	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = server->vals->header_preamble_size;
-	rdata->iov[1].iov_base = buf + server->vals->header_preamble_size;
+	rdata->iov[0].iov_len = HEADER_PREAMBLE_SIZE(server);
+	rdata->iov[1].iov_base = buf + HEADER_PREAMBLE_SIZE(server);
 	rdata->iov[1].iov_len =
-		server->total_read - server->vals->header_preamble_size;
+		server->total_read - HEADER_PREAMBLE_SIZE(server);
 	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
 		 rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 	cifs_dbg(FYI, "1: iov_base=%p iov_len=%zu\n",
@@ -1752,7 +1751,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	data_offset = server->ops->read_data_offset(buf) +
-		server->vals->header_preamble_size;
+		HEADER_PREAMBLE_SIZE(server);
 	if (data_offset < server->total_read) {
 		/*
 		 * win2k8 sometimes sends an offset of 0 when the read
-- 
2.31.1

