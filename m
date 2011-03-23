From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sync_smb2_mid_result
Date: Wed, 23 Mar 2011 12:42:26 -0500
Message-ID: <AANLkTinVcBpT7X7A4XKd8+rz0XJw8ms159UnsK5aH49f@mail.gmail.com>
References: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2@mail.gmail.com>
	<20110323120617.0379e0a1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110323120617.0379e0a1-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 23, 2011 at 11:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, 12 Mar 2011 19:55:55 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Previously CIFS added a function, sync_mid_result, to better handle
>> certain error conditions.
>> This patch adds the equivalent for SMB2 mids (they are used by smb2_sendrcv2
>> which is added in the next patch)

> Now that you've commented out all of the unneeded fields from the
> struct smb2_mid_entry, it's clear that the smb2_mid_entry is a subset
> of mid_q_entry. Some of the mid_q_entry fields might need to be
> expanded (the mid number itself for example), but that hardly seems to
> warrant a completely new struct and codebase for this.
>
> Can you explain why we need all of this code duplication when it now
> seems fairly clear that much of the existing code could be repurposed
> for SMB2? This approach is going to vastly increase the maintenance
> burden and I don't see that we gain anything from it.

Do you mean changing the cifs mid from its current single struct to a
nested mid_common which can be included in cifs and smb2 specific mids
(or made into a union)

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

to
struct mid_q_entry { /* common fields for smb2 and cifs mids */
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
}

and then cifs mids would look like:
struct cifs_mid_entry {
        struct mid_q_entry; /* common fields */
	__u16 mid;		/* multiplex id */
	__u32 sequence_number;  /* for CIFS signing */
	__u8 command;		/* smb command code */
	__u16 pid;		/* process id */
	struct smb_hdr *resp_buf;	/* response buffer */
	bool multiRsp:1;	/* multiple trans2 responses for one request  */
	bool multiEnd:1;	/* both received */
};

and smb2_mids would look like:
struct smb2_mid_entry {
        struct mid_q_entry; /* common fields */
	__u64 mid;		/* multiplex id(s), bigger for smb2 */
	__le16 command;		/* smb2 command code */
	__u32 pid;		/* process id - bigger for smb2 than cifs */
	struct smb2_hdr *resp_buf;	/* response buffer */
	/* More than 10 additional fields were used for other smb2 unique
        features that have not been ported to the new cifs.ko structure
        yet including chains of related commands for handling
        compound smb2 operations,  and for asynchronous smb2_writepages
support have been temporarily
	removed from the port and will be reenabled as that gets merged in */
};







-- 
Thanks,

Steve
