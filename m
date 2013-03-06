From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Wed, 6 Mar 2013 10:24:41 -0500
Message-ID: <CAFB9KM0hHYj0NMdy=ppkq80VGUfJjqSXhAh3a2sD5772G3__ng@mail.gmail.com>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
	<CAH2r5muojf9w9QxkPK5vCQs5Av_wxm+twJ044+Mf8Q_9D=b63Q@mail.gmail.com>
	<20130306084004.05acd57c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130306084004.05acd57c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 6, 2013 at 8:40 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 4 Mar 2013 16:08:30 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Resending patch to a slightly broader list for last minute check if
>> anyone objects.  Although setting this particular socket option
>> (TCP_NODELAY) may not be as useful when corking/uncorking explicitly,
>> I want to doublecheck before removing them because there has been some
>> utility to the server allowing override of various sockopt options.
>> Samba server has long supported at least the following set of settable
>> socket options (although I don't know if the defaults are frequently
>> overridden now, by setting sockopts in smb.conf as used to be common
>> for the server).
>>
>> SO_KEEPALIVE
>> SO_REUSEADDR
>> SO_BROADCAST
>> TCP_NODELAY
>> IPTOS_LOWDELAY
>> IPTOS_THROUGHPUT
>> SO_SNDBUF *
>> SO_RCVBUF *
>> SO_SNDLOWAT *
>> SO_RCVLOWAT *
>>
>> * takes an integer argument rather than a boolean on/off
>>
>> Any objections to removing the ability to set socket options
>> explicitly for the cifs network file system client?
>>
>
> A couple of points...
>
> The sockopt= option was never documented in the mount.cifs manpage and
> the only value it ever accepted was TCP_NODELAY. Now that we're
> explicitly corking the socket, TCP_NODELAY has no effect. I don't think
> there's any value in leaving in a "placeholder" socket= option.
>

After doing some research, I agree.  I've been updating the socket
options section of the Samba smb.conf man page and the performance
section of the Samba HOWTO.  The more research I do the more convinced
that there is almost no reason to set most socket options on a modern
Linux kernel or in Samba (server or client side).

One thing pointed out to me in another thread is that the smbd server
sets TCP_NODELAY by default.  AIUI this was because the TCP_NODELAY
option used to almost double the speed of SMB in some cases due to the
way Microsoft's old TCP/IP stack sent ACKs.

This is all to say that I think the "sockopt" option can go altogether
since it's unlikely that any socket options will be needed in the
future and the only one that was supported is now useless.
-- 
Peace and Blessings,
-Scott.
