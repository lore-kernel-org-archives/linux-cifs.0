Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6053C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A912260249
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhISCPG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:15:06 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:39739 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhISCPF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 22:15:05 -0400
Received: by mail-pl1-f171.google.com with SMTP id c4so8764186pls.6
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 19:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/bM0yGOH/VtWb3S09A8hvDcI91tNnyxvI43zdKXZRQI=;
        b=4Y8mOVmrOAczBmInqJUwG8xfILmwQpibXYMd3Ilw69GRoY0Kpapfn3RkHUs4Z7dHv1
         8/QcVprd/nggVkB+SFeLRH0jsKNKPS6Vur3SHEPKiqI2DHceL+hedTFXKK+dhNwUGiJK
         3VBdHBhKVOeNT8yluxLBlcvaLOLiOc7O/wL9eiyzn3XvM//rKIUtpq0InvM6rpECkOzu
         UeBM2krbUPVQWgoQdHKssCddcUPIFS0ASrQm7qZTAVhdtKMc0iENs8seLWKwqLjYv1rc
         NhpuPc+nkv5vuX3JBKkPQONYFqMT08UsoaxTSBOLLss9DK/rHMtIMuLeP+URTQJjxsis
         ckVg==
X-Gm-Message-State: AOAM532yIGPw1PSc9hClbdDiPd2Yss3l/Y1jTsWchTdbKXO0XTTsrYYk
        YYTFvSFdkOpkEvBgTHuA9oFKH/670ahcFg==
X-Google-Smtp-Source: ABdhPJwqBfo9YvoV+m+EkEDhKyLdSVKbHhf7KChaefKk0Nc5KrtQaRF4AiilNHluGp3Ih0E6z8YjoA==
X-Received: by 2002:a17:90b:4d05:: with SMTP id mw5mr8692950pjb.175.1632017621177;
        Sat, 18 Sep 2021 19:13:41 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m28sm10849537pgl.9.2021.09.18.19.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 19:13:40 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 4/4] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
Date:   Sun, 19 Sep 2021 11:13:15 +0900
Message-Id: <20210919021315.642856-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

Add buffer validation for SMB2_CREATE_CONTEXT.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c  | 35 +++++++++++++++++++++++++----------
 fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
 fs/ksmbd/smbacl.c  |  9 ++++++++-
 3 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 16b6236d1bd2..3fd2713f2282 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1451,26 +1451,41 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
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
+		if ((char *)cc + name_off + name_len > data_end ||
+		    (value_len && (char *)cc + value_off + value_len > data_end))
+			return ERR_PTR(-EINVAL);
+		else if (next && (next < name_off + name_len ||
+			 (value_len && next < value_off + value_len)))
+			return ERR_PTR(-EINVAL);
+
+		name = (char *)cc + name_off;
+		if (name_len < 4)
+			return ERR_PTR(-EINVAL);
+
+		if (memcmp(name, tag, name_len) == 0)
+			return cc;
 	} while (next != 0);
 
 	return NULL;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 117cf242d9b8..6d57827320e3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2393,6 +2393,10 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
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
@@ -2593,6 +2597,12 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -2631,6 +2641,12 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -3037,9 +3053,16 @@ int smb2_open(struct ksmbd_work *work)
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

