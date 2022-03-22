Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936B6C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Mar 2022 06:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiCVGao (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Mar 2022 02:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiCVGan (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Mar 2022 02:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC7FC366B1
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 23:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647930553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xMkf1+J3U2a6dnGL985X0alDThsEqdVprXCeUFSpJBg=;
        b=hnYTucgmyykLVgu0QfxtAgTESpQoJj7QfL6JYzQKmlQbAccw2bMx6WWlvXGhyTxwWyj0g8
        sJiqYGAR54MYgkw6hUmHiOOVYiaLKVP2X83mkTOA/Pgd0eZCYLKP9WyULQVtlTqYaom7yn
        7DcBiC9Para4vXu6WWdTjIZWZDbCxWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-9QrHuVpTPbWXqlKS_Nmwgw-1; Tue, 22 Mar 2022 02:29:11 -0400
X-MC-Unique: 9QrHuVpTPbWXqlKS_Nmwgw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BBFF185A7B2;
        Tue, 22 Mar 2022 06:29:11 +0000 (UTC)
Received: from thinkpad (vpn2-54-164.bne.redhat.com [10.64.54.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32D9140D2821;
        Tue, 22 Mar 2022 06:29:09 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/2] cifs: convert the path to utf16 in smb2_query_info_compound
Date:   Tue, 22 Mar 2022 16:29:02 +1000
Message-Id: <20220322062903.849005-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and not in the callers.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c   | 23 ++++++++++++-----------
 fs/cifs/smb2proto.h |  2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 891b11576e55..024adb91dd57 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1192,17 +1192,12 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 	       struct cifs_sb_info *cifs_sb)
 {
 	int rc;
-	__le16 *utf16_path;
 	struct kvec rsp_iov = {NULL, 0};
 	int buftype = CIFS_NO_BUFFER;
 	struct smb2_query_info_rsp *rsp;
 	struct smb2_file_full_ea_info *info = NULL;
 
-	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
-	rc = smb2_query_info_compound(xid, tcon, utf16_path,
+	rc = smb2_query_info_compound(xid, tcon, path,
 				      FILE_READ_EA,
 				      FILE_FULL_EA_INFORMATION,
 				      SMB2_O_INFO_FILE,
@@ -1235,7 +1230,6 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 			le32_to_cpu(rsp->OutputBufferLength), ea_name);
 
  qeas_exit:
-	kfree(utf16_path);
 	free_rsp_buf(buftype, rsp_iov.iov_base);
 	return rc;
 }
@@ -1295,7 +1289,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 			 * the new EA. If not we should not add it since we
 			 * would not be able to even read the EAs back.
 			 */
-			rc = smb2_query_info_compound(xid, tcon, utf16_path,
+			rc = smb2_query_info_compound(xid, tcon, path,
 				      FILE_READ_EA,
 				      FILE_FULL_EA_INFORMATION,
 				      SMB2_O_INFO_FILE,
@@ -2646,7 +2640,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
  */
 int
 smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
-			 __le16 *utf16_path, u32 desired_access,
+			 const char *path, u32 desired_access,
 			 u32 class, u32 type, u32 output_len,
 			 struct kvec *rsp, int *buftype,
 			 struct cifs_sb_info *cifs_sb)
@@ -2664,6 +2658,13 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	int rc;
+	__le16 *utf16_path;
+
+	if (!path)
+		path = "";
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -2729,6 +2730,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	*buftype = resp_buftype[1];
 
  qic_exit:
+	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	SMB2_close_free(&rqst[2]);
@@ -2743,13 +2745,12 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_query_info_rsp *rsp;
 	struct smb2_fs_full_size_info *info = NULL;
-	__le16 utf16_path = 0; /* Null - open root of share */
 	struct kvec rsp_iov = {NULL, 0};
 	int buftype = CIFS_NO_BUFFER;
 	int rc;
 
 
-	rc = smb2_query_info_compound(xid, tcon, &utf16_path,
+	rc = smb2_query_info_compound(xid, tcon, "",
 				      FILE_READ_ATTRIBUTES,
 				      FS_FULL_SIZE_INFORMATION,
 				      SMB2_O_INFO_FILESYSTEM,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 4a7062fd1c26..a69f1eed1cfe 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -283,7 +283,7 @@ extern int smb311_update_preauth_hash(struct cifs_ses *ses,
 				      struct kvec *iov, int nvec);
 extern int smb2_query_info_compound(const unsigned int xid,
 				    struct cifs_tcon *tcon,
-				    __le16 *utf16_path, u32 desired_access,
+				    const char *path, u32 desired_access,
 				    u32 class, u32 type, u32 output_len,
 				    struct kvec *rsp, int *buftype,
 				    struct cifs_sb_info *cifs_sb);
-- 
2.30.2

