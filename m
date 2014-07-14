From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 6/7] CIFS: Optimize cifs_user_read() in a short read case on reconnects
Date: Mon, 14 Jul 2014 13:01:16 +0400
Message-ID: <1405328477-13484-7-git-send-email-pshilovsky@samba.org>
References: <1405328477-13484-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405328477-13484-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by filling the output buffer with a data got from a partially received
response and requesting the remaining data from the server. This is
suitable for non-signed connections.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifssmb.c |  6 ++++++
 fs/cifs/file.c    | 23 ++++++++++++++++++++---
 fs/cifs/smb2pdu.c |  6 ++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5d6768f..2f7b43a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1561,6 +1561,12 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
 		rdata->result = -EAGAIN;
+		if (server->sign && rdata->got_bytes)
+			/* reset bytes number since we can not check a sign */
+			rdata->got_bytes = 0;
+		/* FIXME: should this be counted toward the initiating task? */
+		task_io_account_read(rdata->got_bytes);
+		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
 	default:
 		rdata->result = -EIO;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6896cb5..e42d26d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3029,13 +3029,30 @@ again:
 			else if (rdata->result == -EAGAIN) {
 				/* resend call if it's a retryable error */
 				struct list_head tmp_list;
+				unsigned int got_bytes = rdata->got_bytes;
 
 				list_del_init(&rdata->list);
 				INIT_LIST_HEAD(&tmp_list);
 
-				rc = cifs_send_async_read(rdata->offset,
-						rdata->bytes, rdata->cfile,
-						cifs_sb, &tmp_list);
+				/*
+				 * Got a part of data and then reconnect has
+				 * happened -- fill the buffer and continue
+				 * reading.
+				 */
+				if (got_bytes && got_bytes < rdata->bytes) {
+					rc = cifs_readdata_to_iov(rdata, to);
+					if (rc) {
+						kref_put(&rdata->refcount,
+						cifs_uncached_readdata_release);
+						continue;
+					}
+				}
+
+				rc = cifs_send_async_read(
+						rdata->offset + got_bytes,
+						rdata->bytes - got_bytes,
+						rdata->cfile, cifs_sb,
+						&tmp_list);
 
 				list_splice(&tmp_list, &rdata_list);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0aabd7c..9b38cd7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1740,6 +1740,12 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
 		rdata->result = -EAGAIN;
+		if (server->sign && rdata->got_bytes)
+			/* reset bytes number since we can not check a sign */
+			rdata->got_bytes = 0;
+		/* FIXME: should this be counted toward the initiating task? */
+		task_io_account_read(rdata->got_bytes);
+		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
 	default:
 		if (rdata->result != -ENODATA)
-- 
1.8.1.2
