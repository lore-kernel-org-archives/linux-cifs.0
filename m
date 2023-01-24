Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F2FC38142
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Jan 2023 15:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjAXPQ3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Jan 2023 10:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjAXPQ3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Jan 2023 10:16:29 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BF21F496
        for <linux-cifs@vger.kernel.org>; Tue, 24 Jan 2023 07:16:28 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id a18so2468873plm.2
        for <linux-cifs@vger.kernel.org>; Tue, 24 Jan 2023 07:16:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNT4i6PjZinbaOYS6RNCFJlqqwjjfI/PaJOJQKQov/g=;
        b=dHlKnYMBcbRAkXZiPzsH3PklbcSCoEx/Jdu65xP9bZQxTQeDX5P5IyQGYGbtzWkyNS
         MJXG2SUKpvs8bjbM0vBpCpIK9iWiDsUy5AoDpOAs5nzyR9wmztt6GZ4e0F0vZq16H4S7
         4noPpMf6hr3zMbUWtNoKvpUJ73gOsdEnRjgmAyEnnUdSiot9hOA080BwN0m0ciIn+eQ+
         EXKeLfW1kg8CfqJLHF7Jq4uItc7+xj6KcBmUtac+UFbFgXrwDXYNJfL80FcncPT7E2sH
         ncw2gNl4uUSkgTfLqA8t6jzPo5f3j1wJSKhEbX2ipIhyeDI4dK4yqaLUVIX+WdhKoxSb
         ebCA==
X-Gm-Message-State: AFqh2kq6uDwWumaZyELDKpSjdRzsks0D0VilboKawDH852KCd7Lexzdg
        RqA3la0NCD/ONmIvGiCamGRSvzxfU2A=
X-Google-Smtp-Source: AMrXdXtM4UJ2+J6fvCRiEXsyWq5U3Z3JL2QxII4iZX05hf43swUqcf2XKgszllPWDBrL6QuaoyDgeg==
X-Received: by 2002:a17:903:2289:b0:194:9290:fa6f with SMTP id b9-20020a170903228900b001949290fa6fmr40171926plh.25.1674573387273;
        Tue, 24 Jan 2023 07:16:27 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0019612221a98sm1706647pll.293.2023.01.24.07.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:16:26 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: limit pdu length size according to connection status
Date:   Wed, 25 Jan 2023 00:16:03 +0900
Message-Id: <20230124151603.18398-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230124151603.18398-1-linkinjeon@kernel.org>
References: <20230124151603.18398-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stream protocol length will never be larger than 16KB until session setup.
After session setup, the size of requests will not be larger than
16KB + SMB2 MAX WRITE size. This patch limits these invalidly oversized
requests and closes the connection immediately.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c | 17 +++++++++++++++--
 fs/ksmbd/smb2pdu.h    |  5 +++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 5be203029bef..ee57db106c1e 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -280,7 +280,7 @@ int ksmbd_conn_handler_loop(void *p)
 {
 	struct ksmbd_conn *conn = (struct ksmbd_conn *)p;
 	struct ksmbd_transport *t = conn->transport;
-	unsigned int pdu_size;
+	unsigned int pdu_size, max_allowed_pdu_size;
 	char hdr_buf[4] = {0,};
 	int size;
 
@@ -305,13 +305,26 @@ int ksmbd_conn_handler_loop(void *p)
 		pdu_size = get_rfc1002_len(hdr_buf);
 		ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size);
 
+		if (conn->status == KSMBD_SESS_GOOD)
+			max_allowed_pdu_size =
+				SMB3_MAX_MSGSIZE + conn->vals->max_write_size;
+		else
+			max_allowed_pdu_size = SMB3_MAX_MSGSIZE;
+
+		if (pdu_size > max_allowed_pdu_size) {
+			pr_err_ratelimited("PDU length(%u) excceed maximum allowed pdu size(%u) on connection(%d)\n",
+					pdu_size, max_allowed_pdu_size,
+					conn->status);
+			break;
+		}
+
 		/*
 		 * Check if pdu size is valid (min : smb header size,
 		 * max : 0x00FFFFFF).
 		 */
 		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
 		    pdu_size > MAX_STREAM_PROT_LEN) {
-			continue;
+			break;
 		}
 
 		/* 4 for rfc1002 length field */
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index aa5dbe54f5a1..0c8a770fe318 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -24,8 +24,9 @@
 
 #define SMB21_DEFAULT_IOSIZE	(1024 * 1024)
 #define SMB3_DEFAULT_TRANS_SIZE	(1024 * 1024)
-#define SMB3_MIN_IOSIZE	(64 * 1024)
-#define SMB3_MAX_IOSIZE	(8 * 1024 * 1024)
+#define SMB3_MIN_IOSIZE		(64 * 1024)
+#define SMB3_MAX_IOSIZE		(8 * 1024 * 1024)
+#define SMB3_MAX_MSGSIZE	(4 * 4096)
 
 /*
  *	Definitions for SMB2 Protocol Data Units (network frames)
-- 
2.25.1

