From: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cifs-utils: moving resolve_host into separate file
Date: Fri, 20 Aug 2010 11:45:13 +0400
Message-ID: <1282290314-9477-1-git-send-email-jaxbrigs@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The resolve_host routine from mount.cifs is carried out in
separate file and appropriate corrections are made.

Signed-off-by: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Makefile.am    |    2 +-
 mount.cifs.c   |  105 +++++++-------------------------------------------------
 resolve_host.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 resolve_host.h |   34 ++++++++++++++++++
 4 files changed, 153 insertions(+), 93 deletions(-)
 create mode 100644 resolve_host.c
 create mode 100644 resolve_host.h

diff --git a/Makefile.am b/Makefile.am
index c53c9ec..1ac9249 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@ ACLOCAL_AMFLAGS = -I aclocal
 
 root_sbindir = "/sbin"
 root_sbin_PROGRAMS = mount.cifs
-mount_cifs_SOURCES = mount.cifs.c mtab.c util.c
+mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
 mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
 
 man_MANS = mount.cifs.8
diff --git a/mount.cifs.c b/mount.cifs.c
index 3623e76..ed27bba 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -56,6 +56,7 @@
 #endif /* HAVE_LIBCAP_NG */
 #include "mount.h"
 #include "util.h"
+#include "resolve_host.h"
 
 #ifndef MS_MOVE 
 #define MS_MOVE 8192 
@@ -87,12 +88,6 @@
 /* max length of username (somewhat made up here) */
 #define MAX_USERNAME_SIZE 32
 
-/* currently maximum length of IPv6 address string */
-#define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
-
-/* limit list of addresses to 16 max-size addrs */
-#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * 16)
-
 #ifndef SAFE_FREE
 #define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
 #endif
@@ -1207,90 +1202,6 @@ nocopy:
 	return 0;
 }
 
