From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Converting the CIFS FS to using socket callbacks so I can
 support multi-connect and RDMA
Date: Mon, 20 Aug 2012 07:23:07 -0400
Message-ID: <20120820072307.5a543f48@corrin.poochiereds.net>
References: <CACyXjPwnRQ=G4orZAw8f-FB2QdfwSETm2H1G0ye2NVWR6xRgTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPwnRQ=G4orZAw8f-FB2QdfwSETm2H1G0ye2NVWR6xRgTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 19 Aug 2012 11:53:38 -0700
Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

Looks like a great start! Comments inline below:

> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 54ec716..9530faf 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -471,6 +471,16 @@ inc_rfc1001_len(void *buf, int count)
>  	be32_add_cpu((__be32 *)buf, count);
>  }
>  
> +/*
> + * States for the read socket work function
> + */
> +enum cifs_sock_read_states {
> +	CIFS_READING_PDU_HEADER = 0,
> +	CIFS_READING_SMB_HEADER,
> +	CIFS_READING_SMB_BODY,
> +	CIFS_READING_JUNK
> +};
> +
>  struct TCP_Server_Info {
>  	struct list_head tcp_ses_list;
>  	struct list_head smb_ses_list;
> @@ -555,6 +565,32 @@ struct TCP_Server_Info {
>  	unsigned int	max_read;
>  	unsigned int	max_write;
>  #endif /* CONFIG_CIFS_SMB2 */
> +
> +	/* The following should be split out probably */
> +	int use_demux_thread;

This should probbaly be a bool. BTW: what determines whether you'll use
the demux thread or not? Module option? That might be a reasonable way
to add this code in parallel to the existing code for testing.

> +	struct work_struct sock_read_work; /* How reads are processed */
> +	struct delayed_work sock_read_delayed_work; /* When we need to delay */
> +	struct delayed_work reconnect_work;  /* When we need to reconnect */
> +	/*
> +	 * Saved socket callbacks
> +	 */ 
> +	void (*initial_cifs_data_ready)(struct sock *, int);
> +	void (*initial_cifs_state_change)(struct sock *);
> +	void (*initial_cifs_write_space)(struct sock *);
> +	void (*initial_cifs_error_report)(struct sock *);
> +
> +	/*
> +	 * It is not clear that we need this ...
> +	 */
> +	spinlock_t conn_read_lock; /* Protects the next few vars */
> +
> +	/*
> +	 * These handle the processing of received SMBs and keeping track of
> +	 * how much data we have read ...
> +	 */
> +	unsigned int tcp_offset;   /* How far into an SMB we are */
> +	unsigned int smb_reclen;
> +	enum cifs_sock_read_states sock_read_state;
>  };
>  

I would think that you'd want to put these fields into a separate
struct that hangs off of a list on the TCP_Server_Info? Or, are you
planning to somehow have multiple TCP_Server_Info structs acting as
parents to the smb_ses objects?

>  static inline unsigned int
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 549409b..06a70be 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -62,6 +62,9 @@ extern mempool_t *cifs_req_poolp;
>  #define TLINK_ERROR_EXPIRE	(1 * HZ)
>  #define TLINK_IDLE_EXPIRE	(600 * HZ)
>  
> +/* How long we delay when there is no memory */
> +#define READ_NO_MEMORY_DELAY    (1 * HZ)
> +
>  enum {
>  
>  	/* Mount options that take no arguments */
> @@ -422,6 +425,46 @@ requeue_echo:
>  	queue_delayed_work(cifsiod_wq, &server->echo, SMB_ECHO_INTERVAL);
>  }
>  
> +/*
> + * An allocate buffers routine for work queues. We cannot call sleep in a 
> + * work queue, so we return false immediately, and the work item must 
> + * reschedule itself, delayed.
> + */

You absolutely _can_ sleep on a workqueue. One of the main reasons for
deferring work to a workqueue from an interrupt handler is to do things
that require you to sleep.

> +static bool
> +work_allocate_buffers(struct TCP_Server_Info *server)
> +{
> +	if (!server->bigbuf) {
> +		server->bigbuf = (char *)cifs_buf_get();


...and you're possibly sleeping here in any case. cifs_buf_get can
sleep since it does a slab allocation with GFP_NOFS. That includes the
__GFP_WAIT flag which allows the page allocator to sleep while trying
to free memory.

> +		if (!server->bigbuf) {
> +			printk(KERN_INFO "%s:no memory for large buf for %p", 
> +				__func__, server);
> +			cERROR(1, "No memory for large SMB response");
> +			/* retry will check if exiting */
> +			return false;
> +		}
> +	} else if (server->large_buf) {
> +		/* we are reusing a dirty large buf, clear its start */
> +		memset(server->bigbuf, 0, HEADER_SIZE(server));
> +	}
> +
> +	if (!server->smallbuf) {
> +		server->smallbuf = (char *)cifs_small_buf_get();
> +		if (!server->smallbuf) {
> +			printk(KERN_INFO "%s:no memory for small buf for %p\n",
> +				__func__, server);
> +			cERROR(1, "No memory for small SMB response");
> +			/* retry will check if exiting */
> +			return false;
> +		}
> +		/* beginning of smb buffer is cleared in our buf_get */
> +	} else {
> +		/* if existing small buf clear beginning */
> +		memset(server->smallbuf, 0, HEADER_SIZE(server));
> +	}
> +
> +	return true;
> +}
> +
>  static bool
>  allocate_buffers(struct TCP_Server_Info *server)
>  {
> @@ -2166,25 +2209,27 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		goto out_err_crypto_release;
>  	}
>  
> +	if (tcp_ses->use_demux_thread) {
> +		tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
> +					  tcp_ses, "cifsd");
> +		if (IS_ERR(tcp_ses->tsk)) {
> +			rc = PTR_ERR(tcp_ses->tsk);
> +			cERROR(1, "error %d create cifsd thread", rc);
> +			goto out_err_crypto_release;
> +		}
> +		tcp_ses->tcpStatus = CifsNeedNegotiate;
> +
> +		/* thread spawned, put it on the list */
> +		spin_lock(&cifs_tcp_ses_lock);
> +		list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
> +		spin_unlock(&cifs_tcp_ses_lock);
> +	}
> +
>  	/*
>  	 * since we're in a cifs function already, we know that
>  	 * this will succeed. No need for try_module_get().
>  	 */
>  	__module_get(THIS_MODULE);
> -	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
> -				  tcp_ses, "cifsd");
> -	if (IS_ERR(tcp_ses->tsk)) {
> -		rc = PTR_ERR(tcp_ses->tsk);
> -		cERROR(1, "error %d create cifsd thread", rc);
> -		module_put(THIS_MODULE);
> -		goto out_err_crypto_release;
> -	}
> -	tcp_ses->tcpStatus = CifsNeedNegotiate;
> -
> -	/* thread spawned, put it on the list */
> -	spin_lock(&cifs_tcp_ses_lock);
> -	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
> -	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	cifs_fscache_get_client_cookie(tcp_ses);
>  
> @@ -2959,6 +3004,332 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
>  	return rc;
>  }
>  
> +/*
> + * Must be holding the lock
> + */
> +static void
> +save_old_callbacks(struct TCP_Server_Info *server, struct sock *sk)
> +{
> +	server->initial_cifs_state_change = sk->sk_state_change;
> +	server->initial_cifs_data_ready   = sk->sk_data_ready;
> +	server->initial_cifs_write_space  = sk->sk_write_space;
> +	server->initial_cifs_error_report = sk->sk_error_report;
> +}
> +
> +static void
> +restore_old_callbacks(struct TCP_Server_Info *server, struct sock *sk)
> +{
> +	sk->sk_state_change = server->initial_cifs_state_change;
> +	sk->sk_data_ready   = server->initial_cifs_data_ready;
> +	sk->sk_write_space  = server->initial_cifs_write_space;
> +	sk->sk_error_report = server->initial_cifs_error_report;
> +}
> +
> +/*
> + * Handle the arrival of data ... we defer it all to the workqueue
> + */
> +static void
> +cifs_data_ready(struct sock *sk, int bytes)
> +{
> +	struct TCP_Server_Info *server;
> +
> +	read_lock(&sk->sk_callback_lock);
> +	
> +	server = sk->sk_user_data;
> +	if (!server || !queue_work(cifsiod_wq, &server->sock_read_work)) {
> +		printk(KERN_INFO "%s: Unable to queue incoming data work on socket\n", __func__);
> +		printk(KERN_INFO "server: %p\n", server);
> +	}
> +
> +	read_unlock(&sk->sk_callback_lock);

You probably need to think about the object lifetime here. What
guarantees that the "server" struct still exists when the work actually
gets around to running?

> +}
> +
> +/*
> + * Handle the state change calls. Drive the state machine and handle disconnect
> + */
> +static void
> +cifs_state_change(struct sock *sk)
> +{
> +	struct TCP_Server_Info *server;
> +
> +	read_lock(&sk->sk_callback_lock);
> +
> +	server = sk->sk_user_data;
> +	if (!server) {
> +		printk(KERN_INFO "%s: sk_user_data bad (%p)!", __func__, server);
> +		goto out;
> +	}
> +
> +	printk(KERN_INFO "%s: Processing socket states for %p", __func__, server);
> +
> +	switch (sk->sk_state) {
> +	case TCP_ESTABLISHED:  /* We are connected */
> +		server->tcp_offset = 0;
> +		server->smb_reclen = 0;
> +		server->sock_read_state = CIFS_READING_PDU_HEADER;
> +
> +		break;
> +	case TCP_FIN_WAIT1:
> +		/* Client shutdown ... reconnect? How many times */
> +		printk(KERN_INFO "%s: We sent shutdown, cleaning up\n",
> +			__func__);
> +		break;
> +	case TCP_CLOSE_WAIT:
> +		/* Server shutdown ... clean up? */
> +		printk(KERN_INFO "%s: Server shutdown, reconnecting\n",
> +			__func__);
> +		break;
> +	case TCP_SYN_SENT:
> +
> +		break;
> +	case TCP_CLOSING:
> +
> +		break;
> +
> +	case TCP_LAST_ACK:
> +
> +		break;
> +
> +	case TCP_CLOSE:
> +
> +		break;
> +	}
> +out:
> +	read_unlock(&sk->sk_callback_lock);	
> +}
> +
> +/*
> + * The socket READ worker work main function. 
> + *
> + * We will get called when there is data on the socket. We expect that there
> + * will be a full PATH_MTU segment worth of data although there might not be
> + * if the server is nasty. We must keep state about where we are up to because
> + * we might have to leave off after reading all the data off the socket without
> + * having processed a complete SMB. This is because we are executing in the
> + * context of a work queue and we cannot block because other work queue items
> + * need to be processed.
> + *
> + * States are: CIFS_READING_PDU_HEADER,  we are reading the 4-byte-header
> + * 	       CIFS_READING_SMB_HEADER,  we are reading the SMB1/2 header 
> + * 	       CIFS_READING_SMB_BODY,    we are reading the SMB body
> + * 	       CIFS_READING_JUNK,        we are reading junk to be ditched.
> + */
> +static void
> +cifs_read_worker_main(struct TCP_Server_Info *server)
> +{
> +	struct msghdr msg;
> +	struct kvec iov;
> +	int result;
> +
> +	if (!work_allocate_buffers(server)) {
> +		printk(KERN_INFO "%s: Delaying because of buffer issues\n",
> +			__func__);
> +
> +		/*
> +		 * Is there an issue here that it could be queued twice?
> +		 */
> +		queue_delayed_work(cifsiod_wq, 
> +				&server->sock_read_delayed_work,
> +				READ_NO_MEMORY_DELAY);
> +		return;  /* Nothing more to do here ... */
> +	}
> +
> +	/*
> +	 * We have memory and data on the socket, deal with it. This might
> +	 * require multiple calls to kernel_recvmsg ... there should be data
> +	 * there, though.
> +	 */
> +	while (1) {
> +		switch (server->sock_read_state) {
> +		case CIFS_READING_PDU_HEADER:
> +			iov.iov_base = server->smallbuf + server->tcp_offset;
> +			iov.iov_len = 4 - server->tcp_offset;
> +			msg.msg_name = NULL;
> +			msg.msg_namelen = 0;
> +			msg.msg_control = NULL;
> +			msg.msg_controllen = 0;
> +			msg.msg_flags = MSG_DONTWAIT;
> +
> +			result = kernel_recvmsg(server->ssocket, 
> +						&msg, 
> +						&iov, 
> +						1, 
> +						iov.iov_len,
> +						msg.msg_flags);
> +
> +			/*
> +			 * Deal with errors ...
> +			 */
> +			if (result < 0) {
> +				if (result == -EAGAIN) {
> +					printk(KERN_INFO "%s: We got EAGAIN ...\n",
> +						__func__);
> +					return;
> +				}
> +				/*
> +			 	* Other errors probably require reconnect.
> +			 	* Should we handle the response?
> +			 	*/
> +				kernel_sock_shutdown(server->ssocket,
> +						SHUT_WR);
> +				queue_delayed_work(cifsiod_wq,
> +						&server->reconnect_work,
> +						(1 * HZ));
> +				return;
> +			}
> +
> +			server->tcp_offset += result;
> +
> +			/*
> +			 * Do we have the PDU header? If so, check it out and
> +			 * update our state etc. FIXME: Extract this into
> +			 * its own function.
> +			 */
> +			if (server->tcp_offset == 4) {
> +				server->smb_reclen = 
> +					get_rfc1002_length(server->smallbuf);
> +
> +				switch((unsigned char)server->smallbuf[0]) {
> +				case RFC1002_SESSION_MESSAGE:
> +					server->sock_read_state = 
> +						CIFS_READING_SMB_HEADER;
> +					break;
> +				case RFC1002_SESSION_KEEP_ALIVE:
> +					printk(KERN_INFO 
> +						"%s: Rcvd session keep alive\n",
> +						__func__);
> +					/* We simply stay in this state */
> +					server->tcp_offset = 0;
> +					break;
> +				case RFC1002_POSITIVE_SESSION_RESPONSE:
> +					printk(KERN_INFO
> +						"%s: Rcvd positive response\n",
> +						__func__);
> +					/* We simply stay in this state */
> +					server->tcp_offset = 0;
> +					break;
> +				case RFC1002_NEGATIVE_SESSION_RESPONSE:
> +					printk(KERN_INFO
> +						"%s: Rcvd negative response\n",
> +						__func__);
> +					kernel_sock_shutdown(server->ssocket,
> +							SHUT_WR);
> +					/* Reconnect in one second */
> +					queue_delayed_work(cifsiod_wq,
> +							&server->reconnect_work,
> +							(1 * HZ));
> +					return;
> +				default:
> +					printk(KERN_INFO 
> +						"%s: Unknown RFC1002 response"
> +						" type 0x%x\n",
> +						__func__,
> +						server->smallbuf[0]);
> +					kernel_sock_shutdown(server->ssocket,
> +							SHUT_WR);
> +					queue_delayed_work(cifsiod_wq,
> +							&server->reconnect_work,
> +							(1 * HZ));
> +					return;
> +				}
> +
> +			}
> +
> +			break;
> +
> +		case CIFS_READING_SMB_HEADER:
> +			/* Process the header. Figure out how long it is */
> +			/* We take up to and including the mid for SMB1 
> +			 * and the whole header for SMB2 ... */
> +
> +			/* We know how long this SMB is, is it long enough? */
> +			if (server->smb_reclen < HEADER_SIZE(server)) {
> +				kernel_sock_shutdown(server->ssocket, SHUT_WR);
> +				queue_delayed_work(cifsiod_wq,
> +						&server->reconnect_work,
> +						(1 *HZ));
> +				return;  /* Nothing more to do ... */
> +			}
> +
> +			iov.iov_base = server->smallbuf + server->tcp_offset;
> +			/*
> +			 * tcp_offset includes the PDU header. We could add it
> +			 * to the length or subtract it from tcp_offset.
> +			 */
> +			iov.iov_len = (HEADER_SIZE(server) + 4) - 
> +					server->tcp_offset;
> +			msg.msg_name = NULL;
> +			msg.msg_namelen = 0;
> +			msg.msg_control = NULL;
> +			msg.msg_controllen = 0;
> +			msg.msg_flags = MSG_DONTWAIT;
> +
> +			result = kernel_recvmsg(server->ssocket, 
> +						&msg, 
> +						&iov, 
> +						1, 
> +						iov.iov_len,
> +						msg.msg_flags);
> +			if (result < 0) {
> +
> +
> +			}
> +
> +			server->tcp_offset += result;
> +
> +			/*
> +			 * Have we got the header? If so, figure out what to
> +			 * do next
> +			 */
> +			if (server->tcp_offset == (HEADER_SIZE(server) + 4)) {
> +
> +			}
> +
> +			break;
> +
> +		case CIFS_READING_SMB_BODY:
> +
> +			break;
> +
> +		case CIFS_READING_JUNK:
> +
> +			break;
> +
> +		default:
> +
> +			break;
> +		}
> +	}
> +}
> +

