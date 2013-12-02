From: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Subject: [PATCH] cifs-utils: pam module to set cifs credentials in key store
Date: Mon, 02 Dec 2013 12:36:38 -0700
Message-ID: <529CE146.8090202@cora.nwra.com>
References: <loom.20131113T002139-562@post.gmane.org>	<20131112212536.6061477e@corrin.poochiereds.net>	<5283E835.2090508@cora.nwra.com> <20131130053237.5ba7359d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010801070302080205050103"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131130053237.5ba7359d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010801070302080205050103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/2013 03:32 AM, Jeff Layton wrote:
> On Wed, 13 Nov 2013 13:59:33 -0700
> Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:
>
>>  From e2e6e73f05d912377656675292994858b99cabbb Mon Sep 17 00:00:00 2001
>> From: Orion Poplawski <orion-CfuHcwXVrUc@public.gmane.org>
>> Date: Wed, 13 Nov 2013 13:53:30 -0700
>> Subject: [PATCH] Create cifscreds PAM module to insert credentials at login
>>
>
> Sorry for taking so long to review this. This looks like a good start.
> FWIW, I'd like to see this merged for the next release, which should
> happen in the next month or two.
>

No problem, thanks for the review.

> When you think this is ready for merge, please resend with a real
> '[PATCH]' tag in the subject, so I don't miss it...

Hopefully this is okay.

>> @@ -231,6 +236,7 @@ AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
>>   AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" != "no"])
>>   AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
>>   AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
>> +AM_CONDITIONAL(CONFIG_PAM, [test "$enable_pam" != "no" -o "$enable_pam" != "no"])
>
> Erm...you're testing the same thing twice here?

Oops, copy/paste error.

>
> I think the autoconf stuff needs some work.
>
> If the box doesn't have what's needed to build it, the build is going
> to fail unless someone explicitly disables CONFIG_PAM.
>
> Ideally, we'd build this by default and have autoconf test for what's
> required to build the PAM module. If the build requires aren't present,
> then the building of the PAM module should be disabled with a warning
> message that states that.
>
> There are some other examples of that sort of behavior in configure.ac.
> It's a little more complicated, but it makes life easier for people
> building the package.

Okay, I've added a section for checking for security/pam_appl.h.  Should we 
also check for the other headers/libraries as well?

I've also added to the keyutils.h section so as to disable the pam module 
there too.


>> +static void
>> +free_password (char *password)
>> +{
>> +	volatile char *vp;
>> +	size_t len;
>> +
>> +	if (!password) {
>> +		return;
>> +	}
>> +
>> +	/* Defeats some optimizations */
>> +	len = strlen (password);
>> +	memset (password, 0xAA, len);
>> +	memset (password, 0xBB, len);
>> +
>> +	/* Defeats others */
>> +	vp = (volatile char*)password;
>> +	while (*vp) {
>> +		*(vp++) = 0xAA;
>> +	}
>> +
>
> I'm all for scrubbing the pw memory but that seems a bit like overkill.
> Got any references to cite about why you need to write over it 3 times?
>
> If that's really necessary, then we should move the password handling
> in cifscreds and mount.cifs binary to use something like this too.
> Maybe consider putting this in an a.out lib and linking it into all 3?

This is copied directly from the gnome-keyring pam module.  I don't have any 
references for why it is done.  My guess is because it is part of a PAM chain, 
so perhaps to prevent later modules from accessing it?  Or perhaps just to 
scrub memory?  I suspect that the multiple times is to defeat compiler 
optimization making it a no-op?

>> +
>> +/**
>> + * This is called when the PAM session is closed.
>> + *
>> + * Currently it does nothing.  The session closing should remove the passwords
>> + *
>> + * @param ph PAM handle
>> + * @param flags currently unused, TODO: check for silent flag
>> + * @param argc number of arguments for this PAM module
>> + * @param argv array of arguments for this PAM module
>> + * @return PAM_SUCCESS
>> + */
>> +PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc, const char **argv)
>> +{
>> +	return PAM_SUCCESS;
>> +}
>> +
>
> Cleaning up after you're done seems like a good thing to do. The thing
> we need to be careful about here is that we might still need these
> creds to write out dirty data. This may require some consideration...

