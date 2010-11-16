From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #2)
Date: Tue, 16 Nov 2010 14:29:50 -0500
Message-ID: <20101116142950.733d538e@corrin.poochiereds.net>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<1289893710-7352-2-git-send-email-piastryyy@gmail.com>
	<AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd@mail.gmail.com>
	<20101116135714.358d6b10@corrin.poochiereds.net>
	<AANLkTimS_nUbk3PMZf8QdZN1gXCUMGQFWSXFyXHBT0h=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimS_nUbk3PMZf8QdZN1gXCUMGQFWSXFyXHBT0h=@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Nov 2010 22:22:40 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> 
> >
> > Now, to be pedantic...the code that Pavel proposed still isn't 100%
> > compliant with the description. If someone specifies port=139 and the
> > server is also listening on 445, a second mount with no port= option
> > will end up using the socket on 139. Still, I think his patches are
> > good enough here and that corner case really isn't worth sweating over
> > too much.
> 
> Jeff, I think it fully follow the description I proposed today:
> 
> "port=arg
> 
> sets the port number on the server to attempt to contact to negotiate
> CIFS support. If this value is specified, looking for an existing
> connection with this port and try to connect if no such a connection.
> Return an error if it fails.
> 
> If this value isn't specified, looking for an existing connection with
> 445 or 139 port. If no such a connection, try to connect with 445 port
> and if it fails - with 139 port. Return an error if both fail."
> 
> So, in your case the second mount without port specifying will end up
> with 139 and this is 100% compiliant with "If this value isn't
> specified, looking for an existing connection with 445 or 139 port".
> 
> So, it means that servers on 445 and 139 ports can't live together on
> the same host:)
> 

True. That manpage change would fully describe the behavior with your
patch in place. FWIW, it's common for servers to listen on both
ports.

The thing you won't be able to expect is to autonegotiate to 445
once you've got a socket connected to 139 on the same server. It
wouldn't be too hard to make that happen, but it's probably not worth
it.


Cheers,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
