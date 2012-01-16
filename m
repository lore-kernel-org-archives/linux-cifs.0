From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: handle errors from rename() in del_mtab
Date: Mon, 16 Jan 2012 12:37:16 -0500
Message-ID: <1326735436-17863-1-git-send-email-jlayton@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The new del_mtab code ignored errors from rename(). Make it handle that
error as well like it does other errors. Also, move the setting of
rc = EX_FILEIO under the del_mtab_error label. All of the existing places
that goto that label set that error already.

Cc: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index af071c1..cd0f3c5 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1639,14 +1639,12 @@ del_mtab(char *mountpoint)
 	mtabdir = realloc(mtabdir, strlen(mtabdir) + strlen(MNT_TMP_FILE) + 2);
 	if (!mtabdir) {
 		fprintf(stderr, "del_mtab: cannot determine current mtab path");
-		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
 	mtabtmpfile = strcat(mtabdir, MNT_TMP_FILE);
 	if (!mtabtmpfile) {
 		fprintf(stderr, "del_mtab: cannot allocate memory to tmp file");
-		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
@@ -1654,21 +1652,18 @@ del_mtab(char *mountpoint)
 	rc = lock_mtab();
 	if (rc) {
 		fprintf(stderr, "del_mtab: cannot lock mtab");
-		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
 	mtabtmpfile = mktemp(mtabtmpfile);
 	if (!mtabtmpfile) {
 		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
-		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
 	mntmtab = setmntent(MOUNTED, "r");
 	if (!mntmtab) {
 		fprintf(stderr, "del_mtab: could not update mount table\n");
-		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
@@ -1676,7 +1671,6 @@ del_mtab(char *mountpoint)
 	if (!mnttmp) {
 		fprintf(stderr, "del_mtab: could not update mount table\n");
 		endmntent(mntmtab);
-		rc = EX_FILEIO;
 		goto del_mtab_exit;
 	}
 
@@ -1686,7 +1680,6 @@ del_mtab(char *mountpoint)
 		rc = addmntent(mnttmp, mountent);
 		if (rc) {
 			fprintf(stderr, "del_mtab: unable to add mount entry to mtab\n");
-			rc = EX_FILEIO;
 			goto del_mtab_error;
 		}
 	}
@@ -1696,11 +1689,13 @@ del_mtab(char *mountpoint)
 	tmprc = my_endmntent(mnttmp, 0);
 	if (tmprc) {
 		fprintf(stderr, "del_mtab: error %d detected on close of tmp file\n", tmprc);
-		rc = EX_FILEIO;
 		goto del_mtab_error;
 	}
 
-	rename(mtabtmpfile, MOUNTED);
+	if (rename(mtabtmpfile, MOUNTED)) {
+		fprintf(stderr, "del_mtab: error %d when renaming mtab in place\n", errno);
+		goto del_mtab_error;
+	}
 
 del_mtab_exit:
 	unlock_mtab();
@@ -1708,6 +1703,7 @@ del_mtab_exit:
 	return rc;
 
 del_mtab_error:
+	rc = EX_FILEIO;
 	if (unlink(mtabtmpfile))
 		fprintf(stderr, "del_mtab: failed to delete tmp file - %s\n",
 				strerror(errno));
-- 
1.7.7.4
