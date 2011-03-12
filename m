From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier structures)
Date: Fri, 11 Mar 2011 21:24:05 -0600
Message-ID: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

    [CIFS] Allocating SMB2 mids (multiplex identifier structures)

    Multiplex structures track pending requests.  Due to protocol
    differences including new features, async responses, and
    larger sizes to various fields in SMB2 vs. CIFS protocol
    (as well as some obsolete features of cifs not needed in
    smb2) the structures differ.

    Also create routines for allocating smb2 mids
    (they are similar in general structure to the two
    mid allocation helpers for cifs but with some obvious
    differences due to SMB2 protocol).

    Thinking over Jeff Layton's comments I have done the following to make
    the two types of mid structures clearer:
    - removed the now unneeded task field that Jeff noted (for smb2)
    - removed the unneeded sequence number field for smb2
    - reordered the fields in the two mid structures so it is clear
what is common
    - put the 6 common fields in the two structures are at the beginning (if we
    ever would want to move to a common base mid substructure e.g. in
a later patch)
    - next put the 7 or 8 fields which differ or are protocol unique
and used now
    - moved to the end, and commented out temporarily (#if 0) until
they are used,
    the mid fields relating to:
       a) handling "async" interim responses from the server to smb2 requests
       b) compound multi part operations (smb2 command chaining)
       c) those for Pavel's asynchronous smb2_writepages (and Jeremy's
readpages)

    Next patch will add the routines to delete smb2 mids.
    The transport routines (in smb2transport.c) needed by SMB2 Negotiate
    obviously need SMB2 mid allocation and deletion routine and will be
    added in the next patch after that and will be the first users
    of this.

    CC: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 120a9cf..1f489c7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/cifsfs.c
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   Common Internet FileSystem (CIFS) client
@@ -88,6 +88,11 @@ MODULE_PARM_DESC(sign_zero_copy, "Don't copy pages
on write with signing "
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
+#ifdef CONFIG_CIFS_SMB2
+extern mempool_t *smb2_mid_poolp;
+mempool_t *smb2_mid_poolp;
+static struct kmem_cache *smb2_mid_cachep;
+#endif /* CONFIG_CIFS_SMB2 */

 void
 cifs_sb_active(struct super_block *sb)
@@ -968,6 +973,25 @@ cifs_init_mids(void)
 		return -ENOMEM;
 	}

+#ifdef CONFIG_CIFS_SMB2
+	smb2_mid_cachep = kmem_cache_create("smb2_mpx_ids",
+					    sizeof(struct smb2_mid_entry), 0,
+					    SLAB_HWCACHE_ALIGN, NULL);
+	if (smb2_mid_cachep == NULL) {
+		mempool_destroy(cifs_mid_poolp);
+		kmem_cache_destroy(cifs_mid_cachep);
+		return -ENOMEM;
+	}
+
+	smb2_mid_poolp = mempool_create_slab_pool(3, smb2_mid_cachep);
+	if (smb2_mid_poolp == NULL) {
+		mempool_destroy(cifs_mid_poolp);
+		kmem_cache_destroy(cifs_mid_cachep);
+		kmem_cache_destroy(smb2_mid_cachep);
+		return -ENOMEM;
+	}
+#endif /* CONFIG_CIFS_SMB2 */
+
 	return 0;
 }

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d69e1e6..398f596 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -591,20 +591,20 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	__u16 mid;		/* multiplex id */
-	__u16 pid;		/* process id */
-	__u32 sequence_number;  /* for CIFS signing */
+	int midState;	/* wish this were enum but can not pass to wait_event */
 	unsigned long when_alloc;  /* when mid was created */
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long when_sent; /* time when smb send finished */
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
+	bool largeBuf:1;	/* if valid response, is pointer to large buf */
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	  /* general purpose pointer for callback */
+	__u16 mid;		/* multiplex id */
+	__u32 sequence_number;  /* for CIFS signing */
+	__u8 command;		/* smb command code */
+	__u16 pid;		/* process id */
 	struct smb_hdr *resp_buf;	/* response buffer */
-	int midState;	/* wish this were enum but can not pass to wait_event */
-	__u8 command;	/* smb command code */
-	bool largeBuf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 };
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 66c01db..0093df9 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -160,29 +160,36 @@ struct page_req {
 	struct mid_q_entry *midq; /* queue structure for demultiplex */
 };

+struct smb2_mid_entry;
+
+typedef void (smb2_mid_callback_t)(struct smb2_mid_entry *mid);
+
 /* one of these for every pending SMB2 request to the server */
 struct smb2_mid_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	__u64 mid;		/* multiplex id(s) */
