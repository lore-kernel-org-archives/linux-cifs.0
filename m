Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83ADCC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C7D60F70
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhKCNgq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 09:36:46 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:33646 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhKCNgp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Nov 2021 09:36:45 -0400
Received: by mail-pj1-f51.google.com with SMTP id x1-20020a17090a530100b001a1efa4ebe6so1700794pjh.0
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 06:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jaDC5Ppyu0J12jWMDjEb68FOKw6yvLdX0D4gJGum9LU=;
        b=luL+puSPzVrIpZ5OPdc5mOg4gtKNTMGZf9cRlhe0rOxyUUUmjMbBTLahIVNI9+k6hW
         cMn/5i8JRV0uGV59ArGrtgEF4zv0h75nLteFgVJxA7UEy7SOZ422JxaIUXajRqqSq2xJ
         mztLfwd5SIUtRu/voyelkqn9k/0RYmA4V7twmWOI0kF4win8uT3BSvC6N/BtzcW8mCod
         YEtB26NVC9wD+nci0UUGPhlCkmBZ+JtPkIVrsXFqxNeN/9LgiSFtLmad2S6f+s983e3u
         stER/AfwwmzAPRLHnHN2YvCmIy6ns8GBTfFzLD0eCmoIIalL9D5z/MgnAunXWZnDS5X5
         Ixjw==
X-Gm-Message-State: AOAM530NPPQdAEGk5Qwpj9l8n5nIPnoS1IjaUjXZdRYLr57LDJ7BcmvD
        eWir5zsG4KsM60q64Dxv43cTUHJT7d0=
X-Google-Smtp-Source: ABdhPJywv8RZmCwpT+lA5KFYYiWhMCX8CLUEyIpnXFkLmP9WyfksS5pe33AS54ho2vv17+fllAxNPQ==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr14789552pjj.165.1635946448830;
        Wed, 03 Nov 2021 06:34:08 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s14sm2692024pfk.95.2021.11.03.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 06:34:08 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: change LeaseKey data type to u8 array
Date:   Wed,  3 Nov 2021 22:33:53 +0900
Message-Id: <20211103133353.6650-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211103133353.6650-1-linkinjeon@kernel.org>
References: <20211103133353.6650-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs define LeaseKey as u8 array in structure. To move lease structure
to smbfs_common, ksmbd change LeaseKey data type to u8 array.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c  | 24 +++++++++---------------
 fs/ksmbd/oplock.h  |  2 --
 fs/ksmbd/smb2pdu.h | 11 +++++------
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index ce0e85552da9..077b8761d099 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1335,19 +1335,16 @@ __u8 smb2_map_lease_to_oplock(__le32 lease_state)
  */
 void create_lease_buf(u8 *rbuf, struct lease *lease)
 {
-	char *LeaseKey = (char *)&lease->lease_key;
-
 	if (lease->version == 2) {
 		struct create_lease_v2 *buf = (struct create_lease_v2 *)rbuf;
-		char *ParentLeaseKey = (char *)&lease->parent_lease_key;
 
 		memset(buf, 0, sizeof(struct create_lease_v2));
-		buf->lcontext.LeaseKeyLow = *((__le64 *)LeaseKey);
-		buf->lcontext.LeaseKeyHigh = *((__le64 *)(LeaseKey + 8));
+		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
+		       SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
 		buf->lcontext.LeaseState = lease->state;
-		buf->lcontext.ParentLeaseKeyLow = *((__le64 *)ParentLeaseKey);
-		buf->lcontext.ParentLeaseKeyHigh = *((__le64 *)(ParentLeaseKey + 8));
+		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
+		       SMB2_LEASE_KEY_SIZE);
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
 				(struct create_lease_v2, lcontext));
 		buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context_v2));
@@ -1362,8 +1359,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 		struct create_lease *buf = (struct create_lease *)rbuf;
 
 		memset(buf, 0, sizeof(struct create_lease));
-		buf->lcontext.LeaseKeyLow = *((__le64 *)LeaseKey);
-		buf->lcontext.LeaseKeyHigh = *((__le64 *)(LeaseKey + 8));
+		memcpy(buf->lcontext.LeaseKey, lease->lease_key, SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
 		buf->lcontext.LeaseState = lease->state;
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
@@ -1416,19 +1412,17 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 			struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
-			*((__le64 *)lreq->lease_key) = lc->lcontext.LeaseKeyLow;
-			*((__le64 *)(lreq->lease_key + 8)) = lc->lcontext.LeaseKeyHigh;
+			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 			lreq->req_state = lc->lcontext.LeaseState;
 			lreq->flags = lc->lcontext.LeaseFlags;
 			lreq->duration = lc->lcontext.LeaseDuration;
-			*((__le64 *)lreq->parent_lease_key) = lc->lcontext.ParentLeaseKeyLow;
-			*((__le64 *)(lreq->parent_lease_key + 8)) = lc->lcontext.ParentLeaseKeyHigh;
+			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+			       SMB2_LEASE_KEY_SIZE);
 			lreq->version = 2;
 		} else {
 			struct create_lease *lc = (struct create_lease *)cc;
 
-			*((__le64 *)lreq->lease_key) = lc->lcontext.LeaseKeyLow;
-			*((__le64 *)(lreq->lease_key + 8)) = lc->lcontext.LeaseKeyHigh;
+			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 			lreq->req_state = lc->lcontext.LeaseState;
 			lreq->flags = lc->lcontext.LeaseFlags;
 			lreq->duration = lc->lcontext.LeaseDuration;
diff --git a/fs/ksmbd/oplock.h b/fs/ksmbd/oplock.h
index 119b8047cfbd..0cf7a2b5bbc0 100644
--- a/fs/ksmbd/oplock.h
+++ b/fs/ksmbd/oplock.h
@@ -28,8 +28,6 @@
 #define OPLOCK_WRITE_TO_NONE		0x04
 #define OPLOCK_READ_TO_NONE		0x08
 
-#define SMB2_LEASE_KEY_SIZE		16
-
 struct lease_ctx_info {
 	__u8			lease_key[SMB2_LEASE_KEY_SIZE];
 	__le32			req_state;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index f418b001b999..829f44569077 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -733,22 +733,21 @@ struct create_posix_rsp {
 
 #define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE	cpu_to_le32(0x02)
 
+#define SMB2_LEASE_KEY_SIZE			16
+
 struct lease_context {
-	__le64 LeaseKeyLow;
-	__le64 LeaseKeyHigh;
+	__u8 LeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le32 LeaseState;
 	__le32 LeaseFlags;
 	__le64 LeaseDuration;
 } __packed;
 
 struct lease_context_v2 {
-	__le64 LeaseKeyLow;
-	__le64 LeaseKeyHigh;
+	__u8 LeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le32 LeaseState;
 	__le32 LeaseFlags;
 	__le64 LeaseDuration;
-	__le64 ParentLeaseKeyLow;
-	__le64 ParentLeaseKeyHigh;
+	__u8 ParentLeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le16 Epoch;
 	__le16 Reserved;
 } __packed;
-- 
2.25.1

