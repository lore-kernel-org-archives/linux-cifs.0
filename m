Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB7FC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Apr 2022 05:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbiDRFRs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Apr 2022 01:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiDRFRq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Apr 2022 01:17:46 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A147648
        for <linux-cifs@vger.kernel.org>; Sun, 17 Apr 2022 22:15:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b7so1856489plh.2
        for <linux-cifs@vger.kernel.org>; Sun, 17 Apr 2022 22:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2rLK7KpRuVsX4HtOGaZFzB5yeE8AkNxSvgfep/43WSI=;
        b=BfETQTA7t1qEnD7NefKQk1Z2cQBwQR2tXF791ML16zCkQqiRZPPbVJbs7q1dw3yPLN
         4dZhQCLXrbUKc56i8NOE09d3zkPLPxhxSHdkcg4SKBwI18vA1d4p/YKjDLelc4X39jMu
         KCtZW2dS9Is+GBWEtDKQ3kALIx9DTYeLktcEpX1UE0uGHvLBAxOISlJ/s9BlyAmd0REe
         GM4rIRe9aWj09SzqqdvTqztnz7yts5hU6oO+6Tz/LBJzKNtKLy/M5wTiccZFkDQJpsqK
         nwLFLuk/gE+w4FN3RqDJFElhimnev2WhzfyoWjOIepf5v+ZvYtuyvhZv7QXa18AlvVgt
         8g7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2rLK7KpRuVsX4HtOGaZFzB5yeE8AkNxSvgfep/43WSI=;
        b=yPkLgQKBf5K1xOLn7UmVjdRgkVdB7ujCPO5fOg/IHnCnuCKWf+LeWNw03YvubnAbvT
         pK6O5ZaemmQ3MK6i1+/0m4+X82KEd35oltoijfTYxQZcz1AGfh6E3/aXJuG8Jl7P4xdq
         laZPUbj22QpxhNv2+dl/jOjVq5JWk1DiEWKG9NMsu3g23MrAGRv1UKRt79+vxO+/BKBJ
         lAJfnLEPcdtT4XIevzXAh2mZ0J/DYqjvjkVSj7nETnlTZwF8l43TbTOF4IhLzNR0dick
         6b1Eu4lOXxEu2zxTePxxK6YheRXZTG8Aq8MbqzqSkzVknglgWzldMqp1RYeskjVSVgOU
         fWSQ==
X-Gm-Message-State: AOAM531gQ+F5V82J8vM05ADlAlaMGeLaPKi05z7ANF1PIj5iphLbvRkx
        gXYDfGgqQugwlaPs5/2o/d1lm5WBLKc=
X-Google-Smtp-Source: ABdhPJxmF3qo15ujE7Yniq0YUSXjiHpHp7n39wbJMXbLvWH3UVrgEwf4yDm93Qfs//4l0EQe6k1leg==
X-Received: by 2002:a17:90b:224f:b0:1cf:156d:f8ae with SMTP id hk15-20020a17090b224f00b001cf156df8aemr16673868pjb.173.1650258907027;
        Sun, 17 Apr 2022 22:15:07 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm11453028pge.23.2022.04.17.22.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 22:15:06 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3 1/4] ksmbd: smbd: change prototypes of RDMA read/write related functions
Date:   Mon, 18 Apr 2022 14:14:09 +0900
Message-Id: <20220418051412.13193-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change the prototypes of RDMA read/write
operations to accept a pointer and length
of buffer descriptors.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v1:
 - Use le16_to_cpu() instead of le32_to_cpu() to retrieve
   req->ReadChannelInfoOffset(reported by kernel test bot)
changes from v2:
 - Split a v2 patch to 4 patches.
 - Change function name from smb2_validate_rdma_buffer_descs
   to smb2_set_remote_key_for_rdma.
 - Change the if condition in smb2_set_remote_key_for_rdma()
   from "ch_count < 1" to "!ch_count".

 fs/ksmbd/connection.c     | 20 ++++++++++----------
 fs/ksmbd/connection.h     | 27 ++++++++++++++++-----------
 fs/ksmbd/smb2pdu.c        | 23 ++++++++---------------
 fs/ksmbd/transport_rdma.c | 30 +++++++++++++++++-------------
 4 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 208d2cff7bd3..7db87771884a 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -205,31 +205,31 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	return 0;
 }
 
-int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
-			 unsigned int buflen, u32 remote_key, u64 remote_offset,
-			 u32 remote_len)
+int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
+			 void *buf, unsigned int buflen,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len)
 {
 	int ret = -EINVAL;
 
 	if (conn->transport->ops->rdma_read)
 		ret = conn->transport->ops->rdma_read(conn->transport,
 						      buf, buflen,
-						      remote_key, remote_offset,
-						      remote_len);
+						      desc, desc_len);
 	return ret;
 }
 
