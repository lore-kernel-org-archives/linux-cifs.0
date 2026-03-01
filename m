Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CB2284662;
	Sun,  1 Mar 2026 01:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328445; cv=none; b=fWyAq0x2EYFGnR0HXFLa3z7OLlPjipIQ9grr9VZhMNDJSwmWLRYIleIzq3uhjvoJJ9b+eJZ0a3Gr615M1Qb/Hfo0ZdEZiLx4W+L6mkueTJFdUdb3m991OYsYO21fP6W88GMf6Rtj2d0WkXHN9ABfsskXm+cDTX6PzHjdjLCy+j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328445; c=relaxed/simple;
	bh=7lE4TiLtqxJKZ1xq5UojLvEOiVWMv8OnsoP+EEzA8jY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TmLrkzNhYHWjy8+E6uNYQz0YFC5T0zGMy1B1cBv0tr7ZD84hhFgRNpNlSJmaiHg2HQapWI7AanWOFLgGLe4k/2GnwWaHCvTMaN9JvWLq0Uaucmnhas4t0g6hQNCaaCQsQdTV6gtpv8qD4xC2cRplrSHG0Fv0pOKHjlo99Klg890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7AdZWgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7AdZWgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A38C2BC86;
	Sun,  1 Mar 2026 01:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328445;
	bh=7lE4TiLtqxJKZ1xq5UojLvEOiVWMv8OnsoP+EEzA8jY=;
	h=From:To:Cc:Subject:Date:From;
	b=F7AdZWgH5WOc2hwfCfKYYr9x7cMoxX6H1L4do1h7v5ZEWSxpIfQtaESj3VtpKSKtX
	 gWMsz4Qk3bEi+WHH556uMuVchb9NVC484gKxmN88i71z3AqGSk0ko7ArqgyzjiLz2R
	 FGqPmo1pBqgrRpfhCKMmH0YfK87t/yRR3lSlNdB0JhKcJYZeh2mOw4Zx4LRlsHcK91
	 7OaFVj7J1ywgi89bZZDxSpzj8afM+Q57fSyvRhrLHhxXPx2z+qMwg6ACWKDc4WutmE
	 VMsub7N+8eefJgnlYtUvf9TFrap/8k0FbwwLUlJYbs+3J4BJ/l9w79Are9MgPfimHS
	 jhaXDkiQyXEqw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: Igor Stepansky <igor.stepansky@orca.security>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org
Subject: FAILED: Patch "ksmbd: add chann_lock to protect ksmbd_chann_list xarray" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:27:23 -0500
Message-ID: <20260301012723.1684877-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 4f3a06cc57976cafa8c6f716646be6c79a99e485 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 9 Feb 2026 10:43:19 +0900
Subject: [PATCH] ksmbd: add chann_lock to protect ksmbd_chann_list xarray

ksmbd_chann_list xarray lacks synchronization, allowing use-after-free in
multi-channel sessions (between lookup_chann_list() and ksmbd_chann_del).

Adds rw_semaphore chann_lock to struct ksmbd_session and protects
all xa_load/xa_store/xa_erase accesses.

Cc: stable@vger.kernel.org
Reported-by: Igor Stepansky <igor.stepansky@orca.security>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/mgmt/user_session.c |  5 +++++
 fs/smb/server/mgmt/user_session.h |  1 +
 fs/smb/server/smb2pdu.c           | 12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 68b3e0cb54d38..8c2b14ea7b0ec 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -244,12 +244,14 @@ static void free_channel_list(struct ksmbd_session *sess)
 	struct channel *chann;
 	unsigned long index;
 
+	down_write(&sess->chann_lock);
 	xa_for_each(&sess->ksmbd_chann_list, index, chann) {
 		xa_erase(&sess->ksmbd_chann_list, index);
 		kfree(chann);
 	}
 
 	xa_destroy(&sess->ksmbd_chann_list);
+	up_write(&sess->chann_lock);
 }
 
 static void __session_rpc_close(struct ksmbd_session *sess,
@@ -434,7 +436,9 @@ static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 {
 	struct channel *chann;
 
+	down_write(&sess->chann_lock);
 	chann = xa_erase(&sess->ksmbd_chann_list, (long)conn);
+	up_write(&sess->chann_lock);
 	if (!chann)
 		return -ENOENT;
 
@@ -668,6 +672,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
 	init_rwsem(&sess->rpc_lock);
+	init_rwsem(&sess->chann_lock);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 176d800c24906..d94f5e128a9b4 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -48,6 +48,7 @@ struct ksmbd_session {
 	char				sess_key[CIFS_KEY_SIZE];
 
 	struct hlist_node		hlist;
+	struct rw_semaphore		chann_lock;
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4d3154cc493ea..3efcc7da1b9f6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -80,7 +80,13 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)
 
 struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn *conn)
 {
-	return xa_load(&sess->ksmbd_chann_list, (long)conn);
+	struct channel *chann;
+
+	down_read(&sess->chann_lock);
+	chann = xa_load(&sess->ksmbd_chann_list, (long)conn);
+	up_read(&sess->chann_lock);
+
+	return chann;
 }
 
 /**
@@ -1559,8 +1565,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
 					KSMBD_DEFAULT_GFP);
+			up_write(&sess->chann_lock);
 			if (xa_is_err(old)) {
 				kfree(chann);
 				return xa_err(old);
@@ -1652,8 +1660,10 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			old = xa_store(&sess->ksmbd_chann_list, (long)conn,
 					chann, KSMBD_DEFAULT_GFP);
+			up_write(&sess->chann_lock);
 			if (xa_is_err(old)) {
 				kfree(chann);
 				return xa_err(old);
-- 
2.51.0




