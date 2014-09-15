From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] [SMB3] Add mfsymlinks support for SMB2.1/SMB3. Part 2
 query symlink
Date: Mon, 15 Sep 2014 18:39:21 -0500
Message-ID: <CAH2r5muq3DYtwtpwTi-ezG7goeOYBLLkO_Nwfdt_2pmT-o0LCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

    Adds support on SMB2.1 and SMB3 mounts for emulation of symlinks
    via the "Minshall/French" symlink format already used for cifs
    mounts when mfsymlinks mount option is used (and also used by Apple).
    http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks
    This second patch adds support to query them (recognize them as symlinks
    and read them).

    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    CC: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c      | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |  2 ++
 fs/cifs/smb2proto.h |  4 ++++
 3 files changed, 71 insertions(+)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 11657f6..cf1113e 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -399,6 +399,71 @@ cifs_create_mf_symlink(unsigned int xid, struct
cifs_tcon *tcon,
     return rc;
 }

+/*
+ * SMB 2.1/SMB3 Protocol specific functions
+ */
+
+int
+smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
+              struct cifs_sb_info *cifs_sb, const unsigned char *path,
+              char *pbuf, unsigned int *pbytes_read)
+{
+    int rc;
+    struct cifs_fid fid;
+    struct cifs_open_parms oparms;
+    struct cifs_io_parms io_parms;
+    int buf_type = CIFS_NO_BUFFER;
+    __le16 *utf16_path;
+    __u8 oplock = SMB2_OPLOCK_LEVEL_II;
+    struct smb2_file_all_info *pfile_info = NULL;
+
+    oparms.tcon = tcon;
+    oparms.cifs_sb = cifs_sb;
+    oparms.desired_access = GENERIC_READ;
+    oparms.create_options = CREATE_NOT_DIR;
+    if (backup_cred(cifs_sb))
+        oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
+    oparms.disposition = FILE_OPEN;
+    oparms.fid = &fid;
+    oparms.reconnect = false;
+
+    utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+    if (utf16_path == NULL)
+        return -ENOMEM;
+
+    pfile_info = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
+                 GFP_KERNEL);
+
+    if (pfile_info == NULL) {
+        rc = -ENOMEM;
+        goto qmf_out;
+    }
+
+    rc = SMB2_open(xid, &oparms, utf16_path, &oplock, pfile_info, NULL);
+    if (rc)
+        goto qmf_out;
+
+    if (pfile_info->EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+        /* it's not a symlink */
+        rc = -ENOENT; /* Is there a better rc to return? */
+        goto qmf_out;
+    }
+
+    io_parms.netfid = fid.netfid;
+    io_parms.pid = current->tgid;
+    io_parms.tcon = tcon;
+    io_parms.offset = 0;
+    io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
+    io_parms.persistent_fid = fid.persistent_fid;
+    io_parms.volatile_fid = fid.volatile_fid;
+    rc = SMB2_read(xid, &io_parms, pbytes_read, &pbuf, &buf_type);
+qmf_out:
+    kfree(utf16_path);
+    kfree(pfile_info);
+    SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+    return rc;
+}
+
 int
 smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
                struct cifs_sb_info *cifs_sb, const unsigned char *path,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7d3fa29..489f48b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1452,6 +1452,7 @@ struct smb_version_operations smb21_operations = {
     .rename = smb2_rename_path,
     .create_hardlink = smb2_create_hardlink,
     .query_symlink = smb2_query_symlink,
+    .query_mf_symlink = smb3_query_mf_symlink,
     .create_mf_symlink = smb3_create_mf_symlink,
     .open = smb2_open_file,
     .set_fid = smb2_set_fid,
@@ -1532,6 +1533,7 @@ struct smb_version_operations smb30_operations = {
     .rename = smb2_rename_path,
     .create_hardlink = smb2_create_hardlink,
     .query_symlink = smb2_query_symlink,
+    .query_mf_symlink = smb3_query_mf_symlink,
     .create_mf_symlink = smb3_create_mf_symlink,
     .open = smb2_open_file,
     .set_fid = smb2_set_fid,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index e144ecf..79dc650 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -85,6 +85,10 @@ extern int smb2_create_hardlink(const unsigned int
xid, struct cifs_tcon *tcon,
 extern int smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
             struct cifs_sb_info *cifs_sb, const unsigned char *path,
             char *pbuf, unsigned int *pbytes_written);
+extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
+              struct cifs_sb_info *cifs_sb,
+              const unsigned char *path, char *pbuf,
+              unsigned int *pbytes_read);
 extern int smb2_open_file(const unsigned int xid,
               struct cifs_open_parms *oparms,
               __u32 *oplock, FILE_ALL_INFO *buf);
-- 

-- 
Thanks,

Steve
