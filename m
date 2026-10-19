Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3910726738D
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792371369; cv=none; b=UZcejZy7aBINyeXKOBJETmqeNFALvFhjtdGA6LrygrDs2SiP7BXLrswunf0d9Z3oTccdegvM+hfgZF5M31pA9SqsosMJZ5Tx6rRD4jhNYJh4osSCpbGrOQeHDRZaFHrEkzZRJDjpkgJbXR/D+vGlOBlxEPXT52gVZdAXtWTJccw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792371369; c=relaxed/simple;
	bh=vU14BXxC8zq5MdWi8lrn8ZOcCW+B8QahWKs+w08pUMs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kVyUtq40EMLycmQWH7yDIKoVvVhBTvJLrMoHQ8Y7guY2lzkYEerOvsuFeMmF6kLw1i8+6RB/ZOCuTb5MW+rZoxAAcNdf3GrNVRD7AX3sExGaIo2nCke7TEAIWRojp8hvyXWtGeAzM3/C5+Y8Rq8CovKCb47n0a9F6NavVG5Z6bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYachGek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYachGek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C7F1F000C4;
	Mon, 19 Oct 2026 00:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792371367;
	bh=k28CQuamCaK6ycuCXf/JHsjxEdbpMBKqLHEkg4+tK1c=;
	h=From:To:Cc:Subject:Date;
	b=CYachGekKXtt2FJIf1PNz+MeS2jY2MdSk2FToWpEnSm3GQHXwy+GT+f/q3GPc6JT5
	 0vxX+EX5F7sUnDxWdg2OCO46T9URyIbO5KoC0UFqKlW/ocBOuph6C8kRZezqwmz0Xk
	 PGlpewVmEIEY1RGkphs2gxeZdxPmqpkEHysaiwQaCUIpSIDiFs1xt3EQ6R/LxQr7CR
	 dsxPbPg98V+oJ6lZ/A4Lge6oddJQ6EKaPtpc0TfSG+pkHO/HV/Ban979lvWIH9y1ex
	 UxaTiRTRKCA2Gc5aipmapbXm6xfVXnbrUn7jNbD9xVcChpkoMOJ+es2I6DLUtCkD54
	 PoKaDFXmkcu2g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] ksmbd: inherit FileIds in related compound requests
Date: Mon, 19 Oct 2026 09:56:03 +0900
Message-Id: <20261019005603.5813-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MS-SMB2 specifies that subsequent related operations use the FileId from
the preceding operation. Track FileIds from handle-bearing requests so
related requests that use the all-ones placeholder resolve to the
inherited handle.

Return STATUS_INVALID_HANDLE when a related request refers to a FileId
but the preceding operation neither contained nor generated one.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.h |   9 ++-
 fs/smb/server/server.c     |   5 +-
 fs/smb/server/smb2pdu.c    | 150 ++++++++++++++++++++++++++++---------
 fs/smb/server/smb2pdu.h    |   1 +
 4 files changed, 126 insertions(+), 39 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index b51dea69cb0e..1ab9ddd20506 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -54,10 +54,7 @@ struct ksmbd_work {
 	/* Current cmd hdr in compound rsp buf*/
 	int                             curr_smb2_rsp_hdr_off;
 
-	/*
-	 * Current Local FID assigned compound response if SMB2 CREATE
-	 * command is present in compound request
-	 */
+	/* FileId generated or used by the previous operation in a compound. */
 	u64				compound_fid;
 	u64				compound_pfid;
 	u64				compound_sid;
@@ -93,6 +90,10 @@ struct ksmbd_work {
 	bool                            asynchronous:1;
 	bool                            need_invalidate_rkey:1;
 	bool				request_open_chseq_tracked:1;
+	/* The previous command carries a FileId or is a CREATE. */
+	bool				compound_fid_present:1;
+	/* A related command failed because there was no FileId to inherit. */
+	bool				compound_fid_missing:1;
 	bool				session_setup_reauth:1;
 	/* Retain the binding decision for response signing and preauth hashing. */
 	bool				session_setup_binding:1;
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index c836e75b4825..064f99427ca6 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -157,7 +157,10 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 		}
 	}
 
-	ret = cmds->proc(work);
+	if (smb2_check_compound_fid(work))
+		ret = -EBADF;
+	else
+		ret = cmds->proc(work);
 	if (conn->ops->inc_reqs) {
 		struct smb2_hdr *rsp = ksmbd_resp_buf_curr(work);
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 97b1e5ac5115..8de3a83e7341 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -456,6 +456,95 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	return 0;
 }
 
