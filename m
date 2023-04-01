Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E63C77B6C
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Apr 2023 08:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDAIwo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Apr 2023 04:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDAIwY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Apr 2023 04:52:24 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2484726BE
        for <linux-cifs@vger.kernel.org>; Sat,  1 Apr 2023 01:50:24 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id dw14so16248358pfb.6
        for <linux-cifs@vger.kernel.org>; Sat, 01 Apr 2023 01:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680339023; x=1682931023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXseCe6Zwgs2yJ1Yqnum9z5oUSnC8fSfjQCOWfhP56M=;
        b=Rk/n3IQhqKOiHNw9kolLFFpGWI+MqbjSOff9eOhOyqMmMMoVX2o6ykiAmkmPlCtgXQ
         pVcBgNcfxpi3Wh7xDO7GUWFFeOHQmHlYGUBtWMrJ95eRUavGS4DDT0f0Zw0IxF7Sb8td
         ce3AqJUF2ve9n4Z9+wW6vPK7TrzEfuCCpZJXUk5TQFu/0xO4RxUchYV/szatmWyOkO6j
         kYgKO5USd3tiyOtnZWLIZvagIwh+ZjcNpzLhKm4m4EDwgujB8RSUUE9moE4M1pu7RvbI
         AkWd/zl7GZLjYnlfmIEAXQllqg3DfqTg98GH1EiFoCl2zY1LXpn6vxABOLy1UbAvhjm/
         yyhA==
X-Gm-Message-State: AAQBX9e9WIs1bCDh7AmO2VbM23Rxm7sP1ckvU1eXV/sZwZahd44OrjS0
        RW8SUKVoSVz7oHLpNq30eemv5KAOXuo=
X-Google-Smtp-Source: AKy350bzRQG/Ip0HRtP8Rl/C1VYxJ3OfzfKOAtbI5D3uFLR2ZhtMfeCr4J5wAgx4tBRNzM2kybPkfg==
X-Received: by 2002:aa7:8f37:0:b0:5a8:4861:af7d with SMTP id y23-20020aa78f37000000b005a84861af7dmr30801161pfr.20.1680339023337;
        Sat, 01 Apr 2023 01:50:23 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c16-20020aa78c10000000b005e5b11335b3sm3118137pfd.57.2023.04.01.01.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 01:50:22 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: delete asynchronous work from list
Date:   Sat,  1 Apr 2023 17:49:50 +0900
Message-Id: <20230401084951.6085-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When smb2_lock request is canceled by smb2_cancel or smb2_close(),
ksmbd is missing deleting async_request_entry async_requests list.
Because calling init_smb2_rsp_hdr() in smb2_lock() mark ->synchronous
as true and then it will not be deleted in
ksmbd_conn_try_dequeue_request(). This patch add release_async_work() to
release the ones allocated for async work.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c | 12 +++++-------
 fs/ksmbd/ksmbd_work.h |  2 +-
 fs/ksmbd/smb2pdu.c    | 33 +++++++++++++++++++++------------
 fs/ksmbd/smb2pdu.h    |  1 +
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 3f5dfebaa041..365ac32af505 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -112,10 +112,8 @@ void ksmbd_conn_enqueue_request(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct list_head *requests_queue = NULL;
 
-	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE) {
+	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE)
 		requests_queue = &conn->requests;
-		work->synchronous = true;
-	}
 
 	if (requests_queue) {
 		atomic_inc(&conn->req_running);
@@ -136,14 +134,14 @@ int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 
 	if (!work->multiRsp)
 		atomic_dec(&conn->req_running);
-	spin_lock(&conn->request_lock);
 	if (!work->multiRsp) {
+		spin_lock(&conn->request_lock);
 		list_del_init(&work->request_entry);
-		if (!work->synchronous)
-			list_del_init(&work->async_request_entry);
+		spin_unlock(&conn->request_lock);
+		if (work->asynchronous)
+			release_async_work(work);
 		ret = 0;
 	}
-	spin_unlock(&conn->request_lock);
 
 	wake_up_all(&conn->req_running_q);
 	return ret;
diff --git a/fs/ksmbd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
index 3234f2cf6327..f8ae6144c0ae 100644
--- a/fs/ksmbd/ksmbd_work.h
+++ b/fs/ksmbd/ksmbd_work.h
@@ -68,7 +68,7 @@ struct ksmbd_work {
 	/* Request is encrypted */
 	bool                            encrypted:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
-	bool                            synchronous:1;
+	bool                            asynchronous:1;
 	bool                            need_invalidate_rkey:1;
 
 	unsigned int                    remote_key;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 97c9d1b5bcc0..3656ccac06e3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -498,12 +498,6 @@ int init_smb2_rsp_hdr(struct ksmbd_work *work)
 	rsp_hdr->SessionId = rcv_hdr->SessionId;
 	memcpy(rsp_hdr->Signature, rcv_hdr->Signature, 16);
 
-	work->synchronous = true;
-	if (work->async_id) {
-		ksmbd_release_id(&conn->async_ida, work->async_id);
-		work->async_id = 0;
-	}
-
 	return 0;
 }
 
@@ -644,7 +638,7 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 		pr_err("Failed to alloc async message id\n");
 		return id;
 	}
-	work->synchronous = false;
+	work->asynchronous = true;
 	work->async_id = id;
 	rsp_hdr->Id.AsyncId = cpu_to_le64(id);
 
@@ -664,6 +658,24 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 	return 0;
 }
 
+void release_async_work(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+
+	spin_lock(&conn->request_lock);
+	list_del_init(&work->async_request_entry);
+	spin_unlock(&conn->request_lock);
+
+	work->asynchronous = 0;
+	work->cancel_fn = NULL;
+	kfree(work->cancel_argv);
+	work->cancel_argv = NULL;
+	if (work->async_id) {
+		ksmbd_release_id(&conn->async_ida, work->async_id);
+		work->async_id = 0;
+	}
+}
+
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
@@ -7045,13 +7057,9 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_vfs_posix_lock_wait(flock);
 
-				spin_lock(&work->conn->request_lock);
 				spin_lock(&fp->f_lock);
 				list_del(&work->fp_entry);
-				work->cancel_fn = NULL;
-				kfree(argv);
 				spin_unlock(&fp->f_lock);
-				spin_unlock(&work->conn->request_lock);
 
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
@@ -7069,6 +7077,7 @@ int smb2_lock(struct ksmbd_work *work)
 						work->send_no_response = 1;
 						goto out;
 					}
+
 					init_smb2_rsp_hdr(work);
 					smb2_set_err_rsp(work);
 					rsp->hdr.Status =
@@ -7081,7 +7090,7 @@ int smb2_lock(struct ksmbd_work *work)
 				spin_lock(&work->conn->llist_lock);
 				list_del(&smb_lock->clist);
 				spin_unlock(&work->conn->llist_lock);
-
+				release_async_work(work);
 				goto retry;
 			} else if (!rc) {
 				spin_lock(&work->conn->llist_lock);
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 0c8a770fe318..9420dd2813fb 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -486,6 +486,7 @@ int find_matching_smb2_dialect(int start_index, __le16 *cli_dialects,
 struct file_lock *smb_flock_init(struct file *f);
 int setup_async_work(struct ksmbd_work *work, void (*fn)(void **),
 		     void **arg);
+void release_async_work(struct ksmbd_work *work);
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status);
 struct channel *lookup_chann_list(struct ksmbd_session *sess,
 				  struct ksmbd_conn *conn);
-- 
2.25.1

