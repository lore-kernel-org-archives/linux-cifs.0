Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726EAC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 03:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiGVDEL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 23:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGVDEG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 23:04:06 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A745489A91
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:04 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id c139so3432347pfc.2
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZhBYI6WpVlVnN9DhiVyLdXrIb0Tcxba6a3GQX4Ia7U=;
        b=3IxuRWrpeFMNHXhSyVioIYOLxudGf+WxztaQe6phKtPLFvbeLBJBDHQILm5sFgc8QB
         SRxaxkb2KxK10o1uWCsRnxgDM1eSrSPLQwVaJQK8qOMpAB8FmldPjy3voOxcKlDAuTc1
         Q/3H76E0f9+d5f+ukpE1IaRSOCCjZdgNbMgZOqP7Mrnlw6qYcOq/WxfB3gBMMSjBFkE9
         fYBWdCPRCy1bqzDFHj4xRkJbscqH3j6IaMi5cRuRCRscBr6DqhsH0snpO5PpNFr9/BTP
         n4rY3SMpAvsdYzVXzgoDx3DdXqQsyLkIUrlcPt4MEijFQWOvcTbNKDLup+nWcrUoGTMR
         K28g==
X-Gm-Message-State: AJIora9+DmOdy/U6ATYYx/IJO6bqbz9+dICjgVaGtjvMy3/9ZwRTVYx5
        czN3ZMm8TdJ0Zi3m8TUR7bJcYj8ekVQ=
X-Google-Smtp-Source: AGRyM1vf7fqGPWv1OMfJ1EssnjmeQ1YzsOKjG6Lxqi8h1SNDXYeo7O4io+1Cwm+I6K8cOxmeLyE9qQ==
X-Received: by 2002:a05:6a00:2307:b0:52a:d2aa:2a9c with SMTP id h7-20020a056a00230700b0052ad2aa2a9cmr1303075pfh.11.1658459043594;
        Thu, 21 Jul 2022 20:04:03 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090a1d0a00b001f216407204sm2115450pjd.36.2022.07.21.20.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 20:04:02 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/5] ksmbd: replace sessions list in connection with xarray
Date:   Fri, 22 Jul 2022 12:03:42 +0900
Message-Id: <20220722030346.28534-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Replace sessions list in connection with xarray.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c        |  3 ++-
 fs/ksmbd/connection.h        |  2 +-
 fs/ksmbd/mgmt/user_session.c | 31 +++++++------------------------
 fs/ksmbd/mgmt/user_session.h |  5 ++---
 fs/ksmbd/smb2pdu.c           | 13 +++++++++----
 5 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index e8f476c5f189..ce23cc89046e 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -36,6 +36,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	list_del(&conn->conns_list);
 	write_unlock(&conn_list_lock);
 
+	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn);
@@ -66,12 +67,12 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
-	INIT_LIST_HEAD(&conn->sessions);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
 	spin_lock_init(&conn->request_lock);
 	spin_lock_init(&conn->credits_lock);
 	ida_init(&conn->async_ida);
+	xa_init(&conn->sessions);
 
 	spin_lock_init(&conn->llist_lock);
 	INIT_LIST_HEAD(&conn->lock_list);
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 98c1cbe45ec9..5b39f0bdeff8 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -55,7 +55,7 @@ struct ksmbd_conn {
 	struct nls_table		*local_nls;
 	struct list_head		conns_list;
 	/* smb session 1 per user */
-	struct list_head		sessions;
+	struct xarray			sessions;
 	unsigned long			last_active;
 	/* How many request are running currently */
 	atomic_t			req_running;
diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 8d8ffd8c6f19..3a44e66456fc 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -152,8 +152,6 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	if (!atomic_dec_and_test(&sess->refcnt))
 		return;
 
-	list_del(&sess->sessions_entry);
-
 	down_write(&sessions_table_lock);
 	hash_del(&sess->hlist);
 	up_write(&sessions_table_lock);
@@ -181,42 +179,28 @@ static struct ksmbd_session *__session_lookup(unsigned long long id)
 	return NULL;
 }
 
