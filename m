From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 2/2] cifs: Alternate Data Stream: account for mount option mapchars
Date: Sat, 20 Oct 2012 08:26:08 -0500
Message-ID: <1350739568-9221-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Account for mount options mapchars.
In case of file streams to servers which do not support POSIX standard,
disregard mount option mapchars behaviour.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c |    5 +-
 fs/cifs/cifs_unicode.c |   26 +++++++--
 fs/cifs/cifs_unicode.h |    6 +-
 fs/cifs/cifsacl.c      |    6 +-
 fs/cifs/cifsglob.h     |    2 +-
 fs/cifs/cifsproto.h    |   50 +++++++----------
 fs/cifs/cifssmb.c      |  147 +++++++++++++++++++----------------------------
 fs/cifs/connect.c      |   13 ++--
 fs/cifs/dir.c          |    7 +--
 fs/cifs/file.c         |    4 +-
 fs/cifs/inode.c        |   61 +++++---------------
 fs/cifs/link.c         |   28 ++-------
 fs/cifs/readdir.c      |    4 +-
 fs/cifs/smb1ops.c      |   39 +++----------
 fs/cifs/smb2misc.c     |    5 +-
 fs/cifs/xattr.c        |   37 +++---------
 16 files changed, 163 insertions(+), 277 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ce5cbd7..c1b0e04 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -304,9 +304,8 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	ses = tlink_tcon(tlink)->ses;
 
 	xid = get_xid();
-	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
-		&num_referrals, &referrals,
-		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb,
+		&num_referrals, &referrals);
 	free_xid(xid);
 
 	cifs_put_tlink(tlink);
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 53cf2aa..f73024f 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -266,14 +266,29 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
  */
 int
 cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
-		 const struct nls_table *cp, int mapChars)
+		 struct cifs_sb_info *cifs_sb)
 {
 	int i, j, charlen;
 	char src_char;
 	__le16 dst_char;
 	wchar_t tmp;
+	int remap;
+	char *altstr = NULL;
+	struct nls_table *cp;
+	struct tcon_link *tlink = NULL;
+	struct cifs_tcon *tcon = NULL;
+
+	cp = cifs_sb->local_nls;
+	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (tlink) {
+		tcon = tlink_tcon(tlink);
+		if (tcon && !(tcon->unix_ext))
+			altstr = strchr(source, ':');
+	}
 
-	if (!mapChars)
+	if (!remap || altstr)
 		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
 
 	for (i = 0, j = 0; i < srclen; j++) {
@@ -330,7 +345,6 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 ctoUTF16_out:
 	return j;
 }
-
 #ifdef CONFIG_CIFS_SMB2
 /*
  * cifs_local_to_utf16_bytes - how long will a string be after conversion?
@@ -374,11 +388,13 @@ cifs_local_to_utf16_bytes(const char *from, int len,
  */
 __le16 *
 cifs_strndup_to_utf16(const char *src, const int maxlen, int *utf16_len,
-		      const struct nls_table *cp, int remap)
+		      struct cifs_sb_info *cifs_sb)
 {
 	int len;
 	__le16 *dst;
+	struct nls_table *cp;
 
+	cp = cifs_sb->local_nls;
 	len = cifs_local_to_utf16_bytes(src, maxlen, cp);
 	len += 2; /* NULL */
 	dst = kmalloc(len, GFP_KERNEL);
@@ -386,7 +402,7 @@ cifs_strndup_to_utf16(const char *src, const int maxlen, int *utf16_len,
 		*utf16_len = 0;
 		return NULL;
 	}
-	cifsConvertToUTF16(dst, src, strlen(src), cp, remap);
+	cifsConvertToUTF16(dst, src, strlen(src), cifs_sb);
 	*utf16_len = len;
 	return dst;
 }
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 4fb0974..a4349d7 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -74,6 +74,7 @@ extern const struct UniCaseRange CifsUniLowerRange[];
 #endif				/* UNIUPR_NOLOWER */
 
 #ifdef __KERNEL__
+struct cifs_sb_info;
 int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 		    const struct nls_table *codepage, bool mapchar);
 int cifs_utf16_bytes(const __le16 *from, int maxbytes,
@@ -83,11 +84,10 @@ char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const bool is_unicode,
 			      const struct nls_table *codepage);
 extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
-			      const struct nls_table *cp, int mapChars);
+			      struct cifs_sb_info *cifs_sb);
 #ifdef CONFIG_CIFS_SMB2
 extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
-				     int *utf16_len, const struct nls_table *cp,
-				     int remap);
+				int *utf16_len, struct cifs_sb_info *cifs_sb);
 #endif /* CONFIG_CIFS_SMB2 */
 #endif
 
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 2ee5c54..848e959 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1193,8 +1193,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
 	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONTROL,
-			create_options, &fid, &oplock, NULL, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			create_options, &fid, &oplock, NULL, cifs_sb);
 	if (!rc) {
 		rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
 		CIFSSMBClose(xid, tcon, fid);
@@ -1254,8 +1253,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 		access_flags = WRITE_DAC;
 
 	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, access_flags,
-			create_options, &fid, &oplock, NULL, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			create_options, &fid, &oplock, NULL, cifs_sb);
 	if (rc) {
 		cERROR(1, "Unable to open file to set ACL");
 		goto out;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 26d65c7..beb1cef 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -254,7 +254,7 @@ struct smb_version_operations {
 	/* get DFS referrals */
 	int (*get_dfs_refer)(const unsigned int, struct cifs_ses *,
 			     const char *, struct dfs_info3_param **,
-			     unsigned int *, const struct nls_table *, int);
+			     unsigned int *, struct cifs_sb_info *);
 	/* informational QFS call */
 	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *);
 	/* check if a path is accessible or not */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 5144e9f..fa816e9 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -235,10 +235,10 @@ extern int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			    const char *search_Name, FILE_ALL_INFO *data,
 			    int legacy /* whether to use old info level */,
