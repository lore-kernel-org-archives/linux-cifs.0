Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6183FC77B7F
	for <linux-cifs@archiver.kernel.org>; Sun, 14 May 2023 03:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjEND3E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 May 2023 23:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjEND3D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 May 2023 23:29:03 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1329D1FEE
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:29:02 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1adc913094aso32798765ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684034941; x=1686626941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=715AYB5LgUKhATwXenlz6c1MTQFz6/PGQzzenJZlGAI=;
        b=KF69+NMFKauB4zNLN1jRLwGtNUzSCyK7vDxJ1jYeIsqxtnW0Fwek2Aqz46b04pHe2M
         M1X+IxObY+mBZr3WdpQW58O2xlsSD2svdYKeHXycbByPB482EopBk0RWRpjJMdC+FdMM
         VB+TjZO6m2JY/ijj3ZpJpxNOr0ZS77xDeTevGSTUshsrCAus7SqHsk4MDoteyWPYBfp2
         Ub6CsgH90ZNBOORK+czWFaj5qoymLE5vqu23g2rI/TfZ//SgsRjpKl6ppUtl0IrOb09g
         T8OvYBy4HMOYn9ARo7fTYUKElAJCUFLmn7Wgw1yiJHj5SbRL65ooyZkWQU6OoqXoeZsM
         8Y4Q==
X-Gm-Message-State: AC+VfDwuiu9oE8BT15KW0o1fK5C+Zz81Zk5axBG/xrZ94OA/N8SVkRVw
        BZ3UTtEHrA+u/lziQRS/IECUj+S0Nmg=
X-Google-Smtp-Source: ACHHUZ5cZnTVx1DhOVROZPH3/CMCsR8cd/kenusOfhekUXHcbylVBWmxxffwYWjpeKipCBbZhyK5Mg==
X-Received: by 2002:a17:902:c1c4:b0:1a8:1320:133 with SMTP id c4-20020a170902c1c400b001a813200133mr26863765plc.51.1684034940856;
        Sat, 13 May 2023 20:29:00 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902dac400b001ab1b7bae5asm693652plx.184.2023.05.13.20.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 20:29:00 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Pumpkin <cc85nod@gmail.com>
Subject: [PATCH v2] ksmbd: fix global-out-of-bounds in smb2_find_context_vals
Date:   Sun, 14 May 2023 12:28:49 +0900
Message-Id: <20230514032849.5099-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pumpkin <cc85nod@gmail.com>

Add tag_len argument in smb2_find_context_vals() to avoid out-of-bound
read when create_context's name_len is larger than tag length.

Signed-off-by: Pumpkin <cc85nod@gmail.com>
---
 v2:
  - add the check if tag len and name len are same before comparing tag
    and name.

 fs/ksmbd/oplock.c  |  5 +++--
 fs/ksmbd/oplock.h  |  2 +-
 fs/ksmbd/smb2pdu.c | 14 +++++++-------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 2e54ded4d..6d1ccb999 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1449,11 +1449,12 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
  * smb2_find_context_vals() - find a particular context info in open request
  * @open_req:	buffer containing smb2 file open(create) request
  * @tag:	context name to search for
+ * @tag_len:	the length of tag
  *
  * Return:	pointer to requested context, NULL if @str context not found
  *		or error pointer if name length is invalid.
  */
-struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
+struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len)
 {
 	struct create_context *cc;
 	unsigned int next = 0;
@@ -1492,7 +1493,7 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
 			return ERR_PTR(-EINVAL);
 
 		name = (char *)cc + name_off;
-		if (memcmp(name, tag, name_len) == 0)
+		if (name_len == tag_len && !memcmp(name, tag, name_len))
 			return cc;
 
 		remain_len -= next;
diff --git a/fs/ksmbd/oplock.h b/fs/ksmbd/oplock.h
index 09753448f..4b0fe6da7 100644
--- a/fs/ksmbd/oplock.h
+++ b/fs/ksmbd/oplock.h
@@ -118,7 +118,7 @@ void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp);
 void create_mxac_rsp_buf(char *cc, int maximal_access);
 void create_disk_id_rsp_buf(char *cc, __u64 file_id, __u64 vol_id);
 void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
-struct create_context *smb2_find_context_vals(void *open_req, const char *str);
+struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
 int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index da66abc7c..013eeefd0 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2492,7 +2492,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 		return -ENOENT;
 
 	/* Parse SD BUFFER create contexts */
-	context = smb2_find_context_vals(req, SMB2_CREATE_SD_BUFFER);
+	context = smb2_find_context_vals(req, SMB2_CREATE_SD_BUFFER, 4);
 	if (!context)
 		return -ENOENT;
 	else if (IS_ERR(context))
@@ -2694,7 +2694,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (req->CreateContextsOffset) {
 		/* Parse non-durable handle create contexts */
-		context = smb2_find_context_vals(req, SMB2_CREATE_EA_BUFFER);
+		context = smb2_find_context_vals(req, SMB2_CREATE_EA_BUFFER, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out1;
@@ -2714,7 +2714,7 @@ int smb2_open(struct ksmbd_work *work)
 		}
 
 		context = smb2_find_context_vals(req,
-						 SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST);
+						 SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out1;
@@ -2725,7 +2725,7 @@ int smb2_open(struct ksmbd_work *work)
 		}
 
 		context = smb2_find_context_vals(req,
-						 SMB2_CREATE_TIMEWARP_REQUEST);
+						 SMB2_CREATE_TIMEWARP_REQUEST, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out1;
@@ -2737,7 +2737,7 @@ int smb2_open(struct ksmbd_work *work)
 
 		if (tcon->posix_extensions) {
 			context = smb2_find_context_vals(req,
-							 SMB2_CREATE_TAG_POSIX);
+							 SMB2_CREATE_TAG_POSIX, 16);
 			if (IS_ERR(context)) {
 				rc = PTR_ERR(context);
 				goto err_out1;
@@ -3136,7 +3136,7 @@ int smb2_open(struct ksmbd_work *work)
 		struct create_alloc_size_req *az_req;
 
 		az_req = (struct create_alloc_size_req *)smb2_find_context_vals(req,
-					SMB2_CREATE_ALLOCATION_SIZE);
+					SMB2_CREATE_ALLOCATION_SIZE, 4);
 		if (IS_ERR(az_req)) {
 			rc = PTR_ERR(az_req);
 			goto err_out;
@@ -3163,7 +3163,7 @@ int smb2_open(struct ksmbd_work *work)
 					    err);
 		}
 
-		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID);
+		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
 			goto err_out;
-- 
2.39.2 (Apple Git-143)

