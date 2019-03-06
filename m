Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10949C4360F
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF67F20675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfCFAGR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 19:06:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbfCFAGR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 19:06:17 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4155B811A9;
        Wed,  6 Mar 2019 00:06:17 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-133.bne.redhat.com [10.64.54.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F4705D782;
        Wed,  6 Mar 2019 00:06:16 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/5] cifs: pass flags down into wait_for_free_credits()
Date:   Wed,  6 Mar 2019 10:06:04 +1000
Message-Id: <20190306000607.31787-3-lsahlber@redhat.com>
In-Reply-To: <20190306000607.31787-1-lsahlber@redhat.com>
References: <20190306000607.31787-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 06 Mar 2019 00:06:17 +0000 (UTC)
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

