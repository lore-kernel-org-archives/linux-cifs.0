From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Establishing connections in the presence of multi-connect ...
 should we be searching top down not bottom up?
Date: Mon, 20 Aug 2012 07:03:25 -0400
Message-ID: <20120820070325.1dbc72d3@corrin.poochiereds.net>
References: <CACyXjPyWm9SjiuF=nh1UwwsCNPwp_5sXiiVzvUDLnyeVEA-zcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPyWm9SjiuF=nh1UwwsCNPwp_5sXiiVzvUDLnyeVEA-zcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 19 Aug 2012 12:10:02 -0700
Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi folks,
> 
> The SMB3.0 documentation refers to this model for multiple channels:
> 
> http://msdn.microsoft.com/en-us/library/cc246488%28v=prot.13%29
> 
> This shows multiple sessions, each with a group of channels over
> multiple connections. The connections are intended, I believe, to be
> references to TCP connections and RDMACM connections. It seems
> possible that two sessions to the same server could actually exist
> over different connections to the same server.
> 
> Currently, in connect.c:cifs_mount we take a bottom up approach. We
> search for a TCP session (cifs_get_tcp_session) and as a side effect,
> return a new TCP connection if we don't find it.
> 
> Then we search for an SMB session on that connection, and, as a side
> effect, create a new session if we don't find it.
> 
> It the multi-connect world, this *seems* wrong.
> 
> It seems to me that we should search for a TCON first, and if we don't
> find one, establish a new on.
> 
> Establishing a new TCON will cause us to search for an existing
> session that matches the credentials we have in hand (and possibly one
> matching the transport type or the specific transport we were asked to
> use), and if we don't find one, we need to create a new session with
> those credentials.
> 
> Creating a new session will cause us to search for an existing
> connection to the server, at which point we might come up with
> multiple connections, and so we can perhaps use the one with the
> fewest sessions bound to it or some other heuristic and start the
> session. We will also then likely engage in multi-connect with one or
> more of the remaining connections. However, if we do not find any
> connections of the appropriate type, we will have to create a new
> connection (and will want to create more connections if multi-connect
> is supported by the server).
> 
> So, I am suggesting that the approach we take needs to be re-ordered.
> Fortunately, I think, it is all confined to cifs_mount.
> 
> Does anyone have any comments?
> 

The patch in the earlier email looks like a good start. One thing that
I would encourage you to do as you go would be to break this up into
small bisectable changesets. Not only does that make things easier to
review, but also gives us a way to track down regressions via bisecting
if that should become necessary.

Currently, we have a pretty clear hierarchy of objects:

    server->session->tcon

There is no global list of tcons, so you'll need to walk 3 different
nested sets of lists in order to reverse the search order.

The way I had envisioned implementing this was to add a new
"connection" object that would hang off the "server" struct (probably
on a list) and move most of the socket-specific fields into that. That
way a "server" could have multiple "connections".

An RDMA connection would be slightly different than a socket connection
-- either different struct altogether or maybe a unioned with a TCP
connection. It would get its own set of callbacks and could be
connected and torn down as necessary.

Matching a "server" at that point becomes a bit more complex, probably
a matter of ensuring that all the connection objects are valid for the
mount.

Attempting to match the tcon first is probably a reasonable shortcut at
least in some cases however.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
