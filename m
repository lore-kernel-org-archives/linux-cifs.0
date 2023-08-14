Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CF9C04A94
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Aug 2023 15:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjHNPXm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Aug 2023 11:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjHNPXT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Aug 2023 11:23:19 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C7210D1
        for <linux-cifs@vger.kernel.org>; Mon, 14 Aug 2023 08:23:17 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bd9b4f8e0eso25294275ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 14 Aug 2023 08:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692026597; x=1692631397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNBvndmEJsGon6cQf8ym/l5WB1Wrp8glkW4VogYBnjI=;
        b=PFNzomt0KjWTaJgPwg+3QAN7PPvX1eaGB+MugHXqAWGK7FBnsX59Vjt+hA7CtHSLtg
         7/ehx1bA9UC5cASwvofNBaRH9yxKJpAEiiDVpmZm+1qh1Y8yYIdHEQkkrJ4pTtakLCEH
         hIJeLMLQjaxq+m/wbNJdgFXgJ8QJObppw5TeoX4Vf6EHugCQmJ3dFfPsOE2fN1IzYzQy
         BSPgSGujrU52WLCG+vpK0HiBvzlPzagpr4DQa4rVbh2CbErhHQApkWYA6wfmCA5r0U8Z
         /NPd0HgNWvjUimYOVjJU/QoTKded6osiAq3bOTctDSpNFoAE13oTysyN3L1W14MBVxQd
         DlZA==
X-Gm-Message-State: AOJu0YyuT9x6uEIGr6SQY3848BOKRM5RIuOkV4hz0IBMXSGR/570HN/n
        dB/Z7JMTa9kx4HEzjrIcUcJl7UCioso=
X-Google-Smtp-Source: AGHT+IHTtrlFn7Zw5AJvEJlLVWoz/yZkeF/GvzO4ZUvyV5xJkpniAzx+OzSIM0EjC/gDGnKaSubKNA==
X-Received: by 2002:a17:902:f68a:b0:1b6:bced:1dc2 with SMTP id l10-20020a170902f68a00b001b6bced1dc2mr10043411plg.0.1692026596591;
        Mon, 14 Aug 2023 08:23:16 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id ij13-20020a170902ab4d00b001b9c5e07bc3sm9726244plb.238.2023.08.14.08.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 08:23:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: fix wrong interim response on compound
Date:   Tue, 15 Aug 2023 00:19:03 +0900
Message-Id: <20230814151903.7931-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814151903.7931-1-linkinjeon@kernel.org>
References: <20230814151903.7931-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If smb2_lock or smb2_open request is compound, ksmbd could send wrong
interim response to client. ksmbd allocate new interim buffer instead of
using resonse buffer to support compound request.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 10 ++++++----
 fs/smb/server/ksmbd_work.h |  2 +-
 fs/smb/server/oplock.c     | 14 ++------------
 fs/smb/server/smb2pdu.c    | 24 ++++++++++++++++--------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 3fc88974346e..c7a72d843c5d 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -159,9 +159,11 @@ int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 	return __ksmbd_iov_pin_rsp(work, ib, len, aux_buf, aux_size);
 }
 
-void ksmbd_iov_reset(struct ksmbd_work *work)
+int allocate_interim_rsp_buf(struct ksmbd_work *work)
 {
-	work->iov_idx = 0;
-	work->iov_cnt = 0;
-	*(__be32 *)work->iov[0].iov_base = 0;
+	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, GFP_KERNEL);
+	if (!work->response_buf)
+		return -ENOMEM;
+	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
+	return 0;
 }
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 255157eb26dc..8ca2c813246e 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -131,5 +131,5 @@ bool ksmbd_queue_work(struct ksmbd_work *work);
 int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 			   void *aux_buf, unsigned int aux_size);
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len);
-void ksmbd_iov_reset(struct ksmbd_work *work);
+int allocate_interim_rsp_buf(struct ksmbd_work *work);
 #endif /* __KSMBD_WORK_H__ */
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index c42b2cff6146..6bc8a1e48171 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -616,15 +616,6 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 	return 0;
 }
 
-static inline int allocate_oplock_break_buf(struct ksmbd_work *work)
-{
-	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, GFP_KERNEL);
-	if (!work->response_buf)
-		return -ENOMEM;
-	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
-	return 0;
-}
-
 /**
  * __smb2_oplock_break_noti() - send smb2 oplock break cmd from conn
  * to client
@@ -647,7 +638,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	if (!fp)
 		goto out;
 
-	if (allocate_oplock_break_buf(work)) {
+	if (allocate_interim_rsp_buf(work)) {
 		pr_err("smb2_allocate_rsp_buf failed! ");
 		ksmbd_fd_put(work, fp);
 		goto out;
@@ -752,7 +743,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	struct lease_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 
-	if (allocate_oplock_break_buf(work)) {
+	if (allocate_interim_rsp_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
 		goto out;
 	}
@@ -843,7 +834,6 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
 			list_del(&in_work->interim_entry);
-			ksmbd_iov_reset(in_work);
 		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 98b923d2af48..c6b07c6559dc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -151,7 +151,7 @@ void smb2_set_err_rsp(struct ksmbd_work *work)
 		err_rsp->ByteCount = 0;
 		err_rsp->ErrorData[0] = 0;
 		ksmbd_iov_pin_rsp(work, (void *)err_rsp,
-				  work->conn->vals->header_size +
+				  __SMB2_HEADER_STRUCTURE_SIZE +
 				  SMB2_ERROR_STRUCTURE_SIZE2);
 	}
 }
@@ -705,13 +705,24 @@ void release_async_work(struct ksmbd_work *work)
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
+	struct ksmbd_work *in_work = ksmbd_alloc_work_struct();
 
-	rsp_hdr = ksmbd_resp_buf_next(work);
-	smb2_set_err_rsp(work);
+	if (allocate_interim_rsp_buf(in_work)) {
+		pr_err("smb_allocate_rsp_buf failed!\n");
+		ksmbd_free_work_struct(in_work);
+		return;
+	}
+
+	in_work->conn = work->conn;
+	memcpy(smb2_get_msg(in_work->response_buf), ksmbd_resp_buf_next(work),
+	       __SMB2_HEADER_STRUCTURE_SIZE);
+
+	rsp_hdr = smb2_get_msg(in_work->response_buf);
+	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-	ksmbd_conn_write(work);
-	rsp_hdr->Status = 0;
+	ksmbd_conn_write(in_work);
+	ksmbd_free_work_struct(in_work);
 }
 
 static __le32 smb2_get_reparse_tag_special_file(umode_t mode)
@@ -7043,8 +7054,6 @@ int smb2_lock(struct ksmbd_work *work)
 				list_del(&work->fp_entry);
 				spin_unlock(&fp->f_lock);
 
-				ksmbd_iov_reset(work);
-
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
 					spin_lock(&work->conn->llist_lock);
@@ -7062,7 +7071,6 @@ int smb2_lock(struct ksmbd_work *work)
 						goto out;
 					}
 
-					init_smb2_rsp_hdr(work);
 					rsp->hdr.Status =
 						STATUS_RANGE_NOT_LOCKED;
 					kfree(smb_lock);
-- 
2.25.1

