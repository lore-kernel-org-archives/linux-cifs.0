From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 21/22] CIFS: Move clear/print_stats code to ops struct
Date: Tue, 19 Jun 2012 16:40:10 +0400
Message-ID: <1340109611-7210-22-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   60 ++++---------------------------------------
 fs/cifs/cifsglob.h   |   48 ++++++++++++++++++++---------------
 fs/cifs/cifssmb.c    |   54 ++++++++++++++++++++--------------------
 fs/cifs/misc.c       |    2 +-
 fs/cifs/smb1ops.c    |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+), 103 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 8aa8693..d9ea6ed 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -282,24 +282,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 							  struct cifs_tcon,
 							  tcon_list);
 					atomic_set(&tcon->num_smbs_sent, 0);
-					atomic_set(&tcon->num_writes, 0);
-					atomic_set(&tcon->num_reads, 0);
-					atomic_set(&tcon->num_oplock_brks, 0);
-					atomic_set(&tcon->num_opens, 0);
-					atomic_set(&tcon->num_posixopens, 0);
-					atomic_set(&tcon->num_posixmkdirs, 0);
-					atomic_set(&tcon->num_closes, 0);
-					atomic_set(&tcon->num_deletes, 0);
-					atomic_set(&tcon->num_mkdirs, 0);
-					atomic_set(&tcon->num_rmdirs, 0);
-					atomic_set(&tcon->num_renames, 0);
-					atomic_set(&tcon->num_t2renames, 0);
-					atomic_set(&tcon->num_ffirst, 0);
-					atomic_set(&tcon->num_fnext, 0);
-					atomic_set(&tcon->num_fclose, 0);
-					atomic_set(&tcon->num_hardlinks, 0);
-					atomic_set(&tcon->num_symlinks, 0);
-					atomic_set(&tcon->num_locks, 0);
+					if (server->ops->clear_stats)
+						server->ops->clear_stats(tcon);
 				}
 			}
 		}
@@ -358,42 +342,10 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n%d) %s", i, tcon->treeName);
 				if (tcon->need_reconnect)
 					seq_puts(m, "\tDISCONNECTED ");
