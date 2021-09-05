Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2F1C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Sep 2021 12:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92FE60F12
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Sep 2021 12:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhIEMU0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Sep 2021 08:20:26 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33700 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhIEMUZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Sep 2021 08:20:25 -0400
Received: by mail-pf1-f169.google.com with SMTP id u6so3383700pfi.0
        for <linux-cifs@vger.kernel.org>; Sun, 05 Sep 2021 05:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wr7UuHj6+dib43tc/fwpxcKzny6jUPArhitLkYF7P1Y=;
        b=b6MykJa9zqFMvfsqfSPw2iLYbWVCwNMS5+9hxfIP1e9AUk+SHeSliK+kN8rrHMMA5X
         nEsLqLYcdQ8uD3YYHb8hmh/6mRQzkGb6g0MGHLnrYFTy65299/JAjNqKTffiU5yniNWG
         TPjtIay6NBO3ENpDqrRdzPvK4DRp2DwlkaTrKOgSWUiylGwqkfyx4SqLdWvSXmwxRjAO
         TxS6VCo4Q0nSiMczATBWU7OSfIktfQTJ7KjN+KMK10MOxmgXppH4aZv/GoV91y6MYVbO
         Ssd1tQbizZW7CLwLHQo9IaFwUsDATrCsfndCFNmzeIasevOitRem2Llte57/wFgySkl8
         mvNw==
X-Gm-Message-State: AOAM530AWZqjnUmyVE4SEd45GUtKU8+OZ0FtyRK6edSa1jHBBlgD3kiu
        wtBBRTUUo25jgTDbYIDP869neh10PRxnpg==
X-Google-Smtp-Source: ABdhPJxfEySD9X8MkE0n+jT2PJtAlRZi/OiKQqtebpFVc8a6kzgTxj0voOqcVsnOz6jCnkeijZjzyw==
X-Received: by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with SMTP id a25-20020aa780d90000b02902ed49fa6dc5mr7290246pfn.3.1630844361339;
        Sun, 05 Sep 2021 05:19:21 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id n14sm5667767pgd.48.2021.09.05.05.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 05:19:20 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 1/2] ksmbd: remove smb2_buf_length in smb2_hdr
