From: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] use mkstemp instead of mktemp
Date: Thu, 26 Apr 2012 11:36:38 -0400
Message-ID: <1335454598-27812-1-git-send-email-gitter.spiros@gmail.com>
Cc: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As described in the manual page mktemp(3) the use of this feature
is strongly discouraged in favor of mkstemp(3).

In fact the mkstemp() function generates a unique temporary file
name from the supplied template,
opens a file of that name using the O_EXCL flag (guaranteeing the
current process to be the only user) and returns a file descriptor.

But the POSIX specification does not say anything about file modes,
so the application should make sure its umask
is set appropriately before calling mkstemp.
( ref. https://buildsecurityin.us-cert.gov/bsi/articles/knowledge/coding/781-BSI.html)

Signed-off-by: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index c90ce3e..bdd9d28 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1627,6 +1627,9 @@ del_mtab(char *mountpoint)
 	FILE *mnttmp, *mntmtab;
 	struct mntent *mountent;
 	char *mtabfile, *mtabdir, *mtabtmpfile;
+	mode_t mode;
+	FILE *spf;
+	int fd = -1 ;
 
 	mtabfile = strdup(MOUNTED);
 	mtabdir = dirname(mtabfile);
@@ -1652,12 +1655,17 @@ del_mtab(char *mountpoint)
 		goto del_mtab_exit;
 	}
 
-	mtabtmpfile = mktemp(mtabtmpfile);
-	if (!mtabtmpfile) {
-		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
-		rc = EX_FILEIO;
-		goto del_mtab_exit;
+	mode = umask(0077);
+	(void) umask(mode);
+	if ((fd = mkstemp(mtabtmpfile)) == -1 ||
+		(spf = fdopen(fd, "w+")) == NULL) {
+		if (fd != -1) {
+			fprintf(stderr, "del_mtab: cannot setup tmp file destination");
+			rc = EX_FILEIO;
+			goto del_mtab_exit;
+                }
 	}
+	(void) fclose(spf);
 
 	mntmtab = setmntent(MOUNTED, "r");
 	if (!mntmtab) {
-- 
1.7.1
