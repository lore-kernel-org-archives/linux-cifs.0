Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13FBCD5BCE
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Sep 2023 14:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjISOtZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjISOtY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Sep 2023 10:49:24 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49735BF
        for <linux-cifs@vger.kernel.org>; Tue, 19 Sep 2023 07:49:19 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-274c05edb69so1676785a91.2
        for <linux-cifs@vger.kernel.org>; Tue, 19 Sep 2023 07:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695134958; x=1695739758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCfGEAocNR+gMVhiVZF+jdCdz3SCRrhLrW54hJ8Jz1I=;
        b=hHJBQTl3aAAg8UUY7MTihriYnd9JS5BIJWakyf2AJZaM0ftLUieAo/nAgu6UqxoFHD
         5g7K1R3+S+D145W2t3xc3rSyUFRwfx/I21npuaQALqBX56NdrnWAEp0YBPl5oRCNG2c4
         8Y/Gxxobqp1DnvGSgNVk4p74rZQQ5FpoJVUTj4I0Xe2BEYUULjZXT3shoSS7xKeum5Wp
         0aCcC0Ui490fWHa/ICjRi9hmmiIh0uKqzUdNV1/xbnu1LznrZmiVdZ/8HUPMRU0jsCWd
         O//02leKcYW8KIdXvibC32bGIeIJxFmtFORWWfpq6HGSw8LmS8U1wBjbvMpKQeNUYm9L
         rrwQ==
X-Gm-Message-State: AOJu0Yzr/wjtbuH5bDl7FT4GV0XXAkgY/Zcc31BjdnhA4xy4Um/AJmGG
        DlwUvnQTRJ82ONWFzNyqRJfzEChsnK8=
X-Google-Smtp-Source: AGHT+IFpnUoXpdnBNpwkgghG0qF5RC6yGq+FN2pC6MVaibOQQB5te1xxibKR6yIVoN/Ji5Z8vAm0xQ==
X-Received: by 2002:a17:90a:cf17:b0:274:9a85:2596 with SMTP id h23-20020a17090acf1700b002749a852596mr9267464pju.32.1695134957885;
        Tue, 19 Sep 2023 07:49:17 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id cu2-20020a17090afa8200b0026b6d0a68c5sm8866843pjb.18.2023.09.19.07.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 07:49:17 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: check iov vector index in ksmbd_conn_write()
Date:   Tue, 19 Sep 2023 23:47:40 +0900
Message-Id: <20230919144740.52610-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230919144740.52610-1-linkinjeon@kernel.org>
References: <20230919144740.52610-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ->iov_idx is zero, This means that the iov vector for the response
was not added during the request process. In other words, it means that
there is a problem in generating a response, So this patch dump the command
information in the request and returned as an error to avoid NULL pointer
dereferencing problem.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c |  6 ++++++
 fs/smb/server/misc.c       | 15 +++++++++++++++
 fs/smb/server/misc.h       |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 0d990c2f33cd..4e4133b3a4c9 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -14,6 +14,7 @@
 #include "connection.h"
 #include "transport_tcp.h"
 #include "transport_rdma.h"
+#include "misc.h"
 
 static DEFINE_MUTEX(init_lock);
 
@@ -197,6 +198,11 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	if (work->send_no_response)
 		return 0;
 
+	if (!work->iov_idx) {
+		ksmbd_dump_commands(work);
+		return -EINVAL;
+	}
+
 	ksmbd_conn_lock(conn);
 	sent = conn->transport->ops->writev(conn->transport, work->iov,
 			work->iov_cnt,
diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 9e8afaa686e3..0e44ce850575 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -379,3 +379,18 @@ inline long long ksmbd_systime(void)
 	ktime_get_real_ts64(&ts);
 	return ksmbd_UnixTimeToNT(ts);
 }
+
+void ksmbd_dump_commands(struct ksmbd_work *work)
+{
+	char *buf = (char *)work->request_buf + 4;
+	struct smb2_hdr *hdr;
+
+	pr_err("Dump commands in request\n");
+	do {
+		hdr = (struct smb2_hdr *)buf;
+		pr_err("Command : 0x%x, Next offset : %u\n",
+		       le16_to_cpu(hdr->Command),
+		       le32_to_cpu(hdr->NextCommand));
+		buf += le32_to_cpu(hdr->NextCommand);
+	} while (hdr->NextCommand);
+}
diff --git a/fs/smb/server/misc.h b/fs/smb/server/misc.h
index 1facfcd21200..3aef766fc722 100644
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -10,6 +10,7 @@ struct ksmbd_share_config;
 struct nls_table;
 struct kstat;
 struct ksmbd_file;
+struct ksmbd_work;
 
 int match_pattern(const char *str, size_t len, const char *pattern);
 int ksmbd_validate_filename(char *filename);
@@ -23,6 +24,7 @@ void ksmbd_conv_path_to_windows(char *path);
 char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
 char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
 char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
+void ksmbd_dump_commands(struct ksmbd_work *work);
 
 #define KSMBD_DIR_INFO_ALIGNMENT	8
 struct ksmbd_dir_info;
-- 
2.25.1

