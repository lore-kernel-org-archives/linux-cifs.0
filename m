From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 06/16] CIFS: Make transport routines work with SMB2
Date: Mon, 26 Mar 2012 13:21:33 +0400
Message-ID: <1332753703-4315-7-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that lets us send SMB2 negotiate message to the server further.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile        |    2 +-
 fs/cifs/cifsglob.h      |    9 +++
 fs/cifs/cifsproto.h     |    7 ++-
 fs/cifs/misc.c          |   11 ++++
 fs/cifs/smb2pdu.h       |   59 ++++++++++++++++++
 fs/cifs/smb2proto.h     |    1 +
 fs/cifs/smb2transport.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c     |   59 +++++++++++++++----
 8 files changed, 286 insertions(+), 13 deletions(-)
 create mode 100644 fs/cifs/smb2transport.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 3117f5f..e094f8a 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
-cifs-$(CONFIG_CIFS_SMB2) += smb2maperror.o
+cifs-$(CONFIG_CIFS_SMB2) += smb2maperror.o smb2transport.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fbee8ef..5db61db 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -22,11 +22,15 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/slab.h>
+#include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2pdu.h"
+#endif /* CONFIG_CIFS_SMB2 */
 
 /*
  * The sizes of various internal tables and strings
@@ -739,6 +743,9 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
+#ifdef CONFIG_CIFS_SMB2
+	bool is_smb2:1;		/* SMB2 mid */
+#endif
 	__u64 mid;		/* multiplex id */
 	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
@@ -1080,4 +1087,6 @@ void cifs_oplock_break(struct work_struct *work);
 extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
 
+extern mempool_t *cifs_mid_poolp;
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 96192c1..9f8ff33 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -36,7 +36,9 @@ extern void cifs_buf_release(void *);
 extern struct smb_hdr *cifs_small_buf_get(void);
 extern void cifs_small_buf_release(void *);
 extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
-			unsigned int /* length */);
+		    unsigned int /* length */);
+extern int smb_sendv(struct TCP_Server_Info *server, struct kvec *iov,
+		     int n_vec);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
 #define GetXid()						\
@@ -68,6 +70,9 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern int cifs_sync_mid_result(struct mid_q_entry *mid,
+				struct TCP_Server_Info *server);
+extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c29d1aa..e8fa7a4 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -241,10 +241,21 @@ __u64 GetNextMid(struct TCP_Server_Info *server)
 
 	spin_lock(&GlobalMid_Lock);
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2) {
+		/* for SMB2 we need the current value */
+		mid = server->CurrentMid;
+		server->CurrentMid++;
+		spin_unlock(&GlobalMid_Lock);
+		return mid;
+	}
+#endif
+
 	/* mid is 16 bit only for CIFS/SMB */
 	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
 	/* we do not want to loop forever */
 	last_mid = cur_mid;
