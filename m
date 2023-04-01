Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7834BC77B6E
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Apr 2023 08:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjDAIwo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Apr 2023 04:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDAIwZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Apr 2023 04:52:25 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECE7B75F
        for <linux-cifs@vger.kernel.org>; Sat,  1 Apr 2023 01:50:27 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id l7so22929453pjg.5
        for <linux-cifs@vger.kernel.org>; Sat, 01 Apr 2023 01:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680339027; x=1682931027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=URBC5ya1q1p2lx0vzapxynxQtF4Lh0fo6pXSptdW3Wc=;
        b=yVsLgJsoxLoekpxcA6d/qmfra+jjqApQrhYdaneOcNXMRqzPDOF9GpYY0ixXB9rKfa
         sdqgXvykDvwFxNITlbRXIDpd4L/zX4tVNWpN+odjhSGC3v8vZ3MW5EejLCGrS8CxrdId
         wQoBPq/rmBhp1No10UjTMZzBD9jQwD+uacL6Uyo4WHKvUknBef8TPYy4mLV321LnTbOi
         dKoJ8m9pPwnBjXz5/jrHcH5nyiK+747iA8+Y+ebMbabj5HeyopIlPFAC5AX8auxe1Ziw
         yw3147DWhSC7zYEcTUqM3C++oy+O48QLjStfP/5RoQB1wnkOzFsQqE/TSvTzIww9maN7
         95MA==
X-Gm-Message-State: AO0yUKVSwUR5mMsretg7bHq2GBfhco9plk6nlzIgW00sEVCO8bkmA9a4
        R0bsoB9YGlWCsRf/6Ro6E0bCqLLlWfM=
X-Google-Smtp-Source: AK7set98fRHrvwKFEhMZRSftlx5B2RxbbevOUeS8iMb4xIAOoEH3UQoDWJmT5I790b+PQJ+TvMI/Ew==
X-Received: by 2002:a05:6a20:2921:b0:da:c7e:6ec0 with SMTP id t33-20020a056a20292100b000da0c7e6ec0mr25113617pzf.25.1680339026664;
        Sat, 01 Apr 2023 01:50:26 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c16-20020aa78c10000000b005e5b11335b3sm3118137pfd.57.2023.04.01.01.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 01:50:26 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr
Date:   Sat,  1 Apr 2023 17:49:51 +0900
Message-Id: <20230401084951.6085-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230401084951.6085-1-linkinjeon@kernel.org>
References: <20230401084951.6085-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When smb1 mount fails, KASAN detect slab-out-of-bounds in
init_smb2_rsp_hdr like the following one.
For smb1 negotiate(56bytes) , init_smb2_rsp_hdr() for smb2 is called.
The issue occurs while handling smb1 negotiate as smb2 server operations.
Add smb server operations for smb1 (get_cmd_val, init_rsp_hdr,
allocate_rsp_buf, check_user_session) to handle smb1 negotiate so that
smb2 server operation does not handle it.

[  411.400423] CIFS: VFS: Use of the less secure dialect vers=1.0 is
not recommended unless required for access to very old servers
[  411.400452] CIFS: Attempting to mount \\192.168.45.139\homes
[  411.479312] ksmbd: init_smb2_rsp_hdr : 492
[  411.479323] ==================================================================
[  411.479327] BUG: KASAN: slab-out-of-bounds in
init_smb2_rsp_hdr+0x1e2/0x1f4 [ksmbd]
[  411.479369] Read of size 16 at addr ffff888488ed0734 by task kworker/14:1/199

[  411.479379] CPU: 14 PID: 199 Comm: kworker/14:1 Tainted: G
 OE      6.1.21 #3
