From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] DNS: Separate out CIFS DNS Resolver code
Date: Wed, 04 Aug 2010 15:16:33 +0100
Message-ID: <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Separate out the DNS resolver key type from the CIFS filesystem into its own
module so that it can be made available for general use, including the AFS
filesystem module.

This facility makes it possible for the kernel to upcall to userspace to have
it issue DNS requests, package up the replies and present them to the kernel
in a useful form.  The kernel is then able to cache the DNS replies as keys
can be retained in keyrings.

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
part remains in the CIFS module for now.

See the added Documentation/networking/dns_resolver.txt for more information.

Signed-off-by: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 Documentation/networking/dns_resolver.txt |  146 ++++++++++++++++++
 fs/cifs/Kconfig                           |   17 +-
 fs/cifs/cifsfs.c                          |   13 --
 fs/cifs/dns_resolve.c                     |  229 ++++++-----------------------
 fs/cifs/dns_resolve.h                     |    2 
 include/keys/dns_resolver-type.h          |   23 +++
 include/linux/dns_resolver.h              |   34 ++++
 net/Kconfig                               |    1 
 net/Makefile                              |    1 
 net/dns_resolver/Kconfig                  |   27 +++
 net/dns_resolver/Makefile                 |    7 +
 net/dns_resolver/dns_key.c                |  210 +++++++++++++++++++++++++++
 net/dns_resolver/dns_query.c              |  159 ++++++++++++++++++++
 net/dns_resolver/internal.h               |   44 ++++++
 14 files changed, 708 insertions(+), 205 deletions(-)
 create mode 100644 Documentation/networking/dns_resolver.txt
 create mode 100644 include/keys/dns_resolver-type.h
 create mode 100644 include/linux/dns_resolver.h
 create mode 100644 net/dns_resolver/Kconfig
 create mode 100644 net/dns_resolver/Makefile
 create mode 100644 net/dns_resolver/dns_key.c
 create mode 100644 net/dns_resolver/dns_query.c
 create mode 100644 net/dns_resolver/internal.h

diff --git a/Documentation/networking/dns_resolver.txt b/Documentation/networking/dns_resolver.txt
new file mode 100644
index 0000000..d8e0ce1
--- /dev/null
+++ b/Documentation/networking/dns_resolver.txt
@@ -0,0 +1,146 @@
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
+ (1) int dns_query(const char *type, const char *name, size_t namelen,
+		   const char *options, char **_result, time_t *_expiry);
+
+     This is the basic access function.  It looks for a cached DNS query and if
+     it doesn't find it, it upcalls to userspace to make a new DNS query, which
+     may then be cached.  The key description is constructed as a string of the
+     form:
+
+		[<type>:]<name>
+
+     where <type> optionally specifies the particular upcall program to invoke,
+     and thus the type of query to do, and <name> specifies the string to be
+     looked up.  The default query type is a straight hostname to IP address
+     set lookup.
+
+     The name parameter is not required to be a NUL-terminated string, and its
+     length should be given by the namelen argument.
+
+     The options parameter may be NULL or it may be a set of options
+     appropriate to the query type.
+
+     The return value is a string appropriate to the query type.  For instance,
+     for the default query type it is just a list of comma-separated IPv4 and
+     IPv6 addresses.  The caller must free the result.
+
+     The length of the result string is returned on success, and a -ve error
+     code is returned otherwise.  -EKEYREJECTED will be returned if the DNS
+     lookup failed.
+
+     If _expiry is non-NULL, the expiry time (TTL) of the result will be
+     returned also.
+
+
+=========
+MECHANISM
+=========
+
+The dnsresolver module registers a key type called "dns_resolver".  Keys of
+this type are used to transport and cache DNS lookup results from userspace.
+
+When dns_query() is invoked, it calls request_key() to search the local
+keyrings for a cached DNS result.  If that fails to find one, it upcalls to
+userspace to get a new result.
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
+dns_query() returns a copy of the value attached to the key, or an error if
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
index 5739fd7..57f0aa9 100644
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
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8a2cf12..2a0c892 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -45,7 +45,6 @@
 #include "cifs_fs_sb.h"
 #include <linux/mm.h>
 #include <linux/key-type.h>
-#include "dns_resolve.h"
 #include "cifs_spnego.h"
 #include "fscache.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
@@ -934,22 +933,13 @@ init_cifs(void)
 	if (rc)
 		goto out_unregister_filesystem;
 #endif
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	rc = cifs_init_dns_resolver();
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
-	cifs_exit_dns_resolver();
  out_unregister_key_type:
