From: Ankit Jain <jankit-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Use systemd's mechanism for getting password,
 if present
Date: Tue, 17 Jul 2012 19:28:09 +0530
Message-ID: <50056F71.9010509@suse.com>
References: <4FE43C1F.8060605@suse.com> <20120625152439.1a68fb6f@tlielax.poochiereds.net> <4FE95EFA.4030809@suse.com> <20120626042835.0a20e3f3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090000030802070401040107"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120626042835.0a20e3f3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090000030802070401040107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jeff,

On 06/26/2012 04:58 PM, Jeff Layton wrote:
[snip]
> It does, but we do have to concern ourselves with older versions of
> systemd that might not, and with distros that might use systemd but not
> add the tool (consider embedded distros). I think we'll need a
> mechanism to fall back to the legacy password mechanism.

I'm guessing that by "legacy" you mean get_pass(..)? But on a regular
systemd install, it takes over stdin/stdout, and the prompt won't come
up on a terminal. But I don't know how it is set up on the other
scenarios you mentioned. So, I'll do that but you will have to test it
;) I tried using /dev/tty, but in/out are redirected AFAIU, so, this
didn't help.

> Also, a way to disable this at compile-time would nice. Maybe a
> --enable-systemd autoconf option would be good that defaults to "on"
> with a simple test to see if the build machine is running systemd?

Sure, autoconf option sounds good. But do we want to check for systemd
running on the *build* machine (and choose default value for
--enable-systemd accordingly)? Systemd running or not sounds like a
runtime behavior, and we fall back to getpass anyway. I haven't added
this in the attached patch, but if you feel that this makes sense, then
I can add it.

Regards,
-- 
Ankit Jain
SUSE Labs



--------------090000030802070401040107
Content-Type: text/x-patch;
 name="cifs-utils-systemd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cifs-utils-systemd.patch"

commit f96147bd08bcfb03e25b040741f4b2185fef0233
Author: Ankit Jain <jankit-l3A5Bk7waGM@public.gmane.org>
Date:   Tue Jul 17 19:21:10 2012 +0530

    mount.cifs: Use systemd's mechanism for getting password, if present.
    
    If systemd is running and /bin/systemd-ask-password if available,
    then use that else fallback on getpass(..).
    
    And add a --enable-systemd configure option, which defaults to yes.

diff --git a/configure.ac b/configure.ac
index 0dd1155..2fea122 100644
--- a/configure.ac
+++ b/configure.ac
@@ -34,6 +34,12 @@ AC_ARG_ENABLE(cifsacl,
 	enable_cifsacl=$enableval,
 	enable_cifsacl="maybe")
 
+AC_ARG_ENABLE(systemd,
+	[AC_HELP_STRING([--enable-systemd],
+			[Enable systemd specific behavior for mount.cifs @<:@default=yes@:>@])],
+	enable_systemd=$enableval,
+	enable_systemd="maybe")
+
 # check for ROOTSBINDIR environment var
 if test -z $ROOTSBINDIR; then
 	ROOTSBINDIR="/sbin"
@@ -178,6 +184,10 @@ if test $enable_cifsupcall != "no"; then
 	AC_CHECK_FUNCS([krb5_auth_con_setaddrs krb5_auth_con_set_req_cksumtype])
 fi
 
+if test $enable_systemd != "no"; then
+	AC_DEFINE(ENABLE_SYSTEMD, 1, [Enable systemd specific behavior for mount.cifs])
+fi
+
 # MIT krb5 < 1.7 does not have this declaration but does have the symbol
 AC_CHECK_DECLS(krb5_auth_con_set_req_cksumtype, [], [], [#include <krb5.h>])
 
diff --git a/mount.cifs.c b/mount.cifs.c
index 6f3f382..a15ba9e 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1687,6 +1687,66 @@ drop_child_privs(void)
 	return 0;
 }
 
+/*
+ * If systemd is running and /bin/systemd-ask-password --
+ * is available, then use that else fallback on getpass(..)
+ *
+ * Returns: @input or NULL on error
+ */
+static char*
+get_password(const char *prompt, char *input, int capacity)
+{
+#ifdef ENABLE_SYSTEMD
+	int is_systemd_running;
+	struct stat a, b;
+
+	/* We simply test whether the systemd cgroup hierarchy is
+	 * mounted */
+	is_systemd_running = (lstat("/sys/fs/cgroup", &a) == 0)
+		&& (lstat("/sys/fs/cgroup/systemd", &b) == 0)
+		&& (a.st_dev != b.st_dev);
+
+	if (is_systemd_running) {
+		char *cmd, *ret;
+		FILE *ask_pass_fp = NULL;
+
+		cmd = ret = NULL;
+		if (asprintf(&cmd, "/bin/systemd-ask-password \"%s\"", prompt) >= 0) {
+			ask_pass_fp = popen (cmd, "re");
+			free (cmd);
+		}
+
+		if (ask_pass_fp) {
+			ret = fgets(input, capacity, ask_pass_fp);
+			pclose(ask_pass_fp);
+		}
+
+		if (ret) {
+			int len = strlen(input);
+			if (input[len - 1] == '\n')
+				input[len - 1] = '\0';
+			return input;
+		}
+	}
+#endif
+
+	/*
+	 * Falling back to getpass(..)
+	 * getpass is obsolete, but there's apparently nothing that replaces it
+	 */
+	char *tmp_pass = getpass(prompt);
+	if (!tmp_pass)
+		return NULL;
+
+	strncpy(input, tmp_pass, capacity - 1);
+	input[capacity - 1] = '\0';
+
+	/* zero-out the static buffer */
+	memset(tmp_pass, 0, strlen(tmp_pass));
+
+	return input;
+}
+
 static int
 assemble_mountinfo(struct parsed_mount_info *parsed_info,
 		   const char *thisprogram, const char *mountpoint,
@@ -1768,14 +1828,20 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 	}
 
 	if (!parsed_info->got_password) {
-		/* getpass is obsolete, but there's apparently nothing that replaces it */
-		char *tmp_pass = getpass("Password: ");
-		if (!tmp_pass) {
+		char tmp_pass[MOUNT_PASSWD_SIZE + 1];
+		char *prompt = NULL;
+
+		if(asprintf(&prompt, "Password for %s@%s: ", parsed_info->username, orig_dev) < 0)
+			prompt = NULL;
+
+		if (get_password(prompt ? prompt : "Password: ", tmp_pass, MOUNT_PASSWD_SIZE + 1)) {
+			rc = set_password(parsed_info, tmp_pass);
+		} else {
 			fprintf(stderr, "Error reading password, exiting\n");
 			rc = EX_SYSERR;
-			goto assemble_exit;
 		}
-		rc = set_password(parsed_info, tmp_pass);
+
+		free(prompt);
 		if (rc)
 			goto assemble_exit;
 	}

--------------090000030802070401040107--
