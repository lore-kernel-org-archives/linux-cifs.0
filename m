Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEEB22A4F1
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199039; cv=none; b=jjP3s6BGTd7b211bNPXua5+/mJE0eQmr7qOibFiaJj7zqvk8/1TUNtzQSc2FnypMbNTPueFLEx9ZJczIC9w6rQRjQu1Q2CODVlEQyYKxFfVKFF5TdPLv8mmPgxTWC8yy9dzauJafwUjYJA/g5wEV/ZO8f/1Hoph/PufwRll2ep8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199039; c=relaxed/simple;
	bh=j1TsAab9EJQ/daAl3RK3IIyF6Fto1glq3JSv7x0jk/c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m9Z8z3Ng4x9Lus6NJXKALaTxISsM2oCvneKpqYpu6bTpm9qiF0iDvBsENG8b6Xdg+VVZMHj3CbNqTlVtdfvddC8BIOiq0fNS8LgjCS/ZruZv2IlAJ9/dkWgAdibz7Gc/t9RI9VCx1aCp65y6A8oozdIpqfCD0T15wPuxNPaok8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkHSLh6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkHSLh6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830341F000C4;
	Sat, 17 Oct 2026 01:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199037;
	bh=u9zkXL8+Ub42f+5YWZo4HwsUTKwXtEpYvU0P1gatkwg=;
	h=From:To:Cc:Subject:Date;
	b=WkHSLh6RmY+gf4AS+wA4vC1JOmKXNfHf24zYt8rhZTvuCL8DVNYwtsuNQogYZ6aYc
	 PVb4Jmu/046JAnLbqAlqXYfO6YoNTVVvjpiQFsVPPFc94X6GIIiLc38A8Cn6jtCcgj
	 Sit+FurEzte35syMtl5cDwDefP0G7PYwrPzDoWDIRfdH2ExC4N2GJXyAG6PgUhhFt8
	 Ia1hVQdxB1KlaQiu3U2Q7+nUI925U7kBEsmrpP991ffhC/+8ts4Gvv9HBLoHYrsgtk
	 OvXuoYWUVVtvnRdPtLYgaCH1OcWtKCvpCsHH01AI+lF1Lbkp+LQYpHgMf+Qi4JMmpz
	 OlduSPJyThZvw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pan Guihua <pan.guihua@datatom.com>
Subject: [PATCH 01/22] ksmbd: release connection lock while draining old session
Date: Sat, 17 Oct 2026 10:03:23 +0900
Message-Id: <20261017010344.11478-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous-session teardown waits for requests on the old channels. Holding
srv_mutex during that wait can block their responses and prevent the drain
from completing.

Record the previous session ID during authentication, finish using the
request's authentication state, and release srv_mutex while the old
session drains. Keep the response binding decision in the work item because
signing and preauthentication hashing run after the drain.

Reported-by: Pan Guihua <pan.guihua@datatom.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.h        |  2 ++
 fs/smb/server/mgmt/user_session.c | 15 +++++++++
 fs/smb/server/smb2pdu.c           | 56 ++++++++++++++++++-------------
 3 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 3a14e4d69aa1..40f70a5d08b5 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -94,6 +94,8 @@ struct ksmbd_work {
 	bool                            need_invalidate_rkey:1;
 	bool				request_open_chseq_tracked:1;
 	bool				session_setup_reauth:1;
+	/* Retain the binding decision for response signing and preauth hashing. */
+	bool				session_setup_binding:1;
 
 	unsigned int                    remote_key;
 	/* cancel works */
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 1321cd6c84e7..d814a99ff519 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -759,6 +759,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 {
 	struct ksmbd_session *prev_sess;
 	struct ksmbd_user *prev_user;
+	bool pinned = false;
 	int err;
 
 	down_write(&sessions_table_lock);
@@ -781,9 +782,21 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 	}
 	prev_sess->tearing_down = true;
 	up_write(&prev_sess->chann_lock);
+	ksmbd_user_session_get(prev_sess);
+	pinned = true;
+	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
 
 	ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_RECONNECT);
+	/*
+	 * The caller has finished using the connection's authentication state.
+	 * Drop srv_mutex so drained requests can write their responses.
+	 */
+	ksmbd_conn_unlock(conn);
 	err = ksmbd_conn_wait_idle_sess(conn, prev_sess);
+	ksmbd_conn_lock(conn);
+	down_write(&sessions_table_lock);
+	down_write(&conn->session_lock);
 	if (err) {
 		down_write(&prev_sess->chann_lock);
 		prev_sess->tearing_down = false;
@@ -800,6 +813,8 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 out:
 	up_write(&conn->session_lock);
 	up_write(&sessions_table_lock);
+	if (pinned)
+		ksmbd_user_session_put(prev_sess);
 }
 
 static bool ksmbd_preauth_session_id_match(struct preauth_session *sess,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2da6163ee776..aca51f54a38d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2206,14 +2206,14 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 
 static int ntlm_authenticate(struct ksmbd_work *work,
 			     struct smb2_sess_setup_req *req,
-			     struct smb2_sess_setup_rsp *rsp)
+			     struct smb2_sess_setup_rsp *rsp,
+			     u64 *previous_session_id)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_user *user;
 	char channel_key[CIFS_KEY_SIZE] = {};
 	char *auth_key = conn->binding ? channel_key : sess->sess_key;
