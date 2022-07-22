Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EAFC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 19:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiGVTKQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 15:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiGVTKO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 15:10:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29B32720
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 12:10:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B63C8380C2;
        Fri, 22 Jul 2022 19:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658517008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gYkV1mN4poDesRktZfYx5kck05Y9arQm6a2uaS49n+Q=;
        b=ncg1rLCd6wwsonxzJpXHSFMY5OfKbvTc0dedzFo/Z7W3OxBURXyIoSDP50NGLvko/ibi6a
        2GyBrPiWBSk5t8ZGknwJ5qypxxG8SIRJ0t2ushoNkwNkpYUXqnKJZ5GT0kOclitdg/fSvv
        cOfAEa8w4Z/ssaoCw/97MZIG41LH2tg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658517008;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gYkV1mN4poDesRktZfYx5kck05Y9arQm6a2uaS49n+Q=;
        b=XeGzVhwzqyB5IuWCND80DAC/lqfujzurW3nKyOiFw/gNxYe3PgiO3q2tXGGEoOympPlaVa
        ee5RO3Om6e9+G/Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED653134A9;
        Fri, 22 Jul 2022 19:10:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aE+dKw/22mL9WgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 22 Jul 2022 19:10:07 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: remove dead/commented code, cifsproto.h cleanup
Date:   Fri, 22 Jul 2022 16:10:03 -0300
Message-Id: <20220722191003.7223-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove commented code. Also remove parameters names from cifsproto.h, as
any kind of comment/documentation related to the functions sould go into
their declaration.

No functional changes.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c   |   2 -
 fs/cifs/cifs_dfs_ref.c |   3 -
 fs/cifs/cifs_ioctl.h   |   2 -
 fs/cifs/cifsacl.c      |   1 -
 fs/cifs/cifsfs.c       |  19 +-
 fs/cifs/cifsglob.h     |   1 -
 fs/cifs/cifspdu.h      |   2 -
 fs/cifs/cifsproto.h    | 908 ++++++++++++++++-------------------------
 fs/cifs/cifssmb.c      |  15 +-
 fs/cifs/fs_context.c   |  20 -
 fs/cifs/inode.c        |   2 -
 fs/cifs/misc.c         |  10 +-
 fs/cifs/smb2ops.c      |   2 +-
 fs/cifs/transport.c    |   3 +-
 14 files changed, 354 insertions(+), 636 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index f5e63dfac2b1..e139719c8b47 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -1059,8 +1059,6 @@ static const struct proc_ops cifs_mount_params_proc_ops = {
 	.proc_read	= seq_read,
 	.proc_lseek	= seq_lseek,
 	.proc_release	= single_release,
-	/* No need for write for now */
-	/* .proc_write	= cifs_mount_params_proc_write, */
 };
 
 #else
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
diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index b87cbbe6d2d4..03e6531998b0 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -30,7 +30,6 @@ struct smb_snapshot_array {
 	__u32	number_of_snapshots;
 	__u32	number_of_snapshots_returned;
 	__u32	snapshot_array_size;
-	/*	snapshots[]; */
 } __packed;
 
 /* query_info flags */
@@ -44,7 +43,6 @@ struct smb_query_info {
 	__u32   flags;
 	__u32	input_buffer_length;
 	__u32	output_buffer_length;
-	/* char buffer[]; */
 } __packed;
 
 /*
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index bf861fef2f0c..73754cb74065 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1208,7 +1208,6 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
-/*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f909d9e9faaa..4c3a9c97d766 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -66,7 +66,6 @@ bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
-/* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
 atomic_t mid_count;
 atomic_t buf_alloc_count;
@@ -394,11 +393,6 @@ cifs_alloc_inode(struct super_block *sb)
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
@@ -722,8 +716,6 @@ static void cifs_umount_begin(struct super_block *sb)
 		tcon->status = TID_EXITING;
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
-	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
 		wake_up_all(&tcon->ses->server->request_q);
@@ -767,12 +759,8 @@ static const struct super_operations cifs_super_ops = {
 	.free_inode = cifs_free_inode,
 	.drop_inode	= cifs_drop_inode,
 	.evict_inode	= cifs_evict_inode,
-/*	.show_path	= cifs_show_path, */ /* Would we ever need show path? */
+	/* XXX: would we ever need show path? */
 	.show_devname   = cifs_show_devname,
-/*	.delete_inode	= cifs_delete_inode,  */  /* Do not need above
-	function unless later we add lazy close of inodes or unless the
-	kernel forgets to call us with the same number of releases (closes)
-	as opens */
 	.show_options = cifs_show_options,
 	.umount_begin   = cifs_umount_begin,
 #ifdef CONFIG_CIFS_STATS2
@@ -1474,10 +1462,7 @@ cifs_init_request_bufs(void)
 	} else {
 		CIFSMaxBufSize &= 0x1FE00; /* Round size to even 512 byte mult*/
 	}
