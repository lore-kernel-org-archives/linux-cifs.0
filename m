Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D336C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 06:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438602147A
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 06:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfBTGL5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfBTGL4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Feb 2019 01:11:56 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 222185A1E3;
        Wed, 20 Feb 2019 06:11:56 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-96.bne.redhat.com [10.64.54.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 425015DF29;
        Wed, 20 Feb 2019 06:11:54 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 1/2] cifs: change wait_for_free_request to take number of requests to wait for
Date:   Wed, 20 Feb 2019 16:11:44 +1000
Message-Id: <20190220061145.28241-2-lsahlber@redhat.com>
In-Reply-To: <20190220061145.28241-1-lsahlber@redhat.com>
References: <20190220061145.28241-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 20 Feb 2019 06:11:56 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change wait_for_free_request to allow specifying how many requests(credits)
to wait for.
Pass 1 from all callsites.

This should not change any behavior but will allow future callers to
atomically wait for >1 requests.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h  |  4 ++--
 fs/cifs/smb2ops.c   |  2 +-
 fs/cifs/transport.c | 25 ++++++++++++++-----------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5bf463c2d9dc..1b3f62eee4d0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -732,13 +732,13 @@ in_flight(struct TCP_Server_Info *server)
 }
 
 static inline bool
-has_credits(struct TCP_Server_Info *server, int *credits)
+has_credits(struct TCP_Server_Info *server, int *credits, int num_credits)
 {
 	int num;
 	spin_lock(&server->req_lock);
 	num = *credits;
 	spin_unlock(&server->req_lock);
-	return num > 0;
+	return num >= num_credits;
 }
 
 static inline void
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 080929a64c64..372a3563b79b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -185,7 +185,7 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-					has_credits(server, &server->credits));
+				 has_credits(server, &server->credits, 1));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d4f1224fb7cb..8ce5b6e787c6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -478,7 +478,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 
 static int
 wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
-		      int *credits, unsigned int *instance)
+		      int num_credits, int *credits,
+		      unsigned int *instance)
 {
 	int rc;
 
@@ -495,11 +496,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
 	}
 
 	while (1) {
-		if (*credits <= 0) {
+		if (*credits < num_credits) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-						 has_credits(server, credits));
+				 has_credits(server, credits, num_credits));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
@@ -517,8 +518,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
 
 			/* update # of requests on the wire to server */
 			if (timeout != CIFS_BLOCKING_OP) {
-				*credits -= 1;
-				server->in_flight++;
+				*credits -= num_credits;
+				server->in_flight += num_credits;
 				*instance = server->reconnect_instance;
 			}
 			spin_unlock(&server->req_lock);
@@ -530,7 +531,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
 
 static int
 wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
-		      const int optype, unsigned int *instance)
+		      int num, const int optype, unsigned int *instance)
 {
 	int *val;
 
@@ -538,7 +539,7 @@ wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
 	/* Since an echo is already inflight, no need to wait to send another */
 	if (*val <= 0 && optype == CIFS_ECHO_OP)
 		return -EAGAIN;
-	return wait_for_free_credits(server, timeout, val, instance);
+	return wait_for_free_credits(server, timeout, num, val, instance);
 }
 
 int
@@ -646,7 +647,8 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	optype = flags & CIFS_OP_MASK;
 
 	if ((flags & CIFS_HAS_CREDITS) == 0) {
-		rc = wait_for_free_request(server, timeout, optype, &instance);
+		rc = wait_for_free_request(server, timeout, 1, optype,
+					   &instance);
 		if (rc)
 			return rc;
 		credits.value = 1;
@@ -923,7 +925,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * Ensure we obtain 1 credit per request in the compound chain.
 	 */
 	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_free_request(ses->server, timeout, optype,
+		rc = wait_for_free_request(ses->server, timeout, 1, optype,
 					   &instance);
 
 		if (rc == 0) {
@@ -1212,7 +1214,8 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, timeout, 0, &credits.instance);
+	rc = wait_for_free_request(ses->server, timeout, 1, 0,
+				   &credits.instance);
 	if (rc)
 		return rc;
 
@@ -1354,7 +1357,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 0,
+	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 1, 0,
 				   &instance);
 	if (rc)
 		return rc;
-- 
2.13.6