+	/* for CIFS/SMB we need the next value */
 	cur_mid++;
 
 	/*
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d35ac68..574ed1d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -27,6 +27,65 @@
 #include <net/sock.h>
 
 /*
+ * Note that, due to trying to use names similar to the protocol specifications,
+ * there are many mixed case field names in the structures below.  Although
+ * this does not match typical Linux kernel style, it is necessary to be
+ * be able to match against the protocol specfication.
+ *
+ * SMB2 commands
+ * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
+ * (ie no useful data other than the SMB error code itself) and are marked such.
+ * Knowing this helps avoid response buffer allocations and copy in some cases.
+ */
+
+/* List is sent on wire as little endian */
+#define SMB2_NEGOTIATE		cpu_to_le16(0x0000)
+#define SMB2_SESSION_SETUP	cpu_to_le16(0x0001)
+#define SMB2_LOGOFF		cpu_to_le16(0x0002) /* trivial request/resp */
+#define SMB2_TREE_CONNECT	cpu_to_le16(0x0003)
+#define SMB2_TREE_DISCONNECT	cpu_to_le16(0x0004) /* trivial req/resp */
+#define SMB2_CREATE		cpu_to_le16(0x0005)
+#define SMB2_CLOSE		cpu_to_le16(0x0006)
+#define SMB2_FLUSH		cpu_to_le16(0x0007) /* trivial resp */
+#define SMB2_READ		cpu_to_le16(0x0008)
+#define SMB2_WRITE		cpu_to_le16(0x0009)
+#define SMB2_LOCK		cpu_to_le16(0x000A)
+#define SMB2_IOCTL		cpu_to_le16(0x000B)
+#define SMB2_CANCEL		cpu_to_le16(0x000C)
+#define SMB2_ECHO		cpu_to_le16(0x000D)
+#define SMB2_QUERY_DIRECTORY	cpu_to_le16(0x000E)
+#define SMB2_CHANGE_NOTIFY	cpu_to_le16(0x000F)
+#define SMB2_QUERY_INFO		cpu_to_le16(0x0010)
+#define SMB2_SET_INFO		cpu_to_le16(0x0011)
+#define SMB2_OPLOCK_BREAK	cpu_to_le16(0x0012)
+
+/* Same List of commands in host endian */
+#define SMB2NEGOTIATE		0x0000
+#define SMB2SESSION_SETUP	0x0001
+#define SMB2LOGOFF		0x0002 /* trivial request/resp */
+#define SMB2TREE_CONNECT	0x0003
+#define SMB2TREE_DISCONNECT	0x0004 /* trivial req/resp */
+#define SMB2CREATE		0x0005
+#define SMB2CLOSE		0x0006
+#define SMB2FLUSH		0x0007 /* trivial resp */
+#define SMB2READ		0x0008
+#define SMB2WRITE		0x0009
+#define SMB2LOCK		0x000A
+#define SMB2IOCTL		0x000B
+#define SMB2CANCEL		0x000C
+#define SMB2ECHO		0x000D
+#define SMB2QUERY_DIRECTORY	0x000E
+#define SMB2CHANGE_NOTIFY	0x000F
+#define SMB2QUERY_INFO		0x0010
+#define SMB2SET_INFO		0x0011
+#define SMB2OPLOCK_BREAK	0x0012
+
+#define NUMBER_OF_SMB2_COMMANDS	0x0013
+
+/* BB FIXME - analyze following length BB */
+#define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 bct + 2 pad */
+
+/*
  * SMB2 Header Definition
  *
  * "MBZ" :  Must be Zero
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 5f8779f..86a1aa9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -38,4 +38,5 @@ extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
+
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
new file mode 100644
index 0000000..a08e415
--- /dev/null
+++ b/fs/cifs/smb2transport.c
@@ -0,0 +1,151 @@
+/*
+ *   fs/cifs/smb2transport.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *                 Etersoft, 2012
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Jeremy Allison (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2006
+ *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/net.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <asm/processor.h>
+#include <linux/mempool.h>
+#include "smb2pdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "smb2proto.h"
+#include "cifs_debug.h"
+#include "smb2status.h"
+
+/*
+ * Set message id for the request. Should be called after wait_for_free_request
+ * and when srv_mutex is held. iov array must have at least 1 element.
+ */
+static inline void
+smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct kvec *iov)
+{
+	((struct smb2_hdr *)iov[0].iov_base)->MessageId = GetNextMid(server);
+}
+
+static struct mid_q_entry *
+smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
+		     struct TCP_Server_Info *server)
+{
+	struct mid_q_entry *temp;
+
+	if (server == NULL) {
+		cERROR(1, "Null TCP session in smb2_mid_entry_alloc");
+		return NULL;
+	}
+
+	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
+	if (temp == NULL)
+		return temp;
+	else {
+		memset(temp, 0, sizeof(struct mid_q_entry));
+		temp->mid = smb_buffer->MessageId;	/* always LE */
+		temp->pid = current->pid;
+		temp->command = smb_buffer->Command;	/* Always LE */
+		temp->when_alloc = jiffies;
+		temp->is_smb2 = true;
+
+		/*
+		 * The default is for the mid to be synchronous, so the
+		 * default callback just wakes up the current task.
+		 */
+		temp->callback = cifs_wake_up_task;
+		temp->callback_data = current;
+	}
+
+	atomic_inc(&midCount);
+	temp->mid_state = MID_REQUEST_ALLOCATED;
+	return temp;
+}
+
+static int
+smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
+		   struct mid_q_entry **mid)
+{
+	if (ses->server->tcpStatus == CifsExiting)
+		return -ENOENT;
+
+	if (ses->server->tcpStatus == CifsNeedReconnect) {
+		cFYI(1, "tcp session dead - return to caller to retry");
+		return -EAGAIN;
+	}
+
+	if (ses->status != CifsGood) {
+		/* check if SMB2 session is bad because we are setting it up */
+		if ((buf->Command != SMB2_SESSION_SETUP) &&
+		    (buf->Command != SMB2_NEGOTIATE))
+			return -EAGAIN;
+		/* else ok - we are setting up session */
+	}
+	*mid = smb2_mid_entry_alloc(buf, ses->server);
+	if (*mid == NULL)
+		return -ENOMEM;
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&(*mid)->qhead, &ses->server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
+	return 0;
+}
+
+int
+smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		   bool log_error)
+{
+	unsigned int len = get_rfc1002_length(mid->resp_buf);
+
+	dump_smb(mid->resp_buf, min_t(u32, 80, len));
+	/* convert the length into a more usable form */
+	/* BB - uncomment with SMB2 signing implementation */
+	/* if ((len > 24) &&
+	    (server->sec_mode & (SECMODE_SIGN_REQUIRED|SECMODE_SIGN_ENABLED))) {
+		if (smb2_verify_signature(mid->resp_buf, server))
+			cERROR(1, "Unexpected SMB signature");
+	} */
+
+	return map_smb2_to_linux_error(mid->resp_buf, log_error);
+}
+
+int
+smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
+		   unsigned int nvec, struct mid_q_entry **ret_mid)
+{
+	int rc;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
+	struct mid_q_entry *mid;
+
+	smb2_seq_num_into_buf(ses->server, iov);
+
+	rc = smb2_get_mid_entry(ses, hdr, &mid);
+	if (rc)
+		return rc;
+	/* rc = smb2_sign_smb2(iov, nvec, ses->server);
+	if (rc)
+		delete_mid(mid); */
+	*ret_mid = mid;
+	return rc;
+}
+
+/* BB add missing functions here */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0961336..79126b9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -34,11 +34,12 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
-extern mempool_t *cifs_mid_poolp;
-
-static void
-wake_up_task(struct mid_q_entry *mid)
+void
+cifs_wake_up_task(struct mid_q_entry *mid)
 {
 	wake_up_process(mid->callback_data);
 }
