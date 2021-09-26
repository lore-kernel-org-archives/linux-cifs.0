Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26753C433FE
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5CD60F9B
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhIZON6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 10:13:58 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:42631 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhIZON5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Sep 2021 10:13:57 -0400
Received: by mail-pj1-f49.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so1636677pjb.1
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 07:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hRxqyy3nibfhhA7qXc2RlbQEqbMe/ajEuAVhjSLNFsY=;
        b=qiR+WDsoDJZFkizOkPdsiFvKGhkhcRgaLMQzsCAntQSZoFR19mpCQQTXhGO6vtwC1t
         M6c0uLOtlUtkpz8TbHVAcj0GWPcqTbSGr96YOrkTdQsbJvruoXij+th71ubhd7WLAEti
         eydAYamHcjJ9SEBayrakImptZcrbJzcAHMcXxOWvX53GaCuVpOkhfTmCTQwz4Xh+4FOy
         mZR1obI9iKol45/Da9pzZoTCbWq3JaLOpojCVPeAPG1nHVL3itxLh9FNKb7Rsl/BWwAu
         jrjuklYiiVUY8i3k90MFpJ9BOwfQltMx6/zmC37dP2rly0rhHi67jlbU/OaGb5eTgNiL
         w+zg==
X-Gm-Message-State: AOAM532SJqiY+eJa7vBP663Feu/IxujcoUxa2uVwUx+byFPV2wqYI80W
        A0pmOwc7V6uMuIKVwcON3JCIhE23RVVi2A==
X-Google-Smtp-Source: ABdhPJzyb/wpUI7L0PQk5GUTQnmfViY29n7um1C2/OSQMRcUoIhict6WGWbR1I2iuqn/962sTIWhWA==
X-Received: by 2002:a17:90b:3715:: with SMTP id mg21mr14075569pjb.186.1632665541236;
        Sun, 26 Sep 2021 07:12:21 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g3sm16521742pgf.1.2021.09.26.07.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 07:12:20 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3 1/5] ksmbd: add the check to vaildate if stream protocol length exceeds maximum value
Date:   Sun, 26 Sep 2021 22:55:39 +0900
Message-Id: <20210926135543.119127-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
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

