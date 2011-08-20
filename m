From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/14] cifs: move buffer pointers into TCP_Server_Info
Date: Fri, 19 Aug 2011 21:55:36 -0400
Message-ID: <1313805339-1233-12-git-send-email-jlayton@redhat.com>
References: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313805339-1233-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have several functions that need to access these pointers. Currently
that's done with a lot of double pointer passing. Instead, move them
into the TCP_Server_Info and simplify the handling.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    4 ++
 fs/cifs/connect.c  |  101 +++++++++++++++++++++++----------------------------
 2 files changed, 50 insertions(+), 55 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 95dad9d..ea5ca9a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -286,7 +286,11 @@ struct TCP_Server_Info {
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
+	bool	large_buf;		/* is current buffer large? */
 	struct delayed_work	echo; /* echo ping workqueue job */
+	char	*smallbuf;	/* pointer to current "small" buffer */
+	char	*bigbuf;	/* pointer to current "big" buffer */
+	unsigned int total_read; /* total amount of data read in this pass */
 #ifdef CONFIG_CIFS_FSCACHE
 	struct fscache_cookie   *fscache; /* client index cache cookie */
 #endif
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 49c7eee..4b727c2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -320,27 +320,24 @@ requeue_echo:
 }
 
 static bool
-allocate_buffers(char **bigbuf, char **smallbuf, unsigned int size,
-		 bool is_large_buf)
+allocate_buffers(struct TCP_Server_Info *server)
 {
-	char *bbuf = *bigbuf, *sbuf = *smallbuf;
-
-	if (bbuf == NULL) {
-		bbuf = (char *)cifs_buf_get();
-		if (!bbuf) {
+	if (!server->bigbuf) {
+		server->bigbuf = (char *)cifs_buf_get();
+		if (!server->bigbuf) {
 			cERROR(1, "No memory for large SMB response");
 			msleep(3000);
 			/* retry will check if exiting */
 			return false;
 		}
-	} else if (is_large_buf) {
+	} else if (server->large_buf) {
 		/* we are reusing a dirty large buf, clear its start */
-		memset(bbuf, 0, size);
+		memset(server->bigbuf, 0, sizeof(struct smb_hdr));
 	}
 
-	if (sbuf == NULL) {
-		sbuf = (char *)cifs_small_buf_get();
-		if (!sbuf) {
+	if (!server->smallbuf) {
+		server->smallbuf = (char *)cifs_small_buf_get();
+		if (!server->smallbuf) {
 			cERROR(1, "No memory for SMB response");
 			msleep(1000);
 			/* retry will check if exiting */
@@ -349,12 +346,9 @@ allocate_buffers(char **bigbuf, char **smallbuf, unsigned int size,
 		/* beginning of smb buffer is cleared in our buf_get */
 	} else {
 		/* if existing small buf clear beginning */
-		memset(sbuf, 0, size);
+		memset(server->smallbuf, 0, sizeof(struct smb_hdr));
 	}
 
-	*bigbuf = bbuf;
-	*smallbuf = sbuf;
-
 	return true;
 }
 
@@ -563,7 +557,7 @@ dequeue_mid(struct mid_q_entry *mid, int malformed)
 
 static struct mid_q_entry *
 find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
-	      int malformed, bool is_large_buf, char **bigbuf)
+	      int malformed)
 {
 	struct mid_q_entry *mid = NULL;
 
@@ -584,19 +578,27 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 			mid->multiEnd = true;
 			goto multi_t2_fnd;
 		}
-		if (!is_large_buf) {
+		if (!server->large_buf) {
 			/*FIXME: switch to already allocated largebuf?*/
 			cERROR(1, "1st trans2 resp needs bigbuf");
 		} else {
 			/* Have first buffer */
 			mid->resp_buf = buf;
 			mid->largeBuf = true;
-			*bigbuf = NULL;
+			server->bigbuf = NULL;
 		}
 		return mid;
 	}
 	mid->resp_buf = buf;
-	mid->largeBuf = is_large_buf;
+	mid->largeBuf = server->large_buf;
+	/* Was previous buf put in mpx struct for multi-rsp? */
+	if (!mid->multiRsp) {
+		/* smb buffer will be freed by user thread */
+		if (server->large_buf)
+			server->bigbuf = NULL;
+		else
+			server->smallbuf = NULL;
+	}
 multi_t2_fnd:
 	dequeue_mid(mid, malformed);
 	return mid;
@@ -702,12 +704,11 @@ cifs_demultiplex_thread(void *p)
 {
 	int length;
 	struct TCP_Server_Info *server = p;
-	unsigned int pdu_length, total_read;
-	char *buf = NULL, *bigbuf = NULL, *smallbuf = NULL;
+	unsigned int pdu_length;
+	char *buf = NULL;
 	struct smb_hdr *smb_buffer = NULL;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
-	bool isLargeBuf = false;
 
 	current->flags |= PF_MEMALLOC;
 	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
@@ -722,19 +723,18 @@ cifs_demultiplex_thread(void *p)
 		if (try_to_freeze())
 			continue;
 
-		if (!allocate_buffers(&bigbuf, &smallbuf,
-				      sizeof(struct smb_hdr), isLargeBuf))
+		if (!allocate_buffers(server))
 			continue;
 
-		isLargeBuf = false;
-		smb_buffer = (struct smb_hdr *)smallbuf;
-		buf = smallbuf;
+		server->large_buf = false;
+		smb_buffer = (struct smb_hdr *)server->smallbuf;
+		buf = server->smallbuf;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
 		length = read_from_socket(server, buf, pdu_length);
 		if (length < 0)
 			continue;
-		total_read = length;
+		server->total_read = length;
 
 		/*
 		 * The right amount was read from socket - 4 bytes,
@@ -760,7 +760,7 @@ cifs_demultiplex_thread(void *p)
 					  sizeof(struct smb_hdr) - 1 - 4);
 		if (length < 0)
 			continue;
-		total_read += length;
+		server->total_read += length;
 
 		if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 			cERROR(1, "SMB response too long (%u bytes)",
@@ -772,10 +772,11 @@ cifs_demultiplex_thread(void *p)
 
 		/* else length ok */
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
-			isLargeBuf = true;
-			memcpy(bigbuf, smallbuf, total_read);
-			smb_buffer = (struct smb_hdr *)bigbuf;
-			buf = bigbuf;
+			server->large_buf = true;
+			memcpy(server->bigbuf, server->smallbuf,
+			       server->total_read);
+			smb_buffer = (struct smb_hdr *)server->bigbuf;
+			buf = server->bigbuf;
 		}
 
 		/* now read the rest */
@@ -784,9 +785,9 @@ cifs_demultiplex_thread(void *p)
 				  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
 		if (length < 0)
 			continue;
-		total_read += length;
+		server->total_read += length;
 
-		dump_smb(smb_buffer, total_read);
+		dump_smb(smb_buffer, server->total_read);
 
 		/*
 		 * We know that we received enough to get to the MID as we
@@ -797,28 +798,18 @@ cifs_demultiplex_thread(void *p)
 		 * 48 bytes is enough to display the header and a little bit
 		 * into the payload for debugging purposes.
 		 */
-		length = checkSMB(smb_buffer, smb_buffer->Mid, total_read);
+		length = checkSMB(smb_buffer, smb_buffer->Mid,
+				  server->total_read);
 		if (length != 0)
 			cifs_dump_mem("Bad SMB: ", buf,
-				      min_t(unsigned int, total_read, 48));
+				min_t(unsigned int, server->total_read, 48));
 
 		server->lstrp = jiffies;
 
-		mid_entry = find_cifs_mid(server, smb_buffer, length,
-					  isLargeBuf, &bigbuf);
+		mid_entry = find_cifs_mid(server, smb_buffer, length);
 		if (mid_entry != NULL) {
-			if (mid_entry->multiRsp && !mid_entry->multiEnd)
-				continue;
-
-			/* Was previous buf put in mpx struct for multi-rsp? */
-			if (!mid_entry->multiRsp) {
-				/* smb buffer will be freed by user thread */
-				if (isLargeBuf)
-					bigbuf = NULL;
-				else
-					smallbuf = NULL;
-			}
-			mid_entry->callback(mid_entry);
+			if (!mid_entry->multiRsp || mid_entry->multiEnd)
+				mid_entry->callback(mid_entry);
 		} else if (length != 0) {
 			/* response sanity checks failed */
 			continue;
@@ -836,9 +827,9 @@ cifs_demultiplex_thread(void *p)
 	} /* end while !EXITING */
 
 	/* buffer usually freed in free_mid - need to free it here on exit */
-	cifs_buf_release(bigbuf);
-	if (smallbuf) /* no sense logging a debug message if NULL */
-		cifs_small_buf_release(smallbuf);
+	cifs_buf_release(server->bigbuf);
+	if (server->smallbuf) /* no sense logging a debug message if NULL */
+		cifs_small_buf_release(server->smallbuf);
 
 	task_to_wake = xchg(&server->tsk, NULL);
 	clean_demultiplex_info(server);
-- 
1.7.6
