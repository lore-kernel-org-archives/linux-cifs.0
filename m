From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] DNS: If the DNS server returns an error, allow that to
 be cached
Date: Fri, 6 Aug 2010 14:27:27 -0400
Message-ID: <20100806142727.472988be@tlielax.poochiereds.net>
References: <20100806182039.5615.62116.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100806182039.5615.62116.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 06 Aug 2010 19:20:39 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> If the DNS server returns an error, allow that to be cached in the DNS resolver
> key in lieu of a value.  Userspace passes the h_errno from the libresolv
> routines as an option in the payload:
> 
> 	"#dnserror=<number>"
> 
> This is mapped through dns_errno_map[] to an appropriate Linux error code.  To
> this end, an internal error EHOSTNOTFOUND is added to be passed back to the
> caller to indicate the resultless lookup.
> 
> If this option is used, the main part of the payload is discarded.  The key may
> still have an expiry time set, however.
> 
> Signed-off-by: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  fs/afs/cell.c                |    5 +++
>  include/linux/errno.h        |    3 ++
>  net/dns_resolver/dns_key.c   |   84 ++++++++++++++++++++++++++++++++++++++++--
>  net/dns_resolver/dns_query.c |    5 +++
>  4 files changed, 93 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/afs/cell.c b/fs/afs/cell.c
> index ffea35c..acbefec 100644
> --- a/fs/afs/cell.c
> +++ b/fs/afs/cell.c
> @@ -73,6 +73,11 @@ static struct afs_cell *afs_cell_alloc(const char *name, char *vllist)
>  	if (!vllist || strlen(vllist) < 7) {
>  		ret = dns_query("afsdb", name, namelen, "ipv4", &dvllist, NULL);
>  		if (ret < 0) {
> +			if (ret == -EHOSTNOTFOUND || ret == -EAGAIN ||
> +			    ret == -ENOKEY)
> +				/* translate these errors into something
> +				 * userspace might understand */
> +				ret = -EDESTADDRREQ;
>  			_leave(" = %d", ret);
>  			return ERR_PTR(ret);
>  		}
> diff --git a/include/linux/errno.h b/include/linux/errno.h
> index 4668583..6c14a57 100644
> --- a/include/linux/errno.h
> +++ b/include/linux/errno.h
> @@ -29,6 +29,9 @@
>  #define EIOCBQUEUED	529	/* iocb queued, will get completion event */
>  #define EIOCBRETRY	530	/* iocb queued, will trigger a retry */
>  
> +/* Defined for the DNS */
> +#define EHOSTNOTFOUND	531	/* Server has no result for the request */
> +
>  #endif
>  
>  #endif
> diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
> index 1b1b411..c429d43 100644
> --- a/net/dns_resolver/dns_key.c
> +++ b/net/dns_resolver/dns_key.c
> @@ -42,6 +42,18 @@ MODULE_PARM_DESC(debug, "DNS Resolver debugging mask");
>  
>  const struct cred *dns_resolver_cache;
>  
> +#define	DNS_ERRORNO_OPTION	"dnserror"
> +
> +static const int dns_errno_map[] = {
> +	0,			/* no error */
> +	-EHOSTNOTFOUND,		/* handle h_errno HOST_NOT_FOUND = 1 */
> +	-EAGAIN,		/* handle h_errno TRY_AGAIN = 2 */
> +	-ECONNREFUSED,		/* handle h_errno NO_RECOVERY = 3 */
> +	-EHOSTNOTFOUND,		/* handle h_errno NO_DATA = 4 */
> +};
> +
> +#define ERRNO_MAP_MAX  (ARRAY_SIZE(dns_errno_map) - 1)
> +
	^^^^^
I'm not thrilled with the error mapping here. It seems like something
that could be prone to breakage in the future. Would it be better to
just have the userspace prog send up the error and just have the kernel
check it for validity?

That does make dealing with EHOSTNOTFOUND a little more tricky though
as it's considered internal to the kernel...

Overall though, the patch seems reasonable and like something we'll
want to ensure that the kernel doesn't spam userspace with requests.

>  /*
>   * Instantiate a user defined key for dns_resolver.
>   *
> @@ -58,9 +70,10 @@ static int
>  dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
>  {
>  	struct user_key_payload *upayload;
> +	unsigned long derrno;
>  	int ret;
>  	size_t result_len = 0;
> -	const char *data = _data, *opt;
> +	const char *data = _data, *end, *opt;
>  
>  	kenter("%%%d,%s,'%s',%zu",
>  	       key->serial, key->description, data, datalen);
> @@ -70,13 +83,76 @@ dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
>  	datalen--;
>  
>  	/* deal with any options embedded in the data */
> +	end = data + datalen;
>  	opt = memchr(data, '#', datalen);
>  	if (!opt) {
> -		kdebug("no options currently supported");
> -		return -EINVAL;
> +		/* no options: the entire data is the result */
> +		kdebug("no options");
> +		result_len = datalen;
> +	} else {
> +		const char *next_opt;
> +
> +		result_len = opt - data;
> +		opt++;
> +		kdebug("options: '%s'", opt);
> +		do {
> +			const char *eq;
> +			int opt_len, opt_nlen, opt_vlen, tmp;
> +
> +			next_opt = memchr(opt, '#', end - opt) ?: end;
> +			opt_len = next_opt - opt;
> +			if (!opt_len) {
> +				printk(KERN_WARNING
> +				       "Empty option to dns_resolver key %d\n",
> +				       key->serial);
> +				return -EINVAL;
> +			}
> +
> +			eq = memchr(opt, '=', opt_len) ?: end;
> +			opt_nlen = eq - opt;
> +			eq++;
> +			opt_vlen = next_opt - eq; /* will be -1 if no value */
> +
> +			tmp = opt_vlen >= 0 ? opt_vlen : 0;
> +			kdebug("option '%*.*s' val '%*.*s'",
> +			       opt_nlen, opt_nlen, opt, tmp, tmp, eq);
> +
> +			/* see if it's a DNS error number */
> +			if (opt_nlen == sizeof(DNS_ERRORNO_OPTION) - 1 &&
> +			    memcmp(opt, DNS_ERRORNO_OPTION, opt_nlen) == 0) {
> +				kdebug("dns error number option");
> +				if (opt_vlen <= 0)
> +					goto bad_option_value;
> +
> +				ret = strict_strtoul(eq, 10, &derrno);
> +				if (ret < 0)
> +					goto bad_option_value;
> +
> +				if (derrno > ERRNO_MAP_MAX)
> +					goto bad_option_value;
> +
> +				kdebug("dns error no. = %lu", derrno);
> +				key->type_data.x[0] = dns_errno_map[derrno];
> +				continue;
> +			}
> +
> +		bad_option_value:
> +			printk(KERN_WARNING
> +			       "Option '%*.*s' to dns_resolver key %d:"
> +			       " bad/missing value\n",
> +			       opt_nlen, opt_nlen, opt, key->serial);
> +			return -EINVAL;
> +		} while (opt = next_opt + 1, opt < end);
> +	}
> +
> +	/* don't cache the result if we're caching an error saying there's no
> +	 * result */
> +	if (key->type_data.x[0]) {
> +		kleave(" = 0 [h_error %ld]", key->type_data.x[0]);
> +		return 0;
>  	}
>  
> -	result_len = datalen;
> +	kdebug("store result");
>  	ret = key_payload_reserve(key, result_len);
>  	if (ret < 0)
>  		return -EINVAL;
> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> index 6c0cf31..ea4b120 100644
> --- a/net/dns_resolver/dns_query.c
> +++ b/net/dns_resolver/dns_query.c
> @@ -135,6 +135,11 @@ int dns_query(const char *type, const char *name, size_t namelen,
>  	if (ret < 0)
>  		goto put;
>  
> +	/* If the DNS server gave an error, return that to the caller */
> +	ret = rkey->type_data.x[0];
> +	if (ret)
> +		goto put;
> +
>  	upayload = rcu_dereference_protected(rkey->payload.data,
>  					     lockdep_is_held(&rkey->sem));
>  	len = upayload->datalen;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
