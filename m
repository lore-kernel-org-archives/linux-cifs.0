Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB9EC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jan 2022 11:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiAKL5R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 06:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiAKL5P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 06:57:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56471C06173F
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 03:57:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso4769325pjo.5
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 03:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dJTVSiIxMSCh2H37cD5BoqzHRdri2AetxhTVIAEl54c=;
        b=AvyL7JI0Fgb5/q/WfHdJXXn5c7ANZ7sUNwYWd98RRttdv7lz2cMg75wIImHqGzL6xX
         xzq5yXWjMNSBybGiCw6PDk9vXGB6XD+kVFKsU1Zrtv9R7bzRIAn9IpOr5DqjOSK6P0wh
         WNJJILe8JfJsAyKSFK3neLJz8bZtUuhVr5Ej39jfrBbzinaoJ8yGj3ayfi1obA6t1RvM
         lK00oc0AIa6am9+0WQTj4Evi9oEvytyzhH5N0DzqVXR9e3ueYrguAHr25fNoDD4kpGzd
         W1lLJjZkHS82P4DMzgkLTQ3WQEaHacYpRnMkIhxfxcOsZ8ixUoEPmcA1WGN62mC1Fcxl
         xhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dJTVSiIxMSCh2H37cD5BoqzHRdri2AetxhTVIAEl54c=;
        b=4I8CEJEQ5kJoc1S/b4l9eWHcec+NGXzspl0bKcruY/zJ1SOMKxL+yPhJeEgfjyoPDj
         r9IJgQF//AINU0lHa4tTJGPSGE3jdqF8vdC4yrWHTufSOV1gVe70xoKLl61cC/iJDI+g
         ZgqhmvkexaLIavEWNWyI3CxLLKZKmccyP5jC3KQTfHIClOU+LYVVmoxEqPRkpp9Tt1zI
         aQJ5GX2gAIyw/Q+U50pbj7ygXtqRi2eqtvyAvMbqt+KGKzz8PO8b4e+Dh6mMRNydtYyY
         VfPfY7MxvZSsxV31YBUNX2L+kgK7Ba6peTP/wWxDg+Jn3xig2iGjkPSQJjfKNCIHTGi2
         yefg==
X-Gm-Message-State: AOAM532kbZE8BC5ImOf7na5alDbVGtBs6x/8LN1jZEKPOHLaQdd8iXDL
        QB3Xqv9PQrm4Y6XuRJ6LsW3aTqQoQoc=
X-Google-Smtp-Source: ABdhPJxWN93/c5u9aBCe4/RoJJEr1TWKQpXhpUMij8kwCBT7XmGSaJd5mqsqcuYmsXYKiuhGpvG++w==
X-Received: by 2002:a63:4d0d:: with SMTP id a13mr3642025pgb.411.1641902234597;
        Tue, 11 Jan 2022 03:57:14 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id ls6sm2797815pjb.33.2022.01.11.03.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 03:57:14 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: smbd: fix missing client's memory region invalidation
Date:   Tue, 11 Jan 2022 20:57:03 +0900
Message-Id: <20220111115703.893347-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

if the Channel of a SMB2 WRITE request is
SMB2_CHANNEL_RDMA_V1_INVALIDTE, a client
does not invalidate its memory regions but
ksmbd must do it by sending a SMB2 WRITE response
with IB_WR_SEND_WITH_INV.

But if errors occur while processing a SMB2
READ/WRITE request, ksmbd sends a response
with IB_WR_SEND. So a client could use memory
regions already in use.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v1:
 - factor out setting a remote key to a helper functions.

 fs/ksmbd/smb2pdu.c | 58 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ced8f949a4d6..b87969576642 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6124,13 +6124,11 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	return err;
 }
 
-static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
-				      struct smb2_read_req *req, void *data_buf,
-				      size_t length)
+static int smb2_set_remote_key_for_rdma_read(struct ksmbd_work *work,
+					     struct smb2_read_req *req)
 {
 	struct smb2_buffer_desc_v1 *desc =
 		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
-	int err;
 
 	if (work->conn->dialect == SMB30_PROT_ID &&
 	    req->Channel != SMB2_CHANNEL_RDMA_V1)
@@ -6143,6 +6141,16 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 	work->need_invalidate_rkey =
 		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
 	work->remote_key = le32_to_cpu(desc->token);
+	return 0;
+}
+
+static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
+				      struct smb2_read_req *req, void *data_buf,
+				      size_t length)
+{
+	struct smb2_buffer_desc_v1 *desc =
+		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
+	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
 				    le32_to_cpu(desc->token),
@@ -6179,6 +6187,13 @@ int smb2_read(struct ksmbd_work *work)
 		return smb2_read_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		err = smb2_set_remote_key_for_rdma_read(work, req);
+		if (err)
+			goto out;
+	}
+
 	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
 				  le64_to_cpu(req->PersistentFileId));
 	if (!fp) {
@@ -6352,17 +6367,11 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	return err;
 }
 
-static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
-				       struct smb2_write_req *req,
-				       struct ksmbd_file *fp,
-				       loff_t offset, size_t length, bool sync)
+static int smb2_set_remote_key_for_rdma_write(struct ksmbd_work *work,
+					      struct smb2_write_req *req)
 {
-	struct smb2_buffer_desc_v1 *desc;
-	char *data_buf;
-	int ret;
-	ssize_t nbytes;
-
-	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
+	struct smb2_buffer_desc_v1 *desc =
+		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 
 	if (work->conn->dialect == SMB30_PROT_ID &&
 	    req->Channel != SMB2_CHANNEL_RDMA_V1)
@@ -6378,6 +6387,20 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 	work->need_invalidate_rkey =
 		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
 	work->remote_key = le32_to_cpu(desc->token);
+	return 0;
+}
+
+static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
+				       struct smb2_write_req *req,
+				       struct ksmbd_file *fp,
+				       loff_t offset, size_t length, bool sync)
+{
+	struct smb2_buffer_desc_v1 *desc;
+	char *data_buf;
+	int ret;
+	ssize_t nbytes;
+
+	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 
 	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!data_buf)
@@ -6425,6 +6448,13 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		err = smb2_set_remote_key_for_rdma_write(work, req);
+		if (err)
+			goto out;
+	}
+
 	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		ksmbd_debug(SMB, "User does not have write permission\n");
 		err = -EACCES;
-- 
2.25.1

