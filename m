From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] DNS: Separate out CIFS DNS Resolver code
Date: Wed, 4 Aug 2010 14:53:52 -0700
Message-ID: <20100804145352.a02a0bad.randy.dunlap@oracle.com>
References: <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100804141633.23934.15025.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 04 Aug 2010 15:16:33 +0100 David Howells wrote:

> From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> See the added Documentation/networking/dns_resolver.txt for more information.
> ---
> 
>  Documentation/networking/dns_resolver.txt |  146 ++++++++++++++++++
>  fs/cifs/Kconfig                           |   17 +-
>  fs/cifs/cifsfs.c                          |   13 --
>  fs/cifs/dns_resolve.c                     |  229 ++++++-----------------------
>  fs/cifs/dns_resolve.h                     |    2 
>  include/keys/dns_resolver-type.h          |   23 +++
>  include/linux/dns_resolver.h              |   34 ++++
>  net/Kconfig                               |    1 
>  net/Makefile                              |    1 
>  net/dns_resolver/Kconfig                  |   27 +++
>  net/dns_resolver/Makefile                 |    7 +
>  net/dns_resolver/dns_key.c                |  210 +++++++++++++++++++++++++++
>  net/dns_resolver/dns_query.c              |  159 ++++++++++++++++++++
>  net/dns_resolver/internal.h               |   44 ++++++
>  14 files changed, 708 insertions(+), 205 deletions(-)
>  create mode 100644 Documentation/networking/dns_resolver.txt
>  create mode 100644 include/keys/dns_resolver-type.h
>  create mode 100644 include/linux/dns_resolver.h
>  create mode 100644 net/dns_resolver/Kconfig
>  create mode 100644 net/dns_resolver/Makefile
>  create mode 100644 net/dns_resolver/dns_key.c
>  create mode 100644 net/dns_resolver/dns_query.c
>  create mode 100644 net/dns_resolver/internal.h
> 
> diff --git a/Documentation/networking/dns_resolver.txt b/Documentation/networking/dns_resolver.txt
> new file mode 100644
> index 0000000..d8e0ce1
> --- /dev/null
> +++ b/Documentation/networking/dns_resolver.txt
> @@ -0,0 +1,146 @@
> +			     ===================
> +			     DNS Resolver Module
> +			     ===================
> +
> +Contents:
> +
> + - Overview.
> + - Compilation.
> + - Setting up.
> + - Usage.
> + - Mechanism.
> + - Debugging.
> +
> +
> +========
> +OVERVIEW
> +========
> +
> +The DNS resolver module provides a way for kernel services to make DNS queries
> +by way of requesting a key of key type dns_resolver.  These queries are
> +upcalled to userspace through /sbin/request-key.
> +
> +These routines must be supported by userspace tools dns.upcall, cifs.upcall and
> +request-key.  It is under development and does not yet provide the full feature
> +set.  The features it does support include:
> +
> + (*) Implements the dns_resolver key_type to contact userspace.
> +
> +It does not yet support the following AFS features:
> +
> + (*) Dns query support for AFSDB resource record.
> +
> +This code is extracted from the CIFS filesystem.
> +
> +
> +===========
> +COMPILATION
> +===========
> +
> +The module should be enabled by turning on the kernel configuration options:
> +
> +	CONFIG_DNS_RESOLVER	- tristate "DNS Resolver support"
> +
> +
> +==========
> +SETTING UP
> +==========
> +
> +To set up this facility, the /etc/request-key.conf file must be altered so that
> +/sbin/request-key can appropriately direct the upcalls.  For example, to handle
> +basic dname to IPv4/IPv6 address resolution, the following line should be
> +added:
> +
> +	#OP	TYPE		DESC	CO-INFO	PROGRAM ARG1 ARG2 ARG3 ...
> +	#======	============	=======	=======	==========================
> +	create	dns_resolver  	*	*	/usr/sbin/cifs.upcall %k
> +
> +To direct a query for query type 'foo', a line of the following should be added
> +before the more general line given above as the first match is the one taken.
> +
> +	create	dns_resolver  	foo:*	*	/usr/sbin/dns.foo %k
> +
> +
> +
> +=====
> +USAGE
> +=====
> +
> +To make use of this facility, one of the following functions that are
> +implemented in the module can be called after doing:
> +
> +	#include <linux/dns_resolver.h>
> +
> + (1) int dns_query(const char *type, const char *name, size_t namelen,
> +		   const char *options, char **_result, time_t *_expiry);
> +
> +     This is the basic access function.  It looks for a cached DNS query and if
> +     it doesn't find it, it upcalls to userspace to make a new DNS query, which
> +     may then be cached.  The key description is constructed as a string of the
> +     form:
> +
> +		[<type>:]<name>
> +
> +     where <type> optionally specifies the particular upcall program to invoke,
> +     and thus the type of query to do, and <name> specifies the string to be
> +     looked up.  The default query type is a straight hostname to IP address
> +     set lookup.
> +
> +     The name parameter is not required to be a NUL-terminated string, and its
> +     length should be given by the namelen argument.
> +
> +     The options parameter may be NULL or it may be a set of options
> +     appropriate to the query type.
> +
> +     The return value is a string appropriate to the query type.  For instance,
> +     for the default query type it is just a list of comma-separated IPv4 and
> +     IPv6 addresses.  The caller must free the result.
> +
> +     The length of the result string is returned on success, and a -ve error

