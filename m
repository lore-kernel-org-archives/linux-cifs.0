From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Add match_port check during looking for an existing connection (try #4)
Date: Mon, 13 Dec 2010 22:32:53 +0300
Message-ID: <1292268773-2918-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we have a share mounted by non-standard port and try to mount another share
on the same host with standard port, we connect to the first share again -
that's wrong. This patch fixes this bug.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b90c741..41f002f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1453,6 +1453,40 @@ srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
 	}
 }
 
+/*
+ * If no port is specified in addr structure, we try to match with 445 port
+ * and if it fails - with 139 ports. It should be called only if address
+ * families of server and addr are equal.
+ */
+static bool
+match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
+{
+	unsigned short int port, *sport;
+
+	switch (addr->sa_family) {
+	case AF_INET:
+		sport = &((struct sockaddr_in *) &server->dstaddr)->sin_port;
+		port = ((struct sockaddr_in *) addr)->sin_port;
+		break;
+	case AF_INET6:
+		sport = &((struct sockaddr_in6 *) &server->dstaddr)->sin6_port;
+		port = ((struct sockaddr_in6 *) addr)->sin6_port;
+		break;
+	default:
+		WARN_ON(1);
+		return false;
+	}
+
+	if (!port) {
+		port = htons(CIFS_PORT);
+		if (port == *sport)
+			return true;
+
+		port = htons(RFC1001_PORT);
+	}
+
+	return port == *sport;
+}
 
 static bool
 match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
@@ -1466,8 +1500,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 
 		if (addr4->sin_addr.s_addr != srv_addr4->sin_addr.s_addr)
 			return false;
-		if (addr4->sin_port && addr4->sin_port != srv_addr4->sin_port)
-			return false;
 		break;
 	}
 	case AF_INET6: {
@@ -1480,9 +1512,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 			return false;
 		if (addr6->sin6_scope_id != srv_addr6->sin6_scope_id)
 			return false;
-		if (addr6->sin6_port &&
-		    addr6->sin6_port != srv_addr6->sin6_port)
-			return false;
 		break;
 	}
 	default:
@@ -1555,6 +1584,9 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 				   (struct sockaddr *)&vol->srcaddr))
 			continue;
 
+		if (!match_port(server, addr))
+			continue;
+
 		if (!match_security(server, vol))
 			continue;
 
-- 
1.7.3.2
