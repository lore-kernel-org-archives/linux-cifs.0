Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B783C77B7C
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjEEPLd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjEEPLc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:11:32 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C7E2719
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:11:32 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1aaf7067647so12931375ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299491; x=1685891491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUt2rEYpR6+/BQaN734mLnNH678//hSLjEdufO3SP0k=;
        b=iMqzP+Z5AlSagIQp5labq9B7zS3nHtLGNb9m45XDSk/DfcaZ//CUbeFijQh5bRW+W9
         HHgUfH/nuj7BXOizeiKt1YTxZmHcTSvuZFCDQtw4iH0gzwmhTXpSNej9ghhz2mKsa2JV
         KYGxU/xOJcR5sZwHXGKb5ucPwtAi4ClOPowdkzBEIRS5L807ILtre/4BAqatG34U/Bn8
         UHZ1qRFr92FfyQvSBPVVlDzHVkMiBhdqaYP4xJ7zyqn0TLriu/YfAU1LynN/YyXJ3rLa
         tf/OL16mexNoiznJ30vzNGH5l62qYtkx0V1BX7hm2jE+4ZN7GxxUWdVMs04A3GgPI2OY
         1aJQ==
X-Gm-Message-State: AC+VfDzzNNFa1Bpcm4Gtgdhv4fvm568SsQln3dK6dKZpgHZXndwRPW0B
        yDcEicjiQhgJVn56CsgBHXaA/IJNbWE=
X-Google-Smtp-Source: ACHHUZ7y9myTbDU8U8Mr4HtVo9Q8LY1QRNehDcjW4BadfTDYKCQdYknlci45SJTBNn6vbxylaciuWA==
X-Received: by 2002:a17:902:d505:b0:1ab:1351:979e with SMTP id b5-20020a170902d50500b001ab1351979emr2263267plg.10.1683299490987;
        Fri, 05 May 2023 08:11:30 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001a2135e7eabsm1950898plg.16.2023.05.05.08.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:11:30 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Pumpkin <cc85nod@gmail.com>
Subject: [PATCH 2/6] ksmbd: fix wrong UserName check in session_user
Date:   Sat,  6 May 2023 00:11:04 +0900
Message-Id: <20230505151108.5911-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230505151108.5911-1-linkinjeon@kernel.org>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pumpkin <cc85nod@gmail.com>

The offset of UserName is related to the address of security
buffer. To ensure the validaty of UserName, we need to compare name_off
+ name_len with secbuf_len instead of auth_msg_len.

[   27.096243] ==================================================================
[   27.096890] BUG: KASAN: slab-out-of-bounds in smb_strndup_from_utf16+0x188/0x350
[   27.097609] Read of size 2 at addr ffff888005e3b542 by task kworker/0:0/7
...
[   27.099950] Call Trace:
[   27.100194]  <TASK>
[   27.100397]  dump_stack_lvl+0x33/0x50
[   27.100752]  print_report+0xcc/0x620
[   27.102305]  kasan_report+0xae/0xe0
[   27.103072]  kasan_check_range+0x35/0x1b0
[   27.103757]  smb_strndup_from_utf16+0x188/0x350
[   27.105474]  smb2_sess_setup+0xaf8/0x19c0
[   27.107935]  handle_ksmbd_work+0x274/0x810
[   27.108315]  process_one_work+0x419/0x760
[   27.108689]  worker_thread+0x2a2/0x6f0
[   27.109385]  kthread+0x160/0x190
[   27.110129]  ret_from_fork+0x1f/0x30
[   27.110454]  </TASK>

Signed-off-by: Pumpkin <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index cb93fd231f4e..8de8afd473ae 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1356,7 +1356,7 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 	struct authenticate_message *authblob;
 	struct ksmbd_user *user;
 	char *name;
-	unsigned int auth_msg_len, name_off, name_len, secbuf_len;
+	unsigned int name_off, name_len, secbuf_len;
 
 	secbuf_len = le16_to_cpu(req->SecurityBufferLength);
 	if (secbuf_len < sizeof(struct authenticate_message)) {
@@ -1366,9 +1366,8 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 	authblob = user_authblob(conn, req);
 	name_off = le32_to_cpu(authblob->UserName.BufferOffset);
 	name_len = le16_to_cpu(authblob->UserName.Length);
-	auth_msg_len = le16_to_cpu(req->SecurityBufferOffset) + secbuf_len;
 
-	if (auth_msg_len < (u64)name_off + name_len)
+	if (secbuf_len < (u64)name_off + name_len)
 		return NULL;
 
 	name = smb_strndup_from_utf16((const char *)authblob + name_off,
-- 
2.25.1

