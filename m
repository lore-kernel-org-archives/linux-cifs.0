From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Samba server bug: CopyChunk from one share to a different share on
 same server
Date: Sun, 8 Nov 2015 21:04:34 -0600
Message-ID: <CAH2r5ms4tZVm0kS-wLjCPrBkfbTMHTER1LXwdkxpV-JjzdjW9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Tried a quick experiment using cloner (David's tool in
xfstests/src/cloner.c) to copy a file from share1 to share2 on the
same target server (using CopyChunk and SMB3).  Works fine for Windows
(tried Windows 8.1 as server) but failed for Samba 4.2.

This is one of the more important cases to support (copying a file
from one share to another).

Samba returned STATUS_OBJECT_NAME_NOT_FOUND on
FSCTL_SRV_COPYCHUNK_WRITE unless source and target are on the same
share.  I didn't try it with vfs_btrfs (the test system was running
ext4, and both exports are on the same volume on the server).

Was testing the change below where I relax the copy offload check in
cifs.ko as follows (to allow cross share copy chunk as Windows often
does)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 28a77bf..35cf990 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -85,9 +85,14 @@ static long cifs_ioctl_clone(unsigned int xid,
struct file *dst_file,
     src_tcon = tlink_tcon(smb_file_src->tlink);
     target_tcon = tlink_tcon(smb_file_target->tlink);

-    /* check if source and target are on same tree connection */
-    if (src_tcon != target_tcon) {
-        cifs_dbg(VFS, "file copy src and target on different volume\n");
+    /* check source and target on same server (or volume if dup_extents) */
+    if (dup_extents && (src_tcon != target_tcon)) {
+        cifs_dbg(VFS, "source and target of copy not on same share\n");
+        goto out_fput;
+    }
+
+    if (!dup_extents && (src_tcon->ses != target_tcon->ses)) {
+        cifs_dbg(VFS, "source and target of copy not on same server\n");
         goto out_fput;
     }

-- 
Thanks,

Steve
