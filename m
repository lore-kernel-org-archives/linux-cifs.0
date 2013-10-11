From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH][cifs-utils] mount.cifs: fix bad free() of string returned by dirname()
Date: Fri, 11 Oct 2013 10:27:53 -0400
Message-ID: <1381501673-7286-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Coverity says:

  Error: CPPCHECK_WARNING: [#def10]
  cifs-utils-6.2/mount.cifs.c:1518: error[memleakOnRealloc]: Common realloc mistake: 'mtabdir' nulled but not freed upon failure

del_mtab has a number of bugs in handling of allocated memory:

a) the return value of strdup() is not checked

b) It calls realloc() on a pointer that wasn't returned by an allocation
   function (e.g. malloc, calloc, etc.)

c) If realloc() fails, it doesn't call free() on the original memory
   returned by strdup()

Fix all of these bugs and add newlines to the end of the error messages
in del_mtab.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 7206dcb..5969afb 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1508,23 +1508,29 @@ add_mtab_exit:
 static int
 del_mtab(char *mountpoint)
 {
-	int tmprc, rc = 0;
+	int len, tmprc, rc = 0;
 	FILE *mnttmp, *mntmtab;
 	struct mntent *mountent;
 	char *mtabfile, *mtabdir, *mtabtmpfile;
 
 	mtabfile = strdup(MOUNTED);
-	mtabdir = dirname(mtabfile);
-	mtabdir = realloc(mtabdir, strlen(mtabdir) + strlen(MNT_TMP_FILE) + 2);
-	if (!mtabdir) {
-		fprintf(stderr, "del_mtab: cannot determine current mtab path");
+	if (!mtabfile) {
+		fprintf(stderr, "del_mtab: cannot strdup MOUNTED\n");
 		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
-	mtabtmpfile = strcat(mtabdir, MNT_TMP_FILE);
+	mtabdir = dirname(mtabfile);
+	len = strlen(mtabdir) + strlen(MNT_TMP_FILE);
+	mtabtmpfile = malloc(len + 1);
 	if (!mtabtmpfile) {
-		fprintf(stderr, "del_mtab: cannot allocate memory to tmp file");
+		fprintf(stderr, "del_mtab: cannot allocate memory to tmp file\n");
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	if (sprintf(mtabtmpfile, "%s%s", mtabdir, MNT_TMP_FILE) != len) {
+		fprintf(stderr, "del_mtab: error writing new string\n");
 		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
@@ -1532,14 +1538,14 @@ del_mtab(char *mountpoint)
 	atexit(unlock_mtab);
 	rc = lock_mtab();
 	if (rc) {
-		fprintf(stderr, "del_mtab: cannot lock mtab");
+		fprintf(stderr, "del_mtab: cannot lock mtab\n");
 		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
 	mtabtmpfile = mktemp(mtabtmpfile);
 	if (!mtabtmpfile) {
-		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
+		fprintf(stderr, "del_mtab: cannot setup tmp file destination\n");
 		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
@@ -1587,7 +1593,7 @@ del_mtab(char *mountpoint)
 
 del_mtab_exit:
 	unlock_mtab();
-	free(mtabdir);
+	free(mtabfile);
 	return rc;
 
 del_mtab_error:
-- 
1.8.3.1
