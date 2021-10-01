Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539F5C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7906136A
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354361AbhJAM1n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354363AbhJAM1n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE60C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=nx+VSDjPAv36NdVeMQh27Wf+hqRz60RvTpdQyV8FkwQ=; b=PokOTgRGPPFSyKBDYozdry3njS
        8qfvXEbyN7uaSpPjZbb7LUWx5W/Qu5Ld1o9Y3WQeyjSOFOy6KtcHaGl3ZIA7Qguq8eqmsgDB906mr
        SlloSqF/zhUeigkV7j/lrLNhxjfc2VB2vOp3dQqaVWeN7GIF/uFa1Ie1HnsLP9lhWJRzk91VPeHDp
        4tsvwBuOlvekbykNJEF7ZdgHKv3dDG0RXf2qqIv0rEqILL1F+4SdlEk999JEKdN/Li9yor0zYwPzj
        oTfPNgYORzW9qomtNZANbbiiC5T9jNmvjQr/OF0ICw9FIYx8gJIxXAz4DRhSQE6UGhVDdFsXWNhUd
        AtTjsSrIp7FnjPDT5DDn7hz99sk12OCdAV4r1t9aPiCkejzMis6ypkCcpaehLBpqnM/Q53CJGn9rX
        mV2wsJBAoB21qULrGIT0a9e3KbdJjMw6ENZ50BUNBqs2BqDXvWDregA5+8WoENL9aQHiz5A2ZsTX7
        bNL0wFP3Ivjqn+t8zB903Z19;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIV-0013Z3-Ls; Fri, 01 Oct 2021 12:05:51 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 19/20] ksmbd: make smb2_check_user_session() callabe for compound PDUs
Date:   Fri,  1 Oct 2021 14:04:20 +0200
Message-Id: <20211001120421.327245-20-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
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
 fs/ksmbd/smb2pdu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 5b1fead05c49..ef551e3633db 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -411,7 +411,6 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		work->compound_pfid =
 			le64_to_cpu(((struct smb2_create_rsp *)rsp)->
 				PersistentFileId);
-		work->compound_sid = le64_to_cpu(rsp->SessionId);
 	}
 
 	len = get_rfc1002_len(work->response_buf) - work->next_smb2_rsp_hdr_off;
@@ -592,6 +591,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	unsigned long long sess_id;
 
 	work->sess = NULL;
+	work->compound_sid = 0;
+
 	/*
 	 * SMB2_ECHO, SMB2_NEGOTIATE, SMB2_SESSION_SETUP command do not
 	 * require a session id, so no need to validate user session's for
@@ -604,11 +605,17 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	if (!ksmbd_conn_good(work))
 		return -EINVAL;
 
-	sess_id = le64_to_cpu(req_hdr->SessionId);
+	if (req_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS)
+		sess_id = work->compound_sid;
+	else
+		sess_id = le64_to_cpu(req_hdr->SessionId);
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

