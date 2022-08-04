Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43E0C19F29
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 00:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbiHDAUK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Aug 2022 20:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240379AbiHDAUE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Aug 2022 20:20:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5175F10F
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 17:19:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1DAE43F072;
        Thu,  4 Aug 2022 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659572391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+U1AH+JGB/nq8iGJxJVwPCKVbAFvZrDaEmLRRqFZrHo=;
        b=bshyayQPVNNiEEyqjiPpQf2RQWsZg0C+0BedfkfKjoQVfKFb3zJGPugDApsy1GNBT2mSj/
        /gmGBTuJz1LfmgJSva1OJzRgP3Q5FXrrniIVXlvg5mqd9PH5+Hv2OjnzoM7mM6XDEE5nvW
        WUVmCpn6BTYXrKHUQDUOnQVDxx+4Ves=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659572391;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+U1AH+JGB/nq8iGJxJVwPCKVbAFvZrDaEmLRRqFZrHo=;
        b=drGPicQxHaq8epYHjOoJrkunnv0+8/FncPxlVCnpds9Pb5hxPXn67Jxci3EQLVLr3DDxLH
        G16m55uPREM0pNDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4719F13A8E;
        Thu,  4 Aug 2022 00:19:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YR69AaYQ62LHCwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 04 Aug 2022 00:19:50 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH v2] cifs: remove some more dead code
Date:   Wed,  3 Aug 2022 21:15:33 -0300
Message-Id: <20220804001532.15833-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove more old commented code, leaving comments where appropriate.

Even though the compiler would probably wipe away the cifs*dbg() macros
contents (because of "if (0)"), leaving any explicit content in them can
be confusing, so also remove them.

Mark variables used only for debugging as __maybe_unused.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2:
- Fix warnings reported by kernel test robot
- Remove even more dead code
- Add a couple IS_ENABLED(CONFIG_CIFS_DEBUG) checks to wrap
  debug-only variables
