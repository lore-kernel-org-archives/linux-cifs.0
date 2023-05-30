Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90581C7EE23
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 12:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjE3M7i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 08:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjE3M7h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 08:59:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C726F9
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:13 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d341bdedcso3176144b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685451492; x=1688043492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FnNMAiSYagBoQy7G3Rszl8N/LirJbUlAbAH4gMgMbNs=;
        b=UjQnPs1Wc8cPWnQdlF+G7v9J1uAoKJXpcnrycrdyBA9AN+wcJR/qXE/Uj4SQpirCAl
         W+ua+h2ZypiQUM/6+XwtmHeI20S469A2ndoIzvVkHWGDJAjtmLJBQ4Ya2KoFItABt+zZ
         tk4w2GbYnNbU1ir7le5xoK+hpxZ2jKXj/KXuk+MJxurxn98Noq7lBAw0WMA4RMjks4qo
         QtG+0JgAhi7Aj7LDcRLaj9T+7YIs78vsjnFPMwkmZAnIR4L8ktlqNTWXTeHLHNa3v3UR
         clDj694FpkgKyHa3euY07XwrSNG5jed5Gep8NZdwUGINpRvQb24jBFwxnKB07W9FLpdG
         gmVA==
X-Gm-Message-State: AC+VfDwU42GzogPkx/wAeDXHwH7rKiLD4h2zT6KprBZMvvzEhGzVlalD
        Y5yCfkVCDjG7vggWKetuc9nNn2xKgJ0=
X-Google-Smtp-Source: ACHHUZ6LdYPbPOKcniKBCMf0cu3pkagQ4QoV+ZsfN6/fq30WPG1YWjjDVKFyLrMgCJ05ECqwoVotcw==
X-Received: by 2002:a05:6a00:a0b:b0:64d:42cb:42af with SMTP id p11-20020a056a000a0b00b0064d42cb42afmr2762577pfh.4.1685451492564;
        Tue, 30 May 2023 05:58:12 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c17-20020aa78c11000000b0063afb08afeesm1605007pfd.67.2023.05.30.05.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 05:58:12 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Chih-Yen Chang <cc85nod@gmail.com>
Subject: [PATCH] ksmbd: fix out-of-bound read in deassemble_neg_contexts()
Date:   Tue, 30 May 2023 21:57:54 +0900
Message-Id: <20230530125757.12910-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The check in the beginning is
`clen + sizeof(struct smb2_neg_context) <= len_of_ctxts`,
but in the end of loop, `len_of_ctxts` will subtract
`((clen + 7) & ~0x7) + sizeof(struct smb2_neg_context)`, which causes
integer underflow when clen does the 8 alignment. We should use
`(clen + 7) & ~0x7` in the check to avoid underflow from happening.

Then there are some variables that need to be declared unsigned
instead of signed.

[   11.671070] BUG: KASAN: slab-out-of-bounds in smb2_handle_negotiate+0x799/0x1610
[   11.671533] Read of size 2 at addr ffff888005e86cf2 by task kworker/0:0/7
...
[   11.673383] Call Trace:
[   11.673541]  <TASK>
[   11.673679]  dump_stack_lvl+0x33/0x50
[   11.673913]  print_report+0xcc/0x620
[   11.674671]  kasan_report+0xae/0xe0
[   11.675171]  kasan_check_range+0x35/0x1b0
[   11.675412]  smb2_handle_negotiate+0x799/0x1610
[   11.676217]  ksmbd_smb_negotiate_common+0x526/0x770
[   11.676795]  handle_ksmbd_work+0x274/0x810
...

Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
Tested-by: Chih-Yen Chang <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7a81541de602..25c0ba04c59d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -963,13 +963,13 @@ static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
 
 static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 				      struct smb2_negotiate_req *req,
-				      int len_of_smb)
+				      unsigned int len_of_smb)
 {
 	/* +4 is to account for the RFC1001 len field */
 	struct smb2_neg_context *pctx = (struct smb2_neg_context *)req;
 	int i = 0, len_of_ctxts;
-	int offset = le32_to_cpu(req->NegotiateContextOffset);
-	int neg_ctxt_cnt = le16_to_cpu(req->NegotiateContextCount);
+	unsigned int offset = le32_to_cpu(req->NegotiateContextOffset);
+	unsigned int neg_ctxt_cnt = le16_to_cpu(req->NegotiateContextCount);
 	__le32 status = STATUS_INVALID_PARAMETER;
 
 	ksmbd_debug(SMB, "decoding %d negotiate contexts\n", neg_ctxt_cnt);
@@ -983,7 +983,7 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 	while (i++ < neg_ctxt_cnt) {
 		int clen, ctxt_len;
 
-		if (len_of_ctxts < sizeof(struct smb2_neg_context))
+		if (len_of_ctxts < (int)sizeof(struct smb2_neg_context))
 			break;
 
 		pctx = (struct smb2_neg_context *)((char *)pctx + offset);
@@ -1038,9 +1038,8 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 		}
 
 		/* offsets must be 8 byte aligned */
-		clen = (clen + 7) & ~0x7;
-		offset = clen + sizeof(struct smb2_neg_context);
-		len_of_ctxts -= clen + sizeof(struct smb2_neg_context);
+		offset = (ctxt_len + 7) & ~0x7;
+		len_of_ctxts -= offset;
 	}
 	return status;
 }
-- 
2.25.1

