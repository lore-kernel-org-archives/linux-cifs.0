Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C76C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0560360FDC
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhIZOOC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 10:14:02 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:47032 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbhIZOOB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Sep 2021 10:14:01 -0400
Received: by mail-pj1-f45.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so11242720pjb.5
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 07:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v5IMxYKkTZ+4sj+T4/cgsisZnOvr+2l4QCJk9Hex2kI=;
        b=WprHTwmoZyezNazrQ886nWhvCBJB0Srt8Bj0Yy4FkWx7VMtzN2pNkB24dP2O2Ky2jP
         nwhf6/ZhEFbMwEwkXvUdcev7cTG/avSOynzyGGeum+EqhRDrCpi9x+2Role8DWYiVMPd
         tV6na8DwQpOOW51eYl2GDWvZTyKuRsLoj6mGeQ8TSxi7yY3rMnxEoCNfVwubQISQz5RO
         PWP3zqKpoLgem0DowshXhSJDhVjFodKSJ1a+AsNa+pIPar2eozmBZydNK/gAd4crBqoN
         C2nfUv6tClSc59KRUV7MP9AYHxJQQrvNcPTpPOqmQssQ7+Kp4BrpuZF4fSbR4Cv/Cg3i
         PsZg==
X-Gm-Message-State: AOAM531cS4rqJ2BObVkceZhvPehWb3kS9Bu69y0ARUlsumJ/k+APVE2D
        5H5/QRC1xia9P8TywDYSRAFMUfA4XraBRA==
X-Google-Smtp-Source: ABdhPJweqdqUztYrjzV8B8r9JKLjiMW5dc0ht7dJgTmM8CCXXQX9OAdXdd18OMkOFHh3bHbKUrcfjw==
X-Received: by 2002:a17:90b:4c86:: with SMTP id my6mr14068754pjb.176.1632665544602;
        Sun, 26 Sep 2021 07:12:24 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g3sm16521742pgf.1.2021.09.26.07.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 07:12:24 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3 2/5] ksmbd: add validation in smb2_ioctl
Date:   Sun, 26 Sep 2021 22:55:40 +0900
Message-Id: <20210926135543.119127-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
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
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 104 ++++++++++++++++++++++++++++++++++-----------
 fs/ksmbd/vfs.c     |   2 +-
 fs/ksmbd/vfs.h     |   2 +-
 3 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ad6533cfc190..068f0f3827f9 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6918,24 +6918,26 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -6945,12 +6947,13 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
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
@@ -6971,9 +6974,7 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
 	src_fp = ksmbd_lookup_foreign_fd(work,
 					 le64_to_cpu(ci_req->ResumeKey[0]));
-	dst_fp = ksmbd_lookup_fd_slow(work,
-				      le64_to_cpu(req->VolatileFileId),
-				      le64_to_cpu(req->PersistentFileId));
+	dst_fp = ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
 	ret = -EINVAL;
 	if (!src_fp ||
 	    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
@@ -7048,11 +7049,11 @@ static __be32 idev_ipv4_address(struct in_device *idev)
 }
 
 static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
-					struct smb2_ioctl_req *req,
-					struct smb2_ioctl_rsp *rsp)
+					struct smb2_ioctl_rsp *rsp,
+					unsigned int out_buf_len)
 {
 	struct network_interface_info_ioctl_rsp *nii_rsp = NULL;
-	int nbytes = 0;
+	unsigned int nbytes = 0;
 	struct net_device *netdev;
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
@@ -7061,6 +7062,10 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
+		if (out_buf_len <
+		    nbytes + sizeof(struct network_interface_info_ioctl_rsp))
+			break;
+
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
 
@@ -7132,6 +7137,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			sockaddr_storage->addr6.ScopeId = 0;
 		}
 
+		if (out_buf_len - nbytes < sizeof(struct network_interface_info_ioctl_rsp))
+			break;
 		nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 	}
 	rtnl_unlock();