-int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
-			  unsigned int buflen, u32 remote_key,
-			  u64 remote_offset, u32 remote_len)
+int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
+			  void *buf, unsigned int buflen,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len)
 {
 	int ret = -EINVAL;
 
 	if (conn->transport->ops->rdma_write)
 		ret = conn->transport->ops->rdma_write(conn->transport,
 						       buf, buflen,
-						       remote_key, remote_offset,
-						       remote_len);
+						       desc, desc_len);
 	return ret;
 }
 
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 7a59aacb5daa..98c1cbe45ec9 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -122,11 +122,14 @@ struct ksmbd_transport_ops {
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
-	int (*rdma_read)(struct ksmbd_transport *t, void *buf, unsigned int len,
-			 u32 remote_key, u64 remote_offset, u32 remote_len);
-	int (*rdma_write)(struct ksmbd_transport *t, void *buf,
-			  unsigned int len, u32 remote_key, u64 remote_offset,
-			  u32 remote_len);
+	int (*rdma_read)(struct ksmbd_transport *t,
+			 void *buf, unsigned int len,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len);
+	int (*rdma_write)(struct ksmbd_transport *t,
+			  void *buf, unsigned int len,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len);
 };
 
 struct ksmbd_transport {
@@ -148,12 +151,14 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
-int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
-			 unsigned int buflen, u32 remote_key, u64 remote_offset,
-			 u32 remote_len);
-int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
-			  unsigned int buflen, u32 remote_key, u64 remote_offset,
-			  u32 remote_len);
+int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
+			 void *buf, unsigned int buflen,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len);
+int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
+			  void *buf, unsigned int buflen,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len);
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
 int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
 void ksmbd_conn_init_server_callbacks(struct ksmbd_conn_ops *ops);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 16c803a9d996..fc9b8def50df 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6116,7 +6116,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 					struct smb2_buffer_desc_v1 *desc,
 					__le32 Channel,
-					__le16 ChannelInfoOffset,
 					__le16 ChannelInfoLength)
 {
 	unsigned int i, ch_count;
@@ -6142,7 +6141,8 @@ static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
-	work->remote_key = le32_to_cpu(desc->token);
+	if (Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE)
+		work->remote_key = le32_to_cpu(desc->token);
 	return 0;
 }
 
@@ -6150,14 +6150,12 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 				      struct smb2_read_req *req, void *data_buf,
 				      size_t length)
 {
-	struct smb2_buffer_desc_v1 *desc =
-		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
-				    le32_to_cpu(desc->token),
-				    le64_to_cpu(desc->offset),
-				    le32_to_cpu(desc->length));
+				    (struct smb2_buffer_desc_v1 *)
+				    ((char *)req + le16_to_cpu(req->ReadChannelInfoOffset)),
+				    le16_to_cpu(req->ReadChannelInfoLength));
 	if (err)
 		return err;
 
@@ -6201,7 +6199,6 @@ int smb2_read(struct ksmbd_work *work)
 						   (struct smb2_buffer_desc_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
-						   req->ReadChannelInfoOffset,
 						   req->ReadChannelInfoLength);
 		if (err)
 			goto out;
@@ -6384,21 +6381,18 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 				       struct ksmbd_file *fp,
 				       loff_t offset, size_t length, bool sync)
 {
-	struct smb2_buffer_desc_v1 *desc;
 	char *data_buf;
 	int ret;
 	ssize_t nbytes;
 
-	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
-
 	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!data_buf)
 		return -ENOMEM;
 
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   le32_to_cpu(desc->token),
-				   le64_to_cpu(desc->offset),
-				   le32_to_cpu(desc->length));
+				   (struct smb2_buffer_desc_v1 *)
+				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
+				   le16_to_cpu(req->WriteChannelInfoLength));
 	if (ret < 0) {
 		kvfree(data_buf);
 		return ret;
@@ -6450,7 +6444,6 @@ int smb2_write(struct ksmbd_work *work)
 						   (struct smb2_buffer_desc_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
-						   req->WriteChannelInfoOffset,
 						   req->WriteChannelInfoLength);
 		if (err)
 			goto out;
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index e646d79554b8..5e34625b5faf 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1351,14 +1351,18 @@ static void write_done(struct ib_cq *cq, struct ib_wc *wc)
 	read_write_done(cq, wc, DMA_TO_DEVICE);
 }
 
-static int smb_direct_rdma_xmit(struct smb_direct_transport *t, void *buf,
-				int buf_len, u32 remote_key, u64 remote_offset,
-				u32 remote_len, bool is_read)
+static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
+				void *buf, int buf_len,
+				struct smb2_buffer_desc_v1 *desc,
+				unsigned int desc_len,
+				bool is_read)
 {
 	struct smb_direct_rdma_rw_msg *msg;
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct ib_send_wr *first_wr = NULL;
+	u32 remote_key = le32_to_cpu(desc[0].token);
+	u64 remote_offset = le64_to_cpu(desc[0].offset);
 
 	ret = wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_ops);
 	if (ret < 0)
@@ -1423,22 +1427,22 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t, void *buf,
 	return ret;
 }
 
-static int smb_direct_rdma_write(struct ksmbd_transport *t, void *buf,
-				 unsigned int buflen, u32 remote_key,
-				 u64 remote_offset, u32 remote_len)
+static int smb_direct_rdma_write(struct ksmbd_transport *t,
+				 void *buf, unsigned int buflen,
+				 struct smb2_buffer_desc_v1 *desc,
+				 unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-				    remote_key, remote_offset,
-				    remote_len, false);
+				    desc, desc_len, false);
 }
 
-static int smb_direct_rdma_read(struct ksmbd_transport *t, void *buf,
-				unsigned int buflen, u32 remote_key,
-				u64 remote_offset, u32 remote_len)
+static int smb_direct_rdma_read(struct ksmbd_transport *t,
+				void *buf, unsigned int buflen,
+				struct smb2_buffer_desc_v1 *desc,
+				unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-				    remote_key, remote_offset,
-				    remote_len, true);
+				    desc, desc_len, true);
 }
 
 static void smb_direct_disconnect(struct ksmbd_transport *t)
-- 
2.25.1