-			    const struct nls_table *nls_codepage, int remap);
+			    struct cifs_sb_info *cifs_sb);
 extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 			       const char *search_name, FILE_ALL_INFO *data,
-			       const struct nls_table *nls_codepage, int remap);
+			       struct cifs_sb_info *cifs_sb);
 
 extern int CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			u16 netfid, FILE_UNIX_BASIC_INFO *pFindData);
@@ -246,19 +246,19 @@ extern int CIFSSMBUnixQPathInfo(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const unsigned char *searchName,
 			FILE_UNIX_BASIC_INFO *pFindData,
-			const struct nls_table *nls_codepage, int remap);
+			struct cifs_sb_info *cifs_sb);
 
 extern int CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 			   const char *search_name,
 			   struct dfs_info3_param **target_nodes,
 			   unsigned int *num_of_nodes,
-			   const struct nls_table *nls_codepage, int remap);
+			   struct cifs_sb_info *cifs_sb);
 
 extern int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
 			const char *old_path,
-			const struct nls_table *nls_codepage,
+			struct cifs_sb_info *cifs_sb,
 			unsigned int *num_referrals,
-			struct dfs_info3_param **referrals, int remap);
+			struct dfs_info3_param **referrals);
 extern void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 				 struct cifs_sb_info *cifs_sb,
 				 struct smb_vol *vol);
@@ -278,8 +278,7 @@ extern int CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 
 extern int CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fileName, const FILE_BASIC_INFO *data,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			const FILE_BASIC_INFO *data, __u16 fid,
 			__u32 pid_of_opener);
@@ -317,8 +316,7 @@ extern int CIFSSMBUnixSetFileInfo(const unsigned int xid,
 extern int CIFSSMBUnixSetPathInfo(const unsigned int xid,
 				  struct cifs_tcon *tcon, const char *file_name,
 				  const struct cifs_unix_set_info_args *args,
-				  const struct nls_table *nls_codepage,
-				  int remap);
+				  struct cifs_sb_info *cifs_sb);
 
 extern int CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *name, struct cifs_sb_info *cifs_sb);
@@ -326,8 +324,7 @@ extern int CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *name, __u16 type,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			  const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
@@ -335,16 +332,14 @@ extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
-				 const struct nls_table *nls_codepage,
-				 int remap_special_chars);
+				 struct cifs_sb_info *cifs_sb);
 extern int CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *from_name, const char *to_name,
 			      struct cifs_sb_info *cifs_sb);
 extern int CIFSUnixCreateHardLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			struct cifs_sb_info *cifs_sb);
 extern int CIFSUnixCreateSymLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
@@ -352,7 +347,7 @@ extern int CIFSUnixCreateSymLink(const unsigned int xid,
 extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const unsigned char *searchName, char **syminfo,
-			const struct nls_table *nls_codepage);
+			struct cifs_sb_info *cifs_sb);
 #ifdef CONFIG_CIFS_SYMLINK_EXPERIMENTAL
 extern int CIFSSMBQueryReparseLinkInfo(const unsigned int xid,
 			struct cifs_tcon *tcon,
@@ -364,17 +359,17 @@ extern int CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fileName, const int disposition,
 			const int access_flags, const int omode,
 			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
-			const struct nls_table *nls_codepage, int remap);
+			struct cifs_sb_info *cifs_sb);
 extern int SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fileName, const int disposition,
 			const int access_flags, const int omode,
 			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
-			const struct nls_table *nls_codepage, int remap);
+			struct cifs_sb_info *cifs_sb);
 extern int CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
 			u32 posix_flags, __u64 mode, __u16 *netfid,
 			FILE_UNIX_BASIC_INFO *pRetData,
 			__u32 *pOplock, const char *name,
-			const struct nls_table *nls_codepage, int remap);
+			struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon,
 			const int smb_file_id);
 
@@ -391,8 +386,7 @@ extern int CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 			unsigned int *nbytes, struct kvec *iov, const int nvec);
 extern int CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 				 const char *search_name, __u64 *inode_number,
-				 const struct nls_table *nls_codepage,
-				 int remap);
+				 struct cifs_sb_info *cifs_sb);
 
 extern int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		      const __u16 netfid, const __u8 lock_type,
@@ -448,17 +442,15 @@ extern int CIFSSMBCopy(unsigned int xid,
 			const char *fromName,
 			const __u16 target_tid,
 			const char *toName, const int flags,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			struct cifs_sb_info *cifs_sb);
 extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 			const unsigned char *searchName,
 			const unsigned char *ea_name, char *EAData,
-			size_t bufsize, const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			size_t bufsize, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 		const char *fileName, const char *ea_name,
 		const void *ea_value, const __u16 ea_value_len,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
 			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
 extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
@@ -466,11 +458,11 @@ extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
 extern int CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 		const unsigned char *searchName,
 		char *acl_inf, const int buflen, const int acl_type,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 		const unsigned char *fileName,
 		const char *local_acl, const int buflen, const int acl_type,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		struct cifs_sb_info *cifs_sb);
 extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
 extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 76d0d29..3fea4a2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -803,8 +803,7 @@ session_already_dead:
 
 int
 CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-		 const char *fileName, __u16 type,
