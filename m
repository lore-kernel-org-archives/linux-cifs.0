Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F6FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C46261AF7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhJBN1A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:00 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3647AC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=5hAfwrhGJImpHft8YW0KFLOp0dMZ1hNydIR2TVPmsEs=; b=q8U5YTEpC9e2neA5o0uBFbksiI
        EgRhe8zWBJRdHE5WjfPpgFL0cqc32uh1mW+ROhAYRjFocyVx35ZoMYT3jRpGypdrfPXGonIxiSISi
        K5YWVDsnRDLb5mnzaLk8q5JeT37P5+wplUFwv/B/WjG7wd5qlLB/RWlcJgbLeNwRfqQAlypqZRm79
        klqE/9Z4qFW2q6dZi5StSCAUd2DYuGUxZJSEbW/yBk9CpCmpYJ9gUpOzPM2TvYXC2rUPYaRZ6Mxhd
        Ld8Eorrivcqg9q9W8gQzfKshzI/TYWB59czgXky+AVPv+RSIKMQTfqEwb6LIZyz/GG3S9iyuwilb5
        bx6DhRJOwDVQwWilZWJK3zEvetnfktzhcL5iVaQr5fGmfPyDTEloSBRJrpG99AedbbdMM7YWN3eJg
        ImJfbKnTdtbUZN2xvmLW6R/KNJnpj/9tN1b/6TTP3mVtzo2cBfnacSuQ0UddQGWau026RIGWkz4iZ
        bk/2RezrVnQp7klRV4G9mhPd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoN-001DcY-OX; Sat, 02 Oct 2021 13:12:19 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 01/14] ksmbd: add the check to vaildate if stream protocol length exceeds maximum value
Date:   Sat,  2 Oct 2021 15:11:59 +0200
Message-Id: <20211002131212.130629-2-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

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
 fs/ksmbd/connection.c | 9 +++++----
 fs/ksmbd/smb_common.c | 6 ------
 fs/ksmbd/smb_common.h | 4 ++--
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index af086d35398a..e50353c50661 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -296,10 +296,11 @@ int ksmbd_conn_handler_loop(void *p)
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
+		if (pdu_size > MAX_STREAM_PROT_LEN) {
 			continue;
 		}
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index db8042a173d0..b6c4c7e960fa 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -21,7 +21,6 @@ static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-#define KSMBD_MIN_SUPPORTED_HEADER_SIZE	(sizeof(struct smb2_hdr))
 
 struct smb_protocol {
 	int		index;
@@ -294,11 +293,6 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
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
2.31.1