- Adjust comments for unused/reserved code so it doesn't looke like
  commented/dead code

 fs/cifs/cifs_debug.c   |  2 --
 fs/cifs/cifs_debug.h   | 30 ++++++--------------------
 fs/cifs/cifs_dfs_ref.c |  3 ---
 fs/cifs/cifs_swn.c     | 24 +++++++++++++--------
 fs/cifs/cifsacl.c      |  6 ------
 fs/cifs/cifsencrypt.c  |  3 ---
 fs/cifs/cifsfs.c       | 32 ++++-----------------------
 fs/cifs/cifsglob.h     |  2 +-
 fs/cifs/cifspdu.h      | 20 +++--------------
 fs/cifs/cifsproto.h    |  1 -
 fs/cifs/cifssmb.c      | 31 --------------------------
 fs/cifs/connect.c      |  8 +++----
 fs/cifs/dir.c          | 18 ----------------
 fs/cifs/export.c       |  6 ------
 fs/cifs/file.c         |  3 ---
 fs/cifs/inode.c        |  4 +---
 fs/cifs/ioctl.c        | 12 -----------
 fs/cifs/link.c         |  3 ---
 fs/cifs/misc.c         | 20 ++++++-----------
 fs/cifs/netmisc.c      |  6 ------
 fs/cifs/ntlmssp.h      | 14 ++++++------
 fs/cifs/readdir.c      | 49 +++++++++---------------------------------
 fs/cifs/sess.c         | 34 ++++++++++++++++-------------
 fs/cifs/smb2misc.c     |  5 +++--
 fs/cifs/smb2ops.c      |  1 -
 fs/cifs/smb2pdu.c      | 44 +------------------------------------
 fs/cifs/smberr.h       |  4 ----
 fs/cifs/transport.c    |  1 -
 28 files changed, 80 insertions(+), 306 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 11fd85de7217..24d42a3b5c58 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -1033,8 +1033,6 @@ static const struct proc_ops cifs_mount_params_proc_ops = {
 	.proc_read	= seq_read,
 	.proc_lseek	= seq_lseek,
 	.proc_release	= single_release,
-	/* No need for write for now */
-	/* .proc_write	= cifs_mount_params_proc_write, */
 };
 
 #else
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index ee4ea2b60c0f..dca47ebb3073 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -133,28 +133,10 @@ do {									\
  *	debug OFF
  *	---------
  */
-#else		/* _CIFS_DEBUG */
-#define cifs_dbg(type, fmt, ...)					\
-do {									\
-	if (0)								\
-		pr_debug(fmt, ##__VA_ARGS__);				\
-} while (0)
-
-#define cifs_server_dbg(type, fmt, ...)					\
-do {									\
-	if (0)								\
-		pr_debug("\\\\%s " fmt,					\
-			 server->hostname, ##__VA_ARGS__);		\
-} while (0)
-
-#define cifs_tcon_dbg(type, fmt, ...)					\
-do {									\
-	if (0)								\
-		pr_debug("%s " fmt, tcon->treeName, ##__VA_ARGS__);	\
-} while (0)
-
-#define cifs_info(fmt, ...)						\
-	pr_info(fmt, ##__VA_ARGS__)
-#endif
-
+#else /* _CIFS_DEBUG */
+#define cifs_dbg(type, fmt, ...) do {} while (0)
+#define cifs_server_dbg(type, fmt, ...) do {} while (0)
+#define cifs_tcon_dbg(type, fmt, ...) do {} while (0)
+#define cifs_info(fmt, ...) pr_info(fmt, ##__VA_ARGS__)
+#endif /* !CONFIG_CIFS_DEBUG */
 #endif				/* _H_CIFS_DEBUG */
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b0864da9ef43..23fa4fa3cb16 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -244,9 +244,6 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	else
 		kfree(name);
 
-	/*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
-	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
-
 compose_mount_options_out:
 	kfree(srvIP);
 	return mountdata;
diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 1e4c7cc5287f..a42fcf44f004 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -258,7 +258,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 
 	net_name = extract_hostname(tcon->treeName);
 	if (IS_ERR(net_name)) {
-		int ret;
+		int ret __maybe_unused;
 
 		ret = PTR_ERR(net_name);
 		cifs_dbg(VFS, "%s: failed to extract host name from target '%s': %d\n",
@@ -268,7 +268,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 
 	share_name = extract_sharename(tcon->treeName);
 	if (IS_ERR(share_name)) {
-		int ret;
+		int ret __maybe_unused;
 
 		ret = PTR_ERR(share_name);
 		cifs_dbg(VFS, "%s: failed to extract share name from target '%s': %d\n",
@@ -508,13 +508,19 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 
 static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
 {
-	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
-	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
-
-	if (addr->ss_family == AF_INET)
-		cifs_dbg(FYI, "%s: move to %pI4\n", __func__, &ipv4->sin_addr);
-	else if (addr->ss_family == AF_INET6)
-		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
+	if (IS_ENABLED(CONFIG_CIFS_DEBUG)) {
+		struct sockaddr_in *ipv4 __maybe_unused =
+			(struct sockaddr_in *)addr;
+		struct sockaddr_in6 *ipv6 __maybe_unused =
+			(struct sockaddr_in6 *)addr;
+
+		if (addr->ss_family == AF_INET)
+			cifs_dbg(FYI, "%s: move to %pI4\n", __func__,
+				 &ipv4->sin_addr);
+		else if (addr->ss_family == AF_INET6)
+			cifs_dbg(FYI, "%s: move to %pI6\n", __func__,
+				 &ipv6->sin6_addr);
+	}
 
 	return cifs_swn_reconnect(swnreg->tcon, addr);
 }
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index fa480d62f313..5179a483e5f2 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -841,11 +841,6 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 				}
 			}
 
-
-/*			memcpy((void *)(&(cifscred->aces[i])),
-				(void *)ppace[i],
-				sizeof(struct cifs_ace)); */
-
 			acl_base = (char *)ppace[i];
 			acl_size = le16_to_cpu(ppace[i]->size);
 		}
@@ -1208,7 +1203,6 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
-/*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 8f7835ccbca1..b6ab4c651982 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -243,9 +243,6 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	if (rc)
 		return rc;
 
-/*	cifs_dump_mem("what we think it should be: ",
-		      what_we_think_sig_should_be, 16); */
-
 	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index af4c5632490e..22b0d215447e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -66,7 +66,6 @@ bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
-/* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
 
 /*
@@ -413,11 +412,6 @@ cifs_alloc_inode(struct super_block *sb)
 	spin_lock_init(&cifs_inode->open_file_lock);
 	generate_random_uuid(cifs_inode->lease_key);
 
-	/*
-	 * Can not set i_flags here - they get immediately overwritten to zero
-	 * by the VFS.
-	 */
-	/* cifs_inode->netfs.inode.i_flags = S_NOATIME | S_NOCMTIME; */
 	INIT_LIST_HEAD(&cifs_inode->openFileList);
 	INIT_LIST_HEAD(&cifs_inode->llist);
 	INIT_LIST_HEAD(&cifs_inode->deferred_closes);
@@ -744,8 +738,6 @@ static void cifs_umount_begin(struct super_block *sb)
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
-	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
 		wake_up_all(&tcon->ses->server->request_q);
@@ -759,14 +751,6 @@ static void cifs_umount_begin(struct super_block *sb)
 	return;
 }
 
-#ifdef CONFIG_CIFS_STATS2
-static int cifs_show_stats(struct seq_file *s, struct dentry *root)
-{
-	/* BB FIXME */
-	return 0;
-}
-#endif
-
 static int cifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	fscache_unpin_writeback(wbc, cifs_inode_cookie(inode));
@@ -789,17 +773,9 @@ static const struct super_operations cifs_super_ops = {
 	.free_inode = cifs_free_inode,
 	.drop_inode	= cifs_drop_inode,
 	.evict_inode	= cifs_evict_inode,
-/*	.show_path	= cifs_show_path, */ /* Would we ever need show path? */
 	.show_devname   = cifs_show_devname,
-/*	.delete_inode	= cifs_delete_inode,  */  /* Do not need above
-	function unless later we add lazy close of inodes or unless the
-	kernel forgets to call us with the same number of releases (closes)
-	as opens */
 	.show_options = cifs_show_options,
 	.umount_begin   = cifs_umount_begin,
-#ifdef CONFIG_CIFS_STATS2
-	.show_stats = cifs_show_stats,
-#endif
 };
 
 /*
@@ -1290,11 +1266,11 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
  * Directory operations under CIFS/SMB2/SMB3 are synchronous, so fsync()
  * is a dummy operation.
  */
-static int cifs_dir_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+static int cifs_dir_fsync(struct file *file __always_unused,
+			  loff_t start __always_unused,
+			  loff_t end __always_unused,
+			  int datasync __always_unused)
 {
-	cifs_dbg(FYI, "Sync directory - name: %pD datasync: 0x%x\n",
-		 file, datasync);
-
 	return 0;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3070407cafa7..f821f7a987fd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2081,7 +2081,7 @@ extern struct smb_version_operations smb30_operations;
 extern struct smb_version_values smb30_values;
 #define SMB302_VERSION_STRING	"3.02"
 #define ALT_SMB302_VERSION_STRING "3.0.2"
-/*extern struct smb_version_operations smb302_operations;*/ /* not needed yet */
+/* no need for a smb302_operations yet */
 extern struct smb_version_values smb302_values;
 #define SMB311_VERSION_STRING	"3.1.1"
 #define ALT_SMB311_VERSION_STRING "3.11"
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index aeba371c4c70..40d61cf9ed35 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1600,8 +1600,8 @@ struct smb_t2_rsp {
 #define SMB_QUERY_ATTR_FLAGS            0x206  /* append,immutable etc. */
 #define SMB_QUERY_POSIX_PERMISSION      0x207
 #define SMB_QUERY_POSIX_LOCK            0x208
-/* #define SMB_POSIX_OPEN               0x209 */
-/* #define SMB_POSIX_UNLINK             0x20a */
+/* SMB_POSIX_OPEN			0x209 */ /* unused */
+/* SMB_POSIX_UNLINK			0x20a */ /* unused */
 #define SMB_QUERY_FILE__UNIX_INFO2      0x20b
 #define SMB_QUERY_FILE_INTERNAL_INFO    0x3ee
 #define SMB_QUERY_FILE_ACCESS_INFO      0x3f0
@@ -1646,7 +1646,7 @@ struct smb_t2_rsp {
 #define SMB_FIND_FILE_ID_FULL_DIR_INFO    0x105
 #define SMB_FIND_FILE_ID_BOTH_DIR_INFO    0x106
 #define SMB_FIND_FILE_UNIX                0x202
-/* #define SMB_FIND_FILE_POSIX_INFO          0x064 */
+/* SMB_FIND_FILE_POSIX_INFO		  0x064 */ /* unused */
 
 typedef struct smb_com_transaction2_qpi_req {
 	struct smb_hdr hdr;	/* wct = 14+ */
@@ -1935,7 +1935,6 @@ typedef struct whoami_rsp_data { /* Query level 0x202 */
 /* SETFSInfo Levels */
 #define SMB_SET_CIFS_UNIX_INFO    0x200
 /* level 0x203 is defined above in list of QFS info levels */
-/* #define SMB_REQUEST_TRANSPORT_ENCRYPTION 0x203 */
 
 /* Level 0x200 request structure follows */
 typedef struct smb_com_transaction2_setfsi_req {
@@ -2412,19 +2411,6 @@ struct cifs_posix_acl { /* access conrol list  (ACL) */
 	struct cifs_posix_ace default_ace_arraay[] */
 } __attribute__((packed));  /* level 0x204 */
 
-/* types of access control entries already defined in posix_acl.h */
-/* #define CIFS_POSIX_ACL_USER_OBJ	 0x01
-#define CIFS_POSIX_ACL_USER      0x02
-#define CIFS_POSIX_ACL_GROUP_OBJ 0x04
-#define CIFS_POSIX_ACL_GROUP     0x08
-#define CIFS_POSIX_ACL_MASK      0x10
-#define CIFS_POSIX_ACL_OTHER     0x20 */
-
-/* types of perms */
-/* #define CIFS_POSIX_ACL_EXECUTE   0x01
-#define CIFS_POSIX_ACL_WRITE     0x02
-#define CIFS_POSIX_ACL_READ	     0x04 */
-
 /* end of POSIX ACL definitions */
 
 /* POSIX Open Flags */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index de167e3af015..5b4358d5a412 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,7 +78,6 @@ extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
 		char **devname);
-/* extern void renew_parental_timestamps(struct dentry *direntry);*/
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 26b9d2438228..89cebf08c057 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1115,11 +1115,6 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	if (create_options & CREATE_OPTION_READONLY)
 		pSMB->FileAttributes |= cpu_to_le16(ATTR_READONLY);
 
-	/* BB FIXME BB */
-/*	pSMB->CreateOptions = cpu_to_le32(create_options &
-						 CREATE_OPTIONS_MASK); */
-	/* BB FIXME END BB */
-
 	pSMB->Sattr = cpu_to_le16(ATTR_HIDDEN | ATTR_SYSTEM | ATTR_DIRECTORY);
 	pSMB->OpenFunction = cpu_to_le16(convert_disposition(openDisposition));
 	count += name_len;
@@ -1133,16 +1128,9 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Error in Open = %d\n", rc);
 	} else {
 	/* BB verify if wct == 15 */
-
-/*		*pOplock = pSMBr->OplockLevel; */ /* BB take from action field*/
-
 		*netfid = pSMBr->Fid;   /* cifs fid stays in le */
 		/* Let caller know file was created so we can set the mode. */
 		/* Do we care about the CreateAction in any other cases? */
-	/* BB FIXME BB */
-/*		if (cpu_to_le32(FILE_CREATE) == pSMBr->CreateAction)
-			*pOplock |= CIFS_CREATE_ACTION; */
-	/* BB FIXME END */
 
 		if (pfile_info) {
 			pfile_info->CreationTime = 0; /* BB convert CreateTime*/
@@ -1491,10 +1479,6 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 		} else {
 			pReadData = (char *) (&pSMBr->hdr.Protocol) +
 					le16_to_cpu(pSMBr->DataOffset);
-/*			if (rc = copy_to_user(buf, pReadData, data_length)) {
-				cifs_dbg(VFS, "Faulting on read rc = %d\n",rc);
-				rc = -EFAULT;
-			}*/ /* can not use copy_to_user when using page cache*/
 			if (*buf)
 				memcpy(*buf, pReadData, data_length);
 		}
@@ -1535,7 +1519,6 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	*nbytes = 0;
 
-	/* cifs_dbg(FYI, "write at %lld %d bytes\n", offset, count);*/
 	if (tcon->ses == NULL)
 		return -ECONNABORTED;
 
@@ -1934,7 +1917,6 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
-/*	LOCK_RSP *pSMBr = NULL; */ /* No response data other than rc to parse */
 	int bytes_returned;
 	int flags = 0;
 	__u16 count;
@@ -2922,10 +2904,6 @@ static void cifs_convert_ace(struct posix_acl_xattr_entry *ace,
 	ace->e_perm = cpu_to_le16(cifs_ace->cifs_e_perm);
 	ace->e_tag  = cpu_to_le16(cifs_ace->cifs_e_tag);
 	ace->e_id   = cpu_to_le32(le64_to_cpu(cifs_ace->cifs_uid));
-/*
-	cifs_dbg(FYI, "perm %d tag %d id %d\n",
-		 ace->e_perm, ace->e_tag, ace->e_id);
-*/
 
 	return;
 }
@@ -2999,10 +2977,6 @@ static void convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
 		cifs_ace->cifs_uid = cpu_to_le64(-1);
 	} else
 		cifs_ace->cifs_uid = cpu_to_le64(le32_to_cpu(local_ace->e_id));
-/*
-	cifs_dbg(FYI, "perm %d tag %d id %d\n",
-		 ace->e_perm, ace->e_tag, ace->e_id);
-*/
 }
 
 /* Convert ACL from local Linux POSIX xattr to CIFS POSIX ACL wire format */
@@ -3689,7 +3663,6 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	/* cifs_dbg(FYI, "In QPathInfo path %s\n", search_name); */
 QPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4194,9 +4167,6 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 				psrch_inf->last_entry =
 					psrch_inf->srch_entries_start + lnoff;
 
-/*  cifs_dbg(FYI, "fnxt2 entries in buf %d index_of_last %d\n",
-    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry); */
-
 			/* BB fixme add unlock here */
 		}
 
@@ -5880,7 +5850,6 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/*BB add length check to see if it would fit in
 	     negotiated SMB buffer size BB */
-	/* if (ea_value_len > buffer_size - 512 (enough for header)) */
 	if (ea_value_len)
 		memcpy(parm_data->list[0].name+name_len+1,
 		       ea_value, ea_value_len);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index abb65dd7471f..8788e352405e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2144,8 +2144,8 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 }
 #else /* ! CONFIG_KEYS */
 static inline int
-cifs_set_cifscreds(struct smb3_fs_context *ctx __attribute__((unused)),
-		   struct cifs_ses *ses __attribute__((unused)))
+cifs_set_cifscreds(struct smb3_fs_context *ctx __always_unused,
+		   struct cifs_ses *ses __always_unused)
 {
 	return -ENOSYS;
 }
@@ -2809,8 +2809,8 @@ bind_socket(struct TCP_Server_Info *server)
 				       (struct sockaddr *) &server->srcaddr,
 				       sizeof(server->srcaddr));
 		if (rc < 0) {
-			struct sockaddr_in *saddr4;
-			struct sockaddr_in6 *saddr6;
+			struct sockaddr_in *saddr4 __maybe_unused;
+			struct sockaddr_in6 *saddr6 __maybe_unused;
 			saddr4 = (struct sockaddr_in *)&server->srcaddr;
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 08f7392716e2..a75c07aecd44 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -344,14 +344,6 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		}
 		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fid->netfid,
 				       current->tgid);
-	} else {
-		/*
-		 * BB implement mode setting via Windows security
-		 * descriptors e.g.
-		 */
-		/* CIFSSMBWinSetPerms(xid,tcon,path,mode,-1,-1,nls);*/
-
-		/* Could set r/o dos attribute if mode & 0222 == 0 */
 	}
 
 cifs_create_get_file_info:
@@ -782,19 +774,9 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 	return 1;
 }
 
