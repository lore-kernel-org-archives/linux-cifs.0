Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7846CC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63BB761357
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244837AbhI2IrA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:47:00 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:46061 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244459AbhI2Iq4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 04:46:56 -0400
Received: by mail-pl1-f180.google.com with SMTP id n2so1004391plk.12
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lzP8NqyTjJbCGax0G2mVKepT01Fj01WwWWSnUpaRRU0=;
        b=K4+RmIbc27kKP80Rhg9vBtyabIwroqaMJNivL44UwFz60wrwdPyxzJN+XgHHOXMfo4
         nAF7CYXZO51hV/+kI57SvCK6qqMwiDte2MjIO/B7iIzTVrR4k9dGPgRHZFbfntbEBs5/
         mnMhm4lf8h0MeuOudE+JnxIgp37py8S5gLanupc1XBOyW+Rn2765LAxm0S4Bu919c96p
         dUxsOZeQYhB73VM8+lq5ASAFJqwPzAiE5RaB1HhkF/M+NPdCOCQEmT549GKJX7jjQlHr
         LzP8ORRtcIZ7ca2M5AKj+VNxqBq+emudTJv+Cv+dtVaKzvv8Jad/sbL5up3CFOffWFJT
         /uZw==
X-Gm-Message-State: AOAM533fTpR917wL3SnO7vuMLT2zLyuVQKQ8+H2Cm8DTEAIGp5nGqdSK
        TnH6PIpWGxkEfUH9GgivMZf6cpYOWuxwfw==
X-Google-Smtp-Source: ABdhPJzfQNBPg3OgPC0Rw6aTuTB1rYqbTzovKmiXijXuuW0Mdzd7OpG72nla5s8NW634emMhgFTXhg==
X-Received: by 2002:a17:90b:1712:: with SMTP id ko18mr5131411pjb.187.1632905114261;
        Wed, 29 Sep 2021 01:45:14 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q3sm1912344pgf.18.2021.09.29.01.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:45:13 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4 1/9] ksmbd: add the check to vaildate if stream protocol length exceeds maximum value
Date:   Wed, 29 Sep 2021 17:44:53 +0900
Message-Id: <20210929084501.94846-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
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
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
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

