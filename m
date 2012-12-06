From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH RFC] cifs-utils: new plugin architecture for ID mapping code
Date: Thu,  6 Dec 2012 07:37:38 -0500
Message-ID: <1354797458-5170-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

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

I'm tracking progress on this work here:

    https://bugzilla.samba.org/show_bug.cgi?id=9203

Here are some questions to ponder:

1/ Should we switch this code to use a config file of some sort instead
of this symlink? The symlink would probably be more efficient, but it
is a little odd and might confuse people. It also might make it hard to
expand the idmapping interfaces later.

2/ Should I switch this code to use libltdl for the plugin architecture?
I started to use that initially, but it was awfully complex to get working.
Since portability isn't really a concern with cifs-utils, I punted. Does
anyone see issues with rolling our own here?

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am    | 12 ++++++--
 getcifsacl.c   | 68 +++++++++++++------------------------------
 idmap_plugin.c | 68 +++++++++++++++++++++++++++++++++++++++++++
 idmap_plugin.h | 40 ++++++++++++++++++++++++++
 idmapwb.c      | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 228 insertions(+), 51 deletions(-)
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
index 3f94a99..1768b16 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -34,10 +34,10 @@
 #include <stddef.h>
 #include <errno.h>
 #include <limits.h>
-#include <wbclient.h>
 #include <ctype.h>
 #include <sys/xattr.h>
 #include "cifsacl.h"
+#include "idmap_plugin.h"
 
 static const char *prog;
 
@@ -172,61 +172,33 @@ print_ace_type(uint8_t acetype, int raw)
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
+	rc = sid_to_str(csid, &name);
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
@@ -237,8 +209,8 @@ print_sid_raw:
 	else
 		printf("-0x%llx", id_auth_val);
 
-	for (i = 0; i < wsid.num_auths; i++)
-		printf("-%u", wsid.sub_auths[i]);
+	for (i = 0; i < csid->num_subauth; i++)
+		printf("-%u", csid->sub_auth[i]);
 }
 
 static void
diff --git a/idmap_plugin.c b/idmap_plugin.c
new file mode 100644
index 0000000..672f465
--- /dev/null
+++ b/idmap_plugin.c
@@ -0,0 +1,68 @@
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
+	if (!plugin) {
+		plugin = dlopen(DEFAULT_PLUGIN_LOCATION, RTLD_LAZY);
+		if (!plugin) {
+			plugin_errmsg = dlerror();
+			return plugin;
+		}
+	}
+
+	dlerror();
+	symbol = dlsym(plugin, symbol_name);
+	if (!symbol)
+		plugin_errmsg = dlerror();
+	return symbol;
+}
+
+void
+close_plugin(void)
+{
+	if (!plugin)
+		return;
+	dlclose(plugin);
+}
+
+int
+sid_to_str(const struct cifs_sid *sid, char **name)
+{
+	int (*entry)(const struct cifs_sid *, char **);
+
+	*(void **)(&entry) = resolve_symbol("idmap_sid_to_str");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(sid, name);
+}
diff --git a/idmap_plugin.h b/idmap_plugin.h
new file mode 100644
index 0000000..8853815
--- /dev/null
+++ b/idmap_plugin.h
@@ -0,0 +1,40 @@
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
+/* Convert cifs_sid to a string. Caller must free *name on success */
+extern int sid_to_str(const struct cifs_sid *sid, char **name);
+
+/*
+ * Plugins should implement the following functions. All of them
+ * return 0 on success and non-zero on error.
+ *
+ * Convert cifs_sid to a string. Caller must free *name on success
+ * extern int (*idmap_sid_to_str)(const struct cifs_sid *, char **);
+ */
diff --git a/idmapwb.c b/idmapwb.c
new file mode 100644
index 0000000..a2072d2
--- /dev/null
+++ b/idmapwb.c
@@ -0,0 +1,91 @@
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
+idmap_sid_to_str(const struct cifs_sid *csid, char **string)
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
-- 
1.7.11.7