Date:   Sun,  5 Sep 2021 21:18:56 +0900
Message-Id: <20210905121857.7383-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To move smb2_hdr to cifs_common, This patch remove smb2_buf_length
variable in smb2_hdr. Also, declare smb2_get_msg function to get smb2
request/response from ->request/response_buf.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c       |   4 +-
 fs/ksmbd/ksmbd_work.h |   4 +-
 fs/ksmbd/oplock.c     |  22 +--
 fs/ksmbd/server.c     |   2 +-
 fs/ksmbd/smb2misc.c   |   4 +-
 fs/ksmbd/smb2pdu.c    | 439 +++++++++++++++++++++---------------------
 fs/ksmbd/smb2pdu.h    |  14 +-
 fs/ksmbd/smb_common.c |  11 +-
 fs/ksmbd/smb_common.h |   6 -
 9 files changed, 255 insertions(+), 251 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index de36f12070bf..1aa199cee668 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -1076,9 +1076,9 @@ int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash)
 {
 	int rc;
-	struct smb2_hdr *rcv_hdr = (struct smb2_hdr *)buf;
+	struct smb2_hdr *rcv_hdr = smb2_get_msg(buf);
 	char *all_bytes_msg = (char *)&rcv_hdr->ProtocolId;
-	int msg_size = be32_to_cpu(rcv_hdr->smb2_buf_length);
+	int msg_size = get_rfc1002_len(buf);
 	struct ksmbd_crypto_ctx *ctx = NULL;
 
 	if (conn->preauth_info->Preauth_HashId !=
diff --git a/fs/ksmbd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
index f7156bc50049..5ece58e40c97 100644
--- a/fs/ksmbd/ksmbd_work.h
+++ b/fs/ksmbd/ksmbd_work.h
@@ -92,7 +92,7 @@ struct ksmbd_work {
  */
 static inline void *ksmbd_resp_buf_next(struct ksmbd_work *work)
 {
-	return work->response_buf + work->next_smb2_rsp_hdr_off;
+	return work->response_buf + work->next_smb2_rsp_hdr_off + 4;
 }
 
 /**
@@ -101,7 +101,7 @@ static inline void *ksmbd_resp_buf_next(struct ksmbd_work *work)
  */
 static inline void *ksmbd_req_buf_next(struct ksmbd_work *work)
 {
-	return work->request_buf + work->next_smb2_rcv_hdr_off;
+	return work->request_buf + work->next_smb2_rcv_hdr_off + 4;
 }
 
 struct ksmbd_work *ksmbd_alloc_work_struct(void);
diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 16b6236d1bd2..662070316e25 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -629,10 +629,10 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 		return;
 	}
 
-	rsp_hdr = work->response_buf;
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	memset(rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
-	rsp_hdr->smb2_buf_length =
-		cpu_to_be32(smb2_hdr_size_no_buflen(conn->vals));
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(conn->vals->header_size);
 	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
 	rsp_hdr->StructureSize = SMB2_HEADER_STRUCTURE_SIZE;
 	rsp_hdr->CreditRequest = cpu_to_le16(0);
@@ -645,7 +645,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	rsp_hdr->SessionId = 0;
 	memset(rsp_hdr->Signature, 0, 16);
 
-	rsp = work->response_buf;
+	rsp = smb2_get_msg(work->response_buf);
 
 	rsp->StructureSize = cpu_to_le16(24);
 	if (!br_info->open_trunc &&
@@ -659,7 +659,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	rsp->PersistentFid = cpu_to_le64(fp->persistent_id);
 	rsp->VolatileFid = cpu_to_le64(fp->volatile_id);
 
-	inc_rfc1001_len(rsp, 24);
+	inc_rfc1001_len(work->response_buf, 24);
 
 	ksmbd_debug(OPLOCK,
 		    "sending oplock break v_id %llu p_id = %llu lock level = %d\n",
@@ -736,10 +736,10 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 		return;
 	}
 
-	rsp_hdr = work->response_buf;
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	memset(rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
-	rsp_hdr->smb2_buf_length =
-		cpu_to_be32(smb2_hdr_size_no_buflen(conn->vals));
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(conn->vals->header_size);
 	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
 	rsp_hdr->StructureSize = SMB2_HEADER_STRUCTURE_SIZE;
 	rsp_hdr->CreditRequest = cpu_to_le16(0);
@@ -752,7 +752,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	rsp_hdr->SessionId = 0;
 	memset(rsp_hdr->Signature, 0, 16);
 
-	rsp = work->response_buf;
+	rsp = smb2_get_msg(work->response_buf);
 	rsp->StructureSize = cpu_to_le16(44);
 	rsp->Epoch = br_info->epoch;
 	rsp->Flags = 0;
@@ -768,7 +768,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	rsp->AccessMaskHint = 0;
 	rsp->ShareMaskHint = 0;
 
-	inc_rfc1001_len(rsp, 44);
+	inc_rfc1001_len(work->response_buf, 44);
 
 	ksmbd_conn_write(work);
 	ksmbd_free_work_struct(work);
@@ -1457,7 +1457,7 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
 	char *name;
 	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
 
-	data_offset = (char *)req + 4 + le32_to_cpu(req->CreateContextsOffset);
+	data_offset = (char *)req + le32_to_cpu(req->CreateContextsOffset);
 	cc = (struct create_context *)data_offset;
 	do {
 		int val;
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index e6a9f6aa47eb..9c45cc31236c 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -94,7 +94,7 @@ static inline int check_conn_state(struct ksmbd_work *work)
 	struct smb_hdr *rsp_hdr;
 
 	if (ksmbd_conn_exiting(work) || ksmbd_conn_need_reconnect(work)) {
-		rsp_hdr = work->response_buf;
+		rsp_hdr = smb2_get_msg(work->response_buf);
 		rsp_hdr->Status.CifsError = STATUS_CONNECTION_DISCONNECTED;
 		return 1;
 	}
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 9aa46bb3e10d..66052b5a88ac 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -332,11 +332,11 @@ static int smb2_validate_credit_charge(struct smb2_hdr *hdr)
 
 int ksmbd_smb2_check_message(struct ksmbd_work *work)
 {
-	struct smb2_pdu *pdu = work->request_buf;
+	struct smb2_pdu *pdu = smb2_get_msg(work->request_buf);
 	struct smb2_hdr *hdr = &pdu->hdr;
 	int command;
 	__u32 clc_len;  /* calculated length */
-	__u32 len = get_rfc1002_len(pdu);
+	__u32 len = get_rfc1002_len(work->request_buf);
 
 	if (work->next_smb2_rcv_hdr_off) {
 		pdu = ksmbd_req_buf_next(work);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a350e1cef7f4..ed1105f3a139 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -44,8 +44,8 @@ static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 		*req = ksmbd_req_buf_next(work);
 		*rsp = ksmbd_resp_buf_next(work);
 	} else {
-		*req = work->request_buf;
-		*rsp = work->response_buf;
+		*req = smb2_get_msg(work->request_buf);
+		*rsp = smb2_get_msg(work->response_buf);
 	}
 }
 
@@ -93,7 +93,7 @@ struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn
  */
 int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 {
-	struct smb2_hdr *req_hdr = work->request_buf;
+	struct smb2_hdr *req_hdr = smb2_get_msg(work->request_buf);
 	int tree_id;
 
 	work->tcon = NULL;
@@ -130,7 +130,7 @@ void smb2_set_err_rsp(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off)
 		err_rsp = ksmbd_resp_buf_next(work);
 	else
-		err_rsp = work->response_buf;
+		err_rsp = smb2_get_msg(work->response_buf);
 
 	if (err_rsp->hdr.Status != STATUS_STOPPED_ON_SYMLINK) {
 		err_rsp->StructureSize = SMB2_ERROR_STRUCTURE_SIZE2_LE;
@@ -150,7 +150,7 @@ void smb2_set_err_rsp(struct ksmbd_work *work)
  */
 bool is_smb2_neg_cmd(struct ksmbd_work *work)
 {
-	struct smb2_hdr *hdr = work->request_buf;
+	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 
 	/* is it SMB2 header ? */
 	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
@@ -174,7 +174,7 @@ bool is_smb2_neg_cmd(struct ksmbd_work *work)
  */
 bool is_smb2_rsp(struct ksmbd_work *work)
 {
-	struct smb2_hdr *hdr = work->response_buf;
+	struct smb2_hdr *hdr = smb2_get_msg(work->response_buf);
 
 	/* is it SMB2 header ? */
 	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
@@ -200,7 +200,7 @@ u16 get_smb2_cmd_val(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off)
 		rcv_hdr = ksmbd_req_buf_next(work);
 	else
-		rcv_hdr = work->request_buf;
+		rcv_hdr = smb2_get_msg(work->request_buf);
 	return le16_to_cpu(rcv_hdr->Command);
 }
 
@@ -216,7 +216,7 @@ void set_smb2_rsp_status(struct ksmbd_work *work, __le32 err)
 	if (work->next_smb2_rcv_hdr_off)
 		rsp_hdr = ksmbd_resp_buf_next(work);
 	else
-		rsp_hdr = work->response_buf;
+		rsp_hdr = smb2_get_msg(work->response_buf);
 	rsp_hdr->Status = err;
 	smb2_set_err_rsp(work);
 }
@@ -240,13 +240,11 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 	      conn->dialect <= SMB311_PROT_ID))
 		return -EINVAL;
 
-	rsp_hdr = work->response_buf;
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(conn->vals->header_size);
 
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	memset(rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
-
-	rsp_hdr->smb2_buf_length =
-		cpu_to_be32(smb2_hdr_size_no_buflen(conn->vals));
-
 	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
 	rsp_hdr->StructureSize = SMB2_HEADER_STRUCTURE_SIZE;
 	rsp_hdr->CreditRequest = cpu_to_le16(2);
@@ -259,7 +257,7 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 	rsp_hdr->SessionId = 0;
 	memset(rsp_hdr->Signature, 0, 16);
 
-	rsp = work->response_buf;
+	rsp = smb2_get_msg(work->response_buf);
 
 	WARN_ON(ksmbd_conn_good(work));
 
@@ -280,12 +278,12 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 
 	rsp->SecurityBufferOffset = cpu_to_le16(128);
 	rsp->SecurityBufferLength = cpu_to_le16(AUTH_GSS_LENGTH);
-	ksmbd_copy_gss_neg_header(((char *)(&rsp->hdr) +
-		sizeof(rsp->hdr.smb2_buf_length)) +
+	ksmbd_copy_gss_neg_header((char *)(&rsp->hdr) +
 		le16_to_cpu(rsp->SecurityBufferOffset));
-	inc_rfc1001_len(rsp, sizeof(struct smb2_negotiate_rsp) -
-		sizeof(struct smb2_hdr) - sizeof(rsp->Buffer) +
-		AUTH_GSS_LENGTH);
+	inc_rfc1001_len(work->response_buf,
+			sizeof(struct smb2_negotiate_rsp) -
+			sizeof(struct smb2_hdr) - sizeof(rsp->Buffer) +
+			AUTH_GSS_LENGTH);
 	rsp->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED_LE;
 	if (server_conf.signing == KSMBD_CONFIG_OPT_MANDATORY)
 		rsp->SecurityMode |= SMB2_NEGOTIATE_SIGNING_REQUIRED_LE;
@@ -413,8 +411,8 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 	next_hdr_offset = le32_to_cpu(req->NextCommand);
 
 	new_len = ALIGN(len, 8);
-	inc_rfc1001_len(work->response_buf, ((sizeof(struct smb2_hdr) - 4)
-			+ new_len - len));
+	inc_rfc1001_len(work->response_buf,
+			sizeof(struct smb2_hdr) + new_len - len);
 	rsp->NextCommand = cpu_to_le32(new_len);
 
 	work->next_smb2_rcv_hdr_off += next_hdr_offset;
@@ -458,7 +456,7 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
  */
 bool is_chained_smb2_message(struct ksmbd_work *work)
 {
-	struct smb2_hdr *hdr = work->request_buf;
+	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 	unsigned int len;
 
 	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
@@ -494,13 +492,13 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
  */
 int init_smb2_rsp_hdr(struct ksmbd_work *work)
 {
-	struct smb2_hdr *rsp_hdr = work->response_buf;
-	struct smb2_hdr *rcv_hdr = work->request_buf;
+	struct smb2_hdr *rsp_hdr = smb2_get_msg(work->response_buf);
+	struct smb2_hdr *rcv_hdr = smb2_get_msg(work->request_buf);
 	struct ksmbd_conn *conn = work->conn;
 
 	memset(rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
-	rsp_hdr->smb2_buf_length =
-		cpu_to_be32(smb2_hdr_size_no_buflen(conn->vals));
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(conn->vals->header_size);
 	rsp_hdr->ProtocolId = rcv_hdr->ProtocolId;
 	rsp_hdr->StructureSize = SMB2_HEADER_STRUCTURE_SIZE;
 	rsp_hdr->Command = rcv_hdr->Command;
@@ -533,7 +531,7 @@ int init_smb2_rsp_hdr(struct ksmbd_work *work)
  */
 int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 {
-	struct smb2_hdr *hdr = work->request_buf;
+	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 	size_t large_sz = work->conn->vals->max_trans_size + MAX_SMB2_HDR_SIZE;
 	size_t sz = small_sz;
@@ -545,7 +543,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 
-		req = work->request_buf;
+		req = smb2_get_msg(work->request_buf);
 		if (req->InfoType == SMB2_O_INFO_FILE &&
 		    (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||
 		     req->FileInfoClass == FILE_ALL_INFORMATION))
@@ -572,7 +570,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
  */
 int smb2_check_user_session(struct ksmbd_work *work)
 {
-	struct smb2_hdr *req_hdr = work->request_buf;
+	struct smb2_hdr *req_hdr = smb2_get_msg(work->request_buf);
 	struct ksmbd_conn *conn = work->conn;
 	unsigned int cmd = conn->ops->get_cmd_val(work);
 	unsigned long long sess_id;
@@ -663,7 +661,7 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 	struct ksmbd_conn *conn = work->conn;
 	int id;
 
-	rsp_hdr = work->response_buf;
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
 
 	id = ksmbd_acquire_async_msg_id(&conn->async_ida);
@@ -695,7 +693,7 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
 
-	rsp_hdr = work->response_buf;
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	smb2_set_err_rsp(work);
 	rsp_hdr->Status = status;
 
@@ -823,11 +821,11 @@ static void build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 }
 
 static void assemble_neg_contexts(struct ksmbd_conn *conn,
-				  struct smb2_negotiate_rsp *rsp)
+				  struct smb2_negotiate_rsp *rsp,
+				  void *smb2_buf_len)
 {
-	/* +4 is to account for the RFC1001 len field */
 	char *pneg_ctxt = (char *)rsp +
-			le32_to_cpu(rsp->NegotiateContextOffset) + 4;
+			le32_to_cpu(rsp->NegotiateContextOffset);
 	int neg_ctxt_cnt = 1;
 	int ctxt_size;
 
@@ -836,7 +834,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 	build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt,
 			   conn->preauth_info->Preauth_HashId);
 	rsp->NegotiateContextCount = cpu_to_le16(neg_ctxt_cnt);
-	inc_rfc1001_len(rsp, AUTH_GSS_PADDING);
+	inc_rfc1001_len(smb2_buf_len, AUTH_GSS_PADDING);
 	ctxt_size = sizeof(struct smb2_preauth_neg_context);
 	/* Round to 8 byte boundary */
 	pneg_ctxt += round_up(sizeof(struct smb2_preauth_neg_context), 8);
@@ -890,7 +888,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ctxt_size += sizeof(struct smb2_signing_capabilities) + 2;
 	}
 
-	inc_rfc1001_len(rsp, ctxt_size);
+	inc_rfc1001_len(smb2_buf_len, ctxt_size);
 }
 
 static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
@@ -973,14 +971,14 @@ static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
 }
 
 static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
-				      struct smb2_negotiate_req *req)
+				      struct smb2_negotiate_req *req,
+				      int len_of_smb)
 {
 	/* +4 is to account for the RFC1001 len field */
-	struct smb2_neg_context *pctx = (struct smb2_neg_context *)((char *)req + 4);
+	struct smb2_neg_context *pctx = (struct smb2_neg_context *)req;
 	int i = 0, len_of_ctxts;
 	int offset = le32_to_cpu(req->NegotiateContextOffset);
 	int neg_ctxt_cnt = le16_to_cpu(req->NegotiateContextCount);
-	int len_of_smb = be32_to_cpu(req->hdr.smb2_buf_length);
 	__le32 status = STATUS_INVALID_PARAMETER;
 
 	ksmbd_debug(SMB, "decoding %d negotiate contexts\n", neg_ctxt_cnt);
@@ -1065,8 +1063,8 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 int smb2_handle_negotiate(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_negotiate_req *req = work->request_buf;
-	struct smb2_negotiate_rsp *rsp = work->response_buf;
+	struct smb2_negotiate_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_negotiate_rsp *rsp = smb2_get_msg(work->response_buf);
 	int rc = 0;
 	__le32 status;
 
@@ -1097,7 +1095,8 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 			goto err_out;
 		}
 
-		status = deassemble_neg_contexts(conn, req);
+		status = deassemble_neg_contexts(conn, req,
+						 get_rfc1002_len(work->request_buf));
 		if (status != STATUS_SUCCESS) {
 			pr_err("deassemble_neg_contexts error(0x%x)\n",
 			       status);
@@ -1117,7 +1116,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 						 conn->preauth_info->Preauth_HashValue);
 		rsp->NegotiateContextOffset =
 				cpu_to_le32(OFFSET_OF_NEG_CONTEXT);
-		assemble_neg_contexts(conn, rsp);
+		assemble_neg_contexts(conn, rsp, work->response_buf);
 		break;
 	case SMB302_PROT_ID:
 		init_smb3_02_server(conn);
@@ -1174,10 +1173,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 
 	rsp->SecurityBufferOffset = cpu_to_le16(128);
 	rsp->SecurityBufferLength = cpu_to_le16(AUTH_GSS_LENGTH);
-	ksmbd_copy_gss_neg_header(((char *)(&rsp->hdr) +
-				  sizeof(rsp->hdr.smb2_buf_length)) +
-				   le16_to_cpu(rsp->SecurityBufferOffset));
-	inc_rfc1001_len(rsp, sizeof(struct smb2_negotiate_rsp) -
+	ksmbd_copy_gss_neg_header((char *)(&rsp->hdr) +
+				  le16_to_cpu(rsp->SecurityBufferOffset));
+	inc_rfc1001_len(work->response_buf, sizeof(struct smb2_negotiate_rsp) -
 			sizeof(struct smb2_hdr) - sizeof(rsp->Buffer) +
 			 AUTH_GSS_LENGTH);
 	rsp->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED_LE;
@@ -1258,7 +1256,7 @@ static int decode_negotiation_token(struct ksmbd_work *work,
 	if (!conn->use_spnego)
 		return -EINVAL;
 
-	req = work->request_buf;
+	req = smb2_get_msg(work->request_buf);
 	sz = le16_to_cpu(req->SecurityBufferLength);
 
 	if (ksmbd_decode_negTokenInit((char *)negblob, sz, conn)) {
@@ -1274,8 +1272,8 @@ static int decode_negotiation_token(struct ksmbd_work *work,
 static int ntlm_negotiate(struct ksmbd_work *work,
 			  struct negotiate_message *negblob)
 {
-	struct smb2_sess_setup_req *req = work->request_buf;
-	struct smb2_sess_setup_rsp *rsp = work->response_buf;
+	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct challenge_message *chgblob;
 	unsigned char *spnego_blob = NULL;
 	u16 spnego_blob_len;
@@ -1373,8 +1371,8 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 
 static int ntlm_authenticate(struct ksmbd_work *work)
 {
-	struct smb2_sess_setup_req *req = work->request_buf;
-	struct smb2_sess_setup_rsp *rsp = work->response_buf;
+	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct channel *chann = NULL;
@@ -1397,7 +1395,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 		memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
 		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 		kfree(spnego_blob);
-		inc_rfc1001_len(rsp, spnego_blob_len - 1);
+		inc_rfc1001_len(work->response_buf, spnego_blob_len - 1);
 	}
 
 	user = session_user(conn, req);
@@ -1511,8 +1509,8 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 #ifdef CONFIG_SMB_SERVER_KERBEROS5
 static int krb5_authenticate(struct ksmbd_work *work)
 {
-	struct smb2_sess_setup_req *req = work->request_buf;
-	struct smb2_sess_setup_rsp *rsp = work->response_buf;
+	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	char *in_blob, *out_blob;
@@ -1527,8 +1525,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
 	out_blob = (char *)&rsp->hdr.ProtocolId +
 		le16_to_cpu(rsp->SecurityBufferOffset);
 	out_len = work->response_sz -
-		offsetof(struct smb2_hdr, smb2_buf_length) -
-		le16_to_cpu(rsp->SecurityBufferOffset);
+		(le16_to_cpu(rsp->SecurityBufferOffset) + 4);
 
 	/* Check previous session */
 	prev_sess_id = le64_to_cpu(req->PreviousSessionId);
@@ -1545,7 +1542,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
 		return -EINVAL;
 	}
 	rsp->SecurityBufferLength = cpu_to_le16(out_len);
-	inc_rfc1001_len(rsp, out_len - 1);
+	inc_rfc1001_len(work->response_buf, out_len - 1);
 
 	if ((conn->sign || server_conf.enforced_signing) ||
 	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
@@ -1603,8 +1600,8 @@ static int krb5_authenticate(struct ksmbd_work *work)
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_sess_setup_req *req = work->request_buf;
-	struct smb2_sess_setup_rsp *rsp = work->response_buf;
+	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_session *sess;
 	struct negotiate_message *negblob;
 	int rc = 0;
@@ -1615,7 +1612,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	rsp->SessionFlags = 0;
 	rsp->SecurityBufferOffset = cpu_to_le16(72);
 	rsp->SecurityBufferLength = 0;
-	inc_rfc1001_len(rsp, 9);
+	inc_rfc1001_len(work->response_buf, 9);
 
 	if (!req->hdr.SessionId) {
 		sess = ksmbd_smb2_session_create();
@@ -1723,7 +1720,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 				 * Note: here total size -1 is done as an
 				 * adjustment for 0 size blob
 				 */
-				inc_rfc1001_len(rsp, le16_to_cpu(rsp->SecurityBufferLength) - 1);
+				inc_rfc1001_len(work->response_buf,
+						le16_to_cpu(rsp->SecurityBufferLength) - 1);
 
 			} else if (negblob->MessageType == NtLmAuthenticate) {
 				rc = ntlm_authenticate(work);
@@ -1791,8 +1789,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 int smb2_tree_connect(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_tree_connect_req *req = work->request_buf;
-	struct smb2_tree_connect_rsp *rsp = work->response_buf;
+	struct smb2_tree_connect_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_tree_connect_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
@@ -1857,7 +1855,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
-	inc_rfc1001_len(rsp, 16);
+	inc_rfc1001_len(work->response_buf, 16);
 
 	if (!IS_ERR(treename))
 		kfree(treename);
@@ -1962,17 +1960,18 @@ static int smb2_create_open_flags(bool file_present, __le32 access,
  */
 int smb2_tree_disconnect(struct ksmbd_work *work)
 {
-	struct smb2_tree_disconnect_rsp *rsp = work->response_buf;
+	struct smb2_tree_disconnect_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_tree_connect *tcon = work->tcon;
 
 	rsp->StructureSize = cpu_to_le16(4);
-	inc_rfc1001_len(rsp, 4);
+	inc_rfc1001_len(work->response_buf, 4);
 
 	ksmbd_debug(SMB, "request\n");
 
 	if (!tcon) {
-		struct smb2_tree_disconnect_req *req = work->request_buf;
+		struct smb2_tree_disconnect_req *req =
+			smb2_get_msg(work->request_buf);
 
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
@@ -1994,11 +1993,11 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 int smb2_session_logoff(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_logoff_rsp *rsp = work->response_buf;
+	struct smb2_logoff_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_session *sess = work->sess;
 
 	rsp->StructureSize = cpu_to_le16(4);
-	inc_rfc1001_len(rsp, 4);
+	inc_rfc1001_len(work->response_buf, 4);
 
 	ksmbd_debug(SMB, "request\n");
 
@@ -2011,7 +2010,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	ksmbd_conn_wait_idle(conn);
 
 	if (ksmbd_tree_conn_session_logoff(sess)) {
-		struct smb2_logoff_req *req = work->request_buf;
+		struct smb2_logoff_req *req = smb2_get_msg(work->request_buf);
 
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
@@ -2038,8 +2037,8 @@ int smb2_session_logoff(struct ksmbd_work *work)
  */
 static noinline int create_smb2_pipe(struct ksmbd_work *work)
 {
-	struct smb2_create_rsp *rsp = work->response_buf;
-	struct smb2_create_req *req = work->request_buf;
+	struct smb2_create_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_create_req *req = smb2_get_msg(work->request_buf);
 	int id;
 	int err;
 	char *name;
@@ -2077,7 +2076,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	rsp->CreateContextsOffset = 0;
 	rsp->CreateContextsLength = 0;
 
-	inc_rfc1001_len(rsp, 88); /* StructureSize - 1*/
+	inc_rfc1001_len(work->response_buf, 88); /* StructureSize - 1*/
 	kfree(name);
 	return 0;
 
@@ -2410,7 +2409,7 @@ int smb2_open(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_tree_connect *tcon = work->tcon;
 	struct smb2_create_req *req;
-	struct smb2_create_rsp *rsp, *rsp_org;
+	struct smb2_create_rsp *rsp;
 	struct path path;
 	struct ksmbd_share_config *share = tcon->share_conf;
 	struct ksmbd_file *fp = NULL;
@@ -2436,7 +2435,6 @@ int smb2_open(struct ksmbd_work *work)
 	umode_t posix_mode = 0;
 	__le32 daccess, maximal_access = 0;
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	if (req->hdr.NextCommand && !work->next_smb2_rcv_hdr_off &&
@@ -3088,7 +3086,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	rsp->CreateContextsOffset = 0;
 	rsp->CreateContextsLength = 0;
-	inc_rfc1001_len(rsp_org, 88); /* StructureSize - 1*/
+	inc_rfc1001_len(work->response_buf, 88); /* StructureSize - 1*/
 
 	/* If lease is request send lease context response */
 	if (opinfo && opinfo->is_lease) {
@@ -3103,7 +3101,8 @@ int smb2_open(struct ksmbd_work *work)
 		create_lease_buf(rsp->Buffer, opinfo->o_lease);
 		le32_add_cpu(&rsp->CreateContextsLength,
 			     conn->vals->create_lease_size);
-		inc_rfc1001_len(rsp_org, conn->vals->create_lease_size);
+		inc_rfc1001_len(work->response_buf,
+				conn->vals->create_lease_size);
 		next_ptr = &lease_ccontext->Next;
 		next_off = conn->vals->create_lease_size;
 	}
@@ -3123,7 +3122,8 @@ int smb2_open(struct ksmbd_work *work)
 				le32_to_cpu(maximal_access));
 		le32_add_cpu(&rsp->CreateContextsLength,
 			     conn->vals->create_mxac_size);
-		inc_rfc1001_len(rsp_org, conn->vals->create_mxac_size);
+		inc_rfc1001_len(work->response_buf,
+				conn->vals->create_mxac_size);
 		if (next_ptr)
 			*next_ptr = cpu_to_le32(next_off);
 		next_ptr = &mxac_ccontext->Next;
@@ -3141,7 +3141,8 @@ int smb2_open(struct ksmbd_work *work)
 				stat.ino, tcon->id);
 		le32_add_cpu(&rsp->CreateContextsLength,
 			     conn->vals->create_disk_id_size);
-		inc_rfc1001_len(rsp_org, conn->vals->create_disk_id_size);
+		inc_rfc1001_len(work->response_buf,
+				conn->vals->create_disk_id_size);
 		if (next_ptr)
 			*next_ptr = cpu_to_le32(next_off);
 		next_ptr = &disk_id_ccontext->Next;
@@ -3155,15 +3156,15 @@ int smb2_open(struct ksmbd_work *work)
 				fp);
 		le32_add_cpu(&rsp->CreateContextsLength,
 			     conn->vals->create_posix_size);
-		inc_rfc1001_len(rsp_org, conn->vals->create_posix_size);
+		inc_rfc1001_len(work->response_buf,
+				conn->vals->create_posix_size);
 		if (next_ptr)
 			*next_ptr = cpu_to_le32(next_off);
 	}
 
 	if (contxt_cnt > 0) {
 		rsp->CreateContextsOffset =
-			cpu_to_le32(offsetof(struct smb2_create_rsp, Buffer)
-			- 4);
+			cpu_to_le32(offsetof(struct smb2_create_rsp, Buffer));
 	}
 
 err_out:
@@ -3746,7 +3747,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_query_directory_req *req;
-	struct smb2_query_directory_rsp *rsp, *rsp_org;
+	struct smb2_query_directory_rsp *rsp;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
 	struct ksmbd_file *dir_fp = NULL;
 	struct ksmbd_dir_info d_info;
@@ -3756,7 +3757,6 @@ int smb2_query_dir(struct ksmbd_work *work)
 	int buffer_sz;
 	struct smb2_query_dir_private query_dir_private = {NULL, };
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	if (ksmbd_override_fsids(work)) {
@@ -3818,7 +3818,8 @@ int smb2_query_dir(struct ksmbd_work *work)
 	memset(&d_info, 0, sizeof(struct ksmbd_dir_info));
 	d_info.wptr = (char *)rsp->Buffer;
 	d_info.rptr = (char *)rsp->Buffer;
-	d_info.out_buf_len = (work->response_sz - (get_rfc1002_len(rsp_org) + 4));
+	d_info.out_buf_len =
+		work->response_sz - (get_rfc1002_len(work->response_buf) + 4);
 	d_info.out_buf_len = min_t(int, d_info.out_buf_len, le32_to_cpu(req->OutputBufferLength)) -
 		sizeof(struct smb2_query_directory_rsp);
 	d_info.flags = srch_flag;
@@ -3873,7 +3874,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->OutputBufferOffset = cpu_to_le16(0);
 		rsp->OutputBufferLength = cpu_to_le32(0);
 		rsp->Buffer[0] = 0;
-		inc_rfc1001_len(rsp_org, 9);
+		inc_rfc1001_len(work->response_buf, 9);
 	} else {
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
@@ -3882,7 +3883,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
 		rsp->OutputBufferLength = cpu_to_le32(d_info.data_count);
-		inc_rfc1001_len(rsp_org, 8 + d_info.data_count);
+		inc_rfc1001_len(work->response_buf, 8 + d_info.data_count);
 	}
 
 	kfree(srch_ptr);
@@ -3925,26 +3926,28 @@ int smb2_query_dir(struct ksmbd_work *work)
  * Return:	0 on success, otherwise error
  */
 static int buffer_check_err(int reqOutputBufferLength,
-			    struct smb2_query_info_rsp *rsp, int infoclass_size)
+			    struct smb2_query_info_rsp *rsp,
+			    void *rsp_org, int infoclass_size)
 {
 	if (reqOutputBufferLength < le32_to_cpu(rsp->OutputBufferLength)) {
 		if (reqOutputBufferLength < infoclass_size) {
 			pr_err("Invalid Buffer Size Requested\n");
 			rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
-			rsp->hdr.smb2_buf_length = cpu_to_be32(sizeof(struct smb2_hdr) - 4);
+			*(__be32 *)rsp_org = cpu_to_be32(sizeof(struct smb2_hdr));
 			return -EINVAL;
 		}
 
 		ksmbd_debug(SMB, "Buffer Overflow\n");
 		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
-		rsp->hdr.smb2_buf_length = cpu_to_be32(sizeof(struct smb2_hdr) - 4 +
+		*(__be32 *)rsp_org = cpu_to_be32(sizeof(struct smb2_hdr) +
 				reqOutputBufferLength);
 		rsp->OutputBufferLength = cpu_to_le32(reqOutputBufferLength);
 	}
 	return 0;
 }
 
-static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp)
+static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
+				   void *rsp_org)
 {
 	struct smb2_file_standard_info *sinfo;
 
@@ -3957,10 +3960,11 @@ static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp)
 	sinfo->Directory = 0;
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
-	inc_rfc1001_len(rsp, sizeof(struct smb2_file_standard_info));
+	inc_rfc1001_len(rsp_org, sizeof(struct smb2_file_standard_info));
 }
 
-static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num)
+static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
+				   void *rsp_org)
 {
 	struct smb2_file_internal_info *file_info;
 
@@ -3970,12 +3974,13 @@ static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num)
 	file_info->IndexNumber = cpu_to_le64(num | (1ULL << 63));
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_internal_info));
-	inc_rfc1001_len(rsp, sizeof(struct smb2_file_internal_info));
+	inc_rfc1001_len(rsp_org, sizeof(struct smb2_file_internal_info));
 }
 
 static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 				   struct smb2_query_info_req *req,
-				   struct smb2_query_info_rsp *rsp)
+				   struct smb2_query_info_rsp *rsp,
+				   void *rsp_org)
 {
 	u64 id;
 	int rc;
@@ -3993,14 +3998,16 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 
 	switch (req->FileInfoClass) {
 	case FILE_STANDARD_INFORMATION:
-		get_standard_info_pipe(rsp);
+		get_standard_info_pipe(rsp, rsp_org);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
-				      rsp, FILE_STANDARD_INFORMATION_SIZE);
+				      rsp, rsp_org,
+				      FILE_STANDARD_INFORMATION_SIZE);
 		break;
 	case FILE_INTERNAL_INFORMATION:
-		get_internal_info_pipe(rsp, id);
+		get_internal_info_pipe(rsp, id, rsp_org);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
-				      rsp, FILE_INTERNAL_INFORMATION_SIZE);
+				      rsp, rsp_org,
+				      FILE_INTERNAL_INFORMATION_SIZE);
 		break;
 	default:
 		ksmbd_debug(SMB, "smb2_info_file_pipe for %u not supported\n",
@@ -4602,7 +4609,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 
 static int smb2_get_info_file(struct ksmbd_work *work,
 			      struct smb2_query_info_req *req,
-			      struct smb2_query_info_rsp *rsp, void *rsp_org)
+			      struct smb2_query_info_rsp *rsp)
 {
 	struct ksmbd_file *fp;
 	int fileinfoclass = 0;
@@ -4613,7 +4620,8 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		/* smb2 info file called for pipe */
-		return smb2_get_info_file_pipe(work->sess, req, rsp);
+		return smb2_get_info_file_pipe(work->sess, req, rsp,
+					       work->response_buf);
 	}
 
 	if (work->next_smb2_rcv_hdr_off) {
@@ -4638,77 +4646,77 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 
 	switch (fileinfoclass) {
 	case FILE_ACCESS_INFORMATION:
-		get_file_access_info(rsp, fp, rsp_org);
+		get_file_access_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_ACCESS_INFORMATION_SIZE;
 		break;
 
 	case FILE_BASIC_INFORMATION:
-		rc = get_file_basic_info(rsp, fp, rsp_org);
+		rc = get_file_basic_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_BASIC_INFORMATION_SIZE;
 		break;
 
 	case FILE_STANDARD_INFORMATION:
-		get_file_standard_info(rsp, fp, rsp_org);
+		get_file_standard_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_STANDARD_INFORMATION_SIZE;
 		break;
 
 	case FILE_ALIGNMENT_INFORMATION:
-		get_file_alignment_info(rsp, rsp_org);
+		get_file_alignment_info(rsp, work->response_buf);
 		file_infoclass_size = FILE_ALIGNMENT_INFORMATION_SIZE;
 		break;
 
 	case FILE_ALL_INFORMATION:
-		rc = get_file_all_info(work, rsp, fp, rsp_org);
+		rc = get_file_all_info(work, rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_ALL_INFORMATION_SIZE;
 		break;
 
 	case FILE_ALTERNATE_NAME_INFORMATION:
-		get_file_alternate_info(work, rsp, fp, rsp_org);
+		get_file_alternate_info(work, rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
 		break;
 
 	case FILE_STREAM_INFORMATION:
-		get_file_stream_info(work, rsp, fp, rsp_org);
+		get_file_stream_info(work, rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_STREAM_INFORMATION_SIZE;
 		break;
 
 	case FILE_INTERNAL_INFORMATION:
-		get_file_internal_info(rsp, fp, rsp_org);
+		get_file_internal_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_INTERNAL_INFORMATION_SIZE;
 		break;
 
 	case FILE_NETWORK_OPEN_INFORMATION:
-		rc = get_file_network_open_info(rsp, fp, rsp_org);
+		rc = get_file_network_open_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_NETWORK_OPEN_INFORMATION_SIZE;
 		break;
 
 	case FILE_EA_INFORMATION:
-		get_file_ea_info(rsp, rsp_org);
+		get_file_ea_info(rsp, work->response_buf);
 		file_infoclass_size = FILE_EA_INFORMATION_SIZE;
 		break;
 
 	case FILE_FULL_EA_INFORMATION:
-		rc = smb2_get_ea(work, fp, req, rsp, rsp_org);
+		rc = smb2_get_ea(work, fp, req, rsp, work->response_buf);
 		file_infoclass_size = FILE_FULL_EA_INFORMATION_SIZE;
 		break;
 
 	case FILE_POSITION_INFORMATION:
-		get_file_position_info(rsp, fp, rsp_org);
+		get_file_position_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_POSITION_INFORMATION_SIZE;
 		break;
 
 	case FILE_MODE_INFORMATION:
-		get_file_mode_info(rsp, fp, rsp_org);
+		get_file_mode_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_MODE_INFORMATION_SIZE;
 		break;
 
 	case FILE_COMPRESSION_INFORMATION:
-		get_file_compression_info(rsp, fp, rsp_org);
+		get_file_compression_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_COMPRESSION_INFORMATION_SIZE;
 		break;
 
 	case FILE_ATTRIBUTE_TAG_INFORMATION:
-		rc = get_file_attribute_tag_info(rsp, fp, rsp_org);
+		rc = get_file_attribute_tag_info(rsp, fp, work->response_buf);
 		file_infoclass_size = FILE_ATTRIBUTE_TAG_INFORMATION_SIZE;
 		break;
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -4716,7 +4724,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			rc = -EOPNOTSUPP;
 		} else {
-			rc = find_file_posix_info(rsp, fp, rsp_org);
+			rc = find_file_posix_info(rsp, fp, work->response_buf);
 			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
 		}
 		break;
@@ -4727,7 +4735,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	}
 	if (!rc)
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
-				      rsp,
+				      rsp, work->response_buf,
 				      file_infoclass_size);
 	ksmbd_fd_put(work, fp);
 	return rc;
@@ -4735,7 +4743,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 
 static int smb2_get_info_filesystem(struct ksmbd_work *work,
 				    struct smb2_query_info_req *req,
-				    struct smb2_query_info_rsp *rsp, void *rsp_org)
+				    struct smb2_query_info_rsp *rsp)
 {
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_conn *conn = sess->conn;
@@ -4775,7 +4783,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->DeviceType = cpu_to_le32(stfs.f_type);
 		info->DeviceCharacteristics = cpu_to_le32(0x00000020);
 		rsp->OutputBufferLength = cpu_to_le32(8);
-		inc_rfc1001_len(rsp_org, 8);
+		inc_rfc1001_len(work->response_buf, 8);
 		fs_infoclass_size = FS_DEVICE_INFORMATION_SIZE;
 		break;
 	}
@@ -4801,7 +4809,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->FileSystemNameLen = cpu_to_le32(len);
 		sz = sizeof(struct filesystem_attribute_info) - 2 + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
-		inc_rfc1001_len(rsp_org, sz);
+		inc_rfc1001_len(work->response_buf, sz);
 		fs_infoclass_size = FS_ATTRIBUTE_INFORMATION_SIZE;
 		break;
 	}
@@ -4822,7 +4830,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->Reserved = 0;
 		sz = sizeof(struct filesystem_vol_info) - 2 + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
-		inc_rfc1001_len(rsp_org, sz);
+		inc_rfc1001_len(work->response_buf, sz);
 		fs_infoclass_size = FS_VOLUME_INFORMATION_SIZE;
 		break;
 	}
@@ -4836,7 +4844,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
 		info->BytesPerSector = cpu_to_le32(stfs.f_bsize);
 		rsp->OutputBufferLength = cpu_to_le32(24);
-		inc_rfc1001_len(rsp_org, 24);
+		inc_rfc1001_len(work->response_buf, 24);
 		fs_infoclass_size = FS_SIZE_INFORMATION_SIZE;
 		break;
 	}
@@ -4853,7 +4861,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
 		info->BytesPerSector = cpu_to_le32(stfs.f_bsize);
 		rsp->OutputBufferLength = cpu_to_le32(32);
-		inc_rfc1001_len(rsp_org, 32);
+		inc_rfc1001_len(work->response_buf, 32);
 		fs_infoclass_size = FS_FULL_SIZE_INFORMATION_SIZE;
 		break;
 	}
@@ -4874,7 +4882,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->extended_info.rel_date = 0;
 		memcpy(info->extended_info.version_string, "1.1.0", strlen("1.1.0"));
 		rsp->OutputBufferLength = cpu_to_le32(64);
-		inc_rfc1001_len(rsp_org, 64);
+		inc_rfc1001_len(work->response_buf, 64);
 		fs_infoclass_size = FS_OBJECT_ID_INFORMATION_SIZE;
 		break;
 	}
@@ -4895,7 +4903,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->ByteOffsetForSectorAlignment = 0;
 		info->ByteOffsetForPartitionAlignment = 0;
 		rsp->OutputBufferLength = cpu_to_le32(28);
-		inc_rfc1001_len(rsp_org, 28);
+		inc_rfc1001_len(work->response_buf, 28);
 		fs_infoclass_size = FS_SECTOR_SIZE_INFORMATION_SIZE;
 		break;
 	}
@@ -4917,7 +4925,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
-		inc_rfc1001_len(rsp_org, 48);
+		inc_rfc1001_len(work->response_buf, 48);
 		fs_infoclass_size = FS_CONTROL_INFORMATION_SIZE;
 		break;
 	}
@@ -4938,7 +4946,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
 			rsp->OutputBufferLength = cpu_to_le32(56);
-			inc_rfc1001_len(rsp_org, 56);
+			inc_rfc1001_len(work->response_buf, 56);
 			fs_infoclass_size = FS_POSIX_INFORMATION_SIZE;
 		}
 		break;
