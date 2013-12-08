From: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Subject: [PATCH 5/5 linux-next V2 (resend)] cifs: Combine set_file_size by handle and path into one function
Date: Sun,  8 Dec 2013 14:13:37 -0700
Message-ID: <1386537217-52184-1-git-send-email-timg@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
Cc: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Gehnert <deang-l6nL5VImRDY@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386536924-51726-1-git-send-email-timg-l6nL5VImRDY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As suggested by Jeff Layton:

--------
"Now that I look though, it's clear to me that cifs_set_file_size is
just wrong. Currently it calls ops->set_path_size and if that fails
with certain error codes it tries to do a SMBLegacyOpen, etc. That's
going to fall on its face if this is a SMB2/3 connection.

Here's what should be done instead, I think:

- get rid of both set_path_size and set_file_size operations. The
  version specific abstraction was implemented at the wrong level, IMO.

- implement a new protocol level operation that basically takes the
  same args as cifs_set_file_size. cifs_setattr_unix/_nounix should
  call this operation.

- the set_path_size operation for SMB1 should basically be the function
  that is cifs_set_file_size today (though that should probably be
  renamed). That function should be restructured to do the following:

  + look for an open filehandle
  + if there isn't one, open the file
  + call CIFSSMBSetFileSize
  + fall back to zero-length write if that fails
  + close the file if we opened it"
--------

This patch also moves all of the SMBv1 legacy hacks from cifs_set_file_size() into
the SMBv1 specific handler smb_set_file_size() more or less intact. SMBv2 and higher are
more regular and orthogonal, so the v2 handler smb2_set_file_size() no longer contains
the legacy hacks.

Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dean Gehnert <deang-l6nL5VImRDY@public.gmane.org>
Signed-off-by: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
---

V2 - this is a new patch in the V2 series.

I know this is kind of a giant patch, but there really doesn't seem to be any
intermediate steps. Its pretty much all or nothing.

I've only tested against a Linux CIFS server running a 3.2 kernel since I no longer
have easy access to smbv2 servers (iOS 10.8 or Windows 7).

resent with corrected Cc's

rtg

 fs/cifs/cifsglob.h |    9 ++---
 fs/cifs/inode.c    |  108 +++++----------------------------------------------
 fs/cifs/smb1ops.c  |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2ops.c  |   57 ++++++++++++++++++++++++---
 4 files changed, 170 insertions(+), 113 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8fd8eb2..6113ce8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -269,12 +269,9 @@ struct smb_version_operations {
 	int (*get_srv_inum)(const unsigned int, struct cifs_tcon *,
 			    struct cifs_sb_info *, const char *,
 			    u64 *uniqueid, FILE_ALL_INFO *);
-	/* set size by path */
-	int (*set_file_size_by_path)(const unsigned int, struct cifs_tcon *,
-			     const char *, __u64, struct cifs_sb_info *, bool);
-	/* set size by file handle */
-	int (*set_file_size_by_handle)(const unsigned int, struct cifs_tcon *,
-			     struct cifsFileInfo *, __u64, bool);
+	/* set file size */
+	int (*set_file_size)(struct inode *inode, struct iattr *attrs,
+			     unsigned int xid, char *full_path);
 	/* set attributes */
 	int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
 			     const unsigned int);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index e332038..3edeafd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1899,118 +1899,28 @@ static void cifs_setsize(struct inode *inode, loff_t offset)
 	truncate_pagecache(inode, offset);
 }
 
