From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/14] cifs: allow for different handling of received
 response
Date: Sun, 28 Nov 2010 06:58:21 -0500
Message-ID: <20101128065821.73b360f0@tlielax.poochiereds.net>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
	<1290862886-2914-6-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-6-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 27 Nov 2010 08:01:17 -0500
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:

> In order to incorporate async requests, we need to allow for a more
> general way to do things on receive, rather than just waking up a
> process.
> 
> Turn the task pointer in the mid_q_entry into a callback function and a
> generic data pointer. When a response comes in, or the socket is
> reconnected, cifsd can call the callback function in order to wake up
> the process.
> 
> The default is to just wake up the current process which should mean no
> change in behavior for existing code.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |    8 ++++----
>  fs/cifs/cifsglob.h   |    7 ++++++-
>  fs/cifs/connect.c    |   25 ++++++++++++++-----------
>  fs/cifs/transport.c  |   14 +++++++++++++-
>  4 files changed, 37 insertions(+), 17 deletions(-)
> 

[...]

> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7758120..770b3c4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -212,10 +212,15 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  			if (server->tcpStatus != CifsExiting)
>  				server->tcpStatus = CifsGood;
>  			spin_unlock(&GlobalMid_Lock);
> -	/*		atomic_set(&server->inFlight,0);*/
> -			wake_up(&server->response_q);
>  		}
>  	}
> +
> +	/* now, issue callback for all mids in flight */
> +	spin_lock(&GlobalMid_Lock);
> +	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead)
> +		mid_entry->callback(mid_entry);
> +	spin_unlock(&GlobalMid_Lock);
> +
	^^^^^^^^^^^^
It occurs to me that the above can deadlock. It ought not call the
callback function under the GlobalMid_Lock. I'll plan to respin this
set with a fix for that (probably by moving all of the mids to a
separate retry list and having the callback function move them back to
the pending_mid_q).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
