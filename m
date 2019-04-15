Return-Path: <SRS0=GStD=SR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162E8C10F0E
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Apr 2019 21:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE80B206B6
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Apr 2019 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfDOVu3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Apr 2019 17:50:29 -0400
Received: from a2nlsmtp01-02.prod.iad2.secureserver.net ([198.71.225.36]:41236
        "EHLO a2nlsmtp01-02.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfDOVu3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 15 Apr 2019 17:50:29 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id G9Tjh0al5O5E5G9Tjhswsi; Mon, 15 Apr 2019 14:49:27 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1hG9Tj-0003Ob-DH; Mon, 15 Apr 2019 14:49:27 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: smbd: take an array of reqeusts when sending upper layer data
Date:   Mon, 15 Apr 2019 14:49:17 -0700
Message-Id: <20190415214917.13011-1-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBRg41gQAKvk5l1EFTc0RL26pOvYIzTzOKYRq6beTkOBT83szseJe8t+h3DS0ioNpkvGbqmxysNN3X8ML8hkb7U+2M5QrTbg3PxzSHH0+Fl9CMHt0axW
 yXM4IbmcvQVKCH+qg6Xgxf9ReBFO+5BnFUb+aERsBRzdttViLkMU5AB++2w+qmgI1bmhU4Qf2w56k8JCr59HHAc74fyZFcX7QG5wWLQYc3OyguS9Q/L3IbHN
 vsznCUDhuR8Sz/lZ/NEuX/XzOpbQk8Fed/eFd61UQvN0E/KlmvoZv3m81Snbo1N3JqTfsk2p3VNqVm1mcXYLfeGvUDETpo/2p23J/A2CZhPBpOkvASsvOeOp
 3rpGuXmPCuP8dFrma3YPOVP9KP1HTA==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

To support compounding, __smb_send_rqst() now sends an array of requests to
the transport layer.
Change smbd_send() to take an array of requests, and send them in as few
packets as possible.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 55 +++++++++++++++++++++++++++--------------------------
 fs/cifs/smbdirect.h |  3 ++-
 fs/cifs/transport.c |  2 +-
 3 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b95354c..272bdf8 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2075,7 +2075,8 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
  * rqst: the data to write
  * return value: 0 if successfully write, otherwise error code
  */
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst_array)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct kvec vec;
@@ -2087,6 +2088,8 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		info->max_send_size - sizeof(struct smbd_data_transfer);
 	struct kvec *iov;
 	int rc;
+	struct smb_rqst *rqst;
+	int rqst_idx;
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		rc = -EAGAIN;
@@ -2094,46 +2097,40 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	}
 
 	/*
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
-	/*
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
@@ -2181,14 +2178,14 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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
@@ -2232,6 +2229,10 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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
index a3c7b3d..9ee7cbf 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -284,7 +284,8 @@ void smbd_destroy(struct TCP_Server_Info *server);
 
 /* Interface for carrying upper layer I/O through send/recv */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst);
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst);
 
 enum mr_state {
 	MR_READY,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 65d9f3e..5c59c49 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -319,7 +319,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		rc = smbd_send(server, rqst);
+		rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 
-- 
2.7.4

