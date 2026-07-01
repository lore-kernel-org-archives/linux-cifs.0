Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79A83A5443
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894391; cv=none; b=S8RxiY6a7zILeHuAjEEPGq3Tjzv7AmLNuNDZyM9DQi9inKXHzVYRWdy4jT59XXbSmuOe8H0ACYMNFagp44Bx13uXlt5KAcE0vH6baxdXqfyO3PYqk2kAq6kThT9aC8bLi0ggfVzF9nW8aWjcPBdR+2GprDdM9ZjqaSdVL5pAdag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894391; c=relaxed/simple;
	bh=X4F2gAn23jV45CdGGzpYLOdq4F/A46QNtFRR4LUHS8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se5ExHjEtfznUAA5Nwguu1i4iNS24ZET/px5oHyO/g3MX79zOgKQTOMVIzxqIvHb+vV8mFex116wymaYrxRUPWugUzbr3bAFU2ohfLX0+r6++OkBaA8Dw6ieSgsyHvwnuAT3Pkh9nkKhc11+WwhvonF/aEyaDg3SiZGA8NWF498=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=tjrqWsXH; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="tjrqWsXH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWuOmzEfko1eSxdPVU+f75vI0exZLalguQquZYJskIw=;
	b=tjrqWsXHw+O2T8Wzuiyio0wdnApyJJFKuUcIj5c5i21zQQ1LuzVqfXG1uv4TeMh1LHKTR2
	cA+TTCESkcPXQNVavzn46uZGJh06Ss8UxglTjVazypU53NNkHgs4EZfhoVrAFNxuX+lPTd
	B2sAVV8mYy0tO7NImJG41b9h90KqQYt5elTTGh9Ju2v5FKMWNXBWpbileVnBScya134cWH
	Css7JQ22iVbucnPsLhBrcwqlXNyJWF3xmZxB7gvCOSlQdD3IbT17MaGN2AukV/ZAU0jIwn
	3czh+8sPAwQ1AqvGKp16JGKX0VdRjafKeHpx4CeYZAVeqtkqaei3aiKIKFPlqA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 8/9] smb/client: send SMB2 cancel requests
Date: Wed,  1 Jul 2026 08:25:06 +0000
Message-ID: <20260701082507.786487-9-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Wire up the generic cancel callback for SMB2 and later dialects. When a
synchronous wait is interrupted, the client can now send SMB2_CANCEL for
the outstanding mid instead of only marking the mid as cancelled locally.

