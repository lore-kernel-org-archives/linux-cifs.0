Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E20CCA48A
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 03:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiGVDEN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 23:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiGVDEL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 23:04:11 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACB289A91
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:11 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id bk6-20020a17090b080600b001f2138a2a7bso5544410pjb.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nA6OYGxKzEWRIa/9Kse+cAqOlRxYs4hm86Do5wpyIeI=;
        b=a41IO4BN5T2W9gog1bHIfE0PcR6yQS1gc3cOslyJZ2pL58HLQfa8EiaJ/vuB4nKT2a
         8P3a7x+GpyCyAP7PRjgHHuUuSZUDe1OGSeuNCFmUFiHneg4DR5e3sffI2go6PLggZCjn
         M7RgRrUhsCBjgB6ufJrMXKSGCX4EnEDq1wV8FuusKkpYo1K2zNaCERlqJmahqVtbrWYz
         7rvVAGuj5iqq32XRtkI5T8unYzDwB/YYk/9TTdTf/vheeYQL9Zv2jpG2m+WPQ2greIDl
         rb5fqtW8f/g60ypn7RUSoorx7YKz2yWLfQxm5Hnf5AqKSRAeQqFM05wh5yh/i1FgDGHb
         MmEA==
X-Gm-Message-State: AJIora81VTlXpN29OZC+NdyHqbvLNkr397B2QxPpOpTtNiI7O8pYnCDV
        i6mRhG0OoeE9zJz3baDUm4bJbx+fWO8=
X-Google-Smtp-Source: AGRyM1uJIL7Jtuhok9wVMLPEBN1g706pp2ZGZFKAUlqLAqdVESUIxI7u22PXdrjb273DswzJeCT+YA==
X-Received: by 2002:a17:903:31d1:b0:16d:2a5e:693f with SMTP id v17-20020a17090331d100b0016d2a5e693fmr1322613ple.154.1658459050182;
        Thu, 21 Jul 2022 20:04:10 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090a1d0a00b001f216407204sm2115450pjd.36.2022.07.21.20.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 20:04:09 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/5] ksmbd: fix kernel oops from idr_remove()
Date:   Fri, 22 Jul 2022 12:03:44 +0900
Message-Id: <20220722030346.28534-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722030346.28534-1-linkinjeon@kernel.org>
References: <20220722030346.28534-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a report that kernel oops happen from idr_remove().

kernel: BUG: kernel NULL pointer dereference, address: 0000000000000010
kernel: RIP: 0010:idr_remove+0x1/0x20
kernel:  __ksmbd_close_fd+0xb2/0x2d0 [ksmbd]
kernel:  ksmbd_vfs_read+0x91/0x190 [ksmbd]
kernel:  ksmbd_fd_put+0x29/0x40 [ksmbd]
kernel:  smb2_read+0x210/0x390 [ksmbd]
kernel:  __process_request+0xa4/0x180 [ksmbd]
kernel:  __handle_ksmbd_work+0xf0/0x290 [ksmbd]
kernel:  handle_ksmbd_work+0x2d/0x50 [ksmbd]
kernel:  process_one_work+0x21d/0x3f0
kernel:  worker_thread+0x50/0x3d0
kernel:  rescuer_thread+0x390/0x390
kernel:  kthread+0xee/0x120
kthread_complete_and_exit+0x20/0x20
kernel:  ret_from_fork+0x22/0x30

While accessing files, If connection is disconnected, windows send
session setup request included previous session destroy. But while still
processing requests on previous session, this request destroy file
table, which mean file table idr will be freed and set to NULL.
So kernel oops happen from ft->idr in __ksmbd_close_fd().
This patch don't directly destroy session in destroy_previous_session().
It just set to KSMBD_SESS_EXITING so that connection will be
terminated after finishing the rest of requests.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/mgmt/user_session.c | 2 ++
 fs/ksmbd/smb2pdu.c           | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 25e9ba3b7550..b9acb6770b03 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -239,6 +239,8 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 	sess = ksmbd_session_lookup(conn, id);
 	if (!sess && conn->binding)
 		sess = ksmbd_session_lookup_slowpath(id);
+	if (sess && sess->state != SMB2_SESSION_VALID)
+		sess = NULL;
 	return sess;
 }
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 5a0328a070dc..ae5677a66cb2 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -593,6 +593,7 @@ static void destroy_previous_session(struct ksmbd_conn *conn,
 {
 	struct ksmbd_session *prev_sess = ksmbd_session_lookup_slowpath(id);
 	struct ksmbd_user *prev_user;
+	struct channel *chann;
 
 	if (!prev_sess)
 		return;
@@ -608,8 +609,11 @@ static void destroy_previous_session(struct ksmbd_conn *conn,
 	}
 
 	put_session(prev_sess);
-	xa_erase(&conn->sessions, prev_sess->id);
-	ksmbd_session_destroy(prev_sess);
+	prev_sess->state = SMB2_SESSION_EXPIRED;
+	write_lock(&prev_sess->chann_lock);
+	list_for_each_entry(chann, &prev_sess->ksmbd_chann_list, chann_list)
+		chann->conn->status = KSMBD_SESS_EXITING;
+	write_unlock(&prev_sess->chann_lock);
 }
 
 /**
-- 
2.25.1

