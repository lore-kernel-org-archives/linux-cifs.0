From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Add match_port check during looking for an existing connection (try #2)
Date: Tue, 16 Nov 2010 10:48:30 +0300
Message-ID: <1289893710-7352-2-git-send-email-piastryyy@gmail.com>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289893710-7352-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we have a share mounted by non-standard port and try to mount another share
on the same host with standard port, we connect to the first share again -
that's wrong. This patch fixes this bug.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8bdf1cc..7956e7c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1439,6 +1439,39 @@ srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
 	}
 }
 
+/* If no port specified in addr structure, we try to match with 445 port
+   and if it fails - with 139 ports */
+static bool
+match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
+{
+	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
+	unsigned short int port, *sport;
+
+	switch (addr->sa_family) {
+	case AF_INET:
+		sport = &server->addr.sockAddr.sin_port;
+		port = addr4->sin_port;
+		break;
+	case AF_INET6:
+		sport = &server->addr.sockAddr6.sin6_port;
+		port = addr6->sin6_port;
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
@@ -1452,9 +1485,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 		if (addr4->sin_addr.s_addr !=
 		    server->addr.sockAddr.sin_addr.s_addr)
 			return false;
-		if (addr4->sin_port &&
-		    addr4->sin_port != server->addr.sockAddr.sin_port)
-			return false;
 		break;
 	case AF_INET6:
 		if (!ipv6_addr_equal(&addr6->sin6_addr,
@@ -1463,9 +1493,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 		if (addr6->sin6_scope_id !=
 		    server->addr.sockAddr6.sin6_scope_id)
 			return false;
-		if (addr6->sin6_port &&
-		    addr6->sin6_port != server->addr.sockAddr6.sin6_port)
-			return false;
 		break;
 	}
 
@@ -1534,6 +1561,9 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 				   (struct sockaddr *)&vol->srcaddr))
 			continue;
 
+		if (!match_port(server, addr))
+			continue;
+
 		if (!match_security(server, vol))
 			continue;
 
-- 
1.7.3.2
