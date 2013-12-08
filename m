From: Tim Gardner <timg@tpi.com>
Subject: [PATCH 3/5 linux-next V2] cifs: Introduce cifs_legacy_set_file_size()
Date: Sun,  8 Dec 2013 14:08:42 -0700
Message-ID: <1386536924-51726-3-git-send-email-timg@tpi.com>
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

Consolidates some duplicate code.

Cc: Steve French <sfrench@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Dean Gehnert <deang@tpi.com>
Signed-off-by: Tim Gardner <timg@tpi.com>
---

V2 - this is a new patch in the V2 series.

 fs/cifs/inode.c |   54 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7181516..3f710c6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1899,6 +1899,30 @@ static void cifs_setsize(struct inode *inode, loff_t offset)
 	truncate_pagecache(inode, offset);
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
 cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		   unsigned int xid, char *full_path)
@@ -1910,7 +1934,6 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
-	struct cifs_io_parms io_parms;
 
 	/*
 	 * To avoid spurious oplock breaks from server, in the case of
@@ -1935,16 +1958,11 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		cifsFileInfo_put(open_file);
 		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
-			unsigned int bytes_written;
-
-			io_parms.netfid = open_file->fid.netfid;
-			io_parms.pid = open_file->pid;
-			io_parms.tcon = tcon;
-			io_parms.offset = 0;
-			io_parms.length = attrs->ia_size;
-			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
-					  NULL, NULL, 1);
-			cifs_dbg(FYI, "Wrt seteof rc %d\n", rc);
+			rc = cifs_legacy_set_file_size(xid,
+						       open_file->fid.netfid,
+						       open_file->pid,
+						       attrs->ia_size,
+						       tcon, full_path);
 		}
 	} else
 		rc = -EINVAL;
@@ -1982,16 +2000,10 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 				   cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 		if (rc == 0) {
-			unsigned int bytes_written;
-
-			io_parms.netfid = netfid;
-			io_parms.pid = current->tgid;
-			io_parms.tcon = tcon;
-			io_parms.offset = 0;
-			io_parms.length = attrs->ia_size;
-			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, NULL,
-					  NULL,  1);
-			cifs_dbg(FYI, "wrt seteof rc %d\n", rc);
+			rc = cifs_legacy_set_file_size(xid, netfid,
+						       current->tgid,
+						       attrs->ia_size, tcon,
+						       full_path);
 			CIFSSMBClose(xid, tcon, netfid);
 		}
 	}
-- 
1.7.9.5
