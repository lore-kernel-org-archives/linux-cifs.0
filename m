From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 35/45] CIFS: Move set_file_size to ops struct
Date: Wed, 18 Jul 2012 19:48:51 +0400
Message-ID: <1342626541-29872-36-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    6 +++
 fs/cifs/cifsproto.h |   10 ++---
 fs/cifs/cifssmb.c   |   40 ++++++++++---------
 fs/cifs/inode.c     |  106 +++++++++++++++++++++++++++------------------------
 fs/cifs/smb1ops.c   |    2 +
 5 files changed, 89 insertions(+), 75 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de11b1f..3f7a53d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -252,6 +252,12 @@ struct smb_version_operations {
 	int (*get_srv_inum)(const unsigned int, struct cifs_tcon *,
 			    struct cifs_sb_info *, const char *,
 			    u64 *uniqueid, FILE_ALL_INFO *);
+	/* set size by path */
+	int (*set_path_size)(const unsigned int, struct cifs_tcon *,
+			     const char *, __u64, struct cifs_sb_info *, bool);
+	/* set size by file handle */
+	int (*set_file_size)(const unsigned int, struct cifs_tcon *,
+			     struct cifsFileInfo *, __u64, bool);
 	/* build a full path to the root of the mount */
 	char * (*build_path_to_root)(struct smb_vol *, struct cifs_sb_info *,
 				     struct cifs_tcon *);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 06b90bb..6e04941 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -270,13 +270,11 @@ extern int CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon,
 			const struct nls_table *nls_codepage);
 #endif /* possibly unneeded function */
 extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *fileName, __u64 size,
-			bool setAllocationSizeFlag,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			 const char *file_name, __u64 size,
+			 struct cifs_sb_info *cifs_sb, bool set_allocation);
 extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
-			 __u64 size, __u16 fileHandle, __u32 opener_pid,
-			bool AllocSizeFlag);
+			      struct cifsFileInfo *cfile, __u64 size,
+			      bool set_allocation);
 
 struct cifs_unix_set_info_args {
 	__u64	ctime;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3029bf8..875a8c2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5392,16 +5392,16 @@ QFSPosixRetry:
 }
 
 
-/* We can not use write of zero bytes trick to
-   set file size due to need for large file support.  Also note that
-   this SetPathInfo is preferred to SetFileInfo based method in next
-   routine which is only needed to work around a sharing violation bug
-   in Samba which this routine can run into */
-
+/*
+ * We can not use write of zero bytes trick to set file size due to need for
+ * large file support. Also note that this SetPathInfo is preferred to
+ * SetFileInfo based method in next routine which is only needed to work around
+ * a sharing violation bugin Samba which this routine can run into.
+ */
 int
 CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
-	      const char *fileName, __u64 size, bool SetAllocation,
-	      const struct nls_table *nls_codepage, int remap)
+	      const char *file_name, __u64 size, struct cifs_sb_info *cifs_sb,
+	      bool set_allocation)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -5409,6 +5409,8 @@ CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	int rc = 0;
 	int bytes_returned = 0;
+	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
+
 	__u16 params, byte_count, data_count, param_offset, offset;
 
 	cFYI(1, "In SetEOF");
@@ -5420,14 +5422,14 @@ SetEOFRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
-				       PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, file_name,
+				       PATH_MAX, cifs_sb->local_nls, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(fileName, PATH_MAX);
+		name_len = strnlen(file_name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->FileName, fileName, name_len);
+		strncpy(pSMB->FileName, file_name, name_len);
 	}
 	params = 6 + name_len;
 	data_count = sizeof(struct file_end_of_file_info);
@@ -5441,7 +5443,7 @@ SetEOFRetry:
 	param_offset = offsetof(struct smb_com_transaction2_spi_req,
 				InformationLevel) - 4;
 	offset = param_offset + params;
-	if (SetAllocation) {
+	if (set_allocation) {
 		if (tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU)
 			pSMB->InformationLevel =
 				cpu_to_le16(SMB_SET_FILE_ALLOCATION_INFO2);
@@ -5488,8 +5490,8 @@ SetEOFRetry:
 }
 
 int
-CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon, __u64 size,
-		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
+CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
+		   struct cifsFileInfo *cfile, __u64 size, bool set_allocation)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	struct file_end_of_file_info *parm_data;
@@ -5503,8 +5505,8 @@ CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon, __u64 size,
 	if (rc)
 		return rc;
 
-	pSMB->hdr.Pid = cpu_to_le16((__u16)pid_of_opener);
-	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid_of_opener >> 16));
+	pSMB->hdr.Pid = cpu_to_le16((__u16)cfile->pid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(cfile->pid >> 16));
 
 	params = 6;
 	pSMB->MaxSetupCount = 0;
@@ -5533,8 +5535,8 @@ CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon, __u64 size,
 				+ offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
 	parm_data->FileSize = cpu_to_le64(size);
