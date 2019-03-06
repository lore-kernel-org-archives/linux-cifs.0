Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9247AC43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 04:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C4F920675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 04:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfCFEQA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 23:16:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfCFEQA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 23:16:00 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B55322D7E7;
        Wed,  6 Mar 2019 04:15:59 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-133.bne.redhat.com [10.64.54.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 206C0608C1;
        Wed,  6 Mar 2019 04:15:58 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 3/6] cifs: wait_for_free_credits() make it possible to wait for >=1 credits
Date:   Wed,  6 Mar 2019 14:15:43 +1000
Message-Id: <20190306041546.10419-4-lsahlber@redhat.com>
In-Reply-To: <20190306041546.10419-1-lsahlber@redhat.com>
References: <20190306041546.10419-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 06 Mar 2019 04:15:59 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change wait_for_free_credits() to allow waiting for >=1 credits instead of just
a single credit.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h  |  4 ++--
 fs/cifs/smb2ops.c   |  2 +-
 fs/cifs/transport.c | 14 +++++++-------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 31c63e7437fd..bc2bb14b2180 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -734,13 +734,13 @@ in_flight(struct TCP_Server_Info *server)
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
index 1243407c9546..15bc7953b7a6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -185,7 +185,7 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-					has_credits(server, &server->credits));
+				has_credits(server, &server->credits, 1));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 8887db2cd582..baf15194aa3d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -477,8 +477,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 }
 
 static int
-wait_for_free_credits(struct TCP_Server_Info *server, const int flags,
-		      unsigned int *instance)
+wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
+		      const int flags, unsigned int *instance)
 {
 	int rc;
 	int *credits;
@@ -504,11 +504,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int flags,
 	}
 
 	while (1) {
-		if (*credits <= 0) {
+		if (*credits < num_credits) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-						 has_credits(server, credits));
+				has_credits(server, credits, num_credits));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
@@ -526,8 +526,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int flags,
 
 			/* update # of requests on the wire to server */
 			if ((flags & CIFS_TIMEOUT_MASK) != CIFS_BLOCKING_OP) {
-				*credits -= 1;
-				server->in_flight++;
+				*credits -= num_credits;
+				server->in_flight += num_credits;
 				*instance = server->reconnect_instance;
 			}
 			spin_unlock(&server->req_lock);
@@ -541,7 +541,7 @@ static int
 wait_for_free_request(struct TCP_Server_Info *server, const int flags,
 		      unsigned int *instance)
 {
-	return wait_for_free_credits(server, flags, instance);
+	return wait_for_free_credits(server, 1, flags, instance);
 }
 
 int
-- 
2.13.6

