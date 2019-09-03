Return-Path: <SRS0=oOOd=W6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29637C3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 16:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB130215EA
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528284;
	bh=zgc+UioOUwGXb7TQaMJXT1bDsSiqExv5Xl/iGS1D/vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WAMtT0qko194sDJM6ifs6FOZNMCssMXaHXTjSkb/+vAnw/7iE+l4LyPYg6MpMIBq0
	 TaBNqEllYQ0+ScGXgFmShC6zxI3/eECuV6zLaIHndC6su4d4Fs+8SjPtw/WHwzVE1S
	 F42iHruG64BBwUBAjygdg1XepCO4fm3ZUICfkxes=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbfICQ2X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730628AbfICQ2X (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE5023789;
        Tue,  3 Sep 2019 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528102;
        bh=zgc+UioOUwGXb7TQaMJXT1bDsSiqExv5Xl/iGS1D/vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUg9uguYV97Snh7ggScv1sJvhaDVZ9TmrE7enLB9FuDs6paTzATRKasYk1WPpA3QH
         zo4LAUbVDZVL8Fjyt/GBjsMR+yxuSKVk3YAJ9k3Y8BVEjHlkyqjWQYys9cHqXyezY1
         xvuPhT/5rw8LfVVdlGAnjjhfEjXnd2I0f5wO+vIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 109/167] cifs: smbd: take an array of reqeusts when sending upper layer data
Date:   Tue,  3 Sep 2019 12:24:21 -0400
Message-Id: <20190903162519.7136-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 4739f2328661d070f93f9bcc8afb2a82706c826d ]

To support compounding, __smb_send_rqst() now sends an array of requests to
the transport layer.
Change smbd_send() to take an array of requests, and send them in as few
packets as possible.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smbdirect.c | 55 +++++++++++++++++++++++----------------------
 fs/cifs/smbdirect.h |  5 +++--
 fs/cifs/transport.c |  2 +-
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fdb9a509a97f..1959931e14c1e 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2090,7 +2090,8 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
  * rqst: the data to write
  * return value: 0 if successfully write, otherwise error code
  */
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst_array)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct kvec vec;
@@ -2102,6 +2103,8 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		info->max_send_size - sizeof(struct smbd_data_transfer);
 	struct kvec *iov;
 	int rc;
+	struct smb_rqst *rqst;
+	int rqst_idx;
 
 	info->smbd_send_pending++;
 	if (info->transport_status != SMBD_CONNECTED) {
@@ -2109,47 +2112,41 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		goto done;
 	}
 
-	/*
-	 * Skip the RFC1002 length defined in MS-SMB2 section 2.1
-	 * It is used only for TCP transport in the iov[0]
-	 * In future we may want to add a transport layer under protocol
-	 * layer so this will only be issued to TCP transport
-	 */
-
-	if (rqst->rq_iov[0].iov_len != 4) {
-		log_write(ERR, "expected the pdu length in 1st iov, but got %zu\n", rqst->rq_iov[0].iov_len);
-		return -EINVAL;
-	}
-
 	/*
 	 * Add in the page array if there is one. The caller needs to set
 	 * rq_tailsz to PAGE_SIZE when the buffer has multiple pages and
 	 * ends at page boundary
 	 */
-	buflen = smb_rqst_len(server, rqst);
+	remaining_data_length = 0;
+	for (i = 0; i < num_rqst; i++)
+		remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
 
-	if (buflen + sizeof(struct smbd_data_transfer) >
+	if (remaining_data_length + sizeof(struct smbd_data_transfer) >
 		info->max_fragmented_send_size) {
 		log_write(ERR, "payload size %d > max size %d\n",
-			buflen, info->max_fragmented_send_size);
+			remaining_data_length, info->max_fragmented_send_size);
 		rc = -EINVAL;
 		goto done;
 	}
 
-	iov = &rqst->rq_iov[1];
+	rqst_idx = 0;
+
+next_rqst:
+	rqst = &rqst_array[rqst_idx];
+	iov = rqst->rq_iov;
 
-	cifs_dbg(FYI, "Sending smb (RDMA): smb_len=%u\n", buflen);
-	for (i = 0; i < rqst->rq_nvec-1; i++)
+	cifs_dbg(FYI, "Sending smb (RDMA): idx=%d smb_len=%lu\n",
+		rqst_idx, smb_rqst_len(server, rqst));
+	for (i = 0; i < rqst->rq_nvec; i++)
 		dump_smb(iov[i].iov_base, iov[i].iov_len);
 
-	remaining_data_length = buflen;
 
-	log_write(INFO, "rqst->rq_nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
-		"rq_tailsz=%d buflen=%d\n",
-		rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
-		rqst->rq_tailsz, buflen);
+	log_write(INFO, "rqst_idx=%d nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
+		"rq_tailsz=%d buflen=%lu\n",
+		rqst_idx, rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
+		rqst->rq_tailsz, smb_rqst_len(server, rqst));
 
-	start = i = iov[0].iov_len ? 0 : 1;
+	start = i = 0;
 	buflen = 0;
 	while (true) {
 		buflen += iov[i].iov_len;
@@ -2197,14 +2194,14 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 						goto done;
 				}
 				i++;
-				if (i == rqst->rq_nvec-1)
+				if (i == rqst->rq_nvec)
 					break;
 			}
 			start = i;
 			buflen = 0;
 		} else {
 			i++;
-			if (i == rqst->rq_nvec-1) {
+			if (i == rqst->rq_nvec) {
 				/* send out all remaining vecs */
 				remaining_data_length -= buflen;
 				log_write(INFO,
@@ -2248,6 +2245,10 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		}
 	}
 
+	rqst_idx++;
+	if (rqst_idx < num_rqst)
+		goto next_rqst;
+
 done:
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a11096254f296..b5c240ff21919 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -292,7 +292,8 @@ void smbd_destroy(struct smbd_connection *info);
 
 /* Interface for carrying upper layer I/O through send/recv */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst);
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst);
 
 enum mr_state {
 	MR_READY,
@@ -332,7 +333,7 @@ static inline void *smbd_get_connection(
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct smbd_connection *info) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
-static inline int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst) {return -1; }
+static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
 #endif
 
 #endif
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f2938bd95c40e..fe77f41bff9f2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -287,7 +287,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		rc = smbd_send(server, rqst);
+		rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 	if (ssocket == NULL)
-- 
2.20.1

