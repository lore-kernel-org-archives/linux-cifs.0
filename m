Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CA2C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 04:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3414261101
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 04:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhIIES4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 00:18:56 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:44853 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhIIESz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Sep 2021 00:18:55 -0400
Received: by mail-pl1-f174.google.com with SMTP id d18so230599pll.11
        for <linux-cifs@vger.kernel.org>; Wed, 08 Sep 2021 21:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOhgJce9eD3w4K0rcye5lGeVBmpeD/ulVTRmhP+vcxk=;
        b=HTkJQZgVVg3azG0ZjxWlFaNiZbL6WJK7rJeM1l8Dla+/Zk/47ful12/HBmLWuolxV7
         grGHdMzo+ED5DyL48HLkWGEcdIHldCORDeZDK1APUeiJIUk/sQnhIF8xAGPBouoovmIo
         OFrzpQF+ILx0zY8yA24zBT1ZUax7PDenCkcOObeve2rTIhL3X8yw24xralcaWxWRKLXu
         z++mx2zaljEPA2Hn7VX1ye2uZcbiW2BJxZ9WNT6A/ePqHm9x7qRWXtfDPL2x6meVI2DI
         q4JfQ7F89mTrCjwBSlMWHxLZnOAr4mNd9a3Wvfge8bWTZypp/6ryg/Q84zIETNBCsQqU
         k6WA==
X-Gm-Message-State: AOAM531yN2TMVx0t0408EGK81S7ce8fd31sTJ6bW7Q3RkyYgO5MvnDWa
        apRWjjCBCQ3Jz8NciIcj/oIUJw9VYH0A/A==
X-Google-Smtp-Source: ABdhPJxwKR3OPtD4WA1tRBhqKcn+q/AgyhAom8bfnQwKNOeq/D3vkKT+HBSbv34nLDXsQ7bYyht9sg==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr1313179pjb.52.1631161066757;
        Wed, 08 Sep 2021 21:17:46 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id z33sm479037pga.20.2021.09.08.21.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 21:17:46 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] ksmbd: change LeaseKey data type to u8 array
Date:   Thu,  9 Sep 2021 13:17:36 +0900
Message-Id: <20210909041736.4348-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs define LeaseKey as u8 array in structure. To move lease structure
to cifs_common, ksmbd change LeaseKey data type to u8 array.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c  | 24 +++++++++---------------
 fs/ksmbd/oplock.h  |  2 --
 fs/ksmbd/smb2pdu.h | 11 +++++------
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index fec4143d575b..1c8ef360b1ec 100644
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
index 4608cab0f708..72180ddd2ffd 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -214,22 +214,21 @@ struct create_posix_rsp {
 
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

