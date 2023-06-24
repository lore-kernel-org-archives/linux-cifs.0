Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F14AEB64DD
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Jun 2023 04:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjFXEIW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Jun 2023 00:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjFXEIV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Jun 2023 00:08:21 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AED269E
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 21:08:20 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-54fb23ff7d3so844583a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 21:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687579699; x=1690171699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i1Uhi9H/fLvRUiW65GHfO25jKwI1YGBvPKy5UfhQrMo=;
        b=WtxdnrMZP4V656ZZMwRbXPUY8GzXBmJSjhzmfZB7RrwdoEu3ftfM0RzmDfAEOlcA5R
         FYPjdmsSTn3YWliwp8boqrFWNd5G6Q2E3A95xw+Gh9q4hc7jkvziGYFsMTU61SUgwUXx
         f2H/H56acrarvskEdXLGD8hUMmpu0ryW0nbqfhZd0b30QlvxgKr5rK9sGSusJAZ+RZpS
         7JvECa5AwkOwFNq3a5AqSBfWpHrpO6CF6U2W3+MuS+m1JZ8xUjcxwIZqMDHJuHfTRXBq
         HC3gF8qbVCzq8q6zjVHowDtDEv4UWR17KBW4o4YpL9z7qeijSF/sJmhhCO283fGwTpi9
         a/7g==
X-Gm-Message-State: AC+VfDz6LxgvZokMObDKS1DpXy6l1pXrosU03pkche2SwtYYomLZj9lC
        RHrkBhA3VT5IxAUztH+XlM1wnw9uK2o=
X-Google-Smtp-Source: ACHHUZ5waYNTOV3lt6sJhHPpB5ZvHwk/iLYE5LCfkYXgcL3xa0hknj7Ij/aHUVTQG+u2VV6s6XMCgg==
X-Received: by 2002:a05:6a20:4391:b0:117:c3f8:2f39 with SMTP id i17-20020a056a20439100b00117c3f82f39mr17239246pzl.19.1687579699226;
        Fri, 23 Jun 2023 21:08:19 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902a50300b001b2063d43a7sm283327plq.249.2023.06.23.21.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 21:08:18 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add missing compound request handing in some commands