-				seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
-					atomic_read(&tcon->num_smbs_sent),
-					atomic_read(&tcon->num_oplock_brks));
-				seq_printf(m, "\nReads:  %d Bytes: %lld",
-					atomic_read(&tcon->num_reads),
-					(long long)(tcon->bytes_read));
-				seq_printf(m, "\nWrites: %d Bytes: %lld",
-					atomic_read(&tcon->num_writes),
-					(long long)(tcon->bytes_written));
-				seq_printf(m, "\nFlushes: %d",
-					atomic_read(&tcon->num_flushes));
-				seq_printf(m, "\nLocks: %d HardLinks: %d "
-					      "Symlinks: %d",
-					atomic_read(&tcon->num_locks),
-					atomic_read(&tcon->num_hardlinks),
-					atomic_read(&tcon->num_symlinks));
-				seq_printf(m, "\nOpens: %d Closes: %d "
-					      "Deletes: %d",
-					atomic_read(&tcon->num_opens),
-					atomic_read(&tcon->num_closes),
-					atomic_read(&tcon->num_deletes));
-				seq_printf(m, "\nPosix Opens: %d "
-					      "Posix Mkdirs: %d",
-					atomic_read(&tcon->num_posixopens),
-					atomic_read(&tcon->num_posixmkdirs));
-				seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
-					atomic_read(&tcon->num_mkdirs),
-					atomic_read(&tcon->num_rmdirs));
-				seq_printf(m, "\nRenames: %d T2 Renames %d",
-					atomic_read(&tcon->num_renames),
-					atomic_read(&tcon->num_t2renames));
-				seq_printf(m, "\nFindFirst: %d FNext %d "
-					      "FClose %d",
-					atomic_read(&tcon->num_ffirst),
-					atomic_read(&tcon->num_fnext),
-					atomic_read(&tcon->num_fclose));
+				seq_printf(m, "\nSMBs: %d",
+					   atomic_read(&tcon->num_smbs_sent));
+				if (server->ops->print_stats)
+					server->ops->print_stats(m, tcon);
 			}
 		}
 	}
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 30f5bd7..3665e1c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -194,6 +194,8 @@ struct smb_version_operations {
 	/* find mid corresponding to the response message */
 	struct mid_q_entry * (*find_mid)(struct TCP_Server_Info *, char *);
 	void (*dump_detail)(void *);
+	void (*clear_stats)(struct cifs_tcon *);
+	void (*print_stats)(struct seq_file *m, struct cifs_tcon *);
 	/* verify the message */
 	int (*check_message)(char *, unsigned int);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
@@ -556,27 +558,31 @@ struct cifs_tcon {
 	enum statusEnum tidStatus;
 #ifdef CONFIG_CIFS_STATS
 	atomic_t num_smbs_sent;
-	atomic_t num_writes;
-	atomic_t num_reads;
-	atomic_t num_flushes;
-	atomic_t num_oplock_brks;
-	atomic_t num_opens;
-	atomic_t num_closes;
-	atomic_t num_deletes;
-	atomic_t num_mkdirs;
-	atomic_t num_posixopens;
-	atomic_t num_posixmkdirs;
-	atomic_t num_rmdirs;
-	atomic_t num_renames;
-	atomic_t num_t2renames;
-	atomic_t num_ffirst;
-	atomic_t num_fnext;
-	atomic_t num_fclose;
-	atomic_t num_hardlinks;
-	atomic_t num_symlinks;
-	atomic_t num_locks;
-	atomic_t num_acl_get;
-	atomic_t num_acl_set;
+	union {
+		struct {
+			atomic_t num_writes;
+			atomic_t num_reads;
+			atomic_t num_flushes;
+			atomic_t num_oplock_brks;
+			atomic_t num_opens;
+			atomic_t num_closes;
+			atomic_t num_deletes;
+			atomic_t num_mkdirs;
+			atomic_t num_posixopens;
+			atomic_t num_posixmkdirs;
+			atomic_t num_rmdirs;
+			atomic_t num_renames;
+			atomic_t num_t2renames;
+			atomic_t num_ffirst;
+			atomic_t num_fnext;
+			atomic_t num_fclose;
+			atomic_t num_hardlinks;
+			atomic_t num_symlinks;
+			atomic_t num_locks;
+			atomic_t num_acl_get;
+			atomic_t num_acl_set;
+		} cifs_stats;
+	} stats;
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long long time_writes;
 	unsigned long long time_reads;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 13e1c7f..0fb345d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -875,7 +875,7 @@ PsxDelete:
 		cFYI(1, "Posix delete returned %d", rc);
 	cifs_buf_release(pSMB);
 
-	cifs_stats_inc(&tcon->num_deletes);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
 
 	if (rc == -EAGAIN)
 		goto PsxDelete;
@@ -917,7 +917,7 @@ DelFileRetry:
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_deletes);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
 	if (rc)
 		cFYI(1, "Error in RMFile = %d", rc);
 
@@ -961,7 +961,7 @@ RmDirRetry:
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_rmdirs);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_rmdirs);
 	if (rc)
 		cFYI(1, "Error in RMDir = %d", rc);
 
@@ -1004,7 +1004,7 @@ MkDirRetry:
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_mkdirs);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_mkdirs);
 	if (rc)
 		cFYI(1, "Error in Mkdir = %d", rc);
 
@@ -1126,9 +1126,9 @@ psx_create_err:
 	cifs_buf_release(pSMB);
 
 	if (posix_flags & SMB_O_DIRECTORY)
-		cifs_stats_inc(&tcon->num_posixmkdirs);
+		cifs_stats_inc(&tcon->stats.cifs_stats.num_posixmkdirs);
 	else
-		cifs_stats_inc(&tcon->num_posixopens);
+		cifs_stats_inc(&tcon->stats.cifs_stats.num_posixopens);
 
 	if (rc == -EAGAIN)
 		goto PsxCreat;
@@ -1249,7 +1249,7 @@ OldOpenRetry:
 	/* long_op set to 1 to allow for oplock break timeouts */
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_opens);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
 	if (rc) {
 		cFYI(1, "Error in Open = %d", rc);
 	} else {
@@ -1362,7 +1362,7 @@ openRetry:
 	/* long_op set to 1 to allow for oplock break timeouts */
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_opens);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
 	if (rc) {
 		cFYI(1, "Error in Open = %d", rc);
 	} else {
@@ -1627,7 +1627,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 			     rdata, 0);
 
 	if (rc == 0)
