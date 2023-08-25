Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC746C7EE2C
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Aug 2023 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbjHYOtu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343917AbjHYOtn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Aug 2023 10:49:43 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863632123
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 07:49:41 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bc5acc627dso8291265ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 07:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692974980; x=1693579780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSnkPrvkw2nAyl+/q49FXKUyvEQvfLcqmGYj81ZWOLU=;
        b=WDfYmYD0v372KX/mTs419esUXYg/TzpYj2tjIKGjuZWCIMyhKlzJBjZ2ily6p+3nFn
         b3WmDJKcNgEOk6NHs9vqTj+8wODkLoTKHte1NLF4+QEpVvAYNcLLAjJsw1k4UK2EMB3V
         ubugM3UewucPHx30o8rUdNWQ6ELbDBIWjDu0D2/OEKzZod2ZT5crcHDJLeWD/lE+BPs/
         k8YencgFUpWTSh5+cFqsOho/eQ4Iyq6d94x5uOADJ3Z2H3Yd/H7KAXG5lXhAQVe7tlcf
         1QhkbtwoJi/in/cDgpLFwCDIIyk4SwbA/tvRy7OTSM3AbBFDUTjNjIvyqlRHwLSgWlDy
         HRHw==
X-Gm-Message-State: AOJu0YzV7r4O+XVV02NebVPw6GyYKa12YAJqk7ZQGp+oj9n4nQ150Jso
        +t72AvcGjJsQ9Yq+y3t9pbvblbRsTUk=
X-Google-Smtp-Source: AGHT+IEuQ2v9vzNWarE5g6SKefrpej7FfxHSfUtihxBhjs2ZJXlMLeCE9TRGCog51iXGvBQJynojbQ==
X-Received: by 2002:a17:902:b602:b0:1bd:f378:b1a8 with SMTP id b2-20020a170902b60200b001bdf378b1a8mr16690472pls.11.1692974980585;
        Fri, 25 Aug 2023 07:49:40 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id jh12-20020a170903328c00b001bee782a1desm1798020plb.181.2023.08.25.07.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 07:49:39 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: replace one-element array with flex-array member in struct smb2_ea_info
Date:   Fri, 25 Aug 2023 23:48:48 +0900
Message-Id: <20230825144848.9034-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230825144848.9034-1-linkinjeon@kernel.org>
References: <20230825144848.9034-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

UBSAN complains about out-of-bounds array indexes on 1-element arrays in
struct smb2_ea_info.

UBSAN: array-index-out-of-bounds in fs/smb/server/smb2pdu.c:4335:15
index 1 is out of range for type 'char [1]'
CPU: 1 PID: 354 Comm: kworker/1:4 Not tainted 6.5.0-rc4 #1
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop
Reference Platform, BIOS 6.00 07/22/2020
Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
Call Trace:
 <TASK>
 __dump_stack linux/lib/dump_stack.c:88
 dump_stack_lvl+0x48/0x70 linux/lib/dump_stack.c:106
 dump_stack+0x10/0x20 linux/lib/dump_stack.c:113
 ubsan_epilogue linux/lib/ubsan.c:217
 __ubsan_handle_out_of_bounds+0xc6/0x110 linux/lib/ubsan.c:348
 smb2_get_ea linux/fs/smb/server/smb2pdu.c:4335
 smb2_get_info_file linux/fs/smb/server/smb2pdu.c:4900
 smb2_query_info+0x63ae/0x6b20 linux/fs/smb/server/smb2pdu.c:5275
 __process_request linux/fs/smb/server/server.c:145
 __handle_ksmbd_work linux/fs/smb/server/server.c:213
 handle_ksmbd_work+0x348/0x10b0 linux/fs/smb/server/server.c:266
 process_one_work+0x85a/0x1500 linux/kernel/workqueue.c:2597
 worker_thread+0xf3/0x13a0 linux/kernel/workqueue.c:2748
 kthread+0x2b7/0x390 linux/kernel/kthread.c:389
 ret_from_fork+0x44/0x90 linux/arch/x86/kernel/process.c:145
 ret_from_fork_asm+0x1b/0x30 linux/arch/x86/entry/entry_64.S:304
 </TASK>

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 fs/smb/server/smb2pdu.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2d4b8efaf19f..d12d995f52d7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4335,7 +4335,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
 			name_len -= XATTR_USER_PREFIX_LEN;
 
-		ptr = (char *)(&eainfo->name + name_len + 1);
+		ptr = eainfo->name + name_len + 1;
 		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
 				name_len + 1);
 		/* bailout if xattr can't fit in buf_free_len */
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 2767c08a534a..d12cfd3b0927 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -361,7 +361,7 @@ struct smb2_ea_info {
 	__u8   Flags;
 	__u8   EaNameLength;
 	__le16 EaValueLength;
-	char name[1];
+	char name[];
 	/* optionally followed by value */
 } __packed; /* level 15 Query */
 
-- 
2.25.1

