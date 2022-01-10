Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78D5C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jan 2022 01:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiAJBg6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jan 2022 20:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236795AbiAJBg5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jan 2022 20:36:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0BDC06173F
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 17:36:57 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t32so9860973pgm.7
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jan 2022 17:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BrGgYV4UjtJiHMu++vLlr26TC8Rv/REkSwpd8IoFqdE=;
        b=GywJRJOvxmbk7SA1940xXmD05N53Aym2dEwN6XOedbHWslyFZhMhzJiCmvmNM0lHZf
         m98rezUqNw8SlMMrpG24dJ9RR0i0IjL8on++/M8VrwG01v0pmXsiyqHlEOwaPLw4NGTp
         5h+nlSqFBNsLUGbEiHcmr5fXJ6GRaxJ13qasEjXRTOrwZYwqK0BqvmlQptHCs/hLwBTa
         7u0Ei3vzLQvxCj8JVn3rHAoi3zLKnbXZtd50khWIRryMfgToBUuCriHmqy6mMolBnzGV
         3fZ+wzoZm56ZEmJBWvi/OK5Y6EUuOW3JFOi8gp1Toa0LW2MnS9d8Jnwzza9Imxa5DhHQ
         3Ing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BrGgYV4UjtJiHMu++vLlr26TC8Rv/REkSwpd8IoFqdE=;
        b=P/yV5dijCJinAXsvkqkzrQxe5s5CV2xuud/KLlalW39Ux8NKQ2XlFHmuMcX9wOx7Zn
         Fx8hXtN659pj4iXrfXayBdjYK1PdSy9BOapY/4aAM68Ft9cBRXYX9UzTnZnrAAaxGjFx
         0nJMLosl5HxTGB3NcwvPerMabqM3Rmp6LH7XcAlcKe593wW3A0v9Nej2qonkMuKc8fE4
         nLbIqWwlai43l16izs8so7rfyMYxEpfh3GQaDlTWoUmKHNvEpS6gfas81Q8MaKgXgGwS
         rTm9sOtaGFkb++z89/QHxOdJlprqUC9cTHx7/ldbNZnod50nQkbDeKjTPRuu8xdN5YHb
         oKew==
X-Gm-Message-State: AOAM531kbBM/cSGimX8DV7P16ep2PD/lncryoI+3tOqPWo0gCMLheop/
        yfOgcK7KTE0bRn1pdFb1yp8FmqGLXXI=
X-Google-Smtp-Source: ABdhPJy2DG86zVJfnBd11iTbFH9OPlJREGbJt9LjryYNRWbWfLvZZrYHxzXFNgRfljY0bX+Tjmiyzw==
X-Received: by 2002:a63:156:: with SMTP id 83mr52291728pgb.196.1641778616454;
        Sun, 09 Jan 2022 17:36:56 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id n10sm5822828pje.0.2022.01.09.17.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 17:36:55 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: smbd: fix missing client's memory region invalidation
Date:   Mon, 10 Jan 2022 10:36:39 +0900
Message-Id: <20220110013639.841324-1-hyc.lee@gmail.com>
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
 fs/ksmbd/smb2pdu.c | 76 ++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ced8f949a4d6..19355511b777 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6132,18 +6132,6 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 	int err;
 
-	if (work->conn->dialect == SMB30_PROT_ID &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1)
-		return -EINVAL;
-
-	if (req->ReadChannelInfoOffset == 0 ||
-	    le16_to_cpu(req->ReadChannelInfoLength) < sizeof(*desc))
-		return -EINVAL;
-
-	work->need_invalidate_rkey =
-		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
-	work->remote_key = le32_to_cpu(desc->token);
-
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
 				    le32_to_cpu(desc->token),
 				    le64_to_cpu(desc->offset),
@@ -6179,6 +6167,28 @@ int smb2_read(struct ksmbd_work *work)
 		return smb2_read_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		struct smb2_buffer_desc_v1 *desc =
+			(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
+
+		if (work->conn->dialect == SMB30_PROT_ID &&
+		    req->Channel != SMB2_CHANNEL_RDMA_V1) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (req->ReadChannelInfoOffset == 0 ||
+		    le16_to_cpu(req->ReadChannelInfoLength) < sizeof(*desc)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		work->need_invalidate_rkey =
+			(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
+		work->remote_key = le32_to_cpu(desc->token);
+	}
+
 	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
 				  le64_to_cpu(req->PersistentFileId));
 	if (!fp) {
@@ -6364,21 +6374,6 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 
 	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 
-	if (work->conn->dialect == SMB30_PROT_ID &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1)
-		return -EINVAL;
-
-	if (req->Length != 0 || req->DataOffset != 0)
-		return -EINVAL;
-
-	if (req->WriteChannelInfoOffset == 0 ||
-	    le16_to_cpu(req->WriteChannelInfoLength) < sizeof(*desc))
-		return -EINVAL;
-
-	work->need_invalidate_rkey =
-		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
-	work->remote_key = le32_to_cpu(desc->token);
-
 	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!data_buf)
 		return -ENOMEM;
@@ -6425,6 +6420,33 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		struct smb2_buffer_desc_v1 *desc =
+			(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
+
+		if (work->conn->dialect == SMB30_PROT_ID &&
+		    req->Channel != SMB2_CHANNEL_RDMA_V1) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (req->Length != 0 || req->DataOffset != 0) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (req->WriteChannelInfoOffset == 0 ||
+		    le16_to_cpu(req->WriteChannelInfoLength) < sizeof(*desc)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		work->need_invalidate_rkey =
+			(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
+		work->remote_key = le32_to_cpu(desc->token);
+	}
+
 	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		ksmbd_debug(SMB, "User does not have write permission\n");
 		err = -EACCES;
-- 
2.25.1

