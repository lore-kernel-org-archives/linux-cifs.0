Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817793559F2
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046149; cv=none; b=pd4y7kxm+gSrYZLEMUyYdWBG3Gji4cFzqorp07M5kkSLFQ96xB9+5qbWAZzToxNx0IPqqm0hDVUZoObkYCRSmmvUot5YsN5YGqG1YAPGlm+yhop6s8Cn5YaSKs1MxDGiICucB2u1LuovygvJP9Lt1zGF4Wg5DEA7vQHkQlEUO1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046149; c=relaxed/simple;
	bh=4/1AwnuVfZExA2u7syAL9FPR5BgcjDtQ59IKDT+HQHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O2wqHvR0obgbhErbYWDFJcAVN4+5U0yTz6b90Hb2JOf1Ep386Ad16PpVwK1vi3v13us3kfzinv0x9o0kXKVgAOmXaE5S4a+1KmyZijuRrhL8xy4FOvsooGC62776oz6nH8lJ8z/JHbDr9WHRyZVwxb/xQWxJGIUgjX1R2GsdJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKag3x/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKag3x/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710B71F000E9;
	Sun, 21 Jun 2026 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046148;
	bh=eLFnzZN0+tg/aaJwFhsmd6PUBLdyfVPJ4kNdBEpDpUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKag3x/C1S31hbqM2K1UlYbix8CSVv/e7itgMlRthZvOs0NG6YYnKyN21lhk8IiJW
	 4uEaQlucUVC/m900vwLC4NLmh5xH9HwBvRBppx3vXNBvtLrVkIxca7VpyZdi18/QDs
	 TNHElPppCj5YGYYuT1oYEuVT1HIfA5TDgAiLKReLzy99k2dN/qDlMQrynW95EOFA6k
	 7r8U6q/N/OOa7jzHOLEpu6XzEDhh2cs6t1RKunjKNk3EI8i+a7UdThrRjNt3Nsyd0t
	 1nDD0HsDTdIhAsYqTsAC53RaUNh9hApLvDyHA24AfecBz/p8b09IoZHe/vF6ZbaqTU
	 +xZo6eWjnxiGA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 09/29] ksmbd: propagate failed command status in related compounds
Date: Sun, 21 Jun 2026 21:48:24 +0900
Message-Id: <20260621124844.6235-9-linkinjeon@kernel.org>
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

In a related compound request, later commands can refer to the file handle
from an earlier command using the related FID value. If the earlier
command fails without producing a valid compound FID, the later related
commands must fail with the same status instead of operating on an invalid
or stale handle.

smb2.compound.related4 sends CREATE followed by IOCTL, CLOSE and SET_INFO.
The CREATE is expected to fail with STATUS_ACCESS_DENIED, and the remaining
related commands are expected to return STATUS_ACCESS_DENIED as well. ksmbd
only stored the compound FID on successful CREATE and did not remember
failed compound statuses.

Store the failed status in the work item and make related handle-based
requests fail immediately with that status only when the compound FID is
invalid. Also preserve and consume the related FID across successful
FLUSH, READ and WRITE requests whose responses do not carry a file id. Keep
a valid compound FID across non-close failures so later related commands
can continue to use the handle.