-	pSMB->Fid = fid;
-	if (SetAllocation) {
+	pSMB->Fid = cfile->fid.netfid;
+	if (set_allocation) {
 		if (tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU)
 			pSMB->InformationLevel =
 				cpu_to_le16(SMB_SET_FILE_ALLOCATION_INFO2);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f1448d9..16101a0 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1883,7 +1883,8 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = NULL;
-	struct cifs_tcon *pTcon = NULL;
+	struct cifs_tcon *tcon = NULL;
+	struct TCP_Server_Info *server;
 	struct cifs_io_parms io_parms;
 
 	/*
@@ -1897,19 +1898,21 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 */
 	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
-		__u16 nfid = open_file->fid.netfid;
-		__u32 npid = open_file->pid;
-		pTcon = tlink_tcon(open_file->tlink);
-		rc = CIFSSMBSetFileSize(xid, pTcon, attrs->ia_size, nfid,
-					npid, false);
+		tcon = tlink_tcon(open_file->tlink);
+		server = tcon->ses->server;
+		if (server->ops->set_file_size)
+			rc = server->ops->set_file_size(xid, tcon, open_file,
+							attrs->ia_size, false);
+		else
+			rc = -ENOSYS;
 		cifsFileInfo_put(open_file);
 		cFYI(1, "SetFSize for attrs rc = %d", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			unsigned int bytes_written;
 
-			io_parms.netfid = nfid;
-			io_parms.pid = npid;
-			io_parms.tcon = pTcon;
+			io_parms.netfid = open_file->fid.netfid;
+			io_parms.pid = open_file->pid;
+			io_parms.tcon = tcon;
 			io_parms.offset = 0;
 			io_parms.length = attrs->ia_size;
 			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
@@ -1919,52 +1922,55 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	} else
 		rc = -EINVAL;
 
-	if (rc != 0) {
-		if (pTcon == NULL) {
-			tlink = cifs_sb_tlink(cifs_sb);
-			if (IS_ERR(tlink))
-				return PTR_ERR(tlink);
-			pTcon = tlink_tcon(tlink);
-		}
+	if (!rc)
+		goto set_size_out;
 
-		/* Set file size by pathname rather than by handle
-		   either because no valid, writeable file handle for
-		   it was found or because there was an error setting
-		   it by handle */
-		rc = CIFSSMBSetEOF(xid, pTcon, full_path, attrs->ia_size,
-				   false, cifs_sb->local_nls,
+	if (tcon == NULL) {
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink))
+			return PTR_ERR(tlink);
+		tcon = tlink_tcon(tlink);
+		server = tcon->ses->server;
+	}
+
+	/*
+	 * Set file size by pathname rather than by handle either because no
+	 * valid, writeable file handle for it was found or because there was
+	 * an error setting it by handle.
+	 */
+	if (server->ops->set_path_size)
+		rc = server->ops->set_path_size(xid, tcon, full_path,
+						attrs->ia_size, cifs_sb, false);
+	else
+		rc = -ENOSYS;
+	cFYI(1, "SetEOF by path (setattrs) rc = %d", rc);
+	if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
+		__u16 netfid;
+		int oplock = 0;
+
+		rc = SMBLegacyOpen(xid, tcon, full_path, FILE_OPEN,
+				   GENERIC_WRITE, CREATE_NOT_DIR, &netfid,
+				   &oplock, NULL, cifs_sb->local_nls,
 				   cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-		cFYI(1, "SetEOF by path (setattrs) rc = %d", rc);
-		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
-			__u16 netfid;
-			int oplock = 0;
-
-			rc = SMBLegacyOpen(xid, pTcon, full_path,
-				FILE_OPEN, GENERIC_WRITE,
-				CREATE_NOT_DIR, &netfid, &oplock, NULL,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-			if (rc == 0) {
-				unsigned int bytes_written;
-
-				io_parms.netfid = netfid;
-				io_parms.pid = current->tgid;
-				io_parms.tcon = pTcon;
-				io_parms.offset = 0;
-				io_parms.length = attrs->ia_size;
-				rc = CIFSSMBWrite(xid, &io_parms,
-						  &bytes_written,
-						  NULL, NULL,  1);
-				cFYI(1, "wrt seteof rc %d", rc);
-				CIFSSMBClose(xid, pTcon, netfid);
-			}
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (rc == 0) {
+			unsigned int bytes_written;
+
+			io_parms.netfid = netfid;
+			io_parms.pid = current->tgid;
+			io_parms.tcon = tcon;
+			io_parms.offset = 0;
+			io_parms.length = attrs->ia_size;
+			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, NULL,
+					  NULL,  1);
+			cFYI(1, "wrt seteof rc %d", rc);
+			CIFSSMBClose(xid, tcon, netfid);
 		}
-		if (tlink)
-			cifs_put_tlink(tlink);
 	}
+	if (tlink)
+		cifs_put_tlink(tlink);
 
+set_size_out:
 	if (rc == 0) {
 		cifsInode->server_eof = attrs->ia_size;
 		cifs_setsize(inode, attrs->ia_size);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index e5d6344..b73d275 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -793,6 +793,8 @@ struct smb_version_operations smb1_operations = {
 	.query_path_info = cifs_query_path_info,
 	.query_file_info = cifs_query_file_info,
 	.get_srv_inum = cifs_get_srv_inum,
+	.set_path_size = CIFSSMBSetEOF,
+	.set_file_size = CIFSSMBSetFileSize,
 	.build_path_to_root = cifs_build_path_to_root,
 	.echo = CIFSSMBEcho,
 	.mkdir = CIFSSMBMkDir,
-- 
1.7.1
