From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] cifs: don't discard readahead pages that are beyond EOF
Date: Fri, 26 Aug 2011 15:18:18 -0400
Message-ID: <1314386298-27424-6-git-send-email-jlayton@redhat.com>
References: <1314386298-27424-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314386298-27424-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

READ_AND_X past the eof on the server seems to generally return success
but with zero bytes. If a process writes to a file while leaving in
sparse regions, then the VFS may issue readahead to try and and fill in
the gaps. Those pages may be beyond the EOF however, if the writes have
not been issued to the server yet. cifs_readv_recieve will currently just
discard the pages from the pagecache when the response comes in.

That confuses the poor VFS -- it thinks that the i_size is bigger and
will keep trying to read from the server to fill the gaps. When there
is no remaining data in the response, and the page is beyond the
server->eof, then simply zero it out, set it uptodate and leave it
in place. This ensures that the VFS won't keep trying to issue reads
for these regions.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c5f6ea6..79f346e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1445,6 +1445,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	struct cifs_readdata *rdata = mid->callback_data;
 	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
 	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length);
+	u64 eof;
+	pgoff_t eof_index;
 	struct page *page, *tpage;
 
 	cFYI(1, "%s: mid=%u offset=%llu bytes=%u", __func__,
@@ -1517,6 +1519,11 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	/* marshal up the page array */
 	remaining = data_len;
 	rdata->nr_iov = 1;
+
+	eof = CIFS_I(rdata->mapping->host)->server_eof;
+	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
+	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
+
 	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
 		if (remaining >= PAGE_CACHE_SIZE) {
 			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
@@ -1539,6 +1546,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			++rdata->nr_iov;
 			len += remaining;
 			remaining = 0;
+		} else if (page->index > eof_index) {
+			zero_user(page, 0, PAGE_CACHE_SIZE);
+			list_del(&page->lru);
+			lru_cache_add_file(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+			unlock_page(page);
+			page_cache_release(page);
 		} else {
 			/* no need to hold page hostage */
 			delete_from_page_cache(page);
-- 
1.7.6
