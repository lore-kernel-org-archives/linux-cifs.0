Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B6425F984
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659696; cv=none; b=ds8znXxxAv6rm6EiALiw6nVEAIdtN8Z1YDj/4U0U4bBZG/lZgF0oyrj7ejPFCbK2LtP/nr3b3v7I79Eavk34PWT51trf2Hnwr9ioljov7WHs404UwS12ViwqXQCIqAm8hbyyMyhjh/1Bs6gcT0n7EGhkbGTtQ6Fiyf3msBrl0n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659696; c=relaxed/simple;
	bh=Xcsa/vUrM59zSkR9BfiDp8riePk0QKU/ZKRnCDqFn20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JR6xKkQsIU9how5oFIG5DcGfhbMHDsX19RrrjDaLfA+yAb2PHme856/svJloQ6qfx4dGcJknt+4BxK7Gbvfxl6BhT7DvPUG+inHc4TpvoODs4SZIo+2u+bBkiFnK6RhqFcm6vaQK18JTCnShUH+Tnx1FXTLb/q0m8lFqleOQjj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrhqRWN4; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrhqRWN4"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82458495219so1106239b3a.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Feb 2026 09:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770659696; x=1771264496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKnD6Utj1BA/r+uw0GOlDUCqNKypNjUDF6q0/a2S7o4=;
        b=SrhqRWN4A+0ytRg2UqNrq88fbWbKPAFOoifvKkouDzn+hqnHC6ftFdUwOJctF6du8V
         HnnTKmZkKAxcni8aVcSRkGYFlBdy3F+hNA2i3VcwJbs+Fe+BDpeNqK5AvCvS+pqGuGGU
         oqNIQ3R3bKqQgQBgDwV8WIEVEudtUnH6iT+O8uoW2MaiHtDq3Sq21N2jL2zDYkSTEWO9
         BppKPD9jbNbTa0epuxJulYL4s/l49ReTiEpf+9x9Fxt7QS5k3sC6mLQc1zMbPuhtVGnK
         wpGiadGWyXPPWKsbGYBbh30DHMd2qg/wO4+OUkl9WKPrsCRAQy35Ch8bl4ZiEDaqtmt+
         OV9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659696; x=1771264496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DKnD6Utj1BA/r+uw0GOlDUCqNKypNjUDF6q0/a2S7o4=;
        b=haEwu2EslYkXONec3IblXpTX6yvhyfyAmPh60g+0KaOkzqmf0BlRG0cZf/Gha+TXsF
         JYqedYBAEB4lkQqk9MaYmQTYls8qgLJgh7nS6saBlOSiyPXxDbmd2JkHZrHX3Lh+nYed
         3dI5Xl3++79SOOC+Bb98mhN+0T4KMsBx+0nvQV80vzhEzshgijNXO6jA0qphGgicXETG
         wJN2fuoOfhVwjgDZGBL0C2ILEn1Mp33hdmhb8ejfdl+qCAKB0k2q/ZsGxxnkK/wugUPe
         V6zcQz2jrr1p5MMZVMQ1C6HeLkUAwd3qwE7X5fib+lsiYX7fb/oeOJW2CvvNak5FMSbg
         6vcA==
X-Forwarded-Encrypted: i=1; AJvYcCWFNRu3j3bCxnte6CX8fuIucdNAvaZwjv1Q9AjaHl71JU0HJhEyBZsasf6ruc7uO6f93IUr2mggKUJJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr2kRo+YnKJsz8uuaqF9Ebe4HBmm8rmETJ7D4q0bomcCJd8ndz
	+/gA9JG+1wIjC7yCo7WNVU6awf1LFSH2PR10K9YPdLATAX2zU20QPrD3
