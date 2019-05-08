Return-Path: <SRS0=nxME=TI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221A0C04A6B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 19:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8D392089E
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 19:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfEHTgc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 May 2019 15:36:32 -0400
Received: from mx1.chost.de ([5.175.28.52]:59039 "EHLO mx1.chost.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbfEHTgc (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 8 May 2019 15:36:32 -0400
Received: from vm002.chost.de ([::ffff:192.168.122.102])
  by mx1.chost.de with SMTP; Wed, 08 May 2019 21:37:15 +0200
  id 0000000001438B7D.000000005CD32FEB.000036CD
Received: by vm002.chost.de (sSMTP sendmail emulation); Wed, 08 May 2019 21:37:15 +0200
From:   Christoph Probst <kernel@probst.it>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Christoph Probst <kernel@probst.it>
Subject: [PATCH] cifs: fix checkpatch warnings and normalize strings
Date:   Wed,  8 May 2019 21:36:25 +0200
Message-Id: <1557344185-18457-1-git-send-email-kernel@probst.it>
X-Mailer: git-send-email 2.1.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix checkpatch warnings/errors in smb2ops.c except "LONG_LINE". Add missing
linebreaks, indentings, __func__. Remove void-returns, unneeded braces.

Add SPDX License Header.

Add missing "\n" and capitalize first letter in some cifs_dbg() strings.

Signed-off-by: Christoph Probst <kernel@probst.it>
---
 fs/cifs/smb2ops.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c36ff0d..9bda7e5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  SMB2 version specific operations
  *
@@ -282,7 +283,7 @@ smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
 	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
-		cifs_dbg(VFS, "encrypted frame parsing not supported yet");
+		cifs_dbg(VFS, "Encrypted frame parsing not supported yet\n");
 		return NULL;
 	}
 
@@ -324,6 +325,7 @@ static int
 smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 {
 	int rc;
+
 	ses->server->CurrentMid = 0;
 	rc = SMB2_negotiate(xid, ses);
 	/* BB we probably don't need to retry with modern servers */
@@ -789,8 +791,6 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	else
 		close_shroot(&tcon->crfid);
-
-	return;
 }
 
 static void
@@ -818,7 +818,6 @@ smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 	SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
 			FS_DEVICE_INFORMATION);
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
-	return;
 }
 
 static int
