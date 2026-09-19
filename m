Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AEF3AC0E5
	for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789820966; cv=none; b=DOKhtytS7xYltbA/97/nWIxFMojTjEq3XKItIZaddSeApPXzKEsEdRC069ABfWFpCiurukMrxfpQ9WY+KVoEzSlW1HF477/QvboYw0bQqH3rXQ0Ng88V5ZQ7UAdqMGmxvcvVEIykhcaUpUBM9rJu5cLgUXXnhdG6QXSWPpBjFCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789820966; c=relaxed/simple;
	bh=b9EnGu9MHAIzx8noPmEkn3SGhoa0kENlp1Yv+S5oI6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+MxQzFdWHd8Ejs8t+ffubYUvLRZrlJvQao0HFA8R9+Xfw29WBqvZZIr92pUdlFu2j5Nf825ANd6uJblo92/QwFhRxby8MUwqEDtGzVS2AHxcgVYTpHzeosMUuxVZ0NEF+XqeobO8nu69na3eLqpfq3KwmZMYDjQneuYY1g1b9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oU/U4NKn; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oU/U4NKn"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so1240145a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789820964; x=1790425764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rSGMD4t/99hwguBKjZyOwue97u3u1kElgmaozxcSBno=;
        b=oU/U4NKn+AXRUxiwyTtk1LwQf909i9Vfepd/xbdq1LanSzmKIzesNK2Ixs+QnTQayv
         ZsOcuIdGL8xpFY6jSvVCMxWmPmy/4Vw7yW+7AweOAY3uEiNx29NjOSdiWiX7AHLA6AoI
         fbBHiaf08PkC9rGCi2Q/NP800pXi73+Wk6JzoKBvFqH0awm7CvjdM6a/h9Gg/5Q4NKax
         A6I8P8TLoFoOnHB9vup6yFAsRgbUkfetLLr4chf0WzCBJ9cMuGFYmFlbrwFr3pcX78OM
         izIBryh+OfooraDKeeCFRW0vpPP7x2sRcMlBML5ki36s5UDutEZJPzxxxa91kMmh/TgA
         gvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789820964; x=1790425764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rSGMD4t/99hwguBKjZyOwue97u3u1kElgmaozxcSBno=;
        b=lDUdDBTRSp65kQhWBF2kLKYRfrP0iAJ57sfZg/zE5NCJOuF85ebjJeXUpKD4VqPXUH
         PcrGdu2UKPstwF+jiXVG8PjVf12ntqrmOlugzSmntFH5dsds3UcsCXkP2nTEi4+WTA4s
         fMzZmZdMzdtzE27o35yj9h/Lgiev46GykvCgT1blZDAFtw5m071YJzGcZ4Ra7tXZdest
         n61s2LGhow2xNFKfgE5mIZyfHRcQZ6ZTOLM5IWjzSR94vIAt2CjwKG7aabBcW/BMgGb+
         U5m0Pd/tBJjBbElJ1b41I3eNhTIC8koDC+352l6hUTFWTC69eGMv48FhR/6wa+bAdll+
         FC7g==
X-Forwarded-Encrypted: i=1; AKwUvBwF7Cu/+G31IYWIU37MJK60G9mPHWri3C6Qf79WNT7JXGdbRVXYmjaBqeWJcl1MOJ7FiV147zMLjXgZ@vger.kernel.org
X-Gm-Message-State: AFuF++lYiWnCjKglttttvbFGwAb+RhUDsCMWQKA8WhfP/RRPeR1Dobbe
	ckUIiWXySmc8IzOrR6MpWMKTAulDiO5xEyR48ROan6YwUaSC8zSo0RCo
X-Gm-Gg: AYBFou3w9kZRveB8gEvrqfpJkB8kx8Jc3AzyV59Hc+eETuaBJ1xGsCJ+Ib4f+SV8VFz
	pUjwIQtK+m2iSpNU773BFEvmyxq/RD0Bnqb87Aubbo5d932zWJbSph9WZdGj6eZZqeNvvVIKqXv
	SD+V6Oj2NA/nwR5C9BQ6/PeBQs8S9P8EKICbslfeFk9QRgzF9y2VnRHo/rZTtqKPJpu8x39QLSi
	SdqHpiqu1mU1YV2ptyWMLtaOv5nEcOackAd1dl4wYdFqeYTwrxA2/Lh5D0HCHZpI3gJP0pFFqJj
	C8+dHYt3RJc+I+z9Yl9Xyi2vR6CZVDFdBFtQe9Oj/tCl4v7PZEMOdmQCHMasC2FFy2ZvHL5eXPM
	jnNAiwaILn65sayhkGdXqP8a9R2/OiHTJ6ubFWaIDvAkcJV0YO/aLZ98jXCeEVp5aUrsSYn9KNj
	QtijBZyLkLgUVINGV/zSMwK0NSpaBUI4qqvuAMlP0oXfdQRlmE0ImKcwTSjp7gWi4uFOObxbp27
	Gz/b5E=