-/*
- * Legacy hack to set file length.
- */
-static int
-cifs_legacy_set_file_size(unsigned int xid, __u16 netfid, __u32 pid,
-			  unsigned int length, struct cifs_tcon *tcon,
-			  char *full_path)
-{
-	int rc;
-	unsigned int bytes_written;
-	struct cifs_io_parms io_parms;
-
-	io_parms.netfid = netfid;
-	io_parms.pid = pid;
-	io_parms.tcon = tcon;
-	io_parms.offset = 0;
-	io_parms.length = length;
-	rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
-			  NULL, NULL, 1);
-	cifs_dbg(FYI, "%s len %d rc %d on %s\n", __func__, length, rc,
-		 full_path);
-	return rc;
-}
-
 static int
 cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		   unsigned int xid, char *full_path)
 {
-	int rc;
-	struct cifsFileInfo *open_file;
+	int rc = -ENOSYS;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
 
-	/*
-	 * To avoid spurious oplock breaks from server, in the case of
-	 * inodes that we already have open, avoid doing path based
-	 * setting of file size if we can do it by handle.
-	 * This keeps our caching token (oplock) and avoids timeouts
-	 * when the local oplock break takes longer to flush
-	 * writebehind data than the SMB timeout for the SetPathInfo
-	 * request would allow
-	 */
-	open_file = find_writable_file(cifsInode, true);
-	if (open_file) {
-		tcon = tlink_tcon(open_file->tlink);
-		server = tcon->ses->server;
-		if (server->ops->set_file_size_by_handle)
-			rc = server->ops->set_file_size_by_handle(xid, tcon,
-								  open_file,
-								  attrs->ia_size,
-								  false);
-		else
-			rc = -ENOSYS;
-		cifsFileInfo_put(open_file);
-		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
-		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
-			rc = cifs_legacy_set_file_size(xid,
-						       open_file->fid.netfid,
-						       open_file->pid,
-						       attrs->ia_size,
-						       tcon, full_path);
-		}
-	} else
-		rc = -EINVAL;
-
-	if (!rc)
-		goto set_size_out;
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
-	if (tcon == NULL) {
-		tlink = cifs_sb_tlink(cifs_sb);
-		if (IS_ERR(tlink))
-			return PTR_ERR(tlink);
-		tcon = tlink_tcon(tlink);
-		server = tcon->ses->server;
-	}
+	if (server->ops->set_file_size)
+		rc = server->ops->set_file_size(inode, attrs, xid, full_path);
 
-	/*
-	 * Set file size by pathname rather than by handle either because no
-	 * valid, writeable file handle for it was found or because there was
-	 * an error setting it by handle.
-	 */
-	if (server->ops->set_file_size_by_path)
-		rc = server->ops->set_file_size_by_path(xid, tcon, full_path,
-							attrs->ia_size, cifs_sb,
-							false);
-	else
-		rc = -ENOSYS;
-	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
-	if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
-		__u16 netfid;
-		int oplock = 0;
-
-		rc = SMBLegacyOpen(xid, tcon, full_path, FILE_OPEN,
-				   GENERIC_WRITE, CREATE_NOT_DIR, &netfid,
-				   &oplock, NULL, cifs_sb->local_nls,
-				   cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-		if (rc == 0) {
-			rc = cifs_legacy_set_file_size(xid, netfid,
-						       current->tgid,
-						       attrs->ia_size, tcon,
-						       full_path);
-			CIFSSMBClose(xid, tcon, netfid);
-		}
-	}
-	if (!open_file)
-		cifs_put_tlink(tlink);
+	cifs_put_tlink(tlink);
 
-set_size_out:
 	if (rc == 0) {
 		cifsInode->server_eof = attrs->ia_size;
 		cifs_setsize(inode, attrs->ia_size);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index c5d9ec6..63ab3aa 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -755,6 +755,30 @@ cifs_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
 	return CIFSSMBWrite2(xid, parms, written, iov, nr_segs);
 }
 