-		 const struct nls_table *nls_codepage, int remap)
+		 const char *fileName, __u16 type, struct cifs_sb_info *cifs_sb)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -824,7 +823,7 @@ PsxDelete:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else { /* BB add path length overrun check */
@@ -886,7 +885,6 @@ CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	int rc = 0;
 	int bytes_returned;
 	int name_len;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 DelFileRetry:
 	rc = smb_init(SMB_COM_DELETE, 1, tcon, (void **) &pSMB,
@@ -896,8 +894,7 @@ DelFileRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->fileName, name,
-					      PATH_MAX, cifs_sb->local_nls,
-					      remap);
+					      PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -932,7 +929,6 @@ CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	int rc = 0;
 	int bytes_returned;
 	int name_len;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSSMBRmDir");
 RmDirRetry:
@@ -943,8 +939,7 @@ RmDirRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, name,
-					      PATH_MAX, cifs_sb->local_nls,
-					      remap);
+					      PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -977,7 +972,6 @@ CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	CREATE_DIRECTORY_RSP *pSMBr = NULL;
 	int bytes_returned;
 	int name_len;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSSMBMkDir");
 MkDirRetry:
@@ -988,8 +982,7 @@ MkDirRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, name,
-					      PATH_MAX, cifs_sb->local_nls,
-					      remap);
+					      PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -1017,8 +1010,7 @@ int
 CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
 		__u32 posix_flags, __u64 mode, __u16 *netfid,
 		FILE_UNIX_BASIC_INFO *pRetData, __u32 *pOplock,
-		const char *name, const struct nls_table *nls_codepage,
-		int remap)
+		const char *name, struct cifs_sb_info *cifs_sb)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -1039,7 +1031,7 @@ PsxCreat:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, name,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -1185,7 +1177,7 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	    const char *fileName, const int openDisposition,
 	    const int access_flags, const int create_options, __u16 *netfid,
 	    int *pOplock, FILE_ALL_INFO *pfile_info,
-	    const struct nls_table *nls_codepage, int remap)
+	    struct cifs_sb_info *cifs_sb)
 {
 	int rc = -EACCES;
 	OPENX_REQ *pSMB = NULL;
@@ -1206,7 +1198,7 @@ OldOpenRetry:
 		count = 1;      /* account for one byte pad to word boundary */
 		name_len =
 		   cifsConvertToUTF16((__le16 *) (pSMB->fileName + 1),
-				      fileName, PATH_MAX, nls_codepage, remap);
+				      fileName, PATH_MAX, cifs_sb);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {                /* BB improve check for buffer overruns BB */
@@ -1292,7 +1284,7 @@ CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	    const char *fileName, const int openDisposition,
 	    const int access_flags, const int create_options, __u16 *netfid,
 	    int *pOplock, FILE_ALL_INFO *pfile_info,
-	    const struct nls_table *nls_codepage, int remap)
+	    struct cifs_sb_info *cifs_sb)
 {
 	int rc = -EACCES;
 	OPEN_REQ *pSMB = NULL;
@@ -1313,7 +1305,7 @@ openRetry:
 		count = 1;	/* account for one byte pad to word boundary */
 		name_len =
 		    cifsConvertToUTF16((__le16 *) (pSMB->fileName + 1),
-				       fileName, PATH_MAX, nls_codepage, remap);
+				       fileName, PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->NameLength = cpu_to_le16(name_len);
@@ -2522,7 +2514,6 @@ CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	int name_len, name_len2;
 	__u16 count;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSSMBRename");
 renameRetry:
@@ -2538,8 +2529,7 @@ renameRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
-					      from_name, PATH_MAX,
-					      cifs_sb->local_nls, remap);
+					      from_name, PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;	/* pad */
@@ -2547,8 +2537,7 @@ renameRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
 		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
-				       to_name, PATH_MAX, cifs_sb->local_nls,
-				       remap);
+				       to_name, PATH_MAX, cifs_sb);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2583,7 +2572,7 @@ renameRetry:
 
 int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 		int netfid, const char *target_name,
-		const struct nls_table *nls_codepage, int remap)
+		struct cifs_sb_info *cifs_sb)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
 	struct smb_com_transaction2_sfi_rsp *pSMBr = NULL;
@@ -2630,12 +2619,11 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 		sprintf(dummy_string, "cifs%x", pSMB->hdr.Mid);
 		len_of_str =
 			cifsConvertToUTF16((__le16 *)rename_info->target_name,
-					dummy_string, 24, nls_codepage, remap);
+					dummy_string, 24, cifs_sb);
 	} else {
 		len_of_str =
 			cifsConvertToUTF16((__le16 *)rename_info->target_name,
-					target_name, PATH_MAX, nls_codepage,
-					remap);
+					target_name, PATH_MAX, cifs_sb);
 	}
 	rename_info->target_name_len = cpu_to_le32(2 * len_of_str);
 	count = 12 /* sizeof(struct set_file_rename) */ + (2 * len_of_str);
@@ -2665,7 +2653,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 int
 CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
 	    const char *fromName, const __u16 target_tid, const char *toName,
-	    const int flags, const struct nls_table *nls_codepage, int remap)
+	    const int flags, struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	COPY_REQ *pSMB = NULL;
@@ -2688,8 +2676,7 @@ copyRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
-					      fromName, PATH_MAX, nls_codepage,
-					      remap);
+					      fromName, PATH_MAX, cifs_sb);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;     /* pad */
@@ -2697,7 +2684,7 @@ copyRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
 		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
