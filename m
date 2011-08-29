From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/16] cifs: make smb_msg local to read_from_socket
Date: Mon, 29 Aug 2011 07:16:52 -0400
Message-ID: <1314616624-5362-5-git-send-email-jlayton@redhat.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314616624-5362-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If msg_controllen is 0, then the socket layer should never touch these
fields. Thus, there's no need to continually reset them. Also, there's
no need to keep this field on the stack for the demultiplex thread, just
make it a local variable in read_from_socket.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5667964..d94eb32 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -359,16 +359,20 @@ allocate_buffers(char **bigbuf, char **smallbuf, unsigned int size,
 }
 
 static int
-read_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg,
+read_from_socket(struct TCP_Server_Info *server,
 		 struct kvec *iov, unsigned int to_read,
 		 unsigned int *ptotal_read, bool is_header_read)
 {
 	int length, rc = 0;
 	unsigned int total_read;
+	struct msghdr smb_msg;
 	char *buf = iov->iov_base;
 
+	smb_msg.msg_control = NULL;
+	smb_msg.msg_controllen = 0;
+
 	for (total_read = 0; total_read < to_read; total_read += length) {
-		length = kernel_recvmsg(server->ssocket, smb_msg, iov, 1,
+		length = kernel_recvmsg(server->ssocket, &smb_msg, iov, 1,
 					to_read - total_read, 0);
 		if (server->tcpStatus == CifsExiting) {
 			/* then will exit */
@@ -397,8 +401,6 @@ read_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 				iov->iov_base = (to_read - total_read) +
 						buf;
 				iov->iov_len = to_read - total_read;
-				smb_msg->msg_control = NULL;
-				smb_msg->msg_controllen = 0;
 				rc = 3;
 			} else
 				rc = 1;
@@ -634,7 +636,6 @@ cifs_demultiplex_thread(void *p)
 	unsigned int pdu_length, total_read;
 	char *buf = NULL, *bigbuf = NULL, *smallbuf = NULL;
 	struct smb_hdr *smb_buffer = NULL;
-	struct msghdr smb_msg;
 	struct kvec iov;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
@@ -665,8 +666,6 @@ cifs_demultiplex_thread(void *p)
 		buf = smallbuf;
 		iov.iov_base = buf;
 		iov.iov_len = 4;
-		smb_msg.msg_control = NULL;
-		smb_msg.msg_controllen = 0;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
 incomplete_rcv:
@@ -681,7 +680,7 @@ incomplete_rcv:
 			continue;
 		}
 
-		rc = read_from_socket(server, &smb_msg, &iov, pdu_length,
+		rc = read_from_socket(server, &iov, pdu_length,
 				      &total_read, true /* header read */);
 		if (rc == 3)
 			goto incomplete_rcv;
@@ -710,7 +709,7 @@ incomplete_rcv:
 
 		iov.iov_base = 4 + buf;
 		iov.iov_len = pdu_length;
-		rc = read_from_socket(server, &smb_msg, &iov, pdu_length,
+		rc = read_from_socket(server, &iov, pdu_length,
 				      &total_read, false);
 		if (rc == 2)
 			break;
-- 
1.7.6
