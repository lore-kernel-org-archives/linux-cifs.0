From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] setcifsacl: fix format specifier in error message
Date: Fri,  9 Nov 2012 07:51:36 -0500
Message-ID: <1352465496-11837-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

setcifsacl.c:833: warning: format '%ld' expects type 'long int', but
argument 3 has type 'ssize_t'

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 465f195..593997a 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -828,7 +828,7 @@ main(const int argc, char *const argv[])
 
 cifsacl:
 	if (bufsize >= XATTR_SIZE_MAX) {
-		printf("%s: Buffer size %ld exceeds max size of %d\n",
+		printf("%s: Buffer size %zd exceeds max size of %d\n",
 				__func__, bufsize, XATTR_SIZE_MAX);
 		goto setcifsacl_cmdlineverify_ret;
 	}
-- 
1.7.11.7
