From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #3)
Date: Mon, 13 Dec 2010 14:02:30 -0500
Message-ID: <20101213140230.7591e331@tlielax.poochiereds.net>
References: <1292256516-4343-1-git-send-email-piastryyy@gmail.com>
	<1292256516-4343-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292256516-4343-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 13 Dec 2010 19:08:36 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> If we have a share mounted by non-standard port and try to mount another share
> on the same host with standard port, we connect to the first share again -
> that's wrong. This patch fixes this bug.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c |   41 ++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b90c741..b9b0ad5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1453,6 +1453,39 @@ srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
>  	}
>  }
>  
> +/*
> + * If no port is specified in addr structure, we try to match with 445 port
> + * and if it fails - with 139 ports
> + */
> +static bool
> +match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
> +{
> +	unsigned short int port, *sport;
> +
> +	switch (addr->sa_family) {
> +	case AF_INET:
> +		sport = &((struct sockaddr_in *) &server->dstaddr)->sin_port;
> +		port = ((struct sockaddr_in *) addr)->sin_port;
> +		break;
> +	case AF_INET6:
> +		sport = &((struct sockaddr_in6 *) &server->dstaddr)->sin6_port;
> +		port = ((struct sockaddr_in6 *) addr)->sin6_port;
> +		break;
> +	default:
> +		WARN_ON(1);
> +		return false;
> +	}
> +

This code assumes that the address families will be the same. That'll
be the case in the current code but it's always good to spell things
like that out.

You should either have this code check for different address families,
or add a comment that states that it should never be called when the
address families differ.

> +	if (!port) {
> +		port = htons(CIFS_PORT);
> +		if (port == *sport)
> +			return true;
> +
> +		port = htons(RFC1001_PORT);
> +	}
> +
> +	return port == *sport;
> +}
>  
>  static bool
>  match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
> @@ -1466,8 +1499,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
>  
>  		if (addr4->sin_addr.s_addr != srv_addr4->sin_addr.s_addr)
>  			return false;
> -		if (addr4->sin_port && addr4->sin_port != srv_addr4->sin_port)
> -			return false;
>  		break;
>  	}
>  	case AF_INET6: {
> @@ -1480,9 +1511,6 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
>  			return false;
>  		if (addr6->sin6_scope_id != srv_addr6->sin6_scope_id)
>  			return false;
> -		if (addr6->sin6_port &&
> -		    addr6->sin6_port != srv_addr6->sin6_port)
> -			return false;
>  		break;
>  	}
>  	default:
> @@ -1555,6 +1583,9 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
>  				   (struct sockaddr *)&vol->srcaddr))
>  			continue;
>  
> +		if (!match_port(server, addr))
> +			continue;
> +
>  		if (!match_security(server, vol))
>  			continue;
>  

Other than the above comment about adding a comment this looks good.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
