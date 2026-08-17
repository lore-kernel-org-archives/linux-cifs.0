Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB093C661A
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968951; cv=none; b=Rkp+8Nn+6Ci+SFu0ER+asB439Qu9XiRW3h9dNt59fauaHsjiVEf+DKB4DlZVMxKfZlvBA5Mg/an2T9l19LLftSHT/vPVyj0utqCPHKrfXuouzEWACBtYVUnOXPTdNd3764k3eebfwjwR0P8kBHrNQV/JwDkog921s2FNU3q4oZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968951; c=relaxed/simple;
	bh=VAnfrHIUobDvwnE3yFY6fP9guaHALXI0RnT7S6rOGB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lYliK64X20mUQOjkYkq/3OFjBsdn7+EXKpTAOHStBt+ROlFh2eLn8ZwyKg5QMRV0a8C09ZWiVYz9/utmo9LnlFFlxfqY6y+IyK9Gv6gmixoaIAY9n0odmQIaYzTjjpIh3nVsyi8rPf7e7FX+V31RCAxrpYZ3brYFmekjBOEByJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGLkT1TQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGLkT1TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DA51F000E9;
	Mon, 17 Aug 2026 12:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968949;
	bh=abcktn7KCbFXKaTtv2gsVMCNIC8uRq6y20VxtQV85To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGLkT1TQCcsG0MFFnEYerDqYTiJRejYy64Jj1O+Lp0rwMgxuWeD4utRREFLww2LnR
	 2uzxF0kiwg46SDt0ubZpmqU+cOzAZYqAYEmzyXP14Rnyq4NuCCyjXt1kxCupNoMM/C
	 2na1prqIRXpJ6BTi8KGspOQnSRmgsT31aaiUsGKSh12jVoTvpyEdN+1V4seOy0+rAZ
	 cVfRHxB7smf8ecv0b2jnBHhihC/vOmqoYHvT/GtRzT9TmnWujU7bF1Wa7O9qolnau2
	 g1OYLg4lsEDeSwT9txlyp0Rieg95e8qDTBdgDIxPLWnuh51fwulq1ZVUKczdm44dBX
	 /qjxLGmQ+ICaQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: disconnect on SMB3 decryption failure
Date: Mon, 17 Aug 2026 21:15:20 +0900
Message-Id: <20260817121524.8812-8-linkinjeon@kernel.org>
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

MS-SMB2 requires the server to disconnect a connection when an
encrypted transform cannot be associated with a session or fails
authenticated decryption. This includes an encrypted request that
still carries a SessionId invalidated through PreviousSessionId.

Move the connection to EXITING and shut down its transport when
decrypt_req() fails. Add the missing TCP shutdown callback so a receive
blocked in kernel_recvmsg() is released; SMB Direct already provides
the corresponding callback.

Plaintext requests using an invalidated SessionId do not take this
path and continue to receive STATUS_USER_SESSION_DELETED.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c    | 16 ++++++++++++++++
 fs/smb/server/connection.h    |  1 +
 fs/smb/server/server.c        |  4 +++-
 fs/smb/server/transport_tcp.c |  6 ++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 71d55d903f6f..5d729473dd18 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -439,6 +439,22 @@ void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status)
 	up_read(&conn_list_lock);
 }
 
+void ksmbd_conn_abort(struct ksmbd_conn *conn)
+{
+	bool shutdown = false;
+
+	spin_lock(&conn->request_lock);
+	if (!ksmbd_conn_exiting(conn) && !ksmbd_conn_releasing(conn)) {
+		ksmbd_conn_set_exiting(conn);
+		shutdown = true;
+	}
+	spin_unlock(&conn->request_lock);
+	wake_up_all(&conn->req_running_q);
+
+	if (shutdown && conn->transport->ops->shutdown)
+		conn->transport->ops->shutdown(conn->transport);
+}
+
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn)
 {
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index c01ccbe8b97c..421907aed473 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -203,6 +203,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
 void ksmbd_conn_put(struct ksmbd_conn *conn);
+void ksmbd_conn_abort(struct ksmbd_conn *conn);
 int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 7881fc7bb8cd..ba44bea9ddc3 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -188,8 +188,10 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
 		rc = conn->ops->decrypt_req(work);
-		if (rc < 0)
+		if (rc < 0) {
+			ksmbd_conn_abort(conn);
 			return;
+		}
 		work->encrypted = true;
 	}
 
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 1045eca581c3..0ae5f145a332 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -435,6 +435,11 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 		atomic_dec(&active_num_conn);
 }
 
+static void ksmbd_tcp_shutdown(struct ksmbd_transport *t)
+{
+	kernel_sock_shutdown(TCP_TRANS(t)->sock, SHUT_RDWR);
+}
+
 static void tcp_destroy_socket(struct socket *ksmbd_socket)
 {
 	int ret;
@@ -681,5 +686,6 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.25.1

