From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify ipv*_connect functions into one
Date: Mon, 15 Nov 2010 07:18:24 -0500
Message-ID: <20101115071824.15eac25d@tlielax.poochiereds.net>
References: <1289734155-3613-1-git-send-email-piastryyy@gmail.com>
	<1289760378-8715-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289760378-8715-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 14 Nov 2010 21:46:18 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Make connect logic more ip-protocol independent. Also move RFC1001 stuff into
> separate function.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Nice cleanup so far. Some comments below:

> ---
>  fs/cifs/connect.c |  311 ++++++++++++++++++-----------------------------------
>  1 files changed, 103 insertions(+), 208 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 251a17c..01ebcc4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -114,8 +114,7 @@ struct smb_vol {
>  #define TLINK_ERROR_EXPIRE	(1 * HZ)
>  #define TLINK_IDLE_EXPIRE	(600 * HZ)
>  
> -static int ipv4_connect(struct TCP_Server_Info *server);
> -static int ipv6_connect(struct TCP_Server_Info *server);
> +static int ip_connect(struct TCP_Server_Info *server);
>  static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
>  static void cifs_prune_tlinks(struct work_struct *work);
>  
> @@ -199,10 +198,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  	while ((server->tcpStatus != CifsExiting) &&
>  	       (server->tcpStatus != CifsGood)) {
>  		try_to_freeze();
> -		if (server->addr.sockAddr6.sin6_family == AF_INET6)
> -			rc = ipv6_connect(server);
> -		else
> -			rc = ipv4_connect(server);
> +		rc = ip_connect(server);
>  		if (rc) {
>  			cFYI(1, "reconnect error %d", rc);
>  			msleep(3000);
> @@ -1668,12 +1664,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		/* other OS never observed in Wild doing 139 with v6 */
>  		memcpy(&tcp_ses->addr.sockAddr6, sin_server6,
>  			sizeof(struct sockaddr_in6));
> -		rc = ipv6_connect(tcp_ses);
> -	} else {
> +	} else
>  		memcpy(&tcp_ses->addr.sockAddr, sin_server,
>  			sizeof(struct sockaddr_in));
> -		rc = ipv4_connect(tcp_ses);
> -	}
> +
> +	rc = ip_connect(tcp_ses);
>  	if (rc < 0) {
>  		cERROR(1, "Error connecting to socket. Aborting operation");
>  		goto out_err_crypto_release;
> @@ -2121,19 +2116,97 @@ bind_socket(struct TCP_Server_Info *server)
>  }
>  
>  static int
> -ipv4_connect(struct TCP_Server_Info *server)
> +ip_rfc1001_connect(struct TCP_Server_Info *server)
> +{
> +	int rc = 0;
> +	/* some servers require RFC1001 sessinit before sending
> +	negprot - BB check reconnection in case where second
> +	sessinit is sent but no second negprot */
> +	struct rfc1002_session_packet *ses_init_buf;
> +	struct smb_hdr *smb_buf;
> +	ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
> +			       GFP_KERNEL);
> +	if (ses_init_buf) {
> +		ses_init_buf->trailer.session_req.called_len = 32;
> +
> +		if (server->server_RFC1001_name &&
> +		    server->server_RFC1001_name[0] != 0)
> +			rfc1002mangle(ses_init_buf->trailer.
> +				      session_req.called_name,
> +				      server->server_RFC1001_name,
> +				      RFC1001_NAME_LEN_WITH_NULL);
> +		else
> +			rfc1002mangle(ses_init_buf->trailer.
> +				      session_req.called_name,
> +				      DEFAULT_CIFS_CALLED_NAME,
> +				      RFC1001_NAME_LEN_WITH_NULL);
> +
> +		ses_init_buf->trailer.session_req.calling_len = 32;
> +
> +		/* calling name ends in null (byte 16) from old smb
> +		convention. */
> +		if (server->workstation_RFC1001_name &&
> +		    server->workstation_RFC1001_name[0] != 0)
> +			rfc1002mangle(ses_init_buf->trailer.
> +				      session_req.calling_name,
> +				      server->workstation_RFC1001_name,
> +				      RFC1001_NAME_LEN_WITH_NULL);
> +		else
> +			rfc1002mangle(ses_init_buf->trailer.
> +				      session_req.calling_name,
> +				      "LINUX_CIFS_CLNT",
> +				      RFC1001_NAME_LEN_WITH_NULL);
> +
> +		ses_init_buf->trailer.session_req.scope1 = 0;
> +		ses_init_buf->trailer.session_req.scope2 = 0;
> +		smb_buf = (struct smb_hdr *)ses_init_buf;
> +
> +		/* sizeof RFC1002_SESSION_REQUEST with no scope */
> +		smb_buf->smb_buf_length = 0x81000044;
> +		rc = smb_send(server, smb_buf, 0x44);
> +		kfree(ses_init_buf);
> +		msleep(1); /* RFC1001 layer in at least one server
> +			      requires very short break before negprot
> +			      presumably because not expecting negprot
> +			      to follow so fast.  This is a simple
> +			      solution that works without
> +			      complicating the code and causes no
> +			      significant slowing down on mount
> +			      for everyone else */
> +	}
> +	/* else the negprot may still work without this
> +	even though malloc failed */
> +
> +	return rc;
> +}
> +
> +static int
> +ip_connect(struct TCP_Server_Info *server)
>  {
>  	int rc = 0;
> -	int val;
> -	bool connected = false;
> -	__be16 orig_port = 0;
> +	bool using_ipv6 = false;
> +	unsigned short int *sport;
> +	int slen;
>  	struct socket *socket = server->ssocket;
> +	struct sockaddr *saddr;
> +
> +	if (server->addr.sockAddr6.sin6_family == AF_INET6) {
> +		sport = &server->addr.sockAddr6.sin6_port;
> +		using_ipv6 = true;
> +		slen = sizeof(struct sockaddr_in6);
> +		saddr = (struct sockaddr *) &server->addr.sockAddr6;
> +	} else {
> +		sport = &server->addr.sockAddr.sin_port;
> +		slen = sizeof(struct sockaddr_in);
> +		saddr = (struct sockaddr *) &server->addr.sockAddr;
> +	}
>  
>  	if (socket == NULL) {
>  		rc = sock_create_kern(PF_INET, SOCK_STREAM,
>  				      IPPROTO_TCP, &socket);
>  		if (rc < 0) {
>  			cERROR(1, "Error %d creating socket", rc);
> +			server->ssocket = NULL;
>  			return rc;
>  		}
>  
> @@ -2141,59 +2214,32 @@ ipv4_connect(struct TCP_Server_Info *server)
>  		cFYI(1, "Socket created");
>  		server->ssocket = socket;
>  		socket->sk->sk_allocation = GFP_NOFS;
> -		cifs_reclassify_socket4(socket);
> +		if (using_ipv6)
> +			cifs_reclassify_socket4(socket);
> +		else
> +			cifs_reclassify_socket6(socket);
		^^^^^^^^
		Isn't that backwards?
>  	}
>  
>  	rc = bind_socket(server);
>  	if (rc < 0)
>  		return rc;
>  
> -	/* user overrode default port */
> -	if (server->addr.sockAddr.sin_port) {
> -		rc = socket->ops->connect(socket, (struct sockaddr *)
> -					  &server->addr.sockAddr,
> -					  sizeof(struct sockaddr_in), 0);
> -		if (rc >= 0)
> -			connected = true;
> -	}
> -
> -	if (!connected) {
> -		/* save original port so we can retry user specified port
> -			later if fall back ports fail this time  */
> -		orig_port = server->addr.sockAddr.sin_port;
> -
> -		/* do not retry on the same port we just failed on */
> -		if (server->addr.sockAddr.sin_port != htons(CIFS_PORT)) {
> -			server->addr.sockAddr.sin_port = htons(CIFS_PORT);
> -			rc = socket->ops->connect(socket,
> -						(struct sockaddr *)
> -						&server->addr.sockAddr,
> -						sizeof(struct sockaddr_in), 0);
> -			if (rc >= 0)
> -				connected = true;
> -		}
> +	if (*sport)
> +		/* user specify port manually */
> +		rc = socket->ops->connect(socket, saddr, slen, 0);
> +	else {
> +		/* try with 445 port at first */
> +		*sport = htons(CIFS_PORT);
> +		rc = socket->ops->connect(socket, saddr, slen, 0);
	^^^^^^^^^
	You could collapse that down to:

	if (*sport = 0)
		*sport = htons(CIFS_PORT);
	rc = socket->ops->connect(socket, saddr, slen, 0);

	Eliminating unnecessary conditional code makes for a smaller
	resulting binary and makes the code easier to read.

>  	}
> -	if (!connected) {
> -		server->addr.sockAddr.sin_port = htons(RFC1001_PORT);
> -		rc = socket->ops->connect(socket, (struct sockaddr *)
> -					      &server->addr.sockAddr,
> -					      sizeof(struct sockaddr_in), 0);
> -		if (rc >= 0)
> -			connected = true;
> -	}
> -
> -	/* give up here - unless we want to retry on different
> -		protocol families some day */
> -	if (!connected) {
> -		if (orig_port)
> -			server->addr.sockAddr.sin_port = orig_port;
> -		cFYI(1, "Error %d connecting to server via ipv4", rc);
> +
> +	if (rc < 0) {
> +		cFYI(1, "Error %d connecting to server", rc);
>  		sock_release(socket);
>  		server->ssocket = NULL;
>  		return rc;
>  	}
>  
> -
>  	/*
>  	 * Eventually check for other socket options to change from
>  	 *  the default. sock_setsockopt not used because it expects
> @@ -2211,7 +2257,7 @@ ipv4_connect(struct TCP_Server_Info *server)
>  	}
>  
>  	if (server->tcp_nodelay) {
> -		val = 1;
> +		int val = 1;
>  		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
>  				(char *)&val, sizeof(val));
>  		if (rc)
> @@ -2222,159 +2268,8 @@ ipv4_connect(struct TCP_Server_Info *server)
>  		 socket->sk->sk_sndbuf,
>  		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
>  
> -	/* send RFC1001 sessinit */
> -	if (server->addr.sockAddr.sin_port == htons(RFC1001_PORT)) {
> -		/* some servers require RFC1001 sessinit before sending
> -		negprot - BB check reconnection in case where second
> -		sessinit is sent but no second negprot */
> -		struct rfc1002_session_packet *ses_init_buf;
> -		struct smb_hdr *smb_buf;
> -		ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
> -				       GFP_KERNEL);
> -		if (ses_init_buf) {
> -			ses_init_buf->trailer.session_req.called_len = 32;
> -			if (server->server_RFC1001_name &&
> -			    server->server_RFC1001_name[0] != 0)
> -				rfc1002mangle(ses_init_buf->trailer.
> -						session_req.called_name,
> -					      server->server_RFC1001_name,
> -					      RFC1001_NAME_LEN_WITH_NULL);
> -			else
> -				rfc1002mangle(ses_init_buf->trailer.
> -						session_req.called_name,
> -					      DEFAULT_CIFS_CALLED_NAME,
> -					      RFC1001_NAME_LEN_WITH_NULL);
> -
> -			ses_init_buf->trailer.session_req.calling_len = 32;
> -
> -			/* calling name ends in null (byte 16) from old smb
> -			convention. */
> -			if (server->workstation_RFC1001_name &&
> -			    server->workstation_RFC1001_name[0] != 0)
> -				rfc1002mangle(ses_init_buf->trailer.
> -						session_req.calling_name,
> -					      server->workstation_RFC1001_name,
> -					      RFC1001_NAME_LEN_WITH_NULL);
> -			else
> -				rfc1002mangle(ses_init_buf->trailer.
> -						session_req.calling_name,
> -					      "LINUX_CIFS_CLNT",
> -					      RFC1001_NAME_LEN_WITH_NULL);
> -
> -			ses_init_buf->trailer.session_req.scope1 = 0;
> -			ses_init_buf->trailer.session_req.scope2 = 0;
> -			smb_buf = (struct smb_hdr *)ses_init_buf;
> -			/* sizeof RFC1002_SESSION_REQUEST with no scope */
> -			smb_buf->smb_buf_length = 0x81000044;
> -			rc = smb_send(server, smb_buf, 0x44);
> -			kfree(ses_init_buf);
> -			msleep(1); /* RFC1001 layer in at least one server
> -				      requires very short break before negprot
> -				      presumably because not expecting negprot
> -				      to follow so fast.  This is a simple
> -				      solution that works without
> -				      complicating the code and causes no
> -				      significant slowing down on mount
> -				      for everyone else */
> -		}
> -		/* else the negprot may still work without this
> -		even though malloc failed */
> -
> -	}
> -
> -	return rc;
> -}
> -
> -static int
> -ipv6_connect(struct TCP_Server_Info *server)
> -{
> -	int rc = 0;
> -	int val;
> -	bool connected = false;
> -	__be16 orig_port = 0;
> -	struct socket *socket = server->ssocket;
> -
> -	if (socket == NULL) {
> -		rc = sock_create_kern(PF_INET6, SOCK_STREAM,
> -				      IPPROTO_TCP, &socket);
> -		if (rc < 0) {
> -			cERROR(1, "Error %d creating ipv6 socket", rc);
> -			socket = NULL;
> -			return rc;
> -		}
> -
> -		/* BB other socket options to set KEEPALIVE, NODELAY? */
> -		cFYI(1, "ipv6 Socket created");
> -		server->ssocket = socket;
> -		socket->sk->sk_allocation = GFP_NOFS;
> -		cifs_reclassify_socket6(socket);
> -	}
> -
> -	rc = bind_socket(server);
> -	if (rc < 0)
> -		return rc;
> -
> -	/* user overrode default port */
> -	if (server->addr.sockAddr6.sin6_port) {
> -		rc = socket->ops->connect(socket,
> -				(struct sockaddr *) &server->addr.sockAddr6,
> -				sizeof(struct sockaddr_in6), 0);
> -		if (rc >= 0)
> -			connected = true;
> -	}
> -
> -	if (!connected) {
> -		/* save original port so we can retry user specified port
> -			later if fall back ports fail this time  */
> -
> -		orig_port = server->addr.sockAddr6.sin6_port;
> -		/* do not retry on the same port we just failed on */
> -		if (server->addr.sockAddr6.sin6_port != htons(CIFS_PORT)) {
> -			server->addr.sockAddr6.sin6_port = htons(CIFS_PORT);
> -			rc = socket->ops->connect(socket, (struct sockaddr *)
> -					&server->addr.sockAddr6,
> -					sizeof(struct sockaddr_in6), 0);
> -			if (rc >= 0)
> -				connected = true;
> -		}
> -	}
> -	if (!connected) {
> -		server->addr.sockAddr6.sin6_port = htons(RFC1001_PORT);
> -		rc = socket->ops->connect(socket, (struct sockaddr *)
> -				&server->addr.sockAddr6,
> -				sizeof(struct sockaddr_in6), 0);
> -		if (rc >= 0)
> -			connected = true;
> -	}
> -
> -	/* give up here - unless we want to retry on different
> -		protocol families some day */
> -	if (!connected) {
> -		if (orig_port)
> -			server->addr.sockAddr6.sin6_port = orig_port;
> -		cFYI(1, "Error %d connecting to server via ipv6", rc);
> -		sock_release(socket);
> -		server->ssocket = NULL;
> -		return rc;
> -	}
> -
> -	/*
> -	 * Eventually check for other socket options to change from
> -	 * the default. sock_setsockopt not used because it expects
> -	 * user space buffer
> -	 */
> -	socket->sk->sk_rcvtimeo = 7 * HZ;
> -	socket->sk->sk_sndtimeo = 5 * HZ;
> -
> -	if (server->tcp_nodelay) {
> -		val = 1;
> -		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
> -				(char *)&val, sizeof(val));
> -		if (rc)
> -			cFYI(1, "set TCP_NODELAY socket option error %d", rc);
> -	}
> -
> -	server->ssocket = socket;
> +	if (*sport == htons(RFC1001_PORT))
> +		rc = ip_rfc1001_connect(server);
>  
>  	return rc;
>  }

With these changes, where does the port get automatically set to
RFC1001_PORT if the CIFS_PORT connect fails? It looks like that part
got ripped out, but not replaced.

That said, it seems like it might be better to separate policy
from function here. The socket connect code really has no
business deciding what port to use. Might it be better to
instead have a generic function that takes a fully filled-out sockaddr,
and then have another function that calls it and decides what ports
to try?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
