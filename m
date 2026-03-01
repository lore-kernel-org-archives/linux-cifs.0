Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F742DCF67;
	Sun,  1 Mar 2026 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329609; cv=none; b=QhPz5RH3rniAuGZ3kktM8cGtJMW7VFQSONXznx+0oh7zZ80oS8IeuAgD83It1lXGNdQCNT8qcWqewNpXXpwVA6xhD/9KhS5lK6POZQcxdrTWCDJAm0uhVPGzwzmD6bmxcN+aTBwja04sWujECUZRKhnZ96Owgijfd3KohCScM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329609; c=relaxed/simple;
	bh=AcP9sno7F5Tu+dfxWSLMpnF+ZT9/ZZGCqkdEQdGDMV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G3Hy7/L453nVHHkKsYk5w0bc5t/6wgXRZKSwoIGwmu60zON+ATgtRJp+iesuqIFc77HB3I2yXkZomj9WgHYbQ4z9Z/JW6u7k0YbJ78dsMbWeMljOUELteDPG2b36LcmRONoR098a9luPwNjuX4O9gtcc1LJP4NBj7khUSbpYWVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIvvC5Ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIvvC5Ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EDAC19421;
	Sun,  1 Mar 2026 01:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329609;
	bh=AcP9sno7F5Tu+dfxWSLMpnF+ZT9/ZZGCqkdEQdGDMV8=;
	h=From:To:Cc:Subject:Date:From;
	b=eIvvC5IeFJbFGySNPXploTyTiMUYXZZXOiv/Iht+m8v+93QA8I+8xlL20Y81UZ8br
	 45pe3tgNO2J3cne/xZbUg0XXgdhijmajPCffD+0whXPuVb8uYtxfgJdjWXVAJxf4+M
	 711GnT4UiAzfRTv7fAIiRsBcWsghJq2mzic85qGvg2wxGzAOcT2GnNQ7NEABjt30n9
	 vIuo1CAwfqpcfKKMRGjp6DaCSAJvYQCPEoW/RJkTCaH91v8tm+ucuWjb1mXSoaQWdG
	 tjxt8tpate/uYhxRWubDBNCxOQOnOo7GcCqRi6J2P4+fGWsN3WXeehOpfgOmn+vWAh
	 UPNx7g0PIa0lg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: Igor Stepansky <igor.stepansky@orca.security>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org
Subject: FAILED: Patch "ksmbd: add chann_lock to protect ksmbd_chann_list xarray" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:46 -0500
Message-ID: <20260301014647.1709841-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