-/* static int cifs_d_delete(struct dentry *direntry)
-{
-	int rc = 0;
-
-	cifs_dbg(FYI, "In cifs d_delete, name = %pd\n", direntry);
-
-	return rc;
-}     */
-
 const struct dentry_operations cifs_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
 	.d_automount = cifs_dfs_d_automount,
-/* d_delete:       cifs_d_delete,      */ /* not needed except for debugging */
 };
 
 static int cifs_ci_hash(const struct dentry *dentry, struct qstr *q)
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 37c28415df1e..550e7e846c54 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -42,12 +42,6 @@ static struct dentry *cifs_get_parent(struct dentry *dentry)
 
 const struct export_operations cifs_export_ops = {
 	.get_parent = cifs_get_parent,
-/*	Following five export operations are unneeded so far and can default:
-	.get_dentry =
-	.get_name =
-	.find_exported_dentry =
-	.decode_fh =
-	.encode_fs =  */
 };
 
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 85f2abcb2795..06f90e02959a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -89,9 +89,6 @@ static inline int cifs_convert_flags(unsigned int flags)
 	else if ((flags & O_ACCMODE) == O_WRONLY)
 		return GENERIC_WRITE;
 	else if ((flags & O_ACCMODE) == O_RDWR) {
-		/* GENERIC_ALL is too much permission to request
-		   can cause unnecessary access denied on create */
-		/* return GENERIC_ALL; */
 		return (GENERIC_READ | GENERIC_WRITE);
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index eeeaba3dec05..fc83c8845340 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -632,8 +632,6 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
 	fattr->cf_mode = (umode_t) le32_to_cpu(info->Mode);
-	/* The srv fs device id is overridden on network mount so setting rdev isn't needed here */
-	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
 	if (symlink) {
 		fattr->cf_mode |= S_IFLNK;
@@ -2324,7 +2322,7 @@ cifs_invalidate_mapping(struct inode *inode)
  * @mode:	the task state to sleep in
  */
 static int
-cifs_wait_bit_killable(struct wait_bit_key *key, int mode)
+cifs_wait_bit_killable(struct wait_bit_key *key __always_unused, int mode)
 {
 	freezable_schedule_unsafe();
 	if (signal_pending_state(mode, current))
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index b6e6e5d6c8dd..8ceb000da50f 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -170,7 +170,6 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 		return 0;
 
 	cifs_dbg(VFS, "shut down requested (%d)", flags);
-/*	trace_cifs_shutdown(sb, flags);*/
 
 	/*
 	 * see:
@@ -360,23 +359,12 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			if (pSMBFile == NULL)
 				break;
 			tcon = tlink_tcon(pSMBFile->tlink);
-			/* caps = le64_to_cpu(tcon->fsUnixInfo.Capability); */
 
 			if (get_user(ExtAttrBits, (int __user *)arg)) {
 				rc = -EFAULT;
 				break;
 			}
 
-			/*
-			 * if (CIFS_UNIX_EXTATTR_CAP & caps)
-			 *	rc = CIFSSetExtAttr(xid, tcon,
-			 *		       pSMBFile->fid.netfid,
-			 *		       extAttrBits,
-			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
-			 *	break;
-			 */
-
 			/* Currently only flag we can set is compressed flag */
 			if ((ExtAttrBits & FS_COMPR_FL) == 0)
 				break;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 6803cb27eecc..1c0ea6474040 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -716,9 +716,6 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
 					   cifs_sb->local_nls,
 					   cifs_remap(cifs_sb));
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	/* else
-	   rc = CIFSCreateReparseSymLink(xid, pTcon, fromName, toName,
-					cifs_sb_target->local_nls); */
 
 	if (rc == 0) {
 		if (pTcon->posix_extensions)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 7a906067db04..f475bf1127c5 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -55,8 +55,6 @@ void
 _free_xid(unsigned int xid)
 {
 	spin_lock(&GlobalMid_Lock);
-	/* if (GlobalTotalActiveXid == 0)
-		BUG(); */
 	GlobalTotalActiveXid--;
 	spin_unlock(&GlobalMid_Lock);
 }
@@ -185,10 +183,9 @@ cifs_buf_get(void)
 void
 cifs_buf_release(void *buf_to_free)
 {
-	if (buf_to_free == NULL) {
-		/* cifs_dbg(FYI, "Null buffer passed to cifs_buf_release\n");*/
+	if (buf_to_free == NULL)
 		return;
-	}
+
 	mempool_free(buf_to_free, cifs_req_poolp);
 
 	atomic_dec(&buf_alloc_count);
@@ -205,8 +202,6 @@ cifs_small_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
 	ret_buf = mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
-	/* No need to clear memory here, cleared in header assemble */
-	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
 	atomic_inc(&small_buf_alloc_count);
 #ifdef CONFIG_CIFS_STATS2
 	atomic_inc(&total_small_buf_alloc_count);
@@ -365,7 +360,6 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 	}
 
 	if (4 + rfclen != clc_len) {
-		__u16 mid = get_mid(smb);
 		/* check if bcc wrapped around for large read responses */
 		if ((rfclen > 64 * 1024) && (rfclen > clc_len)) {
 			/* check if lengths match mod 64K */
@@ -373,11 +367,11 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 				return 0; /* bcc wrapped */
 		}
 		cifs_dbg(FYI, "Calculated size %u vs length %u mismatch for mid=%u\n",
-			 clc_len, 4 + rfclen, mid);
+			 clc_len, 4 + rfclen, get_mid(smb));
 
 		if (4 + rfclen < clc_len) {
 			cifs_dbg(VFS, "RFC1001 size %u smaller than SMB for mid=%u\n",
-				 rfclen, mid);
+				 rfclen, get_mid(smb));
 			return -EIO;
 		} else if (rfclen > clc_len + 512) {
 			/*
@@ -390,7 +384,7 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 			 * data to 512 bytes.
 			 */
 			cifs_dbg(VFS, "RFC1001 size %u more than 512 bytes larger than SMB for mid=%u\n",
-				 rfclen, mid);
+				 rfclen, get_mid(smb));
 			return -EIO;
 		}
 	}
