From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IPv6 mount support
Date: Fri, 12 Oct 2012 14:36:48 -0400
Message-ID: <20121012143648.4694ab58@corrin.poochiereds.net>
References: <CAFB9KM2GbrVzE+UEatrV5-QH_iT_Vu4Z0=o3GmezEJo_uKsyWw@mail.gmail.com>
	<CAFB9KM2kFUO39TCmh5rHh8Y8yCoU=8hpw=ahnM_teCLkfTXsRg@mail.gmail.com>
	<20121012132203.1c39533d@corrin.poochiereds.net>
	<CAH2r5msSdL25ywGNt2-QYCzOOPvqa4n34f2zgne3izzPz=a9Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msSdL25ywGNt2-QYCzOOPvqa4n34f2zgne3izzPz=a9Vw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 12 Oct 2012 13:23:41 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I saw various people use the NFS syntax for cifs - it probably helps
> with portability a little
> 

What sort of portability?

Note that there is a cost in long term maintenance in supporting so
many ways to specify a mount. IPv6 support is a good case in point.
Clearly that wasn't considered when this syntax was implemented.

Another good example is the username=DOMAIN/username%password syntax,
which pretty much prevents those delimiter characters from being used
in the username.

While it sounds nice to add this sort of stuff, it's problematic to
maintain over the long haul. IMO, we're better served by insisting that
people specify their mounts in a fairly rigid fashion, and simply
document that well.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
