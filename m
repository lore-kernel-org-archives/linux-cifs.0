From: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] s390x: fix condition to choose correct function
Date: Wed, 24 Feb 2016 14:45:47 +0800
Message-ID: <1456296347-9665-1-git-send-email-ydfan@suse.com>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This issue is involved from commit 02323db17e3a7 ("cifs: fix
cifs_uniqueid_to_ino_t not to ever return 0"), when BITS_PER_LONG
is 64 on s390x, the corresponding cifs_uniqueid_to_ino_t()
function will cast 64-bit fileid to 32-bit by using (ino_t)fileid,
because ino_t (typdefed __kernel_ino_t) is int type.

Signed-off-by: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 68c4547..02dcbe1 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -31,7 +31,7 @@
  * so that it will fit. We use hash_64 to convert the value to 31 bits, and
  * then add 1, to ensure that we don't end up with a 0 as the value.
  */
-#if BITS_PER_LONG == 64
+#if BITS_PER_LONG == 64 && !defined(CONFIG_S390)
 static inline ino_t
 cifs_uniqueid_to_ino_t(u64 fileid)
 {
-- 
2.6.2
