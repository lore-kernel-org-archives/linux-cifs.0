From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Wed, 6 Mar 2013 08:40:04 -0500
Message-ID: <20130306084004.05acd57c@tlielax.poochiereds.net>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
	<CAH2r5muojf9w9QxkPK5vCQs5Av_wxm+twJ044+Mf8Q_9D=b63Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muojf9w9QxkPK5vCQs5Av_wxm+twJ044+Mf8Q_9D=b63Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 4 Mar 2013 16:08:30 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Resending patch to a slightly broader list for last minute check if
> anyone objects.  Although setting this particular socket option
> (TCP_NODELAY) may not be as useful when corking/uncorking explicitly,
> I want to doublecheck before removing them because there has been some
> utility to the server allowing override of various sockopt options.
> Samba server has long supported at least the following set of settable
> socket options (although I don't know if the defaults are frequently
> overridden now, by setting sockopts in smb.conf as used to be common
> for the server).
> 
> SO_KEEPALIVE
> SO_REUSEADDR
> SO_BROADCAST
> TCP_NODELAY
> IPTOS_LOWDELAY
> IPTOS_THROUGHPUT
> SO_SNDBUF *
> SO_RCVBUF *
> SO_SNDLOWAT *
> SO_RCVLOWAT *
> 
> * takes an integer argument rather than a boolean on/off
> 
> Any objections to removing the ability to set socket options
> explicitly for the cifs network file system client?
> 

A couple of points...

The sockopt= option was never documented in the mount.cifs manpage and
the only value it ever accepted was TCP_NODELAY. Now that we're
explicitly corking the socket, TCP_NODELAY has no effect. I don't think
there's any value in leaving in a "placeholder" socket= option.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