-/*
-	cifs_dbg(VFS, "CIFSMaxBufSize %d 0x%x\n",
-		 CIFSMaxBufSize, CIFSMaxBufSize);
-*/
+
 	cifs_req_cachep = kmem_cache_create_usercopy("cifs_request",
 					    CIFSMaxBufSize + max_hdr_size, 0,
 					    SLAB_HWCACHE_ALIGN, 0,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9b7f409bfc8c..2a458db1b5ae 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2034,7 +2034,6 @@ extern struct smb_version_operations smb30_operations;
 extern struct smb_version_values smb30_values;
 #define SMB302_VERSION_STRING	"3.02"
 #define ALT_SMB302_VERSION_STRING "3.0.2"
-/*extern struct smb_version_operations smb302_operations;*/ /* not needed yet */
 extern struct smb_version_values smb302_values;
 #define SMB311_VERSION_STRING	"3.1.1"
 #define ALT_SMB311_VERSION_STRING "3.11"
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index aeba371c4c70..36df9a55376f 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1928,8 +1928,6 @@ typedef struct whoami_rsp_data { /* Query level 0x202 */
 	__u32 number_of_sids; /* may be zero */
 	__u32 length_of_sid_array; /* in bytes - may be zero */
 	__u32 pad; /* reserved - MBZ */
-	/* __u64 gid_array[0]; */  /* may be empty */
-	/* __u8 * psid_list */  /* may be empty */
 } __attribute__((packed)) WHOAMI_RSP_DATA;
 
 /* SETFSInfo Levels */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d59aebefa71c..4b67df555c14 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -28,14 +28,13 @@ extern void cifs_buf_release(void *);
 extern struct smb_hdr *cifs_small_buf_get(void);
 extern void cifs_small_buf_release(void *);
 extern void free_rsp_buf(int, void *);
-extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
-			unsigned int /* length */);
+extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *, unsigned int);
 extern unsigned int _get_xid(void);
 extern void _free_xid(unsigned int);
 #define get_xid()							\
 ({									\
 	unsigned int __xid = _get_xid();				\
-	cifs_dbg(FYI, "VFS: in %s as Xid: %u with uid: %d\n",		\
+	cifs_dbg(FYI, "VFS: in %s as: %u with uid: %d\n",		\
 		 __func__, __xid,					\
 		 from_kuid(&init_user_ns, current_fsuid()));		\
 	trace_smb3_enter(__xid, __func__);				\
@@ -57,8 +56,7 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern const char *build_path_from_dentry(struct dentry *, void *);
-extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
-						    void *page, bool prefix);
+extern char *build_path_from_dentry_optional_prefix(struct dentry *, void *, bool);
 static inline void *alloc_dentry_path(void)
 {
 	return __getname();
@@ -70,219 +68,151 @@ static inline void free_dentry_path(void *page)
 		__putname(page);
 }
 
-extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
-				     struct cifs_sb_info *cifs_sb,
-				     struct cifs_tcon *tcon,
+extern char *cifs_build_path_to_root(struct smb3_fs_context *,
+				     struct cifs_sb_info *, struct cifs_tcon *,
 				     int add_treename);
-extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
-extern char *cifs_compose_mount_options(const char *sb_mountdata,
-		const char *fullpath, const struct dfs_info3_param *ref,
-		char **devname);
-/* extern void renew_parental_timestamps(struct dentry *direntry);*/
-extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
-					struct TCP_Server_Info *server);
-extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
-extern void cifs_delete_mid(struct mid_q_entry *mid);
-extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
-extern void cifs_wake_up_task(struct mid_q_entry *mid);
-extern int cifs_handle_standard(struct TCP_Server_Info *server,
-				struct mid_q_entry *mid);
-extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
-extern int smb3_parse_opt(const char *options, const char *key, char **val);
-extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
-extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
-extern int cifs_call_async(struct TCP_Server_Info *server,
-			struct smb_rqst *rqst,
-			mid_receive_t *receive, mid_callback_t *callback,
-			mid_handle_t *handle, void *cbdata, const int flags,
-			const struct cifs_credits *exist_credits);
-extern struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
-extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
-			  struct TCP_Server_Info *server,
-			  struct smb_rqst *rqst, int *resp_buf_type,
-			  const int flags, struct kvec *resp_iov);
-extern int compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
-			      struct TCP_Server_Info *server,
-			      const int flags, const int num_rqst,
-			      struct smb_rqst *rqst, int *resp_buf_type,
-			      struct kvec *resp_iov);
-extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
-			struct smb_hdr * /* input */ ,
-			struct smb_hdr * /* out */ ,
-			int * /* bytes returned */ , const int);
-extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
-			    char *in_buf, int flags);
+extern char *build_wildcard_path_from_dentry(struct dentry *);
+extern char *cifs_compose_mount_options(const char *, const char *,
+					const struct dfs_info3_param *, char **);
+extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *,
+					struct TCP_Server_Info *);
+extern void DeleteMidQEntry(struct mid_q_entry *);
+extern void cifs_delete_mid(struct mid_q_entry *);
+extern void cifs_mid_q_entry_release(struct mid_q_entry *);
+extern void cifs_wake_up_task(struct mid_q_entry *);
+extern int cifs_handle_standard(struct TCP_Server_Info *, struct mid_q_entry *);
+extern int smb3_parse_devname(const char *, struct smb3_fs_context *);
+extern int smb3_parse_opt(const char *, const char *, char **);
+extern bool cifs_match_ipaddr(struct sockaddr *, struct sockaddr *);
+extern int cifs_discard_remaining_data(struct TCP_Server_Info *);
+extern int cifs_call_async(struct TCP_Server_Info *, struct smb_rqst *,
+			mid_receive_t *, mid_callback_t *, mid_handle_t *,
+			void *, const int, const struct cifs_credits *);
+extern struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *);
+extern int cifs_send_recv(const unsigned int, struct cifs_ses *,
+			  struct TCP_Server_Info *, struct smb_rqst *,
+			  int *, const int, struct kvec *);
+extern int compound_send_recv(const unsigned int, struct cifs_ses *,
+			      struct TCP_Server_Info *, const int, const int,
+			      struct smb_rqst *, int *, struct kvec *);
+extern int SendReceive(const unsigned int, struct cifs_ses *, struct smb_hdr *,
+		       struct smb_hdr *, int *, const int);
+extern int SendReceiveNoRsp(const unsigned int, struct cifs_ses *, char *, int);
 extern struct mid_q_entry *cifs_setup_request(struct cifs_ses *,
-				struct TCP_Server_Info *,
-				struct smb_rqst *);
+					      struct TCP_Server_Info *,
+					      struct smb_rqst *);
 extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
-						struct smb_rqst *);
-extern int cifs_check_receive(struct mid_q_entry *mid,
-			struct TCP_Server_Info *server, bool log_error);
-extern int cifs_wait_mtu_credits(struct TCP_Server_Info *server,
-				 unsigned int size, unsigned int *num,
-				 struct cifs_credits *credits);
-extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
-			struct kvec *, int /* nvec to send */,
-			int * /* type of buf returned */, const int flags,
-			struct kvec * /* resp vec */);
-extern int SendReceiveBlockingLock(const unsigned int xid,
-			struct cifs_tcon *ptcon,
-			struct smb_hdr *in_buf ,
-			struct smb_hdr *out_buf,
-			int *bytes_returned);
-void
-cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
-				      bool all_channels);
-void
-cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
-				      bool mark_smb_session);
-extern int cifs_reconnect(struct TCP_Server_Info *server,
-			  bool mark_smb_session);
-extern int checkSMB(char *buf, unsigned int len, struct TCP_Server_Info *srvr);
+						    struct smb_rqst *);
+extern int cifs_check_receive(struct mid_q_entry *, struct TCP_Server_Info *, bool);
+extern int cifs_wait_mtu_credits(struct TCP_Server_Info *, unsigned int,
+				 unsigned int *, struct cifs_credits *);
+extern int SendReceive2(const unsigned int, struct cifs_ses *, struct kvec *, int,
+			int *, const int, struct kvec *);
+extern int SendReceiveBlockingLock(const unsigned int, struct cifs_tcon *,
+				   struct smb_hdr *, struct smb_hdr *, int *);
+void cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *, bool);
+void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *, bool);
+extern int cifs_reconnect(struct TCP_Server_Info *, bool);
+extern int checkSMB(char *, unsigned int, struct TCP_Server_Info *);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
-extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
-extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
-			    unsigned int bytes_written);
+extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64);
+extern void cifs_update_eof(struct cifsInodeInfo *, loff_t, unsigned int);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
-extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
-				  int flags,
-				  struct cifsFileInfo **ret_file);
-extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
-				  int flags,
-				  struct cifsFileInfo **ret_file);
+extern int cifs_get_writable_file(struct cifsInodeInfo *, int, struct cifsFileInfo **);
+extern int cifs_get_writable_path(struct cifs_tcon *, const char *, int,
+				  struct cifsFileInfo **);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
-extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
-				  struct cifsFileInfo **ret_file);
-extern unsigned int smbCalcSize(void *buf, struct TCP_Server_Info *server);
-extern int decode_negTokenInit(unsigned char *security_blob, int length,
-			struct TCP_Server_Info *server);
-extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
-extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
-extern int map_smb_to_linux_error(char *buf, bool logErr);
-extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
-extern void header_assemble(struct smb_hdr *, char /* command */ ,
-			    const struct cifs_tcon *, int /* length of
-			    fixed section (word count) in two byte units */);
-extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
-				struct cifs_ses *ses,
-				void **request_buf);
-extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
-				enum securityEnum requested);
-extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
-			  struct TCP_Server_Info *server,
-			  const struct nls_table *nls_cp);
-extern struct timespec64 cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
+extern int cifs_get_readable_path(struct cifs_tcon *, const char *,
+				  struct cifsFileInfo **);
+extern unsigned int smbCalcSize(void *, struct TCP_Server_Info *);
+extern int decode_negTokenInit(unsigned char *, int, struct TCP_Server_Info *);
+extern int cifs_convert_address(struct sockaddr *, const char *, int);
+extern void cifs_set_port(struct sockaddr *, const unsigned short int);
+extern int map_smb_to_linux_error(char *, bool);
+extern int map_and_check_smb_error(struct mid_q_entry *, bool);
+extern void header_assemble(struct smb_hdr *, char, const struct cifs_tcon *, int);
+extern int small_smb_init_no_tc(const int, const int, struct cifs_ses *, void **);
+extern enum securityEnum select_sectype(struct TCP_Server_Info *, enum securityEnum);
+extern int CIFS_SessSetup(const unsigned int, struct cifs_ses *,
+			  struct TCP_Server_Info *,
+			  const struct nls_table *);
+extern struct timespec64 cifs_NTtimeToUnix(__le64);
 extern u64 cifs_UnixTimeToNT(struct timespec64);