When extracting the FID from a successful READ, WRITE or FLUSH request, use
the request structure matching the SMB2 command: READ and WRITE place
PersistentFileId and VolatileFileId at a different offset than FLUSH, so a
single smb2_flush_req cast can save the wrong value as compound_fid and
make the following related request fail with STATUS_FILE_CLOSED
(smb2.compound_async.write_write after smb2.compound_async.flush_flush).
Only update the saved compound FID when the request carries a valid
volatile FID. otherwise an all-ones related FID would overwrite the CREATE
FID and break smb2.compound.related6.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.h |   1 +
 fs/smb/server/smb2pdu.c    | 159 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 156 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 5368430561fb..df0554a2c50d 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -60,6 +60,7 @@ struct ksmbd_work {
 	u64				compound_fid;
 	u64				compound_pfid;
 	u64				compound_sid;
+	__le32				compound_status;
 
 	const struct cred		*saved_cred;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f2ba52c7e325..df79533dc0a2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -405,6 +405,59 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		work->compound_fid = ((struct smb2_create_rsp *)rsp)->VolatileFileId;
 		work->compound_pfid = ((struct smb2_create_rsp *)rsp)->PersistentFileId;
 		work->compound_sid = le64_to_cpu(rsp->SessionId);
+		work->compound_status = STATUS_SUCCESS;
+	} else if ((req->Command == SMB2_FLUSH ||
+		    req->Command == SMB2_READ ||
+		    req->Command == SMB2_WRITE) &&
+		   rsp->Status == STATUS_SUCCESS) {
+		u64 volatile_id = KSMBD_NO_FID;
+		u64 persistent_id = KSMBD_NO_FID;
+
+		if (req->Command == SMB2_FLUSH) {
+			struct smb2_flush_req *flush_req =
+				(struct smb2_flush_req *)req;
+
+			volatile_id = flush_req->VolatileFileId;
+			persistent_id = flush_req->PersistentFileId;
+		} else if (req->Command == SMB2_READ) {
+			struct smb2_read_req *read_req =
+				(struct smb2_read_req *)req;
+
+			volatile_id = read_req->VolatileFileId;
+			persistent_id = read_req->PersistentFileId;
+		} else {
+			struct smb2_write_req *write_req =
+				(struct smb2_write_req *)req;
+
+			volatile_id = write_req->VolatileFileId;
+			persistent_id = write_req->PersistentFileId;
+		}
+
+		if (has_file_id(volatile_id)) {
+			work->compound_fid = volatile_id;
+			work->compound_pfid = persistent_id;
+			work->compound_sid = le64_to_cpu(rsp->SessionId);
+			work->compound_status = STATUS_SUCCESS;
+		}
+	} else if (req->Command == SMB2_CREATE) {
+		work->compound_fid = KSMBD_NO_FID;
+		work->compound_pfid = KSMBD_NO_FID;
+		work->compound_sid = le64_to_cpu(rsp->SessionId);
+		work->compound_status = rsp->Status;
+	} else if (rsp->Status != STATUS_SUCCESS) {
+		work->compound_sid = le64_to_cpu(rsp->SessionId);
+		/*
+		 * Only carry the failed status forward when the failing command
+		 * was itself part of the related chain. An unrelated command
+		 * that fails (e.g. a standalone request with a bad session id)
+		 * must not seed the status for a following related command,
+		 * which has to be evaluated on its own (and may legitimately
+		 * fail with a different status such as INVALID_PARAMETER). The
+		 * compound session id is still tracked so a following related
+		 * command can validate it.
+		 */
+		if (req->Flags & SMB2_FLAGS_RELATED_OPERATIONS)
+			work->compound_status = rsp->Status;
 	}
 
 	len = get_rfc1002_len(work->response_buf) - work->next_smb2_rsp_hdr_off;
@@ -430,6 +483,7 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "related flag should be set\n");
 		work->compound_fid = KSMBD_NO_FID;
 		work->compound_pfid = KSMBD_NO_FID;
+		work->compound_status = STATUS_SUCCESS;
 	}
 	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
 	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
@@ -449,6 +503,19 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 	memcpy(rsp_hdr->Signature, rcv_hdr->Signature, 16);
 }
 