-		cifs_stats_inc(&tcon->num_reads);
+		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
 	else
 		kref_put(&rdata->refcount, cifs_readdata_release);
 
@@ -1697,7 +1697,7 @@ CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigned int *nbytes,
 	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
 			 &resp_buf_type, CIFS_LOG_ERROR);
-	cifs_stats_inc(&tcon->num_reads);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
 	pSMBr = (READ_RSP *)iov[0].iov_base;
 	if (rc) {
 		cERROR(1, "Send error in read = %d", rc);
@@ -1849,7 +1849,7 @@ CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, long_op);
-	cifs_stats_inc(&tcon->num_writes);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
 		cFYI(1, "Send error in write = %d", rc);
 	} else {
@@ -2098,7 +2098,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 			     NULL, cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
-		cifs_stats_inc(&tcon->num_writes);
+		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	else
 		kref_put(&wdata->refcount, cifs_writedata_release);
 
@@ -2188,7 +2188,7 @@ CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
 
 	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type,
 			  long_op);
-	cifs_stats_inc(&tcon->num_writes);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
 		cFYI(1, "Send error Write2 = %d", rc);
 	} else if (resp_buf_type == 0) {
@@ -2254,7 +2254,7 @@ int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
 	iov[1].iov_base = (char *)buf;
 	iov[1].iov_len = (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
 
-	cifs_stats_inc(&tcon->num_locks);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
 	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
 	if (rc)
 		cFYI(1, "Send error in cifs_lockv = %d", rc);
@@ -2323,7 +2323,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 		rc = SendReceiveNoRsp(xid, tcon->ses, (char *)pSMB, flags);
 		/* SMB buffer freed by function above */
 	}
-	cifs_stats_inc(&tcon->num_locks);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
 	if (rc)
 		cFYI(1, "Send error in Lock = %d", rc);
 
@@ -2488,7 +2488,7 @@ CIFSSMBClose(const int xid, struct cifs_tcon *tcon, int smb_file_id)
 	pSMB->LastWriteTime = 0xFFFFFFFF;
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
-	cifs_stats_inc(&tcon->num_closes);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_closes);
 	if (rc) {
 		if (rc != -EINTR) {
 			/* EINTR is expected when user ctl-c to kill app */
@@ -2517,7 +2517,7 @@ CIFSSMBFlush(const int xid, struct cifs_tcon *tcon, int smb_file_id)
 	pSMB->FileID = (__u16) smb_file_id;
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
-	cifs_stats_inc(&tcon->num_flushes);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_flushes);
 	if (rc)
 		cERROR(1, "Send error in Flush = %d", rc);
 
@@ -2580,7 +2580,7 @@ renameRetry:
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_renames);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_renames);
 	if (rc)
 		cFYI(1, "Send error in rename = %d", rc);
 
@@ -2661,7 +2661,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifs_tcon *pTcon,
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, pTcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&pTcon->num_t2renames);
+	cifs_stats_inc(&pTcon->stats.cifs_stats.num_t2renames);
 	if (rc)
 		cFYI(1, "Send error in Rename (by file handle) = %d", rc);
 
@@ -2818,7 +2818,7 @@ createSymLinkRetry:
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_symlinks);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_symlinks);
 	if (rc)
 		cFYI(1, "Send error in SetPathInfo create symlink = %d", rc);
 
@@ -2904,7 +2904,7 @@ createHardLinkRetry:
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_hardlinks);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
 	if (rc)
 		cFYI(1, "Send error in SetPathInfo (hard link) = %d", rc);
 
@@ -2976,7 +2976,7 @@ winCreateHardLinkRetry:
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_hardlinks);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
 	if (rc)
 		cFYI(1, "Send error in hard link (NT rename) = %d", rc);
 
@@ -3394,7 +3394,7 @@ queryAclRetry:
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_acl_get);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
 	if (rc) {
 		cFYI(1, "Send error in Query POSIX ACL = %d", rc);
 	} else {
@@ -3705,7 +3705,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fid,
 
 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovec */, &buf_type,
 			 0);
