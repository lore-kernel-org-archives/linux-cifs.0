From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Initialise mid_q_entry before putting it on the pending
 queue
Date: Tue, 10 Jul 2012 15:11:31 -0400
Message-ID: <20120710151131.1e0a6f91@tlielax.poochiereds.net>
References: <1341946720-4980-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341946720-4980-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 10 Jul 2012 19:58:40 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> A user reported a crash in cifs_demultiplex_thread() caused by an
> incorrectly set mid_q_entry->callback() function. It appears that the
> callback assignment made in cifs_call_async() was not flushed back to
> memory suggesting that a memory barrier was required here. Changing the
> code to make sure that the mid_q_entry structure was completely
> initialised before it was added to the pending queue fixes the problem.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 3097ee5..c5faf02 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -365,14 +365,10 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
>  	if (mid == NULL)
>  		return -ENOMEM;
>  
> -	/* put it on the pending_mid_q */
> -	spin_lock(&GlobalMid_Lock);
> -	list_add_tail(&mid->qhead, &server->pending_mid_q);
> -	spin_unlock(&GlobalMid_Lock);
> -
>  	rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
>  	if (rc)
> -		delete_mid(mid);
> +		DeleteMidQEntry(mid);
> +
>  	*ret_mid = mid;
>  	return rc;
>  }
> @@ -407,17 +403,21 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
>  	mid->callback_data = cbdata;
>  	mid->mid_state = MID_REQUEST_SUBMITTED;
>  
> +	/* put it on the pending_mid_q */
> +	spin_lock(&GlobalMid_Lock);
> +	list_add_tail(&mid->qhead, &server->pending_mid_q);
> +	spin_unlock(&GlobalMid_Lock);
> +
> +
>  	cifs_in_send_inc(server);
>  	rc = smb_sendv(server, iov, nvec);
>  	cifs_in_send_dec(server);
>  	cifs_save_when_sent(mid);
>  	mutex_unlock(&server->srv_mutex);
>  
> -	if (rc)
> -		goto out_err;
> +	if (rc == 0)
> +		return 0;
>  
> -	return rc;
> -out_err:
>  	delete_mid(mid);
>  	add_credits(server, 1);
>  	wake_up(&server->request_q);

Looks correct.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
