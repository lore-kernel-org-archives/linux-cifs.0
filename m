From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Implementing some SMB2.2/3.0 features ...
Date: Sun, 29 Jul 2012 09:28:06 -0400
Message-ID: <20120729092806.4e2b657e@tlielax.poochiereds.net>
References: <CACyXjPz1fVUKADaan72krJCf-21e1QOrm2s1TEEAxR_S5mk0NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPz1fVUKADaan72krJCf-21e1QOrm2s1TEEAxR_S5mk0NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 28 Jul 2012 08:19:48 -0700
Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi folks,
> 
> I have started looking at implementing some of the SMB3.0 features.
> This is because, in order to do SMB Direct I need multi-connect.
> 
> In reading the latest version of the spec ([MS-SMB2] dated July 5,
> 2012 and available from msdn.microsoft.com) I notice that each session
> should have a channel list, which is a list of objects containing a
> connection reference and a signing key. It also should have a channel
> sequence number.
> 
> This means that I will need to change the struct cifs_ses to have a
> channel list rather than a struct TCP_Server_Info.
> 
> In addition, multi-connect allows multiple connections to the same
> actual server, since it allows a session to use multiple TCP
> connection on a GbE or 10GbE link. So, it seems that I will need to
> introduce an explicit notion of a connection, which the code does not
> currently have. This will definitely be needed for SMB Direct, because
> the model is that you establish a connection to the server on TCP,
> negotiate a protocol and then establish a session and then send an
> FSCTL to discover the (common) set of interfaces the server has. After
> that, if you notice that the client and server have an RDMA-capable
> interface in common, you establish a connection via that interface,
> negotiate protocol and then create a session (session setup) but bind
> it to the existing session.
> 
> Does anyone have any comments at this stage? This seems like a
> significant undertaking :-)
> 

It sounds like you're on the right track. Essentially I think you need
to abstract out the parts of the TCP_Server_Info that are specific to
the socket, and put them in a new struct that will hang off of the
TCP_Server_Info in some way (maybe a linked list of "smb_connection"
structs?)

Once you get that done, you can start thinking about how to allow more
than one to hang off the TCP_Server_Info, and how those connections
should be used. When you go to send a new SMB frame, you'll need to
pick a connection to send it on (right?), so the sending code will need
logic to deal with that.

You'll also need to teach the cifs_demultiplex_thread code how to deal
with receiving from multiple sockets. For that, maybe it's time to
think about getting away from pretending to be userland socket code,
and use the sock->sk_* callbacks directly like the sunrpc code does.
It's more complex, but would probably give much better performance in
the long run -- we wouldn't need a dedicated thread to handle it, for
instance.

While you're at it, if you feel like renaming TCP_Server_Info to
something better, I wouldn't object...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
