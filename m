Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F46AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jan 2022 00:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiAMAwN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiAMAwK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jan 2022 19:52:10 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA40C06173F
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 16:52:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso15847262pjo.5
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 16:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GM+Cli/GCCmwNv8gy4gcEIxwQxKx9zeCTJt/eB5NJ14=;
        b=V9U4lDbqGajWNMfzUePbilgtnwYWFAi7Z0gtJ49IC61bp2D44lSBqrX7kPMGWpJSXH
         q04/a/3rdAQkPuB98G8mgNNclVQF9/CvpQCgEZvyu3n0X+MJd6lNLyiy382Ck68y6NQG
         TsmcM1h8/nCyg41+7M9aqIyfhDO0JUVQ/DHDpWieCdM15idJWv4QSXo4Igy1gma/KwBB
         fqZfDG2SrrliOTjWKlK+k3MBJIrTZXZMf0OkpQG0YGYcIx5rZ4kPmcwmSXI9HkpM9pil
         wXf08PWYz5PKDS1hQFs8PK8uoyo+qpp6eGVGagemgo/CSwzcSa49b5N3qyibfpb2IhFE
         Bt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GM+Cli/GCCmwNv8gy4gcEIxwQxKx9zeCTJt/eB5NJ14=;
        b=0ru+IF4W7u/w7POgC+cWZocdvmnHEc65DTJejwtlwb0BNqooN+76XKtBB6adNbTBac
         WKzOPjE0vbp50y9ARKIivndnng3ptjtC1oC2HcYZ5JB64M7KFGZcsurdKHXbWQC9nC4a
         Hs1fnJMwgh13nBYuY9ayWaeq+RkHzsB7GPt133dCNW51H0MRmPxrxSVu8PwCjM0FLben
         CU8ZrnISqmtI8BR4WLuOJ7A4jYRj4m8cEOfXP+Am10bGOHcE6TLPUeKKg4yiZZBpE/LO
         52zxqOLsCR8faBajyX9jfQtuA/8PstyH9WA+BjiL0Tv7Lw36x+4pusGHFAqB8oiD1EcY
         xvdw==
X-Gm-Message-State: AOAM5309uDRHWg6qk8oLD863G1+fRqvmCKaAjrWuqroajbzNiJhr3Rmv
        JQpUX4/ZjpLk5087pxdVFBFmKh9nNrs=
X-Google-Smtp-Source: ABdhPJxPMmrNCufdFjhLoT5iojh6mu8XFJGIWvEiC/f5WPEbmWRF2FjDecS2C85nFKeEDF+CyOJXlg==
X-Received: by 2002:a62:2743:0:b0:4bd:356:21e with SMTP id n64-20020a622743000000b004bd0356021emr1900127pfn.51.1642035129723;
        Wed, 12 Jan 2022 16:52:09 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id z24sm6796749pjq.17.2022.01.12.16.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 16:52:09 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4] ksmbd: smbd: fix missing client's memory region invalidation
Date:   Thu, 13 Jan 2022 09:51:39 +0900
Message-Id: <20220113005139.236076-1-hyc.lee@gmail.com>
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
 - factor out setting a remote key to helper functions.
changes from v2:
 - Make helper functions one smb2_set_remote_key_for_rdma.
changes from v3:
 - initialize fp to NULL for fixing the warning message,
   "variable fp is used unintialized..".

 fs/ksmbd/smb2pdu.c | 73 +++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ced8f949a4d6..b232f78d5b8a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6124,25 +6124,33 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	return err;
 }
 
-static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
-				      struct smb2_read_req *req, void *data_buf,
-				      size_t length)
+static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
+					struct smb2_buffer_desc_v1 *desc,
+					__le32 Channel,
+					__le16 ChannelInfoOffset,
+					__le16 ChannelInfoLength)
 {
-	struct smb2_buffer_desc_v1 *desc =
-		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
-	int err;
-
 	if (work->conn->dialect == SMB30_PROT_ID &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1)
+	    Channel != SMB2_CHANNEL_RDMA_V1)
 		return -EINVAL;
 
-	if (req->ReadChannelInfoOffset == 0 ||
-	    le16_to_cpu(req->ReadChannelInfoLength) < sizeof(*desc))
+	if (ChannelInfoOffset == 0 ||
+	    le16_to_cpu(ChannelInfoLength) < sizeof(*desc))
 		return -EINVAL;
 
 	work->need_invalidate_rkey =
-		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
+		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
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
@@ -6165,7 +6173,7 @@ int smb2_read(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
-	struct ksmbd_file *fp;
+	struct ksmbd_file *fp = NULL;
 	loff_t offset;
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
@@ -6179,6 +6187,18 @@ int smb2_read(struct ksmbd_work *work)
 		return smb2_read_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		err = smb2_set_remote_key_for_rdma(work,
+						   (struct smb2_buffer_desc_v1 *)
+						   &req->Buffer[0],
+						   req->Channel,
+						   req->ReadChannelInfoOffset,
+						   req->ReadChannelInfoLength);
+		if (err)
+			goto out;
+	}
+
 	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
 				  le64_to_cpu(req->PersistentFileId));
 	if (!fp) {
@@ -6364,21 +6384,6 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 
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
@@ -6425,6 +6430,20 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		if (req->Length != 0 || req->DataOffset != 0)
+			return -EINVAL;
+		err = smb2_set_remote_key_for_rdma(work,
+						   (struct smb2_buffer_desc_v1 *)
+						   &req->Buffer[0],
+						   req->Channel,
+						   req->WriteChannelInfoOffset,
+						   req->WriteChannelInfoLength);
+		if (err)
+			goto out;
+	}
+
 	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		ksmbd_debug(SMB, "User does not have write permission\n");
 		err = -EACCES;
-- 
2.25.1

