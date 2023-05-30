Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649A8C7EE2F
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 13:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjE3NAE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 09:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjE3NAD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 09:00:03 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A04127
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:40 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-64d44b198baso3022071b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685451497; x=1688043497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpDRXdHm0h78ohDmltjWdcN9Fe7T0riwP8LaYasdf7w=;
        b=M11y3gv1ybw0WoKx2g+kUGBnJPawj9zyx3Yq4KPdCl0mC3j+RattQ5nz4q7Sw68ArQ
         h1vqjNN5cdRSK9M3atvdxrVrLaiGt8vs3HbeTVxnjrLIYmVQzwkOV7/8EzE+2F0ELBV3
         4aF5ZtXZoUmuLsAI5+Va/CJpFZ2CGlM9PwmKamqP/Hby2YbyOrfsxdWn4coimfOdQoGZ
         PhX8A/SuquWF7gSgRtwbZXTLqp3XOZBqfA9hHoAClu6+OVegU8uCpTS/GrpiEDrJUV7i
         jr67rXOjjhzXzbI66l/a0x+alSS1qGnQJMph2wv+nvcWO5af2i8YV8AVIg/CjYRymZgu
         sf2A==
X-Gm-Message-State: AC+VfDyk9+iwSILxu2khFGmEQeHgp/vl70MaIemXwnu3jSpfUCMRtUv4
        SGvAMB2rFRa8kypdSdOgxiFFnohy39U=
X-Google-Smtp-Source: ACHHUZ7sxr5h1c9Fi2YKL4cBQclvtBzHxNWTU/Q2Pt0kdCjSn/X7FUOL+VJowc18ZdJgxS1n78QfTg==
X-Received: by 2002:a05:6a00:2393:b0:64d:2a87:2596 with SMTP id f19-20020a056a00239300b0064d2a872596mr3698793pfc.10.1685451496698;
        Tue, 30 May 2023 05:58:16 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c17-20020aa78c11000000b0063afb08afeesm1605007pfd.67.2023.05.30.05.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 05:58:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Chih-Yen Chang <cc85nod@gmail.com>
Subject: [PATCH] ksmbd: fix out-of-bound read in parse_lease_state()
Date:   Tue, 30 May 2023 21:57:55 +0900
Message-Id: <20230530125757.12910-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530125757.12910-1-linkinjeon@kernel.org>
References: <20230530125757.12910-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This bug is in parse_lease_state, and it is caused by the missing check
of `struct create_context`. When the ksmbd traverses the create_contexts,
it doesn't check if the field of `NameOffset` and `Next` is valid,
The KASAN message is following:

[    6.664323] BUG: KASAN: slab-out-of-bounds in parse_lease_state+0x7d/0x280
[    6.664738] Read of size 2 at addr ffff888005c08988 by task kworker/0:3/103
...
[    6.666644] Call Trace:
[    6.666796]  <TASK>
[    6.666933]  dump_stack_lvl+0x33/0x50
[    6.667167]  print_report+0xcc/0x620
[    6.667903]  kasan_report+0xae/0xe0
[    6.668374]  kasan_check_range+0x35/0x1b0
[    6.668621]  parse_lease_state+0x7d/0x280
[    6.668868]  smb2_open+0xbe8/0x4420
[    6.675137]  handle_ksmbd_work+0x282/0x820

Use smb2_find_context_vals() to find smb2 create request lease context.
smb2_find_context_vals validate create context fields.

Reported-by: Chih-Yen Chang <cc85nod@gmail.com>
Tested-by: Chih-Yen Chang <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 66 +++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index db181bdad73a..844b303baf29 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1415,56 +1415,38 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
  */
 struct lease_ctx_info *parse_lease_state(void *open_req)
 {
-	char *data_offset;
 	struct create_context *cc;
-	unsigned int next = 0;
-	char *name;
-	bool found = false;
 	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
-	struct lease_ctx_info *lreq = kzalloc(sizeof(struct lease_ctx_info),
-		GFP_KERNEL);
+	struct lease_ctx_info *lreq;
+
+	cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
+	if (IS_ERR_OR_NULL(cc))
+		return NULL;
+
+	lreq = kzalloc(sizeof(struct lease_ctx_info), GFP_KERNEL);
 	if (!lreq)
 		return NULL;
 
-	data_offset = (char *)req + le32_to_cpu(req->CreateContextsOffset);
-	cc = (struct create_context *)data_offset;
-	do {
-		cc = (struct create_context *)((char *)cc + next);
-		name = le16_to_cpu(cc->NameOffset) + (char *)cc;
-		if (le16_to_cpu(cc->NameLength) != 4 ||
-		    strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
-			next = le32_to_cpu(cc->Next);
-			continue;
-		}
-		found = true;
-		break;
-	} while (next != 0);
+	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
+		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
-	if (found) {
-		if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
-			struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
-
-			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-			lreq->req_state = lc->lcontext.LeaseState;
-			lreq->flags = lc->lcontext.LeaseFlags;
-			lreq->duration = lc->lcontext.LeaseDuration;
-			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
-			       SMB2_LEASE_KEY_SIZE);
-			lreq->version = 2;
-		} else {
-			struct create_lease *lc = (struct create_lease *)cc;
+		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
+		lreq->req_state = lc->lcontext.LeaseState;
+		lreq->flags = lc->lcontext.LeaseFlags;
+		lreq->duration = lc->lcontext.LeaseDuration;
+		memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+				SMB2_LEASE_KEY_SIZE);
+		lreq->version = 2;
+	} else {
+		struct create_lease *lc = (struct create_lease *)cc;
 
-			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-			lreq->req_state = lc->lcontext.LeaseState;
-			lreq->flags = lc->lcontext.LeaseFlags;
-			lreq->duration = lc->lcontext.LeaseDuration;
-			lreq->version = 1;
-		}
-		return lreq;
+		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
+		lreq->req_state = lc->lcontext.LeaseState;
+		lreq->flags = lc->lcontext.LeaseFlags;
+		lreq->duration = lc->lcontext.LeaseDuration;
+		lreq->version = 1;
 	}
-
-	kfree(lreq);
-	return NULL;
+	return lreq;
 }
 
 /**
-- 
2.25.1