-void ksmbd_session_register(struct ksmbd_conn *conn,
-			    struct ksmbd_session *sess)
+int ksmbd_session_register(struct ksmbd_conn *conn,
+			   struct ksmbd_session *sess)
 {
 	sess->conn = conn;
-	list_add(&sess->sessions_entry, &conn->sessions);
+	return xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNEL));
 }
 
 void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 {
 	struct ksmbd_session *sess;
+	unsigned long id;
 
-	while (!list_empty(&conn->sessions)) {
-		sess = list_entry(conn->sessions.next,
-				  struct ksmbd_session,
-				  sessions_entry);
-
+	xa_for_each(&conn->sessions, id, sess) {
+		xa_erase(&conn->sessions, sess->id);
 		ksmbd_session_destroy(sess);
 	}
 }
 
-static bool ksmbd_session_id_match(struct ksmbd_session *sess,
-				   unsigned long long id)
-{
-	return sess->id == id;
-}
-
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 					   unsigned long long id)
 {
-	struct ksmbd_session *sess = NULL;
-
-	list_for_each_entry(sess, &conn->sessions, sessions_entry) {
-		if (ksmbd_session_id_match(sess, id))
-			return sess;
-	}
-	return NULL;
+	return xa_load(&conn->sessions, id);
 }
 
 int get_session(struct ksmbd_session *sess)
@@ -314,7 +298,6 @@ static struct ksmbd_session *__session_create(int protocol)
 		goto error;
 
 	set_session_flag(sess, protocol);
-	INIT_LIST_HEAD(&sess->sessions_entry);
 	xa_init(&sess->tree_conns);
 	INIT_LIST_HEAD(&sess->ksmbd_chann_list);
 	INIT_LIST_HEAD(&sess->rpc_handle_list);
diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
index e241f16a3851..8b08189be3fc 100644
--- a/fs/ksmbd/mgmt/user_session.h
+++ b/fs/ksmbd/mgmt/user_session.h
@@ -57,7 +57,6 @@ struct ksmbd_session {
 	__u8				smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
 	__u8				smb3signingkey[SMB3_SIGN_KEY_SIZE];
 
-	struct list_head		sessions_entry;
 	struct ksmbd_file_table		file_table;
 	atomic_t			refcnt;
 };
@@ -84,8 +83,8 @@ void ksmbd_session_destroy(struct ksmbd_session *sess);
 struct ksmbd_session *ksmbd_session_lookup_slowpath(unsigned long long id);
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 					   unsigned long long id);
-void ksmbd_session_register(struct ksmbd_conn *conn,
-			    struct ksmbd_session *sess);
+int ksmbd_session_register(struct ksmbd_conn *conn,
+			   struct ksmbd_session *sess);
 void ksmbd_sessions_deregister(struct ksmbd_conn *conn);
 struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 					       unsigned long long id);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 94ab1dcd80e7..04d20a2e6dee 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -588,7 +588,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	return -EINVAL;
 }
 
-static void destroy_previous_session(struct ksmbd_user *user, u64 id)
+static void destroy_previous_session(struct ksmbd_conn *conn,
+				     struct ksmbd_user *user, u64 id)
 {
 	struct ksmbd_session *prev_sess = ksmbd_session_lookup_slowpath(id);
 	struct ksmbd_user *prev_user;
@@ -607,6 +608,7 @@ static void destroy_previous_session(struct ksmbd_user *user, u64 id)
 	}
 
 	put_session(prev_sess);
+	xa_erase(&conn->sessions, prev_sess->id);
 	ksmbd_session_destroy(prev_sess);
 }
 
@@ -1439,7 +1441,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 	/* Check for previous session */
 	prev_id = le64_to_cpu(req->PreviousSessionId);
 	if (prev_id && prev_id != sess->id)
-		destroy_previous_session(user, prev_id);
+		destroy_previous_session(conn, user, prev_id);
 
 	if (sess->state == SMB2_SESSION_VALID) {
 		/*
@@ -1561,7 +1563,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
 	/* Check previous session */
 	prev_sess_id = le64_to_cpu(req->PreviousSessionId);
 	if (prev_sess_id && prev_sess_id != sess->id)
-		destroy_previous_session(sess->user, prev_sess_id);
+		destroy_previous_session(conn, sess->user, prev_sess_id);
 
 	if (sess->state == SMB2_SESSION_VALID)
 		ksmbd_free_user(sess->user);
@@ -1650,7 +1652,9 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 		rsp->hdr.SessionId = cpu_to_le64(sess->id);
-		ksmbd_session_register(conn, sess);
+		rc = ksmbd_session_register(conn, sess);
+		if (rc)
+			goto out_err;
 	} else if (conn->dialect >= SMB30_PROT_ID &&
 		   (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
 		   req->Flags & SMB2_SESSION_REQ_FLAG_BINDING) {
@@ -1828,6 +1832,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			if (sess->user && sess->user->flags & KSMBD_USER_FLAG_DELAY_SESSION)
 				try_delay = true;
 
+			xa_erase(&conn->sessions, sess->id);
 			ksmbd_session_destroy(sess);
 			work->sess = NULL;
 			if (try_delay)
-- 
2.25.1

