From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] Implement a DNS Resolver Module
Date: Wed, 07 Jul 2010 10:14:11 +0100
Message-ID: <20100707091411.16573.81747.stgit@warthog.procyon.org.uk>
References: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707091400.16573.2817.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Separate out the DNS resolver key type from the CIFS filesystem into its own
module so that it can be made available for general use, including the AFS
filesystem module.

This makes it possible for the kernel to upcall to userspace to have it issue
DNS requests and package up the replies and present them to the kernel in a
useful form.  The kernel is then able to cache the DNS replies as keys can be
retained in keyrings.

Resolver keys are of type "dns_resolver" and have a case-insensitive
description that is of the form "[<type>:]<domain_name>".  The optional <type>
indicates the particular DNS lookup and packaging that's required.  The
<domain_name> is the query to be made.

If <type> isn't given, a basic hostname to IP address lookup is made, and the
result is stored in the key in the form of a printable string consisting of a
comma-separated list of IPv4 and IPv6 addresses.

This key type is supported by userspace helpers driven from /sbin/request-key
and configured through /etc/request-key.conf.  The cifs.upcall utility is
invoked for UNC path server name to IP address resolution.

The CIFS functionality is encapsulated by the dns_resolve_unc_to_ip() function,
which is used to resolve a UNC path to an IP address for CIFS filesystem.  This
can be reused by filesystems other than CIFS that want to make the same
resolution.

Signed-off-by: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 Documentation/networking/dnsresolver.txt |  150 +++++++++++++++
 fs/cifs/Kconfig                          |   17 +-
 fs/cifs/Makefile                         |    2 
 fs/cifs/cifs_dfs_ref.c                   |    4 
 fs/cifs/cifsfs.c                         |   13 -
 fs/cifs/dns_resolve.c                    |  168 -----------------
 fs/cifs/dns_resolve.h                    |   32 ---
 include/keys/dnsresolver-type.h          |   23 ++
 include/linux/dns_resolver.h             |   35 ++++
 net/Kconfig                              |    1 
 net/Makefile                             |    1 
 net/dnsresolver/Kconfig                  |   27 +++
 net/dnsresolver/Makefile                 |    7 +
 net/dnsresolver/dns_resolver.c           |  293 ++++++++++++++++++++++++++++++
 net/dnsresolver/internal.h               |   39 ++++
 net/dnsresolver/resolv_unc_to_ip.c       |  111 +++++++++++
 16 files changed, 700 insertions(+), 223 deletions(-)
 create mode 100644 Documentation/networking/dnsresolver.txt
 delete mode 100644 fs/cifs/dns_resolve.c
 delete mode 100644 fs/cifs/dns_resolve.h
 create mode 100644 include/keys/dnsresolver-type.h
 create mode 100644 include/linux/dns_resolver.h
 create mode 100644 net/dnsresolver/Kconfig
 create mode 100644 net/dnsresolver/Makefile
 create mode 100644 net/dnsresolver/dns_resolver.c
 create mode 100644 net/dnsresolver/internal.h
 create mode 100644 net/dnsresolver/resolv_unc_to_ip.c

