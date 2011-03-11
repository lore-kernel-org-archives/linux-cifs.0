From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Add structure definitions for SMB2 PDUs
Date: Fri, 11 Mar 2011 14:59:17 -0500
Message-ID: <20110311145917.6f0e40ea@tlielax.poochiereds.net>
References: <AANLkTin7S9baWgbaHXXVFWx50kj2bsDj-XqdQ-OZ=zzY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin7S9baWgbaHXXVFWx50kj2bsDj-XqdQ-OZ=zzY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Feb 2011 23:25:08 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
 +
> +/* one of these for every pending SMB2 request to the server */
> +struct smb2_mid_entry {
> +	struct list_head qhead;	/* mids waiting on reply from this server */
> +	__u64 mid;		/* multiplex id(s) */
> +	__u16 pid;		/* process id */
> +	__u32 sequence_number;	/* for signing */ /* BB check if needed */
> +	unsigned long when_alloc;  /* when mid was created */
> +#ifdef CONFIG_CIFS_STATS2
> +	unsigned long when_sent; /* time when smb send finished */
> +	unsigned long when_received; /* when demux complete (taken off wire) */
> +#endif
> +	struct task_struct *tsk;	/* task waiting for response */
> +	struct smb2_hdr *resp_buf;	/* response buffer */
> +	char **pagebuf_list;	        /* response buffer */
> +	int num_pages;
> +	int mid_state;	/* wish this were enum but can not pass to wait_event */
> +	__le16 command;	/* smb command code */
> +	bool async_resp_rcvd:1; /* if server has responded with interim resp */
> +	bool large_buf:1;	/* if valid response, is pointer to large buf */
> +	bool is_kmap_buf:1;
> +/*	bool multi_rsp:1; BB do we have to account for something in SMB2 like
> +	we saw multiple trans2 responses for one request (possible in CIFS) */
> +	/* Async things */
> +	__u64 *mid_list;	/* multiplex id(s) */
> +	int *mid_state_list;
> +	short int *large_buf_list;
> +	unsigned int num_mid;
> +	unsigned int act_num_mid;
> +	unsigned int num_received;
> +	unsigned int cur_id;
> +	struct smb2_hdr **resp_buf_list;	/* response buffer */
> +	__le16 *command_list;
> +	bool async:1;
> +	bool complex_mid:1; /* complex entry - consists of several messages */
> +	int result;
> +	unsigned long last_rsp_time;
> +	int (*callback)(struct smb2_mid_entry * , void *);
> +	void *callback_data;
> +};
> +
>

Holy cow, this thing is a porker.

Can we eliminate some of these fields? For instance, you have a
callback and callback_data field like in the cifs variant, but you also
have a tsk pointer. That should no longer be needed. There also seem to
be a lot of fields that are not used in any of the code that has yet
been merged. Much of it is really unclear.

This seems like a real red flag to me. Dumping code into the tree like
this en-masse is a recipe for bloat and waste. Adding structs for
protocol definitions is one thing, adding things like this that seem to
have no rhyme or reason is quite another.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
