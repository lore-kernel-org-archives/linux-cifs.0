From: Tim Gardner <timg@tpi.com>
Subject: [PATCH 2/5 linux-next V2] cifs: rename set_path_size and set_file_size
Date: Sun,  8 Dec 2013 14:08:41 -0700
Message-ID: <1386536924-51726-2-git-send-email-timg@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
Cc: Steve French <sfrench@samba.org>, Tim Gardner <timg@tpi.com>, Dean Gehnert <deang@tpi.com>, Jeff Layton <jlayton@redhat.com>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1386536924-51726-1-git-send-email-timg@tpi.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

These 2 method names are a bit confusing. Rename them
so that one can tell at a glance how they are to be used.

Cc: Steve French <sfrench@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Dean Gehnert <deang@tpi.com>
Signed-off-by: Tim Gardner <timg@tpi.com>
---

V2 - this is a new patch in the V2 series.

 fs/cifs/cifsglob.h  |    4 ++--
 fs/cifs/inode.c     |   15 +++++++++------
 fs/cifs/smb1ops.c   |    6 +++---
 fs/cifs/smb2inode.c |    2 +-
 fs/cifs/smb2ops.c   |   14 +++++++-------
 fs/cifs/smb2proto.h |    8 +++++---
 6 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f918a99..8fd8eb2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -270,10 +270,10 @@ struct smb_version_operations {
 			    struct cifs_sb_info *, const char *,
 			    u64 *uniqueid, FILE_ALL_INFO *);
 	/* set size by path */
-	int (*set_path_size)(const unsigned int, struct cifs_tcon *,
+	int (*set_file_size_by_path)(const unsigned int, struct cifs_tcon *,
 			     const char *, __u64, struct cifs_sb_info *, bool);
 	/* set size by file handle */
-	int (*set_file_size)(const unsigned int, struct cifs_tcon *,
+	int (*set_file_size_by_handle)(const unsigned int, struct cifs_tcon *,
 			     struct cifsFileInfo *, __u64, bool);
 	/* set attributes */
 	int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 36f9ebb..7181516 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1925,9 +1925,11 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	if (open_file) {
 		tcon = tlink_tcon(open_file->tlink);
 		server = tcon->ses->server;
-		if (server->ops->set_file_size)
-			rc = server->ops->set_file_size(xid, tcon, open_file,
-							attrs->ia_size, false);
+		if (server->ops->set_file_size_by_handle)
+			rc = server->ops->set_file_size_by_handle(xid, tcon,
+								  open_file,
+								  attrs->ia_size,
+								  false);
 		else
 			rc = -ENOSYS;
 		cifsFileInfo_put(open_file);
@@ -1963,9 +1965,10 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 * valid, writeable file handle for it was found or because there was
 	 * an error setting it by handle.
 	 */
-	if (server->ops->set_path_size)
-		rc = server->ops->set_path_size(xid, tcon, full_path,
-						attrs->ia_size, cifs_sb, false);
+	if (server->ops->set_file_size_by_path)
+		rc = server->ops->set_file_size_by_path(xid, tcon, full_path,
+							attrs->ia_size, cifs_sb,
+							false);
 	else
 		rc = -ENOSYS;
 	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 14d4832..c5d9ec6 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -756,7 +756,7 @@ cifs_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
 }
 
 static int
-smb_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
+smb_set_file_size_by_path(const unsigned int xid, struct cifs_tcon *tcon,
 	      const char *full_path, __u64 size, struct cifs_sb_info *cifs_sb,
 	      bool set_allocation)
 {
@@ -1013,8 +1013,8 @@ struct smb_version_operations smb1_operations = {
 	.query_path_info = cifs_query_path_info,
 	.query_file_info = cifs_query_file_info,
 	.get_srv_inum = cifs_get_srv_inum,
-	.set_path_size = smb_set_file_size,
-	.set_file_size = CIFSSMBSetFileSize,
+	.set_file_size_by_path = smb_set_file_size_by_path,
+	.set_file_size_by_handle = CIFSSMBSetFileSize,
 	.set_file_info = smb_set_file_info,
 	.set_compression = cifs_set_compression,
 	.echo = CIFSSMBEcho,
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 84c012a..78b590f 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -244,7 +244,7 @@ smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
-smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
+smb2_set_file_size_by_path(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *full_path, __u64 size,
 		   struct cifs_sb_info *cifs_sb, bool set_alloc)
 {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 757da3e..dc7b1cb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -688,7 +688,7 @@ smb2_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
 }
 
 static int
-smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
+smb2_set_file_size_by_handle(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile, __u64 size, bool set_alloc)
 {
 	__le64 eof = cpu_to_le64(size);
@@ -1131,8 +1131,8 @@ struct smb_version_operations smb20_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
-	.set_path_size = smb2_set_path_size,
-	.set_file_size = smb2_set_file_size,
+	.set_file_size_by_path = smb2_set_file_size_by_path,
+	.set_file_size_by_handle = smb2_set_file_size_by_handle,
 	.set_file_info = smb2_set_file_info,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
@@ -1205,8 +1205,8 @@ struct smb_version_operations smb21_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
-	.set_path_size = smb2_set_path_size,
-	.set_file_size = smb2_set_file_size,
+	.set_file_size_by_path = smb2_set_file_size_by_path,
+	.set_file_size_by_handle = smb2_set_file_size_by_handle,
 	.set_file_info = smb2_set_file_info,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
@@ -1280,8 +1280,8 @@ struct smb_version_operations smb30_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.query_file_info = smb2_query_file_info,
-	.set_path_size = smb2_set_path_size,
-	.set_file_size = smb2_set_file_size,
+	.set_file_size_by_path = smb2_set_file_size_by_path,
+	.set_file_size_by_handle = smb2_set_file_size_by_handle,
 	.set_file_info = smb2_set_file_info,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 93adc64..b6f3c13 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -62,9 +62,11 @@ extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
 				const char *full_path, FILE_ALL_INFO *data,
 				bool *adjust_tz, bool *symlink);
-extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
-			      const char *full_path, __u64 size,
-			      struct cifs_sb_info *cifs_sb, bool set_alloc);
+extern int smb2_set_file_size_by_path(const unsigned int xid,
+				      struct cifs_tcon *tcon,
+				      const char *full_path, __u64 size,
+				      struct cifs_sb_info *cifs_sb,
+				      bool set_alloc);
 extern int smb2_set_file_info(struct inode *inode, const char *full_path,
 			      FILE_BASIC_INFO *buf, const unsigned int xid);
 extern int smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon,
-- 
1.7.9.5
