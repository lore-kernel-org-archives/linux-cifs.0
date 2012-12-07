From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: new plugin architecture for ID mapping code
Date: Fri,  7 Dec 2012 10:30:16 -0500
Message-ID: <1354894216-31870-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Ok, first "official" posting for the plugin architecture. Changes since
the original RFC set:

1/ init_plugin() and exit_plugin() functions have been added to the
   plugin API. The init passes back an opaque handle so we can
   potentially use this in threaded programs later if needed.

2/ the plugin function names are more distinct, now prefixed with
   "cifs_idmap_".

3/ the code has been changed to never dlclose() the plugin and rely
   on it to be closed at exit. That makes things a lot simpler...

Original description follows...

-----------------------[snip]----------------------

Currently, the ACL-related tools in cifs-utils call into the wbclient
libs directly in order to do their bidding. The wbclient developers want
to get away from needing to configure winbind on the clients and instead
allow sssd to handle the id-mapping. Less muss, less fuss...

This patch represents an initial step in that direction. It adds a
plugin architecture for cifs-utils, adds wrappers around the calls into
libwbclient that find an idmap plugin library to use and then has it
call into that plugin to do the actual ID mapping.

This patch should be considered an RFC on the overall design. Once I
have some positive feedback (or lack of negative feedback), I'll do the
same with cifs.idmap and setcifsacl.

This patch is still pretty rough, but should demonstrate the basic
design:

The application will call into a set of routines that find the correct
plugin and dlopen() it. Currently the plugin is located in a hardcoded
location that will eventually be settable via autoconf. That location is
intended to be a symlink that points to the real plugin (generally under
%libdir/cifs-utils).

The plugin will export a number of functions with well-known names. The
wrappers find those by using dlsym() and then call them.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am    |  12 +++++--
 getcifsacl.c   |  95 +++++++++++++++++++++++---------------------------
 idmap_plugin.c |  97 +++++++++++++++++++++++++++++++++++++++++++++++++++
 idmap_plugin.h |  49 ++++++++++++++++++++++++++
 idmapwb.c      | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 307 insertions(+), 54 deletions(-)
 create mode 100644 idmap_plugin.c
 create mode 100644 idmap_plugin.h
 create mode 100644 idmapwb.c

diff --git a/Makefile.am b/Makefile.am
index ff7a726..dab2957 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -56,9 +56,8 @@ endif
 
 if CONFIG_CIFSACL
 bin_PROGRAMS += getcifsacl
-getcifsacl_SOURCES = getcifsacl.c
-getcifsacl_LDADD = $(WBCLIENT_LIBS)
-getcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
+getcifsacl_SOURCES = getcifsacl.c idmap_plugin.c
+getcifsacl_LDADD = -ldl
 man_MANS += getcifsacl.1
 
 bin_PROGRAMS += setcifsacl
@@ -66,6 +65,13 @@ setcifsacl_SOURCES = setcifsacl.c
 setcifsacl_LDADD = $(WBCLIENT_LIBS)
 setcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
 man_MANS += setcifsacl.1
+
+plugindir = $(pkglibdir)
+plugin_PROGRAMS = idmapwb.so
+
+idmapwb.so: idmapwb.c
+	$(CC) $(CFLAGS) $(AM_CFLAGS) $(WBCLIENT_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ $(WBCLIENT_LIBS)
+
 endif
 
 SUBDIRS = contrib
diff --git a/getcifsacl.c b/getcifsacl.c
index 550429c..fcc56f0 100644
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
@@ -169,61 +172,48 @@ print_ace_type(uint8_t acetype, int raw)
 	}
 }
 
-/*
- * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
- * csid to the wsid, while converting the subauthority fields from LE.
- */
-static void
-csid_to_wsid(struct wbcDomainSid *wsid, const struct cifs_sid *csid)
+static int
+getcifsacl_sid_to_str(struct cifs_sid *csid, char **name)
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
+	int ret;
+
+	if (!plugin_loaded) {
+		ret = init_plugin(&plugin_handle);
+		if (ret)
+			return ret;
+		plugin_loaded = true;
+	}
+
+	return sid_to_str(plugin_handle, csid, name);
 }
 
 static void
