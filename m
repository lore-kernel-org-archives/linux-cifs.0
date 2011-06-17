From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] cifs: Call id to SID mapping functions to change owner/group
Date: Fri, 17 Jun 2011 18:37:15 -0500
Message-ID: <1308353835-8776-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Now build security descriptor to change either owner or group at the
server.  Initially security descriptor was built to change only
ACL, that functionality has been extended.

When either an Owner or Group of a file object at the server is changed,
rest of security descriptor remains same (DACL etc.).

To set security descriptor, it is essential to open that file
with WRITE_DAC as well as WRITE_OWNER (Take Ownership) permission bits.
Function set_cifs_acl_by_fid() has been removed since we can't be
sure how a file was opened for writing, a valid request can fail
if the file was not opened with two above mentioned permissions.
 
It is the server that decides whether a set security descriptor with
either owner or group change succeeds or not.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c   |  148 ++++++++++++++++++++++++++++-----------------------
 fs/cifs/cifsproto.h |    7 ++-
 fs/cifs/cifssmb.c   |    4 +-
 fs/cifs/inode.c     |   35 ++++++++----
 fs/cifs/xattr.c     |    2 +-
 5 files changed, 111 insertions(+), 85 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 6f72ea6..fcde17d 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -904,7 +904,7 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 	acl_size = sizeof(struct cifs_acl);
 
 	num_aces = le32_to_cpu(pdacl->num_aces);
-	if (num_aces  > 0) {
+	if (num_aces > 0) {
 		umode_t user_mask = S_IRWXU;
 		umode_t group_mask = S_IRWXG;
 		umode_t other_mask = S_IRWXU | S_IRWXG | S_IRWXO;
@@ -1066,52 +1066,82 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 	else
 		cFYI(1, "no ACL"); /* BB grant all or default perms? */
 
-/*	cifscred->uid = owner_sid_ptr->rid;
-	cifscred->gid = group_sid_ptr->rid;
-	memcpy((void *)(&(cifscred->osid)), (void *)owner_sid_ptr,
-			sizeof(struct cifs_sid));
-	memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_ptr,
-			sizeof(struct cifs_sid)); */
-
 	return rc;
 }
 
-
 /* Convert permission bits from mode to equivalent CIFS ACL */
 static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
-				struct inode *inode, __u64 nmode)
+	__u32 secdesclen, __u64 nmode, uid_t uid, gid_t gid, int *aclflag)
 {
 	int rc = 0;
 	__u32 dacloffset;
 	__u32 ndacloffset;
 	__u32 sidsoffset;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
+	struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
 	struct cifs_acl *dacl_ptr = NULL;  /* no need for SACL ptr */
 	struct cifs_acl *ndacl_ptr = NULL; /* no need for SACL ptr */
 
-	if ((inode == NULL) || (pntsd == NULL) || (pnntsd == NULL))
-		return -EIO;
-
-	owner_sid_ptr = (struct cifs_sid *)((char *)pntsd +
+	if (nmode != NO_CHANGE_64) { /* chmod */
+		owner_sid_ptr = (struct cifs_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->osidoffset));
-	group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
+		group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->gsidoffset));
-
-	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
-
-	ndacloffset = sizeof(struct cifs_ntsd);
-	ndacl_ptr = (struct cifs_acl *)((char *)pnntsd + ndacloffset);
-	ndacl_ptr->revision = dacl_ptr->revision;
-	ndacl_ptr->size = 0;
-	ndacl_ptr->num_aces = 0;
-
-	rc = set_chmod_dacl(ndacl_ptr, owner_sid_ptr, group_sid_ptr, nmode);
-
-	sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
-
-	/* copy security descriptor control portion and owner and group sid */
-	copy_sec_desc(pntsd, pnntsd, sidsoffset);
+		dacloffset = le32_to_cpu(pntsd->dacloffset);
+		dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
+		ndacloffset = sizeof(struct cifs_ntsd);
+		ndacl_ptr = (struct cifs_acl *)((char *)pnntsd + ndacloffset);
+		ndacl_ptr->revision = dacl_ptr->revision;
+		ndacl_ptr->size = 0;
+		ndacl_ptr->num_aces = 0;
+
+		rc = set_chmod_dacl(ndacl_ptr, owner_sid_ptr, group_sid_ptr,
+					nmode);
+		sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
+		/* copy sec desc control portion & owner and group sids */
+		copy_sec_desc(pntsd, pnntsd, sidsoffset);
+		*aclflag = CIFS_ACL_DACL;
+	} else {
+		memcpy(pnntsd, pntsd, secdesclen);
+		if (uid != NO_CHANGE_32) { /* chown */
+			owner_sid_ptr = (struct cifs_sid *)((char *)pnntsd +
+					le32_to_cpu(pnntsd->osidoffset));
+			nowner_sid_ptr = kmalloc(sizeof(struct cifs_sid),
+								GFP_KERNEL);
+			if (!nowner_sid_ptr)
+				return -ENOMEM;
+			rc = id_to_sid(uid, SIDOWNER, nowner_sid_ptr);
+			if (rc) {
+				cFYI(1, "%s: Mapping error %d for owner id %d",
+						__func__, rc, uid);
+				kfree(nowner_sid_ptr);
+				return rc;
+			}
+			memcpy(owner_sid_ptr, nowner_sid_ptr,
+					sizeof(struct cifs_sid));
+			kfree(nowner_sid_ptr);
+			*aclflag = CIFS_ACL_OWNER;
+		}
+		if (gid != NO_CHANGE_32) { /* chgrp */
+			group_sid_ptr = (struct cifs_sid *)((char *)pnntsd +
+					le32_to_cpu(pnntsd->gsidoffset));
+			ngroup_sid_ptr = kmalloc(sizeof(struct cifs_sid),
+								GFP_KERNEL);
+			if (!ngroup_sid_ptr)
+				return -ENOMEM;
+			rc = id_to_sid(gid, SIDGROUP, ngroup_sid_ptr);
+			if (rc) {
+				cFYI(1, "%s: Mapping error %d for group id %d",
+						__func__, rc, gid);
+				kfree(ngroup_sid_ptr);
+				return rc;
+			}
+			memcpy(group_sid_ptr, ngroup_sid_ptr,
+					sizeof(struct cifs_sid));
+			kfree(ngroup_sid_ptr);
+			*aclflag = CIFS_ACL_GROUP;
+		}
+	}
 
 	return rc;
 }