-				       toName, PATH_MAX, nls_codepage, remap);
+				       toName, PATH_MAX, cifs_sb);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2; /* convert to bytes */
 	} else { 	/* BB improve the check for buffer overruns BB */
@@ -2822,7 +2809,7 @@ createSymLinkRetry:
 int
 CIFSUnixCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 		       const char *fromName, const char *toName,
-		       const struct nls_table *nls_codepage, int remap)
+		       struct cifs_sb_info *cifs_sb)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -2842,7 +2829,7 @@ createHardLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->FileName, toName,
-					      PATH_MAX, nls_codepage, remap);
+					      PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2865,7 +2852,7 @@ createHardLinkRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len_target =
 		    cifsConvertToUTF16((__le16 *) data_offset, fromName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len_target++;	/* trailing null */
 		name_len_target *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2915,7 +2902,6 @@ CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	int name_len, name_len2;
 	__u16 count;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSCreateHardLink");
 winCreateHardLinkRetry:
@@ -2936,7 +2922,7 @@ winCreateHardLinkRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->OldFileName, from_name,
-				       PATH_MAX, cifs_sb->local_nls, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2945,8 +2931,7 @@ winCreateHardLinkRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00; /* pad */
 		name_len2 =
 		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
-				       to_name, PATH_MAX, cifs_sb->local_nls,
-				       remap);
+				       to_name, PATH_MAX, cifs_sb);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2981,7 +2966,7 @@ winCreateHardLinkRetry:
 int
 CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 			const unsigned char *searchName, char **symlinkinfo,
-			const struct nls_table *nls_codepage)
+			struct cifs_sb_info *cifs_sb)
 {
 /* SMB_QUERY_FILE_UNIX_LINK */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3003,7 +2988,7 @@ querySymLinkRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifs_strtoUTF16((__le16 *) pSMB->FileName, searchName,
-					PATH_MAX, nls_codepage);
+					PATH_MAX, cifs_sb->local_nls);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3061,7 +3046,7 @@ querySymLinkRetry:
 
 			/* BB FIXME investigate remapping reserved chars here */
 			*symlinkinfo = cifs_strndup_from_utf16(data_start,
-					count, is_unicode, nls_codepage);
+					count, is_unicode, cifs_sb->local_nls);
 			if (!*symlinkinfo)
 				rc = -ENOMEM;
 		}
@@ -3324,7 +3309,7 @@ int
 CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 		   const unsigned char *searchName,
 		   char *acl_inf, const int buflen, const int acl_type,
-		   const struct nls_table *nls_codepage, int remap)
+		   struct cifs_sb_info *cifs_sb)
 {
 /* SMB_QUERY_POSIX_ACL */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3345,8 +3330,7 @@ queryAclRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUTF16((__le16 *) pSMB->FileName,
-					   searchName, PATH_MAX, nls_codepage,
-					   remap);
+					   searchName, PATH_MAX, cifs_sb);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 		pSMB->FileName[name_len] = 0;
@@ -3414,7 +3398,7 @@ CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 		   const unsigned char *fileName,
 		   const char *local_acl, const int buflen,
 		   const int acl_type,
-		   const struct nls_table *nls_codepage, int remap)
+		   struct cifs_sb_info *cifs_sb)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -3433,7 +3417,7 @@ setAclRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
-					   PATH_MAX, nls_codepage, remap);
+					   PATH_MAX, cifs_sb);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3824,7 +3808,7 @@ setCifsAclRetry:
 int
 SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 		    const char *search_name, FILE_ALL_INFO *data,
-		    const struct nls_table *nls_codepage, int remap)
+		    struct cifs_sb_info *cifs_sb)
 {
 	QUERY_INFORMATION_REQ *pSMB;
 	QUERY_INFORMATION_RSP *pSMBr;
@@ -3842,8 +3826,7 @@ QInfRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUTF16((__le16 *) pSMB->FileName,
-					   search_name, PATH_MAX, nls_codepage,
-					   remap);
+					   search_name, PATH_MAX, cifs_sb);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {
@@ -3960,7 +3943,7 @@ int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *search_name, FILE_ALL_INFO *data,
 		 int legacy /* old style infolevel */,
-		 const struct nls_table *nls_codepage, int remap)
+		 struct cifs_sb_info *cifs_sb)
 {
 	/* level 263 SMB_QUERY_FILE_ALL_INFO */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3980,7 +3963,7 @@ QPathInfoRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, search_name,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4130,7 +4113,7 @@ int
 CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		     const unsigned char *searchName,
 		     FILE_UNIX_BASIC_INFO *pFindData,
-		     const struct nls_table *nls_codepage, int remap)
+		     struct cifs_sb_info *cifs_sb)
 {
 /* SMB_QUERY_FILE_UNIX_BASIC */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -4150,7 +4133,7 @@ UnixQPathInfoRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4224,9 +4207,8 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	T2_FFIRST_RSP_PARMS *parms;
 	int rc = 0;
 	int bytes_returned = 0;
-	int name_len, remap;
+	int name_len;
 	__u16 params, byte_count;
-	struct nls_table *nls_codepage;
 
 	cFYI(1, "In FindFirst for %s", searchName);
 
@@ -4236,13 +4218,10 @@ findFirstRetry:
 	if (rc)
 		return rc;
 
-	nls_codepage = cifs_sb->local_nls;
-	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
-
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		/* We can not add the asterik earlier in case
 		it got remapped to 0xF03A as if it were part of the
 		directory name instead of a wildcard */
@@ -4537,7 +4516,7 @@ CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *search_name, __u64 *inode_number,
-		      const struct nls_table *nls_codepage, int remap)
+		      struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -4558,8 +4537,7 @@ GetInodeNumberRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUTF16((__le16 *) pSMB->FileName,
-					   search_name, PATH_MAX, nls_codepage,
-					   remap);
+					   search_name, PATH_MAX, cifs_sb);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4637,8 +4615,7 @@ static int
 parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		unsigned int *num_of_nodes,
 		struct dfs_info3_param **target_nodes,
