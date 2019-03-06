Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376C2C43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DB8320675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfCFAGY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 19:06:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbfCFAGY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 19:06:24 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1748459447;
        Wed,  6 Mar 2019 00:06:24 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-133.bne.redhat.com [10.64.54.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7820F17187;
        Wed,  6 Mar 2019 00:06:23 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 1/5] cifs: change wait_for_free_request() to take flags as argument
Date:   Wed,  6 Mar 2019 10:06:03 +1000
Message-Id: <20190306000607.31787-2-lsahlber@redhat.com>
In-Reply-To: <20190306000607.31787-1-lsahlber@redhat.com>
References: <20190306000607.31787-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 06 Mar 2019 00:06:24 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and compute timeout and optyp from it.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 849a45d7d732..5c4becefde4b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -529,15 +529,20 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
 }
 
 static int
-wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
-		      const int optype, unsigned int *instance)
+wait_for_free_request(struct TCP_Server_Info *server, const int flags,
+		      unsigned int *instance)
 {
 	int *val;
+	int timeout, optype;
+
+	timeout = flags & CIFS_TIMEOUT_MASK;
+	optype = flags & CIFS_OP_MASK;
 
 	val = server->ops->get_credits_field(server, optype);
 	/* Since an echo is already inflight, no need to wait to send another */
 	if (*val <= 0 && optype == CIFS_ECHO_OP)
 		return -EAGAIN;
+
 	return wait_for_free_credits(server, timeout, val, instance);
 }
 
@@ -637,16 +642,16 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		mid_handle_t *handle, void *cbdata, const int flags,
 		const struct cifs_credits *exist_credits)
 {
-	int rc, timeout, optype;
+	int rc;
 	struct mid_q_entry *mid;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	unsigned int instance;
+	int optype;
 
-	timeout = flags & CIFS_TIMEOUT_MASK;
 	optype = flags & CIFS_OP_MASK;
 
 	if ((flags & CIFS_HAS_CREDITS) == 0) {
-		rc = wait_for_free_request(server, timeout, optype, &instance);
+		rc = wait_for_free_request(server, flags, &instance);
 		if (rc)
 			return rc;
 		credits.value = 1;
@@ -862,8 +867,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   const int flags, const int num_rqst, struct smb_rqst *rqst,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
-	int i, j, rc = 0;
-	int timeout, optype;
+	int i, j, optype, rc = 0;
 	struct mid_q_entry *midQ[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
@@ -873,7 +877,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	unsigned int first_instance = 0;
 	char *buf;
 
-	timeout = flags & CIFS_TIMEOUT_MASK;
 	optype = flags & CIFS_OP_MASK;
 
 	for (i = 0; i < num_rqst; i++)
@@ -924,8 +927,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * Ensure we obtain 1 credit per request in the compound chain.
 	 */
 	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_free_request(ses->server, timeout, optype,
-					   &instance);
+		rc = wait_for_free_request(ses->server, flags, &instance);
 
 		if (rc == 0) {
 			credits[i].value = 1;
@@ -1048,7 +1050,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
 
-	if (timeout == CIFS_ASYNC_OP)
+	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP)
 		goto out;
 
 	for (i = 0; i < num_rqst; i++) {
@@ -1185,7 +1187,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 int
 SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
-	    int *pbytes_returned, const int timeout)
+	    int *pbytes_returned, const int flags)
 {
 	int rc = 0;
 	struct mid_q_entry *midQ;
@@ -1216,7 +1218,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, timeout, 0, &credits.instance);
+	rc = wait_for_free_request(ses->server, flags, &credits.instance);
 	if (rc)
 		return rc;
 
@@ -1255,7 +1257,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc < 0)
 		goto out;
 
-	if (timeout == CIFS_ASYNC_OP)
+	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP)
 		goto out;
 
 	rc = wait_for_response(ses->server, midQ);
@@ -1358,8 +1360,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 0,
-				   &instance);
+	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP, &instance);
 	if (rc)
 		return rc;
 
-- 
2.13.6