@@ -7152,11 +7159,16 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 					 struct validate_negotiate_info_req *neg_req,
-					 struct validate_negotiate_info_rsp *neg_rsp)
+					 struct validate_negotiate_info_rsp *neg_rsp,
+					 unsigned int in_buf_len)
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
@@ -7190,7 +7202,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 					struct file_allocated_range_buffer *qar_req,
 					struct file_allocated_range_buffer *qar_rsp,
-					int in_count, int *out_count)
+					unsigned int in_count, unsigned int *out_count)
 {
 	struct ksmbd_file *fp;
 	loff_t start, length;
@@ -7217,7 +7229,8 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 }
 
 static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
-				 int out_buf_len, struct smb2_ioctl_req *req,
+				 unsigned int out_buf_len,
+				 struct smb2_ioctl_req *req,
 				 struct smb2_ioctl_rsp *rsp)
 {
 	struct ksmbd_rpc_command *rpc_resp;
@@ -7331,8 +7344,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 {
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp, *rsp_org;
-	int cnt_code, nbytes = 0;
-	int out_buf_len;
+	unsigned int cnt_code, nbytes = 0, out_buf_len, in_buf_len;
 	u64 id = KSMBD_NO_FID;
 	struct ksmbd_conn *conn = work->conn;
 	int ret = 0;
@@ -7361,7 +7373,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 	cnt_code = le32_to_cpu(req->CntCode);
 	out_buf_len = le32_to_cpu(req->MaxOutputResponse);
-	out_buf_len = min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
+	out_buf_len =
+		min_t(u32, MAX_STREAM_PROT_LEN - offsetof(struct smb2_ioctl_rsp, Buffer) - 4,
+		      out_buf_len);
+	in_buf_len = le32_to_cpu(req->InputCount);
 
 	switch (cnt_code) {
 	case FSCTL_DFS_GET_REFERRALS:
@@ -7389,6 +7404,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		break;
 	}
 	case FSCTL_PIPE_TRANSCEIVE:
+		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
 		nbytes = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
 		break;
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
@@ -7397,9 +7413,16 @@ int smb2_ioctl(struct ksmbd_work *work)
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
 
@@ -7408,7 +7431,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
 		break;
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
-		nbytes = fsctl_query_iface_info_ioctl(conn, req, rsp);
+		nbytes = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
 		if (nbytes < 0)
 			goto out;
 		break;
@@ -7435,15 +7458,33 @@ int smb2_ioctl(struct ksmbd_work *work)
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
@@ -7462,6 +7503,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
+		if (in_buf_len < sizeof(struct file_zero_data_information)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
@@ -7481,6 +7527,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
@@ -7521,6 +7572,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		struct duplicate_extents_to_file *dup_ext;
 		loff_t src_off, dst_off, length, cloned;
 
+		if (in_buf_len < sizeof(struct duplicate_extents_to_file)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		dup_ext = (struct duplicate_extents_to_file *)&req->Buffer[0];
 
 		fp_in = ksmbd_lookup_fd_slow(work, dup_ext->VolatileFileHandle,
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index b41954294d38..835b384b0895 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1023,7 +1023,7 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 			 struct file_allocated_range_buffer *ranges,
-			 int in_count, int *out_count)
+			 unsigned int in_count, unsigned int *out_count)
 {
 	struct file *f = fp->filp;
 	struct inode *inode = file_inode(fp->filp);
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index 7b1dcaa3fbdc..b0d5b8feb4a3 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -166,7 +166,7 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 struct file_allocated_range_buffer;
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 			 struct file_allocated_range_buffer *ranges,
-			 int in_count, int *out_count);
+			 unsigned int in_count, unsigned int *out_count);
 int ksmbd_vfs_unlink(struct user_namespace *user_ns,
 		     struct dentry *dir, struct dentry *dentry);
 void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat);
-- 
2.25.1

