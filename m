Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB52C2F5A
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 04:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732335449; cv=none; b=dMP8ygabFo+kJDV/CibQxsGo69eKCxVvI7ixIA6Q/XTVa+ediFhUwOSbg9IqJLzphYnu+Wtk0pcFJSeCsjT9f/fjwjGqbDB3AlrSLEw5k/DwwSEj7qC8m0i0CDn/ATKE6TIGqjEwA9p0KvusNhxQxOIzahuM+PnelyP3hGQO+iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732335449; c=relaxed/simple;
	bh=RxMcDSrxOHQ/iBIak0WWBpnpbf1q7kVdFbTR64haUrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vGQ0XKWwP2w7C6Qim4Vkw+hyBzVWY4BMM8RjBNbyOvSUtjd3SQ62bZ596ifF/bSyiVfBY8qZY56lzd5M3DhmdFRhotru5sYl8Gu2ZtrM17mRK7Saoaj3Zd9PFsycLy83TSgcLYovpbJYjP3Hi1JW71PTgMHil6NevLoohoAPRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-212008b0d6eso24157895ad.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732335447; x=1732940247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zu14a9uziauC+OgX1eqfoXcGkHNaDv7zB2oMQSmO5uA=;
        b=leSmmYORaPjZFa6ayvNdKEYLi5Jhw6ED4EVkj2hPRsKyPKTvXVv6sZeZ4KOqyeQChv
         SggjEbc5BYs0ChJQa9pGfw4xYvJjIyao6oAOzqDW9DBTvlvSTjUcqm8aIjt66zh0zWgf
         Mej6vOtsMdzB0b7jwW+aR+A1ESE0K6kZh5ityhZ5RQmJXZybG4xID3b3jkHFyqanV22y
         tQ8bB6RcXgtmqYZUUFgqJk3use65P+5eBR35Uh5+ZWpb6LUHE8/NNeAc2QSFlBDA/6eL
         r1uD7kEY9F90a94FgI3Osj9E/WvLKqXhY5a0lEDGZjuhaycrhnoQr7Xe1HzvdJmxZReD
         oksg==
X-Gm-Message-State: AOJu0YwTM1U0ep2yr1hNiFMRRjdXCxgdaElnlz2RL2wP36XTNvThIIkN
	otZj2lemd4Q0cB7OJoLm0tnm/25cL+fJuV+pbHy+vkj42abRzcWFvxW7kA==
X-Gm-Gg: ASbGncvTiPkmdz1cPRLxW1mGl711LBuVr3sMcMwBI28yvaqBmf4rFBpvntYw/7rRvTk
	CLw1uJ+3yhnEXrjbW7xN4TPee8GE1ZHtu8Ij3YbM5jdkezrE9d2gtRG5uZmJbow5Ww7q46v0MSB
	7Pgx7vxPFCEwSUQDjuSgOLXI/rdrlgH8AXsYQCSbhwoKrBTBO6trW/oysLFjdKkejsyT+B8Av/5
	qwBYvtD0YClsundB4sHelRWziXJuslHg7gQQTeZajjd//q+bnb6C9X7XjDqnrFU
X-Google-Smtp-Source: AGHT+IEMZWeIxxM1W9pJbvy3YMhIBTJ9bTHTpUv5s3pSjZjKFzC04eNGbOPenkVvU3k+aCCpZpdDyw==
X-Received: by 2002:a17:902:c94f:b0:205:4721:19c with SMTP id d9443c01a7336-2129f27ebc7mr84515635ad.37.1732335446755;
        Fri, 22 Nov 2024 20:17:26 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dba20e2sm24437805ad.94.2024.11.22.20.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 20:17:26 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/6] ksmbd: add debug prints to know what smb2 requests were received
Date: Sat, 23 Nov 2024 13:17:03 +0900
Message-Id: <20241123041706.4943-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241123041706.4943-1-linkinjeon@kernel.org>
References: <20241123041706.4943-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add debug prints to know what smb2 requests were received.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 61c82c755f6c..416f7df4edef 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1666,7 +1666,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
 
