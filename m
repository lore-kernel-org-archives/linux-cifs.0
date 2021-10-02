Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B21EC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663B761AF7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhJBN11 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN11 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:27 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6BFC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=TK9qiT27d4foHLgTPiXRQKYqkNOpAHE0UzhEoKCwx40=; b=IHkQ/V0HMF6I9Qmmx+07ysI+tK
        GBxTg7hYKfvx+jSJYZTpxWBR8TO5T1mx+VzRbmpKmmDoxRan83tTVOkgDsHjevn3LEozkoxffhJde
        ofJeCbsCnhRcNEr6C/4ce2Zdvs/RvGVfa+dwnwQZV2zXAXAJbRf5az9kBDsXIGrvsfLZyMOCItt6D
        Pzb3cYQb9pV+j0sG1Towv/V1M/+bcIVlBo9hxOwBHYA7Q9js2WJbq0RbyeyKISSXLxybbRHtU7gPj
        3/MShzg1t74OEoFYg9mFAuKfItjiRtNlV/V6qUrI5bJdV9DlTe4LIXvG0sT3Z/1jJMauJlpXi0ZI6
        FEeppVGg3O9AnQFEcvJsCV9kSdSRZP2dRXnf915MRjJqN/spiQT/NiSEDQX6wKNBIIxGdLRgEffES
        nmRhP0A+XZBQJmAh21uEp0g1FxefrWpnyYv1rg4wNR/jqeL38Up+17MSsvWoOuxZesLhbisJa2HD3
        kbQQM87QREQQpGWXt6PRIHkE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoT-001DcY-V1; Sat, 02 Oct 2021 13:12:26 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 12/14] ksmbd: make smb2_check_user_session() callable for compound PDUs
Date:   Sat,  2 Oct 2021 15:12:10 +0200
Message-Id: <20211002131212.130629-13-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
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
index 8cbce9a9c2e0..2f71905503b5 100644
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