-extern struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
-				      int offset);
-extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
-extern int cifs_get_writer(struct cifsInodeInfo *cinode);
-extern void cifs_put_writer(struct cifsInodeInfo *cinode);
-extern void cifs_done_oplock_break(struct cifsInodeInfo *cinode);
-extern int cifs_unlock_range(struct cifsFileInfo *cfile,
-			     struct file_lock *flock, const unsigned int xid);
-extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
-
-extern void cifs_down_write(struct rw_semaphore *sem);
-extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
-					      struct file *file,
-					      struct tcon_link *tlink,
-					      __u32 oplock);
-extern int cifs_posix_open(const char *full_path, struct inode **inode,
-			   struct super_block *sb, int mode,
-			   unsigned int f_flags, __u32 *oplock, __u16 *netfid,
-			   unsigned int xid);
-void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
-extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
-				     FILE_UNIX_BASIC_INFO *info,
-				     struct cifs_sb_info *cifs_sb);
+extern struct timespec64 cnvrtDosUnixTm(__le16, __le16, int);
+extern void cifs_set_oplock_level(struct cifsInodeInfo *, __u32);
+extern int cifs_get_writer(struct cifsInodeInfo *);
+extern void cifs_put_writer(struct cifsInodeInfo *);
+extern void cifs_done_oplock_break(struct cifsInodeInfo *);
+extern int cifs_unlock_range(struct cifsFileInfo *, struct file_lock *,
+			     const unsigned int);
+extern int cifs_push_mandatory_locks(struct cifsFileInfo *);
+extern void cifs_down_write(struct rw_semaphore *);
+extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *, struct file *,
+					      struct tcon_link *, __u32);
+extern int cifs_posix_open(const char *, struct inode **, struct super_block *,
+			   int, unsigned int, __u32 *, __u16 *, unsigned int);
+void cifs_fill_uniqueid(struct super_block *, struct cifs_fattr *);
+extern void cifs_unix_basic_to_fattr(struct cifs_fattr *, FILE_UNIX_BASIC_INFO *,
+				     struct cifs_sb_info *);
 extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
-					struct cifs_sb_info *);
-extern int cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
-extern struct inode *cifs_iget(struct super_block *sb,
-			       struct cifs_fattr *fattr);
-
-extern int cifs_get_inode_info(struct inode **inode, const char *full_path,
-			       FILE_ALL_INFO *data, struct super_block *sb,
-			       int xid, const struct cifs_fid *fid);
-extern int smb311_posix_get_inode_info(struct inode **pinode, const char *search_path,
-			struct super_block *sb, unsigned int xid);
-extern int cifs_get_inode_info_unix(struct inode **pinode,
-			const unsigned char *search_path,
-			struct super_block *sb, unsigned int xid);
-extern int cifs_set_file_info(struct inode *inode, struct iattr *attrs,
-			      unsigned int xid, const char *full_path, __u32 dosattr);
-extern int cifs_rename_pending_delete(const char *full_path,
-				      struct dentry *dentry,
-				      const unsigned int xid);
-extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
-				struct cifs_fattr *fattr, uint sidtype);
-extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
-			      struct cifs_fattr *fattr, struct inode *inode,
-			      bool get_mode_from_special_sid,
-			      const char *path, const struct cifs_fid *pfid);
-extern int id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
-					kuid_t uid, kgid_t gid);
+				   struct cifs_sb_info *);
+extern int cifs_fattr_to_inode(struct inode *, struct cifs_fattr *);
+extern struct inode *cifs_iget(struct super_block *, struct cifs_fattr *);
+extern int cifs_get_inode_info(struct inode **, const char *, FILE_ALL_INFO *,
+			       struct super_block *, int, const struct cifs_fid *);
+extern int smb311_posix_get_inode_info(struct inode **, const char *,
+				       struct super_block *, unsigned int);
+extern int cifs_get_inode_info_unix(struct inode **, const unsigned char *,
+				    struct super_block *, unsigned int);
+extern int cifs_set_file_info(struct inode *, struct iattr *, unsigned int,
+			      const char *, __u32);
+extern int cifs_rename_pending_delete(const char *, struct dentry *,
+				      const unsigned int);
+extern int sid_to_id(struct cifs_sb_info *, struct cifs_sid *, struct cifs_fattr *,
+		     uint);
+extern int cifs_acl_to_fattr(struct cifs_sb_info *, struct cifs_fattr *,
+			     struct inode *, bool, const char *,
+			     const struct cifs_fid *);
+extern int id_mode_to_cifs_acl(struct inode *, const char *, __u64 *, kuid_t, kgid_t);
 extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 				      const char *, u32 *, u32);
 extern struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *,
-				const struct cifs_fid *, u32 *, u32);
-extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
-				const char *, int);
-extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
-extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
-extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *pace);
-
-extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
-extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
-			         unsigned int to_read);
-extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
-					size_t to_read);
-extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
-					struct page *page,
-					unsigned int page_offset,
-					unsigned int to_read);
-extern int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb);
+					     const struct cifs_fid *, u32 *, u32);
+extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *, const char *, int);
+extern unsigned int setup_authusers_ACE(struct cifs_ace *);
+extern unsigned int setup_special_mode_ACE(struct cifs_ace *, __u64);
+extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *);
+extern void dequeue_mid(struct mid_q_entry *, bool);
+extern int cifs_read_from_socket(struct TCP_Server_Info *, char *, unsigned int);
+extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *, size_t);
+extern int cifs_read_page_from_socket(struct TCP_Server_Info *, struct page *,
+				      unsigned, unsigned int);
+extern int cifs_setup_cifs_sb(struct cifs_sb_info *);
 extern int cifs_match_super(struct super_block *, void *);
