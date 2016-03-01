From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] s390x: fix condition to choose correct function
Date: Mon, 29 Feb 2016 18:04:12 -0600
Message-ID: <1456790652-92638-1-git-send-email-smfrench@gmail.com>
References: <smfrench@gmail.com>
Cc: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>

This issue is involved from commit 02323db17e3a7 ("cifs: fix
cifs_uniqueid_to_ino_t not to ever return 0"), when BITS_PER_LONG
is 64 on s390x, the corresponding cifs_uniqueid_to_ino_t()
function will cast 64-bit fileid to 32-bit by using (ino_t)fileid,
because ino_t (typdefed __kernel_ino_t) is int type.

Signed-off-by: Yadan Fan <ydfan-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
1.9.1