-		const struct nls_table *nls_codepage, int remap,
-		const char *searchName)
+		struct cifs_sb_info *cifs_sb, const char *searchName)
 {
 	int i, rc = 0;
 	char *data_end;
@@ -4697,10 +4674,10 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 				goto parse_DFS_referrals_exit;
 			}
 			cifsConvertToUTF16((__le16 *) tmp, searchName,
-					   PATH_MAX, nls_codepage, remap);
+					   PATH_MAX, cifs_sb);
 			node->path_consumed = cifs_utf16_bytes(tmp,
 					le16_to_cpu(pSMBr->PathConsumed),
-					nls_codepage);
+					cifs_sb->local_nls);
 			kfree(tmp);
 		} else
 			node->path_consumed = le16_to_cpu(pSMBr->PathConsumed);
@@ -4712,7 +4689,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
 		max_len = data_end - temp;
 		node->path_name = cifs_strndup_from_utf16(temp, max_len,
-						is_unicode, nls_codepage);
+					is_unicode, cifs_sb->local_nls);
 		if (!node->path_name) {
 			rc = -ENOMEM;
 			goto parse_DFS_referrals_exit;
@@ -4722,7 +4699,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		temp = (char *)ref + le16_to_cpu(ref->NetworkAddressOffset);
 		max_len = data_end - temp;
 		node->node_name = cifs_strndup_from_utf16(temp, max_len,
-						is_unicode, nls_codepage);
+						is_unicode, cifs_sb->local_nls);
 		if (!node->node_name) {
 			rc = -ENOMEM;
 			goto parse_DFS_referrals_exit;
@@ -4744,7 +4721,7 @@ int
 CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		const char *search_name, struct dfs_info3_param **target_nodes,
 		unsigned int *num_of_nodes,
-		const struct nls_table *nls_codepage, int remap)
+		struct cifs_sb_info *cifs_sb)
 {
 /* TRANS2_GET_DFS_REFERRAL */
 	TRANSACTION2_GET_DFS_REFER_REQ *pSMB = NULL;
@@ -4753,10 +4730,10 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 	int bytes_returned;
 	int name_len;
 	__u16 params, byte_count;
-	*num_of_nodes = 0;
-	*target_nodes = NULL;
 
 	cFYI(1, "In GetDFSRefer the path %s", search_name);
+	*num_of_nodes = 0;
+	*target_nodes = NULL;
 	if (ses == NULL)
 		return -ENODEV;
 getDFSRetry:
@@ -4779,8 +4756,7 @@ getDFSRetry:
 		pSMB->hdr.Flags2 |= SMBFLG2_UNICODE;
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->RequestFileName,
-				       search_name, PATH_MAX, nls_codepage,
-				       remap);
+				       search_name, PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4841,8 +4817,7 @@ getDFSRetry:
 
 	/* parse returned result into more usable form */
 	rc = parse_DFS_referrals(pSMBr, num_of_nodes,
-				 target_nodes, nls_codepage, remap,
-				 search_name);
+				 target_nodes, cifs_sb, search_name);
 
 GetDFSRefExit:
 	cifs_buf_release(pSMB);
@@ -5403,7 +5378,6 @@ CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	int rc = 0;
 	int bytes_returned = 0;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	__u16 params, byte_count, data_count, param_offset, offset;
 
@@ -5417,7 +5391,7 @@ SetEOFRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, file_name,
-				       PATH_MAX, cifs_sb->local_nls, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5687,7 +5661,7 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *fileName, const FILE_BASIC_INFO *data,
-		   const struct nls_table *nls_codepage, int remap)
+		   struct cifs_sb_info *cifs_sb)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -5708,7 +5682,7 @@ SetTimesRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5924,7 +5898,7 @@ int
 CIFSSMBUnixSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		       const char *file_name,
 		       const struct cifs_unix_set_info_args *args,
-		       const struct nls_table *nls_codepage, int remap)
+		       struct cifs_sb_info *cifs_sb)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -5944,7 +5918,7 @@ setPermsRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, file_name,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -6012,7 +5986,7 @@ ssize_t
 CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 		const unsigned char *searchName, const unsigned char *ea_name,
 		char *EAData, size_t buf_size,