Yeah, I'm not sure what there is to do here really.  Anything would be more 
than what is done currently running cifscreds directly.

>> +/**
>> + * This is called when PAM is invoked to change the user's authentication token.
>> + * TODO - update the credetials
>> + *
>> + * @param ph PAM handle
>> + * @param flags currently unused, TODO: check for silent flag
>> + * @param argc number of arguments for this PAM module
>> + * @param argv array of arguments for this PAM module
>> + * @return PAM_SUCCESS
>> + */
>> + PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const char **argv)
>> +{
>> +	return PAM_SUCCESS;
>> +}
>
> The rest looks reasonably straightforward, but I don't PAM that well,
> so it's hard for me to comment.
>

Actually, I'm not sure what should be done here.  gnome-keyring doesn't do 
anything.  http://pubs.opengroup.org/onlinepubs/008329799/pam_sm_setcred.htm 
describes the call.

Looks like the pam_sm_chauthtok function is used to update the passwords. 
I've made attempts to implement that.

-- 
Orion Poplawski
Technical Manager                     303-415-9701 x222
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion-CfuHcwXVrUc@public.gmane.org
Boulder, CO 80301                   http://www.nwra.com

--------------010801070302080205050103
Content-Type: text/x-patch;
 name="0001-Create-cifscreds-PAM-module-to-insert-credentials-at.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Create-cifscreds-PAM-module-to-insert-credentials-at.pa";
 filename*1="tch"

>From 4a6c651bef574697bfaf8d1be24ca48cc46418e5 Mon Sep 17 00:00:00 2001
From: Orion Poplawski <orion-CfuHcwXVrUc@public.gmane.org>
Date: Wed, 13 Nov 2013 13:53:30 -0700
Subject: [PATCH] Create cifscreds PAM module to insert credentials at login

---
 Makefile.am     |  11 +-
 cifscreds.c     |  49 +----
 cifskey.c       |  52 ++++++
 cifskey.h       |  47 +++++
 configure.ac    |  24 ++-
 pam_cifscreds.c | 550 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 681 insertions(+), 52 deletions(-)
 create mode 100644 cifskey.c
 create mode 100644 cifskey.h
 create mode 100644 pam_cifscreds.c

diff --git a/Makefile.am b/Makefile.am
index 6407520..6e86cd3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -34,7 +34,7 @@ endif
 
 if CONFIG_CIFSCREDS
 bin_PROGRAMS += cifscreds
-cifscreds_SOURCES = cifscreds.c resolve_host.c util.c
+cifscreds_SOURCES = cifscreds.c cifskey.c resolve_host.c util.c
 cifscreds_LDADD = -lkeyutils
 man_MANS += cifscreds.1
 endif
@@ -91,4 +91,13 @@ idmapwb.8: idmapwb.8.in
 
 endif
 
+if CONFIG_PAM
+pamdir = $(libdir)/security
+
+pam_PROGRAMS = pam_cifscreds.so
+
+pam_cifscreds.so: pam_cifscreds.c cifskey.c resolve_host.c util.c
+	$(CC) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ -lpam -lkeyutils
+endif
+
 SUBDIRS = contrib
diff --git a/cifscreds.c b/cifscreds.c
index 60be4e5..fa05dc8 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -29,35 +29,16 @@
 #include <keyutils.h>
 #include <getopt.h>
 #include <errno.h>
+#include "cifskey.h"
 #include "mount.h"
 #include "resolve_host.h"
 #include "util.h"
 
 #define THIS_PROGRAM_NAME "cifscreds"
-#define KEY_PREFIX	  "cifs"
 
 /* max length of appropriate command */
 #define MAX_COMMAND_SIZE 32
 