-#endif
 #ifdef CONFIG_CIFS_UPCALL
 	unregister_key_type(&cifs_spnego_key_type);
  out_unregister_filesystem:
@@ -976,7 +966,6 @@ exit_cifs(void)
 	cifs_fscache_unregister();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
-	cifs_exit_dns_resolver();
 #endif
 #ifdef CONFIG_CIFS_UPCALL
 	unregister_key_type(&cifs_spnego_key_type);
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index aa967e7..39a323d 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -4,6 +4,8 @@
  *   Copyright (c) 2007 Igor Mammedov
  *   Author(s): Igor Mammedov (niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
  *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *		David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
  *
  *   Contains the CIFS DFS upcall routines used for hostname to
  *   IP address translation.
@@ -24,212 +26,73 @@
  */
 
 #include <linux/slab.h>
-#include <linux/keyctl.h>
-#include <linux/key-type.h>
-#include <keys/user-type.h>
+#include <linux/dns_resolver.h>
 #include "dns_resolve.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
-static const struct cred *dns_resolver_cache;
-
-/* Checks if supplied name is IP address
- * returns:
- * 		1 - name is IP
- * 		0 - name is not IP
- */
-static int
-is_ip(const char *name, int len)
-{
-	struct sockaddr_storage ss;
-
-	return cifs_convert_address((struct sockaddr *)&ss, name, len);
-}
-
-static int
-dns_resolver_instantiate(struct key *key, const void *data,
-		size_t datalen)
-{
-	int rc = 0;
-	char *ip;
-
-	/* make sure this looks like an address */
-	if (!is_ip(data, datalen))
-		return -EINVAL;
-
-	ip = kmalloc(datalen + 1, GFP_KERNEL);
-	if (!ip)
-		return -ENOMEM;
-
-	memcpy(ip, data, datalen);
-	ip[datalen] = '\0';
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
- * return the length of the returned string on success
+/**
+ * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
+ * @unc: UNC path specifying the server
+ * @ip_addr: Where to return the IP address.
+ *
+ * The IP address will be returned in string form, and the caller is
+ * responsible for freeing it.
+ *
+ * Returns length of result on success, -ve on error.
  */
 int
 dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 {
-	const struct cred *saved_cred;
-	int rc = -EAGAIN;
-	struct key *rkey = ERR_PTR(-EAGAIN);
+	struct sockaddr_storage ss;
+	const char *hostname, *sep;
 	char *name;
-	char *data = NULL;
-	int len;
+	int len, rc;
 
 	if (!ip_addr || !unc)
 		return -EINVAL;
 
-	/* search for server name delimiter */
 	len = strlen(unc);
 	if (len < 3) {
 		cFYI(1, "%s: unc is too short: %s", __func__, unc);
 		return -EINVAL;
 	}
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
-	if (is_ip(name, len)) {
-		cFYI(1, "%s: it is IP, skipping dns upcall: %s",
-					__func__, name);
-		data = name;
-		goto skip_upcall;
-	}
 
-	saved_cred = override_creds(dns_resolver_cache);
-	rkey = request_key(&key_type_dns_resolver, name, "");
-	revert_creds(saved_cred);
-	if (!IS_ERR(rkey)) {
-		if (!(rkey->perm & KEY_USR_VIEW)) {
-			down_read(&rkey->sem);
-			rkey->perm |= KEY_USR_VIEW;
-			up_read(&rkey->sem);
-		}
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
-			rc = len;
-		} else {
-			rc = -ENOMEM;
-		}
-		if (!IS_ERR(rkey))
-			key_put(rkey);
-	}
+	/* Discount leading slashes for cifs */
+	len -= 2;
+	hostname = unc + 2;
 
-out:
-	kfree(name);
+	/* Search for server name delimiter */
+	sep = memchr(hostname, '\\', len);
+	if (sep)
+		len = sep - unc;
+	else
+		cFYI(1, "%s: probably server name is whole unc: %s",
+		     __func__, unc);
+
+	/* Try to interpret hostname as an IPv4 or IPv6 address */
+	rc = cifs_convert_address((struct sockaddr*)&ss, hostname, len);
+	if (rc > 0)
+		goto name_is_IP_address;
+
+	/* Perform the upcall */
+	rc = dns_query(NULL, hostname, len, NULL, ip_addr, NULL);
+	if (rc < 0)
+		cERROR(1, "%s: unable to resolve: %*.*s",
+		       __func__, len, len, hostname);
+	else
+		cFYI(1, "%s: resolved: %*.*s to %s",
+		     __func__, len, len, hostname, *ip_addr);
 	return rc;
-}
 
-int __init cifs_init_dns_resolver(void)
-{
-	struct cred *cred;
-	struct key *keyring;
-	int ret;
-
-	printk(KERN_NOTICE "Registering the %s key type\n",
-	       key_type_dns_resolver.name);
-
-	/* create an override credential set with a special thread keyring in
-	 * which DNS requests are cached
-	 *
-	 * this is used to prevent malicious redirections from being installed
-	 * with add_key().
-	 */
-	cred = prepare_kernel_cred(NULL);
-	if (!cred)
+name_is_IP_address:
+	name = kmalloc(len + 1, GFP_KERNEL);
+	if (!name)
 		return -ENOMEM;
-
-	keyring = key_alloc(&key_type_keyring, ".dns_resolver", 0, 0, cred,
-			    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
-			    KEY_USR_VIEW | KEY_USR_READ,
-			    KEY_ALLOC_NOT_IN_QUOTA);
-	if (IS_ERR(keyring)) {
-		ret = PTR_ERR(keyring);
-		goto failed_put_cred;
-	}
-
-	ret = key_instantiate_and_link(keyring, NULL, 0, NULL, NULL);
-	if (ret < 0)
-		goto failed_put_key;
-
-	ret = register_key_type(&key_type_dns_resolver);
-	if (ret < 0)
-		goto failed_put_key;
-
-	/* instruct request_key() to use this special keyring as a cache for
-	 * the results it looks up */
-	cred->thread_keyring = keyring;
-	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
-	dns_resolver_cache = cred;
+	memcpy(name, hostname, len);
+	name[len] = 0;
+	cFYI(1, "%s: unc is IP, skipping dns upcall: %s", __func__, name);
+	*ip_addr = name;
 	return 0;
-
-failed_put_key:
-	key_put(keyring);
-failed_put_cred:
-	put_cred(cred);
-	return ret;
-}
-
-void cifs_exit_dns_resolver(void)
-{
-	key_revoke(dns_resolver_cache->thread_keyring);
-	unregister_key_type(&key_type_dns_resolver);
-	put_cred(dns_resolver_cache);
-	printk(KERN_NOTICE "Unregistered %s key type\n",
-	       key_type_dns_resolver.name);
 }
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index 5d7f291..d3f5d27 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -24,8 +24,6 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
-extern int __init cifs_init_dns_resolver(void);
-extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
 
diff --git a/include/keys/dns_resolver-type.h b/include/keys/dns_resolver-type.h
new file mode 100644
index 0000000..9284a19
--- /dev/null
+++ b/include/keys/dns_resolver-type.h
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
index 0000000..cc92268
--- /dev/null
+++ b/include/linux/dns_resolver.h
@@ -0,0 +1,34 @@
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
+#ifndef _LINUX_DNS_RESOLVER_H
+#define _LINUX_DNS_RESOLVER_H
+
+#ifdef __KERNEL__
+
+extern int dns_query(const char *type, const char *name, size_t namelen,
+		     const char *options, char **_result, time_t *_expiry);
+
+#endif /* KERNEL */
+
+#endif /* _LINUX_DNS_RESOLVER_H */
diff --git a/net/Kconfig b/net/Kconfig
index 0d68b40..ad358e7 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -203,6 +203,7 @@ source "net/phonet/Kconfig"
 source "net/ieee802154/Kconfig"
 source "net/sched/Kconfig"
 source "net/dcb/Kconfig"
+source "net/dns_resolver/Kconfig"
 
 config RPS
 	boolean
diff --git a/net/Makefile b/net/Makefile
index cb7bdc1..d6030b4 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -67,3 +67,4 @@ ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
 endif
 obj-$(CONFIG_WIMAX)		+= wimax/
+obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
diff --git a/net/dns_resolver/Kconfig b/net/dns_resolver/Kconfig
new file mode 100644
index 0000000..2ec47cb
--- /dev/null
+++ b/net/dns_resolver/Kconfig
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
+	  See <file:Documentation/networking/dns_resolver.txt> for further
+	  information.
+
+	  To compile this as a module, choose M here: the module will be called
+	  dnsresolver.
+
+	  If unsure, say N.
diff --git a/net/dns_resolver/Makefile b/net/dns_resolver/Makefile
new file mode 100644
index 0000000..c0ef4e7
--- /dev/null
+++ b/net/dns_resolver/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux DNS Resolver.
+#
+
+obj-$(CONFIG_DNS_RESOLVER) += dns_resolver.o
+
+dns_resolver-objs :=  dns_key.o dns_query.o
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
new file mode 100644
index 0000000..1b1b411
--- /dev/null
+++ b/net/dns_resolver/dns_key.c
@@ -0,0 +1,210 @@
+/* Key type used to cache DNS lookups made by the kernel
+ *
+ * See Documentation/networking/dns_resolver.txt
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
+#include <linux/keyctl.h>
+#include <keys/dns_resolver-type.h>
+#include <keys/user-type.h>
+#include "internal.h"
+
+MODULE_DESCRIPTION("DNS Resolver");
+MODULE_AUTHOR("Wang Lei");
+MODULE_LICENSE("GPL");
+
+unsigned dns_resolver_debug;
+module_param_named(debug, dns_resolver_debug, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(debug, "DNS Resolver debugging mask");
+
+const struct cred *dns_resolver_cache;
+
+/*
+ * Instantiate a user defined key for dns_resolver.
+ *
+ * The data must be a NUL-terminated string, with the NUL char accounted in
+ * datalen.
+ *
+ * If the data contains a '#' characters, then we take the clause after each
+ * one to be an option of the form 'key=value'.  The actual data of interest is
+ * the string leading up to the first '#'.  For instance:
+ *
+ *        "ip1,ip2,...#foo=bar"
+ */
+static int
+dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
+{
+	struct user_key_payload *upayload;
+	int ret;
+	size_t result_len = 0;
+	const char *data = _data, *opt;
+
+	kenter("%%%d,%s,'%s',%zu",
+	       key->serial, key->description, data, datalen);
+
+	if (datalen <= 1 || !data || data[datalen - 1] != '\0')
+		return -EINVAL;
+	datalen--;
+
+	/* deal with any options embedded in the data */
+	opt = memchr(data, '#', datalen);
+	if (!opt) {
+		kdebug("no options currently supported");
+		return -EINVAL;
+	}
+
+	result_len = datalen;
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
+	upayload->datalen = result_len;
+	memcpy(upayload->data, data, result_len);
+	upayload->data[result_len] = '\0';
+	rcu_assign_pointer(key->payload.data, upayload);
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
+static int __init init_dns_resolver(void)
+{
+	struct cred *cred;
+	struct key *keyring;
+	int ret;
+
+	printk(KERN_NOTICE "Registering the %s key type\n",
+	       key_type_dns_resolver.name);
+
+	/* create an override credential set with a special thread keyring in
+	 * which DNS requests are cached
+	 *
+	 * this is used to prevent malicious redirections from being installed
+	 * with add_key().
+	 */
+	cred = prepare_kernel_cred(NULL);
+	if (!cred)
+		return -ENOMEM;
+
+	keyring = key_alloc(&key_type_keyring, ".dns_resolver", 0, 0, cred,
+			    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			    KEY_USR_VIEW | KEY_USR_READ,
+			    KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(keyring)) {
+		ret = PTR_ERR(keyring);
+		goto failed_put_cred;
+	}
+
+	ret = key_instantiate_and_link(keyring, NULL, 0, NULL, NULL);
+	if (ret < 0)
+		goto failed_put_key;
+
+	ret = register_key_type(&key_type_dns_resolver);
+	if (ret < 0)
+		goto failed_put_key;
+
+	/* instruct request_key() to use this special keyring as a cache for
+	 * the results it looks up */
+	cred->thread_keyring = keyring;
+	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
+	dns_resolver_cache = cred;
+
+	kdebug("DNS resolver keyring: %d\n", key_serial(keyring));
+	return 0;
+
+failed_put_key:
+	key_put(keyring);
+failed_put_cred:
+	put_cred(cred);
+	return ret;
+}
+
+static void __exit exit_dns_resolver(void)
+{
+	key_revoke(dns_resolver_cache->thread_keyring);
+	unregister_key_type(&key_type_dns_resolver);
+	put_cred(dns_resolver_cache);
+	printk(KERN_NOTICE "Unregistered %s key type\n",
+	       key_type_dns_resolver.name);
+}
+
+module_init(init_dns_resolver)
+module_exit(exit_dns_resolver)
+MODULE_LICENSE("GPL");
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
new file mode 100644
index 0000000..6c0cf31
--- /dev/null
+++ b/net/dns_resolver/dns_query.c
@@ -0,0 +1,159 @@
+/* Upcall routine, designed to work as a key type and working through
+ * /sbin/request-key to contact userspace when handling DNS queries.
+ *
+ * See Documentation/networking/dns_resolver.txt
+ *
+ *   Copyright (c) 2007 Igor Mammedov
+ *   Author(s): Igor Mammedov (niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *		David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
+ *
+ *   The upcall wrapper used to make an arbitrary DNS query.
+ *
+ *   This function requires the appropriate userspace tool dns.upcall to be
+ *   installed and something like the following lines should be added to the
+ *   /etc/request-key.conf file:
+ *
+ *	create dns_resolver * * /sbin/dns.upcall %k
+ *
+ *   For example to use this module to query AFSDB RR:
+ *
+ *	create dns_resolver afsdb:* * /sbin/dns.afsdb %k
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
+#include <linux/dns_resolver.h>
+#include <keys/dns_resolver-type.h>
+#include <keys/user-type.h>
+
+#include "internal.h"
+
+/*
+ * dns_query - Query the DNS
+ * @type: Query type (or NULL for straight host->IP lookup)
+ * @name: Name to look up
+ * @namelen: Length of name
+ * @options: Request options (or NULL if no options)
+ * @_result: Where to place the returned data.
+ * @_expiry: Where to store the result expiry time (or NULL)
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
+ * Returns the size of the result on success, -ve error code otherwise.
+ */
+int dns_query(const char *type, const char *name, size_t namelen,
+	      const char *options, char **_result, time_t *_expiry)
+{
+	struct key *rkey;
+	struct user_key_payload *upayload;
+	const struct cred *saved_cred;
+	size_t typelen, desclen;
+	char *desc, *cp;
+	int ret, len;
+
+	kenter("%s,%*.*s,%zu,%s",
+	       type, (int)namelen, (int)namelen, name, namelen, options);
+
+	if (!name || namelen == 0 || !_result)
+		return -EINVAL;
+
+	/* construct the query key description as "[<type>:]<name>" */
+	typelen = 0;
+	desclen = 0;
+	if (type) {
+		typelen = strlen(type);
+		if (typelen < 1)
+			return -EINVAL;
+		desclen += typelen + 1;
+	}
+
+	if (!namelen)
+		namelen = strlen(name);
+	if (namelen < 3)
+		return -EINVAL;
+	desclen += namelen + 1;
+
+	desc = kmalloc(desclen, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	cp = desc;
+	if (type) {
+		memcpy(cp, type, typelen);
+		cp += typelen;
+		*cp++ = ':';
+	}
+	memcpy(cp, name, namelen);
+	cp += namelen;
+	*cp = '\0';
+
+	if (!options)
+		options = "";
+	kdebug("call request_key(,%s,%s)", desc, options);
+
+	/* make the upcall, using special credentials to prevent the use of
+	 * add_key() to preinstall malicious redirections
+	 */
+	saved_cred = override_creds(dns_resolver_cache);
+	rkey = request_key(&key_type_dns_resolver, desc, options);
+	revert_creds(saved_cred);
+	kfree(desc);
+	if (IS_ERR(rkey)) {
+		ret = PTR_ERR(rkey);
+		goto out;
+	}
+
+	down_read(&rkey->sem);
+	rkey->perm |= KEY_USR_VIEW;
+
+	ret = key_validate(rkey);
+	if (ret < 0)
+		goto put;
+
+	upayload = rcu_dereference_protected(rkey->payload.data,
+					     lockdep_is_held(&rkey->sem));
+	len = upayload->datalen;
+
+	ret = -ENOMEM;
+	*_result = kmalloc(len + 1, GFP_KERNEL);
+	if (!*_result)
+		goto put;
+
+	memcpy(*_result, upayload->data, len + 1);
+	if (_expiry)
+		*_expiry = rkey->expiry;
+
+	ret = len;
+put:
+	up_read(&rkey->sem);
+	key_put(rkey);
+out:
+	kleave(" = %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL(dns_query);
diff --git a/net/dns_resolver/internal.h b/net/dns_resolver/internal.h
new file mode 100644
index 0000000..189ca9e
--- /dev/null
+++ b/net/dns_resolver/internal.h
@@ -0,0 +1,44 @@
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
+ * dns_key.c
+ */
+extern const struct cred *dns_resolver_cache;
+
+/*
+ * debug tracing
+ */
+extern unsigned dns_resolver_debug;
+
+#define	kdebug(FMT, ...)				\
+do {							\
+	if (unlikely(dns_resolver_debug))		\
+		printk(KERN_DEBUG "[%-6.6s] "FMT"\n",	\
+		       current->comm, ##__VA_ARGS__);	\
+} while (0)
+
+#define kenter(FMT, ...) kdebug("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) kdebug("<== %s()"FMT"", __func__, ##__VA_ARGS__)
