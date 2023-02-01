Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4BAC05027
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Feb 2023 12:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjBAMFl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Feb 2023 07:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBAMFk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Feb 2023 07:05:40 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499DF2CC60
        for <linux-cifs@vger.kernel.org>; Wed,  1 Feb 2023 04:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=IMxYJ0tVCTl6eqGyHVw2KnyRPFh2LXUpr+XpcPOHyVg=; b=owU/RjKkGiDny/ROzMtyu1cYlR
        I1RzcXLOCLBNZt9/inWdeGHMc6z65vm/sGEPDTmyg6WW+xNA8g5gIJCYaadMMRT0qSXBK2wZOPpS+
        paVV1RZsQXmEryAjARAJrbAMlkaUoQnAJvxRGXV766vZj1ItZYWf7F5uZvFAGCyUHbZi6eADHTFy5
        QPuW6PE2Kn7jtRjX9O84RGPoJe/ruDtF+uJFuiwch3Y9HKRfDMO0JH+hk5rdXcGrbNZ3lY6cGndB8
        o53J2B5jS/+39NyCCqkRVE2PGeafl7xzyoXlBY0HyCXI4vkcsX1qew424EyntDIhAtAMMYQcmInSD
        OitRqAfsBjJBEHYO3uMmBIl9QTtCn7pOOHWGCdW5UW8WrubVlZev/5L8ba2NCcWm/0YMYofR26gbG
        chVUkmlnlfD5kXBEH4SsXGud48/tXj6iQKXv+OCOJIXOx2UlMhGGJ6B1iFU3sVOL6UgEwFkmCmrQ+
        M5yT26etAdVZ0VTRUzP7J7wz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNBrq-00BE69-Fe; Wed, 01 Feb 2023 12:05:34 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 2/3] cifs: split out smb3_use_rdma_offload() helper
Date:   Wed,  1 Feb 2023 13:04:42 +0100
Message-Id: <d393687816f6913a026c2c0d66553cc23d3e42b1.1675252643.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1675252643.git.metze@samba.org>
References: <cover.1675252643.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We should have the logic to decide if we want rdma offload
in a single spot in order to advance it in future.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/smb2pdu.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 64e2c8b438f4..6a4d621241dd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4063,6 +4063,32 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	return rc;
 }
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
+static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
+{
+	struct TCP_Server_Info *server = io_parms->server;
+	struct cifs_tcon *tcon = io_parms->tcon;
+
+	/* we can only offload if we're connected */
+	if (!server || !tcon)
+		return false;
+
+	/* we can only offload on an rdma connection */
+	if (!server->rdma || !server->smbd_conn)
+		return false;
+
+	/* we don't support signed offload yet */
+	if (server->sign)
+		return false;
+
+	/* offload also has its overhead, so only do it if desired */
+	if (io_parms->length < server->smbd_conn->rdma_readwrite_threshold)
+		return false;
+
+	return true;
+}
+#endif /* CONFIG_CIFS_SMB_DIRECT */
+
 /*
  * To form a chain of read requests, any read requests after the first should
  * have the end_of_chain boolean set to true.
@@ -4106,9 +4132,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	 * If we want to do a RDMA write, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of read request
 	 */
-	if (server->rdma && rdata && !server->sign &&
-		rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
-
+	if (smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
@@ -4558,9 +4582,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	 * If we want to do a server RDMA read, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of write request
 	 */
-	if (server->rdma && !server->sign && io_parms->length >=
-		server->smbd_conn->rdma_readwrite_threshold) {
-
+	if (smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-- 
2.34.1

