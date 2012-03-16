From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 08/11] CIFS: Separate protocol-specific code from demultiplex code
Date: Fri, 16 Mar 2012 18:09:31 +0300
Message-ID: <1331910574-998-9-git-send-email-piastry@etersoft.ru>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331910574-998-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    5 ++-
 fs/cifs/cifs_debug.h |    2 +-
 fs/cifs/cifsglob.h   |    2 +-
 fs/cifs/cifsproto.h  |    5 +--
 fs/cifs/connect.c    |   78 +++++++++++++++++++++++++++-----------------------
 fs/cifs/misc.c       |    7 +++-
 fs/cifs/transport.c  |    4 +-
 7 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 573b899..bcd0db7 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -58,15 +58,16 @@ cifs_dump_mem(char *label, void *data, int length)
 }
 
 #ifdef CONFIG_CIFS_DEBUG2
-void cifs_dump_detail(struct smb_hdr *smb)
+void cifs_dump_detail(void *buf)
 {
+	struct smb_hdr *smb = (struct smb_hdr *)buf;
+
 	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
 		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
 	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
 }
 
-
 void cifs_dump_mids(struct TCP_Server_Info *server)
 {
 	struct list_head *tmp;
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 0a234c1..566e0ae 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -26,7 +26,7 @@
 void cifs_dump_mem(char *label, void *data, int length);
 #ifdef CONFIG_CIFS_DEBUG2
 #define DBG2 2
-void cifs_dump_detail(struct smb_hdr *);
+void cifs_dump_detail(void *);
 void cifs_dump_mids(struct TCP_Server_Info *);
 #else
 #define DBG2 0
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c3c7d7c..34a897e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -730,7 +730,7 @@ struct mid_q_entry {
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	  /* general purpose pointer for callback */
-	struct smb_hdr *resp_buf;	/* pointer to received SMB header */
+	void *resp_buf;		/* pointer to received SMB header */
 	int midState;	/* wish this were enum but can not pass to wait_event */
 	__u8 command;	/* smb command code */
 	bool largeBuf:1;	/* if valid response, is pointer to large buf */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2d506e3..15c9b59 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -91,9 +91,8 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 extern void cifs_add_credits(struct TCP_Server_Info *server,
 			     const unsigned int add);
 extern void cifs_set_credits(struct TCP_Server_Info *server, const int val);
-extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
-extern bool is_valid_oplock_break(struct smb_hdr *smb,
-				  struct TCP_Server_Info *);
+extern int checkSMB(char *buf, unsigned int length);
+extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
 extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4156351..76cffc9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -183,8 +183,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		-EINVAL = invalid transact2
 
  */
-static int check2ndT2(struct smb_hdr *pSMB)
+static int check2ndT2(char *buf)
 {
+	struct smb_hdr *pSMB = (struct smb_hdr *)buf;
 	struct smb_t2_rsp *pSMBt;
 	int remaining;
 	__u16 total_data_size, data_in_this_rsp;
@@ -224,10 +225,10 @@ static int check2ndT2(struct smb_hdr *pSMB)
 	return remaining;
 }
 
-static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
+static int coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 {
-	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)psecond;
-	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)pTargetSMB;
+	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)second_buf;
+	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)target_hdr;
 	char *data_area_of_tgt;
 	char *data_area_of_src;
 	int remaining;
@@ -280,23 +281,23 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
 
 	/* fix up the BCC */
-	byte_count = get_bcc(pTargetSMB);
+	byte_count = get_bcc(target_hdr);
 	byte_count += total_in_src;
 	/* is the result too big for the field? */
 	if (byte_count > USHRT_MAX) {
 		cFYI(1, "coalesced BCC too large (%u)", byte_count);
 		return -EPROTO;
 	}
-	put_bcc(byte_count, pTargetSMB);
+	put_bcc(byte_count, target_hdr);
 
-	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
+	byte_count = be32_to_cpu(target_hdr->smb_buf_length);
 	byte_count += total_in_src;
 	/* don't allow buffer to overflow */
 	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 		cFYI(1, "coalesced BCC exceeds buffer size (%u)", byte_count);
 		return -ENOBUFS;
 	}
-	pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
+	target_hdr->smb_buf_length = cpu_to_be32(byte_count);
 
 	/* copy second buffer into end of first buffer */
 	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
@@ -337,6 +338,18 @@ requeue_echo:
 	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
 }
 
+static inline size_t
+header_size(void)
+{
+	return sizeof(struct smb_hdr);
+}
+
+static inline size_t
+max_header_size(void)
+{
+	return MAX_CIFS_HDR_SIZE;
+}
+
 static bool
 allocate_buffers(struct TCP_Server_Info *server)
 {
@@ -350,7 +363,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		}
 	} else if (server->large_buf) {
 		/* we are reusing a dirty large buf, clear its start */
-		memset(server->bigbuf, 0, sizeof(struct smb_hdr));
+		memset(server->bigbuf, 0, header_size());
 	}
 
 	if (!server->smallbuf) {
@@ -364,7 +377,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		/* beginning of smb buffer is cleared in our buf_get */
 	} else {
 		/* if existing small buf clear beginning */
-		memset(server->smallbuf, 0, sizeof(struct smb_hdr));
+		memset(server->smallbuf, 0, header_size());
 	}
 
 	return true;
