From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] DNS: If the DNS server returns an error, allow that to
 be cached [ver #2]
Date: Mon, 9 Aug 2010 12:16:55 -0400
Message-ID: <20100809121655.34d71797@tlielax.poochiereds.net>
References: <20100809152322.17164.23320.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100809152322.17164.23320.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 09 Aug 2010 16:23:22 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> If the DNS server returns an error, allow that to be cached in the DNS resolver
> key in lieu of a value.  Userspace passes the desired error number as an option
> in the payload:
> 
> 	"#dnserror=<number>"
> 
> Userspace must map h_errno from the name resolution routines to an appropriate
> Linux error before passing it up.  Something like the following mapping is
> recommended:
> 
> 	[HOST_NOT_FOUND]	= ENODATA,
> 	[TRY_AGAIN]		= EAGAIN,
> 	[NO_RECOVERY]		= ECONNREFUSED,
> 	[NO_DATA]		= ENODATA,
> 
> in lieu of Linux errors specifically for representing name service errors.  The
> filesystem must map these errors appropropriately before passing them to
> userspace.  AFS is made to map ENODATA and EAGAIN to EDESTADDRREQ for the
> return to userspace; ECONNREFUSED is allowed to stand as is.
> 
> The error can be seen in /proc/keys as a negative number after the description
> of the key.  Compare, for example, the following key entries:
> 
> 2f97238c I--Q--     1  53s 3f010000     0     0 dns_resol afsdb:grand.centrall.org: -61
> 338bfbbe I--Q--     1  59m 3f010000     0     0 dns_resol afsdb:grand.central.org: 37
> 
> 
> If the error option is supplied in the payload, the main part of the payload is
> discarded.  The key should have an expiry time set by userspace.
> 
> Signed-off-by: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  fs/afs/cell.c                |    4 ++
>  net/dns_resolver/dns_key.c   |   92 ++++++++++++++++++++++++++++++++++++++++--
>  net/dns_resolver/dns_query.c |    5 ++
>  3 files changed, 96 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/afs/cell.c b/fs/afs/cell.c
> index ffea35c..d076588 100644
> --- a/fs/afs/cell.c
> +++ b/fs/afs/cell.c
> @@ -73,6 +73,10 @@ static struct afs_cell *afs_cell_alloc(const char *name, char *vllist)
>  	if (!vllist || strlen(vllist) < 7) {
>  		ret = dns_query("afsdb", name, namelen, "ipv4", &dvllist, NULL);
>  		if (ret < 0) {
> +			if (ret == -ENODATA || ret == -EAGAIN || ret == -ENOKEY)
> +				/* translate these errors into something
> +				 * userspace might understand */
> +				ret = -EDESTADDRREQ;
>  			_leave(" = %d", ret);
>  			return ERR_PTR(ret);
>  		}
> diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
> index 400a04d..739435a 100644
> --- a/net/dns_resolver/dns_key.c
> +++ b/net/dns_resolver/dns_key.c
> @@ -29,6 +29,7 @@
>  #include <linux/kernel.h>
>  #include <linux/keyctl.h>
>  #include <linux/err.h>
> +#include <linux/seq_file.h>
>  #include <keys/dns_resolver-type.h>
>  #include <keys/user-type.h>
>  #include "internal.h"
> @@ -43,6 +44,8 @@ MODULE_PARM_DESC(debug, "DNS Resolver debugging mask");
>  
>  const struct cred *dns_resolver_cache;
>  
> +#define	DNS_ERRORNO_OPTION	"dnserror"
> +
>  /*
>   * Instantiate a user defined key for dns_resolver.
>   *
> @@ -59,9 +62,10 @@ static int
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
> @@ -71,13 +75,77 @@ dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
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
> +			/* see if it's an error number representing a DNS error
> +			 * that's to be recorded as the result in this key */
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
> +				if (derrno < 1 || derrno > 511)
> +					goto bad_option_value;
> +
> +				kdebug("dns error no. = %lu", derrno);
> +				key->type_data.x[0] = -derrno;
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
> @@ -135,13 +203,27 @@ no_match:
>  	return ret;
>  }
>  
> +/*
> + * Describe a DNS key
> + */
> +static void dns_resolver_describe(const struct key *key, struct seq_file *m)
> +{
> +	int err = key->type_data.x[0];
> +
> +	seq_puts(m, key->description);
> +	if (err)
> +		seq_printf(m, ": %d", err);
> +	else
> +		seq_printf(m, ": %u", key->datalen);
> +}
> +
>  struct key_type key_type_dns_resolver = {
>  	.name		= "dns_resolver",
>  	.instantiate	= dns_resolver_instantiate,
>  	.match		= dns_resolver_match,
>  	.revoke		= user_revoke,
>  	.destroy	= user_destroy,
> -	.describe	= user_describe,
> +	.describe	= dns_resolver_describe,
>  	.read		= user_read,
>  };
>  
> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> index 03d5255..c32be29 100644
> --- a/net/dns_resolver/dns_query.c
> +++ b/net/dns_resolver/dns_query.c
> @@ -136,6 +136,11 @@ int dns_query(const char *type, const char *name, size_t namelen,
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

Looks good to me. I guess with this, callers need to be prepared to
deal with any error from userspace from 1-511, but that seems
reasonable.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
