From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 05/24] CIFS: Make transport routines work with SMB2
Date: Wed, 20 Jun 2012 18:30:45 +0400
Message-ID: <1340202664-28696-6-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile        |    2 +-
 fs/cifs/cifsglob.h      |    5 ++
 fs/cifs/cifsproto.h     |    1 +
 fs/cifs/smb1ops.c       |    1 +
 fs/cifs/smb2ops.c       |   17 +++++
 fs/cifs/smb2pdu.h       |   59 ++++++++++++++++++
 fs/cifs/smb2proto.h     |    5 ++
 fs/cifs/smb2transport.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c     |   13 ++--
 9 files changed, 246 insertions(+), 8 deletions(-)
 create mode 100644 fs/cifs/smb2transport.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 4a77271..a73d7f8 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
-cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o
+cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6d18962..3575f0f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -22,6 +22,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/slab.h>
+#include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
@@ -218,6 +219,7 @@ struct smb_version_values {
 	size_t		header_size;
 	size_t		max_header_size;
 	size_t		read_rsp_size;
+	__le16		lock_cmd;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
@@ -812,6 +814,7 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
+	struct TCP_Server_Info *server;	/* server corresponding to this mid */
 	__u64 mid;		/* multiplex id */
 	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
@@ -1153,6 +1156,8 @@ void cifs_oplock_break(struct work_struct *work);
 extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
 
+extern mempool_t *cifs_mid_poolp;
+
 /* Operations for different SMB versions */
 #define SMB1_VERSION_STRING	"1.0"
 extern struct smb_version_operations smb1_operations;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7ae25c2..80d35ee 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -68,6 +68,7 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 728595f..8f87386 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -445,4 +445,5 @@ struct smb_version_values smb1_values = {
 	.header_size = sizeof(struct smb_hdr),
 	.max_header_size = MAX_CIFS_HDR_SIZE,
 	.read_rsp_size = sizeof(READ_RSP),
+	.lock_cmd = cpu_to_le16(SMB_COM_LOCKING_ANDX),
 };
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f065e89..09530f4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -18,10 +18,27 @@
  */
 
 #include "cifsglob.h"
+#include "smb2pdu.h"
+#include "smb2proto.h"
+
+static __u64
+smb2_get_next_mid(struct TCP_Server_Info *server)
+{
+	__u64 mid;
+	/* for SMB2 we need the current value */
+	spin_lock(&GlobalMid_Lock);
+	mid = server->CurrentMid++;
+	spin_unlock(&GlobalMid_Lock);
+	return mid;
+}
 
 struct smb_version_operations smb21_operations = {
+	.setup_request = smb2_setup_request,
+	.check_receive = smb2_check_receive,
+	.get_next_mid = smb2_get_next_mid,
 };
 
 struct smb_version_values smb21_values = {
 	.version_string = SMB21_VERSION_STRING,
+	.lock_cmd = SMB2_LOCK,
 };
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d35ac68..c7f52e3 100644
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
+/* List of commands in host endian */
+#define SMB2_NEGOTIATE_HE	0x0000
+#define SMB2_SESSION_SETUP_HE	0x0001
+#define SMB2_LOGOFF_HE		0x0002 /* trivial request/resp */
+#define SMB2_TREE_CONNECT_HE	0x0003
+#define SMB2_TREE_DISCONNECT_HE	0x0004 /* trivial req/resp */
+#define SMB2_CREATE_HE		0x0005
+#define SMB2_CLOSE_HE		0x0006
+#define SMB2_FLUSH_HE		0x0007 /* trivial resp */
+#define SMB2_READ_HE		0x0008
+#define SMB2_WRITE_HE		0x0009
+#define SMB2_LOCK_HE		0x000A
+#define SMB2_IOCTL_HE		0x000B
+#define SMB2_CANCEL_HE		0x000C
+#define SMB2_ECHO_HE		0x000D
+#define SMB2_QUERY_DIRECTORY_HE	0x000E
+#define SMB2_CHANGE_NOTIFY_HE	0x000F
+#define SMB2_QUERY_INFO_HE	0x0010
+#define SMB2_SET_INFO_HE	0x0011
+#define SMB2_OPLOCK_BREAK_HE	0x0012
+
+/* The same list in little endian */
+#define SMB2_NEGOTIATE		cpu_to_le16(SMB2_NEGOTIATE_HE)
+#define SMB2_SESSION_SETUP	cpu_to_le16(SMB2_SESSION_SETUP_HE)
+#define SMB2_LOGOFF		cpu_to_le16(SMB2_LOGOFF_HE)
+#define SMB2_TREE_CONNECT	cpu_to_le16(SMB2_TREE_CONNECT_HE)
+#define SMB2_TREE_DISCONNECT	cpu_to_le16(SMB2_TREE_DISCONNECT_HE)
+#define SMB2_CREATE		cpu_to_le16(SMB2_CREATE_HE)
+#define SMB2_CLOSE		cpu_to_le16(SMB2_CLOSE_HE)
+#define SMB2_FLUSH		cpu_to_le16(SMB2_FLUSH_HE)
+#define SMB2_READ		cpu_to_le16(SMB2_READ_HE)
+#define SMB2_WRITE		cpu_to_le16(SMB2_WRITE_HE)
+#define SMB2_LOCK		cpu_to_le16(SMB2_LOCK_HE)
+#define SMB2_IOCTL		cpu_to_le16(SMB2_IOCTL_HE)
+#define SMB2_CANCEL		cpu_to_le16(SMB2_CANCEL_HE)
+#define SMB2_ECHO		cpu_to_le16(SMB2_ECHO_HE)
+#define SMB2_QUERY_DIRECTORY	cpu_to_le16(SMB2_QUERY_DIRECTORY_HE)
+#define SMB2_CHANGE_NOTIFY	cpu_to_le16(SMB2_CHANGE_NOTIFY_HE)
+#define SMB2_QUERY_INFO		cpu_to_le16(SMB2_QUERY_INFO_HE)
+#define SMB2_SET_INFO		cpu_to_le16(SMB2_SET_INFO_HE)
+#define SMB2_OPLOCK_BREAK	cpu_to_le16(SMB2_OPLOCK_BREAK_HE)
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
index 08249ee..0e59afb 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -34,4 +34,9 @@ struct statfs;
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
 
+extern int smb2_check_receive(struct mid_q_entry *mid,
+			      struct TCP_Server_Info *server, bool log_error);
+extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
+			      unsigned int nvec, struct mid_q_entry **ret_mid);
+
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
new file mode 100644
index 0000000..b4b6b9a
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
+ * and when srv_mutex is held.
+ */
+static inline void
+smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct smb2_hdr *hdr)
+{
+	hdr->MessageId = get_next_mid(server);
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
+		temp->server = server;
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
+	smb2_seq_num_into_buf(ses->server, hdr);
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
index bfbf0f9..bd51339 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -35,10 +35,8 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
-extern mempool_t *cifs_mid_poolp;
-
-static void
-wake_up_task(struct mid_q_entry *mid)
+void
+cifs_wake_up_task(struct mid_q_entry *mid)
 {
 	wake_up_process(mid->callback_data);
 }
@@ -65,12 +63,13 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 		/* when mid allocated can be before when sent */
 		temp->when_alloc = jiffies;
+		temp->server = server;
 
 		/*
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
-		temp->callback = wake_up_task;
+		temp->callback = cifs_wake_up_task;
 		temp->callback_data = current;
 	}
 
@@ -83,6 +82,7 @@ void
 DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 #ifdef CONFIG_CIFS_STATS2
+	__le16 command = midEntry->server->vals->lock_cmd;
 	unsigned long now;
 #endif
 	midEntry->mid_state = MID_FREE;
@@ -96,8 +96,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	/* commands taking longer than one second are indications that
 	   something is wrong, unless it is quite a slow link or server */
 	if ((now - midEntry->when_alloc) > HZ) {
-		if ((cifsFYI & CIFS_TIMER) &&
-		    (midEntry->command != cpu_to_le16(SMB_COM_LOCKING_ANDX))) {
+		if ((cifsFYI & CIFS_TIMER) && (midEntry->command != command)) {
 			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
 			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
-- 
1.7.1
