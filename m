Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ECBCCA487
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 03:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiGVDEM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 23:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiGVDEI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 23:04:08 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC2D89A91
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:08 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id p8so3488266plq.13
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YyokJFzTX0KIJLFd7mHrhgJ/G8oqFq0bM+rgDFwjn20=;
        b=OryRVwJ4UWGIP5aOFx29GGhpK4Chrt/v/BWvqS7Yl8dT7D1CeNIf9DJUAGQmdGtbNo
         d0yrKLT7UP44tj93MhGhAAPYjXKlaujDYupOU1rdB6AIMInmB+SJAIe/hup9B6mA37tq
         uU6k5Xg4PbxtPLVilEOH9E1tmhXCfBsDB0p4NvppwpnzWTQEi2yr1A3L3Ate9mFESf+L
         eOM1dGIRupdvGVMQmLpq7Cz6akHIVRmmtdKZv4eA620t+YKJ1hgxv4DbWlV8yCqAGhRi
         HpnogbLrk5WE9CU8cT+xjKismtZUAXmx9GvcfKoltvlmjpjpECayElQK7dFvrh16PM/3
         X2rw==
X-Gm-Message-State: AJIora/TeEW/lIoPYrVVveV6gefnTF1aiOa2dCCadGxsKDQFtQnjRBEF
        hK+2oN1TBysMyJ8dqXnVEwW92rfjO1Q=
X-Google-Smtp-Source: AGRyM1uRxheV8vqfsL+i5mM3ZFHVKZ3lBJT5JYol9UIaw8Q9UtK/ry6wlX1c4X7mnzr+C+ovRpRQzA==
X-Received: by 2002:a17:90b:1b0d:b0:1f0:2407:6b17 with SMTP id nu13-20020a17090b1b0d00b001f024076b17mr1635134pjb.214.1658459047214;
        Thu, 21 Jul 2022 20:04:07 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090a1d0a00b001f216407204sm2115450pjd.36.2022.07.21.20.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 20:04:06 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/5] ksmbd: add channel rwlock
Date:   Fri, 22 Jul 2022 12:03:43 +0900
Message-Id: <20220722030346.28534-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722030346.28534-1-linkinjeon@kernel.org>
References: <20220722030346.28534-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add missing rwlock for channel list in session.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/mgmt/user_session.c |  3 +++
 fs/ksmbd/mgmt/user_session.h |  1 +
 fs/ksmbd/smb2pdu.c           | 20 ++++++++++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 3a44e66456fc..25e9ba3b7550 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -32,11 +32,13 @@ static void free_channel_list(struct ksmbd_session *sess)
 {
 	struct channel *chann, *tmp;
 
+	write_lock(&sess->chann_lock);
 	list_for_each_entry_safe(chann, tmp, &sess->ksmbd_chann_list,
 				 chann_list) {
 		list_del(&chann->chann_list);
 		kfree(chann);
 	}
+	write_unlock(&sess->chann_lock);
 }
 
 static void __session_rpc_close(struct ksmbd_session *sess,
@@ -303,6 +305,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	INIT_LIST_HEAD(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
 	atomic_set(&sess->refcnt, 1);
+	rwlock_init(&sess->chann_lock);
 
 	switch (protocol) {
 	case CIFDS_SESSION_FLAG_SMB2:
diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
index 8b08189be3fc..1ec659f0151b 100644
--- a/fs/ksmbd/mgmt/user_session.h
+++ b/fs/ksmbd/mgmt/user_session.h
@@ -48,6 +48,7 @@ struct ksmbd_session {
 	char				sess_key[CIFS_KEY_SIZE];
 
 	struct hlist_node		hlist;
+	rwlock_t			chann_lock;
 	struct list_head		ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 04d20a2e6dee..5a0328a070dc 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1512,7 +1512,9 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 
 binding_session:
 	if (conn->dialect >= SMB30_PROT_ID) {
+		read_lock(&sess->chann_lock);
 		chann = lookup_chann_list(sess, conn);
+		read_unlock(&sess->chann_lock);
 		if (!chann) {
 			chann = kmalloc(sizeof(struct channel), GFP_KERNEL);
 			if (!chann)
@@ -1520,7 +1522,9 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 
 			chann->conn = conn;
 			INIT_LIST_HEAD(&chann->chann_list);
+			write_lock(&sess->chann_lock);
 			list_add(&chann->chann_list, &sess->ksmbd_chann_list);
+			write_unlock(&sess->chann_lock);
 		}
 	}
 
@@ -1594,7 +1598,9 @@ static int krb5_authenticate(struct ksmbd_work *work)
 	}
 
 	if (conn->dialect >= SMB30_PROT_ID) {
+		read_lock(&sess->chann_lock);
 		chann = lookup_chann_list(sess, conn);
+		read_unlock(&sess->chann_lock);
 		if (!chann) {
 			chann = kmalloc(sizeof(struct channel), GFP_KERNEL);
 			if (!chann)
@@ -1602,7 +1608,9 @@ static int krb5_authenticate(struct ksmbd_work *work)
 
 			chann->conn = conn;
 			INIT_LIST_HEAD(&chann->chann_list);
+			write_lock(&sess->chann_lock);
 			list_add(&chann->chann_list, &sess->ksmbd_chann_list);
+			write_unlock(&sess->chann_lock);
 		}
 	}
 
@@ -8351,10 +8359,14 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	if (le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
 		signing_key = work->sess->smb3signingkey;
 	} else {
+		read_lock(&work->sess->chann_lock);
 		chann = lookup_chann_list(work->sess, conn);
-		if (!chann)
+		if (!chann) {
+			read_unlock(&work->sess->chann_lock);
 			return 0;
+		}
 		signing_key = chann->smb3signingkey;
+		read_unlock(&work->sess->chann_lock);
 	}
 
 	if (!signing_key) {
@@ -8414,10 +8426,14 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	    le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
 		signing_key = work->sess->smb3signingkey;
 	} else {
+		read_lock(&work->sess->chann_lock);
 		chann = lookup_chann_list(work->sess, work->conn);
-		if (!chann)
+		if (!chann) {
+			read_unlock(&work->sess->chann_lock);
 			return;
+		}
 		signing_key = chann->smb3signingkey;
+		read_unlock(&work->sess->chann_lock);
 	}
 
 	if (!signing_key)
-- 
2.25.1

