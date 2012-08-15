From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3] cifs: obtain file access during backup intent lookup
Date: Wed, 15 Aug 2012 09:06:30 -0500
Message-ID: <1345039590-18282-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

path based querries can fail for lack of access, especially during lookup
during open.
open itself would actually succeed becasue of back up intent bit
but querries (either path or file handle based) do not have a means to
specifiy backup intent bit.
So querry the file info during lookup using
 trans2 / findfirst / file_id_full_ir_info
to obtain file info as well as file_id/inode value.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Tushar Gosavi <tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h   |    1 +
 fs/cifs/cifsproto.h |   10 +++++---
 fs/cifs/cifssmb.c   |   43 ++++++++++++++++++++++--------------
 fs/cifs/inode.c     |   60 ++++++++++++++++++++++++++++++++++++++------------
 fs/cifs/readdir.c   |    8 ++----
 5 files changed, 81 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 3fb03e2..b539ee7 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -275,6 +275,7 @@
  * Invalid readdir handle
  */
 #define CIFS_NO_HANDLE        0xFFFF
+#define INVALINUM		0xFFFFFFFFFFFFFFFFULL
 
 #define NO_CHANGE_64          0xFFFFFFFFFFFFFFFFULL
 #define NO_CHANGE_32          0xFFFFFFFFUL
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f1bbf83..6b66516 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -132,14 +132,16 @@ void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
 extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
 				     FILE_UNIX_BASIC_INFO *info,
 				     struct cifs_sb_info *cifs_sb);
+extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
+					struct cifs_sb_info *);
 extern void cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
 extern struct inode *cifs_iget(struct super_block *sb,
 			       struct cifs_fattr *fattr);
 
 extern int cifs_get_file_info(struct file *filp);
 extern int cifs_get_inode_info(struct inode **inode, const char *full_path,
-			       FILE_ALL_INFO *data, struct super_block *sb,
-			       int xid, const __u16 *fid);
+			       void *data, struct super_block *sb,
+			       int xid, __u16 *fid);
 extern int cifs_get_file_info_unix(struct file *filp);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
@@ -190,10 +192,10 @@ extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		    const struct nls_table *);
 
 extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
-		const char *searchName, const struct nls_table *nls_codepage,
+		const char *searchName, struct cifs_sb_info *cifs_sb,
 		__u16 *searchHandle, __u16 search_flags,
 		struct cifs_search_info *psrch_inf,
-		int map, const char dirsep);
+		bool msearch);
 
 extern int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 		__u16 searchHandle, __u16 search_flags,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 074923c..32cc44c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4249,10 +4249,9 @@ UnixQPathInfoRetry:
 /* xid, tcon, searchName and codepage are input parms, rest are returned */
 int
 CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
-	      const char *searchName,
-	      const struct nls_table *nls_codepage,
+	      const char *searchName, struct cifs_sb_info *cifs_sb,
 	      __u16 *pnetfid, __u16 search_flags,
-	      struct cifs_search_info *psrch_inf, int remap, const char dirsep)
+	      struct cifs_search_info *psrch_inf, bool msearch)
 {
 /* level 257 SMB_ */
 	TRANSACTION2_FFIRST_REQ *pSMB = NULL;
@@ -4260,8 +4259,9 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	T2_FFIRST_RSP_PARMS *parms;
 	int rc = 0;
 	int bytes_returned = 0;
-	int name_len;
+	int name_len, remap;
 	__u16 params, byte_count;
+	struct nls_table *nls_codepage;
 
 	cFYI(1, "In FindFirst for %s", searchName);
 
@@ -4271,6 +4271,9 @@ findFirstRetry:
 	if (rc)
 		return rc;
 
+	nls_codepage = cifs_sb->local_nls;
+	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
+
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
@@ -4279,24 +4282,29 @@ findFirstRetry:
 		it got remapped to 0xF03A as if it were part of the
 		directory name instead of a wildcard */
 		name_len *= 2;
-		pSMB->FileName[name_len] = dirsep;
-		pSMB->FileName[name_len+1] = 0;
-		pSMB->FileName[name_len+2] = '*';
-		pSMB->FileName[name_len+3] = 0;
-		name_len += 4; /* now the trailing null */
-		pSMB->FileName[name_len] = 0; /* null terminate just in case */
-		pSMB->FileName[name_len+1] = 0;
-		name_len += 2;
+		if (msearch) {
+			pSMB->FileName[name_len] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[name_len+1] = 0;
+			pSMB->FileName[name_len+2] = '*';
+			pSMB->FileName[name_len+3] = 0;
+			name_len += 4; /* now the trailing null */
+			/* null terminate just in case */
+			pSMB->FileName[name_len] = 0;
+			pSMB->FileName[name_len+1] = 0;
+			name_len += 2;
+		}
 	} else {	/* BB add check for overrun of SMB buf BB */
 		name_len = strnlen(searchName, PATH_MAX);
 /* BB fix here and in unicode clause above ie
 		if (name_len > buffersize-header)
 			free buffer exit; BB */
 		strncpy(pSMB->FileName, searchName, name_len);
-		pSMB->FileName[name_len] = dirsep;
-		pSMB->FileName[name_len+1] = '*';
-		pSMB->FileName[name_len+2] = 0;
-		name_len += 3;
+		if (msearch) {
+			pSMB->FileName[name_len] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[name_len+1] = '*';
+			pSMB->FileName[name_len+2] = 0;
+			name_len += 3;
+		}
 	}
 
 	params = 12 + name_len /* includes null */ ;
