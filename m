Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF7DC433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 13:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E13E60E9B
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 13:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346562AbhIXNdH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 09:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346443AbhIXNdE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Sep 2021 09:33:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94172C03B1AE
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 06:22:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j14so6474284plx.4
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 06:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fN4X5uwjq/73I4k/hupepuR/MbgZgQrLoftOE7b54NI=;
        b=MlmDPIwVP/JehalIcvSC+i0++Ck2MszFzBc7A6fCZIRPsRjFOc7Im7s/tite9+SBrS
         eVHycskbLa+B5mmoHUuLgnN5EgpcMCGG1ScXtCJ1wG5YcG8CkIq1dAmDYTaGkw/txB4A
         J20TXDdtdtoWOOPlIPmMbPZ8KagTTXwVwuHaPt4tiSjaL2tS7chv/LcELD5FPpNp7Jk2
         qFokaXPro4g2/A+gx9Z5pVfM/xQ6IkiY4O3wKo3s59f5riY83I3BIqoKzOC1itIce+Lv
         Jqdu7Hmg2yZ6b1p3SkMgFOT7E11zHKpK6yjpuUvmb5Lt04Gg74orb8r2hrW00hKy8dAI
         R8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fN4X5uwjq/73I4k/hupepuR/MbgZgQrLoftOE7b54NI=;
        b=HxJBzdMkO/FNRIi3WQvSFbDAzx8icIjLUYQvxvkF8THXOuypRfWnqBaDJJ7J7YwogI
         7YLhU4oWv1e1RjhYg6vp3ihZG4arDqjzIkGnMHEUvJMrdBdwQpq//ZI1HssHZiJwVPHq
         ykxNqDNSds1tA6ihODqOndWDLvBpcm0TlIbMne0qGVGhhsmGACbn9yXV407+XXI0H0ut
         9E9O1dZKujisUSHSrCC80kGveE7gvlw/6oVg4CuCTo5NG9SOZkySKzA2hF+ICk76V8q7
         V4+ROwI7pawlE6Tn2aebPaLxN15dHMfH/BBAOKyv9kbE4yNvmqCYMzGb/TGZVP4OHBYF
         wz/Q==
X-Gm-Message-State: AOAM531wSonRp+Ah7xCbejW4ujcjou6pGEwz0WBScLfEzRR5sw/Jnr6h
        fOMO+gpl/KLsS+I2adEF8N+noya0MsIMFkEw
X-Google-Smtp-Source: ABdhPJwtIYDALiZqKqAFuhB3TB41NG6ZHhaQwmZpLU3RYiRniXB6GkFgnR90rK4esli/x43QUVm8Bg==
X-Received: by 2002:a17:90a:9289:: with SMTP id n9mr2231045pjo.27.1632489774852;
        Fri, 24 Sep 2021 06:22:54 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id m126sm9682495pga.53.2021.09.24.06.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 06:22:54 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
Date:   Fri, 24 Sep 2021 22:22:22 +0900
Message-Id: <20210924132222.914168-2-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210924132222.914168-1-hyc.lee@gmail.com>
References: <20210924132222.914168-1-hyc.lee@gmail.com>
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
 - check struct create_context's fields more in smb2_find_context_vals()
Changes from v3:
 - fix possible overflow when accessing create_context structure in
   smb2_find_context_vals()
 - fix possible overflow when accessing smb_ace structure in parse_dacl()

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
index bb39b18a6673..6220f1f7322e 100644
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