Big function, might be nice to break that up a bit.

> +/*
> + * Call cifs_read_worker_main ... 
> + */
> +static void
> +cifs_read_worker(struct work_struct *work)
> +{
> +	struct TCP_Server_Info *server =
> +		container_of(work, struct TCP_Server_Info, sock_read_work);
> +
> +	cifs_read_worker_main(server);
> +}
> +
> +/*
> + * The reconnect worker function.
> + */
> +static void
> +cifs_reconnect_worker(struct work_struct *work)
> +{
> +	struct TCP_Server_Info *server =
> +		container_of(work, struct TCP_Server_Info, reconnect_work.work);
> +
> +	/*
> +	 * Initiate reconnect processing ... do we need to shutdown the
> +	 * existing socket and the reconnect?
> +	 */
> +
> +}
> +
>  static int
>  generic_ip_connect(struct TCP_Server_Info *server)
>  {
> @@ -2967,6 +3338,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
>  	int slen, sfamily;
>  	struct socket *socket = server->ssocket;
>  	struct sockaddr *saddr;
> +	struct sock *sk;
>  
>  	saddr = (struct sockaddr *) &server->dstaddr;
>  
> @@ -3031,6 +3403,32 @@ generic_ip_connect(struct TCP_Server_Info *server)
>  		 socket->sk->sk_sndbuf,
>  		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
>  
> +	if (!server->use_demux_thread) {
> +		/*
> +		 * Save the old socket callbacks and establish our own.
> +		 */
> +		sk = socket->sk;
> +		write_lock_bh(&sk->sk_callback_lock);
> +		save_old_callbacks(server, sk);
> +		sk->sk_user_data = server;
> +
> +		/* We only change two callbacks for the moment */
> +		sk->sk_data_ready = cifs_data_ready;
> +		sk->sk_state_change = cifs_state_change;
> +
> +		write_unlock_bh(&sk->sk_callback_lock);
> +
> +		INIT_WORK(&server->sock_read_work, cifs_read_worker);

What happens if you reinit the work while it's already queued on the
workqueue? It seems like that could happen here, no?

> +		/*
> +		 * Can this be deferrable as well? Anyway, this is used when 
> +		 * we cannot get memory, and it calls cifs_read_worker as well.
> +		 */ 
> +		INIT_DELAYED_WORK(&server->sock_read_delayed_work, 
> +				cifs_read_worker);
> +		INIT_DELAYED_WORK(&server->reconnect_work, 
> +				cifs_reconnect_worker);
> +	}
> +
>  	rc = socket->ops->connect(socket, saddr, slen, 0);
>  	if (rc < 0) {
>  		cFYI(1, "Error %d connecting to server", rc);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