-		const struct nls_table *nls_codepage, int remap)
+		struct cifs_sb_info *cifs_sb)
 {
 		/* BB assumes one setup word */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -6037,7 +6011,7 @@ QAllEAsRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		list_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		list_len++;	/* trailing null */
 		list_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -6194,8 +6168,7 @@ QAllEAsOut:
 int
 CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	     const char *fileName, const char *ea_name, const void *ea_value,
-	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
-	     int remap)
+	     const __u16 ea_value_len, struct cifs_sb_info *cifs_sb)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -6215,7 +6188,7 @@ SetEARetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
-				       PATH_MAX, nls_codepage, remap);
+				       PATH_MAX, cifs_sb);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2fdbe08..deec3d6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2753,8 +2753,8 @@ out:
 
 int
 get_dfs_path(const unsigned int xid, struct cifs_ses *ses, const char *old_path,
-	     const struct nls_table *nls_codepage, unsigned int *num_referrals,
-	     struct dfs_info3_param **referrals, int remap)
+	     struct cifs_sb_info *cifs_sb, unsigned int *num_referrals,
+	     struct dfs_info3_param **referrals)
 {
 	char *temp_unc;
 	int rc = 0;
@@ -2776,14 +2776,14 @@ get_dfs_path(const unsigned int xid, struct cifs_ses *ses, const char *old_path,
 		strcpy(temp_unc + 2, ses->serverName);
 		strcpy(temp_unc + 2 + strlen(ses->serverName), "\\IPC$");
 		rc = ses->server->ops->tree_connect(xid, ses, temp_unc, NULL,
-						    nls_codepage);
+						    cifs_sb->local_nls);
 		cFYI(1, "Tcon rc = %d ipc_tid = %d", rc, ses->ipc_tid);
 		kfree(temp_unc);
 	}
 	if (rc == 0)
 		rc = ses->server->ops->get_dfs_refer(xid, ses, old_path,
 						     referrals, num_referrals,
-						     nls_codepage, remap);
+						     cifs_sb);
 	/*
 	 * BB - map targetUNCs to dfs_info3 structures, here or in
 	 * ses->server->ops->get_dfs_refer.
@@ -3326,9 +3326,8 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 	/* For DFS paths, skip the first '\' of the UNC */
 	ref_path = check_prefix ? full_path + 1 : volume_info->UNC + 1;
 
-	rc = get_dfs_path(xid, ses, ref_path, cifs_sb->local_nls,
-			  &num_referrals, &referrals,
-			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = get_dfs_path(xid, ses, ref_path, cifs_sb, &num_referrals,
+			  &referrals);
 
 	if (!rc && num_referrals > 0) {
 		char *fake_devname = NULL;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 7c0a812..4e8c53f 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -554,9 +554,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 			args.gid = NO_CHANGE_64;
 		}
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, &args,
-					    cifs_sb->local_nls,
-					    cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					    cifs_sb);
 		if (rc)
 			goto mknod_out;
 
@@ -587,8 +585,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 
 	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_CREATE,
 			 GENERIC_WRITE, create_options,
-			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 &fileHandle, &oplock, buf, cifs_sb);
 	if (rc)
 		goto mknod_out;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7d7bbdc..c5afde5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -134,9 +134,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 
 	posix_flags = cifs_posix_convert_flags(f_flags);
 	rc = CIFSPOSIXCreate(xid, tcon, posix_flags, mode, pnetfid, presp_data,
-			     poplock, full_path, cifs_sb->local_nls,
-			     cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+			     poplock, full_path, cifs_sb);
 	cifs_put_tlink(tlink);
 
 	if (rc)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 201ec46..b9fb02c 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -327,9 +327,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	tcon = tlink_tcon(tlink);
 
 	/* could have done a find first instead but this returns more info */
-	rc = CIFSSMBUnixQPathInfo(xid, tcon, full_path, &find_data,
-				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = CIFSSMBUnixQPathInfo(xid, tcon, full_path, &find_data, cifs_sb);
 	cifs_put_tlink(tlink);
 
 	if (!rc) {
@@ -396,10 +394,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	tcon = tlink_tcon(tlink);
 
 	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, GENERIC_READ,
-			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
-			 cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 CREATE_NOT_DIR, &netfid, &oplock, NULL, cifs_sb);
 	if (rc == 0) {
 		int buf_type = CIFS_NO_BUFFER;
 			/* Read header */
@@ -478,9 +473,7 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 	tcon = tlink_tcon(tlink);
 
 	rc = CIFSSMBQAllEAs(xid, tcon, path, "SETFILEBITS",
-			    ea_value, 4 /* size of buf */, cifs_sb->local_nls,
-			    cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			    ea_value, 4 /* size of buf */, cifs_sb);
 	cifs_put_tlink(tlink);
 	if (rc < 0)
 		return (int)rc;
@@ -1020,8 +1013,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 
 	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
 			 DELETE|FILE_WRITE_ATTRIBUTES, CREATE_NOT_DIR,
-			 &netfid, &oplock, NULL, cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 &netfid, &oplock, NULL, cifs_sb);
 	if (rc != 0)
 		goto out;
 
@@ -1053,9 +1045,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	}
 
 	/* rename the file */
