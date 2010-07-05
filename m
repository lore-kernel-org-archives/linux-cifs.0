From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 03/09] cifs: define server-level cache index objects and register them
Date: Mon,  5 Jul 2010 18:12:15 +0530
Message-ID: <1278333735-30604-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-cachefs@redhat.com, David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Yes>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Define server-level cache index objects (as managed by TCP_ServerInfo structs)
and register then with FS-Cache. Each server object is created in the CIFS
top-level index object and is itself an index into which superblock-level
objects are inserted.

The server objects are now keyed by {IPaddress,family,port} tuple.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/Makefile   |    2 -
 fs/cifs/cache.c    |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsglob.h |    3 ++
 fs/cifs/connect.c  |    5 ++++
 fs/cifs/fscache.c  |   41 +++++++++++++++++++++++++++++++++++
 fs/cifs/fscache.h  |   14 +++++++++++
 6 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 fs/cifs/fscache.c

Index: cifs-2.6/fs/cifs/Makefile
===================================================================
--- cifs-2.6.orig/fs/cifs/Makefile
+++ cifs-2.6/fs/cifs/Makefile
@@ -12,4 +12,4 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spneg
 
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
-cifs-$(CONFIG_CIFS_FSCACHE) += cache.o
+cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
Index: cifs-2.6/fs/cifs/cache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/cache.c
+++ cifs-2.6/fs/cifs/cache.c
@@ -19,6 +19,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 #include "fscache.h"
+#include "cifs_debug.h"
 
 /*
  * CIFS filesystem definition for FS-Cache
@@ -44,3 +45,64 @@ void cifs_fscache_unregister(void)
 	fscache_unregister_netfs(&cifs_fscache_netfs);
 }
 
+/*
+ * Key layout of CIFS server cache index object
+ */
+struct cifs_server_key {
+	uint16_t	family;		/* address family */
+	uint16_t	port;		/* IP port */
+	union {
+		struct in_addr	ipv4_addr;
+		struct in6_addr	ipv6_addr;
+	} addr[0];
+};
+
+/*
+ * Server object keyed by {IPaddress,port,family} tuple
+ */
+static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
+				   void *buffer, uint16_t maxbuf)
+{
+	const struct TCP_Server_Info *server = cookie_netfs_data;
+	const struct sockaddr *sa = (struct sockaddr *) &server->addr.sockAddr;
+	struct cifs_server_key *key = buffer;
+	uint16_t key_len = sizeof(struct cifs_server_key);
+
+	memset(key, 0, key_len);
+
+	/*
+	 * Should not be a problem as sin_family/sin6_family overlays
+	 * sa_family field
+	 */
+	switch (sa->sa_family) {
+	case AF_INET:
+		key->family = server->addr.sockAddr.sin_family;
+		key->port = server->addr.sockAddr.sin_port;
+		key->addr[0].ipv4_addr = server->addr.sockAddr.sin_addr;
+		key_len += sizeof(key->addr[0].ipv4_addr);
+		break;
+
+	case AF_INET6:
+		key->family = server->addr.sockAddr6.sin6_family;
+		key->port = server->addr.sockAddr6.sin6_port;
+		key->addr[0].ipv6_addr = server->addr.sockAddr6.sin6_addr;
+		key_len += sizeof(key->addr[0].ipv6_addr);
+		break;
+
+	default:
+		cERROR(1, "CIFS: Unknown network family '%d'", sa->sa_family);
+		key_len = 0;
+		break;
+	}
+
+	return key_len;
+}
+
+/*
+ * Server object for FS-Cache
+ */
+const struct fscache_cookie_def cifs_fscache_server_index_def = {
+	.name = "CIFS.server",
+	.type = FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key = cifs_server_get_key,
+};
Index: cifs-2.6/fs/cifs/cifsglob.h
===================================================================
--- cifs-2.6.orig/fs/cifs/cifsglob.h
+++ cifs-2.6/fs/cifs/cifsglob.h
@@ -190,6 +190,9 @@ struct TCP_Server_Info {
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
 	bool	sec_ntlmssp;		/* supports NTLMSSP */
+#ifdef CONFIG_CIFS_FSCACHE
+	struct fscache_cookie   *fscache; /* client index cache cookie */
+#endif
 };
 
 /*
Index: cifs-2.6/fs/cifs/connect.c
===================================================================
--- cifs-2.6.orig/fs/cifs/connect.c
+++ cifs-2.6/fs/cifs/connect.c
@@ -48,6 +48,7 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "cn_cifs.h"
+#include "fscache.h"
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -1460,6 +1461,8 @@ cifs_put_tcp_session(struct TCP_Server_I
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
 
+	cifs_fscache_release_client_cookie(server);
+
 	task = xchg(&server->tsk, NULL);
 	if (task)
 		force_sig(SIGKILL, task);
@@ -1577,6 +1580,8 @@ cifs_get_tcp_session(struct smb_vol *vol
 	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
 	write_unlock(&cifs_tcp_ses_lock);
 
+	cifs_fscache_get_client_cookie(tcp_ses);
+
 	return tcp_ses;
 
 out_err:
Index: cifs-2.6/fs/cifs/fscache.c
===================================================================
--- /dev/null
+++ cifs-2.6/fs/cifs/fscache.c
@@ -0,0 +1,41 @@
+/*
+ *   fs/cifs/fscache.c - CIFS filesystem cache interface
+ *
+ *   Copyright (c) 2010 Novell, Inc.
+ *   Author(s): Suresh Jayaraman (sjayaraman@suse.de>
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
+#include "fscache.h"
+#include "cifsglob.h"
+#include "cifs_debug.h"
+
+void cifs_fscache_get_client_cookie(struct TCP_Server_Info *server)
+{
+	server->fscache =
+		fscache_acquire_cookie(cifs_fscache_netfs.primary_index,
+				&cifs_fscache_server_index_def, server);
+	cFYI(1, "CIFS: get client cookie (0x%p/0x%p)", server,
+				server->fscache);
+}
+
+void cifs_fscache_release_client_cookie(struct TCP_Server_Info *server)
+{
+	cFYI(1, "CIFS: release client cookie (0x%p/0x%p)", server,
+				server->fscache);
+	fscache_relinquish_cookie(server->fscache, 0);
+	server->fscache = NULL;
+}
+
Index: cifs-2.6/fs/cifs/fscache.h
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.h
+++ cifs-2.6/fs/cifs/fscache.h
@@ -23,17 +23,31 @@
 
 #include <linux/fscache.h>
 
+#include "cifsglob.h"
+
 #ifdef CONFIG_CIFS_FSCACHE
 
 extern struct fscache_netfs cifs_fscache_netfs;
+extern const struct fscache_cookie_def cifs_fscache_server_index_def;
 
 extern int cifs_fscache_register(void);
 extern void cifs_fscache_unregister(void);
 
+/*
+ * fscache.c
+ */
+extern void cifs_fscache_get_client_cookie(struct TCP_Server_Info *);
+extern void cifs_fscache_release_client_cookie(struct TCP_Server_Info *);
+
 #else /* CONFIG_CIFS_FSCACHE */
 static inline int cifs_fscache_register(void) { return 0; }
 static inline void cifs_fscache_unregister(void) {}
 
+static inline void
+cifs_fscache_get_client_cookie(struct TCP_Server_Info *server) {}
+static inline void
+cifs_fscache_get_client_cookie(struct TCP_Server_Info *server); {}
+
 #endif /* CONFIG_CIFS_FSCACHE */
 
 #endif /* _CIFS_FSCACHE_H */
