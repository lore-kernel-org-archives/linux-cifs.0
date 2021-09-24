Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574F2C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4165C610F7
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243908AbhIXCOy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:14:54 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:36793 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243883AbhIXCOy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 22:14:54 -0400
Received: by mail-pg1-f176.google.com with SMTP id t1so8403218pgv.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeYZ7EbIzj7fI8V9DssZSUTJ5Sc5F7Zl/7B3hmJZSm0=;
        b=2xHfnf9KO7xibUGSaN2w5BVidoesZJEM5mZ9VPVKlezqCGhi1whFEwRi7/1GhtwA4y
         yJA4iP187c+43s880cUd5BFi1013A/WSSPYgJcvsKC2+LchT3BRi2slFCiknPB4Y27X0
         ZURkoO7CGOwh/TzomeNqQXCtcUj7S9vZ6VRiYzdYgDn2Z8siUcy6O2SkDzsvlmre4t55
         0b4rXtwyAE2xTf+FSWQcJSPvK1dG0a0gMCkS2Exgps9FlInIfOsaI3TxiXW8E95LA4Aa
         QkMUr103OPJUwM6AdPMQVDKA+clFdzsLGcbb6HL30kMTS8n44bZ03dYYtdt8q9IRHAxj
         NS7A==
X-Gm-Message-State: AOAM531fAV846S6M9h3ElxsVYkg2TLEzHM/GHNsUNDjrxUdk8Joqt5fP
        hUHE7bMmapv26JcI3tZvEa/blMQ/+l4lvw==
X-Google-Smtp-Source: ABdhPJwXmwa3PyQjZ3OvsaKD2FXcXBJVg9ZwsrVn+XeoEgS6fhsWjLf7XIp+yZ+Bd5IBjMMSqjHPpQ==
X-Received: by 2002:a05:6a00:4:b0:440:6476:bcb4 with SMTP id h4-20020a056a00000400b004406476bcb4mr7559238pfk.0.1632449601808;
        Thu, 23 Sep 2021 19:13:21 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c16sm6724746pfo.163.2021.09.23.19.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 19:13:21 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 5/7] ksmbd: add the check to vaildate if stream protocol length exceeds maximum value
Date:   Fri, 24 Sep 2021 11:12:52 +0900
Message-Id: <20210924021254.27096-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210924021254.27096-1-linkinjeon@kernel.org>
References: <20210924021254.27096-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
length exceeds maximum value. opencode pdu size check in
ksmbd_pdu_size_has_room().

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c | 10 ++++++----
 fs/ksmbd/smb_common.c |  6 ------
 fs/ksmbd/smb_common.h |  4 ++--
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index af086d35398a..48b18b4ec117 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -296,10 +296,12 @@ int ksmbd_conn_handler_loop(void *p)
 		pdu_size = get_rfc1002_len(hdr_buf);
 		ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size);
 
-		/* make sure we have enough to get to SMB header end */
-		if (!ksmbd_pdu_size_has_room(pdu_size)) {
-			ksmbd_debug(CONN, "SMB request too short (%u bytes)\n",
-				    pdu_size);
+		/*
+		 * Check if pdu size is valid (min : smb header size,
+		 * max : 0x00FFFFFF).
+		 */
+		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
+		    pdu_size > MAX_STREAM_PROT_LEN) {
 			continue;
 		}
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 5901b2884c60..20bd5b8e3c0a 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -21,7 +21,6 @@ static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-#define KSMBD_MIN_SUPPORTED_HEADER_SIZE	(sizeof(struct smb2_hdr))
 
 struct smb_protocol {
 	int		index;
@@ -272,11 +271,6 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
 	return 0;
 }
 
-bool ksmbd_pdu_size_has_room(unsigned int pdu)
-{
-	return (pdu >= KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
-}
-
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 				      struct ksmbd_file *dir,
 				      struct ksmbd_dir_info *d_info,
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 994abede27e9..6e79e7577f6b 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -48,6 +48,8 @@
 #define CIFS_DEFAULT_IOSIZE	(64 * 1024)
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
+#define MAX_STREAM_PROT_LEN	0x00FFFFFF
+
 /* Responses when opening a file. */
 #define F_SUPERSEDED	0
 #define F_OPENED	1
@@ -493,8 +495,6 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
 
 int ksmbd_init_smb_server(struct ksmbd_work *work);
 
-bool ksmbd_pdu_size_has_room(unsigned int pdu);
-
 struct ksmbd_kstat;
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
 				      int info_level,
-- 
2.25.1