-	u64 prev_id;
 	bool binding = conn->binding;
 	int sz, rc;
 
@@ -2278,9 +2278,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		}
 	}
 
-	prev_id = le64_to_cpu(req->PreviousSessionId);
-	if (prev_id && prev_id != sess->id)
-		destroy_previous_session(conn, sess->user, prev_id);
+	*previous_session_id = le64_to_cpu(req->PreviousSessionId);
 
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
@@ -2342,7 +2340,8 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 #ifdef CONFIG_SMB_SERVER_KERBEROS5
 static int krb5_authenticate(struct ksmbd_work *work,
 			     struct smb2_sess_setup_req *req,
-			     struct smb2_sess_setup_rsp *rsp)
+			     struct smb2_sess_setup_rsp *rsp,
+			     u64 *previous_session_id)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
@@ -2351,7 +2350,6 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	char reauth_key[CIFS_KEY_SIZE] = {};
 	char *auth_key = conn->binding ? channel_key :
 		(work->session_setup_reauth ? reauth_key : sess->sess_key);
-	u64 prev_sess_id;
 	bool binding = conn->binding;
 	int in_len, out_len;
 	int retval;
@@ -2373,10 +2371,7 @@ static int krb5_authenticate(struct ksmbd_work *work,
 		goto out;
 	}
 
-	/* Check previous session */
-	prev_sess_id = le64_to_cpu(req->PreviousSessionId);
-	if (prev_sess_id && prev_sess_id != sess->id)
-		destroy_previous_session(conn, sess->user, prev_sess_id);
+	*previous_session_id = le64_to_cpu(req->PreviousSessionId);
 
 	rsp->SecurityBufferLength = cpu_to_le16(out_len);
 
@@ -2445,7 +2440,8 @@ static int krb5_authenticate(struct ksmbd_work *work,
 #else
 static int krb5_authenticate(struct ksmbd_work *work,
 			     struct smb2_sess_setup_req *req,
-			     struct smb2_sess_setup_rsp *rsp)
+			     struct smb2_sess_setup_rsp *rsp,
+			     u64 *previous_session_id)
 {
 	return -EOPNOTSUPP;
 }
@@ -2459,6 +2455,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct ksmbd_session *sess = NULL;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
+	u64 previous_session_id = 0;
+	bool authenticated = false;
 	int rc = 0;
 
 	ksmbd_debug(SMB, "Received smb2 session setup request\n");
@@ -2648,14 +2646,11 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (conn->preferred_auth_mech &
 				(KSMBD_AUTH_KRB5 | KSMBD_AUTH_MSKRB5)) {
-			rc = krb5_authenticate(work, req, rsp);
+			rc = krb5_authenticate(work, req, rsp, &previous_session_id);
 			if (rc)
 				goto out_err;
 
-			if (!ksmbd_conn_need_reconnect(conn)) {
-				ksmbd_conn_set_good(conn);
-				sess->state = SMB2_SESSION_VALID;
-			}
+			authenticated = true;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
 				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
@@ -2664,14 +2659,12 @@ int smb2_sess_setup(struct ksmbd_work *work)
 				rsp->hdr.Status =
 					STATUS_MORE_PROCESSING_REQUIRED;
 			} else if (negblob->MessageType == NtLmAuthenticate) {
-				rc = ntlm_authenticate(work, req, rsp);
+				rc = ntlm_authenticate(work, req, rsp,
+						       &previous_session_id);
 				if (rc)
 					goto out_err;
 
-				if (!ksmbd_conn_need_reconnect(conn)) {
-					ksmbd_conn_set_good(conn);
-					sess->state = SMB2_SESSION_VALID;
-				}
+				authenticated = true;
 				if (conn->binding) {
 					struct preauth_session *preauth_sess;
 
@@ -2804,6 +2797,21 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 	}
 
+	work->session_setup_binding = conn->binding;
+	if (authenticated) {
+		/*
+		 * Draining the previous session drops srv_mutex. Finish using the
+		 * connection's authentication state and free mechToken first, and
+		 * retain this request's binding decision for response processing.
+		 */
+		if (previous_session_id && previous_session_id != sess->id)
+			destroy_previous_session(conn, sess->user, previous_session_id);
+		if (!ksmbd_conn_need_reconnect(conn)) {
+			ksmbd_conn_set_good(conn);
+			sess->state = SMB2_SESSION_VALID;
+		}
+	}
+
 	ksmbd_conn_unlock(conn);
 	return rc;
 }
@@ -12478,7 +12486,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	command = le16_to_cpu(hdr->Command);
 
 	if (command == SMB2_SESSION_SETUP_HE &&
-	    (!conn->binding || hdr->Status != STATUS_SUCCESS)) {
+	    (!work->session_setup_binding || hdr->Status != STATUS_SUCCESS)) {
 		signing_key = work->sess->smb3signingkey;
 	} else {
 		chann = lookup_chann_list(work->sess, work->conn);
@@ -12527,7 +12535,7 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {
 		ksmbd_conn_lock(conn);
 
-		if (conn->binding) {
+		if (work->session_setup_binding) {
 			struct preauth_session *preauth_sess;
 
 			preauth_sess = ksmbd_preauth_session_lookup(conn, sess->id);
-- 
2.25.1

