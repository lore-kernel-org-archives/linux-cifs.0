From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cifs: prevent possible memory corruption in cifs_demultiplex_thread
Date: Fri,  3 Sep 2010 08:25:11 -0400
Message-ID: <1283516711-15073-4-git-send-email-jlayton@redhat.com>
References: <1283516711-15073-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283516711-15073-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_demultiplex_thread sets the addr.sockAddr.sin_port without any
regard for the socket family. While it may be that the error in question
here never occurs on an IPv6 socket, it's probably best to be safe and
set the port properly if it ever does.

Break the port setting code out of cifs_fill_sockaddr and into a new
function, and call that from cifs_demultiplex_thread.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 ++-
 fs/cifs/connect.c   |    3 ++-
 fs/cifs/netmisc.c   |   22 +++++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1378d91..c3d3472 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -87,8 +87,9 @@ extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
+extern int cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
-				unsigned short int port);
+				const unsigned short int port);
 extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifsTconInfo *, int /* length of
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a071358..dee5762 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -463,7 +463,8 @@ incomplete_rcv:
 			 * is since we do not begin with RFC1001 session
 			 * initialize frame)
 			 */
-			server->addr.sockAddr.sin_port = htons(CIFS_PORT);
+			cifs_set_port((struct sockaddr *)
+					&server->addr.sockAddr, CIFS_PORT);
 			cifs_reconnect(server);
 			csocket = server->ssocket;
 			wake_up(&server->response_q);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index f978511..9aad47a 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -206,26 +206,30 @@ cifs_convert_address(struct sockaddr *dst, const char *src, int len)
 }
 
 int
-cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
-		   const unsigned short int port)
+cifs_set_port(struct sockaddr *addr, const unsigned short int port)
 {
-	if (!cifs_convert_address(dst, src, len))
-		return 0;
-
-	switch (dst->sa_family) {
+	switch (addr->sa_family) {
 	case AF_INET:
-		((struct sockaddr_in *)dst)->sin_port = htons(port);
+		((struct sockaddr_in *)addr)->sin_port = htons(port);
 		break;
 	case AF_INET6:
-		((struct sockaddr_in6 *)dst)->sin6_port = htons(port);
+		((struct sockaddr_in6 *)addr)->sin6_port = htons(port);
 		break;
 	default:
 		return 0;
 	}
-
 	return 1;
 }
 
+int
+cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
+		   const unsigned short int port)
+{
+	if (!cifs_convert_address(dst, src, len))
+		return 0;
+	return cifs_set_port(dst, port);
+}
+
 /*****************************************************************************
 convert a NT status code to a dos class/code
  *****************************************************************************/
-- 
1.7.1
