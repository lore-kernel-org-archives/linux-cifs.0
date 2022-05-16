Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29207C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 16 May 2022 07:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbiEPHmO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 May 2022 03:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiEPHmN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 May 2022 03:42:13 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752A52BFE
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:11 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 31so13326395pgp.8
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTnXUKF42K/gHUDbdRvUVJz0VBNV+3J6ycRb64rVuuM=;
        b=cCKg1puyNP0Dq5NwhHgrJ5ngzCG8Fm5IveUVIIM7qkPkRzZi3tW3S70RSFbfBwWvKc
         cxnF0xvcrc6oKgvKuXQFr20bQjqo9e/X9mCu+CyD1V58FjG06SeEOKGpgQ8TTN5v87sw
         QHJQxuUnJnszOUoW+Gvl5lbMrtzo7CZquTs/wozeyKKQuCdmYQ3DFad1ZOXuBzLy3GOu
         yqlXounDuAI4/St4iwP6TcZQyebhquAUqkqgxiU8iMcc2w3XA3AdNW566/HAE9bIAMzx
         3/8FUu54ljwOj6USgRhu3qGkTBIRmfZP0rBbK1m9HDMPA/ru+Vcgr/BB86GMQ+yxefB8
         7AOA==
X-Gm-Message-State: AOAM53371WW6sFVuLAkYhp4yIq9mbVov2WSj9DzuzOd+4ytiJQvwhvn1
        SFjR/VGJ+NN8QHIz8EVmsulU5eLOhGtELw==
X-Google-Smtp-Source: ABdhPJwWjshwC1M4lrtptSKx8LYpbv+4jHh4YcZxZQO+d0ihkUC0+0r4YQ8y3LzgWIA8xREt2POlrQ==
X-Received: by 2002:a05:6a00:10cc:b0:506:e0:d6c3 with SMTP id d12-20020a056a0010cc00b0050600e0d6c3mr16489034pfu.33.1652686930766;
        Mon, 16 May 2022 00:42:10 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id r19-20020a170903021300b0015e8d4eb26esm6321342plh.184.2022.05.16.00.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 00:42:10 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: add smbd max io size parameter
Date:   Mon, 16 May 2022 16:41:39 +0900
Message-Id: <20220516074140.28522-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220516074140.28522-1-linkinjeon@kernel.org>
References: <20220516074140.28522-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add 'smbd max io size' parameter to adjust smbd-direct max read/write
size.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/ksmbd_netlink.h  | 3 ++-
 fs/ksmbd/transport_ipc.c  | 3 +++
 fs/ksmbd/transport_rdma.c | 8 +++++++-
 fs/ksmbd/transport_rdma.h | 6 ++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index ebe6ca08467a..52aa0adeb951 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -104,7 +104,8 @@ struct ksmbd_startup_request {
 					 */
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
-	__u32	reserved[128];		/* Reserved room */
+	__u32	smbd_max_io_size;	/* smbd read write size */
+	__u32	reserved[127];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 3ad6881e0f7e..7cb0eeb07c80 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -26,6 +26,7 @@
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
 #include "transport_tcp.h"
+#include "transport_rdma.h"
 
 #define IPC_WAIT_TIMEOUT	(2 * HZ)
 
@@ -303,6 +304,8 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 		init_smb2_max_trans_size(req->smb2_max_trans);
 	if (req->smb2_max_credits)
 		init_smb2_max_credits(req->smb2_max_credits);
+	if (req->smbd_max_io_size)
+		init_smbd_max_io_size(req->smbd_max_io_size);
 
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 19a605fd46ff..6d652ff38b82 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 8 * 1024 * 1024;
+static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
 static LIST_HEAD(smb_direct_device_list);
 static DEFINE_RWLOCK(smb_direct_device_lock);
@@ -214,6 +214,12 @@ struct smb_direct_rdma_rw_msg {
 	struct scatterlist	sg_list[];
 };
 
+void init_smbd_max_io_size(unsigned int sz)
+{
+	sz = clamp_val(sz, SMBD_MIN_IOSIZE, SMBD_MAX_IOSIZE);
+	smb_direct_max_read_write_size = sz;
+}
+
 static inline int get_buf_page_count(void *buf, int size)
 {
 	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index 5567d93a6f96..e7b4e6790fab 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -7,6 +7,10 @@
 #ifndef __KSMBD_TRANSPORT_RDMA_H__
 #define __KSMBD_TRANSPORT_RDMA_H__
 
+#define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
+#define SMBD_MIN_IOSIZE (512 * 1024)
+#define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
+
 /* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
 struct smb_direct_negotiate_req {
 	__le16 min_version;
@@ -52,10 +56,12 @@ struct smb_direct_data_transfer {
 int ksmbd_rdma_init(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
+void init_smbd_max_io_size(unsigned int sz);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
+static inline void init_smbd_max_io_size(unsigned int sz) { }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
-- 
2.25.1

