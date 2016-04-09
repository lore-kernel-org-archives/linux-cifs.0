From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [PATCH 6/6] cifs: don't bother with kmap on read_pages side
Date: Sat, 9 Apr 2016 21:53:04 +0100
Message-ID: <20160409205304.GL25498@ZenIV.linux.org.uk>
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

just do ITER_BVEC recvmsg

Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 fs/cifs/cifsproto.h |  7 +++---
 fs/cifs/connect.c   | 65 ++++++++++++++++++++++++++++-------------------------
 fs/cifs/file.c      | 53 ++++++++++++++-----------------------------
 3 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7d5f53a..0f9a6bc 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -179,10 +179,9 @@ extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 
 extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
-		     unsigned int to_read);
-extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
-		struct kvec *iov_orig, unsigned int nr_segs,
-		unsigned int to_read);
+			         unsigned int to_read);
+extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
+				      struct page *page, unsigned int to_read);
 extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index eb42665..e33c5e0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -501,39 +501,34 @@ server_unresponsive(struct TCP_Server_Info *server)
 	return false;
 }
 
-int
-cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
-		       unsigned int nr_segs, unsigned int to_read)
+static int
+cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 {
 	int length = 0;
 	int total_read;
-	struct msghdr smb_msg;
 
-	smb_msg.msg_control = NULL;
-	smb_msg.msg_controllen = 0;
-	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC,
-		      iov_orig, nr_segs, to_read);
+	smb_msg->msg_control = NULL;
+	smb_msg->msg_controllen = 0;
 
-	for (total_read = 0; msg_data_left(&smb_msg); total_read += length) {
+	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
 		try_to_freeze();
 
-		if (server_unresponsive(server)) {
-			total_read = -ECONNABORTED;
-			break;
-		}
+		if (server_unresponsive(server))
+			return -ECONNABORTED;
 
-		length = sock_recvmsg(server->ssocket, &smb_msg, 0);
+		length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
-		if (server->tcpStatus == CifsExiting) {
-			total_read = -ESHUTDOWN;
-			break;
-		} else if (server->tcpStatus == CifsNeedReconnect) {
+		if (server->tcpStatus == CifsExiting)
+			return -ESHUTDOWN;
+
+		if (server->tcpStatus == CifsNeedReconnect) {
 			cifs_reconnect(server);
-			total_read = -ECONNABORTED;
-			break;
-		} else if (length == -ERESTARTSYS ||
-			   length == -EAGAIN ||
-			   length == -EINTR) {
+			return -ECONNABORTED;
+		}
+
+		if (length == -ERESTARTSYS ||
+		    length == -EAGAIN ||
+		    length == -EINTR) {
 			/*
 			 * Minimum sleep to prevent looping, allowing socket
 			 * to clear and app threads to set tcpStatus
@@ -542,11 +537,12 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			usleep_range(1000, 2000);
 			length = 0;
 			continue;
-		} else if (length <= 0) {
+		}
+
+		if (length <= 0) {
 			cifs_dbg(FYI, "Received no data or error: %d\n", length);
 			cifs_reconnect(server);
-			total_read = -ECONNABORTED;
-			break;
+			return -ECONNABORTED;
 		}
 	}
 	return total_read;
@@ -556,12 +552,21 @@ int
 cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 		      unsigned int to_read)
 {
-	struct kvec iov;
+	struct msghdr smb_msg;
+	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
+	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC, &iov, 1, to_read);
 
-	iov.iov_base = buf;
-	iov.iov_len = to_read;
+	return cifs_readv_from_socket(server, &smb_msg);
+}
 
-	return cifs_readv_from_socket(server, &iov, 1, to_read);
+int
+cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
+		      unsigned int to_read)
+{
+	struct msghdr smb_msg;
+	struct bio_vec bv = {.bv_page = page, .bv_len = to_read};
+	iov_iter_bvec(&smb_msg.msg_iter, READ | ITER_BVEC, &bv, 1, to_read);
+	return cifs_readv_from_socket(server, &smb_msg);
 }
 
 static bool
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ff882ae..0f71867 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2855,39 +2855,31 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 	int result = 0;
 	unsigned int i;
 	unsigned int nr_pages = rdata->nr_pages;
-	struct kvec iov;
 
 	rdata->got_bytes = 0;
 	rdata->tailsz = PAGE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = rdata->pages[i];
+		size_t n;
 
-		if (len >= PAGE_SIZE) {
-			/* enough data to fill the page */
-			iov.iov_base = kmap(page);
-			iov.iov_len = PAGE_SIZE;
-			cifs_dbg(FYI, "%u: iov_base=%p iov_len=%zu\n",
-				 i, iov.iov_base, iov.iov_len);
-			len -= PAGE_SIZE;
-		} else if (len > 0) {
-			/* enough for partial page, fill and zero the rest */
-			iov.iov_base = kmap(page);
-			iov.iov_len = len;
-			cifs_dbg(FYI, "%u: iov_base=%p iov_len=%zu\n",
-				 i, iov.iov_base, iov.iov_len);
-			memset(iov.iov_base + len, '\0', PAGE_SIZE - len);
-			rdata->tailsz = len;
-			len = 0;
-		} else {
+		if (len <= 0) {
 			/* no need to hold page hostage */
 			rdata->pages[i] = NULL;
 			rdata->nr_pages--;
 			put_page(page);
 			continue;
 		}
-
-		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
-		kunmap(page);
+		n = len;
+		if (len >= PAGE_SIZE) {
+			/* enough data to fill the page */
+			n = PAGE_SIZE;
+			len -= n;
+		} else {
+			zero_user(page, len, PAGE_SIZE - len);
+			rdata->tailsz = len;
+			len = 0;
+		}
+		result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
 			break;
 
@@ -3303,7 +3295,6 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 	u64 eof;
 	pgoff_t eof_index;
 	unsigned int nr_pages = rdata->nr_pages;
-	struct kvec iov;
 
 	/* determine the eof that the server (probably) has */
 	eof = CIFS_I(rdata->mapping->host)->server_eof;
@@ -3314,23 +3305,14 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 	rdata->tailsz = PAGE_CACHE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = rdata->pages[i];
+		size_t n = PAGE_CACHE_SIZE;
 
 		if (len >= PAGE_CACHE_SIZE) {
-			/* enough data to fill the page */
-			iov.iov_base = kmap(page);
-			iov.iov_len = PAGE_CACHE_SIZE;
-			cifs_dbg(FYI, "%u: idx=%lu iov_base=%p iov_len=%zu\n",
-				 i, page->index, iov.iov_base, iov.iov_len);
 			len -= PAGE_CACHE_SIZE;
 		} else if (len > 0) {
 			/* enough for partial page, fill and zero the rest */
-			iov.iov_base = kmap(page);
-			iov.iov_len = len;
-			cifs_dbg(FYI, "%u: idx=%lu iov_base=%p iov_len=%zu\n",
-				 i, page->index, iov.iov_base, iov.iov_len);
-			memset(iov.iov_base + len,
-				'\0', PAGE_CACHE_SIZE - len);
-			rdata->tailsz = len;
+			zero_user(page, len, PAGE_CACHE_SIZE - len);
+			n = rdata->tailsz = len;
 			len = 0;
 		} else if (page->index > eof_index) {
 			/*
@@ -3360,8 +3342,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 			continue;
 		}
 
-		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
-		kunmap(page);
+		result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
 			break;
 
-- 
2.8.0.rc3
