Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2835DC43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 04:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE1520675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 04:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfCFEQD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 23:16:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfCFEQD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 23:16:03 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40205308222E;
        Wed,  6 Mar 2019 04:16:03 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-133.bne.redhat.com [10.64.54.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0645F90E;
        Wed,  6 Mar 2019 04:16:02 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 5/6] cifs: add a timeout argument to wait_for_free_credits
Date:   Wed,  6 Mar 2019 14:15:45 +1000
Message-Id: <20190306041546.10419-6-lsahlber@redhat.com>
In-Reply-To: <20190306041546.10419-1-lsahlber@redhat.com>
References: <20190306041546.10419-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 06 Mar 2019 04:16:03 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A negative timeout is the same as the current behaviour, i.e. no timeout.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f4ec9635dab2..3263e8b3a57d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -478,11 +478,18 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 
 static int
 wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
-		      const int flags, unsigned int *instance)
+		      const int timeout, const int flags,
+		      unsigned int *instance)
 {
 	int rc;
 	int *credits;
 	int optype;
+	long int t;
+
+	if (timeout < 0)
+		t = MAX_JIFFY_OFFSET;
+	else
+		t = msecs_to_jiffies(timeout);
 
 	optype = flags & CIFS_OP_MASK;
 
@@ -507,11 +514,16 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		if (*credits < num_credits) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
-			rc = wait_event_killable(server->request_q,
-				has_credits(server, credits, num_credits));
+			rc = wait_event_killable_timeout(server->request_q,
+				has_credits(server, credits, num_credits), t);
 			cifs_num_waiters_dec(server);
-			if (rc)
-				return rc;
+			if (!rc) {
+				cifs_dbg(VFS, "wait timed out after %d ms\n",
+					 timeout);
+				return -EAGAIN;
+			}
+			if (rc == -ERESTARTSYS)
+				return -ERESTARTSYS;
 			spin_lock(&server->req_lock);
 		} else {
 			if (server->tcpStatus == CifsExiting) {
@@ -537,12 +549,19 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 			    *credits <= MAX_COMPOUND) {
 				spin_unlock(&server->req_lock);
 				cifs_num_waiters_inc(server);
-				rc = wait_event_killable(server->request_q,
+				rc = wait_event_killable_timeout(
+					server->request_q,
 					has_credits(server, credits,
-						    MAX_COMPOUND + 1));
+						    MAX_COMPOUND + 1),
+					t);
 				cifs_num_waiters_dec(server);
-				if (rc)
-					return rc;
+				if (!rc) {
+					cifs_dbg(VFS, "wait timed out after %d ms\n",
+						 timeout);
+					return -EAGAIN;
+				}
+				if (rc == -ERESTARTSYS)
+					return -ERESTARTSYS;
 				spin_lock(&server->req_lock);
 				continue;
 			}
@@ -569,7 +588,8 @@ static int
 wait_for_free_request(struct TCP_Server_Info *server, const int flags,
 		      unsigned int *instance)
 {
-	return wait_for_free_credits(server, 1, flags, instance);
+	return wait_for_free_credits(server, 1, -1, flags,
+				     instance);
 }
 
 int
-- 
2.13.6

