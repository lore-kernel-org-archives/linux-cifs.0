Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3382C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 22:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E62C6101B
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 22:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241283AbhJGWda (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 18:33:30 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:44008 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237282AbhJGWd3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 18:33:29 -0400
Received: by mail-pg1-f176.google.com with SMTP id r2so1190254pgl.10
        for <linux-cifs@vger.kernel.org>; Thu, 07 Oct 2021 15:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HUmQ6ruOTOTcbrL6zJqDEI4QHKuVeOz2icX9VBKNxI4=;
        b=R4glQkAqw4ImmiI62r9HAOQn2IJ/L23oi/DoUltQQIxqLcYyIvCkavoaDv8e1SpZDY
         3/xZHJnOOY/U7YnikLa+xCYnxVXUUauk7ib4gqabpmbE+9T/G3Uevz+Q1dwidz0vHYOy
         35sV6A5tyVS/PXuwrEDXf0n/EedwGUTkhoWStAkHpjafEwyjv5HNl3FuzdTM3rf7BL3o
         fr8KJX2lr1sfD99No1j5253RXRj+D2ugXWc+ULGSVcBFHePMYZZdj+hrX94E2WfhDkpB
         8PlKWAJEh+do6zhifYOwYkpl+7KJojEDqJDt8qmrWUpzpo1Z3qWIcRV4nv3JSAZGJW9N
         fP6A==
X-Gm-Message-State: AOAM531v4qnCvrvOHyBXUtqjdFThI5NeDIjOPD3RlYaCKTbqcVlaow00
        cFFg1MW0fwOlxNUsWcvUVPYEQK8v/EXSRQ==
X-Google-Smtp-Source: ABdhPJyGbE/zKtUP0bDIRQ93YX3vgXMWyza+KrZj9JMfsMCZzmQZtPDNtvAxOPqD3WHmp+7UayIaQQ==
X-Received: by 2002:a62:2587:0:b0:44b:2d81:8520 with SMTP id l129-20020a622587000000b0044b2d818520mr6747536pfl.43.1633645895124;
        Thu, 07 Oct 2021 15:31:35 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x11sm419167pfh.75.2021.10.07.15.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:31:34 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v5] ksmbd: add validation in smb2_ioctl
Date:   Fri,  8 Oct 2021 07:31:03 +0900
Message-Id: <20211007223103.5340-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007223103.5340-1-linkinjeon@kernel.org>
References: <20211007223103.5340-1-linkinjeon@kernel.org>
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
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - fix warning: variable 'ret' is used uninitialized ret.
 v3:
   - fsctl_copychunk() take copychunk_ioctl_req pointer and the other arguments
     instead of smb2_ioctl_req structure.
   - remove an unused smb2_ioctl_req argument of fsctl_validate_negotiate_info.
 v4:
   - use work->response_sz for out_buf_len calculation in smb2_ioctl.
 v5:
   - combine the patch fixed by Colin and reported by Coverity scan.
   - remove duplicated out_buf_len check in
     fsctl_query_iface_info_ioctl().
   - return status too small error if out_buf_len is insufficient.
   - Fix an issue with overwriting error status in changes from Colin. 

 fs/ksmbd/smb2pdu.c | 113 +++++++++++++++++++++++++++++++++------------
 fs/ksmbd/vfs.c     |   2 +-
 fs/ksmbd/vfs.h     |   2 +-
 3 files changed, 86 insertions(+), 31 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 005aa93a49d6..1c7b837c8106 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7023,24 +7023,26 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -7050,12 +7052,13 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
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
@@ -7076,9 +7079,7 @@ static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
 
 	src_fp = ksmbd_lookup_foreign_fd(work,
 					 le64_to_cpu(ci_req->ResumeKey[0]));
-	dst_fp = ksmbd_lookup_fd_slow(work,
-				      le64_to_cpu(req->VolatileFileId),
-				      le64_to_cpu(req->PersistentFileId));
+	dst_fp = ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
 	ret = -EINVAL;
 	if (!src_fp ||
 	    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
@@ -7153,8 +7154,8 @@ static __be32 idev_ipv4_address(struct in_device *idev)
 }
 
 static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
