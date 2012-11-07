From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/3] getcifsacl: fix endianness bug in getcifsacl and add better bounds checks
Date: Wed,  7 Nov 2012 06:51:58 -0500
Message-ID: <1352289120-29327-2-git-send-email-jlayton@samba.org>
References: <1352289120-29327-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352289120-29327-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

getcifsacl must convert the access_req field from little endian. Also,
we should ensure that the "size" field in the ACE is reachable before
trying to access it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index b832c50..c576fc0 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -31,6 +31,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stddef.h>
 #include <errno.h>
 #include <limits.h>
 #include <wbclient.h>
@@ -235,7 +236,15 @@ print_sid_raw:
 static void
 print_ace(struct cifs_ace *pace, char *end_of_acl, int raw)
 {
-	/* 16 == size of cifs_ace sans the cifs_sid */
+	uint16_t size;
+
+	/* make sure we can safely get to "size" */
+	if (end_of_acl < (char *)pace + offsetof(struct cifs_ace, size) + 1)
+		return;
+
+	size = le16toh(pace->size);
+
+	/* 16 == size of cifs_ace when cifs_sid has no subauths */
 	if (le16toh(pace->size) < 16)
 		return;
 
@@ -250,8 +259,7 @@ print_ace(struct cifs_ace *pace, char *end_of_acl, int raw)
 	printf("/");
 	print_ace_flags(pace->flags, raw);
 	printf("/");
-	print_ace_mask(pace->access_req, raw);
-
+	print_ace_mask(le32toh(pace->access_req), raw);
 
 	return;
 }
-- 
1.7.12.1