@@ -412,11 +406,11 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	   (pSMB->hdr.Flags & SMBFLG_RESPONSE)) {
 		struct smb_com_transaction_change_notify_rsp *pSMBr =
 			(struct smb_com_transaction_change_notify_rsp *)buf;
-		struct file_notify_information *pnotify;
 		__u32 data_offset = 0;
 		size_t len = srv->total_read - sizeof(pSMBr->hdr.smb_buf_length);
 
 		if (get_bcc(buf) > sizeof(struct file_notify_information)) {
+			struct file_notify_information *pnotify __maybe_unused;
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
 
 			if (data_offset >
@@ -429,8 +423,6 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 				((char *)&pSMBr->hdr.Protocol + data_offset);
 			cifs_dbg(FYI, "dnotify on %s Action: 0x%x\n",
 				 pnotify->FileName, pnotify->Action);
-			/*   cifs_dump_mem("Rcvd notify Data: ",buf,
-				sizeof(struct smb_hdr)+60); */
 			return true;
 		}
 		if (pSMBr->hdr.Status.CifsError) {
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 28caae7aed1b..0c832487051b 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -103,10 +103,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{ERRusestd, -EIO},
 	{ERR_NOTIFY_ENUM_DIR, -ENOBUFS},
 	{ERRnoSuchUser, -EACCES},
-/*	{ERRaccountexpired, -EACCES},
-	{ERRbadclient, -EACCES},
-	{ERRbadLogonTime, -EACCES},
-	{ERRpasswordExpired, -EACCES},*/
 	{ERRaccountexpired, -EKEYEXPIRED},
 	{ERRbadclient, -EACCES},
 	{ERRbadLogonTime, -EACCES},
@@ -1014,8 +1010,6 @@ struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 
 	ts.tv_sec = sec + offset;
 
-	/* cifs_dbg(FYI, "sec after cnvrt dos to unix time %d\n",sec); */
-
 	ts.tv_nsec = 0;
 	return ts;
 }
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 55758b9ec877..b489338b2c09 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -17,12 +17,12 @@
 #define NTLMSSP_NEGOTIATE_UNICODE         0x01 /* Text strings are unicode */
 #define NTLMSSP_NEGOTIATE_OEM             0x02 /* Text strings are in OEM */
 #define NTLMSSP_REQUEST_TARGET            0x04 /* Srv returns its auth realm */
-/* define reserved9                       0x08 */
+/* reserved9				0x08 */
 #define NTLMSSP_NEGOTIATE_SIGN          0x0010 /* Request signing capability */
 #define NTLMSSP_NEGOTIATE_SEAL          0x0020 /* Request confidentiality */
 #define NTLMSSP_NEGOTIATE_DGRAM         0x0040
 #define NTLMSSP_NEGOTIATE_LM_KEY        0x0080 /* Use LM session key */
-/* defined reserved 8                   0x0100 */
+/* reserved 8				0x0100 */
 #define NTLMSSP_NEGOTIATE_NTLM          0x0200 /* NTLM authentication */
 #define NTLMSSP_NEGOTIATE_NT_ONLY       0x0400 /* Lanman not allowed */
 #define NTLMSSP_ANONYMOUS               0x0800
@@ -34,16 +34,16 @@
 #define NTLMSSP_TARGET_TYPE_SERVER     0x20000
 #define NTLMSSP_TARGET_TYPE_SHARE      0x40000
 #define NTLMSSP_NEGOTIATE_EXTENDED_SEC 0x80000 /* NB:not related to NTLMv2 pwd*/
-/* #define NTLMSSP_REQUEST_INIT_RESP     0x100000 */
+/* NTLMSSP_REQUEST_INIT_RESP     0x100000 */ /* unused */
 #define NTLMSSP_NEGOTIATE_IDENTIFY    0x100000
 #define NTLMSSP_REQUEST_ACCEPT_RESP   0x200000 /* reserved5 */
 #define NTLMSSP_REQUEST_NON_NT_KEY    0x400000
 #define NTLMSSP_NEGOTIATE_TARGET_INFO 0x800000
-/* #define reserved4                 0x1000000 */
+/* reserved4			     0x1000000 */
 #define NTLMSSP_NEGOTIATE_VERSION    0x2000000 /* we only set for SMB2+ */
-/* #define reserved3                 0x4000000 */
-/* #define reserved2                 0x8000000 */
-/* #define reserved1                0x10000000 */
+/* reserved3			     0x4000000 */
+/* reserved2			     0x8000000 */
+/* reserved1			    0x10000000 */
 #define NTLMSSP_NEGOTIATE_128       0x20000000
 #define NTLMSSP_NEGOTIATE_KEY_XCH   0x40000000
 #define NTLMSSP_NEGOTIATE_56        0x80000000
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 384cabdf47ca..5d7863af757f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -335,36 +335,11 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 	cifs_fill_common_info(fattr, cifs_sb);
 }
 
-/* BB eventually need to add the following helper function to
-      resolve NT_STATUS_STOPPED_ON_SYMLINK return code when
-      we try to do FindFirst on (NTFS) directory symlinks */
 /*
-int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
-			     unsigned int xid)
-{
-	__u16 fid;
-	int len;
-	int oplock = 0;
-	int rc;
-	struct cifs_tcon *ptcon = cifs_sb_tcon(cifs_sb);
-	char *tmpbuffer;
-
-	rc = CIFSSMBOpen(xid, ptcon, full_path, FILE_OPEN, GENERIC_READ,
-			OPEN_REPARSE_POINT, &fid, &oplock, NULL,
-			cifs_sb->local_nls,
-			cifs_remap(cifs_sb);
-	if (!rc) {
-		tmpbuffer = kmalloc(maxpath);
-		rc = CIFSSMBQueryReparseLinkInfo(xid, ptcon, full_path,
-				tmpbuffer,
-				maxpath -1,
-				fid,
-				cifs_sb->local_nls);
-		if (CIFSSMBClose(xid, ptcon, fid)) {
-			cifs_dbg(FYI, "Error closing temporary reparsepoint open\n");
-		}
-	}
-}
+ * TODO: eventually need to add a helper function to
+ * resolve NT_STATUS_STOPPED_ON_SYMLINK return code when
+ * we try to do FindFirst on (NTFS) directory symlinks
+ * (see below)
  */
 
 static int
@@ -411,9 +386,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	cifs_dbg(FYI, "Full path: %s start at: %lld\n", full_path, file->f_pos);
 
 ffirst_retry:
-	/* test for Unix extensions */
-	/* but now check for them on the share/mount not on the SMB session */
-	/* if (cap_unix(tcon->ses) { */
+	/* test for Unix extensions on the share/mount, not on the SMB session */
 	if (tcon->unix_ext)
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_UNIX;
 	else if (tcon->posix_extensions)
@@ -437,9 +410,10 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 
 	if (rc == 0)
 		cifsFile->invalidHandle = false;
-	/* BB add following call to handle readdir on new NTFS symlink errors
-	else if STATUS_STOPPED_ON_SYMLINK
-		call get_symlink_reparse_path and retry with new path */
+	/*
+	 * TODO: handle readdir on new NTFS symlink errors here
+	 * (STATUS_STOPPED_ON_SYMLINK) and retry with new path
+	 */
 	else if ((rc == -EOPNOTSUPP) &&
 		(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
@@ -1134,10 +1108,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 			rc = 0;
 			goto rddir2_exit;
 		}
-	} /* else {
-		cifsFile->invalidHandle = true;
-		tcon->ses->server->close(xid, tcon, &cifsFile->fid);
-	} */
+	}
 
 	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3af3b05b6c74..a9d888c5cb86 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -361,19 +361,28 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	struct smb3_fs_context ctx = {NULL};
 	static const char unc_fmt[] = "\\%s\\foo";
 	char unc[sizeof(unc_fmt)+SERVER_NAME_LEN_WITH_NULL] = {0};