+/*
+ * Legacy hack to set file length.
+ */
+static int
+cifs_legacy_set_file_size(unsigned int xid, __u16 netfid, __u32 pid,
+			  unsigned int length, struct cifs_tcon *tcon,
+			  char *full_path)
+{
+	int rc;
+	unsigned int bytes_written;
+	struct cifs_io_parms io_parms;
+
+	io_parms.netfid = netfid;
+	io_parms.pid = pid;
+	io_parms.tcon = tcon;
+	io_parms.offset = 0;
+	io_parms.length = length;
+	rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
+			  NULL, NULL, 1);
+	cifs_dbg(FYI, "%s len %d rc %d on %s\n", __func__, length, rc,
+		 full_path);
+	return rc;
+}
+
 static int
 smb_set_file_size_by_path(const unsigned int xid, struct cifs_tcon *tcon,
 	      const char *full_path, __u64 size, struct cifs_sb_info *cifs_sb,
@@ -790,6 +814,88 @@ smb_set_file_size_by_path(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
+smb_set_file_size(struct inode *inode, struct iattr *attrs, unsigned int xid,
+		  char *full_path)
+{
+	int rc;
+	struct cifsFileInfo *open_file;
+	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink = NULL;
+	struct cifs_tcon *tcon = NULL;
+	struct TCP_Server_Info *server;
+
+	/*
+	 * To avoid spurious oplock breaks from server, in the case of
+	 * inodes that we already have open, avoid doing path based
+	 * setting of file size if we can do it by handle.
+	 * This keeps our caching token (oplock) and avoids timeouts
+	 * when the local oplock break takes longer to flush
+	 * writebehind data than the SMB timeout for the SetPathInfo
+	 * request would allow
+	 */
+	open_file = find_writable_file(cifsInode, true);
+	if (open_file) {
+		tcon = tlink_tcon(open_file->tlink);
+		server = tcon->ses->server;
+		rc = CIFSSMBSetFileSize(xid, tcon, open_file, attrs->ia_size,
+					false);
+		cifsFileInfo_put(open_file);
+		cifs_dbg(FYI, "%s by handle rc = %d for %s\n", __func__, rc,
+			 full_path);
+		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP))
+			rc = cifs_legacy_set_file_size(xid,
+						       open_file->fid.netfid,
+						       open_file->pid,
+						       attrs->ia_size,
+						       tcon, full_path);
+	} else
+		rc = -EINVAL;
+
+	if (!rc)
+		goto set_size_out;
+
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
+	rc = smb_set_file_size_by_path(xid, tcon, full_path, attrs->ia_size,
+				       cifs_sb, false);
+	cifs_dbg(FYI, "%s by path rc = %d for %s\n", __func__, rc, full_path);
+	if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
+		__u16 netfid;
+		int oplock = 0;
+
+		rc = SMBLegacyOpen(xid, tcon, full_path, FILE_OPEN,
+				   GENERIC_WRITE, CREATE_NOT_DIR, &netfid,
+				   &oplock, NULL, cifs_sb->local_nls,
+				   cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (rc == 0) {
+			rc = cifs_legacy_set_file_size(xid, netfid,
+						       current->tgid,
+						       attrs->ia_size, tcon,
+						       full_path);
+			CIFSSMBClose(xid, tcon, netfid);
+		}
+	}
+	if (!open_file)
+		cifs_put_tlink(tlink);
+
+set_size_out:
+	return rc;
+}
+
+static int
 smb_set_file_info(struct inode *inode, const char *full_path,
 		  FILE_BASIC_INFO *buf, const unsigned int xid)
 {
@@ -1013,8 +1119,7 @@ struct smb_version_operations smb1_operations = {
 	.query_path_info = cifs_query_path_info,
 	.query_file_info = cifs_query_file_info,
 	.get_srv_inum = cifs_get_srv_inum,
-	.set_file_size_by_path = smb_set_file_size_by_path,
-	.set_file_size_by_handle = CIFSSMBSetFileSize,
+	.set_file_size = smb_set_file_size,
 	.set_file_info = smb_set_file_info,
 	.set_compression = cifs_set_compression,
 	.echo = CIFSSMBEcho,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index dc7b1cb..206b45f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -697,6 +697,54 @@ smb2_set_file_size_by_handle(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
+smb2_set_file_size(struct inode *inode, struct iattr *attrs, unsigned int xid,
+		   char *full_path)
+{
+	int rc;
+	struct cifsFileInfo *open_file;
+	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+
+	/*
+	 * To avoid spurious oplock breaks from server, in the case of
+	 * inodes that we already have open, avoid doing path based
+	 * setting of file size if we can do it by handle.
+	 * This keeps our caching token (oplock) and avoids timeouts
+	 * when the local oplock break takes longer to flush
+	 * writebehind data than the SMB timeout for the SetPathInfo
+	 * request would allow
+	 */
+	open_file = find_writable_file(cifsInode, true);
+	if (open_file) {
+		tcon = tlink_tcon(open_file->tlink);
+		server = tcon->ses->server;
+		rc = smb2_set_file_size_by_handle(xid, tcon, open_file,
+						  attrs->ia_size, false);
+		cifsFileInfo_put(open_file);
+		cifs_dbg(FYI, "%s by handle rc = %d on %s\n", __func__, rc,
+			 full_path);
+		return rc;
+	}
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	rc = smb2_set_file_size_by_path(xid, tcon, full_path, attrs->ia_size,
+					cifs_sb, false);
+	cifs_dbg(FYI, "%s by path rc = %d on %s\n", __func__, rc, full_path);
+
+	cifs_put_tlink(tlink);
+
+	return rc;
+}
+
+static int
 smb2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile)
 {
@@ -1131,8 +1179,7 @@ struct smb_version_operations smb20_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
-	.set_file_size_by_path = smb2_set_file_size_by_path,
-	.set_file_size_by_handle = smb2_set_file_size_by_handle,
+	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
@@ -1205,8 +1252,7 @@ struct smb_version_operations smb21_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
-	.set_file_size_by_path = smb2_set_file_size_by_path,
-	.set_file_size_by_handle = smb2_set_file_size_by_handle,
+	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
@@ -1280,8 +1326,7 @@ struct smb_version_operations smb30_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
-	.set_file_size_by_path = smb2_set_file_size_by_path,
-	.set_file_size_by_handle = smb2_set_file_size_by_handle,
+	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
-- 
1.7.9.5