@@ -4384,7 +4392,8 @@ findFirstRetry:
 			psrch_inf->last_entry = psrch_inf->srch_entries_start +
 							lnoff;
 
-			*pnetfid = parms->SearchHandle;
+			if (pnetfid)
+				*pnetfid = parms->SearchHandle;
 		} else {
 			cifs_buf_release(pSMB);
 		}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7354877..76aa1f9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -602,23 +602,25 @@ cgfi_exit:
 
 int
 cifs_get_inode_info(struct inode **inode, const char *full_path,
-		    FILE_ALL_INFO *data, struct super_block *sb, int xid,
-		    const __u16 *fid)
+		    void *data, struct super_block *sb, int xid, __u16 *fid)
 {
+	__u16 srchflgs;
 	int rc = 0, tmprc;
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	char *buf = NULL;
+	void *buf = NULL;
 	bool adjust_tz = false;
 	struct cifs_fattr fattr;
+	struct cifs_search_info *srchinf = NULL;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
+	fattr.cf_uniqueid = INVALINUM;
 
 	cFYI(1, "Getting info on %s", full_path);
 
@@ -635,24 +637,51 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 			rc = -ENOSYS;
 			goto cgii_exit;
 		}
+
 		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 		if (buf == NULL) {
 			rc = -ENOMEM;
 			goto cgii_exit;
 		}
 		data = (FILE_ALL_INFO *)buf;
-		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path,
-						  data, &adjust_tz);
-	}
+		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
+				full_path, data, &adjust_tz);
+		if (!rc)
+			cifs_all_info_to_fattr(&fattr,
+				(FILE_ALL_INFO *)data, cifs_sb,
+				adjust_tz);
+		else if (rc == -EREMOTE) {
+			cifs_create_dfs_fattr(&fattr, sb);
+			rc = 0;
+		} else if (rc == -EACCES && backup_cred(cifs_sb)) {
+			srchinf = kzalloc(sizeof(struct cifs_search_info),
+							GFP_KERNEL);
+			if (srchinf == NULL) {
+				rc = -ENOMEM;
+				goto cgii_exit;
+			}
 
-	if (!rc) {
-		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *)data, cifs_sb,
-				       adjust_tz);
-	} else if (rc == -EREMOTE) {
-		cifs_create_dfs_fattr(&fattr, sb);
-		rc = 0;
-	} else {
-		goto cgii_exit;
+			srchinf->endOfSearch = false;
+			srchinf->info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
+
+			srchflgs = CIFS_SEARCH_CLOSE_ALWAYS |
+				CIFS_SEARCH_CLOSE_AT_END |
+				CIFS_SEARCH_BACKUP_SEARCH;
+
+			rc = CIFSFindFirst(xid, tcon, full_path,
+				cifs_sb, fid, srchflgs, srchinf, 0);
+			if (!rc) {
+				data = srchinf->srch_entries_start;
+				cifs_dir_info_to_fattr(&fattr,
+					(FILE_DIRECTORY_INFO *)data, cifs_sb);
+				fattr.cf_uniqueid = le64_to_cpu(
+				((SEARCH_ID_FULL_DIR_INFO *)data)->UniqueId);
+				cifs_buf_release(srchinf->ntwrk_buf_start);
+				kfree(srchinf);
+			}
+		}
+		if (rc)
+			goto cgii_exit;
 	}
 
 	/*
@@ -664,7 +693,8 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	 */
 	if (*inode == NULL) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
-			if (server->ops->get_srv_inum)
+			if (server->ops->get_srv_inum &&
+					fattr.cf_uniqueid == INVALINUM)
 				tmprc = server->ops->get_srv_inum(xid, tcon,
 					cifs_sb, full_path, &fattr.cf_uniqueid,
 					data);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index d87f826..6ce1a5d 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -151,7 +151,7 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	}
 }
 
-static void
+void
 cifs_dir_info_to_fattr(struct cifs_fattr *fattr, FILE_DIRECTORY_INFO *info,
 		       struct cifs_sb_info *cifs_sb)
 {
@@ -278,10 +278,8 @@ ffirst_retry:
 	if (backup_cred(cifs_sb))
 		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
 
-	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb->local_nls,
-		&cifsFile->netfid, search_flags, &cifsFile->srch_inf,
-		cifs_sb->mnt_cifs_flags &
-			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
+	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb,
+		&cifsFile->netfid, search_flags, &cifsFile->srch_inf, 1);
 	if (rc == 0)
 		cifsFile->invalidHandle = false;
 	/* BB add following call to handle readdir on new NTFS symlink errors
-- 
1.6.0.2
