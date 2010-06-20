From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] cifs: have cifs_convert_address set port
Date: Sun, 20 Jun 2010 17:10:46 -0400
Message-ID: <1277068251-16344-2-git-send-email-jlayton@redhat.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently we set this in cifs_find_tcp_session, but that's more of a
side effect than anything. Set it in cifs_convert_address instead as
that's a better fit.

This also allows us to skip passing in the port as a separate parm to
cifs_find_tcp_session.

Also, pass in a struct sockaddr * rather than void * to make it
clearer how this function should be called.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h   |    3 ++-
 fs/cifs/connect.c     |   12 +++++-------
 fs/cifs/dns_resolve.c |    2 +-
 fs/cifs/netmisc.c     |    5 ++++-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fb6318b..fe26f09 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -86,7 +86,8 @@ extern unsigned int smbCalcSize(struct smb_hdr *ptr);
 extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
-extern int cifs_convert_address(char *src, void *dst);
+extern int cifs_convert_address(struct sockaddr *dst, char *src,
+				unsigned short int port);
 extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifsTconInfo *, int /* length of
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2208f06..640c7d5 100644
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
+		rc = cifs_convert_address((struct sockaddr *)&addr,
+					  volume_info->UNCip,
+					  volume_info->port);
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
index 4db2c5e..b6f8e34 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -40,7 +40,7 @@ is_ip(char *name)
 {
 	struct sockaddr_storage ss;
 
-	return cifs_convert_address(name, &ss);
+	return cifs_convert_address((struct sockaddr *)&ss, name, 0);
 }
 
 static int
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index d35d528..33b7929 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -164,7 +164,8 @@ cifs_inet_pton(const int address_family, const char *cp, void *dst)
  * Returns 0 on failure.
  */
 int
-cifs_convert_address(char *src, void *dst)
+cifs_convert_address(struct sockaddr *dst, char *src,
+		     const unsigned short int port)
 {
 	int rc;
 	char *pct, *endp;
@@ -174,6 +175,7 @@ cifs_convert_address(char *src, void *dst)
 	/* IPv4 address */
 	if (cifs_inet_pton(AF_INET, src, &s4->sin_addr.s_addr)) {
 		s4->sin_family = AF_INET;
+		s4->sin_port = htons(port);
 		return 1;
 	}
 
@@ -192,6 +194,7 @@ cifs_convert_address(char *src, void *dst)
 		return rc;
 
 	s6->sin6_family = AF_INET6;
+	s6->sin6_port = htons(port);
 	if (pct) {
 		s6->sin6_scope_id = (u32) simple_strtoul(pct, &endp, 0);
 		if (!*pct || *endp)
-- 
1.6.6.1
