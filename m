From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: re: mid structures cifs vs. smb2
Date: Fri, 11 Mar 2011 19:09:25 -0600
Message-ID: <AANLkTimG8a_XsYKeGzfjdEF-nKZorq0HjJL9_6Chg2fq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

So with the rearrangement of fields to make it easier to compare the
two structures (and fixing the size of the smb2 pid field
to match the SMB2 protocol definition rather than pid_t,
and removing the unneded sequence number for smb2),
the structures now would look simpler:

/* one of these for every pending CIFS request to the server */
struct mid_q_entry {
	struct list_head qhead;	/* mids waiting on reply from this server */
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
	__u32 sequence_number;  /* for CIFS signing */
	__u8 command;		/* smb command code */
	__u16 pid;		/* process id */
	struct smb_hdr *resp_buf;	/* response buffer */
	bool multiRsp:1;	/* multiple trans2 responses for one request  */
	bool multiEnd:1;	/* both received */
};


/* one of these for every pending SMB2 request to the server */
struct smb2_mid_entry {
	struct list_head qhead;	/* mids waiting on reply from this server */
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
	__u32 pid;		/* process id - bigger for smb2 than cifs */
	struct smb2_hdr *resp_buf;	/* response buffer */

	/* Additional fields below needed for handling async smb2 responses
	and for asynchronous smb2_writepages support have been temporarily
	removed from the port and will be reenabled as that gets merged in */

    /* Fields needed for smb2_writepages, compound ops, async support
       will eventually follow */
};
-- 
Thanks,

Steve
