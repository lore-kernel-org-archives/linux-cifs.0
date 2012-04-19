From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: fix up some -D_FORTIFY_SOURCE=2 warnings
Date: Wed, 18 Apr 2012 21:50:11 -0400
Message-ID: <1334800211-870-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and add -D_FORTIFY_SOURCE=2 to the default $CFLAGS.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am  |    2 +-
 mount.cifs.c |   12 +++++++-----
 mtab.c       |    4 +++-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d95142a..05729ca 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -Wall -Wextra -Werror
+AM_CFLAGS = -Wall -Wextra -Werror -D_FORTIFY_SOURCE=2
 ACLOCAL_AMFLAGS = -I aclocal
 
 root_sbindir = $(ROOTSBINDIR)
diff --git a/mount.cifs.c b/mount.cifs.c
index f0b073e..ecbf034 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -928,10 +928,10 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 				}
 			} else {
 				/* domain/username%password */
-				const int max = MAX_DOMAIN_SIZE +
-						MAX_USERNAME_SIZE +
-						MOUNT_PASSWD_SIZE + 2;
-				if (strnlen(value, max + 1) >= max + 1) {
+				const size_t max = MAX_DOMAIN_SIZE +
+						   MAX_USERNAME_SIZE +
+						   MOUNT_PASSWD_SIZE + 2 + 1;
+				if (strnlen(value, max) >= max) {
 					fprintf(stderr, "username too long\n");
 					return EX_USAGE;
 				}
@@ -1603,8 +1603,10 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
 	mountent.mnt_passno = 0;
 	rc = addmntent(pmntfile, &mountent);
 	if (rc) {
+		int ignore __attribute__((unused));
+
 		fprintf(stderr, "unable to add mount entry to mtab\n");
-		ftruncate(fd, statbuf.st_size);
+		ignore = ftruncate(fd, statbuf.st_size);
 		rc = EX_FILEIO;
 	}
 	tmprc = my_endmntent(pmntfile, statbuf.st_size);
diff --git a/mtab.c b/mtab.c
index de545b7..3d42ac0 100644
--- a/mtab.c
+++ b/mtab.c
@@ -271,8 +271,10 @@ my_endmntent(FILE *stream, off_t size)
 
 	/* truncate file back to "size" -- best effort here */
 	if (rc) {
+		int ignore __attribute__((unused));
+
 		rc = errno;
-		ftruncate(fd, size);
+		ignore = ftruncate(fd, size);
 	}
 
 	endmntent(stream);
-- 
1.7.7.6