diff --git a/Documentation/networking/dnsresolver.txt b/Documentation/networking/dnsresolver.txt
new file mode 100644
index 0000000..a7fd352
--- /dev/null
+++ b/Documentation/networking/dnsresolver.txt
@@ -0,0 +1,150 @@
+			     ===================
+			     DNS Resolver Module
+			     ===================
+
+Contents:
+
+ - Overview.
+ - Compilation.
+ - Setting up.
+ - Usage.
+ - Mechanism.
+ - Debugging.
+
+
+========
+OVERVIEW
+========
+
+The DNS resolver module provides a way for kernel services to make DNS queries
+by way of requesting a key of key type dns_resolver.  These queries are
+upcalled to userspace through /sbin/request-key.
+
+These routines must be supported by userspace tools dns.upcall, cifs.upcall and
+request-key.  It is under development and does not yet provide the full feature
+set.  The features it does support include:
+
+ (*) Implements the dns_resolver key_type to contact userspace.
+
+ (*) extracted the dns_resolve_unc_to_ip function from CIFS.
+
+It does not yet support the following AFS features:
+
+ (*) Dns query support for AFSDB resource record.
+
+This code is extracted from the CIFS filesystem.
+
+
+===========
+COMPILATION
+===========
+
+The module should be enabled by turning on the kernel configuration options:
+
+	CONFIG_DNS_RESOLVER	- tristate "DNS Resolver support"
+
+
+==========
+SETTING UP
+==========
+
+To set up this facility, the /etc/request-key.conf file must be altered so that
+/sbin/request-key can appropriately direct the upcalls.  For example, to handle
+basic dname to IPv4/IPv6 address resolution, the following line should be
+added:
+
+	#OP	TYPE		DESC	CO-INFO	PROGRAM ARG1 ARG2 ARG3 ...
+	#======	============	=======	=======	==========================
+	create	dns_resolver  	*	*	/usr/sbin/cifs.upcall %k
+
+To direct a query for query type 'foo', a line of the following should be added
+before the more general line given above as the first match is the one taken.
+
+	create	dns_resolver  	foo:*	*	/usr/sbin/dns.foo %k
+
+
+
+=====
+USAGE
+=====
+
+To make use of this facility, one of the following functions that are
+implemented in the module can be called after doing:
+
+	#include <linux/dns_resolver.h>
+
+ (1) int request_dns_resolution(const char *description, const char *options,
+				char **result);
+
+     This is the basic access function.  It looks for a cached DNS query and if
+     it doesn't find it, it upcalls to userspace to make a new DNS query, which
+     may then be cached.  The description is a string of form:
+
+	[<query_type>:]<dname>
+
+     where <query_type> optionally specifies the particular upcall program to
+     invoke, and thus the type of query to do, and <dname> specifies the string
+     to be looked up.  The default query type is a straight hostname to IP
+     address set lookup.
+
+     The options parameter may be NULL or it may be a set of options
+     appropriate to the query type.
+
+     The return value is a string appropriate to the query type.  For instance,
+     for the default query type it is just a list of comma-separated IPv4 and
+     IPv6 addresses.  The caller must free the result.
+
+     0 is returned on success, and a -ve error code is returned otherwise.
+     -EKEYREJECTED will be returned if the DNS lookup failed.
+
+
+ (2) int dns_resolve_unc_to_ip(const char *unc, char **ip_addr);
+
+     This functions takes a UNC-style path, as used by CIFS, and translates the
+     server address embedded therein into an IP address in string form, which
+     it returns by pointing *ip_addr at it.  The caller must free the result.
+
+     0 is returned on success, and a -ve error code is returned otherwise.
+     -EKEYREJECTED will be returned if the DNS lookup failed.
+
+
+=========
+MECHANISM
+=========
+
+The dnsresolver module registers a key type called "dns_resolver".  Keys of
+this type are used to transport and cache DNS lookup results from userspace.
+
+When request_dns_resolution() is invoked, it calls request_key() to search the
+local keyrings for a cached DNS result.  If that fails to find one, it upcalls
+to userspace to get a new result.
+
+Upcalls to userspace are made through the request_key() upcall vector, and are
+directed by means of configuration lines in /etc/request-key.conf that tell
+/sbin/request-key what program to run to instantiate the key.
+
+The upcall handler program is responsible for querying the DNS, processing the
+result into a form suitable for passing to the keyctl_instantiate_key()
+routine.  This then passes the data to dns_resolver_instantiate() which strips
+off and processes any options included in the data, and then attaches the
+remainder of the string to the key as its payload.
+
+The upcall handler program should set the expiry time on the key to that of the
+lowest TTL of all the records it has extracted a result from.  This means that
+the key will be discarded and recreated when the data it holds has expired.
+
+request_dns_resolution() returns the value attached to the key, or an error if
+that is indicated instead.
+
+See <file:Documentation/keys-request-key.txt> for further information about
+request-key function.
+
+
+=========
+DEBUGGING
+=========
+
+Debugging messages can be turned on dynamically by writing a 1 into the
+following file:
+
+        /sys/module/dnsresolver/parameters/debug
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 80f3525..7a7081c 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -71,14 +71,14 @@ config CIFS_WEAK_PW_HASH
 	  If unsure, say N.
 
 config CIFS_UPCALL
