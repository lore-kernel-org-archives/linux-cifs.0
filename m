From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: fix cifs_uniqueid_to_ino_t not to ever return 0
Date: Fri,  2 May 2014 13:50:02 -0400
Message-ID: <1399053002-3393-1-git-send-email-jlayton@poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, copet_eric-mb1K0bWo544@public.gmane.org, per-ola-ePW4WA7C/hizQB+pC5nmwQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, when the top and bottom 32-bit words are equivalent and the
host is a 32-bit arch, cifs_uniqueid_to_ino_t returns 0 as the ino_t
value. All we're doing to hash the value down to 32 bits is xor'ing the
top and bottom 32-bit words and that obviously results in 0 if they are
equivalent.

The kernel doesn't really care if it returns this value, but some
userland apps (like "ls") will ignore dirents that have a zero d_ino
value.

Change this function to use hash_64 to convert this value to a 31 bit
value and then add 1 to ensure that it doesn't ever return 0. Also,
there's no need to check the sizeof(ino_t) at runtime so create two
different cifs_uniqueid_to_ino_t functions based on whether
BITS_PER_LONG is 64 for not.

This should fix:

    https://bugzilla.kernel.org/show_bug.cgi?id=19282

Reported-by: Eric <copet_eric-mb1K0bWo544@public.gmane.org>
Reported-by: <per-ola-ePW4WA7C/hizQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
---
 fs/cifs/cifsfs.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index b7cf9ee7654b..1bbe97c2a632 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -22,20 +22,28 @@
 #ifndef _CIFSFS_H
 #define _CIFSFS_H
 
+#include <linux/hash.h>
+
 #define ROOT_I 2
 
 /*
  * ino_t is 32-bits on 32-bit arch. We have to squash the 64-bit value down
- * so that it will fit.
+ * so that it will fit. We use hash_64 to convert the value to 31 bits, and
+ * then add 1, to ensure that we don't end up with a 0 as the value.
  */
+#if BITS_PER_LONG == 64
 static inline ino_t
 cifs_uniqueid_to_ino_t(u64 fileid)
 {
-	ino_t ino = (ino_t) fileid;
-	if (sizeof(ino_t) < sizeof(u64))
-		ino ^= fileid >> (sizeof(u64)-sizeof(ino_t)) * 8;
-	return ino;
+	return (ino_t)fileid;
 }
+#else
+static inline ino_t
+cifs_uniqueid_to_ino_t(u64 fileid)
+{
+	return (ino_t)hash_64(fileid, (sizeof(ino_t) * 8) - 1) + 1;
+}
+#endif
 
 extern struct file_system_type cifs_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
-- 
1.9.0
