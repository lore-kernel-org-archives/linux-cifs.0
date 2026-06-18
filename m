Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794692609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792268; cv=none; b=Vx8yZOhZDlIgY2UlGoE1QyFOiGh18oxDfd3bqrs924KhC9IcbdRkJ/Yn8rhyNvOPj77sfJgdUhtT5yuu+xvbc3xn7LmKeAePvd0d7TmjByPqZ5y4JFdVL70EHWObnxSpzOPFH10FIMLyW6j9F+PN4G96bg1SW1iysLTHJ0MqEjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792268; c=relaxed/simple;
	bh=MSTVuepRi5wUKv2YzZx+vniU1D3nEYfIfGBRU1sL4OA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pbzd1h2ctbJiPDrZgk1rDSxmxd3QmJ/rOgyo4GPtmOpsgsZ4j75w1fXPnnN/capBEmv55bxC3elosfl5QDzjHyOvoQgvaQiq+bGLDqKdxdOJUFYJ4yfn3p7Vt0m9+jA90IoBpZ6DVk0EfwMHXyQvjEoQDvZFT1URx8y0x0/tMuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6ND+kPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6ND+kPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E341F00A3A;
	Thu, 18 Jun 2026 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792267;
	bh=QdACCytn40ePgYZXWUwlQjxsD37BetKTsvFz6kfLBMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n6ND+kPnW2tHl6NsekKHuTk9RTwIpDaWAL+eUZWlwvdJcWXW22jsthZsXwNfL/Nc0
	 8Eu2XUD98ubY9N3+22flqfzC3Slznk/jEygQKOoBzCBO3ZoG4TTPGlLpckVC0wg+7e
	 98UrlazyiDN4ifHiyj8cTeiXZ02ZS+VWkcXdpfbmIQfipEs8FUUHlsRo8SpI0tkDBt
	 YSO0ucUy38vREdSwtG9imhgAlUFjP7dnMdcnsS3hYX8bRkctLEvBeN0wRXKKUHxhGu
	 8cF0kO/Mzl8aaYqeyCUf2Pla7QQB4t2MZsLh01dCTxMxy53Aef9VkknEzmh5eZAQAR
	 EqnKznFItpHEw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 02/14] ksmbd: use connection ClientGUID for lease lookup
Date: Thu, 18 Jun 2026 23:17:27 +0900
Message-Id: <20260618141739.9029-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260618141739.9029-1-linkinjeon@kernel.org>
References: <20260618141739.9029-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MS-SMB2 defines the lease table lookup key as Connection.ClientGuid.
Use the connection ClientGUID consistently when checking for same-client
leases and duplicate lease keys.

Also preserve directory and parent lease metadata when copying an existing
lease state to a new open.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 16 +++++++++-------
 fs/smb/server/oplock.h  |  2 +-
 fs/smb/server/smb2pdu.c |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 5c6c0550a477..627cea7fd7ea 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -520,7 +520,7 @@ static inline int compare_guid_key(struct oplock_info *opinfo,
  * Return:      oplock(lease) object on success, otherwise NULL
  */
 static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
-						 char *client_guid,
+						 const char *client_guid,
 						 struct lease_ctx_info *lctx)
 {
 	int ret;
@@ -1012,7 +1012,7 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 	write_unlock(&lease_list_lock);
 }
 
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx)
 {
 	struct oplock_info *opinfo;
@@ -1029,7 +1029,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 	}
 
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
-		if (!memcmp(lb->client_guid, sess->ClientGUID,
+		if (!memcmp(lb->client_guid, conn->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE))
 			goto found;
 	}
@@ -1045,7 +1045,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 		rcu_read_unlock();
 		if (opinfo->o_fp->f_ci == ci)
 			goto op_next;
-		err = compare_guid_key(opinfo, sess->ClientGUID,
+		err = compare_guid_key(opinfo, conn->ClientGUID,
 				       lctx->lease_key);
 		if (err) {
 			err = -EINVAL;
@@ -1078,6 +1078,9 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch;
 	lease2->version = lease1->version;
+	lease2->is_dir = lease1->is_dir;
+	memcpy(lease2->parent_lease_key, lease1->parent_lease_key,
+	       SMB2_LEASE_KEY_SIZE);
 }
 
 static void add_lease_global_list(struct oplock_info *opinfo,
@@ -1216,7 +1219,6 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		     struct ksmbd_file *fp, __u16 tid,
 		     struct lease_ctx_info *lctx, int share_ret)
 {
-	struct ksmbd_session *sess = work->sess;
 	int err = 0;
 	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1259,12 +1261,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		struct oplock_info *m_opinfo;
 
 		/* is lease already granted ? */
-		m_opinfo = same_client_has_lease(ci, sess->ClientGUID,
+		m_opinfo = same_client_has_lease(ci, work->conn->ClientGUID,
 						 lctx);
 		if (m_opinfo) {
 			copy_lease(m_opinfo, opinfo);
 			if (atomic_read(&m_opinfo->breaking_cnt))
-				opinfo->o_lease->flags =
+				opinfo->o_lease->flags |=
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 			opinfo_put(m_opinfo);
 			goto out;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index d91a8266e065..795a9119dad9 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -116,7 +116,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 85fafd602740..3b4355c6a146 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3637,7 +3637,7 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "lease req for(%s) req oplock state 0x%x, lease state 0x%x\n",
 				    name, req_op_level, lc->req_state);
-			rc = find_same_lease_key(sess, fp->f_ci, lc);
+			rc = find_same_lease_key(conn, fp->f_ci, lc);
 			if (rc)
 				goto err_out1;
 		} else if (open_flags == O_RDONLY &&
-- 
2.25.1