@@ -4948,7 +4956,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		return -EOPNOTSUPP;
 	}
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
-			      rsp,
+			      rsp, work->response_buf,
 			      fs_infoclass_size);
 	path_put(&path);
 	return rc;
@@ -4956,7 +4964,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 static int smb2_get_info_sec(struct ksmbd_work *work,
 			     struct smb2_query_info_req *req,
-			     struct smb2_query_info_rsp *rsp, void *rsp_org)
+			     struct smb2_query_info_rsp *rsp)
 {
 	struct ksmbd_file *fp;
 	struct user_namespace *user_ns;
@@ -4983,7 +4991,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 		secdesclen = sizeof(struct smb_ntsd);
 		rsp->OutputBufferLength = cpu_to_le32(secdesclen);
-		inc_rfc1001_len(rsp_org, secdesclen);
+		inc_rfc1001_len(work->response_buf, secdesclen);
 
 		return 0;
 	}
@@ -5025,7 +5033,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 		return rc;
 
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
-	inc_rfc1001_len(rsp_org, secdesclen);
+	inc_rfc1001_len(work->response_buf, secdesclen);
 	return 0;
 }
 
@@ -5038,10 +5046,9 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 int smb2_query_info(struct ksmbd_work *work)
 {
 	struct smb2_query_info_req *req;
-	struct smb2_query_info_rsp *rsp, *rsp_org;
+	struct smb2_query_info_rsp *rsp;
 	int rc = 0;
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	ksmbd_debug(SMB, "GOT query info request\n");
@@ -5049,15 +5056,15 @@ int smb2_query_info(struct ksmbd_work *work)
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
-		rc = smb2_get_info_file(work, req, rsp, (void *)rsp_org);
+		rc = smb2_get_info_file(work, req, rsp);
 		break;
 	case SMB2_O_INFO_FILESYSTEM:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILESYSTEM\n");
-		rc = smb2_get_info_filesystem(work, req, rsp, (void *)rsp_org);
+		rc = smb2_get_info_filesystem(work, req, rsp);
 		break;
 	case SMB2_O_INFO_SECURITY:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
-		rc = smb2_get_info_sec(work, req, rsp, (void *)rsp_org);
+		rc = smb2_get_info_sec(work, req, rsp);
 		break;
 	default:
 		ksmbd_debug(SMB, "InfoType %d not supported yet\n",
@@ -5082,7 +5089,7 @@ int smb2_query_info(struct ksmbd_work *work)
 	}
 	rsp->StructureSize = cpu_to_le16(9);
 	rsp->OutputBufferOffset = cpu_to_le16(72);
-	inc_rfc1001_len(rsp_org, 8);
+	inc_rfc1001_len(work->response_buf, 8);
 	return 0;
 }
 