X-Gm-Gg: AZuq6aJvq2xwMgrG9K/3o3M+WstJWVn6xxSxBlrBz7Z6aUqWq06fHDRwWQjgmfIq/ea
	JykbcJddyt3J2vEtdgHBCqOteexrFhSu4nmr8aztb2mEwR479zgzhmMNBSfcAPiHgOTLrxh7r6U
	XKvYHGp4jA9va8HrhGWrMmbepvWx+SPTiPLXqeNl9gEUbwtGe3pB7TTagKSKjhZJkbK4lR3Be6j
	saK49u8Z6x5SjK7k50LjdxeXakkBYXtHerbTRjbWRxzVi4+HuFTsEgrAKyUAUXPPheNk5OB+8Sv
	IzE+f9QTwvZ6BwVbzQiArX3LukGLi9/29nSSdSM6s5i0IVfgM0OP4t23YiYLLtBIWvT8waODOp3
	T9pZUJyV1NvIWDV8knF9NHyVExrLG1K+24UWoHlJG1QCPISDw/jnTOsQz7fWS0yKStdgFCDkNL5
	Pe9RBRciESjruTYY3sjcLY/aY=
X-Received: by 2002:a05:6a00:2442:b0:81f:9a5b:e8fc with SMTP id d2e1a72fcca58-82441762e1fmr11176826b3a.54.1770659695428;
        Mon, 09 Feb 2026 09:54:55 -0800 (PST)
