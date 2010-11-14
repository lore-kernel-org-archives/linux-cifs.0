From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Add match_port check during looking for existing connection
Date: Sun, 14 Nov 2010 14:29:15 +0300
Message-ID: <1289734155-3613-2-git-send-email-piastryyy@gmail.com>
References: <1289734155-3613-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289734155-3613-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we have a share mounted by non-standard port and try to mount another share
on the same host with standard port, we connect the first share again that's wrong.
This patch fixes this bug.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f0d0c1a..483ccb2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1371,6 +1371,35 @@ cifs_parse_mount_options(char *options, const char *devname,
 }
 
 static bool
+match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
+{
+	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
+	unsigned short int port;
+
+	/* search for a connection with the default port if user doesn't
+	   specify the port manually */
+	port = htons(CIFS_PORT);
+
+	switch (addr->sa_family) {
+	case AF_INET:
+		if (addr4->sin_port)
+			port = addr4->sin_port;
+		if (port != server->addr.sockAddr.sin_port)
+			return false;
+		break;
+	case AF_INET6:
+		if (addr6->sin6_port)
+			port = addr6->sin6_port;
+		if (port != server->addr.sockAddr6.sin6_port)
+			return false;
+		break;
+	}
+
+	return true;
+}
+
+static bool
 match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 {
 	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
@@ -1381,9 +1410,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 		if (addr4->sin_addr.s_addr !=
 		    server->addr.sockAddr.sin_addr.s_addr)
 			return false;
-		if (addr4->sin_port &&
-		    addr4->sin_port != server->addr.sockAddr.sin_port)
-			return false;
 		break;
 	case AF_INET6:
 		if (!ipv6_addr_equal(&addr6->sin6_addr,
@@ -1392,9 +1418,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 		if (addr6->sin6_scope_id !=
 		    server->addr.sockAddr6.sin6_scope_id)
 			return false;
-		if (addr6->sin6_port &&
-		    addr6->sin6_port != server->addr.sockAddr6.sin6_port)
-			return false;
 		break;
 	}
 
@@ -1468,6 +1491,9 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 		if (!match_address(server, addr))
 			continue;
 
+		if (!match_port(server, addr))
+			continue;
+
 		if (!match_security(server, vol))
 			continue;
 
-- 
1.7.2.3
