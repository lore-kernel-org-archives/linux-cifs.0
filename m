From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 15/18] cifs: reconnect unresponsive servers
Date: Thu, 23 Dec 2010 16:01:08 +0530
Message-ID: <4D1324EC.8010305@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-16-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-16-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> If the server isn't responding to echoes, we don't want to leave tasks
> hung waiting for it to reply. At that point, we'll want to reconnect
> so that soft mounts can return an error to userspace quickly.
> 
> If the client hasn't received a reply after 3 echo intervals, assume
> that the transport is down and attempt to reconnect the socket.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 20f6eda..2ad3c67 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -55,6 +55,9 @@
>  /* SMB echo "timeout" -- FIXME: tunable? */
>  #define SMB_ECHO_INTERVAL (60 * HZ)
>  
> +/* reconnect if no response from server in this time period */
> +#define UNRESPONSIVE_SERVER_TIMEOUT (5 * SMB_ECHO_INTERVAL)
> +

It's not clear to me why is this timeout is set to be
5 * SMB_ECHO_INTERVAL?

>  extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
>  			 unsigned char *p24);
>  
> @@ -186,6 +189,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  	kfree(server->session_key.response);
>  	server->session_key.response = NULL;
>  	server->session_key.len = 0;
> +	server->lstrp = jiffies;
>  	mutex_unlock(&server->srv_mutex);
>  
>  	/*
> @@ -423,7 +427,19 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
>  		smb_msg.msg_control = NULL;
>  		smb_msg.msg_controllen = 0;
>  		pdu_length = 4; /* enough to get RFC1001 header */
> +
>  incomplete_rcv:
> +		if (time_after(jiffies,
> +			       server->lstrp + UNRESPONSIVE_SERVER_TIMEOUT)) {
> +			cERROR(1, "Server %s has not responded in %d seconds. "
> +				  "Reconnecting...", server->hostname,
> +				  UNRESPONSIVE_SERVER_TIMEOUT / HZ);
> +			cifs_reconnect(server);
> +			csocket = server->ssocket;
> +			wake_up(&server->response_q);
> +			continue;
> +		}
> +
>  		length =
>  		    kernel_recvmsg(csocket, &smb_msg,
>  				&iov, 1, pdu_length, 0 /* BB other flags? */);
> @@ -584,6 +600,8 @@ incomplete_rcv:
>  		}
>  
>  		mid_entry = NULL;
> +		server->lstrp = jiffies;
> +
>  		spin_lock(&GlobalMid_Lock);
>  		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>  			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> @@ -632,10 +650,6 @@ multi_t2_fnd:
>  #ifdef CONFIG_CIFS_STATS2
>  				mid_entry->when_received = jiffies;
>  #endif
> -				/* so we do not time out requests to  server
> -				which is still responding (since server could
> -				be busy but not dead) */
> -				server->lstrp = jiffies;
>  				break;
>  			}
>  			mid_entry = NULL;
> @@ -1685,6 +1699,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		volume_info->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
>  	tcp_ses->session_estab = false;
>  	tcp_ses->sequence_number = 0;
> +	tcp_ses->lstrp = jiffies;
>  	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
>  	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
>  	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);


-- 
Suresh Jayaraman
