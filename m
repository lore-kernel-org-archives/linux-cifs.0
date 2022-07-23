Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C2DC43334
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jul 2022 20:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiGWU7K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Jul 2022 16:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbiGWU7J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Jul 2022 16:59:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49057183A6
        for <linux-cifs@vger.kernel.org>; Sat, 23 Jul 2022 13:59:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DAF833F0D2;
        Sat, 23 Jul 2022 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658609945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rI+uzf99ip0hovdXfVjz+bcjtBOGnp+wbhx/e0AK5h0=;
        b=MhjChJ43niG9gtxdgEthPcyBHxCqSoThl3BNz6ownpcNqdAk4jTVI0NUgzlN6pNtutLsz6
        9no8Tgjxw2vQpQpTWxo/7Q3MsPLff+aTWTgdCAN3n8g0qmCo4J549uzZ6Q99hqdXSBd+0B
        Nj/lyr674K6q8UyAvd+WLp2Pb3tTHm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658609945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rI+uzf99ip0hovdXfVjz+bcjtBOGnp+wbhx/e0AK5h0=;
        b=2yUmwMv5bd4J6aVPVp33ExnWGYWJqUX5N+bn+9N53kbwaVCEa/gQNROY0thwOMPzXfFyBD
        rO07yVlDztsWElAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 568F513483;
        Sat, 23 Jul 2022 20:59:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yGdjBhlh3GKmdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 23 Jul 2022 20:59:05 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: remove some more dead code
Date:   Sat, 23 Jul 2022 17:59:01 -0300
Message-Id: <20220723205901.16678-1-ematsumiya@suse.de>
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

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.h  | 26 ++++-------------------
 fs/cifs/cifsacl.c     |  5 -----
 fs/cifs/cifsencrypt.c |  3 ---
 fs/cifs/cifsproto.h   |  2 +-
 fs/cifs/cifssmb.c     | 18 ----------------
 fs/cifs/dir.c         | 18 ----------------
 fs/cifs/export.c      |  6 ------
 fs/cifs/file.c        |  3 ---
 fs/cifs/ioctl.c       | 12 -----------
 fs/cifs/link.c        |  3 ---
 fs/cifs/netmisc.c     |  6 ------
 fs/cifs/readdir.c     | 49 +++++++++----------------------------------
 fs/cifs/smb2pdu.c     | 44 +-------------------------------------
 13 files changed, 16 insertions(+), 179 deletions(-)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index ee4ea2b60c0f..6edcb834d1f4 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -134,27 +134,9 @@ do {									\
  *	---------
  */
 #else		/* _CIFS_DEBUG */
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
+#define cifs_dbg(type, fmt, ...)
+#define cifs_server_dbg(type, fmt, ...)
+#define cifs_tcon_dbg(type, fmt, ...)
+#define cifs_info(fmt, ...) pr_info(fmt, ##__VA_ARGS__)
 #endif
-
 #endif				/* _H_CIFS_DEBUG */
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d38677e59484..a9c7ad6097b2 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -839,11 +839,6 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
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
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7198cae5bbf0..a59a57a354ae 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -241,9 +241,6 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	if (rc)
 		return rc;
 
-/*	cifs_dump_mem("what we think it should be: ",
-		      what_we_think_sig_should_be, 16); */
-
 	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4b67df555c14..f3680348207f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -217,7 +217,7 @@ extern void cifs_put_tcon(struct cifs_tcon *);
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
 #else /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
-#define cifs_dfs_release_automount_timer()	do { } while (0)
+#define cifs_dfs_release_automount_timer()
 #endif /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
 
 void cifs_proc_init(void);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d7cf1fae3af5..2bb0c72eb148 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1748,10 +1748,6 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
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
@@ -1792,7 +1788,6 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	*nbytes = 0;
 
-	/* cifs_dbg(FYI, "write at %lld %d bytes\n", offset, count);*/
 	if (tcon->ses == NULL)
 		return -ECONNABORTED;
 
@@ -3355,10 +3350,6 @@ static void cifs_convert_ace(struct posix_acl_xattr_entry *ace,
 	ace->e_perm = cpu_to_le16(cifs_ace->cifs_e_perm);
 	ace->e_tag  = cpu_to_le16(cifs_ace->cifs_e_tag);
 	ace->e_id   = cpu_to_le32(le64_to_cpu(cifs_ace->cifs_uid));
-/*
-	cifs_dbg(FYI, "perm %d tag %d id %d\n",
-		 ace->e_perm, ace->e_tag, ace->e_id);
-*/
 
 	return;
 }
@@ -3432,10 +3423,6 @@ static void convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
 		cifs_ace->cifs_uid = cpu_to_le64(-1);
 	} else
 		cifs_ace->cifs_uid = cpu_to_le64(le32_to_cpu(local_ace->e_id));
