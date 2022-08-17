Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B678C25B08
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Aug 2022 17:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbiHQROj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241132AbiHQROX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Aug 2022 13:14:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CA1A2631
        for <linux-cifs@vger.kernel.org>; Wed, 17 Aug 2022 10:14:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DC7C23377B;
        Wed, 17 Aug 2022 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660756445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=AsOuDR8svKf5dmAQ6ktlofftlcegxV2W3B5skclkm1M=;
        b=zUWLDz/OAF/j4QBcQTJw794LsnXtZBm82+WPth4C9KungU8M8Mn14NU1bejr1C4GFS4UWa
        qOCuy/YwFfNMzMl6GfnliXfAIIB+Z03G4G2/WfNsA90QGB1FaDydm9Swk5y0bPanTfsmj7
        8qKAsXnOUcPmbhjOFB3ZjPbxD3jl0BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660756445;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=AsOuDR8svKf5dmAQ6ktlofftlcegxV2W3B5skclkm1M=;
        b=fOP8wWFSUp3T7e/KDXnq4zaz/9JORNtv9x1KgHZ53/KrELUfucXoFUgPF7ZsVVPavhzhq2
        pBy37nZ5XHyUolCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 609C213428;
        Wed, 17 Aug 2022 17:14:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EZQyCd0h/WImOQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 17 Aug 2022 17:14:05 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com
Subject: [PATCH] cifs: remove unused server parameter from calc_smb_size()
Date:   Wed, 17 Aug 2022 14:14:02 -0300
Message-Id: <20220817171402.7984-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c | 2 +-
 fs/cifs/cifsglob.h   | 2 +-
 fs/cifs/cifsproto.h  | 2 +-
 fs/cifs/misc.c       | 2 +-
 fs/cifs/netmisc.c    | 2 +-
 fs/cifs/readdir.c    | 6 ++----
 fs/cifs/smb2misc.c   | 4 ++--
 fs/cifs/smb2ops.c    | 2 +-
 fs/cifs/smb2proto.h  | 2 +-
 9 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 11fd85de7217..c05477e28cff 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -42,7 +42,7 @@ void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
 		 smb->Command, smb->Status.CifsError,
 		 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
 	cifs_dbg(VFS, "smb buf %p len %u\n", smb,
-		 server->ops->calc_smb_size(smb, server));
+		 server->ops->calc_smb_size(smb));
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bc0ee2d4b47b..f15d7b0c123d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -417,7 +417,7 @@ struct smb_version_operations {
 	int (*close_dir)(const unsigned int, struct cifs_tcon *,
 			 struct cifs_fid *);
 	/* calculate a size of SMB message */
-	unsigned int (*calc_smb_size)(void *buf, struct TCP_Server_Info *ptcpi);
+	unsigned int (*calc_smb_size)(void *buf);
 	/* check for STATUS_PENDING and process the response if yes */
 	bool (*is_status_pending)(char *buf, struct TCP_Server_Info *server);
 	/* check for STATUS_NETWORK_SESSION_EXPIRED */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 87a77a684339..3bc94bcc7177 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -151,7 +151,7 @@ extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 				  struct cifsFileInfo **ret_file);
-extern unsigned int smbCalcSize(void *buf, struct TCP_Server_Info *server);
+extern unsigned int smbCalcSize(void *buf);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 34d990f06fd6..1f2628ffe9d7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -354,7 +354,7 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 	/* otherwise, there is enough to get to the BCC */
 	if (check_smb_hdr(smb))
 		return -EIO;
-	clc_len = smbCalcSize(smb, server);
+	clc_len = smbCalcSize(smb);
 
 	if (4 + rfclen != total_read) {
 		cifs_dbg(VFS, "Length read does not match RFC1001 length %d\n",
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 28caae7aed1b..1b52e6ac431c 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -909,7 +909,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
  * portion, the number of word parameters and the data portion of the message
  */
 unsigned int
-smbCalcSize(void *buf, struct TCP_Server_Info *server)
+smbCalcSize(void *buf)
 {
 	struct smb_hdr *ptr = buf;
 	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 2eece8a07c11..8e060c00c969 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -806,8 +806,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 
 		end_of_smb = cfile->srch_inf.ntwrk_buf_start +
 			server->ops->calc_smb_size(
-					cfile->srch_inf.ntwrk_buf_start,
-					server);
+					cfile->srch_inf.ntwrk_buf_start);
 
 		cur_ent = cfile->srch_inf.srch_entries_start;
 		first_entry_in_buffer = cfile->srch_inf.index_of_last_entry
@@ -1161,8 +1160,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n",
 		 num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
 	max_len = tcon->ses->server->ops->calc_smb_size(
-			cifsFile->srch_inf.ntwrk_buf_start,
-			tcon->ses->server);
+			cifsFile->srch_inf.ntwrk_buf_start);
 	end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
 
 	tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 6a6ec6efb45a..d73e5672aac4 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -222,7 +222,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		}
 	}
 
-	calc_len = smb2_calc_size(buf, server);
+	calc_len = smb2_calc_size(buf);
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -410,7 +410,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
  * portion, the number of word parameters and the data portion of the message.
  */
 unsigned int
-smb2_calc_size(void *buf, struct TCP_Server_Info *srvr)
+smb2_calc_size(void *buf)
 {
 	struct smb2_pdu *pdu = buf;
 	struct smb2_hdr *shdr = &pdu->hdr;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f406af596887..293fdfdf374b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -387,7 +387,7 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
 		 shdr->Id.SyncId.ProcessId);
 	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
-		 server->ops->calc_smb_size(buf, server));
+		 server->ops->calc_smb_size(buf));
 #endif
 }
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 51c5bf4a338a..08f243757b9b 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -23,7 +23,7 @@ struct smb_rqst;
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
-extern unsigned int smb2_calc_size(void *buf, struct TCP_Server_Info *server);
+extern unsigned int smb2_calc_size(void *buf);
 extern char *smb2_get_data_area_len(int *off, int *len,
 				    struct smb2_hdr *shdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
-- 
2.35.3

