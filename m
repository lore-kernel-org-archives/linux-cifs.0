From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] cifs: move address comparison into separate function
Date: Sun, 20 Jun 2010 17:10:47 -0400
Message-ID: <1277068251-16344-3-git-send-email-jlayton@redhat.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move the address comparator out of cifs_find_tcp_session and into a
separate function for cleanliness. Also change the argument to
that function to a "struct sockaddr" pointer. Passing pointers to
sockaddr_storage is a little odd since that struct is generally for
declaring static storage.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   73 ++++++++++++++++++++++++++---------------------------
 1 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 640c7d5..665ee37 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1380,18 +1380,44 @@ cifs_parse_mount_options(char *options, const char *devname,
 	return 0;
 }
 
+static bool
+match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
+{
+	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
+
+	switch (addr->sa_family) {
+	case AF_INET:
+		if (addr4->sin_addr.s_addr !=
+		    server->addr.sockAddr.sin_addr.s_addr)
+			return false;
+		if (addr4->sin_port &&
+		    addr4->sin_port != server->addr.sockAddr.sin_port)
+			return false;
+		break;
+	case AF_INET6:
+		if (!ipv6_addr_equal(&addr6->sin6_addr,
+				     &server->addr.sockAddr6.sin6_addr))
+			return false;
+		if (addr6->sin6_scope_id !=
+		    server->addr.sockAddr6.sin6_scope_id)
+			return false;
+		if (addr6->sin6_port &&
+		    addr6->sin6_port != server->addr.sockAddr6.sin6_port)
+			return false;
+		break;
+	}
+
+	return true;
+}
+
 static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr_storage *addr)
+cifs_find_tcp_session(struct sockaddr *addr)
 {
-	struct list_head *tmp;
 	struct TCP_Server_Info *server;
-	struct sockaddr_in *addr4 = (struct sockaddr_in *) addr;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *) addr;
 
 	write_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &cifs_tcp_ses_list) {
-		server = list_entry(tmp, struct TCP_Server_Info,
-				    tcp_ses_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		/*
 		 * the demux thread can exit on its own while still in CifsNew
 		 * so don't accept any sockets in that state. Since the
@@ -1401,35 +1427,8 @@ cifs_find_tcp_session(struct sockaddr_storage *addr)
 		if (server->tcpStatus == CifsNew)
 			continue;
 
-		switch (addr->ss_family) {
-		case AF_INET:
-			if (addr4->sin_addr.s_addr ==
-			    server->addr.sockAddr.sin_addr.s_addr) {
-				/* user overrode default port? */
-				if (addr4->sin_port) {
-					if (addr4->sin_port !=
-					    server->addr.sockAddr.sin_port)
-						continue;
-				}
-				break;
-			} else
-				continue;
-
-		case AF_INET6:
-			if (ipv6_addr_equal(&addr6->sin6_addr,
-			    &server->addr.sockAddr6.sin6_addr) &&
-			    (addr6->sin6_scope_id ==
-			    server->addr.sockAddr6.sin6_scope_id)) {
-				/* user overrode default port? */
-				if (addr6->sin6_port) {
-					if (addr6->sin6_port !=
-					   server->addr.sockAddr6.sin6_port)
-						continue;
-				}
-				break;
-			} else
-				continue;
-		}
+		if (!match_address(server, addr))
+			continue;
 
 		++server->srv_count;
 		write_unlock(&cifs_tcp_ses_lock);
@@ -1499,7 +1498,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 
 	/* see if we already have a matching tcp_ses */
-	tcp_ses = cifs_find_tcp_session(&addr);
+	tcp_ses = cifs_find_tcp_session((struct sockaddr *)&addr);
 	if (tcp_ses)
 		return tcp_ses;
 
-- 
1.6.6.1
