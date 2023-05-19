Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168E2C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 19 May 2023 14:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjESOPe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 May 2023 10:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjESOPY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 May 2023 10:15:24 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1936C12C
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 07:15:20 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1ae4d1d35e6so24892565ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 07:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684505719; x=1687097719;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6hH5LoAPzLRuNwQSivPUT9RGZEJq6cymw3Y+qmHiKk=;
        b=cZC4bjc9Bo+oKXiH0sbWIXquXz/r5RBHXV0HdtjW1wNs/Gr0bU3akcksmUoufGFQDZ
         42muYvla3yTXlT0L9W2VflpebKsdCJzUHhgL/6jsVDa/+vlj6ey8lYzLs50R6+pT61tA
         1b9l/xrkNszO3BBaskRcB/9IpZA+hmWIVn/SACUc/z6ruGk5+k0R6WThvhXRrCM9Ihtl
         KBVXyf1TmgOlbTRt8P8FA72AgW/WTpt9639TZ6cMevbO0RUbIIgGhIk/fG2fkqU1PGcA
         JJ0magMBchEs54LHQcu/Y/a6Vp+hoXIaK70SNm8B93hxAkUjo5PWMW0vrbmyZ79bDVPa
         42KA==
X-Gm-Message-State: AC+VfDxWGVSf3pt0balbjRXgegvvJS3/j4KqmVdZrwgz7blTyhY6YPUp
        jbYonmgfzD2Agg6bKSEurOYmig8M09c=
X-Google-Smtp-Source: ACHHUZ5ZeuuSr3VpppSYxFJiiMvXfn29hUc5j3mU9By+BJXEYASn2G7ZDsMtzGCTODLPYZvZ00OrWA==
X-Received: by 2002:a17:903:4ca:b0:1a6:b23c:3bf2 with SMTP id jm10-20020a17090304ca00b001a6b23c3bf2mr2810087plb.10.1684505719225;
        Fri, 19 May 2023 07:15:19 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id ba9-20020a170902720900b001ac7af58b66sm3489409plb.224.2023.05.19.07.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 07:15:18 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Per Forlin <per.forlin@axis.com>
Subject: [PATCH] ksmbd: fix UAF issue from opinfo->conn
Date:   Fri, 19 May 2023 23:15:07 +0900
Message-Id: <20230519141508.12694-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If opinfo->conn is another connection and while ksmbd send oplock break
request to cient on current connection, The connection for opinfo->conn
can be disconnect and conn could be freed. When sending oplock break
request, this ksmbd_conn can be used and cause user-after-free issue.
When getting opinfo from the list, ksmbd check connection is being
released. If it is not released, Increase ->r_count to wait that connection
is freed.

Reported-by: Per Forlin <per.forlin@axis.com>
Tested-by: Per Forlin <per.forlin@axis.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c | 72 +++++++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 25 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 6d1ccb999893..db181bdad73a 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -157,13 +157,42 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 	rcu_read_lock();
 	opinfo = list_first_or_null_rcu(&ci->m_op_list, struct oplock_info,
 					op_entry);
-	if (opinfo && !atomic_inc_not_zero(&opinfo->refcount))
-		opinfo = NULL;
+	if (opinfo) {
+		if (!atomic_inc_not_zero(&opinfo->refcount))
+			opinfo = NULL;
+		else {
+			atomic_inc(&opinfo->conn->r_count);
+			if (ksmbd_conn_releasing(opinfo->conn)) {
+				atomic_dec(&opinfo->conn->r_count);
+				atomic_dec(&opinfo->refcount);
+				opinfo = NULL;
+			}
+		}
+	}
+
 	rcu_read_unlock();
 
 	return opinfo;
 }
 
+static void opinfo_conn_put(struct oplock_info *opinfo)
+{
+	struct ksmbd_conn *conn;
+
+	if (!opinfo)
+		return;
+
+	conn = opinfo->conn;
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
+	opinfo_put(opinfo);
+}
+
 void opinfo_put(struct oplock_info *opinfo)
 {
 	if (!atomic_dec_and_test(&opinfo->refcount))
@@ -666,13 +695,6 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 
 out:
 	ksmbd_free_work_struct(work);
-	/*
-	 * Checking waitqueue to dropping pending requests on
-	 * disconnection. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
-		wake_up(&conn->r_count_q);
 }
 
 /**
@@ -706,7 +728,6 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	work->conn = conn;
 	work->sess = opinfo->sess;
 
-	atomic_inc(&conn->r_count);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
@@ -776,13 +797,6 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 
 out:
 	ksmbd_free_work_struct(work);
-	/*
-	 * Checking waitqueue to dropping pending requests on
-	 * disconnection. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
-		wake_up(&conn->r_count_q);
 }
 
 /**
@@ -822,7 +836,6 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	work->conn = conn;
 	work->sess = opinfo->sess;
 
-	atomic_inc(&conn->r_count);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
 		list_for_each_safe(tmp, t, &opinfo->interim_list) {
 			struct ksmbd_work *in_work;
@@ -1144,8 +1157,10 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	}
 	prev_opinfo = opinfo_get_list(ci);
 	if (!prev_opinfo ||
-	    (prev_opinfo->level == SMB2_OPLOCK_LEVEL_NONE && lctx))
+	    (prev_opinfo->level == SMB2_OPLOCK_LEVEL_NONE && lctx)) {
+		opinfo_conn_put(prev_opinfo);
 		goto set_lev;
+	}
 	prev_op_has_lease = prev_opinfo->is_lease;
 	if (prev_op_has_lease)
 		prev_op_state = prev_opinfo->o_lease->state;
@@ -1153,19 +1168,19 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (share_ret < 0 &&
 	    prev_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		err = share_ret;
-		opinfo_put(prev_opinfo);
+		opinfo_conn_put(prev_opinfo);
 		goto err_out;
 	}
 
 	if (prev_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    prev_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		opinfo_put(prev_opinfo);
+		opinfo_conn_put(prev_opinfo);
 		goto op_break_not_needed;
 	}
 
 	list_add(&work->interim_entry, &prev_opinfo->interim_list);
 	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II);
-	opinfo_put(prev_opinfo);
+	opinfo_conn_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
 	/* Check all oplock was freed by close */
@@ -1228,14 +1243,14 @@ static void smb_break_all_write_oplock(struct ksmbd_work *work,
 		return;
 	if (brk_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    brk_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		opinfo_put(brk_opinfo);
+		opinfo_conn_put(brk_opinfo);
 		return;
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
 	list_add(&work->interim_entry, &brk_opinfo->interim_list);
 	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II);
-	opinfo_put(brk_opinfo);
+	opinfo_conn_put(brk_opinfo);
 }
 
 /**
@@ -1263,6 +1278,13 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 	list_for_each_entry_rcu(brk_op, &ci->m_op_list, op_entry) {
 		if (!atomic_inc_not_zero(&brk_op->refcount))
 			continue;
+
+		atomic_inc(&brk_op->conn->r_count);
+		if (ksmbd_conn_releasing(brk_op->conn)) {
+			atomic_dec(&brk_op->conn->r_count);
+			continue;
+		}
+
 		rcu_read_unlock();
 		if (brk_op->is_lease && (brk_op->o_lease->state &
 		    (~(SMB2_LEASE_READ_CACHING_LE |
@@ -1292,7 +1314,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		brk_op->open_trunc = is_trunc;
 		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE);
 next:
-		opinfo_put(brk_op);
+		opinfo_conn_put(brk_op);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.25.1