-print_sid(struct cifs_sid *sidptr, int raw)
+print_sid(struct cifs_sid *csid, int raw)
 {
-	int i;
-	wbcErr rc;
-	char *domain_name = NULL;
-	char *sidname = NULL;
-	enum wbcSidType sntype;
+	int i, rc;
+	char *name;
 	unsigned long long id_auth_val;
-	struct wbcDomainSid wsid;
-
-	csid_to_wsid(&wsid, sidptr);
 
 	if (raw)
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
+	rc = getcifsacl_sid_to_str(csid, &name);
+	if (rc)
+		goto print_sid_raw;
+
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
@@ -234,8 +224,8 @@ print_sid_raw:
 	else
 		printf("-0x%llx", id_auth_val);
 
-	for (i = 0; i < wsid.num_auths; i++)
-		printf("-%u", wsid.sub_auths[i]);
+	for (i = 0; i < csid->num_subauth; i++)
+		printf("-%u", csid->sub_auth[i]);
 }
 
 static void
@@ -368,7 +358,7 @@ getcifsacl_usage(const char *prog)
 int
 main(const int argc, char *const argv[])
 {
-	int c, raw = 0;
+	int c, ret = 0, raw = 0;
 	ssize_t attrlen;
 	size_t bufsize = BUFSIZE;
 	char *filename, *attrval;
@@ -392,20 +382,22 @@ main(const int argc, char *const argv[])
 		filename = argv[1];
 	else {
 		getcifsacl_usage(basename(argv[0]));
-		return 0;
+		goto out;
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
@@ -421,7 +413,8 @@ cifsacl:
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
index 0000000..61f050d
--- /dev/null
+++ b/idmap_plugin.c
@@ -0,0 +1,97 @@
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
+#include <dlfcn.h>
+#include <errno.h>
+#include <stdint.h>
+
+#include "cifsacl.h"
+
+#define DEFAULT_PLUGIN_LOCATION "/etc/cifs-utils/idmap-plugin"
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
+	plugin = dlopen(DEFAULT_PLUGIN_LOCATION, RTLD_LAZY);
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
+	int (*init)(void **);
+
+	ret = open_plugin();
+	if (ret)
+		return ret;
+
+	init = resolve_symbol("cifs_idmap_init_plugin");
+	if (!init)
+		return -ENOSYS;
+	return (*init)(handle);
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
+	int (*entry)(void **, const struct cifs_sid *, char **);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_sid_to_str");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(handle, sid, name);
+}
diff --git a/idmap_plugin.h b/idmap_plugin.h
new file mode 100644
index 0000000..90aefe2
--- /dev/null
+++ b/idmap_plugin.h
@@ -0,0 +1,49 @@
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
+#include "cifsacl.h"
+
+/*
+ * On error, plugin functions should set this pointer to a string description
+ * of the error. The string should not be freed by the caller.
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
+/*
+ * Plugins should implement the following functions. All of them
+ * return 0 on success and non-zero on error.
+ *
+ * Convert cifs_sid to a string. Caller must free *name on success
+ * int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *, char **);
+ */
diff --git a/idmapwb.c b/idmapwb.c
new file mode 100644
index 0000000..78d9f23
--- /dev/null
+++ b/idmapwb.c
@@ -0,0 +1,108 @@
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
+#include <stdint.h>
+#include <endian.h>
+#include <string.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <wbclient.h>
+
+#include "idmap_plugin.h"
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
+		plugin_errmsg = wbcErrorString(wbcrc);
+		return -EIO;
+	}
+
+	/* +1 for '\\' and +1 for NULL terminator */
+	len = strlen(domain) + 1 + strlen(name) + 1;
+
+	*string = malloc(len);
+	if (!*string) {
+		plugin_errmsg = "Unable to allocate memory";
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = snprintf(*string, len, "%s\\%s", domain, name);
+	if (rc >= (long)len) {
+		free(*string);
+		plugin_errmsg = "Resulting string was truncated";
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
+cifs_idmap_init_plugin(void **handle __attribute__((unused)))
+{
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