-	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
-	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
 	int rc;
 	unsigned int xid = get_xid();
 
-	if (iface->sockaddr.ss_family == AF_INET)
-		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI4)\n",
-			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
-			 &ipv4->sin_addr);
-	else
-		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI6)\n",
-			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
-			 &ipv6->sin6_addr);
+	if (IS_ENABLED(CONFIG_CIFS_DEBUG)) {
+		struct sockaddr_in *ipv4 __maybe_unused =
+			(struct sockaddr_in *)&iface->sockaddr;
+		struct sockaddr_in6 *ipv6 __maybe_unused =
+			(struct sockaddr_in6 *)&iface->sockaddr;
+
+		if (iface->sockaddr.ss_family == AF_INET)
+			cifs_dbg(FYI, "adding channel to ses %p "
+				 "(speed:%zu bps rdma:%s ip:%pI4)\n",
+				 ses, iface->speed,
+				 iface->rdma_capable ? "yes" : "no",
+				 &ipv4->sin_addr);
+		else
+			cifs_dbg(FYI, "adding channel to ses %p "
+				 "(speed:%zu bps rdma:%s ip:%pI6)\n",
+				 ses, iface->speed,
+				 iface->rdma_capable ? "yes" : "no",
+				 &ipv6->sin6_addr);
+	}
 
 	/*
 	 * Setup a ctx with mostly the same info as the existing
@@ -601,11 +610,6 @@ static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 	/* BB FIXME add check that strings total less
 	than 335 or will need to send them as arrays */
 
