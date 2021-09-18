Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D54FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 09:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34ED060F51
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 09:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhIRJrE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 05:47:04 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:38824 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbhIRJrC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 05:47:02 -0400
Received: by mail-pl1-f179.google.com with SMTP id 5so7818691plo.5
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 02:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVrIvUtaupYQIbk93XYhhB9dYlSPjy0yjG8Ppphx1cQ=;
        b=g6Y/7uminGInZ/UyiWNS7gcQyl8+xPnEwfg8TesQrJJ0WCQMusE8T8TWV92VTP7prB
         uvTCr+woJWSu3yZ0Wqmhqp0pQ7FJtgPO911Qv0GyQtyjRmWCyokoSaCbnsIPFBADLDba
         ilpEFrxGGONHIJojCDSzhFga5XRD0bKcwWECHiObQ9Ckl+hIXjJGh21Rfc68o8WVfJtk
         uaZf2WzpWGf9K4+wBQKH8AM+1FjLd9JquyrpDHm24xlm+92lbLUveqJ5cgQgrP68c3k6
         os9WhfcEyRFfzsXOhagBzNcbVX+QSl65rFfhjh82wFI264VhVI7c6UplZZh/23ZmLQ3O
         u/Ew==
X-Gm-Message-State: AOAM530Smn2XYEhplq7GRfH5rovvvh0g4W53gyL1JVHfrQRsOuMXJm9w
        0s6R1K3r52C5hDSTCCi/n3h22QbpPWtYXg==
X-Google-Smtp-Source: ABdhPJxU/szMha9xfYrWM1X/zoEkAjZp4cNy/xLzt0fsfQnZjHqJmXdVhVIrNx1obOdexgXUWFHJnQ==
X-Received: by 2002:a17:902:e144:b0:13b:96ee:ad48 with SMTP id d4-20020a170902e14400b0013b96eead48mr13604652pla.26.1631958338599;
        Sat, 18 Sep 2021 02:45:38 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id l10sm8928966pgn.22.2021.09.18.02.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 02:45:38 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 2/4] ksmbd: add validation in smb2_ioctl
Date:   Sat, 18 Sep 2021 18:45:11 +0900
Message-Id: <20210918094513.89480-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210918094513.89480-1-linkinjeon@kernel.org>
References: <20210918094513.89480-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add validation for request/response buffer size check in smb2_ioctl.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 54 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7763f69e1ae8..e589e8cc389f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7038,6 +7038,8 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
 	chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
 	chunk_count = le32_to_cpu(ci_req->ChunkCount);
+	if (chunk_count == 0)
+		goto out;
 	total_size_written = 0;
 
 	/* verify the SRV_COPYCHUNK_COPY packet */
@@ -7142,7 +7144,8 @@ static __be32 idev_ipv4_address(struct in_device *idev)
 
 static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 					struct smb2_ioctl_req *req,
-					struct smb2_ioctl_rsp *rsp)
+					struct smb2_ioctl_rsp *rsp,
+					int out_buf_len)
 {
 	struct network_interface_info_ioctl_rsp *nii_rsp = NULL;
 	int nbytes = 0;
@@ -7225,6 +7228,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			sockaddr_storage->addr6.ScopeId = 0;
 		}
 
+		if (out_buf_len < sizeof(struct network_interface_info_ioctl_rsp))
+			break;
 		nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 	}
 	rtnl_unlock();
@@ -7245,11 +7250,16 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
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
@@ -7425,7 +7435,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp, *rsp_org;
 	int cnt_code, nbytes = 0;
-	int out_buf_len;
+	int out_buf_len, in_buf_len;
 	u64 id = KSMBD_NO_FID;
 	struct ksmbd_conn *conn = work->conn;
 	int ret = 0;
@@ -7455,6 +7465,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	cnt_code = le32_to_cpu(req->CntCode);
 	out_buf_len = le32_to_cpu(req->MaxOutputResponse);
 	out_buf_len = min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
+	in_buf_len = le32_to_cpu(req->InputCount);
 
 	switch (cnt_code) {
 	case FSCTL_DFS_GET_REFERRALS:
@@ -7490,9 +7501,16 @@ int smb2_ioctl(struct ksmbd_work *work)
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
 
@@ -7501,7 +7519,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
 		break;
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
-		nbytes = fsctl_query_iface_info_ioctl(conn, req, rsp);
+		nbytes = fsctl_query_iface_info_ioctl(conn, req, rsp,
+						      out_buf_len);
 		if (nbytes < 0)
 			goto out;
 		break;
@@ -7528,6 +7547,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
@@ -7537,6 +7561,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		fsctl_copychunk(work, req, rsp);
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
@@ -7555,6 +7584,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
+		if (in_buf_len < sizeof(struct file_zero_data_information)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
@@ -7574,6 +7608,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
@@ -7614,6 +7653,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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