-extern int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
+extern int cifs_mount(struct cifs_sb_info *, struct smb3_fs_context *);
 extern void cifs_umount(struct cifs_sb_info *);
-extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
-extern void cifs_reopen_persistent_handles(struct cifs_tcon *tcon);
-
-extern bool cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
-				    __u64 length, __u8 type, __u16 flags,
-				    struct cifsLockInfo **conf_lock,
-				    int rw_check);
-extern void cifs_add_pending_open(struct cifs_fid *fid,
-				  struct tcon_link *tlink,
-				  struct cifs_pending_open *open);
-extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
-					 struct tcon_link *tlink,
-					 struct cifs_pending_open *open);
-extern void cifs_del_pending_open(struct cifs_pending_open *open);
-
-extern bool cifs_is_deferred_close(struct cifsFileInfo *cfile,
-				struct cifs_deferred_close **dclose);
-
-extern void cifs_add_deferred_close(struct cifsFileInfo *cfile,
-				struct cifs_deferred_close *dclose);
-
-extern void cifs_del_deferred_close(struct cifsFileInfo *cfile);
-
-extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
-
-extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
-
-extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
-				const char *path);
-extern struct TCP_Server_Info *
-cifs_get_tcp_session(struct smb3_fs_context *ctx,
-		     struct TCP_Server_Info *primary_server);
-extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
-				 int from_reconnect);
-extern void cifs_put_tcon(struct cifs_tcon *tcon);
+extern void cifs_mark_open_files_invalid(struct cifs_tcon *);
+extern void cifs_reopen_persistent_handles(struct cifs_tcon *);
+extern bool cifs_find_lock_conflict(struct cifsFileInfo *, __u64, __u64, __u8,
+				    __u16, struct cifsLockInfo **, int);
+extern void cifs_add_pending_open(struct cifs_fid *, struct tcon_link *,
+				  struct cifs_pending_open *);
+extern void cifs_add_pending_open_locked(struct cifs_fid *, struct tcon_link *,
+					 struct cifs_pending_open *);
+extern void cifs_del_pending_open(struct cifs_pending_open *);
+extern bool cifs_is_deferred_close(struct cifsFileInfo *,
+				   struct cifs_deferred_close **);
+extern void cifs_add_deferred_close(struct cifsFileInfo *,
+				    struct cifs_deferred_close *);
+extern void cifs_del_deferred_close(struct cifsFileInfo *);
+extern void cifs_close_deferred_file(struct cifsInodeInfo *);
+extern void cifs_close_all_deferred_files(struct cifs_tcon *);
+extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *, const char *);
+extern struct TCP_Server_Info *cifs_get_tcp_session(struct smb3_fs_context *,
+						    struct TCP_Server_Info *);
+extern void cifs_put_tcp_session(struct TCP_Server_Info *, int);
+extern void cifs_put_tcon(struct cifs_tcon *);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
@@ -293,104 +223,66 @@ extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
-extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
-extern void cifs_free_llist(struct list_head *llist);
-extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
-
-extern int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon,
-			     const struct nls_table *nlsc);
-
-extern int cifs_negotiate_protocol(const unsigned int xid,
-				   struct cifs_ses *ses,
-				   struct TCP_Server_Info *server);
-extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
-			      struct TCP_Server_Info *server,
-			      struct nls_table *nls_info);
-extern int cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required);
-extern int CIFSSMBNegotiate(const unsigned int xid,
-			    struct cifs_ses *ses,
-			    struct TCP_Server_Info *server);
-
-extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
-		    const char *tree, struct cifs_tcon *tcon,
-		    const struct nls_table *);
-
-extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
-		const char *searchName, struct cifs_sb_info *cifs_sb,
-		__u16 *searchHandle, __u16 search_flags,
-		struct cifs_search_info *psrch_inf,
-		bool msearch);
-
-extern int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
-		__u16 searchHandle, __u16 search_flags,
-		struct cifs_search_info *psrch_inf);
-
-extern int CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
-			const __u16 search_handle);
-
-extern int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			u16 netfid, FILE_ALL_INFO *pFindData);
-extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			    const char *search_Name, FILE_ALL_INFO *data,
-			    int legacy /* whether to use old info level */,
-			    const struct nls_table *nls_codepage, int remap);
-extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
-			       const char *search_name, FILE_ALL_INFO *data,
-			       const struct nls_table *nls_codepage, int remap);
-
-extern int CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			u16 netfid, FILE_UNIX_BASIC_INFO *pFindData);
-extern int CIFSSMBUnixQPathInfo(const unsigned int xid,
-			struct cifs_tcon *tcon,
-			const unsigned char *searchName,
-			FILE_UNIX_BASIC_INFO *pFindData,
-			const struct nls_table *nls_codepage, int remap);
-
-extern int CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
-			   const char *search_name,
-			   struct dfs_info3_param **target_nodes,
-			   unsigned int *num_of_nodes,
-			   const struct nls_table *nls_codepage, int remap);
-
-extern int parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
-			       unsigned int *num_of_nodes,
-			       struct dfs_info3_param **target_nodes,
-			       const struct nls_table *nls_codepage, int remap,
-			       const char *searchName, bool is_unicode);
-extern void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb,
-				 struct smb3_fs_context *ctx);
-extern int CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			struct kstatfs *FSData);
-extern int SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			struct kstatfs *FSData);
-extern int CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			__u64 cap);
-
-extern int CIFSSMBQFSAttributeInfo(const unsigned int xid,
-			struct cifs_tcon *tcon);
-extern int CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon);
-extern int CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon);
-extern int CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			struct kstatfs *FSData);
-
-extern int CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *fileName, const FILE_BASIC_INFO *data,
-			const struct nls_table *nls_codepage,
-			struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			const FILE_BASIC_INFO *data, __u16 fid,
-			__u32 pid_of_opener);
-extern int CIFSSMBSetFileDisposition(const unsigned int xid,
-				     struct cifs_tcon *tcon,
-				     bool delete_file, __u16 fid,
-				     __u32 pid_of_opener);
-extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
-			 const char *file_name, __u64 size,
-			 struct cifs_sb_info *cifs_sb, bool set_allocation);
-extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
-			      struct cifsFileInfo *cfile, __u64 size,
-			      bool set_allocation);
+extern void cifs_move_llist(struct list_head *, struct list_head *);
+extern void cifs_free_llist(struct list_head *);
+extern void cifs_del_lock_waiters(struct cifsLockInfo *);
+extern int cifs_tree_connect(const unsigned int, struct cifs_tcon *,
+			     const struct nls_table *);
+extern int cifs_negotiate_protocol(const unsigned int, struct cifs_ses *,
+				   struct TCP_Server_Info *);
+extern int cifs_setup_session(const unsigned int, struct cifs_ses *,
+			      struct TCP_Server_Info *, struct nls_table *);
+extern int cifs_enable_signing(struct TCP_Server_Info *, bool);
+extern int CIFSSMBNegotiate(const unsigned int, struct cifs_ses *,
+			    struct TCP_Server_Info *);
+extern int CIFSTCon(const unsigned int, struct cifs_ses *, const char *,
+		    struct cifs_tcon *, const struct nls_table *);
+extern int CIFSFindFirst(const unsigned int, struct cifs_tcon *, const char *,
+			 struct cifs_sb_info *, __u16 *, __u16,
+			 struct cifs_search_info *, bool);
+extern int CIFSFindNext(const unsigned int, struct cifs_tcon *, __u16, __u16,
+			struct cifs_search_info *);
+extern int CIFSFindClose(const unsigned int, struct cifs_tcon *, const __u16);
+extern int CIFSSMBQFileInfo(const unsigned int, struct cifs_tcon *, u16,
+			    FILE_ALL_INFO *);
+extern int CIFSSMBQPathInfo(const unsigned int, struct cifs_tcon *,
+			    const char *, FILE_ALL_INFO *, int,
+			    const struct nls_table *, int);
+extern int SMBQueryInformation(const unsigned int, struct cifs_tcon *,
+			       const char *, FILE_ALL_INFO *,
+			       const struct nls_table *, int);
+extern int CIFSSMBUnixQFileInfo(const unsigned int, struct cifs_tcon *, u16,
+				FILE_UNIX_BASIC_INFO *);
+extern int CIFSSMBUnixQPathInfo(const unsigned int, struct cifs_tcon *,
+				const unsigned char *, FILE_UNIX_BASIC_INFO *,
+				const struct nls_table *, int);
+extern int CIFSGetDFSRefer(const unsigned int, struct cifs_ses *, const char *,
+			   struct dfs_info3_param **, unsigned int *,
+			   const struct nls_table *, int);
+extern int parse_dfs_referrals(struct get_dfs_referral_rsp *, u32, unsigned int *,
+			       struct dfs_info3_param **, const struct nls_table *,
+			       int, const char *, bool);
+extern void reset_cifs_unix_caps(unsigned int, struct cifs_tcon *,
+				 struct cifs_sb_info *, struct smb3_fs_context *);
+extern int CIFSSMBQFSInfo(const unsigned int, struct cifs_tcon *, struct kstatfs *);
+extern int SMBOldQFSInfo(const unsigned int, struct cifs_tcon *, struct kstatfs *);
+extern int CIFSSMBSetFSUnixInfo(const unsigned int, struct cifs_tcon *, __u64);
+extern int CIFSSMBQFSAttributeInfo(const unsigned int, struct cifs_tcon *);
+extern int CIFSSMBQFSDeviceInfo(const unsigned int, struct cifs_tcon *);
+extern int CIFSSMBQFSUnixInfo(const unsigned int, struct cifs_tcon *);
+extern int CIFSSMBQFSPosixInfo(const unsigned int, struct cifs_tcon *,
+			       struct kstatfs *);
+extern int CIFSSMBSetPathInfo(const unsigned int, struct cifs_tcon *,
+			      const char *, const FILE_BASIC_INFO *,
+			      const struct nls_table *, struct cifs_sb_info *);
+extern int CIFSSMBSetFileInfo(const unsigned int, struct cifs_tcon *,
+			      const FILE_BASIC_INFO *, __u16, __u32);
+extern int CIFSSMBSetFileDisposition(const unsigned int, struct cifs_tcon *,
+				     bool, __u16, __u32);
+extern int CIFSSMBSetEOF(const unsigned int, struct cifs_tcon *, const char *,
+			 __u64, struct cifs_sb_info *, bool);
+extern int CIFSSMBSetFileSize(const unsigned int, struct cifs_tcon *,
+			      struct cifsFileInfo *, __u64, bool);
 
 struct cifs_unix_set_info_args {
 	__u64	ctime;
@@ -402,278 +294,178 @@ struct cifs_unix_set_info_args {
 	dev_t	device;
 };
 
-extern int CIFSSMBUnixSetFileInfo(const unsigned int xid,
-				  struct cifs_tcon *tcon,
-				  const struct cifs_unix_set_info_args *args,
-				  u16 fid, u32 pid_of_opener);
-
-extern int CIFSSMBUnixSetPathInfo(const unsigned int xid,
-				  struct cifs_tcon *tcon, const char *file_name,
-				  const struct cifs_unix_set_info_args *args,
-				  const struct nls_table *nls_codepage,
-				  int remap);
-
-extern int CIFSSMBMkDir(const unsigned int xid, struct inode *inode,
-			umode_t mode, struct cifs_tcon *tcon,
-			const char *name, struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *name, struct cifs_sb_info *cifs_sb);
-extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *name, __u16 type,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
-extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-			  const char *name, struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
-			 const char *from_name, const char *to_name,
-			 struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
-				 int netfid, const char *target_name,
-				 const struct nls_table *nls_codepage,
-				 int remap_special_chars);
-extern int CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
-			      const char *from_name, const char *to_name,
-			      struct cifs_sb_info *cifs_sb);
-extern int CIFSUnixCreateHardLink(const unsigned int xid,
-			struct cifs_tcon *tcon,
-			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
-extern int CIFSUnixCreateSymLink(const unsigned int xid,
-			struct cifs_tcon *tcon,
-			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage, int remap);
-extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
-			struct cifs_tcon *tcon,
-			const unsigned char *searchName, char **syminfo,
-			const struct nls_table *nls_codepage, int remap);
-extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
-			       __u16 fid, char **symlinkinfo,
-			       const struct nls_table *nls_codepage);
-extern int CIFSSMB_set_compression(const unsigned int xid,
-				   struct cifs_tcon *tcon, __u16 fid);
-extern int CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms,
-		     int *oplock, FILE_ALL_INFO *buf);
-extern int SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *fileName, const int disposition,
-			const int access_flags, const int omode,
-			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
-			const struct nls_table *nls_codepage, int remap);
-extern int CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
-			u32 posix_flags, __u64 mode, __u16 *netfid,
-			FILE_UNIX_BASIC_INFO *pRetData,
-			__u32 *pOplock, const char *name,
-			const struct nls_table *nls_codepage, int remap);
-extern int CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon,
-			const int smb_file_id);
-
-extern int CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon,
-			const int smb_file_id);
-
-extern int CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
-			unsigned int *nbytes, char **buf,
-			int *return_buf_type);
-extern int CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
-			unsigned int *nbytes, const char *buf);
-extern int CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
-			unsigned int *nbytes, struct kvec *iov, const int nvec);
-extern int CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
-				 const char *search_name, __u64 *inode_number,
-				 const struct nls_table *nls_codepage,
-				 int remap);
-
-extern int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
-		      const __u16 netfid, const __u8 lock_type,
-		      const __u32 num_unlock, const __u32 num_lock,
-		      LOCKING_ANDX_RANGE *buf);
-extern int CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
-			const __u16 netfid, const __u32 netpid, const __u64 len,
-			const __u64 offset, const __u32 numUnlock,
-			const __u32 numLock, const __u8 lockType,
-			const bool waitFlag, const __u8 oplock_level);
-extern int CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
-			const __u16 smb_file_id, const __u32 netpid,
-			const loff_t start_offset, const __u64 len,
-			struct file_lock *, const __u16 lock_type,
-			const bool waitFlag);
-extern int CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon);
-extern int CIFSSMBEcho(struct TCP_Server_Info *server);
-extern int CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses);
+extern int CIFSSMBUnixSetFileInfo(const unsigned int, struct cifs_tcon *,
+				  const struct cifs_unix_set_info_args *,
+				  u16, u32);
+extern int CIFSSMBUnixSetPathInfo(const unsigned int, struct cifs_tcon *,
+				  const char *,
+				  const struct cifs_unix_set_info_args *,
+				  const struct nls_table *, int);
+extern int CIFSSMBMkDir(const unsigned int, struct inode *,
+			umode_t mode, struct cifs_tcon *,
+			const char *, struct cifs_sb_info *);
+extern int CIFSSMBRmDir(const unsigned int, struct cifs_tcon *,
+			const char *, struct cifs_sb_info *);
+extern int CIFSPOSIXDelFile(const unsigned int, struct cifs_tcon *, const char *,
+			    __u16 type, const struct nls_table *, int);
+extern int CIFSSMBDelFile(const unsigned int, struct cifs_tcon *, const char *,
+			  struct cifs_sb_info *);
+extern int CIFSSMBRename(const unsigned int, struct cifs_tcon *, const char *,
+			 const char *, struct cifs_sb_info *);
+extern int CIFSSMBRenameOpenFile(const unsigned int, struct cifs_tcon *, int,
+				 const char *, const struct nls_table *, int);
+extern int CIFSCreateHardLink(const unsigned int, struct cifs_tcon *, const char *,
+			      const char *, struct cifs_sb_info *);
+extern int CIFSUnixCreateHardLink(const unsigned int, struct cifs_tcon *,
+				  const char *, const char *,
+				  const struct nls_table *, int);
+extern int CIFSUnixCreateSymLink(const unsigned int, struct cifs_tcon *,
+				 const char *, const char *,
+				 const struct nls_table *, int);
+extern int CIFSSMBUnixQuerySymLink(const unsigned int, struct cifs_tcon *,
+				   const unsigned char *, char **,
+				   const struct nls_table *, int);
+extern int CIFSSMBQuerySymLink(const unsigned int, struct cifs_tcon *, __u16,
+			       char **, const struct nls_table *);
+extern int CIFSSMB_set_compression(const unsigned int, struct cifs_tcon *, __u16);
+extern int CIFS_open(const unsigned int, struct cifs_open_parms *, int *,
+		     FILE_ALL_INFO *);
+extern int SMBLegacyOpen(const unsigned int, struct cifs_tcon *, const char *,
+			 const int, const int, const int, __u16 *, int *,
+			 FILE_ALL_INFO *, const struct nls_table *, int);
+extern int CIFSPOSIXCreate(const unsigned int, struct cifs_tcon *, u32, __u64,
+			   __u16 *, FILE_UNIX_BASIC_INFO *, __u32 *, const char *,
+			   const struct nls_table *, int);
+extern int CIFSSMBClose(const unsigned int, struct cifs_tcon *, const int);
+extern int CIFSSMBFlush(const unsigned int, struct cifs_tcon *, const int);
+extern int CIFSSMBRead(const unsigned int, struct cifs_io_parms *,
+		       unsigned int *, char **, int *);
+extern int CIFSSMBWrite(const unsigned int, struct cifs_io_parms *,
+			unsigned int *, const char *);
+extern int CIFSSMBWrite2(const unsigned int, struct cifs_io_parms *,
+			 unsigned int *, struct kvec *, int);
+extern int CIFSGetSrvInodeNumber(const unsigned int, struct cifs_tcon *,
+				 const char *, __u64 *, const struct nls_table *,
+				 int);
+extern int cifs_lockv(const unsigned int, struct cifs_tcon *, const __u16,
+		      const __u8, const __u32, const __u32, LOCKING_ANDX_RANGE *);
+extern int CIFSSMBLock(const unsigned int, struct cifs_tcon *, const __u16,
+		       const __u32, const __u64, const __u64, const __u32,
+		       const __u32, const __u8, const bool, const __u8);
+extern int CIFSSMBPosixLock(const unsigned int, struct cifs_tcon *, const __u16,
+			    const __u32, const loff_t, const __u64,
+			    struct file_lock *, const __u16, const bool);
+extern int CIFSSMBTDis(const unsigned int, struct cifs_tcon *);
+extern int CIFSSMBEcho(struct TCP_Server_Info *);
+extern int CIFSSMBLogoff(const unsigned int, struct cifs_ses *);
 
 extern struct cifs_ses *sesInfoAlloc(void);
 extern void sesInfoFree(struct cifs_ses *);
 extern struct cifs_tcon *tconInfoAlloc(void);
 extern void tconInfoFree(struct cifs_tcon *);
 
