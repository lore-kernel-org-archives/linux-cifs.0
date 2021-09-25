Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DD2C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB7C60EE5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245220AbhIYNS7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 09:18:59 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:36768 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245011AbhIYNSz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 09:18:55 -0400
Received: by mail-pg1-f180.google.com with SMTP id t1so12751145pgv.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 06:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wQwduL5J6qre25n3niYQJlJXOZqhZLA4CpfV9QFs2V0=;
        b=AjNoLONWyK2HoEA2JRQDC+iqGiv5JCzbGPbDSvK6XcLgmRbH74JurBWNPzI6c0V8zf
         2T/+w1w9qImvnxhb5xPtSxa/mlvlpDPKBvlaamCTlTOMn/TZ5+Fim4JZAqPIqE0elmhD
         x1U+0XBLlLuhTwTDeShKL+mAJaz7G8ZJbDRMR7hXwNQN9t22Fblh3v3r1sArBgyjlHRS
         NJKMlyYPKyNtYduNTxZIMxxjKdH7L8h3IEDBvqIRQc/mboqjay4L8NFI5OlsB2HUOrM4
         EdzPIvvhoGD117UTpFmg+L013r4ElYlvaLFyYWhuDCp7aA3WwH6hB7iJjta5iezSWqn0
         rAHg==
X-Gm-Message-State: AOAM532GClvEiCIXUznlfJg3UOZXYMRKkFalJzk7geRgCLTND3YNyELh
        0mIc6rAJQePhBrApkTzBxHIA6EVR+JnEew==
X-Google-Smtp-Source: ABdhPJy5nz8uuoI08c4eTtw+JHvfcCNBoM9HP9gStofETNLtFJSohcoFiL0msIal62z8UlEaAbfyaQ==
X-Received: by 2002:a63:1e16:: with SMTP id e22mr8142357pge.153.1632575840446;
        Sat, 25 Sep 2021 06:17:20 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x8sm4714698pjf.43.2021.09.25.06.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:17:20 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2 6/7] ksmbd: fix invalid request buffer access in compound
Date:   Sat, 25 Sep 2021 22:16:24 +0900
Message-Id: <20210925131625.29617-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925131625.29617-1-linkinjeon@kernel.org>
References: <20210925131625.29617-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie reported invalid request buffer access in chained command when
inserting garbage value to NextCommand of compound request.
This patch add validation check to avoid this issue.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c463375b0a4a..713f861fdaad 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -459,13 +459,22 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 bool is_chained_smb2_message(struct ksmbd_work *work)
 {
 	struct smb2_hdr *hdr = work->request_buf;
-	unsigned int len;
+	unsigned int len, next_cmd;
 
 	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
 		return false;
 
 	hdr = ksmbd_req_buf_next(work);
-	if (le32_to_cpu(hdr->NextCommand) > 0) {
+	next_cmd = le32_to_cpu(hdr->NextCommand);
+	if (next_cmd > 0) {
+		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd +
+			__SMB2_HEADER_STRUCTURE_SIZE >
+		    get_rfc1002_len(work->request_buf)) {
+			pr_err("next command(%u) offset exceeds smb msg size\n",
+			       next_cmd);
+			return false;
+		}
+
 		ksmbd_debug(SMB, "got SMB2 chained command\n");
 		init_chained_smb2_rsp(work);
 		return true;
-- 
2.25.1