-/*
- * resolve "host" portion of parsed info to comma-separated list of
- * address(es)
- */
-static int resolve_host(struct parsed_mount_info *parsed_info)
-{
-	int rc;
-	/* 10 for max width of decimal scopeid */
-	char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
-	const char *ipaddr;
-	size_t len;
-	struct addrinfo *addrlist, *addr;
-	struct sockaddr_in *sin;
-	struct sockaddr_in6 *sin6;
-
-	rc = getaddrinfo(parsed_info->host, NULL, NULL, &addrlist);
-	if (rc != 0) {
-		fprintf(stderr, "mount error: could not resolve address for "
-			"%s: %s\n", parsed_info->host,
-			rc == EAI_SYSTEM ? strerror(errno) : gai_strerror(rc));
-		/* FIXME: return better error based on rc? */
-		return EX_USAGE;
-	}
-
-	addr = addrlist;
-	while (addr) {
-		/* skip non-TCP entries */
-		if (addr->ai_socktype != SOCK_STREAM ||
-		    addr->ai_protocol != IPPROTO_TCP) {
-			addr = addr->ai_next;
-			continue;
-		}
-
-		switch (addr->ai_addr->sa_family) {
-		case AF_INET6:
-			sin6 = (struct sockaddr_in6 *)addr->ai_addr;
-			ipaddr = inet_ntop(AF_INET6, &sin6->sin6_addr, tmpbuf,
-					   sizeof(tmpbuf));
-			if (!ipaddr) {
-				rc = EX_SYSERR;
-				fprintf(stderr,
-					"mount error: problem parsing address "
-					"list: %s\n", strerror(errno));
-				goto resolve_host_out;
-			}
-
-			if (sin6->sin6_scope_id) {
-				len = strnlen(tmpbuf, sizeof(tmpbuf));
-				ipaddr = tmpbuf + len;
-				snprintf(tmpbuf, sizeof(tmpbuf) - len, "%%%u",
-					 sin6->sin6_scope_id);
-			}
-			break;
-		case AF_INET:
-			sin = (struct sockaddr_in *)addr->ai_addr;
-			ipaddr = inet_ntop(AF_INET, &sin->sin_addr, tmpbuf,
-					   sizeof(tmpbuf));
-			if (!ipaddr) {
-				rc = EX_SYSERR;
-				fprintf(stderr,
-					"mount error: problem parsing address "
-					"list: %s\n", strerror(errno));
-				goto resolve_host_out;
-			}
-
-			break;
-		default:
-			addr = addr->ai_next;
-			continue;
-		}
-
-		if (parsed_info->addrlist[0] != '\0')
-			strlcat(parsed_info->addrlist, ",",
-				sizeof(parsed_info->addrlist));
-		strlcat(parsed_info->addrlist, tmpbuf,
-			sizeof(parsed_info->addrlist));
-		addr = addr->ai_next;
-	}
-
-resolve_host_out:
-	freeaddrinfo(addrlist);
-	return rc;
-}
-
 static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info)
 {
 	int length = strnlen(unc_name, MAX_UNC_LEN);
@@ -1645,10 +1556,20 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 	if (rc)
 		goto assemble_exit;
 
-	rc = resolve_host(parsed_info);
-	if (rc)
+	rc = resolve_host(parsed_info->host, parsed_info->addrlist);
+	switch (rc) {
+	case EX_USAGE:
+		fprintf(stderr, "mount error: could not resolve address for "
+			"%s: %s\n", parsed_info->host,
+			rc == EAI_SYSTEM ? strerror(errno) : gai_strerror(rc));
 		goto assemble_exit;
 
+	case EX_SYSERR:
+		fprintf(stderr, "mount error: problem parsing address "
+			"list: %s\n", strerror(errno));
+		goto assemble_exit;
+	}
+
 	if (!parsed_info->got_user) {
 		/*
 		 * Note that the password will not be retrieved from the
diff --git a/resolve_host.c b/resolve_host.c
new file mode 100644
index 0000000..7687503
--- /dev/null
+++ b/resolve_host.c
@@ -0,0 +1,105 @@
+/*
+ * resolving DNS hostname routine
+ *
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
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif /* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include "mount.h"
+#include "util.h"
+#include "resolve_host.h"
+
+/*
+ * resolve hostname to comma-separated list of address(es)
+ */
+int resolve_host(const char *host, char *addrstr)
+{
+	int rc;
+	/* 10 for max width of decimal scopeid */
+	char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
+	const char *ipaddr;
+	size_t len;
+	struct addrinfo *addrlist, *addr;
+	struct sockaddr_in *sin;
+	struct sockaddr_in6 *sin6;
+
+	rc = getaddrinfo(host, NULL, NULL, &addrlist);
+	if (rc != 0)
+		return EX_USAGE;
+
+	addr = addrlist;
+	while (addr) {
+		/* skip non-TCP entries */
+		if (addr->ai_socktype != SOCK_STREAM ||
+		    addr->ai_protocol != IPPROTO_TCP) {
+			addr = addr->ai_next;
+			continue;
+		}
+
+		switch (addr->ai_addr->sa_family) {
+		case AF_INET6:
+			sin6 = (struct sockaddr_in6 *)addr->ai_addr;
+			ipaddr = inet_ntop(AF_INET6, &sin6->sin6_addr, tmpbuf,
+					   sizeof(tmpbuf));
+			if (!ipaddr) {
+				rc = EX_SYSERR;
+				goto resolve_host_out;
+			}
+
+			if (sin6->sin6_scope_id) {
+				len = strnlen(tmpbuf, sizeof(tmpbuf));
+				ipaddr = tmpbuf + len;
+				snprintf(tmpbuf, sizeof(tmpbuf) - len, "%%%u",
+					 sin6->sin6_scope_id);
+			}
+			break;
+		case AF_INET:
+			sin = (struct sockaddr_in *)addr->ai_addr;
+			ipaddr = inet_ntop(AF_INET, &sin->sin_addr, tmpbuf,
+					   sizeof(tmpbuf));
+			if (!ipaddr) {
+				rc = EX_SYSERR;
+				goto resolve_host_out;
+			}
+
+			break;
+		default:
+			addr = addr->ai_next;
+			continue;
+		}
+
+		if (addr == addrlist)
+			*addrstr = '\0';
+		else
+			strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
+
+		strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
+		addr = addr->ai_next;
+	}
+
+resolve_host_out:
+	freeaddrinfo(addrlist);
+	return rc;
+}
diff --git a/resolve_host.h b/resolve_host.h
new file mode 100644
index 0000000..b949245
--- /dev/null
+++ b/resolve_host.h
@@ -0,0 +1,34 @@
+/*
+ * resolving DNS hostname routine
+ *
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
+#ifndef _RESOLVE_HOST_H_
+#define _RESOLVE_HOST_H_
+
+#include <arpa/inet.h>
+
+/* currently maximum length of IPv6 address string */
+#define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
+
+/* limit list of addresses to 16 max-size addrs */
+#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * 16)
+
+extern int resolve_host(const char *host, char *addrstr);
+
+#endif /* _RESOLVE_HOST_H_ */
-- 
1.7.2.1
