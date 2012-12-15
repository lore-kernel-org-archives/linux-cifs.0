From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Performance degradation with ISAM tables
Date: Sat, 15 Dec 2012 09:39:25 -0500
Message-ID: <20121215093925.0f555cd9@tlielax.poochiereds.net>
References: <50CA5C4C.60103@electrodh.com>
	<20121213213929.0eea2f5f@corrin.poochiereds.net>
	<50CBB21B.3080908@electrodh.com>
	<CAH2r5mv6njgwQpSUMD106BExG8b9ErRPdpeoC2eSj0mff3Hs6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?B?U2Vu6W4=?= de Diego <senen-qHrp9QoZuCS1Z/+hSey0Gg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv6njgwQpSUMD106BExG8b9ErRPdpeoC2eSj0mff3Hs6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Dec 2012 17:20:28 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Could you correlate these with the SMB counters (stats) on the client
> in /proc/fs/cifs/ which also should include bytes written/read?
> 
> Based on your description it looks like reads totally dominate this
> workload.  The obvious thing to check is the read size - a few quick
> things does "forcedirectio" (or "cache=none" for newer kernels) help -
> in that case the network read size which usually match what the client
> application requests (which is usually a bad thing because we want
> large i/o over the network and apps tend to read too small).   Second
> thing to try is a larger rsize - IIRC Windows should generally support
> up to rsize of about 127K (for Samba the rsize can be larger due to
> Unix extensions, we set the rsize smaller than 127K to Windows to work
> around bugs in other non-Samba, non-Windows servers).
> 

Actually, based on the original email, it sounds to me more like this
is a very metadata-intensive workload, likely dominated by lookups
and/or stat calls. I'd be surprised if reads were slower on the new
kernels, but it can be hard to tell...

In any case, you may want to try a larger actimeo= mount option and see
if it helps. It defaults to 1s, but you have at least one
QUERY_PATH_INFO call that took >2s for the server to respond to. Maybe
try actimeo=5 or so?

> >
> >> The next problem is that it's difficult for us to infer anything about
> >> your workload. You'll probably need to do some investigative work to
> >> figure out what's actually slow. In particular, if you can phrase the
> >> problem in terms of particular syscalls being slower, then we might be
> >> able to help you more.
> >> Even better is to come up with a small reproducer program that
> >> demonstrates the slowdown.
> >
> > The file access is done by a proprietary jdbc driver inside a jvm. I really
> > don't know how to do what you suggest. The SMB service response time
> > statitics are all I've got.
> >
> >

Then you have your work cut out for you. Trying to figure out what the
heck a particular java program is doing can be an exercise in pain
management.

You might want to consider bisecting the problem down to a narrower
range of kernel versions. If your distro provides pre-built kernels,
you can try different versions within the range you've already ID'ed.
See if you can figure out when the performance regression crept in.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
