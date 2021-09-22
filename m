Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74713C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 01:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D26361156
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 01:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhIVB2w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 21:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhIVB2w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 21:28:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42394C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 18:27:23 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id w8so945805pgf.5
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 18:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GpjQXiw2pwjQ7U4qQN9PiadNlP7BgqjLEOnpwHYNRg8=;
        b=BN7efIm26Wn4s6V7f2DuDDVyO26jdqXaSzdYoaJqMgbpZI5ieJ+j0aJpzWhJvOL6Mk
         4G8wo6ALQRADvQ5M2E3ww6vEvprOAb/kit3LKFkKRCrrFQRfDpmaUv1Jf4MyQMcuOn9B
         OQ5b5TSw0Q0ZH5ADceDoD7Sfd3ZD+qTPP/90Wei9HPLW4cRwUh5gBGmhq3y20NQTGGIL
         GqW4Ufld4bGJ8mp6kux75EzgakJ/9z/vKUteJyIOkuwZ2ZL7i/RssfblQQNK5cA8jn4u
         45+KAIh9X7i5aWbxVMD+YPHAqnkJSN8uc1ubqMjk6B/Tb8YbPXEdItPazYZIIID62yRo
         ZUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GpjQXiw2pwjQ7U4qQN9PiadNlP7BgqjLEOnpwHYNRg8=;
        b=E/bRYsknkrMy5i6ZZlbZD+z/cksqX+Jcb9/QtEdmbZv55A3Xi74rH73XEl8OSghZfj
         O1GJRQX1kup/oBL1JPT8x+DOfO2ir9CZIqkPJtX4r5Eq039kRKylN99+munzYstOJPC5
         /weEwqyo1BqHMxlb95xLr1eEhnMFI0KnJd+n6telZtUWrksiwgHvCZ05lERu/uuhIhIh
         bEWwHKikV7X9xZluHb7yYOXN25C+sGPgbSVOyXjr2IUmLW6Urm4ryRTabQA5GYKbsfu+
         cUuPAgkmcndsOX8m1AO5+bGNuNvZwBhroTqrkKWo+Yr4gTPcIT3jO2MqKZwqI95tOdmy
         682Q==
X-Gm-Message-State: AOAM530z3SW7Pwoc9I7eWh1VOSqWBQ/Z5O7qBBGedRDGfcohDISH7DAp
        YMKtn9nQiP3T2C2x2+apeACDn+Y6GPgFlzOo5sU=
X-Google-Smtp-Source: ABdhPJymKAYg2lrBR5NlYwpkVdWXUela0cZK0MHihovFawbEfXRBZ29AMuqknabutSVv7lLtJ7ptPg==
X-Received: by 2002:aa7:8e91:0:b0:43e:1dd:812b with SMTP id a17-20020aa78e91000000b0043e01dd812bmr33073932pfr.35.1632274042588;
        Tue, 21 Sep 2021 18:27:22 -0700 (PDT)
Received: from localhost.localdomain ([210.123.88.105])
        by smtp.googlemail.com with ESMTPSA id n9sm3910431pjk.3.2021.09.21.18.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 18:27:22 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v3] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
