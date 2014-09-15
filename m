From: Steve French <smfrench@gmail.com>
Subject: [PATCH] [SMB3] Add mfsymlinks support for SMB2.1/SMB3. Part 1 create symlink
Date: Mon, 15 Sep 2014 13:39:16 -0500
Message-ID: <CAH2r5msPjpPvom=0G0-Sj3RdnXMRVJpXb=VBiRZ+E0RSqAPh6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical@lists.samba.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Adds support on SMB2.1 and SMB3 mounts for emulation of symlinks
via the "Minshall/French" symlink format already used for cifs
mounts when mfsymlinks mount option is used (and also used by Apple).
http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks
This first patch adds support to create them.  The next patch will
add support for recognizing them and reading them.  Although CIFS/SMB3
have other types of symlinks, in the many use cases they aren't
practical (e.g. either require cifs only mounts with unix extensions
to Samba, or require the user to be Administrator to Windows for SMB3).
This also helps enable running additional xfstests over SMB3 (since some
xfstests directly or indirectly require symlink support).

Signed-off-by: Steve French <smfrench@gmail.com>
CC: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/link.c      | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |  2 ++
 fs/cifs/smb2proto.h |  4 +++-
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index a5c2812..11657f6 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -28,6 +28,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
+#include "smb2proto.h"

 /*
  * M-F Symlink Functions - Begin
@@ -398,6 +399,68 @@ cifs_create_mf_symlink(unsigned int xid, struct
cifs_tcon *tcon,
     return rc;
 }

+int
+smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
+               struct cifs_sb_info *cifs_sb, const unsigned char *path,
+               char *pbuf, unsigned int *pbytes_written)
+{
+    int rc;
+    struct cifs_fid fid;
+    struct cifs_open_parms oparms;
+    struct cifs_io_parms io_parms;
+    int create_options = CREATE_NOT_DIR;
+    __le16 *utf16_path;
+    __u8 oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+    struct kvec iov[2];
+
+    if (backup_cred(cifs_sb))
+        create_options |= CREATE_OPEN_BACKUP_INTENT;
+
+    cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
+
+    utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+    if (!utf16_path)
+        return -ENOMEM;
+
+    oparms.tcon = tcon;
+    oparms.cifs_sb = cifs_sb;
+    oparms.desired_access = GENERIC_WRITE;
+    oparms.create_options = create_options;
+    oparms.disposition = FILE_CREATE;
+    oparms.fid = &fid;
+    oparms.reconnect = false;
+
+    rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
+    if (rc) {
+        kfree(utf16_path);
+        return rc;
+    }
+
+    io_parms.netfid = fid.netfid;
+    io_parms.pid = current->tgid;
+    io_parms.tcon = tcon;
+    io_parms.offset = 0;
+    io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
+    io_parms.persistent_fid = fid.persistent_fid;
+    io_parms.volatile_fid = fid.volatile_fid;
+
+    /* iov[0] is reserved for smb header */
+    iov[1].iov_base = pbuf;
+    iov[1].iov_len = CIFS_MF_SYMLINK_FILE_SIZE;
+
+    rc = SMB2_write(xid, &io_parms, pbytes_written, iov, 1);
+
+    /* Make sure we wrote all of the symlink data */
+    if ((rc == 0) && (*pbytes_written != CIFS_MF_SYMLINK_FILE_SIZE))
+        rc = -EIO;
+
+    SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+
+    kfree(utf16_path);
+    return rc;
+}
+
+
 /*
  * M-F Symlink Functions - End
  */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f522193..7d3fa29 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1452,6 +1452,7 @@ struct smb_version_operations smb21_operations = {
     .rename = smb2_rename_path,
     .create_hardlink = smb2_create_hardlink,
     .query_symlink = smb2_query_symlink,
+    .create_mf_symlink = smb3_create_mf_symlink,
     .open = smb2_open_file,
     .set_fid = smb2_set_fid,
     .close = smb2_close_file,
@@ -1531,6 +1532,7 @@ struct smb_version_operations smb30_operations = {
     .rename = smb2_rename_path,
     .create_hardlink = smb2_create_hardlink,
     .query_symlink = smb2_query_symlink,
+    .create_mf_symlink = smb3_create_mf_symlink,
     .open = smb2_open_file,
     .set_fid = smb2_set_fid,
     .close = smb2_close_file,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 67e8ce8..e144ecf 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -82,7 +82,9 @@ extern int smb2_rename_path(const unsigned int xid,
struct cifs_tcon *tcon,
 extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
                 const char *from_name, const char *to_name,
                 struct cifs_sb_info *cifs_sb);
-
+extern int smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
+            struct cifs_sb_info *cifs_sb, const unsigned char *path,
+            char *pbuf, unsigned int *pbytes_written);
 extern int smb2_open_file(const unsigned int xid,
               struct cifs_open_parms *oparms,
               __u32 *oplock, FILE_ALL_INFO *buf);
-- 

-- 
Thanks,

Steve