-extern int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
-		   __u32 *pexpected_response_sequence_number);
-extern int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
-			  __u32 *);
+extern int cifs_sign_rqst(struct smb_rqst *, struct TCP_Server_Info *, __u32 *);
+extern int cifs_sign_smbv(struct kvec *, int, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
-extern int cifs_verify_signature(struct smb_rqst *rqst,
-				 struct TCP_Server_Info *server,
-				__u32 expected_sequence_number);
+extern int cifs_verify_signature(struct smb_rqst *, struct TCP_Server_Info *, __u32);
 extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
-extern void cifs_crypto_secmech_release(struct TCP_Server_Info *server);
+extern void cifs_crypto_secmech_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
-extern int generate_smb30signingkey(struct cifs_ses *ses,
-				    struct TCP_Server_Info *server);
-extern int generate_smb311signingkey(struct cifs_ses *ses,
-				     struct TCP_Server_Info *server);
-
-extern int CIFSSMBCopy(unsigned int xid,
-			struct cifs_tcon *source_tcon,
-			const char *fromName,
-			const __u16 target_tid,
-			const char *toName, const int flags,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
-extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
-			const unsigned char *searchName,
-			const unsigned char *ea_name, char *EAData,
-			size_t bufsize, struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-		const char *fileName, const char *ea_name,
-		const void *ea_value, const __u16 ea_value_len,
-		const struct nls_table *nls_codepage,
-		struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
-			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
+extern int generate_smb30signingkey(struct cifs_ses *, struct TCP_Server_Info *);
+extern int generate_smb311signingkey(struct cifs_ses *, struct TCP_Server_Info *);
+extern int CIFSSMBCopy(unsigned int, struct cifs_tcon *, const char *, const __u16,
+			const char *, const int, const struct nls_table *, int);
+extern ssize_t CIFSSMBQAllEAs(const unsigned int, struct cifs_tcon *,
+			const unsigned char *, const unsigned char *, char *,
+			size_t, struct cifs_sb_info *);
+extern int CIFSSMBSetEA(const unsigned int, struct cifs_tcon *, const char *,
+			const char *, const void *, const __u16,
+			const struct nls_table *, struct cifs_sb_info *);
+extern int CIFSSMBGetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
+			     struct cifs_ntsd **, __u32 *);
 extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
-			struct cifs_ntsd *, __u32, int);
-extern int CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
-		const unsigned char *searchName,
-		char *acl_inf, const int buflen, const int acl_type,
-		const struct nls_table *nls_codepage, int remap_special_chars);
-extern int CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
-		const unsigned char *fileName,
-		const char *local_acl, const int buflen, const int acl_type,
-		const struct nls_table *nls_codepage, int remap_special_chars);
-extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
-			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
-extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
-extern bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
-extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
-			      struct cifs_sb_info *cifs_sb,
-			      struct cifs_fattr *fattr,
-			      const unsigned char *path);
-extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
-			const struct nls_table *codepage);
-
-extern int
-cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname);
-
-extern struct TCP_Server_Info *
-cifs_find_tcp_session(struct smb3_fs_context *ctx);
-
-extern void cifs_put_smb_ses(struct cifs_ses *ses);
-
-extern struct cifs_ses *
-cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx);
-
-void cifs_readdata_release(struct kref *refcount);
-int cifs_async_readv(struct cifs_readdata *rdata);
-int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
-
-int cifs_async_writev(struct cifs_writedata *wdata,
-		      void (*release)(struct kref *kref));
-void cifs_writev_complete(struct work_struct *work);
-struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
-						work_func_t complete);
-struct cifs_writedata *cifs_writedata_direct_alloc(struct page **pages,
-						work_func_t complete);
-void cifs_writedata_release(struct kref *refcount);
-int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
-			  struct cifs_sb_info *cifs_sb,
-			  const unsigned char *path, char *pbuf,
-			  unsigned int *pbytes_read);
-int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
-			   struct cifs_sb_info *cifs_sb,
-			   const unsigned char *path, char *pbuf,
-			   unsigned int *pbytes_written);
-int __cifs_calc_signature(struct smb_rqst *rqst,
-			struct TCP_Server_Info *server, char *signature,
-			struct shash_desc *shash);
-enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
-					enum securityEnum);
+			     struct cifs_ntsd *, __u32, int);
+extern int CIFSSMBGetPosixACL(const unsigned int, struct cifs_tcon *,
+			      const unsigned char *, char *, const int,
+			      const int, const struct nls_table *, int);
+extern int CIFSSMBSetPosixACL(const unsigned int, struct cifs_tcon *,
+			      const unsigned char *, const char *, const int,
+			      const int, const struct nls_table *, int);
+extern int CIFSGetExtAttr(const unsigned int, struct cifs_tcon *, const int,
+			  __u64 *, __u64 *);
+extern void cifs_autodisable_serverino(struct cifs_sb_info *);
+extern bool couldbe_mf_symlink(const struct cifs_fattr *);
+extern int check_mf_symlink(unsigned int, struct cifs_tcon *, struct cifs_sb_info *,
+			    struct cifs_fattr *, const unsigned char *);
+extern int E_md4hash(const unsigned char *, unsigned char *p16,
+		     const struct nls_table *);
+extern int cifs_setup_volume_info(struct smb3_fs_context *, const char *, const char *);
+extern struct TCP_Server_Info *cifs_find_tcp_session(struct smb3_fs_context *);
+extern void cifs_put_smb_ses(struct cifs_ses *);
+extern struct cifs_ses *cifs_get_smb_ses(struct TCP_Server_Info *,
+					 struct smb3_fs_context *);
+void cifs_readdata_release(struct kref *);
+int cifs_async_readv(struct cifs_readdata *);
+int cifs_readv_receive(struct TCP_Server_Info *, struct mid_q_entry *);
+int cifs_async_writev(struct cifs_writedata *, void (*)(struct kref *));
+void cifs_writev_complete(struct work_struct *);
+struct cifs_writedata *cifs_writedata_alloc(unsigned int, work_func_t);
+struct cifs_writedata *cifs_writedata_direct_alloc(struct page **, work_func_t);
+void cifs_writedata_release(struct kref *);
+int cifs_query_mf_symlink(unsigned int, struct cifs_tcon *, struct cifs_sb_info *,
+			  const unsigned char *, char *, unsigned int *);
+int cifs_create_mf_symlink(unsigned int, struct cifs_tcon *, struct cifs_sb_info *,
+			   const unsigned char *, char *, unsigned int *);
+int __cifs_calc_signature(struct smb_rqst *, struct TCP_Server_Info *,
+			  char *signature, struct shash_desc *);
+enum securityEnum cifs_select_sectype(struct TCP_Server_Info *, enum securityEnum);
 struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
