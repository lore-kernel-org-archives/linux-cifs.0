From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][CIFS] Add worker function to set allocation size
Date: Tue, 5 Aug 2014 13:05:16 -0500
Message-ID: <CAH2r5msNfb3FPseWmeS+TLtHD=z=UPr6H-XzgE+hXa3Ei=9QdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Date: Sat, 19 Jul 2014 21:44:58 -0500
Subject: [PATCH] [CIFS] Add worker function to set allocation size

Adds setinfo worker function for SMB2/SMB3 support of SET_ALLOCATION_INFORMATION

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2inode.c |  2 +-
 fs/cifs/smb2ops.c   |  3 ++-
 fs/cifs/smb2pdu.c   | 10 +++++++---
 fs/cifs/smb2proto.h |  2 +-
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 84c012a..0150182 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -91,7 +91,7 @@ smb2_open_op_close(const unsigned int xid, struct
cifs_tcon *tcon,
     case SMB2_OP_SET_EOF:
         tmprc = SMB2_set_eof(xid, tcon, fid.persistent_fid,
                      fid.volatile_fid, current->tgid,
-                     (__le64 *)data);
+                     (__le64 *)data, false);
         break;
     case SMB2_OP_SET_INFO:
         tmprc = SMB2_set_info(xid, tcon, fid.persistent_fid,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 787844b..ae1bff3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -19,6 +19,7 @@

 #include <linux/pagemap.h>
 #include <linux/vfs.h>
+#include <linux/falloc.h>
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
@@ -687,7 +688,7 @@ smb2_set_file_size(const unsigned int xid, struct
cifs_tcon *tcon,
 {
     __le64 eof = cpu_to_le64(size);
     return SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-                cfile->fid.volatile_fid, cfile->pid, &eof);
+                cfile->fid.volatile_fid, cfile->pid, &eof, false);
 }

 static int
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b0b260d..49d14b6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2325,7 +2325,7 @@ SMB2_set_hardlink(const unsigned int xid, struct
cifs_tcon *tcon,

 int
 SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64
persistent_fid,
-         u64 volatile_fid, u32 pid, __le64 *eof)
+         u64 volatile_fid, u32 pid, __le64 *eof, bool is_falloc)
 {
     struct smb2_file_eof_info info;
     void *data;
@@ -2336,8 +2336,12 @@ SMB2_set_eof(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
     data = &info;
     size = sizeof(struct smb2_file_eof_info);

-    return send_set_info(xid, tcon, persistent_fid, volatile_fid, pid,
-                 FILE_END_OF_FILE_INFORMATION, 1, &data, &size);
+    if (is_falloc)
+        return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+            pid, FILE_ALLOCATION_INFORMATION, 1, &data, &size);
+    else
+        return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+            pid, FILE_END_OF_FILE_INFORMATION, 1, &data, &size);
 }

 int
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 0ce48db..67e8ce8 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -139,7 +139,7 @@ extern int SMB2_set_hardlink(const unsigned int
xid, struct cifs_tcon *tcon,
                  __le16 *target_file);
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
             u64 persistent_fid, u64 volatile_fid, u32 pid,
-            __le64 *eof);
+            __le64 *eof, bool is_fallocate);
 extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
              u64 persistent_fid, u64 volatile_fid,
              FILE_BASIC_INFO *buf);


-- 
Thanks,

Steve
