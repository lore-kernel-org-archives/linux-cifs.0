Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECD2C433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8E76136A
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354255AbhJAM1b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJAM1b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:31 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F08CC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=2Dd7ebzVyD7CeByR9fNJuA681xSwAX4KEnum8fBjft8=; b=C3++zGAMYBSV2YyoDiKrANYcio
        oQGhkFyJJE2jYdyH4hJRyhEVCYy8/O/uZt0rLDWpj/Yl8YcVFOKnfXmXv1aCsA2Fo1247iv6xlsrk
        GyJPLZgLxWjyPdv3EodF6sTYbS5iM1onHyBVxCaxO8QC9acRrKMHbJ7zYO5Z3Yvlsb5uBLFAWFIrN
        1G8uRx/YxojJ0a9iNnIYZ/HHqSR2lditoOfj4Z7sb/x0O9msmPNBKN0Hrb7kz5T5iqiD+xBN1dgrH
        Oo98eRVU85i7sD6oKS/zviNQ2b5nBqgmqXC/p29zCs0OYVdIIsvrRYbJZNrbyPYt95kP28mF1Lh/B
        bYcMdOfDfIMg8ke6qm2XMon/IpmSELxxz3Fv1/eoWAeWLCh02UVLuVTMifO94iwNMU3+2Qeq0Q/cr
        PcpW2ZVIoElqeRJckm9kKJMmZfias1c5m5WBvIvJJeRtsk2e2kf90um6ewLBz/FRgPb8vMatQ5mCR
        MfqN2g9n0allN+z2ciw1mgsy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIW-0013Z3-6G; Fri, 01 Oct 2021 12:05:52 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 20/20] ksmdb: move session and tcon validation to ksmbd_smb2_check_message()
Date:   Fri,  1 Oct 2021 14:04:21 +0200
Message-Id: <20211001120421.327245-21-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
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
 fs/ksmbd/server.c   | 17 -----------------
 fs/ksmbd/smb2misc.c | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 328c4225cec1..8b638c701b7f 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -184,23 +184,6 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 541b39b7a84b..d0a3fbf7bc89 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -334,6 +334,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	int command;
 	__u32 clc_len;  /* calculated length */
 	__u32 len = ksmbd_smb2_cur_pdu_buflen(work);
+	int rc;
 
 	if (check_smb2_hdr(hdr))
 		return 1;
@@ -416,6 +417,25 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
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
 	return 0;
 }
 
-- 
2.31.1

