From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: switch to using _PATH_MNTTAB and paths.h
Date: Wed,  7 Jul 2010 10:34:02 -0400
Message-ID: <1278513242-27622-1-git-send-email-jlayton@samba.org>
Cc: linux-PcxqyTrCPbsXhy9q4Lf3Ug@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The code currently uses fstab.h and _PATH_FSTAB, but uClibc apparently
doesn't have that header. It does have paths.h and _PATH_MNTTAB however
and so does glibc, so use that instead.

Reported-and-Tested-by: Armin Kuster <linux-PcxqyTrCPbsXhy9q4Lf3Ug@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 51fc1a8..c84e72d 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -41,7 +41,7 @@
 #include <mntent.h>
 #include <fcntl.h>
 #include <limits.h>
-#include <fstab.h>
+#include <paths.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #ifdef HAVE_LIBCAP_NG
@@ -212,9 +212,9 @@ check_fstab(const char *progname, const char *mountpoint, const char *devname,
 	struct mntent *mnt;
 
 	/* make sure this mount is listed in /etc/fstab */
-	fstab = setmntent(_PATH_FSTAB, "r");
+	fstab = setmntent(_PATH_MNTTAB, "r");
 	if (!fstab) {
-		fprintf(stderr, "Couldn't open %s for reading!\n", _PATH_FSTAB);
+		fprintf(stderr, "Couldn't open %s for reading!\n", _PATH_MNTTAB);
 		return EX_FILEIO;
 	}
 
@@ -226,7 +226,7 @@ check_fstab(const char *progname, const char *mountpoint, const char *devname,
 
 	if (mnt == NULL || strcmp(mnt->mnt_fsname, devname)) {
 		fprintf(stderr, "%s: permission denied: no match for "
-			"%s found in %s\n", progname, mountpoint, _PATH_FSTAB);
+			"%s found in %s\n", progname, mountpoint, _PATH_MNTTAB);
 		return EX_USAGE;
 	}
 
-- 
1.6.6.1
