From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][SMB3] Cleanup sparse file support by creating worker function
 for it
Date: Thu, 14 Aug 2014 16:44:15 -0500
Message-ID: <CAH2r5msUgxmikvOmirUfceCubUek8+AaCv6RcJoU6mcrJ9j=sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Simply move code to new function (for clarity).  The new function
sets or clears the sparse file attribute flag.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2ops.c | 82 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7463436..04a86cc 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -731,6 +731,54 @@ smb2_sync_write(const unsigned int xid, struct
cifsFileInfo *cfile,
     return SMB2_write(xid, parms, written, iov, nr_segs);
 }

+/* Set or clear the SPARSE_FILE attribute based on value passed in setsparse */
+static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
+        struct cifsFileInfo *cfile, struct inode *inode, __u8 setsparse)
+{
+    struct cifsInodeInfo *cifsi;
+    int rc;
+
+    cifsi = CIFS_I(inode);
+
+    /* if file already sparse don't bother setting sparse again */
+    if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && setsparse)
+        return true; /* already sparse */
+
+    if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && !setsparse)
+        return true; /* already not sparse */
+
+
+    /*
+     * Can't check for sparse support on share the usual way via the
+     * FS attribute info (FILE_SUPPORTS_SPARSE_FILES) on the share
+     * since Samba server doesn't set the flag on the share, yet
+     * supports the set sparse FSCTL and returns sparse correctly
+     * in the file attributes. If we fail setting sparse though we
+     * mark that server does not support sparse files for this share
+     * to avoid repeatedly sending the unsupported fsctl to server
+     * if the file is repeatedly extended.
+     */
+    if (tcon->broken_sparse_sup)
+        return false;
+
+    rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+            cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
+            true /* is_fctl */, &setsparse, 1, NULL, NULL);
+    if (rc) {
+        tcon->broken_sparse_sup = true;
+        cifs_dbg(FYI, "set sparse rc = %d\n", rc);
+        return false;
+    }
+
+    if (setsparse)
+        cifsi->cifsAttrs |= FILE_ATTRIBUTE_SPARSE_FILE;
+    else
+        cifsi->cifsAttrs &= (~FILE_ATTRIBUTE_SPARSE_FILE);
+
+    return true;
+}
+
+
 static int
 smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
            struct cifsFileInfo *cfile, __u64 size, bool set_alloc)
@@ -745,40 +793,12 @@ smb2_set_file_size(const unsigned int xid,
struct cifs_tcon *tcon,
     inode = cfile->dentry->d_inode;

     if (!set_alloc && (size > inode->i_size + 8192)) {
-        struct cifsInodeInfo *cifsi;
         __u8 set_sparse = 1;
-        int rc;
-
-        cifsi = CIFS_I(inode);
-
-        /* if file already sparse or no server support don't bother */
-        if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
-            goto smb2_set_eof;
-
-        /*
-         * Can't check for sparse support on share the usual way via the
-         * FS attribute info (FILE_SUPPORTS_SPARSE_FILES) on the share
-         * since Samba server doesn't set the flag on the share, yet
-         * supports the set sparse FSCTL and returns sparse correctly
-         * in the file attributes. If we fail setting sparse though we
-         * mark that server does not support sparse files for this share
-         * to avoid repeatedly sending the unsupported fsctl to server
-         * if the file is repeatedly extended.
-         */
-        if (tcon->broken_sparse_sup)
-            goto smb2_set_eof;
-
-        rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-                cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
-                true /* is_fctl */, &set_sparse, 1, NULL, NULL);
-        if (rc) {
-            tcon->broken_sparse_sup = true;
-            cifs_dbg(FYI, "set sparse rc = %d\n", rc);
-        } else
-            cifsi->cifsAttrs |= FILE_ATTRIBUTE_SPARSE_FILE;
+
+        /* whether set sparse succeeds or not, extend the file */
+        smb2_set_sparse(xid, tcon, cfile, inode, set_sparse);
     }

-smb2_set_eof:
     return SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
                 cfile->fid.volatile_fid, cfile->pid, &eof, false);
 }

-- 
Thanks,

Steve
