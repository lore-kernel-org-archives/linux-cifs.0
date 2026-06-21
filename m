Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7127366049
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046142; cv=none; b=Fg9R5QZZEFi3xht6801Tzm34jJiIt0G00xy4l4tvKNIZfZniaUlG3A5y0NnneOU97Uson62A1judAxxpj6k1oPeD4/01khLC+VfYYeLk3lm3NdFTW+GiGoEh4dWcJaFe/EyzUId6uvPYn3uh52Xf3Bwha559pJVw+MyQkeVCm5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046142; c=relaxed/simple;
	bh=NI/fE4vLp2FbbivmaK6Z3vvyNVdJ148ZhCayr65RP9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HCt67YyaFWpHrJ/Iv4MD/5TvvtaHgtqLpFvVbuA9Rub9htRi7NLy3Uq0u1qyg8WHJ3Eq7dyM2dIDbK0ocCHZWV9v0PXiBZL/o4VDIVYIpe/XYDiUwOWJqJKfIFkQsaKRE9/R/qQ9AVZjt/0K1MnoMTKr/2C7PuH8m0QKeq7RLCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJ7EmXhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJ7EmXhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9495A1F000E9;
	Sun, 21 Jun 2026 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046140;
	bh=DuXDjUWoiwnMGR5JxD+H0741ZFRr0RR0iegtglyPtgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJ7EmXheuq/GVlKbvRzsMZPTUu/UDYbnR8IBvTwETE3frIj3ZLKE7KLkE+wZlKta3
	 zmj5ojsOcxPz46jTeroFfU8A8lMgQwe2EBYCtC6zCdPMiv/RkkvE3219DbtZmtKRq1
	 7nt5F+okbO4nd6LCUN7YJd+vdntoqHzJgD7KqXn9aUBR0B6UYMv3SPh1gMRwNJ00uK
	 5eP/Sr2xTuEDer4pj9axMu2Zs2ibpD5AgxOxurR6xheXkpaSiPDPY657G8iX8uWLBo
	 +bGM08C/7QLWilaeLxxZxDsRhqriGpIoPpsf0+Bw/kuWB1wh5tUsZ0f9dEKgZqZEJI
	 JW/soXSv+GXZQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 05/29] ksmbd: handle durable v2 app instance id
Date: Sun, 21 Jun 2026 21:48:20 +0900
Message-Id: <20260621124844.6235-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMB2_CREATE_APP_INSTANCE_ID create context is used with durable v2
opens to identify another open from the same application instance. When
a new durable v2 open arrives with the same AppInstanceId as an existing
open, the server should close the previous open without sending an
oplock break notification.

ksmbd ignored this create context. A second durable v2 batch oplock open
with the same AppInstanceId therefore went through the normal competing
open path and sent an oplock break to the first opener. smbtorture
smb2.durable-v2-open.app-instance expects no oplock break and then
expects the old handle to be closed.

Parse and store AppInstanceId for durable v2 opens. Before creating the
new open, find an existing file with the same AppInstanceId and close it
through the normal close teardown path without issuing an oplock break.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 37 ++++++++++++++++++++
 fs/smb/server/vfs_cache.c | 72 +++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 110 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 35db86da79d3..a21760394637 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2807,8 +2807,10 @@ struct durable_info {
 	unsigned short int type;
 	bool persistent;
 	bool reconnected;
+	bool app_instance_id;
 	unsigned int timeout;
 	char *CreateGuid;
+	char AppInstanceId[SMB2_CREATE_GUID_SIZE];
 };
 
 static int parse_durable_handle_context(struct ksmbd_work *work,
@@ -2993,6 +2995,31 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 	return err;
 }
 
