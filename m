From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 2/6] cifs-utils: new plugin architecture for ID mapping code
Date: Thu, 20 Dec 2012 07:50:29 -0500
Message-ID: <1356007833-10893-3-git-send-email-jlayton@samba.org>
References: <1356007833-10893-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356007833-10893-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the ACL-related tools in cifs-utils call into the wbclient
libs directly in order to do their bidding. The wbclient developers want
to get away from needing to configure winbind on the clients and instead
allow sssd to handle the mapping in most cases.

This patch represents an initial step in that direction. It adds a
plugin architecture for cifs-utils, adds wrappers around the calls into
libwbclient that find an idmap plugin library to use and then has it
call into that plugin to do the actual ID mapping.

The application will call into a set of routines that find the correct
plugin and dlopen() it. Currently the plugin is located in a well-known
location that is settable via autoconf. That location is intended to be
a symlink that points to the real plugin (generally under $pkglibdir).

The plugin will export a number of functions with well-known names. The
wrappers find those by using dlsym() and then call them.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am    |  13 +++++--
 cifsidmap.h    |  45 ++++++++++++++++++++++
 configure.ac   |   9 +++++
 getcifsacl.c   |  98 +++++++++++++++++++++---------------------------
 idmap_plugin.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 idmap_plugin.h |  46 +++++++++++++++++++++++
 idmapwb.c      | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 371 insertions(+), 58 deletions(-)
 create mode 100644 idmap_plugin.c
 create mode 100644 idmap_plugin.h
 create mode 100644 idmapwb.c

diff --git a/Makefile.am b/Makefile.am
index 8964b37..bc5e517 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -57,9 +57,8 @@ endif
 
 if CONFIG_CIFSACL
 bin_PROGRAMS += getcifsacl
-getcifsacl_SOURCES = getcifsacl.c
-getcifsacl_LDADD = $(WBCLIENT_LIBS)
-getcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
+getcifsacl_SOURCES = getcifsacl.c idmap_plugin.c
+getcifsacl_LDADD = -ldl
 man_MANS += getcifsacl.1
 
 bin_PROGRAMS += setcifsacl
@@ -69,4 +68,12 @@ setcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
 man_MANS += setcifsacl.1
 endif
 
+if CONFIG_PLUGIN
+plugindir = $(pkglibdir)
+plugin_PROGRAMS = idmapwb.so
+
+idmapwb.so: idmapwb.c
+	$(CC) $(CFLAGS) $(AM_CFLAGS) $(WBCLIENT_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ $(WBCLIENT_LIBS)
+endif
+
 SUBDIRS = contrib
diff --git a/cifsidmap.h b/cifsidmap.h
index 9907618..c307333 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -34,4 +34,49 @@ struct cifs_sid {
 	uint32_t sub_auth[SID_MAX_SUB_AUTHORITIES];
 } __attribute__((packed));
 
+/* Plugins should implement the following functions: */
+
+/**
+ * cifs_idmap_init_plugin - Initialize the plugin interface
+ * @handle - return pointer for an opaque handle
+ * @errmsg - pointer to error message pointer
+ *
+ * This function should do whatever is required to establish a context
+ * for later ID mapping operations. The "handle" is an opaque context
+ * cookie that will be passed in on subsequent ID mapping operations.
+ * The errmsg is used to pass back an error string both during the init
+ * and in subsequent idmapping functions. On any error, the plugin
+ * should point *errmsg at a string describing that error. Returns 0
+ * on success and non-zero on error.
+ *
+ * int cifs_idmap_init_plugin(void **handle, const char **errmsg);
+ */
+
+/**
+ * cifs_idmap_exit_plugin - Destroy an idmapping context
+ * @handle - context handle that should be destroyed
+ *
+ * When programs are finished with the idmapping plugin, they'll call
+ * this function to destroy any context that was created during the
+ * init_plugin. The handle passed back in was the one given by the init
+ * routine.
+ *
+ * void cifs_idmap_exit_plugin(void *handle);
+ */
+
+/**
+ * cifs_idmap_sid_to_str - convert cifs_sid to a string
+ * @handle - context handle
+ * @sid    - pointer to a cifs_sid
+ * @name   - return pointer for the name
+ *
+ * This function should convert the given cifs_sid to a string
+ * representation in a heap-allocated buffer. The caller of this
+ * function is expected to free "name" on success. Returns 0 on
+ * success and non-zero on error.
+ *
+ * int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *sid,
+ * 				char **name);
+ */
+
 #endif /* _CIFSIDMAP_H */
diff --git a/configure.ac b/configure.ac
index b6791ab..9652ad2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,6 +52,14 @@ AC_ARG_ENABLE(systemd,
 	enable_systemd=$enableval,
 	enable_systemd="maybe")
 
+# "with" options
+AC_ARG_WITH(idmap-plugin,
+	[AC_HELP_STRING([--with-idmap-plugin=/path/to/plugin],
+			[Define the path to the plugin that the idmapping infrastructure should use @<:@default=/etc/cifs-utils/idmap-plugin@:>@])],
+	pluginpath=$withval,
+	pluginpath="/etc/cifs-utils/idmap-plugin")
+AC_DEFINE_UNQUOTED(IDMAP_PLUGIN_PATH, "$pluginpath", [Location of plugin that ID mapping infrastructure should use. (usually a symlink to real plugin)])
+
 # check for ROOTSBINDIR environment var
 if test -z $ROOTSBINDIR; then
 	ROOTSBINDIR="/sbin"
@@ -230,6 +238,7 @@ AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
+AM_CONDITIONAL(CONFIG_PLUGIN, [test "$enable_cifsidmap" != "no" -o "$enable_cifsacl" != "no"])
 
 LIBCAP_NG_PATH
 
diff --git a/getcifsacl.c b/getcifsacl.c
index 550429c..b8998ef 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -33,10 +33,13 @@
 #include <stddef.h>
 #include <errno.h>
 #include <limits.h>
-#include <wbclient.h>
 #include <ctype.h>
 #include <sys/xattr.h>
 #include "cifsacl.h"
+#include "idmap_plugin.h"
+
+static void *plugin_handle;
+static bool plugin_loaded;
 
 static void
 print_each_ace_mask(uint32_t mask)
@@ -169,61 +172,33 @@ print_ace_type(uint8_t acetype, int raw)
 	}
 }
 