@@ -555,8 +568,9 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 static struct mid_q_entry *
-find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
+find_mid(struct TCP_Server_Info *server, char *buffer)
 {
+	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct mid_q_entry *mid;
 
 	spin_lock(&GlobalMid_Lock);
@@ -589,7 +603,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 
 static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
-	   struct smb_hdr *buf, int malformed)
+	   char *buf, int malformed)
 {
 	if (malformed == 0 && check2ndT2(buf) > 0) {
 		mid->multiRsp = true;
@@ -720,11 +734,10 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length;
 	char *buf = server->smallbuf;
-	struct smb_hdr *smb_buffer = (struct smb_hdr *)buf;
-	unsigned int pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
+	unsigned int pdu_length = get_rfc1002_length(buf);
 
 	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+	if (pdu_length > CIFSMaxBufSize + max_header_size() - 4) {
 		cERROR(1, "SMB response too long (%u bytes)",
 			pdu_length);
 		cifs_reconnect(server);
@@ -735,20 +748,18 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	/* switch to large buffer if too big for a small one */
 	if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
 		server->large_buf = true;
-		memcpy(server->bigbuf, server->smallbuf, server->total_read);
+		memcpy(server->bigbuf, buf, server->total_read);
 		buf = server->bigbuf;
-		smb_buffer = (struct smb_hdr *)buf;
 	}
 
 	/* now read the rest */
-	length = cifs_read_from_socket(server,
-			  buf + sizeof(struct smb_hdr) - 1,
-			  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
+	length = cifs_read_from_socket(server, buf + header_size() - 1,
+				       pdu_length - header_size() + 1 + 4);
 	if (length < 0)
 		return length;
 	server->total_read += length;
 
-	dump_smb(smb_buffer, server->total_read);
+	dump_smb(buf, server->total_read);
 
 	/*
 	 * We know that we received enough to get to the MID as we
@@ -759,7 +770,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = checkSMB(smb_buffer, smb_buffer->Mid, server->total_read);
+	length = checkSMB(buf, server->total_read);
 	if (length != 0)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
@@ -767,7 +778,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (!mid)
 		return length;
 
-	handle_mid(mid, server, smb_buffer, length);
+	handle_mid(mid, server, buf, length);
 	return 0;
 }
 
@@ -778,7 +789,6 @@ cifs_demultiplex_thread(void *p)
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length;
 	char *buf = NULL;
-	struct smb_hdr *smb_buffer = NULL;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 
@@ -799,7 +809,6 @@ cifs_demultiplex_thread(void *p)
 			continue;
 
 		server->large_buf = false;
-		smb_buffer = (struct smb_hdr *)server->smallbuf;
 		buf = server->smallbuf;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
@@ -812,14 +821,14 @@ cifs_demultiplex_thread(void *p)
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
+		if (pdu_length < header_size() - 1 - 4) {
 			cERROR(1, "SMB response too short (%u bytes)",
 				pdu_length);
 			cifs_reconnect(server);
@@ -829,12 +838,12 @@ cifs_demultiplex_thread(void *p)
 
 		/* read down to the MID */
 		length = cifs_read_from_socket(server, buf + 4,
-					sizeof(struct smb_hdr) - 1 - 4);
+					       header_size() - 1 - 4);
 		if (length < 0)
 			continue;
 		server->total_read += length;
 
-		mid_entry = find_mid(server, smb_buffer);
+		mid_entry = find_mid(server, buf);
 
 		if (!mid_entry || !mid_entry->receive)
 			length = standard_receive3(server, mid_entry);
@@ -844,22 +853,19 @@ cifs_demultiplex_thread(void *p)
 		if (length < 0)
 			continue;
 
-		if (server->large_buf) {
+		if (server->large_buf)
 			buf = server->bigbuf;
-			smb_buffer = (struct smb_hdr *)buf;
-		}
 
 		server->lstrp = jiffies;
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!is_valid_oplock_break(smb_buffer, server)) {
+		} else if (!is_valid_oplock_break(buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
-			cifs_dump_mem("Received Data is: ", buf,
-				      sizeof(struct smb_hdr));
+			cifs_dump_mem("Received Data is: ", buf, header_size());
 #ifdef CONFIG_CIFS_DEBUG2
-			cifs_dump_detail(smb_buffer);
+			cifs_dump_detail(buf);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1578617..88459d0 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -420,8 +420,10 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 }
 
 int
-checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int total_read)
+checkSMB(char *buf, unsigned int total_read)
 {
+	struct smb_hdr *smb = (struct smb_hdr *)buf;
+	__u16 mid = smb->Mid;
 	__u32 rfclen = be32_to_cpu(smb->smb_buf_length);
 	__u32 clc_len;  /* calculated length */
 	cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x",
@@ -502,8 +504,9 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int total_read)
 }
 
 bool
-is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
+is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 {
+	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
 	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 7f63c44..d4c01b9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -785,7 +785,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	*pbytes_returned = be32_to_cpu(midQ->resp_buf->smb_buf_length);
+	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
@@ -953,7 +953,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	*pbytes_returned = be32_to_cpu(midQ->resp_buf->smb_buf_length);
+	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
-- 
1.7.1
