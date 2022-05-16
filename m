Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDEEC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 16 May 2022 07:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241179AbiEPHmP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 May 2022 03:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiEPHmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 May 2022 03:42:15 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EBD2BFE
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:14 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id q4so13646064plr.11
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WhfTXMstmadGHEd8GtgEVKg8E9scCJIYhGG0D9+u6KQ=;
        b=KMUsLlU7fagHnsp3ju6jN/IHyGOLnVzsjrnWCdqqEbfWLnuZ+kTFiO3hpQq7a252ht
         9gmw6GzcgCpSuTRz9+VR2yxL14y+UWB5fS+O5a6GS6dIwxYr4gns8aDVq6evXjAsDyw4
         8C4SyBmflwXQWBK6/bAtBBZqVx7hiwXu/7jLzQzt8M0ZqXEdwzOCwTBF8agvUq5IgVFt
         tY7yZBRnU7HIvsr1CO/Unl2hi5kD1u7yWSPWIa0lPLQ2k63CstB2Qgt4rJ3hCtTuhzIO
         GC/3PIp6rRiwVfVz2gfh00SFsqcZAg1WJoLg1afv4bisr8C6/52e8Ve76FuBdP6xGemC
         3EOg==
X-Gm-Message-State: AOAM5326SJDkxWPtCf189zUSEB6NEYdEAzjHRyyjXI6L35uTTL8NUiRv
        tSMB+QpmAFuzgl9IpmW/odCllmb3bK7pdw==
X-Google-Smtp-Source: ABdhPJyrfRgRUBpmTB/9MToU2J1qqWME8/sW7fjJyNuR5uzixJIIJGdLtiF952pyNAyglZBN9WphvQ==
X-Received: by 2002:a17:90a:3804:b0:1df:1fb1:b892 with SMTP id w4-20020a17090a380400b001df1fb1b892mr10197697pjb.104.1652686933629;
        Mon, 16 May 2022 00:42:13 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id r19-20020a170903021300b0015e8d4eb26esm6321342plh.184.2022.05.16.00.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 00:42:13 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: fix wrong smbd max read/write size check
Date:   Mon, 16 May 2022 16:41:40 +0900
Message-Id: <20220516074140.28522-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220516074140.28522-1-linkinjeon@kernel.org>
References: <20220516074140.28522-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb-direct max read/write size can be different with smb2 max read/write
size. So smb2_read() can return error by wrong max read/write size check.
This patch use smb_direct_max_read_write_size for this check in
smb-direct read/write().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c        | 39 +++++++++++++++++++++++++--------------
 fs/ksmbd/transport_rdma.c |  5 +++++
 fs/ksmbd/transport_rdma.h |  2 ++
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index eb7ca5f24a3b..937f9760f181 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6098,6 +6098,8 @@ int smb2_read(struct ksmbd_work *work)
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
+	bool is_rdma_channel = false;
+	unsigned int max_read_size = conn->vals->max_read_size;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -6109,6 +6111,11 @@ int smb2_read(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		is_rdma_channel = true;
+		max_read_size = get_smbd_max_read_write_size();
+	}
+
+	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
 
 		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
@@ -6140,9 +6147,9 @@ int smb2_read(struct ksmbd_work *work)
 	length = le32_to_cpu(req->Length);
 	mincount = le32_to_cpu(req->MinimumCount);
 
-	if (length > conn->vals->max_read_size) {
+	if (length > max_read_size) {
 		ksmbd_debug(SMB, "limiting read size to max size(%u)\n",
-			    conn->vals->max_read_size);
+			    max_read_size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -6174,8 +6181,7 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
 		    nbytes, offset, mincount);
 
-	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
-	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+	if (is_rdma_channel == true) {
 		/* write data to the client using rdma channel */
 		remain_bytes = smb2_read_rdma_channel(work, req,
 						      work->aux_payload_buf,
@@ -6336,8 +6342,9 @@ int smb2_write(struct ksmbd_work *work)
 	size_t length;
 	ssize_t nbytes;
 	char *data_buf;
-	bool writethrough = false;
+	bool writethrough = false, is_rdma_channel = false;
 	int err = 0;
+	unsigned int max_write_size = work->conn->vals->max_write_size;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -6346,8 +6353,17 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	offset = le64_to_cpu(req->Offset);
+	length = le32_to_cpu(req->Length);
+
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		is_rdma_channel = true;
+		max_write_size = get_smbd_max_read_write_size();
+		length = le32_to_cpu(req->RemainingBytes);
+	}
+
+	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
 
 		if (req->Length != 0 || req->DataOffset != 0 ||
@@ -6382,12 +6398,9 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
-	offset = le64_to_cpu(req->Offset);
-	length = le32_to_cpu(req->Length);
-
-	if (length > work->conn->vals->max_write_size) {
+	if (length > max_write_size) {
 		ksmbd_debug(SMB, "limiting write size to max size(%u)\n",
-			    work->conn->vals->max_write_size);
+			    max_write_size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -6395,8 +6408,7 @@ int smb2_write(struct ksmbd_work *work)
 	if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 		writethrough = true;
 
-	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+	if (is_rdma_channel == false) {
 		if ((u64)le16_to_cpu(req->DataOffset) + length >
 		    get_rfc1002_len(work->request_buf)) {
 			pr_err("invalid write data offset %u, smb_len %u\n",
@@ -6422,8 +6434,7 @@ int smb2_write(struct ksmbd_work *work)
 		/* read data from the client using rdma channel, and
 		 * write the data.
 		 */
-		nbytes = smb2_write_rdma_channel(work, req, fp, offset,
-						 le32_to_cpu(req->RemainingBytes),
+		nbytes = smb2_write_rdma_channel(work, req, fp, offset, length,
 						 writethrough);
 		if (nbytes < 0) {
 			err = (int)nbytes;
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 6d652ff38b82..0741fd129d16 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -220,6 +220,11 @@ void init_smbd_max_io_size(unsigned int sz)
 	smb_direct_max_read_write_size = sz;
 }
 
+unsigned int get_smbd_max_read_write_size(void)
+{
+	return smb_direct_max_read_write_size;
+}
+
 static inline int get_buf_page_count(void *buf, int size)
 {
 	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index e7b4e6790fab..77aee4e5c9dc 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -57,11 +57,13 @@ int ksmbd_rdma_init(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
+unsigned int get_smbd_max_read_write_size(void);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
+static inline unsigned int get_smbd_max_read_write_size(void) { return 0; }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
-- 
2.25.1

