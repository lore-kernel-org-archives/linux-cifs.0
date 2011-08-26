From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/16] cifs: add a callback function to receive the rest of the frame
Date: Fri, 26 Aug 2011 15:06:29 -0400
Message-ID: <1314385589-27136-17-git-send-email-jlayton@redhat.com>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314385589-27136-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In order to handle larger SMBs for readpages and other calls, we want
to be able to read into a preallocated set of buffers. Rather than
changing all of the existing code to preallocate buffers however, we
instead add a receive callback function to the MID.

cifsd will call this function once the mid_q_entry has been identified
in order to receive the rest of the SMB. If the mid can't be identified
or the receive pointer is unset, then the standard 3rd phase receive
function will be called.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   23 ++++++++++++++++++++---
 fs/cifs/cifsproto.h |    5 +++--
 fs/cifs/cifssmb.c   |    5 +++--
 fs/cifs/connect.c   |    6 +++++-
 fs/cifs/transport.c |    5 +++--
 5 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index efa8b37..214fe47 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -649,8 +649,24 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
 struct mid_q_entry;
 
 /*
- * This is the prototype for the mid callback function. When creating one,
- * take special care to avoid deadlocks. Things to bear in mind:
+ * This is the prototype for the mid receive function. This function is for
+ * receiving the rest of the SMB frame, starting with the WordCount (which is
+ * just after the MID in struct smb_hdr). Note:
+ *
+ * - This will be called by cifsd, with no locks held.
+ * - The mid will still be on the pending_mid_q.
+ * - mid->resp_buf will point to the current buffer.
+ *
+ * Returns zero on a successful receive, or an error. The receive state in
+ * the TCP_Server_Info will also be updated.
+ */
+typedef int (mid_receive_t)(struct TCP_Server_Info *server,
+			    struct mid_q_entry *mid);
+
+/*
+ * This is the prototype for the mid callback function. This is called once the
+ * mid has been received off of the socket. When creating one, take special
+ * care to avoid deadlocks. Things to bear in mind:
  *
  * - it will be called by cifsd, with no locks held
  * - the mid will be removed from any lists
@@ -668,9 +684,10 @@ struct mid_q_entry {
 	unsigned long when_sent; /* time when smb send finished */
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
+	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	  /* general purpose pointer for callback */
-	struct smb_hdr *resp_buf;	/* response buffer */
+	struct smb_hdr *resp_buf;	/* pointer to received SMB header */
 	int midState;	/* wish this were enum but can not pass to wait_event */
 	__u8 command;	/* smb command code */
 	bool largeBuf:1;	/* if valid response, is pointer to large buf */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 03dc945..51c0ebc 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -69,8 +69,9 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
-			   unsigned int nvec, mid_callback_t *callback,
-			   void *cbdata, bool ignore_pend);
+			   unsigned int nvec, mid_receive_t *receive,
+			   mid_callback_t *callback, void *cbdata,
+			   bool ignore_pend);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 52fc500..911bc7e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -748,7 +748,8 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_base = smb;
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
-	rc = cifs_call_async(server, &iov, 1, cifs_echo_callback, server, true);
+	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
+			     server, true);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
@@ -1845,7 +1846,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     cifs_writev_callback, wdata, false);
+			     NULL, cifs_writev_callback, wdata, false);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_writes);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dd4c3bae..9d0b1c2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -825,7 +825,11 @@ cifs_demultiplex_thread(void *p)
 
 		mid_entry = find_mid(server, smb_buffer);
 
-		length = standard_receive3(server, mid_entry);
+		if (!mid_entry || !mid_entry->receive)
+			length = standard_receive3(server, mid_entry);
+		else
+			length = mid_entry->receive(server, mid_entry);
+
 		if (length < 0)
 			continue;
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 316d4cb..cbad728 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -343,8 +343,8 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
  */
 int
 cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
-		unsigned int nvec, mid_callback_t *callback, void *cbdata,
-		bool ignore_pend)
+		unsigned int nvec, mid_receive_t *receive,
+		mid_callback_t *callback, void *cbdata, bool ignore_pend)
 {
 	int rc;
 	struct mid_q_entry *mid;
@@ -378,6 +378,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		goto out_err;
 	}
 
+	mid->receive = receive;
 	mid->callback = callback;
 	mid->callback_data = cbdata;
 	mid->midState = MID_REQUEST_SUBMITTED;
-- 
1.7.6
