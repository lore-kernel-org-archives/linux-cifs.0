From: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Use mkstemp instead of mktemp
Date: Fri, 27 Apr 2012 11:12:48 -0400
Message-ID: <1335539568-32024-1-git-send-email-gitter.spiros@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As described in the manual page mktemp(3) the use of this function
is strongly discouraged in favor of mkstemp(3).

In fact the mkstemp() function generates a unique temporary file
name from the supplied template,
opens a file of that name using the O_EXCL flag (guaranteeing the
current process to be the only user) and returns a file descriptor.

The file is then created with mode read/write and permissions 0666 (glibc 2.0.6 and earlier),
0600 (glibc 2.0.7 and later).

But for portability the POSIX specification does not say anything about file modes,
so the application should make sure its umask is set appropriately before calling mkstemp.
( ref. https://buildsecurityin.us-cert.gov/bsi/articles/knowledge/coding/781-BSI.html)

In this case we set umask to 033 before calling mkstemp
and after we reset the original umask.

Signed-off-by: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
This is the second version of the patch. I have
tried to follow the Jeff indication
http://article.gmane.org/gmane.linux.kernel.cifs/5988


 mount.cifs.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index c90ce3e..1cdaf38 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1627,6 +1627,7 @@ del_mtab(char *mountpoint)
 	FILE *mnttmp, *mntmtab;
 	struct mntent *mountent;
 	char *mtabfile, *mtabdir, *mtabtmpfile;
+	mode_t mode;
 
 	mtabfile = strdup(MOUNTED);
 	mtabdir = dirname(mtabfile);
@@ -1652,12 +1653,14 @@ del_mtab(char *mountpoint)
 		goto del_mtab_exit;
 	}
 
-	mtabtmpfile = mktemp(mtabtmpfile);
-	if (!mtabtmpfile) {
-		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
-		rc = EX_FILEIO;
-		goto del_mtab_exit;
+	mode = umask(0077);
+	if (close(mkstemp(mtabtmpfile)) == -1 ) {
+			fprintf(stderr, "del_mtab: cannot setup tmp file destination");
+			(void)umask(mode);
+			rc = EX_FILEIO;
+			goto del_mtab_exit;
 	}
+	(void)umask(mode);
 
 	mntmtab = setmntent(MOUNTED, "r");
 	if (!mntmtab) {
-- 
1.7.8.rc3.31.g017d1