X-Received: by 2002:a05:6a21:a393:b0:3dd:a196:69e8 with SMTP id adf61e73a8af0-3dda196789bmr3798920637.67.1789820963689;
        Sat, 19 Sep 2026 05:29:23 -0700 (PDT)
Received: from RyzenBox.localdomain ([137.59.96.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c331aef9bsm5978411eec.25.2026.09.19.05.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 05:29:23 -0700 (PDT)
From: Omkar Chandorkar <omkar0926@gmail.com>
X-Google-Original-From: Omkar Chandorkar <gotenksIN@aospa.co>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Omkar Chandorkar <gotenksIN@aospa.co>
Subject: [PATCH v1 2/3] ksmbd: fix compound CREATE and CHANGE_NOTIFY response handling
Date: Sat, 19 Sep 2026 17:59:09 +0530
Message-ID: <20260919122910.2382-3-gotenksIN@aospa.co>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919122910.2382-1-gotenksIN@aospa.co>
References: <20260919122910.2382-1-gotenksIN@aospa.co>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Windows 11 Explorer opens a directory on an SMB share, it emits a
compounded request chaining SMB2_CREATE with SMB2_CHANGE_NOTIFY under
SMB2_FLAGS_RELATED_OPERATIONS. The secondary CHANGE_NOTIFY command sets
VolatileFileId to SMB2_NO_FID (0xFFFFFFFFFFFFFFFF), expecting the server
to inherit the handle opened by the preceding CREATE command.

smb2_notify() currently checks:
    if (req->VolatileFileId == SMB2_NO_FID &&
        req->PersistentFileId == SMB2_NO_FID)
before resolving compound handles. Consequently, it misidentifies
Windows Explorer's compound directory open as a standalone macOS Time
Machine share-root sentinel.

Additionally, smb2_send_interim_resp() lacked compound prefix response
dispatching. When smb2_notify() transitions to an asynchronous state and
sets work->send_no_response = 1, the server drops the entire compound
response without transmitting the completed CREATE response to the
client. Windows Explorer is left blocked waiting for the directory open
reply until the 60-second SMB timeout expires.

Fix this by:
1. Resolving work->compound_fid and work->compound_pfid in smb2_notify()
   when SMB2_FLAGS_RELATED_OPERATIONS is set.
2. Restricting the macOS share-root sentinel check to standalone
   requests.
3. Backporting smb2_send_interim_compound_prefix() from mainline to
   immediately transmit the completed compound prefix responses
   (including the CREATE response) before dispatching the asynchronous
   interim response for CHANGE_NOTIFY.

Assisted-by: OpenCode:gpt-6-astra
Signed-off-by: Omkar Chandorkar <gotenksIN@aospa.co>
---
 fs/smb/server/smb2pdu.c | 128 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 124 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4cf7083f3..619ef0e11 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1095,6 +1095,107 @@ void release_async_work(struct ksmbd_work *work)
 	}
 }
 