-	rc = CIFSSMBRenameOpenFile(xid, tcon, netfid, NULL, cifs_sb->local_nls,
-				   cifs_sb->mnt_cifs_flags &
-					    CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = CIFSSMBRenameOpenFile(xid, tcon, netfid, NULL, cifs_sb);
 	if (rc != 0) {
 		rc = -ETXTBSY;
 		goto undo_setattr;
@@ -1095,9 +1085,7 @@ out:
 	 * them anyway.
 	 */
 undo_rename:
-	CIFSSMBRenameOpenFile(xid, tcon, netfid, dentry->d_name.name,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					    CIFS_MOUNT_MAP_SPECIAL_CHR);
+	CIFSSMBRenameOpenFile(xid, tcon, netfid, dentry->d_name.name, cifs_sb);
 undo_setattr:
 	if (dosattr != origattr) {
 		info_buf->Attributes = cpu_to_le32(origattr);
@@ -1162,8 +1150,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = CIFSPOSIXDelFile(xid, tcon, full_path,
-			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb);
 		cFYI(1, "posix del rc %d", rc);
 		if ((rc == 0) || (rc == -ENOENT))
 			goto psx_del_no_retry;
@@ -1286,10 +1273,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			args.uid = NO_CHANGE_64;
 			args.gid = NO_CHANGE_64;
 		}
-		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
-				       cifs_sb->local_nls,
-				       cifs_sb->mnt_cifs_flags &
-				       CIFS_MOUNT_MAP_SPECIAL_CHR);
+		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args, cifs_sb);
 	} else {
 		struct TCP_Server_Info *server = tcon->ses->server;
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
@@ -1331,8 +1315,7 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 	mode &= ~current_umask();
 	rc = CIFSPOSIXCreate(xid, tcon, SMB_O_DIRECTORY | SMB_O_CREAT, mode,
 			     NULL /* netfid */, info, &oplock, full_path,
-			     cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-			     CIFS_MOUNT_MAP_SPECIAL_CHR);
+			     cifs_sb);
 	if (rc == -EOPNOTSUPP)
 		goto posix_mkdir_out;
 	else if (rc) {
@@ -1541,14 +1524,10 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 
 	/* open the file to be renamed -- we need DELETE perms */
 	rc = CIFSSMBOpen(xid, tcon, from_path, FILE_OPEN, DELETE,
-			 CREATE_NOT_DIR, &srcfid, &oplock, NULL,
-			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 CREATE_NOT_DIR, &srcfid, &oplock, NULL, cifs_sb);
 	if (rc == 0) {
 		rc = CIFSSMBRenameOpenFile(xid, tcon, srcfid,
-				(const char *) to_dentry->d_name.name,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				(const char *) to_dentry->d_name.name, cifs_sb);
 		CIFSSMBClose(xid, tcon, srcfid);
 	}
 do_rename_exit:
@@ -1612,18 +1591,12 @@ cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 
 		info_buf_target = info_buf_source + 1;
 		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, from_name,
-					     info_buf_source,
-					     cifs_sb->local_nls,
-					     cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					     info_buf_source, cifs_sb);
 		if (tmprc != 0)
 			goto unlink_target;
 
 		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, to_name,
-					     info_buf_target,
-					     cifs_sb->local_nls,
-					     cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					     info_buf_target, cifs_sb);
 
 		if (tmprc == 0 && (info_buf_source->UniqueId ==
 				   info_buf_target->UniqueId)) {
@@ -1942,9 +1915,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 
 		rc = SMBLegacyOpen(xid, tcon, full_path, FILE_OPEN,
 				   GENERIC_WRITE, CREATE_NOT_DIR, &netfid,
-				   &oplock, NULL, cifs_sb->local_nls,
-				   cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+				   &oplock, NULL, cifs_sb);
 		if (rc == 0) {
 			unsigned int bytes_written;
 
@@ -2082,9 +2053,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		}
 		pTcon = tlink_tcon(tlink);
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args,
-				    cifs_sb->local_nls,
-				    cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				    cifs_sb);
 		cifs_put_tlink(tlink);
 	}
 
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 51dc2fb..299ee9a 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -187,16 +187,11 @@ CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	int oplock = 0;
-	int remap;
 	int create_options = CREATE_NOT_DIR;
 	__u16 netfid = 0;
 	u8 *buf;
 	unsigned int bytes_written = 0;
 	struct cifs_io_parms io_parms;
-	struct nls_table *nls_codepage;
-
-	nls_codepage = cifs_sb->local_nls;
-	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -212,8 +207,7 @@ CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
 	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
-			 create_options, &netfid, &oplock, NULL,
-			 nls_codepage, remap);
+			 create_options, &netfid, &oplock, NULL, cifs_sb);
 	if (rc != 0) {
 		kfree(buf);
 		return rc;
@@ -240,7 +234,7 @@ CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 static int
 CIFSQueryMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 		   const unsigned char *searchName, char **symlinkinfo,
-		   const struct nls_table *nls_codepage, int remap)
+		   struct cifs_sb_info *cifs_sb)
 {
 	int rc;
 	int oplock = 0;
@@ -254,8 +248,7 @@ CIFSQueryMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 	FILE_ALL_INFO file_info;
 
 	rc = CIFSSMBOpen(xid, tcon, searchName, FILE_OPEN, GENERIC_READ,
-			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
-			 nls_codepage, remap);
+			 CREATE_NOT_DIR, &netfid, &oplock, &file_info, cifs_sb);
 	if (rc != 0)
 		return rc;
 
@@ -332,10 +325,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 	pTcon = tlink_tcon(tlink);
 
 	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
-			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
-			 cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 CREATE_NOT_DIR, &netfid, &oplock, &file_info, cifs_sb);
 	if (rc != 0)
 		goto out;
 
@@ -415,9 +405,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 
 	if (tcon->unix_ext)
 		rc = CIFSUnixCreateHardLink(xid, tcon, from_name, to_name,
-					    cifs_sb->local_nls,
-					    cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					    cifs_sb);
 	else {
 		server = tcon->ses->server;
 		if (!server->ops->create_hardlink)
@@ -530,13 +518,11 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	 */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
 		rc = CIFSQueryMFSymLink(xid, tcon, full_path, &target_path,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					cifs_sb);
 
 	if ((rc != 0) && cap_unix(tcon->ses))
 		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
-					     cifs_sb->local_nls);
+					     cifs_sb);
 
 	kfree(full_path);
 out:
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index f9b5d3d..cdab041 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -203,9 +203,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 	char *tmpbuffer;
 
 	rc = CIFSSMBOpen(xid, ptcon, full_path, FILE_OPEN, GENERIC_READ,
-			OPEN_REPARSE_POINT, &fid, &oplock, NULL,
-			cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			OPEN_REPARSE_POINT, &fid, &oplock, NULL, cifs_sb);
 	if (!rc) {
 		tmpbuffer = kmalloc(maxpath);
 		rc = CIFSSMBQueryReparseLinkInfo(xid, ptcon, full_path,
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 56cc4be..1b51709 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -508,14 +508,11 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			      0 /* not legacy */, cifs_sb);
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
 		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_MAP_SPECIAL_CHR);