@@ -906,9 +905,8 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 		value = &src->ea_data[src->ea_name_length + 1];
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
-		if (name_len == 0) {
+		if (name_len == 0)
 			break;
-		}
 
 		if (src_size < 8 + name_len + 1 + value_len) {
 			cifs_dbg(FYI, "EA entry goes beyond length of list\n");
@@ -1161,6 +1159,7 @@ static void
 smb2_clear_stats(struct cifs_tcon *tcon)
 {
 	int i;
+
 	for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
 		atomic_set(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
 		atomic_set(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
@@ -1501,7 +1500,7 @@ smb2_copychunk_range(const unsigned int xid,
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
-	cifs_dbg(FYI, "in smb2_copychunk_range - about to call request res key\n");
+	cifs_dbg(FYI, "%s: about to call request res key\n", __func__);
 	/* Request a key from the server to identify the source of the copy */
 	rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
 				srcfile->fid.persistent_fid,
@@ -1621,6 +1620,7 @@ static unsigned int
 smb2_read_data_offset(char *buf)
 {
 	struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
+
 	return rsp->DataOffset;
 }
 
@@ -1749,7 +1749,7 @@ smb2_duplicate_extents(const unsigned int xid,
 	dup_ext_buf.SourceFileOffset = cpu_to_le64(src_off);
 	dup_ext_buf.TargetFileOffset = cpu_to_le64(dest_off);
 	dup_ext_buf.ByteCount = cpu_to_le64(len);
-	cifs_dbg(FYI, "duplicate extents: src off %lld dst off %lld len %lld",
+	cifs_dbg(FYI, "Duplicate extents: src off %lld dst off %lld len %lld\n",
 		src_off, dest_off, len);
 
 	rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
@@ -1766,7 +1766,7 @@ smb2_duplicate_extents(const unsigned int xid,
 			&ret_data_len);
 
 	if (ret_data_len > 0)
-		cifs_dbg(FYI, "non-zero response length in duplicate extents");
+		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
 duplicate_extents_out:
 	return rc;
@@ -1947,9 +1947,9 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 /*
-* If we negotiate SMB2 protocol and get STATUS_PENDING - update
-* the number of credits and return true. Otherwise - return false.
-*/
+ * If we negotiate SMB2 protocol and get STATUS_PENDING - update
+ * the number of credits and return true. Otherwise - return false.
+ */
 static bool
 smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 {
@@ -2270,7 +2270,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	struct get_dfs_referral_rsp *dfs_rsp = NULL;
 	u32 dfs_req_size = 0, dfs_rsp_size = 0;
 
-	cifs_dbg(FYI, "smb2_get_dfs_refer path <%s>\n", search_name);
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, search_name);
 
 	/*
 	 * Try to use the IPC tcon, otherwise just use any
@@ -2324,7 +2324,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 
 	if (rc) {
 		if ((rc != -ENOENT) && (rc != -EOPNOTSUPP))
-			cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
+			cifs_dbg(VFS, "ioctl error in %s rc=%d\n", __func__, rc);
 		goto out;
 	}
 
@@ -2333,7 +2333,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 				 nls_codepage, remap, search_name,
 				 true /* is_unicode */);
 	if (rc) {
-		cifs_dbg(VFS, "parse error in smb2_get_dfs_refer rc=%d\n", rc);
+		cifs_dbg(VFS, "parse error in %s rc=%d\n", __func__, rc);
 		goto out;
 	}
 
@@ -2629,7 +2629,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
 
-        trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
+	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
 
@@ -2655,7 +2655,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	cifs_dbg(FYI, "offset %lld len %lld", offset, len);
+	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
 	fsctl_buf.FileOffset = cpu_to_le64(offset);
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
@@ -2744,7 +2744,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	cifs_dbg(FYI, "offset %lld len %lld", offset, len);
+	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
 	fsctl_buf.FileOffset = cpu_to_le64(offset);
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
@@ -3237,7 +3237,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		cifs_dbg(VFS, "%s: Failed to alloc aead request", __func__);
+		cifs_dbg(VFS, "%s: Failed to alloc aead request\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -3248,7 +3248,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 
 	sg = init_sg(num_rqst, rqst, sign);
 	if (!sg) {
-		cifs_dbg(VFS, "%s: Failed to init sg", __func__);
+		cifs_dbg(VFS, "%s: Failed to init sg\n", __func__);
 		rc = -ENOMEM;
 		goto free_req;
 	}
@@ -3256,7 +3256,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	iv_len = crypto_aead_ivsize(tfm);
 	iv = kzalloc(iv_len, GFP_KERNEL);
 	if (!iv) {
-		cifs_dbg(VFS, "%s: Failed to alloc IV", __func__);
+		cifs_dbg(VFS, "%s: Failed to alloc IV\n", __func__);
 		rc = -ENOMEM;
 		goto free_sg;
 	}
@@ -3364,7 +3364,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	fill_transform_hdr(tr_hdr, orig_len, old_rq);
 
 	rc = crypt_message(server, num_rqst, new_rq, 1);
-	cifs_dbg(FYI, "encrypt message returned %d", rc);
+	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
 	if (rc)
 		goto err_free;
 
@@ -3405,7 +3405,7 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 	rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
 
 	rc = crypt_message(server, 1, &rqst, 0);
-	cifs_dbg(FYI, "decrypt message returned %d\n", rc);
+	cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
 
 	if (rc)
 		return rc;
-- 
2.1.4

