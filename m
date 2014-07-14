From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 2/7] CIFS: Use separate var for the number of bytes got in async read
Date: Mon, 14 Jul 2014 13:01:12 +0400
Message-ID: <1405328477-13484-3-git-send-email-pshilovsky@samba.org>
References: <1405328477-13484-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405328477-13484-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and don't mix it with the number of bytes that was requested.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h | 1 +
 fs/cifs/cifssmb.c  | 6 +++---
 fs/cifs/file.c     | 2 +-
 fs/cifs/smb2pdu.c  | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f33ff4c..0012e1e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1059,6 +1059,7 @@ struct cifs_readdata {
 	struct address_space		*mapping;
 	__u64				offset;
 	unsigned int			bytes;
+	unsigned int			got_bytes;
 	pid_t				pid;
 	int				result;
 	struct work_struct		work;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6ded59d..a3e424d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1513,7 +1513,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return length;
 
 	server->total_read += length;
-	rdata->bytes = length;
+	rdata->got_bytes = length;
 
 	cifs_dbg(FYI, "total_read=%u buflen=%u remaining=%u\n",
 		 server->total_read, buflen, data_len);
@@ -1556,8 +1556,8 @@ cifs_readv_callback(struct mid_q_entry *mid)
 					 rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
-		task_io_account_read(rdata->bytes);
-		cifs_stats_bytes_read(tcon, rdata->bytes);
+		task_io_account_read(rdata->got_bytes);
+		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0974dd2..7fc9bdc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2839,7 +2839,7 @@ cifs_uncached_readdata_release(struct kref *refcount)
 static int
 cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
 {
-	size_t remaining = rdata->bytes;
+	size_t remaining = rdata->got_bytes;
 	unsigned int i;
 
 	for (i = 0; i < rdata->nr_pages; i++) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 26624ee..0aabd7c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1734,8 +1734,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 					 rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
-		task_io_account_read(rdata->bytes);
-		cifs_stats_bytes_read(tcon, rdata->bytes);
+		task_io_account_read(rdata->got_bytes);
+		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
-- 
1.8.1.2
