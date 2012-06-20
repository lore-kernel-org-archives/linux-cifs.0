From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 15/24] CIFS: Move is_path_accessible to ops struct
Date: Wed, 20 Jun 2012 18:30:55 +0400
Message-ID: <1340202664-28696-16-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 ++
 fs/cifs/cifsproto.h |   12 ++++------
 fs/cifs/cifssmb.c   |   60 +++++++++++++++++++++++++-------------------------
 fs/cifs/connect.c   |   31 +++++---------------------
 fs/cifs/smb1ops.c   |   25 +++++++++++++++++++++
 5 files changed, 69 insertions(+), 62 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c294e67..9ce2d4c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -215,6 +215,9 @@ struct smb_version_operations {
 			     unsigned int *, const struct nls_table *, int);
 	/* informational QFS call */
 	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *);
+	/* check if a path is accessible or not */
+	int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
+				  struct cifs_sb_info *, const char *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 416d820..f0641ce 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -208,14 +208,12 @@ extern int CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			u16 netfid, FILE_ALL_INFO *pFindData);
 extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
-			const unsigned char *searchName,
-			FILE_ALL_INFO *findData,
-			int legacy /* whether to use old info level */,
-			const struct nls_table *nls_codepage, int remap);
+			    const char *search_Name, FILE_ALL_INFO *data,
+			    int legacy /* whether to use old info level */,
+			    const struct nls_table *nls_codepage, int remap);
 extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
-			const unsigned char *searchName,
-			FILE_ALL_INFO *findData,
-			const struct nls_table *nls_codepage, int remap);
+			       const char *search_name, FILE_ALL_INFO *data,
+			       const struct nls_table *nls_codepage, int remap);
 
 extern int CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			u16 netfid, FILE_UNIX_BASIC_INFO *pFindData);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index df0652a..177ea5e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3834,10 +3834,10 @@ setCifsAclRetry:
 
 /* Legacy Query Path Information call for lookup to old servers such
    as Win9x/WinME */
-int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
-			const unsigned char *searchName,
-			FILE_ALL_INFO *pFinfo,
-			const struct nls_table *nls_codepage, int remap)
+int
+SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
+		    const char *search_name, FILE_ALL_INFO *data,
+		    const struct nls_table *nls_codepage, int remap)
 {
 	QUERY_INFORMATION_REQ *pSMB;
 	QUERY_INFORMATION_RSP *pSMBr;
@@ -3845,7 +3845,7 @@ int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, "In SMBQPath path %s", searchName);
+	cFYI(1, "In SMBQPath path %s", search_name);
 QInfRetry:
 	rc = smb_init(SMB_COM_QUERY_INFORMATION, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3855,14 +3855,14 @@ QInfRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUTF16((__le16 *) pSMB->FileName,
-					   searchName, PATH_MAX, nls_codepage,
+					   search_name, PATH_MAX, nls_codepage,
 					   remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {
-		name_len = strnlen(searchName, PATH_MAX);
+		name_len = strnlen(search_name, PATH_MAX);
 		name_len++;     /* trailing null */
-		strncpy(pSMB->FileName, searchName, name_len);
+		strncpy(pSMB->FileName, search_name, name_len);
 	}
 	pSMB->BufferFormat = 0x04;
 	name_len++; /* account for buffer type byte */
@@ -3873,23 +3873,23 @@ QInfRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
 		cFYI(1, "Send error in QueryInfo = %d", rc);
-	} else if (pFinfo) {
+	} else if (data) {
 		struct timespec ts;
 		__u32 time = le32_to_cpu(pSMBr->last_write_time);
 
 		/* decode response */
 		/* BB FIXME - add time zone adjustment BB */
-		memset(pFinfo, 0, sizeof(FILE_ALL_INFO));
+		memset(data, 0, sizeof(FILE_ALL_INFO));
 		ts.tv_nsec = 0;
 		ts.tv_sec = time;
 		/* decode time fields */
-		pFinfo->ChangeTime = cpu_to_le64(cifs_UnixTimeToNT(ts));
-		pFinfo->LastWriteTime = pFinfo->ChangeTime;
-		pFinfo->LastAccessTime = 0;
-		pFinfo->AllocationSize =
+		data->ChangeTime = cpu_to_le64(cifs_UnixTimeToNT(ts));
+		data->LastWriteTime = data->ChangeTime;
+		data->LastAccessTime = 0;
+		data->AllocationSize =
 			cpu_to_le64(le32_to_cpu(pSMBr->size));
-		pFinfo->EndOfFile = pFinfo->AllocationSize;
-		pFinfo->Attributes =
+		data->EndOfFile = data->AllocationSize;
+		data->Attributes =
 			cpu_to_le32(le16_to_cpu(pSMBr->attr));
 	} else
 		rc = -EIO; /* bad buffer passed in */
@@ -3971,12 +3971,11 @@ QFileInfoRetry:
 
 int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
-		 const unsigned char *searchName,
-		 FILE_ALL_INFO *pFindData,
+		 const char *search_name, FILE_ALL_INFO *data,
 		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
-/* level 263 SMB_QUERY_FILE_ALL_INFO */
+	/* level 263 SMB_QUERY_FILE_ALL_INFO */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
 	TRANSACTION2_QPI_RSP *pSMBr = NULL;
 	int rc = 0;
@@ -3984,7 +3983,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-/* cFYI(1, "In QPathInfo path %s", searchName); */
+	/* cFYI(1, "In QPathInfo path %s", search_name); */
 QPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3993,14 +3992,14 @@ QPathInfoRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, search_name,
 				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(searchName, PATH_MAX);
+		name_len = strnlen(search_name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->FileName, searchName, name_len);
+		strncpy(pSMB->FileName, search_name, name_len);
 	}
 
 	params = 2 /* level */ + 4 /* reserved */ + name_len /* includes NUL */;
