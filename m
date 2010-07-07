From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] Provide generic DNS query function
Date: Wed, 07 Jul 2010 10:14:16 +0100
Message-ID: <20100707091416.16573.62091.stgit@warthog.procyon.org.uk>
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

Provide a way of making generic DNS queries.  Note that the upcall service
program may process the result before returning it.

For example, if an AFSDB query is requested to find a list of Volume Location
servers for a cell, that would only get a list of server names.  That, however,
is not what the kernel needs, so the upcall program makes secondary lookups to
turn those into IP addresses and then instantiates the key with a string
consisting of a comma-separated list of IP addresses.

Signed-off-by: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 include/linux/dns_resolver.h |    2 +
 net/dnsresolver/Makefile     |    2 -
 net/dnsresolver/dns_query.c  |  130 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletions(-)
 create mode 100644 net/dnsresolver/dns_query.c

diff --git a/include/linux/dns_resolver.h b/include/linux/dns_resolver.h
index 72b9edf..328cc05 100644
--- a/include/linux/dns_resolver.h
+++ b/include/linux/dns_resolver.h
@@ -29,6 +29,8 @@
 extern int request_dns_resolution(const char *description, const char *options,
 				  char **result);
 extern int dns_resolve_unc_to_ip(const char *unc, char **ip_addr);
+extern int dns_query(const char *type, const char *name, const char *inetf,
+		     char **_result, time_t *_expiry);
 
 #endif /* KERNEL */
 
diff --git a/net/dnsresolver/Makefile b/net/dnsresolver/Makefile
index 260ccc4..aa7e422 100644
--- a/net/dnsresolver/Makefile
+++ b/net/dnsresolver/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_DNS_RESOLVER) += dnsresolver.o
 
-dnsresolver-objs :=  dns_resolver.o resolv_unc_to_ip.o
+dnsresolver-objs :=  dns_resolver.o resolv_unc_to_ip.o dns_query.o
diff --git a/net/dnsresolver/dns_query.c b/net/dnsresolver/dns_query.c
new file mode 100644
index 0000000..61ef026
--- /dev/null
+++ b/net/dnsresolver/dns_query.c
@@ -0,0 +1,130 @@
+/*
+ *   Copyright (c) 2010 Wang Lei
+ *   Author(s): Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
+ *		David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
+#include <keys/dnsresolver-type.h>
+#include <keys/user-type.h>
+
+#include "internal.h"
+
+/**
+ * dns_query - Query DNS
+ * @type: Query type
+ * @name: Name to look up
+ * @options: Space-separated options appropriate to the query type
+ * @_result: Where to return the result
+ * @_expiry: Where to store the result expiry time (or NULL)
+ *
+ * The result is copied into a buffer and returned in *_result.  The caller is
+ * responsible for freeing this buffer.  The result is NUL-terminated, though
+ * the termination is not included in the result size.  Optionally, the time at
+ * which the result expires is stored in *_expiry.
+ *
+ * Note that the upcall program may have edited the result from what the DNS
+ * server returned, for example to turn hostnames obtained by the lookup into
+ * IP addresses for the AFSDB query type.
+ *
+ * The options may include such things as IP address family ("ipv4" or "ipv6")
+ *
+ * Returns the size of the result on success, -ve error code otherwise.
+ */
+int dns_query(const char *type, const char *name, const char *options,
+	      char **_result, time_t *_expiry)
+{
+	struct key *rkey;
+	size_t typelen, namelen;
+	struct user_key_payload *upayload;
+	char *desc;
+	int ret, len;
+
+	kenter("%s,%s,%s,,,", type, name, options);
+
+	ret =  -EINVAL;
+	if (!type || !name || !_result)
+		goto err;
+
+	typelen = strlen(type);
+	namelen = strlen(name);
+	if (typelen < 1 || namelen < 3)
+		goto err;
+
+	ret = -ENOMEM;
+	/* construct the query key description as "<type>:<name>" */
+	desc = kmalloc(typelen + 1 + namelen + 1, GFP_KERNEL);
+	if (!desc)
+		goto err;
+
+	memcpy(desc, type, typelen);
+	desc[typelen] = ':';
+	memcpy(desc + typelen + 1, name, namelen + 1);
+
+	if (!options)
+		options = "";
+	kdebug("call request_key(,%s,%s)", desc, options);
+
+	/* make the upcall */
+	rkey = request_key(&key_type_dns_resolver, desc, options);
+	kfree(desc);
+
+	if (IS_ERR(rkey)) {
+		ret = PTR_ERR(rkey);
+		goto err;
+	}
+
+	down_read(&rkey->sem);
+
+	upayload = rcu_dereference_check(rkey->payload.data,
+					 lockdep_is_held(&rkey->sem));
+	len = upayload->datalen;
+	*_result = kmalloc(len + 1, GFP_KERNEL);
+	if (!*_result) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(*_result, upayload->data, len + 1);
+	if (_expiry)
+		*_expiry = rkey->expiry;
+	ret = len;
+
+
+out:
+	up_read(&rkey->sem);
+	key_put(rkey);
+
+err:
+	kleave(" = %d [r=%s]", ret, *_result);
+	return ret;
+}
+EXPORT_SYMBOL(dns_query);
