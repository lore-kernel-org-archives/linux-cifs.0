From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 09/15] CIFS: SMBD: Support page offset in RDMA recv
Date: Wed, 30 May 2018 12:48:01 -0700
Message-ID: <20180530194807.31657-10-longli@linuxonhyperv.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

RDMA recv function needs to place data to the correct place starting at
page offset.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 6141e3c..ba53c52 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2004,10 +2004,12 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
  * return value: actual data read
  */
 static int smbd_recv_page(struct smbd_connection *info,
-		struct page *page, unsigned int to_read)
+		struct page *page, unsigned int page_offset,
+		unsigned int to_read)
 {
 	int ret;
 	char *to_address;
+	void *page_address;
 
 	/* make sure we have the page ready for read */
 	ret = wait_event_interruptible(
@@ -2015,16 +2017,17 @@ static int smbd_recv_page(struct smbd_connection *info,
 		info->reassembly_data_length >= to_read ||
 			info->transport_status != SMBD_CONNECTED);
 	if (ret)
-		return 0;
+		return ret;
 
 	/* now we can read from reassembly queue and not sleep */
-	to_address = kmap_atomic(page);
+	page_address = kmap_atomic(page);
+	to_address = (char *) page_address + page_offset;
 
 	log_read(INFO, "reading from page=%p address=%p to_read=%d\n",
 		page, to_address, to_read);
 
 	ret = smbd_recv_buf(info, to_address, to_read);
-	kunmap_atomic(to_address);
+	kunmap_atomic(page_address);
 
 	return ret;
 }
@@ -2038,7 +2041,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
 	char *buf;
 	struct page *page;
-	unsigned int to_read;
+	unsigned int to_read, page_offset;
 	int rc;
 
 	info->smbd_recv_pending++;
@@ -2052,15 +2055,16 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 
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
 
 	info->smbd_recv_pending--;
-- 
2.7.4
