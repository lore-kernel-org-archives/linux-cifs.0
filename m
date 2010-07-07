From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] Implement a DNS Resolver Module
Date: Wed, 7 Jul 2010 08:02:57 -0400
Message-ID: <20100707080257.1d627e09@corrin.poochiereds.net>
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

-----------------[snip]----------------

> diff --git a/net/dnsresolver/resolv_unc_to_ip.c b/net/dnsresolver/resolv_unc_to_ip.c
> new file mode 100644
> index 0000000..169f9d9
> --- /dev/null
> +++ b/net/dnsresolver/resolv_unc_to_ip.c
> @@ -0,0 +1,111 @@
> +/*
> + *   Copyright (c) 2007 Igor Mammedov
> + *   Author(s): Igor Mammedov (niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> + *              Wang Lei (wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *
> + *   Routines used for Universal Naming Convention (UNC) path style hostname to
> + *   IP address translation.  For this function to work, the userspace tool
> + *   dns.upcall is needed and something like the following lines should be
> + *   added to the /etc/request-key.conf file:
> + *
> + *	create dns_resolver * * /sbin/dns.upcall %k
> + *
> + *   This library is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU Lesser General Public License as published
> + *   by the Free Software Foundation; either version 2.1 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This library is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + *   the GNU Lesser General Public License for more details.
> + *
> + *   You should have received a copy of the GNU Lesser General Public License
> + *   along with this library; if not, write to the Free Software
> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/socket.h>
> +#include <linux/in.h>
> +#include <linux/inet.h>
> +#include <linux/in6.h>
> +#include <linux/string.h>
> +#include <linux/dns_resolver.h>
> +#include <keys/dnsresolver-type.h>
> +#include "internal.h"
> +
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

I'm not sold that the above function really belongs in generic code. It
seems like it might make more sense to have a cifs function that parses
out the host portion of the UNC and then pass that to a generic
function that does the in4_pton/in6_pton and then the upcall if that
fails?

Nice work on the set. Moving the DNS upcall into generic code is
definitely a good move.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
