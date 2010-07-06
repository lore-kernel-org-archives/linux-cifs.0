From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: set the port in sockaddr in a more clearly defined fashion
Date: Tue,  6 Jul 2010 16:35:10 -0400
Message-ID: <1278448510-13199-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch should replace the patch I sent a couple of weeks ago to
set the port in cifs_convert_address.

Currently we set this in cifs_find_tcp_session, but that's more of a
side effect than anything. Add a new function called cifs_fill_sockaddr.
Have it call cifs_convert_address and then set the port.

This also allows us to skip passing in the port as a separate parm to
cifs_find_tcp_session.

Also, change cifs_convert_address take a struct sockaddr * rather than
void * to make it clearer how this function should be called.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h   |    4 +++-
 fs/cifs/connect.c     |   12 +++++-------
 fs/cifs/dns_resolve.c |    2 +-
 fs/cifs/netmisc.c     |   23 ++++++++++++++++++++++-
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fb6318b..2eaebbd 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -86,7 +86,9 @@ extern unsigned int smbCalcSize(struct smb_hdr *ptr);
 extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
-extern int cifs_convert_address(char *src, void *dst);
+extern int cifs_convert_address(struct sockaddr *dst, char *src);
+extern int cifs_fill_sockaddr(struct sockaddr *dst, char *src,
+				unsigned short int port);
 extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifsTconInfo *, int /* length of
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2208f06..05133aa 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1381,7 +1381,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 }
 
 static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr_storage *addr, unsigned short int port)
+cifs_find_tcp_session(struct sockaddr_storage *addr)
 {
 	struct list_head *tmp;
 	struct TCP_Server_Info *server;
@@ -1405,7 +1405,6 @@ cifs_find_tcp_session(struct sockaddr_storage *addr, unsigned short int port)
 		case AF_INET:
 			if (addr4->sin_addr.s_addr ==
 			    server->addr.sockAddr.sin_addr.s_addr) {
-				addr4->sin_port = htons(port);
 				/* user overrode default port? */
 				if (addr4->sin_port) {
 					if (addr4->sin_port !=
@@ -1421,7 +1420,6 @@ cifs_find_tcp_session(struct sockaddr_storage *addr, unsigned short int port)
 			    &server->addr.sockAddr6.sin6_addr) &&
 			    (addr6->sin6_scope_id ==
 			    server->addr.sockAddr6.sin6_scope_id)) {
-				addr6->sin6_port = htons(port);
 				/* user overrode default port? */
 				if (addr6->sin6_port) {
 					if (addr6->sin6_port !=
@@ -1479,7 +1477,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	cFYI(1, "UNC: %s ip: %s", volume_info->UNC, volume_info->UNCip);
 
 	if (volume_info->UNCip && volume_info->UNC) {
-		rc = cifs_convert_address(volume_info->UNCip, &addr);
+		rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
+					volume_info->UNCip,
+					volume_info->port);
 		if (!rc) {
 			/* we failed translating address */
 			rc = -EINVAL;
@@ -1499,7 +1499,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 
 	/* see if we already have a matching tcp_ses */
-	tcp_ses = cifs_find_tcp_session(&addr, volume_info->port);
+	tcp_ses = cifs_find_tcp_session(&addr);
 	if (tcp_ses)
 		return tcp_ses;
 
@@ -1543,12 +1543,10 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		cFYI(1, "attempting ipv6 connect");
 		/* BB should we allow ipv6 on port 139? */
 		/* other OS never observed in Wild doing 139 with v6 */
-		sin_server6->sin6_port = htons(volume_info->port);
 		memcpy(&tcp_ses->addr.sockAddr6, sin_server6,
 			sizeof(struct sockaddr_in6));
 		rc = ipv6_connect(tcp_ses);
 	} else {
-		sin_server->sin_port = htons(volume_info->port);
 		memcpy(&tcp_ses->addr.sockAddr, sin_server,
 			sizeof(struct sockaddr_in));
 		rc = ipv4_connect(tcp_ses);
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 4db2c5e..22afe38 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -40,7 +40,7 @@ is_ip(char *name)
 {
 	struct sockaddr_storage ss;
 
-	return cifs_convert_address(name, &ss);
+	return cifs_convert_address((struct sockaddr *)&ss, name);
 }
 
 static int
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index d35d528..3489468 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -164,7 +164,7 @@ cifs_inet_pton(const int address_family, const char *cp, void *dst)
  * Returns 0 on failure.
  */
 int
-cifs_convert_address(char *src, void *dst)
+cifs_convert_address(struct sockaddr *dst, char *src)
 {
 	int rc;
 	char *pct, *endp;
@@ -201,6 +201,27 @@ cifs_convert_address(char *src, void *dst)
 	return rc;
 }
 
+int
+cifs_fill_sockaddr(struct sockaddr *dst, char *src,
+		   const unsigned short int port)
+{
+	if (!cifs_convert_address(dst, src))
+		return 0;
+
+	switch (dst->sa_family) {
+	case AF_INET:
+		((struct sockaddr_in *)dst)->sin_port = htons(port);
+		break;
+	case AF_INET6:
+		((struct sockaddr_in6 *)dst)->sin6_port = htons(port);
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
 /*****************************************************************************
 convert a NT status code to a dos class/code
  *****************************************************************************/
-- 
1.7.1
