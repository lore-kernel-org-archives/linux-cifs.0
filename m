From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: don't allow unprivileged users to mount onto dirs to which they can't chdir
Date: Mon,  2 Apr 2012 09:29:59 -0400
Message-ID: <1333373399-5478-1-git-send-email-jlayton@samba.org>
Cc: Jesus Olmos <jesus.olmos-QVTk+HlWL3hBDgjK7y7TUQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If mount.cifs is installed as a setuid root program, then a user can
use it to gather information about files and directories to which he
does not have access.

One of the first things that mount.cifs does is to chdir() into the
mountpoint and then proceeds to perform the mount onto ".". A malicious
user could exploit this fact to determine information about directories
to which he does not have access. Specifically, whether the dentry in
question is a file or directory and whether it exists at all.

This patch fixes this by making the program switch the fsuid to the
real uid for unprivileged users when mounting.

Note that this is a behavior change. mount.cifs has in the past allowed
users to mount onto any directory as long as it's listed in /etc/fstab
as a user mount. With this change, the user must also be able to chdir
into the mountpoint without needing special privileges. Hopefully not
many people have such a pathological configuration.

This patch should fix CVE-2012-1586.

Reported-by: Jesus Olmos <jesus.olmos-QVTk+HlWL3hBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 configure.ac |    4 +++
 mount.cifs.c |   85 +++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 70 insertions(+), 19 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3027eba..1f561f5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,6 +77,10 @@ AC_CHECK_FUNCS(clock_gettime, [], [
 # Checks for header files.
 AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
 
+# do we have sys/fsuid.h and setfsuid()?
+AC_CHECK_HEADERS([sys/fsuid.h])
+AC_CHECK_FUNC(setfsuid, , [AC_MSG_ERROR([System does not support setfsuid()])])
+
 if test $enable_cifsupcall != "no"; then
 	AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
 	if test x$ac_cv_header_krb5_krb5_h != xyes ; then
diff --git a/mount.cifs.c b/mount.cifs.c
index c0aea35..f0b073e 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -45,6 +45,9 @@
 #include <libgen.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
+#ifdef HAVE_SYS_FSUID_H
+#include <sys/fsuid.h>
+#endif /* HAVE_SYS_FSUID_H */
 #ifdef HAVE_LIBCAP_NG
 #include <cap-ng.h>
 #else /* HAVE_LIBCAP_NG */
@@ -1854,6 +1857,68 @@ assemble_exit:
 	return rc;
 }
 
+/*
+ * chdir() into the mountpoint and determine "realpath". We assume here that
+ * "mountpoint" is a statically allocated string and does not need to be freed.
+ */
+static int
+acquire_mountpoint(char **mountpointp)
+{
+	int rc, dacrc;
+	uid_t realuid, oldfsuid;
+	gid_t oldfsgid;
+	char *mountpoint;
+
+	/*
+	 * Acquire the necessary privileges to chdir to the mountpoint. If
+	 * the real uid is root, then we reacquire CAP_DAC_READ_SEARCH. If
+	 * it's not, then we change the fsuid to the real uid to ensure that
+	 * the mounting user actually has access to the mountpoint.
+	 *
+	 * The mount(8) manpage does not state that users must be able to
+	 * chdir into the mountpoint in order to mount onto it, but if we
+	 * allow that, then an unprivileged user could use this program to
+	 * "probe" into directories to which he does not have access.
+	 */
+	realuid = getuid();
+	if (realuid == 0) {
+		dacrc = toggle_dac_capability(0, 1);
+		if (dacrc)
+			return dacrc;
+	} else {
+		oldfsuid = setfsuid(realuid);
+		oldfsgid = setfsgid(getgid());
+	}
+
+	rc = chdir(*mountpointp);
+	if (rc) {
+		fprintf(stderr, "Couldn't chdir to %s: %s\n", *mountpointp,
+			strerror(errno));
+		rc = EX_USAGE;
+		goto restore_privs;
+	}
+
+	mountpoint = realpath(".", NULL);
+	if (!mountpoint) {
+		fprintf(stderr, "Unable to resolve %s to canonical path: %s\n",
+			*mountpointp, strerror(errno));
+		rc = EX_SYSERR;
+	}
+
+	*mountpointp = mountpoint;
+restore_privs:
+	if (realuid == 0) {
+		dacrc = toggle_dac_capability(0, 0);
+		if (dacrc)
+			rc = rc ? rc : dacrc;
+	} else {
+		setfsuid(oldfsuid);
+		setfsgid(oldfsgid);
+	}
+
+	return rc;
+}
+
 int main(int argc, char **argv)
 {
 	int c;
@@ -1953,25 +2018,7 @@ int main(int argc, char **argv)
 	mountpoint = argv[optind + 1];
 
 	/* chdir into mountpoint as soon as possible */
-	rc = toggle_dac_capability(0, 1);
-	if (rc)
-		return rc;
-	rc = chdir(mountpoint);
-	if (rc) {
-		fprintf(stderr, "Couldn't chdir to %s: %s\n", mountpoint,
-			strerror(errno));
-		rc = EX_USAGE;
-		goto mount_exit;
-	}
-
-	mountpoint = realpath(".", NULL);
-	if (!mountpoint) {
-		fprintf(stderr, "Unable to resolve %s to canonical path: %s\n",
-			mountpoint, strerror(errno));
-		rc = EX_SYSERR;
-		goto mount_exit;
-	}
-	rc = toggle_dac_capability(0, 0);
+	rc = acquire_mountpoint(&mountpoint);
 	if (rc)
 		return rc;
 
-- 
1.7.7.6
