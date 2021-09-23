Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9C8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEAA61214
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242780AbhIWTKb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 15:10:31 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:37457 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240205AbhIWTKb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 15:10:31 -0400
Received: by mail-pj1-f44.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so7643021pjb.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 12:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=22xe0Hvv606edlLkC1cXFcqiZFK2bnXDDBgGgcbeUYE=;
        b=3AxPSawRKzmMBjen+INIlEkcmwF7qZtzwmgMlWKbhSmC8cfMyQAvpCH8yh1PSSKUH7
         LA88pda63ShRDYaxOMkvDD5UDg/D3KSOtyHJFjO7iyFDrkIuCJLqqPSOB85YwqcGvC3X
         kqlj3IEc39YhKGfFnEp2QTmFEdKjDGZms71mMkdsz7FJ9lOvvQNc81BeRp4Z5K4iFH7J
         CqEIIakMbLKnQEoUFNFCKQF7d4wXOyvWMd8JdAvz7XvslSFL8dkGsPXPRQiI3qxAvJjy
         CgsbOxvdJpWbkHs7s/NosqlMOayCDoMKClIO1aVXypVJNSbfjZ4tLrrFw/9y06XNoVcw
         l+Ig==
X-Gm-Message-State: AOAM533SArE25hj0vRHzFFhRvP9gIqQUlxgGlPWVbyrrKcBXFEQ7CCGp
        JlNPng4K6yA2KSUO+FTRQ+1CXfLqaTvQlw==
X-Google-Smtp-Source: ABdhPJwc7WUdNu43Xtq91OFMnE9FTndYZy0xyup+v4Xt5dehvu+9yb/SOtevDft78SwtvOdSK5vAXQ==
X-Received: by 2002:a17:90b:4d05:: with SMTP id mw5mr18772707pjb.175.1632424138853;
        Thu, 23 Sep 2021 12:08:58 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id w14sm7227363pge.40.2021.09.23.12.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 12:08:58 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [RESEND PATCH v3] ksmbd: add validation in smb2_ioctl
Date:   Fri, 24 Sep 2021 04:08:07 +0900
Message-Id: <20210923190807.5133-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add validation for request/response buffer size check in smb2_ioctl and
fsctl_copychunk() take copychunk_ioctl_req pointer and the other arguments
instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
argument of fsctl_validate_negotiate_info.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 19 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b8854962afcb..be57647454fe 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6927,24 +6927,26 @@ int smb2_lock(struct ksmbd_work *work)
 	return err;
 }
 
-static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
+static int fsctl_copychunk(struct ksmbd_work *work,
+			   struct copychunk_ioctl_req *ci_req,
+			   unsigned int cnt_code,
+			   unsigned int input_count,
+			   unsigned long long volatile_id,
+			   unsigned long long persistent_id,
 			   struct smb2_ioctl_rsp *rsp)
 {
-	struct copychunk_ioctl_req *ci_req;
 	struct copychunk_ioctl_rsp *ci_rsp;
 	struct ksmbd_file *src_fp = NULL, *dst_fp = NULL;
 	struct srv_copychunk *chunks;
 	unsigned int i, chunk_count, chunk_count_written = 0;
 	unsigned int chunk_size_written = 0;
 	loff_t total_size_written = 0;
-	int ret, cnt_code;
+	int ret = 0;
 
-	cnt_code = le32_to_cpu(req->CntCode);
-	ci_req = (struct copychunk_ioctl_req *)&req->Buffer[0];
 	ci_rsp = (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
 
-	rsp->VolatileFileId = req->VolatileFileId;
-	rsp->PersistentFileId = req->PersistentFileId;
+	rsp->VolatileFileId = cpu_to_le64(volatile_id);
+	rsp->PersistentFileId = cpu_to_le64(persistent_id);
 	ci_rsp->ChunksWritten =
 		cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
 	ci_rsp->ChunkBytesWritten =
@@ -6954,12 +6956,13 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
 	chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
 	chunk_count = le32_to_cpu(ci_req->ChunkCount);
+	if (chunk_count == 0)
+		goto out;
 	total_size_written = 0;
 
 	/* verify the SRV_COPYCHUNK_COPY packet */
 	if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
-	    le32_to_cpu(req->InputCount) <
-	     offsetof(struct copychunk_ioctl_req, Chunks) +
+	    input_count < offsetof(struct copychunk_ioctl_req, Chunks) +
 	     chunk_count * sizeof(struct srv_copychunk)) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		return -EINVAL;
@@ -6980,9 +6983,7 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
 	src_fp = ksmbd_lookup_foreign_fd(work,
 					 le64_to_cpu(ci_req->ResumeKey[0]));
-	dst_fp = ksmbd_lookup_fd_slow(work,
-				      le64_to_cpu(req->VolatileFileId),
-				      le64_to_cpu(req->PersistentFileId));
+	dst_fp = ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
 	ret = -EINVAL;
 	if (!src_fp ||
 	    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
@@ -7057,8 +7058,8 @@ static __be32 idev_ipv4_address(struct in_device *idev)
 }
 
 static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
-					struct smb2_ioctl_req *req,
-					struct smb2_ioctl_rsp *rsp)
+					struct smb2_ioctl_rsp *rsp,
+					int out_buf_len)
 {
 	struct network_interface_info_ioctl_rsp *nii_rsp = NULL;
 	int nbytes = 0;
@@ -7141,6 +7142,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			sockaddr_storage->addr6.ScopeId = 0;
 		}
 