-					struct smb2_ioctl_req *req,
-					struct smb2_ioctl_rsp *rsp)
+					struct smb2_ioctl_rsp *rsp,
+					unsigned int out_buf_len)
 {
 	struct network_interface_info_ioctl_rsp *nii_rsp = NULL;
 	int nbytes = 0;
@@ -7166,6 +7167,12 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
+		if (out_buf_len <
+		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+			rtnl_unlock();
+			return -ENOSPC;
+		}
+
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
 
@@ -7245,11 +7252,6 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	if (nii_rsp)
 		nii_rsp->Next = 0;
 
-	if (!nbytes) {
-		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
-		return -EINVAL;
-	}
-
 	rsp->PersistentFileId = cpu_to_le64(SMB2_NO_FID);
 	rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
 	return nbytes;
@@ -7257,11 +7259,16 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
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
@@ -7295,7 +7302,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 					struct file_allocated_range_buffer *qar_req,
 					struct file_allocated_range_buffer *qar_rsp,
-					int in_count, int *out_count)
+					unsigned int in_count, unsigned int *out_count)
 {
 	struct ksmbd_file *fp;
 	loff_t start, length;
@@ -7322,7 +7329,8 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 }
 
 static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
-				 int out_buf_len, struct smb2_ioctl_req *req,
+				 unsigned int out_buf_len,
+				 struct smb2_ioctl_req *req,
 				 struct smb2_ioctl_rsp *rsp)
 {
 	struct ksmbd_rpc_command *rpc_resp;
@@ -7436,8 +7444,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 {
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp, *rsp_org;
-	int cnt_code, nbytes = 0;
-	int out_buf_len;
+	unsigned int cnt_code, nbytes = 0, out_buf_len, in_buf_len;
 	u64 id = KSMBD_NO_FID;
 	struct ksmbd_conn *conn = work->conn;
 	int ret = 0;
@@ -7466,7 +7473,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 	cnt_code = le32_to_cpu(req->CntCode);
 	out_buf_len = le32_to_cpu(req->MaxOutputResponse);
-	out_buf_len = min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
+	out_buf_len =
+		min_t(u32, work->response_sz - work->next_smb2_rsp_hdr_off -
+				(offsetof(struct smb2_ioctl_rsp, Buffer) - 4),
+		      out_buf_len);
+	in_buf_len = le32_to_cpu(req->InputCount);
 
 	switch (cnt_code) {
 	case FSCTL_DFS_GET_REFERRALS:
@@ -7494,6 +7505,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		break;
 	}
 	case FSCTL_PIPE_TRANSCEIVE:
+		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
 		nbytes = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
 		break;
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
@@ -7502,9 +7514,16 @@ int smb2_ioctl(struct ksmbd_work *work)
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
 
@@ -7513,9 +7532,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
 		break;
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
-		nbytes = fsctl_query_iface_info_ioctl(conn, req, rsp);
-		if (nbytes < 0)
+		ret = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
+		if (ret < 0)
 			goto out;
+		nbytes = ret;
 		break;
 	case FSCTL_REQUEST_RESUME_KEY:
 		if (out_buf_len < sizeof(struct resume_key_ioctl_rsp)) {
@@ -7540,15 +7560,33 @@ int smb2_ioctl(struct ksmbd_work *work)
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
@@ -7567,6 +7605,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
+		if (in_buf_len < sizeof(struct file_zero_data_information)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
@@ -7586,6 +7629,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
@@ -7626,6 +7674,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		struct duplicate_extents_to_file *dup_ext;
 		loff_t src_off, dst_off, length, cloned;
 
+		if (in_buf_len < sizeof(struct duplicate_extents_to_file)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		dup_ext = (struct duplicate_extents_to_file *)&req->Buffer[0];
 
 		fp_in = ksmbd_lookup_fd_slow(work, dup_ext->VolatileFileHandle,
@@ -7696,6 +7749,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
 	else if (ret == -EOPNOTSUPP)
 		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+	else if (ret == -ENOSPC)
+		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
 	else if (ret < 0 || rsp->hdr.Status == 0)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 	smb2_set_err_rsp(work);
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

