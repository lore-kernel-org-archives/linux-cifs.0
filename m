From: david.kondrad-9WVPih6vfS2cqzYg7KEe8g@public.gmane.org
Subject: Re: deadlock in cifs mounts when server connection goes down
Date: Wed, 6 Oct 2010 09:47:38 -0400
Message-ID: <OF821FB6BB.E917E447-ON852577B4.0047E869-852577B4.004BC604@grpleg.it>
References: <20101005215340.1f0b6b71@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101005215340.1f0b6b71-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/05/2010 09:53:40 PM
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> > Retrying indefinitely is actually the correct behavior I believe. If
> > I'm writing or reading files to/from CIFS, then the last thing I want
> > is for the kernel to corrupt that data or start returning errors just
> > because the network is having problems.

Yes, I can see your point of view regarding trying indefinitely.
Indeed it would be generally a bad thing if a connection gave up in
the middle of an operation where it otherwise would not have; however,
I believe this violates basic posix semantics of not letting userspace
decide what to do when a resource is deemed unavailable.

For example, if I had a non-system harddrive in the system and that
drive failed for some reason, I would expect something like EIO to be
returned after a period of time.

Even more relevant are posix socket semantics of returning errors
for various connection failures, like ETIMEDOUT, ENOTCONN, and ECONNRESET.

> > However, none of this should cause the client to start returning errors
> > to userspace. That doesn't make for robustness in the face of network
> > partitions. If, however, the processes waiting on syscalls are
> > interrupted with a SIGKILL, we probably ought to return an error to
> > userspace (probably an EINTR).

Yes, that does remind me that those processes that are deadlocked
cannot be killed and that includes attempts to unmount the share.

This, in effect, creates what I call the ten-car-pile-up whereby
processes just start piling up in the 'D' state like wreck on a busy
highway.

Because of these behaviors, I think not returning errors to userspace
is actually detrimental to robustness because it can leave the system
in an unrecoverable state (especially an embedded system).

Take a photo viewer app for instance. If there was an embedded device
(digital photo frame) that would mount a cifs share as read-only
and create a slide show of the jpegs, would you expect to have to
power down the device (due to the app stuck in a stat() or read())
because someone closed the lid on the laptop (that hosted the share)
and it went to sleep?

Besides, if a laptop goes into standby, chances are that the network
card has been powered down and the tcp stack torn down anyway.

> Note that the above is just my opinion on the matter... I'm open to
> suggestions and other opinions on how it should behave.

I appreciate you taking the time to have this discussion with me.
Hopefully, other cifs developers will chime in so that we can get a good
exchange of ideas going.

> One of the main problems with CIFS in this and other matters has been a
> lack of clarity on what the behavior should be. Having a clear
> behavioral goal in mind for the code before we embark on changes is a
> necessity I think.

I think you hit the nail on the head here. I've found that most of the
roadblocks we face as engineers involve not being on the same page.

If I had to choose, I would go with socket semantics for networked file
systems, although the issue is complicated by write-backs, data
consistency,
inode caches, etc.

>From a userspace point of view, I would expect a read() or write() to
return ECONNRESET upon having the connection to the server
unrecoverably severed. I don't know how cifs handles the non-blocking case
but that should also be spec'd out.

Now for things like stat() , either EIO or ENOENT would be fitting I
suppose.

I'll put the idea on to simmer while I take care of setting up a build
environment for a new product. More to follow.

Regards,
David

--
David Kondrad
Software Design Engineer
Home Systems Division
Legrand, North America

717.546.5442
david.kondrad-9WVPih6vfS2cqzYg7KEe8g@public.gmane.org
www.legrand.us/onq

This email, and any document attached hereto, may contain
confidential and/or privileged information.  If you are not the
intended recipient (or have received this email in error) please
notify the sender immediately and destroy this email.  Any
unauthorized, direct or indirect, copying, disclosure, distribution
or other use of the material or parts thereof is strictly
forbidden.
