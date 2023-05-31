Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BB3C7EE23
	for <linux-cifs@archiver.kernel.org>; Wed, 31 May 2023 13:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjEaNg1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 May 2023 09:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjEaNg0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 May 2023 09:36:26 -0400
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F5FC0
        for <linux-cifs@vger.kernel.org>; Wed, 31 May 2023 06:36:24 -0700 (PDT)
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-33b1e83e204so8881245ab.1
        for <linux-cifs@vger.kernel.org>; Wed, 31 May 2023 06:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685540183; x=1688132183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6dDof1E7ccifmYNgK/6VRthgRC6mJbb72IGfJEO+C7I=;
        b=JUseqjP5nkrAxOJRJI1adDxo7MXvfFe6tjrpAJZdzVNXCxmzsi4CSFVUHXFj1ybTNQ
         ZhDirtwlNwR23gJtVOtDnf3gefuwzw3nXkrAVD+tQjQYXkPx2T3qdV3NZj0k7X6zbxZK
         pM5SGlMmDfBITlJlCX9y1gfZ6RzVQsjpQ8sFWJRN7LZZ4UJqaMNAWJdQx5WmUXvRZfIo
         LUXQDlADgW4C482NFBzNzAKwCak1QWUV+NHgIHkL3MFj0uPru0olTbDWFXzPH0i3DIPD
         gRT3BP87F/6MPrx3wS5iUOZSV//FdiM4IJzAwQ3qu79GTkgeW+e0hV1/ODwog1We/ar4
         3Jrw==
X-Gm-Message-State: AC+VfDzFDEy/a7ahHmlZwA/4e4VrritZ/5/6v/8EYPY/q7LHvsCe4yKY
        zqmmYYdd0uX3r/klAmxnuslhIhR5va0=
X-Google-Smtp-Source: ACHHUZ66FrbYrq+1O+aD3LFyC0D85KaM2ts45dewWee+fo+PNh3Ip0wTbpcOnAWiIgBOukQIw5t14g==
X-Received: by 2002:a92:d0c3:0:b0:33b:16e9:bba5 with SMTP id y3-20020a92d0c3000000b0033b16e9bba5mr2615137ila.28.1685540183282;
        Wed, 31 May 2023 06:36:23 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id y12-20020a63fa0c000000b0051b36aee4f6sm1261809pgh.83.2023.05.31.06.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 06:36:22 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ksmbd: use kvzalloc instead of kvmalloc
Date:   Wed, 31 May 2023 22:36:14 +0900
Message-Id: <20230531133614.15973-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use kvzalloc instead of kvmalloc.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c       | 8 ++++----
 fs/smb/server/smb_common.c    | 4 ++--
 fs/smb/server/transport_ipc.c | 4 ++--
 fs/smb/server/vfs.c           | 4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b5e323b379c4..82cadebec459 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -526,7 +526,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	if (le32_to_cpu(hdr->NextCommand) > 0)
 		sz = large_sz;
 
-	work->response_buf = kvmalloc(sz, GFP_KERNEL | __GFP_ZERO);
+	work->response_buf = kvzalloc(sz, GFP_KERNEL);
 	if (!work->response_buf)
 		return -ENOMEM;
 
@@ -6064,7 +6064,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 		}
 
 		work->aux_payload_buf =
-			kvmalloc(rpc_resp->payload_sz, GFP_KERNEL | __GFP_ZERO);
+			kvmalloc(rpc_resp->payload_sz, GFP_KERNEL);
 		if (!work->aux_payload_buf) {
 			err = -ENOMEM;
 			goto out;
@@ -6216,7 +6216,7 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
 		    fp->filp, offset, length);
 
-	work->aux_payload_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
+	work->aux_payload_buf = kvzalloc(length, GFP_KERNEL);
 	if (!work->aux_payload_buf) {
 		err = -ENOMEM;
 		goto out;
@@ -6365,7 +6365,7 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 	int ret;
 	ssize_t nbytes;
 
-	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
+	data_buf = kvzalloc(length, GFP_KERNEL);
 	if (!data_buf)
 		return -ENOMEM;
 
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index af0c2a9b8529..c6e4d38319df 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -347,8 +347,8 @@ static int smb1_check_user_session(struct ksmbd_work *work)
  */
 static int smb1_allocate_rsp_buf(struct ksmbd_work *work)
 {
-	work->response_buf = kmalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
-			GFP_KERNEL | __GFP_ZERO);
+	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
+			GFP_KERNEL);
 	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 
 	if (!work->response_buf) {
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 40c721f9227e..b49d47bdafc9 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -229,7 +229,7 @@ static struct ksmbd_ipc_msg *ipc_msg_alloc(size_t sz)
 	struct ksmbd_ipc_msg *msg;
 	size_t msg_sz = sz + sizeof(struct ksmbd_ipc_msg);
 
-	msg = kvmalloc(msg_sz, GFP_KERNEL | __GFP_ZERO);
+	msg = kvzalloc(msg_sz, GFP_KERNEL);
 	if (msg)
 		msg->sz = sz;
 	return msg;
@@ -268,7 +268,7 @@ static int handle_response(int type, void *payload, size_t sz)
 			       entry->type + 1, type);
 		}
 
-		entry->response = kvmalloc(sz, GFP_KERNEL | __GFP_ZERO);
+		entry->response = kvzalloc(sz, GFP_KERNEL);
 		if (!entry->response) {
 			ret = -ENOMEM;
 			break;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index a7b7264fb4e6..23eb1da4bcad 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -424,7 +424,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	}
 
 	if (v_len < size) {
-		wbuf = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
+		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {
 			err = -ENOMEM;
 			goto out;
@@ -826,7 +826,7 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
 	if (size <= 0)
 		return size;
 
-	vlist = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
+	vlist = kvzalloc(size, GFP_KERNEL);
 	if (!vlist)
 		return -ENOMEM;
 
-- 
2.25.1

