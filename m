Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F48C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 781EC61AF7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhJBN1K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C229EC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Umiz6jNkxJhh7bHGki0vDMexgYdOtVbyRz8bFzWT1jc=; b=Lk0VTeAgSFWPWMHbUAzTrDEHa4
        beP/7+UqMXiQf6Tkmeqy5AtkJtCMc1dRJp1zjyrsaxzxmEPR7MuNY9vHnSs9jlrVzDhpq+2DpezV3
        Up/1PXS/qlvAitXSsWyBOVggexodOLW0VVWeGE2/stbYmFPJAMjEDupAmGjOgLihcfkVY2LiKXzGV
        BqKWqq6WWq6gTGanbL4WylPG6+I9GXLQv4D8PjuKSn+cMV8vva85+/u8ATfMSOt7eqM4HDncmf+g3
        tSsraY2NaaW6/QFlLABfonyyEQsFDYIQkULWSqV/UjvAK290o04YR64eGmCda7p3o3GoeQoBawO28
        hnz0acNRAESjyrfotaEEEuV57cp7E6TKryoAiwfphkHnnzRxcb40MZImekQYnIu5k58Au2U1S5D0k
        duXYA+BEWH50ZRrXD+BxIXiKharIUBVWN5i7dsXz6NYUjkywgv04+N6gbkzpQnqHc4yA3i04mdB8W
        7y4rjL5B1JK1zkVfjDPBnRft;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoU-001DcY-Ie; Sat, 02 Oct 2021 13:12:26 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 13/14] ksmdb: move session and tcon validation to ksmbd_smb2_check_message()
Date:   Sat,  2 Oct 2021 15:12:11 +0200
Message-Id: <20211002131212.130629-14-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

For compound non-related operations session id and tree id must be taken from
earch PDU.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/server.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 2a2b2135bfde..5d1ef277653f 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -101,6 +101,32 @@ static inline int check_conn_state(struct ksmbd_work *work)
 	return 0;
 }
 
+static int check_session_and_tcon(struct ksmbd_work *work)
+{
+	int rc;
+
+	if (work->conn->ops->check_user_session == NULL)
+		return 0;
+
+	rc = work->conn->ops->check_user_session(work);
+	if (rc < 0) {
+		work->conn->ops->set_rsp_status(work,
+						STATUS_USER_SESSION_DELETED);
+		return 1;
+	}
+	if (rc == 0)
+		return 0;
+
+	rc = work->conn->ops->get_ksmbd_tcon(work);
+	if (rc < 0) {
+		work->conn->ops->set_rsp_status(work,
+						STATUS_NETWORK_NAME_DELETED);
+		return 1;
+	}
+
+	return 0;
+}
+
 #define SERVER_HANDLER_CONTINUE		0
 #define SERVER_HANDLER_ABORT		1
 
@@ -117,6 +143,9 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	if (ksmbd_verify_smb_message(work))
 		return SERVER_HANDLER_ABORT;
 
+	if (check_session_and_tcon(work))
+		return SERVER_HANDLER_ABORT;
+
 	command = conn->ops->get_cmd_val(work);
 	*cmd = command;
 
@@ -184,23 +213,6 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 		goto send;
 	}
 
-	if (conn->ops->check_user_session) {
-		rc = conn->ops->check_user_session(work);
-		if (rc < 0) {
-			command = conn->ops->get_cmd_val(work);
-			conn->ops->set_rsp_status(work,
-					STATUS_USER_SESSION_DELETED);
-			goto send;
-		} else if (rc > 0) {
-			rc = conn->ops->get_ksmbd_tcon(work);
-			if (rc < 0) {
-				conn->ops->set_rsp_status(work,
-					STATUS_NETWORK_NAME_DELETED);
-				goto send;
-			}
-		}
-	}
-
 	do {
 		rc = __process_request(work, conn, &command);
 		if (rc == SERVER_HANDLER_ABORT)
-- 
2.31.1