-/* max length of username, password and domain name */
-#define MAX_USERNAME_SIZE 32
-#define MOUNT_PASSWD_SIZE 128
-#define MAX_DOMAIN_SIZE 64
-
-/*
- * disallowed characters for user and domain names. See:
- * http://technet.microsoft.com/en-us/library/bb726984.aspx
- * http://support.microsoft.com/kb/909264
- */
-#define USER_DISALLOWED_CHARS "\\/\"[]:|<>+=;,?*"
-#define DOMAIN_DISALLOWED_CHARS "\\/:*?\"<>|"
-
-/* destination keyring */
-#define DEST_KEYRING KEY_SPEC_SESSION_KEYRING
-#define CIFS_KEY_TYPE  "logon"
-#define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
-			KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)
-
 struct cmdarg {
 	char		*host;
 	char		*user;
@@ -106,17 +87,6 @@ usage(void)
 	return EXIT_FAILURE;
 }
 
-/* search a specific key in keyring */
-static key_serial_t
-key_search(const char *addr, char keytype)
-{
-	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
-
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
-
-	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
-}
-
 /* search all program's keys in keyring */
 static key_serial_t key_search_all(void)
 {
@@ -170,23 +140,6 @@ key_search_all_out:
 	return ret;
 }
 
-/* add or update a specific key to keyring */
-static key_serial_t
-key_add(const char *addr, const char *user, const char *pass, char keytype)
-{
-	int len;
-	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
-	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
-
-	/* set key description */
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
-
-	/* set payload contents */
-	len = sprintf(val, "%s:%s", user, pass);
-
-	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
-}
-
 /* add command handler */
 static int cifscreds_add(struct cmdarg *arg)
 {
diff --git a/cifskey.c b/cifskey.c
new file mode 100644
index 0000000..7716c42
--- /dev/null
+++ b/cifskey.c
@@ -0,0 +1,52 @@
+/*
+ * Credentials stashing routines for Linux CIFS VFS (virtual filesystem)
+ * Copyright (C) 2010 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
+ * Copyright (C) 2010 Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/types.h>
+#include <keyutils.h>
+#include <stdio.h>
+#include "cifskey.h"
+#include "resolve_host.h"
+
+/* search a specific key in keyring */
+key_serial_t
+key_search(const char *addr, char keytype)
+{
+	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
+
+	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+
+	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
+}
+
+/* add or update a specific key to keyring */
+key_serial_t
+key_add(const char *addr, const char *user, const char *pass, char keytype)
+{
+	int len;
+	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
+	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
+
+	/* set key description */
+	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+
+	/* set payload contents */
+	len = sprintf(val, "%s:%s", user, pass);
+
+	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
+}
diff --git a/cifskey.h b/cifskey.h
new file mode 100644
index 0000000..ed0c469
--- /dev/null
+++ b/cifskey.h
@@ -0,0 +1,47 @@
+/*
+ * Credentials stashing utility for Linux CIFS VFS (virtual filesystem) definitions
+ * Copyright (C) 2010 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
+ * Copyright (C) 2010 Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _CIFSKEY_H
+#define _CIFSKEY_H
+
+#define KEY_PREFIX	  "cifs"
+
+/* max length of username, password and domain name */
+#define MAX_USERNAME_SIZE 32
+#define MOUNT_PASSWD_SIZE 128
+#define MAX_DOMAIN_SIZE 64
+
+/*
+ * disallowed characters for user and domain names. See:
+ * http://technet.microsoft.com/en-us/library/bb726984.aspx
+ * http://support.microsoft.com/kb/909264
+ */
+#define USER_DISALLOWED_CHARS "\\/\"[]:|<>+=;,?*"
+#define DOMAIN_DISALLOWED_CHARS "\\/:*?\"<>|"
+
+/* destination keyring */
+#define DEST_KEYRING KEY_SPEC_SESSION_KEYRING
+#define CIFS_KEY_TYPE  "logon"
+#define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
+			KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)
+
+key_serial_t key_search(const char *addr, char keytype);
+key_serial_t key_add(const char *addr, const char *user, const char *pass, char keytype);
+
+#endif /* _CIFSKEY_H */
diff --git a/configure.ac b/configure.ac
index c5b2244..4a9cb6d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,6 +40,11 @@ AC_ARG_ENABLE(cifsacl,
 	enable_cifsacl=$enableval,
 	enable_cifsacl="maybe")
 
