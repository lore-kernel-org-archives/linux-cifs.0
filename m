From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] Implement a DNS Resolver Module
Date: Tue, 20 Jul 2010 10:39:43 -0500
Message-ID: <AANLkTilOVluiKSL_ZbOPW-lzqhWcp9eHOGru0UfNS0WO@mail.gmail.com>
References: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
	<20100707091411.16573.81747.stgit@warthog.procyon.org.uk>
	<20100720112506.7f7cfe1d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100720112506.7f7cfe1d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jul 20, 2010 at 10:25 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Wed, 07 Jul 2010 10:14:11 +0100
> David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> From: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>
> ----------------[snip]------------------
>
>> +/**
>> + * dns_resolve_unc_to_ip - Resolve UNC server name to ip address.
>> + * @unc: UNC path specifying the server
>> + * @ip_addr: Where to return the IP address.
>> + *
>> + * The IP address will be returned in string form, and the caller i=
s
>> + * responsible for freeing it.
>> + *
>> + * Returns 0 on success, -ve on error.
>> + */
>> +int
>> +dns_resolve_unc_to_ip(const char *unc, char **ip_addr)

> Another (somewhat minor) nit that Steve F pointed out. The function
> that this replaces in cifs can deal with numeric scopeid's as part of
> the address. For instance:
>
> =A0 =A0fea1::1%2
>
> ...where the scopeid here is "2". For linux machines, the scopeid
> essentially equates to an interface index and really has no meaning
> outside of the machine.
>
> It's not clear to me that we'd ever see one of those in a hostname th=
at
> we want to parse here, but it might not hurt to plan for it and deal
> with it appropriately.

I think it is plausible that the scopeid/interface matters here (I hear=
d the
request before and it seems reasonable).   For IPv6 in UNC names
Windows maps : to -- IIRC so scope ids look a little different,
but I think they support them

--=20
Thanks,

Steve
