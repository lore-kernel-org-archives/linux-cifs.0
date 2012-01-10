From: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mount.cifs: Properly update mtab during remount V3
Date: Tue, 10 Jan 2012 18:49:22 -0200
Message-ID: <1326228562-18494-1-git-send-email-cmaiolino@redhat.com>
Cc: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

During a remount of a cifs filesystem, the mtab file is not properly updated, which
leads to a doubled entry of the same filesystem in the /etc/mtab file. This patch
adds a new function del_mtab() which is called before the add_mtab() in case the fs
is being remounted.
The del_mtab() function will delete from the mtab, the old entry from the filesystem
which is being remounted, and then, calls add_mtab() to add an updated entry to the
mtab file.

Signed-off-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mount.cifs.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 147f7fc..a7c76e9 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -42,6 +42,7 @@
 #include <fcntl.h>
 #include <limits.h>
 #include <paths.h>
+#include <libgen.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #ifdef HAVE_LIBCAP_NG
@@ -161,6 +162,7 @@
 #define OPT_BKUPUID    30
 #define OPT_BKUPGID    31
 
+#define MNT_TMP_FILE "/.mtab.tmp.XXXXXX"
 
 /* struct for holding parsed mount info for use by privleged process */
 struct parsed_mount_info {
@@ -1624,6 +1626,106 @@ add_mtab_exit:
 	return rc;
 }
 
+static int
+del_mtab(char *mountpoint)
+{
+	int fd, tmprc, rc = 0;
+	FILE *mnttmp, *mntmtab;
+	struct mntent *mountent;
+	struct stat statbuf;
+	char *mtabfile, *mtabdir, *mtabtmpfile;
+
+	mtabfile = strdup(MOUNTED);
+	mtabdir = dirname(mtabfile);
+	mtabdir = realloc(mtabdir, strlen(mtabdir) + strlen(MNT_TMP_FILE) + 2 );
+	if (!mtabdir) {
+		fprintf(stderr, "del_mtab: cannot determine current mtab path");
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	mtabtmpfile = malloc(strlen(mtabdir) + strlen(MNT_TMP_FILE) + 2 );
+	mtabtmpfile = strcat(mtabdir, MNT_TMP_FILE);
+	if (!mtabtmpfile) {
+		fprintf(stderr, "del_mtab: cannot allocate memory to tmp file");
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	mtabtmpfile = mktemp(mtabtmpfile);
+	if (!mtabtmpfile) {
+		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	atexit(unlock_mtab);
+	rc = lock_mtab();
+	if (rc) {
+		fprintf(stderr, "del_mtab: cannot lock mtab");
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	mntmtab = setmntent(MOUNTED, "r");
+	if (!mntmtab) {
+		fprintf(stderr, "del_mtab: could not update mount table\n");
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	mnttmp = setmntent(mtabtmpfile, "w");
+	if (!mnttmp) {
+		fprintf(stderr, "del_mtab: could not update mount table\n");
+		endmntent(mntmtab);
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	fd = fileno(mnttmp);
+	if (fd < 0) {
+		fprintf(stderr, "del_mtab: mntent does not appear to be valid\n");
+		endmntent(mntmtab);
+		endmntent(mnttmp);
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	while ((mountent = getmntent(mntmtab)) != NULL) {
+		if (!strcmp(mountent->mnt_dir,mountpoint))
+			continue;
+		rc = addmntent(mnttmp, mountent);
+		if (rc) {
+			fprintf(stderr, "del_mtab: unable to add mount entry to mtab\n");
+			rc = EX_FILEIO;
+			break;
+		}
+	}
+
+	rc = fstat(fd, &statbuf);
+	if (rc != 0) {
+		fprintf(stderr, "del_mtab: unable to fstat open tmp file\n");
+		endmntent(mntmtab);
+		endmntent(mnttmp);
+		rc = EX_FILEIO;
+		goto del_mtab_exit;
+	}
+
+	tmprc = my_endmntent(mnttmp, statbuf.st_size);
+	if (tmprc) {
+		fprintf(stderr, "del_mtab: error %d detected on close of tmp file\n",
+				tmprc);
+		rc = EX_FILEIO;
+	}
+	endmntent(mntmtab);
+
+	rename(mtabtmpfile, MOUNTED);
+
+del_mtab_exit:
+	unlock_mtab();
+	return rc;
+}
+
 /* have the child drop root privileges */
 static int
 drop_child_privs(void)
@@ -2021,6 +2123,11 @@ mount_retry:
 	}
 
 do_mtab:
+	if (parsed_info->flags & MS_REMOUNT){
+		rc = del_mtab(mountpoint);
+		if (rc)
+			goto mount_exit;
+	}
 	if (!parsed_info->nomtab && !mtab_unusable())
 		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
 
-- 
1.7.6.4