-	  bool "Kerberos/SPNEGO advanced session setup"
-	  depends on CIFS && KEYS
-	  help
-	    Enables an upcall mechanism for CIFS which accesses
-	    userspace helper utilities to provide SPNEGO packaged (RFC 4178)
-	    Kerberos tickets which are needed to mount to certain secure servers
-	    (for which more secure Kerberos authentication is required). If
-	    unsure, say N.
+	bool "Kerberos/SPNEGO advanced session setup"
+	depends on CIFS && KEYS
+	select DNS_RESOLVER
+	help
+	  Enables an upcall mechanism for CIFS which accesses userspace helper
+	  utilities to provide SPNEGO packaged (RFC 4178) Kerberos tickets
+	  which are needed to mount to certain secure servers (for which more
+	  secure Kerberos authentication is required). If unsure, say N.
 
 config CIFS_XATTR
         bool "CIFS extended attributes"
@@ -122,6 +122,7 @@ config CIFS_DEBUG2
 config CIFS_DFS_UPCALL
 	  bool "DFS feature support"
 	  depends on CIFS && KEYS
+	  select DNS_RESOLVER
 	  help
 	    Distributed File System (DFS) support is used to access shares
 	    transparently in an enterprise name space, even if the share
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 9948c00..db98b59 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -10,4 +10,4 @@ cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
-cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
+cifs-$(CONFIG_CIFS_DFS_UPCALL) += cifs_dfs_ref.o
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ac19a6f..89ff5e7 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -18,10 +18,10 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/fs.h>
+#include <linux/dns_resolver.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
-#include "dns_resolve.h"
 #include "cifs_debug.h"
 
 static LIST_HEAD(cifs_dfs_automount_list);
@@ -140,7 +140,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		goto compose_mount_options_err;
 	}
 
-	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
+	rc = dns_resolve_unc_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, "%s: Failed to resolve server part of %s to IP: %d",
 			  __func__, *devname, rc);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 484e52b..ef9a773 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -45,7 +45,6 @@
 #include "cifs_fs_sb.h"
 #include <linux/mm.h>
 #include <linux/key-type.h>
-#include "dns_resolve.h"
 #include "cifs_spnego.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
@@ -922,22 +921,13 @@ init_cifs(void)
 	if (rc)
 		goto out_unregister_filesystem;
 #endif
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	rc = register_key_type(&key_type_dns_resolver);
-	if (rc)
-		goto out_unregister_key_type;
-#endif
 	rc = slow_work_register_user(THIS_MODULE);
 	if (rc)
-		goto out_unregister_resolver_key;
+		goto out_unregister_key_type;
 
 	return 0;
 
- out_unregister_resolver_key:
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	unregister_key_type(&key_type_dns_resolver);
  out_unregister_key_type:
-#endif
 #ifdef CONFIG_CIFS_UPCALL
 	unregister_key_type(&cifs_spnego_key_type);
  out_unregister_filesystem:
@@ -961,7 +951,6 @@ exit_cifs(void)
 	cifs_proc_clean();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