+		if (out_buf_len < sizeof(struct network_interface_info_ioctl_rsp))
+			break;
 		nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 	}
 	rtnl_unlock();
@@ -7161,11 +7164,16 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 					 struct validate_negotiate_info_req *neg_req,
-					 struct validate_negotiate_info_rsp *neg_rsp)
+					 struct validate_negotiate_info_rsp *neg_rsp,
+					 int in_buf_len)
 {
 	int ret = 0;
 	int dialect;
 
+	if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
+			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
+		return -EINVAL;
+
 	dialect = ksmbd_lookup_dialect_by_id(neg_req->Dialects,
 					     neg_req->DialectCount);
 	if (dialect == BAD_PROT_ID || dialect != conn->dialect) {
@@ -7341,7 +7349,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp, *rsp_org;
 	int cnt_code, nbytes = 0;
-	int out_buf_len;
+	int out_buf_len, in_buf_len;
 	u64 id = KSMBD_NO_FID;
 	struct ksmbd_conn *conn = work->conn;
 	int ret = 0;
@@ -7371,6 +7379,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	cnt_code = le32_to_cpu(req->CntCode);
 	out_buf_len = le32_to_cpu(req->MaxOutputResponse);
 	out_buf_len = min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
+	in_buf_len = le32_to_cpu(req->InputCount);
 
 	switch (cnt_code) {
 	case FSCTL_DFS_GET_REFERRALS:
@@ -7406,9 +7415,16 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
+		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
+			return -EINVAL;
+
+		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
+			return -EINVAL;
+
 		ret = fsctl_validate_negotiate_info(conn,
 			(struct validate_negotiate_info_req *)&req->Buffer[0],
-			(struct validate_negotiate_info_rsp *)&rsp->Buffer[0]);
+			(struct validate_negotiate_info_rsp *)&rsp->Buffer[0],
+			in_buf_len);
 		if (ret < 0)
 			goto out;
 
@@ -7417,7 +7433,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
 		break;
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
-		nbytes = fsctl_query_iface_info_ioctl(conn, req, rsp);
+		nbytes = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
 		if (nbytes < 0)
 			goto out;
 		break;
@@ -7444,15 +7460,33 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
+		if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) {
 			ret = -EINVAL;
 			goto out;
 		}
 
 		nbytes = sizeof(struct copychunk_ioctl_rsp);
-		fsctl_copychunk(work, req, rsp);
+		rsp->VolatileFileId = req->VolatileFileId;
+		rsp->PersistentFileId = req->PersistentFileId;
+		fsctl_copychunk(work,
+				(struct copychunk_ioctl_req *)&req->Buffer[0],
+				le32_to_cpu(req->CntCode),
+				le32_to_cpu(req->InputCount),
+				le64_to_cpu(req->VolatileFileId),
+				le64_to_cpu(req->PersistentFileId),
+				rsp);
 		break;
 	case FSCTL_SET_SPARSE:
+		if (in_buf_len < sizeof(struct file_sparse)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		ret = fsctl_set_sparse(work, id,
 				       (struct file_sparse *)&req->Buffer[0]);
 		if (ret < 0)
@@ -7471,6 +7505,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
+		if (in_buf_len < sizeof(struct file_zero_data_information)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
@@ -7490,6 +7529,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		break;
 	}
 	case FSCTL_QUERY_ALLOCATED_RANGES:
+		if (in_buf_len < sizeof(struct file_allocated_range_buffer)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		ret = fsctl_query_allocated_ranges(work, id,
 			(struct file_allocated_range_buffer *)&req->Buffer[0],
 			(struct file_allocated_range_buffer *)&rsp->Buffer[0],
@@ -7530,6 +7574,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		struct duplicate_extents_to_file *dup_ext;
 		loff_t src_off, dst_off, length, cloned;
 
+		if (in_buf_len < sizeof(struct duplicate_extents_to_file)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		dup_ext = (struct duplicate_extents_to_file *)&req->Buffer[0];
 
 		fp_in = ksmbd_lookup_fd_slow(work, dup_ext->VolatileFileHandle,
-- 
2.25.1

