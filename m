From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 05/11] CIFS: Make wait_for_free_request interruptible
Date: Wed, 22 Feb 2012 14:15:34 -0500
Message-ID: <20120222141534.5512c3bf@samba.org>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-6-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-6-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Feb 2012 10:32:58 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> to let us interrupt the proccess if the session went down and echo
> is disabled.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/transport.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index fa93720..938d20b 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -257,6 +257,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
>  static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
>  {
> +	int rc;
> +
>  	spin_lock(&server->req_lock);
>  
>  	if (long_op == CIFS_ASYNC_OP) {
> @@ -271,8 +273,11 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
>  		if (server->credits <= 0) {
>  			spin_unlock(&server->req_lock);
>  			cifs_num_waiters_inc(server);
> -			wait_event(server->request_q, get_credits(server) > 0);
> +			rc = wait_event_interruptible(server->request_q,
> +						      get_credits(server) > 0);
>  			cifs_num_waiters_dec(server);
> +			if (rc)
> +				return rc;
>  			spin_lock(&server->req_lock);
>  		} else {
>  			if (server->tcpStatus == CifsExiting) {

In general, I think making this interruptible is a good idea. The
problem here though is that you're going to end up interrupting this on
any signal. That includes stuff like SIGCHLD -- you don't necessarily
want to interrupt this because the process forked off a child earlier
and then that child exited...

It's probably simpler to just make this a TASK_KILLABLE sleep for that
reason, rather than trying to handle different signals differently.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
