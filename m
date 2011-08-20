From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/14] cifs: add a callback function to receive the rest of the frame
Date: Fri, 19 Aug 2011 21:55:39 -0400
Message-ID: <1313805339-1233-15-git-send-email-jlayton@redhat.com>
References: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313805339-1233-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
 fs/cifs/cifsglob.h |   23 ++++++++++++++++++++---
 fs/cifs/connect.c  |    6 +++++-
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ea5ca9a..e2655b0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -647,8 +647,24 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
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
@@ -666,9 +682,10 @@ struct mid_q_entry {
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
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f122bfa..6b661e2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -811,7 +811,11 @@ cifs_demultiplex_thread(void *p)
 
 		mid_entry = find_mid(server, smb_buffer);
 
-		length = standard_receive3(server, mid_entry);
+		if (!mid_entry || !mid_entry->receive)
+			length = standard_receive3(server, mid_entry);
+		else
+			length = mid->receive(server, mid_entry);
+
 		if (length < 0)
 			continue;
 
-- 
1.7.6