Build cancel requests from the original request header so the message id,
session id, tree id, signing state, and any saved async id target the
request that is being abandoned. Encrypted shares wrap the cancel in a
transform request before sending it.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c       |   4 ++
 fs/smb/client/smb2proto.h     |   3 +
 fs/smb/client/smb2transport.c | 105 ++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 40f1ae0e9735..1f5dc1d9897f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5484,6 +5484,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_operations smb20_operations = {
+	.send_cancel = smb2_send_cancel,
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -5586,6 +5587,7 @@ struct smb_version_operations smb20_operations = {
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
 
 struct smb_version_operations smb21_operations = {
+	.send_cancel = smb2_send_cancel,
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -5690,6 +5692,7 @@ struct smb_version_operations smb21_operations = {
 };
 
 struct smb_version_operations smb30_operations = {
+	.send_cancel = smb2_send_cancel,
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -5806,6 +5809,7 @@ struct smb_version_operations smb30_operations = {
 };
 
 struct smb_version_operations smb311_operations = {
+	.send_cancel = smb2_send_cancel,
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 78a4e1c340f9..855d5c4637f0 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -40,6 +40,9 @@ int smb2_verify_signature(struct smb_rqst *rqst,
 			  struct TCP_Server_Info *server);
 int smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		       bool log_error);
+int smb2_send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
+		     struct smb_rqst *rqst, struct mid_q_entry *mid,
+		     unsigned int xid);
 struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 				       struct TCP_Server_Info *server,
 				       struct smb_rqst *rqst);
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 1143ee52470a..3c113e0e17b1 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -591,6 +591,111 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		return 0;
 }
 
+int
+smb2_send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
+		 struct smb_rqst *rqst, struct mid_q_entry *mid,
+		 unsigned int xid)
+{
+	struct smb2_pdu *req;
+	struct smb2_hdr *shdr;
+	struct smb2_transform_hdr tr_hdr;
+	struct smb_rqst new_rqst[2] = {};
+	struct kvec tr_iov = {
+		.iov_base = &tr_hdr,
+		.iov_len = sizeof(tr_hdr),
+	};
+	struct kvec iov[1];
+	struct smb_rqst crqst = {
+		.rq_iov = iov,
+		.rq_nvec = 1,
+	};
+	struct cifs_tcon *tcon;
+	__le32 flags;
+	__le32 pid;
+	__le32 tid;
+	__le64 sid;
+	__u64 async_id;
+	bool async_cmd;
+	bool encrypt = false;
+	int rc;
+
+	if (!ses || !server || !rqst || !rqst->rq_iov || !mid)
+		return -EINVAL;
+
+	if (rqst->rq_iov[0].iov_len < sizeof(struct smb2_hdr) + 4)
+		return -EINVAL;
+
+	req = rqst->rq_iov[0].iov_base;
+	if (!req)
+		return -EINVAL;
+
+	shdr = &req->hdr;
+	flags = shdr->Flags & SMB2_FLAGS_SIGNED;
+	pid = shdr->Id.SyncId.ProcessId;
+	tid = shdr->Id.SyncId.TreeId;
+	sid = shdr->SessionId;
+	spin_lock(&mid->mid_lock);
+	async_cmd = mid->async_cmd;
+	async_id = mid->async_id;
+	spin_unlock(&mid->mid_lock);
+
+	tcon = smb2_find_smb_tcon(server, le64_to_cpu(sid), le32_to_cpu(tid));
+	if (tcon) {
+		encrypt = smb3_encryption_required(tcon);
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_mid);
+	}
+	if (encrypt)
+		flags = 0;
+
+	/* SMB2_CANCEL targets an existing mid and does not get a response. */
+	memset(req, 0, sizeof(struct smb2_hdr) + 4);
+	shdr->ProtocolId = SMB2_PROTO_NUMBER;
+	shdr->StructureSize = SMB2_HEADER_STRUCTURE_SIZE;
+	shdr->Command = SMB2_CANCEL;
+	shdr->Flags = flags;
+	shdr->MessageId = cpu_to_le64(mid->mid);
+	if (async_cmd) {
+		shdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+		shdr->Id.AsyncId = cpu_to_le64(async_id);
+	} else {
+		shdr->Id.SyncId.ProcessId = pid;
+		shdr->Id.SyncId.TreeId = tid;
+	}
+	shdr->SessionId = sid;
+	req->StructureSize2 = cpu_to_le16(4);
+
+	iov[0].iov_base = req;
+	iov[0].iov_len = sizeof(struct smb2_hdr) + 4;
+
+	cifs_server_lock(server);
+	if (encrypt) {
+		if (!server->ops->init_transform_rq) {
+			rc = smb_EIO(smb_eio_trace_tx_need_transform);
+			goto unlock;
+		}
+
+		new_rqst[0].rq_iov = &tr_iov;
+		new_rqst[0].rq_nvec = 1;
+		rc = server->ops->init_transform_rq(server, 2, new_rqst,
+						    &crqst);
+		if (!rc) {
+			rc = __smb_send_cancel_rqst(server, 2, new_rqst);
+			smb3_free_compound_rqst(1, &new_rqst[1]);
+		}
+	} else {
+		rc = smb2_sign_rqst(&crqst, server);
+		if (!rc)
+			rc = __smb_send_cancel_rqst(server, 1, &crqst);
+	}
+
+unlock:
+	cifs_server_unlock(server);
+
+	cifs_dbg(FYI, "issued SMB2_CANCEL for mid %llu xid=%u rc=%d\n",
+		 mid->mid, xid, rc);
+	return rc;
+}
+
 /*
  * Set message id for the request. Should be called after wait_for_free_request
  * and when srv_mutex is held.
-- 
2.54.0

