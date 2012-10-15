From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IPv6 mount support
Date: Mon, 15 Oct 2012 08:35:10 -0400
Message-ID: <20121015083510.02be43f1@tlielax.poochiereds.net>
References: <CAFB9KM2GbrVzE+UEatrV5-QH_iT_Vu4Z0=o3GmezEJo_uKsyWw@mail.gmail.com>
	<CAFB9KM2kFUO39TCmh5rHh8Y8yCoU=8hpw=ahnM_teCLkfTXsRg@mail.gmail.com>
	<20121012132203.1c39533d@corrin.poochiereds.net>
	<CAH2r5msSdL25ywGNt2-QYCzOOPvqa4n34f2zgne3izzPz=a9Vw@mail.gmail.com>
	<20121012143648.4694ab58@corrin.poochiereds.net>
	<CAFB9KM1Ah4bCcNYawAJtNUsWa6kXT-c3QS8T7pxd-11Y=yFXig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM1Ah4bCcNYawAJtNUsWa6kXT-c3QS8T7pxd-11Y=yFXig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 14 Oct 2012 21:51:38 -0400
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Oct 12, 2012 at 2:36 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > While it sounds nice to add this sort of stuff, it's problematic to
> > maintain over the long haul. IMO, we're better served by insisting that
> > people specify their mounts in a fairly rigid fashion, and simply
> > document that well.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> 

> If the pathname has a ':' in it, I'd want to yell at someone.  What
> kind of sick person does that? :)

For better or worse, ':' is a perfectly valid character in a POSIX
directory name. Since we have to contend with servers (such as samba)
that may share out directories with such that have that sort of
prefixpath, then we have to be able to contend with them.

> What would you propose?  I'd be willing to document this if there is a
> consensus.
> 

I'd propose adding a patch that prints a warning to stderr whenever
someone tries to use nfs-style "devicenames" that says we'll remove
support for it in ~6.0 or so.

Then, after 5.9 is released spin up a patch that removes support for
that syntax.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
