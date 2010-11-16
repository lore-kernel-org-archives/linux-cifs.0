From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #2)
Date: Tue, 16 Nov 2010 13:57:14 -0500
Message-ID: <20101116135714.358d6b10@corrin.poochiereds.net>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<1289893710-7352-2-git-send-email-piastryyy@gmail.com>
	<AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Nov 2010 12:47:07 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Nov 16, 2010 at 1:48 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > If we have a share mounted by non-standard port and try to mount another share
> > on the same host with standard port, we connect to the first share again -
> > that's wrong. This patch fixes this bug.
> 
> The description seems a little strange - can you clarify?
> 
> If we have an existing session with a server (using whatever port), by
> default we want to use it (unless the user forces a different port
> than the existing connection was made with).  If we have a firewall
> issue and therefore go through a non-standard port (port=something on
> mount), we usually wouldn't want to fork a new connection on a second
> connection to the same server.
> 
> So if we specify port=5000 on a mount and we already have a mount on
> port 139, it makes sense that we would want to create a new session.
> But if you already have a mount on port 5000, and did a mount with no
> port specified - why wouldn't you use the existing port?  It saves
> server, client and network resources.
> 

That doesn't match what the manpage says. It says:

       port=arg
           sets the port number on the server to attempt to contact to
           negotiate CIFS support. If the CIFS server is not listening on this
           port or if it is not specified, the default ports will be tried
           i.e. port 445 is tried and if no response then port 139 is tried.


...which to me says that if you want the new mount to share the socket
already on port 5000, you need to specify port=5000 in the mount
options. The code doesn't do this today, but I think it probably ought
to conform to the above description, or more accurately, with the
manpage update that Pavel proposed.

Now, to be pedantic...the code that Pavel proposed still isn't 100%
compliant with the description. If someone specifies port=139 and the
server is also listening on 445, a second mount with no port= option
will end up using the socket on 139. Still, I think his patches are
good enough here and that corner case really isn't worth sweating over
too much.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
