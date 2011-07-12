From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mtab: handle ENOSPC/EFBIG condition properly when altering mtab (try #2)
Date: Tue, 12 Jul 2011 07:53:43 -0400
Message-ID: <1310471623-1407-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch is mostly the same as the original. The only difference is
that it also attempts an ftruncate if the addmntent call fails.

It's possible that when mount.cifs goes to append the mtab that there
won't be enough space to do so, and the mntent won't be appended to the
file in its entirety.

Add a my_endmntent routine that will fflush and then fsync the FILE if
that succeeds. If either fails then it will truncate the file back to
its provided size. It will then call endmntent unconditionally.

Have add_mtab call fstat on the opened mtab file in order to get the
size of the file before it has been appended. Assuming that that
succeeds, use my_endmntent to ensure that the file is not corrupted
before closing it. It's possible that we'll have a small race window
where the mtab is incorrect, but it should be quickly corrected.

This was reported some time ago as CVE-2011-1678:

    http://openwall.com/lists/oss-security/2011/03/04/9

...and it seems to fix the reproducer that I was able to come up with.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   27 +++++++++++++++++++++++++--
 mount.h      |    1 +
 mtab.c       |   27 +++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 9d7e107..107a5a5 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1428,10 +1428,11 @@ static int check_mtab(const char *progname, const char *devname,
 static int
 add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstype)
 {
-	int rc = 0;
+	int rc = 0, tmprc, fd;
 	uid_t uid;
 	char *mount_user = NULL;
 	struct mntent mountent;
+	struct stat statbuf;
 	FILE *pmntfile;
 	sigset_t mask, oldmask;
 
@@ -1483,6 +1484,23 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
 		goto add_mtab_exit;
 	}
 
+	fd = fileno(pmntfile);
+	if (fd < 0) {
+		fprintf(stderr, "mntent does not appear to be valid\n");
+		unlock_mtab();
+		rc = EX_FILEIO;
+		goto add_mtab_exit;
+	}
+
+	rc = fstat(fd, &statbuf);
+	if (rc != 0) {
+		fprintf(stderr, "unable to fstat open mtab\n");
+		endmntent(pmntfile);
+		unlock_mtab();
+		rc = EX_FILEIO;
+		goto add_mtab_exit;
+	}
+
 	mountent.mnt_fsname = devname;
 	mountent.mnt_dir = mountpoint;
 	mountent.mnt_type = (char *)(void *)fstype;
@@ -1514,9 +1532,14 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
 	rc = addmntent(pmntfile, &mountent);
 	if (rc) {
 		fprintf(stderr, "unable to add mount entry to mtab\n");
+		ftruncate(fd, statbuf.st_size);
+		rc = EX_FILEIO;
+	}
+	tmprc = my_endmntent(pmntfile, statbuf.st_size);
+	if (tmprc) {
+		fprintf(stderr, "error %d detected on close of mtab\n", tmprc);
 		rc = EX_FILEIO;
 	}
-	endmntent(pmntfile);
 	unlock_mtab();
 	SAFE_FREE(mountent.mnt_opts);
 add_mtab_exit:
diff --git a/mount.h b/mount.h
index d49c2ea..80bdbe7 100644
--- a/mount.h
+++ b/mount.h
@@ -35,5 +35,6 @@
 extern int mtab_unusable(void);
 extern int lock_mtab(void);
 extern void unlock_mtab(void);
+extern int my_endmntent(FILE *stream, off_t size);
 
 #endif /* ! _MOUNT_H_ */
diff --git a/mtab.c b/mtab.c
index 9cd50d8..de545b7 100644
--- a/mtab.c
+++ b/mtab.c
@@ -251,3 +251,30 @@ lock_mtab (void) {
 	return 0;
 }
 
+/*
+ * Call fflush and fsync on the mtab, and then endmntent. If either fflush
+ * or fsync fails, then truncate the file back to "size". endmntent is called
+ * unconditionally, and the errno (if any) from fflush and fsync are returned.
+ */
+int
+my_endmntent(FILE *stream, off_t size)
+{
+	int rc, fd;
+
+	fd = fileno(stream);
+	if (fd < 0)
+		return -EBADF;
+
+	rc = fflush(stream);
+	if (!rc)
+		rc = fsync(fd);
+
+	/* truncate file back to "size" -- best effort here */
+	if (rc) {
+		rc = errno;
+		ftruncate(fd, size);
+	}
+
+	endmntent(stream);
+	return rc;
+}
-- 
1.7.6