@@ -5095,8 +5102,8 @@ int smb2_query_info(struct ksmbd_work *work)
 static noinline int smb2_close_pipe(struct ksmbd_work *work)
 {
 	u64 id;
-	struct smb2_close_req *req = work->request_buf;
-	struct smb2_close_rsp *rsp = work->response_buf;
+	struct smb2_close_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_close_rsp *rsp = smb2_get_msg(work->response_buf);
 
 	id = le64_to_cpu(req->VolatileFileId);
 	ksmbd_session_rpc_close(work->sess, id);
@@ -5111,7 +5118,7 @@ static noinline int smb2_close_pipe(struct ksmbd_work *work)
 	rsp->AllocationSize = 0;
 	rsp->EndOfFile = 0;
 	rsp->Attributes = 0;
-	inc_rfc1001_len(rsp, 60);
+	inc_rfc1001_len(work->response_buf, 60);
 	return 0;
 }
 
@@ -5127,14 +5134,12 @@ int smb2_close(struct ksmbd_work *work)
 	u64 sess_id;
 	struct smb2_close_req *req;
 	struct smb2_close_rsp *rsp;
-	struct smb2_close_rsp *rsp_org;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_file *fp;
 	struct inode *inode;
 	u64 time;
 	int err = 0;
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	if (test_share_config_flag(work->tcon->share_conf,
@@ -5224,7 +5229,7 @@ int smb2_close(struct ksmbd_work *work)
 			rsp->hdr.Status = STATUS_FILE_CLOSED;
 		smb2_set_err_rsp(work);
 	} else {
-		inc_rfc1001_len(rsp_org, 60);
+		inc_rfc1001_len(work->response_buf, 60);
 	}
 
 	return 0;
@@ -5238,11 +5243,11 @@ int smb2_close(struct ksmbd_work *work)
  */
 int smb2_echo(struct ksmbd_work *work)
 {
-	struct smb2_echo_rsp *rsp = work->response_buf;
+	struct smb2_echo_rsp *rsp = smb2_get_msg(work->response_buf);
 
 	rsp->StructureSize = cpu_to_le16(4);
 	rsp->Reserved = 0;
-	inc_rfc1001_len(rsp, 4);
+	inc_rfc1001_len(work->response_buf, 4);
 	return 0;
 }
 
@@ -5814,14 +5819,13 @@ static int smb2_set_info_sec(struct ksmbd_file *fp, int addition_info,
 int smb2_set_info(struct ksmbd_work *work)
 {
 	struct smb2_set_info_req *req;
-	struct smb2_set_info_rsp *rsp, *rsp_org;
+	struct smb2_set_info_rsp *rsp;
 	struct ksmbd_file *fp;
 	int rc = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	ksmbd_debug(SMB, "Received set info request\n");
 
-	rsp_org = work->response_buf;
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
@@ -5832,8 +5836,8 @@ int smb2_set_info(struct ksmbd_work *work)
 			pid = work->compound_pfid;
 		}
 	} else {
-		req = work->request_buf;
-		rsp = work->response_buf;
+		req = smb2_get_msg(work->request_buf);
+		rsp = smb2_get_msg(work->response_buf);
 	}
 
 	if (!has_file_id(id)) {
@@ -5874,7 +5878,7 @@ int smb2_set_info(struct ksmbd_work *work)
 		goto err_out;
 
 	rsp->StructureSize = cpu_to_le16(2);
-	inc_rfc1001_len(rsp_org, 2);
+	inc_rfc1001_len(work->response_buf, 2);
 	ksmbd_fd_put(work, fp);
 	return 0;
 
@@ -5914,12 +5918,12 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	int nbytes = 0, err;
 	u64 id;
 	struct ksmbd_rpc_command *rpc_resp;
-	struct smb2_read_req *req = work->request_buf;
-	struct smb2_read_rsp *rsp = work->response_buf;
+	struct smb2_read_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_read_rsp *rsp = smb2_get_msg(work->response_buf);
 
 	id = le64_to_cpu(req->VolatileFileId);
 
-	inc_rfc1001_len(rsp, 16);
+	inc_rfc1001_len(work->response_buf, 16);
 	rpc_resp = ksmbd_rpc_read(work->sess, id);
 	if (rpc_resp) {
 		if (rpc_resp->flags != KSMBD_RPC_OK) {
@@ -5938,7 +5942,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 		       rpc_resp->payload_sz);
 
 		nbytes = rpc_resp->payload_sz;
-		work->resp_hdr_sz = get_rfc1002_len(rsp) + 4;
+		work->resp_hdr_sz = get_rfc1002_len(work->response_buf) + 4;
 		work->aux_payload_sz = nbytes;
 		kvfree(rpc_resp);
 	}
@@ -5949,7 +5953,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rsp->DataLength = cpu_to_le32(nbytes);
 	rsp->DataRemaining = 0;
 	rsp->Reserved2 = 0;
-	inc_rfc1001_len(rsp, nbytes);
+	inc_rfc1001_len(work->response_buf, nbytes);
 	return 0;
 
 out:
@@ -5999,14 +6003,13 @@ int smb2_read(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_read_req *req;
-	struct smb2_read_rsp *rsp, *rsp_org;
+	struct smb2_read_rsp *rsp;
 	struct ksmbd_file *fp;
 	loff_t offset;
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	if (test_share_config_flag(work->tcon->share_conf,
@@ -6088,10 +6091,10 @@ int smb2_read(struct ksmbd_work *work)
 	rsp->DataLength = cpu_to_le32(nbytes);
 	rsp->DataRemaining = cpu_to_le32(remain_bytes);
 	rsp->Reserved2 = 0;
-	inc_rfc1001_len(rsp_org, 16);
-	work->resp_hdr_sz = get_rfc1002_len(rsp_org) + 4;
+	inc_rfc1001_len(work->response_buf, 16);
+	work->resp_hdr_sz = get_rfc1002_len(work->response_buf) + 4;
 	work->aux_payload_sz = nbytes;
-	inc_rfc1001_len(rsp_org, nbytes);
+	inc_rfc1001_len(work->response_buf, nbytes);
 	ksmbd_fd_put(work, fp);
 	return 0;
 
@@ -6126,8 +6129,8 @@ int smb2_read(struct ksmbd_work *work)
  */
 static noinline int smb2_write_pipe(struct ksmbd_work *work)
 {
-	struct smb2_write_req *req = work->request_buf;
-	struct smb2_write_rsp *rsp = work->response_buf;
+	struct smb2_write_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_write_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_rpc_command *rpc_resp;
 	u64 id = 0;
 	int err = 0, ret = 0;
@@ -6141,11 +6144,13 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	    (offsetof(struct smb2_write_req, Buffer) - 4)) {
 		data_buf = (char *)&req->Buffer[0];
 	} else {
-		if ((le16_to_cpu(req->DataOffset) > get_rfc1002_len(req)) ||
-		    (le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req))) {
+		if ((le16_to_cpu(req->DataOffset) >
+		     get_rfc1002_len(work->request_buf)) ||
+		    (le16_to_cpu(req->DataOffset) + length >
+		     get_rfc1002_len(work->request_buf))) {
 			pr_err("invalid write data offset %u, smb_len %u\n",
 			       le16_to_cpu(req->DataOffset),
-			       get_rfc1002_len(req));
+			       get_rfc1002_len(work->request_buf));
 			err = -EINVAL;
 			goto out;
 		}
@@ -6177,7 +6182,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	rsp->DataLength = cpu_to_le32(length);
 	rsp->DataRemaining = 0;
 	rsp->Reserved2 = 0;
-	inc_rfc1001_len(rsp, 16);
+	inc_rfc1001_len(work->response_buf, 16);
 	return 0;
 out:
 	if (err) {
@@ -6245,7 +6250,7 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 int smb2_write(struct ksmbd_work *work)
 {
 	struct smb2_write_req *req;
-	struct smb2_write_rsp *rsp, *rsp_org;
+	struct smb2_write_rsp *rsp;
 	struct ksmbd_file *fp = NULL;
 	loff_t offset;
 	size_t length;
@@ -6254,7 +6259,6 @@ int smb2_write(struct ksmbd_work *work)
 	bool writethrough = false;
 	int err = 0;
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	if (test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_PIPE)) {
@@ -6300,11 +6304,13 @@ int smb2_write(struct ksmbd_work *work)
 		    (offsetof(struct smb2_write_req, Buffer) - 4)) {
 			data_buf = (char *)&req->Buffer[0];
 		} else {
-			if ((le16_to_cpu(req->DataOffset) > get_rfc1002_len(req)) ||
-			    (le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req))) {
+			if ((le16_to_cpu(req->DataOffset) >
+			     get_rfc1002_len(work->request_buf)) ||
+			    (le16_to_cpu(req->DataOffset) + length >
+			     get_rfc1002_len(work->request_buf))) {
 				pr_err("invalid write data offset %u, smb_len %u\n",
 				       le16_to_cpu(req->DataOffset),
-				       get_rfc1002_len(req));
+				       get_rfc1002_len(work->request_buf));
 				err = -EINVAL;
 				goto out;
 			}
@@ -6342,7 +6348,7 @@ int smb2_write(struct ksmbd_work *work)
 	rsp->DataLength = cpu_to_le32(nbytes);
 	rsp->DataRemaining = 0;
 	rsp->Reserved2 = 0;
-	inc_rfc1001_len(rsp_org, 16);
+	inc_rfc1001_len(work->response_buf, 16);
 	ksmbd_fd_put(work, fp);
 	return 0;
 
@@ -6376,10 +6382,9 @@ int smb2_write(struct ksmbd_work *work)
 int smb2_flush(struct ksmbd_work *work)
 {
 	struct smb2_flush_req *req;
-	struct smb2_flush_rsp *rsp, *rsp_org;
+	struct smb2_flush_rsp *rsp;
 	int err;
 
-	rsp_org = work->response_buf;
 	WORK_BUFFERS(work, req, rsp);
 
 	ksmbd_debug(SMB, "SMB2_FLUSH called for fid %llu\n",
@@ -6393,7 +6398,7 @@ int smb2_flush(struct ksmbd_work *work)
 
 	rsp->StructureSize = cpu_to_le16(4);
 	rsp->Reserved = 0;
-	inc_rfc1001_len(rsp_org, 4);
+	inc_rfc1001_len(work->response_buf, 4);
 	return 0;
 
 out:
@@ -6414,7 +6419,7 @@ int smb2_flush(struct ksmbd_work *work)
 int smb2_cancel(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_hdr *hdr = work->request_buf;
+	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 	struct smb2_hdr *chdr;
 	struct ksmbd_work *cancel_work = NULL;
 	int canceled = 0;
@@ -6429,7 +6434,7 @@ int smb2_cancel(struct ksmbd_work *work)
 		spin_lock(&conn->request_lock);
 		list_for_each_entry(cancel_work, command_list,
 				    async_request_entry) {
-			chdr = cancel_work->request_buf;
+			chdr = smb2_get_msg(cancel_work->request_buf);
 
 			if (cancel_work->async_id !=
 			    le64_to_cpu(hdr->Id.AsyncId))
@@ -6448,7 +6453,7 @@ int smb2_cancel(struct ksmbd_work *work)
 
 		spin_lock(&conn->request_lock);
 		list_for_each_entry(cancel_work, command_list, request_entry) {
-			chdr = cancel_work->request_buf;
+			chdr = smb2_get_msg(cancel_work->request_buf);
 
 			if (chdr->MessageId != hdr->MessageId ||
 			    cancel_work == work)
@@ -6583,8 +6588,8 @@ static inline bool lock_defer_pending(struct file_lock *fl)
  */
 int smb2_lock(struct ksmbd_work *work)
 {
-	struct smb2_lock_req *req = work->request_buf;
-	struct smb2_lock_rsp *rsp = work->response_buf;
+	struct smb2_lock_req *req = smb2_get_msg(work->request_buf);
+	struct smb2_lock_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct smb2_lock_element *lock_ele;
 	struct ksmbd_file *fp = NULL;
 	struct file_lock *flock = NULL;
@@ -6891,7 +6896,7 @@ int smb2_lock(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "successful in taking lock\n");
 	rsp->hdr.Status = STATUS_SUCCESS;
 	rsp->Reserved = 0;
-	inc_rfc1001_len(rsp, 4);
+	inc_rfc1001_len(work->response_buf, 4);
 	ksmbd_fd_put(work, fp);
 	return 0;
 
@@ -7356,14 +7361,13 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
 int smb2_ioctl(struct ksmbd_work *work)
 {
 	struct smb2_ioctl_req *req;
-	struct smb2_ioctl_rsp *rsp, *rsp_org;
+	struct smb2_ioctl_rsp *rsp;
 	int cnt_code, nbytes = 0;
 	int out_buf_len;
 	u64 id = KSMBD_NO_FID;
 	struct ksmbd_conn *conn = work->conn;
 	int ret = 0;
 
-	rsp_org = work->response_buf;
 	if (work->next_smb2_rcv_hdr_off) {
 		req = ksmbd_req_buf_next(work);
 		rsp = ksmbd_resp_buf_next(work);
@@ -7373,8 +7377,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 			id = work->compound_fid;
 		}
 	} else {
-		req = work->request_buf;
-		rsp = work->response_buf;
+		req = smb2_get_msg(work->request_buf);
+		rsp = smb2_get_msg(work->response_buf);
 	}
 
 	if (!has_file_id(id))
@@ -7606,7 +7610,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	rsp->Reserved = cpu_to_le16(0);
 	rsp->Flags = cpu_to_le32(0);
 	rsp->Reserved2 = cpu_to_le32(0);
-	inc_rfc1001_len(rsp_org, 48 + nbytes);
+	inc_rfc1001_len(work->response_buf, 48 + nbytes);
 
 	return 0;
 
@@ -7631,8 +7635,8 @@ int smb2_ioctl(struct ksmbd_work *work)
  */
 static void smb20_oplock_break_ack(struct ksmbd_work *work)
 {
-	struct smb2_oplock_break *req = work->request_buf;
-	struct smb2_oplock_break *rsp = work->response_buf;
+	struct smb2_oplock_break *req = smb2_get_msg(work->request_buf);
+	struct smb2_oplock_break *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_file *fp;
 	struct oplock_info *opinfo = NULL;
 	__le32 err = 0;
@@ -7739,7 +7743,7 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	rsp->Reserved2 = 0;
 	rsp->VolatileFid = cpu_to_le64(volatile_id);
 	rsp->PersistentFid = cpu_to_le64(persistent_id);
-	inc_rfc1001_len(rsp, 24);
+	inc_rfc1001_len(work->response_buf, 24);
 	return;
 
 err_out:
@@ -7775,8 +7779,8 @@ static int check_lease_state(struct lease *lease, __le32 req_state)
 static void smb21_lease_break_ack(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_lease_ack *req = work->request_buf;
-	struct smb2_lease_ack *rsp = work->response_buf;
+	struct smb2_lease_ack *req = smb2_get_msg(work->request_buf);
+	struct smb2_lease_ack *rsp = smb2_get_msg(work->response_buf);
 	struct oplock_info *opinfo;
 	__le32 err = 0;
 	int ret = 0;
@@ -7888,7 +7892,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	memcpy(rsp->LeaseKey, req->LeaseKey, 16);
 	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
-	inc_rfc1001_len(rsp, 36);
+	inc_rfc1001_len(work->response_buf, 36);
 	return;
 
 err_out:
@@ -7909,8 +7913,8 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
  */
 int smb2_oplock_break(struct ksmbd_work *work)
 {
-	struct smb2_oplock_break *req = work->request_buf;
-	struct smb2_oplock_break *rsp = work->response_buf;
+	struct smb2_oplock_break *req = smb2_get_msg(work->request_buf);
+	struct smb2_oplock_break *rsp = smb2_get_msg(work->response_buf);
 
 	switch (le16_to_cpu(req->StructureSize)) {
 	case OP_BREAK_STRUCT_SIZE_20:
@@ -7962,7 +7966,7 @@ int smb2_notify(struct ksmbd_work *work)
  */
 bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
 {
-	struct smb2_hdr *rcv_hdr2 = work->request_buf;
+	struct smb2_hdr *rcv_hdr2 = smb2_get_msg(work->request_buf);
 
 	if ((rcv_hdr2->Flags & SMB2_FLAGS_SIGNED) &&
 	    command != SMB2_NEGOTIATE_HE &&
@@ -7981,22 +7985,22 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
  */
 int smb2_check_sign_req(struct ksmbd_work *work)
 {
-	struct smb2_hdr *hdr, *hdr_org;
+	struct smb2_hdr *hdr;
 	char signature_req[SMB2_SIGNATURE_SIZE];
 	char signature[SMB2_HMACSHA256_SIZE];
 	struct kvec iov[1];
 	size_t len;
 
-	hdr_org = hdr = work->request_buf;
+	hdr = smb2_get_msg(work->request_buf);
 	if (work->next_smb2_rcv_hdr_off)
 		hdr = ksmbd_req_buf_next(work);
 
 	if (!hdr->NextCommand && !work->next_smb2_rcv_hdr_off)
-		len = be32_to_cpu(hdr_org->smb2_buf_length);
+		len = get_rfc1002_len(work->request_buf);
 	else if (hdr->NextCommand)
 		len = le32_to_cpu(hdr->NextCommand);
 	else
-		len = be32_to_cpu(hdr_org->smb2_buf_length) -
+		len = get_rfc1002_len(work->request_buf) -
 			work->next_smb2_rcv_hdr_off;
 
 	memcpy(signature_req, hdr->Signature, SMB2_SIGNATURE_SIZE);
@@ -8024,25 +8028,26 @@ int smb2_check_sign_req(struct ksmbd_work *work)
  */
 void smb2_set_sign_rsp(struct ksmbd_work *work)
 {
-	struct smb2_hdr *hdr, *hdr_org;
+	struct smb2_hdr *hdr;
 	struct smb2_hdr *req_hdr;
 	char signature[SMB2_HMACSHA256_SIZE];
 	struct kvec iov[2];
 	size_t len;
 	int n_vec = 1;
 
-	hdr_org = hdr = work->response_buf;
+	hdr = smb2_get_msg(work->response_buf);
 	if (work->next_smb2_rsp_hdr_off)
 		hdr = ksmbd_resp_buf_next(work);
 
 	req_hdr = ksmbd_req_buf_next(work);
 
 	if (!work->next_smb2_rsp_hdr_off) {
-		len = get_rfc1002_len(hdr_org);
+		len = get_rfc1002_len(work->response_buf);
 		if (req_hdr->NextCommand)
 			len = ALIGN(len, 8);
 	} else {
-		len = get_rfc1002_len(hdr_org) - work->next_smb2_rsp_hdr_off;
+		len = get_rfc1002_len(work->response_buf) -
+			work->next_smb2_rsp_hdr_off;
 		len = ALIGN(len, 8);
 	}
 
@@ -8078,23 +8083,23 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	char *signing_key;
-	struct smb2_hdr *hdr, *hdr_org;
+	struct smb2_hdr *hdr;
 	struct channel *chann;
 	char signature_req[SMB2_SIGNATURE_SIZE];
 	char signature[SMB2_CMACAES_SIZE];
 	struct kvec iov[1];
 	size_t len;
 
-	hdr_org = hdr = work->request_buf;
+	hdr = smb2_get_msg(work->request_buf);
 	if (work->next_smb2_rcv_hdr_off)
 		hdr = ksmbd_req_buf_next(work);
 
 	if (!hdr->NextCommand && !work->next_smb2_rcv_hdr_off)
-		len = be32_to_cpu(hdr_org->smb2_buf_length);
+		len = get_rfc1002_len(work->request_buf);
 	else if (hdr->NextCommand)
 		len = le32_to_cpu(hdr->NextCommand);
 	else
-		len = be32_to_cpu(hdr_org->smb2_buf_length) -
+		len = get_rfc1002_len(work->request_buf) -
 			work->next_smb2_rcv_hdr_off;
 
 	if (le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
@@ -8135,8 +8140,7 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 void smb3_set_sign_rsp(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_hdr *req_hdr;
-	struct smb2_hdr *hdr, *hdr_org;
+	struct smb2_hdr *req_hdr, *hdr;
 	struct channel *chann;
 	char signature[SMB2_CMACAES_SIZE];
 	struct kvec iov[2];
@@ -8144,18 +8148,19 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	size_t len;
 	char *signing_key;
 
-	hdr_org = hdr = work->response_buf;
+	hdr = smb2_get_msg(work->response_buf);
 	if (work->next_smb2_rsp_hdr_off)
 		hdr = ksmbd_resp_buf_next(work);
 
 	req_hdr = ksmbd_req_buf_next(work);
 
 	if (!work->next_smb2_rsp_hdr_off) {
-		len = get_rfc1002_len(hdr_org);
+		len = get_rfc1002_len(work->response_buf);
 		if (req_hdr->NextCommand)
 			len = ALIGN(len, 8);
 	} else {
-		len = get_rfc1002_len(hdr_org) - work->next_smb2_rsp_hdr_off;
+		len = get_rfc1002_len(work->response_buf) -
+			work->next_smb2_rsp_hdr_off;
 		len = ALIGN(len, 8);
 	}
 
@@ -8207,7 +8212,7 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 	WORK_BUFFERS(work, req, rsp);
 
 	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE)
-		ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
+		ksmbd_gen_preauth_integrity_hash(conn, work->response_buf,
 						 conn->preauth_info->Preauth_HashValue);
 
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {
@@ -8225,7 +8230,7 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 			if (!hash_value)
 				return;
 		}
-		ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
+		ksmbd_gen_preauth_integrity_hash(conn, work->response_buf,
 						 hash_value);
 	}
 }
@@ -8353,7 +8358,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_hdr *rsp = work->response_buf;
+	struct smb2_hdr *rsp = smb2_get_msg(work->response_buf);
 
 	if (conn->dialect < SMB30_PROT_ID)
 		return false;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index bcec845b03f3..d975e044704f 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -128,11 +128,6 @@
 	cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
 
 struct smb2_hdr {
-	__be32 smb2_buf_length;	/* big endian on wire */
-				/*
-				 * length is only two or three bytes - with
-				 * one or two byte type preceding it that MBZ
-				 */
 	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
 	__le16 StructureSize;	/* 64 */
 	__le16 CreditCharge;	/* MBZ */
@@ -1695,4 +1690,13 @@ int smb2_ioctl(struct ksmbd_work *work);
 int smb2_oplock_break(struct ksmbd_work *work);
 int smb2_notify(struct ksmbd_work *ksmbd_work);
 
+/*
+ * Get the body of the smb2 message excluding the 4 byte rfc1002 headers
+ * from request/response buffer.
+ */
+static inline void *smb2_get_msg(void *buf)
+{
+	return buf + 4;
+}
+
 #endif	/* _SMB2PDU_H */
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 43d3123d8b62..7360387a6b4d 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -133,7 +133,7 @@ int ksmbd_lookup_protocol_idx(char *str)
  */
 int ksmbd_verify_smb_message(struct ksmbd_work *work)
 {
-	struct smb2_hdr *smb2_hdr = work->request_buf;
+	struct smb2_hdr *smb2_hdr = smb2_get_msg(work->request_buf);
 
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
 		return ksmbd_smb2_check_message(work);
@@ -244,11 +244,11 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 {
 	__le32 proto;
 
-	proto = ((struct smb2_hdr *)buf)->ProtocolId;
+	proto = ((struct smb2_hdr *)smb2_get_msg(buf))->ProtocolId;
 	if (proto == SMB2_PROTO_NUMBER) {
 		struct smb2_negotiate_req *req;
 
-		req = (struct smb2_negotiate_req *)buf;
+		req = (struct smb2_negotiate_req *)smb2_get_msg(buf);
 		return ksmbd_lookup_dialect_by_id(req->Dialects,
 						  req->DialectCount);
 	}
@@ -437,11 +437,12 @@ int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
 	struct ksmbd_conn *conn = work->conn;
 	int ret;
 
-	conn->dialect = ksmbd_negotiate_smb_dialect(work->request_buf);
+	conn->dialect =
+		ksmbd_negotiate_smb_dialect(work->request_buf);
 	ksmbd_debug(SMB, "conn->dialect 0x%x\n", conn->dialect);
 
 	if (command == SMB2_NEGOTIATE_HE) {
-		struct smb2_hdr *smb2_hdr = work->request_buf;
+		struct smb2_hdr *smb2_hdr = smb2_get_msg(work->request_buf);
 
 		if (smb2_hdr->ProtocolId != SMB2_PROTO_NUMBER) {
 			ksmbd_debug(SMB, "Downgrade to SMB1 negotiation\n");
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 57c667c1be06..b66f28f28b0a 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -482,12 +482,6 @@ struct smb_version_cmds {
 	int (*proc)(struct ksmbd_work *swork);
 };
 
-static inline size_t
-smb2_hdr_size_no_buflen(struct smb_version_values *vals)
-{
-	return vals->header_size - 4;
-}
-
 int ksmbd_min_protocol(void);
 int ksmbd_max_protocol(void);
 
-- 
2.25.1

