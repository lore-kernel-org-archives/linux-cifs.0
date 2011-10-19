From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/9] cifs: turn read_from_socket into a wrapper around a vectorized version
Date: Wed, 19 Oct 2011 09:16:51 -0400
Message-ID: <1319030219-3811-2-git-send-email-jlayton@redhat.com>
References: <1319030219-3811-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319030219-3811-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eventually we'll want to allow cifsd to read data directly into the
pagecache. In order to do that we'll need a routine that can take a
kvec array and pass that directly to kernel_recvmsg.

Unfortunately though, the kernel's recvmsg routines modify the kvec
array that gets passed in, so we need to use a copy of the kvec array
and refresh that copy on each pass through the loop.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 97a65af..4860940 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -375,14 +375,54 @@ server_unresponsive(struct TCP_Server_Info *server)
 	return false;
 }
 
+/*
+ * kvec_array_init - clone a kvec array, and advance into it
+ * @new:	pointer to memory for cloned array
+ * @iov:	pointer to original array
+ * @nr_segs:	number of members in original array
+ * @bytes:	number of bytes to advance into the cloned array
+ *
+ * This function will copy the array provided in iov to a section of memory
+ * and advance the specified number of bytes into the new array. It returns
+ * the number of segments in the new array. "new" must be at least as big as
+ * the original iov array.
+ */
+static unsigned int
+kvec_array_init(struct kvec *new, struct kvec *iov, unsigned int nr_segs,
+		size_t bytes)
+{
+	size_t base = 0;
+
+	while (bytes || !iov->iov_len) {
+		int copy = min(bytes, iov->iov_len);
+
+		bytes -= copy;
+		base += copy;
+		if (iov->iov_len == base) {
+			iov++;
+			nr_segs--;
+			base = 0;
+		}
+	}
+	memcpy(new, iov, sizeof(*iov) * nr_segs);
+	new->iov_base += base;
+	new->iov_len -= base;
+	return nr_segs;
+}
+
 static int
-read_from_socket(struct TCP_Server_Info *server, char *buf,
-		 unsigned int to_read)
+readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
+		  unsigned int nr_segs, unsigned int to_read)
 {
 	int length = 0;
 	int total_read;
+	unsigned int segs;
 	struct msghdr smb_msg;
-	struct kvec iov;
+	struct kvec *iov;
+
+	iov = kmalloc(sizeof(*iov_orig) * nr_segs, GFP_NOFS);
+	if (!iov)
+		return -ENOMEM;
 
 	smb_msg.msg_control = NULL;
 	smb_msg.msg_controllen = 0;
@@ -393,10 +433,11 @@ read_from_socket(struct TCP_Server_Info *server, char *buf,
 			break;
 		}
 
-		iov.iov_base = buf + total_read;
-		iov.iov_len = to_read;
-		length = kernel_recvmsg(server->ssocket, &smb_msg, &iov, 1,
-					to_read, 0);
+		segs = kvec_array_init(iov, iov_orig, nr_segs, total_read);
+
+		length = kernel_recvmsg(server->ssocket, &smb_msg,
+					iov, segs, to_read, 0);
+
 		if (server->tcpStatus == CifsExiting) {
 			total_read = -ESHUTDOWN;
 			break;
@@ -423,9 +464,22 @@ read_from_socket(struct TCP_Server_Info *server, char *buf,
 			break;
 		}
 	}
+	kfree(iov);
 	return total_read;
 }
 
+static int
+read_from_socket(struct TCP_Server_Info *server, char *buf,
+		 unsigned int to_read)
+{
+	struct kvec iov;
+
+	iov.iov_base = buf;
+	iov.iov_len = to_read;
+
+	return readv_from_socket(server, &iov, 1, to_read);
+}
+
 static bool
 is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 {
-- 
1.7.6.4
