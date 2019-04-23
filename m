Return-Path: <SRS0=YW4u=SZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1E6C10F14
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Apr 2019 03:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1AD220811
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Apr 2019 03:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfDWD16 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Apr 2019 23:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfDWD16 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Apr 2019 23:27:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2104E369D2;
        Tue, 23 Apr 2019 03:27:58 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A07E16013B;
        Tue, 23 Apr 2019 03:27:57 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
Date:   Tue, 23 Apr 2019 13:27:49 +1000
Message-Id: <20190423032749.30799-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 23 Apr 2019 03:27:58 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5c59c498f56a..3b80884ddf0f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -971,7 +971,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   const int flags, const int num_rqst, struct smb_rqst *rqst,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
-	int i, j, optype, rc = 0;
+	int i, j, optype, opmask, rc = 0;
 	struct mid_q_entry *midQ[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
@@ -981,6 +981,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	char *buf;
 
 	optype = flags & CIFS_OP_MASK;
+	opmask = flags & (CIFS_ASYNC_OP|CIFS_NO_RESP);
 
 	for (i = 0; i < num_rqst; i++)
 		resp_buf_type[i] = CIFS_NO_BUFFER;  /* no response buf yet */
@@ -1073,8 +1074,13 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_unlock(&ses->server->srv_mutex);
 
-	if (rc < 0) {
-		/* Sending failed for some reason - return credits back */
+	/*
+	 * If sending failed for some reason or it is an oplock break that we
+	 * will not receive a response to - return credits back
+	 */
+	if (rc < 0 ||
+	    (optype == CIFS_OBREAK_OP &&
+	     opmask == (CIFS_ASYNC_OP|CIFS_NO_RESP))) {
 		for (i = 0; i < num_rqst; i++)
 			add_credits(ses->server, &credits[i], optype);
 		goto out;
-- 
2.13.6