-	cifs_stats_inc(&tcon->num_acl_get);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
 	if (rc) {
 		cFYI(1, "Send error in QuerySecDesc = %d", rc);
 	} else {                /* decode response */
@@ -4307,7 +4307,7 @@ findFirstRetry:
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_ffirst);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_ffirst);
 
 	if (rc) {/* BB add logic to retry regular search if Unix search
 			rejected unexpectedly by server */
@@ -4433,7 +4433,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon, __u16 searchHandle,
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			(struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	cifs_stats_inc(&tcon->num_fnext);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_fnext);
 	if (rc) {
 		if (rc == -EBADF) {
 			psrch_inf->endOfSearch = true;
@@ -4524,7 +4524,7 @@ CIFSFindClose(const int xid, struct cifs_tcon *tcon,
 	if (rc)
 		cERROR(1, "Send error in FindClose = %d", rc);
 
-	cifs_stats_inc(&tcon->num_fclose);
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_fclose);
 
 	/* Since session is dead, search handle closed on server already */
 	if (rc == -EAGAIN)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index df9f886..f090612 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -461,7 +461,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 			if (tcon->tid != buf->Tid)
 				continue;
 
-			cifs_stats_inc(&tcon->num_oplock_brks);
+			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
 			spin_lock(&cifs_file_list_lock);
 			list_for_each(tmp2, &tcon->openFileList) {
 				netfile = list_entry(tmp2, struct cifsFileInfo,
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 0bbe785..8cec320 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -531,6 +531,72 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 	return full_path;
 }
 
+static void
+cifs_clear_stats(struct cifs_tcon *tcon)
+{
+#ifdef CONFIG_CIFS_STATS
+	atomic_set(&tcon->stats.cifs_stats.num_writes, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_reads, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_flushes, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_oplock_brks, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_opens, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_posixopens, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_posixmkdirs, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_closes, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_deletes, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_mkdirs, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_rmdirs, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_renames, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_t2renames, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_ffirst, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_fnext, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_fclose, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_hardlinks, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_symlinks, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_locks, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_acl_get, 0);
+	atomic_set(&tcon->stats.cifs_stats.num_acl_set, 0);
+#endif
+}
+
+static void
+cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
+{
+#ifdef CONFIG_CIFS_STATS
+	seq_printf(m, " Oplocks breaks: %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
+	seq_printf(m, "\nReads:  %d Bytes: %llu",
+		   atomic_read(&tcon->stats.cifs_stats.num_reads),
+		   (long long)(tcon->bytes_read));
+	seq_printf(m, "\nWrites: %d Bytes: %llu",
+		   atomic_read(&tcon->stats.cifs_stats.num_writes),
+		   (long long)(tcon->bytes_written));
+	seq_printf(m, "\nFlushes: %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_flushes));
+	seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_locks),
+		   atomic_read(&tcon->stats.cifs_stats.num_hardlinks),
+		   atomic_read(&tcon->stats.cifs_stats.num_symlinks));
+	seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_opens),
+		   atomic_read(&tcon->stats.cifs_stats.num_closes),
+		   atomic_read(&tcon->stats.cifs_stats.num_deletes));
+	seq_printf(m, "\nPosix Opens: %d Posix Mkdirs: %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_posixopens),
+		   atomic_read(&tcon->stats.cifs_stats.num_posixmkdirs));
+	seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_mkdirs),
+		   atomic_read(&tcon->stats.cifs_stats.num_rmdirs));
+	seq_printf(m, "\nRenames: %d T2 Renames %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_renames),
+		   atomic_read(&tcon->stats.cifs_stats.num_t2renames));
+	seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
+		   atomic_read(&tcon->stats.cifs_stats.num_ffirst),
+		   atomic_read(&tcon->stats.cifs_stats.num_fnext),
+		   atomic_read(&tcon->stats.cifs_stats.num_fclose));
+#endif
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -547,6 +613,8 @@ struct smb_version_operations smb1_operations = {
 	.find_mid = cifs_find_mid,
 	.check_message = checkSMB,
 	.dump_detail = cifs_dump_detail,
+	.clear_stats = cifs_clear_stats,
+	.print_stats = cifs_print_stats,
 	.is_oplock_break = is_valid_oplock_break,
 	.check_trans2 = cifs_check_trans2,
 	.need_neg = cifs_need_neg,
-- 
1.7.1
