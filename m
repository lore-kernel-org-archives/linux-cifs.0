From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/7] CIFS: Count got bytes in read_into_pages()
Date: Thu, 10 Jul 2014 13:30:43 +0400
Message-ID: <1404984647-8710-4-git-send-email-pshilovsky@samba.org>
References: <1404984647-8710-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404984647-8710-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that let us know how many bytes we have already got before reconnect.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifssmb.c |  1 -
 fs/cifs/file.c    | 16 ++++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8af078f..9f13b62 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1513,7 +1513,6 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return length;
 
 	server->total_read += length;
-	rdata->got_bytes = length;
 
 	cifs_dbg(FYI, "total_read=%u buflen=%u remaining=%u\n",
 		 server->total_read, buflen, data_len);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7fc9bdc..f6cb765 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2867,11 +2867,12 @@ static int
 cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 			struct cifs_readdata *rdata, unsigned int len)
 {
-	int total_read = 0, result = 0;
+	int result = 0;
 	unsigned int i;
 	unsigned int nr_pages = rdata->nr_pages;
 	struct kvec iov;
 
+	rdata->got_bytes = 0;
 	rdata->tailsz = PAGE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = rdata->pages[i];
@@ -2905,10 +2906,11 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 		if (result < 0)
 			break;
 
-		total_read += result;
+		rdata->got_bytes += result;
 	}
 
-	return total_read > 0 && result != -ECONNABORTED ? total_read : result;
+	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+						rdata->got_bytes : result;
 }
 
 static int
@@ -3289,7 +3291,7 @@ static int
 cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 			struct cifs_readdata *rdata, unsigned int len)
 {
-	int total_read = 0, result = 0;
+	int result = 0;
 	unsigned int i;
 	u64 eof;
 	pgoff_t eof_index;
@@ -3301,6 +3303,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
 	cifs_dbg(FYI, "eof=%llu eof_index=%lu\n", eof, eof_index);
 
+	rdata->got_bytes = 0;
 	rdata->tailsz = PAGE_CACHE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = rdata->pages[i];
@@ -3355,10 +3358,11 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 		if (result < 0)
 			break;
 
-		total_read += result;
+		rdata->got_bytes += result;
 	}
 
-	return total_read > 0 && result != -ECONNABORTED ? total_read : result;
+	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+						rdata->got_bytes : result;
 }
 
 static int
-- 
1.8.1.2