+static bool smb2_get_file_ids(struct smb2_hdr *hdr, u64 *volatile_id,
+			      u64 *persistent_id)
+{
+	unsigned int offset;
+
+	switch (hdr->Command) {
+	case SMB2_CLOSE:
+		offset = offsetof(struct smb2_close_req, PersistentFileId);
+		break;
+	case SMB2_FLUSH:
+		offset = offsetof(struct smb2_flush_req, PersistentFileId);
+		break;
+	case SMB2_READ:
+		offset = offsetof(struct smb2_read_req, PersistentFileId);
+		break;
+	case SMB2_WRITE:
+		offset = offsetof(struct smb2_write_req, PersistentFileId);
+		break;
+	case SMB2_LOCK:
+		offset = offsetof(struct smb2_lock_req, PersistentFileId);
+		break;
+	case SMB2_IOCTL: {
+		struct smb2_ioctl_req *req = (struct smb2_ioctl_req *)hdr;
+
+		switch (le32_to_cpu(req->CtlCode)) {
+		case FSCTL_DFS_GET_REFERRALS:
+		case FSCTL_DFS_GET_REFERRALS_EX:
+		case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
+		case FSCTL_VALIDATE_NEGOTIATE_INFO:
+		case FSCTL_PIPE_WAIT:
+			return false;
+		}
+		offset = offsetof(struct smb2_ioctl_req, PersistentFileId);
+		break;
+	}
+	case SMB2_QUERY_DIRECTORY:
+		offset = offsetof(struct smb2_query_directory_req, PersistentFileId);
+		break;
+	case SMB2_CHANGE_NOTIFY:
+		offset = offsetof(struct smb2_change_notify_req, PersistentFileId);
+		break;
+	case SMB2_QUERY_INFO:
+		offset = offsetof(struct smb2_query_info_req, PersistentFileId);
+		break;
+	case SMB2_SET_INFO:
+		offset = offsetof(struct smb2_set_info_req, PersistentFileId);
+		break;
+	case SMB2_OPLOCK_BREAK:
+		if (((struct smb2_oplock_break *)hdr)->StructureSize !=
+		    cpu_to_le16(OP_BREAK_STRUCT_SIZE_20))
+			return false;
+		offset = offsetof(struct smb2_oplock_break, PersistentFid);
+		break;
+	default:
+		return false;
+	}
+
+	/* FileId contains consecutive persistent and volatile opaque values. */
+	memcpy(persistent_id, (char *)hdr + offset, sizeof(*persistent_id));
+	memcpy(volatile_id, (char *)hdr + offset + sizeof(*persistent_id),
+	       sizeof(*volatile_id));
+	return true;
+}
+
+/* Called after message validation and signature verification. */
+bool smb2_check_compound_fid(struct ksmbd_work *work)
+{
+	struct smb2_hdr *req = ksmbd_req_buf_next(work);
+	struct smb2_hdr *rsp = ksmbd_resp_buf_next(work);
+	u64 volatile_id, persistent_id;
+
+	if (!work->next_smb2_rcv_hdr_off ||
+	    !(req->Flags & SMB2_FLAGS_RELATED_OPERATIONS))
+		return false;
+
+	if (!work->compound_fid_missing &&
+	    !work->compound_fid_present &&
+	    smb2_get_file_ids(req, &volatile_id, &persistent_id))
+		work->compound_fid_missing = true;
+
+	if (!work->compound_fid_missing)
+		return false;
+
+	/* MS-SMB2 3.3.5.2.7.2 requires all subsequent operations to fail too. */
+	rsp->Status = STATUS_INVALID_HANDLE;
+	smb2_set_err_rsp(work);
+	return true;
+}
+
 /**
  * init_chained_smb2_rsp() - initialize smb2 chained response
  * @work:	smb work containing smb response buffer
@@ -468,6 +557,21 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 	struct smb2_hdr *rcv_hdr;
 	int next_hdr_offset = 0;
 	int len, new_len;
+	u64 volatile_id = KSMBD_NO_FID, persistent_id = KSMBD_NO_FID;
+	bool req_has_fid;
+
+	req_has_fid = smb2_get_file_ids(req, &volatile_id, &persistent_id);
+	/* A failed CREATE is handled through compound_status instead. */
+	work->compound_fid_present = req_has_fid || req->Command == SMB2_CREATE;
+	if (!work->compound_fid_present) {
+		work->compound_fid = KSMBD_NO_FID;
+		work->compound_pfid = KSMBD_NO_FID;
+	}
+
+	/* Related requests keep the inherited SessionId. */
+	if (!work->next_smb2_rcv_hdr_off ||
+	    !(req->Flags & SMB2_FLAGS_RELATED_OPERATIONS))
+		work->compound_sid = le64_to_cpu(rsp->SessionId);
 
 	/* Len of this response = updated RFC len - offset of previous cmd
 	 * in the compound rsp
@@ -479,48 +583,24 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 	if (req->Command == SMB2_CREATE && rsp->Status == STATUS_SUCCESS) {
 		work->compound_fid = ((struct smb2_create_rsp *)rsp)->VolatileFileId;
 		work->compound_pfid = ((struct smb2_create_rsp *)rsp)->PersistentFileId;
-		work->compound_sid = le64_to_cpu(rsp->SessionId);
 		work->compound_status = STATUS_SUCCESS;
-	} else if ((req->Command == SMB2_FLUSH ||
-		    req->Command == SMB2_READ ||
-		    req->Command == SMB2_WRITE) &&
-		   rsp->Status == STATUS_SUCCESS) {
-		u64 volatile_id = KSMBD_NO_FID;
-		u64 persistent_id = KSMBD_NO_FID;
-
-		if (req->Command == SMB2_FLUSH) {
-			struct smb2_flush_req *flush_req =
-				(struct smb2_flush_req *)req;
-
-			volatile_id = flush_req->VolatileFileId;
-			persistent_id = flush_req->PersistentFileId;
-		} else if (req->Command == SMB2_READ) {
-			struct smb2_read_req *read_req =
-				(struct smb2_read_req *)req;
-
-			volatile_id = read_req->VolatileFileId;
-			persistent_id = read_req->PersistentFileId;
+	} else if (rsp->Status == STATUS_SUCCESS) {
+		if (req_has_fid && req->Command != SMB2_CLOSE) {
+			/* Preserve the inherited FID when the request uses all ones. */
+			if (has_file_id(volatile_id)) {
+				work->compound_fid = volatile_id;
+				work->compound_pfid = persistent_id;
+			}
 		} else {
-			struct smb2_write_req *write_req =
-				(struct smb2_write_req *)req;
-
-			volatile_id = write_req->VolatileFileId;
-			persistent_id = write_req->PersistentFileId;
-		}
-
-		if (has_file_id(volatile_id)) {
-			work->compound_fid = volatile_id;
-			work->compound_pfid = persistent_id;
-			work->compound_sid = le64_to_cpu(rsp->SessionId);
-			work->compound_status = STATUS_SUCCESS;
+			work->compound_fid = KSMBD_NO_FID;
+			work->compound_pfid = KSMBD_NO_FID;
 		}
