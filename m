Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A23C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC2961A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353397AbhJAM1T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354362AbhJAM1P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2296FC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=4sgNGeiX6lIjDAIyfrNU1nThIZ+c07EIJLYzoomm29s=; b=UnmrWgP3st7iFiMcPNp5K7Z6Q5
        Dp1kJnfb3WGBSyQYr0KVfPs1tM+fLvp1IhWUQGom58g7V92P0h3ddQukY8Z331zptj40DDnSD/IJ0
        v5lRcFWhI9zby3bjdrmB8OQFbWFQkVfBpWbx2l7rfClJmmjg4qyIcdFimyVITVpPTsbchspPSuT27
        c+BqUSZ1SoNysgckReWvDNO0Dm4bP3R+XeGclJbDrtWHNLFmFrkwN33nEGPgr4FQX4tnFgXNr7RBT
        /G8C39+pKrp6QNQMb+H+dinrlOd82dgjAZaP83RnWAJ1UWCLefTtkrjuGdJy9rr1q2k9TMG0e2I8y
        Zj8LQLfrNFfOZv/ppYY64Z10V3pyRZJ5ZUXBYQYHcoHo0yZKMVUeLmr2V9vVcGDJpo9zae4Ya51dn
        R5FmNNdCmHilWegztngR4F1s/K3gw0rWChrpCE1V62Fzvo2LYQqEs/8HccxLEMq1mUqujnVhKloDC
        FC7JtWuXrZJO1YOS6ZpNySQl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIO-0013Z3-MX; Fri, 01 Oct 2021 12:05:44 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v5 07/20] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
Date:   Fri,  1 Oct 2021 14:04:08 +0200
Message-Id: <20211001120421.327245-8-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
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
2.31.1

