Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A75C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jan 2022 00:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346894AbiALAv2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343866AbiALAv2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 19:51:28 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479C3C06173F
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 16:51:28 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso1763365pjg.4
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 16:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ctkg1PIGRiJbntRLhRxDnM9ZW84KrM+5mv73ePwQ/48=;
        b=fggekjEhfM4DzIkb+roUgm0S8ANr1v8FuG6NsGWklqdSNlKhjDlG2ydHawZzrxGo2b
         +BGQop/L4z/J2dxzDRvF+ZGI4Ql0HqdWKH5qSo1oDfza4qaIxMoEvd2bUECiDdI0DO5L
         hvxkhEnXoRPo9E5pcBpvk0StgYEJgCfyP0lQQl03P7p8/XANO4cKtXoaLDUDTXsfkzS4
         RR58/DkdpZ7VkxtytAxw+fLJQPWpZ4q8WBMezVEDuEqAcyFWDqslwCWwAy/MtqkHPbE9
         F9IN4gR9sPDVF/4mK2o2j3nb7wLT1eRLOtrefIrQg/0nVivXE/wgYJFrJ3YmmpgZBDys
         k+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ctkg1PIGRiJbntRLhRxDnM9ZW84KrM+5mv73ePwQ/48=;
        b=Ty4oH+EMYkLzyW77ISSL+y+1+nerQqNYpKNq+GvmAVV8p5fixsVW5sC1odXkVKTqnp
         Vn2RnpTnZPhWX0tysSQWZOVGar8cbWH31vz6wZ5kXHWHtoJ3U5Lh0a3BfsnM6kDELWfG
         K+ita8hdwQfzxYZiiz/ABOWJKkzi5SYvPJXpfZ14bG2uIzeSuNqgICZfq8FpyTIGJhG7
         SCQjlMxx+MBy6Xq8S2igYVDB3nYJIdOZ3VyAaeqFIWAQ+LlThdrjdEQj/LRdPO/2TSMd
         88nR83PBC5AlZydwbIj+73Py2piD2LHz+d/VPj3dbzL1m3QVrXVmxKVKK+D578u9kq38
         j3Qg==
X-Gm-Message-State: AOAM532+NmWA8xGK6GmbGPFForwHyN7iHRgfLTUilSMweAQtYbh7/Ud3
        3r3BuZdqS0BHinvL3CCgRqJovjKQjVQ=
X-Google-Smtp-Source: ABdhPJyIdG1cJ6i9GxHtWQ0scP9sycDqr7xOhNecZiAGozcZPc7A9CA1rv6B2LaHm91c40aRSik/Sw==
X-Received: by 2002:a17:902:eccd:b0:149:4497:fae8 with SMTP id a13-20020a170902eccd00b001494497fae8mr6974695plh.143.1641948687526;
        Tue, 11 Jan 2022 16:51:27 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id b4sm3547157pjh.44.2022.01.11.16.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 16:51:27 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3] ksmbd: smbd: fix missing client's memory region invalidation
Date:   Wed, 12 Jan 2022 09:51:15 +0900
Message-Id: <20220112005115.99855-1-hyc.lee@gmail.com>
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

 fs/ksmbd/smb2pdu.c | 71 +++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ced8f949a4d6..c3f248d461e6 100644
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