+static int parse_app_instance_id(struct smb2_create_req *req,
+				 struct durable_info *dh_info)
+{
+	struct create_context *context;
+	char *data;
+
+	context = smb2_find_context_vals(req, SMB2_CREATE_APP_INSTANCE_ID,
+					 SMB2_CREATE_GUID_SIZE);
+	if (IS_ERR(context))
+		return PTR_ERR(context);
+	if (!context)
+		return 0;
+
+	if (le32_to_cpu(context->DataLength) < 20)
+		return -EINVAL;
+
+	data = (char *)context + le16_to_cpu(context->DataOffset);
+	if (data[0] != 20 || data[1])
+		return -EINVAL;
+
+	memcpy(dh_info->AppInstanceId, data + 4, SMB2_CREATE_GUID_SIZE);
+	dh_info->app_instance_id = true;
+	return 0;
+}
+
 /**
  * smb2_open() - handler for smb file open request
  * @work:	smb work containing request buffer
@@ -3135,6 +3162,9 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB, "error parsing durable handle context\n");
 			goto err_out2;
 		}
+		rc = parse_app_instance_id(req, &dh_info);
+		if (rc)
+			goto err_out2;
 
 		if (dh_info.reconnected == true) {
 			rc = smb2_check_durable_oplock(conn, share, dh_info.fp,
@@ -3161,6 +3191,9 @@ int smb2_open(struct ksmbd_work *work)
 
 			goto reconnected_fp;
 		}
+
+		if (dh_info.type == DURABLE_REQ_V2 && dh_info.app_instance_id)
+			ksmbd_close_fd_app_instance_id(dh_info.AppInstanceId);
 	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
 		lc = parse_lease_state(req);
 		if (IS_ERR(lc)) {
@@ -3775,6 +3808,10 @@ int smb2_open(struct ksmbd_work *work)
 		if (dh_info.type == DURABLE_REQ_V2) {
 			memcpy(fp->create_guid, dh_info.CreateGuid,
 					SMB2_CREATE_GUID_SIZE);
+			if (dh_info.app_instance_id)
+				memcpy(fp->app_instance_id,
+				       dh_info.AppInstanceId,
+				       SMB2_CREATE_GUID_SIZE);
 			if (dh_info.timeout)
 				fp->durable_timeout =
 					min_t(unsigned int, dh_info.timeout,
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 3546d95df76f..5a2fddadcddf 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -37,6 +37,8 @@ static struct ksmbd_file_table global_ft;
 static atomic_long_t fd_limit;
 static struct kmem_cache *filp_cache;
 
+static int ksmbd_mark_fp_closed(struct ksmbd_file *fp);
+
 #define OPLOCK_NONE      0
 #define OPLOCK_EXCLUSIVE 1
 #define OPLOCK_BATCH     2
@@ -773,6 +775,76 @@ bool ksmbd_has_other_active_fd(struct ksmbd_file *fp)
 	return ret;
 }
 
+static struct ksmbd_file *ksmbd_lookup_fd_app_instance_id(char *app_instance_id)
+{
+	struct ksmbd_file *fp = NULL;
+	unsigned int id;
+
+	if (!memchr_inv(app_instance_id, 0, SMB2_CREATE_GUID_SIZE))
+		return NULL;
+
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		if (!memcmp(fp->app_instance_id, app_instance_id,
+			    SMB2_CREATE_GUID_SIZE)) {
+			fp = ksmbd_fp_get(fp);
+			break;
+		}
+	}
+	read_unlock(&global_ft.lock);
+
+	return fp;
+}
+
+int ksmbd_close_fd_app_instance_id(char *app_instance_id)
+{
+	struct ksmbd_file_table *ft;
+	struct ksmbd_file *fp;
+	struct oplock_info *opinfo;
+	int n_to_drop = 0;
+
+	fp = ksmbd_lookup_fd_app_instance_id(app_instance_id);
+	if (!fp)
+		return 0;
+
+	opinfo = opinfo_get(fp);
+	if (!opinfo || !opinfo->sess)
+		goto out;
+
+	ft = &opinfo->sess->file_table;
+	write_lock(&ft->lock);
+	if (fp->f_state == FP_INITED) {
+		if (has_file_id(fp->volatile_id)) {
+			idr_remove(ft->idr, fp->volatile_id);
+			fp->volatile_id = KSMBD_NO_FID;
+		}
+		n_to_drop = ksmbd_mark_fp_closed(fp);
+	}
+	write_unlock(&ft->lock);
+	opinfo_put(opinfo);
+	opinfo = NULL;
+
+	if (!n_to_drop)
+		goto out;
+
+	down_write(&fp->f_ci->m_lock);
+	list_del_init(&fp->node);
+	up_write(&fp->f_ci->m_lock);
+
+	if (atomic_sub_and_test(n_to_drop, &fp->refcount)) {
+		if (fp->conn)
+			atomic_dec(&fp->conn->stats.open_files_count);
+		__ksmbd_close_fd(NULL, fp);
+	}
+	return 0;
+
+out:
+	if (opinfo)
+		opinfo_put(opinfo);
+	ksmbd_put_durable_fd(fp);
+	return 0;
+}
+
 int ksmbd_invalidate_durable_fd(unsigned long long id)
 {
 	struct ksmbd_file *fp;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 4803f41a91ef..ca391d597e2e 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -168,6 +168,7 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);
 int ksmbd_invalidate_durable_fd(unsigned long long id);
 bool ksmbd_has_other_active_fd(struct ksmbd_file *fp);
+int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
-- 
2.25.1

