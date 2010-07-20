From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] Implement a DNS Resolver Module
Date: Tue, 20 Jul 2010 11:25:06 -0400
Message-ID: <20100720112506.7f7cfe1d@tlielax.poochiereds.net>
References: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
	<20100707091411.16573.81747.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707091411.16573.81747.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 07 Jul 2010 10:14:11 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 

----------------[snip]------------------

> +/**
> + * dns_resolve_unc_to_ip - Resolve UNC server name to ip address.
> + * @unc: UNC path specifying the server
> + * @ip_addr: Where to return the IP address.
> + *
> + * The IP address will be returned in string form, and the caller is
> + * responsible for freeing it.
> + *
> + * Returns 0 on success, -ve on error.
> + */
> +int
> +dns_resolve_unc_to_ip(const char *unc, char **ip_addr)
> +{
> +	struct in_addr s4;
> +	struct in6_addr	s6;
> +	char *name, *sep;
> +	int len, rc;
> +
> +	kenter("%s,", unc);
> +
> +	rc = -EINVAL;
> +	if (!ip_addr || !unc)
> +		goto out;
> +
> +	len = strlen(unc);
> +	if (len < 3)
> +		goto out;
> +
> +	/* discount leading slashes for cifs */
> +	len -= 2;
> +	unc += 2;
> +
> +	/* search for server name delimiter */
> +	sep = memchr(unc, '\\', len);
> +	if (sep)
> +		len = sep - unc;
> +	kdebug("server name:%*.*s", len, len, unc);
> +
> +	rc = -ENOMEM;
> +	name = kmalloc(len + 1, GFP_KERNEL);
> +	if (!name)
> +		goto out;
> +
> +	memcpy(name, unc, len);
> +	name[len] = 0;
> +	kdebug("name to resolve '%s'", name);
> +
> +	/* Try to convert a string to an IPv4 address */
> +	rc = in4_pton(name, len, (void *)&s4.s_addr, '\\', NULL);
> +	if (rc > 0) {
> +		*ip_addr = name;
> +		kleave(" = 0 [UNC is IPv4]");
> +		return 0;
> +	}
> +
> +	/* Try to convert a string to an IPv6 address */
> +	rc = in6_pton(name, len, (void *)&s6.s6_addr, '\\', NULL);
> +	if (rc > 0) {
> +		*ip_addr = name;
> +		kleave(" = 0 [UNC is IPv6]");
> +		return 0;
> +	}
> +

Another (somewhat minor) nit that Steve F pointed out. The function
that this replaces in cifs can deal with numeric scopeid's as part of
the address. For instance:

    fea1::1%2

...where the scopeid here is "2". For linux machines, the scopeid
essentially equates to an interface index and really has no meaning
outside of the machine.

It's not clear to me that we'd ever see one of those in a hostname that
we want to parse here, but it might not hurt to plan for it and deal
with it appropriately.

> +	/* perform the upcall */
> +	rc = request_dns_resolution(name, NULL, ip_addr);
> +	kfree(name);
> +
> +out:
> +	kleave(" = %d", rc);
> +	return rc;
> +}
> +EXPORT_SYMBOL(dns_resolve_unc_to_ip);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
