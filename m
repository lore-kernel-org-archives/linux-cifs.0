From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [PATCH 4/6] cifs: no need to wank with copying and advancing iovec
 on recvmsg side either
Date: Sat, 9 Apr 2016 21:52:10 +0100
Message-ID: <20160409205210.GJ25498@ZenIV.linux.org.uk>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160409204301.GF25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 fs/cifs/cifsglob.h |  2 --
 fs/cifs/connect.c  | 72 ++++--------------------------------------------------
 2 files changed, 5 insertions(+), 69 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d21da9f..df03c5e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -615,8 +615,6 @@ struct TCP_Server_Info {
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	large_buf;		/* is current buffer large? */
 	struct delayed_work	echo; /* echo ping workqueue job */
-	struct kvec *iov;	/* reusable kvec array for receives */
-	unsigned int nr_iov;	/* number of kvecs in array */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
 	unsigned int total_read; /* total amount of data read in this pass */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a763cd3..eb42665 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -501,77 +501,20 @@ server_unresponsive(struct TCP_Server_Info *server)
 	return false;
 }
 
-/*
- * kvec_array_init - clone a kvec array, and advance into it
- * @new:	pointer to memory for cloned array
- * @iov:	pointer to original array
- * @nr_segs:	number of members in original array
- * @bytes:	number of bytes to advance into the cloned array
- *
- * This function will copy the array provided in iov to a section of memory
- * and advance the specified number of bytes into the new array. It returns
- * the number of segments in the new array. "new" must be at least as big as
- * the original iov array.
- */
-static unsigned int
-kvec_array_init(struct kvec *new, struct kvec *iov, unsigned int nr_segs,
-		size_t bytes)
-{
-	size_t base = 0;
-
-	while (bytes || !iov->iov_len) {
-		int copy = min(bytes, iov->iov_len);
-
-		bytes -= copy;
-		base += copy;
-		if (iov->iov_len == base) {
-			iov++;
-			nr_segs--;
-			base = 0;
-		}
-	}
-	memcpy(new, iov, sizeof(*iov) * nr_segs);
-	new->iov_base += base;
-	new->iov_len -= base;
-	return nr_segs;
-}
-
-static struct kvec *
-get_server_iovec(struct TCP_Server_Info *server, unsigned int nr_segs)
-{
-	struct kvec *new_iov;
-
-	if (server->iov && nr_segs <= server->nr_iov)
-		return server->iov;
-
-	/* not big enough -- allocate a new one and release the old */
-	new_iov = kmalloc(sizeof(*new_iov) * nr_segs, GFP_NOFS);
-	if (new_iov) {
-		kfree(server->iov);
-		server->iov = new_iov;
-		server->nr_iov = nr_segs;
-	}
-	return new_iov;
-}
-
 int
 cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 		       unsigned int nr_segs, unsigned int to_read)
 {
 	int length = 0;
 	int total_read;
-	unsigned int segs;
 	struct msghdr smb_msg;
-	struct kvec *iov;
-
-	iov = get_server_iovec(server, nr_segs);
-	if (!iov)
-		return -ENOMEM;
 
 	smb_msg.msg_control = NULL;
 	smb_msg.msg_controllen = 0;
+	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC,
+		      iov_orig, nr_segs, to_read);
 
-	for (total_read = 0; to_read; total_read += length, to_read -= length) {
+	for (total_read = 0; msg_data_left(&smb_msg); total_read += length) {
 		try_to_freeze();
 
 		if (server_unresponsive(server)) {
@@ -579,10 +522,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			break;
 		}
 
-		segs = kvec_array_init(iov, iov_orig, nr_segs, total_read);
-
-		length = kernel_recvmsg(server->ssocket, &smb_msg,
-					iov, segs, to_read, 0);
+		length = sock_recvmsg(server->ssocket, &smb_msg, 0);
 
 		if (server->tcpStatus == CifsExiting) {
 			total_read = -ESHUTDOWN;
@@ -603,8 +543,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			length = 0;
 			continue;
 		} else if (length <= 0) {
-			cifs_dbg(FYI, "Received no data or error: expecting %d\n"
-				 "got %d", to_read, length);
+			cifs_dbg(FYI, "Received no data or error: %d\n", length);
 			cifs_reconnect(server);
 			total_read = -ECONNABORTED;
 			break;
@@ -783,7 +722,6 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	}
 
 	kfree(server->hostname);
-	kfree(server->iov);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
-- 
2.8.0.rc3