-	ksmbd_debug(SMB, "Received request for session setup\n");
+	ksmbd_debug(SMB, "Received smb2 session setup request\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -1940,6 +1940,8 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
+	ksmbd_debug(SMB, "Received smb2 tree connect request\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	treename = smb_strndup_from_utf16((char *)req + le16_to_cpu(req->PathOffset),
@@ -2136,9 +2138,9 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 	struct ksmbd_tree_connect *tcon = work->tcon;
 	int err;
 
-	WORK_BUFFERS(work, req, rsp);
+	ksmbd_debug(SMB, "Received smb2 tree disconnect request\n");
 
-	ksmbd_debug(SMB, "request\n");
+	WORK_BUFFERS(work, req, rsp);
 
 	if (!tcon) {
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
@@ -2203,7 +2205,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
-	ksmbd_debug(SMB, "request\n");
+	ksmbd_debug(SMB, "Received smb2 session logoff request\n");
 
 	ksmbd_conn_lock(conn);
 	if (!ksmbd_conn_good(conn)) {
@@ -2849,6 +2851,8 @@ int smb2_open(struct ksmbd_work *work)
 	__le32 daccess, maximal_access = 0;
 	int iov_len = 0;
 
+	ksmbd_debug(SMB, "Received smb2 create request\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	if (req->hdr.NextCommand && !work->next_smb2_rcv_hdr_off &&
@@ -4296,6 +4300,8 @@ int smb2_query_dir(struct ksmbd_work *work)
 	int buffer_sz;
 	struct smb2_query_dir_private query_dir_private = {NULL, };
 
+	ksmbd_debug(SMB, "Received smb2 query directory request\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	if (ksmbd_override_fsids(work)) {
@@ -5602,9 +5608,9 @@ int smb2_query_info(struct ksmbd_work *work)
 	struct smb2_query_info_rsp *rsp;
 	int rc = 0;
 
-	WORK_BUFFERS(work, req, rsp);
+	ksmbd_debug(SMB, "Received request smb2 query info request\n");
 
-	ksmbd_debug(SMB, "GOT query info request\n");
+	WORK_BUFFERS(work, req, rsp);
 
 	if (ksmbd_override_fsids(work)) {
 		rc = -ENOMEM;
@@ -5709,6 +5715,8 @@ int smb2_close(struct ksmbd_work *work)
 	u64 time;
 	int err = 0;
 
+	ksmbd_debug(SMB, "Received smb2 close request\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	if (test_share_config_flag(work->tcon->share_conf,
@@ -5825,6 +5833,8 @@ int smb2_echo(struct ksmbd_work *work)
 {
 	struct smb2_echo_rsp *rsp = smb2_get_msg(work->response_buf);
 
+	ksmbd_debug(SMB, "Received smb2 echo request\n");
+
 	if (work->next_smb2_rcv_hdr_off)
 		rsp = ksmbd_resp_buf_next(work);
 
@@ -6365,7 +6375,7 @@ int smb2_set_info(struct ksmbd_work *work)
 	int rc = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
-	ksmbd_debug(SMB, "Received set info request\n");
+	ksmbd_debug(SMB, "Received smb2 set info request\n");
 
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
@@ -6591,6 +6601,8 @@ int smb2_read(struct ksmbd_work *work)
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	void *aux_payload_buf;
 
+	ksmbd_debug(SMB, "Received smb2 read request\n");
+
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		ksmbd_debug(SMB, "IPC pipe read request\n");
@@ -6856,6 +6868,8 @@ int smb2_write(struct ksmbd_work *work)
 	int err = 0;
 	unsigned int max_write_size = work->conn->vals->max_write_size;
 
+	ksmbd_debug(SMB, "Received smb2 write request\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	if (test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_PIPE)) {
@@ -6994,7 +7008,7 @@ int smb2_flush(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
-	ksmbd_debug(SMB, "SMB2_FLUSH called for fid %llu\n", req->VolatileFileId);
+	ksmbd_debug(SMB, "Received smb2 flush request(fid : %llu)\n", req->VolatileFileId);
 
 	err = ksmbd_vfs_fsync(work, req->VolatileFileId, req->PersistentFileId);
 	if (err)
@@ -7206,7 +7220,7 @@ int smb2_lock(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
-	ksmbd_debug(SMB, "Received lock request\n");
+	ksmbd_debug(SMB, "Received smb2 lock request\n");
 	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
 	if (!fp) {
 		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n", req->VolatileFileId);
@@ -7973,6 +7987,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 	int ret = 0;
 	char *buffer;
 
+	ksmbd_debug(SMB, "Received smb2 ioctl request\n");
+
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
@@ -8599,6 +8615,8 @@ int smb2_oplock_break(struct ksmbd_work *work)
 	struct smb2_oplock_break *req;
 	struct smb2_oplock_break *rsp;
 
+	ksmbd_debug(SMB, "Received smb2 oplock break acknowledgment request\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	switch (le16_to_cpu(req->StructureSize)) {
@@ -8629,6 +8647,8 @@ int smb2_notify(struct ksmbd_work *work)
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
 
+	ksmbd_debug(SMB, "Received smb2 notify\n");
+
 	WORK_BUFFERS(work, req, rsp);
 
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
-- 
2.25.1

