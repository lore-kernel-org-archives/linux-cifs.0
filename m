Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA61022A817
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968947; cv=none; b=SD2fbzBpCZYAB7heUrtXhm/EopnCFd/850At+4VNPn5CiZJRHIkMTuKGwTvoTZyVzdkoIo2uuOK0H/KzF1ZIlrSMLRpK5sEYCVSo3dZ3DV9d/lnYNzUbUYpGYK0Q72QyNfsfNMnaJ4v7bXH6uqZr+wvau0BHBpnu5LeeAW7tfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968947; c=relaxed/simple;
	bh=6DWVylphhRDCWMhOOQwgrf1044wcRjN1ct5Uw8SFfPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FECYH95T44h+rs7ZwugZ22AT+zs04PPSymBAAaVTMIsEjrA9lb5ajkhizKpplh0FkT4sQhY99n/yW+VRiXGb8Xfi92aPvRFmm+7HadCAOm8HnzPybpXy42urcHBvDeypIIXR6/Nr0uf9IhzmR2iFuSH291BTF3HYyZCW9VSMrF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rq7NwBvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rq7NwBvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC2D1F000E9;
	Mon, 17 Aug 2026 12:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968945;
	bh=sm83ncjjDZCLRQYcRwRfq8HSWJt9dL+GWq1VddIXmwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rq7NwBvYVG7a1ugn6mUeR3V/LoawLlFjso2uR4DuSQ/7Y+LYvpwvh474eAbmZbrgu
	 nG+Wg8C0XYR7tFJ2jwF5uocaAYKPyEtAcKEGyb8dzEa2Ocyc6O/0kI+yflf7W4QkXJ
	 R7WBLdCMLenxM2p4KzBAbdoe/TakrEivd3aBEqqRT1LtQktvDZwWl1iXw8znoY1dZz
	 Q9KNRZnWVDrDKKveSTT50alBIytYFkFlqlskBts/VzXXaCcZSfRAQBWF7GvRVpiV4g
	 Z3SETZXdJ/8n4+HUPYaFZMRtNhZ0E9iAHdFuNzDdxhb2Q4UJnf5q5syzHaFDEvQ3sK
	 n63NWPXXPVIVA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: scope session state changes to bound connections
Date: Mon, 17 Aug 2026 21:15:18 +0900
Message-Id: <20260817121524.8812-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_all_conn_set_status() treats every connection whose transient
binding flag is set as belonging to the target SessionId.  A logoff or
session replacement can consequently move an unrelated connection to
NEED_RECONNECT or NEED_SETUP.

Pass the target session itself and select connections using either the
connection-local session xarray or the session's permanent channel list.
Use the same association test while waiting for requests to drain.

Serialize session-wide status changes under request_lock and do not
overwrite EXITING or RELEASING. Protect the shutdown transition with the
same lock so a concurrent session update cannot revive a closing
connection.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Fixes: abcc506a9a71 ("ksmbd: fix racy issue from smb2 close and logoff with multichannel")
Fixes: c444139cb747 ("ksmbd: rewrite stop_sessions() with restartable iteration")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c        | 37 ++++++++++++++++++++++++++-----
 fs/smb/server/connection.h        |  6 +++--
 fs/smb/server/mgmt/user_session.c |  8 +++----
 fs/smb/server/smb2pdu.c           |  6 ++---
 4 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index e225aca67686..71d55d903f6f 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -404,15 +404,37 @@ void ksmbd_conn_unlock(struct ksmbd_conn *conn)
 	mutex_unlock(&conn->srv_mutex);
 }
 
-void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
+static bool ksmbd_session_is_bound_to_conn(struct ksmbd_session *sess,
+					   struct ksmbd_conn *conn)
+{
+	bool found;
+
+	rcu_read_lock();
+	found = xa_load(&conn->sessions, sess->id) == sess;
+	rcu_read_unlock();
+	if (found)
+		return true;
+
+	down_read(&sess->chann_lock);
+	found = xa_load(&sess->ksmbd_chann_list, (long)conn);
+	up_read(&sess->chann_lock);
+	return found;
+}
+
+void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status)
 {
 	struct ksmbd_conn *conn;
 	int bkt;
 
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
-		if (conn->binding || xa_load(&conn->sessions, sess_id))
-			WRITE_ONCE(conn->status, status);
+		if (ksmbd_session_is_bound_to_conn(sess, conn)) {
+			spin_lock(&conn->request_lock);
+			if (!ksmbd_conn_exiting(conn) &&
+			    !ksmbd_conn_releasing(conn))
+				WRITE_ONCE(conn->status, status);
+			spin_unlock(&conn->request_lock);
+		}
 	}
 	up_read(&conn_list_lock);
 }
