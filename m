From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 09/18] cifs: clean up sync_mid_result
Date: Mon, 20 Dec 2010 16:57:41 +0530
Message-ID: <4D0F3DAD.7080801@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-10-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-10-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> Make it use a switch statement based on the value of the midStatus. If
> the resp_buf is set, then MID_RESPONSE_RECEIVED is too.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c |   35 ++++++++++++++++++-----------------
>  1 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index f65cdec..6abd144 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -363,28 +363,29 @@ sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
>  {
>  	int rc = 0;
>  
> -	spin_lock(&GlobalMid_Lock);
> +	cFYI(1, "%s: cmd=%d mid=%d state=%d", __func__, mid->command,
> +		mid->mid, mid->midState);
>  
> -	if (mid->resp_buf) {
> +	spin_lock(&GlobalMid_Lock);
> +	switch (mid->midState) {
> +	case MID_RESPONSE_RECEIVED:
>  		spin_unlock(&GlobalMid_Lock);
>  		return rc;
> -	}
> -
> -	cERROR(1, "No response to cmd %d mid %d", mid->command, mid->mid);
> -	if (mid->midState == MID_REQUEST_SUBMITTED) {
> -		if (server->tcpStatus == CifsExiting)
> +	case MID_REQUEST_SUBMITTED:
> +		/* socket is going down, reject all calls */
> +		if (server->tcpStatus == CifsExiting) {
> +			cERROR(1, "%s: canceling mid=%d cmd=0x%x state=%d",
> +			       __func__, mid->mid, mid->command, mid->midState);
>  			rc = -EHOSTDOWN;
> -		else
> -			mid->midState = MID_RETRY_NEEDED;
> -	}

When midState is MID_REQUEST_SUBMITTED and tcpStatus is not CifsExiting,
the old code used to set midState to MID_RETRY_NEEDED. This is not set
now - is this intentional?

> -	if (rc != -EHOSTDOWN) {
> -		if (mid->midState == MID_RETRY_NEEDED) {
> -			rc = -EAGAIN;
> -			cFYI(1, "marking request for retry");
> -		} else {
> -			rc = -EIO;
> +			break;
>  		}
> +	case MID_RETRY_NEEDED:
> +		rc = -EAGAIN;
> +		break;
> +	default:
> +		cERROR(1, "%s: invalid mid state mid=%d state=%d", __func__,
> +			mid->mid, mid->midState);
> +		rc = -EIO;
>  	}
>  	spin_unlock(&GlobalMid_Lock);
>  


-- 
Suresh Jayaraman