Date:   Sat, 24 Jun 2023 13:01:41 +0900
Message-Id: <20230624040141.16088-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230624040141.16088-1-linkinjeon@kernel.org>
References: <20230624040141.16088-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch add the compound request handling to the some commands.
Existing clients do not send these commands as compound requests,
but ksmbd should consider that they may come.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 78 ++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 38738b430e11..cf8822103f50 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1914,14 +1914,16 @@ int smb2_sess_setup(struct ksmbd_work *work)
 int smb2_tree_connect(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_tree_connect_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_tree_connect_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_tree_connect_req *req;
+	struct smb2_tree_connect_rsp *rsp;
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
 	struct ksmbd_share_config *share;
 	int rc = -EINVAL;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	treename = smb_strndup_from_utf16(req->Buffer,
 					  le16_to_cpu(req->PathLength), true,
 					  conn->local_nls);
@@ -2090,19 +2092,19 @@ static int smb2_create_open_flags(bool file_present, __le32 access,
  */
 int smb2_tree_disconnect(struct ksmbd_work *work)
 {
-	struct smb2_tree_disconnect_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_tree_disconnect_rsp *rsp;
+	struct smb2_tree_disconnect_req *req;
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_tree_connect *tcon = work->tcon;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	rsp->StructureSize = cpu_to_le16(4);
 	inc_rfc1001_len(work->response_buf, 4);
 
 	ksmbd_debug(SMB, "request\n");
 
 	if (!tcon || test_and_set_bit(TREE_CONN_EXPIRE, &tcon->status)) {
-		struct smb2_tree_disconnect_req *req =
-			smb2_get_msg(work->request_buf);
-
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
 
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
@@ -2125,10 +2127,14 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 int smb2_session_logoff(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_logoff_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_logoff_req *req;
+	struct smb2_logoff_rsp *rsp;
 	struct ksmbd_session *sess;
-	struct smb2_logoff_req *req = smb2_get_msg(work->request_buf);
-	u64 sess_id = le64_to_cpu(req->hdr.SessionId);
+	u64 sess_id;
+
+	WORK_BUFFERS(work, req, rsp);
+
+	sess_id = le64_to_cpu(req->hdr.SessionId);
 
 	rsp->StructureSize = cpu_to_le16(4);
 	inc_rfc1001_len(work->response_buf, 4);
@@ -2168,12 +2174,14 @@ int smb2_session_logoff(struct ksmbd_work *work)
  */
 static noinline int create_smb2_pipe(struct ksmbd_work *work)
 {
-	struct smb2_create_rsp *rsp = smb2_get_msg(work->response_buf);
-	struct smb2_create_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_create_rsp *rsp;
+	struct smb2_create_req *req;
 	int id;
 	int err;
 	char *name;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	name = smb_strndup_from_utf16(req->Buffer, le16_to_cpu(req->NameLength),
 				      1, work->conn->local_nls);
 	if (IS_ERR(name)) {
@@ -5306,8 +5314,10 @@ int smb2_query_info(struct ksmbd_work *work)
 static noinline int smb2_close_pipe(struct ksmbd_work *work)
 {
 	u64 id;
-	struct smb2_close_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_close_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_close_req *req;
+	struct smb2_close_rsp *rsp;
+
+	WORK_BUFFERS(work, req, rsp);
 
 	id = req->VolatileFileId;
 	ksmbd_session_rpc_close(work->sess, id);
@@ -5449,6 +5459,9 @@ int smb2_echo(struct ksmbd_work *work)
 {
 	struct smb2_echo_rsp *rsp = smb2_get_msg(work->response_buf);
 
+	if (work->next_smb2_rcv_hdr_off)
+		rsp = ksmbd_resp_buf_next(work);
+
 	rsp->StructureSize = cpu_to_le16(4);
 	rsp->Reserved = 0;
 	inc_rfc1001_len(work->response_buf, 4);
@@ -6083,8 +6096,10 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	int nbytes = 0, err;
 	u64 id;
 	struct ksmbd_rpc_command *rpc_resp;
-	struct smb2_read_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_read_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_read_req *req;
+	struct smb2_read_rsp *rsp;
+
+	WORK_BUFFERS(work, req, rsp);
 
 	id = req->VolatileFileId;
 
@@ -6332,14 +6347,16 @@ int smb2_read(struct ksmbd_work *work)
  */
 static noinline int smb2_write_pipe(struct ksmbd_work *work)
 {
-	struct smb2_write_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_write_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_write_req *req;
+	struct smb2_write_rsp *rsp;
 	struct ksmbd_rpc_command *rpc_resp;
 	u64 id = 0;
 	int err = 0, ret = 0;
 	char *data_buf;
 	size_t length;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
 
@@ -6608,6 +6625,9 @@ int smb2_cancel(struct ksmbd_work *work)
 	struct ksmbd_work *iter;
 	struct list_head *command_list;
 
+	if (work->next_smb2_rcv_hdr_off)
+		hdr = ksmbd_resp_buf_next(work);
+
 	ksmbd_debug(SMB, "smb2 cancel called on mid %llu, async flags 0x%x\n",
 		    hdr->MessageId, hdr->Flags);
 
@@ -6767,8 +6787,8 @@ static inline bool lock_defer_pending(struct file_lock *fl)
  */
 int smb2_lock(struct ksmbd_work *work)
 {
-	struct smb2_lock_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_lock_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_lock_req *req;
+	struct smb2_lock_rsp *rsp;
 	struct smb2_lock_element *lock_ele;
 	struct ksmbd_file *fp = NULL;
 	struct file_lock *flock = NULL;
@@ -6785,6 +6805,8 @@ int smb2_lock(struct ksmbd_work *work)
 	LIST_HEAD(rollback_list);
 	int prior_lock = 0;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	ksmbd_debug(SMB, "Received lock request\n");
 	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
 	if (!fp) {
@@ -7898,8 +7920,8 @@ int smb2_ioctl(struct ksmbd_work *work)
  */
 static void smb20_oplock_break_ack(struct ksmbd_work *work)
 {
-	struct smb2_oplock_break *req = smb2_get_msg(work->request_buf);
-	struct smb2_oplock_break *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_oplock_break *req;
+	struct smb2_oplock_break *rsp;
 	struct ksmbd_file *fp;
 	struct oplock_info *opinfo = NULL;
 	__le32 err = 0;
@@ -7908,6 +7930,8 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	char req_oplevel = 0, rsp_oplevel = 0;
 	unsigned int oplock_change_type;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	volatile_id = req->VolatileFid;
 	persistent_id = req->PersistentFid;
 	req_oplevel = req->OplockLevel;
@@ -8042,8 +8066,8 @@ static int check_lease_state(struct lease *lease, __le32 req_state)
 static void smb21_lease_break_ack(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_lease_ack *req = smb2_get_msg(work->request_buf);
-	struct smb2_lease_ack *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_lease_ack *req;
+	struct smb2_lease_ack *rsp;
 	struct oplock_info *opinfo;
 	__le32 err = 0;
 	int ret = 0;
@@ -8051,6 +8075,8 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	__le32 lease_state;
 	struct lease *lease;
 
+	WORK_BUFFERS(work, req, rsp);
+
 	ksmbd_debug(OPLOCK, "smb21 lease break, lease state(0x%x)\n",
 		    le32_to_cpu(req->LeaseState));
 	opinfo = lookup_lease_in_table(conn, req->LeaseKey);
@@ -8176,8 +8202,10 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
  */
 int smb2_oplock_break(struct ksmbd_work *work)
 {
-	struct smb2_oplock_break *req = smb2_get_msg(work->request_buf);
-	struct smb2_oplock_break *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_oplock_break *req;
+	struct smb2_oplock_break *rsp;
+
+	WORK_BUFFERS(work, req, rsp);
 
 	switch (le16_to_cpu(req->StructureSize)) {
 	case OP_BREAK_STRUCT_SIZE_20:
-- 
2.25.1

