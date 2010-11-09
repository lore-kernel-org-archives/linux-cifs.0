From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Tue,  9 Nov 2010 19:50:25 +0300
Message-ID: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch fixes the following situation: we have the share (1) mounted
with a non-standard port and try to mount another share (2) with the standard
one (not specifying the port), the client doesn't connect to the new share (2)
and returns with existing connection (1). The patch also makes the client
prevent connecting to a wrong share on a reconnect if the client fails during
the re-establishing connection to a lost share.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   86 ++++++++++++++++++++++++++---------------------------
 1 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 251a17c..6edf5ed 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1446,25 +1446,32 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 {
 	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
+	unsigned short int port;
+
+	/* search for a connection with the default port if user doesn't
+	   specify the port manually */
+	port = htons(CIFS_PORT);
 
 	switch (addr->sa_family) {
 	case AF_INET:
+		if (addr4->sin_port)
+			port = addr4->sin_port;
 		if (addr4->sin_addr.s_addr !=
 		    server->addr.sockAddr.sin_addr.s_addr)
 			return false;
-		if (addr4->sin_port &&
-		    addr4->sin_port != server->addr.sockAddr.sin_port)
+		if (port != server->addr.sockAddr.sin_port)
 			return false;
 		break;
 	case AF_INET6:
+		if (addr6->sin6_port)
+			port = addr6->sin6_port;
 		if (!ipv6_addr_equal(&addr6->sin6_addr,
 				     &server->addr.sockAddr6.sin6_addr))
 			return false;
 		if (addr6->sin6_scope_id !=
 		    server->addr.sockAddr6.sin6_scope_id)
 			return false;
-		if (addr6->sin6_port &&
-		    addr6->sin6_port != server->addr.sockAddr6.sin6_port)
+		if (port != server->addr.sockAddr6.sin6_port)
 			return false;
 		break;
 	}
@@ -2126,7 +2133,7 @@ ipv4_connect(struct TCP_Server_Info *server)
 	int rc = 0;
 	int val;
 	bool connected = false;
-	__be16 orig_port = 0;
+	bool orig_port_error = false;
 	struct socket *socket = server->ssocket;
 
 	if (socket == NULL) {
@@ -2148,32 +2155,30 @@ ipv4_connect(struct TCP_Server_Info *server)
 	if (rc < 0)
 		return rc;
 
-	/* user overrode default port */
+	/* user overrode default port or we perform reconnect */
 	if (server->addr.sockAddr.sin_port) {
 		rc = socket->ops->connect(socket, (struct sockaddr *)
 					  &server->addr.sockAddr,
 					  sizeof(struct sockaddr_in), 0);
 		if (rc >= 0)
 			connected = true;
+		else
+			orig_port_error = true;
+		/* in this case we don't have to try other port
+		   because we can mount another share */
 	}
 
-	if (!connected) {
-		/* save original port so we can retry user specified port
-			later if fall back ports fail this time  */
-		orig_port = server->addr.sockAddr.sin_port;
-
-		/* do not retry on the same port we just failed on */
-		if (server->addr.sockAddr.sin_port != htons(CIFS_PORT)) {
-			server->addr.sockAddr.sin_port = htons(CIFS_PORT);
-			rc = socket->ops->connect(socket,
-						(struct sockaddr *)
-						&server->addr.sockAddr,
-						sizeof(struct sockaddr_in), 0);
-			if (rc >= 0)
-				connected = true;
-		}
+	if (!orig_port_error && !connected) {
+		server->addr.sockAddr.sin_port = htons(CIFS_PORT);
+		rc = socket->ops->connect(socket,
+					(struct sockaddr *)
+					&server->addr.sockAddr,
+					sizeof(struct sockaddr_in), 0);
+		if (rc >= 0)
+			connected = true;
 	}
-	if (!connected) {
+
+	if (!orig_port_error && !connected) {
 		server->addr.sockAddr.sin_port = htons(RFC1001_PORT);
 		rc = socket->ops->connect(socket, (struct sockaddr *)
 					      &server->addr.sockAddr,
@@ -2185,15 +2190,12 @@ ipv4_connect(struct TCP_Server_Info *server)
 	/* give up here - unless we want to retry on different
 		protocol families some day */
 	if (!connected) {
-		if (orig_port)
-			server->addr.sockAddr.sin_port = orig_port;
 		cFYI(1, "Error %d connecting to server via ipv4", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
 	}
 
-
 	/*
 	 * Eventually check for other socket options to change from
 	 *  the default. sock_setsockopt not used because it expects
@@ -2291,7 +2293,7 @@ ipv6_connect(struct TCP_Server_Info *server)
 	int rc = 0;
 	int val;
 	bool connected = false;
-	__be16 orig_port = 0;
+	bool orig_port_error = false;
 	struct socket *socket = server->ssocket;
 
 	if (socket == NULL) {
@@ -2314,31 +2316,29 @@ ipv6_connect(struct TCP_Server_Info *server)
 	if (rc < 0)
 		return rc;
 
-	/* user overrode default port */
+	/* user overrode default port or we perform reconnect */
 	if (server->addr.sockAddr6.sin6_port) {
 		rc = socket->ops->connect(socket,
 				(struct sockaddr *) &server->addr.sockAddr6,
 				sizeof(struct sockaddr_in6), 0);
 		if (rc >= 0)
 			connected = true;
+		else
+			orig_port_error = true;
+		/* in this case we don't have to try other port
+		   because we can mount another share */
 	}
 
-	if (!connected) {
-		/* save original port so we can retry user specified port
-			later if fall back ports fail this time  */
-
-		orig_port = server->addr.sockAddr6.sin6_port;
-		/* do not retry on the same port we just failed on */
-		if (server->addr.sockAddr6.sin6_port != htons(CIFS_PORT)) {
-			server->addr.sockAddr6.sin6_port = htons(CIFS_PORT);
-			rc = socket->ops->connect(socket, (struct sockaddr *)
-					&server->addr.sockAddr6,
-					sizeof(struct sockaddr_in6), 0);
-			if (rc >= 0)
-				connected = true;
-		}
+	if (!orig_port_error && !connected) {
+		server->addr.sockAddr6.sin6_port = htons(CIFS_PORT);
+		rc = socket->ops->connect(socket, (struct sockaddr *)
+				&server->addr.sockAddr6,
+				sizeof(struct sockaddr_in6), 0);
+		if (rc >= 0)
+			connected = true;
 	}
-	if (!connected) {
+
+	if (!orig_port_error && !connected) {
 		server->addr.sockAddr6.sin6_port = htons(RFC1001_PORT);
 		rc = socket->ops->connect(socket, (struct sockaddr *)
 				&server->addr.sockAddr6,
@@ -2350,8 +2350,6 @@ ipv6_connect(struct TCP_Server_Info *server)
 	/* give up here - unless we want to retry on different
 		protocol families some day */
 	if (!connected) {
-		if (orig_port)
-			server->addr.sockAddr6.sin6_port = orig_port;
 		cFYI(1, "Error %d connecting to server via ipv6", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
-- 
1.7.2.3
