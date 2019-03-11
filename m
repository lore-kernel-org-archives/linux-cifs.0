Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881D3C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 02:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50CD320652
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 02:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfCKCTL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 10 Mar 2019 22:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfCKCTL (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 10 Mar 2019 22:19:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06774882F5;
        Mon, 11 Mar 2019 02:19:11 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-95.bne.redhat.com [10.64.54.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AC80600CC;
        Mon, 11 Mar 2019 02:19:10 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 6/6] cifs: simplify how we handle credits in compond_send_recv()
Date:   Mon, 11 Mar 2019 12:18:58 +1000
Message-Id: <20190311021858.1504-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 11 Mar 2019 02:19:11 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since we can now wait for multiple requests atomically in
wait_for_free_request() we can now greatly simplify the handling
of the credits in this function.

This fixes a potential deadlock where many concurrent compound requests
could each have reserved 1 or 2 credits each but are all blocked
waiting for the final credits they need to be able to issue the requests
to the server.

Set a default timeout of 60 seconds for compounded requests.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 110 ++++++++++++++++++----------------------------------
 1 file changed, 38 insertions(+), 72 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 62c58ce80123..5539c5c8ed75 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -592,6 +592,31 @@ wait_for_free_request(struct TCP_Server_Info *server, const int flags,
 				     instance);
 }
 
+static int
+wait_for_compound_request(struct TCP_Server_Info *server, int num,
+			  const int flags, unsigned int *instance)
+{
+	int *credits;
+
+	credits = server->ops->get_credits_field(server, flags & CIFS_OP_MASK);
+
+	spin_lock(&server->req_lock);
+	if (*credits < num) {
+		/*
+		 * Return immediately if not too many requests in flight since
+		 * we will likely be stuck on waiting for credits.
+		 */
+		if (server->in_flight < num - *credits) {
+			spin_unlock(&server->req_lock);
+			return -ENOTSUPP;
+		}
+	}
+	spin_unlock(&server->req_lock);
+
+	return wait_for_free_credits(server, num, 60000, flags,
+				     instance);
+}
+
 int
 cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 		      unsigned int *num, struct cifs_credits *credits)
@@ -920,7 +945,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		{ .value = 0, .instance = 0 }
 	};
 	unsigned int instance;
-	unsigned int first_instance = 0;
 	char *buf;
 
 	optype = flags & CIFS_OP_MASK;
@@ -936,80 +960,24 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	if (ses->server->tcpStatus == CifsExiting)
 		return -ENOENT;
 
-	spin_lock(&ses->server->req_lock);
-	if (ses->server->credits < num_rqst) {
-		/*
-		 * Return immediately if not too many requests in flight since
-		 * we will likely be stuck on waiting for credits.
-		 */
-		if (ses->server->in_flight < num_rqst - ses->server->credits) {
-			spin_unlock(&ses->server->req_lock);
-			return -ENOTSUPP;
-		}
-	} else {
-		/* enough credits to send the whole compounded request */
-		ses->server->credits -= num_rqst;
-		ses->server->in_flight += num_rqst;
-		first_instance = ses->server->reconnect_instance;
-	}
-	spin_unlock(&ses->server->req_lock);
-
-	if (first_instance) {
-		cifs_dbg(FYI, "Acquired %d credits at once\n", num_rqst);
-		for (i = 0; i < num_rqst; i++) {
-			credits[i].value = 1;
-			credits[i].instance = first_instance;
-		}
-		goto setup_rqsts;
-	}
-
 	/*
-	 * There are not enough credits to send the whole compound request but
-	 * there are requests in flight that may bring credits from the server.
+	 * Wait for all the requests to become available.
 	 * This approach still leaves the possibility to be stuck waiting for
 	 * credits if the server doesn't grant credits to the outstanding
-	 * requests. This should be fixed by returning immediately and letting
-	 * a caller fallback to sequential commands instead of compounding.
-	 * Ensure we obtain 1 credit per request in the compound chain.
+	 * requests and if the client is completely idle, not generating any
+	 * other requests.
+	 * This can be handled by the eventual session reconnect.
 	 */
-	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_free_request(ses->server, flags, &instance);
-
-		if (rc == 0) {
-			credits[i].value = 1;
-			credits[i].instance = instance;
-			/*
-			 * All parts of the compound chain must get credits from
-			 * the same session, otherwise we may end up using more
-			 * credits than the server granted. If there were
-			 * reconnects in between, return -EAGAIN and let callers
-			 * handle it.
-			 */
-			if (i == 0)
-				first_instance = instance;
-			else if (first_instance != instance) {
-				i++;
-				rc = -EAGAIN;
-			}
-		}
+	rc = wait_for_compound_request(ses->server, num_rqst, flags,
+				       &instance);
+	if (rc)
+		return rc;
 
-		if (rc) {
-			/*
-			 * We haven't sent an SMB packet to the server yet but
-			 * we already obtained credits for i requests in the
-			 * compound chain - need to return those credits back
-			 * for future use. Note that we need to call add_credits
-			 * multiple times to match the way we obtained credits
-			 * in the first place and to account for in flight
-			 * requests correctly.
-			 */
-			for (j = 0; j < i; j++)
-				add_credits(ses->server, &credits[j], optype);
-			return rc;
-		}
+	for (i = 0; i < num_rqst; i++) {
+		credits[i].value = 1;
+		credits[i].instance = instance;
 	}
 
-setup_rqsts:
 	/*
 	 * Make sure that we sign in the same order that we send on this socket
 	 * and avoid races inside tcp sendmsg code that could cause corruption
@@ -1020,14 +988,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	/*
 	 * All the parts of the compound chain belong obtained credits from the
-	 * same session (see the appropriate checks above). In the same time
-	 * there might be reconnects after those checks but before we acquired
-	 * the srv_mutex. We can not use credits obtained from the previous
+	 * same session. We can not use credits obtained from the previous
 	 * session to send this request. Check if there were reconnects after
 	 * we obtained credits and return -EAGAIN in such cases to let callers
 	 * handle it.
 	 */
-	if (first_instance != ses->server->reconnect_instance) {
+	if (instance != ses->server->reconnect_instance) {
 		mutex_unlock(&ses->server->srv_mutex);
 		for (j = 0; j < num_rqst; j++)
 			add_credits(ses->server, &credits[j], optype);
-- 
2.13.6