@@ -1189,26 +1219,8 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 	return pntsd;
 }
 
-static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 fid,
-		struct cifs_ntsd *pnntsd, u32 acllen)
-{
-	int xid, rc;
-	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
-
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-
-	xid = GetXid();
-	rc = CIFSSMBSetCIFSACL(xid, tlink_tcon(tlink), fid, pnntsd, acllen);
-	FreeXid(xid);
-	cifs_put_tlink(tlink);
-
-	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
-	return rc;
-}
-
 static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
-		struct cifs_ntsd *pnntsd, u32 acllen)
+		struct cifs_ntsd *pnntsd, u32 acllen, int aclflag)
 {
 	int oplock = 0;
 	int xid, rc;
@@ -1222,7 +1234,7 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 	tcon = tlink_tcon(tlink);
 	xid = GetXid();
 
-	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_DAC, 0,
+	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_DAC | WRITE_OWNER, 0,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
@@ -1230,7 +1242,7 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 		goto out;
 	}
 
-	rc = CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, acllen);
+	rc = CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, acllen, aclflag);
 	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
 
 	CIFSSMBClose(xid, tcon, fid);
@@ -1242,21 +1254,18 @@ out:
 
 /* Set an ACL on the server */
 int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
-				struct inode *inode, const char *path)
+			struct inode *inode, const char *path, int aclflag)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsFileInfo *open_file;
-	int rc;
-
-	cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode->i_mode);
-
-	open_file = find_readable_file(CIFS_I(inode), true);
-	if (!open_file)
-		return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen);
 
-	rc = set_cifs_acl_by_fid(cifs_sb, open_file->netfid, pnntsd, acllen);
-	cifsFileInfo_put(open_file);
-	return rc;
+	cFYI(DBG2, "%s: set ACL for %s", __func__, path);
+	/*
+	 * Always open file by path. We do not know how a file was
+	 * opened if we search and find a writable find handle.
+	 * WRITRE_DAC and WRITE_OWNER permissions are essential for
+	 * changing ownership of a file at the server.
+	 */
+	return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen, aclflag);
 }
 
 /* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mode bits */
@@ -1290,9 +1299,12 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 }
 
 /* Convert mode bits to an ACL so we can update the ACL on the server */
-int mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode)
+int
+id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
+			uid_t uid, gid_t gid)
 {
 	int rc = 0;
+	int aclflag = CIFS_ACL_DACL; /* default flag to set */
 	__u32 secdesclen = 0;
 	struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
 	struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
@@ -1322,13 +1334,15 @@ int mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode)
 			return -ENOMEM;
 		}
 