+AC_ARG_ENABLE(pam,
+	[AS_HELP_STRING([--enable-pam],[Create cifscreds PAM module @<:@default=yes@:>@])],
+	enable_pam=$enableval,
+	enable_pam="maybe")
+
 AC_ARG_ENABLE(systemd,
 	[AS_HELP_STRING([--enable-systemd],[Enable systemd specific behavior for mount.cifs @<:@default=yes@:>@])],
 	enable_systemd=$enableval,
@@ -190,18 +195,30 @@ AC_TEST_WBCHL
 # test for presence of WBC_ID_TYPE_BOTH enum value
 AC_TEST_WBC_IDMAP_BOTH
 
-if test $enable_cifscreds != "no"; then
+if test $enable_cifscreds != "no" -o $enable_pam != "no"; then
 	AC_CHECK_HEADERS([keyutils.h], , [
 
-				if test $enable_cifscreds = "yes"; then
+				if test $enable_cifscreds = "yes" -o $enable_pam = "yes"; then
 					AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
 				else
-					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifscreds.])
+					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifscreds and cifscreds PAM module.])
 					enable_cifscreds="no"
+					enable_pam="no"
 				fi
 			])
 fi
 
+if test $enable_pam != "no"; then
+	AC_CHECK_HEADERS([security/pam_appl.h], , [
+
+				if test $enable_pam = "yes"; then
+					AC_MSG_ERROR([security/pam_appl.h not found, consider installing keyutils-libs-devel.])
+				else
+					AC_MSG_WARN([security/pam_appl.h not found, consider installing pam-devel. Disabling cifscreds PAM module.])
+					enable_pam="no"
+				fi
+			])
+fi
 
 # ugly, but I'm not sure how to check for functions in a library that's not in $LIBS
 cu_saved_libs=$LIBS
@@ -231,6 +248,7 @@ AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
+AM_CONDITIONAL(CONFIG_PAM, [test "$enable_pam" != "no"])
 AM_CONDITIONAL(CONFIG_PLUGIN, [test "$enable_cifsidmap" != "no" -o "$enable_cifsacl" != "no"])
 
 LIBCAP_NG_PATH