s/-ve/negative/ please.  Some readers won't know that "-ve" means.

> +     code is returned otherwise.  -EKEYREJECTED will be returned if the DNS
> +     lookup failed.
> +
> +     If _expiry is non-NULL, the expiry time (TTL) of the result will be
> +     returned also.
> +
> +
> +=========
> +MECHANISM
> +=========
> +
> +The dnsresolver module registers a key type called "dns_resolver".  Keys of
> +this type are used to transport and cache DNS lookup results from userspace.
> +
> +When dns_query() is invoked, it calls request_key() to search the local
> +keyrings for a cached DNS result.  If that fails to find one, it upcalls to
> +userspace to get a new result.
> +
> +Upcalls to userspace are made through the request_key() upcall vector, and are
> +directed by means of configuration lines in /etc/request-key.conf that tell
> +/sbin/request-key what program to run to instantiate the key.
> +
> +The upcall handler program is responsible for querying the DNS, processing the
> +result into a form suitable for passing to the keyctl_instantiate_key()
> +routine.  This then passes the data to dns_resolver_instantiate() which strips
> +off and processes any options included in the data, and then attaches the
> +remainder of the string to the key as its payload.
> +
> +The upcall handler program should set the expiry time on the key to that of the
> +lowest TTL of all the records it has extracted a result from.  This means that
> +the key will be discarded and recreated when the data it holds has expired.
> +
> +dns_query() returns a copy of the value attached to the key, or an error if
> +that is indicated instead.
> +
> +See <file:Documentation/keys-request-key.txt> for further information about
> +request-key function.
> +
> +
> +=========
> +DEBUGGING
> +=========
> +
> +Debugging messages can be turned on dynamically by writing a 1 into the
> +following file:
> +
> +        /sys/module/dnsresolver/parameters/debug


> diff --git a/include/keys/dns_resolver-type.h b/include/keys/dns_resolver-type.h
> new file mode 100644

I sure would prefer not to mix - and _ in the file name.


> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> new file mode 100644
> index 0000000..6c0cf31
> --- /dev/null
> +++ b/net/dns_resolver/dns_query.c
> @@ -0,0 +1,159 @@

...

> +/*

Use
/**
to make this kernel-doc, since the lines below here already are that.

> + * dns_query - Query the DNS
> + * @type: Query type (or NULL for straight host->IP lookup)
> + * @name: Name to look up
> + * @namelen: Length of name
> + * @options: Request options (or NULL if no options)
> + * @_result: Where to place the returned data.
> + * @_expiry: Where to store the result expiry time (or NULL)
> + *
> + * The data will be returned in the pointer at *result, and the caller is
> + * responsible for freeing it.
> + *
> + * The description should be of the form "[<query_type>:]<domain_name>", and
> + * the options need to be appropriate for the query type requested.  If no
> + * query_type is given, then the query is a straight hostname to IP address
> + * lookup.
> + *
> + * The DNS resolution lookup is performed by upcalling to userspace by way of
> + * requesting a key of type dns_resolver.
> + *
> + * Returns the size of the result on success, -ve error code otherwise.
> + */
> +int dns_query(const char *type, const char *name, size_t namelen,
> +	      const char *options, char **_result, time_t *_expiry)
> +{



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
