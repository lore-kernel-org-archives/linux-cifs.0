From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/3] cifs: Do not set cifs/ntfs acl using a file handle (try #4)
Date: Tue,  9 Aug 2011 14:30:39 -0500
Message-ID: <1312918239-23711-1-git-send-email-shirishpargonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Set security descriptor using path name instead of a file handle.
We can't be sure that the file handle has adequate permission to
set a security descriptor (to modify DACL).

Function set_cifs_acl_by_fid() has been removed since we can't be
sure how a file was opened for writing, a valid request can fail
if the file was not opened with two above mentioned permissions.
We could have opted to add on WRITE_DAC and WRITE_OWNER permissions
to file opens and then use that file handle but adding addtional
permissions such as WRITE_DAC and WRITE_OWNER could cause an
any open to fail.

And it was incorrect to look for read file handle to set a
security descriptor anyway.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 21de1d6..d0f59fa 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -991,24 +991,6 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
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
 		struct cifs_ntsd *pnntsd, u32 acllen)
 {
@@ -1047,18 +1029,10 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 				struct inode *inode, const char *path)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsFileInfo *open_file;
-	int rc;
 
 	cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode->i_mode);
 
-	open_file = find_readable_file(CIFS_I(inode), true);
-	if (!open_file)
-		return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen);
-
-	rc = set_cifs_acl_by_fid(cifs_sb, open_file->netfid, pnntsd, acllen);
-	cifsFileInfo_put(open_file);
-	return rc;
+	return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen);
 }
 
 /* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mode bits */
-- 
1.6.0.2
