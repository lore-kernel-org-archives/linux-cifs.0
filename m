From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 06/09] Change RDMA recv to support offset in the 1st page
Date: Thu, 17 May 2018 17:22:11 -0700
Message-ID: <20180518002214.5657-7-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

The actaul data buffer may start with an offset in the 1st page, modify RDMA recv
function to read the data to the correct buffer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b46586d..939c289 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1978,7 +1978,7 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
  * return value: actual data read
  */
 static int smbd_recv_page(struct smbd_connection *info,
-		struct page *page, unsigned int to_read)
+		struct page *page, unsigned int page_offset, unsigned int to_read)
 {
 	int ret;
 	char *to_address;
@@ -1989,10 +1989,10 @@ static int smbd_recv_page(struct smbd_connection *info,
 		info->reassembly_data_length >= to_read ||
 			info->transport_status != SMBD_CONNECTED);
 	if (ret)
-		return 0;
+		return ret;
 
 	/* now we can read from reassembly queue and not sleep */
-	to_address = kmap_atomic(page);
+	to_address = (char *) kmap_atomic(page) + page_offset;
 
 	log_read(INFO, "reading from page=%p address=%p to_read=%d\n",
 		page, to_address, to_read);
@@ -2012,7 +2012,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
 	char *buf;
 	struct page *page;
-	unsigned int to_read;
+	unsigned int to_read, page_offset;
 	int rc;
 
 	switch (msg->msg_iter.type) {
@@ -2024,15 +2024,16 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 
 	case READ | ITER_BVEC:
 		page = msg->msg_iter.bvec->bv_page;
+		page_offset = msg->msg_iter.bvec->bv_offset;
 		to_read = msg->msg_iter.bvec->bv_len;
-		rc = smbd_recv_page(info, page, to_read);
+		rc = smbd_recv_page(info, page, page_offset, to_read);
 		break;
 
 	default:
 		/* It's a bug in upper layer to get there */
 		cifs_dbg(VFS, "CIFS: invalid msg type %d\n",
 			msg->msg_iter.type);
-		rc = -EIO;
+		rc = -EINVAL;
 	}
 
 	/* SMBDirect will read it all or nothing */
-- 
2.7.4