+				cifs_sb);
 	kfree(file_info);
 	return rc;
 }
@@ -529,18 +526,14 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* could do find first instead but this returns more info */
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+			      cifs_sb);
 	/*
 	 * BB optimize code so we do not make the above call when server claims
 	 * no NT SMB support and the above call failed at least once - set flag
 	 * in tcon or mount.
 	 */
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
-		rc = SMBQueryInformation(xid, tcon, full_path, data,
-					 cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		rc = SMBQueryInformation(xid, tcon, full_path, data, cifs_sb);
 		*adjustTZ = true;
 	}
 	return rc;
@@ -562,10 +555,7 @@ cifs_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
 	 * server or network appliances for which IndexNumber field is not
 	 * guaranteed unique?
 	 */
-	return CIFSGetSrvInodeNumber(xid, tcon, full_path, uniqueid,
-				     cifs_sb->local_nls,
-				     cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+	return CIFSGetSrvInodeNumber(xid, tcon, full_path, uniqueid, cifs_sb);
 }
 
 static int
@@ -686,9 +676,7 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 	cifsInode = CIFS_I(inode);
 	dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
 	info.Attributes = cpu_to_le32(dosattrs);
-	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info, cifs_sb);
 	if (rc == 0)
 		cifsInode->cifsAttrs = dosattrs;
 }
@@ -702,13 +690,10 @@ cifs_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	if (!(tcon->ses->capabilities & CAP_NT_SMBS))
 		return SMBLegacyOpen(xid, tcon, path, disposition,
 				     desired_access, create_options,
-				     &fid->netfid, oplock, buf,
-				     cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-						& CIFS_MOUNT_MAP_SPECIAL_CHR);
+				     &fid->netfid, oplock, buf, cifs_sb);
 	return CIFSSMBOpen(xid, tcon, path, disposition, desired_access,
 			   create_options, &fid->netfid, oplock, buf,
-			   cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+			   cifs_sb);
 }
 
 static void
@@ -790,10 +775,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	 * work.
 	 */
 	if (!(tcon->ses->flags & CIFS_SES_NT4)) {
-		rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf, cifs_sb);
 		if (rc == 0) {
 			cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
 			goto out;
@@ -805,8 +787,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 		"by this server");
 	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
 			 SYNCHRONIZE | FILE_WRITE_ATTRIBUTES, CREATE_NOT_DIR,
-			 &netfid, &oplock, NULL, cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			 &netfid, &oplock, NULL, cifs_sb);
 
 	if (rc != 0) {
 		if (rc == -EIO)
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b1c5e3..7b6a95f 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -360,10 +360,7 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 		start_of_path = from + 1;
 	else
 		start_of_path = from;
-	to = cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len,
-				   cifs_sb->local_nls,
-				   cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	to = cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len, cifs_sb);
 	return to;
 }
 
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 5142f2c..4ee1ba1 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -83,8 +83,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
-			(__u16)0, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			(__u16)0, cifs_sb);
 	}
 remove_ea_exit:
 	kfree(full_path);
@@ -150,8 +149,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			(__u16)value_size, cifs_sb);
 	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)
 		   == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
@@ -159,8 +157,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 
 		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			(__u16)value_size, cifs_sb);
 	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
 			strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
 #ifdef CONFIG_CIFS_ACL
@@ -190,9 +187,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			if (sb->s_flags & MS_POSIXACL)
 				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
 					ea_value, (const int)value_size,
-					ACL_TYPE_ACCESS, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					ACL_TYPE_ACCESS, cifs_sb);
 			cFYI(1, "set POSIX ACL rc %d", rc);
 #else
 			cFYI(1, "set POSIX ACL not supported");
@@ -203,9 +198,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			if (sb->s_flags & MS_POSIXACL)
 				rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
 					ea_value, (const int)value_size,
-					ACL_TYPE_DEFAULT, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					ACL_TYPE_DEFAULT, cifs_sb);
 			cFYI(1, "set POSIX default ACL rc %d", rc);
 #else
 			cFYI(1, "set default POSIX ACL not supported");
@@ -275,25 +268,20 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 		} /* BB add else when above is implemented */
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			buf_size, cifs_sb);
 	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
 		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
 		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			buf_size, cifs_sb);
 	} else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
 			  strlen(POSIX_ACL_XATTR_ACCESS)) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_ACCESS,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				ea_value, buf_size, ACL_TYPE_ACCESS, cifs_sb);
 #else
 		cFYI(1, "Query POSIX ACL not supported yet");
 #endif /* CONFIG_CIFS_POSIX */
@@ -302,10 +290,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
 			rc = CIFSSMBGetPosixACL(xid, pTcon, full_path,
-				ea_value, buf_size, ACL_TYPE_DEFAULT,
-				cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				ea_value, buf_size, ACL_TYPE_DEFAULT, cifs_sb);
 #else
 		cFYI(1, "Query POSIX default ACL not supported yet");
 #endif /* CONFIG_CIFS_POSIX */
@@ -403,9 +388,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 		search server for EAs or streams to
 		returns as xattrs */
 	rc = CIFSSMBQAllEAs(xid, pTcon, full_path, NULL, data,
-				buf_size, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				buf_size, cifs_sb);
 
 list_ea_exit:
 	kfree(full_path);
-- 
1.6.0.2