+static bool smb2_compound_has_failed(struct ksmbd_work *work,
+				     struct smb2_hdr *rsp)
+{
+	if (!work->next_smb2_rcv_hdr_off ||
+	    has_file_id(work->compound_fid) ||
+	    work->compound_status == STATUS_SUCCESS)
+		return false;
+
+	rsp->Status = work->compound_status;
+	smb2_set_err_rsp(work);
+	return true;
+}
+
 /**
  * is_chained_smb2_message() - check for chained command
  * @work:	smb work containing smb request buffer
@@ -4608,11 +4675,28 @@ int smb2_query_dir(struct ksmbd_work *work)
 	unsigned char srch_flag;
 	int buffer_sz;
 	struct smb2_query_dir_private query_dir_private = {NULL, };
+	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	ksmbd_debug(SMB, "Received smb2 query directory request\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
 	if (ksmbd_override_fsids(work)) {
 		rsp->hdr.Status = STATUS_NO_MEMORY;
 		smb2_set_err_rsp(work);
@@ -4625,7 +4709,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		goto err_out2;
 	}
 
-	dir_fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	dir_fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!dir_fp) {
 		rc = -EBADF;
 		goto err_out2;
@@ -6088,6 +6172,9 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
 	if (ksmbd_override_fsids(work)) {
 		rc = -ENOMEM;
 		goto err_out;
@@ -6192,6 +6279,9 @@ int smb2_close(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		ksmbd_debug(SMB, "IPC pipe close request\n");
@@ -6862,6 +6952,8 @@ int smb2_set_info(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
+		if (smb2_compound_has_failed(work, &rsp->hdr))
+			return -EACCES;
 		if (!has_file_id(req->VolatileFileId)) {
 			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
 				    work->compound_fid);
@@ -7093,6 +7185,8 @@ int smb2_read(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
+		if (smb2_compound_has_failed(work, &rsp->hdr))
+			return -EACCES;
 		if (!has_file_id(req->VolatileFileId)) {
 			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
 					work->compound_fid);
@@ -7366,11 +7460,28 @@ int smb2_write(struct ksmbd_work *work)
 	bool writethrough = false, is_rdma_channel = false;
 	int err = 0;
 	unsigned int max_write_size = work->conn->vals->max_write_size;
+	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	ksmbd_debug(SMB, "Received smb2 write request\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
 	if (test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_PIPE)) {
 		ksmbd_debug(SMB, "IPC pipe write request\n");
 		return smb2_write_pipe(work);
@@ -7415,7 +7526,7 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!fp) {
 		err = -ENOENT;
 		goto out;
@@ -7509,13 +7620,30 @@ int smb2_flush(struct ksmbd_work *work)
 {
 	struct smb2_flush_req *req;
 	struct smb2_flush_rsp *rsp;
+	u64 id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	int err;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	ksmbd_debug(SMB, "Received smb2 flush request(fid : %llu)\n", req->VolatileFileId);
 
-	err = ksmbd_vfs_fsync(work, req->VolatileFileId, req->PersistentFileId);
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
+	err = ksmbd_vfs_fsync(work, id, pid);
 	if (err)
 		goto out;
 
@@ -7734,11 +7862,29 @@ int smb2_lock(struct ksmbd_work *work)
 	LIST_HEAD(lock_list);
 	LIST_HEAD(rollback_list);
 	int prior_lock = 0, bkt;
+	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	ksmbd_debug(SMB, "Received smb2 lock request\n");
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
+	if (work->next_smb2_rcv_hdr_off &&
+	    !has_file_id(req->VolatileFileId)) {
+		ksmbd_debug(SMB, "Compound request set FID = %llu\n",
+			    work->compound_fid);
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
+	if (!has_file_id(id)) {
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+	}
+
+	fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!fp) {
 		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n", req->VolatileFileId);
 		err = -ENOENT;
@@ -8544,6 +8690,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
+		if (smb2_compound_has_failed(work, &rsp->hdr))
+			return -EACCES;
 		if (!has_file_id(req->VolatileFileId)) {
 			ksmbd_debug(SMB, "Compound request set FID = %llu\n",
 				    work->compound_fid);
@@ -9208,6 +9356,9 @@ int smb2_notify(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
+	if (smb2_compound_has_failed(work, &rsp->hdr))
+		return -EACCES;
+
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
 		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
 		smb2_set_err_rsp(work);
-- 
2.25.1