[  411.479386] Hardware name: ASUSTeK COMPUTER INC. Z10PA-D8
Series/Z10PA-D8 Series, BIOS 3801 08/23/2019
[  411.479390] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[  411.479425] Call Trace:
[  411.479428]  <TASK>
[  411.479432]  dump_stack_lvl+0x49/0x63
[  411.479444]  print_report+0x171/0x4a8
[  411.479452]  ? kasan_complete_mode_report_info+0x3c/0x200
[  411.479463]  ? init_smb2_rsp_hdr+0x1e2/0x1f4 [ksmbd]
[  411.479497]  kasan_report+0xb4/0x130
[  411.479503]  ? init_smb2_rsp_hdr+0x1e2/0x1f4 [ksmbd]
[  411.479537]  kasan_check_range+0x149/0x1e0
[  411.479543]  memcpy+0x24/0x70
[  411.479550]  init_smb2_rsp_hdr+0x1e2/0x1f4 [ksmbd]
[  411.479585]  handle_ksmbd_work+0x109/0x760 [ksmbd]
[  411.479616]  ? _raw_spin_unlock_irqrestore+0x50/0x50
[  411.479624]  ? smb3_encrypt_resp+0x340/0x340 [ksmbd]
[  411.479656]  process_one_work+0x49c/0x790
[  411.479667]  worker_thread+0x2b1/0x6e0
[  411.479674]  ? process_one_work+0x790/0x790
[  411.479680]  kthread+0x177/0x1b0
[  411.479686]  ? kthread_complete_and_exit+0x30/0x30
[  411.479692]  ret_from_fork+0x22/0x30
[  411.479702]  </TASK>

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/server.c     |   5 +-
 fs/ksmbd/smb2pdu.c    |   3 -
 fs/ksmbd/smb_common.c | 138 +++++++++++++++++++++++++++++++++---------
 fs/ksmbd/smb_common.h |   2 +-
 4 files changed, 111 insertions(+), 37 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 394b6ceac431..0d8242789dc8 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -289,10 +289,7 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	work->request_buf = conn->request_buf;
 	conn->request_buf = NULL;
 
-	if (ksmbd_init_smb_server(work)) {
-		ksmbd_free_work_struct(work);
-		return -EINVAL;
-	}
+	ksmbd_init_smb_server(work);
 
 	ksmbd_conn_enqueue_request(work);
 	atomic_inc(&conn->r_count);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 3656ccac06e3..8af939a181be 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -229,9 +229,6 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 	struct smb2_negotiate_rsp *rsp;
 	struct ksmbd_conn *conn = work->conn;
 
-	if (conn->need_neg == false)
-		return -EINVAL;
-
 	*(__be32 *)work->response_buf =
 		cpu_to_be32(conn->vals->header_size);
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 9c1ce6d199ce..af0c2a9b8529 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -283,20 +283,121 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 	return BAD_PROT_ID;
 }
 
-int ksmbd_init_smb_server(struct ksmbd_work *work)
+#define SMB_COM_NEGOTIATE_EX	0x0
+
+/**
+ * get_smb1_cmd_val() - get smb command value from smb header
+ * @work:	smb work containing smb header
+ *
+ * Return:      smb command value
+ */
+static u16 get_smb1_cmd_val(struct ksmbd_work *work)
 {
-	struct ksmbd_conn *conn = work->conn;
+	return SMB_COM_NEGOTIATE_EX;
+}
 
-	if (conn->need_neg == false)
+/**
+ * init_smb1_rsp_hdr() - initialize smb negotiate response header
+ * @work:	smb work containing smb request
+ *
+ * Return:      0 on success, otherwise -EINVAL
+ */
+static int init_smb1_rsp_hdr(struct ksmbd_work *work)
+{
+	struct smb_hdr *rsp_hdr = (struct smb_hdr *)work->response_buf;
+	struct smb_hdr *rcv_hdr = (struct smb_hdr *)work->request_buf;
+
+	/*
+	 * Remove 4 byte direct TCP header.
+	 */
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(sizeof(struct smb_hdr) - 4);
+
+	rsp_hdr->Command = SMB_COM_NEGOTIATE;
+	*(__le32 *)rsp_hdr->Protocol = SMB1_PROTO_NUMBER;
+	rsp_hdr->Flags = SMBFLG_RESPONSE;
+	rsp_hdr->Flags2 = SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS |
+		SMBFLG2_EXT_SEC | SMBFLG2_IS_LONG_NAME;
+	rsp_hdr->Pid = rcv_hdr->Pid;
+	rsp_hdr->Mid = rcv_hdr->Mid;
+	return 0;
+}
+
+/**
+ * smb1_check_user_session() - check for valid session for a user
+ * @work:	smb work containing smb request buffer
+ *
+ * Return:      0 on success, otherwise error
+ */
+static int smb1_check_user_session(struct ksmbd_work *work)
+{
+	unsigned int cmd = work->conn->ops->get_cmd_val(work);
+
+	if (cmd == SMB_COM_NEGOTIATE_EX)
 		return 0;
 
-	init_smb3_11_server(conn);
+	return -EINVAL;
+}
+
+/**
+ * smb1_allocate_rsp_buf() - allocate response buffer for a command
+ * @work:	smb work containing smb request
+ *
+ * Return:      0 on success, otherwise -ENOMEM
+ */
+static int smb1_allocate_rsp_buf(struct ksmbd_work *work)
+{
+	work->response_buf = kmalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
+			GFP_KERNEL | __GFP_ZERO);
+	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
+
+	if (!work->response_buf) {
+		pr_err("Failed to allocate %u bytes buffer\n",
+				MAX_CIFS_SMALL_BUFFER_SIZE);
+		return -ENOMEM;
+	}
 
