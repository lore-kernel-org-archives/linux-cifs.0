Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C0CC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328B961A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354363AbhJAM1q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354364AbhJAM1q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98DAC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=skH0ba/C/5YHeOyjYMYNshVkPL7AAa9MhtVOWwxAoyg=; b=1vEOdG4+YuKAYtGEqI+RvE1oW6
        WXpQYPeU/Xwl81ECV83fNYkFTmchzvOyAkGZvTittWRKjHJfAsAdfwNQNKVIPC28sb/RALExMQH1p
        O2ITDnJqmmYVp4w0+zORcm6GtRl+nDoUzo7CC6byuGhNQslhX0EQ8xjGgNpH5dc6wyoPRfAS3dWuT
        YPwyyxG7odLxM2qL0h7rTLC0nNUVUylYZJj1wSwh8OzVA+DMuE4AzQJ/wV99lcJkdiNSa7BKRWrgi
        l2HS1YKGrtAN+ycWRSejZbib7EK+Ms8Bzo9gcl2gjPp0ef8At+f2PfiruErysJd9aaFc8h0Ds/0J1
        hQO1Xe/mC9VkNt/Brr8375fNp1IFIN3j8/FSzx5rHXyNWDhFCMXwURtLUAigMHfV8ZRHB1d9UG0wn
        jPn9ulUP9zdW92KEbpaUd5N0CBzHlGufrrq8y1wtp7+8kBj/FX3EE8dh+qRIWhYsxbfIU+IoVIJNQ
        0zkZX9GjA3W0xmMa1acvq8Pc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIS-0013Z3-AB; Fri, 01 Oct 2021 12:05:48 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 13/20] ksmbd: remove ksmbd_verify_smb_message()
Date:   Fri,  1 Oct 2021 14:04:14 +0200
Message-Id: <20211001120421.327245-14-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Another leftover from SMB1 support. Remove it and use ksmbd_verify_smb_message()
directly in __process_request().

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/server.c     |  2 +-
 fs/ksmbd/smb_common.c | 24 ------------------------
 fs/ksmbd/smb_common.h |  1 -
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 2a2b2135bfde..328c4225cec1 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -114,7 +114,7 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	if (check_conn_state(work))
 		return SERVER_HANDLER_CONTINUE;
 
-	if (ksmbd_verify_smb_message(work))
+	if (ksmbd_smb2_check_message(work))
 		return SERVER_HANDLER_ABORT;
 
 	command = conn->ops->get_cmd_val(work);
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index e1e5a071678e..4a283cd6d6e1 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -122,30 +122,6 @@ int ksmbd_lookup_protocol_idx(char *str)
 	return -1;
 }
 
-/**
- * ksmbd_verify_smb_message() - check for valid smb2 request header
- * @work:	smb work
- *
- * check for valid smb signature and packet direction(request/response)
- *
- * Return:      0 on success, otherwise -EINVAL
- */
-int ksmbd_verify_smb_message(struct ksmbd_work *work)
-{
-	struct smb2_hdr *smb2_hdr = ksmbd_req_buf_next(work);
-	struct smb_hdr *hdr;
-
-	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
-		return ksmbd_smb2_check_message(work);
-
-	hdr = work->request_buf;
-	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
-	    hdr->Command == SMB_COM_NEGOTIATE)
-		return 0;
-
-	return -EINVAL;
-}
-
 /**
  * ksmbd_smb_request() - check for valid smb request type
  * @conn:	connection instance
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 6e79e7577f6b..782c06292020 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -488,7 +488,6 @@ int ksmbd_max_protocol(void);
 
 int ksmbd_lookup_protocol_idx(char *str);
 
-int ksmbd_verify_smb_message(struct ksmbd_work *work);
 bool ksmbd_smb_request(struct ksmbd_conn *conn);
 
 int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
-- 
2.31.1

