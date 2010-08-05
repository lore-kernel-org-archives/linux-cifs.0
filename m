From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] DNS: Separate out CIFS DNS Resolver code
Date: Thu, 05 Aug 2010 11:03:03 +0100
Message-ID: <13632.1281002583@redhat.com>
References: <AANLkTikhKSWKO5L6GBGSWhCHRbicUs4ZNVxA_Y0Qnj-h@mail.gmail.com> <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikhKSWKO5L6GBGSWhCHRbicUs4ZNVxA_Y0Qnj-h-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Merged, after addressing trivial checkpatch error:
> 
> [sfrench@hera cifs-2.6]$ scripts/checkpatch.pl ~/dh1a.patch
> ERROR: "(foo*)" should be "(foo *)"
> #523: FILE: fs/cifs/dns_resolve.c:75:
> +	rc = cifs_convert_address((struct sockaddr*)&ss, hostname, len);
> 
> total: 1 errors, 0 warnings, 999 lines checked

Thanks!  I forgot to run checkpatch, detestable though it may be:-).

David