-/*
-	cifs_dbg(FYI, "perm %d tag %d id %d\n",
-		 ace->e_perm, ace->e_tag, ace->e_id);
-*/
 }
 
 /* Convert ACL from local Linux POSIX xattr to CIFS POSIX ACL wire format */
@@ -4123,7 +4110,6 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	/* cifs_dbg(FYI, "In QPathInfo path %s\n", search_name); */
 QPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4628,9 +4614,6 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 				psrch_inf->last_entry =
 					psrch_inf->srch_entries_start + lnoff;
 
-/*  cifs_dbg(FYI, "fnxt2 entries in buf %d index_of_last %d\n",
-    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry); */
-
 			/* BB fixme add unlock here */
 		}
 
@@ -6314,7 +6297,6 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/*BB add length check to see if it would fit in
 	     negotiated SMB buffer size BB */
-	/* if (ea_value_len > buffer_size - 512 (enough for header)) */
 	if (ea_value_len)
 		memcpy(parm_data->list[0].name+name_len+1,
 		       ea_value, ea_value_len);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 13124b9c737d..cc940de39902 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -339,14 +339,6 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
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
@@ -772,19 +764,9 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
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
index 5c9290d55e02..05b0938afb79 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -40,12 +40,6 @@ static struct dentry *cifs_get_parent(struct dentry *dentry)
 
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
index c9f95d18b417..f8fe21dfed9e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -39,9 +39,6 @@ static inline int cifs_convert_flags(unsigned int flags)
 	else if ((flags & O_ACCMODE) == O_WRONLY)
 		return GENERIC_WRITE;
 	else if ((flags & O_ACCMODE) == O_RDWR) {
-		/* GENERIC_ALL is too much permission to request
-		   can cause unnecessary access denied on create */
-		/* return GENERIC_ALL; */
 		return (GENERIC_READ | GENERIC_WRITE);
 	}
 
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 7365abf170a4..ba5461589b1a 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -168,7 +168,6 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 		return 0;
 
 	cifs_dbg(VFS, "shut down requested (%d)", flags);
-/*	trace_cifs_shutdown(sb, flags);*/
 
 	/*
 	 * see:
@@ -356,23 +355,12 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
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
index 2990697916a3..976121f74933 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -706,9 +706,6 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
 					   cifs_sb->local_nls,
 					   cifs_remap(cifs_sb));
-	/* else
-	   rc = CIFSCreateReparseSymLink(xid, pTcon, fromName, toName,
-					cifs_sb_target->local_nls); */
 
 	if (rc == 0) {
 		if (pTcon->posix_extensions)
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 06f3ba5b05e3..9b9cb4b2d3f3 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -102,10 +102,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
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
@@ -1013,8 +1009,6 @@ struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 
 	ts.tv_sec = sec + offset;
 
-	/* cifs_dbg(FYI, "sec after cnvrt dos to unix time %d\n",sec); */
-
 	ts.tv_nsec = 0;
 	return ts;
 }
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 14546c32021d..590e15f426c0 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -333,36 +333,11 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
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
@@ -409,9 +384,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	cifs_dbg(FYI, "Full path: %s start at: %lld\n", full_path, file->f_pos);
 
 ffirst_retry:
-	/* test for Unix extensions */
-	/* but now check for them on the share/mount not on the SMB session */
-	/* if (cap_unix(tcon->ses) { */
+	/* test for Unix extensions on the share/mount, not on the SMB session */
 	if (tcon->unix_ext)
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_UNIX;
 	else if (tcon->posix_extensions)
@@ -435,9 +408,10 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 
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
@@ -1132,10 +1106,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 45f3db4da860..cdf1ff4112a2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -117,19 +117,6 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
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
@@ -950,10 +937,7 @@ SMB2_negotiate(const unsigned int xid,
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
@@ -1787,10 +1771,6 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	rc = cifs_send_recv(xid, ses, ses->server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
-	/*
-	 * No tcon so can't do
-	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
-	 */
 
 smb2_session_already_dead:
 	return rc;
@@ -2138,11 +2118,6 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
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
@@ -3618,23 +3593,6 @@ int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
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
-- 
2.35.3