-		rc = build_sec_desc(pntsd, pnntsd, inode, nmode);
+		rc = build_sec_desc(pntsd, pnntsd, secdesclen, nmode, uid, gid,
+					&aclflag);
 
 		cFYI(DBG2, "build_sec_desc rc: %d", rc);
 
 		if (!rc) {
 			/* Set the security descriptor */
-			rc = set_cifs_acl(pnntsd, secdesclen, inode, path);
+			rc = set_cifs_acl(pnntsd, secdesclen, inode,
+						path, aclflag);
 			cFYI(DBG2, "set_cifs_acl rc: %d", rc);
 		}
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 953f844..3c0e026 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -145,11 +145,12 @@ extern int cifs_get_inode_info_unix(struct inode **pinode,
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
-extern int mode_to_cifs_acl(struct inode *inode, const char *path, __u64);
+extern int id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64,
+					uid_t, gid_t);
 extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 					const char *, u32 *);
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
-				const char *);
+				const char *, int);
 
 extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
@@ -419,7 +420,7 @@ extern int CIFSSMBSetEA(const int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tcon,
 			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
 extern int CIFSSMBSetCIFSACL(const int, struct cifs_tcon *, __u16,
-			struct cifs_ntsd *, __u32);
+			struct cifs_ntsd *, __u32, int);
 extern int CIFSSMBGetPosixACL(const int xid, struct cifs_tcon *tcon,
 		const unsigned char *searchName,
 		char *acl_inf, const int buflen, const int acl_type,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 1a9fe7f..f393bf1 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3467,7 +3467,7 @@ qsec_out:
 
 int
 CIFSSMBSetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fid,
-			struct cifs_ntsd *pntsd, __u32 acllen)
+			struct cifs_ntsd *pntsd, __u32 acllen, int aclflag)
 {
 	__u16 byte_count, param_count, data_count, param_offset, data_offset;
 	int rc = 0;
@@ -3504,7 +3504,7 @@ setCifsAclRetry:
 
 	pSMB->Fid = fid; /* file handle always le */
 	pSMB->Reserved2 = 0;
-	pSMB->AclFlags = cpu_to_le32(CIFS_ACL_DACL);
+	pSMB->AclFlags = cpu_to_le32(aclflag);
 
 	if (pntsd && acllen) {
 		memcpy((char *) &pSMBr->hdr.Protocol + data_offset,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9b018c8..7251f88 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2106,6 +2106,8 @@ static int
 cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 {
 	int xid;
+	uid_t uid = NO_CHANGE_32;
+	gid_t gid = NO_CHANGE_32;
 	struct inode *inode = direntry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
@@ -2156,13 +2158,25 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			goto cifs_setattr_exit;
 	}
 
-	/*
-	 * Without unix extensions we can't send ownership changes to the
-	 * server, so silently ignore them. This is consistent with how
-	 * local DOS/Windows filesystems behave (VFAT, NTFS, etc). With
-	 * CIFSACL support + proper Windows to Unix idmapping, we may be
-	 * able to support this in the future.
-	 */
+	if (attrs->ia_valid & ATTR_UID)
+		uid = attrs->ia_uid;
+
+	if (attrs->ia_valid & ATTR_GID)
+		gid = attrs->ia_gid;
+
+#ifdef CONFIG_CIFS_ACL
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+		if (uid != NO_CHANGE_32 || gid != NO_CHANGE_32) {
+			rc = id_mode_to_cifs_acl(inode, full_path, NO_CHANGE_64,
+							uid, gid);
+			if (rc) {
+				cFYI(1, "%s: Setting id failed with error: %d",
+					__func__, rc);
+				goto cifs_setattr_exit;
+			}
+		}
+	} else
+#endif /* CONFIG_CIFS_ACL */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
 
@@ -2171,15 +2185,12 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 		attrs->ia_valid &= ~ATTR_MODE;
 
 	if (attrs->ia_valid & ATTR_MODE) {
-		cFYI(1, "Mode changed to 0%o", attrs->ia_mode);
 		mode = attrs->ia_mode;
-	}
-
-	if (attrs->ia_valid & ATTR_MODE) {
 		rc = 0;
 #ifdef CONFIG_CIFS_ACL
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-			rc = mode_to_cifs_acl(inode, full_path, mode);
+			rc = id_mode_to_cifs_acl(inode, full_path, mode,
+						NO_CHANGE_32, NO_CHANGE_32);
 			if (rc) {
 				cFYI(1, "%s: Setting ACL failed with error: %d",
 					__func__, rc);
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 2a22fb2..fde15b1 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -178,7 +178,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 #ifdef CONFIG_CIFS_ACL
 			memcpy(pacl, ea_value, value_size);
 			rc = set_cifs_acl(pacl, value_size,
-				direntry->d_inode, full_path);
+				direntry->d_inode, full_path, CIFS_ACL_DACL);
 			if (rc == 0) /* force revalidate of the inode */
 				CIFS_I(direntry->d_inode)->time = 0;
 			kfree(pacl);
-- 
1.6.0.2
