From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/11] CIFS: Make wait_for_free_request killable
Date: Sat, 17 Mar 2012 07:13:40 -0400
Message-ID: <20120317071340.58f8e31c@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-5-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331910574-998-5-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 16 Mar 2012 18:09:27 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> to let us kill the proccess if it hangs waiting for a credit when
> the session is down and echo is disabled.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/transport.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e8a4fd3..11787cc 100644
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
> -			wait_event(server->request_q, has_credits(server));
> +			rc = wait_event_killable(server->request_q,
> +						 has_credits(server));
>  			cifs_num_waiters_dec(server);
> +			if (rc)
> +				return rc;
>  			spin_lock(&server->req_lock);
>  		} else {
>  			if (server->tcpStatus == CifsExiting) {

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
