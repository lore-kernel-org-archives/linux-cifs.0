Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EEDC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 831F6613C8
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbhI2IrP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:47:15 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:37393 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244764AbhI2IrO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 04:47:14 -0400
Received: by mail-pj1-f45.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so3696026pjb.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bLWfFUHu0GP9lqFAtezgaEiZzcH7MQ1RUoailCDJ1cg=;
        b=XIIQb1wWZ2ZTctiWfwKdukmICTGHDw10c6Wb/xKrNYBycBScD3o89DDBGwCj1FoGBc
         Gk9onT4ZxWJ6MJb1i9JRg//kVRrJQ1Brs1zBOtYB/zRgRVN002JVldH4bsHo8fofcXJ2
         OJQlakctK1kkHuoZ4AWMpNyNQ0vwxRcGxrZgYfUAktUlBaWXyCzCFIGsZIov6X2rpQUt
         kF8gAWv/b4zlelqeoYF18ZLxGyzkG4eVO4xQ40KQ9vFzqV1d80981RqypQOEee4Un0x9
         G5UEEVaaj0cVNJtFafs1QEgOVQJoEo2uIjeQj5sjP8aHkrPRptDlNjj3A/did/Rl6Yod
         0xYg==
X-Gm-Message-State: AOAM532owF7HS271aPgf5Hfpl0IqMm75wmhZ8uPc22SltYbhLeJVfj8I
        rENETEMiJkDSsl7AboF5edf+CmDw9VqD6A==
X-Google-Smtp-Source: ABdhPJws7H9sSUPWIC1wkegULQDlXGrh/U9ET6WdmfWE6JbzmG8RWHhnJRAbk4jg//XJ0ueE1FBOHw==
X-Received: by 2002:a17:902:64d6:b0:13e:59fe:8124 with SMTP id y22-20020a17090264d600b0013e59fe8124mr1846970pli.89.1632905131638;
        Wed, 29 Sep 2021 01:45:31 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q3sm1912344pgf.18.2021.09.29.01.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:45:31 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 7/9] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
Date:   Wed, 29 Sep 2021 17:44:59 +0900
Message-Id: <20210929084501.94846-8-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

Add buffer validation for SMB2_CREATE_CONTEXT.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Reviewed-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c  | 41 +++++++++++++++++++++++++++++++----------
 fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
 fs/ksmbd/smbacl.c  | 21 +++++++++++++++++++--
 3 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 16b6236d1bd2..f9dae6ef2115 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1451,26 +1451,47 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
  */
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
 {
-	char *data_offset;
 	struct create_context *cc;
 	unsigned int next = 0;
 	char *name;
 	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
+	unsigned int remain_len, name_off, name_len, value_off, value_len,
+		     cc_len;
 
-	data_offset = (char *)req + 4 + le32_to_cpu(req->CreateContextsOffset);
-	cc = (struct create_context *)data_offset;
+	/*
+	 * CreateContextsOffset and CreateContextsLength are guaranteed to
+	 * be valid because of ksmbd_smb2_check_message().
+	 */
+	cc = (struct create_context *)((char *)req + 4 +
+				       le32_to_cpu(req->CreateContextsOffset));
+	remain_len = le32_to_cpu(req->CreateContextsLength);
 	do {
-		int val;
-
 		cc = (struct create_context *)((char *)cc + next);
-		name = le16_to_cpu(cc->NameOffset) + (char *)cc;
-		val = le16_to_cpu(cc->NameLength);
-		if (val < 4)
+		if (remain_len < offsetof(struct create_context, Buffer))
 			return ERR_PTR(-EINVAL);
 
-		if (memcmp(name, tag, val) == 0)
-			return cc;
 		next = le32_to_cpu(cc->Next);
+		name_off = le16_to_cpu(cc->NameOffset);
+		name_len = le16_to_cpu(cc->NameLength);
+		value_off = le16_to_cpu(cc->DataOffset);
+		value_len = le32_to_cpu(cc->DataLength);
+		cc_len = next ? next : remain_len;
+
+		if ((next & 0x7) != 0 ||
+		    next > remain_len ||
+		    name_off != offsetof(struct create_context, Buffer) ||
+		    name_len < 4 ||
+		    name_off + name_len > cc_len ||
+		    (value_off & 0x7) != 0 ||
+		    (value_off && (value_off < name_off + name_len)) ||
+		    ((u64)value_off + value_len > cc_len))
+			return ERR_PTR(-EINVAL);
+
+		name = (char *)cc + name_off;
+		if (memcmp(name, tag, name_len) == 0)
+			return cc;
+
+		remain_len -= next;
 	} while (next != 0);
 
 	return NULL;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0b0ab3297e05..e40bcc86f3b3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2427,6 +2427,10 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
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
@@ -2621,6 +2625,12 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -2659,6 +2669,12 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -3049,9 +3065,16 @@ int smb2_open(struct ksmbd_work *work)
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
index 0a95cdec8c80..bd792db32623 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -380,7 +380,7 @@ static void parse_dacl(struct user_namespace *user_ns,
 {
 	int i, ret;
 	int num_aces = 0;
-	int acl_size;
+	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
 	struct posix_acl_entry *cf_pace, *cf_pdace;
@@ -392,7 +392,7 @@ static void parse_dacl(struct user_namespace *user_ns,
 		return;
 
 	/* validate that we do not go past end of acl */
-	if (end_of_acl <= (char *)pdacl ||
+	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
 	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
 		pr_err("ACL too small to parse DACL\n");
 		return;
@@ -431,8 +431,22 @@ static void parse_dacl(struct user_namespace *user_ns,
 	 * user/group/other have no permissions
 	 */
 	for (i = 0; i < num_aces; ++i) {
+		if (end_of_acl - acl_base < acl_size)
+			break;
+
 		ppace[i] = (struct smb_ace *)(acl_base + acl_size);
 		acl_base = (char *)ppace[i];
+		acl_size = offsetof(struct smb_ace, sid) +
+			offsetof(struct smb_sid, sub_auth);
+
+		if (end_of_acl - acl_base < acl_size ||
+		    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    (end_of_acl - acl_base <
+		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
+		    (le16_to_cpu(ppace[i]->size) <
+		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth))
+			break;
+
 		acl_size = le16_to_cpu(ppace[i]->size);
 		ppace[i]->access_req =
 			smb_map_generic_desired_access(ppace[i]->access_req);
@@ -807,6 +821,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
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

