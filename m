Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E424C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BF060EE4
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbhIYNSk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 09:18:40 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:46973 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhIYNSk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 09:18:40 -0400
Received: by mail-pg1-f177.google.com with SMTP id m21so12679486pgu.13
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 06:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hRxqyy3nibfhhA7qXc2RlbQEqbMe/ajEuAVhjSLNFsY=;
        b=eLPH+R6RS60B6GOJOLtuGrqTNvInyQ6/OjZ1GH82IdREqgado0cn+n41G7SHbalznV
         LBYDabcvCtj9ltXYooQZNF+8kHKm7pl/Az+YV7nC6MIvLeFSTcpqKo2QFAlEx1Fkh7ve
         CmP+UTKItvpconQtZ1uTWLozCkE83ixEivibI7tevrZzRVxRSxknvbycEi6IfAfYCn/e
         kaEVC4KQSNcIx0iEbIGHCBTGNfFBcs6lCw9nE5sJh6LB5HGms24NsiPyJwMIkQN0GsE4
         UXOoFCwxlIFT3XpFyf7vTklNoHQvLdM1+9P91RshasK44S+YyuDBKuF3l4H2y+522ZCE
         rUrA==
X-Gm-Message-State: AOAM530eM1QBE3eQtbHE//fioV2QE31Betpr+QngHZrqhldkwTrEfzzZ
        wXYn6rBTHqRmJ4MM3AqS8Asl51YDMd4uqQ==
X-Google-Smtp-Source: ABdhPJyFiMHk8K1PnfhdEdMfgCp1beI9MRrt9P3v+F2CdepebzL5AsILQITNLWQoVkWZsJbv0A3d7w==
X-Received: by 2002:a63:4506:: with SMTP id s6mr473602pga.211.1632575825118;
        Sat, 25 Sep 2021 06:17:05 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x8sm4714698pjf.43.2021.09.25.06.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:17:04 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2 2/7] ksmbd: add the check to vaildate if stream protocol length exceeds maximum value
Date:   Sat, 25 Sep 2021 22:16:20 +0900
Message-Id: <20210925131625.29617-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925131625.29617-1-linkinjeon@kernel.org>
References: <20210925131625.29617-1-linkinjeon@kernel.org>
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
index 1da67217698d..36fd9695fbc5 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -21,7 +21,6 @@ static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-#define KSMBD_MIN_SUPPORTED_HEADER_SIZE	(sizeof(struct smb2_hdr))
 
 struct smb_protocol {
 	int		index;
@@ -267,11 +266,6 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
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
index d7df19c97c4c..b8d225f7dbfc 100644
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
@@ -492,8 +494,6 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
 
 int ksmbd_init_smb_server(struct ksmbd_work *work);
 
-bool ksmbd_pdu_size_has_room(unsigned int pdu);
-
 struct ksmbd_kstat;
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
 				      int info_level,
-- 
2.25.1

