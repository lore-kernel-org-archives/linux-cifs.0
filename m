From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Percolate errors up to the caller during get/set acls
Date: Mon,  8 Nov 2010 09:47:18 -0600
Message-ID: <1289231238-15203-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Modify get/set_cifs_acl* calls to reutrn error code and percolate the
error code up to the caller.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c |   84 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c9b4792..8c260b9 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -552,38 +552,40 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	return rc;
 }
 
-static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
-		__u16 fid, u32 *pacllen)
+static int
+get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
+		__u16 fid, u32 *pacllen, struct cifs_ntsd **pntsd)
 {
-	struct cifs_ntsd *pntsd = NULL;
-	int xid, rc;
+	int xid;
+	int rc = 0;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 
 	if (IS_ERR(tlink))
-		return NULL;
+		PTR_ERR(tlink);
 
 	xid = GetXid();
-	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &pntsd, pacllen);
+	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, pntsd, pacllen);
 	FreeXid(xid);
 
 	cifs_put_tlink(tlink);
 
 	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
-	return pntsd;
+	return rc;
 }
 
-static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
-		const char *path, u32 *pacllen)
+static int
+get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
+			u32 *pacllen, struct cifs_ntsd **pntsd)
 {
-	struct cifs_ntsd *pntsd = NULL;
 	int oplock = 0;
-	int xid, rc;
+	int xid;
+	int rc = 0;
 	__u16 fid;
 	struct cifsTconInfo *tcon;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 
 	if (IS_ERR(tlink))
-		return NULL;
+		return PTR_ERR(tlink);
 
 	tcon = tlink_tcon(tlink);
 	xid = GetXid();
@@ -596,32 +598,34 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 		goto out;
 	}
 
-	rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
+	rc = CIFSSMBGetCIFSACL(xid, tcon, fid, pntsd, pacllen);
 	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
 
 	CIFSSMBClose(xid, tcon, fid);
  out:
 	cifs_put_tlink(tlink);
 	FreeXid(xid);
-	return pntsd;
+	return rc;
 }
 
 /* Retrieve an ACL from the server */
-static struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
-				      struct inode *inode, const char *path,
-				      u32 *pacllen)
+static int
+get_cifs_acl(struct cifs_sb_info *cifs_sb, struct inode *inode,
+		const char *path, u32 *pacllen, struct cifs_ntsd **pntsd)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	int rc = 0;
 	struct cifsFileInfo *open_file = NULL;
 
 	if (inode)
 		open_file = find_readable_file(CIFS_I(inode), true);
-	if (!open_file)
-		return get_cifs_acl_by_path(cifs_sb, path, pacllen);
+	if (open_file) {
+		rc = get_cifs_acl_by_fid(cifs_sb, open_file->netfid, pacllen,
+						pntsd);
+		cifsFileInfo_put(open_file);
+	} else
+		rc = get_cifs_acl_by_path(cifs_sb, path, pacllen, pntsd);
 
-	pntsd = get_cifs_acl_by_fid(cifs_sb, open_file->netfid, pacllen);
-	cifsFileInfo_put(open_file);
-	return pntsd;
+	return rc;
 }
 
 static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 fid,
@@ -686,11 +690,13 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode->i_mode);
 
 	open_file = find_readable_file(CIFS_I(inode), true);
-	if (!open_file)
-		return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen);
+	if (open_file) {
+		rc = set_cifs_acl_by_fid(cifs_sb, open_file->netfid, pnntsd,
+						acllen);
+		cifsFileInfo_put(open_file);
+	} else
+		rc = set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen);
 
-	rc = set_cifs_acl_by_fid(cifs_sb, open_file->netfid, pnntsd, acllen);
-	cifsFileInfo_put(open_file);
 	return rc;
 }
 
@@ -706,15 +712,18 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	cFYI(DBG2, "converting ACL to mode for %s", path);
 
 	if (pfid)
-		pntsd = get_cifs_acl_by_fid(cifs_sb, *pfid, &acllen);
+		rc = get_cifs_acl_by_fid(cifs_sb, *pfid, &acllen, &pntsd);
 	else
-		pntsd = get_cifs_acl(cifs_sb, inode, path, &acllen);
+		rc = get_cifs_acl(cifs_sb, inode, path, &acllen, &pntsd);
 
 	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
-	if (pntsd)
-		rc = parse_sec_desc(pntsd, acllen, fattr);
 	if (rc)
-		cFYI(1, "parse sec desc failed rc = %d", rc);
+		cFYI(1, "%s: get acl failed rc: %d", __func__, rc);
+	else {
+		rc = parse_sec_desc(pntsd, acllen, fattr);
+		if (rc)
+			cFYI(1, "%s: parse sec desc fail rc: %d", __func__, rc);
+	}
 
 	kfree(pntsd);
 	return;
@@ -731,12 +740,15 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
 	cFYI(DBG2, "set ACL from mode for %s", path);
 
 	/* Get the security descriptor */
-	pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
+	rc = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen,
+				&pntsd);
 
 	/* Add three ACEs for owner, group, everyone getting rid of
 	   other ACEs as chmod disables ACEs and set the security descriptor */
 
-	if (pntsd) {
+	if (rc)
+		cFYI(DBG2, "%s: get cifs acl failed rc: %d", __func__, rc);
+	else {
 		/* allocate memory for the smb header,
 		   set security descriptor request security descriptor
 		   parameters, and secuirty descriptor itself */
@@ -760,10 +772,10 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
 			cFYI(DBG2, "set_cifs_acl rc: %d", rc);
 		}
 
-		kfree(pnntsd);
-		kfree(pntsd);
 	}
 
+	kfree(pnntsd);
+	kfree(pntsd);
 	return rc;
 }
 #endif /* CONFIG_CIFS_EXPERIMENTAL */
-- 
1.6.0.2
