Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77401C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 06:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F9C2147A
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 06:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfBTGMB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:12:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfBTGMA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Feb 2019 01:12:00 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3430C155AC;
        Wed, 20 Feb 2019 06:12:00 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-96.bne.redhat.com [10.64.54.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89A79600C0;
        Wed, 20 Feb 2019 06:11:59 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/2] cifs: simplify how we handle credits in compond_send_recv()
Date:   Wed, 20 Feb 2019 16:11:45 +1000
Message-Id: <20190220061145.28241-3-lsahlber@redhat.com>
In-Reply-To: <20190220061145.28241-1-lsahlber@redhat.com>
References: <20190220061145.28241-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 20 Feb 2019 06:12:00 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since we can now wait for multiple requests atimically in
wait_for_free_request() we can now greatly simplify the handling
of the credits in this function.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 74 ++++++++++-------------------------------------------
 1 file changed, 13 insertions(+), 61 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 8ce5b6e787c6..b8f2643048e3 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -871,7 +871,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		{ .value = 0, .instance = 0 }
 	};
 	unsigned int instance;
-	unsigned int first_instance = 0;
 	char *buf;
 
 	timeout = flags & CIFS_TIMEOUT_MASK;
@@ -898,71 +897,28 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			spin_unlock(&ses->server->req_lock);
 			return -ENOTSUPP;
 		}
-	} else {
-		/* enough credits to send the whole compounded request */
-		ses->server->credits -= num_rqst;
-		ses->server->in_flight += num_rqst;
-		first_instance = ses->server->reconnect_instance;
 	}
 	spin_unlock(&ses->server->req_lock);
 
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
-		rc = wait_for_free_request(ses->server, timeout, 1, optype,
-					   &instance);
+	rc = wait_for_free_request(ses->server, timeout, num_rqst, optype,
+				   &instance);
 
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
@@ -973,17 +929,13 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
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
-		for (j = 0; j < num_rqst; j++)
-			add_credits(ses->server, &credits[j], optype);
 		return -EAGAIN;
 	}
 
-- 
2.13.6