@@ -70,7 +71,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
-		temp->callback = wake_up_task;
+		temp->callback = cifs_wake_up_task;
 		temp->callback_data = current;
 	}
 
@@ -83,7 +84,15 @@ void
 DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 #ifdef CONFIG_CIFS_STATS2
+	__le16 command;
 	unsigned long now;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (midEntry->is_smb2)
+		command = SMB2_LOCK;
+	else
+#endif
+		command = cpu_to_le16(SMB_COM_LOCKING_ANDX);
 #endif
 	midEntry->mid_state = MID_FREE;
 	atomic_dec(&midCount);
@@ -96,8 +105,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	/* commands taking longer than one second are indications that
 	   something is wrong, unless it is quite a slow link or server */
 	if ((now - midEntry->when_alloc) > HZ) {
-		if ((cifsFYI & CIFS_TIMER) &&
-		    (midEntry->command != cpu_to_le16(SMB_COM_LOCKING_ANDX))) {
+		if ((cifsFYI & CIFS_TIMER) && (midEntry->command != command)) {
 			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
 			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
@@ -120,7 +128,7 @@ delete_mid(struct mid_q_entry *mid)
 	DeleteMidQEntry(mid);
 }
 
-static int
+int
 smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 {
 	int rc = 0;
@@ -449,7 +457,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-static int
+int
 cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
@@ -499,6 +507,11 @@ send_nt_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 {
 	int rc = 0;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		return rc;
+#endif
+
 	/* -4 for RFC1001 length and +2 for BCC field */
 	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
 	in_buf->Command = SMB_COM_NT_CANCEL;
@@ -545,6 +558,18 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 }
 
 static int
+check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+	      bool log_error)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		return smb2_check_receive(mid, server, log_error);
+	else
+#endif
+		return cifs_check_receive(mid, server, log_error);
+}
+
+static int
 cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
 		   unsigned int nvec, struct mid_q_entry **ret_mid)
 {
@@ -562,6 +587,18 @@ cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
 	return rc;
 }
 
+static int
+setup_request(struct cifs_ses *ses, struct kvec *iov,
+	      unsigned int nvec, struct mid_q_entry **ret_mid)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (ses->server->is_smb2)
+		return smb2_setup_request(ses, iov, nvec, ret_mid);
+	else
+#endif
+		return cifs_setup_request(ses, iov, nvec, ret_mid);
+}
+
 int
 SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
@@ -607,7 +644,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_lock(&ses->server->srv_mutex);
 
-	rc = cifs_setup_request(ses, iov, n_vec, &midQ);
+	rc = setup_request(ses, iov, n_vec, &midQ);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
@@ -670,7 +707,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
 
-	rc = cifs_check_receive(midQ, ses->server, flags & CIFS_LOG_ERROR);
+	rc = check_receive(midQ, ses->server, flags & CIFS_LOG_ERROR);
 
 	/* mark it so buf will not be freed by delete_mid */
 	if ((flags & CIFS_NO_RESP) == 0)
-- 
1.7.1
