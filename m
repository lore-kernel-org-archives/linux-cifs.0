From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 22/37] [CIFS] SMBD: Implement API for upper layer to receive data to page
Date: Wed,  2 Aug 2017 13:10:33 -0700
Message-ID: <1501704648-20159-23-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Sometimes upper layer may also want to read data to a page. Implement this API.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsrdma.c | 30 ++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index e5f6300..67a11d9 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -1316,6 +1316,36 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 }
 
 /*
+ * Read a page from receive reassembly queue
+ * page: the page to read data into
+ * to_read: the length of data to read
+ * return value: actual data read
+ */
+int cifs_rdma_read_page(struct cifs_rdma_info *info,
+		struct page *page, unsigned int to_read)
+{
+	int ret;
+	char *to_address;
+
+	// make sure we have the page ready for read
+	wait_event(
+		info->wait_reassembly_queue,
+		atomic_read(&info->reassembly_data_length) >= to_read ||
+			info->transport_status != CIFS_RDMA_CONNECTED);
+
+	// now we can read from reassembly queue and not sleep
+	to_address = kmap_atomic(page);
+
+	log_cifs_read("reading from page=%p address=%p to_read=%d\n",
+		page, to_address, to_read);
+
+	ret = cifs_rdma_read(info, to_address, to_read);
+	kunmap_atomic(to_address);
+
+	return ret;
+}
+
+/*
  * Read data from receive reassembly queue
  * All the incoming data packets are placed in reassembly queue
  * buf: the buffer to read data into
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 8891e21..36f3e4c 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -215,5 +215,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 // SMBDirect interface for carrying upper layer CIFS I/O
 int cifs_rdma_read(
 	struct cifs_rdma_info *rdma, char *buf, unsigned int to_read);
+int cifs_rdma_read_page(
+	struct cifs_rdma_info *rdma, struct page *page, unsigned int to_read);
 int cifs_rdma_write(struct cifs_rdma_info *rdma, struct smb_rqst *rqst);
 #endif
-- 
2.7.4
