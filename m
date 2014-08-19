From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [SMB3] Enable fallocate -z support for SMB3 mounts
Date: Tue, 19 Aug 2014 09:58:31 -0500
Message-ID: <CAH2r5mtS9zdJHF14uTK49oJiPEPJ5Kzm35WmZUhV+Pn+wX8z7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fallocate -z (FALLOC_FL_ZERO_RANGE) can map to SMB3
FSCTL_SET_ZERO_DATA SMB3 FSCTL but FALLOC_FL_ZERO_RANGE
when called without the FALLOC_FL_KEEPSIZE flag set could want
the file size changed so we can not support that subcase unless
the file is cached (and thus we know the file size).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 101670c..5a48aa2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1015,6 +1015,56 @@ smb2_query_symlink(const unsigned int xid,
struct cifs_tcon *tcon,
     return rc;
 }

+static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
+                loff_t offset, loff_t len, bool keep_size)
+{
+    struct inode *inode;
+    struct cifsInodeInfo *cifsi;
+    struct cifsFileInfo *cfile = file->private_data;
+    struct file_zero_data_information fsctl_buf;
+    long rc;
+    unsigned int xid;
+
+    xid = get_xid();
+
+    inode = cfile->dentry->d_inode;
+    cifsi = CIFS_I(inode);
+
+    /* if file not oplocked can't be sure whether asking to extend size */
+    if (!CIFS_CACHE_READ(cifsi))
+        if (keep_size == false)
+            return -EOPNOTSUPP;
+
+    /*
+     * Must check if file sparse since fallocate -z (zero range) assumes
+     * non-sparse allocation
+     */
+    if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE))
+        return -EOPNOTSUPP;
+
+    /*
+     * need to make sure we are not asked to extend the file since the SMB3
+     * fsctl does not change the file size. In the future we could change
+     * this to zero the first part of the range then set the file size
+     * which for a non sparse file would zero the newly extended range
+     */
+    if (keep_size == false)
+        if (i_size_read(inode) < offset + len)
+            return -EOPNOTSUPP;
+
+    cifs_dbg(FYI, "offset %lld len %lld", offset, len);
+
+    fsctl_buf.FileOffset = cpu_to_le64(offset);
+    fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
+
+    rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+            cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
+            true /* is_fctl */, (char *)&fsctl_buf,
+            sizeof(struct file_zero_data_information), NULL, NULL);
+    free_xid(xid);
+    return rc;
+}
+
 static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
                 loff_t offset, loff_t len)
 {
@@ -1055,6 +1105,11 @@ static long smb3_fallocate(struct file *file,
struct cifs_tcon *tcon, int mode,
     /* KEEP_SIZE already checked for by do_fallocate */
     if (mode & FALLOC_FL_PUNCH_HOLE)
         return smb3_punch_hole(file, tcon, off, len);
+    else if (mode & FALLOC_FL_ZERO_RANGE) {
+        if (mode & FALLOC_FL_KEEP_SIZE)
+            return smb3_zero_range(file, tcon, off, len, true);
+        return smb3_zero_range(file, tcon, off, len, false);
+    }

     return -EOPNOTSUPP;
 }

-- 
Thanks,

Steve
