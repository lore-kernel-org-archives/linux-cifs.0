From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] getcifsacl: remove unneeded openlog() call
Date: Fri,  7 Dec 2012 10:41:33 -0500
Message-ID: <1354894893-387-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

getcifsacl doesn't log to syslog, so there's no need to open a channel
to it. Also, remove the unneeded "prog" global variable since only
the usage() function needs it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 3f94a99..550429c 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -25,7 +25,6 @@
 
 #include <string.h>
 #include <getopt.h>
-#include <syslog.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <unistd.h>
@@ -39,8 +38,6 @@
 #include <sys/xattr.h>
 #include "cifsacl.h"
 
-static const char *prog;
-
 static void
 print_each_ace_mask(uint32_t mask)
 {
@@ -355,7 +352,7 @@ parse_sec_desc(struct cifs_ntsd *pntsd, ssize_t acl_len, int raw)
 }
 
 static void
-getcifsacl_usage(void)
+getcifsacl_usage(const char *prog)
 {
 	fprintf(stderr,
 	"%s: Display CIFS/NTFS ACL in a security descriptor of a file object\n",
@@ -376,9 +373,6 @@ main(const int argc, char *const argv[])
 	size_t bufsize = BUFSIZE;
 	char *filename, *attrval;
 
-	prog = basename(argv[0]);
-	openlog(prog, 0, LOG_DAEMON);
-
 	while ((c = getopt_long(argc, argv, "r:v", NULL, NULL)) != -1) {
 		switch (c) {
 		case 'v':
@@ -397,7 +391,7 @@ main(const int argc, char *const argv[])
 	else if (argc == 2)
 		filename = argv[1];
 	else {
-		getcifsacl_usage();
+		getcifsacl_usage(basename(argv[0]));
 		return 0;
 	}
 
-- 
1.7.11.7