-void cifs_aio_ctx_release(struct kref *refcount);
-int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
-void smb2_cached_lease_break(struct work_struct *work);
-
-int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
-		    struct sdesc **sdesc);
-void cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc);
-
-extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
-				unsigned int *len, unsigned int *offset);
-struct cifs_chan *
-cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server);
-int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
-bool is_server_using_iface(struct TCP_Server_Info *server,
-			   struct cifs_server_iface *iface);
-bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
-void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
-
-unsigned int
-cifs_ses_get_chan_index(struct cifs_ses *ses,
-			struct TCP_Server_Info *server);
-void
-cifs_chan_set_in_reconnect(struct cifs_ses *ses,
-			     struct TCP_Server_Info *server);
-void
-cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
-			       struct TCP_Server_Info *server);
-bool
-cifs_chan_in_reconnect(struct cifs_ses *ses,
-			  struct TCP_Server_Info *server);
-void
-cifs_chan_set_need_reconnect(struct cifs_ses *ses,
-			     struct TCP_Server_Info *server);
-void
-cifs_chan_clear_need_reconnect(struct cifs_ses *ses,
-			       struct TCP_Server_Info *server);
-bool
-cifs_chan_needs_reconnect(struct cifs_ses *ses,
-			  struct TCP_Server_Info *server);
-bool
-cifs_chan_is_iface_active(struct cifs_ses *ses,
-			  struct TCP_Server_Info *server);
-int
-cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
-int
-SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon);
-
-void extract_unc_hostname(const char *unc, const char **h, size_t *len);
-int copy_path_name(char *dst, const char *src);
-int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
-			       int resp_buftype,
-			       struct cifs_search_info *srch_inf);
-
-struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
-void cifs_put_tcp_super(struct super_block *sb);
-int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
-char *extract_hostname(const char *unc);
-char *extract_sharename(const char *unc);
+void cifs_aio_ctx_release(struct kref *);
+int setup_aio_ctx_iter(struct cifs_aio_ctx *, struct iov_iter *, int);
+void smb2_cached_lease_break(struct work_struct *);
+int cifs_alloc_hash(const char *, struct crypto_shash **, struct sdesc **);
+void cifs_free_hash(struct crypto_shash **, struct sdesc **);
+extern void rqst_page_get_length(struct smb_rqst *, unsigned int, unsigned int *,
+				 unsigned int *);
+struct cifs_chan *cifs_ses_find_chan(struct cifs_ses *, struct TCP_Server_Info *);
+int cifs_try_adding_channels(struct cifs_sb_info *, struct cifs_ses *);
+bool is_server_using_iface(struct TCP_Server_Info *, struct cifs_server_iface *);
+bool is_ses_using_iface(struct cifs_ses *, struct cifs_server_iface *);
+void cifs_ses_mark_for_reconnect(struct cifs_ses *);
+unsigned int cifs_ses_get_chan_index(struct cifs_ses *, struct TCP_Server_Info *);
+void cifs_chan_set_in_reconnect(struct cifs_ses *, struct TCP_Server_Info *);
+void cifs_chan_clear_in_reconnect(struct cifs_ses *, struct TCP_Server_Info *);
+bool cifs_chan_in_reconnect(struct cifs_ses *, struct TCP_Server_Info *);
+void cifs_chan_set_need_reconnect(struct cifs_ses *, struct TCP_Server_Info *);
+void cifs_chan_clear_need_reconnect(struct cifs_ses *, struct TCP_Server_Info *);
+bool cifs_chan_needs_reconnect(struct cifs_ses *, struct TCP_Server_Info *);
+bool cifs_chan_is_iface_active(struct cifs_ses *, struct TCP_Server_Info *);
+int cifs_chan_update_iface(struct cifs_ses *, struct TCP_Server_Info *);
+int SMB3_request_interfaces(const unsigned int, struct cifs_tcon *);
+void extract_unc_hostname(const char *, const char **, size_t *);
+int copy_path_name(char *, const char *);
+int smb2_parse_query_directory(struct cifs_tcon *, struct kvec *, int,
+			       struct cifs_search_info *);
+struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *);
+void cifs_put_tcp_super(struct super_block *);
+int cifs_update_super_prepath(struct cifs_sb_info *, char *);
+char *extract_hostname(const char *);
+char *extract_sharename(const char *);
+struct super_block *cifs_get_tcon_super(struct cifs_tcon *);
+void cifs_put_tcon_super(struct super_block *);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
-			       const char *old_path,
-			       const struct nls_table *nls_codepage,
+			       const char *old_path, const struct nls_table *cp,
 			       struct dfs_info3_param *referral, int remap)
 {
-	return dfs_cache_find(xid, ses, nls_codepage, remap, old_path,
+	return dfs_cache_find(xid, ses, cp, remap, old_path,
 			      referral, NULL);
 }
 
-int match_target_ip(struct TCP_Server_Info *server,
-		    const char *share, size_t share_len,
-		    bool *result);
-
-int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
-				       struct cifs_tcon *tcon,
-				       struct cifs_sb_info *cifs_sb,
-				       const char *dfs_link_path);
+int match_target_ip(struct TCP_Server_Info *, const char *, size_t, bool *);
+int cifs_dfs_query_info_nonascii_quirk(const unsigned int, struct cifs_tcon *,
+				       struct cifs_sb_info *, const char *);
 #endif
 
 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
