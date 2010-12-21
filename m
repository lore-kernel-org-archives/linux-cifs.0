From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/18] cifs: allow for different handling of received
 response
Date: Tue, 21 Dec 2010 11:48:17 -0500
Message-ID: <20101221114817.582b44df@tlielax.poochiereds.net>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
	<1292598497-29796-11-git-send-email-jlayton@redhat.com>
	<4D10CCD3.1040502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D10CCD3.1040502-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 21 Dec 2010 21:20:43 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 12/17/2010 08:38 PM, Jeff Layton wrote:
> > In order to incorporate async requests, we need to allow for a more
> > general way to do things on receive, rather than just waking up a
> > process.
> > 
> > Turn the task pointer in the mid_q_entry into a callback function and a
> > generic data pointer. When a response comes in, or the socket is
> > reconnected, cifsd can call the callback function in order to wake up
> > the process.
> > 
> > The default is to just wake up the current process which should mean no
> > change in behavior for existing code.
> > 
> > Also, clean up the locking in cifs_reconnect. There doesn't seem to be
> > any need to hold both the srv_mutex and GlobalMid_Lock when walking the
> > list of mids.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifs_debug.c |    8 +++---
> >  fs/cifs/cifsglob.h   |   15 ++++++++++++-
> >  fs/cifs/connect.c    |   56 +++++++++++++++++++++++++-------------------------
> >  fs/cifs/transport.c  |   19 +++++++++++++++-
> >  4 files changed, 63 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> > index ac7a38f..30d01bc 100644
> > --- a/fs/cifs/cifs_debug.c
> > +++ b/fs/cifs/cifs_debug.c
> > @@ -79,11 +79,11 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
> >  	spin_lock(&GlobalMid_Lock);
> >  	list_for_each(tmp, &server->pending_mid_q) {
> >  		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> > -		cERROR(1, "State: %d Cmd: %d Pid: %d Tsk: %p Mid %d",
> > +		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %d",
> >  			mid_entry->midState,
> >  			(int)mid_entry->command,
> >  			mid_entry->pid,
> > -			mid_entry->tsk,
> > +			mid_entry->callback_data,
> >  			mid_entry->mid);
> >  #ifdef CONFIG_CIFS_STATS2
> >  		cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
> > @@ -218,11 +218,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
> >  				mid_entry = list_entry(tmp3, struct mid_q_entry,
> >  					qhead);
> >  				seq_printf(m, "\tState: %d com: %d pid:"
> > -						" %d tsk: %p mid %d\n",
> > +						" %d cbdata: %p mid %d\n",
> >  						mid_entry->midState,
> >  						(int)mid_entry->command,
> >  						mid_entry->pid,
> > -						mid_entry->tsk,
> > +						mid_entry->callback_data,
> >  						mid_entry->mid);
> >  			}
> >  			spin_unlock(&GlobalMid_Lock);
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 8c3c165..db90fe0 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -508,6 +508,18 @@ static inline void cifs_stats_bytes_read(struct cifsTconInfo *tcon,
> >  
> >  #endif
> >  
> > +struct mid_q_entry;
> > +
> > +/*
> > + * This is the prototype for the mid callback function. When creating one,
> > + * take special care to avoid deadlocks. Things to bear in mind:
> > + *
> > + * - it will be called by cifsd
> > + * - the GlobalMid_Lock will be held
> > + * - the mid will be removed from the pending_mid_q list
> > + */
> > +typedef void (mid_callback_t)(struct mid_q_entry *mid);
> > +
> >  /* one of these for every pending CIFS request to the server */
> >  struct mid_q_entry {
> >  	struct list_head qhead;	/* mids waiting on reply from this server */
> > @@ -519,7 +531,8 @@ struct mid_q_entry {
> >  	unsigned long when_sent; /* time when smb send finished */
> >  	unsigned long when_received; /* when demux complete (taken off wire) */
> >  #endif
> > -	struct task_struct *tsk;	/* task waiting for response */
> > +	mid_callback_t *callback; /* call completion callback */
> > +	void *callback_data;	  /* general purpose pointer for callback */
> >  	struct smb_hdr *resp_buf;	/* response buffer */
> >  	int midState;	/* wish this were enum but can not pass to wait_event */
> >  	__u8 command;	/* smb command code */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 515cafa..734fb09 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -152,6 +152,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >  
> >  	/* before reconnecting the tcp session, mark the smb session (uid)
> >  		and the tid bad so they are not used until reconnected */
> > +	cFYI(1, "%s: marking sessions and tcons for reconnect", __func__);
> >  	spin_lock(&cifs_tcp_ses_lock);
> >  	list_for_each(tmp, &server->smb_ses_list) {
> >  		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
> > @@ -163,7 +164,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >  		}
> >  	}
> >  	spin_unlock(&cifs_tcp_ses_lock);
> > +
> >  	/* do not want to be sending data on a socket we are freeing */
> > +	cFYI(1, "%s: tearing down socket", __func__);
> >  	mutex_lock(&server->srv_mutex);
> >  	if (server->ssocket) {
> >  		cFYI(1, "State: 0x%x Flags: 0x%lx", server->ssocket->state,
> > @@ -180,22 +183,22 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >  	kfree(server->session_key.response);
> >  	server->session_key.response = NULL;
> >  	server->session_key.len = 0;
> > +	mutex_unlock(&server->srv_mutex);
> >  
> > +	/*
> > +	 * move in-progress mids to a private list so that we can walk it later
> > +	 * without needing a lock. We'll mark them for retry after reconnect.
> > +	 */
> > +	cFYI(1, "%s: issuing mid callbacks", __func__);
> 
> Is the above comment valid? This patchset doesn't use a separate list IIUC?
> 
> 

You're correct. I'll fix and resend.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
