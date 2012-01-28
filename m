From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to handle failed writes in the middle of a set?
Date: Sat, 28 Jan 2012 09:59:37 -0500
Message-ID: <20120128095937.29a6ac16@tlielax.poochiereds.net>
References: <20120128064422.5d5e4022@tlielax.poochiereds.net>
	<1327761391.2924.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327761391.2924.9.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 28 Jan 2012 08:36:31 -0600
James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

> On Sat, 2012-01-28 at 06:44 -0500, Jeff Layton wrote:
> > The SMB protocol specifies that if you don't have an oplock then writes
> > and reads to/from the server are not supposed to use the cache. Currently
> > cifs does this sort of write serially. I'd like to change it to do them
> > in parallel for better performance, but I'm not sure what to do in the
> > following situation:
> > 
> > Suppose we have a wsize of 64k. An application opens a file for write
> > and does not get an oplock. It sends down a 192k write from userspace.
> > cifs breaks that up into 3 SMB_COM_WRITE_AND_X calls on the wire,
> > fires them off in parallel and waits for them to return. The first and
> > third write succeed, but the second one (the one in the middle) fails
> > with a hard error.
> > 
> > How should we return from the write at that point? The alternatives I
> > see are:
> > 
> > 1/ return -EIO for the whole thing, even though part of it was
> > successfully written?
> 
> This would be the safest return.  Whether it's optimal depends on how
> the writes are issued (and by what) and whether the error handling is
> sophisticated enough.
> 
> > 2/ pretend only the first write succeeded, even though the part
> > afterward might have been corrupted?
> 
> This would be what the current Linux SCSI behaviour is today (assuming
> the underlying storage reports it).  We mark the sectors up to the
> failure good and then error the rest.  Assuming the cifs client is
> sophisticated enough, it should be OK to do this, and would represent
> the most accurate information.
> 
> > 3/ do something else?
> 
> Like what?  I'm assuming from the way you phrased the question the error
> returns in cifs aren't sophisticated enough to do one per chunk (or
> sector)?  In linux, we could, in theory return OK for writes 1 and 3 and
> error write 2, but that's because we can carry one error per bio.
> However, we never do this because disk errors are always sequential and
> we'd have to have the bio boundary aligned correctly for your chunks
> (because a bio always completes partially beginning with good and ending
> with bad).
>

No idea what else we could do...

We we have to return something there to the application on (for
instance) a write(2) syscall. I don't see how we can represent that
situation more granularly in the context of that.

FWIW, if we assume that the 2nd write failed, then we'll end up with a
sparse file or zero-filled gap in the file on the server. I guess
you're correct that returning an EIO on the whole thing would be
safest...

--
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
