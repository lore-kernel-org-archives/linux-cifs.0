Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44668C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2935A61186
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhJEFGE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhJEFGD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:06:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94635C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Z8f4dUKuaaj6WW6TSTFylzXwyNsHQwH8N/ljzXsw7m4=; b=LwRj3sc4/Azigm2pDyLVvy3DOI
        NC1ce6//ZwUFN6xL0zkztStjjAt4gIUw4Dgq7yXmhNa0IAp6dXiQsZaoOsTxgvKLia6n6FqP7oYQ1
        Bm6UUvn1kCix9aGKHlSk5lufcl8XK/+KAymbGkCBUHFUUzHgW/n7NjOPfB2oE1G/Av1b10mJ+PRo8
        41sV0MyF03OwHN6uK7PEbZBMQtVxkRlYhtFz93sF5tslBWPIGlbGUkfn8F5pgZtEqD2SJnQ1OlviB
        uJf6e2aGHL+2w1twEHS5qZ14o21Lk+Pge2y2PQYioSLJRjSPV1li9JXQJjXacpZxZaiyn2riLvCOb
        YzSqABVHRHpqp/YmyIf+K8hemdr0SsskF+fwkC13dI7dNWUMQhL7NiPcmlFxx7DxT8GVYdPX7wX3A
        w+rAxdK0UWnAScalNa8Lt2As2MQrdoWURfuJAEQg/rqzQwCpDHwkclKwTyHGxwH8b9QAKaM67Mp0j
        Y/hDTAi36zEsFOMDr/izHEdh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccd-001Yyq-Hi; Tue, 05 Oct 2021 05:04:11 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v7 8/9] ksmbd: make smb2_check_user_session() callable for compound PDUs
Date:   Tue,  5 Oct 2021 07:03:42 +0200
Message-Id: <20211005050343.268514-9-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2pdu.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1755a524beb3..c137c1a94b99 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -416,7 +416,6 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		work->compound_pfid =
 			le64_to_cpu(((struct smb2_create_rsp *)rsp)->
 				PersistentFileId);
-		work->compound_sid = le64_to_cpu(rsp->SessionId);
 	}
 
 	len = get_rfc1002_len(work->response_buf) - work->next_smb2_rsp_hdr_off;
@@ -596,7 +595,6 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	unsigned int cmd = conn->ops->get_cmd_val(work);
 	unsigned long long sess_id;
 
-	work->sess = NULL;
 	/*
 	 * SMB2_ECHO, SMB2_NEGOTIATE, SMB2_SESSION_SETUP command do not
 	 * require a session id, so no need to validate user session's for
@@ -609,11 +607,25 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	if (!ksmbd_conn_good(work))
 		return -EINVAL;
 
+	if (req_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) {
+		if (work->sess) {
+			pr_err("Missing session\n");
+			return -EINVAL;
+		}
+		return 1;
+	}
+
+	work->sess = NULL;
+	work->compound_sid = 0;
+
 	sess_id = le64_to_cpu(req_hdr->SessionId);
+
 	/* Check for validity of user session */
 	work->sess = ksmbd_session_lookup_all(conn, sess_id);
-	if (work->sess)
+	if (work->sess) {
+		work->compound_sid = sess_id;
 		return 1;
+	}
 	ksmbd_debug(SMB, "Invalid user session, Uid %llu\n", sess_id);
 	return -EINVAL;
 }
-- 
2.31.1