Received: from archlinux ([103.208.68.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244166f3e2sm11232882b3a.10.2026.02.09.09.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 09:54:55 -0800 (PST)
From: Adarsh Das <adarshdas950@gmail.com>
To: sfrench@samba.org,
	linkinjeon@kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adarsh Das <adarshdas950@gmail.com>
Subject: [PATCH 2/2] smb: remove redundant == false comparisons
Date: Mon,  9 Feb 2026 23:24:21 +0530
Message-ID: <20260209175421.66469-3-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209175421.66469-1-adarshdas950@gmail.com>
References: <20260209175421.66469-1-adarshdas950@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace "== false" with "!" operator. This should improve readability.

Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
---
 fs/smb/client/cifsacl.c        |  2 +-
 fs/smb/client/connect.c        |  2 +-
 fs/smb/client/file.c           |  5 ++---
 fs/smb/client/fs_context.c     |  6 +++---
 fs/smb/client/smb2misc.c       |  4 ++--
 fs/smb/client/smb2ops.c        |  8 ++++----
 fs/smb/client/smb2pdu.c        |  2 +-
 fs/smb/client/transport.c      |  2 +-
 fs/smb/server/oplock.c         |  6 +++---
 fs/smb/server/smb2misc.c       |  2 +-
 fs/smb/server/smb2pdu.c        | 32 +++++++++++++++-----------------
 fs/smb/server/smb_common.c     |  2 +-
 fs/smb/server/transport_rdma.c |  2 +-
 fs/smb/server/vfs_cache.c      |  4 ++--
 14 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 7e6e473bd4a0..4771e310cac3 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -367,7 +367,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
 		else
 			is_group = false;
 
-		if (is_well_known_sid(psid, &unix_id, is_group) == false)
+		if (!is_well_known_sid(psid, &unix_id, is_group))
 			goto try_upcall_to_get_id;
 
 		if (is_group) {
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 75137359757d..eaf2855625a4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2801,7 +2801,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		}
 	} else if ((tcon->capabilities & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
 	     && (ses->server->capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
-	     && (ctx->nopersistent == false)) {
+	     && !ctx->nopersistent) {
 		cifs_dbg(FYI, "enabling persistent handles\n");
 		tcon->use_persistent = true;
 	} else if (ctx->resilient) {
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 7ff5cc9c5c5b..bc218f34b7e8 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1350,7 +1350,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	 * not dirty locally we could do this.
 	 */
 	rc = server->ops->open(xid, &oparms, &oplock, NULL);
-	if (rc == -ENOENT && oparms.reconnect == false) {
+	if (rc == -ENOENT && !oparms.reconnect) {
 		/* durable handle timeout is expired - open the file again */
 		rc = server->ops->open(xid, &oparms, &oplock, NULL);
 		/* indicate that we need to relock the file */
@@ -1459,8 +1459,7 @@ int cifs_close(struct inode *inode, struct file *file)
 		cfile = file->private_data;
 		file->private_data = NULL;
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
-		if ((cfile->status_file_deleted == false) &&
-		    (smb2_can_defer_close(inode, dclose))) {
+		if (!cfile->status_file_deleted && smb2_can_defer_close(inode, dclose)) {
 			if (test_and_clear_bit(NETFS_ICTX_MODIFIED_ATTR, &cinode->netfs.flags)) {
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d4291d3a9a48..d95b4d3c8fe4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -851,7 +851,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 	}
 #endif
 
-	if (ctx->got_version == false)
+	if (!ctx->got_version)
 		pr_warn_once("No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.\n");
 
 
@@ -977,7 +977,7 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 	}
 	if (new_ctx->password &&
 	    (!old_ctx->password || strcmp(new_ctx->password, old_ctx->password))) {
-		if (need_recon == false) {
+		if (!need_recon) {
 			cifs_errorf(fc,
 				    "can not change password of active session during remount\n");
 			return -EINVAL;
@@ -1100,7 +1100,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
 
-	if (need_recon == false)
+	if (!need_recon)
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
 	else  {
 		if (ctx->password) {
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index f3cb62d91450..bc940034a72f 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -425,7 +425,7 @@ smb2_calc_size(void *buf)
 	 */
 	len += le16_to_cpu(pdu->StructureSize2);
 
-	if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
+	if (!has_smb2_data_area[le16_to_cpu(shdr->Command)])
 		goto calc_size_exit;
 
 	smb2_get_data_area_len(&offset, &data_length, shdr);
@@ -808,7 +808,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 	cancelled->cmd = cmd;
 	cancelled->mid = mid;
 	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
-	WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
+	WARN_ON(!queue_work(cifsiod_wq, &cancelled->work));
 
 	return 0;
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index edf5afb2ddd2..16a0e572f775 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3403,7 +3403,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	rc = -EOPNOTSUPP;
-	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
+	if (!keep_size && !CIFS_CACHE_READ(cifsi))
 		goto zero_range_exit;
 
 	rc = smb3_zero_data(file, tcon, offset, len, xid);
@@ -3414,7 +3414,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	 * do we also need to change the size of the file?
 	 */
 	new_size = offset + len;
-	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
+	if (!keep_size && (unsigned long long)i_size_read(inode) < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
 		if (rc >= 0) {
@@ -3643,7 +3643,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 				tcon->ses->Suid, off, len);
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
+		if (!keep_size) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
@@ -3653,7 +3653,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * Extending the file
 	 */
-	if ((keep_size == false) && i_size_read(inode) < off + len) {
+	if (!keep_size && i_size_read(inode) < off + len) {
 		rc = inode_newsize_ok(inode, off + len);
 		if (rc)
 			goto out;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5d57c895ca37..254409ddcc66 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1636,7 +1636,7 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 	if (rc == 0)
 		sess_data->ses->expired_pwd = false;
 	else if ((rc == -EACCES) || (rc == -EKEYEXPIRED) || (rc == -EKEYREVOKED)) {
-		if (sess_data->ses->expired_pwd == false)
+		if (!sess_data->ses->expired_pwd)
 			trace_smb3_key_expired(sess_data->server->hostname,
 					       sess_data->ses->user_name,
 					       sess_data->server->conn_id,
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 3b34c3f4da2d..b9809d4110e6 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -762,7 +762,7 @@ int cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server
 		rc = mid->mid_rc;
 		break;
 	default:
-		if (mid->deleted_from_q == false) {
+		if (!mid->deleted_from_q) {
 			list_del_init(&mid->qhead);
 			mid->deleted_from_q = true;
 		}
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a5967ac46604..3a0fdde9dade 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -583,7 +583,7 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
 		else if (opinfo->level <= req_op_level) {
-			if (opinfo->is_lease == false)
+			if (!opinfo->is_lease)
 				return 1;
 
 			if (opinfo->o_lease->state !=
@@ -594,7 +594,7 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 	}
 
 	if (opinfo->level <= req_op_level) {
-		if (opinfo->is_lease == false) {
+		if (!opinfo->is_lease) {
 			wake_up_oplock_break(opinfo);
 			return 1;
 		}
@@ -1816,7 +1816,7 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 	if (!opinfo)
 		return 0;
 
-	if (opinfo->is_lease == false) {
+	if (!opinfo->is_lease) {
 		if (lctx) {
 			pr_err("create context include lease\n");
 			ret = -EBADF;
diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index a1ddca21c47b..e303596c83a3 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -228,7 +228,7 @@ static int smb2_calc_size(void *buf, unsigned int *len)
 	if (hdr->Command == SMB2_LOCK)
 		*len -= sizeof(struct smb2_lock_element);
 
-	if (has_smb2_data_area[le16_to_cpu(hdr->Command)] == false)
+	if (!has_smb2_data_area[le16_to_cpu(hdr->Command)])
 		goto calc_size_exit;
 
 	ret = smb2_get_data_area_len(&offset, &data_length, hdr);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index de40ef7ac26a..8a62cd40c89a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1488,7 +1488,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		 * Reuse session if anonymous try to connect
 		 * on reauthetication.
 		 */
-		if (conn->binding == false && ksmbd_anonymous_user(user)) {
+		if (!conn->binding && ksmbd_anonymous_user(user)) {
 			ksmbd_free_user(user);
 			return 0;
 		}
@@ -1502,7 +1502,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		sess->user = user;
 	}
 
-	if (conn->binding == false && user_guest(sess->user)) {
+	if (!conn->binding && user_guest(sess->user)) {
 		rsp->SessionFlags = SMB2_SESSION_FLAG_IS_GUEST_LE;
 	} else {
 		struct authenticate_message *authblob;
@@ -2945,7 +2945,7 @@ int smb2_open(struct ksmbd_work *work)
 
 		ksmbd_debug(SMB, "converted name = %s\n", name);
 
-		if (posix_ctxt == false) {
+		if (!posix_ctxt) {
 			if (strchr(name, ':')) {
 				if (!test_share_config_flag(work->tcon->share_conf,
 							KSMBD_SHARE_FLAG_STREAMS)) {
@@ -3553,7 +3553,7 @@ int smb2_open(struct ksmbd_work *work)
 			query_disk_id = 1;
 		}
 
-		if (conn->is_aapl == false) {
+		if (!conn->is_aapl) {
 			context = smb2_find_context_vals(req, SMB2_CREATE_AAPL, 4);
 			if (IS_ERR(context)) {
 				rc = PTR_ERR(context);
@@ -4874,7 +4874,7 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	sinfo = (struct smb2_file_standard_info *)rsp->Buffer;
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
-	if (ksmbd_stream_fd(fp) == false) {
+	if (!ksmbd_stream_fd(fp)) {
 		sinfo->AllocationSize = cpu_to_le64(stat.blocks << 9);
 		sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
@@ -4945,7 +4945,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
-	if (ksmbd_stream_fd(fp) == false) {
+	if (!ksmbd_stream_fd(fp)) {
 		file_info->AllocationSize =
 			cpu_to_le64(stat.blocks << 9);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
@@ -4961,7 +4961,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->IndexNumber = cpu_to_le64(stat.ino);
 	file_info->EASize = 0;
 	file_info->AccessFlags = fp->daccess;
-	if (ksmbd_stream_fd(fp) == false)
+	if (!ksmbd_stream_fd(fp))
 		file_info->CurrentByteOffset = cpu_to_le64(fp->filp->f_pos);
 	else
 		file_info->CurrentByteOffset = cpu_to_le64(fp->stream.pos);
@@ -5152,7 +5152,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	time = ksmbd_UnixTimeToNT(stat.ctime);
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
-	if (ksmbd_stream_fd(fp) == false) {
+	if (!ksmbd_stream_fd(fp)) {
 		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
@@ -5181,7 +5181,7 @@ static void get_file_position_info(struct smb2_query_info_rsp *rsp,
 	struct smb2_file_pos_info *file_info;
 
 	file_info = (struct smb2_file_pos_info *)rsp->Buffer;
-	if (ksmbd_stream_fd(fp) == false)
+	if (!ksmbd_stream_fd(fp))
 		file_info->CurrentByteOffset = cpu_to_le64(fp->filp->f_pos);
 	else
 		file_info->CurrentByteOffset = cpu_to_le64(fp->stream.pos);
@@ -5274,7 +5274,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->DosAttributes = fp->f_ci->m_fattr;
 	file_info->Inode = cpu_to_le64(stat.ino);
-	if (ksmbd_stream_fd(fp) == false) {
+	if (!ksmbd_stream_fd(fp)) {
 		file_info->EndOfFile = cpu_to_le64(stat.size);
 		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
 	} else {
@@ -6001,7 +6001,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	if (IS_ERR(new_name))
 		return PTR_ERR(new_name);
 
-	if (fp->is_posix_ctxt == false && strchr(new_name, ':')) {
+	if (!fp->is_posix_ctxt && strchr(new_name, ':')) {
 		int s_type;
 		char *xattr_stream_name, *stream_name = NULL;
 		size_t xattr_stream_size;
@@ -6283,8 +6283,7 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	 * truncate of some filesystem like FAT32 fill zero data in
 	 * truncated range.
 	 */
-	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC &&
-	    ksmbd_stream_fd(fp) == false) {
+	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC && !ksmbd_stream_fd(fp)) {
 		ksmbd_debug(SMB, "truncated to newsize %lld\n", newsize);
 		rc = ksmbd_vfs_truncate(work, fp, newsize);
 		if (rc) {
@@ -6357,7 +6356,7 @@ static int set_file_position_info(struct ksmbd_file *fp,
 		return -EINVAL;
 	}
 
-	if (ksmbd_stream_fd(fp) == false)
+	if (!ksmbd_stream_fd(fp))
 		fp->filp->f_pos = current_byte_offset;
 	else {
 		if (current_byte_offset > XATTR_SIZE_MAX)
@@ -7089,7 +7088,7 @@ int smb2_write(struct ksmbd_work *work)
 	if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 		writethrough = true;
 
-	if (is_rdma_channel == false) {
+	if (!is_rdma_channel) {
 		if (le16_to_cpu(req->DataOffset) <
 		    offsetof(struct smb2_write_req, Buffer)) {
 			err = -EINVAL;
@@ -8982,8 +8981,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 
 	hdr = ksmbd_resp_buf_curr(work);
 
-	if (conn->binding == false &&
-	    le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
+	if (!conn->binding && le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
 		signing_key = work->sess->smb3signingkey;
 	} else {
 		chann = lookup_chann_list(work->sess, work->conn);
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 1cd7e738434d..aeaf1cffa0da 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -415,7 +415,7 @@ int ksmbd_init_smb_server(struct ksmbd_conn *conn)
 	__le32 proto;
 
 	proto = *(__le32 *)rcv_hdr->Protocol;
-	if (conn->need_neg == false) {
+	if (!conn->need_neg) {
 		if (proto == SMB1_PROTO_NUMBER)
 			return -EINVAL;
 		return 0;
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e4273932e7e4..7f868162ace5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2785,7 +2785,7 @@ static bool ksmbd_find_rdma_capable_netdev(struct net_device *netdev)
 out:
 	read_unlock(&smb_direct_device_lock);
 
-	if (rdma_capable == false) {
+	if (!rdma_capable) {
 		struct ib_device *ibdev;
 
 		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index ea9c237b2bca..0f8009c136ed 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -810,7 +810,7 @@ static int ksmbd_durable_scavenger(void *dummy)
 		found_fp_timeout = false;
 
 		remaining_jiffies = wait_event_timeout(dh_wq,
-				   ksmbd_durable_scavenger_alive() == false,
+				   !ksmbd_durable_scavenger_alive(),
 				   __msecs_to_jiffies(min_timeout));
 		if (remaining_jiffies)
 			min_timeout = jiffies_to_msecs(remaining_jiffies);
@@ -846,7 +846,7 @@ static int ksmbd_durable_scavenger(void *dummy)
 
 		ksmbd_scavenger_dispose_dh(&scavenger_list);
 
-		if (found_fp_timeout == false)
+		if (!found_fp_timeout)
 			break;
 	}
 
-- 
2.53.0

