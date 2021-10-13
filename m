Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0363C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 08:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850A561027
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 08:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhJMIqG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:46:06 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:42902 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhJMIqF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Oct 2021 04:46:05 -0400
Received: by mail-pg1-f170.google.com with SMTP id 66so1640451pgc.9
        for <linux-cifs@vger.kernel.org>; Wed, 13 Oct 2021 01:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lURRwrKU/V+ypYEIAHqkzvKKZKAqXAQWJAPD0gIPRC8=;
        b=pdIGHbqU5dYveJ4BMoQ97JfSiVGzgtYKvkDLf5R2KNhOr9RDu2fheRqXgjyyCMdfYj
         ACvnMP6yfiR4s7D/uj7HREWdkByAUOp0jguCck585Y/58J6Km4EByLH08OmxDBq5yi5R
         Ot8K49LaU2QkkZh/ZwSJcKg7QhzvKbhmZBEhCaPn6mmld0TvnHYhHp6PXJ/c32WR6Lzr
         CPCTKLHAhcpMHAJ1v34O+s2cqgjHqdB2/EaBZxRWrzQ5JUga4XJCNk4xch6mqGnHivH1
         XAdkXRYJp8r3beAkwl7jUogIp4fV0uC3CNvf//wcJ00u+oktCzmJl+EcOQTUXPt+4aU5
         VStg==
X-Gm-Message-State: AOAM530kfGfyLaYXu6U8NN36LR8uraPPUsneVhvKW97VPHiusPWBdfr9
        cxsVZz3l05Ck6dWGHZ3jl+SbjXIczVC0zQ==
X-Google-Smtp-Source: ABdhPJwId+rEOiQ3naKkm+ER7+B59SJpN291UE+Wh/KmoT6zZoVUwhPCTEvcidBukbOgR6ZfBqXsvw==
X-Received: by 2002:a63:3d4c:: with SMTP id k73mr26865427pga.44.1634114642654;
        Wed, 13 Oct 2021 01:44:02 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id z11sm13186694pfk.204.2021.10.13.01.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 01:44:02 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: throttle session setup failures to avoid dictionary attacks
Date:   Wed, 13 Oct 2021 17:43:27 +0900
Message-Id: <20211013084327.22515-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To avoid dictionary attacks (repeated session setups rapidly sent) to
connect to server, ksmbd make a delay of a 5 seconds on session setup
failure to make it harder to send enough random connection requests
to break into a server if an user insert the wrong password 10 times
in a row.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 include/linux/ksmbd_server.h |  2 ++
 include/management/user.h    |  3 +++
 lib/management/tree_conn.c   |  3 +++
 lib/management/user.c        | 19 +++++++++++++++++++
 mountd/worker.c              |  2 +-
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 800925c..b1c5e63 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -122,6 +122,7 @@ struct ksmbd_tree_disconnect_request {
 
 struct ksmbd_logout_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
+	__u32	account_flags;
 };
 
 struct ksmbd_rpc_command {
@@ -203,6 +204,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_USER_FLAG_BAD_UID		(1 << 2)
 #define KSMBD_USER_FLAG_BAD_USER	(1 << 3)
 #define KSMBD_USER_FLAG_GUEST_ACCOUNT	(1 << 4)
+#define KSMBD_USER_FLAG_DELAY_SESSION	(1 << 5)
 
 /*
  * Share config flags.
diff --git a/include/management/user.h b/include/management/user.h
index 26132d2..7482051 100644
--- a/include/management/user.h
+++ b/include/management/user.h
@@ -26,6 +26,7 @@ struct ksmbd_user {
 	int		flags;
 	int		state;
 	GRWLock		update_lock;
+	unsigned int	failed_login_count;
 };
 
 static inline void set_user_flag(struct ksmbd_user *user, int bit)
@@ -61,8 +62,10 @@ void for_each_ksmbd_user(walk_users cb, gpointer user_data);
 
 struct ksmbd_login_request;
 struct ksmbd_login_response;
+struct ksmbd_logout_request;
 
 int usm_handle_login_request(struct ksmbd_login_request *req,
 			     struct ksmbd_login_response *resp);
+int usm_handle_logout_request(struct ksmbd_logout_request *req);
 
 #endif /* __MANAGEMENT_USER_H__ */
diff --git a/lib/management/tree_conn.c b/lib/management/tree_conn.c
index 7158e8a..e6fc185 100644
--- a/lib/management/tree_conn.c
+++ b/lib/management/tree_conn.c
@@ -145,6 +145,9 @@ int tcm_handle_tree_connect(struct ksmbd_tree_connect_request *req,
 		goto out_error;
 	}
 
+	user->failed_login_count = 0;
+	user->flags &= ~KSMBD_USER_FLAG_DELAY_SESSION;
+
 	if (test_user_flag(user, KSMBD_USER_FLAG_GUEST_ACCOUNT))
 		set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_GUEST_ACCOUNT);
 
diff --git a/lib/management/user.c b/lib/management/user.c
index 28c4dcd..b4727a7 100644
--- a/lib/management/user.c
+++ b/lib/management/user.c
@@ -387,3 +387,22 @@ int usm_handle_login_request(struct ksmbd_login_request *req,
 	put_ksmbd_user(user);
 	return 0;
 }
+
+int usm_handle_logout_request(struct ksmbd_logout_request *req)
+{
+	struct ksmbd_user *user;
+
+	user = usm_lookup_user(req->account);
+	if (!user)
+		return -ENOENT;
+
+	if (req->account_flags & KSMBD_USER_FLAG_BAD_PASSWORD) {
+		if (user->failed_login_count < 10)
+			user->failed_login_count++;
+		else
+			user->flags |= KSMBD_USER_FLAG_DELAY_SESSION;
+	} else {
+		user->failed_login_count = 0;
+		user->flags &= ~KSMBD_USER_FLAG_DELAY_SESSION;
+	}
+}
diff --git a/mountd/worker.c b/mountd/worker.c
index 06ebb81..70f2655 100644
--- a/mountd/worker.c
+++ b/mountd/worker.c
@@ -204,7 +204,7 @@ static int logout_request(struct ksmbd_ipc_msg *msg)
 	if (!VALID_IPC_MSG(msg, struct ksmbd_logout_request))
 		return -EINVAL;
 
-	return 0;
+	return usm_handle_logout_request(KSMBD_IPC_MSG_PAYLOAD(msg));
 }
 
 static int heartbeat_request(struct ksmbd_ipc_msg *msg)
-- 
2.25.1

