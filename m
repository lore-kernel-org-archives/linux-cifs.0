Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35009C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 08:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E26361053
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 08:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhJMIqg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:46:36 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:52890 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbhJMIqd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Oct 2021 04:46:33 -0400
Received: by mail-pj1-f50.google.com with SMTP id oa4so1659990pjb.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Oct 2021 01:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lI9jQrBfRsnWfyp2k7WbB7rQukSCScdfFndqD8TYlxM=;
        b=hn3moPPLoycQN6MZpzU7GZbxZmZzl5dzTZrj2uWaQjlXy4f+1dGNw1EVPLSk9tdEcq
         9RLwf1lBUBs78odQCK1ENxlTNTbIZetMVSwL8wyJwnApKCpSlOaSD/h/ERbPKGphhpjG
         UJx9qAfRVErbxvgWKSz+kUgnaaxWeQjRGL9diBCAGhYJnoC1TtdtqYbfd5mg2Y+lXY6l
         0CdxVbo/1/Lw6pTtL0NPVO0e3MTm45yzZgv8e8VpwORZXsE2JwsYmwN8HPjgSPPar906
         Pz99oGTJNOKaITuxYGJGyirZw3W4QSjXajjrtEVwekaWcwdsdnZEgmfDdx35d8ao/k6i
         wfnA==
X-Gm-Message-State: AOAM533ibyWzhNegm3SHetQtRSnSQ0fGGG7NuwPQ5ps815m39H7xEXMW
        GjLxVDxAIsZzYzc33gxYq4ReG6bPHRYGuQ==
X-Google-Smtp-Source: ABdhPJwzc42xe/2KxanYnhvpOKeJKjwZJzwElRdDZt8wv0s2wrVJ2XM5j92OF1aPcy0zUXaPdX2kvg==
X-Received: by 2002:a17:90b:3a88:: with SMTP id om8mr11080162pjb.164.1634114669610;
        Wed, 13 Oct 2021 01:44:29 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s2sm5480563pjs.56.2021.10.13.01.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 01:44:29 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: throttle session setup failures to avoid dictionary attacks
Date:   Wed, 13 Oct 2021 17:44:21 +0900
Message-Id: <20211013084421.22608-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To avoid dictionary attacks (repeated session setups rapidly sent) to
connect to server, ksmbd make a delay of a 5 seconds on session setup
failure to make it harder to send enough random connection requests
to break into a server if a user insert the wrong password 10 times
in a row.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/ksmbd_netlink.h    |  2 ++
 fs/ksmbd/mgmt/user_config.c |  2 +-
 fs/ksmbd/mgmt/user_config.h |  1 +
 fs/ksmbd/smb2pdu.c          | 27 ++++++++++++++++++++++++---
 fs/ksmbd/transport_ipc.c    |  3 ++-
 fs/ksmbd/transport_ipc.h    |  2 +-
 6 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index 2fbe2bc1e093..c6718a05d347 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -211,6 +211,7 @@ struct ksmbd_tree_disconnect_request {
  */
 struct ksmbd_logout_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ]; /* user account name */
+	__u32	account_flags;
 };
 
 /*
@@ -317,6 +318,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_USER_FLAG_BAD_UID		BIT(2)
 #define KSMBD_USER_FLAG_BAD_USER	BIT(3)
 #define KSMBD_USER_FLAG_GUEST_ACCOUNT	BIT(4)
+#define KSMBD_USER_FLAG_DELAY_SESSION	BIT(5)
 
 /*
  * Share config flags.
diff --git a/fs/ksmbd/mgmt/user_config.c b/fs/ksmbd/mgmt/user_config.c
index d21629ae5c89..1019d3677d55 100644
--- a/fs/ksmbd/mgmt/user_config.c
+++ b/fs/ksmbd/mgmt/user_config.c
@@ -55,7 +55,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp)
 
 void ksmbd_free_user(struct ksmbd_user *user)
 {
-	ksmbd_ipc_logout_request(user->name);
+	ksmbd_ipc_logout_request(user->name, user->flags);
 	kfree(user->name);
 	kfree(user->passkey);
 	kfree(user);
diff --git a/fs/ksmbd/mgmt/user_config.h b/fs/ksmbd/mgmt/user_config.h
index b2bb074a0150..44c3e954f9c6 100644
--- a/fs/ksmbd/mgmt/user_config.h
+++ b/fs/ksmbd/mgmt/user_config.h
@@ -18,6 +18,7 @@ struct ksmbd_user {
 
 	size_t			passkey_sz;
 	char			*passkey;
+	unsigned int		failed_login_count;
 };
 
 static inline bool user_guest(struct ksmbd_user *user)
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 89c187aa8db2..050ca60abe72 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1779,9 +1779,30 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		conn->mechToken = NULL;
 	}
 
-	if (rc < 0 && sess) {
-		ksmbd_session_destroy(sess);
-		work->sess = NULL;
+	if (rc < 0) {
+		/*
+		 * SecurityBufferOffset should be set to zero
+		 * in session setup error response.
+		 */
+		rsp->SecurityBufferOffset = 0;
+
+		if (sess) {
+			bool try_delay = false;
+
+			/*
+			 * To avoid dictionary attacks (repeated session setups rapidly sent) to
+			 * connect to server, ksmbd make a delay of a 5 seconds on session setup
+			 * failure to make it harder to send enough random connection requests
+			 * to break into a server.
+			 */
+			if (sess->user && sess->user->flags & KSMBD_USER_FLAG_DELAY_SESSION)
+				try_delay = true;
+
+			ksmbd_session_destroy(sess);
+			work->sess = NULL;
+			if (try_delay)
+				ssleep(5);
+		}
 	}
 
 	return rc;
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 44aea33a67fa..1acf1892a466 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -601,7 +601,7 @@ int ksmbd_ipc_tree_disconnect_request(unsigned long long session_id,
 	return ret;
 }
 
-int ksmbd_ipc_logout_request(const char *account)
+int ksmbd_ipc_logout_request(const char *account, int flags)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_logout_request *req;
@@ -616,6 +616,7 @@ int ksmbd_ipc_logout_request(const char *account)
 
 	msg->type = KSMBD_EVENT_LOGOUT_REQUEST;
 	req = (struct ksmbd_logout_request *)msg->payload;
+	req->account_flags = flags;
 	strscpy(req->account, account, KSMBD_REQ_MAX_ACCOUNT_NAME_SZ);
 
 	ret = ipc_msg_send(msg);
diff --git a/fs/ksmbd/transport_ipc.h b/fs/ksmbd/transport_ipc.h
index 9eacc895ffdb..5e5b90a0c187 100644
--- a/fs/ksmbd/transport_ipc.h
+++ b/fs/ksmbd/transport_ipc.h
@@ -25,7 +25,7 @@ ksmbd_ipc_tree_connect_request(struct ksmbd_session *sess,
 			       struct sockaddr *peer_addr);
 int ksmbd_ipc_tree_disconnect_request(unsigned long long session_id,
 				      unsigned long long connect_id);
-int ksmbd_ipc_logout_request(const char *account);
+int ksmbd_ipc_logout_request(const char *account, int flags);
 struct ksmbd_share_config_response *
 ksmbd_ipc_share_config_request(const char *name);
 struct ksmbd_spnego_authen_response *
-- 
2.25.1