+static int smb2_send_interim_work(struct ksmbd_work *in_work,
+				  struct ksmbd_work *work, bool eor)
+{
+	int err = 0;
+
+	in_work->encrypted = work->encrypted;
+	if (work->encrypted && work->sess && work->sess->enc &&
+	    work->conn->ops->encrypt_resp) {
+		in_work->sess = work->sess;
+		err = work->conn->ops->encrypt_resp(in_work);
+		in_work->sess = NULL;
+	}
+	if (err)
+		return err;
+
+	return ksmbd_conn_write(in_work);
+}
+
+static int smb2_send_interim_prefix_work(struct ksmbd_work *work)
+{
+	struct ksmbd_work *in_work;
+	unsigned int len, copied = 0;
+	char *dst;
+	int err = -ENOMEM;
+	int i;
+
+	len = get_rfc1002_len(work->iov[0].iov_base);
+	in_work = ksmbd_alloc_work_struct();
+	if (!in_work)
+		return err;
+
+	in_work->response_buf = kvzalloc(len + 4, KSMBD_DEFAULT_GFP);
+	if (!in_work->response_buf)
+		goto out;
+	in_work->response_sz = len + 4;
+	in_work->conn = work->conn;
+	dst = in_work->response_buf + 4;
+	for (i = 1; i <= work->iov_idx; i++) {
+		if (work->iov[i].iov_len > len - copied) {
+			err = -EINVAL;
+			goto out;
+		}
+		memcpy(dst + copied, work->iov[i].iov_base,
+		       work->iov[i].iov_len);
+		copied += work->iov[i].iov_len;
+	}
+	if (copied != len) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ksmbd_iov_pin_rsp(in_work, dst, len);
+	if (!err)
+		err = smb2_send_interim_work(in_work, work, true);
+out:
+	ksmbd_free_work_struct(in_work);
+	return err;
+}
+
+static void smb2_send_interim_compound_prefix(struct ksmbd_work *work)
+{
+	struct smb2_hdr *req_hdr;
+	struct smb2_hdr *rsp_hdr;
+	int err;
+
+	if (!work->next_smb2_rcv_hdr_off ||
+	    !work->next_smb2_rsp_hdr_off ||
+	    work->curr_smb2_rsp_hdr_off == work->next_smb2_rsp_hdr_off ||
+	    !work->iov_idx)
+		return;
+
+	req_hdr = ksmbd_req_buf_next(work);
+	/* Detach only the final async command from the completed prefix. */
+	if (req_hdr->NextCommand)
+		return;
+
+	/*
+	 * The responses before the async command are sent as a standalone
+	 * compound response. The last response in this prefix must terminate
+	 * the chain.
+	 */
+	rsp_hdr = ksmbd_resp_buf_curr(work);
+	rsp_hdr->NextCommand = 0;
+	if ((rsp_hdr->Flags & SMB2_FLAGS_SIGNED) && work->sess &&
+	    work->conn->ops->set_sign_rsp)
+		work->conn->ops->set_sign_rsp(work);
+
+	err = smb2_send_interim_prefix_work(work);
+	if (err)
+		ksmbd_debug(SMB, "failed to send compound interim prefix: %d\n",
+			    err);
+
+	work->iov_idx = 0;
+	work->iov_cnt = 0;
+	work->curr_smb2_rsp_hdr_off = work->next_smb2_rsp_hdr_off;
+	*(__be32 *)work->response_buf = 0;
+
+	rsp_hdr = ksmbd_resp_buf_next(work);
+	rsp_hdr->Flags &= ~SMB2_FLAGS_RELATED_OPERATIONS;
+}
+
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
@@ -1109,6 +1210,9 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 		return;
 	}
 
+	if (status == STATUS_PENDING)
+		smb2_send_interim_compound_prefix(work);
+
 	in_work->conn = work->conn;
 	memcpy(smb_get_msg(in_work->response_buf), ksmbd_resp_buf_next(work),
 	       __SMB2_HEADER_STRUCTURE_SIZE);
@@ -1119,7 +1223,8 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-	ksmbd_conn_write(in_work);
+	if (smb2_send_interim_work(in_work, work, true))
+		ksmbd_debug(SMB, "failed to send interim response\n");
 	ksmbd_free_work_struct(in_work);
 }
 
@@ -10405,6 +10510,7 @@ int smb2_notify(struct ksmbd_work *work)
 	struct ksmbd_work *in_work;
 	struct smb2_hdr *in_hdr;
 	struct ksmbd_file *fp;
+	u64 id, pid;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -10419,14 +10525,28 @@ int smb2_notify(struct ksmbd_work *work)
 		return -EIO;
 	}
 
+	id = req->VolatileFileId;
+	pid = req->PersistentFileId;
+	if (work->next_smb2_rcv_hdr_off &&
+	    (req->hdr.Flags & SMB2_FLAGS_RELATED_OPERATIONS)) {
+		if (!has_file_id(work->compound_fid)) {
+			rsp->hdr.Status = STATUS_INVALID_HANDLE;
+			smb2_set_err_rsp(work);
+			return 0;
+		}
+		id = work->compound_fid;
+		pid = work->compound_pfid;
+	}
+
 	/*
 	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF (share-root
 	 * sentinel) to watch for changes on the share root without holding an
 	 * open handle. Respond STATUS_PENDING + STATUS_NOTIFY_CLEANUP immediately;
 	 * without this, backupd aborts Time Machine setup on STATUS_FILE_CLOSED.
 	 */
-	if (req->VolatileFileId == SMB2_NO_FID &&
-	    req->PersistentFileId == SMB2_NO_FID) {
+	if (!work->next_smb2_rcv_hdr_off && !req->hdr.NextCommand &&
+	    !(req->hdr.Flags & SMB2_FLAGS_RELATED_OPERATIONS) &&
+	    id == SMB2_NO_FID && pid == SMB2_NO_FID) {
 		in_work = ksmbd_alloc_work_struct();
 		if (!in_work || allocate_interim_rsp_buf(in_work)) {
 			if (in_work)
@@ -10470,7 +10590,7 @@ int smb2_notify(struct ksmbd_work *work)
 	 * STATUS_NOT_IMPLEMENTED here (like stock ksmbd) makes macOS smbfs
 	 * hard-freeze on unmount, so this must stay deferred.
 	 */
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	fp = ksmbd_lookup_fd_slow(work, id, pid);
 	if (!fp) {
 		rsp->hdr.Status = STATUS_FILE_CLOSED;
 		smb2_set_err_rsp(work);
-- 
2.55.0

