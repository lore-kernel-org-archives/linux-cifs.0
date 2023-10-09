Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9412CE95A95
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Oct 2023 15:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376413AbjJIPMW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376407AbjJIPMV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Oct 2023 11:12:21 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C76C5
        for <linux-cifs@vger.kernel.org>; Mon,  9 Oct 2023 08:12:15 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3af8b498d30so2651210b6e.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Oct 2023 08:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864334; x=1697469134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OUZ/RcL9St8MgfbQHX7Mi0TJ70Jap2ZFfNVW08HwPP0=;
        b=P2CBc5fSdxPj1GNaOJYMylifVll3yGkpkvKEBynI0qNIb7x1puUxLo8nm0/cN4IU2b
         F/VHxD2zabmAs9gGEgRk9U1puI2pamqOL5sprfGiKCIyOQrnLfckYl7k2zYi5XkdeXdj
         GdZYlU+wQZJcBGi7NTDssyb12RDiTWJk4iePq93uCAvNQGgpUZUq0JQpklNQ/XyQ5Dx+
         fTgseRIU3gkQjyd0kJb0xzO+kL1CA1A6I2g+zaDQKaoS+E1TsHJvGkUFgcMd3OPFmNc8
         qYbVX8crFj3hmPujpo/DCyJmzKhRVcGQOWTkvcZtdYl+MtC8JXADjKwruqrBcdWqPMgD
         Ahuw==
X-Gm-Message-State: AOJu0YwpWhxN/N5NCcKQ+gvWwBRYIRO/mW8LsMj4EVVoJWY87mPHIVcF
        bEV/BiBxtMUogozJ3mUbmYNtUVbXo4A=
X-Google-Smtp-Source: AGHT+IF0v/rdC3MZ8+L23ih3W66KDV2QLpXxkohqty4RfBdccv14UCY4XnqdZl4ETS8VNnN17P8Jug==
X-Received: by 2002:a05:6358:e48c:b0:143:7cc8:70b1 with SMTP id by12-20020a056358e48c00b001437cc870b1mr10917334rwb.6.1696864333983;
        Mon, 09 Oct 2023 08:12:13 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id mp3-20020a17090b190300b00267d9f4d340sm10529284pjb.44.2023.10.09.08.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:12:13 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: reorganize ksmbd_iov_pin_rsp()
Date:   Tue, 10 Oct 2023 00:11:51 +0900
Message-Id: <20231009151153.7360-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009151153.7360-1-linkinjeon@kernel.org>
References: <20231009151153.7360-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ksmbd_iov_pin_rsp fail, io vertor should be rollback.
This patch moves memory allocations to before setting the io vector
to avoid rollbacks.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 43 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 51def3ca74c0..a2ed441e837a 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -95,11 +95,28 @@ bool ksmbd_queue_work(struct ksmbd_work *work)
 	return queue_work(ksmbd_wq, &work->work);
 }
 
-static int ksmbd_realloc_iov_pin(struct ksmbd_work *work, void *ib,
-				 unsigned int ib_len)
+static inline void __ksmbd_iov_pin(struct ksmbd_work *work, void *ib,
+				   unsigned int ib_len)
 {
+	work->iov[++work->iov_idx].iov_base = ib;
+	work->iov[work->iov_idx].iov_len = ib_len;
+	work->iov_cnt++;
+}
+
+static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
+			       void *aux_buf, unsigned int aux_size)
+{
+	struct aux_read *ar;
+	int need_iov_cnt = 1;
 
-	if (work->iov_alloc_cnt <= work->iov_cnt) {
+	if (aux_size) {
+		need_iov_cnt++;
+		ar = kmalloc(sizeof(struct aux_read), GFP_KERNEL);
+		if (!ar)
+			return -ENOMEM;
+	}
+
+	if (work->iov_alloc_cnt < work->iov_cnt + need_iov_cnt) {
 		struct kvec *new;
 
 		work->iov_alloc_cnt += 4;
@@ -111,16 +128,6 @@ static int ksmbd_realloc_iov_pin(struct ksmbd_work *work, void *ib,
 		work->iov = new;
 	}
 
-	work->iov[++work->iov_idx].iov_base = ib;
-	work->iov[work->iov_idx].iov_len = ib_len;
-	work->iov_cnt++;
-
-	return 0;
-}
-
-static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
-			       void *aux_buf, unsigned int aux_size)
-{
 	/* Plus rfc_length size on first iov */
 	if (!work->iov_idx) {
 		work->iov[work->iov_idx].iov_base = work->response_buf;
@@ -129,19 +136,13 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 		work->iov_cnt++;
 	}
 
-	ksmbd_realloc_iov_pin(work, ib, len);
+	__ksmbd_iov_pin(work, ib, len);
 	inc_rfc1001_len(work->iov[0].iov_base, len);
 
 	if (aux_size) {
-		struct aux_read *ar;
-
-		ksmbd_realloc_iov_pin(work, aux_buf, aux_size);
+		__ksmbd_iov_pin(work, aux_buf, aux_size);
 		inc_rfc1001_len(work->iov[0].iov_base, aux_size);
 
-		ar = kmalloc(sizeof(struct aux_read), GFP_KERNEL);
-		if (!ar)
-			return -ENOMEM;
-
 		ar->buf = aux_buf;
 		list_add(&ar->entry, &work->aux_read_list);
 	}
-- 
2.25.1

