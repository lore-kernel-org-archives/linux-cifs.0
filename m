From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/50] CIFS: Add SMB2 credits support
Date: Fri, 3 Feb 2012 13:42:12 -0500
Message-ID: <20120203134212.53f1e950@tlielax.poochiereds.net>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-6-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-6-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jan 2012 12:34:27 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> Convert wait_for_free_request to wait on available credits
> for SMB2 servers and decrement a credit number for every call.
> Increment the credit number in smb2_sendrcv2 with every response
> got from the server.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h      |    1 +
>  fs/cifs/cifsproto.h     |    2 +-
>  fs/cifs/smb2transport.c |    6 ++++++
>  fs/cifs/transport.c     |   20 ++++++++++++++++++--
>  4 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index bb2af48..e5f0b86 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -318,6 +318,7 @@ struct TCP_Server_Info {
>  	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
>  #endif
>  #ifdef CONFIG_CIFS_SMB2
> +	atomic_t credits; /* send no more simultaneous requests than this */
>  	__u64 current_smb2_mid;         /* multiplex id - rotating counter */
>  #endif
>  };
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index d1e30d9..b6c784b 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -1,7 +1,7 @@
>  /*
>   *   fs/cifs/cifsproto.h
>   *
> - *   Copyright (c) International Business Machines  Corp., 2002,2008
> + *   Copyright (c) International Business Machines  Corp., 2002,2011
>   *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>   *
>   *   This library is free software; you can redistribute it and/or modify
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index d7f1c05..b5702f3 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -148,6 +148,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
>  	unsigned int receive_len;
>  	struct mid_q_entry *midQ;
>  	struct smb2_hdr *buf = iov[0].iov_base;
> +	unsigned int credits = 1;
>  
>  	if (status)
>  		*status = STATUS_SUCCESS;
> @@ -186,6 +187,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
>  	if (rc) {
>  		mutex_unlock(&ses->server->srv_mutex);
>  		cifs_small_buf_release(buf);
> +		atomic_inc(&ses->server->credits);
>  		wake_up(&ses->server->request_q);
>  		return rc;
>  	}
> @@ -222,6 +224,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
>  			midQ->callback = cifs_delete_mid;
>  			spin_unlock(&GlobalMid_Lock);
>  			cifs_small_buf_release(buf);
> +			atomic_inc(&ses->server->credits);
>  			wake_up(&ses->server->request_q);
>  			return rc;
>  		}
> @@ -232,6 +235,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
>  
>  	rc = cifs_sync_mid_result(midQ, ses->server);
>  	if (rc) {
> +		atomic_inc(&ses->server->credits);
>  		wake_up(&ses->server->request_q);
>  		return rc;
>  	}
> @@ -271,7 +275,9 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
>  		/* mark it so buf will not be freed by free_smb2mid */
>  		midQ->resp_buf = NULL;
>  
> +	credits = le16_to_cpu(buf->CreditRequest);
>  out:
> +	atomic_add(credits, &ses->server->credits);
>  	cifs_delete_mid(midQ);
>  	wake_up(&ses->server->request_q);
>  	return rc;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index f7ac3f0..4414df8 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -287,7 +287,8 @@ cifs_wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
>  
>  	spin_lock(&GlobalMid_Lock);
>  	while (1) {
> -		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
> +		if ((server->is_smb2 == false) &&
> +		    atomic_read(&server->inFlight) >= cifs_max_pending) {
>  			spin_unlock(&GlobalMid_Lock);
>  			cifs_num_waiters_inc(server);
>  			wait_event(server->request_q,
> @@ -295,6 +296,16 @@ cifs_wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
>  				     < cifs_max_pending);
>  			cifs_num_waiters_dec(server);
>  			spin_lock(&GlobalMid_Lock);
> +#ifdef CONFIG_CIFS_SMB2
> +		} else if (server->is_smb2 &&
> +			  (atomic_read(&server->credits) < 1)) {
> +			spin_unlock(&GlobalMid_Lock);
> +			cifs_num_waiters_inc(server);
> +			wait_event(server->request_q,
> +				   atomic_read(&server->credits) > 0);
> +			cifs_num_waiters_dec(server);
> +			spin_lock(&GlobalMid_Lock);
> +#endif /* CONFIG_CIFS_SMB2 */
>  		} else {
>  			if (server->tcpStatus == CifsExiting) {
>  				spin_unlock(&GlobalMid_Lock);
> @@ -305,8 +316,13 @@ cifs_wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
>  			   as they are allowed to block on server */
>  
>  			/* update # of requests on the wire to server */
> -			if (long_op != CIFS_BLOCKING_OP)
> +			if (server->is_smb2 == false &&
> +			    long_op != CIFS_BLOCKING_OP)
>  				atomic_inc(&server->inFlight);
> +#ifdef CONFIG_CIFS_SMB2
> +			else if (server->is_smb2)
> +				atomic_dec(&server->credits);
> +#endif
>  			spin_unlock(&GlobalMid_Lock);
>  			break;
>  		}

I'd like to suggest an alternate approach here...

Instead of considering this as a SMB1 vs. SMB2 either/or thing we
should consider the SMB1 case to be a special case of SMB2 credits. In
the SMB1 NEGOTIATE response, the server sends us a MaxMpx value. We
could consider that to be an initial set of credits. Every time we get
a SMB1 response from the server, we'll increment the credit value.

If we do that, then there's a lot less protocol dependent code that's
needed, and if done correctly should also fix the current bug in
the SMB1 code where it ignores the MaxMpx value.

Thoughts?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
