From: Steve French <smfrench@gmail.com>
Subject: [PATCH] [CIFS] Add sparse file support to SMB2/SMB3 mounts
Date: Tue, 12 Aug 2014 09:13:43 -0500
Message-ID: <CAH2r5mvt=S1eAs3BKhkim+=PPO9GrJ3jsXqYD8O1rxN2=eg-3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Many Linux filesystems make a file "sparse" when extending
a file with ftruncate. This does work for CIFS to Samba
(only) but not for SMB2/SMB3 (to Samba or Windows) since
there is a "set sparse" fsctl which is supposed to be
sent to mark a file as sparse.

This patch marks a file as sparse by sending this simple
set sparse fsctl if it is extended more than 2 pages.
It has been tested to Windows 8.1, Samba and various
SMB2/SMB3 servers which do support setting sparse (and
MacOS which does not appear to support the fsctl yet).
If a server share does not support setting a file
as sparse, then we do not retry setting sparse on that
share.

The disk space savings for sparse files can be quite
large (even more significant on Windows servers than Samba).

Signed-off-by: Steve French <smfrench@gmail.com>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/smb2ops.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c  |  4 +++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0012e1e..bc20a6e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -883,6 +883,7 @@ struct cifs_tcon {
                 for this mount even if server would support */
     bool local_lease:1; /* check leases (only) on local system not remote */
     bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
+    bool broken_sparse_sup; /* if server or share does not support sparse */
     bool need_reconnect:1; /* connection reset, tid now invalid */
 #ifdef CONFIG_CIFS_SMB2
     bool print:1;        /* set if connection to printer share */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 77f8aeb..7463436 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -736,6 +736,49 @@ smb2_set_file_size(const unsigned int xid, struct
cifs_tcon *tcon,
            struct cifsFileInfo *cfile, __u64 size, bool set_alloc)
 {
     __le64 eof = cpu_to_le64(size);
+    struct inode *inode;
+
+    /*
+     * If extending file more than one page make sparse. Many Linux fs
+     * make files sparse by default when extending via ftruncate
+     */
+    inode = cfile->dentry->d_inode;
+
+    if (!set_alloc && (size > inode->i_size + 8192)) {
+        struct cifsInodeInfo *cifsi;
+        __u8 set_sparse = 1;
+        int rc;
+
+        cifsi = CIFS_I(inode);
+
+        /* if file already sparse or no server support don't bother */
+        if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
+            goto smb2_set_eof;
+
+        /*
+         * Can't check for sparse support on share the usual way via the
+         * FS attribute info (FILE_SUPPORTS_SPARSE_FILES) on the share
+         * since Samba server doesn't set the flag on the share, yet
+         * supports the set sparse FSCTL and returns sparse correctly
+         * in the file attributes. If we fail setting sparse though we
+         * mark that server does not support sparse files for this share
+         * to avoid repeatedly sending the unsupported fsctl to server
+         * if the file is repeatedly extended.
+         */
+        if (tcon->broken_sparse_sup)
+            goto smb2_set_eof;
+
+        rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+                cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
+                true /* is_fctl */, &set_sparse, 1, NULL, NULL);
+        if (rc) {
+            tcon->broken_sparse_sup = true;
+            cifs_dbg(FYI, "set sparse rc = %d\n", rc);
+        } else
+            cifsi->cifsAttrs |= FILE_ATTRIBUTE_SPARSE_FILE;
+    }
+
+smb2_set_eof:
     return SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
                 cfile->fid.volatile_fid, cfile->pid, &eof, false);
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 42ebc1a..74440af 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1224,7 +1224,9 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,

     cifs_dbg(FYI, "SMB2 IOCTL\n");

-    *out_data = NULL;
+    if (out_data != NULL)
+        *out_data = NULL;
+
     /* zero out returned data len, in case of error */
     if (plen)
         *plen = 0;


-- 
Thanks,

Steve
