From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 15/53] CIFS: Make demultiplex_thread work with SMB2 code
Date: Fri, 28 Oct 2011 23:54:26 +0400
Message-ID: <1319831704-3572-16-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

Now we can process SMB2 messages: check message, get message id
and wakeup awaiting routines.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
---
 fs/cifs/cifs_debug.c |   14 ++++-
 fs/cifs/connect.c    |  161 +++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/misc.c       |    5 ++
 3 files changed, 151 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 1f91bc6..b49fed2 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -30,6 +30,9 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -63,9 +66,18 @@ void cifs_dump_detail(struct smb_hdr *smb)
 	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
 		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
+	cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
 }
 
+#ifdef CONFIG_CIFS_SMB2
+void smb2_dump_detail(struct smb2_hdr *smb)
+{
+	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
+		  smb->Command, smb->Status, smb->Flags, smb->MessageId,
+		  smb->ProcessId);
+	cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
+}
+#endif
 
 void cifs_dump_mids(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 680017d..ccb7ea7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -325,6 +325,14 @@ requeue_echo:
 static bool
 allocate_buffers(struct TCP_Server_Info *server)
 {
+	size_t buf_size;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		buf_size = sizeof(struct smb2_hdr);
+	else
+#endif
+		buf_size = sizeof(struct smb_hdr);
 	if (!server->bigbuf) {
 		server->bigbuf = (char *)cifs_buf_get();
 		if (!server->bigbuf) {
@@ -335,7 +343,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		}
 	} else if (server->large_buf) {
 		/* we are reusing a dirty large buf, clear its start */
-		memset(server->bigbuf, 0, sizeof(struct smb_hdr));
+		memset(server->bigbuf, 0, buf_size);
 	}
 
 	if (!server->smallbuf) {
@@ -349,7 +357,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		/* beginning of smb buffer is cleared in our buf_get */
 	} else {
 		/* if existing small buf clear beginning */
-		memset(server->smallbuf, 0, sizeof(struct smb_hdr));
+		memset(server->smallbuf, 0, buf_size);
 	}
 
 	return true;
@@ -539,7 +547,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 static struct mid_q_entry *
-find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
+find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 {
 	struct mid_q_entry *mid;
 
@@ -556,6 +564,40 @@ find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 	return NULL;
 }
 
+#ifdef CONFIG_CIFS_SMB2
+static struct mid_q_entry *
+find_smb2_mid(struct TCP_Server_Info *server, struct smb2_hdr *buf)
+{
+	struct mid_q_entry *mid;
+
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+		if ((mid->mid == buf->MessageId) &&
+		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
+		    (mid->command == buf->Command)) {
+			spin_unlock(&GlobalMid_Lock);
+			return mid;
+		}
+	}
+	spin_unlock(&GlobalMid_Lock);
+	return NULL;
+}
+#endif
+
+static struct mid_q_entry *
+find_mid(struct TCP_Server_Info *server, char *buf)
+{
+	struct mid_q_entry *mid;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		mid = find_smb2_mid(server, (struct smb2_hdr *)buf);
+	else
+#endif
+		mid = find_cifs_mid(server, (struct smb_hdr *)buf);
+	return mid;
+}
+
 void
 dequeue_mid(struct mid_q_entry *mid, bool malformed)
 {
@@ -573,13 +615,18 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 
 static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
-	   struct smb_hdr *buf, int malformed)
+	   char *buf, int malformed)
 {
-	if (malformed == 0 && check2ndT2(buf) > 0) {
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		goto next;
+#endif
+	if (malformed == 0 && check2ndT2((struct smb_hdr *)buf) > 0) {
 		mid->multiRsp = true;
 		if (mid->resp_buf) {
 			/* merge response - fix up 1st*/
-			malformed = coalesce_t2(buf, mid->resp_buf);
+			malformed = coalesce_t2((struct smb_hdr *)buf,
+						mid->resp_buf);
 			if (malformed > 0)
 				return;
 
@@ -598,6 +645,9 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		}
 		return;
 	}
+#ifdef CONFIG_CIFS_SMB2
+next:
+#endif
 	mid->resp_buf = buf;
 	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
@@ -712,13 +762,27 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length;
 	char *buf = server->smallbuf;
-	struct smb_hdr *smb_buffer = (struct smb_hdr *)buf;
-	unsigned int pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
+	unsigned int pdu_length = get_rfc1002_length(buf);
+	size_t buf_size, max_hdr_size;
+	struct smb_hdr *smb_buffer = (struct smb_hdr *)buf; /* quiet compiler */
+#ifdef CONFIG_CIFS_SMB2
+	struct smb2_hdr *smb2_buffer = (struct smb2_hdr *)buf;
+#endif
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2) {
+		max_hdr_size = MAX_SMB2_HDR_SIZE;
+		buf_size = sizeof(struct smb2_hdr);
+	} else {
+#endif
+		max_hdr_size = MAX_CIFS_HDR_SIZE;
+		buf_size = sizeof(struct smb_hdr);
+#ifdef CONFIG_CIFS_SMB2
+	}
+#endif
 	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "SMB response too long (%u bytes)",
-			pdu_length);
+	if (pdu_length > CIFSMaxBufSize + max_hdr_size - 4) {
+		cERROR(1, "SMB response too long (%u bytes)", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -EAGAIN;
@@ -729,18 +793,27 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		server->large_buf = true;
 		memcpy(server->bigbuf, server->smallbuf, server->total_read);
 		buf = server->bigbuf;
-		smb_buffer = (struct smb_hdr *)buf;
+#ifdef CONFIG_CIFS_SMB2
+		if (server->is_smb2)
+			smb2_buffer = (struct smb2_hdr *)buf;
+		else
+#endif
+			smb_buffer = (struct smb_hdr *)buf;
 	}
 
 	/* now read the rest */
-	length = cifs_read_from_socket(server,
-			  buf + sizeof(struct smb_hdr) - 1,
-			  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
+	length = cifs_read_from_socket(server, buf + buf_size - 1,
+				       pdu_length - buf_size + 1 + 4);
 	if (length < 0)
 		return length;
 	server->total_read += length;
 
-	dump_smb(smb_buffer, server->total_read);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		dump_smb2(smb2_buffer, server->total_read);
+	else
+#endif
+		dump_smb(smb_buffer, server->total_read);
 
 	/*
 	 * We know that we received enough to get to the MID as we
@@ -751,13 +824,20 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = checkSMB(smb_buffer, smb_buffer->Mid, server->total_read);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		length = checkSMB2(smb2_buffer, smb2_buffer->MessageId,
+				   server->total_read);
+	else
+#endif
+		length = checkSMB(smb_buffer, smb_buffer->Mid,
+				  server->total_read);
 	if (length != 0)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
 	if (mid)
-		handle_mid(mid, server, smb_buffer, length);
+		handle_mid(mid, server, buf, length);
 
 	return length;
 }
@@ -769,7 +849,11 @@ cifs_demultiplex_thread(void *p)
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length;
 	char *buf = NULL;
+	size_t buf_size;
 	struct smb_hdr *smb_buffer = NULL;
+#ifdef CONFIG_CIFS_SMB2
+	struct smb2_hdr *smb2_buffer = NULL;
+#endif
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 
@@ -781,6 +865,13 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
 				GFP_KERNEL);
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		buf_size = sizeof(struct smb2_hdr);
+	else
+#endif
+		buf_size = sizeof(struct smb_hdr);
+
 	set_freezable();
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
@@ -790,8 +881,13 @@ cifs_demultiplex_thread(void *p)
 			continue;
 
 		server->large_buf = false;
-		smb_buffer = (struct smb_hdr *)server->smallbuf;
 		buf = server->smallbuf;
+#ifdef CONFIG_CIFS_SMB2
+		if (server->is_smb2)
+			smb2_buffer = (struct smb2_hdr *)buf;
+		else
+#endif
+			smb_buffer = (struct smb_hdr *)buf;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
 		length = cifs_read_from_socket(server, buf, pdu_length);
@@ -803,14 +899,14 @@ cifs_demultiplex_thread(void *p)
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
-		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
+		pdu_length = get_rfc1002_length(buf);
 
 		cFYI(1, "RFC1002 header 0x%x", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
 
 		/* make sure we have enough to get to the MID */
-		if (pdu_length < sizeof(struct smb_hdr) - 1 - 4) {
+		if (pdu_length < buf_size - 1 - 4) {
 			cERROR(1, "SMB response too short (%u bytes)",
 				pdu_length);
 			cifs_reconnect(server);
@@ -820,12 +916,12 @@ cifs_demultiplex_thread(void *p)
 
 		/* read down to the MID */
 		length = cifs_read_from_socket(server, buf + 4,
-					sizeof(struct smb_hdr) - 1 - 4);
+					       buf_size - 1 - 4);
 		if (length < 0)
 			continue;
 		server->total_read += length;
 
-		mid_entry = find_mid(server, smb_buffer);
+		mid_entry = find_mid(server, buf);
 
 		if (!mid_entry || !mid_entry->receive)
 			length = standard_receive3(server, mid_entry);
@@ -837,20 +933,29 @@ cifs_demultiplex_thread(void *p)
 
 		if (server->large_buf) {
 			buf = server->bigbuf;
-			smb_buffer = (struct smb_hdr *)buf;
+#ifdef CONFIG_CIFS_SMB2
+			if (server->is_smb2)
+				smb2_buffer = (struct smb2_hdr *)buf;
+			else
+#endif
+				smb_buffer = (struct smb_hdr *)buf;
 		}
 
 		server->lstrp = jiffies;
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!is_valid_oplock_break(smb_buffer, server)) {
+		} else if (!is_valid_oplock_break((void *)buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
-			cifs_dump_mem("Received Data is: ", buf,
-				      sizeof(struct smb_hdr));
+			cifs_dump_mem("Received Data is: ", buf, buf_size);
 #ifdef CONFIG_CIFS_DEBUG2
-			cifs_dump_detail(smb_buffer);
+#ifdef CONFIG_CIFS_SMB2
+			if (server->is_smb2)
+				smb2_dump_detail(smb2_buffer);
+			else
+#endif
+				cifs_dump_detail(smb_buffer);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4ead6f9..d291463 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -514,6 +514,11 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 	struct cifsInodeInfo *pCifsInode;
 	struct cifsFileInfo *netfile;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (srv->is_smb2)
+		return false;
+#endif
+
 	cFYI(1, "Checking for oplock break or dnotify response");
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
 	   (pSMB->hdr.Flags & SMBFLG_RESPONSE)) {
-- 
1.7.1

