Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8B4EE49A6
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Aug 2023 13:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbjHUNv7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbjHUNv6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Aug 2023 09:51:58 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B8CBE
        for <linux-cifs@vger.kernel.org>; Mon, 21 Aug 2023 06:51:53 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-68a440a8a20so977836b3a.3
        for <linux-cifs@vger.kernel.org>; Mon, 21 Aug 2023 06:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692625912; x=1693230712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RsH+xjCroeWF/hAquiLltfPEVVD2nPXioeEu7iTQn/c=;
        b=lC4a6AczqR5hXi65VdaJ1vWO9+N14ANBeQn+wdcXNQCpUjf9LO3wFAu/stIqZnILOI
         mzjNDp8iQxAPpZpTX8FBLcnjAZVVI/AfDE+vT0KnnwEZ3NK05UjYdLvxtzlL42bUfsmz
         HEkyF+QetoqPa3o3dKFHSs6rBgi+Tyt3GlmR8T1QLFaEWJir8f9jebD4KdwVBG0KddLK
         UfO2rxyvUl34E/DePx1ubzQUVBD/4TKxvRvg3TZZx2bCDaoEfYS2sERQ7jyy2C57jcQ/
         UWGdpbekvjyQRk4fMx+Gb3k19DjTAUVUuYkXN6/2Yk72EppGK/a32P6i6M3kTDqtn2al
         fWzg==
X-Gm-Message-State: AOJu0Yw/PgELIDqNqFrQz+RVc61rBdT8m3jYCzFzlnyHh4wv96maCOZ5
        cW4WlI1CRmv/mYs/O8eNuRM2Rm4A1LA=
X-Google-Smtp-Source: AGHT+IGLL5+8ggZTVe+7THGtVSNbh7KDxFV8U9nNFqH/Rt1jyA93Qmw1j1DXrDmtavZqVTw1Zd/ZCg==
X-Received: by 2002:a05:6a00:15d4:b0:681:c372:5aa4 with SMTP id o20-20020a056a0015d400b00681c3725aa4mr9356263pfu.27.1692625912139;
        Mon, 21 Aug 2023 06:51:52 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id x24-20020a62fb18000000b0066ebaeb149dsm4784931pfm.88.2023.08.21.06.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 06:51:50 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: reduce descriptor size if remaining bytes is less than request size
Date:   Mon, 21 Aug 2023 22:51:40 +0900
Message-Id: <20230821135140.4434-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create 3 kinds of files to reproduce this problem.

dd if=/dev/urandom of=127k.bin bs=1024 count=127
dd if=/dev/urandom of=128k.bin bs=1024 count=128
dd if=/dev/urandom of=129k.bin bs=1024 count=129

When copying files from ksmbd share to windows or cifs.ko, The following
error message happen from windows client.

"The file '129k.bin' is too large for the destination filesystem."

We can see the error logs from ksmbd debug prints

[48394.611537] ksmbd: RDMA r/w request 0x0: token 0x669d, length 0x20000
[48394.612054] ksmbd: smb_direct: RDMA write, len 0x20000, needed credits 0x1
[48394.612572] ksmbd: filename 129k.bin, offset 131072, len 131072
[48394.614189] ksmbd: nbytes 1024, offset 132096 mincount 0
[48394.614585] ksmbd: Failed to process 8 [-22]

And we can reproduce it with cifs.ko,
e.g. dd if=129k.bin of=/dev/null bs=128KB count=2

This problem is that ksmbd rdma return error if remaining bytes is less
than Length of Buffer Descriptor V1 Structure.

smb_direct_rdma_xmit()
...
     if (desc_buf_len == 0 || total_length > buf_len ||
           total_length > t->max_rdma_rw_size)
               return -EINVAL;

This patch reduce descriptor size with remaining bytes and remove the
check for total_length and buf_len.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c06efc020bd9..9e8df0d9bb5a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1366,24 +1366,37 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	LIST_HEAD(msg_list);
 	char *desc_buf;
 	int credits_needed;
-	unsigned int desc_buf_len;
+	unsigned int desc_buf_len, desc_num = 0;
 	size_t total_length = 0;
 
 	if (t->status != SMB_DIRECT_CS_CONNECTED)
 		return -ENOTCONN;
 
+	if (buf_len > t->max_rdma_rw_size)
+		return -EINVAL;
+
 	/* calculate needed credits */
 	credits_needed = 0;
 	desc_buf = buf;
-	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+	for (i = 0; i < desc_len / sizeof(*desc) && buf_len != 0; i++) {
+		if (!buf_len)
+			break;
+
 		desc_buf_len = le32_to_cpu(desc[i].length);
+		if (!desc_buf_len)
+			return -EINVAL;
+
+		if (desc_buf_len > buf_len) {
+			desc_buf_len = buf_len;
+			desc[i].length = cpu_to_le32(desc_buf_len);
+			buf_len = 0;
+		}
 
 		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
 		desc_buf += desc_buf_len;
 		total_length += desc_buf_len;
-		if (desc_buf_len == 0 || total_length > buf_len ||
-		    total_length > t->max_rdma_rw_size)
-			return -EINVAL;
+		buf_len -= desc_buf_len;
+		desc_num++;
 	}
 
 	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
@@ -1395,7 +1408,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 	/* build rdma_rw_ctx for each descriptor */
 	desc_buf = buf;
-	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+	for (i = 0; i < desc_num; i++) {
 		msg = kzalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
 			      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
 		if (!msg) {
-- 
2.25.1

