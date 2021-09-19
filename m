Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B44CC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BFA661056
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhISCO6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:14:58 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40831 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhISCO5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 22:14:57 -0400
Received: by mail-pj1-f49.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso12722171pjh.5
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 19:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qFcBjOa9bbyjJ22t8jcU/CFAgMVO6yYfkWM3FxsOxvU=;
        b=Jx9KHd2+PY4ZJ3oSFOo2lmVaMNUTkUcH7H5vhg9LXY+yUioIzUFHuhOdW+RcwLrZb3
         pYVP2mDtiUiLNpwYnMyOaF1o/5e4Veszua3lVlYiteUj6LL4WACfUW0WlRMBoKDsTQPP
         rAYknz0OY5zvT/Mvwq7kfub7+8HXs0yMNCV40Hltc47vtb7gqPC+HxLyC5uNwBRHqcJA
         KS91uQQYbpB+nICoq5e6FiyQnY8IzkSqjFuH31pSrt1W0fVr6s+9k3p30076+z/z9tZR
         GNC+gIxX2LZ2kz4MZ2+hFsVCTz9o+B6VtiOgkCmaQ9FzbjMD4mrcE04Ocu0BMcCAF/wk
         io6A==
X-Gm-Message-State: AOAM533qHTdDj5kgAT+X0D80qrsUAKxFeHgS95TTVChkAL6+33E/u9tx
        SHY76gfl8tkIPaotm+XDM8q272sNdQ1DKg==
X-Google-Smtp-Source: ABdhPJyoh3jOkAoul5SPRhazr0LieTsJGq/4W6JvPyUmGEY6h/jWs15BW38CHe+evU8vpC/X2WOwlw==
X-Received: by 2002:a17:902:8307:b0:13c:ac55:5e1d with SMTP id bd7-20020a170902830700b0013cac555e1dmr11582978plb.56.1632017613195;
        Sat, 18 Sep 2021 19:13:33 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m28sm10849537pgl.9.2021.09.18.19.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 19:13:32 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH v2 2/4] ksmbd: add validation in smb2_ioctl
Date:   Sun, 19 Sep 2021 11:13:13 +0900
Message-Id: <20210919021315.642856-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
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
 v2:
   - fix warning: variable 'ret' is used uninitialized ret.

 fs/ksmbd/smb2pdu.c | 56 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7763f69e1ae8..6ea50a9ac64e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7021,7 +7021,7 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 	unsigned int i, chunk_count, chunk_count_written = 0;
 	unsigned int chunk_size_written = 0;
 	loff_t total_size_written = 0;
-	int ret, cnt_code;
+	int ret = 0, cnt_code;
 
 	cnt_code = le32_to_cpu(req->CntCode);
 	ci_req = (struct copychunk_ioctl_req *)&req->Buffer[0];
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