diff --git a/pam_cifscreds.c b/pam_cifscreds.c
new file mode 100644
index 0000000..1385146
--- /dev/null
+++ b/pam_cifscreds.c
@@ -0,0 +1,550 @@
+/*
+ * Copyright (C) 2013 Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
+ *
+ * based on gkr-pam-module.c, Copyright (C) 2007 Stef Walter
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif /* HAVE_CONFIG_H */
+
+#include <assert.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syslog.h>
+#include <sys/types.h>
+/*
+#include <signal.h>
+#include <unistd.h>
+#include <sys/wait.h>
+*/
+
+#include <keyutils.h>
+
+#include <security/pam_appl.h>
+#include <security/pam_modules.h>
+#include <security/pam_ext.h>
+
+#include "cifskey.h"
+#include "mount.h"
+#include "resolve_host.h"
+#include "util.h"
+
+/**
+ * Flags that can be passed to the PAM module
+ */
+enum {
+	ARG_DOMAIN	   = 1 << 0,	/** Set domain password */
+	ARG_DEBUG	   = 1 << 1	/** Print debug messages */
+};
+
+/**
+ * Parse the arguments passed to the PAM module.
+ *
+ * @param ph PAM handle
+ * @param argc number of arguments
+ * @param argv array of arguments
+ * @param kwalletopener kwalletopener argument, path to the kwalletopener binary
+ * @return ORed flags that have been parsed
+ */
+static uint parse_args (pam_handle_t *ph, int argc, const char **argv, const char **hostdomain)
+{
+	uint args = 0;
+	const void *svc;
+	int i;
+	const char *host = NULL;
+	const char *domain = NULL;
+
+	svc = NULL;
+	if (pam_get_item (ph, PAM_SERVICE, &svc) != PAM_SUCCESS) {
+		svc = NULL;
+	}
+
+	size_t host_len = strlen("host=");
+	size_t domain_len = strlen("domain=");
+
+	/* Parse the arguments */
+	for (i = 0; i < argc; i++) {
+		if (strncmp(argv[i], "host=", host_len) == 0) {
+			host = (argv[i]) + host_len;
+			if (*host == '\0') {
+				host = NULL;
+				pam_syslog(ph, LOG_ERR, ""
+					   "host= specification missing argument");
+			} else {
+				*hostdomain = host;
+			}
+		} else if (strncmp(argv[i], "domain=", domain_len) == 0) {
+			domain = (argv[i]) + domain_len;
+			if (*domain == '\0') {
+				domain = NULL;
+				pam_syslog(ph, LOG_ERR, ""
+					   "domain= specification missing argument");
+			} else {
+				*hostdomain = domain;
+				args |= ARG_DOMAIN;
+			}
+		} else if (strcmp(argv[i], "debug") == 0) {
+			args |= ARG_DEBUG;
+		} else {
+			pam_syslog(ph, LOG_ERR, "invalid option %s",
+				   argv[i]);
+		}
+	}
+
+	if (host && domain) {
+		pam_syslog(ph, LOG_ERR, "cannot specify both host= and "
+			   "domain= arguments");
+	}
+
+	return args;
+}
+
+static void
+free_password (char *password)
+{
+	volatile char *vp;
+	size_t len;
+
+	if (!password) {
+		return;
+	}
+
+	/* Defeats some optimizations */
+	len = strlen (password);
+	memset (password, 0xAA, len);
+	memset (password, 0xBB, len);
+
+	/* Defeats others */
+	vp = (volatile char*)password;
+	while (*vp) {
+		*(vp++) = 0xAA;
+	}
+
+	free (password);
+}
+
+static void
+cleanup_free_password (pam_handle_t *ph, void *data, int pam_end_status)
+{
+	free_password (data);
+}
+
+/**
+ * Set the cifs credentials
+ *
+ * @param ph PAM handle
+ * @param user
+ * @param password
+ * @param args ORed flags for this module
+ * @param hostdomain hostname or domainname
+ */
+static int cifscreds_pam_add(pam_handle_t *ph, const char *user, const char *password,
+			     uint args, const char *hostdomain)
+{
+	int ret = PAM_SUCCESS;
+	char addrstr[MAX_ADDR_LIST_LEN];
+	char *currentaddress, *nextaddress;
+	char keytype = ((args & ARG_DOMAIN) == ARG_DOMAIN) ? 'd' : 'a';
+
+	assert(user);
+	assert(password);
+	assert(hostdomain);
+
+	if (keytype == 'd') {
+		if (strpbrk(hostdomain, DOMAIN_DISALLOWED_CHARS)) {
+			pam_syslog(ph, LOG_ERR, "Domain name contains invalid characters");
+			return PAM_SERVICE_ERR;
+		}
+		strlcpy(addrstr, hostdomain, MAX_ADDR_LIST_LEN);
+	} else {
+		ret = resolve_host(hostdomain, addrstr);
+	}
+
+	switch (ret) {
+	case EX_USAGE:
+		pam_syslog(ph, LOG_ERR, "Could not resolve address for %s", hostdomain);
+		return PAM_SERVICE_ERR;
+
+	case EX_SYSERR:
+		pam_syslog(ph, LOG_ERR, "Problem parsing address list");
+		return PAM_SERVICE_ERR;
+	}
+
+	if (strpbrk(user, USER_DISALLOWED_CHARS)) {
+		pam_syslog(ph, LOG_ERR, "Incorrect username");
+		return PAM_SERVICE_ERR;
+	}
+
+	/* search for same credentials stashed for current host */
+	currentaddress = addrstr;
+	nextaddress = strchr(currentaddress, ',');
+	if (nextaddress)
+		*nextaddress++ = '\0';
+
+	while (currentaddress) {
+		if (key_search(currentaddress, keytype) > 0) {
+			pam_syslog(ph, LOG_WARNING, "You already have stashed credentials "
+				"for %s (%s)", currentaddress, hostdomain);
+
+			return PAM_SERVICE_ERR;
+		}
+
+		currentaddress = nextaddress;
+		if (currentaddress) {
+			*(currentaddress - 1) = ',';
+			nextaddress = strchr(currentaddress, ',');
+			if (nextaddress)
+				*nextaddress++ = '\0';
+		}
+	}
+
+	/* Set the password */
+	currentaddress = addrstr;
+	nextaddress = strchr(currentaddress, ',');
+	if (nextaddress)
+		*nextaddress++ = '\0';
+
+	while (currentaddress) {
+		key_serial_t key = key_add(currentaddress, user, password, keytype);
+		if (key <= 0) {
+			pam_syslog(ph, LOG_ERR, "error: Add credential key for %s",
+				currentaddress);
+		} else {
+			if ((args & ARG_DEBUG) == ARG_DEBUG) {
+				pam_syslog(ph, LOG_DEBUG, "credential key for \\\\%s\\%s added",
+					   currentaddress, user);
+			}
+			if (keyctl(KEYCTL_SETPERM, key, CIFS_KEY_PERMS) < 0) {
+				pam_syslog(ph, LOG_ERR,"error: Setting permissons "
+					"on key, attempt to delete...");
+
+				if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
+					pam_syslog(ph, LOG_ERR, "error: Deleting key from "
+						"keyring for %s (%s)",
+						currentaddress, hostdomain);
+				}
+			}
+		}
+
+		currentaddress = nextaddress;
+		if (currentaddress) {
+			nextaddress = strchr(currentaddress, ',');
+			if (nextaddress)
+				*nextaddress++ = '\0';
+		}
+	}
+
+	return PAM_SUCCESS;
+}
+
+/**
+ * Update the cifs credentials
+ *
+ * @param ph PAM handle
+ * @param user
+ * @param password
+ * @param args ORed flags for this module
+ * @param hostdomain hostname or domainname
+ */
+static int cifscreds_pam_update(pam_handle_t *ph, const char *user, const char *password,
+				uint args, const char *hostdomain)
+{
+	int ret = PAM_SUCCESS;
+	char addrstr[MAX_ADDR_LIST_LEN];
+	char *currentaddress, *nextaddress;
+	char *addrs[16];
+	int id, count = 0;
+	char keytype = ((args & ARG_DOMAIN) == ARG_DOMAIN) ? 'd' : 'a';
+
+	assert(user);
+	assert(password);
+	assert(hostdomain);
+
+	if (keytype == 'd') {
+		if (strpbrk(hostdomain, DOMAIN_DISALLOWED_CHARS)) {
+			pam_syslog(ph, LOG_ERR, "Domain name contains invalid characters");
+			return PAM_SERVICE_ERR;
+		}
+		strlcpy(addrstr, hostdomain, MAX_ADDR_LIST_LEN);
+	} else {
+		ret = resolve_host(hostdomain, addrstr);
+	}
+
+	switch (ret) {
+	case EX_USAGE:
+		pam_syslog(ph, LOG_ERR, "Could not resolve address for %s", hostdomain);
+		return PAM_SERVICE_ERR;
+
+	case EX_SYSERR:
+		pam_syslog(ph, LOG_ERR, "Problem parsing address list");
+		return PAM_SERVICE_ERR;
+	}
+
+	if (strpbrk(user, USER_DISALLOWED_CHARS)) {
+		pam_syslog(ph, LOG_ERR, "Incorrect username");
+		return PAM_SERVICE_ERR;
+	}
+
+	/* search for necessary credentials stashed in session keyring */
+	currentaddress = addrstr;
+	nextaddress = strchr(currentaddress, ',');
+	if (nextaddress)
+		*nextaddress++ = '\0';
+
+	while (currentaddress) {
+		if (key_search(currentaddress, keytype) > 0) {
+			addrs[count] = currentaddress;
+			count++;
+		}
+
+		currentaddress = nextaddress;
+		if (currentaddress) {
+			nextaddress = strchr(currentaddress, ',');
+			if (nextaddress)
+				*nextaddress++ = '\0';
+		}
+	}
+
+	if (!count) {
+		pam_syslog(ph, LOG_ERR, "You have no same stached credentials for %s", hostdomain);
+		return PAM_SERVICE_ERR;
+	}
+
+	for (id = 0; id < count; id++) {
+		key_serial_t key = key_add(currentaddress, user, password, keytype);
+		if (key <= 0) {
+			pam_syslog(ph, LOG_ERR, "error: Update credential key for %s",
+				currentaddress);
+		}
+	}
+
+	return PAM_SUCCESS;
+}
+
+/**
+ * PAM function called during authentication.
+ *
+ * This function first tries to get a password from PAM. Afterwards two
+ * scenarios are possible:
+ *
+ * - A session is already available which usually means that the user is already
+ *	logged on and PAM has been used inside the screensaver. In that case, no need to 
+ *	do anything(?).
+ *
+ * - A session is not yet available. Store the password inside PAM data so
+ *	it can be retrieved during pam_open_session to set the credentials.
+ *
+ * @param ph PAM handle
+ * @param unused unused
+ * @param argc number of arguments for this PAM module
+ * @param argv array of arguments for this PAM module
+ * @return any of the PAM return values
+ */
+PAM_EXTERN int pam_sm_authenticate(pam_handle_t *ph, int unused, int argc, const char **argv)
+{
+	const char *hostdomain;
+	const char *user;
+	const char *password;
+	uint args;
+	int ret;
+
+	args = parse_args(ph, argc, argv, &hostdomain);
+	
+	/* Figure out and/or prompt for the user name */
+	ret = pam_get_user(ph, &user, NULL);
+	if (ret != PAM_SUCCESS || !user) {
+		pam_syslog(ph, LOG_ERR, "couldn't get the user name: %s",
+			   pam_strerror(ph, ret));
+		return PAM_SERVICE_ERR;
+	}
+
+	/* Lookup the password */
+	ret = pam_get_item(ph, PAM_AUTHTOK, (const void**)&password);
+	if (ret != PAM_SUCCESS || password == NULL) {
+		if (ret == PAM_SUCCESS) {
+			pam_syslog(ph, LOG_WARNING, "no password is available for user");
+		} else {
+			pam_syslog(ph, LOG_WARNING, "no password is available for user: %s",
+				   pam_strerror(ph, ret));
+		}
+		return PAM_SUCCESS;
+	}
+
+	/* set password as pam data and launch during open_session. */
+	if (pam_set_data(ph, "cifscreds_password", strdup(password), cleanup_free_password) != PAM_SUCCESS) {
+		pam_syslog(ph, LOG_ERR, "error storing password");
+		return PAM_AUTHTOK_RECOVER_ERR;
+	}
+
+	if ((args & ARG_DEBUG) == ARG_DEBUG) {
+		pam_syslog(ph, LOG_DEBUG, "password stored");
+	}
+
+	return PAM_SUCCESS;
+}
+
+/**
+ * PAM function called during opening the session.
+ *
+ * Retrieves the password stored during authentication from PAM data, then uses
+ * it set the cifs key.
+ *
+ * @param ph PAM handle
+ * @param flags currently unused, TODO: check for silent flag
+ * @param argc number of arguments for this PAM module
+ * @param argv array of arguments for this PAM module
+ * @return any of the PAM return values
+ */
+PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags, int argc, const char **argv)
+{
+	const char *user = NULL;
+	const char *password = NULL;
+	const char *hostdomain = NULL;
+	uint args;
+	int retval;
+	key_serial_t	ses_key, uses_key;
+
+	args = parse_args(ph, argc, argv, &hostdomain);
+
+	/* Figure out the user name */
+	retval = pam_get_user(ph, &user, NULL);
+	if (retval != PAM_SUCCESS || !user) {
+		pam_syslog(ph, LOG_ERR, "couldn't get the user name: %s",
+			   pam_strerror(ph, retval));
+		return PAM_SERVICE_ERR;
+	}
+
+	/* retrieve the stored password */
+	if (pam_get_data(ph, "cifscreds_password", (const void**)&password) != PAM_SUCCESS) {
+		/*
+		 * No password, no worries, maybe this (PAM using) application
+		 * didn't do authentication, or is hopeless and wants to call
+		 * different PAM callbacks from different processes.
+		 *
+		 *
+		 */
+		password = NULL;
+		if ((args & ARG_DEBUG) == ARG_DEBUG) {
+			pam_syslog(ph, LOG_DEBUG, "no stored password found");
+		}
+		return PAM_SUCCESS;
+	}
+
+	/* make sure we have a host or domain name */
+	if (!hostdomain) {
+		pam_syslog(ph, LOG_ERR, "one of host= or domain= must be specified");
+		return PAM_SERVICE_ERR;
+	}
+
+	/* make sure there is a session keyring */
+	ses_key = keyctl_get_keyring_ID(KEY_SPEC_SESSION_KEYRING, 0);
+	if (ses_key == -1) {
+		if (errno == ENOKEY)
+			pam_syslog(ph, LOG_ERR, "you have no session keyring. "
+					"Consider using pam_keyinit to "
+					"install one.");
+		else
+			pam_syslog(ph, LOG_ERR, "unable to query session "
+					"keyring: %s", strerror(errno));
+	}
+
+	/* A problem querying the user-session keyring isn't fatal. */
+	uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
+	if ((uses_key >= 0) && (ses_key == uses_key))
+		pam_syslog(ph, LOG_ERR, "you have no persistent session "
+				"keyring. cifscreds keys will not persist.");
+
+	return cifscreds_pam_add(ph, user, password, args, hostdomain);
+}
+
+/**
+ * This is called when the PAM session is closed.
+ *
+ * Currently it does nothing.  The session closing should remove the passwords
+ *
+ * @param ph PAM handle
+ * @param flags currently unused, TODO: check for silent flag
+ * @param argc number of arguments for this PAM module
+ * @param argv array of arguments for this PAM module
+ * @return PAM_SUCCESS
+ */
+PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc, const char **argv)
+{
+	return PAM_SUCCESS;
+}
+
+/**
+ * This is called when pam_set_cred() is invoked.
+ *
+ * @param ph PAM handle
+ * @param flags currently unused, TODO: check for silent flag
+ * @param argc number of arguments for this PAM module
+ * @param argv array of arguments for this PAM module
+ * @return PAM_SUCCESS
+ */
+PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const char **argv)
+{
+	return PAM_SUCCESS;
+}
+
+/**
+ * This is called when the user's password is changed
+ *
+ * @param ph PAM handle
+ * @param flags currently unused, TODO: check for silent flag
+ * @param argc number of arguments for this PAM module
+ * @param argv array of arguments for this PAM module
+ * @return PAM_SUCCESS
+ */
+PAM_EXTERN int
+pam_sm_chauthtok (pam_handle_t *ph, int flags, int argc, const char **argv)
+{
+	const char *hostdomain = NULL;
+	const char *user = NULL;
+	const char *password = NULL;
+	uint args;
+	int ret;
+	
+	args = parse_args(ph, argc, argv, &hostdomain);
+
+	if (flags & PAM_UPDATE_AUTHTOK) {
+		/* Figure out the user name */
+		ret = pam_get_user(ph, &user, NULL);
+		if (ret != PAM_SUCCESS) {
+			pam_syslog(ph, LOG_ERR, "couldn't get the user name: %s", 
+				pam_strerror (ph, ret));
+			return PAM_SERVICE_ERR;
+		}
+
+		ret = pam_get_item(ph, PAM_AUTHTOK, (const void**)&password);
+		if (ret != PAM_SUCCESS || password == NULL) {
+			if (ret == PAM_SUCCESS) {
+				pam_syslog(ph, LOG_WARNING, "no password is available for user");
+			} else {
+				pam_syslog(ph, LOG_WARNING, "no password is available for user: %s",
+					pam_strerror(ph, ret));
+			}
+			return PAM_AUTHTOK_RECOVER_ERR;
+		}
+	
+		return cifscreds_pam_update(ph, user, password, args, hostdomain);
+	}
+	else 
+		return PAM_IGNORE;
+}
-- 
1.8.3.1


--------------010801070302080205050103--