@@ -4045,20 +4044,21 @@ QPathInfoRetry:
 		else if (legacy && get_bcc(&pSMBr->hdr) < 24)
 			rc = -EIO;  /* 24 or 26 expected but we do not read
 					last field */
-		else if (pFindData) {
+		else if (data) {
 			int size;
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 
-			/* On legacy responses we do not read the last field,
-			EAsize, fortunately since it varies by subdialect and
-			also note it differs on Set vs. Get, ie two bytes or 4
-			bytes depending but we don't care here */
+			/*
+			 * On legacy responses we do not read the last field,
+			 * EAsize, fortunately since it varies by subdialect and
+			 * also note it differs on Set vs Get, ie two bytes or 4
+			 * bytes depending but we don't care here.
+			 */
 			if (legacy)
 				size = sizeof(FILE_INFO_STANDARD);
 			else
 				size = sizeof(FILE_ALL_INFO);
-			memcpy((char *) pFindData,
-			       (char *) &pSMBr->hdr.Protocol +
+			memcpy((char *) data, (char *) &pSMBr->hdr.Protocol +
 			       data_offset, size);
 		} else
 		    rc = -ENOMEM;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fe883a0..9e82950 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3386,30 +3386,6 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	return rsize;
 }
 
-static int
-is_path_accessible(unsigned int xid, struct cifs_tcon *tcon,
-		   struct cifs_sb_info *cifs_sb, const char *full_path)
-{
-	int rc;
-	FILE_ALL_INFO *pfile_info;
-
-	pfile_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (pfile_info == NULL)
-		return -ENOMEM;
-
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, pfile_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
-
-	if (rc == -EOPNOTSUPP || rc == -EINVAL)
-		rc = SMBQueryInformation(xid, tcon, full_path, pfile_info,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_MAP_SPECIAL_CHR);
-	kfree(pfile_info);
-	return rc;
-}
-
 static void
 cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
@@ -3687,13 +3663,18 @@ remote_path_check:
 
 	/* check if a whole path is not remote */
 	if (!rc && tcon) {
+		if (!server->ops->is_path_accessible) {
+			rc = -ENOSYS;
+			goto mount_fail_check;
+		}
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon);
 		if (full_path == NULL) {
 			rc = -ENOMEM;
 			goto mount_fail_check;
 		}
-		rc = is_path_accessible(xid, tcon, cifs_sb, full_path);
+		rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
+						     full_path);
 		if (rc != 0 && rc != -EREMOTE) {
 			kfree(full_path);
 			goto mount_fail_check;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 96eb06f..43f3881 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -417,6 +417,30 @@ cifs_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 	CIFSSMBQFSAttributeInfo(xid, tcon);
 }
 
+static int
+cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
+			struct cifs_sb_info *cifs_sb, const char *full_path)
+{
+	int rc;
+	FILE_ALL_INFO *file_info;
+
+	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (file_info == NULL)
+		return -ENOMEM;
+
+	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
+			      0 /* not legacy */, cifs_sb->local_nls,
+			      cifs_sb->mnt_cifs_flags &
+				CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+				  CIFS_MOUNT_MAP_SPECIAL_CHR);
+	kfree(file_info);
+	return rc;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -443,6 +467,7 @@ struct smb_version_operations smb1_operations = {
 	.tree_disconnect = CIFSSMBTDis,
 	.get_dfs_refer = CIFSGetDFSRefer,
 	.qfs_tcon = cifs_qfs_tcon,
+	.is_path_accessible = cifs_is_path_accessible,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