Date:   Wed, 22 Sep 2021 10:26:51 +0900
Message-Id: <20210922012651.513888-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add buffer validation for SMB2_CREATE_CONTEXT.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
Changes from v2:
 - check struct create_context's fields more in smb2_find_context_vals
   (suggested by Ralph Boehme).

 fs/ksmbd/oplock.c  | 34 ++++++++++++++++++++++++----------
 fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
 fs/ksmbd/smbacl.c  |  9 ++++++++-
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 16b6236d1bd2..8f743913b1cf 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1451,26 +1451,40 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
  */
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
 {
-	char *data_offset;
+	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
 	struct create_context *cc;
-	unsigned int next = 0;
+	char *data_offset, *data_end;
 	char *name;
-	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
+	unsigned int next = 0;
+	unsigned int name_off, name_len, value_off, value_len;
 
 	data_offset = (char *)req + 4 + le32_to_cpu(req->CreateContextsOffset);
+	data_end = data_offset + le32_to_cpu(req->CreateContextsLength);
 	cc = (struct create_context *)data_offset;
 	do {
-		int val;
-
 		cc = (struct create_context *)((char *)cc + next);
-		name = le16_to_cpu(cc->NameOffset) + (char *)cc;
-		val = le16_to_cpu(cc->NameLength);
-		if (val < 4)
+		if ((char *)cc + offsetof(struct create_context, Buffer) >
+		    data_end)
 			return ERR_PTR(-EINVAL);
 
-		if (memcmp(name, tag, val) == 0)
-			return cc;
 		next = le32_to_cpu(cc->Next);
+		name_off = le16_to_cpu(cc->NameOffset);
+		name_len = le16_to_cpu(cc->NameLength);
+		value_off = le16_to_cpu(cc->DataOffset);
+		value_len = le32_to_cpu(cc->DataLength);
+
+		if ((next & 0x7) != 0 ||
+		    name_off != 16 ||
+		    name_len < 4 ||
+		    (char *)cc + name_off + name_len > data_end ||
+		    (value_off & 0x7) != 0 ||
+		    (value_off && value_off < name_off + name_len) ||
+		    (char *)cc + value_off + value_len > data_end)
+			return ERR_PTR(-EINVAL);
+
+		name = (char *)cc + name_off;
+		if (memcmp(name, tag, name_len) == 0)
+			return cc;
 	} while (next != 0);
 
 	return NULL;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c86164dc70bb..976490bfd93c 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2377,6 +2377,10 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 	ksmbd_debug(SMB,
 		    "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
 	sd_buf = (struct create_sd_buf_req *)context;
+	if (le16_to_cpu(context->DataOffset) +
+	    le32_to_cpu(context->DataLength) <
+	    sizeof(struct create_sd_buf_req))
+		return -EINVAL;
 	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
 			    le32_to_cpu(sd_buf->ccontext.DataLength), true);
 }
@@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		} else if (context) {
 			ea_buf = (struct create_ea_buf_req *)context;
+			if (le16_to_cpu(context->DataOffset) +
+			    le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_ea_buf_req)) {
+				rc = -EINVAL;
+				goto err_out1;
+			}
 			if (req->CreateOptions & FILE_NO_EA_KNOWLEDGE_LE) {
 				rsp->hdr.Status = STATUS_ACCESS_DENIED;
 				rc = -EACCES;
@@ -2615,6 +2625,12 @@ int smb2_open(struct ksmbd_work *work)
 			} else if (context) {
 				struct create_posix *posix =
 					(struct create_posix *)context;
+				if (le16_to_cpu(context->DataOffset) +
+				    le32_to_cpu(context->DataLength) <
+				    sizeof(struct create_posix)) {
+					rc = -EINVAL;
+					goto err_out1;
+				}
 				ksmbd_debug(SMB, "get posix context\n");
 
 				posix_mode = le32_to_cpu(posix->Mode);
@@ -3019,9 +3035,16 @@ int smb2_open(struct ksmbd_work *work)
 			rc = PTR_ERR(az_req);
 			goto err_out;
 		} else if (az_req) {
-			loff_t alloc_size = le64_to_cpu(az_req->AllocationSize);
+			loff_t alloc_size;
 			int err;
 
+			if (le16_to_cpu(az_req->ccontext.DataOffset) +
+			    le32_to_cpu(az_req->ccontext.DataLength) <
+			    sizeof(struct create_alloc_size_req)) {
+				rc = -EINVAL;
+				goto err_out;
+			}
+			alloc_size = le64_to_cpu(az_req->AllocationSize);
 			ksmbd_debug(SMB,
 				    "request smb2 create allocate size : %llu\n",
 				    alloc_size);
diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 0a95cdec8c80..f67567e1e178 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -392,7 +392,7 @@ static void parse_dacl(struct user_namespace *user_ns,
 		return;
 
 	/* validate that we do not go past end of acl */
-	if (end_of_acl <= (char *)pdacl ||
+	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
 	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
 		pr_err("ACL too small to parse DACL\n");
 		return;
@@ -434,6 +434,10 @@ static void parse_dacl(struct user_namespace *user_ns,
 		ppace[i] = (struct smb_ace *)(acl_base + acl_size);
 		acl_base = (char *)ppace[i];
 		acl_size = le16_to_cpu(ppace[i]->size);
+
+		if (acl_base + acl_size > end_of_acl)
+			break;
+
 		ppace[i]->access_req =
 			smb_map_generic_desired_access(ppace[i]->access_req);
 
@@ -807,6 +811,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 	if (!pntsd)
 		return -EIO;
 
+	if (acl_len < sizeof(struct smb_ntsd))
+		return -EINVAL;
+
 	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
 			le32_to_cpu(pntsd->osidoffset));
 	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-- 
2.25.1