-	/* unicode strings, must be word aligned before the call */
-/*	if ((long) bcc_ptr % 2)	{
-		*bcc_ptr = 0;
-		bcc_ptr++;
-	} */
 	/* copy user */
 	if (ses->user_name == NULL) {
 		/* null user mount */
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 818cc4dee0e2..fb364e0a9c2e 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -509,7 +509,7 @@ cifs_ses_oplock_break(struct work_struct *work)
 {
 	struct smb2_lease_break_work *lw = container_of(work,
 				struct smb2_lease_break_work, lease_break);
-	int rc = 0;
+	int rc __maybe_unused = 0;
 
 	rc = SMB2_lease_break(0, tlink_tcon(lw->tlink), lw->lease_key,
 			      lw->lease_state);
@@ -809,7 +809,8 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
 	if (tcon->tc_count <= 0) {
-		struct TCP_Server_Info *server = NULL;
+		/* cifs_server_dbg() assumes this variable exists */
+		struct TCP_Server_Info *server __maybe_unused = NULL;
 
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
 		spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 82dd2e973753..ac7e7c2491c3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5864,7 +5864,6 @@ struct smb_version_operations smb311_operations = {
 	.parse_lease_buf = smb3_parse_lease_buf,
 	.copychunk_range = smb2_copychunk_range,
 	.duplicate_extents = smb2_duplicate_extents,
-/*	.validate_negotiate = smb3_validate_negotiate, */ /* not used in 3.11 */
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.fallocate = smb3_fallocate,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 131bec79d6fd..1456dd5db04d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -119,19 +119,6 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	if (tcon->ses)
 		shdr->SessionId = cpu_to_le64(tcon->ses->Suid);
 
-	/*
-	 * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
-	 * to pass the path on the Open SMB prefixed by \\server\share.
-	 * Not sure when we would need to do the augmented path (if ever) and
-	 * setting this flag breaks the SMB2 open operation since it is
-	 * illegal to send an empty path name (without \\server\share prefix)
-	 * when the DFS flag is set in the SMB open header. We could
-	 * consider setting the flag on all operations other than open
-	 * but it is safer to net set it for now.
-	 */
-/*	if (tcon->share_flags & SHI1005_FLAGS_DFS)
-		shdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
-
 	if (server && server->sign && !smb3_encryption_required(tcon))
 		shdr->Flags |= SMB2_FLAGS_SIGNED;
 out:
@@ -954,10 +941,7 @@ SMB2_negotiate(const unsigned int xid,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_negotiate_rsp *)rsp_iov.iov_base;
-	/*
-	 * No tcon so can't do
-	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
-	 */
+
 	if (rc == -EOPNOTSUPP) {
 		cifs_server_dbg(VFS, "Dialect not supported by server. Consider  specifying vers=1.0 or vers=2.0 on mount for accessing older servers\n");
 		goto neg_exit;
@@ -1791,10 +1775,6 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	rc = cifs_send_recv(xid, ses, ses->server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
-	/*
-	 * No tcon so can't do
-	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
-	 */
 
 smb2_session_already_dead:
 	return rc;
@@ -2142,11 +2122,6 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
 			    memcmp(name, smb3_create_tag_posix, 16) == 0)
 				parse_posix_ctxt(cc, buf, posix);
 		}
-		/* else {
-			cifs_dbg(FYI, "Context not matched with len %d\n",
-				le16_to_cpu(cc->NameLength));
-			cifs_dump_mem("Cctxt name: ", name, 4);
-		} */
 
 		next = le32_to_cpu(cc->Next);
 		if (!next)
@@ -3622,23 +3597,6 @@ int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			  NULL);
 }
 
-#if 0
-/* currently unused, as now we are doing compounding instead (see smb311_posix_query_path_info) */
-int
-SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
-		u64 persistent_fid, u64 volatile_fid, struct smb311_posix_qinfo *data, u32 *plen)
-{
-	size_t output_len = sizeof(struct smb311_posix_qinfo *) +
-			(sizeof(struct cifs_sid) * 2) + (PATH_MAX * 2);
-	*plen = 0;
-
-	return query_info(xid, tcon, persistent_fid, volatile_fid,
-			  SMB_FIND_FILE_POSIX_INFO, SMB2_O_INFO_FILE, 0,
-			  output_len, sizeof(struct smb311_posix_qinfo), (void **)&data, plen);
-	/* Note caller must free "data" (passed in above). It may be allocated in query_info call */
-}
-#endif
-
 int
 SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	       u64 persistent_fid, u64 volatile_fid,
diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
index aeffdad829e2..c9581ef49e6f 100644
--- a/fs/cifs/smberr.h
+++ b/fs/cifs/smberr.h
@@ -15,10 +15,6 @@
 #define ERRHRD	0x03	/* Error is a hardware error. */
 #define ERRCMD	0xFF	/* Command was not in the "SMB" format. */
 
-/* The following error codes may be generated with the SUCCESS error class.*/
-
-/*#define SUCCESS	0	The request was successful. */
-
 /* The following error codes may be generated with the ERRDOS error class.*/
 
 #define ERRbadfunc		1	/* Invalid function. The server did not
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 914a7aaf9fa7..5c53156629df 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -55,7 +55,6 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	temp->pid = current->pid;
 	temp->command = cpu_to_le16(smb_buffer->Command);
 	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
-	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 	/* when mid allocated can be before when sent */
 	temp->when_alloc = jiffies;
 	temp->server = server;
-- 
2.35.3