-	if (conn->ops->get_cmd_val(work) != SMB_COM_NEGOTIATE)
-		conn->need_neg = false;
 	return 0;
 }
 
+static struct smb_version_ops smb1_server_ops = {
+	.get_cmd_val = get_smb1_cmd_val,
+	.init_rsp_hdr = init_smb1_rsp_hdr,
+	.allocate_rsp_buf = smb1_allocate_rsp_buf,
+	.check_user_session = smb1_check_user_session,
+};
+
+static int smb1_negotiate(struct ksmbd_work *work)
+{
+	return ksmbd_smb_negotiate_common(work, SMB_COM_NEGOTIATE);
+}
+
+static struct smb_version_cmds smb1_server_cmds[1] = {
+	[SMB_COM_NEGOTIATE_EX]	= { .proc = smb1_negotiate, },
+};
+
+static void init_smb1_server(struct ksmbd_conn *conn)
+{
+	conn->ops = &smb1_server_ops;
+	conn->cmds = smb1_server_cmds;
+	conn->max_cmds = ARRAY_SIZE(smb1_server_cmds);
+}
+
+void ksmbd_init_smb_server(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+	__le32 proto;
+
+	if (conn->need_neg == false)
+		return;
+
+	proto = *(__le32 *)((struct smb_hdr *)work->request_buf)->Protocol;
+	if (proto == SMB1_PROTO_NUMBER)
+		init_smb1_server(conn);
+	else
+		init_smb3_11_server(conn);
+}
+
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 				      struct ksmbd_file *dir,
 				      struct ksmbd_dir_info *d_info,
@@ -444,20 +545,10 @@ static int smb_handle_negotiate(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
 
-	/*
-	 * Remove 4 byte direct TCP header, add 2 byte bcc and
-	 * 2 byte DialectIndex.
-	 */
-	*(__be32 *)work->response_buf =
-		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
+	/* Add 2 byte bcc and 2 byte DialectIndex. */
+	inc_rfc1001_len(work->response_buf, 4);
 	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
 
-	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
-	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
-	neg_rsp->hdr.Flags = SMBFLG_RESPONSE;
-	neg_rsp->hdr.Flags2 = SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS |
-		SMBFLG2_EXT_SEC | SMBFLG2_IS_LONG_NAME;
-
 	neg_rsp->hdr.WordCount = 1;
 	neg_rsp->DialectIndex = cpu_to_le16(work->conn->dialect);
 	neg_rsp->ByteCount = 0;
@@ -473,24 +564,13 @@ int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
 		ksmbd_negotiate_smb_dialect(work->request_buf);
 	ksmbd_debug(SMB, "conn->dialect 0x%x\n", conn->dialect);
 
-	if (command == SMB2_NEGOTIATE_HE) {
-		struct smb2_hdr *smb2_hdr = smb2_get_msg(work->request_buf);
-
-		if (smb2_hdr->ProtocolId != SMB2_PROTO_NUMBER) {
-			ksmbd_debug(SMB, "Downgrade to SMB1 negotiation\n");
-			command = SMB_COM_NEGOTIATE;
-		}
-	}
-
 	if (command == SMB2_NEGOTIATE_HE) {
 		ret = smb2_handle_negotiate(work);
-		init_smb2_neg_rsp(work);
 		return ret;
 	}
 
 	if (command == SMB_COM_NEGOTIATE) {
 		if (__smb2_negotiate(conn)) {
-			conn->need_neg = true;
 			init_smb3_11_server(conn);
 			init_smb2_neg_rsp(work);
 			ksmbd_debug(SMB, "Upgrade to SMB2 negotiation\n");
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index d30ce4c1a151..9130d2e3cd78 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -427,7 +427,7 @@ bool ksmbd_smb_request(struct ksmbd_conn *conn);
 
 int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
 
-int ksmbd_init_smb_server(struct ksmbd_work *work);
+void ksmbd_init_smb_server(struct ksmbd_work *work);
 
 struct ksmbd_kstat;
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
-- 
2.25.1