@@ -683,8 +475,4 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 	else
 		return options;
 }
-
-struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
-void cifs_put_tcon_super(struct super_block *sb);
-
-#endif			/* _CIFSPROTO_H */
+#endif /* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9ed21752f2df..011d17b7523c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1208,11 +1208,6 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -1225,17 +1220,10 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Error in Open = %d\n", rc);
 	} else {
-	/* BB verify if wct == 15 */
-
-/*		*pOplock = pSMBr->OplockLevel; */ /* BB take from action field*/
-
+		/* BB verify if wct == 15 */
 		*netfid = pSMBr->Fid;   /* cifs fid stays in le */
 		/* Let caller know file was created so we can set the mode. */
 		/* Do we care about the CreateAction in any other cases? */
-	/* BB FIXME BB */
-/*		if (cpu_to_le32(FILE_CREATE) == pSMBr->CreateAction)
-			*pOplock |= CIFS_CREATE_ACTION; */
-	/* BB FIXME END */
 
 		if (pfile_info) {
 			pfile_info->CreationTime = 0; /* BB convert CreateTime*/
@@ -2382,7 +2370,6 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
-/*	LOCK_RSP *pSMBr = NULL; */ /* No response data other than rc to parse */
 	int bytes_returned;
 	int flags = 0;
 	__u16 count;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8dc0d923ef6a..f76d9920a7a7 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -5,19 +5,6 @@
  *   Author(s): Steve French <stfrench@microsoft.com>
  *              David Howells <dhowells@redhat.com>
  */
-
-/*
-#include <linux/module.h>
-#include <linux/nsproxy.h>
-#include <linux/slab.h>
-#include <linux/magic.h>
-#include <linux/security.h>
-#include <net/net_namespace.h>
-#ifdef CONFIG_CIFS_DFS_UPCALL
-#include "dfs_cache.h"
-#endif
-*/
-
 #include <linux/ctype.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -1538,13 +1525,6 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-/*
- *	short int override_uid = -1;
- *	short int override_gid = -1;
- *	char *nodename = strdup(utsname()->nodename);
- *	struct sockaddr *dstaddr = (struct sockaddr *)&vol->dstaddr;
- */
-
 	fc->fs_private = ctx;
 	fc->ops = &smb3_fs_context_ops;
 	return 0;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3ad303dd5e5a..46ebc2554b53 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -623,8 +623,6 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
 	fattr->cf_mode = (umode_t) le32_to_cpu(info->Mode);
-	/* The srv fs device id is overridden on network mount so setting rdev isn't needed here */
-	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
 	if (symlink) {
 		fattr->cf_mode |= S_IFLNK;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 16168ebd1a62..ec0069058f45 100644
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
@@ -183,10 +181,8 @@ cifs_buf_get(void)
 void
 cifs_buf_release(void *buf_to_free)
 {
-	if (buf_to_free == NULL) {
-		/* cifs_dbg(FYI, "Null buffer passed to cifs_buf_release\n");*/
+	if (buf_to_free == NULL)
 		return;
-	}
 	mempool_free(buf_to_free, cifs_req_poolp);
 
 	atomic_dec(&buf_alloc_count);
@@ -203,8 +199,6 @@ cifs_small_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
 	ret_buf = mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
-	/* No need to clear memory here, cleared in header assemble */
-	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
 	atomic_inc(&small_buf_alloc_count);
 #ifdef CONFIG_CIFS_STATS2
 	atomic_inc(&total_small_buf_alloc_count);
@@ -428,8 +422,6 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 				((char *)&pSMBr->hdr.Protocol + data_offset);
 			cifs_dbg(FYI, "dnotify on %s Action: 0x%x\n",
 				 pnotify->FileName, pnotify->Action);
-			/*   cifs_dump_mem("Rcvd notify Data: ",buf,
-				sizeof(struct smb_hdr)+60); */
 			return true;
 		}
 		if (pSMBr->hdr.Status.CifsError) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index aa4c1d403708..2f36bc1720fd 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5862,7 +5862,7 @@ struct smb_version_operations smb311_operations = {
 	.parse_lease_buf = smb3_parse_lease_buf,
 	.copychunk_range = smb2_copychunk_range,
 	.duplicate_extents = smb2_duplicate_extents,
-/*	.validate_negotiate = smb3_validate_negotiate, */ /* not used in 3.11 */
+	/* validate_negotiate not used in 3.11 */
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.fallocate = smb3_fallocate,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index dac8d6f9b309..081dd21b731e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -54,8 +54,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	temp->pid = current->pid;
 	temp->command = cpu_to_le16(smb_buffer->Command);
 	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
-	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
-	/* when mid allocated can be before when sent */
+	/* when_alloc can be before when_sent */
 	temp->when_alloc = jiffies;
 	temp->server = server;
 
-- 
2.35.3

