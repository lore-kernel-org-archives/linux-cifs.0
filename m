From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs: add server-provided principal name in upcall
Date: Tue, 6 Sep 2011 12:16:31 -0400
Message-ID: <20110906121631.587b9551@tlielax.poochiereds.net>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315322512-10652-1-git-send-email-martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  6 Sep 2011 17:21:52 +0200
Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org> wrote:

> The current cifs implementation discards a principal name found
> in the CIFS server's SecBlob. This patch adds the principal name
> into the data used for the request_key call. Combined with a separate
> cifs-utils patch, this enables cifs mounts using kerberos on servers
> that use different principal names than the default cifs/<hostname>
> or host/<hostname> which are tried by cifs.upcall.
> 
> Signed-off-by: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
> ---
>  fs/cifs/asn1.c        |   28 ++++++++++++++++++++++++----
>  fs/cifs/cifs_spnego.c |   10 ++++++++++
>  fs/cifs/cifs_spnego.h |    2 +-
>  fs/cifs/cifsglob.h    |    1 +
>  fs/cifs/connect.c     |    3 +++
>  5 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
> index cfd1ce3..5ab23f2 100644
> --- a/fs/cifs/asn1.c
> +++ b/fs/cifs/asn1.c
> @@ -369,7 +369,7 @@ static unsigned char asn1_ulong_decode(struct asn1_ctx *ctx,
>  		*integer |= ch;
>  	}
>  	return 1;
> -}
> +} */
>  
>  static unsigned char
>  asn1_octets_decode(struct asn1_ctx *ctx,
> @@ -395,7 +395,7 @@ asn1_octets_decode(struct asn1_ctx *ctx,
>  		(*len)++;
>  	}
>  	return 1;
> -} */
> +}
>  
>  static unsigned char
>  asn1_subid_decode(struct asn1_ctx *ctx, unsigned long *subid)
> @@ -496,9 +496,9 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  {
>  	struct asn1_ctx ctx;
>  	unsigned char *end;
> -	unsigned char *sequence_end;
> +	unsigned char *sequence_end, *principal;
>  	unsigned long *oid = NULL;
> -	unsigned int cls, con, tag, oidlen, rc;
> +	unsigned int cls, con, tag, oidlen, rc, princlen;
>  
>  	/* cifs_dump_mem(" Received SecBlob ", security_blob, length); */
>  
> @@ -661,6 +661,26 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>  	}
>  	cFYI(1, "Need to call asn1_octets_decode() function for %s",
>  		ctx.pointer);	/* is this UTF-8 or ASCII? */
> +	if (asn1_octets_decode(&ctx, end, &principal, &princlen) == 0) {
> +		cFYI(1, "Error decoding principal name exit10");
> +		return 0;
> +	} else if (princlen == 0) {
> +		cFYI(1, "Empty principal name");
> +	} else if (!strcmp(principal, "not_defined_in_RFC4178@please_ignore")) {
> +		cFYI(1, "Ignoring principal name");
> +	} else {
> +		server->principal = kmalloc(princlen+1, GFP_ATOMIC);
							^^^^^^^^^^
					I don't think GFP_ATOMIC is really necessary here.

> +		if (server->principal != NULL) {
> +			memcpy(server->principal, principal, princlen);
> +			server->principal[princlen] = '\0';
> +			cFYI(1, "Got principal: %s", server->principal);
> +		} else {
> +			kfree(principal);
> +			cFYI(1, "Error allocating memory exit 11");
> +			return 0;
> +		}
> +	}
> +	kfree(principal);
>  decode_negtoken_exit:
>  	return 1;
>  }
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 2272fd5..356a8a6 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -93,6 +93,9 @@ struct key_type cifs_spnego_key_type = {
>  /* strlen of ";pid=0x" */
>  #define PID_KEY_LEN		7
>  
> +/* strlen of ";pri=" */
> +#define PRINC_KEY_LEN		5
> +
>  /* get a key struct with a SPNEGO security blob, suitable for session setup */
>  struct key *
>  cifs_get_spnego_key(struct cifs_ses *sesInfo)
> @@ -109,6 +112,8 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
>  	   host=hostname sec=mechanism uid=0xFF user=username */
>  	desc_len = MAX_VER_STR_LEN +
>  		   HOST_KEY_LEN + strlen(hostname) +
> +		   (server->principal ?
> +			PRINC_KEY_LEN + strlen(server->principal) : 0) +
>  		   IP_KEY_LEN + INET6_ADDRSTRLEN +
>  		   MAX_MECH_STR_LEN +
>  		   UID_KEY_LEN + (sizeof(uid_t) * 2) +
> @@ -128,6 +133,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
>  		hostname);
>  	dp = description + strlen(description);
>  
> +	if (server->principal) {
> +		sprintf(dp, "pri=%s;", server->principal);
> +		dp = description + strlen(description);
> +	}
> +
>  	/* add the server address */
>  	if (server->dstaddr.ss_family == AF_INET)
>  		sprintf(dp, "ip4=%pI4", &sa->sin_addr);
> diff --git a/fs/cifs/cifs_spnego.h b/fs/cifs/cifs_spnego.h
> index 31bef9e..bae1877 100644
> --- a/fs/cifs/cifs_spnego.h
> +++ b/fs/cifs/cifs_spnego.h
> @@ -23,7 +23,7 @@
>  #ifndef _CIFS_SPNEGO_H
>  #define _CIFS_SPNEGO_H
>  
> -#define CIFS_SPNEGO_UPCALL_VERSION 2
> +#define CIFS_SPNEGO_UPCALL_VERSION 3
>  
				^^^^^^^^
	Again, no need to rev the upcall format.

>  /*
>   * The version field should always be set to CIFS_SPNEGO_UPCALL_VERSION.
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 95dad9d..86de4fb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -238,6 +238,7 @@ struct TCP_Server_Info {
>  	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>  	enum statusEnum tcpStatus; /* what we think the status is */
>  	char *hostname; /* hostname portion of UNC string */
> +	char *principal;
>  	struct socket *ssocket;
>  	struct sockaddr_storage dstaddr;
>  	struct sockaddr_storage srcaddr; /* locally bind to this IP */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f4af4cc..6fdca9f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -618,6 +618,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>  	}
>  
>  	kfree(server->hostname);
> +	if (server->principal != NULL)
> +		kfree(server->principal);

It's safe to kfree a NULL pointer.

>  	kfree(server);
>  
>  	length = atomic_dec_return(&tcpSesAllocCount);
> @@ -1780,6 +1782,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		rc = PTR_ERR(tcp_ses->hostname);
>  		goto out_err_crypto_release;
>  	}
> +	tcp_ses->principal = NULL;
>  
>  	tcp_ses->noblocksnd = volume_info->noblocksnd;
>  	tcp_ses->noautotune = volume_info->noautotune;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
