Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704E9ECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 23:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiH3Xvf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 19:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiH3Xve (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 19:51:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117ED6F27D
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 16:51:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C0DF61FA73;
        Tue, 30 Aug 2022 23:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661903490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EqrgcMHjmKi8MvUdmRW/FTdOZY9VN3LjPK9qbwWDklQ=;
        b=DpMb4TkNHAiEUfXToMCHFQ69PLlI1Mb9LvI9oN13OvLxqkPMBC+4BgIJkV+E3XMxSZuPve
        7p+5oDaJvDorJkQnaBOwknZfsUbEOXt6/HDHaN5XhskrYHlV15xOubmhBS3wEiMAt78Ud5
        5f00PdEHhDlzP29BMh6ytTdz9ytHmW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661903490;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EqrgcMHjmKi8MvUdmRW/FTdOZY9VN3LjPK9qbwWDklQ=;
        b=z86AP6Rv657qYWLly2vvjwYZxRjWkbJHnI4BmcCLBhDNy35q0yRnTeftnglcZboQGAwBFy
        To3LVc7Tx8EZnPAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40AEA13B0C;
        Tue, 30 Aug 2022 23:51:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DhIfAYKiDmPHAgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 30 Aug 2022 23:51:30 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] smb3: remove ->validate_negotiate server op
Date:   Tue, 30 Aug 2022 20:51:19 -0300
Message-Id: <20220830235119.16991-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since only SMB 3.0 and 3.0.2 uses it, and they use the same operations
struct, remove the ->validate_negotiate server op and just check for
server->dialect on the only caller (SMB2_tcon()).

- rename smb3_validate_negotiate() to smb30_validate_negotiate() to be
  more explict
- remove check for SMB311_PROT_ID since it's unreachable anyway
- simplify dialect counting by using a counter

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsglob.h  |  1 -
 fs/cifs/smb2ops.c   |  2 --
 fs/cifs/smb2pdu.c   | 62 ++++++++++++++++++++++-----------------------
 fs/cifs/smb2proto.h |  1 -
 4 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ae7f571a7dba..69067111ec66 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -474,7 +474,6 @@ struct smb_version_operations {
 	int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
 			struct cifsFileInfo *target_file, u64 src_off, u64 len,
 			u64 dest_off);
-	int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
 	ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
 			const unsigned char *, const unsigned char *, char *,
 			size_t, struct cifs_sb_info *);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f1d36b70cef7..4c5e3866a952 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5479,7 +5479,6 @@ struct smb_version_operations smb30_operations = {
 	.parse_lease_buf = smb3_parse_lease_buf,
 	.copychunk_range = smb2_copychunk_range,
 	.duplicate_extents = smb2_duplicate_extents,
-	.validate_negotiate = smb3_validate_negotiate,
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.fallocate = smb3_fallocate,
@@ -5593,7 +5592,6 @@ struct smb_version_operations smb311_operations = {
 	.parse_lease_buf = smb3_parse_lease_buf,
 	.copychunk_range = smb2_copychunk_range,
 	.duplicate_extents = smb2_duplicate_extents,
-/*	.validate_negotiate = smb3_validate_negotiate, */ /* not used in 3.11 */
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.fallocate = smb3_fallocate,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 128e44e57528..bf6460c4c8bf 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1089,9 +1089,15 @@ SMB2_negotiate(const unsigned int xid,
 	return rc;
 }
 
-int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
+/*
+ * Validate negotiate is only supported in SMB 3.0 and 3.0.2.
+ * In SMB 3.1.1, preauth integrity supersedes it.
+ *
+ * See MS-SMB2 2.2.31.4
+ */
+static int smb30_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 {
-	int rc;
+	int i, rc;
 	struct validate_negotiate_info_req *pneg_inbuf;
 	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
 	u32 rsplen;
@@ -1100,10 +1106,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	cifs_dbg(FYI, "validate negotiate\n");
 
-	/* In SMB3.11 preauth integrity supersedes validate negotiate */
-	if (server->dialect == SMB311_PROT_ID)
-		return 0;
-
 	/*
 	 * validation ioctl must be signed, so no point sending this if we
 	 * can not sign it (ie are not known user).  Even if signing is not
@@ -1143,35 +1145,30 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	else
 		pneg_inbuf->SecurityMode = 0;
 
-
-	if (strcmp(server->vals->version_string,
-		SMB3ANY_VERSION_STRING) == 0) {
-		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
-		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
-		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
-		pneg_inbuf->DialectCount = cpu_to_le16(3);
-		/* SMB 2.1 not included so subtract one dialect from len */
-		inbuflen = sizeof(*pneg_inbuf) -
-				(sizeof(pneg_inbuf->Dialects[0]));
-	} else if (strcmp(server->vals->version_string,
-		SMBDEFAULT_VERSION_STRING) == 0) {
-		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
-		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
-		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
-		pneg_inbuf->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
-		pneg_inbuf->DialectCount = cpu_to_le16(4);
+	i = 0;
+	if (!strcmp(server->vals->version_string, SMB3ANY_VERSION_STRING)) {
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB30_PROT_ID);
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB302_PROT_ID);
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB311_PROT_ID);
+		/* SMB 2.1 not included */
+	} else if (!strcmp(server->vals->version_string, SMBDEFAULT_VERSION_STRING)) {
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB21_PROT_ID);
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB30_PROT_ID);
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB302_PROT_ID);
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB311_PROT_ID);
 		/* structure is big enough for 4 dialects */
-		inbuflen = sizeof(*pneg_inbuf);
 	} else {
 		/* otherwise specific dialect was requested */
-		pneg_inbuf->Dialects[0] =
-			cpu_to_le16(server->vals->protocol_id);
-		pneg_inbuf->DialectCount = cpu_to_le16(1);
-		/* structure is big enough for 3 dialects, sending only 1 */
-		inbuflen = sizeof(*pneg_inbuf) -
-				sizeof(pneg_inbuf->Dialects[0]) * 2;
+		pneg_inbuf->Dialects[i++] = cpu_to_le16(server->vals->protocol_id);
 	}
 
+	pneg_inbuf->DialectCount = cpu_to_le16(i);
+	/*
+	 * The structure holds 4 dialects at most, so subtract the number of dialects not added,
+	 * if any.
+	 */
+	inbuflen = sizeof(*pneg_inbuf) - (sizeof(pneg_inbuf->Dialects[0]) * (4 - i));
+
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 		FSCTL_VALIDATE_NEGOTIATE_INFO,
 		(char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,
@@ -1939,8 +1936,9 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		cifs_tcon_dbg(VFS, "Encryption is requested but not supported\n");
 
 	init_copy_chunk_defaults(tcon);
-	if (server->ops->validate_negotiate)
-		rc = server->ops->validate_negotiate(xid, tcon);
+
+	if (server->dialect == SMB30_PROT_ID || server->dialect == SMB302_PROT_ID)
+		rc = smb30_validate_negotiate(xid, tcon);
 tcon_exit:
 
 	free_rsp_buf(resp_buftype, rsp);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 3f740f24b96a..da498d044d8b 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -248,7 +248,6 @@ extern int smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		      struct smb2_lock_element *buf);
 extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u8 *lease_key, const __le32 lease_state);
-extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
 extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
-- 
2.35.3

