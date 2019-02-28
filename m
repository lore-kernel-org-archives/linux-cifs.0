Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1144AC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 06:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25CA21850
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 06:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbfB1GYS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:24:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfB1GYS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Feb 2019 01:24:18 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6060930C7543;
        Thu, 28 Feb 2019 06:24:18 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-37.bne.redhat.com [10.64.54.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9C8568D7A;
        Thu, 28 Feb 2019 06:24:17 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/5] cifs: pass flags down into wait_for_free_credits()
Date:   Thu, 28 Feb 2019 16:24:02 +1000
Message-Id: <20190228062405.32107-3-lsahlber@redhat.com>
In-Reply-To: <20190228062405.32107-1-lsahlber@redhat.com>
References: <20190228062405.32107-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 28 Feb 2019 06:24:18 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5c4becefde4b..8887db2cd582 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -477,15 +477,24 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 }
 
 static int
-wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
-		      int *credits, unsigned int *instance)
+wait_for_free_credits(struct TCP_Server_Info *server, const int flags,
+		      unsigned int *instance)
 {
 	int rc;
+	int *credits;
+	int optype;
+
+	optype = flags & CIFS_OP_MASK;
 
 	*instance = 0;
 
+	credits = server->ops->get_credits_field(server, optype);
+	/* Since an echo is already inflight, no need to wait to send another */
+	if (*credits <= 0 && optype == CIFS_ECHO_OP)
+		return -EAGAIN;
+
 	spin_lock(&server->req_lock);
-	if (timeout == CIFS_ASYNC_OP) {
+	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
 		server->in_flight++;
 		*credits -= 1;
@@ -516,7 +525,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
 			 */
 
 			/* update # of requests on the wire to server */
-			if (timeout != CIFS_BLOCKING_OP) {
+			if ((flags & CIFS_TIMEOUT_MASK) != CIFS_BLOCKING_OP) {
 				*credits -= 1;
 				server->in_flight++;
 				*instance = server->reconnect_instance;
@@ -532,18 +541,7 @@ static int
 wait_for_free_request(struct TCP_Server_Info *server, const int flags,
 		      unsigned int *instance)
 {
-	int *val;
-	int timeout, optype;
-
-	timeout = flags & CIFS_TIMEOUT_MASK;
-	optype = flags & CIFS_OP_MASK;
-
-	val = server->ops->get_credits_field(server, optype);
-	/* Since an echo is already inflight, no need to wait to send another */
-	if (*val <= 0 && optype == CIFS_ECHO_OP)
-		return -EAGAIN;
-
-	return wait_for_free_credits(server, timeout, val, instance);
+	return wait_for_free_credits(server, flags, instance);
 }
 
 int
-- 
2.13.6