-	unregister_key_type(&key_type_dns_resolver);
 #endif
 #ifdef CONFIG_CIFS_UPCALL
 	unregister_key_type(&cifs_spnego_key_type);
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
deleted file mode 100644
index 4db2c5e..0000000
--- a/fs/cifs/dns_resolve.c
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- *  fs/cifs/dns_resolve.c
- *
- *   Copyright (c) 2007 Igor Mammedov
- *   Author(s): Igor Mammedov (niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
- *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
- *
- *   Contains the CIFS DFS upcall routines used for hostname to
- *   IP address translation.
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#include <linux/slab.h>
-#include <keys/user-type.h>
-#include "dns_resolve.h"
-#include "cifsglob.h"
-#include "cifsproto.h"
-#include "cifs_debug.h"
-
-/* Checks if supplied name is IP address
- * returns:
- * 		1 - name is IP
- * 		0 - name is not IP
- */
-static int
-is_ip(char *name)
-{
-	struct sockaddr_storage ss;
-
-	return cifs_convert_address(name, &ss);
-}
-
-static int
-dns_resolver_instantiate(struct key *key, const void *data,
-		size_t datalen)
-{
-	int rc = 0;
-	char *ip;
-
-	ip = kmalloc(datalen + 1, GFP_KERNEL);
-	if (!ip)
-		return -ENOMEM;
-
-	memcpy(ip, data, datalen);
-	ip[datalen] = '\0';
-
-	/* make sure this looks like an address */
-	if (!is_ip(ip)) {
-		kfree(ip);
-		return -EINVAL;
-	}
-
-	key->type_data.x[0] = datalen;
-	key->payload.data = ip;
-
-	return rc;
-}
-
-static void
-dns_resolver_destroy(struct key *key)
-{
-	kfree(key->payload.data);
-}
-
-struct key_type key_type_dns_resolver = {
-	.name        = "dns_resolver",
-	.def_datalen = sizeof(struct in_addr),
-	.describe    = user_describe,
-	.instantiate = dns_resolver_instantiate,
-	.destroy     = dns_resolver_destroy,
-	.match       = user_match,
-};
-
-/* Resolves server name to ip address.
- * input:
- * 	unc - server UNC
- * output:
- * 	*ip_addr - pointer to server ip, caller responcible for freeing it.
- * return 0 on success
- */
-int
-dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
-{
-	int rc = -EAGAIN;
-	struct key *rkey = ERR_PTR(-EAGAIN);
-	char *name;
-	char *data = NULL;
-	int len;
-
-	if (!ip_addr || !unc)
-		return -EINVAL;
-
-	/* search for server name delimiter */
-	len = strlen(unc);
-	if (len < 3) {
-		cFYI(1, "%s: unc is too short: %s", __func__, unc);
-		return -EINVAL;
-	}
-	len -= 2;
-	name = memchr(unc+2, '\\', len);
-	if (!name) {
-		cFYI(1, "%s: probably server name is whole unc: %s",
-					__func__, unc);
-	} else {
-		len = (name - unc) - 2/* leading // */;
-	}
-
-	name = kmalloc(len+1, GFP_KERNEL);
-	if (!name) {
-		rc = -ENOMEM;
-		return rc;
-	}
-	memcpy(name, unc+2, len);
-	name[len] = 0;
-
-	if (is_ip(name)) {
-		cFYI(1, "%s: it is IP, skipping dns upcall: %s",
-					__func__, name);
-		data = name;
-		goto skip_upcall;
-	}
-
-	rkey = request_key(&key_type_dns_resolver, name, "");
-	if (!IS_ERR(rkey)) {
-		len = rkey->type_data.x[0];
-		data = rkey->payload.data;
-	} else {
-		cERROR(1, "%s: unable to resolve: %s", __func__, name);
-		goto out;
-	}
-
-skip_upcall:
-	if (data) {
-		*ip_addr = kmalloc(len + 1, GFP_KERNEL);
-		if (*ip_addr) {
-			memcpy(*ip_addr, data, len + 1);
-			if (!IS_ERR(rkey))
-				cFYI(1, "%s: resolved: %s to %s", __func__,
-							name,
-							*ip_addr
-					);
-			rc = 0;
-		} else {
-			rc = -ENOMEM;
-		}
-		if (!IS_ERR(rkey))
-			key_put(rkey);
-	}
-
-out:
-	kfree(name);
-	return rc;
-}
-
-
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
deleted file mode 100644
index 966e928..0000000
--- a/fs/cifs/dns_resolve.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- *   fs/cifs/dns_resolve.h -- DNS Resolver upcall management for CIFS DFS
- *                            Handles host name to IP address resolution
- *
- *   Copyright (c) International Business Machines  Corp., 2008
- *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#ifndef _DNS_RESOLVE_H
-#define _DNS_RESOLVE_H
-
-#ifdef __KERNEL__
-#include <linux/key-type.h>
-extern struct key_type key_type_dns_resolver;
-extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
-#endif /* KERNEL */
-
-#endif /* _DNS_RESOLVE_H */
diff --git a/include/keys/dnsresolver-type.h b/include/keys/dnsresolver-type.h
new file mode 100644
index 0000000..9284a19
--- /dev/null
+++ b/include/keys/dnsresolver-type.h
@@ -0,0 +1,23 @@
+/* DNS resolver key type
+ *
+ * Copyright (C) 2010 Wang Lei. All Rights Reserved.
+ * Written by Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _KEYS_DNS_RESOLVER_TYPE_H
+#define _KEYS_DNS_RESOLVER_TYPE_H
+
+#include <linux/key-type.h>
+
+extern struct key_type key_type_dns_resolver;
+
+extern int request_dns_resolver_key(const char *description,
+				    const char *callout_info,
+				    char **data);
+
+#endif /* _KEYS_DNS_RESOLVER_TYPE_H */
diff --git a/include/linux/dns_resolver.h b/include/linux/dns_resolver.h
new file mode 100644
index 0000000..72b9edf
--- /dev/null
+++ b/include/linux/dns_resolver.h
@@ -0,0 +1,35 @@
+/*
+ *   DNS Resolver upcall management for CIFS DFS and AFS
+ *   Handles host name to IP address resolution and DNS query for AFSDB RR.
+ *
+ *   Copyright (c) International Business Machines  Corp., 2008
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef _DNS_RESOLVER_H
+#define _DNS_RESOLVER_H
+
+#ifdef __KERNEL__
+
+extern int request_dns_resolution(const char *description, const char *options,
+				  char **result);
+extern int dns_resolve_unc_to_ip(const char *unc, char **ip_addr);
+
+#endif /* KERNEL */
+
+#endif /* _DNS_RESOLVER_H */
diff --git a/net/Kconfig b/net/Kconfig
index 0d68b40..3c4eced 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -203,6 +203,7 @@ source "net/phonet/Kconfig"
 source "net/ieee802154/Kconfig"
 source "net/sched/Kconfig"
 source "net/dcb/Kconfig"
+source "net/dnsresolver/Kconfig"
 
 config RPS
 	boolean
diff --git a/net/Makefile b/net/Makefile
index cb7bdc1..3a7a17b 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -67,3 +67,4 @@ ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
 endif
 obj-$(CONFIG_WIMAX)		+= wimax/
+obj-$(CONFIG_DNS_RESOLVER)	+= dnsresolver/
diff --git a/net/dnsresolver/Kconfig b/net/dnsresolver/Kconfig
new file mode 100644
index 0000000..09de536
--- /dev/null
+++ b/net/dnsresolver/Kconfig
@@ -0,0 +1,27 @@
+#
+# Configuration for DNS Resolver
+#
+config DNS_RESOLVER
+	tristate "DNS Resolver support"
+	depends on NET && KEYS
+	help
+	  Saying Y here will include support for the DNS Resolver key type
+	  which can be used to make upcalls to perform DNS lookups in
+	  userspace.
+
+	  DNS Resolver is used to query DNS server for information.  Examples
+	  being resolving a UNC hostname element to an IP address for CIFS or
+	  performing a DNS query for AFSDB records so that AFS can locate a
+	  cell's volume location database servers.
+
+	  DNS Resolver is used by the CIFS and AFS modules, and would support
+	  samba4 later.  DNS Resolver is supported by the userspace upcall
+	  helper "/sbin/dns.resolver" via /etc/request-key.conf.
+
+	  See <file:Documentation/networking/dnsresolver.txt> for further
+	  information.
+
+	  To compile this as a module, choose M here: the module will be called
+	  dnsresolver.
+
+	  If unsure, say N.
diff --git a/net/dnsresolver/Makefile b/net/dnsresolver/Makefile
new file mode 100644
index 0000000..260ccc4
--- /dev/null
+++ b/net/dnsresolver/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux DNS Resolver.
+#
+
+obj-$(CONFIG_DNS_RESOLVER) += dnsresolver.o
+
+dnsresolver-objs :=  dns_resolver.o resolv_unc_to_ip.o
diff --git a/net/dnsresolver/dns_resolver.c b/net/dnsresolver/dns_resolver.c
new file mode 100644
index 0000000..f7d0386
--- /dev/null
+++ b/net/dnsresolver/dns_resolver.c
@@ -0,0 +1,293 @@
+/* Upcall routine, designed to work as a key type and working through
+ * /sbin/request-key to contact userspace when handling DNS queries.
+ *
+ *   Copyright (c) 2007 Igor Mammedov
+ *   Author(s): Igor Mammedov (niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *		David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <keys/dnsresolver-type.h>
+#include <keys/user-type.h>
+#include "internal.h"
+
+MODULE_DESCRIPTION("DNS Resolver");
+MODULE_AUTHOR("Wang Lei");
+MODULE_LICENSE("GPL");
+
+unsigned dnsresolver_debug;
+module_param_named(debug, dnsresolver_debug, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(debug, "DNS Rsolver debugging mask");
+
+#define	DNS_EXPIRY_OPTION	"expiry_time"
+
+/*
+ * Instantiate a user defined key for dns_resolver.
+ *
+ * The data must be a NUL-terminated string, with the NUL char accounted in
+ * datalen.
+ *
+ * If the data contains a '#' characters, then we take the clause after each
+ * one to be an option of the form 'key=value'.  The actual data of interest is
+ * the string leading up to the first '#'.
+ *
+ * The only option currently supported is the expiry time of the key, which can
+ * be set from the TTL field of the DNS record.  The value should be a time_t
+ * time.
+ *
+ * For instance:
+ *
+ *        "ip1,ip2,...#expiry_time=123"
+ *
+ * the expiry time of the data is 123 and the data starts after '#'.
+ */
+static int
+dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
+{
+	struct user_key_payload *upayload;
+	unsigned long expiry = 0;
+	int ret;
+	size_t result_len = 0;
+	const char *data = _data, *end, *opt;
+
+	kenter("%%%d,%s,'%s',%zu",
+	       key->serial, key->description, data, datalen);
+
+	if (datalen <= 1 || datalen > 32767 ||
+	    !data || data[datalen - 1] != '\0')
+		return -EINVAL;
+
+	/* deal with any options embedded in the data */
+	end = data + datalen - 1;
+	opt = memchr(data, '#', datalen - 1);
+	if (!opt) {
+		/* no options: the entire data is the result */
+		kdebug("no options");
+		result_len = datalen - 1;
+	} else {
+		result_len = opt - data;
+		opt++;
+		kdebug("options: '%s'", opt);
+		do {
+			const char *next_opt, *eq;
+			int opt_len, opt_nlen, opt_vlen, tmp;
+
+			next_opt = memchr(opt, '#', end - opt) ?: end;
+			opt_len = next_opt - opt;
+			if (!opt_len) {
+				printk(KERN_WARNING
+				       "Empty option to dnsresolver key %d\n",
+				       key->serial);
+				return -EINVAL;
+			}
+
+			eq = memchr(opt, '=', opt_len) ?: end;
+			opt_nlen = eq - opt;
+			eq++;
+			opt_vlen = next_opt - eq; /* will be -1 if no value */
+
+			tmp = opt_vlen >= 0 ? opt_vlen : 0;
+			kdebug("option '%*.*s' val '%*.*s'",
+			       opt_nlen, opt_nlen, opt, tmp, tmp, eq);
+
+			/* see if it's the expiry time */
+			if (opt_nlen == sizeof(DNS_EXPIRY_OPTION) - 1 &&
+			    memcmp(opt, DNS_EXPIRY_OPTION, opt_nlen) == 0) {
+				kdebug("expiry time option");
+				if (opt_vlen <= 0)
+					goto bad_option_value;
+
+				ret = strict_strtoul(eq, 10, &expiry);
+				if (ret < 0)
+					goto bad_option_value;
+				kdebug("expiry time = %lu", expiry);
+				goto next_option;
+			}
+
+		bad_option_value:
+			printk(KERN_WARNING
+			       "Option '%*.*s' to dnsresolver key %d:"
+			       " bad/missing value\n",
+			       opt_nlen, opt_nlen, opt, key->serial);
+			return -EINVAL;
+
+		next_option:
+			opt = next_opt + 1;
+		} while (opt < end);
+	}
+
+	kdebug("store result");
+	ret = key_payload_reserve(key, result_len);
+	if (ret < 0)
+		return -EINVAL;
+
+	upayload = kmalloc(sizeof(*upayload) + result_len + 1, GFP_KERNEL);
+	if (!upayload) {
+		kleave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	/* attach the data */
+	upayload->datalen = result_len;
+	memcpy(upayload->data, data, result_len);
+	upayload->data[result_len] = '\0';
+	rcu_assign_pointer(key->payload.data, upayload);
+
+	/* if we were given an expiry time, then try to apply it */
+	kdebug("expiry %lu [%lu]", expiry, key->expiry);
+	if (expiry && (key->expiry == 0 || expiry < key->expiry)) {
+		kdebug("set expiry to %ld hence", expiry - get_seconds());
+		key->expiry = expiry;
+	}
+
+	kleave(" = 0");
+	return 0;
+}
+
+/*
+ * The description is of the form "[<type>:]<domain_name>"
+ *
+ * The domain name may be a simple name or an absolute domain name (which
+ * should end with a period).  The domain name is case-independent.
+ */
+static int
+dns_resolver_match(const struct key *key, const void *description)
+{
+	int slen, dlen, ret = 0;
+	const char *src = key->description, *dsp = description;
+
+	kenter("%s,%s", src, dsp);
+
+	if (!src || !dsp)
+		goto no_match;
+
+	if (strcasecmp(src, dsp) == 0)
+		goto matched;
+
+	slen = strlen(src);
+	dlen = strlen(dsp);
+	if (slen <= 0 || dlen <= 0)
+		goto no_match;
+	if (src[slen - 1] == '.')
+		slen--;
+	if (dsp[dlen - 1] == '.')
+		dlen--;
+	if (slen != dlen || strncasecmp(src, dsp, slen) != 0)
+		goto no_match;
+
+matched:
+	ret = 1;
+no_match:
+	kleave(" = %d", ret);
+	return ret;
+}
+
+struct key_type key_type_dns_resolver = {
+	.name		= "dns_resolver",
+	.instantiate	= dns_resolver_instantiate,
+	.match		= dns_resolver_match,
+	.revoke		= user_revoke,
+	.destroy	= user_destroy,
+	.describe	= user_describe,
+	.read		= user_read,
+};
+
+/*
+ * request_dns_resolution - Request a DNS lookup.
+ * @description: Description of the request
+ * @options: Request options (or NULL if no options)
+ * @result: Where to place the returned data.
+ *
+ * The data will be returned in the pointer at *result, and the caller is
+ * responsible for freeing it.
+ *
+ * The description should be of the form "[<query_type>:]<domain_name>", and
+ * the options need to be appropriate for the query type requested.  If no
+ * query_type is given, then the query is a straight hostname to IP address
+ * lookup.
+ *
+ * The DNS resolution lookup is performed by upcalling to userspace by way of
+ * requesting a key of type dns_resolver.
+ *
+ * Returns 0 on success, -ve on error.
+ */
+int
+request_dns_resolution(const char *description, const char *options,
+		       char **result)
+{
+	int ret, len;
+	struct key *rkey;
+	struct user_key_payload *upayload;
+
+	kenter("%s,%s,", description, options);
+
+	if (!description || !result) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	rkey = request_key(&key_type_dns_resolver, description, options ?: "");
+	if (IS_ERR(rkey)) {
+		ret = PTR_ERR(rkey);
+		goto out;
+	}
+
+	ret = key_validate(rkey);
+	if (ret < 0)
+		goto put;
+
+	upayload = rcu_dereference(rkey->payload.data);
+	len = upayload->datalen;
+
+	ret = -ENOMEM;
+	*result = kmalloc(len + 1, GFP_KERNEL);
+	if (!*result)
+		goto put;
+
+	memcpy(*result, upayload->data, len + 1);
+
+	ret = 0;
+put:
+	key_put(rkey);
+out:
+	kleave(" = %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL(request_dns_resolution);
+
+static int __init init_dns_resolver(void)
+{
+	printk(KERN_NOTICE "Registering the %s key type\n",
+	       key_type_dns_resolver.name);
+	return register_key_type(&key_type_dns_resolver);
+}
+
+static void __exit exit_dns_resolver(void)
+{
+	unregister_key_type(&key_type_dns_resolver);
+	printk(KERN_NOTICE "Unregistered %s key type\n",
+	       key_type_dns_resolver.name);
+}
+
+module_init(init_dns_resolver)
+module_exit(exit_dns_resolver)
+MODULE_LICENSE("GPL");
diff --git a/net/dnsresolver/internal.h b/net/dnsresolver/internal.h
new file mode 100644
index 0000000..c094fc4
--- /dev/null
+++ b/net/dnsresolver/internal.h
@@ -0,0 +1,39 @@
+/*
+ *   Copyright (c) 2010 Wang Lei
+ *   Author(s): Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org). All Rights Reserved.
+ *
+ *   Internal DNS Rsolver stuff
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+
+/*
+ * debug tracing
+ */
+extern unsigned dnsresolver_debug;
+
+#define	kdebug(FMT, ...)				\
+do {							\
+	if (unlikely(dnsresolver_debug))		\
+		printk(KERN_DEBUG "[%-6.6s] "FMT"\n",	\
+		       current->comm, ##__VA_ARGS__);	\
+} while (0)
+
+#define kenter(FMT, ...) kdebug("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) kdebug("<== %s()"FMT"", __func__, ##__VA_ARGS__)
diff --git a/net/dnsresolver/resolv_unc_to_ip.c b/net/dnsresolver/resolv_unc_to_ip.c
new file mode 100644
index 0000000..169f9d9
--- /dev/null
+++ b/net/dnsresolver/resolv_unc_to_ip.c
@@ -0,0 +1,111 @@
+/*
+ *   Copyright (c) 2007 Igor Mammedov
+ *   Author(s): Igor Mammedov (niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *
+ *   Routines used for Universal Naming Convention (UNC) path style hostname to
+ *   IP address translation.  For this function to work, the userspace tool
+ *   dns.upcall is needed and something like the following lines should be
+ *   added to the /etc/request-key.conf file:
+ *
+ *	create dns_resolver * * /sbin/dns.upcall %k
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/socket.h>
+#include <linux/in.h>
+#include <linux/inet.h>
+#include <linux/in6.h>
+#include <linux/string.h>
+#include <linux/dns_resolver.h>
+#include <keys/dnsresolver-type.h>
+#include "internal.h"
+
+/**
+ * dns_resolve_unc_to_ip - Resolve UNC server name to ip address.
+ * @unc: UNC path specifying the server
+ * @ip_addr: Where to return the IP address.
+ *
+ * The IP address will be returned in string form, and the caller is
+ * responsible for freeing it.
+ *
+ * Returns 0 on success, -ve on error.
+ */
+int
+dns_resolve_unc_to_ip(const char *unc, char **ip_addr)
+{
+	struct in_addr s4;
+	struct in6_addr	s6;
+	char *name, *sep;
+	int len, rc;
+
+	kenter("%s,", unc);
+
+	rc = -EINVAL;
+	if (!ip_addr || !unc)
+		goto out;
+
+	len = strlen(unc);
+	if (len < 3)
+		goto out;
+
+	/* discount leading slashes for cifs */
+	len -= 2;
+	unc += 2;
+
+	/* search for server name delimiter */
+	sep = memchr(unc, '\\', len);
+	if (sep)
+		len = sep - unc;
+	kdebug("server name:%*.*s", len, len, unc);
+
+	rc = -ENOMEM;
+	name = kmalloc(len + 1, GFP_KERNEL);
+	if (!name)
+		goto out;
+
+	memcpy(name, unc, len);
+	name[len] = 0;
+	kdebug("name to resolve '%s'", name);
+
+	/* Try to convert a string to an IPv4 address */
+	rc = in4_pton(name, len, (void *)&s4.s_addr, '\\', NULL);
+	if (rc > 0) {
+		*ip_addr = name;
+		kleave(" = 0 [UNC is IPv4]");
+		return 0;
+	}
+
+	/* Try to convert a string to an IPv6 address */
+	rc = in6_pton(name, len, (void *)&s6.s6_addr, '\\', NULL);
+	if (rc > 0) {
+		*ip_addr = name;
+		kleave(" = 0 [UNC is IPv6]");
+		return 0;
+	}
+
+	/* perform the upcall */
+	rc = request_dns_resolution(name, NULL, ip_addr);
+	kfree(name);
+
+out:
+	kleave(" = %d", rc);
+	return rc;
+}
+EXPORT_SYMBOL(dns_resolve_unc_to_ip);
