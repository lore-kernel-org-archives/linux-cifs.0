From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs: pave way for change to "strictcache" by
 default
Date: Mon, 30 Apr 2012 07:28:46 -0400
Message-ID: <20120430072846.69d489aa@corrin.poochiereds.net>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335524179-1671-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Apr 2012 06:56:15 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> cifs.ko currently does not follow the CIFS protocol as it should by
> default. The protocol specifies (paraphrasing) "Thou shalt not cache
> file data without an oplock." cifs.ko by default *does* do this however,
> opting for a more NFS-like cache coherency scheme. It caches file data
> in the pagecache, and invalidate it when the attributes look like the
> file has changed.
> 
> Unfortunately, this can and does cause cache coherency problems. The
> kernel can end up buffering up writes for longer than it should. In
> particular, internal testing at RH with Samba/CTDB has shown cache
> coherency problems when we don't mount on the clients with
> strictcache:
> 
>     https://bugzilla.redhat.com/show_bug.cgi?id=742314
> 
> Up until now, we've shied away from changing this default primarily for
> performance reasons. The code to handle uncached reads and writes was
> synchronous, and very slow. With the addition of async uncached writes
> in 3.4 and async uncached reads in 3.5, I think performance is good
> enough that we ought to change the defaults to be "strictcache" for
> better adherence to the protocol.
> 
> This patchset begins this transition by cleaning up the mount options
> that we use to control the cache behavior, and adding some warnings
> about the impending behavior change. I'm proposing that we follow the
> kernel convention of warning for 2 releases about user-visible changes
> and then we'll make the switch in 3.7.
> 
> At the same time, it corrects a problem with the current code. The
> different cache behaviors are not considered to be mutually exclusive
> even though they should be. If someone (for instance) specifies
> "strictcache" and "fsc" the results are poorly defined. The first
> patch corrects this.
> 
> If this looks acceptable, I'll also plan to spin up a manpage patch
> to help document this change.
> 

(cc'ing samba-technical too for those that don't follow linux-cifs...)

I discussed this some via IM with Steve last week and he has his doubts
about whether we should do this. I think we ought to bring this
discussion to the lists though so we can try to settle this in time for
the next kernel merge window.

The (valid) point that he brings up is that this will harm performance
when an application is doing small I/Os sizes and does not have an
oplock. This is true -- reads and writes will be synchronous and will
match the sizes that come from userspace. An application doing small
I/Os will suffer performance-wise when it does not have an oplock on an
open file.

He also claims that Windows will still buffer up writes when it doesn't
have an oplock in an effort to do larger I/Os on the wire. I've got a
dochelp request into MS to clarify this point and what the protocol
mandates, but I don't think the answer there will have much bearing on
what we should do. There are a number of problems with keeping
"cache=loose" the default...

When we do I/O out of the pagecache, then we more or less do it along
page boundaries. If another client has locked a region in the middle of
a page, then that request will generally fail. We have no way to know
what region is locked, so we have no way to handle this case.

We also have quite a few documented cases where using "strictcache" has
fixed cache coherency problems. Here's one, for instance, but there are
others:

    https://bugzilla.samba.org/show_bug.cgi?id=6174

I think it's important that cifs.ko is safe to use by default, even if
it's a little slower. We can always tell people "try cache=loose" if
their workload is slow with "cache=strict", but having defaults that
can munch your data is really not acceptable. 

I guess the question we have to answer is:

"Is it worth risking data corruption in order to eke out better
performance when a user is doing small I/Os and does not have an oplock?"

To me, the answer is an unqualified "no". In most cases, you don't have
an oplock because another client has the file open. In those cases,
cache coherency generally trumps performance. In cases where it
doesn't, a user has the freedom to mount with "cache=loose" with the
understanding of all that that entails.

Thoughts?
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