-	__u16 pid;		/* process id */
-	__u32 sequence_number;	/* for signing */ /* BB check if needed */
+	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	unsigned long when_alloc;  /* when mid was created */
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long when_sent; /* time when smb send finished */
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
-	struct task_struct *tsk;	/* task waiting for response */
+	bool large_buf:1;	/* if valid response, is pointer to large buf */
+	smb2_mid_callback_t *callback;
+	void *callback_data;
+	__u64 mid;		/* multiplex id(s), bigger for smb2 */
+	__le16 command;		/* smb2 command code */
+	__u32 pid;		/* process id - bigger for smb2 than cifs */
 	struct smb2_hdr *resp_buf;	/* response buffer */
+
+	/* Additional fields below needed for handling async smb2 responses
+	and for asynchronous smb2_writepages support have been temporarily
+	removed from the port and will be reenabled as that gets merged in */
+
+#if 0 /* Fields needed for smb2_writepages, compound ops, async support */
 	char **pagebuf_list;	        /* response buffer */
 	int num_pages;
-	int mid_state;	/* wish this were enum but can not pass to wait_event */
-	__le16 command;	/* smb command code */
 	bool async_resp_rcvd:1; /* if server has responded with interim resp */
-	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool is_kmap_buf:1;
-/*	bool multi_rsp:1; BB do we have to account for something in SMB2 like
-	we saw multiple trans2 responses for one request (possible in CIFS) */
-	/* Async things */
 	__u64 *mid_list;	/* multiplex id(s) */
 	int *mid_state_list;
 	short int *large_buf_list;
@@ -196,8 +203,7 @@ struct smb2_mid_entry {
 	bool complex_mid:1; /* complex entry - consists of several messages */
 	int result;
 	unsigned long last_rsp_time;
-	int (*callback)(struct smb2_mid_entry * , void *);
-	void *callback_data;
+#endif
 };


diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 018d36f..bce3cf9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -187,8 +187,6 @@ extern int new_read_req(struct kvec *iov, struct
cifs_tcon *tcon,
 			const unsigned int count, const __u64 lseek,
 			unsigned int remaining_bytes,
 			int request_type);
-extern int allocate_mid(struct cifs_ses *ses, struct smb2_hdr *in_buf,
-			struct mid_q_entry **ppmidq);
 extern int smb2_sendv(struct TCP_Server_Info *server, struct kvec *iov,
 		      int n_vec);
 extern int wait_for_free_request(struct cifs_ses *ses, const int long_op);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 53cf4ec..9d33cd2 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -35,6 +35,8 @@
 #include "cifs_debug.h"
 #include "smb2status.h"

+extern mempool_t *smb2_mid_poolp;
+
 /*
  *  Send an (optionally, already signed) SMB2 request over a socket.
  *  This socket is already locked (by a mutex) by the caller so we
@@ -137,4 +139,72 @@ smb2_send_complex(const unsigned int xid, struct
cifs_ses *ses,
 	return rc;
 }

+static void
+wake_up_smb2_task(struct smb2_mid_entry *mid)
+{
+	wake_up_process(mid->callback_data);
+}
+
+static struct smb2_mid_entry *
+smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
+		     struct TCP_Server_Info *server)
+{
+	struct smb2_mid_entry *temp;
+
+	if (server == NULL) {
+		cERROR(1, "Null TCP session in smb2_mid_entry_alloc");
+		return NULL;
+	}
+
+	temp = mempool_alloc(smb2_mid_poolp, GFP_NOFS);
+	if (temp == NULL)
+		return temp;
+	else {
+		memset(temp, 0, sizeof(struct smb2_mid_entry));
+		temp->mid = smb_buffer->MessageId;	/* always LE */
+		temp->pid = current->pid;
+		temp->command = smb_buffer->Command;	/* Always LE */
+		temp->when_alloc = jiffies;
+
+		/*
+		 * The default is for the mid to be synchronous, so the
+		 * default callback just wakes up the current task.
+		 */
+		temp->callback = wake_up_smb2_task;
+		temp->callback_data = current;
+	}
+
+	atomic_inc(&midCount);
+	temp->mid_state = MID_REQUEST_ALLOCATED;
+	return temp;
+}
+
+static int get_smb2_mid(struct cifs_ses *ses, struct smb2_hdr *in_buf,
+			struct smb2_mid_entry **ppmidQ)
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
+		/* check if SMB session is bad because we are setting it up */
+		if ((in_buf->Command != SMB2_SESSION_SETUP) &&
+			(in_buf->Command != SMB2_NEGOTIATE))
+			return -EAGAIN;
+		/* else ok - we are setting up session */
+	}
+	*ppmidQ = smb2_mid_entry_alloc(in_buf, ses->server);
+	if (*ppmidQ == NULL)
+		return -ENOMEM;
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&(*ppmidQ)->qhead, &ses->server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
+	return 0;
+}
+
+
 /* BB add missing functions here */

-- 
Thanks,

Steve
