From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: file truncation on newer linux-cifs versions
Date: Sat, 14 Jan 2012 09:33:22 -0500
Message-ID: <20120114093322.7e36221d@tlielax.poochiereds.net>
References: <20120113230701.GA3100@gwdu05.gwdg.de>
	<CAOhYWN+dLLKXs6MU3W88oHzyFgi1KV+7oh1qPh61ZEqUA-Jw8w@mail.gmail.com>
	<20120114135057.GA4197@gwdu05.gwdg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: mscholz5-2/1ofaGcC4w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120114135057.GA4197-b2CffKLTPqzm5j4aBFDdOg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 14 Jan 2012 14:50:58 +0100
Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org> wrote:

> 
> > Does the problem go away if you mount with wsize=65535? If so, I guess we
> > can add bluearc to the list of servers that can't handle writes larger than
> > windows sends.
> yes it does.  Thanks for pointing it out, as it is clearly mentioned
> in mount.cifs(8).  But it says, that this size is negotiated...?
> 

To a degree...

We attempt to set the wsize according to what the server supports, but
there is no way for the server to say "I only support writes up to this
size". Currently, when the server says it supports large writes, we
attempt to set the wsize as large as we can go -- ~127k or so.

Windows servers support that just fine, but windows clients never send
writes larger thank 64k. Unfortunately, some servers are not engineered
to handle larger writes, and only handle up to what windows clients
default to.

I sent a patch a while back to set the default wsize to match what
windows does, but Steve has so far refused to take it.

> > Steve is right though that a capture would be helpful to confirm what's
> > happening.
> 
> You'll find it at http://www.gwdg.de/~mscholz5/cifs-problem/v3.1.0-1
> 
> Thank you both for the quick reply.  I noticed this problem a while ago,
> but hasitated to report it, since cifs is not officially supported
> at my site.
> 
> Steve, do you still need the bug-report?
> 

Thanks -- there's probably no need for a bug report. I think I
understand the problem. You can probably set wsize=65536, actually and
it should still work.

The server is responding to a 66560 byte write with a length of 65536.
The current code treats a short write like an -ENOSPC error. It's not
ideal, but the spec doesn't really spell out what a short write means,
and it would be quite difficult to try to recover from this situation
gracefully.

Steve, the list of servers that do not support >64k writes is growing.
Are you ready to take my patch to set the default wsize lower yet?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