@@ -422,7 +444,8 @@ void ksmbd_conn_wait_idle(struct ksmbd_conn *conn)
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
 }
 
-int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
+int ksmbd_conn_wait_idle_sess(struct ksmbd_conn *curr_conn,
+			      struct ksmbd_session *sess)
 {
 	struct ksmbd_conn *conn;
 	int rc, retry_count = 0, max_timeout = 120;
@@ -434,7 +457,7 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
-		if (conn->binding || xa_load(&conn->sessions, sess_id)) {
+		if (ksmbd_session_is_bound_to_conn(sess, conn)) {
 			rcount = (conn == curr_conn) ? 2 : 1;
 			if (atomic_read(&conn->req_running) >= rcount) {
 				rc = wait_event_timeout(conn->req_running_q,
@@ -780,8 +803,10 @@ static void stop_sessions(void)
 		 * handler exited its receive loop for an unrelated
 		 * reason).
 		 */
-		if (READ_ONCE(conn->status) != KSMBD_SESS_RELEASING)
+		spin_lock(&conn->request_lock);
+		if (!ksmbd_conn_releasing(conn))
 			ksmbd_conn_set_exiting(conn);
+		spin_unlock(&conn->request_lock);
 		target = conn;
 		break;
 	}
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 9ca03f9774d3..c01ccbe8b97c 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -23,6 +23,7 @@
 #include "ksmbd_work.h"
 
 struct smbdirect_buffer_descriptor_v1;
+struct ksmbd_session;
 
 #define KSMBD_SOCKET_BACKLOG		16
 
@@ -196,7 +197,8 @@ extern struct rw_semaphore conn_list_lock;
 
 bool ksmbd_conn_alive(struct ksmbd_conn *conn);
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn);
-int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id);
+int ksmbd_conn_wait_idle_sess(struct ksmbd_conn *curr_conn,
+			      struct ksmbd_session *sess);
 struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
@@ -310,5 +312,5 @@ static inline void ksmbd_conn_set_releasing(struct ksmbd_conn *conn)
 	WRITE_ONCE(conn->status, KSMBD_SESS_RELEASING);
 }
 
-void ksmbd_all_conn_set_status(u64 sess_id, u32 status);
+void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status);
 #endif /* __CONNECTION_H__ */
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 31eccad5d732..7e187d20828b 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -647,17 +647,17 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
 		goto out;
 
-	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_RECONNECT);
-	err = ksmbd_conn_wait_idle_sess_id(conn, id);
+	ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_RECONNECT);
+	err = ksmbd_conn_wait_idle_sess(conn, prev_sess);
 	if (err) {
-		ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
+		ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_SETUP);
 		goto out;
 	}
 
 	ksmbd_destroy_file_table(prev_sess);
 	prev_sess->kerberos_expiry = 0;
 	prev_sess->state = SMB2_SESSION_EXPIRED;
-	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
+	ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_SETUP);
 	ksmbd_launch_ksmbd_durable_scavenger();
 out:
 	up_write(&conn->session_lock);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index aa662adaf63d..6581c79635fa 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2899,7 +2899,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	struct smb2_logoff_req *req;
 	struct smb2_logoff_rsp *rsp;
-	u64 sess_id;
 	int err;
 
 	WORK_BUFFERS(work, req, rsp);
@@ -2913,8 +2912,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 		smb2_set_err_rsp(work);
 		return -ENOENT;
 	}
-	sess_id = le64_to_cpu(req->hdr.SessionId);
-	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_RECONNECT);
+	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_RECONNECT);
 	ksmbd_conn_unlock(conn);
 
 	ksmbd_close_session_fds(work);
@@ -2932,7 +2930,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
+	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));
-- 
2.25.1