+		work->compound_status = STATUS_SUCCESS;
 	} else if (req->Command == SMB2_CREATE) {
 		work->compound_fid = KSMBD_NO_FID;
 		work->compound_pfid = KSMBD_NO_FID;
-		work->compound_sid = le64_to_cpu(rsp->SessionId);
 		work->compound_status = rsp->Status;
 	} else if (rsp->Status != STATUS_SUCCESS) {
-		work->compound_sid = le64_to_cpu(rsp->SessionId);
 		/*
 		 * Only carry the failed status forward when the failing command
 		 * was itself part of the related chain. An unrelated command
@@ -559,6 +639,8 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		work->compound_fid = KSMBD_NO_FID;
 		work->compound_pfid = KSMBD_NO_FID;
 		work->compound_status = STATUS_SUCCESS;
+		work->compound_fid_present = false;
+		work->compound_fid_missing = false;
 	}
 	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
 	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index e706aa52352c..bd62e97938b8 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -421,6 +421,7 @@ bool is_smb2_rsp(struct ksmbd_work *work);
 u16 get_smb2_cmd_val(struct ksmbd_work *work);
 void set_smb2_rsp_status(struct ksmbd_work *work, __le32 err);
 int init_smb2_rsp_hdr(struct ksmbd_work *work);
+bool smb2_check_compound_fid(struct ksmbd_work *work);
 int smb2_allocate_rsp_buf(struct ksmbd_work *work);
 bool is_chained_smb2_message(struct ksmbd_work *work);
 int init_smb2_neg_rsp(struct ksmbd_work *work);
-- 
2.25.1