-/*
- * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
- * csid to the wsid, while converting the subauthority fields from LE.
- */
 static void
-csid_to_wsid(struct wbcDomainSid *wsid, const struct cifs_sid *csid)
+print_sid(struct cifs_sid *csid, int raw)
 {
-	int i;
-	uint8_t num_subauth = (csid->num_subauth <= WBC_MAXSUBAUTHS) ?
-				csid->num_subauth : WBC_MAXSUBAUTHS;
-
-	wsid->sid_rev_num = csid->revision;
-	wsid->num_auths = num_subauth;
-	for (i = 0; i < NUM_AUTHS; i++)
-		wsid->id_auth[i] = csid->authority[i];
-	for (i = 0; i < num_subauth; i++)
-		wsid->sub_auths[i] = le32toh(csid->sub_auth[i]);
-}
-
-static void
-print_sid(struct cifs_sid *sidptr, int raw)
-{
-	int i;
-	wbcErr rc;
-	char *domain_name = NULL;
-	char *sidname = NULL;
-	enum wbcSidType sntype;
+	int i, rc;
+	char *name;
 	unsigned long long id_auth_val;
-	struct wbcDomainSid wsid;
 
-	csid_to_wsid(&wsid, sidptr);
+	if (raw || !plugin_loaded)
+		goto print_sid_raw;
 
-	if (raw)
+	rc = sid_to_str(plugin_handle, csid, &name);
+	if (rc)
 		goto print_sid_raw;
 
-	rc = wbcLookupSid(&wsid, &domain_name, &sidname, &sntype);
-	if (WBC_ERROR_IS_OK(rc)) {
-		printf("%s", domain_name);
-		if (strlen(domain_name))
-			printf("%c", '\\');
-		printf("%s", sidname);
-		wbcFreeMemory(domain_name);
-		wbcFreeMemory(sidname);
-		return;
-	}
+	printf("%s", name);
+	free(name);
+	return;
 
 print_sid_raw:
-	printf("S-%hhu", wsid.sid_rev_num);
+	printf("S-%hhu", csid->revision);
 
-	id_auth_val = (unsigned long long)wsid.id_auth[5];
-	id_auth_val += (unsigned long long)wsid.id_auth[4] << 8;
-	id_auth_val += (unsigned long long)wsid.id_auth[3] << 16;
-	id_auth_val += (unsigned long long)wsid.id_auth[2] << 24;
-	id_auth_val += (unsigned long long)wsid.id_auth[1] << 32;
-	id_auth_val += (unsigned long long)wsid.id_auth[0] << 48;
+	id_auth_val = (unsigned long long)csid->authority[5];
+	id_auth_val += (unsigned long long)csid->authority[4] << 8;
+	id_auth_val += (unsigned long long)csid->authority[3] << 16;
+	id_auth_val += (unsigned long long)csid->authority[2] << 24;
+	id_auth_val += (unsigned long long)csid->authority[1] << 32;
+	id_auth_val += (unsigned long long)csid->authority[0] << 48;
 
 	/*
 	 * MS-DTYP states that if the authority is >= 2^32, then it should be
@@ -234,8 +209,8 @@ print_sid_raw:
 	else
 		printf("-0x%llx", id_auth_val);
 
-	for (i = 0; i < wsid.num_auths; i++)
-		printf("-%u", wsid.sub_auths[i]);
+	for (i = 0; i < csid->num_subauth; i++)
+		printf("-%u", le32toh(csid->sub_auth[i]));
 }
 
 static void
@@ -368,7 +343,8 @@ getcifsacl_usage(const char *prog)
 int
 main(const int argc, char *const argv[])
 {
-	int c, raw = 0;
+	int c, ret = 0;
+	bool raw = false;
 	ssize_t attrlen;
 	size_t bufsize = BUFSIZE;
 	char *filename, *attrval;
@@ -379,7 +355,7 @@ main(const int argc, char *const argv[])
 			printf("Version: %s\n", VERSION);
 			goto out;
 		case 'r':
-			raw = 1;
+			raw = true;
 			break;
 		default:
 			break;
@@ -392,20 +368,31 @@ main(const int argc, char *const argv[])
 		filename = argv[1];
 	else {
 		getcifsacl_usage(basename(argv[0]));
-		return 0;
+		goto out;
+	}
+
+	if (!raw && !plugin_loaded) {
+		ret = init_plugin(&plugin_handle);
+		if (ret)
+			printf("WARNING: unable to initialize idmapping plugin: %s\n",
+				plugin_errmsg);
+		else
+			plugin_loaded = true;
 	}
 
 cifsacl:
 	if (bufsize >= XATTR_SIZE_MAX) {
 		printf("buffer to allocate exceeds max size of %d\n",
 				XATTR_SIZE_MAX);
-		return -1;
+		ret = -1;
+		goto out;
 	}
 
 	attrval = malloc(bufsize * sizeof(char));
 	if (!attrval) {
 		printf("error allocating memory for attribute value buffer\n");
-		return -1;
+		ret = -1;
+		goto out;
 	}
 
 	attrlen = getxattr(filename, ATTRNAME, attrval, bufsize);
@@ -421,7 +408,8 @@ cifsacl:
 	parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
 
 	free(attrval);
-
 out:
-	return 0;
+	if (plugin_loaded)
+		exit_plugin(plugin_handle);
+	return ret;
 }
diff --git a/idmap_plugin.c b/idmap_plugin.c
new file mode 100644
index 0000000..237c921
--- /dev/null
+++ b/idmap_plugin.c
@@ -0,0 +1,103 @@
+/*
+ * ID Mapping Plugin interface for cifs-utils
+ * Copyright (C) 2012 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
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
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif /* HAVE_CONFIG_H */
+
+#include <dlfcn.h>
+#include <errno.h>
+#include <stdint.h>
+
+#include "cifsidmap.h"
+
+const char *plugin_errmsg;
+static void *plugin;
+
+static void *
+resolve_symbol(const char *symbol_name)
+{
+	void *symbol;
+
+	dlerror();
+	symbol = dlsym(plugin, symbol_name);
+	if (!symbol)
+		plugin_errmsg = dlerror();
+	return symbol;
+}
+
+/*
+ * open the plugin. Note that we leave it open over the life of the
+ * program. It gets closed on exit.
+ */
+static int
+open_plugin(void)
+{
+	if (plugin)
+		return 0;
+
+	plugin = dlopen(IDMAP_PLUGIN_PATH, RTLD_LAZY);
+	if (!plugin) {
+		plugin_errmsg = dlerror();
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int
+init_plugin(void **handle)
+{
+	int ret;
+	int (*init)(void **, const char **);
+
+	ret = open_plugin();
+	if (ret)
+		return ret;
+
+	init = resolve_symbol("cifs_idmap_init_plugin");
+	if (!init) {
+		plugin_errmsg = "cifs_idmap_init_plugin not implemented";
+		return -ENOSYS;
+	}
+	return (*init)(handle, &plugin_errmsg);
+}
+
+void
+exit_plugin(void *handle)
+{
+	int (*exit)(void *);
+
+	exit = resolve_symbol("cifs_idmap_exit_plugin");
+	if (exit)
+		(*exit)(handle);
+}
+
+int
+sid_to_str(void *handle, const struct cifs_sid *sid, char **name)
+{
+	int (*entry)(void *, const struct cifs_sid *, char **);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_sid_to_str");
+	if (!entry) {
+		plugin_errmsg = "cifs_idmap_sid_to_str not implemented";
+		return -ENOSYS;
+	}
+
+	return (*entry)(handle, sid, name);
+}
diff --git a/idmap_plugin.h b/idmap_plugin.h
new file mode 100644
index 0000000..277bb12
--- /dev/null
+++ b/idmap_plugin.h
@@ -0,0 +1,46 @@
+/*
+ * ID Mapping Plugin interface for cifs-utils
+ * Copyright (C) 2012 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
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
+#include "cifsidmap.h"
+
+#ifndef _IDMAP_PLUGIN_H
+#define _IDMAP_PLUGIN_H
+
+/*
+ * On error, plugin functions will set this pointer to a string description
+ * of the error. The string should not be freed.
+ */
+extern const char *plugin_errmsg;
+
+/*
+ * External API. Programs should call this to use the plugin functionality.
+ */
+
+/*
+ * Initialize plugin. Returns an opaque handle that should be passed to
+ * other idmapping functions.
+ */
+extern int init_plugin(void **handle);
+
+/* Close out an init'ed handle */
+extern void exit_plugin(void *handle);
+
+/* Convert cifs_sid to a string. Caller must free *name on success */
+extern int sid_to_str(void *handle, const struct cifs_sid *sid, char **name);
+
+#endif /* _IDMAP_PLUGIN_H */
diff --git a/idmapwb.c b/idmapwb.c
new file mode 100644
index 0000000..858028f
--- /dev/null
+++ b/idmapwb.c
@@ -0,0 +1,115 @@
+/*
+ * Winbind ID Mapping Plugin
+ * Copyright (C) 2012 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
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
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif /* HAVE_CONFIG_H */
+
+#include <stdint.h>
+#include <endian.h>
+#include <string.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <wbclient.h>
+
+#include "cifsidmap.h"
+
+static const char **plugin_errmsg;
+
+/*
+ * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
+ * csid to the wsid, while converting the subauthority fields from LE.
+ */
+static void
+csid_to_wsid(struct wbcDomainSid *wsid, const struct cifs_sid *csid)
+{
+	int i;
+	uint8_t num_subauth = (csid->num_subauth <= WBC_MAXSUBAUTHS) ?
+				csid->num_subauth : WBC_MAXSUBAUTHS;
+
+	wsid->sid_rev_num = csid->revision;
+	wsid->num_auths = num_subauth;
+	for (i = 0; i < NUM_AUTHS; i++)
+		wsid->id_auth[i] = csid->authority[i];
+	for (i = 0; i < num_subauth; i++)
+		wsid->sub_auths[i] = le32toh(csid->sub_auth[i]);
+}
+
+int
+cifs_idmap_sid_to_str(void *handle __attribute__ ((unused)),
+			const struct cifs_sid *csid, char **string)
+{
+	int rc;
+	wbcErr wbcrc;
+	char *domain = NULL;
+	char *name = NULL;
+	enum wbcSidType sntype;
+	struct wbcDomainSid wsid;
+	size_t len;
+
+	csid_to_wsid(&wsid, csid);
+
+	wbcrc = wbcLookupSid(&wsid, &domain, &name, &sntype);
+	if (!WBC_ERROR_IS_OK(wbcrc)) {
+		*plugin_errmsg = wbcErrorString(wbcrc);
+		return -EIO;
+	}
+
+	/* +1 for '\\' and +1 for NULL terminator */
+	len = strlen(domain) + 1 + strlen(name) + 1;
+
+	*string = malloc(len);
+	if (!*string) {
+		*plugin_errmsg = "Unable to allocate memory";
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = snprintf(*string, len, "%s\\%s", domain, name);
+	if (rc >= (long)len) {
+		free(*string);
+		*plugin_errmsg = "Resulting string was truncated";
+		*string = NULL;
+		rc = -EIO;
+	} else {
+		rc = 0;
+	}
+out:
+	wbcFreeMemory(domain);
+	wbcFreeMemory(name);
+	return rc;
+}
+
+/*
+ * For the winbind plugin, we don't need to do anything special on
+ * init or exit
+ */
+int
+cifs_idmap_init_plugin(void **handle __attribute__((unused)), const char **errmsg)
+{
+	plugin_errmsg = errmsg;
+	return 0;
+}
+
+void
+cifs_idmap_exit_plugin(void *handle __attribute__((unused)))
+{
+	return;
+}
-- 
1.7.11.7
