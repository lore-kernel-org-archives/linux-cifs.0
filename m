From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mid structures cifs vs. smb2
Date: Fri, 11 Mar 2011 18:00:20 -0600
Message-ID: <AANLkTi=O_D90MxzG81V6==8GDc78mPrBW=+6ERLwKmwr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thinking over Jeff's comments I have done the following to make it easier to
read/review and cleanup:
- removed the now unneeded field that Jeff noted
- reordered the fields in the two mid structures so it is clear what is common
- put the 7 common fields in the two structures are at the beginning (if we want
to move to a common base mid substructure e.g.)
- next put the 7 or 8 fields which differ or are protocol unique and used now
- moved to the end, and commented out temporarily (#if 0) until they are used,
the mid fields relating to:
    a) handling "async" interim responses from the server to smb2 requests
    b) compound multi part operations (smb2 command chaining)
    c) those for Pavel's asynchronous smb2_writepages (and Jeremy's readpages)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d69e1e6..ce378ed 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -591,20 +591,20 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	__u16 mid;		/* multiplex id */
-	__u16 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
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
index 66c01db..909cf39 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -160,29 +160,37 @@ struct page_req {
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
 	__u32 sequence_number;	/* for signing */ /* BB check if needed */
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
+	pid_t pid;		/* process id - bigger for smb2 than cifs */
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
@@ -196,8 +204,7 @@ struct smb2_mid_entry {
 	bool complex_mid:1; /* complex entry - consists of several messages */
 	int result;
 	unsigned long last_rsp_time;
-	int (*callback)(struct smb2_mid_entry * , void *);
-	void *callback_data;
+#endif
 };

This makes the mids looks as follows.  For cifs:
struct mid_q_entry {
	struct list_head qhead;	/* mids waiting on reply from this server */
	__u32 sequence_number;  /* for CIFS signing */
	int midState;	/* wish this were enum but can not pass to wait_event */
	unsigned long when_alloc;  /* when mid was created */
#ifdef CONFIG_CIFS_STATS2
	unsigned long when_sent; /* time when smb send finished */
	unsigned long when_received; /* when demux complete (taken off wire) */
#endif
	bool largeBuf:1;	/* if valid response, is pointer to large buf */
	mid_callback_t *callback; /* call completion callback */
	void *callback_data;	  /* general purpose pointer for callback */
	__u16 mid;		/* multiplex id */
	__u8 command;		/* smb command code */
	__u16 pid;		/* process id */
	struct smb_hdr *resp_buf;	/* response buffer */
	bool multiRsp:1;	/* multiple trans2 responses for one request  */
	bool multiEnd:1;	/* both received */
};

and for smb2 it should be easier to read now:
/* one of these for every pending SMB2 request to the server */
struct smb2_mid_entry {
	struct list_head qhead;	/* mids waiting on reply from this server */
	__u32 sequence_number;	/* for signing */ /* BB check if needed */
	int mid_state;	/* wish this were enum but can not pass to wait_event */
	unsigned long when_alloc;  /* when mid was created */
#ifdef CONFIG_CIFS_STATS2
	unsigned long when_sent; /* time when smb send finished */
	unsigned long when_received; /* when demux complete (taken off wire) */
#endif
	bool large_buf:1;	/* if valid response, is pointer to large buf */
	smb2_mid_callback_t *callback;
	void *callback_data;
	__u64 mid;		/* multiplex id(s), bigger for smb2 */
	__le16 command;		/* smb2 command code */
	pid_t pid;		/* process id - bigger for smb2 than cifs */
	struct smb2_hdr *resp_buf;	/* response buffer */

	/* Additional fields below needed for handling async smb2 responses
	and for asynchronous smb2_writepages support have been temporarily
	removed from the port and will be reenabled as that gets merged in */

#if 0 /* Fields needed for smb2_writepages, compound ops, async support */
	char **pagebuf_list;	        /* response buffer */
	int num_pages;
	bool async_resp_rcvd:1; /* if server has responded with interim resp */
	bool is_kmap_buf:1;
	__u64 *mid_list;	/* multiplex id(s) */
	int *mid_state_list;
	short int *large_buf_list;
	unsigned int num_mid;
	unsigned int act_num_mid;
	unsigned int num_received;
	unsigned int cur_id;
	struct smb2_hdr **resp_buf_list;	/* response buffer */
	__le16 *command_list;
	bool async:1;
	bool complex_mid:1; /* complex entry - consists of several messages */
	int result;
	unsigned long last_rsp_time;
#endif
};


-- 
Thanks,

Steve
