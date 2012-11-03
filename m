From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 04/17] get/setcifsacl: set "prog" via basename(argv[0])
Date: Sat,  3 Nov 2012 08:50:21 -0400
Message-ID: <1351947034-18876-5-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This saves a tiny bit of memory, and doesn't make the program assume
that the binary is named something in particular.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 3 ++-
 setcifsacl.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 8cbdb1d..da4bb67 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -38,7 +38,7 @@
 #include <sys/xattr.h>
 #include "cifsacl.h"
 
-static const char *prog = "getcifsacl";
+static const char *prog;
 
 static void
 print_each_ace_mask(uint32_t mask)
@@ -333,6 +333,7 @@ main(const int argc, char *const argv[])
 	size_t bufsize = BUFSIZE;
 	char *filename, *attrval;
 
+	prog = basename(argv[0]);
 	openlog(prog, 0, LOG_DAEMON);
 
 	while ((c = getopt_long(argc, argv, "r:v", NULL, NULL)) != -1) {
diff --git a/setcifsacl.c b/setcifsacl.c
index 380adac..50822e6 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -39,7 +39,7 @@
 #include <sys/xattr.h>
 #include "cifsacl.h"
 
-static const char *prog = "setcifsacl";
+static const char *prog;
 
 static void
 copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
@@ -775,6 +775,8 @@ main(const int argc, char *const argv[])
 	struct cifs_ace **cacesptr = NULL, **facesptr = NULL;
 	struct cifs_ntsd *ntsdptr = NULL;
 
+	prog = basename(argv[0]);
+
 	openlog(prog, 0, LOG_DAEMON);
 
 	c = getopt(argc, argv, "v:D:M:a:S:?");
-- 
1.7.11.7
